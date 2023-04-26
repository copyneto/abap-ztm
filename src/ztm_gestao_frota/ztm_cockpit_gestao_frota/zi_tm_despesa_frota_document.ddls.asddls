@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de despesas: Documentação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_DOCUMENT
  as select from ZI_TM_DESPESA_FROTA_DOCUMENT_P
{
  key Equipment                as Equipment,
      sum( DocumentationCost ) as DocumentationCost

}
group by
  Equipment
