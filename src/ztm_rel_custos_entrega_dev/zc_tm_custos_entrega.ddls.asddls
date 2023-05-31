@AbapCatalog.sqlViewName: 'ZCTMRCUST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo relatório de custos de entrega'

@VDM.viewType: #CONSUMPTION
@OData.publish: true

@Metadata.allowExtensions: true

@UI.presentationVariant: {
    qualifier: 'CondExpPorTotal',
    text: 'Filter: Cond. Expedição  por Qnt Total',
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
                dimensions: ['CondicaoExpedicao'],
                dimensionAttributes: [{ dimension: 'CondicaoExpedicao', role: #SERIES }]

    }

//    {   qualifier: 'FilterTipoExpedicao',
//                chartType: #DONUT,
//                description: 'Tipo Expedição por Qnt Total',
//                measures: ['Total'],
//                measureAttributes: [{ measure: 'Total', role: #AXIS_1 }],
//                dimensions: ['TipoExpedicao'],
//                dimensionAttributes: [{ dimension: 'TipoExpedicao', role: #SERIES }]
//
//    }

]

define view ZC_TM_CUSTOS_ENTREGA
  as select from ZI_TM_CUSTOS_ENTREGA
{
       @Consumption.hidden: true
  key  OrdemId,
       @Consumption.semanticObject: 'FreightOrder'
       @UI.selectionField: [{position: 10 }]
       @UI.dataPoint:{title: 'Ordem de Frete'}
       @UI.lineItem: [ { position: 10, importance: #HIGH }]
       @EndUserText.label: 'Nº Ordem de Frete'
  key  OrdemFreteNum,

       @UI.selectionField: [{position: 22 }]
       @UI.lineItem: [ { position: 22, importance: #HIGH }]
       @EndUserText.label: 'Doc. Num.'
       @UI.hidden: false
       DocNum,

       @UI.lineItem: [ { position: 90 }]
       @UI.selectionField: [{position: 20 }]
       @EndUserText.label: 'Data Criação OF'
       DataCriacaoOF,

       @UI.selectionField: [{position: 70 }]
       @EndUserText.label: 'Criado por (OF)'
       CriadoPorOF,


       @UI.lineItem: [ { position: 20 }]
       @EndUserText.label: 'Placa Veículo'
       Placa,

       @UI.lineItem: [ { position: 30 }]
       @EndUserText.label: 'Grupo Veículo'
       GrupoVeiculo,

       @UI.lineItem: [ { position: 35 }]
       @EndUserText.label: 'Tipo de Veículo'
       TipoVeiculo,


       @UI.lineItem: [ { position: 50 }]
       @EndUserText.label: 'Nota Fiscal'
       NotaFiscalNum,

       @UI.lineItem: [ { position: 60 }]
       @UI.selectionField: [{position: 40 }]
       @EndUserText.label: 'Data Emissão da Nfe'
       DataEmissaoNFe,

       @UI.lineItem: [ { position: 70 }]
       @EndUserText.label: 'Chave de Acesso NFe'
       ChaveAcessoNfe,

       @UI.lineItem: [ { position: 80 }]
       @EndUserText.label: 'Código Motorista'
       Motorista,

       @UI.lineItem: [ { position: 100 }]
       @UI.selectionField: [{position: 30 }]
       @EndUserText.label: 'Data Emissão Doc. Frete (Fornecedor)'
       DataEmissaoDocFrete,

       @UI.lineItem: [ { position: 110 }]
       @EndUserText.label: 'Chave de Acesso Doc. Frete'
       ChaveAcessoDocFrete,

       @UI.lineItem: [ { position: 120 }]
       @EndUserText.label: 'Nº CTe/Nº NFS/DANFE'
       CTENum,

       @UI.lineItem: [ { position: 130 }]
       @EndUserText.label: 'Nº NFS/DANFE'
       NFSDanfeNum,

       @EndUserText.label: 'UG Origem'
       //@Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Region' } } ]
       @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_UG', element: 'LocationId' } } ]
       UGOrigem,

       @EndUserText.label: 'UF Origem'
       UFOrigem,

       @EndUserText.label: 'Cidade Origem'
       CidadeOrigem,

       @UI.lineItem: [ { position: 140 }]
       @EndUserText.label: 'Data Saída Planejada (Etapa)'
       DataSaidaPlanejada,

       @UI.lineItem: [ { position: 150 }]
       @EndUserText.label: 'Data Saída Real (Etapa)'
       DataSaidaReal,

       @EndUserText.label: 'UG Destino'
       //      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Region' } } ]
       @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_UG', element: 'LocationId' } } ]
       UGDestino,

       @EndUserText.label: 'UF Destino'
       UFDestino,

       @EndUserText.label: 'Cidade Destino'
       CidadeDestino,

       @UI.lineItem: [ { position: 160 }]
       @EndUserText.label: 'Data Chegada Real'
       DataChegadaReal,

       @UI.lineItem: [ { position: 170 }]
       @EndUserText.label: 'Data Chegada Planejada'
       DataChegadaPlanejada,

       @UI.lineItem: [ { position: 180 }]
       @EndUserText.label: 'Bloqueio Planejamento'
       BloqueioPlanejamento,

       @UI.lineItem: [ { position: 190 }]
       @EndUserText.label: 'Bloqueio Execução'
       BloqueioExecucao,

       @UI.lineItem: [ { position: 200 }]
       @EndUserText.label: 'Utilização Máxima (OF)'
       UtilizacaoMaximaOF,

       @UI.lineItem: [ { position: 210 }]
       //@EndUserText.label: 'Código Local de Transporte'
       @EndUserText.label: 'Cód. Unidade Gerencial'
       @UI.selectionField: [{position: 50 }]
       CodigoLocalTransporte,

       //@EndUserText.label: 'Desc. Local de Transporte'
       @EndUserText.label: 'Desc. Unidade Gerencial'
       @UI.selectionField: [{position: 211 }]
       DescLocalTransporte,

       @UI.lineItem: [ { position: 220 }]
       @EndUserText.label: 'Código da Transportadora'
       @ObjectModel.text.element: ['NomeTransportadora']
       //@UI.textArrangement: #TEXT_SEPARATE
       CodigoTransportadora,

       @UI.hidden: true
       NomeTransportadora,

       @UI.lineItem: [ { position: 230 }]
       @EndUserText.label: 'Nome do Produto'
       NomeProduto,

       @UI.lineItem: [ { position: 240 }]
       @EndUserText.label: 'Família Produtos (Nivel 1)'
       FamiliaProdutosNivel1,

       @UI.lineItem: [ { position: 250 }]
       @EndUserText.label: 'Família Produtos (Nivel 2)'
       FamiliaProdutosNivel2,

       @UI.lineItem: [ { position: 260 }]
       @EndUserText.label: 'Família Produtos (Nivel 3)'
       FamiliaProdutosNivel3,

       @UI.lineItem: [ { position: 261 }]
       @UI.selectionField: [{position: 70 }]
       @EndUserText.label: 'Tipo Expedição'
       @ObjectModel.text.element: ['DescTipoExpedicao']
       @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_TIPO_EXPED', element: 'TipoExped' }} ]
       TipoExpedicao,

       @UI.hidden: true
       DescTipoExpedicao,

       @UI.lineItem: [ { position: 500 }]
       CodigoHierarquiaProduto,
       //@UI.lineItem: [ { position: 510 }]
       //ProductHierarchy,

       @UI.selectionField: [{position: 60 }]
       @EndUserText.label: 'Condição Expedição'
       @ObjectModel.text.element: ['DescCondicaoExpedicao']
       @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_COND_EXP', element: 'CondExped' }} ]
       CondicaoExpedicao,

       @EndUserText.label: 'Cond. Expedição'
       @UI.hidden: true
       DescCondicaoExpedicao,

       @UI.lineItem: [ { position: 520 }]
       @Aggregation.default: #SUM
       TotalItensNF,

       @Aggregation.default: #SUM
       @EndUserText.label: 'Peso Bruto'
       PesoBruto,

       @UI.lineItem: [ { position: 267 }]
       @EndUserText.label: 'Peso Bruto Unidade'
       PesoBrutoUnidade,

       @UI.lineItem: [ { position: 268 }]
       @EndUserText.label: 'Peso Líquido'
       @Aggregation.default: #SUM
       PesoLiquido,

       @UI.lineItem: [ { position: 269 }]
       @EndUserText.label: 'Peso Líquido Unidade'
       PesoLiquidoUnidade,

       @UI.lineItem: [ { position: 270 }]
       @EndUserText.label: 'Código Cliente'
       CodigoCliente,

       @UI.lineItem: [ { position: 280 }]
       @EndUserText.label: 'Nome do Cliente'
       NomeCliente,

       @UI.lineItem: [ { position: 285 }]
       @EndUserText.label: 'Nº Remessa'
       NumeroRemessa,

       @UI.lineItem: [ { position: 290 }]
       @EndUserText.label: 'Tipo Remessa'
       TipoRemessa,

       @UI.lineItem: [ { position: 300 }]
       @EndUserText.label: 'Desc. Tipo Remessa'
       DescTipoRemessa,

       @UI.lineItem: [ { position: 310 }]
       @EndUserText.label: 'Modificado por'
       ModificadoPor,

       @UI.lineItem: [ { position: 320 }]
       @EndUserText.label: 'Cód. Grupo Mercadorias'
       CodigoGrupoMercadorias,

       @UI.lineItem: [ { position: 330 }]
       @EndUserText.label: 'Denom. Grupo Mercadorias'
       DescGrupoMercadoria,

       @UI.lineItem: [ { position: 340 }]
       @EndUserText.label: 'Código Produto'
       CodigoProduto,

       //      @UI.lineItem: [ { position: 350 }]
       //      @EndUserText.label: 'Tipo de Transporte'
       //      TipoTransporte,

       @UI.lineItem: [ { position: 360 }]
       @EndUserText.label: 'Modo de Transporte'
       @ObjectModel.text.element: ['DescTipoTransporte']
       TipoTransporte,

       @UI.hidden: true
       DescTipoTransporte,

       @UI.lineItem: [ { position: 370 }]
       @EndUserText.label: 'Nº Fatura GKO'
       NumeroFaturaGKO,

       @UI.lineItem: [ { position: 380 }]
       @EndUserText.label: 'Status do Ciclo de Vida'
       @ObjectModel.text.element: ['DescStatusOrdemFreteCicloVida']
       StatusOrdemFreteCicloVida,
       @UI.hidden: true
       DescStatusOrdemFreteCicloVida,

       @UI.lineItem: [ { position: 390 }]
       @EndUserText.label: 'Status do Planejamento'
       @ObjectModel.text.element: ['DescStatusOrdemFretePlan']
       StatusOrdemFretePlanejamento,
       @UI.hidden: true
       DescStatusOrdemFretePlan,

       @UI.selectionField: [{position: 100 }]
       @UI.lineItem: [ { position: 400 }]
       @EndUserText.label: 'Status da Execução'
       @ObjectModel.text.element: ['DescStatusOrdemFreteExecucao']
       @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_STS_OF_EXEC', element: 'Codigo' }} ]
       StatusOrdemFreteExecucao,
       @UI.hidden: true
       DescStatusOrdemFreteExecucao,

       @UI.lineItem: [ { position: 410 }]
       @EndUserText.label: 'Nº da Carga SAGA'
       NumeroCargaSAGA,

       @UI.lineItem: [ { position: 420 }]
       @EndUserText.label: 'Tipo Ordem de Frete'
       @ObjectModel.text.element: ['DescTipoOrdemFrete']
       TipoOrdemFrete,
       @UI.hidden: true
       DescTipoOrdemFrete,

       @UI.lineItem: [ { position: 430 }]
       @EndUserText.label: 'Unidade de Frete'
       UnidadeFrete,

       @UI.lineItem: [ { position: 440 }]
       @EndUserText.label: 'Valor Frete Bruto'
       @Aggregation.default: #SUM
       ValorFreteBruto,

       @UI.lineItem: [ { position: 450 }]
       @EndUserText.label: 'Valor Frete Líquido (R$)'  //Valor Frete Liquido
       @Aggregation.default: #SUM
       CustoEntregaLiquidoRS,

       @UI.lineItem: [ { position: 460 }]
       @EndUserText.label: 'Valor PIS'
       @Aggregation.default: #SUM
       Pis,

       @UI.lineItem: [ { position: 470 }]
       @EndUserText.label: 'Valor COFINS'
       @Aggregation.default: #SUM
       Cofins,

       @UI.lineItem: [ { position: 480 }]
       @EndUserText.label: 'Volume Cubado (E-commerce)'
       @Aggregation.default: #SUM
       VolumeCubadoEcom,

       @UI.lineItem: [ { position: 480 }]
       @EndUserText.label: 'Peso Bruto (E-commerce)'
       @Aggregation.default: #SUM
       PesoBrutoEcom,

       @UI.lineItem: [ { position: 525 }]
       @EndUserText.label: 'Valor Nota Fiscal (R$) Item'
       ValorNFITEM,

       @UI.lineItem: [ { position: 530 }]
       @Aggregation.referenceElement: ['OrdemFreteNum']
       @Aggregation.default: #COUNT_DISTINCT
       cast(1 as abap.int8) as Total,
       
       //Associations
      _UGOrigem,
      _UGDestino
      
       //      cast(1 as abap.int8) as Contador

       //_CondExpedVH
}
