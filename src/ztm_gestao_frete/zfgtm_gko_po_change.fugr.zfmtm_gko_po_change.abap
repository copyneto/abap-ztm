FUNCTION zfmtm_gko_po_change.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_PURCHASEORDER) TYPE  BAPIMEPOHEADER-PO_NUMBER
*"     VALUE(IT_POITEM) TYPE  BAPIMEPOITEM_TP OPTIONAL
*"     VALUE(IT_POITEMX) TYPE  BAPIMEPOITEMX_TP OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(EV_SUCESS) TYPE  CHAR1
*"----------------------------------------------------------------------

  DATA: lt_return TYPE bapiret2_t.

  CALL FUNCTION 'BAPI_PO_CHANGE'
    EXPORTING
      purchaseorder = iv_purchaseorder
    TABLES
      return        = lt_return
      poitem        = it_poitem
      poitemx       = it_poitemx.

  SORT lt_return BY type.

  IF line_exists( lt_return[ type = 'E' ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    ev_sucess = abap_true.

  ENDIF.

  et_return[] = lt_return[].

ENDFUNCTION.
