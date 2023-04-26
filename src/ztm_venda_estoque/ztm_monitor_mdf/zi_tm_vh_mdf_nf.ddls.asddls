@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search help: Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_MDF_NF
  as select from j_1bnfdoc as Doc

  association [0..1] to j_1bnfe_active as _Active on _Active.docnum = Doc.docnum
{
  key Doc.docnum                  as BR_NotaFiscal,

      concat( _Active.regio,
      concat( _Active.nfyear,
      concat( _Active.nfmonth,
      concat( _Active.stcd1,
      concat( _Active.model,
      concat( _Active.serie,
      concat( _Active.nfnum9,
      concat( _Active.docnum9, _Active.cdv ) ) ) ) ) ) ) ) as AccessKey
}
