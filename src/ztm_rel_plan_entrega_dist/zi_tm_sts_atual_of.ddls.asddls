@AbapCatalog.sqlViewName: 'ZI_TM_SAOF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Obter ultimo status de uma ordm de frete'
define view ZI_TM_STS_ATUAL_OF
  as select from I_TransportationOrder as _TransportationOrder
{
  key _TransportationOrder._TranspOrdExecution.TransportationOrderUUID         as IdOrdemFrete,
      _TransportationOrder.TransportationOrder                                 as CodigoOrdemFrete,
      max(_TransportationOrder._TranspOrdExecution.TranspOrdEvtActualDateTime) as Data,
      _TransportationOrder._TranspOrdExecution.TranspOrdEventCode              as Evento
}
group by
  _TransportationOrder._TranspOrdExecution.TransportationOrderUUID,
  _TransportationOrder.TransportationOrder,
  _TransportationOrder._TranspOrdExecution.TranspOrdEventCode


///scmtms/c_ev_ty :: tabela de tipos de eventos
