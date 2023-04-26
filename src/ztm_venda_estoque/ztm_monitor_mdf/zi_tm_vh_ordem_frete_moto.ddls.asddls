@AbapCatalog.sqlViewName: 'ZTM_MDF_MOTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Frete: Motorista'
define view ZI_TM_VH_ORDEM_FRETE_MOTO
  as select from /scmtms/d_torite
{
  key parent_key as ParentUUID,
  key res_key    as DriverUUID,
      res_id     as DriverId,
      item_descr as DriverName
}
where
  item_cat = 'DRI'
  and res_id is not initial

union select from /scmtms/d_torpty as Party
  left outer join but000           as _Parceiro on _Parceiro.partner = Party.party_id
{
  key Party.parent_key                                                 as ParentUUID,
  key Party.node_key                                                   as DriverUUID,
      Party.party_id                                                   as DriverId,
      concat_with_space(_Parceiro.name_first, _Parceiro.name_last, 1 ) as DriverName
}
where
  party_rco = 'YM'
  and Party.party_id is not initial
