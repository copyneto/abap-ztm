@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Histórico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HISTORICO_LAST
  as select from zttm_mdf_hist                  as _Historico

    inner join   ZI_TM_MDF_HISTORICO_LAST_EVENT as _Evento on  _Evento.Id    = _Historico.id
                                                           and _Evento.Event = _Historico.event
{
  key _Historico.id             as Id,
      _Historico.event          as Event,
      max(_Historico.histcount) as Histcount
}
group by
  _Historico.id,
  _Historico.event
