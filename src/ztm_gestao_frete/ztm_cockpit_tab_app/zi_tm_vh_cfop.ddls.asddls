@AbapCatalog.sqlViewName: 'ZI_TM_CFOP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_CFOP as select from j_1bagn as _CFOP 
inner join j_1bagnt as _Text on _CFOP.cfop = _Text.cfop
                                 and _CFOP.version = _Text.version
                                 and _Text.spras = $session.system_language 
{
  @ObjectModel.text.element: ['TextoCFOP']
//  @UI.textArrangement: #TEXT_LAST
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  key cast(_CFOP.cfop as abap.char(10) ) as cfop ,
  @UI.hidden: true
  key _CFOP.version,
  
  @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
  cast( _Text.cfotxt as abap.char(40) ) as TextoCFOP
//  _Text.cfop as TextoCFOP    
}
