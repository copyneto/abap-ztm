@AbapCatalog.sqlViewName: 'ZI_VH_TPMATERIAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de Tipo de Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_TPMATERIAL
  as select from t134
    inner join   t134t as _Text on  _Text.spras = $session.system_language
                                and _Text.mtart = t134.mtart
{
      @UI.textArrangement: #TEXT_LAST
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key t134.mtart,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.mtbez as mtart_txt
}
