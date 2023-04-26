@AbapCatalog.sqlViewName: 'ZTM_MOTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Motorista'
define view ZI_TM_PRESTACAO_MOTO
  as select from /scmtms/d_torite
{
  key parent_key as ParentUUID,
  key res_key    as DriverUUID,
      res_id     as DriverId,
      item_descr as DriverName
}
where
  item_cat = 'DRI'

union select from /scmtms/d_torpty as Party
  left outer join but000           as _Parceiro on _Parceiro.partner = Party.party_id
{
  key Party.parent_key                                                 as ParentUUID,
  key Party.node_key                                                   as DriverUUID,
      Party.party_id                                                   as DriverId,
      concat_with_space(_Parceiro.name_first, _Parceiro.name_last, 1 ) as DriverName

      //      case
      //        when length( _Parceiro.name1_text ) < 1
      //         then
      //      concat_with_space(_Parceiro.name_first, _Parceiro.name_last, 1 )
      //        else _Parceiro.name1_text
      //      end        as DriverName
}
where
  party_rco = 'YM'



//  as select from ZI_TM_PRESTACAO_MOTORISTA_ITEM
//{
//  key ParentUUID,
//  key DriverUUID,
//      DriverId,
//      DriverName
//}
//union select from ZI_TM_PRESTACAO_MOTORISTA_PTY
//{
//  key ParentUUID,
//  key DriverUUID,
//  DriverId,
//  DriverName
//}
//group by
//  ParentUUID,
//  DriverUUID,
//  DriverId,
//  DriverName
