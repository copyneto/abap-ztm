@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Último histórico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HISTORICO_LAST_EVENT
  as select from zttm_mdf_hist
{
  key id             as Id,
      max(event)     as Event
}
group by
  id
