CLASS zcl_im_tm_conferen_entrega DEFINITION
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
        RETURNING VALUE(rs_data) TYPE zstm_rel_ordem_frete.
ENDCLASS.



CLASS zcl_im_tm_conferen_entrega IMPLEMENTATION.


  METHOD if_ex_doc_personalize_bcs~personalize_document.
    "Variáveis
    DATA: lv_function_name TYPE rs38l_fnam.


    "Montando os dados do formulário
    DATA(ls_conferencia_data) = get_form_data( io_appl_object ).


    "Fazendo a impressão
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSFTM_CONF_ENTREGA_MERCADORIA'
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
        user_settings        = abap_true
        is_ordem_frete       = ls_conferencia_data
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


  METHOD if_ex_doc_personalize_bcs~personalize_pdf_doc_sfif.
    "Variáveis
    DATA: lv_function_name TYPE rs38l_fnam.


    "Montando os dados do formulário
    DATA(ls_conferencia_data) = get_form_data( io_appl_object ).


    "Fazendo a impressão
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSFTM_CONF_ENTREGA_MERCADORIA'
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
        is_ordem_frete       = ls_conferencia_data
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
    "Objetos
    DATA: lo_object TYPE REF TO /bofu/cl_ppf_container.


    lo_object ?= io_appl_object.

    "Obtendo chave da ordem de frete
    DATA(lv_key) = lo_object->get_db_key( ).

    "Obtendo os dados do plano de carga
    SELECT Motorista,
           NomeMotorista,
           PlacaVeiculo
      FROM zi_tm_plano_carga
      INTO TABLE @DATA(lt_plano_carga)
      WHERE TransportationOrderKey = @lv_key.

    IF sy-subrc IS NOT INITIAL.
      EXIT.
    ENDIF.

    "Montando os dados do cabeçalho do formulário
    DATA(ls_plano_carga) = lt_plano_carga[ 1 ].

    rs_data-motorista      = ls_plano_carga-Motorista.
    rs_data-nome_motorista = ls_plano_carga-NomeMotorista.
    rs_data-placa          = ls_plano_carga-PlacaVeiculo.

    "Obtendo os dados do plano de carga
    SELECT *
      FROM zi_tm_ordem_frete_nf
      WHERE TransportationOrderKey = @lv_key
      INTO TABLE @DATA(lt_nf_ordem).

    IF sy-subrc IS NOT INITIAL.
      EXIT.
    ENDIF.

    SORT lt_nf_ordem BY StopOrder ItemSort.

    LOOP AT lt_nf_ordem ASSIGNING FIELD-SYMBOL(<fs_s_plano_carga>).

      AT NEW NotaFiscalDoc.
        rs_data-ordemfrete = <fs_s_plano_carga>-TransportationOrder.

        "Dados da nota
        APPEND INITIAL LINE TO rs_data-notas_ordem ASSIGNING FIELD-SYMBOL(<fs_s_notas_ordem>).

        <fs_s_notas_ordem>-nfnum = <fs_s_plano_carga>-NotaFiscal.
        UNPACK <fs_s_notas_ordem>-nfnum TO <fs_s_notas_ordem>-nfnum.

        <fs_s_notas_ordem>-nome_cliente   = <fs_s_plano_carga>-Cliente.
        <fs_s_notas_ordem>-data_emissao   = <fs_s_plano_carga>-DataEmissao.
      ENDAT.

      APPEND INITIAL LINE TO <fs_s_notas_ordem>-nf_itens ASSIGNING FIELD-SYMBOL(<fs_s_itens>).

      <fs_s_itens>-produto     = <fs_s_plano_carga>-Material.
      SHIFT <fs_s_itens>-produto LEFT DELETING LEADING '0'.

      <fs_s_itens>-produto_txt = <fs_s_plano_carga>-MaterialName.
      <fs_s_itens>-quantidade  = <fs_s_plano_carga>-Quantity.
      <fs_s_itens>-unid        = <fs_s_plano_carga>-QuantityUnit.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_ex_doc_personalize_bcs~personalize_pdf_doc_pdfif. "#EC NEEDED

  ENDMETHOD.

ENDCLASS.
