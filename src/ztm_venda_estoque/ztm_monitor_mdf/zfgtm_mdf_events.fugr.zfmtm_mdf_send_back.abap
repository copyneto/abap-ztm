FUNCTION zfmtm_mdf_send_back.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"     VALUE(IV_ID) TYPE  SYSUUID_X16
*"     VALUE(IV_RESEND) TYPE  /XNFE/RESEND
*"  EXPORTING
*"     VALUE(EV_STATUSCODE) TYPE  /XNFE/STATUSCODE
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE et_return.

  DATA(lo_mdf_events) = NEW zcltm_mdf_events( ).

  et_return = lo_mdf_events->mdf_send( EXPORTING iv_docnum = iv_docnum
                                                 iv_id     = iv_id
                                                 iv_resend = iv_resend
                                       IMPORTING ev_statuscode = ev_statuscode ).

ENDFUNCTION.
