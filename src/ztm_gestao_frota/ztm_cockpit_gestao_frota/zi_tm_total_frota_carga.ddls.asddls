@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo do total: Valor da Carga'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_TOTAL_FROTA_CARGA
  as select from ZI_TM_GESTAO_FROTA_DOCS_OF as OF

    inner join   I_BR_NFDocument            as _NF on _NF.BR_NotaFiscal = OF.BR_NotaFiscal
{
  key OF.FreightOrder,
  key OF.BR_NotaFiscal,
      cast( _NF.BR_NFTotalAmount as abap.dec(15,2) ) as TotalLoadingValue
}
group by
  OF.FreightOrder,
  OF.BR_NotaFiscal,
  _NF.BR_NFTotalAmount
