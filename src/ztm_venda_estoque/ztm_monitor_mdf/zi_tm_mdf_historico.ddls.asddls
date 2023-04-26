@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Histórico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HISTORICO
  as select from zttm_mdf_hist
  association        to parent ZI_TM_MDF        as _MDF         on  _MDF.Guid = $projection.Id

  association [0..1] to ZI_CA_VH_XNFE_PROCTYP   as _Process     on  _Process.Process = $projection.Proctyp
  association [0..1] to ZI_CA_VH_XNFE_PROCSTEP  as _ProcessStep on  _ProcessStep.ProcessStep = $projection.Procstep
  association [0..1] to ZI_CA_VH_XNFE_STEPSTAT  as _StepStatus  on  _StepStatus.StepStatus = $projection.Stepstatus
  association [0..1] to ZI_CA_VH_USER           as _Username    on  _Username.Bname = $projection.Username
  association [1..1] to ZI_TM_MDF_HISTORICO_MSG as _Message     on  _Message.Id        = $projection.Id
                                                                and _Message.Histcount = $projection.Histcount
                                                                and _Message.Event     = $projection.Event

{
  key id                                    as Id,
  key histcount                             as Histcount,
  key event                                 as Event,
      proctyp                               as Proctyp, 
      procstep                              as Procstep,
      stepstatus                            as Stepstatus,

      case stepstatus
      when '  '  -- Inicial
      then 0
      when '01'  -- OK
      then 3
      when '02'  -- Erro
      then 1
      when '03'  -- Erro técnico
      then 1
      when '04'  -- Erro temporário
      then 1
      when '11'  -- Etapa espera por resposta assíncrona
      then 2
      when '12'  -- Verificação status: etapa esperando por resposta assíncrona
      then 2
      when '13'  -- Etapa esperando acionamento
      then 2
      when '14'  -- Etapa espera por evento
      then 2
      else 0 end                            as StepstatusCriticality,

      createtime                            as Createtime,
      username                              as Username,
      _Message.Msgid                        as Msgid,
      _Message.Msgno                        as Msgno,
      _Message.Msgv1                        as Msgv1,
      _Message.Msgv2                        as Msgv2,
      _Message.Msgv3                        as Msgv3,
      _Message.Msgv4                        as Msgv4,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_HISTORICO_VE'
      cast ( _Message.Message as bapi_msg ) as Message,

      @Semantics.user.createdBy: true
      created_by                            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                 as LocalLastChangedAt,

      /* associations */
      _MDF,
      _Process,
      _ProcessStep,
      _StepStatus,
      _Username
}
