
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Regio'

@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity  ZI_TM_VH_REGIO as select from  t005s as REGIO
 association to t005u as _Text on  $projection.land1  = _Text.land1
                                and $projection.bland   = _Text.bland
                                and _Text.spras     = $session.system_language
{
//    @UI.hidden: true    
    @Search.ranking: #MEDIUM
   @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
   key REGIO.bland,
       REGIO.land1,
   _Text.bezei as texto
}
where
 REGIO.land1 =  'BR'
 and _Text.spras = 'P'
