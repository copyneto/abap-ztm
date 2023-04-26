FUNCTION zfmtm_reversal_purchase_order.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ACCKEY) TYPE  J_1B_NFE_ACCESS_KEY_DTEL44
*"     VALUE(IV_TPPROCESS) TYPE  ZE_GKO_TPPROCESS
*"  EXPORTING
*"     VALUE(EV_SUCCESS) TYPE  FLAG
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(ET_BAPI_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE: et_return, et_bapi_return, ev_success.

  TRY.
      DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey    = iv_acckey
                                                    iv_tpprocess = iv_tpprocess ).

      lr_gko_process->reversal_purchase_order( IMPORTING et_return = et_return ).

    CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

      et_bapi_return = lr_cx_gko_process->get_bapi_return( ).

  ENDTRY.

  IF NOT line_exists( et_return[ type = 'E' ] )
  AND NOT line_exists( et_bapi_return[ type = 'E' ] ).
    ev_success = abap_true.
  ENDIF.

ENDFUNCTION.
