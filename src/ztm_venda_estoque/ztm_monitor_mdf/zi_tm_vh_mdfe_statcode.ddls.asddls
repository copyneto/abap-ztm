@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Status MDF-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_TM_VH_MDFE_STATCODE
  as select from ztfm_mdf_stat
{
      @ObjectModel.text.element: ['StatusText']
      @EndUserText.label: 'Status'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key statcode    as StatusCode,
      @EndUserText.label: 'Descrição'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      description as StatusText
      //      concat_with_space(statcode, description, 1) as StatusText

}
