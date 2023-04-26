@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Gestão de Frota: Documentos (OF)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GESTAO_FROTA_DOCS_OF
  as select from           /scmtms/d_torrot      as _OrdemFrete -- Referência: C_FrtUnitGenDataBasicFacts

    left outer join        /scmtms/d_torite      as _Entrega      on _Entrega.parent_key     = _OrdemFrete.db_key
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

    left outer join        I_BR_NFItem           as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'BI' -- Faturamento
                                                                  and _NFItem.BR_NFSourceDocumentNumber = _Fatura.BillingDocument
                                                                  and _NFItem.BR_NFSourceDocumentItem   = _Fatura.BillingDocumentItem
{
  cast( _OrdemFrete.db_key as /bobf/conf_key preserving type ) as FreightOrderId,
  _OrdemFrete.tor_id                                           as FreightOrder,
  _UnidadeFrete.tor_id                                         as FreightUnit,
  cast( substring( _OrdemVenda.btd_id, 26, 10) as vbeln_vl )   as SalesDocument,
  cast( substring( _Entrega.base_btd_id, 26, 10) as vbeln_va ) as DeliveryDocument,
  _Fatura.BillingDocument                                      as BillingDocument,
  _NFItem.BR_NotaFiscal                                        as BR_NotaFiscal
}
where
      _OrdemFrete.tor_id  is not initial
  and _OrdemFrete.tor_cat = 'TO' -- Ordem de frete
  and _OrdemFrete.lifecycle <> '10' -- Cancelado

group by
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _UnidadeFrete.tor_id,
  _OrdemVenda.btd_id,
  _Entrega.base_btd_id,
  _Fatura.BillingDocument,
  _NFItem.BR_NotaFiscal
