@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Carregamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_CARREGAMENTO
  as select from ZI_TM_MDF_CARREGAMENTO_U
  association        to parent ZI_TM_MDF          as _MDF        on _MDF.Guid = $projection.Id

  association [0..1] to ZI_CA_VH_DOMICILIO_FISCAL as _TaxJurCode on _TaxJurCode.Txjcd = $projection.TaxJurCode
  association [0..1] to ZI_CA_VH_REGIO_BR         as _Region     on _Region.Region = $projection.Uf
{
  key Id                 as Id,
  key TaxJurCode         as TaxJurCode,
      _TaxJurCode.Text   as TaxJurCodeText,
      Region             as Uf,
      _Region.RegionName as UfName,

      /* associations */
      _MDF
}
