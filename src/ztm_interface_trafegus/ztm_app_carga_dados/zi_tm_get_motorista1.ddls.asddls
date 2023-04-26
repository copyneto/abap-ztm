@AbapCatalog.sqlViewName: 'ZVTM_GETMOTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dados para Interface do motorista'
define view ZI_TM_GET_MOTORISTA1
  as select from I_BusinessPartner          as _BP
    inner join   I_Businesspartnertaxnumber as _BPTax on  _BP.BusinessPartner = _BPTax.BusinessPartner
                                                      and _BPTax.BPTaxType    = 'BR2'

{
  _BP.BusinessPartner,
  _BPTax.BPTaxNumber,
  _BP.BusinessPartnerName
}
where
  BusinessPartnerType = '0011'
