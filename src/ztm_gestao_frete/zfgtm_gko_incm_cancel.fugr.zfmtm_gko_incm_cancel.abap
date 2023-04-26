FUNCTION zfmtm_gko_incm_cancel.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_INVOICEDOCNUMBER) TYPE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(IV_FISCALYEAR) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"     VALUE(IV_REASONREVERSAL) TYPE  BAPI_INCINV_FLD-REASON_REV
*"     VALUE(IV_POSTINGDATE) TYPE  BAPI_INCINV_FLD-PSTNG_DATE OPTIONAL
*"  EXPORTING
*"     VALUE(EV_INVNUMBER_REVERSAL) TYPE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(EV_FISCALYEAR_REVERSAL) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  TRY.
      CALL FUNCTION 'BAPI_INCOMINGINVOICE_CANCEL'
        EXPORTING
          invoicedocnumber          = iv_invoicedocnumber
          fiscalyear                = iv_fiscalyear
          reasonreversal            = iv_reasonreversal
          postingdate               = iv_postingdate
        IMPORTING
          invoicedocnumber_reversal = ev_invnumber_reversal
          fiscalyear_reversal       = ev_fiscalyear_reversal
        TABLES
          return                    = et_return.

      IF ev_invnumber_reversal IS INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF.

    CATCH cx_root INTO DATA(lo_root).

      DATA(lv_message) = CONV char200( lo_root->get_longtext( ) ).

      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '000'
                                            message_v1 = lv_message+0(50)
                                            message_v2 = lv_message+50(50)
                                            message_v3 = lv_message+100(50)
                                            message_v4 = lv_message+150(50) ) ).
  ENDTRY.

ENDFUNCTION.
