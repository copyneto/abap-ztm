@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de despesas: Mão-de-obra'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_MAO_OBRA
//  as select from ZI_TM_DESPESA_FROTA_MAO_OBRA_T as Truck
  as select from ZI_TM_DESPESA_FROTA_MAO_OBRA2T as Truck

//    inner join   ZI_TM_DESPESA_FROTA_MAO_OBRA_P as _Param on  _Param.Plant       = Truck.Plant
    inner join   ZI_TM_DESPESA_FROTA_MAO_OBRA2P as _Param on  _Param.Plant       = Truck.Plant
                                                          and _Param.CompanyCode = Truck.CompanyCode
                                                          and _Param.Period      = Truck.Period

{
  key Truck.Plant                                  as Plant,
  key Truck.CompanyCode                            as Company,
  key Truck.Period                                 as Period,
      _Param.LaborCost                             as OriginalLaborCost,
      division(_Param.LaborCost, Truck.Travels, 2) as MeasureLaborCost
}
