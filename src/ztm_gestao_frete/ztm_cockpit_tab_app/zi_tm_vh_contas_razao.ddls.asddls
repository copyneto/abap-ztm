@AbapCatalog.sqlViewName: 'ZI_TM_RAZAO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Contas do Razão'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_CONTAS_RAZAO as select from ska1 as _SKA1
association to skat as _SKAT on _SKAT.ktopl = _SKA1.ktopl
                                and _SKAT.saknr = $projection.saknr
                                and _SKAT.spras = $session.system_language
 {

 
  @UI.textArrangement: #TEXT_LAST
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
 key _SKA1.saknr, 
  @UI.hidden: true
 _SKA1.ktopl,
 @ObjectModel.text.element: ['TextoConta']
@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.8
 _SKAT.txt20 as TextoConta
    
}
where
_SKAT.spras = $session.system_language
