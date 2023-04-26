@AbapCatalog.sqlViewName: 'ZITM_REGIO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Regio'

@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_REGIO2
  as select from t005s as REGIO
  association to t005u as _Text on  $projection.land1 = _Text.land1
                                and $projection.bland = _Text.bland
                                and $projection.land1 = 'BR'
                                and _Text.spras       = $session.system_language
{
      @UI.hidden: true
  key REGIO.land1,
//      @ObjectModel.text.element: ['regio_id']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8

  key REGIO.bland,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.bezei as texto
}
