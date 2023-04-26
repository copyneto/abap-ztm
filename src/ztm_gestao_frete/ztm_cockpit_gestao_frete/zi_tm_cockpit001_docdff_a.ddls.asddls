@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - chave de acesso'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_DOCDFF_A
  as select from ZI_TM_COCKPIT001_DOCDFF_ACCKEY
{
  key acckey,
  key tor_id,
      db_key,
      ref_doc_nr_1,
      tpevento,
      max(wbeln) as wbeln,
      sfir_id,
      sfir_key,
      lifecycle,
      confirmation,
      btd_year,
      btd_id_056,
      btd_id_001,
      btd_id_127,
      btd_id_127_estorno,
      docnum,
      nfenum,
      packno,
      sub_packno,
      sakto,
      kostl,
      belnr_fin
}
where
  acckey is not initial
group by
  acckey,
  tor_id,
  db_key,
  ref_doc_nr_1,
  tpevento,
  sfir_id,
  sfir_key,
  lifecycle,
  confirmation,
  btd_year,
  btd_id_056,
  btd_id_001,
  btd_id_127,
  btd_id_127_estorno,
  docnum,
  nfenum,
  packno,
  sub_packno,
  sakto,
  kostl,
  belnr_fin
