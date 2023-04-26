@AbapCatalog.sqlViewName: 'ZVTM_INCO1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de Incoterms'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_INCOTERMS as select from tinc as INCO1
association to tinct as _Text on $projection.inco1  = _Text.inco1
                                and _Text.spras    = $session.system_language
 {
 @ObjectModel.text.element: ['TextoInco']
 @UI.textArrangement: #TEXT_LAST
 @Search.ranking: #MEDIUM
 @Search.defaultSearchElement: true
 @Search.fuzzinessThreshold: 0.8
 key inco1,
 _Text.bezei as TextoInco   
}
