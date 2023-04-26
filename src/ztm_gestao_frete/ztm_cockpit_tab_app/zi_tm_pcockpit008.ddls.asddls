@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 008'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT008
  as select from zttm_pcockpit008
  association to ZC_TM_VH_CFOP as _CFOPDc on _CFOPDc.cfop = $projection.Dcfop
  association to ZC_TM_VH_CFOP as _CFOPPc on _CFOPPc.cfop = $projection.pcfop
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
  key guid      as Guid,
      //    key concat(concat(LEFT(dcfop, 1),'.'),concat(concat(LEFT(RIGHT(dcfop, 5), 3), '/'), RIGHT(dcfop, 2))) as Dcfop,
      //    concat(concat(LEFT(pcfop, 1),'.'),concat(concat(LEFT(RIGHT(pcfop, 5), 3), '/'), RIGHT(pcfop, 2))) as Pcfop,
      @EndUserText.label: 'CFOP Saída'
  key dcfop     as Dcfop,
  
      @EndUserText.label: 'CFOP Entrada'
      pcfop     as pcfop,
      dcfop_int as DcfopInt,
      pcfop_int as PcfopInt,
      _CFOPDc.TextoCFOP as TextDc,
      _CFOPPc.TextoCFOP as TextPc,
      _Cockpit
}
