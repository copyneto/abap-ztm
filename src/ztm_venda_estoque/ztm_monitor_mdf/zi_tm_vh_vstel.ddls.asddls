@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Placa Local Expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_VSTEL
  as select from    ZI_TM_VH_VSTEL_UNION as tvst
    left outer join tvstt                as _Text on  _Text.vstel = tvst.LocalExpedicao
                                                  and _Text.spras = $session.system_language
{
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key tvst.LocalExpedicao,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.vtext as Text

}
where
  tvst.LocalExpedicao <> '0000'
