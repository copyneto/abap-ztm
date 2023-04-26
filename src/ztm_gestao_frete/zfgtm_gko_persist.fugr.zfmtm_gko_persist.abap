FUNCTION zfmtm_gko_persist.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GKO_HEADER) TYPE  ZTTM_GKOT001 OPTIONAL
*"     VALUE(IS_GKO_COMPL) TYPE  ZTTM_GKOT004 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"  TABLES
*"      IT_GKO_REFERENCES STRUCTURE  ZTTM_GKOT003 OPTIONAL
*"      IT_GKO_ACCKEY_PO_DEL STRUCTURE  ZTTM_GKOT005 OPTIONAL
*"      IT_GKO_ACCKEY_PO STRUCTURE  ZTTM_GKOT005 OPTIONAL
*"      IT_GKO_LOGS STRUCTURE  ZTTM_GKOT006 OPTIONAL
*"      IT_GKO_AGRUP_DEL STRUCTURE  ZTTM_GKOT009 OPTIONAL
*"----------------------------------------------------------------------

  DATA: gs_gko_header TYPE zttm_gkot001,
        gs_gko_compl  TYPE zttm_gkot004.

  DATA: gt_gko_attachments   TYPE TABLE OF zttm_gkot002,
        gt_gko_references    TYPE TABLE OF zttm_gkot003,
        gt_gko_acckey_po_del TYPE TABLE OF zttm_gkot005,
        gt_gko_acckey_po     TYPE TABLE OF zttm_gkot005,
        gt_gko_logs          TYPE TABLE OF zttm_gkot006.

  gs_gko_header          = is_gko_header.
  gs_gko_compl           = is_gko_compl.

*  gt_gko_attachments[]   = it_gko_attachments[].
  gt_gko_references[]    = it_gko_references[].
  gt_gko_acckey_po_del[] = it_gko_acckey_po_del[].
  gt_gko_acckey_po[]     = it_gko_acckey_po[].
  gt_gko_logs[]          = it_gko_logs[].

  IF gs_gko_header IS NOT INITIAL.

    IF gs_gko_header-tor_id IS NOT INITIAL.
      gs_gko_header-tor_id = |{ gs_gko_header-tor_id ALPHA = IN }|.
    ENDIF.

    MODIFY zttm_gkot001 FROM gs_gko_header.

    IF sy-subrc IS NOT INITIAL.
      " Erro ao inserir/modificar os dados da tabela &.
      APPEND INITIAL LINE TO et_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      <fs_return>-type       = 'E'.
      <fs_return>-id         = 'ZTM_GKO'.
      <fs_return>-number     = '012'.
      <fs_return>-message_v1 = 'ZTTM_GKOT001'.
    ENDIF.
  ENDIF.

  IF gt_gko_attachments IS NOT INITIAL.

    MODIFY zttm_gkot002 FROM TABLE gt_gko_attachments.
    IF sy-subrc IS NOT INITIAL.

      " Erro ao inserir/modificar os dados da tabela &.
      APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
      <fs_return>-type       = 'E'.
      <fs_return>-id         = 'ZTM_GKO'.
      <fs_return>-number     = '012'.
      <fs_return>-message_v1 = 'ZTTM_GKOT002'.
    ENDIF.

  ENDIF.

  IF gt_gko_references IS NOT INITIAL.

    MODIFY zttm_gkot003 FROM TABLE gt_gko_references.
    IF sy-subrc IS NOT INITIAL.

      " Erro ao inserir/modificar os dados da tabela &.
      APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
      <fs_return>-type       = 'E'.
      <fs_return>-id         = 'ZTM_GKO'.
      <fs_return>-number     = '012'.
      <fs_return>-message_v1 = 'ZTTM_GKOT003'.

    ENDIF.

  ENDIF.

  IF gs_gko_compl IS NOT INITIAL.

    MODIFY zttm_gkot004 FROM gs_gko_compl.

    IF sy-subrc IS NOT INITIAL.
      " Erro ao inserir/modificar os dados da tabela &.
      APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
      <fs_return>-type       = 'E'.
      <fs_return>-id         = 'ZTM_GKO'.
      <fs_return>-number     = '012'.
      <fs_return>-message_v1 = 'ZTTM_GKOT004'.
    ENDIF.

  ENDIF.

  IF gt_gko_acckey_po_del IS NOT INITIAL.
    DELETE zttm_gkot005 FROM TABLE gt_gko_acckey_po_del.
    FREE: gt_gko_acckey_po_del.
  ENDIF.

  IF gt_gko_acckey_po IS NOT INITIAL.

    MODIFY zttm_gkot005 FROM TABLE gt_gko_acckey_po.

    IF sy-subrc IS NOT INITIAL.
      " Erro ao inserir/modificar os dados da tabela &.
      APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
      <fs_return>-id         = 'ZTM_GKO'.
      <fs_return>-number     = '012'.
      <fs_return>-message_v1 = 'ZTTM_GKOT005'.
    ENDIF.

  ENDIF.

  IF gt_gko_logs IS NOT INITIAL.

    MODIFY zttm_gkot006 FROM TABLE gt_gko_logs.
    IF sy-subrc IS NOT INITIAL.

      " Erro ao inserir/modificar os dados da tabela &.
      APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
      <fs_return>-type       = 'E'.
      <fs_return>-id         = 'ZTM_GKO'.
      <fs_return>-number     = '012'.
      <fs_return>-message_v1 = 'ZTTM_GKOT006'.

    ENDIF.

  ENDIF.

  " Remove dados de agrupamento
  IF it_gko_agrup_del[] IS NOT INITIAL.

    SELECT *
        FROM zttm_gkot009
        INTO TABLE @DATA(lt_009_del)
        FOR ALL ENTRIES IN @it_gko_agrup_del
        WHERE xblnr = @it_gko_agrup_del-xblnr
          AND stcd1 = @it_gko_agrup_del-stcd1
          AND bldat = @it_gko_agrup_del-bldat.

    IF sy-subrc EQ 0.
      DELETE zttm_gkot009 FROM TABLE it_gko_agrup_del.
      IF sy-subrc NE 0.
        " Erro ao apagar os dados da tabela &.
        APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
        <fs_return>-type       = 'E'.
        <fs_return>-id         = 'ZTM_GKO'.
        <fs_return>-number     = '136'.
        <fs_return>-message_v1 = 'ZTTM_GKOT009'.
      ENDIF.
    ENDIF.

    SELECT *
        FROM zttm_gkot010
        INTO TABLE @DATA(lt_010_del)
        FOR ALL ENTRIES IN @it_gko_agrup_del
        WHERE xblnr = @it_gko_agrup_del-xblnr
          AND stcd1 = @it_gko_agrup_del-stcd1
          AND bldat = @it_gko_agrup_del-bldat.

    IF sy-subrc EQ 0.
      DELETE zttm_gkot010 FROM TABLE lt_010_del.
      IF sy-subrc NE 0.
        " Erro ao apagar os dados da tabela &.
        APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
        <fs_return>-type       = 'E'.
        <fs_return>-id         = 'ZTM_GKO'.
        <fs_return>-number     = '136'.
        <fs_return>-message_v1 = 'ZTTM_GKOT010'.
      ENDIF.
    ENDIF.

    SELECT *
        FROM zttm_gkot011
        INTO TABLE @DATA(lt_011_del)
        FOR ALL ENTRIES IN @it_gko_agrup_del
        WHERE xblnr = @it_gko_agrup_del-xblnr
          AND stcd1 = @it_gko_agrup_del-stcd1
          AND bldat = @it_gko_agrup_del-bldat.

    IF sy-subrc EQ 0.
      DELETE zttm_gkot011 FROM TABLE lt_011_del.
      IF sy-subrc NE 0.
        " Erro ao apagar os dados da tabela &.
        APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
        <fs_return>-type       = 'E'.
        <fs_return>-id         = 'ZTM_GKO'.
        <fs_return>-number     = '136'.
        <fs_return>-message_v1 = 'ZTTM_GKOT011'.
      ENDIF.
    ENDIF.
  ENDIF.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDFUNCTION.
