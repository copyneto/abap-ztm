FUNCTION ZFMTM_PRESTACAO_DEF_STS_UNID.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_FREIGHTORDERUUID) TYPE  /BOBF/CONF_KEY
*"     VALUE(IV_FREIGHTUNITUUID) TYPE  /BOBF/CONF_KEY
*"     VALUE(IV_TRANSPORDEVENTCODE) TYPE  /SCMTMS/TOR_EVENT
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  FREE et_messages.

  DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

  lo_cockpit->insert_unit_event_status( EXPORTING iv_freightorderuuid   = iv_freightorderuuid
                                                  iv_freightunituuid    = iv_freightunituuid
                                                  iv_transpordeventcode = iv_transpordeventcode ).

  lo_cockpit->get_messages( IMPORTING et_messages = et_messages ).

ENDFUNCTION.
