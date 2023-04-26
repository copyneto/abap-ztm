FUNCTION zfmtm_delete_cte.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ACCKEY) TYPE  J_1B_NFE_ACCESS_KEY_DTEL44
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE: et_return.

  DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

  lo_cockpit->delete_cte( EXPORTING iv_acckey = iv_acckey
                          IMPORTING et_return = et_return ).


ENDFUNCTION.
