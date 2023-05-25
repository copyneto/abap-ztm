@AbapCatalog.sqlViewName: 'ZCTM_PEDR03'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Cons - Plan entreg e distrib'

@VDM.viewType: #CONSUMPTION
@OData.publish: true
@Metadata.allowExtensions: true

@UI.headerInfo: {
 typeName: 'Planejamento de Entrega e Distribuição',
 typeNamePlural: 'Planejamentos de Entrega e Distribuição'
}

@UI.presentationVariant: {
    qualifier: 'CondExpPorTotal',
    text: 'Filter: Local Expedição  por Qnt Total',
    visualizations: [{
        type: #AS_CHART,
        qualifier: 'Default'
    }]
}

@UI.chart: [{   qualifier: 'Default',
                chartType: #BAR,
                description: 'Local Expedição por Qnt Total',
                measures: ['Total'],
                measureAttributes: [{ measure: 'Total', role: #AXIS_1 }],
                dimensions: ['LocalExpedicao'],
                dimensionAttributes: [{ dimension: 'LocalExpedicao', role: #SERIES }]

    }
]

define view ZC_TM_PLAN_ENTREGA_DIST
  as select from ZI_TM_PLAN_ENTREGA
{
  @UI.hidden: true
  key OrdemId,
  @UI.hidden: true
  key ReferUnidadeFrete,

  @Consumption.semanticObject: 'FreightOrder'
  @UI.selectionField: [{position: 10 }]
  @UI.dataPoint:{title: 'Ordem de Frete'}
  @UI.lineItem: [ { position: 10, importance: #HIGH }]
  @EndUserText.label: 'Nº Ordem de Frete'
  OrdemFreteNum,

  @UI.selectionField: [{position: 20 }]
  @UI.lineItem: [ { position: 20 }]
  @EndUserText.label: 'Data Criação OF'
  DataCriacaoOF,

  @UI.selectionField: [{position: 60 }]
  @UI.lineItem: [ { position: 30 }]
  @EndUserText.label: 'Local de Expedição'
  LocalExpedicao,

  @UI.selectionField: [{position: 30 }]
  @UI.lineItem: [ { position: 40 }]
  @EndUserText.label: 'Cod. Local Transp.'
  CodigoLocalTransporte,

  @UI.lineItem: [ { position: 50 }]
  @EndUserText.label: 'Desc. Local Transp.'
  DescLocalTransporte,

  @UI.selectionField: [{position: 40 }]
  @UI.lineItem: [ { position: 60 }]
  @EndUserText.label: 'Condição Expedição'
  @ObjectModel.text.element: ['DescCondicaoExpedicao']
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_COND_EXP', element: 'CondExped' }} ]
  CondicaoExpedicao,

  @UI.hidden: true
  DescCondicaoExpedicao,

  @UI.selectionField: [{position: 50 }]
  @UI.lineItem: [ { position: 70 }]
  @EndUserText.label: 'Criado por (OF)'
  CriadoPorOF,

  @UI.lineItem: [ { position: 75 }]
  @EndUserText.label: 'Nº Remessa'
  NumeroRemessa,

  @UI.lineItem: [ { position: 80 }]
  @Aggregation.referenceElement: ['NumeroRemessa']
  @Aggregation.default: #COUNT_DISTINCT
  cast(1 as abap.int8) as QtdRemessaOF,

  @UI.lineItem: [ { position: 90 }]
  @Aggregation.referenceElement: ['OrdemFreteNum']
  @Aggregation.default: #COUNT_DISTINCT
  cast(1 as abap.int8) as Total,

  @UI.lineItem: [ { position: 100 }]
  @EndUserText.label: 'Código Cliente'
  CodigoCliente,

  @UI.lineItem: [ { position: 110 }]
  @EndUserText.label: 'Doc. Vendas'
  DocumentoVendas,

  @UI.lineItem: [ { position: 120 }]
  @EndUserText.label: 'UG Destino'
  @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_UG', element: 'LocationId' } } ]
  UGDestino,

  @UI.lineItem: [ { position: 130 }]
  @EndUserText.label: 'UF Destino'
  UFDestino,

  @UI.lineItem: [ { position: 140 }]
  @EndUserText.label: 'Cidade Destino'
  CidadeDestino,

  @UI.lineItem: [ { position: 150 }]
  @EndUserText.label: 'Tipo Doc. Vendas'
  TipoDocVendas,

  @UI.lineItem: [ { position: 160 }]
  @EndUserText.label: 'Data Criação Ped. SAP'
  DataCriacaoPedidoSAP,

  @UI.lineItem: [ { position: 170 }]
  @EndUserText.label: 'Hora Criação Ped. SAP'
  HoraCriacaoPedidoSAP,
  
  @UI.lineItem: [ { position: 180 }]
  @EndUserText.label: 'Data Exportado p/ Roadnet'
  DataExportadoRoadnet,

  @UI.lineItem: [ { position: 190 }]
  @EndUserText.label: 'Área Atendimento'
  @ObjectModel.text.element: ['DescAreaAtendimento']
  CodAreaAtendimento,

  //@UI.lineItem: [ { position: 200 }]
  //@EndUserText.label: 'Desc. Área Atendimento'
  @UI.hidden: true
  DescAreaAtendimento,

  @UI.lineItem: [ { position: 210 }]
  @EndUserText.label: 'Placa Veículo'
  Placa,

  @UI.lineItem: [ { position: 220 }]
  @EndUserText.label: 'Tipo Expedição'
  @ObjectModel.text.element: ['DescTipoExpedicao']
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_TIPO_EXPED', element: 'TipoExped' }} ]
  TipoExpedicao,

  @UI.hidden: true
  DescTipoExpedicao,

  @UI.lineItem: [ { position: 230 }]
  @EndUserText.label: 'Status OF Ciclo Vida'
  @ObjectModel.text.element: ['DescStatusOrdemFreteCicloVida']
  StatusOrdemFreteCicloVida,

  @UI.hidden: true
  DescStatusOrdemFreteCicloVida,

  @UI.lineItem: [ { position: 240 }]
  @EndUserText.label: 'Status OF Planejamento'
  @ObjectModel.text.element: ['DescStatusOrdemFretePlan']
  StatusOrdemFretePlanejamento,

  @UI.hidden: true
  DescStatusOrdemFretePlan,

  @UI.lineItem: [ { position: 240 }]
  @EndUserText.label: 'Status OF Execução'
  @ObjectModel.text.element: ['DescStatusOrdemFreteExecucao']
  StatusOrdemFreteExecucao,

  @UI.hidden: true
  DescStatusOrdemFreteExecucao,

  @UI.lineItem: [ { position: 250 }]
  @EndUserText.label: 'Região Vendas (Grupo Cliente)'
  @ObjectModel.text.element: ['DescRegiaoVendas']
  RegiaoVendas,
  
  @UI.hidden: true
  DescRegiaoVendas,

  @UI.lineItem: [ { position: 260 }]
  @EndUserText.label: 'Hora Criação OF'
  HoraCriacaoOF,

  @UI.lineItem: [ { position: 270 }]
  @EndUserText.label: 'Status NFe / Pré Ordem'
  StatusNFE,

  @UI.lineItem: [ { position: 280 }]
  @EndUserText.label: 'Data Status NFe'
  DataStatusNfe,

  @UI.lineItem: [ { position: 290 }]
  @EndUserText.label: 'Hora Status NFe'
  HoraStatus,

  @UI.lineItem: [ { position: 300 }]
  @EndUserText.label: 'Data Encerramento OF'
  DataEncerramentoOF,

  @UI.lineItem: [ { position: 320 }]
  @EndUserText.label: 'Empresa'  
  @ObjectModel.text.element: ['DescEmpresa']
  Empresa,
  
  @UI.hidden: true
  DescEmpresa,

  @UI.lineItem: [ { position: 330 }]
  @EndUserText.label: 'Doc. Num'
  @UI.hidden: false
  DocNum,

  @UI.lineItem: [ { position: 340 }]
  @EndUserText.label: 'Doc. Faturamento'
  DocumentoFaturamento,

  @UI.lineItem: [ { position: 350 }]
  @EndUserText.label: 'Tipo Faturamento p/ Doc.'
  TipoFaturamento,

  @UI.lineItem: [ { position: 360 }]
  @EndUserText.label: 'Bairro Destino'
  BairroDestino,

  @UI.lineItem: [ { position: 370 }]
  @EndUserText.label: 'Data Criação Remessa'
  DataCriacaoRemessa,
  
  @UI.lineItem: [ { position: 380 }]
  @EndUserText.label: 'Hora Criação Remessa'
  HoraCriacaoRemessa,
  
  @UI.lineItem: [ { position: 390 }]
  @EndUserText.label: 'Nome Transportadora'
  NomeTransportadora,
  
  @UI.lineItem: [ { position: 400 }]
  @EndUserText.label: 'Data Criação Pedido Sirius'
  DataCriacaoPedSirius,

  @UI.lineItem: [ { position: 410 }]
  @EndUserText.label: 'Data Envio Roteirização'
  DataEnvioRoteirizacao,
  
  @UI.lineItem: [ { position: 420 }]
  @EndUserText.label: 'Hora Envio Roteirização'
  HoraEnvioRoteirizacao,

  @UI.lineItem: [ { position: 430 }]
  @EndUserText.label: 'Data Liberação OF'
  DataLiberacaoOF,
  
  @UI.lineItem: [ { position: 440 }]
  @EndUserText.label: 'Data Emissão NF'  
  DataEmissaoNF,
  
  @UI.lineItem: [ { position: 450 }]
  @EndUserText.label: 'Data Saída Veículo'
  DataSaidaVeiculo,
  
  @UI.lineItem: [ { position: 460 }]
  @EndUserText.label: 'Hora Saída Veículo'
  HoraSaidaVeiculo,
  
  @UI.lineItem: [ { position: 470 }]
  @EndUserText.label: 'Data Limite Saída Veículo'
  DataLimiteSaidaVeiculo,
  
  @UI.lineItem: [ { position: 480 }]
  @EndUserText.label: 'Hora Limite Saída Veículo'
  HoraLimiteSaidaVeiculo,
  
  @UI.lineItem: [ { position: 490 }]
  @EndUserText.label: 'Data Limite Entrega Cliente'
  DataLimiteEntregaCliente,
  
  @UI.lineItem: [ { position: 500 }]
  @EndUserText.label: 'Data Prest. Contas'
  DataPrestConta,
  
  @UI.lineItem: [ { position: 510 }]
  @EndUserText.label: 'Data Desejada Cliente'
  DataDesejadaCliente,
  
  @UI.lineItem: [ { position: 520 }]
  @EndUserText.label: 'Data Limite Ciclo Interno'
  DataLimiteCicloInterno,


  @UI.lineItem: [ { position: 530 }]
  @EndUserText.label: 'Código Motorista'
  CodigoMotorista,
  
  @UI.lineItem: [ { position: 540 }]
  @EndUserText.label: 'Nome Motorista'
  NomeMotorista,
  
  @UI.lineItem: [ { position: 550 }]
  @EndUserText.label: 'Data Admissão'
  DataAdmissao,
  
  @UI.lineItem: [ { position: 560 }]
  @EndUserText.label: 'Organização de Vendas'
  OrganizacaoVendas,
  
  @UI.lineItem: [ { position: 570 }]
  @EndUserText.label: 'Data Fatura Devolvida'
  DataFaturaDevolvida,
  
  @UI.lineItem: [ { position: 580 }]
  @EndUserText.label: 'Sit. Lanç NF Devolução'
  SitLancamentoNFDevolucao,
  
  @UI.lineItem: [ { position: 590 }]
  @EndUserText.label: 'NF Devolução'
  NotaFiscalDevolucao,
  
  @UI.lineItem: [ { position: 600 }]
  @EndUserText.label: 'Doc. Fatura Devolução'
  DocFaturaDevolucao,
  
  @UI.lineItem: [ { position: 610 }]
  @EndUserText.label: 'Canal Devolução'
  @ObjectModel.text.element: ['DescCanalDistribuicaoDevolucao']
  CanalDistribuicaoDevolucao,
  
  @UI.hidden: true
  DescCanalDistribuicaoDevolucao,
  
  @UI.lineItem: [ { position: 620 }]
  @ObjectModel.text.element: ['DescricaoRecusa']
  @EndUserText.label: 'Motivo Recusa'
  CodigoMotivoRecusa,
  
  @UI.hidden: true  
  DescricaoRecusa,
  
  @UI.lineItem: [ { position: 630 }]
  @EndUserText.label: 'Área Responsável'
  AreaResponsavel,
  
  @UI.lineItem: [ { position: 640 }]
  @EndUserText.label: 'Impacto'
  Impacto,
  
  @UI.lineItem: [ { position: 650 }]
  @EndUserText.label: 'Embarque'
  Embarque,
  
  @UI.lineItem: [ { position: 660 }]
  @EndUserText.label: 'Qualidade'
  Qualidade,
  
  @UI.lineItem: [ { position: 670 }]
  @EndUserText.label: 'Data Criação Doc. Faturam.'
  DataCriacaoDocumentoFat,
  
  @UI.lineItem: [ { position: 680 }]
  @EndUserText.label: 'Código Vendedor'
  CodigoVendedor,
  
  @UI.lineItem: [ { position: 690 }]
  @EndUserText.label: 'Nome Vendedor'
  NomeVendedor,
  
  @UI.lineItem: [ { position: 700 }]
  @EndUserText.label: 'Nome Cliente'
  NomeCliente,
  
  @UI.lineItem: [ { position: 710 }]
  @EndUserText.label: 'Nº Remessa Devolução'
  NumeroRemessaDev,
  
  @UI.lineItem: [ { position: 730 }]
  @EndUserText.label: 'Nº do MDF-e'
  NumMDFE,
  
  @UI.lineItem: [ { position: 740 }]
  @EndUserText.label: 'NF Manual'
  NotaFiscalManual,
  
  @UI.lineItem: [ { position: 750 }]
  @EndUserText.label: 'Código Transportadora'
  CodigoTransportadora,
  
  @UI.lineItem: [ { position: 760 }]
  @EndUserText.label: 'Grupo Veículo'
  GrupoVeiculo,
  
  @UI.lineItem: [ { position: 770 }]
  @EndUserText.label: 'Tipo Veículo'
  TipoVeiculo,
  
  @UI.lineItem: [ { position: 780 }]
  @EndUserText.label: 'Tipo Entrega'
  @ObjectModel.text.element: ['DescTipoEntregra']
  CodigoTipoEntrega,
  
  @UI.hidden: true
  DescTipoEntregra,
  
  @UI.lineItem: [ { position: 790 }]
  @EndUserText.label: 'Modificado por (OF)'
  ModificadoPor,
  
  @UI.lineItem: [ { position: 800 }]
  @EndUserText.label: 'Nota Fiscal'
  NotaFiscalNum,
  
  @UI.lineItem: [ { position: 810 }]
  @EndUserText.label: 'Tipo Transporte'
  @ObjectModel.text.element: ['DescTipoTransporte']
  CodigoTipoTransporte,
  @UI.hidden: true
  DescTipoTransporte,
  
  @UI.lineItem: [ { position: 820 }]
  @EndUserText.label: 'Valor NF Pendente'
  @Aggregation.default: #SUM
  ValorNFPendente,
  
//  @UI.lineItem: [ { position: 830 }]
//  @EndUserText.label: 'Valor Total NFe'
//  ValorTotalNFe,
  
//  @UI.lineItem: [ { position: 840 }]
//  @EndUserText.label: 'Qtd Entregas OF'
//  @Aggregation.default: #SUM
//  QtdEntregas          as QtdEntregasOF,
//  
  @UI.lineItem: [ { position: 840 }]
  @Aggregation.referenceElement: ['CodigoCliente']
  @Aggregation.default: #COUNT_DISTINCT
  cast(1 as abap.int8) as QtdEntregasOF,
  
  @UI.lineItem: [ { position: 850 }]
  @EndUserText.label: 'Capacidade Máx.'
  @Aggregation.referenceElement: ['OrdemFreteNum']
  //@Aggregation.default: #SUM
  CapacidadeMaxVeiculo,

  @EndUserText.label: 'Otimização da Cap. Máx'
  @UI.lineItem: [ { position: 860 }]  
  concat(cast( OtimizacaoCapMax as abap.sstring( 20 ) ), '%')  as OtimizacaoCapMax,  
  
  @UI.lineItem: [ { position: 870 }]
  @EndUserText.label: 'Dropsize'
  //@Aggregation.default: #SUM
  @Aggregation.referenceElement: ['OrdemFreteNum']
  Dropsize,
    
  @UI.lineItem: [ { position: 880 }]
  @EndUserText.label: 'Distância'
  //@Aggregation.default: #SUM
  Distancia,

  @UI.lineItem: [ { position: 890 }]
  @EndUserText.label: 'Valor Total NFe (Bruto)'
  @Aggregation.default: #SUM
  ValorTotalNFeBruto,
  
  @UI.lineItem: [ { position: 900 }]
  @EndUserText.label: 'Peso Total OF'
  @Aggregation.default: #SUM
  PesoTotalOF,
  
  @UI.lineItem: [ { position: 910 }]
  @EndUserText.label: 'Data Ciclo Ext. (Meta)'
  DataCicloExternoMeta,
  
  @UI.lineItem: [ { position: 920 }]
  @EndUserText.label: 'Data Ciclo Interno (Meta)'
  DataCicloInternoMeta,
  
  @UI.lineItem: [ { position: 930 }]
  @EndUserText.label: 'Data Ciclo Interno (Real)'
  DataCicloInternoReal,

  @UI.lineItem: [ { position: 940 }]
  @EndUserText.label: 'Peso Líquido (Remessa)'
  @Aggregation.referenceElement: ['OrdemFreteNum']
  @Aggregation.default: #SUM
  PesoLiquido,
  
  @UI.lineItem: [ { position: 950 }]
  @EndUserText.label: 'Peso Líquido Unid. (Remessa)'
  PesoLiquidoUnidade

}
