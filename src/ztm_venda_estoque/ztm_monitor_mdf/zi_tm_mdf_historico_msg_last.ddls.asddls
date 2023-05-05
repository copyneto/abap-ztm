@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Último histórico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HISTORICO_MSG_LAST
  as select from ZI_TM_MDF_HISTORICO_LAST

  association [0..1] to ZI_TM_MDF_HISTORICO as _Historico on  _Historico.Id        = $projection.Id
                                                          and _Historico.Histcount = $projection.Histcount
                                                          and _Historico.Event     = $projection.Event
{
  key Id,  
      Histcount,
      Event, 
      _Historico.Proctyp,
      _Historico.Procstep,
      _Historico._ProcessStep.ProcessStepText,
      _Historico.Stepstatus,
      _Historico._StepStatus.StepStatusText,
      _Historico.StepstatusCriticality
}
