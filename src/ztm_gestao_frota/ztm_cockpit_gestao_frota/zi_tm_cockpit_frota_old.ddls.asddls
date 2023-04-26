@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Gestão de Frota'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_COCKPIT_FROTA_OLD
  as select from    ZI_TM_GESTAO_FROTA_DOCS_OF as Docs

    left outer join ZI_TM_GESTAO_FROTA_TRUCK   as _Truck  on _Truck.FreightOrder = Docs.FreightOrder

    left outer join ZI_TM_GESTAO_FROTA_DRIVER  as _Driver on _Driver.FreightOrder = Docs.FreightOrder

  association [0..1] to I_BR_NFDocument  as _NF            on _NF.BR_NotaFiscal = $projection.BR_NotaFiscal
  association [0..1] to /scmtms/d_torrot as _OF            on _OF.db_key = $projection.FreightOrderId
  association [0..1] to I_SalesDocument  as _SalesDocument on _SalesDocument.SalesDocument = $projection.SalesDocument
  association [0..1] to j_1bnfe_active   as _Active        on _Active.docnum = $projection.BR_NotaFiscal

{
  key Docs.FreightOrder                                                    as FreightOrder,
  key Docs.FreightUnit                                                     as FreightUnit,
  key Docs.SalesDocument                                                   as SalesDocument,
  key Docs.DeliveryDocument                                                as DeliveryDocument,
  key Docs.BillingDocument                                                 as BillingDocument,
  key Docs.BR_NotaFiscal                                                   as BR_NotaFiscal,
  key _Truck.VehicleId                                                     as VehicleId,
  key _Truck.ProductId                                                     as ProductId,
  key _Driver.Driver                                                       as Driver,

      /* Campos para filtro na CDS. Por enquanto utilizamos apenas para ver se a OV é a mesma da OF*/

      _Truck.DocumentNumber,
      _Truck.DocumentType,

      /* Dados de ordem de frete */

      Docs.FreightOrderId                                                  as FreightOrderId,
      _OF.max_util                                                         as MaxUtil,
      cast ( _OF.created_on as log_created_on preserving type )            as CreatedOn,

      /* Dados de ordem de venda */

      _SalesDocument.DistributionChannel                                   as DistributionChannel,
      _SalesDocument._DistributionChannel.
      _Text[1:Language = $session.system_language].DistributionChannelName as DistributionChannelName,

      /* Dados de nota fiscal */

      _NF.BR_NFNumber                                                      as BR_NFNumber,
      concat( _Active.regio,
      concat( _Active.nfyear,
      concat( _Active.nfmonth,
      concat( _Active.stcd1,
      concat( _Active.model,
      concat( _Active.serie,
      concat( _Active.nfnum9,
      concat( _Active.docnum9, _Active.cdv ) ) ) ) ) ) ) )                 as AccessKey,
      _Active.docsta                                                       as DocumentStatus,
      _Active.cancel                                                       as Cancel,

      /* Dados de veículo */

      _Truck.PlateNumber,
      _Truck.EquipmentCode,
      _Truck.EquipmentCodeText,

      /* Dados do produto */

      _Truck.Consignee,
      _Truck.ConsigneeName,
      _Truck.ConsigneeCPF,
      _Truck.ConsigneeCPFText,
      _Truck.ConsigneeCNPJ,
      _Truck.ConsigneeCNPJText,
      @Semantics.quantity.unitOfMeasure : 'GrossWeightUnit'
      _Truck.GrossWeightValue,
      _Truck.GrossWeightUnit,
      @Semantics.quantity.unitOfMeasure : 'GrossVolumeUnit'
      _Truck.GrossVolumeValue,
      _Truck.GrossVolumeUnit,
      _Truck.Product,
      _Truck.ProductText,
      _Truck.Plant,
      _Truck.PlantName,
      _Truck.Company,
      _Truck.CompanyName,

      /* Parada de origem */

      _Truck.FirstStopKey,
      _Truck.FirstStopNext,
      _Truck.FirstStopNextText,
      _Truck.FirstLocationId,
      _Truck.FirstPeriod,
      _Truck.FirstName,
      _Truck.FirstCountryCode,
      _Truck.FirstRegion,
      _Truck.FirstCityName,
      _Truck.FirstAddressNumber,
      _Truck.FirstTaxJurCode,
      _Truck.FirstTaxJurCodeText,

      /* Parada de destino */

      _Truck.LastStopKey,
      _Truck.LastStopNext,
      _Truck.LastStopNextText,
      _Truck.LastLocationId,
      _Truck.LastPeriod,
      _Truck.LastName,
      _Truck.LastCountryCode,
      _Truck.LastRegion,
      _Truck.LastCityName,
      _Truck.LastAddressNumber,
      _Truck.LastTaxJurCode,
      _Truck.LastTaxJurCodeText,
      _Truck.DistanceKm,

      /* Dados de equipamento */

      _Truck.ValidityStartDate,
      _Truck.ValidityEndDate,
      _Truck.AssetManufacturerName,
      _Truck.MaintenancePlant,
      _Truck.MaintenancePlantName,
      _Truck.EquipmentAge,
      _Truck.ConstructionYear,
      _Truck.ConstructionMonth,
      _Truck.ConstructionDate,
      _Truck.TechnicalObjectType,
      _Truck.TechnicalObjectTypeText,
      _Truck.EquipmentCategory,
      _Truck.EquipmentCategoryText,
      _Truck.EquipmentClass,
      _Truck.InventoryNumber,

      /* Dados de motorista */

      _Driver.DriverName,

      /* Dados de despesa (proporcional) */

      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 1 as abap.dec(21,3) )                                          as MeasureFuelVolume,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 2 as abap.dec(21,3) )                                          as MeasureFuelValue,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 3 as abap.dec(21,3) )                                          as MeasureFuelDistanceKm,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 4 as abap.dec(21,2) )                                          as MeasureDepreciationCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 5 as abap.dec(21,2) )                                          as MeasureWashingCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 6 as abap.dec(21,2) )                                          as MeasurePreventiveMaintCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 7 as abap.dec(21,2) )                                          as MeasureCorrectiveMaintCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 8 as abap.dec(21,2) )                                          as MeasureTiresCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 9 as abap.dec(21,2) )                                          as MeasureDocumentationCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 10 as abap.dec(21,2) )                                         as MeasureLaborCost,

      /* Dados de despesa (original) */

      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 11 as abap.dec(21,3) )                                         as OriginalFuelVolume,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 12 as abap.dec(21,3) )                                         as OriginalFuelValue,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 13 as abap.dec(21,3) )                                         as OriginalFuelDistanceKm,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 14 as abap.dec(21,2) )                                         as OriginalDepreciationCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 21 as abap.dec(21,2) )                                         as OriginalWashingCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 16 as abap.dec(21,2) )                                         as OriginalPreventiveMaintCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 17 as abap.dec(21,2) )                                         as OriginalCorrectiveMaintCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 18 as abap.dec(21,2) )                                         as OriginalTiresCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 19 as abap.dec(21,2) )                                         as OriginalDocumentationCost,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_VE'
      cast( 20 as abap.dec(21,2) )                                         as OriginalLaborCost,

      /* Totais */

      cast( 10 as abap.int4 )                                              as TotalSalesDocument,
      cast( 20 as abap.int4 )                                              as TotalCustomers,
      cast( 30 as abap.dec(21,2) )                                         as TotalWeightKg,
      cast( 40 as abap.dec(21,2) )                                         as TotalLoadingValue,
      cast( 40 as abap.dec(21,2) )                                         as TotalKmPerLiter,
      cast( 50 as abap.dec(21,2) )                                         as TotalValue,
      cast( 60 as abap.dec(21,2) )                                         as TotalValuePerLiter,
      cast( 70 as abap.dec(21,2) )                                         as TotalValuePerKm,
      cast( 80 as abap.dec(21,2) )                                         as TotalValuePerKg,
      cast( 90 as abap.dec(21,2) )                                         as TotalValuePerKgPerCustomer

}
where
        _Active.docsta           =  '1'   -- Autorizado
  and   _Active.cancel           =  ''    -- Não cancelado

  and(
        _Truck.DocumentType      =  '114' -- Ordem de Venda
    and _Truck.DocumentNumber    =  Docs.SalesDocument
  )

  or(
        _Truck.DocumentType      <> '114' -- Ordem de Venda
  )
