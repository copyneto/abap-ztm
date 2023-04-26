@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo do total: Qtd Ordem de Venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_TOTAL_FROTA_OV
  as select from ZI_TM_TOTAL_FROTA_OV_S as Docs

{
  key Docs.FreightOrder,
      sum ( cast ( 1 as abap.int4 ) ) as TotalSalesDocument,
      sum ( Docs.TotalWeightKg )      as TotalWeightKg
}
group by
  Docs.FreightOrder
