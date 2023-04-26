@AbapCatalog.sqlViewName: 'ZIVHVEHYTP'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Tipo Veículo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Search.searchable: true


define view ZI_TM_VH_VEHICLE_TYPE
  as select distinct from /scmb/equi_code
    inner join            /scmb/equi_codet on  /scmb/equi_codet.spras     = $session.system_language
                                           and /scmb/equi_codet.equi_type = /scmb/equi_code.equi_type
                                           and /scmb/equi_codet.equi_code = /scmb/equi_code.equi_code
{
      @Search.ranking: #HIGH
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: ['VehicleTypeDescription']
  key /scmb/equi_code.equi_code as VehicleType,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @Semantics.text: true
      /scmb/equi_codet.descr    as VehicleTypeDescription
}
