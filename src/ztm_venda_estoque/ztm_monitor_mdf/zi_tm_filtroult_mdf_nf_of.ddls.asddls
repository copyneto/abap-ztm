@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro da última NF da Ordem de Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_FILTROULT_MDF_NF_OF
  as select from ZI_TM_MDF_NF_OF

{
  key FreightOrder,
  key DeliveryDocument,

      max(BR_NotaFiscal) as BR_NotaFiscal

}
where
  AccessKey is not initial
group by
  FreightOrder,
  DeliveryDocument
