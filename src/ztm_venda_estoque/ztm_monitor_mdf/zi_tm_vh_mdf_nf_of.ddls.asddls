@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Nota Fiscal x Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define view entity ZI_TM_VH_MDF_NF_OF
  as select from ZI_TM_MDF_NF_OF

{
       @Search.defaultSearchElement: true
  key  BR_NotaFiscal,
       @Search.defaultSearchElement: true
  key  FreightOrder,
  key  DeliveryDocument,
       FreightOrderCategory,
       FreightOrderType,
       @UI.hidden: true
       FreightOrderUUID,
       @ObjectModel.text.element: ['BR_NFeDocumentStatusText']
       AccessKey,
       BR_NFeDocumentStatus,
       BR_NFeDocumentStatusText,
       BR_NFIsCanceled
}
