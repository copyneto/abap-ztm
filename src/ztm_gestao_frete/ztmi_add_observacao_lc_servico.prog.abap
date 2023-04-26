*&---------------------------------------------------------------------*
*& Include ZTMI_ADD_OBSERVACAO_LC_SERVICO
*&---------------------------------------------------------------------*

NEW zcltm_modify_po( )->add_lc_observacao_nf_miro(
  EXPORTING
    it_nfitems    = CORRESPONDING #( lineitem[] )
    is_nfheader   = CORRESPONDING #( nfheader )
  CHANGING
    cv_observacao = nfheader-observat
).
