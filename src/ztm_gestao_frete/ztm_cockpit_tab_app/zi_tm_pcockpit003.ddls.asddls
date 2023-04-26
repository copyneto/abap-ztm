@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 003'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT003 as select from zttm_pcockpit003 as _003
//association to ZI_TM_VH_ID_CENARIO  as _CONFID on _CONFID.DomvalueL = $projection.Cenario
left outer join  ZC_MM_VH_MWSKZ as _MWSKZ on _MWSKZ.IVACode = _003.dmwskz
left outer join ZC_MM_VH_MWSKZ as _MWSKZP on _MWSKZP.IVACode = _003.pmwskz
left outer join ZC_TM_VH_CFOP as _CFOP on _CFOP.cfop = _003.cfop
association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
 {
    key _003.guid as Guid,
    @EndUserText.label: 'CFOP'
    key cast(_003.cfop as abap.char(10) ) as Cfop ,    
    @EndUserText.label: 'IVA de'
    key _003.dmwskz as Dmwskz,
    
//      @Search.defaultSearchElement: true
//    key cenario as Cenario,
    _003.cenario as Cenario,
    
    @EndUserText.label: 'IVA para'
    _003.pmwskz as Pmwskz,
//    cast( _CFOP.TextoCFOP as abap.char(30)) as TextoCFOP,
    _Cockpit,
    _MWSKZ.IVACodeName as TxtIvaDe,
    _MWSKZP.IVACodeName as TxtIvaPara,
    //Associações
//      _CONFID.Text              as TextoCenario
      _CFOP.TextoCFOP as TextoCFOP

}
