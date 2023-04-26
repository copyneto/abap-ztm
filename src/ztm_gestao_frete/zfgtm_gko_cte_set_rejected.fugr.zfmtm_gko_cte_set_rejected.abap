FUNCTION zfmtm_gko_cte_set_rejected.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_GUID) TYPE  /XNFE/GUID_16
*"     VALUE(IV_NOT_CODE) TYPE  /XNFE/NOT_CODE
*"     VALUE(IV_OVERWRITE) TYPE  /XNFE/OVERWRITE OPTIONAL
*"  EXPORTING
*"     VALUE(EV_SUBRC) TYPE  SY-SUBRC
*"     VALUE(ES_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  CALL FUNCTION '/XNFE/CTE_SET_REJECTED'
    EXPORTING
      iv_guid              = iv_guid
      iv_not_code          = iv_not_code
      iv_overwrite         = iv_overwrite
    EXCEPTIONS
      no_proc_allowed      = 1
      error_reading_cte    = 2
      error_creating_event = 3
      technical_error      = 4
      OTHERS               = 5.

  ev_subrc = sy-subrc.

  IF sy-subrc IS NOT INITIAL.

    es_return-id         = sy-msgid.
    es_return-number     = sy-msgno.
    es_return-type       = sy-msgty.
    es_return-message_v1 = sy-msgv1.
    es_return-message_v2 = sy-msgv2.
    es_return-message_v3 = sy-msgv3.
    es_return-message_v4 = sy-msgv4.

  ENDIF.

ENDFUNCTION.
