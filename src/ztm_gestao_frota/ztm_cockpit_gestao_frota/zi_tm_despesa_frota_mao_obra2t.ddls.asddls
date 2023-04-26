@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Mão -de-obra (Caminhão) x Período'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_MAO_OBRA2T
  as select from ZI_TM_DESPESA_FROTA_MAO_OBRA_T
{
  key Plant,
  key CompanyCode,
  key PeriodYearMonth as Period,
      sum( Travels )  as Travels
}
group by
  Plant,
  CompanyCode,
  PeriodYearMonth
