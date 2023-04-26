CLASS zcltm_mdf_cockpit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters  TYPE if_rap_query_filter=>tt_name_range_pairs
          io_instance TYPE REF TO zcltm_monitor_mdf.
ENDCLASS.



CLASS zcltm_mdf_cockpit IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    " Cria instancia
    DATA(lo_cockpit) = zcltm_monitor_mdf=>get_instance( ).

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
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) io_instance = lo_cockpit ). "#EC CI_CONV_OK
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        lv_exp_msg = lo_ex_filter->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------
    DATA(lt_result) = lo_cockpit->build(  ).

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


  METHOD set_filters.

    IF it_filters IS NOT INITIAL.

      TRY.
          DATA(lr_BR_NotaFiscal)   = it_filters[ name = 'BR_NOTAFISCAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_exp_msg) = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
         DATA(lr_OrdemFrete)   = it_filters[ name = 'ORDEMFRETE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_BR_MDFeNumber)   = it_filters[ name = 'BR_MDFENUMBER' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_LocalExpedicao)   = it_filters[ name = 'LOCALEXPEDICAO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.


      TRY.
          DATA(lr_Placa)   = it_filters[ name = 'PLACA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_StatusCode)   = it_filters[ name = 'STATUSCODE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_DataCriacao)   = it_filters[ name = 'DATACRIACAO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_TipoOperacao)   = it_filters[ name = 'TIPOOPERACAO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_Empresa)   = it_filters[ name = 'EMPRESA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_Agrupador)   = it_filters[ name = 'AGRUPADOR' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_StepStatus)   = it_filters[ name = 'STEPSTATUS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(lr_PeriodoValido)   = it_filters[ name = 'PERIODOVALIDO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      "Export referencias
      GET REFERENCE OF: lr_BR_NotaFiscal[]   INTO io_instance->gr_BR_NotaFiscal.
      GET REFERENCE OF: lr_OrdemFrete[]      INTO io_instance->gr_OrdemFrete.
      GET REFERENCE OF: lr_BR_MDFeNumber[]   INTO io_instance->gr_BR_MDFeNumber.
      GET REFERENCE OF: lr_LocalExpedicao[]  INTO io_instance->gr_LocalExpedicao.
      GET REFERENCE OF: lr_Placa[]           INTO io_instance->gr_Placa.
      GET REFERENCE OF: lr_StatusCode[]      INTO io_instance->gr_StatusCode.
      GET REFERENCE OF: lr_DataCriacao[]     INTO io_instance->gr_DataCriacao.
      GET REFERENCE OF: lr_TipoOperacao[]    INTO io_instance->gr_TipoOperacao.
      GET REFERENCE OF: lr_Empresa[]         INTO io_instance->gr_Empresa.
      GET REFERENCE OF: lr_Agrupador[]       INTO io_instance->gr_Agrupador.
      GET REFERENCE OF: lr_StepStatus[]      INTO io_instance->gr_StepStatus.
      GET REFERENCE OF: lr_PeriodoValido[]   INTO io_instance->gr_PeriodoValido.

      io_instance->set_ref_data(  ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
