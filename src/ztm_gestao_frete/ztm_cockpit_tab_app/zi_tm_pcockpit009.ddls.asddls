@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 009'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT009
  as select from zttm_pcockpit009
  association to ZI_TM_VH_TPMATERIAL      as _TpMat   on _TpMat.mtart = $projection.TipoMat
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
  key guid      as Guid,
  key tipo_mat  as TipoMat,
    @EndUserText.label: 'Descrição Tipo Material'  
//    categoria as Categoria,
//  key categoria as Categoria,    
      _Cockpit,
      _TpMat
}
