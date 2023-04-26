@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Pagamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_PAGAMENTO
  as select from           /scmtms/d_torrot      as _OrdemFrete

    left outer join        /scmtms/d_torite      as _Entrega on  _Entrega.parent_key   = _OrdemFrete.db_key
                                                             and _Entrega.base_btd_tco = '73' -- Entrega

    left outer to one join I_BillingDocumentItem as _Fatura  on  _Fatura.ReferenceSDDocument     = substring(
      _Entrega.base_btd_id, 26, 10
    )
                                                             and _Fatura.ReferenceSDDocumentItem = substring(
      _Entrega.base_btditem_id, 5, 6
    )

  association [0..1] to I_PaymentMethodText as _PaymentMethodText on  _PaymentMethodText.Country       = $projection.Country
                                                                  and _PaymentMethodText.PaymentMethod = $projection.PaymentMethod
                                                                  and _PaymentMethodText.Language      = $session.system_language
{
  key
  cast( _OrdemFrete.db_key as /bobf/conf_key preserving type ) as FreightOrderUUID,
  _OrdemFrete.tor_id                                           as FreightOrder,
  substring( _Entrega.base_btd_id, 26, 10)                     as DeliveryDocument,
  max( _Fatura.BillingDocument )                               as Fatura,
  max( _Fatura._BillingDocument.Country )                      as Country,
  max( _Fatura._BillingDocument.PaymentMethod )                as PaymentMethod,

  /* associations */
  _PaymentMethodText
}
group by
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _Entrega.base_btd_id
