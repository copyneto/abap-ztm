@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_TOTALS
  as select from ZI_TM_MDF_MUNICIPIO as Municipio


{
  Municipio.Guid                                              as Guid,
  sum( Municipio._Quantidade.QtdNfe  )                        as QtdNfe,
  sum( Municipio._Quantidade.QtdNfeWrt )                      as QtdNfeWrt,
  sum( Municipio.QtdNfExtrn )                                 as QtdNfeExt,
  cast( sum( Municipio.BR_NFTotalAmount ) as abap.dec(15,2) ) as VlrCarga,
  cast( 'BRL' as waerk )                                      as Moeda, -- Municipio.SalesDocumentCurrency
  min( Municipio.Carga )                                      as Carga,
  min( Municipio.Descarga )                                   as Descarga

}
group by
  Municipio.Guid
