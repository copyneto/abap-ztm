@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Gestão de Frota: Equipamentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GESTAO_FROTA_EQUIP_L
  as select from           /scmtms/d_torrot as FreightOrder

    left outer to one join /scmtms/d_torite as _Vehicle     on  _Vehicle.parent_key = FreightOrder.db_key
                                                            and _Vehicle.item_cat   = 'AVR' -- Recurso de veículo

    inner join             I_EquipmentData  as _Equipment   on _Equipment.Equipment = _Vehicle.platenumber
                                                            and _Equipment.ValidityEndDate   >= cast( substring( cast ( FreightOrder.created_on as abap.char(20) ), 1, 8 ) as abap.dats )
                                                            and _Equipment.ValidityStartDate <= cast( substring( cast ( FreightOrder.created_on as abap.char(20) ), 1, 8 ) as abap.dats )

    left outer join        inob             as _IntNumber   on  _IntNumber.obtab = 'EQUI'
                                                            and _IntNumber.objek = _Vehicle.platenumber

    left outer join        kssk             as _ClassObject on  _ClassObject.objek = _IntNumber.cuobj
                                                            and _ClassObject.klart = _IntNumber.klart

    left outer join        klah             as _Class       on  _Class.clint = _ClassObject.clint
                                                            and _Class.class = 'SGP_VEICULOS'
                                                            
    left outer join        ausp             as _Charact     on  _Charact.objek = _IntNumber.cuobj
                                                            and _Charact.mafid = _ClassObject.mafid
                                                            and _Charact.klart = _Class.klart
                                                            and _Charact.adzhl = _ClassObject.adzhl
                                                            and _Charact.datub >= cast( substring( cast ( FreightOrder.created_on as abap.char(20) ), 1, 8 ) as abap.dats )

{
  key FreightOrder.tor_id               as FreightOrder,
  key _Vehicle.platenumber              as PlateNumber,
      max( _Equipment.ValidityEndDate ) as ValidityEndDate,
      max( _Charact.atwrt )             as EquipmentClass

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''

group by
  FreightOrder.tor_id,
  _Vehicle.platenumber
