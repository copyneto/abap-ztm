@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_MOTO_ALL
  as select from ZI_TM_PRESTACAO_MOTO
{
  key ParentUUID,
  key DriverUUID,
      DriverId,
      DriverName
}

group by
  ParentUUID,
  DriverUUID,
  DriverId,
  DriverName
