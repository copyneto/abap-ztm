@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação Contas - Motorista (nó Item)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_MOTORISTA_ITEM
  as select from /scmtms/d_torite
{
  key parent_key as ParentUUID,
  key res_key    as DriverUUID,
      res_id     as DriverId,
      item_descr as DriverName
}
where
  item_cat = 'DRI'
