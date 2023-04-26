FUNCTION zfmtm_gko_nfe_active_lock.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_ACTTAB) TYPE  J_1BNFE_ACTIVE
*"     VALUE(IS_HISTTAB) TYPE  J_1BNFE_HISTORY OPTIONAL
*"     VALUE(IV_UPDMODE) TYPE  CHAR1
*"     VALUE(IV_WAIT_AFTER_COMMIT) TYPE  XFELD OPTIONAL
*"     VALUE(IS_HISTORY) TYPE  J_1BNFE_HISTORY OPTIONAL
*"  EXPORTING
*"     VALUE(EV_SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------

  DATA: ls_history TYPE j_1bnfe_history.

  ls_history = is_history.

  CALL FUNCTION 'J_1B_NFE_HISTORY_COUNT'
    CHANGING
      ch_history = ls_history.

  CALL FUNCTION 'J_1B_NFE_UPDATE_ACTIVE_W_LOCK'
    EXPORTING
      is_acttab            = is_acttab
      is_histtab           = is_histtab
      iv_updmode           = iv_updmode
      iv_wait_after_commit = iv_wait_after_commit
    EXCEPTIONS
      update_error         = 1
      lock_error           = 2
      OTHERS               = 3.

  ev_subrc = sy-subrc.

ENDFUNCTION.
