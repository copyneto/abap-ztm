FUNCTION ZFMTM_PRESTACAO_DEF_STS .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_FREIGHTORDERUUID) TYPE  /BOBF/CONF_KEY
*"     VALUE(IV_STATUS) TYPE  /SCMTMS/TOR_LC_STATUS
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  FREE et_messages.

  DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

  lo_cockpit->change_order_status( EXPORTING iv_freightorderuuid = iv_FreightOrderUUID
                                             iv_status           = iv_status ).

  lo_cockpit->get_messages( IMPORTING et_messages = et_messages ).

ENDFUNCTION.
