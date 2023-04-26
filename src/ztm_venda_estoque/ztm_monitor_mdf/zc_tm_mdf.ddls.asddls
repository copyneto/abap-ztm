@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e'
@Metadata.allowExtensions: true
define root view entity ZC_TM_MDF
  as projection on ZI_TM_MDF as MDF
  //  association [0..1] to ZI_TM_VH_MOTORISTA as _MotoristaPopup on _MotoristaPopup.Parceiro = $projection.Motorista
{
  key Guid,
      @EndUserText.label: 'Agrupador'
      Agrupador,
      @EndUserText.label: 'Manual'
      Manual,
      @EndUserText.label: 'Nº MDF-e'
      BR_MDFeNumber,
      @EndUserText.label: 'Série'
      BR_MDFeSeries,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MDFE_STATCODE', element: 'StatusCode' }}]
      @ObjectModel.text.element: ['StatusText']
      @EndUserText.label: 'Status'
      StatusCode,
      StatusText,
      StatusCriticality,
      @EndUserText.label: 'Protocolo'
      Protocol,
      @EndUserText.label: 'Chave de Acesso'
      AccessKey,
      @EndUserText.label: 'Processo'
      BR_MDFeNumberStatus,
      BR_MDFeNumberStatusCriticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_TPEMIS', element: 'TipoEmissao' }}]
      @ObjectModel.text.element: ['TipoEmissaoText']
      TipoEmissao,
      TipoEmissaoText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_COMPANY', element: 'CompanyCode' }}]
      @ObjectModel.text.element: ['CompanyCodeName']
      @EndUserText.label: 'Empresa'
      CompanyCode,
      CompanyCodeName,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' },
                                           additionalBinding: [{  element: 'CompanyCode', localElement: 'CompanyCode' }]}]
      @ObjectModel.text.element: ['BusinessPlaceName']
      @EndUserText.label: 'Local de negócio'
      BusinessPlace,
      BusinessPlaceName,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_FREIGHT_MODE', element: 'FreightMode' }}]
      @ObjectModel.text.element: ['ModFreteText']
      @EndUserText.label: 'Modalidade do frete'
      ModFrete,
      ModFreteText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd'},
                                           additionalBinding: [{  element: 'Region', localElement: 'UfInicio' }]}]
      @ObjectModel.text.element: ['DomFiscalInicioText']
      @EndUserText.label: 'Dom. Fiscal Origem'
      DomFiscalInicio,
      _DomFiscalInicio.Text as DomFiscalInicioText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Region' },
                                           additionalBinding: [{  element: 'Txjcd', localElement: 'DomFiscalInicio' }]}]
      @ObjectModel.text.element: ['UfInicioText']
      @EndUserText.label: 'UF Origem'
      UfInicio,
      _UfInicio.RegionName  as UfInicioText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd'},
                                           additionalBinding: [{  element: 'Region', localElement: 'UfFim' }]}]
      @ObjectModel.text.element: ['DomFiscalFimText']
      @EndUserText.label: 'Dom. Fiscal Destino'
      DomFiscalFim,
      _DomFiscalFim.Text as DomFiscalFimText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Region' },
                                           additionalBinding: [{  element: 'Txjcd', localElement: 'DomFiscalFim' }]}]
      @ObjectModel.text.element: ['UfFimText']
      @EndUserText.label: 'UF Destino'
      UfFim,
      _UfFim.RegionName     as UfFimText,
      @EndUserText.label: 'Data Início Viagem'
      DataInicioViagem,
      @EndUserText.label: 'Hora Início Viagem'
      HoraInicioViagem,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSTEL', element: 'LocalExpedicao' }}]
      @ObjectModel.text.element: ['LocalExpedicaoText']
      @EndUserText.label: 'Local Expedição'
      LocalExpedicao,
      LocalExpedicaoText,
      @EndUserText.label: 'RNTRC'
      Rntrc,
      @EndUserText.label: 'Quantidade NFe'
      QtdNfe,
      @EndUserText.label: 'Quantidade NFe Wrt'
      QtdNfeWrt,
      @EndUserText.label: 'Quantidade NFe Externa'
      QtdNfeExt,
      @EndUserText.label: 'Valor da Carga'
      @Semantics.amount.currencyCode:'Moeda'
      VlrCarga,
      @EndUserText.label: 'Moeda'
      Moeda,
      @EndUserText.label: 'Correção'
      Correcao,
      CorrecaoCriticality,
      @EndUserText.label: 'Informações adicionais (Fisco)'
      InfoFisco,
      @EndUserText.label: 'Informações adicionais (Contribuinte)'
      InfoContrib,
      @EndUserText.label: 'Placa'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_TM_VH_EQUNR', element: 'Equipamento' }}]
      Placa,
      @EndUserText.label: 'Criado à partir de uma OF'
      RefOf,

      @EndUserText.label: 'Criado Por'
      CreatedBy,
      @EndUserText.label: 'Criado Em'
      CreatedAt,
      @EndUserText.label: 'Criado Em'
      CreatedDate,
      @EndUserText.label: 'Alterado Por'
      LastChangedBy,
      @EndUserText.label: 'Alterado Em'
      LastChangedAt,
      @EndUserText.label: 'Alterado Em'
      LastChangedDate,
      @EndUserText.label: 'Registro da hora'
      LocalLastChangedAt,

      @EndUserText.label: 'Etapa do Processo'
      @ObjectModel.text.element: ['ProcessStepText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_PROCSTEP', element: 'ProcessStep' }}]
      Procstep,
      ProcessStepText,
      @EndUserText.label: 'Status da Etapa do Processo'
      @ObjectModel.text.element: ['StepStatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_STEPSTAT', element: 'StepStatus' }}]
      Stepstatus,
      StepStatusText,
      StepstatusCriticality,

      /* Campos Abstract */
      @EndUserText.label: 'Novo motorista'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MOTORISTA', element: 'Parceiro' }}]
      Motorista,
      @EndUserText.label: 'Ordem de Frete'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' }}]
      FreightOrder,

      /* Associations */
      _Complemento     : redirected to composition child ZC_TM_MDF_COMPLEMENTO,
      _Emitente        : redirected to composition child ZC_TM_MDF_EMITENTE,
      _Municipio       : redirected to composition child ZC_TM_MDF_MUNICIPIO,
      _Historico       : redirected to composition child ZC_TM_MDF_HISTORICO,
      _Motorista       : redirected to composition child ZC_TM_MDF_MOTORISTA,
      _Placa           : redirected to composition child ZC_TM_MDF_PLACA,
      _Percurso        : redirected to composition child ZC_TM_MDF_PERCURSO_DOC,
      _Carregamento    : redirected to composition child ZC_TM_MDF_CARREGAMENTO,
      _Descarregamento : redirected to composition child ZC_TM_MDF_DESCARREGAMENTO

      //      _MotoristaPopup
}
