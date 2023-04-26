FUNCTION zfmtm_gko_reverse_fi_docs.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_RE_BELNR) TYPE  ZTTM_GKOT001-RE_BELNR
*"     VALUE(IV_RE_GJAHR) TYPE  ZTTM_GKOT001-RE_GJAHR
*"     VALUE(IV_REV_BELNR) TYPE  ZTTM_GKOT001-RE_BELNR
*"     VALUE(IV_REV_GJAHR) TYPE  ZTTM_GKOT001-RE_GJAHR
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"     VALUE(ET_BAPI_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE: et_return.

  TRY.
*      SELECT SINGLE bukrs,
*                    budat
*        FROM rbkp
*        INTO @DATA(ls_rbkp_rev)
*        WHERE belnr = @iv_rev_belnr
*          AND gjahr = @iv_rev_gjahr.
*
*      SELECT SINGLE buzei
*        FROM bseg
*        INTO @DATA(lv_buzei_orig)
*       WHERE bukrs = @ls_rbkp_rev-bukrs
*         AND belnr = @iv_re_belnr
*         AND gjahr = @iv_re_gjahr
*         AND koart = 'K'.
*
*      SELECT SINGLE buzei
*        FROM bseg
*        INTO @DATA(lv_buzei_rev)
*       WHERE bukrs = @ls_rbkp_rev-bukrs
*         AND belnr = @iv_rev_belnr
*         AND gjahr = @iv_rev_gjahr
*         AND koart = 'K'.

      " Recupera documento original
      SELECT SINGLE rbkp~belnr,
                    rbkp~gjahr,
                    rbkp~bukrs,
                    rbkp~budat,
                    bseg~bukrs AS b_bukrs,
                    bseg~belnr AS b_belnr,
                    bseg~gjahr AS b_gjahr,
                    bseg~buzei AS b_buzei,
                    bseg~koart
        FROM rbkp
        INNER JOIN bseg
            ON  bseg~lifnr = rbkp~lifnr
            AND bseg~awkey = concat( rbkp~belnr, rbkp~gjahr )
            AND koart = 'K'
        WHERE rbkp~belnr = @iv_re_belnr
          AND rbkp~gjahr = @iv_re_gjahr
        INTO @DATA(ls_rbkp_re).

      " Recupera documento de estorno
      SELECT SINGLE rbkp~belnr,
                    rbkp~gjahr,
                    rbkp~bukrs,
                    rbkp~budat,
                    bseg~bukrs AS b_bukrs,
                    bseg~belnr AS b_belnr,
                    bseg~gjahr AS b_gjahr,
                    bseg~buzei AS b_buzei,
                    bseg~koart
        FROM rbkp
        INNER JOIN bseg
            ON  bseg~lifnr = rbkp~lifnr
            AND bseg~awkey = concat( rbkp~belnr, rbkp~gjahr )
            AND koart = 'K'
        WHERE rbkp~belnr = @iv_rev_belnr
          AND rbkp~gjahr = @iv_rev_gjahr
        INTO @DATA(ls_rbkp_rev).

      IF sy-subrc NE 0.
        CLEAR ls_rbkp_rev.
      ENDIF.

      DATA(lr_gko_clearing) = NEW zclfi_gko_clearing( iv_augvl = 'UMBUCHNG' ).

      lr_gko_clearing->set_header_data( VALUE #( bukrs = ls_rbkp_rev-bukrs
                                                 blart = 'KP'
                                                 budat = ls_rbkp_rev-budat
                                                 bldat = ls_rbkp_rev-budat
                                                 monat = ls_rbkp_rev-budat+4(2)
                                                 waers = 'BRL'
                                                 bktxt = 'ESTORNO FATURA GKO'
                                               ) ).

      lr_gko_clearing->set_documents( VALUE #( ( bukrs = ls_rbkp_re-b_bukrs
                                                 belnr = ls_rbkp_re-b_belnr
                                                 gjahr = ls_rbkp_re-b_gjahr
                                                 buzei = ls_rbkp_re-b_buzei
                                                 koart = ls_rbkp_re-koart )
                                               ( bukrs = ls_rbkp_rev-b_bukrs
                                                 belnr = ls_rbkp_rev-b_belnr
                                                 gjahr = ls_rbkp_rev-b_gjahr
                                                 buzei = ls_rbkp_rev-b_buzei
                                                 koart = ls_rbkp_rev-koart )
                                               ) ).

      DATA(lt_result) = lr_gko_clearing->clear_documents( IMPORTING et_return = et_bapi_return ).

      TRY.
          DATA(ls_result) = lt_result[ 1 ].
          DATA(lv_bukrs) = ls_result-bukrs.
          DATA(lv_belnr) = ls_result-belnr.
          DATA(lv_gjahr) = ls_result-gjahr.

          " Documento de estorno compensado com sucesso, &.
          et_return = VALUE #( ( id         = 'ZTM_GKO'
                                 number     = '085'
                                 type       = 'S'
                                 message_v1 = |{ lv_bukrs }/{ lv_belnr }/{ lv_gjahr }| ) ).
        CATCH cx_root.
      ENDTRY.

    CATCH zcxtm_gko_clearing INTO DATA(lr_cx_gko_clearing).

      " Compensar manualmente o documento de estorno, &.
      et_return = VALUE #( ( id         = 'ZTM_GKO'
                             number     = '086'
                             type       = 'S'
                             message_v1 = |{ ls_rbkp_rev-bukrs }/{ iv_rev_belnr }/{ iv_rev_gjahr }| ) ).

  ENDTRY.

ENDFUNCTION.
