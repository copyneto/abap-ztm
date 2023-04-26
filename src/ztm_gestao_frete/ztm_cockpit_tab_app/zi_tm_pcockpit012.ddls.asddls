@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 012'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT012 as select from zttm_pcockpit012 
association to ZI_TM_VH_ID_TPDOC as _TpDoc on _TpDoc.DomvalueL = $projection.Tpdoc
association to ZC_TM_VH_NFTYPE as _NFTYPE on _NFTYPE.nftype = $projection.Nftype
association to ZI_TM_VH_MOD_NF  as _MODNF on _MODNF.DomvalueL = $projection.Model
association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
    key guid as Guid,
    key tpdoc as Tpdoc,
    key model as Model,
    nftype as Nftype,    
    _Cockpit,
    _TpDoc.Text as TextoTpDoc,
    _NFTYPE.TextoNFType as TextoNFType,
    _MODNF.Text      as TextoModel
}
