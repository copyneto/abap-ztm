@AbapCatalog.sqlViewName: 'ZVTM_TRANSP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Transportador'
define view ZI_TM_GET_TRANSP
  as select from I_BusinessPartner_to_BP_Role as _BPRole
    inner join   I_Businesspartnertaxnumber   as _BPTax on  _BPRole.BusinessPartner = _BPTax.BusinessPartner
                                                        and _BPTax.BPTaxType        = 'BR1'
    inner join   I_BusinessPartner            as _BP    on _BP.BusinessPartner = _BPRole.BusinessPartner
{
  _BPRole.BusinessPartner,
  _BPTax.BPTaxNumber,
  _BP.BusinessPartnerName

} where _BPRole.BusinessPartnerRole = 'CRM010'
