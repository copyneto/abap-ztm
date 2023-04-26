@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Documentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_DOCUMENTOS
  as select from           /scmtms/d_torrot      as _OrdemFrete -- Referência: C_FrtUnitGenDataBasicFacts

    left outer join        /scmtms/d_torite      as _Entrega      on  _Entrega.parent_key   = _OrdemFrete.db_key
                                                                  and( _Entrega.base_btd_tco = '73' -- Entrega
                                                                    or _Entrega.base_btd_tco = '58' -- Recebimento
                                                                   )

    left outer to one join /scmtms/d_torrot      as _UnidadeFrete on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                                  and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

    left outer to one join /scmtms/d_tordrf      as _OrdemVenda   on  _OrdemVenda.parent_key = _UnidadeFrete.db_key
                                                                  and _OrdemVenda.btd_tco    = '114' -- Ordem de Venda

    left outer to one join I_BillingDocumentItem as _Fatura       on  _Fatura.SalesDocument       = substring(
      _OrdemVenda.btd_id, 26, 10
    )
                                                                  and _Fatura.ReferenceSDDocument = substring(
      _Entrega.base_btd_id, 26, 10
    )

    left outer join        I_BR_NFItem           as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                                                  and _NFItem.BR_NFSourceDocumentNumber = _Fatura.BillingDocument
                                                                  and _NFItem.BR_NFSourceDocumentItem   = _Fatura.BillingDocumentItem

    left outer join        I_BR_NFDocument       as _NF           on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  //    left outer to one join /scmtms/d_tordrf as _NotaFiscal   on  _NotaFiscal.parent_key = _UnidadeFrete.db_key
  //                                                             and _NotaFiscal.btd_tco    = '004' -- Fatura (Nota Fiscal)

    left outer to one join /scmtms/d_torsum      as _SumOF        on _SumOF.parent_key = _OrdemFrete.db_key

    left outer to one join /scmtms/d_torsum      as _SumUF        on _SumUF.parent_key = _UnidadeFrete.db_key

{
  cast( _OrdemFrete.db_key as /bobf/conf_key preserving type ) as FreightOrderUUID,

  case when _UnidadeFrete.tor_id is not initial
  then cast( _Entrega.fu_root_key as /scmtms/tor_key preserving type )
  else hextobin( '99999999999999999999999999999999' )  end     as FreightUnitUUID,
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
  max( substring( _OrdemVenda.btd_id, 26, 10) )                as SalesDocument,
  max( _Fatura.BillingDocument  )                              as BillingDocument,
  //max( cast( _NFItem.BR_NotaFiscal as abap.char(10) ) )        as BR_NotaFiscal,
  max( cast( _NF.BR_NFeNumber as abap.char(10) ) )             as BR_NotaFiscal,
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
  _OrdemVenda.btd_id,
  _SumUF.amt_gdsv_val,
  _SumUF.amt_gdsv_cur
