FUNCTION zfmtm_monitor_mdf_busca_hist.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_MDF) TYPE  ZTTM_MDF
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  FREE: et_return.

  DATA(lo_events) = NEW zcltm_mdf_events_manual( ).

  lo_events->get_history_background( EXPORTING is_mdf    = is_mdf
                                     IMPORTING es_mdfehd = DATA(ls_mdfehd)
                                               et_return = DATA(lt_return) ).

  INSERT LINES OF lt_return INTO TABLE et_return.

  lo_events->update_freight_order( EXPORTING is_mdf    = is_mdf
                                             is_mdfehd = ls_mdfehd
                                   IMPORTING et_return = lt_return ).

  lo_events->format_message( EXPORTING iv_change_error_type   = abap_true
                                       iv_change_warning_type = abap_true
                             CHANGING  ct_return              = lt_return ).

  INSERT LINES OF lt_return INTO TABLE et_return.

ENDFUNCTION.
