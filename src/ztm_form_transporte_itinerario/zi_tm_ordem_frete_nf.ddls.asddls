@AbapCatalog.sqlViewName: 'ZITMORDEMFRETE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ordem de frete, notas fiscais e itens'
define view ZI_TM_ORDEM_FRETE_NF
  as select from    /scmtms/d_torrot      as _OrdemFrete
    inner join      /scmtms/d_torite      as _OrdemFreteItem    on  _OrdemFreteItem.parent_key      = _OrdemFrete.db_key
                                                                and _OrdemFreteItem.main_cargo_item = 'X'
                                                                and _OrdemFreteItem.base_btd_tco    = '73'
    left outer join      /scmtms/d_torite      as _OrdemFreteItemFat on  _OrdemFreteItemFat.item_parent_key = _OrdemFreteItem.db_key
                                                                and _OrdemFreteItemFat.base_btd_tco    = '73'
    left outer join      /scmtms/d_torsts      as _Paradas           on _Paradas.succ_stop_key = _OrdemFreteItem.des_stop_key
    left outer join      /scmtms/d_tordrf      as _DocsReferencia    on  _DocsReferencia.orig_ref_root = _OrdemFreteItemFat.base_btd_key
                                                                and _DocsReferencia.btd_tco       = '73'
    left outer join      /scmtms/d_torrot      as _UnidadeFrete      on  _UnidadeFrete.db_key  = _DocsReferencia.parent_key
                                                                and _UnidadeFrete.tor_cat = 'FU'
    left outer join      I_DeliveryDocument    as _CabRemessa        on _CabRemessa.DeliveryDocument = right(
      _OrdemFreteItemFat.base_btd_id, 10
    )
    left outer join I_BR_NFDocumentFlow_C as _NFDocumentFlow    on  _NFDocumentFlow.PredecessorReferenceDocument = right(
      _OrdemFreteItemFat.base_btd_id, 10
    )
                                                                and _NFDocumentFlow.PredecessorReferenceDocItem  = right(
      _OrdemFreteItemFat.base_btditem_id, 6
    )
    left outer join I_BR_NFDocument       as _NFDocument        on _NFDocument.BR_NotaFiscal = _NFDocumentFlow.BR_NotaFiscal
    inner join      I_BR_NFItem           as _NFItens           on  _NFItens.BR_NotaFiscal     = _NFDocument.BR_NotaFiscal
                                                                and _NFItens.BR_NotaFiscalItem = _NFDocumentFlow.BR_NotaFiscalItem
{
  key _OrdemFrete.db_key                           as TransportationOrderKey,
      _OrdemFrete.tor_id                           as TransportationOrder,
      _NFDocument.BR_NotaFiscal                    as NotaFiscalDoc,
      _NFItens.BR_NotaFiscalItem                   as NotaFiscalDocItem,
      _NFDocumentFlow.PredecessorReferenceDocument as DeliveryDocument,
      _NFDocumentFlow.PredecessorReferenceDocItem  as DeliveryDocItem,
      _NFDocumentFlow.ReferenceDocument            as InvoiceDocument,
      _NFDocumentFlow.ReferenceDocumentItem        as InvoiceDocItem,
      _NFDocument.BR_NFeNumber                     as NotaFiscal,
      _UnidadeFrete.db_key                         as UnitFreightKey,
      _UnidadeFrete.tor_id                         as UnitFreight,
      _NFDocument.BR_NFPartnerName1                as Cliente,
      _NFDocument.CreationDate                     as DataEmissao,
      _NFItens.Material                            as Material,
      _NFItens.MaterialName                        as MaterialName,
      _NFItens.QuantityInBaseUnit                  as Quantity,
      _NFItens.BaseUnit                            as QuantityUnit,
      _Paradas.successor_id                        as StopOrder,
      _OrdemFreteItem.item_sort_id                 as ItemSort,
      _OrdemFreteItem.net_wei_val                  as FreightOrderWeight,
      _OrdemFreteItem.net_wei_uni                  as FreightOrderWeightUnit

}
where
      _OrdemFrete.tor_cat              =  'TO'
  and _CabRemessa.DeliveryDocumentType <> 'Y026'
  and _UnidadeFrete.tor_cat            =  'FU'
