@AbapCatalog.sqlViewName: 'ZC_TM_REGIO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Regio'
define view ZC_TM_VH_REGIO as select from ZI_TM_VH_REGIO2 {

     @UI.hidden: true
  key land1,
//      @ObjectModel.text.element: ['regio_id']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8

  key bland,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      texto
    
}
where
  land1 = 'BR';
