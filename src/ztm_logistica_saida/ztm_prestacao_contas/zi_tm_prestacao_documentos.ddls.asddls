@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Documentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_DOCUMENTOS
  as select from ZI_TM_PRESTACAO_DOCUMENTOS_U

{
  FreightOrderUUID,
  case when FreightUnitUUID is not null
       then FreightUnitUUID
       else hextobin( '00000000000000000000000000000000' )
       end                               as FreightUnitUUID,
  FreightOrder,
  FreightOrderCategory,
  FreightOrderType,
  DeliveryDocument,
  DeliveryItemCat,
  @Semantics.quantity.unitOfMeasure : 'BaseUnit'
  BaseValue,
  BaseUnit,
  FreightUnit,
  FreightUnitCategory,
  FreightUnitType,
  SalesDocument,
  BillingDocument,
  MaterialDocument,
  MaterialDocumentYear,
  PurchaseOrder,
  AccountingDocument,
  AccountingDocumentYear,
  cast( BR_NotaFiscal as abap.char(10) ) as BR_NotaFiscal,
  @Semantics.amount.currencyCode : 'AmountCurrency'
  AmountValue,
  AmountCurrency
}
