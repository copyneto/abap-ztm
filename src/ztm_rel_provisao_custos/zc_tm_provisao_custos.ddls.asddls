@AbapCatalog.sqlViewName: 'ZCTMRPROV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo relatório de provisão de custos'

@VDM.viewType: #CONSUMPTION
@OData.publish: true

@Metadata.allowExtensions: true

@UI.presentationVariant: {
    qualifier: 'CondExpPorTotal',
    text: 'Filter: Cond. Expedição por Qnt Total',
    visualizations: [{
        type: #AS_CHART,
        qualifier: 'Default'
    }]
}

@UI.chart: [{   qualifier: 'Default',
                chartType: #BAR,
                description: 'Cond. Expedição por Qnt Total',
                measures: ['Total'],
                measureAttributes: [{ measure: 'Total', role: #AXIS_1 }],
                dimensions: ['ShippingCondition'],
                dimensionAttributes: [{ dimension: 'ShippingCondition', role: #SERIES }]
    }
]

@UI.headerInfo: {
 typeName: 'Relatório Provisão e Custos',
 typeNamePlural: 'Relatório Provisão e Custos'
}

define view ZC_TM_PROVISAO_CUSTOS
  as select from ZI_TM_PROVISAO_CUSTOS
{
      @Consumption.semanticObject: 'FreightOrder'
      @UI.lineItem: [ { position: 190, importance: #HIGH }]      
      @UI.selectionField: [{position: 10 }]
      @EndUserText.label: 'Nº Ordem de Frete'
  key TransportationOrder,

      @UI.lineItem: [ { position: 30 }]
      @EndUserText.label: 'Nº Item'
  key TransportationOrderItem,

      @UI.lineItem: [ { position: 250 }]
      @EndUserText.label: 'Doc. Fat. Frete - DFF'
  key DFFDocument,
  
  
      @UI.lineItem: [ { position: 400 }]
      @EndUserText.label: 'Chave acesso NF-e Frete'
  key ChaveAcessoDocFrete,
  

      @UI.lineItem: [ { position: 10 }]
      @EndUserText.label: 'Cód. Produto'
      ProductID,

      @UI.lineItem: [ { position: 20 }]
      @EndUserText.label: 'Nome Produto'
      ProductName,

      @UI.lineItem: [ { position: 40 }]
      @EndUserText.label: 'Família Produto (Nível 1)'
      FamiliaProdutosNivel1,

      @UI.lineItem: [ { position: 50 }]
      @EndUserText.label: 'Doc.Num'
      @UI.hidden: false
      BR_NotaFiscal,

      @UI.lineItem: [ { position: 60 }]
      @EndUserText.label: 'Nota Fiscal'
      BR_NFeNumber,

      @UI.lineItem: [ { position: 70 }]
      @EndUserText.label: 'Chv. Acesso NF-e'
      BR_NFeAccessKey,

      @UI.lineItem: [ { position: 80 }]
      @EndUserText.label: 'Nº Série'
      BR_NFSeries,

      @UI.lineItem: [ { position: 90 }]
      @UI.selectionField: [{position: 60 }]
      @EndUserText.label: 'Dt. Emissão NF-e'
      BR_NFIssueDate,

      @UI.lineItem: [ { position: 100 }]
      @EndUserText.label: 'Cód. Transportadora'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' }} ]
      @ObjectModel.text.element: ['CarrierName']
      CarrierCode,

//      @UI.lineItem: [ { position: 110 }]
//      @EndUserText.label: 'Nome Transportadora'
      @UI.hidden: true
      CarrierName,

      @UI.lineItem: [ { position: 120 }]
      @EndUserText.label: 'Unidade de Medida'
      TranspOrdItemQuantityUnit,

      @UI.lineItem: [ { position: 130 }]
//      @UI.selectionField: [{position: 70 }]
      @EndUserText.label: 'UG Origem'
//      @ObjectModel.foreignKey.association: '_UGFrom'
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_UG', element: 'LocationId' }} ]
      UGFrom,

      @UI.lineItem: [ { position: 140 }]
      @EndUserText.label: 'Cidade Origem'
      CityFrom,

      @UI.lineItem: [ { position: 150 }]
      @EndUserText.label: 'UF Origem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' }} ]
      UFFrom,

      @UI.lineItem: [ { position: 160 }]
      @EndUserText.label: 'UG Destino'
//      @ObjectModel.foreignKey.association: '_UGTo'
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_UG', element: 'LocationId' }} ]
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'YI_TM_VH_LOCATION_ID', element: 'LocationId' }} ]
      UGTo,

      @UI.lineItem: [ { position: 170 }]
      @EndUserText.label: 'Cidade Destino'
      CityTo,

      @UI.lineItem: [ { position: 180 }]
      @EndUserText.label: 'UF Destino'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' }} ]      
      UFTo,

      @UI.lineItem: [ { position: 200 }]
      @UI.selectionField: [{position: 20 }]
      @EndUserText.label: 'Tp. Ordem de Frete'
      TransportationOrderType,

      @UI.lineItem: [ { position: 210 }]
      @EndUserText.label: 'Canal de Atendimento'
      DistributionChannelName,

      @UI.lineItem: [ { position: 220 }]
      @UI.selectionField: [{position: 90 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_TIPO_EXPED', element: 'TipoExped' }} ]
      @ObjectModel.text.element: ['ExpeditionTypeText']
      @EndUserText.label: 'Tipo Expedição'
      ExpeditionType,

      @UI.hidden: true
      ExpeditionTypeText,

      @UI.lineItem: [ { position: 230 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_COND_EXP', element: 'CondExped' }} ]
      @UI.selectionField: [{position: 80 }]
      @ObjectModel.text.element: ['ShippingConditionText']
      @EndUserText.label: 'Cond. Expedição'
      ShippingCondition,


      @UI.lineItem: [ { position: 240 }]
      @EndUserText.label: 'Tipo de Operação'
      @ObjectModel.text.element: ['ScenarioName']
      Scenario,
      
//      @UI.lineItem.hidden: true
//      @Consumption.hidden: true
      @UI.hidden: true
      ScenarioName,

      @UI.lineItem: [ { position: 260 }]
      @EndUserText.label: 'Pedido de Frete'
      FreightPurchaseOrder,

      @UI.lineItem: [ { position: 270 }]
      @EndUserText.label: 'Nº Folha Serviço'
      ServiceDocument,

      @UI.lineItem: [ { position: 280 }]
      @EndUserText.label: 'Centro de Custo'
      ServiceDocumentCostCenter,

      @UI.lineItem: [ { position: 290 }]
      @EndUserText.label: 'Desc. Centro de Custo'
      ServiceDocumentCostCenterName,

      @UI.lineItem: [ { position: 300 }]
      @EndUserText.label: 'Conta Razão'
      ServiceDocumentAccount,

      @UI.lineItem: [ { position: 310 }]
      @EndUserText.label: 'Desc. Conta Razão'
      ServiceDocumentAccountName,

      @UI.lineItem: [ { position: 320 }]
      @EndUserText.label: 'Empresa'
      CompanyCode,

      @UI.lineItem: [ { position: 330 }]
      @EndUserText.label: 'Cód. Filial Tomadora Serviço'
      BranchReceivingService,

      @UI.lineItem: [ { position: 340 }]
      @EndUserText.label: 'Nome da Regional'
      SalesOfficeName,

      @UI.lineItem: [ { position: 350 }]
      @UI.selectionField: [{position: 40 }]
      @EndUserText.label: 'Dt. Criação OF'
      TranspOrderCreationDate,

      @UI.lineItem: [ { position: 360 }]
      @UI.selectionField: [{position: 50 }]
      @EndUserText.label: 'Dt. Emissão Doc. Frete'
      DataEmissaoDocFrete,

      @UI.lineItem: [ { position: 370 }]
      @EndUserText.label: 'Tp. Doc. Frete'
      FreightDocumentType,

      @UI.lineItem: [ { position: 380 }]
      @UI.selectionField: [{position: 30 }]
      @EndUserText.label: 'Status Process. Cockpit'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_GKO_VH_STATUSCODE', element: 'StatusCode' }} ]
      CockpitProcessStatus,

      @UI.lineItem: [ { position: 390 }]
      @EndUserText.label: 'Descr. Status Process. Cockpit'
      CockpitProcessStatusName,

      @UI.lineItem: [ { position: 410 }]
      @EndUserText.label: 'Nº CTE'
      CTENum,

      @UI.lineItem: [ { position: 420 }]
      @EndUserText.label: 'Nº NFS/DANFE'
      NFSDanfeNum,

      @UI.lineItem: [ { position: 430 }]
      @EndUserText.label: 'Tp. Evento'
      EventType,

      @UI.lineItem: [ { position: 440 }]
      @EndUserText.label: 'Nº Fat. GKO'
      NumeroFaturaGKO,

      @UI.lineItem: [ { position: 450 }]
      @EndUserText.label: 'Venc. Fatura'
      InvoiceDueDate,

      @UI.lineItem: [ { position: 460 }]
      @EndUserText.label: 'Nº Lanc. MIRO'
      InvoiceDocument,

      @UI.lineItem: [ { position: 470 }]
      @EndUserText.label: 'Dt. Lanc. MIRO'
      InvoicePostingDate,

      @UI.lineItem: [ { position: 480 }]
      @EndUserText.label: 'Nº Doc. Financeiro'
      FinancialDocument,

      @UI.lineItem: [ { position: 490 }]
      @EndUserText.label: 'Dt. Compensação'
      ClearingDate,

      @UI.lineItem: [ { position: 500 }]
      @EndUserText.label: 'Peso Bruto Item'
      @Aggregation.default:#SUM
      TranspOrdItemGrossWeight,

      @UI.lineItem: [ { position: 510 }]
      @EndUserText.label: 'Peso Bruto Unidade'
      TranspOrdItemGrossWeightUnit,

      @UI.lineItem: [ { position: 520 }]
      @EndUserText.label: 'Peso Líquido Item'
      @Aggregation.default:#SUM
      TranspOrdItemNetWeight,

      @UI.lineItem: [ { position: 530 }]
      @EndUserText.label: 'Peso Líquido Unidade'
      TranspOrdItemNetWeightUnit,

      @UI.lineItem: [ { position: 540 }]
      @EndUserText.label: 'Vlr. Item Nota Fiscal'
      @Aggregation.default:#SUM
      BR_NFValueAmountWithTaxes,

      @UI.lineItem: [ { position: 550 }]
      @EndUserText.label: 'Vlr. PIS'
      @Aggregation.default:#SUM
      PisValue,

      @UI.lineItem: [ { position: 560 }]
      @EndUserText.label: 'Vlr. COFINS'
      @Aggregation.default:#SUM
      CofinsValue,

      @UI.lineItem: [ { position: 570 }]
      @EndUserText.label: 'Vlr. ICMS'
      @Aggregation.default:#SUM
      ICMSValue,

      @UI.lineItem: [ { position: 580 }]
      @EndUserText.label: 'Aliq. ICMS'
      ICMSAliquot,

      @UI.lineItem: [ { position: 590 }]
      @EndUserText.label: 'Vlr. ISS'
      @Aggregation.default:#SUM
      ISSValue,

      @UI.lineItem: [ { position: 600 }]
      @EndUserText.label: 'Aliq. ISS'
      ISSAliquot,

      @UI.lineItem: [ { position: 610 }]
      @EndUserText.label: 'Vlr. Crédito ICMS'
      @Aggregation.default:#SUM
      ICMSCreditValue,

      @UI.lineItem: [ { position: 620 }]
      @EndUserText.label: 'Vlr. Frete Liq.'
      @Aggregation.default:#SUM      
      ( GrossFreightValue - ( ICMSValue + ISSValue + PisValue + CofinsValue ) ) as NetFreightValue,      

      @UI.lineItem: [ { position: 630 }]
      @EndUserText.label: 'Vlr. Frete Bruto'
      @Aggregation.default:#SUM
      GrossFreightValue,

      @UI.lineItem: [ { position: 640 }]
      @EndUserText.label: 'Vlr. Provisão Contab.'
      @Semantics.amount.currencyCode:'CostProvisionCurrencyValue'
      @Aggregation.default:#SUM
      CostProvisionValue,

      @UI.lineItem: [ { position: 650 }]
      @EndUserText.label: 'Qtd. produto item'
      @Aggregation.default:#SUM
      TranspOrdItemQuantity,

      @UI.lineItem: [ { position: 660 }]
      @UI.selectionField: [{position: 90 }]
      @EndUserText.label: 'Criado por'
      CreatedByUser,
      
      @UI.lineItem: [ { position: 670 }]
      @UI.selectionField: [{position: 90 }]
      @EndUserText.label: 'Tipo Veículo'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_VEHICLE_TYPE', element: 'VehicleType' }} ]
      VehicleType,
      
      @Consumption.hidden: true
      CostProvisionCurrencyValue,
         
//      @UI.lineItem: [ { position: 680 }]
//      @UI.lineItem: [ { position: 545 }]
//      @Aggregation.referenceElement: ['TransportationOrder']
//      @Aggregation.default: #COUNT_DISTINCT
//      @EndUserText.label: 'Contador'
//      cast(1 as abap.int8) as Contador,  
      
      @Aggregation.referenceElement: ['TransportationOrder']
      @Aggregation.default: #COUNT_DISTINCT
//      @UI.lineItem: [ { position: 680 }]
      cast(1 as abap.int8) as Total,  
      
      @UI.selectionField: [{position: 100 }]
      @EndUserText.label: 'Status da Execução'
      @ObjectModel.text.element: ['TransportationOrderExecStsDesc']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_STS_OF_EXEC', element: 'Codigo' }} ]
      TransportationOrderExecSts,
      
      @UI.hidden: true
      TransportationOrderExecStsDesc,
      
      @UI.hidden: true
      ShippingConditionText,
      
      //Associations
      _UGFrom,
      _UGTo
         
}
