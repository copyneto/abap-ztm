@AbapCatalog.sqlViewName: 'ZI_TM_NFTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de Categoria de NF'
define view ZC_TM_VH_NFTYPE as select from ZI_TM_VH_NFTYPE
 {
  @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key nftype,
 @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
  TextoNFType 
//  spras
    
} 
