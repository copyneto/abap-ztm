@EndUserText.label: 'Prestação de Contas - Execução (Status)'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_COCKPIT_ITEM_EXECUCAO
  as projection on ZI_TM_COCKPIT_ITEM_EXECUCAO
{ 
  key FreightOrderUUID,
  key FreightUnitUUID,
  key TransportationOrderEventUUID,
      TranspOrdExecution,
      @ObjectModel.text.element: ['TranspOrdEventCodeDesc']
      TranspOrdEventCode,
      TranspOrdEventCodeDesc,
      @ObjectModel.text.element: ['TranspOrdEventStatusDesc']
      TranspOrdEventStatus,
      TranspOrdEventStatusDesc,
      @ObjectModel.text.element: ['TransportationActivityDesc']
      TransportationActivity,
      TransportationActivityDesc,
      @ObjectModel.text.element: ['TranspOrdExecInfoSourceDesc'] 
      TranspOrdExecInfoSource,
      TranspOrdExecInfoSourceDesc,
      TranspOrdEvtActualDateTime,
      TranspOrdEvtActualDateTimeZone,

      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_PRESTACAO_CONTAS
}
