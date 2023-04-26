@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit - Execução (Status)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZI_TM_COCKPIT_SUM_ITEM_EXEC
  as select from ZI_TM_PRESTACAO_DOCUMENTOS as _Documentos

    inner join   I_TranspOrdExecution       as _Execucao on _Execucao.TransportationOrderUUID = _Documentos.FreightUnitUUID

  association to parent ZI_TM_COCKPIT_SUM_PRESTACAO as _Cockpit on  _Cockpit.FreightOrderUUID = $projection.FreightOrderUUID
                                                                and _Cockpit.FreightUnitUUID  = $projection.FreightUnitUUID
{
  key _Documentos.FreightOrderUUID,
  key _Documentos.FreightUnitUUID,
  key _Execucao.TransportationOrderEventUUID,
      _Execucao.TranspOrdExecution,
      _Execucao.TranspOrdEventCode,
      _Execucao._TranspOrdEventCode._Text[1:Language = $session.system_language ].TranspOrdEventCodeDesc,
      _Execucao.TranspOrdEventStatus,
      _Execucao._TranspOrdEventStatus._Text[1:Language = $session.system_language ].TranspOrdEventStatusDesc,
      _Execucao.TransportationActivity,
      _Execucao._TransportationActivity._Text[1:Language = $session.system_language ].TransportationActivityDesc,
      _Execucao.TranspOrdExecInfoSource,
      _Execucao._TranspOrdExecInfoSource._Text[1:Language = $session.system_language ].ExecInfoSourceDesc as TranspOrdExecInfoSourceDesc,
      _Execucao.TranspOrdEvtActualDateTime,
      _Execucao.TranspOrdEvtActualDateTimeZone,
      _Execucao.CreatedByUser,
      _Execucao.CreationDateTime,
      _Execucao.LastChangedByUser,
      _Execucao.ChangedDateTime,

      /* associations */
      _Cockpit
}
