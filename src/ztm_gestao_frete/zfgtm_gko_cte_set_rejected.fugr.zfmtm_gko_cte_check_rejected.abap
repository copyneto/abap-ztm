FUNCTION zfmtm_gko_cte_check_rejected.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_CTEID) TYPE  /XNFE/ID
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA: ls_event     TYPE /xnfe/events,
        ls_xml       TYPE /xnfe/event_xml,
        lt_status    TYPE /xnfe/event_stat_t,
        lt_hist      TYPE /xnfe/event_hist_t,
        lt_symsg     TYPE /xnfe/symsg_t,
        lv_histcount TYPE /xnfe/histcount.

  FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera o último evento
* ---------------------------------------------------------------------------
  SELECT SINGLE guid, chnfe, tpevento, proctyp, nseqevento_int, nseqevento, current_status
      FROM /xnfe/events
      INTO @DATA(ls_current_event)
      WHERE chnfe      EQ @iv_cteid
        AND is_current EQ @abap_true.

  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

* ---------------------------------------------------------------------------
* Verifica o status do evento
* ---------------------------------------------------------------------------
  CALL FUNCTION '/XNFE/EVENT_READ'
    EXPORTING
      iv_guid              = ls_current_event-guid
    IMPORTING
      es_event             = ls_event
      es_xml               = ls_xml
      et_status            = lt_status
      et_hist              = lt_hist
      et_symsg             = lt_symsg
      ev_histcount         = lv_histcount
    EXCEPTIONS
      event_does_not_exist = 1
      event_locked         = 2
      technical_error      = 3
      OTHERS               = 4.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  IF  ls_event-current_status NE '02'  " incorreto
  AND ls_event-current_status NE '88'  " Processo concluído, evento foi rejeitado
  AND ls_event-current_status NE '99'. " Processo concluído, evento foi processado com êxito
    RETURN.
  ENDIF.

  SORT lt_hist BY histcount.
  SORT lt_symsg BY histcount.

* ---------------------------------------------------------------------------
* Separa as mensagens
* ---------------------------------------------------------------------------
  LOOP AT lt_hist REFERENCE INTO DATA(ls_hist).    "#EC CI_LOOP_INTO_WA

    READ TABLE lt_symsg REFERENCE INTO DATA(ls_symsg) WITH KEY histcount = ls_hist->histcount
                                                               BINARY SEARCH.
    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    et_return = VALUE #( BASE et_return (
                         type       = SWITCH #( ls_event-current_status
                                                WHEN '02' then if_xo_const_message=>error
                                                WHEN '99' then if_xo_const_message=>success
                                                when '88' then if_xo_const_message=>warning
                                                          else if_xo_const_message=>info )
                         id         = ls_symsg->msgid
                         number     = ls_symsg->msgno
                         message_v1 = ls_symsg->msgv1
                         message_v2 = ls_symsg->msgv2
                         message_v3 = ls_symsg->msgv3
                         message_v4 = ls_symsg->msgv4 ) ).
  ENDLOOP.

ENDFUNCTION.
