@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 006'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT006
  as select from zttm_pcockpit006 
  association to ZC_TM_VH_CFOP as _CFOP on _CFOP.cfop = $projection.Cfop
//  association to ZI_CA_VH_CFOP as _CFOP on _CFOP.Cfop = $projection.Cfop
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
  
  
{
  key guid     as Guid,
  key cfop     as Cfop,
      cfop_int as CfopInt,
      _CFOP.TextoCFOP as TextoCFOP,
      _Cockpit
}
