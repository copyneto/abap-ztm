@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Código status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_CODSTATUS
  as select from    dd07l as Domain
    left outer join dd07t as _Text on  _Text.domname    = Domain.domname
                                   and _Text.as4local   = Domain.as4local
                                   and _Text.valpos     = Domain.valpos
                                   and _Text.as4vers    = Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['desc_codstatus']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key cast( Domain.domvalue_l as ze_gko_codstatus     ) as codstatus,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.ddtext                                      as desc_codstatus

}
where
      Domain.domname  = 'ZD_GKO_CODSTATUS'
  and Domain.as4local = 'A';
