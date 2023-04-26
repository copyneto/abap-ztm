@AbapCatalog.sqlViewName: 'ZVTM_BRANCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de Centro / Filial'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_BRANCH
  as select from pbusinessplace
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key bukrs,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key branch,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      name as nome
}
