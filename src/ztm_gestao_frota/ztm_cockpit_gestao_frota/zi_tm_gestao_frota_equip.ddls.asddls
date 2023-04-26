@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes: Equipamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GESTAO_FROTA_EQUIP
  as select from ZI_TM_GESTAO_FROTA_EQUIP_L as LastEquipment

  association [0..1] to I_EquipmentData as _EquipmentData on  _EquipmentData.Equipment       = $projection.PlateNumber
                                                          and _EquipmentData.ValidityEndDate >= $projection.ValidityEndDate
                                                          and _EquipmentData.MaintenancePlant <> ''
{
  key LastEquipment.FreightOrder                                           as FreightOrder,
  key LastEquipment.PlateNumber                                            as PlateNumber,
      _EquipmentData.InventoryNumber                                       as InventoryNumber,

      /* Validade do equipamento */

      LastEquipment.ValidityEndDate                                        as ValidityEndDate,
      _EquipmentData.ValidityStartDate                                     as ValidityStartDate,

      /* Dados de equipamento */

      _EquipmentData.AssetManufacturerName                                 as AssetManufacturerName,
      _EquipmentData.MaintenancePlant                                      as MaintenancePlant,
      _EquipmentData._MaintenancePlant.PlantName                           as MaintenancePlantName,
      lpad( _EquipmentData.ConstructionYear, 4, '0' )                      as ConstructionYear,
      lpad( _EquipmentData.ConstructionMonth, 2, '0' )                     as ConstructionMonth,

      case when _EquipmentData.ConstructionYear  = ''
             or _EquipmentData.ConstructionMonth = ''
            then cast( '00000000' as abap.dats )
            else cast( concat( _EquipmentData.ConstructionYear,
                       concat( _EquipmentData.ConstructionMonth,
                       '01' ) ) as abap.dats ) end                         as ConstructionDate,

      case when _EquipmentData.ConstructionYear  = ''
            and _EquipmentData.ConstructionMonth = ''
      then cast( 0 as abap.int4 )
      else dats_days_between(
           cast( concat( _EquipmentData.ConstructionYear, 
                 concat( _EquipmentData.ConstructionMonth, 
                 '01' ) ) as abap.dats ),
           $session.system_date )
      end                                                                  as EquipmentAgeDays,

      _EquipmentData.TechnicalObjectType                                   as TechnicalObjectType,
      _EquipmentData._TechnicalObjectType.
      _Text[1:Language = $session.system_language].TechnicalObjectTypeDesc as TechnicalObjectTypeText,
      _EquipmentData.EquipmentCategory                                     as EquipmentCategory,
      _EquipmentData._EquipmentCategory.
      _Text[1:Language = $session.system_language].EquipmentCategoryDesc   as EquipmentCategoryText,
      LastEquipment.EquipmentClass                                         as EquipmentClass,
      _EquipmentData.MaintenancePlant                                      as equipPlant

}
