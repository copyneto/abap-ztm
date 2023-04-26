@EndUserText.label: 'Interface Trafegus - Mensagens de log'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['FreightOrder', 'ContadorItf', 'ContadorMsg' ]

define root view entity ZC_TM_TRAFEGUS_LOG
  as projection on ZI_TM_TRAFEGUS_LOG
{
      @EndUserText.label: 'Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_TRAFEGUS_ORDEM_FRETE', element: 'TransportationOrder' }}]
  key FreightOrder,
      @EndUserText.label: 'ID Chamada'
  key ContadorItf,
      @EndUserText.label: 'ID Mensagem'
  key ContadorMsg,
      @EndUserText.label: 'Código de Status'
      CodStatus,
      @EndUserText.label: 'Código da Viagem'
      CodViagem,
      @EndUserText.label: 'Tipo da Mensagem'
      @ObjectModel.text.element: ['TipoMensagemTxt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MSGTY', element: 'msgty' }}]
      TipoMensagem,
      TipoMensagemTxt,
      TipoMensagemCrit,
      @EndUserText.label: 'Mensagem'
      Mensagem,
      @EndUserText.label: 'Valor'
      Valor,
      @EndUserText.label: 'Campo'
      Campo,
      @EndUserText.label: 'Link'
      LinkMapaVeiculoViagem,
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: ['CreatedByName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' }}]
      CreatedBy,
      CreatedByName,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Modificado por'
      @ObjectModel.text.element: ['LastChangedByName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' }}]
      LastChangedBy,
      LastChangedByName,
      @EndUserText.label: 'Modificado em'
      LastChangedAt,
      @EndUserText.label: 'Registro'
      LocalLastChangedAt,
      @EndUserText.label: 'ID Ordem de Frete'
      TransportationOrderUUID
}
