@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos relacionados à NF de saída'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_FRETE_DOCS_NF_SAIDA
  as select from ZI_TM_VH_FRETE_DOCS_NF_SAIDA_U
{
      -- Remessa
  key vbeln_vl,
  key posnr_vl,

      -- Ordem de Venda
      vbeln_va,
      posnr_va,

      -- Fatura
      vbeln_vf,
      posnr_vf,

      -- Documento Material
      mblnr,
      mjahr,
      zeile,

      -- Nota Fiscal Entrada
      docnum,
      itmnum,
      cancel,
      acckey,
      mwskz,

      -- Ordem de Frete
      of_db_key,
      of_tor_id,

      -- Unidade de Frete
      uf_tor_id
}
where
     refitm = posnr_vf
  or refitm = zeile

group by
  vbeln_vl,
  posnr_vl,
  vbeln_va,
  posnr_va,
  vbeln_vf,
  posnr_vf,
  mblnr,
  mjahr,
  zeile,
  docnum,
  itmnum,
  cancel,
  acckey,
  mwskz,
  of_db_key,
  of_tor_id,
  uf_tor_id
