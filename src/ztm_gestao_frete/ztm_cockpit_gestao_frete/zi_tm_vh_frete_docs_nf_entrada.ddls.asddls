@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos relacionados à NF de entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_FRETE_DOCS_NF_ENTRADA

  as select from ZI_TM_VH_FRETE_DOCS_NF_ENTRA_U

{

      -- Remessa
  key vbeln_vl,
  key posnr_vl,
      -- Ordem de Venda
      vbeln_va,
      posnr_va,
      -- Pedido
      ebeln,
      ebelp,
      etens,
      -- Fatura
      belnr,
      gjahr,
      buzei,
      -- Fatura (estorno)
      stblg,
      stjah,
      -- Nota Fiscal Entrada
      docnum,
      itmnum,
      cancel,
      acckey,
      mwskz,
      -- Ordem de Frete
//      max( of_db_key )   as of_db_key,
      max( of_tor_id )   as of_tor_id,
      max( of_tor_cat )  as of_tor_cat,
      max( of_tor_type ) as of_tor_type,
      -- Unidade de Frete
      max( uf_tor_id )   as uf_tor_id

}
group by
  vbeln_vl,
  posnr_vl,
  vbeln_va,
  posnr_va,
  ebeln,
  ebelp,
  etens,
  belnr,
  gjahr,
  buzei,
  stblg,
  stjah,
  docnum,
  itmnum,
  cancel,
  acckey,
  mwskz
