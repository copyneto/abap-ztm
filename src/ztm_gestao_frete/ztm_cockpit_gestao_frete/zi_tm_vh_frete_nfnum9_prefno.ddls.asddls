@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search-Help: Nº CT-e/NF-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_FRETE_NFNUM9_PREFNO
  as select from zttm_gkot001
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key case when nfnum9 is not initial
           then nfnum9
           when prefno is not initial
           then prefno
           else cast( '' as j_1bprefno )  end as nfnum9,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key tpdoc                                   as tpdoc,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key acckey                                  as acckey

}
where
     nfnum9 is not initial
  or prefno is not initial
