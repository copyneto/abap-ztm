@AbapCatalog.sqlViewName: 'ZTM_TITNF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Total de itens da nota fiscal'
define view ZI_TM_TOT_ITENS_NF 
 as select from I_BR_NFItem as _NFItem
{
  BR_NotaFiscal,
  BR_NotaFiscalItem,
  PurchaseOrder,
  @Semantics.amount.currencyCode:'SalesDocumentCurrency'
  BR_NFValueAmountWithTaxes as ItemValueTotal,
  SalesDocumentCurrency,
  count(*) as TotalItensNF
}
group by
  BR_NotaFiscal,
  BR_NotaFiscalItem,
  BR_NFValueAmountWithTaxes,
  SalesDocumentCurrency,
  PurchaseOrder
