@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo do total: Qtd Ordem de Venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_TOTAL_FROTA_OV_S
  as select from ZI_TM_GESTAO_FROTA_DOCS_OF as Docs

    inner join   I_SalesDocumentItem        as _SalesDocumentItem on _SalesDocumentItem.SalesDocument = Docs.SalesDocument
{
  key Docs.FreightOrder,
  key Docs.SalesDocument,
      sum ( cast( _SalesDocumentItem.ItemNetWeight as abap.dec(15,3) ) ) as TotalWeightKg
}
group by
  Docs.FreightOrder,
  Docs.SalesDocument
