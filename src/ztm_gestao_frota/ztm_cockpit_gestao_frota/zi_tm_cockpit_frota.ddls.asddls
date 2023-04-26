@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Gestão de Frota'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define root view entity ZI_TM_COCKPIT_FROTA
  as select from    ZI_TM_GESTAO_FROTA_DOCS_OF as Docs

  -- Exibir somente OF com placas
    inner join      ZI_TM_GESTAO_FROTA_TRUCK   as _Truck          on  _Truck.FreightOrder = Docs.FreightOrder
                                                                  and _Truck.PlateNumber  is not initial

  -- Exibir somente placas que existem
    inner join      equi                       as _TruckEquipment on _TruckEquipment.equnr   = _Truck.PlateNumber
                                                                  and(
                                                                    _TruckEquipment.eqtyp    = 'J'
                                                                    or _TruckEquipment.eqtyp = 'K'
                                                                  )

    left outer join ZI_TM_GESTAO_FROTA_DRIVER  as _Driver         on _Driver.FreightOrder = Docs.FreightOrder

  association [0..1] to I_BR_NFDocument           as _NF             on  _NF.BR_NotaFiscal = $projection.BR_NotaFiscal
  association [0..1] to /scmtms/d_torrot          as _OF             on  _OF.db_key = $projection.FreightOrderId
  association [0..1] to I_SalesDocument           as _SalesDocument  on  _SalesDocument.SalesDocument = $projection.SalesDocument
  association [0..1] to j_1bnfe_active            as _Active         on  _Active.docnum = $projection.BR_NotaFiscal

  association [0..1] to ZI_TM_TOTAL_FROTA_OV      as _TotalSales     on  _TotalSales.FreightOrder = $projection.FreightOrder
  association [0..1] to ZI_TM_TOTAL_FROTA_CLIENTE as _TotalCustomers on  _TotalCustomers.FreightOrder = $projection.FreightOrder
  association [0..1] to ZI_TM_TOTAL_FROTA_CARGA   as _TotalLoading   on  _TotalLoading.FreightOrder  = $projection.FreightOrder
                                                                     and _TotalLoading.BR_NotaFiscal = $projection.BR_NotaFiscal

{
  key Docs.FreightOrder                                                    as FreightOrder,
  key Docs.FreightUnit                                                     as FreightUnit,
  key Docs.SalesDocument                                                   as SalesDocument,
  key Docs.DeliveryDocument                                                as OutboundDelivery,
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

      case when _NF.BR_NFeNumber is not null
           then _NF.BR_NFeNumber
           else _NF.BR_NFNumber end                                        as BR_NFNumber,

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

      _Truck.PlateNumber                                                   as Equipment,
      _Truck.EquipmentCode,
      _Truck.EquipmentCodeText,

      /* Dados do produto */

      _Truck.Consignee,
      _Truck.ConsigneeName,
      _Truck.EconomicGroup,
      _Truck.ConsigneeCPF,
      _Truck.ConsigneeCPFText,
      _Truck.ConsigneeCNPJ,
      _Truck.ConsigneeCNPJText,
      @Semantics.quantity.unitOfMeasure : 'GrossWeightUnit'
      cast( _Truck.GrossWeightValue as abap.quan(31,3) )                   as GrossWeightValue,
      _Truck.GrossWeightUnit,
      @Semantics.quantity.unitOfMeasure : 'GrossVolumeUnit'
      cast( _Truck.GrossVolumeValue as abap.quan(31,3) )                   as GrossVolumeValue,
      _Truck.GrossVolumeUnit,
      _Truck.Product,
      _Truck.ProductText,
      //      _Truck.Plant,
      _Truck.equipPlant                                                    as Plant,
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
      cast( _Truck.DistanceKm as abap.dec(28,3) )                          as DistanceKm,
      cast( _TotalCustomers.AllDistanceKm as abap.dec(28,3) )              as AllDistanceKm,

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

      cast( 0 as abap.dec(21,3) )                                          as MeasureFuelVolume,
      cast( 0 as abap.dec(21,3) )                                          as MeasureFuelValue,
      cast( 0 as abap.dec(21,3) )                                          as MeasureFuelDistanceKm,
      cast( 0 as abap.dec(21,2) )                                          as MeasureDepreciationCost,
      cast( 0 as abap.dec(21,2) )                                          as MeasureWashingCost,
      cast( 0 as abap.dec(21,2) )                                          as MeasurePreventiveMaintCost,
      cast( 0 as abap.dec(21,2) )                                          as MeasureCorrectiveMaintCost,
      cast( 0 as abap.dec(21,2) )                                          as MeasureTiresCost,
      cast( 0 as abap.dec(21,2) )                                          as MeasureDocumentationCost,
      cast( 0 as abap.dec(21,8) )                                          as MeasureLaborCost,
      //      _Truck._Labor.MeasureLaborCost                                       as MeasureLaborCost,

      /* Dados de despesa (original) */

      cast( 0 as abap.dec(21,3) )                                          as OriginalFuelVolume,
      cast( 0 as abap.dec(21,3) )                                          as OriginalFuelValue,
      cast( 0 as abap.dec(21,3) )                                          as OriginalFuelDistanceKm,
      cast( 0 as abap.dec(21,2) )                                          as OriginalDepreciationCost,
      cast( 0 as abap.dec(21,2) )                                          as OriginalWashingCost,
      cast( 0 as abap.dec(21,2) )                                          as OriginalPreventiveMaintCost,
      cast( 0 as abap.dec(21,2) )                                          as OriginalCorrectiveMaintCost,
      cast( 0 as abap.dec(21,2) )                                          as OriginalTiresCost,
      cast( 0 as abap.dec(21,2) )                                          as OriginalDocumentationCost,
      cast( 0 as abap.dec(21,8) )                                          as OriginalLaborCost,
      //      _Truck._Labor.OriginalLaborCost                                      as OriginalLaborCost,

      /* Totais */

      _TotalSales.TotalSalesDocument                                       as TotalSalesDocument,
      _TotalCustomers.TotalCustomers                                       as TotalCustomers,
      _TotalCustomers.AllCustomers                                         as TotalAllCustomers,
      _TotalSales.TotalWeightKg                                            as TotalWeightKg,
      _TotalLoading.TotalLoadingValue                                      as TotalLoadingValue,
      cast( 0 as abap.dec(21,2) )                                          as TotalKmPerLiter,
      cast( 0 as abap.dec(21,2) )                                          as TotalValue,
      cast( 0 as abap.dec(21,2) )                                          as TotalValuePerLiter,
      cast( 0 as abap.dec(21,2) )                                          as TotalValuePerKm,
      cast( 0 as abap.dec(21,2) )                                          as TotalValuePerKg,
      cast( 0 as abap.dec(21,2) )                                          as TotalValuePerKgPerCustomer

}
where
        _Active.docsta           =  '1' -- Autorizado
  and   _Active.cancel           =  ''    -- Não cancelado
  and(
        _Truck.EquipmentCategory =  'J'
    or  _Truck.EquipmentCategory =  'K'
    or  _Truck.EquipmentCategory =  'C'
  )

  and(
        _Truck.DocumentType      =  '114' -- Ordem de Venda
    and _Truck.DocumentNumber    =  Docs.SalesDocument
  )
  or(
        _Truck.DocumentType      <> '114' -- Ordem de Venda
  )
