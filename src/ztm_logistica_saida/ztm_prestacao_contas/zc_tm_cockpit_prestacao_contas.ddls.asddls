@EndUserText.label: 'Cockpit para Prestação de Contas'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_TM_COCKPIT_PRESTACAO_CONTAS
  as projection on ZI_TM_COCKPIT_PRESTACAO_CONTAS
  association [0..1] to ZI_TM_VH_TRANSEVENT_POPUP_STAT as _EventoPopup on _EventoPopup.TranspOrdEventCode = $projection.TranspOrdEventCodeNew
  //association [0..1] to ZI_TM_VH_TRANSPORDEVENT_STATUS as _EventoPopup on _EventoPopup.TranspOrdEventCode = $projection.TranspOrdEventCodeNew
{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrderUUID,
      @EndUserText.label: 'Unidade de Frete'
  key FreightUnitUUID,
      @EndUserText.label: 'Unidade de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_UNIDADE_FRETE', element: 'TransportationOrder' } }]
      FreightUnit,
      @EndUserText.label: 'Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } }]
      FreightOrder,
      @EndUserText.label: 'Ordem de Venda'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentItemStdVH', element: 'SalesDocument' } }]
      SalesDocument,
      @EndUserText.label: 'Entrega'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DeliveryDocumentStdVH', element: 'DeliveryDocument' } }]
      DeliveryDocument,
      @EndUserText.label: 'Nota Fiscal'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NFeNumber' } }]
      BR_NotaFiscal,
      @EndUserText.label: 'Empresa'
      CompanyCode,      
      @EndUserText.label: 'Motorista'
      DriverUUID,
      @EndUserText.label: 'Motorista'
      @ObjectModel.text.element: ['DriverName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_PF', element: 'Parceiro' } }]
      DriverId,
      @EndUserText.label: 'Motorista'
      DriverName,
      @EndUserText.label: 'Placa do Veículo'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_TM_VH_EQUNR', element: 'Placa' } }]
      PlateNumber,
      @EndUserText.label: 'Tipo de Ordem de Venda'
      SalesDocumentType,
      @EndUserText.label: 'Recebedor'
      @ObjectModel.text.element: ['ConsigneeName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_ORG', element: 'Parceiro' } }]
      ConsigneeId,
      @EndUserText.label: 'Recebedor'
      ConsigneeName,
      @EndUserText.label: 'Status Ordem de Frete'
      @ObjectModel.text.element: ['TranspOrdLifeCycleStatusDesc']
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_TM_VH_LIFECYCLE_STATUS', element: 'TranspOrdLifeCycleStatus' } }]
      TranspOrdLifeCycleStatus,
      @EndUserText.label: 'Status Ordem de Frete'
      TranspOrdLifeCycleStatusDesc,
      @EndUserText.label: 'Status Ordem de Frete'
      TranspOrdLifeCycleStatusCrit,
      @EndUserText.label: 'Status Unidade de Frete'
      @ObjectModel.text.element: ['TranspOrdEventCodeDesc']
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_TM_VH_TRANSEVENT_POPUP_STAT', element: 'TranspOrdEventCode' } }]
      TranspOrdEventCode,
      @EndUserText.label: 'Status Unidade de Frete'
      TranspOrdEventCodeDesc,
      @EndUserText.label: 'Status Unidade de Frete'
      TranspOrdEventCodeCrit,
      @EndUserText.label: 'Entregue'
      @ObjectModel.text.element: ['StatusEntregueText']
      StatusEntregue,
      @EndUserText.label: 'Entregue'
      StatusEntregueText,
      @EndUserText.label: 'Entregue'
      StatusEntregueCriticality,
      @EndUserText.label: 'Devolvido'
      @ObjectModel.text.element: ['StatusDevolvidoText']
      StatusDevolvido,
      @EndUserText.label: 'Devolvido'
      StatusDevolvidoText,
      @EndUserText.label: 'Devolvido'
      StatusDevolvidoCriticality,
      @EndUserText.label: 'Pendente'
      @ObjectModel.text.element: ['StatusPendenteText']
      StatusPendente,
      @EndUserText.label: 'Pendente'
      StatusPendenteText,
      @EndUserText.label: 'Pendente'
      StatusPendenteCriticality,
      @EndUserText.label: 'Sinistro'
      @ObjectModel.text.element: ['StatusSinistroText']
      StatusSinistro,
      @EndUserText.label: 'Sinistro'
      StatusSinistroText,
      @EndUserText.label: 'Sinistro'
      StatusSinistroCriticality,
      @EndUserText.label: 'Coletado'
      @ObjectModel.text.element: ['StatusColetadoText']
      StatusColetado,
      @EndUserText.label: 'Coletado'
      StatusColetadoText,
      @EndUserText.label: 'Coletado'
      StatusColetadoCriticality,
      @EndUserText.label: 'Não Coletado'
      @ObjectModel.text.element: ['StatusNaoColetadoText']
      StatusNaoColetado,
      @EndUserText.label: 'Não Coletado'
      StatusNaoColetadoText,
      @EndUserText.label: 'Não Coletado'
      StatusNaoColetadoCriticality,
      @EndUserText.label: 'Destino'
      BusinessPartnerUUID,
      @EndUserText.label: 'Destino'
      BusinessPartner,
      @EndUserText.label: 'Destino'
      LocationDescription,
      @EndUserText.label: 'Tipo de Destino'
      LocationType,
      @EndUserText.label: 'País'
      Country,
      @EndUserText.label: 'Cidade'
      CityName,
      @EndUserText.label: 'CEP'
      PostalCode,
      @EndUserText.label: 'Rua'
      StreetName,
      @EndUserText.label: 'Número'
      HouseNumber,
      @EndUserText.label: 'Forma de Pagamento'
      @ObjectModel.text.element: ['PaymentMethodDescription']
      PaymentMethod,
      @EndUserText.label: 'Forma de Pagamento'
      PaymentMethodDescription,
      @EndUserText.label: 'Volumes'
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      BaseValue,
      @EndUserText.label: 'Unidade de Medida'
      BaseUnit,
      @EndUserText.label: 'Valor total'
      @Semantics.amount.currencyCode : 'AmountCurrency'
      AmountValue,
      @EndUserText.label: 'Moeda'
      AmountCurrency,

      @EndUserText.label: 'Novo status' -- Usado no POP-UP da Abstract View
      TranspOrdEventCodeNew,

      /* Associations */
      _Execucao : redirected to composition child ZC_TM_COCKPIT_ITEM_EXECUCAO,

      _EventoPopup
}
