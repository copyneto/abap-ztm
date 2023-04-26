CLASS zcltm_cockpit_frete_new_ce DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_cockpit_frete_new_ce IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    TYPES: ty_t_result TYPE SORTED TABLE OF zc_tm_cockpit_new
                       WITH NON-UNIQUE KEY acckey.

    DATA: lt_result_s TYPE ty_t_result.

    " Cria instancia
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
        DATA(lv_exp_msg) = lo_ex_dest->get_longtext( ).
*        RETURN.
    ENDTRY.

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
* Recupera e seta filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_range)  = io_request->get_filter( )->get_as_ranges( ).
        DATA(lv_filter) = io_request->get_filter( )->get_as_sql_string( ).

        lo_cockpit->set_filters( it_range = lt_range ).

      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.

** ---------------------------------------------------------------------------
** Monta relatório
** ---------------------------------------------------------------------------
    DATA(lt_result) = lo_cockpit->build(  ).

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

    SORT lt_result BY acckey       DESCENDING.

* ---------------------------------------------------------------------------
* Realiza ordenação de acordo com parâmetros de entrada
* ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).

    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.


* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result_aux IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result_aux ) ).

* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    io_response->set_data( lt_result_page[] ).
  ENDMETHOD.

ENDCLASS.
