@AbapCatalog.sqlViewName: 'ZVTM_FROTA_DRI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes: Motorista'
define view ZI_TM_GESTAO_FROTA_DRIVER
  as select from /scmtms/d_torrot as FreightOrder
    inner join   /scmtms/d_torite as _Item on _Item.parent_key = FreightOrder.db_key
{
  key FreightOrder.tor_id as FreightOrder,
  key _Item.res_id        as Driver,
      _Item.item_descr    as DriverName
}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _Item.item_cat       =  'DRI'
  and _Item.res_id         is not initial

union select from /scmtms/d_torrot as FreightOrder
  inner join      /scmtms/d_torpty as _Party    on _Party.parent_key = FreightOrder.db_key
  left outer join but000           as _Parceiro on _Parceiro.partner = _Party.party_id
{
  key FreightOrder.tor_id                                              as FreightOrder,
  key _Party.party_id                                                  as Driver,
      concat_with_space(_Parceiro.name_first, _Parceiro.name_last, 1 ) as DriverName
}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _Party.party_rco     =  'YM'
  and _Party.party_id      is not initial
