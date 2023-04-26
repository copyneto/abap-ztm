@AbapCatalog.sqlViewName: 'ZVTMPLANCARGSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Resumo de pagamentos plano de carga'
define view ZI_TM_PLANO_CARGA_PAG_SUM
  as select from ZI_TM_PLANO_CARGA_PAG as _Pagamentos
{
  key _Pagamentos.TransportationOrderKey,
  key _Pagamentos.PaymentFormType,
      _Pagamentos.TransportationOrder,
      _Pagamentos.PaymentForms,
      _Pagamentos.PaymentDescription,
      _Pagamentos.Moeda,
      @Semantics.amount.currencyCode : 'Moeda'
      sum( _Pagamentos.PaymentValue ) as PaymentValueSum
}
group by
  _Pagamentos.TransportationOrderKey,
  _Pagamentos.PaymentFormType,
  _Pagamentos.TransportationOrder,
  _Pagamentos.PaymentForms,
  _Pagamentos.PaymentDescription,
  _Pagamentos.Moeda
