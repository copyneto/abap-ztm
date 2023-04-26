@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Mão -de-obra (Parâmetro) x Período'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_MAO_OBRA2P
  as select from ZI_TM_DESPESA_FROTA_MAO_OBRA_P
{
  key Plant,
  key CompanyCode,
  key PeriodYearMonth  as Period,
      sum( LaborCost ) as LaborCost,
      sum( Documents ) as Documents
}
group by
  Plant,
  CompanyCode,
  PeriodYearMonth
