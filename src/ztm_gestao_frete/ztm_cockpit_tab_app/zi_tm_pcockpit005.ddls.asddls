@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 005'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT005 as select from zttm_pcockpit005 
association to C_CompanyCodeValueHelp as _Empresa on _Empresa.CompanyCode = $projection.Burks
association to C_ShippingPointVH as _VSTEL on _VSTEL.ShippingPoint = $projection.Vstel
association to ZC_MM_VH_MWSKZ as _MWSKZ on _MWSKZ.IVACode = $projection.Mwskz
association to ZC_TM_VH_REGIO as _FROM  on _FROM.bland    =   $projection.RegioFrom
association to ZC_TM_VH_REGIO as _TO  on _TO.bland       = $projection.RegioTo
association to ZI_TM_VH_INCOTERMS as _INCO1  on _INCO1.inco1     = $projection.Incoterm
association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
    key guid as Guid,
    @EndUserText.label: 'Origem'
    key regio_from as RegioFrom,
    @EndUserText.label: 'Destino'
    key regio_to as RegioTo,
     @Search.defaultSearchElement: true
    key incoterm as Incoterm,
    key burks as Burks,
    key vstel as Vstel,
    mwskz as Mwskz,
    
     _Cockpit,
     _INCO1.TextoInco as TextoInco,
     _FROM.texto as TextoFrom,
     _TO.texto as TextoTo,
     _MWSKZ.IVACodeName as TxtIva,
     _VSTEL.ShippingPointName as TxtVstel,
     _Empresa.CompanyCodeName as TxtEmp
}
