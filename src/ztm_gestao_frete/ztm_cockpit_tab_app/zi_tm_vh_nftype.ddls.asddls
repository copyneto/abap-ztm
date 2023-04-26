@AbapCatalog.sqlViewName: 'ZI_TM_NF_TYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de Categoria de NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_NFTYPE as select from j_1baa as _J_1BAA
     association  to j_1baat as _J_1BAAT on _J_1BAAT.nftype = $projection.nftype
                                            and _J_1BAAT.spras = $session.system_language
 {
 
   @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _J_1BAA.nftype,
   @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
  _J_1BAAT.nfttxt as TextoNFType
//  @UI.hidden: true
//  _J_1BAAT.spras
    
}
 