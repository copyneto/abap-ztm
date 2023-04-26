
DATA: lv_gko_acckey          TYPE ZTTM_gkot001-acckey,
      lv_gko_pcfop           TYPE zttm_pcockpit008-pcfop,
      ls_gko_cfop_parameters TYPE j_1bao.

"Verifica se o registro está sendo gerado pela integração GKO
IF zcltm_gko_process=>check_invoice_gko( EXPORTING
                                         iv_belnr   = rbkpv-belnr
                                         iv_gjahr   = rbkpv-gjahr
                                       IMPORTING
                                         ev_acckey = lv_gko_acckey ).

  "Obtêm os dados da chave de acesso
  SELECT SINGLE
         tpdoc
       , rem_uf
       , dest_uf
    FROM ZTTM_gkot001
    INTO @DATA(ls_zgkot001)
    WHERE acckey = @lv_gko_acckey.

  "Preenchimento da lei complementar para NFS
  IF sy-subrc IS INITIAL AND ls_zgkot001-tpdoc = zcltm_gko_process=>gc_tpdoc-nfs AND lineitem IS NOT INITIAL.
    nfheader-observat = lineitem[ 1 ]-nbm.
  ENDIF.

  "Verifica se há necessidade de troca do CFOP
  SELECT SINGLE zttm_pcockpit008~pcfop
    FROM ZTTM_gkot001
    INNER JOIN zttm_pcockpit008
      ON zttm_pcockpit008~dcfop = ZTTM_gkot001~cfop
    WHERE ZTTM_gkot001~acckey     EQ @lv_gko_acckey
      AND zttm_pcockpit008~pcfop  NE @space
    INTO @lv_gko_pcfop.

  IF sy-subrc NE 0.

    SELECT SINGLE zttm_pcockpit008~pcfop
      FROM ZTTM_gkot001
      INNER JOIN zttm_pcockpit008
        ON substring( zttm_pcockpit008~dcfop, 1, 4 ) = substring( ZTTM_gkot001~cfop, 1, 4 )
      WHERE ZTTM_gkot001~acckey     EQ @lv_gko_acckey
        AND zttm_pcockpit008~pcfop  NE @space
      INTO @lv_gko_pcfop.

    IF sy-subrc NE 0.
      CLEAR lv_gko_pcfop.
    ENDIF.
  ENDIF.

  IF lv_gko_pcfop IS NOT INITIAL.

    LOOP AT lineitem ASSIGNING FIELD-SYMBOL(<fs_s_gko_lineitem>).
      <fs_s_gko_lineitem>-cfop = lv_gko_pcfop.
    ENDLOOP.

  ELSEIF ls_zgkot001-tpdoc <> zcltm_gko_process=>gc_tpdoc-nfs.

    "Obtêm a categoria do CFOP
    SELECT SINGLE
           industry
      FROM j_1bbranch
      INTO ls_gko_cfop_parameters-indus2
      WHERE bukrs  = nfheader-bukrs
        AND branch = nfheader-branch.

    IF ls_zgkot001-rem_uf <> ls_zgkot001-dest_uf.
      ls_gko_cfop_parameters-dstcat = '1'.
    ELSE.
      ls_gko_cfop_parameters-dstcat = '0'.
    ENDIF.

    ls_gko_cfop_parameters-direct = nfheader-direct.
    ls_gko_cfop_parameters-indus3 = '03'.

    LOOP AT lineitem ASSIGNING FIELD-SYMBOL(<fs_s_gko_lineitem2>).

      ls_gko_cfop_parameters-itmtyp = <fs_s_gko_lineitem2>-itmtyp.
      ls_gko_cfop_parameters-spcsto = <fs_s_gko_lineitem2>-spcsto.
      ls_gko_cfop_parameters-matuse = <fs_s_gko_lineitem2>-matuse.

      FREE: lv_gko_pcfop.

      "Determinando CFOP
      CALL FUNCTION 'J_1B_NF_CFOP_1_DETERMINATION'
        EXPORTING
          cfop_parameters = ls_gko_cfop_parameters
          i_land1         = nfheader-land1
          i_region        = nfheader-regio
          i_date          = nfheader-pstdat
        IMPORTING
          cfop            = lv_gko_pcfop
        EXCEPTIONS
          cfop_not_found  = 1
          OTHERS          = 2.

      "Atualiza os itens com o CFOP encontrado
      IF sy-subrc IS INITIAL AND lv_gko_pcfop IS NOT INITIAL.

        <fs_s_gko_lineitem2>-cfop = lv_gko_pcfop.

      ENDIF.

    ENDLOOP.

  ENDIF.

ENDIF.
