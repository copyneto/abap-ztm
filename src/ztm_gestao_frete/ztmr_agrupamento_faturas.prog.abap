***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: JOB para efetivação de agrupamento                     *
*** AUTOR : WILLIAN HAZOR – META                                      *
*** FUNCIONAL: Jefferson Alcantara – META                             *
*** DATA : 03.05.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA  | AUTOR | DESCRIÇÃO                                         *
***-------------------------------------------------------------------*
***       |       |                                                   *
***********************************************************************
** PROGRAMA OBSOLETO. UTILIZANDO O PROGRAMA zfir_gko_agrup_fatura     *
***********************************************************************
REPORT ztmr_agrupamento_faturas.

TABLES: zttm_gkot001.

CONSTANTS: gc_OBJECT    TYPE  balobj_d VALUE 'ZTM',
           gc_SUBOBJECT	TYPE  balsubobj VALUE 'ZAGRU'.

DATA: lT_XBLNR      TYPE zctgtm_gko009,
      lt_msg        TYPE bapiret2_tab,
      ls_LOG_HANDLE TYPE  balloghndl.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: s_XBLNR FOR zttm_gkot001-num_fatura.
SELECTION-SCREEN END OF BLOCK b1.

IF s_xblnr IS NOT INITIAL.
  SELECT xblnr
    FROM zttm_gkot009
      INTO TABLE lT_XBLNR
      WHERE xblnr IN s_XBLNR.

  IF lT_XBLNR IS INITIAL.
    MESSAGE s116(ztm_gestao_frete) DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
ENDIF.

NEW zcltm_agrupar_fatura( )->efetivar_agrupamento( EXPORTING it_xblnr       = lT_XBLNR
                                                   IMPORTING et_bapi_return = lt_msg ).


DATA: ls_log TYPE bal_s_log.

ls_log-aluser    = sy-uname.
ls_log-alprog    = sy-repid.
ls_log-object    = gc_object.
ls_log-subobject = gc_subobject.

CALL FUNCTION 'BAL_LOG_CREATE'
  EXPORTING
    i_s_log      = ls_log
  IMPORTING
    e_log_handle = ls_LOG_HANDLE
  EXCEPTIONS
    OTHERS       = 1.

IF sy-subrc <> 0.
  RETURN.
ENDIF.

DATA: ls_msg     TYPE bal_s_msg.
*          ls_context TYPE ypoc_job.

LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
  ls_msg = VALUE #(
    msgty = <fs_msg>-type
    msgid = <fs_msg>-id
    msgno = <fs_msg>-number
    msgv1 = <fs_msg>-message_v1
    msgv2 = <fs_msg>-message_v2
    msgv3 = <fs_msg>-message_v3
    msgv4 = <fs_msg>-message_v4
  ).

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = ls_LOG_HANDLE
      i_s_msg          = ls_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.
    CONTINUE.
  ENDIF.

ENDLOOP.

DATA: lt_log_handle TYPE bal_t_logh.

APPEND ls_log_handle TO lt_log_handle.

CALL FUNCTION 'BAL_DB_SAVE'
  EXPORTING
    i_t_log_handle = lt_log_handle
  EXCEPTIONS
    OTHERS         = 4.

IF sy-subrc <> 0.
  RETURN.
ENDIF.


IF sy-batch IS INITIAL.

  CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
    EXPORTING
*     i_s_display_profile  = display_profile
      i_t_log_handle       = lt_log_handle[]
      i_amodal             = space
    EXCEPTIONS
      profile_inconsistent = 1
      internal_error       = 2
      no_data_available    = 3
      no_authority         = 4
      OTHERS               = 5.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

ENDIF.
