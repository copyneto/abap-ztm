@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Nº NF-e dos serviços'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_FRETE_PREFNO
  as select from zttm_gkot001
{
  key prefno,
      acckey,
      tor_id

}
where
  prefno is not initial
