@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo do total: Qtd Clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_TOTAL_FROTA_CLIENTE
  as select from ZI_TM_TOTAL_FROTA_CLIENTE_T
{
  key FreightOrder,
      cast ( 1 as abap.int4 )         as TotalCustomers,
      sum ( Customers )               as AllCustomers,
      sum ( DistanceKm )              as AllDistanceKm
}
group by
  FreightOrder
