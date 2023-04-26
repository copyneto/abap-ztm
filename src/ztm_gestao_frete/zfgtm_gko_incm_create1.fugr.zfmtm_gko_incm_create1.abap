FUNCTION zfmtm_gko_incm_create1.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADERDATA) TYPE  BAPI_INCINV_CREATE_HEADER
*"     VALUE(IV_INVOICESTATUS) TYPE  BAPI_INCINV_CREATE_STATUS-RBSTAT
*"       DEFAULT 5
*"     VALUE(IV_ACCKEY) TYPE  J_1B_NFE_ACCESS_KEY_DTEL44 OPTIONAL
*"     VALUE(IS_ARREDONDAMENTO) TYPE  ZSTM_GKO_ARREDONDAMENTO OPTIONAL
*"  EXPORTING
*"     VALUE(EV_INVOICEDOCNUMBER) TYPE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(EV_FISCALYEAR) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"  CHANGING
*"     VALUE(CT_ITEMDATA) TYPE  BAPI_INCINV_CREATE_ITEM_TAB OPTIONAL
*"     VALUE(CT_RETURN) TYPE  BAPIRET2_T OPTIONAL
*"----------------------------------------------------------------------

  DATA: lt_return TYPE bapiret2_t.

  " Limpa a variável para evitar o erro 8B 219 'Documento de referência  não encontrado'
  " O mesmo ocorre quando o estorno é realizado e em seguida é realizada a criação da fatura
  ASSIGN ('(SAPLJ1BI)STORNO_FLAG') TO FIELD-SYMBOL(<fs_storno_flag>).
  IF sy-subrc IS INITIAL.
    FREE: <fs_storno_flag>.
  ENDIF.

  IF iv_acckey IS NOT INITIAL.
    " Exporta a chave de acesso, para o correto processamento do ENHANCEMENT ZENH_GKO_NF_MIRO
    EXPORT gko_acckey = iv_acckey TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
  ENDIF.

  IF is_arredondamento IS NOT INITIAL.
    " Utilizado na BAdI ZCL_J_1BNF_ADD_DATA para distribuir o valor da diferença
    EXPORT item_arredondamento = is_arredondamento TO MEMORY ID zcltm_gko_process=>gc_memory_id-item_arredondamento.
  ENDIF.

  CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
    EXPORTING
      headerdata       = is_headerdata
      invoicestatus    = iv_invoicestatus
    IMPORTING
      invoicedocnumber = ev_invoicedocnumber
      fiscalyear       = ev_fiscalyear
    TABLES
      itemdata         = ct_itemdata
      return           = lt_return.

  IF iv_acckey IS NOT INITIAL.
    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
  ENDIF.

  IF is_arredondamento IS NOT INITIAL.
    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-item_arredondamento.
  ENDIF.

  SORT lt_return BY type.

  IF line_exists( lt_return[ type = 'E' ] )
  OR ev_invoicedocnumber IS INITIAL.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
