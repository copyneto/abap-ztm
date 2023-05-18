@AbapCatalog.sqlViewName: 'ZVTM_PRE_CON_DOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de contas - documentos'
define view ZI_TM_PRESTACAO_DOCUMENTOS_U
  as select from           /scmtms/d_torrot      as _OrdemFrete -- Referência: C_FrtUnitGenDataBasicFacts

    left outer join        /scmtms/d_torite      as _Entrega      on _Entrega.parent_key     = _OrdemFrete.db_key
                                                                  and( _Entrega.base_btd_tco = '73' -- Entrega
                                                                    or _Entrega.base_btd_tco = '58' -- Recebimento
                                                                  )

    left outer to one join /scmtms/d_torrot      as _UnidadeFrete on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                                  and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

    left outer to one join /scmtms/d_tordrf      as _OrdemVenda   on  _OrdemVenda.parent_key = _UnidadeFrete.db_key
                                                                  and ( _OrdemVenda.btd_tco    = '114' -- Ordem de Venda
                                                                     or _OrdemVenda.btd_tco    = '32' -- Devolução
                                                                  )

    left outer to one join I_BillingDocumentItem as _Fatura       on  _Fatura.SalesDocument       = right( _OrdemVenda.btd_id, 10 )
                                                                  and _Fatura.ReferenceSDDocument = right( _Entrega.base_btd_id, 10 )

    left outer join        I_BR_NFItem           as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                                                  and _NFItem.BR_NFSourceDocumentNumber = _Fatura.BillingDocument
                                                                  and _NFItem.BR_NFSourceDocumentItem   = _Fatura.BillingDocumentItem
                                                                  
    left outer join        I_BR_NFDocument       as _NF           on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

    left outer join        I_BR_NFeActive        as _NFActive     on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal
    
    left outer join        I_DeliveryDocumentItem as _RemessaItem on _RemessaItem.DeliveryDocument = right( _Entrega.base_btd_id, 10 )

    left outer to one join /scmtms/d_torsum      as _SumOF        on _SumOF.parent_key = _OrdemFrete.db_key

    left outer to one join /scmtms/d_torsum      as _SumUF        on _SumUF.parent_key = _UnidadeFrete.db_key

{
  cast( _OrdemFrete.db_key as /bobf/conf_key preserving type )    as FreightOrderUUID,
  cast( _Entrega.fu_root_key as /scmtms/tor_key preserving type ) as FreightUnitUUID,
  _OrdemFrete.tor_id                                              as FreightOrder,
  _OrdemFrete.tor_cat                                             as FreightOrderCategory,
  _OrdemFrete.tor_type                                            as FreightOrderType,
  substring( _Entrega.base_btd_id, 26, 10)                        as DeliveryDocument,
  _Entrega.item_cat                                               as DeliveryItemCat,
  @Semantics.quantity.unitOfMeasure : 'BaseUnit'   
  cast( _UnidadeFrete.gro_vol_val as /scmtms/quantity_13_3 )      as BaseValue,
  _UnidadeFrete.gro_vol_uni                                       as BaseUnit,
  _UnidadeFrete.tor_id                                            as FreightUnit,
  _UnidadeFrete.tor_cat                                           as FreightUnitCategory,
  _UnidadeFrete.tor_type                                          as FreightUnitType,
  max( _RemessaItem.ReferenceSDDocument )                         as SalesDocument,
  max( _Fatura.BillingDocument  )                                 as BillingDocument,
  cast('' as mblnr )                                              as MaterialDocument,
  cast('' as mjahr )                                              as MaterialDocumentYear,
  cast('' as ebeln )                                              as PurchaseOrder,
  cast('' as belnr_d )                                            as AccountingDocument,
  cast('' as gjahr )                                              as AccountingDocumentYear,
  max( _NF.BR_NFeNumber )                                         as BR_NotaFiscal,
  @Semantics.amount.currencyCode : 'AmountCurrency'   
  cast( _SumUF.amt_gdsv_val as abap.dec(28,6) ) * 10000           as AmountValue,
  _SumUF.amt_gdsv_cur                                             as AmountCurrency
}
where
      _OrdemFrete.tor_id  is not initial
  and _OrdemFrete.tor_cat = 'TO' -- Ordem de frete

group by
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _OrdemFrete.tor_cat,
  _OrdemFrete.tor_type,
  _Entrega.base_btd_id,
  _Entrega.item_cat,
  _UnidadeFrete.gro_vol_val,
  _UnidadeFrete.gro_vol_uni,
  _Entrega.fu_root_key,
  _UnidadeFrete.tor_id,
  _UnidadeFrete.tor_cat,
  _UnidadeFrete.tor_type,
  _OrdemVenda.btd_id,
  _SumUF.amt_gdsv_val,
  _SumUF.amt_gdsv_cur

/* ----------------------------------------------------------------------
   Cenário de Transferência
---------------------------------------------------------------------- */

union select from        /scmtms/d_torrot   as _OrdemFrete

  left outer join        /scmtms/d_torite   as _Entrega       on _Entrega.parent_key     = _OrdemFrete.db_key
                                                              and( _Entrega.base_btd_tco = '73'     -- Entrega
                                                                or _Entrega.base_btd_tco = '58'     -- Recebimento
                                                              )

  left outer to one join /scmtms/d_torrot   as _UnidadeFrete  on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                              and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

  left outer join        lips               as _RemessaItem   on _RemessaItem.vbeln = right( _Entrega.base_btd_id, 10 )

  left outer join        I_DeliveryDocument as _Likp          on _Likp.DeliveryDocument = right( _Entrega.base_btd_id, 10 )

  left outer join        nsdm_e_mseg        as _Transferencia on  _Transferencia.ebeln    = _RemessaItem.vgbel
                                                              and _Transferencia.ebelp    = right( _RemessaItem.vgpos, 5 )
                                                              and _Transferencia.vbeln_im = _RemessaItem.vbeln
                                                              and _Transferencia.vbelp_im = _RemessaItem.posnr

  left outer join        I_BR_NFItem        as _NFItem        on  _NFItem.BR_NFSourceDocumentType   = 'MD'
                                                              and _NFItem.BR_NFSourceDocumentNumber = concat( left( _Transferencia.mblnr, 10 ), left( _Transferencia.mjahr, 4 ) )

  left outer join        I_BR_NFDocument    as _NF            on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal
    
  left outer join        I_BR_NFeActive     as _NFActive      on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer to one join /scmtms/d_torsum   as _SumOF         on _SumOF.parent_key = _OrdemFrete.db_key

  left outer to one join /scmtms/d_torsum   as _SumUF         on _SumUF.parent_key = _UnidadeFrete.db_key

{
  cast( _OrdemFrete.db_key as /bobf/conf_key preserving type ) as FreightOrderUUID,

  case when _UnidadeFrete.tor_id is not initial
  then cast( _Entrega.fu_root_key as /scmtms/tor_key preserving type )
  else hextobin( '00000000000000000000000000000000' )  end     as FreightUnitUUID,
  _OrdemFrete.tor_id                                           as FreightOrder,
  _OrdemFrete.tor_cat                                          as FreightOrderCategory,
  _OrdemFrete.tor_type                                         as FreightOrderType,
  substring( _Entrega.base_btd_id, 26, 10)                     as DeliveryDocument,
  _Entrega.item_cat                                            as DeliveryItemCat,
  @Semantics.quantity.unitOfMeasure : 'BaseUnit'
  cast( _UnidadeFrete.gro_vol_val as /scmtms/quantity_13_3 )   as BaseValue,
  _UnidadeFrete.gro_vol_uni                                    as BaseUnit,
  _UnidadeFrete.tor_id                                         as FreightUnit,
  _UnidadeFrete.tor_cat                                        as FreightUnitCategory,
  _UnidadeFrete.tor_type                                       as FreightUnitType,
  max( _RemessaItem.vgbel )                                    as SalesDocument,
  cast('' as vbeln_vf )                                        as BillingDocument,
  max( _Transferencia.mblnr )                                  as MaterialDocument,
  max( _Transferencia.mjahr )                                  as MaterialDocumentYear,
  cast('' as ebeln )                                           as PurchaseOrder,
  cast('' as belnr_d )                                         as AccountingDocument,
  cast('' as gjahr )                                           as AccountingDocumentYear,
  max( _NF.BR_NFeNumber )                                      as BR_NotaFiscal,
  @Semantics.amount.currencyCode : 'AmountCurrency'
  cast( _SumUF.amt_gdsv_val as abap.dec(28,6) ) * 10000        as AmountValue,
  _SumUF.amt_gdsv_cur                                          as AmountCurrency
}
where
      _OrdemFrete.tor_id  is not initial
  and _OrdemFrete.tor_cat = 'TO' -- Ordem de frete

group by
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _OrdemFrete.tor_cat,
  _OrdemFrete.tor_type,
  _Entrega.base_btd_id,
  _Entrega.item_cat,
  _UnidadeFrete.gro_vol_val,
  _UnidadeFrete.gro_vol_uni,
  _Entrega.fu_root_key,
  _UnidadeFrete.tor_id,
  _UnidadeFrete.tor_cat,
  _UnidadeFrete.tor_type,
  _Transferencia.mblnr,
  _Transferencia.mjahr,
  _SumUF.amt_gdsv_val,
  _SumUF.amt_gdsv_cur

/* ----------------------------------------------------------------------
   Cenário de Venda Coligada
---------------------------------------------------------------------- */

union select from        /scmtms/d_torrot   as _OrdemFrete

  left outer join        /scmtms/d_torite   as _Entrega      on _Entrega.parent_key     = _OrdemFrete.db_key
                                                             and( _Entrega.base_btd_tco = '73'      -- Entrega
                                                               or _Entrega.base_btd_tco = '58'      -- Recebimento
                                                             )

  left outer to one join /scmtms/d_torrot   as _UnidadeFrete on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                             and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

  left outer join        lips               as _RemessaItem  on _RemessaItem.vbeln = right( _Entrega.base_btd_id, 10 )

  left outer join        ekes               as _Pedido       on _Pedido.vbeln = right( _Entrega.base_btd_id, 10 )

  left outer join        rseg               as _Fatura       on  _Fatura.ebeln = _Pedido.ebeln
                                                             and _Fatura.ebelp = _Pedido.ebelp

  left outer join        I_BR_NFItem        as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'LI'
                                                             and _NFItem.BR_NFSourceDocumentNumber = concat( left( _Fatura.belnr, 10 ), left( _Fatura.gjahr, 4 ) )

  left outer join        I_BR_NFDocument    as _NF           on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal
  
  left outer join        I_BR_NFeActive     as _NFActive     on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer to one join /scmtms/d_torsum   as _SumOF        on _SumOF.parent_key = _OrdemFrete.db_key

  left outer to one join /scmtms/d_torsum   as _SumUF        on _SumUF.parent_key = _UnidadeFrete.db_key

{
  cast( _OrdemFrete.db_key as /bobf/conf_key preserving type ) as FreightOrderUUID,

  case when _UnidadeFrete.tor_id is not initial
  then cast( _Entrega.fu_root_key as /scmtms/tor_key preserving type )
  else hextobin( '00000000000000000000000000000000' )  end     as FreightUnitUUID,
  _OrdemFrete.tor_id                                           as FreightOrder,
  _OrdemFrete.tor_cat                                          as FreightOrderCategory,
  _OrdemFrete.tor_type                                         as FreightOrderType,
  substring( _Entrega.base_btd_id, 26, 10)                     as DeliveryDocument,
  _Entrega.item_cat                                            as DeliveryItemCat,
  @Semantics.quantity.unitOfMeasure : 'BaseUnit'
  cast( _UnidadeFrete.gro_vol_val as /scmtms/quantity_13_3 )   as BaseValue,
  _UnidadeFrete.gro_vol_uni                                    as BaseUnit,
  _UnidadeFrete.tor_id                                         as FreightUnit,
  _UnidadeFrete.tor_cat                                        as FreightUnitCategory,
  _UnidadeFrete.tor_type                                       as FreightUnitType,
  max( _RemessaItem.vgbel )                                    as SalesDocument,
  cast('' as vbeln_vf )                                        as BillingDocument,
  cast('' as mblnr )                                           as MaterialDocument,
  cast('' as mjahr )                                           as MaterialDocumentYear,
  _Pedido.ebeln                                                as PurchaseOrder,
  _Fatura.belnr                                                as AccountingDocument,
  _Fatura.gjahr                                                as AccountingDocumentYear,
  max( _NF.BR_NFeNumber )                                      as BR_NotaFiscal,
  @Semantics.amount.currencyCode : 'AmountCurrency'
  cast( _SumUF.amt_gdsv_val as abap.dec(28,6) ) * 10000        as AmountValue,
  _SumUF.amt_gdsv_cur                                          as AmountCurrency
}
where
      _OrdemFrete.tor_id  is not initial
  and _OrdemFrete.tor_cat = 'TO' -- Ordem de frete

group by
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _OrdemFrete.tor_cat,
  _OrdemFrete.tor_type,
  _Entrega.base_btd_id,
  _Entrega.item_cat,
  _UnidadeFrete.gro_vol_val,
  _UnidadeFrete.gro_vol_uni,
  _Entrega.fu_root_key,
  _UnidadeFrete.tor_id,
  _UnidadeFrete.tor_cat,
  _UnidadeFrete.tor_type,
  _Pedido.ebeln,
  _Fatura.belnr,
  _Fatura.gjahr,
  _SumUF.amt_gdsv_val,
  _SumUF.amt_gdsv_cur
