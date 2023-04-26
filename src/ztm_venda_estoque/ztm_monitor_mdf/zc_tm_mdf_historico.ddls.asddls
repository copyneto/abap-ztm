@EndUserText.label: 'Informações MDF-e : Histórico'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_HISTORICO
  as projection on ZI_TM_MDF_HISTORICO
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Contador de Histórico'
  key Histcount,
      @EndUserText.label: 'Evento'
  key Event,
      @EndUserText.label: 'Processo'
      @ObjectModel.text.element: ['ProctypText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_PROCTYP', element: 'Process' } }]
      Proctyp,
      _Process.ProcessText         as ProctypText,
      @EndUserText.label: 'Etapa do Processo'
      @ObjectModel.text.element: ['ProcStepText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_PROCSTEP', element: 'ProcessStep' } }]
      Procstep,
      _ProcessStep.ProcessStepText as ProcStepText,
      @EndUserText.label: 'Status da Etapa do Processo'
      @ObjectModel.text.element: ['StepStatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_STEPSTAT', element: 'StepStatus' } }]
      Stepstatus,
      _StepStatus.StepStatusText   as StepStatusText,
      StepstatusCriticality,
      @EndUserText.label: 'Registrado em'
      Createtime,
      @EndUserText.label: 'Responsável'
      @ObjectModel.text.element: ['UsernameText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      Username,
      _Username.Text               as UsernameText,

      @EndUserText.label: 'Mensagem'
      Message,
      Msgid,
      Msgno,
      Msgv1,
      Msgv2,
      Msgv3,
      Msgv4,

      @EndUserText.label: 'Criado por'
      CreatedBy,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Alterado por'
      LastChangedBy,
      @EndUserText.label: 'Alterado em'
      LastChangedAt,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF
}
