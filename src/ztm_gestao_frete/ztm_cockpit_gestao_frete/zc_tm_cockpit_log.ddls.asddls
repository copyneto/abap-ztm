@EndUserText.label: 'Projection Cockpit Log'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity zc_tm_cockpit_log
  as projection on ZI_TM_COCKPIT006
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ACCKEY', element: 'acckey' } }]
      @EndUserText.label: 'Chave de acesso'
  key Acckey,
      @EndUserText.label: 'Contador'
  key Counter,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CODSTATUS', element: 'codstatus' } }]
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: [ 'CodstatusText']
      Codstatus,
      CodstatusText,
      CodstatusCrit,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPPROCESS', element: 'tpprocess' } }]
      @EndUserText.label: 'Processamento '
      @ObjectModel.text.element: [ 'TpprocessText']
      Tpprocess,
      TpprocessText,
      TpprocessCrit,
      @EndUserText.label: 'Documento'
      Newdoc,
      @EndUserText.label: 'Código'
      Codigo,
      @EndUserText.label: 'Descrição'
      DescCodigo,
      @EndUserText.label: 'Criado em'
      Credat,
      @EndUserText.label: 'Criado às'
      Cretim,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: [ 'CrenamText']
      Crenam,
      CrenamText,
      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT
}
