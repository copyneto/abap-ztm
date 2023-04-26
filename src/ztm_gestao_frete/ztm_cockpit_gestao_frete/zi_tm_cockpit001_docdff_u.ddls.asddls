@AbapCatalog.sqlViewName: 'ZVTM_DOCDFF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - Combinações'
define view ZI_TM_COCKPIT001_DOCDFF_U
  as select from ZI_TM_COCKPIT001_DOCDFF as dff
{
  key dff.tor_id,
  key dff.db_key,
  key dff.ref_doc_nr_1,
  key dff.tpevento,
      max( dff.wbeln ) as wbeln,
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
      dff.sakto,
      dff.kostl,
      dff.belnr_fin
}
group by
  dff.tor_id,
  dff.ref_doc_nr_1,
  dff.db_key,
  dff.sfir_key,
  dff.tpevento,
  dff.sfir_id,
  dff.lifecycle,
  dff.confirmation,
  dff.btd_year,
  dff.btd_id_056,
  dff.btd_id_001,
  dff.btd_id_127,
  dff.btd_id_127_estorno,
  dff.docnum,
  dff.nfenum,
  dff.sakto,
  dff.kostl,
  dff.belnr_fin

union select from ZI_TM_COCKPIT001_DOCDFF_ENTR as _entrega

  inner join      ZI_TM_COCKPIT001_DOCDFF      as dff on  dff.tor_id = _entrega.tor_id
                                                      and dff.db_key = _entrega.db_key
{
  key dff.tor_id,
  key dff.db_key,
  key dff.ref_doc_nr_1,
  key cast( 'ENTREGA' as ze_gko_tpevento ) as tpevento,
      max( dff.wbeln )                     as wbeln,
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
      dff.sakto,
      dff.kostl,
      dff.belnr_fin
}
group by
  dff.tor_id,
  dff.ref_doc_nr_1,
  dff.db_key,
  dff.tpevento,
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
  dff.sakto,
  dff.kostl,
  dff.belnr_fin

union select from ZI_TM_COCKPIT001_DOCDFF_NORMAL as _normal

  inner join      ZI_TM_COCKPIT001_DOCDFF        as dff on  dff.tor_id = _normal.tor_id
                                                        and dff.db_key = _normal.db_key

{
  key dff.tor_id,
  key dff.db_key,
  key dff.ref_doc_nr_1,
  key cast( 'NORMAL' as ze_gko_tpevento ) as tpevento,
      max( dff.wbeln )                    as wbeln,
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
      dff.sakto,
      dff.kostl,
      dff.belnr_fin
}
group by
  dff.tor_id,
  dff.ref_doc_nr_1,
  dff.db_key,
  dff.tpevento,
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
  dff.sakto,
  dff.kostl,
  dff.belnr_fin
