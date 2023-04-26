@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Tipo de Equipamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_TURES_TCO
  as select from    /scmb/equi_code  as EquipmentType
    left outer join /scmb/equi_codet as _Text on  _Text.equi_type = EquipmentType.equi_type
                                              and _Text.equi_code = EquipmentType.equi_code
                                              and _Text.spras     = $session.system_language
{
      @ObjectModel.text.element: ['EquipmentCodeText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key EquipmentType.equi_code as EquipmentCode,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      EquipmentType.equi_type as EquipmentType,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.descr             as EquipmentCodeText

}
