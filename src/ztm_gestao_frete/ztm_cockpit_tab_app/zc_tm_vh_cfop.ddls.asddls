@AbapCatalog.sqlViewName: 'ZC_TM_CFOP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta CFOP'
@Search.searchable: true
define view ZC_TM_VH_CFOP
  as select from ZI_TM_VH_CFOP      as Cfop
    inner join   ZI_TM_VH_CFOP_LAST as _Last on  _Last.cfop    = Cfop.cfop
                                             and _Last.version = Cfop.version
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'CFOP'
  key Cfop.cfop                          as cfop,
      @UI.hidden: true
  key Cfop.version,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Descrição'
      substring( Cfop.TextoCFOP , 1, 40) as TextoCFOP
}
