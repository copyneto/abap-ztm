@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo do total: Todos os Clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_TOTAL_FROTA_CLIENTE_T
  as select from ZI_TM_GESTAO_FROTA_TRUCK
{
  key FreightOrder,
  key LastLocationId,
      cast ( 1 as abap.int4 )  as Customers,
      sum ( DistanceKm )              as DistanceKm

}
group by
  FreightOrder,
  LastLocationId
