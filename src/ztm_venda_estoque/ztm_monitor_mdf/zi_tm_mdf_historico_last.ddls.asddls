@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Histórico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HISTORICO_LAST
  as select from zttm_mdf_hist
{
  key id             as Id,
      max(histcount) as Histcount,
      max(event)     as Event
}
group by
  id
