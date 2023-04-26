@AbapCatalog.sqlViewName: 'ZVTM_GETCAR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dados para Interface do veiculo'
define view ZI_TM_GET_VEICULO
  as select from equi as _Dado
  inner join eqkt as _Txt on  _Dado.equnr = _Txt.equnr 
                          and _Txt.spras = $session.system_language
{
  _Txt.equnr,
  _Txt.eqktx
}
where
  s_fleet = 'X'
