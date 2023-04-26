FUNCTION zfmtm_mdf_driver_change.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"     VALUE(IS_PARAMETERS) TYPE  ZC_TM_MDF_MOTORISTA_POPUP
*"     VALUE(IV_ID) TYPE  SYSUUID_X16
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE et_return.

  DATA(lo_mdf_events) = NEW zcltm_mdf_events( ).

  et_return = lo_mdf_events->mdf_driver_change( EXPORTING iv_docnum     = iv_docnum
                                                          is_parameters = is_parameters
                                                          iv_id         = iv_id ).
ENDFUNCTION.
