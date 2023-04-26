@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Próxima parada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_WH_NEXT_REL
  as select from    dd07l as Domain
    left outer join dd07t as _Text on  _Text.domname    = Domain.domname
                                   and _Text.as4local   = Domain.as4local
                                   and _Text.valpos     = Domain.valpos
                                   and _Text.as4vers    = Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['StopNextText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key cast( Domain.domvalue_l as /scmtms/stop_wh_next ) as StopNext,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.ddtext                                      as StopNextText

}
where
      Domain.domname  = '/SCMTMS/STOP_WH_NEXT'
  and Domain.as4local = 'A';
