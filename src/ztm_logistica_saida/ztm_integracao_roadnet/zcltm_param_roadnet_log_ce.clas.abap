CLASS zcltm_param_roadnet_log_ce DEFINITION
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
        line         TYPE string VALUE 'LINE',
        description  TYPE string VALUE 'DESCRIPTION',
      END OF gc_fields,

      BEGIN OF gc_criticality,
        success TYPE int1 VALUE 3,
        warning TYPE int1 VALUE 2,
        error   TYPE int1 VALUE 1,
        initial TYPE int1 VALUE 0,
      END OF gc_criticality.

    TYPES: BEGIN OF ty_filter,
             centro       TYPE RANGE OF zc_tm_param_roadnet_new_log-centro,
             session_data TYPE RANGE OF zc_tm_param_roadnet_new_log-session_data,
             session_id   TYPE RANGE OF zc_tm_param_roadnet_new_log-session_id,
             line         TYPE RANGE OF zc_tm_param_roadnet_new_log-line,
             description  TYPE RANGE OF zc_tm_param_roadnet_new_log-description,
           END OF ty_filter,

           ty_result   TYPE zc_tm_param_roadnet_new_log,

           ty_t_result TYPE STANDARD TABLE OF ty_result.

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



CLASS zcltm_param_roadnet_log_ce IMPLEMENTATION.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    TYPES: ty_t_result TYPE SORTED TABLE OF zc_tm_param_roadnet_new_log
                       WITH NON-UNIQUE KEY centro session_data session_id line.

    DATA: lt_result_s TYPE ty_t_result.

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

    SORT lt_result BY centro       DESCENDING
                      session_data DESCENDING
*                      session_id   DESCENDING
                      line         DESCENDING.

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

    TRY.
        es_filter-line[]         = VALUE #( FOR ls_range IN it_range[ name = gc_fields-line ]-range ( CORRESPONDING #( ls_range ) ) ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        es_filter-description[]  = VALUE #( FOR ls_range IN it_range[ name = gc_fields-description ]-range ( CORRESPONDING #( ls_range ) ) ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

  METHOD execute.

    DATA: lt_user_key TYPE SORTED TABLE OF zi_ca_vh_user-bname
                      WITH UNIQUE KEY table_line,
          lr_msgid    TYPE RANGE OF sy-msgid.

* ---------------------------------------------------------------------------
* Recupera os registros
* ---------------------------------------------------------------------------
    SELECT *
       FROM zttm_road_log
       INTO TABLE @DATA(lt_road_log)
       WHERE werks       IN @is_filter-centro[]
         AND dtsession   IN @is_filter-session_data[]
         AND session_id  IN @is_filter-session_id[]
         AND line        IN @is_filter-line[]
         AND obsolete    EQ @abap_false.

    IF sy-subrc EQ 0.
      SORT lt_road_log BY werks dtsession session_id line.
    ENDIF.

    " Monta tabela de chaves
    DATA(lt_road_log_key) = lt_road_log.
    SORT lt_road_log_key BY werks dtsession session_id route_id.
    DELETE ADJACENT DUPLICATES FROM lt_road_log_key COMPARING werks dtsession session_id route_id.

* ---------------------------------------------------------------------------
* Recupera os sessões
* ---------------------------------------------------------------------------
    IF lt_road_log_key[] IS NOT INITIAL.

      SELECT *
          FROM zttm_road_item
          INTO TABLE @DATA(lt_road_item)
          FOR ALL ENTRIES IN @lt_road_log_key
          WHERE werks      EQ @lt_road_log_key-werks
            AND dtsession  EQ @lt_road_log_key-dtsession
            AND session_id EQ @lt_road_log_key-session_id.
*            AND route_id   EQ @lt_road_log_key-route_id.

      IF sy-subrc EQ 0.
        SORT lt_road_item BY werks dtsession session_id. " route_id.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    LOOP AT lt_road_log REFERENCE INTO DATA(ls_road_log).
      INSERT ls_road_log->created_by INTO TABLE lt_user_key.
      INSERT ls_road_log->created_by INTO TABLE lt_user_key.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera os nomes de usuários
* ---------------------------------------------------------------------------
    IF lt_user_key IS NOT INITIAL.

      SELECT *
          FROM zi_ca_vh_user
          FOR ALL ENTRIES IN @lt_user_key
          WHERE bname = @lt_user_key-table_line
          INTO TABLE @DATA(lt_user).

      IF sy-subrc EQ 0.
        SORT lt_user BY bname.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera mensagens que serão desconsideradas
* ---------------------------------------------------------------------------
    SELECT chave2, low
    FROM ztca_param_val
    INTO TABLE @DATA(lt_param_messages)
    WHERE modulo = 'TM'
      AND chave1 = 'ROADNET'
      AND chave3 = 'MENSAGEM'
      AND sign   = 'I'
      AND opt    = 'EQ'.

*    TRY.
*        DATA(lo_param) = NEW zclca_tabela_parametros( ).
*
*        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
*                                         iv_chave1 = 'ROADNET'
*                                         iv_chave2 = 'MENSAGENS'
*                               IMPORTING et_range  = lr_msgid ).
*      CATCH zcxca_tabela_parametros.
*        FREE lr_msgid.
*    ENDTRY.

    LOOP AT lt_road_log REFERENCE INTO ls_road_log.

      IF NOT ls_road_log->msgid(1) = 'Z' AND
        NOT line_exists( lt_param_messages[ chave2 = ls_road_log->msgid low = ls_road_log->msgno ] ).
        CONTINUE.
      ENDIF.
*      " Mensagens que serão desconsideradas
*      IF ls_road_log->msgid IN lr_msgid[] AND lr_msgid IS NOT INITIAL.
*        CONTINUE.
*      ENDIF.

      " Recupera usuário de criação
      READ TABLE lt_user INTO DATA(ls_user_created) WITH KEY bname = ls_road_log->created_by
                                                    BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_user_created.
      ENDIF.

      " Recupera usuário de modificação
      READ TABLE lt_user INTO DATA(ls_user_changed) WITH KEY bname = ls_road_log->last_changed_by
                                                    BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_user_changed.
      ENDIF.

      " Recupera sessão
      READ TABLE lt_road_item INTO DATA(ls_road_item) WITH KEY werks      = ls_road_log->werks
                                                               dtsession  = ls_road_log->dtsession
                                                               session_id = ls_road_log->session_id
*                                                               route_id   = ls_road_log->route_id
                                                               BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_road_item.
      ENDIF.

      " Filtra as descrições conforme variante
      IF ls_road_item-description NOT IN is_filter-description[].
        CONTINUE.
      ENDIF.

      et_result = VALUE #( BASE et_result (
                           centro                 = ls_road_log->werks
                           session_data           = ls_road_log->dtsession
                           session_id             = ls_road_log->session_id
                           line                   = ls_road_log->line
                           route_id               = ls_road_log->route_id
                           description            = ls_road_item-description
                           msgty                  = ls_road_log->msgty
                           msgid                  = ls_road_log->msgid
                           msgno                  = ls_road_log->msgno
                           msgv1                  = ls_road_log->msgv1
                           msgv2                  = ls_road_log->msgv2
                           msgv3                  = ls_road_log->msgv3
                           msgv4                  = ls_road_log->msgv4
                           message                = ls_road_log->message
                           created_by             = ls_road_log->created_by
                           created_by_name        = ls_user_created-text
                           created_at             = ls_road_log->created_at
                           last_changed_by        = ls_road_log->last_changed_by
                           last_changed_by_name   = ls_user_changed-text
                           last_changed_at        = ls_road_log->last_changed_at
                           local_last_changed_at  = ls_road_log->local_last_changed_at
                           criticality            = SWITCH #( ls_road_log->msgty
                                                      WHEN 'S' THEN gc_criticality-success
                                                      WHEN 'W' THEN gc_criticality-success
                                                      WHEN 'E' THEN gc_criticality-error
                                                               ELSE gc_criticality-initial ) ) ).

    ENDLOOP.
  ENDMETHOD.


ENDCLASS.
