@AbapCatalog.sqlViewName: 'ZTM_CLI_OC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Obter cliente para cenário de compras'
define view ZI_TM_CLI_COMPRA
  as select from    /SCMTMS/CV_LocationRoot as _LocationBOPF
    inner join      I_BusinessPartner       as _BP   on _LocationBOPF.business_partner_id = _BP.BusinessPartner
    left outer join kna1                    as _Kna1 on _Kna1.kunnr = _BP.BusinessPartner
{
  _LocationBOPF.location_id   as LocationId,
  business_partner_id         as CodigoBP,
  _BP.BusinessPartnerFullName as NomeBP,
  _Kna1.katr9                 as AreaAtendimento
}
