@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Busca Agrupador'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GET_AGRUPADOR
  as select from    ZI_TM_MDF_MUNICIPIO as Municipio
    left outer join ZI_TM_MDF           as MDF on MDF.Guid = Municipio.Guid
{
  key Municipio.BR_NotaFiscal as BR_NotaFiscal,
  key Municipio.FreightOrder  as OrdemFrete,
      Municipio.Guid          as Id,
      MDF.Agrupador,
      MDF.BR_MDFeNumber,
      MDF.BR_MDFeSeries,
      MDF.AccessKey,
      MDF.StatusCode,
      MDF.StatusText,
      MDF.StatusCriticality
}
