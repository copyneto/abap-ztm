FUNCTION zfmtm_interfaces.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADER) TYPE  J_1BNFDOC
*"----------------------------------------------------------------------

  DATA(lo_tor) = NEW zcltm_interface_fo( ).
  lo_tor->set_status_invoicing( is_header ).

ENDFUNCTION.
