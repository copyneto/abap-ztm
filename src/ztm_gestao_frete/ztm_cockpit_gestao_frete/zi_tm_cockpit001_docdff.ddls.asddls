@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_DOCDFF
  as select from    ZI_TM_COCKPIT001_DOCDFF_E as dff

  // Cálculo de custo extra. Se existir, utilzar
    left outer join zttm_pcockpit014          as parametro on parametro.tp_custo_tm = dff.tpevento
{
  key dff.tor_id,
  key dff.db_key,
  key dff.ref_doc_nr_1,

      case when parametro.evento_extra is not null
           then parametro.evento_extra
           else dff.tpevento end                as tpevento,

      case when dff.tpevento is not null
           then dff.tpevento
           else cast('' as ze_gko_tpevento) end as tpevento_ref,
      dff.wbeln,
      dff.sfir_id,
      dff.sfir_key,
      dff.lifecycle,
      dff.confirmation,
      dff.btd_year,
      dff.btd_id_056,
      dff.btd_id_001,
      dff.btd_id_127,
      dff.btd_id_127_estorno,
      dff.docnum,
      dff.nfenum,
      dff.packno,
      dff.sub_packno,
      dff.sakto,
      dff.kostl,
      dff.belnr_fin,
      dff.acckey
}
where
  dff.acckey is initial
