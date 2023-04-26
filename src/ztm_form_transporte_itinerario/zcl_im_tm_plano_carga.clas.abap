CLASS zcl_im_tm_plano_carga DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_doc_personalize_bcs .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      get_form_data
        IMPORTING
                  io_appl_object TYPE REF TO object
        RETURNING VALUE(rs_data) TYPE zstm_transporte_itinerario,
      convert_value
        IMPORTING
          iv_material      TYPE zi_tm_itens_plano_carga-Product
          iv_qty           TYPE bstmg
          iv_unit_in       TYPE zi_tm_itens_plano_carga-qtyitemunit
          iv_unit_out      TYPE zi_tm_itens_plano_carga-qtywholesaletotalunit
        RETURNING
          VALUE(rv_result) TYPE zstm_produtos_itinerario-qtd_atacado,
      convert_value_simple
        IMPORTING
          iv_weight_qty    TYPE zi_tm_itens_plano_carga-GrossWeight
          iv_unit_in       TYPE zi_tm_itens_plano_carga-grossweightunit
          iv_unit_out      TYPE zi_tm_itens_plano_carga-grossweighttotalunit
        RETURNING
          VALUE(rv_result) TYPE zstm_produtos_itinerario-peso_bruto.
ENDCLASS.



CLASS zcl_im_tm_plano_carga IMPLEMENTATION.


  METHOD if_ex_doc_personalize_bcs~personalize_document.
    "Variáveis
    DATA: lv_function_name TYPE rs38l_fnam.


    "Montando os dados do formulário
    DATA(ls_itinerario_data) = get_form_data( io_appl_object ).


    "Fazendo a impressão
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSFTM_TRANSPORTE_ITINERARIO'
      IMPORTING
        fm_name            = lv_function_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    CALL FUNCTION lv_function_name
      EXPORTING
        archive_index_tab    = ct_archive_index_tab
        archive_parameters   = is_archive_parameters
        control_parameters   = is_control_parameters
        mail_appl_obj        = is_mail_appl_obj
        mail_recipient       = is_mail_recipient
        mail_sender          = is_mail_sender
        output_options       = is_output_options
        user_settings        = ip_user_settings
        is_dados_itinerario  = ls_itinerario_data
      IMPORTING
        document_output_info = es_document_output_info
        job_output_info      = es_job_output_info
        job_output_options   = es_job_output_options
      EXCEPTIONS
        formatting_error     = 1
        internal_error       = 2
        send_error           = 3
        user_canceled        = 4
        OTHERS               = 5.

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  ENDMETHOD.


  METHOD if_ex_doc_personalize_bcs~personalize_pdf_doc_pdfif. "#EC NEEDED

  ENDMETHOD.


  METHOD if_ex_doc_personalize_bcs~personalize_pdf_doc_sfif.
    "Variáveis
    DATA: lv_function_name TYPE rs38l_fnam.


    "Montando os dados do formulário
    DATA(ls_itinerario_data) = get_form_data( io_appl_object ).


    "Fazendo a impressão
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSFTM_TRANSPORTE_ITINERARIO'
      IMPORTING
        fm_name            = lv_function_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    CALL FUNCTION lv_function_name
      EXPORTING
        archive_index_tab    = ct_archive_index_tab
        archive_parameters   = is_archive_parameters
        control_parameters   = is_control_parameters
        mail_appl_obj        = is_mail_appl_obj
        mail_recipient       = is_mail_recipient
        mail_sender          = is_mail_sender
        output_options       = is_output_options
        user_settings        = ip_user_settings
        is_dados_itinerario  = ls_itinerario_data
      IMPORTING
        document_output_info = es_document_output_info
        job_output_info      = es_job_output_info
        job_output_options   = es_job_output_options
      EXCEPTIONS
        formatting_error     = 1
        internal_error       = 2
        send_error           = 3
        user_canceled        = 4
        OTHERS               = 5.

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  ENDMETHOD.


  METHOD get_form_data.
    "Estruturas
    DATA: ls_produtos LIKE LINE OF rs_data-produtos.

    "Objetos
    DATA: lo_object TYPE REF TO /bofu/cl_ppf_container.

    "Variáveis
    DATA: lv_qtd_atacado           TYPE i,
          lv_resto_qtd_atacado(15) TYPE p DECIMALS 2.


    lo_object ?= io_appl_object.

    "Obtendo chave da ordem de frete
    DATA(lv_key) = lo_object->get_db_key( ).


    "Obtendo os dados do plano de carga
    SELECT *
      FROM zi_tm_plano_carga
      INTO TABLE @DATA(lt_plano_carga)
      WHERE TransportationOrderKey = @lv_key.

    IF sy-subrc IS NOT INITIAL.
      EXIT.
    ENDIF.

    "Montando os dados do cabeçalho do formulário
    DATA(ls_plano_carga) = lt_plano_carga[ 1 ].

    rs_data-cab_itinerario-motorista      = ls_plano_carga-Motorista.
    rs_data-cab_itinerario-nome_motorista = ls_plano_carga-NomeMotorista.
    rs_data-cab_itinerario-ordem_frete    = ls_plano_carga-TransportationOrder.
    rs_data-cab_itinerario-placa          = ls_plano_carga-PlacaVeiculo.

    "Montando os dados
    SORT lt_plano_carga BY StopOrder.

    LOOP AT lt_plano_carga ASSIGNING FIELD-SYMBOL(<fs_s_plano_carga>).
      APPEND INITIAL LINE TO rs_data-notas_fiscais ASSIGNING FIELD-SYMBOL(<fs_s_notas_ficais>).

      <fs_s_notas_ficais>-bairro         = <fs_s_plano_carga>-Bairro.
      <fs_s_notas_ficais>-cidade         = <fs_s_plano_carga>-Cidade.
      <fs_s_notas_ficais>-cliente        = <fs_s_plano_carga>-Recebedor.
      <fs_s_notas_ficais>-nome           = <fs_s_plano_carga>-RazaoSocial.
      <fs_s_notas_ficais>-endereco       = <fs_s_plano_carga>-Endereco.
      <fs_s_notas_ficais>-form_pagamento = <fs_s_plano_carga>-FormaPagamento.
      <fs_s_notas_ficais>-moeda          = <fs_s_plano_carga>-Moeda.
      <fs_s_notas_ficais>-nota_fiscal    = <fs_s_plano_carga>-NotaFiscal.

      IF <fs_s_notas_ficais>-nota_fiscal NE 'Coleta'.
        UNPACK <fs_s_notas_ficais>-nota_fiscal TO <fs_s_notas_ficais>-nota_fiscal.
      ELSE.
        rs_data-coletas = rs_data-coletas + 1.
      ENDIF.

      <fs_s_notas_ficais>-valor = <fs_s_plano_carga>-ValorTotal.
    ENDLOOP.

    "Montando os dados de produto
    SELECT *
      FROM zi_tm_itens_plano_carga
      INTO TABLE @DATA(lt_itens)
      WHERE TransportationOrderKey = @lv_key.

    LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_s_itens>).
      CLEAR ls_produtos.

      ls_produtos-produto    = <fs_s_itens>-Product.
      ls_produtos-descricao  = <fs_s_itens>-ProductDescription.
      ls_produtos-peso_bruto = convert_value_simple( iv_weight_qty = <fs_s_itens>-GrossWeight
                                                     iv_unit_in    = <fs_s_itens>-GrossWeightUnit
                                                     iv_unit_out   = <fs_s_itens>-GrossWeightTotalUnit ).

      ls_produtos-uni_peso_bruto = <fs_s_itens>-GrossWeightTotalUnit.

      ls_produtos-qtd_atacado = convert_value( iv_material = <fs_s_itens>-Product
                                               iv_qty      = CONV #( <fs_s_itens>-QtyItem )
                                               iv_unit_in  = <fs_s_itens>-QtyItemUnit
                                               iv_unit_out = <fs_s_itens>-QtyWholesaleTotalUnit ).

      ls_produtos-uni_qtd_atacado = <fs_s_itens>-QtyWholesaleTotalUnit.

      ls_produtos-qtd_total = convert_value( iv_material = <fs_s_itens>-Product
                                             iv_qty      = CONV #( <fs_s_itens>-QtyItem )
                                             iv_unit_in  = <fs_s_itens>-QtyItemUnit
                                             iv_unit_out = <fs_s_itens>-ProductBaseUnit ).

      ls_produtos-uni_qtd_total  = <fs_s_itens>-QtyTotalUnit.
      ls_produtos-uni_qtd_varejo = <fs_s_itens>-QtyRetailTotalUnit.

      COLLECT ls_produtos INTO rs_data-produtos.
    ENDLOOP.


    LOOP AT rs_data-produtos ASSIGNING FIELD-SYMBOL(<fs_s_produtos>).
      lv_qtd_atacado = floor( <fs_s_produtos>-qtd_atacado ).

      lv_resto_qtd_atacado = <fs_s_produtos>-qtd_atacado - lv_qtd_atacado.

      <fs_s_produtos>-qtd_atacado = lv_qtd_atacado.

      IF <fs_s_produtos>-qtd_atacado > 0.
        <fs_s_produtos>-qtd_varejo  = convert_value( iv_material = <fs_s_produtos>-produto
                                                     iv_qty      = CONV #( lv_resto_qtd_atacado )
                                                     iv_unit_in  = <fs_s_produtos>-uni_qtd_atacado
                                                     iv_unit_out = <fs_s_produtos>-uni_qtd_varejo ).
      ELSEIF lv_resto_qtd_atacado > 0.
        IF <fs_s_produtos>-uni_qtd_total = <fs_s_produtos>-uni_qtd_varejo.
          <fs_s_produtos>-qtd_varejo = <fs_s_produtos>-qtd_total.
        ELSE.
          <fs_s_produtos>-qtd_varejo = convert_value( iv_material = <fs_s_produtos>-produto
                                                      iv_qty      = <fs_s_produtos>-qtd_total
                                                      iv_unit_in  = <fs_s_produtos>-uni_qtd_total
                                                      iv_unit_out = <fs_s_produtos>-uni_qtd_varejo ).
        ENDIF.
      ENDIF.

      "Calculando os totais
      rs_data-totais-peso_bruto      = rs_data-totais-peso_bruto + <fs_s_produtos>-peso_bruto.
      rs_data-totais-uni_peso_bruto  = <fs_s_produtos>-uni_peso_bruto.
      rs_data-totais-qtd_atacado     = rs_data-totais-qtd_atacado +
                                       convert_value( iv_material = <fs_s_produtos>-produto
                                                      iv_qty      = <fs_s_produtos>-qtd_atacado
                                                      iv_unit_in  = <fs_s_produtos>-uni_qtd_atacado
                                                      iv_unit_out = <fs_s_produtos>-uni_peso_bruto ).
      rs_data-totais-uni_qtd_atacado = <fs_s_produtos>-uni_peso_bruto.

      rs_data-totais-qtd_total       = rs_data-totais-qtd_total +
                                       convert_value( iv_material = <fs_s_produtos>-produto
                                                      iv_qty      = <fs_s_produtos>-qtd_total
                                                      iv_unit_in  = <fs_s_produtos>-uni_qtd_total
                                                      iv_unit_out = <fs_s_produtos>-uni_peso_bruto ).
      rs_data-totais-uni_qtd_total   = <fs_s_produtos>-uni_peso_bruto.



      rs_data-totais-qtd_varejo      = rs_data-totais-qtd_varejo +
                                       convert_value( iv_material = <fs_s_produtos>-produto
                                                      iv_qty      = <fs_s_produtos>-qtd_varejo
                                                      iv_unit_in  = <fs_s_produtos>-uni_qtd_varejo
                                                      iv_unit_out = <fs_s_produtos>-uni_peso_bruto ).
      rs_data-totais-uni_qtd_varejo  = <fs_s_produtos>-uni_peso_bruto.
    ENDLOOP.

    "Montando os detalhes de pagamento
    SELECT *
      FROM zi_tm_plano_carga_pag_sum
      INTO TABLE @DATA(lt_plano_carga_pagamento)
      WHERE TransportationOrderKey = @lv_key.

    SORT lt_plano_carga_pagamento BY PaymentFormType.

    LOOP AT lt_plano_carga_pagamento ASSIGNING FIELD-SYMBOL(<fs_s_plano_carga_pagamento>).
      APPEND INITIAL LINE TO rs_data-det_pagamento ASSIGNING FIELD-SYMBOL(<fs_s_det_pagamento>).

      <fs_s_det_pagamento>-descricao = <fs_s_plano_carga_pagamento>-PaymentDescription.
      <fs_s_det_pagamento>-valor     = <fs_s_plano_carga_pagamento>-PaymentValueSum.

      rs_data-total_financeiro = rs_data-total_financeiro + <fs_s_plano_carga_pagamento>-PaymentValueSum.
    ENDLOOP.

  ENDMETHOD.


  METHOD convert_value.
    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = iv_material
        i_in_me              = iv_unit_in
        i_out_me             = iv_unit_out
        i_menge              = iv_qty
      IMPORTING
        e_menge              = rv_result
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.
    IF sy-subrc IS NOT INITIAL.
      rv_result = iv_qty.
    ENDIF.
  ENDMETHOD.


  METHOD convert_value_simple.
    CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
      EXPORTING
        input                = iv_weight_qty
        unit_in              = iv_unit_in
        unit_out             = iv_unit_out
      IMPORTING
        output               = rv_result
      EXCEPTIONS
        conversion_not_found = 1
        division_by_zero     = 2
        input_invalid        = 3
        output_invalid       = 4
        overflow             = 5
        type_invalid         = 6
        units_missing        = 7
        unit_in_not_found    = 8
        unit_out_not_found   = 9
        OTHERS               = 10.
    IF sy-subrc IS NOT INITIAL.
      rv_result = iv_weight_qty.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
