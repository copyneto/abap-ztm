@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Última Execução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_CONTAS_ULT_EXE
  as select from I_TranspOrdExecution as Execucao
{
  key TransportationOrderUUID as TransportationOrderUUID,
      max(TranspOrdExecution) as TranspOrdExecution
 
}
group by
  TransportationOrderUUID
