FUNCTION zfmtm_gko_incm_delete.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_INVNUMBER) TYPE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(IV_FISCALYEAR) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"  EXPORTING
*"     VALUE(EV_SUCESS) TYPE  CHAR1
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_return TYPE bapiret2_t.

  CALL FUNCTION 'BAPI_INCOMINGINVOICE_DELETE'
    EXPORTING
      invoicedocnumber = iv_invnumber
      fiscalyear       = iv_fiscalyear
    TABLES
      return           = lt_return.

  TRY.
      " Muda a mensagem de erro "Documento & eliminado" para sucesso
      lt_return[ type = 'E' id = 'M8' number = '417' ]-type = 'S'.
    CATCH cx_root.
  ENDTRY.

  SORT lt_return BY type.

  IF line_exists( lt_return[ type = 'E' ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    DELETE lt_return WHERE type = 'S'
                        OR type = 'W'
                        OR type = 'I'.

    et_return[] = lt_return[].

  ELSE.

    ev_sucess = abap_true.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
