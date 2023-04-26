FUNCTION zfmtm_extra_charge_save.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_COD_EVENTO) TYPE  /SCMTMS/TRCHARG_ELMNT_TYPECD
*"     VALUE(IS_GKO_HEADER) TYPE  ZTTM_GKOT001 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  CONSTANTS: BEGIN OF gc_tpcte,
               normal                 TYPE ze_gko_tpcte VALUE '0',
               complemento_de_valores TYPE ze_gko_tpcte VALUE '1',
               anulacao_de_valores    TYPE ze_gko_tpcte VALUE '2',
               substituto             TYPE ze_gko_tpcte VALUE '3',
             END OF gc_tpcte .

  IF ( is_gko_header-tpevento NE 'NORMAL'
  AND  is_gko_header-tpevento NE 'ENTREGA' )
  OR ( is_gko_header-tpcte    EQ gc_tpcte-complemento_de_valores
  OR   is_gko_header-tpcte    EQ gc_tpcte-substituto ).

    " Cobrança Extra
    et_return  = NEW zcltm_eventos_extras( )->executar( EXPORTING iv_cod_evento = iv_cod_evento
                                                                  is_gko_header = is_gko_header ).

  ELSE.

* BEGIN OF INSERT - JWSILVA - 24.03.2023
      " Cobrança Normal utilizando lógica do custo extra
      et_return  = NEW zcltm_eventos_extras( )->executar( EXPORTING iv_cod_evento = 'COCKPIT'
                                                                    is_gko_header = is_gko_header ).
* END OF INSERT - JWSILVA - 24.03.2023
* BEGIN OF DELETE - JWSILVA - 24.03.2023
*      " Cobrança Normal
*      et_return  = NEW zcltm_eventos_extras( )->custo_normal( EXPORTING is_gko_header = is_gko_header ).
* END OF DELETE - JWSILVA - 24.03.2023

  ENDIF.

ENDFUNCTION.
