@EndUserText.label: 'Gestão de Fretes - Monitor GKO - Log'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MONITOR_GKO_LOG
  as projection on ZI_TM_MONITOR_GKO_LOG
{
      @EndUserText.label: 'Chave de acesso'
  key acckey, 
      @EndUserText.label: 'Contador'
  key counter,
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['desc_codstatus']
      codstatus,
      desc_codstatus,
      crit_codstatus,   
      @EndUserText.label: 'Tipo de processamento'
      @ObjectModel.text.element: ['desc_tpprocess']
      tpprocess,
      desc_tpprocess,
      crit_tpprocess,
      @EndUserText.label: 'Mensagem / Doc. gerado'
      newdoc,
      @EndUserText.label: 'Código'
      codigo,
      desc_codigo,
      @EndUserText.label: 'Data criação'
      credat,
      @EndUserText.label: 'Hora criação'
      cretim,
      @EndUserText.label: 'Usuário criação'
      @ObjectModel.text.element: ['desc_crenam']
      crenam, 
      desc_crenam,
      
      /* Associations */
      _monitor : redirected to parent ZC_TM_MONITOR_GKO
}
