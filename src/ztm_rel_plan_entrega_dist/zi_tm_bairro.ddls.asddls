@AbapCatalog.sqlViewName: 'ZITMBAIRRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Obter Bairro'
define view ZI_TM_BAIRRO
  as select from but020
    inner join   adrc on but020.addrnumber = adrc.addrnumber
{
  but020.partner,
  adrc.addrnumber,
  adrc.city2
}
