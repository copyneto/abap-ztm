@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes - Monitor GKO - Evento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MONITOR_GKO_EVENTO
  as select from zttm_gkot007
  association        to parent ZI_TM_MONITOR_GKO as _monitor   on _monitor.acckey = $projection.acckey

  association [0..1] to ZI_TM_VH_CODEVENTO       as _codevento on _codevento.codevento = $projection.codevento
  association [0..1] to ZI_TM_VH_CUF             as _uf        on _uf.uf = $projection.uf
  association [0..1] to ZI_TM_VH_TPAMB           as _tpamb     on _tpamb.tpamb = $projection.tpamb
{
  key acckey,
      codevento,
      _codevento.desc_codevento,
      nseqevento,
      uf,
      _uf.desc_uf,
      tpamb,
      _tpamb.desc_tpamb,
      cstat,
      xmotivo,
      dhregevento,
      nprot,
      dh_regevento_int,
      digval,

      /* Associations */
      _monitor
}
