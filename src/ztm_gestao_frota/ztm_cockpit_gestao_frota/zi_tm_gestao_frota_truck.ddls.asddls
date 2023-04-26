@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes: Caminhão'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GESTAO_FROTA_TRUCK
  as select from           /scmtms/d_torrot as FreightOrder

    left outer to one join /scmtms/d_torite as _Vehicle on  _Vehicle.parent_key = FreightOrder.db_key
                                                        and _Vehicle.item_cat   = 'AVR' -- Recurso de veículo

    left outer join        /scmtms/d_torite as _Product on  _Product.parent_key = FreightOrder.db_key
                                                        and _Product.item_cat   = 'PRD' -- Produto
                                                        and _Product.main_cargo_item = 'X'
    
    left outer join ZI_TM_GESTAO_FROTA_DRIVER  as _Driver         on _Driver.FreightOrder = FreightOrder.tor_id 

  association [0..1] to ZI_TM_GESTAO_FROTA_STOP      as _FirstStop     on  _FirstStop.FreightOrder = $projection.FreightOrder
                                                                       and _FirstStop.StopKey      = $projection.FirstStopKey

  association [0..1] to ZI_TM_GESTAO_FROTA_STOP      as _LastStop      on  _LastStop.FreightOrder = $projection.FreightOrder
                                                                       and _LastStop.StopKey      = $projection.LastStopKey

  association [0..1] to ZI_TM_GESTAO_FROTA_EQUIP     as _Equipment     on  _Equipment.FreightOrder = $projection.FreightOrder
                                                                       and _Equipment.PlateNumber  = $projection.PlateNumber

  association [0..1] to ZI_TM_GESTAO_FROTA_UG        as _EconomicGroup on  _EconomicGroup.Consignee = $projection.Consignee

  association [0..1] to ZI_TM_VH_TURES_TCO           as _EquipmentCode on  _EquipmentCode.EquipmentCode = $projection.EquipmentCode
  association [0..1] to ZI_TM_VH_CONSIGNEE_ID        as _Consignee     on  _Consignee.Partner = _Driver.Driver
  association [0..1] to ZI_CA_VH_MATERIAL            as _Material      on  _Material.Material = $projection.Product
  association [0..1] to ZI_CA_VH_WERKS               as _Plant         on  _Plant.WerksCode = $projection.Plant
  association [0..1] to ZI_CA_VH_COMPANY             as _Company       on  _Company.CompanyCode = $projection.Company

  /* Despesas */

  association [0..1] to ZI_TM_DESPESA_FROTA_MAO_OBRA as _Labor         on  _Labor.Plant   = $projection.Plant
                                                                       and _Labor.Company = $projection.Company
                                                                       and _Labor.Period  = $projection.FirstPeriod

{
  key FreightOrder.tor_id                                              as FreightOrder,
  key _Vehicle.db_key                                                  as VehicleId,
  key _Product.db_key                                                  as ProductId,

      FreightOrder.db_key                                              as FreightOrderId,

      /* Dados de veículo */

      _Vehicle.platenumber                                             as PlateNumber,
      _Vehicle.tures_tco                                               as EquipmentCode,
      _EquipmentCode.EquipmentCode                                     as EquipmentCodeText,

      /* Dados do produto */

      _Product.consignee_id                                            as Consignee,
      _Consignee.PartnerName                                           as ConsigneeName,
      _EconomicGroup.LocationId                                        as EconomicGroup,
      _Consignee.CPF                                                   as ConsigneeCPF,
      _Consignee.CPFText                                               as ConsigneeCPFText,
      _Consignee.CNPJ                                                  as ConsigneeCNPJ,
      _Consignee.CNPJText                                              as ConsigneeCNPJText,
      @Semantics.quantity.unitOfMeasure : 'GrossWeightUnit'
      cast ( _Product.gro_wei_val as /sapmp/qty_long preserving type ) as GrossWeightValue,
      _Product.gro_wei_uni                                             as GrossWeightUnit,
      @Semantics.quantity.unitOfMeasure : 'GrossVolumeUnit'
      cast ( _Product.gro_vol_val as /sapmp/qty_long preserving type ) as GrossVolumeValue,
      _Product.gro_vol_uni                                             as GrossVolumeUnit,
      _Product.product_id                                              as Product,
      _Material.Text                                                   as ProductText,
      _Product.erp_plant_id                                            as Plant,
      //      cast( _Equipment.equipPlant  as abap.char(4) )                   as Plant,
      //      _Equipment.equipPlant                                            as Plant,
      _Equipment.equipPlant                                            as equipPlant,
      _Plant.WerksCodeName                                             as PlantName,
      _Product.erp_comp_code                                           as Company,
      _Company.CompanyCodeName                                         as CompanyName,
      cast( substring( _Product.orig_btd_id, 26, 10) as vbeln_vl )     as DocumentNumber,
      _Product.orig_btd_tco                                            as DocumentType,

      /* Parada de origem */

      _Product.src_stop_key                                            as FirstStopKey,
      _FirstStop.StopNext                                              as FirstStopNext,
      _FirstStop.StopNextText                                          as FirstStopNextText,
      _FirstStop.LocationId                                            as FirstLocationId,
      _FirstStop.BusinessPartnerId                                     as FirstBusinessPartnerId,
      _FirstStop.LocationTypeCode                                      as FirstLocationTypeCode,
      _FirstStop.Period                                                as FirstPeriod,
      _FirstStop.Name                                                  as FirstName,
      _FirstStop.CountryCode                                           as FirstCountryCode,
      _FirstStop.Region                                                as FirstRegion,
      _FirstStop.CityName                                              as FirstCityName,
      _FirstStop.AddressNumber                                         as FirstAddressNumber,
      _FirstStop.TaxJurCode                                            as FirstTaxJurCode,
      _FirstStop.TaxJurCodeText                                        as FirstTaxJurCodeText,

      /* Parada de destino */

      _Product.des_stop_key                                            as LastStopKey,
      _LastStop.StopNext                                               as LastStopNext,
      _LastStop.StopNextText                                           as LastStopNextText,
      _LastStop.LocationId                                             as LastLocationId,
      _LastStop.BusinessPartnerId                                      as LastBusinessPartnerId,
      _LastStop.LocationTypeCode                                       as LastLocationTypeCode,
      _LastStop.Period                                                 as LastPeriod,
      _LastStop.Name                                                   as LastName,
      _LastStop.CountryCode                                            as LastCountryCode,
      _LastStop.Region                                                 as LastRegion,
      _LastStop.CityName                                               as LastCityName,
      _LastStop.AddressNumber                                          as LastAddressNumber,
      _LastStop.TaxJurCode                                             as LastTaxJurCode,
      _LastStop.TaxJurCodeText                                         as LastTaxJurCodeText,
      _LastStop.DistanceKm                                             as DistanceKm,

      /* Dados de equipamento */

      _Equipment.ValidityStartDate                                     as ValidityStartDate,
      _Equipment.ValidityEndDate                                       as ValidityEndDate,
      _Equipment.AssetManufacturerName                                 as AssetManufacturerName,
      _Equipment.MaintenancePlant                                      as MaintenancePlant,
      _Equipment.MaintenancePlantName                                  as MaintenancePlantName,
      division( _Equipment.EquipmentAgeDays, 365, 0 )                  as EquipmentAge, -- Idade em anos
      _Equipment.ConstructionYear                                      as ConstructionYear,
      _Equipment.ConstructionMonth                                     as ConstructionMonth,
      _Equipment.ConstructionDate                                      as ConstructionDate,
      _Equipment.TechnicalObjectType                                   as TechnicalObjectType,
      _Equipment.TechnicalObjectTypeText                               as TechnicalObjectTypeText,
      _Equipment.EquipmentCategory                                     as EquipmentCategory,
      _Equipment.EquipmentCategoryText                                 as EquipmentCategoryText,
      _Equipment.EquipmentClass                                        as EquipmentClass,
      _Equipment.InventoryNumber                                       as InventoryNumber,

      /* Despesas */

      _Labor
}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
