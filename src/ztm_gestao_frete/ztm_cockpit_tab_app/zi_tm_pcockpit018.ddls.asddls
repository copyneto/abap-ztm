@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 018'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT018 as select from zttm_pcockpit018 
association to C_ShippingPointVH as _VSTEL on _VSTEL.ShippingPoint = $projection.Vstel
association to ZC_MM_VH_MWSKZ as _MWSKZ on _MWSKZ.IVACode = $projection.Mwskz

//association to ZI_TM_VH_TPMATERIAL as _TpMat on _TpMat.mtart = $projection.Mtart
association to ZC_TM_VH_MATKL as _GrpMat on _GrpMat.MATKL = $projection.Mtart

association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
    key guid as Guid,
    key vstel as Vstel,
//    @EndUserText.label: 'Tipo Material'
    key mtart as Mtart,
    key mwskz as Mwskz,
    
    _GrpMat.TextoMATKL as TextoMATKL,
    
    _Cockpit
}
