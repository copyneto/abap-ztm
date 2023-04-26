@AbapCatalog.sqlViewName: 'ZV_VH_VSTEL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Placa Local Expedição'
define view ZI_TM_VH_VSTEL_UNION
  as select from ZI_CA_VH_VSTEL
{
  ZI_CA_VH_VSTEL.LocalExpedicao as LocalExpedicao
}
union select from /scmtms/d_torrot
{
  lpad( substring(/scmtms/d_torrot.shipperid, 7, 4 ), 4, '0') as LocalExpedicao
}
