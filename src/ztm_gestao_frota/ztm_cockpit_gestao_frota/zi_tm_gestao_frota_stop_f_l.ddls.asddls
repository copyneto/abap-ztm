@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Gestão de Frota: Paradas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GESTAO_FROTA_STOP_F_L
  as select from           /scmtms/d_torrot              as FreightOrder

    left outer join        /scmtms/d_torstp              as _FirstStop         on  _FirstStop.parent_key  = FreightOrder.db_key
                                                                               and _FirstStop.wh_next_rel = 'L' --  Carregamento

  -- View /SCMTMS/CV_LOCAD
    left outer to one join /SCMTMS/CV_LocationSelAddrDet as _FirstLocation     on _FirstLocation.location_id = _FirstStop.log_locid

  -- View /SCMTMS/CV_LOCRT
    left outer to one join /SCMTMS/CV_LocationRoot       as _FirstAddress      on _FirstAddress.location_id = _FirstStop.log_locid

    left outer to one join adrc                          as _FirstAddressInfo  on  _FirstAddressInfo.addrnumber = _FirstAddress.adrnummer
                                                                               and _FirstAddressInfo.nation     = ''


    left outer to one join /scmtms/d_torstp              as _LastStop          on  _LastStop.parent_key  = FreightOrder.db_key
                                                                               and _LastStop.wh_next_rel = 'U' --  Descarregamento ( múltiplos)

  // View /SCMTMS/CV_LOCAD
    left outer to one join /SCMTMS/CV_LocationSelAddrDet as _LastLocation      on _LastLocation.location_id = _LastStop.log_locid

  -- View /SCMTMS/CV_LOCRT
    left outer to one join /SCMTMS/CV_LocationRoot       as _LastAddress       on _LastAddress.location_id = _LastStop.log_locid

    left outer to one join adrc                          as _LastAddressInfo   on _LastAddressInfo.addrnumber = _LastAddress.adrnummer

    left outer to one join /scmtms/d_torsts              as _LastStopSuccessor on  _LastStopSuccessor.root_key      = FreightOrder.db_key
                                                                               and _LastStopSuccessor.succ_stop_key = _LastStop.db_key

  association [0..1] to ZI_CA_VH_DOMICILIO_FISCAL as _FirstTaxJurCode on _FirstTaxJurCode.Txjcd = $projection.FirstTaxJurCode
  association [0..1] to ZI_CA_VH_DOMICILIO_FISCAL as _LastTaxJurCode  on _LastTaxJurCode.Txjcd = $projection.LastTaxJurCode

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id            as FreightOrder,
      FreightOrder.db_key            as FreightOrderUUID,

      _FirstStop.db_key              as FirstKey,
      _FirstStop.log_locid           as FirstLocationId,
      _FirstStop.plan_trans_time     as FirstPeriod,
      _FirstLocation.name1           as FirstName,
      _FirstLocation.country_code    as FirstCountryCode,
      _FirstLocation.region          as FirstRegion,
      _FirstAddress.adrnummer        as FirstAddressNumber,
      _FirstAddressInfo.taxjurcode   as FirstTaxJurCode,
      _FirstTaxJurCode.Text          as FirstTaxJurCodeText,

      _LastStop.db_key               as LastKey,
      _LastStop.log_locid            as LastLocationId,
      _LastStop.plan_trans_time      as LastPeriod,
      _LastLocation.name1            as LastName,
      _LastLocation.country_code     as LastCountryCode,
      _LastLocation.region           as LastRegion,
      _LastAddress.adrnummer         as LastAddressNumber,
      _LastAddressInfo.taxjurcode    as LastTaxJurCode,
      _LastTaxJurCode.Text           as LastTaxJurCodeText,
      _LastStopSuccessor.distance_km as LastDistanceKm

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
