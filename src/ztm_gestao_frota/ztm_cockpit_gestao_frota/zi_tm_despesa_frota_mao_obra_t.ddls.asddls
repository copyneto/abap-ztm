@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo despesas: Mão-de-obra (Caminhão)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_MAO_OBRA_T
  as select from ZI_TM_GESTAO_FROTA_TRUCK

{
  key Plant                          as Plant,
  key Company                        as CompanyCode,
  key FirstPeriod                    as Period,
      substring( FirstPeriod, 1, 6 ) as PeriodYearMonth,
      sum( cast( 1 as abap.int4 ) )  as Travels
}
where
      Plant       is not initial
  and Company     is not initial
  and FirstPeriod is not initial

group by
  Plant,
  Company,
  FirstPeriod
