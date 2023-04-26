@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Unidade de Medida para NF Externa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_TM_VH_MDF_NF_EXT_UM
  as select from    t006

    left outer join t006a on  t006a.spras = $session.system_language
                          and t006a.msehi = t006.msehi
{
      @EndUserText.label: 'Unidade de medida'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key t006.msehi  as msehi,
      @EndUserText.label: 'Descrição'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      t006a.msehl as msehl
}
where
     t006a.msehi = 'KG'
  or t006a.msehi = 'TO'
