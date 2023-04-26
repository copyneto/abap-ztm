@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 019'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT019 as select from zttm_pcockpit019 
association to ZI_TM_VH_ID_CENARIO  as _CONFID on _CONFID.DomvalueL = $projection.Cenario
 association to ZC_MM_VH_MWSKZ       as _ivanf    on _ivanf.IVACode = $projection.IvaNf
  association to ZC_MM_VH_MWSKZ       as _ivafrete    on _ivafrete.IVACode = $projection.IvaFrete
association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
    key guid as Guid,
    key cenario as Cenario,
    @EndUserText.label: 'ICMS no XML'
    key icms_xml as IcmsXml,
    @EndUserText.label: 'Iva NF'
    key iva_nf as IvaNf,
    @EndUserText.label: 'Iva Frete'
    key iva_frete as IvaFrete,
    
    @EndUserText.label: 'Movimentação'
    movimentacao,
    _ivanf.IVACodeName as TextoIvaNF,
    _ivafrete.IVACodeName as TextoIvaFrete,
    _Cockpit,
    
    //Associações
      _CONFID.Text              as TextoCenario
}
