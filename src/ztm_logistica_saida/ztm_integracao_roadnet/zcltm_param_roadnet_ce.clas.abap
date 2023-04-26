CLASS zcltm_param_roadnet_ce DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.
    INTERFACES if_rap_query_filter.

    CONSTANTS:
      BEGIN OF gc_fields,
        centro       TYPE string VALUE 'CENTRO',
        session_data TYPE string VALUE 'SESSION_DATA',
        session_id   TYPE string VALUE 'SESSION_ID',
      END OF gc_fields,

      BEGIN OF gc_criticality,
        success TYPE int1 VALUE 3,
        warning TYPE int1 VALUE 2,
        error   TYPE int1 VALUE 1,
        initial TYPE int1 VALUE 0,
      END OF gc_criticality.

    TYPES: BEGIN OF ty_filter,
             centro       TYPE RANGE OF zc_tm_param_roadnet_new-centro,
             session_data TYPE RANGE OF zc_tm_param_roadnet_new-session_data,
             session_id   TYPE RANGE OF zc_tm_param_roadnet_new-session_id,
           END OF ty_filter,

           ty_result     TYPE zc_tm_param_roadnet_new,

           ty_t_result   TYPE STANDARD TABLE OF ty_result,

           ty_t_result_s TYPE SORTED TABLE OF ty_result
                         WITH NON-UNIQUE KEY centro session_data.

    METHODS get_filter
      IMPORTING it_range  TYPE if_rap_query_filter=>tt_name_range_pairs
      EXPORTING es_filter TYPE ty_filter.

    METHODS execute
      IMPORTING is_filter TYPE ty_filter
      EXPORTING et_result TYPE ty_t_result
                et_return TYPE bapiret2_t.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcltm_param_roadnet_ce IMPLEMENTATION.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    DATA: lt_result_s TYPE SORTED TABLE OF zc_tm_param_roadnet_new
                      WITH NON-UNIQUE KEY centro session_data.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

    " Ao navegar pra Object Page, devemos setar como um registro .
    lv_top      = COND #( WHEN lv_top <= 0 THEN 1 ELSE lv_top ).
    lv_max_rows = COND #( WHEN lv_max_rows <= 0 THEN 1 ELSE lv_max_rows ).

* ---------------------------------------------------------------------------
* Recupera filtros do relatório
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_ranges) = io_request->get_filter( )->get_as_ranges( ).
        DATA(lv_filter) = io_request->get_filter( )->get_as_sql_string( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------
    me->get_filter( EXPORTING it_range  = lt_ranges
                    IMPORTING es_filter = DATA(ls_filter) ).

    me->execute( EXPORTING is_filter = ls_filter
                 IMPORTING et_result = DATA(lt_result)
                           et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Realiza ordenação de acordo com parâmetros de entrada
* ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).

    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.

* ---------------------------------------------------------------------------
* Realiza as agregações de acordo com as annotatios na custom entity
* ---------------------------------------------------------------------------
    DATA(lt_req_elements) = io_request->get_requested_elements( ).
    DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).

    SORT lt_req_elements BY table_line.

    LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
      DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element.
      DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
      APPEND lv_aggregation TO lt_req_elements.
    ENDLOOP.

    DATA(lv_req_elements)    = concat_lines_of( table = lt_req_elements sep = ',' ).
    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping)        = concat_lines_of(  table = lt_grouped_element sep = ',' ).

    TRY.
        lt_result_s = lt_result.

        SELECT (lv_req_elements) FROM @lt_result_s AS dados
                                 GROUP BY (lv_grouping)
                                 INTO CORRESPONDING FIELDS OF TABLE @lt_result.
      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = lo_root->get_longtext( ).
    ENDTRY.
* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result_aux IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result_aux ) ).

* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_result_page[] ).
    ENDIF.

* ---------------------------------------------------------------------------
* Dispara mensagem de erro. Obs: somente mensagens de erro aparecerão na tela
* ---------------------------------------------------------------------------
    LOOP AT lt_return REFERENCE INTO DATA(ls_return).
      MESSAGE ID ls_return->id
            TYPE ls_return->type
          NUMBER ls_return->number
            WITH ls_return->message_v1
                 ls_return->message_v2
                 ls_return->message_v3
                 ls_return->message_v4.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_filter.

    FREE: es_filter.

* ---------------------------------------------------------------------------
* Recupera filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        es_filter-centro[]       = VALUE #( FOR ls_range IN it_range[ name = gc_fields-centro ]-range ( CORRESPONDING #( ls_range ) ) ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        es_filter-session_data[] = VALUE #( FOR ls_range IN it_range[ name = gc_fields-session_data ]-range ( CORRESPONDING #( ls_range ) ) ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        es_filter-session_id[]   = VALUE #( FOR ls_range IN it_range[ name = gc_fields-session_id ]-range ( CORRESPONDING #( ls_range ) ) ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    DATA: lo_interface        TYPE REF TO ziftm_integracao_roadnet,
          lt_road_session_all TYPE zctgtm_road_session,
          lt_road_item_all    TYPE zctgtm_road_item,
          lt_road_log_all     TYPE zctgtm_road_log,
          lt_result           TYPE ty_t_result_s,
          lr_msgid            TYPE RANGE OF sy-msgid,
          lv_message          TYPE string.

    FREE: et_result, et_return.

* ---------------------------------------------------------------------------
* Valida filtros de seleção
* ---------------------------------------------------------------------------
    IF is_filter-centro IS INITIAL.
      " Nenhum centro informado.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '007' ) ).
      RETURN.
    ENDIF.

    IF is_filter-session_data IS INITIAL.
      " Nenhuma data informada.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '008' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera centros
* ---------------------------------------------------------------------------
    IF is_filter-centro[] IS NOT INITIAL.

      SELECT werks, name1
          FROM t001w
          WHERE werks IN @is_filter-centro
          INTO TABLE @DATA(lt_centro).

      IF sy-subrc EQ 0.
        SORT lt_centro BY werks.
      ELSE.
        " Nenhum centro encontrado.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '006' ) ).
        RETURN.
      ENDIF.
    ENDIF.

    lo_interface ?= NEW zcltm_process_roadnet( ).

* ---------------------------------------------------------------------------
* Executa chamada da interface Roadnet
* ---------------------------------------------------------------------------
    LOOP AT lt_centro REFERENCE INTO DATA(ls_centro).

      LOOP AT is_filter-session_data[] REFERENCE INTO DATA(ls_data).

        lo_interface->executar( EXPORTING iv_centro       = ls_centro->werks
                                          iv_data         = ls_data->low
                                          iv_data_ate     = ls_data->high
                                          iv_sessao       = space
                                          iv_testrun      = abap_true
                                IMPORTING et_road_session = DATA(lt_road_session)
                                          et_road_item    = DATA(lt_road_item)
                                          et_road_log     = DATA(lt_road_log) ).

        INSERT LINES OF lt_road_session INTO TABLE lt_road_session_all.
        INSERT LINES OF lt_road_item INTO TABLE lt_road_item_all.
        INSERT LINES OF lt_road_log INTO TABLE lt_road_log_all.

      ENDLOOP.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera mensagens que serão desconsideradas
* ---------------------------------------------------------------------------
    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
                                         iv_chave1 = 'ROADNET'
                                         iv_chave2 = 'EXCLUI_LOG'
                               IMPORTING et_range  = lr_msgid ).
      CATCH zcxca_tabela_parametros.
        FREE lr_msgid.
    ENDTRY.

    IF lr_msgid IS NOT INITIAL.
      DELETE lt_road_log_all WHERE msgid IN lr_msgid[].
    ENDIF.

* ---------------------------------------------------------------------------
* Prepara resultados
* ---------------------------------------------------------------------------
    SORT lt_road_session_all BY werks dtsession.
    DELETE ADJACENT DUPLICATES FROM lt_road_session_all COMPARING werks dtsession.

    SORT lt_road_item_all BY werks dtsession session_id route_id.
    DELETE ADJACENT DUPLICATES FROM lt_road_item_all COMPARING werks dtsession session_id route_id.

    SORT lt_road_log_all BY werks dtsession session_id line.
    DELETE ADJACENT DUPLICATES FROM lt_road_log_all COMPARING werks dtsession session_id line.

* ---------------------------------------------------------------------------
* Monta linhas do relatório
* ---------------------------------------------------------------------------
    LOOP AT lt_road_session_all REFERENCE INTO DATA(ls_road_session).

      " Recupera descrição do centro
      READ TABLE lt_centro INTO DATA(ls_centro_txt) BINARY SEARCH WITH KEY werks = ls_road_session->werks.

      IF sy-subrc NE 0.
        CLEAR ls_centro.
      ENDIF.

      " Verifica se existe erros
      READ TABLE lt_road_log_all TRANSPORTING NO FIELDS BINARY SEARCH WITH KEY werks      = ls_road_session->werks
                                                                               dtsession  = ls_road_session->dtsession
                                                                               session_id = ls_road_session->id_session_roadnet.
      IF sy-subrc EQ 0.
        LOOP AT lt_road_log_all INTO DATA(ls_road_log) FROM sy-tabix WHERE werks      = ls_road_session->werks
                                                                       AND dtsession  = ls_road_session->dtsession
                                                                       AND session_id = ls_road_session->id_session_roadnet.
          IF ls_road_log-msgty = 'E'.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      CASE ls_road_log-msgty.
        WHEN 'S' OR 'I'.
          " Importação realizada.
          MESSAGE s010(ztm_roadnet_session) INTO lv_message.
        WHEN 'W'.
          " Importação realizada com avisos.
          MESSAGE s011(ztm_roadnet_session) INTO lv_message.
        WHEN 'E'.
          " Importação realizada com erros.
          MESSAGE s012(ztm_roadnet_session) INTO lv_message.
        WHEN OTHERS.
          CLEAR lv_message.
      ENDCASE.

      lt_result = VALUE #( BASE lt_result (
                           centro                 = ls_road_session->werks
                           centro_txt             = ls_centro_txt-name1
                           session_data           = ls_road_session->dtsession
                           session_id             = ls_road_session->id_session_roadnet
                           total_route_id         = ls_road_session->total_route_id
                           mensagem               = lv_message
                           criticality            = SWITCH #( ls_road_log-msgty
                                                    WHEN 'S' THEN gc_criticality-success
                                                    WHEN 'W' THEN gc_criticality-success
                                                    WHEN 'E' THEN gc_criticality-error
                                                             ELSE gc_criticality-initial )
                           created_by             = ls_road_session->created_by
                           created_at             = ls_road_session->created_at
                           last_changed_by        = ls_road_session->last_changed_by
                           last_changed_at        = ls_road_session->last_changed_at
                           local_last_changed_at  = ls_road_session->local_last_changed_at ) ).

    ENDLOOP.

* ---------------------------------------------------------------------------
* Filtra o resultado de acordo com os filtros de seleção
* ---------------------------------------------------------------------------
    SELECT *
        FROM @lt_result AS result
        WHERE centro        IN @is_filter-centro
          AND session_data  IN @is_filter-session_data
          AND session_id    IN @is_filter-session_id
        INTO TABLE @et_result.

  ENDMETHOD.

ENDCLASS.
