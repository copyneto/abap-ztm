CLASS zcltm_ce_monitor_gko_cte_carga DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.

    TYPES: ty_carga   TYPE zc_tm_monitor_gko_cte_carga,

           ty_t_carga TYPE STANDARD TABLE OF ty_carga.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_ce_monitor_gko_cte_carga IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO cx_rap_query_provider.

* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
      CATCH cx_rfc_dest_provider_error  INTO DATA(lo_ex_dest).
        DATA(lv_exp_msg) = lo_ex_dest->get_longtext( ).
        RETURN.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_entity_id) = io_request->get_entity_id( ).
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------
    TRY.
        DATA(lo_gko) = NEW zcltm_gko_process( ).

        lo_gko->fill_relatorio_cte_carga( EXPORTING iv_filter = io_request->get_filter( )->get_as_sql_string( )
                                          IMPORTING et_carga   = DATA(lt_result) ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result ) ).

* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    io_response->set_data( lt_result_page[] ).

  ENDMETHOD.

ENDCLASS.
