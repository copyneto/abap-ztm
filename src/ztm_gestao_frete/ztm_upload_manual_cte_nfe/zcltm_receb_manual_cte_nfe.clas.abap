CLASS zcltm_receb_manual_cte_nfe DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_bin_data,
        line(2550) TYPE x,
      END OF ty_bin_data,

      BEGIN OF ty_dms,
        documentnumber  TYPE ztfm_mv_vrb_att-documentnumber,
        documenttype    TYPE ztfm_mv_vrb_att-documenttype,
        documentpart    TYPE ztfm_mv_vrb_att-documentpart,
        documentversion TYPE ztfm_mv_vrb_att-documentversion,
      END OF ty_dms.

    METHODS add_attachment_to_dms
      IMPORTING iv_filename TYPE string
                iv_file     TYPE xstring
      EXPORTING es_dms      TYPE ty_dms
                et_return   TYPE bapiret2_t.

    METHODS get_attachment_from_dms
      IMPORTING iv_guid     TYPE sysuuid_x16
      EXPORTING ev_filename TYPE string
                ev_file     TYPE xstring
                ev_mimetype TYPE skwf_mime
                et_return   TYPE bapiret2_t.

    METHODS send_to_grc
      IMPORTING iv_file    TYPE xstring
                iv_doctype TYPE zttm_log_cte_nfe-doctype
      EXPORTING et_return  TYPE bapiret2_t.

    METHODS save_log
      IMPORTING iv_guid     TYPE sysuuid_x16
                iv_doctype  TYPE zttm_log_cte_nfe-doctype
                iv_filename TYPE string
                is_dms      TYPE ty_dms
                it_return   TYPE bapiret2_t
      EXPORTING es_log      TYPE zttm_log_cte_nfe.

    "! Formata as mensages de retorno
    "! @parameter iv_change_error_type | Muda o Tipo de mensagem 'E' para 'I'.
    "! @parameter iv_change_warning_type | Muda o Tipo de mensagem 'W' para 'I'.
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      IMPORTING
        iv_change_error_type   TYPE flag OPTIONAL
        iv_change_warning_type TYPE flag OPTIONAL
      CHANGING
        ct_return              TYPE bapiret2_t .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCLTM_RECEB_MANUAL_CTE_NFE IMPLEMENTATION.


  METHOD add_attachment_to_dms.

    DATA: lt_bin_data       TYPE STANDARD TABLE OF ty_bin_data, "sdokcntbin,
          ls_documentdata   TYPE bapi_doc_draw2,
          ls_messages       TYPE messages,
          ls_return         TYPE bapiret2,
          lv_filename       TYPE chkfile,
          lv_pure_filename  TYPE char30,
          lv_pure_extension TYPE char30,
          lv_bin_length     TYPE i.

    FREE: et_return, es_dms.

* ----------------------------------------------------------------------
* Recupera nome do arquivo e separa extensão
* ----------------------------------------------------------------------
    lv_filename = to_upper( iv_filename ).

    SPLIT lv_filename AT '.' INTO lv_pure_filename lv_pure_extension.

* ----------------------------------------------------------------------
* Recupera Aplicação
* ----------------------------------------------------------------------
    DATA(lv_dateifrmt) = to_lower( |*.{ lv_pure_extension }| ).

    SELECT SINGLE dappl
        FROM tdwp
        WHERE dateifrmt EQ @lv_dateifrmt
        INTO @DATA(lv_dappl).

    IF sy-subrc NE 0.
      CLEAR lv_dappl.
    ENDIF.

* ----------------------------------------------------------------------
* Prepara para criar documento no DMS - Transação CV03N
* ----------------------------------------------------------------------
    ls_documentdata-documenttype    = |SFI|.
    ls_documentdata-documentversion = '000'.
    ls_documentdata-documentpart    = '00'.
    ls_documentdata-laboratory      = '001'.
    ls_documentdata-wsapplication1  = lv_dappl.
    ls_documentdata-wsapplication2  = lv_dappl.

    DATA(lt_files) = VALUE bapi_tt_doc_files2( ( originaltype      = '001'
                                                 storagecategory   = |DMS_C1_ST|
                                                 created_by        = sy-uname
                                                 wsapplication     = lv_pure_extension
                                                 sourcedatacarrier = 'SAP-SYSTEM'
                                                 docfile           = iv_filename ) ).

* ----------------------------------------------------------------------
* Cria documento
* ----------------------------------------------------------------------
    CALL FUNCTION 'BAPI_DOCUMENT_CREATE2'
      EXPORTING
        documentdata    = ls_documentdata
        pf_ftp_dest     = 'SAPFTPA'
        pf_http_dest    = 'SAPHTTP'
      IMPORTING
        documenttype    = es_dms-documenttype
        documentnumber  = es_dms-documentnumber
        documentpart    = es_dms-documentpart
        documentversion = es_dms-documentversion
        return          = ls_return.

    IF ls_return-type EQ 'E' OR ls_return-type EQ 'A'.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      et_return[] = VALUE #( BASE et_return ( ls_return ) ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = iv_file
      IMPORTING
        output_length = lv_bin_length
      TABLES
        binary_tab    = lt_bin_data.

* ----------------------------------------------------------------------
* Adiciona documento
* ----------------------------------------------------------------------
    DATA(lt_drao) = VALUE dms_tbl_drao( FOR ls_bin IN lt_bin_data (
                                        orblk = ls_bin-line
                                        orln  = lv_bin_length ) ).

    DATA(lt_bin_file) = VALUE cvapi_tbl_doc_files( ( updateflag  = |I|
                                                     dappl       = lv_dappl
                                                     storage_cat = |DMS_C1_ST|
                                                     filename    = lv_filename
                                                     checked_in  = abap_true ) ).

    CALL FUNCTION 'CVAPI_DOC_CHECKIN'
      EXPORTING
        pf_dokar           = es_dms-documenttype
        pf_doknr           = es_dms-documentnumber
        pf_dokvr           = es_dms-documentversion
        pf_doktl           = es_dms-documentpart
        ps_api_control     = VALUE cvapi_api_control( no_update_task = abap_true )
        pf_replace         = abap_true
        pf_content_provide = 'TBL'
        pf_ftp_dest        = 'SAPFTPA'
        pf_http_dest       = 'SAPHTTPA'
        pf_hostname        = 'DEFAULT'
      IMPORTING
        psx_message        = ls_messages
      TABLES
        pt_files_x         = lt_bin_file
        pt_content         = lt_drao.

    IF ls_return-type EQ 'E' OR ls_return-type EQ 'A'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      et_return[] = VALUE #( BASE et_return ( id         = ls_messages-msg_id
                                              type       = ls_messages-msg_type
                                              number     = ls_messages-msg_no
                                              message_v1 = ls_messages-msg_v1
                                              message_v2 = ls_messages-msg_v2
                                              message_v3 = ls_messages-msg_v3
                                              message_v4 = ls_messages-msg_v4 ) ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD save_log.

    DATA: lv_timestamp TYPE timestampl.

    FREE: es_log.

    DATA(lt_return) = it_return.
    me->format_return( CHANGING ct_return = lt_return ).

    TRY.
        DATA(ls_return) = lt_return[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Prepara registro de log
* ----------------------------------------------------------------------
    GET TIME STAMP FIELD lv_timestamp.

    es_log = VALUE #( guid                  = iv_guid
                      doctype               = iv_doctype
                      status                = SWITCH #( ls_return-type WHEN 'S' THEN 'S'    " OK
                                                                       WHEN 'E' THEN 'E'    " Erro
                                                                       WHEN 'A' THEN 'E'    " Erro
                                                                       WHEN 'W' THEN 'W'    " Avisos
                                                                       WHEN 'I' THEN 'W' )  " Avisos
                      message               = ls_return-message
                      filename              = iv_filename
                      documenttype          = is_dms-documenttype
                      documentnumber        = is_dms-documentnumber
                      documentversion       = is_dms-documentversion
                      documentpart          = is_dms-documentpart
                      created_by            = sy-uname
                      created_at            = lv_timestamp
                      local_last_changed_at = lv_timestamp ).

* ----------------------------------------------------------------------
* Salva registro de log
* ----------------------------------------------------------------------
    IF es_log IS NOT INITIAL.

      MODIFY zttm_log_cte_nfe FROM es_log.

      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD send_to_grc.

    FREE: et_return.

    CASE iv_doctype.

      WHEN '1'. " NF-e

        CALL FUNCTION '/XNFE/NFE_INCOMING_CREATE_INT'
          EXPORTING
            iv_xstring            = iv_file
            iv_b2b                = abap_true
          EXCEPTIONS
            nfe_already_exists    = 1
            unknown_cnpj          = 2
            technical_error       = 3
            technical_error_retry = 4
            OTHERS                = 5.

        IF sy-subrc EQ 5.
          " Erro ao enviar arquivo XML para o GRC.
          et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '128' ) ).
          RETURN.

        ELSEIF sy-subrc NE 0.
          et_return = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
          RETURN.
        ENDIF.

      WHEN '2'. " CT-e

        CALL FUNCTION '/XNFE/CTE_INCOMING_CREATE_INT'
          EXPORTING
            iv_cteproc_xstring    = iv_file
          EXCEPTIONS
            cte_already_exists    = 1
            technical_error       = 2
            technical_error_retry = 3
            OTHERS                = 4.

        IF sy-subrc EQ 4.
          " Erro ao enviar arquivo XML para o GRC.
          et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '128' ) ).
          RETURN.

        ELSEIF sy-subrc NE 0.
          et_return = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
          RETURN.
        ENDIF.

      WHEN OTHERS.
        " Tipo de documento não existe.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '127' ) ).
        RETURN.

    ENDCASE.

    IF et_return IS INITIAL.
      " Envio realizado com sucesso!
      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '129' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Formata mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_Return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E' AND iv_change_error_type IS NOT INITIAL
                                THEN 'I'
                                WHEN ls_return->type EQ 'W' AND iv_change_warning_type IS NOT INITIAL
                                THEN 'I'
                                ELSE ls_return->type ).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_Return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_attachment_from_dms.

    DATA: lt_files          TYPE STANDARD TABLE OF bapi_doc_files2,
          lt_docfiles       TYPE STANDARD TABLE OF cvapi_doc_file,
          lt_access_info    TYPE STANDARD TABLE OF scms_acinf,
          lt_bin_data       TYPE STANDARD TABLE OF sdokcntbin,
          ls_documentdata   TYPE bapi_doc_draw2,
          ls_documentfile   TYPE bapi_doc_files2,
          ls_return         TYPE bapiret2,
          lv_pure_filename  TYPE char30,
          lv_pure_extension TYPE char30.

    FREE: ev_filename, ev_file, ev_mimetype, et_return.

* ---------------------------------------------------------------------------
* Recupera número do documento
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zttm_log_cte_nfe
        WHERE guid = @iv_guid
        INTO @DATA(ls_log).

    IF sy-subrc NE 0.
      " Nenhum registro encontrado para a chave informada.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '130' ) ).
    ENDIF.

    IF ls_log-documentnumber IS INITIAL.
      " Registro sem número de documento para buscar o arquivo.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '131' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera detalhes do anexo
* ---------------------------------------------------------------------------
    CALL FUNCTION 'BAPI_DOCUMENT_GETDETAIL2'
      EXPORTING
        documenttype    = ls_log-documenttype
        documentnumber  = ls_log-documentnumber
        documentpart    = ls_log-documentpart
        documentversion = ls_log-documentversion
      IMPORTING
        documentdata    = ls_documentdata
        return          = ls_return
      TABLES
        documentfiles   = lt_files.

    IF ls_return-type EQ 'E' OR ls_return-type EQ 'A'.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      et_return[] = VALUE #( BASE et_return ( id         = ls_return-id
                                              type       = ls_return-type
                                              number     = ls_return-number
                                              message_v1 = ls_return-message_v1
                                              message_v2 = ls_return-message_v2
                                              message_v3 = ls_return-message_v3
                                              message_v4 = ls_return-message_v4 ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera Aplicação
* ----------------------------------------------------------------------
    TRY.
        DATA(lv_dappl) = lt_files[ 1 ]-wsapplication.
      CATCH cx_root.

        SPLIT ls_log-filename AT '.' INTO lv_pure_filename lv_pure_extension.
        DATA(lv_dateifrmt) = to_lower( |*.{ lv_pure_extension }| ).

        SELECT SINGLE dappl
            FROM tdwp
            WHERE dateifrmt EQ @lv_dateifrmt
            INTO @lv_dappl.

        IF sy-subrc NE 0.
          CLEAR lv_dappl.
        ENDIF.
    ENDTRY.

* ----------------------------------------------------------------------
* Prepara documento - Funciona somente com FRONT-END
* ----------------------------------------------------------------------
*    CALL FUNCTION 'BAPI_DOCUMENT_CHECKOUTVIEW2'
*      EXPORTING
*        documenttype    = ls_log-documenttype
*        documentnumber  = ls_log-documentnumber
*        documentpart    = ls_log-documentpart
*        documentversion = ls_log-documentversion
*        documentfile    = ls_documentfile "VALUE bapi_doc_files2( wsapplication = lv_dappl )
*        pf_ftp_dest     = 'SAPFTPA'
*        pf_http_dest    = 'SAPHTTPA'
*        hostname        = 'DEFAULT'
*      IMPORTING
*       return          = ls_return
*      TABLES
*        documentfiles   = lt_files.

* ----------------------------------------------------------------------
* Prepara documento - Funciona em BACKGROUND
* ----------------------------------------------------------------------
    CALL FUNCTION 'CVAPI_DOC_GETDETAIL'
      EXPORTING
        pf_batchmode    = abap_true
        pf_hostname     = 'DEFAULT'
        pf_dokar        = ls_log-documenttype
        pf_doknr        = ls_log-documentnumber
        pf_dokvr        = ls_log-documentversion
        pf_doktl        = ls_log-documentpart
        pf_active_files = abap_true
        pf_read_comp    = abap_true
      TABLES
        pt_files        = lt_docfiles
      EXCEPTIONS
        not_found       = 1
        no_auth         = 2
        error           = 3
        OTHERS          = 4.

    IF sy-subrc NE 0.
    ENDIF.

    TRY.
        DATA(lv_file_id) = lt_docfiles[ 1 ]-ph_objid.
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Recupera documento
* ----------------------------------------------------------------------
    CALL FUNCTION 'SCMS_DOC_READ'
      EXPORTING
        stor_cat              = 'DMS_C1_ST'
        doc_id                = lv_file_id
      TABLES
        access_info           = lt_access_info
        content_bin           = lt_bin_data
      EXCEPTIONS
        bad_storage_type      = 1
        bad_request           = 2
        unauthorized          = 3
        comp_not_found        = 4
        not_found             = 5
        forbidden             = 6
        conflict              = 7
        internal_server_error = 8
        error_http            = 9
        error_signature       = 10
        error_config          = 11
        error_format          = 12
        error_parameter       = 13
        error                 = 14
        OTHERS                = 15.

    IF sy-subrc NE 0.
      et_return[] = VALUE #( BASE et_return ( id         = sy-msgid
                                              type       = sy-msgty
                                              number     = sy-msgno
                                              message_v1 = sy-msgv1
                                              message_v2 = sy-msgv2
                                              message_v3 = sy-msgv3
                                              message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera tipo de arquivo
* ----------------------------------------------------------------------
    TRY.
        DATA(ls_access_info) = lt_access_info[ 1 ].
      CATCH cx_root.
    ENDTRY.

    ev_mimetype = ls_access_info-mimetype.
    ev_filename = ls_log-filename.

* ----------------------------------------------------------------------
* Converte arquivo em binário
* ----------------------------------------------------------------------
    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = ls_access_info-comp_size
      IMPORTING
        buffer       = ev_file
      TABLES
        binary_tab   = lt_bin_data
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.

    IF sy-subrc NE 0.
      et_return[] = VALUE #( BASE et_return ( id         = sy-msgid
                                              type       = sy-msgty
                                              number     = sy-msgno
                                              message_v1 = sy-msgv1
                                              message_v2 = sy-msgv2
                                              message_v3 = sy-msgv3
                                              message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
