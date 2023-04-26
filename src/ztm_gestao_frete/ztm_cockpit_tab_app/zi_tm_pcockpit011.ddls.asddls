@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 011'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT011
  as select from zttm_pcockpit011
  association to ZI_TM_VH_INCOTERMS       as _Incoterms on _Incoterms.inco1 = $projection.Incoterms
  association to ZC_MM_VH_MWSKZ           as _Dmwskz    on _Dmwskz.IVACode = $projection.Dmwskz
  association to ZC_MM_VH_MWSKZ           as _Pmwskz    on _Pmwskz.IVACode = $projection.Pmwskz
  association to ZC_MM_VH_MWSKZ           as _Gmwskz    on _Gmwskz.IVACode = $projection.Gmwskz
  association to ZI_TM_VH_ID_CENARIO      as _CONFID    on _CONFID.DomvalueL = $projection.Cenario
  association to ZI_TM_VH_ID_TPRATEIO     as _TpRat     on _TpRat.DomvalueL = $projection.Rateio
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit   on _Cockpit.Guid = $projection.Guid
{
  key guid                 as Guid,
  key cenario              as Cenario,
  key incoterm             as Incoterms,
  key rateio               as Rateio,
      _CONFID.Text         as TextoCenario,
      _TpRat.Text          as TextoRateio,
      _Incoterms.TextoInco as TextoIncoterms,
      dmwskz               as Dmwskz,
      _Dmwskz.IVACodeName  as TextoDmwskz,
      pmwskz               as Pmwskz,
      _Pmwskz.IVACodeName  as TextoPmwskz,
      gmwskz               as Gmwskz,
      _Gmwskz.IVACodeName  as TextoGmwskz,

      //Associações
      _Cockpit
}
