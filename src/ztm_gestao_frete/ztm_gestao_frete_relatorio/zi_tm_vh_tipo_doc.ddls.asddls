@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Tipo documento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_TIPO_DOC
  as select from    dd07l as Domain
    left outer join dd07t as _Text on  _Text.domname    = Domain.domname
                                   and _Text.as4local   = Domain.as4local
                                   and _Text.valpos     = Domain.valpos
                                   and _Text.as4vers    = Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['desc_tipodoc']
  key cast( Domain.domvalue_l as ze_gko_tipo_doc  ) as tipodoc,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.ddtext                                  as desc_tipodoc,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      @UI.hidden: true
      Domain.domvalue_l                             as tipodoc_search

}
where
      Domain.domname  = 'ZD_GKO_TIPO_DOC'
  and Domain.as4local = 'A';
