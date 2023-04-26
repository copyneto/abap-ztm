FUNCTION zfmtm_gko_document_change.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_AWTYP) TYPE  ACCHD-AWTYP OPTIONAL
*"     VALUE(IV_AWREF) TYPE  ACCHD-AWREF OPTIONAL
*"     VALUE(IV_AWORG) TYPE  ACCHD-AWORG DEFAULT SPACE
*"     VALUE(IV_AWSYS) TYPE  ACCHD-AWSYS DEFAULT SPACE
*"     VALUE(IV_KUNNR) TYPE  ACCIT-KUNNR DEFAULT SPACE
*"     VALUE(IV_LIFNR) TYPE  ACCIT-LIFNR DEFAULT SPACE
*"     VALUE(IV_HKONT) TYPE  ACCIT-HKONT DEFAULT SPACE
*"     VALUE(IV_OBZEI) TYPE  BSEG-OBZEI DEFAULT SPACE
*"     VALUE(IV_BUZEI) TYPE  BSEG-BUZEI OPTIONAL
*"     VALUE(IV_BSEGC) TYPE  BSEGC OPTIONAL
*"     VALUE(IV_LOCK) TYPE  BOOLE-BOOLE DEFAULT 'X'
*"     VALUE(IV_BUKRS) TYPE  BUKRS OPTIONAL
*"     VALUE(IV_BELNR) TYPE  BELNR_D OPTIONAL
*"     VALUE(IV_GJAHR) TYPE  GJAHR OPTIONAL
*"     VALUE(IV_ALE) TYPE  XFELD OPTIONAL
*"     VALUE(IV_UPD_FQM) TYPE  BOOLE_D DEFAULT 'X'
*"     VALUE(IV_FI_INTERNAL_USE) TYPE  BOOLE_D OPTIONAL
*"     VALUE(IT_ACCCHG) TYPE  ARBERP_T_ACCCHG OPTIONAL
*"  EXPORTING
*"     VALUE(EV_SUBRC) TYPE  SY-SUBRC
*"     VALUE(ES_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
* BEGIN OF INSERT - JWSILVA - 01.03.2023
  " Em vez de retornar erro na função FI_DOCUMENT_CHANGE, ele dispara um DUMP que não é possível capturar.
  " Logo fizemos uma tratativa para verificar se o documento já foi compensado, que foi o cenário encontrado.
  IF iv_belnr IS NOT INITIAL.

    " Verifica se a fatura já foi compensada
    SELECT COUNT(*)
      FROM bsak_view
      WHERE bukrs = @iv_bukrs
        AND belnr = @iv_belnr
        AND gjahr = @iv_gjahr.
*        AND buzei = @iv_buzei.
    IF sy-subrc EQ 0.
      " Em caso de Fatura compensada, não prosseguir com a atualização do documento.
      RETURN.
    ENDIF.
  ENDIF.
* END OF INSERT - JWSILVA - 01.03.2023

  TRY.
      CALL FUNCTION 'FI_DOCUMENT_CHANGE'
        EXPORTING
          i_awtyp              = iv_awtyp
          i_awref              = iv_awref
          i_aworg              = iv_aworg
          i_awsys              = iv_awsys
          i_kunnr              = iv_kunnr
          i_lifnr              = iv_lifnr
          i_hkont              = iv_hkont
          i_obzei              = iv_obzei
          i_buzei              = iv_buzei
          i_bsegc              = iv_bsegc
          x_lock               = iv_lock
          i_bukrs              = iv_bukrs
          i_belnr              = iv_belnr
          i_gjahr              = iv_gjahr
          x_ale                = iv_ale
          i_upd_fqm            = iv_upd_fqm
          i_fi_internal_use    = iv_fi_internal_use
        TABLES
          t_accchg             = it_accchg
        EXCEPTIONS
          no_reference         = 1
          no_document          = 2
          many_documents       = 3
          wrong_input          = 4
          overwrite_creditcard = 5
          OTHERS               = 6.
    CATCH cx_root INTO DATA(lo_root).
      DATA(lv_message) = lo_root->get_longtext( ).
  ENDTRY.

  ev_subrc = sy-subrc.

  IF sy-subrc IS INITIAL.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ELSE.

    es_return-id         = sy-msgid.
    es_return-number     = sy-msgno.
    es_return-type       = sy-msgty.
    es_return-message_v1 = sy-msgv1.
    es_return-message_v2 = sy-msgv2.
    es_return-message_v3 = sy-msgv3.
    es_return-message_v4 = sy-msgv4.

  ENDIF.

ENDFUNCTION.
