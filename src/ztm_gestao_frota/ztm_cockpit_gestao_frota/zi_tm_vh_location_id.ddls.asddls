@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Local Expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_LOCATION_ID -- Visão /SAPAPO/V_LOCADR

  as select from    /sapapo/loc      as Loc

    inner join      adrc             as _Address     on  _Address.addrnumber = Loc.adrnummer
                                                     and _Address.nation     = ''
    inner join      /sapapo/locmap   as _Map         on _Map.locid = Loc.locid

    left outer join but000           as _Partner     on _Partner.partner_guid = Loc.partner_guid

    left outer join ZI_CA_VH_PARTNER as _PartnerInfo on _PartnerInfo.Parceiro = _Partner.partner
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Loc.locno           as LocationId,
      _Partner.partner    as Partner,
      _PartnerInfo.CPF    as CPF,
      _PartnerInfo.CNPJ   as CNPJ,
      Loc.adrnummer       as AddressNumber,
      Loc.unlocode        as Unlocode,
      Loc.iatacode        as Iatacode,
      _Address.country    as Country,
      _Address.region     as Region,
      _Address.city1      as City,
      _Address.post_code1 as Code,
      _Address.street     as Street,
      _Address.house_num1 as HouseNumber,
      _Map.wm_logsys      as WmLogsys,
      _Map.wm_wh_number   as WmWhNumber
}
