@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Tipo do CT-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_FRETE_TPCTE
  as select from    dd07l as Domain
    left outer join dd07t as _Text on  _Text.domname    = Domain.domname
                                   and _Text.as4local   = Domain.as4local
                                   and _Text.valpos     = Domain.valpos
                                   and _Text.as4vers    = Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['tpcte_txt']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key cast( Domain.domvalue_l as ze_gko_tpcte ) as tpcte,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.ddtext                              as tpcte_txt

}
where
      Domain.domname  = 'ZD_GKO_TPCTE'
  and Domain.as4local = 'A';
