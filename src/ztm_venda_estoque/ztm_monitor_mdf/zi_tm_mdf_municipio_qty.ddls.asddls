@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Município (Qtd)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_MUNICIPIO_QTY
  as select from I_BR_NFDocument as Doc
{
  key Doc.BR_NotaFiscal                    as BR_NotaFiscal,
      Doc.BR_NFIsCreatedManually           as BR_NFIsCreatedManually,
      Doc.SalesDocumentCurrency            as SalesDocumentCurrency,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      Doc.BR_NFTotalAmount                 as BR_NFTotalAmount,
      Doc.HeaderWeightUnit                 as HeaderWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      Doc.HeaderNetWeight                  as HeaderNetWeight,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      Doc.HeaderGrossWeight                as HeaderGrossWeight,
      Doc.BR_NFeDocumentStatus             as BR_NFeDocumentStatus,
      Doc.ShippingPoint                    as ShippingPoint,
      Doc.BusinessPlace                    as BusinessPlace,
      Doc.CompanyCode                      as CompanyCode,
      Doc.BR_NFModel                       as BR_NFModel,
      Doc.BR_NFPartnerTaxJurisdiction      as BR_NFPartnerTaxJurisdiction,

      case when Doc.BR_NFIsCreatedManually is not initial
           then cast( 0 as abap.int4 )
           else cast( 1 as abap.int4 ) end as QtdNfe,

      case when Doc.BR_NFIsCreatedManually is not initial
           then cast( 1 as abap.int4 )
           else cast( 0 as abap.int4 ) end as QtdNfeWrt
}
