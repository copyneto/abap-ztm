@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes - Monitor GKO - Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MONITOR_GKO_LOG
  as select from zttm_gkot006
  association        to parent ZI_TM_MONITOR_GKO as _monitor   on _monitor.acckey = $projection.acckey

  association [0..1] to ZI_TM_VH_CODSTATUS       as _codstatus on _codstatus.codstatus = $projection.codstatus
  association [0..1] to ZI_TM_VH_TPPROCESS       as _tpprocess on _tpprocess.tpprocess = $projection.tpprocess
  association [0..1] to ZI_CA_VH_USER            as _crenam    on _crenam.Bname = $projection.crenam

{
 
  key acckey,
  key counter, 
      codstatus,
      _codstatus.desc_codstatus,

      case when left(codstatus, 1) = 'E' then 1
           when codigo is initial        then 3
                                         else 0
      end                       as crit_codstatus,

      tpprocess,
      _tpprocess.desc_tpprocess,

      case tpprocess when '1' then 3
                     when '2' then 2
                     else 0 end as crit_tpprocess,

      newdoc,
      codigo,
      desc_codigo,
      credat,
      cretim,
      crenam,
      _crenam.Bname             as desc_crenam,

      /* Associations */
      _monitor
}
