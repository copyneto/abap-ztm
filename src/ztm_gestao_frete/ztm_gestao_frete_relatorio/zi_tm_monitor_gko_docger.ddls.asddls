@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor GKO - Documentos Gerados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MONITOR_GKO_DOCGER
  as select from ZI_TM_MONITOR_GKO_DOCGER_U
  association        to parent ZI_TM_MONITOR_GKO as _monitor on _monitor.acckey = $projection.acckey

  association [0..1] to ZI_TM_VH_TIPO_DOC        as _tipodoc on _tipodoc.tipodoc = $projection.tipodoc
{
  key acckey,
  key docgerado,
      tipodoc,
      _tipodoc.desc_tipodoc,

      /* Associations */
      _monitor
}

