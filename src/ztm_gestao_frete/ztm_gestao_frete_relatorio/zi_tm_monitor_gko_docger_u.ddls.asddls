@AbapCatalog.sqlViewName: 'ZCVTM_GKO_DOCGER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor GKO - Documentos Gerados'

// Fatura

define view ZI_TM_MONITOR_GKO_DOCGER_U
  as select from ZI_TM_COCKPIT001
{

  key acckey                         as acckey,
      num_fatura                     as docgerado,
      cast( '2' as ze_gko_tipo_doc ) as tipodoc

}
where
  num_fatura is not initial

// Documento de distribuição de custo

union select from ZI_TM_COCKPIT001               as gkot001

  inner join      ZI_TM_COCKPIT001_DOCDFF_ACCKEY as dff on dff.acckey = gkot001.acckey
{
  key gkot001.acckey                 as acckey,
      dff.wbeln                      as docgerado,
      cast( '5' as ze_gko_tipo_doc ) as tipodoc
}
where
  dff.wbeln is not initial
group by
  gkot001.acckey,
  dff.wbeln
// Documento de faturamento de frete

union select from ZI_TM_COCKPIT001
{

  key acckey                         as acckey,
      right( sfir_id, 10 )           as docgerado,
      cast( '6' as ze_gko_tipo_doc ) as tipodoc

}
where
  ref_doc_nr_1 is not initial

// Pedido de Compra

union select from ZI_TM_COCKPIT001
{

  key acckey                         as acckey,
      Pedido                         as docgerado,
      cast( '1' as ze_gko_tipo_doc ) as tipodoc

}
where
  Pedido is not initial

// Folha de registro de serviços

union select from ZI_TM_COCKPIT001
{

  key acckey                         as acckey,
      btd_id                         as docgerado,
      cast( '4' as ze_gko_tipo_doc ) as tipodoc

}
where
  tor_id is not initial
