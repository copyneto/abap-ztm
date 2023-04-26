FUNCTION zfmtm_reversal_invoice_group.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ESTORNO_MIRO) TYPE  FLAG
*"     VALUE(IV_ESTORNO_PEDIDO) TYPE  FLAG
*"     VALUE(IT_COCKPIT) TYPE  ZCTGTM_COCKPIT_NEW
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(ET_BAPI_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE: et_return, et_bapi_return.

  DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

  lo_cockpit->estorno_agrupamento( EXPORTING iv_estorno_miro   = iv_estorno_miro
                                             iv_estorno_pedido = iv_estorno_pedido
                                             it_cockpit        = CORRESPONDING #( it_cockpit )
                                   IMPORTING et_return         = et_return
                                             et_bapi_return    = et_bapi_return ).

ENDFUNCTION.
