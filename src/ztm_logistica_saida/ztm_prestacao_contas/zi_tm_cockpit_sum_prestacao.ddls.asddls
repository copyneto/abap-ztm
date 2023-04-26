@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit para Prestação de Contas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X, 
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@VDM: { viewType: #COMPOSITE }
@Analytics.dataCategory: #CUBE
 
define root view entity ZI_TM_COCKPIT_SUM_PRESTACAO
  as select from ZI_TM_PRESTACAO_CONTAS

  composition [0..*] of ZI_TM_COCKPIT_SUM_ITEM_EXEC as _Execucao

{
      @EndUserText.label: 'Ordem de Frete' 
  key cast( FreightOrderUUID as /bobf/conf_key preserving type ) as FreightOrderUUID,
      @EndUserText.label: 'Unidade de Frete'
  key cast( FreightUnitUUID as /bobf/conf_key preserving type )  as FreightUnitUUID,
      @EndUserText.label: 'Unidade de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_UNIDADE_FRETE', element: 'TransportationOrder' } }]
      FreightUnit, 
      @EndUserText.label: 'Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } }]
      FreightOrder,
      @EndUserText.label: 'Ordem de Venda'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentItemStdVH', element: 'SalesDocument' } }]
      SalesDocument,
      @EndUserText.label: 'Tipo de Ordem de Venda'
      SalesDocumentType,
      @EndUserText.label: 'Entrega'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DeliveryDocumentStdVH', element: 'DeliveryDocument' } }]
      DeliveryDocument, 
      @EndUserText.label: 'Nota Fiscal'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' } }]
      BR_NotaFiscal,
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
      @EndUserText.label: 'Recebedor'
      @ObjectModel.text.element: ['ConsigneeName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_ORG', element: 'Parceiro' } }]
      ConsigneeId,
      @EndUserText.label: 'Recebedor'
      ConsigneeName,
      TranspOrdExecution,
      TranspOrdEventCode,
      TranspOrdEventCodeDesc,
      TranspOrdEventStatus,
      TransportationActivity,
      TransportationActivityDesc,
      TranspOrdExecInfoSource,
      TranspOrdExecInfoSourceDesc,
      TranspOrdEvtActualDateTime,
      TranspOrdEvtActualDate,
      TranspOrdEvtActualTime,
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['TranspOrdLifeCycleStatusDesc']
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_TM_VH_LIFECYCLE_STATUS', element: 'TranspOrdLifeCycleStatus' } }]
      TranspOrdLifeCycleStatus,
      @EndUserText.label: 'Status'
      TranspOrdLifeCycleStatusDesc,
      @EndUserText.label: 'Status'
      case TranspOrdLifeCycleStatus
      when '00' then 0 -- Esboço
      when '01' then 0 -- Novo
      when '02' then 2 -- Em processamento
      when '05' then 3 -- Concluído
      when '10' then 1 -- Cancelado
                else 0 end                                       as TranspOrdLifeCycleStatusCrit,
                
      @EndUserText.label: 'Entregue'
      cast( case TranspOrdEventCode
      when 'ENTREGUE'
      then 'X'
      else ' ' end as flag )                                     as StatusEntregue,
      @EndUserText.label: 'Entregue'
      case TranspOrdEventCode
      when 'ENTREGUE'
      then 3
      else 1 end                                                 as StatusEntregueCriticality,
      @EndUserText.label: 'Devolvido'
      cast( case TranspOrdEventCode
      when 'DEVOLVIDO'
      then 'X'
      else ' ' end as flag )                                     as StatusDevolvido,
      @EndUserText.label: 'Devolvido'
      case TranspOrdEventCode
      when 'DEVOLVIDO'
      then 3
      else 1 end                                                 as StatusDevolvidoCriticality,
      @EndUserText.label: 'Pendente'
      cast( case TranspOrdEventCode
      when 'PENDENTE'
      then 'X'
      else ' ' end as flag )                                     as StatusPendente,
      @EndUserText.label: 'Pendente'
      case TranspOrdEventCode
      when 'PENDENTE'
      then 3
      else 1 end                                                 as StatusPendenteCriticality,
      @EndUserText.label: 'Sinistro'
      cast( case TranspOrdEventCode
      when 'SINISTRO'
      then 'X'
      else ' ' end as flag )                                     as StatusSinistro,
      @EndUserText.label: 'Sinistro'
      case TranspOrdEventCode
      when 'SINISTRO'
      then 3
      else 1 end                                                 as StatusSinistroCriticality,
      @EndUserText.label: 'Coletado'
      cast( case TranspOrdEventCode
      when 'COLETADO'
      then 'X'
      else ' ' end as flag )                                     as StatusColetado,
      @EndUserText.label: 'Coletado'
      case TranspOrdEventCode
      when 'COLETADO'
      then 3
      else 1 end                                                 as StatusColetadoCriticality,
      @EndUserText.label: 'Não Coletado'
      cast( case TranspOrdEventCode
      when 'NÃO COLETADO'
      then 'X'
      else ' ' end as flag )                                     as StatusNaoColetado,
      @EndUserText.label: 'Não Coletado'
      case TranspOrdEventCode
      when 'NÃO COLETADO'
      then 3
      else 1 end                                                 as StatusNaoColetadoCriticality,
      DestinationLocation,
      DestinationLocationLabel,
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
      @Aggregation.default: #SUM
      AmountValue,
      @EndUserText.label: 'Moeda'
      AmountCurrency,

      /* composition */
      _Execucao

}
