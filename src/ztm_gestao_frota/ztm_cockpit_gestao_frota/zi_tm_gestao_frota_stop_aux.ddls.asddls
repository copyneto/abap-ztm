@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Gestão de Frota: Paradas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GESTAO_FROTA_STOP_AUX
  as select from           /scmtms/d_torrot              as FreightOrder

    left outer to one join /scmtms/d_torstp              as _Stop          on _Stop.parent_key = FreightOrder.db_key

    left outer to one join /SCMTMS/CV_LocationSelAddrDet as _Location      on _Location.location_id = _Stop.log_locid

    left outer to one join /SCMTMS/CV_LocationRoot       as _Address       on _Address.location_id = _Stop.log_locid

    left outer to one join adrc                          as _AddressInfo   on _AddressInfo.addrnumber = _Address.adrnummer

    left outer to one join /scmtms/d_torsts              as _StopSuccessor on  _StopSuccessor.root_key      = FreightOrder.db_key
                                                                           //and _StopSuccessor.succ_stop_key = _Stop.db_key

  association [0..1] to ZI_TM_VH_WH_NEXT_REL      as _StopNext   on _StopNext.StopNext = $projection.StopNext
  association [0..1] to ZI_CA_VH_DOMICILIO_FISCAL as _TaxJurCode on _TaxJurCode.Txjcd = $projection.TaxJurCode

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                                                                                     as FreightOrder,
  key _Stop.db_key                                                                                            as StopKey,
  key _StopSuccessor.successor_id                                                                             as SucessorId,
      _Stop.wh_next_rel                                                                                       as StopNext,
      _StopNext.StopNextText                                                                                  as StopNextText,

      FreightOrder.db_key                                                                                     as FreightOrderUUID,
      
      _Stop.log_locid                                                                                         as LocationId,
      _Address.business_partner_id                                                                            as BusinessPartnerId,
      _Address.location_type_code                                                                             as LocationTypeCode,

      cast( lpad( substring( cast ( _Stop.plan_trans_time as abap.char(20) ), 1, 8 ), 8, '0' ) as abap.dats ) as Period,
      _Location.name1                                                                                         as Name,
      _Location.country_code                                                                                  as CountryCode,
      _Location.region                                                                                        as Region,
      _Location.city_name                                                                                     as CityName,
      _Address.adrnummer                                                                                      as AddressNumber,
      _AddressInfo.taxjurcode                                                                                 as TaxJurCode,
      _TaxJurCode.Text                                                                                        as TaxJurCodeText,
      _StopSuccessor.distance_km                                                                              as DistanceKm

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _StopSuccessor.successor_id <> ''
  //and _Stop.stop_seq_pos   <> 'L'
