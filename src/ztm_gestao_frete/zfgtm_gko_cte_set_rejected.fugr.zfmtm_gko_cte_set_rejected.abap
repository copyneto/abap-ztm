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
  DATA: ls_ctehd        TYPE /xnfe/inctehd,
        lv_guid         TYPE /xnfe/guid_16,
        lv_tpevento     TYPE /xnfe/ev_tpevento,
        lv_proctyp      TYPE /xnfe/proctyp,
        lv_event_exists TYPE abap_bool,
        lv_current      TYPE /xnfe/actstat.

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
    RETURN.
  ENDIF.

* BEGIN OF INSERT - JWSILVA - 10.05.2023
* ---------------------------------------------------------------------------
* Recupera chave CTE
* ---------------------------------------------------------------------------
  CALL FUNCTION '/XNFE/B2BCTE_READ_CTE_FOR_UPD'
    EXPORTING
      iv_guid  = iv_guid
    IMPORTING
      es_ctehd = ls_ctehd.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

* ---------------------------------------------------------------------------
* Verifica se evento de rejeição existe
* ---------------------------------------------------------------------------
  lv_tpevento   = '610110'.       " Desacordo de Entrega de Serviço
  lv_proctyp    = 'ISSUCPSD'.

  CALL FUNCTION '/XNFE/EVENT_EXISTS'
    EXPORTING
      iv_chnfe          = ls_ctehd-cteid
      iv_tpevento       = lv_tpevento
      iv_proctyp        = lv_proctyp
    IMPORTING
      ev_event_exists   = lv_event_exists
      ev_guid           = lv_guid
      ev_current_status = lv_current.

* ---------------------------------------------------------------------------
* Continua processo (evento)
* ---------------------------------------------------------------------------
  CALL FUNCTION '/XNFE/EV_PROCFLOW_EXECUTION_UI'
    EXPORTING
      iv_guid         = lv_guid
      iv_main_doctype = 'CTE'
    EXCEPTIONS
      no_proc_allowed = 1
      technical_error = 2
      OTHERS          = 3.

  IF sy-subrc IS NOT INITIAL.
    es_return-id         = sy-msgid.
    es_return-number     = sy-msgno.
    es_return-type       = sy-msgty.
    es_return-message_v1 = sy-msgv1.
    es_return-message_v2 = sy-msgv2.
    es_return-message_v3 = sy-msgv3.
    es_return-message_v4 = sy-msgv4.
    RETURN.
  ENDIF.
* END OF INSERT - JWSILVA - 10.05.2023

ENDFUNCTION.
