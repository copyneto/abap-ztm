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
define view ZI_TM_VH_CFOP
  as select from j_1bagn  as _CFOP
    inner join   j_1bagnt as _Text on  _CFOP.cfop    = _Text.cfop
                                   and _CFOP.version = _Text.version
                                   and _Text.spras   = $session.system_language
{
      @ObjectModel.text.element: ['TextoCFOP']
  key cast(_CFOP.cfop as abap.char(10) )    as cfop,
      @UI.hidden: true
  key _CFOP.version,
      @Semantics.text: true
      cast( _Text.cfotxt as abap.char(40) ) as TextoCFOP,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      @UI.hidden: true
      _CFOP.cfop                            as cfop_search,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      @UI.hidden: true
      _Text.cfotxt                          as TextoCFOP_search

}
