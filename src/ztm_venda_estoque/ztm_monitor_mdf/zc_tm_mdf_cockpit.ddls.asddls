@EndUserText.label: 'Cockpit MDF-e'
@UI :  { headerInfo:  { typeName: 'Cockpit',
                      typeNamePlural: 'Cockpit',
                      title:  { value: 'Titulo' } } }
@Metadata.allowExtensions: true
@ObjectModel:  { query.implementedBy: 'ABAP:ZCLTM_MDF_COCKPIT'}
define root custom entity ZC_TM_MDF_COCKPIT
{ 
      @UI.selectionField    : [{ position: 30 }]
      @EndUserText.label    : 'DocNum NF Manual'
      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_NOTA_FISCAL', element: 'BR_NotaFiscal' } }]
  key BR_NotaFiscal         : j_1bdocnum;

      @UI.selectionField    : [{ position: 20 }]
      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_ORDEM_FRETE', element: 'OrdemFrete' } }]
      @EndUserText.label    : 'Ordem de frete'
  key OrdemFrete            : traid;

      @Consumption.filter.hidden: true
  key Guid                  : sysuuid_x16;

      @UI.lineItem          : [{ position: 10 }]
      @Consumption.filter.hidden: true
      @EndUserText.label    : 'OF/NF'
      Titulo                : abap.char(100);

      @UI.lineItem          : [{ position: 40, semanticObjectAction: 'manage', type: #WITH_INTENT_BASED_NAVIGATION }]
      @EndUserText.label    : 'Agrupador'
      @Consumption.semanticObject:'ZZ1_MONITOR_MDF'
      Agrupador             : abap.char(10);

      @UI.lineItem          : [{ position: 50, label: 'Status da Etapa do Processo', criticality: 'StepstatusCriticality', criticalityRepresentation: #WITHOUT_ICON }]
      @EndUserText.label    : 'Status da Etapa do Processo'
      @Consumption.valueHelpDefinition: [{ entity:  { name: 'ZI_CA_VH_XNFE_STEPSTAT', element: 'StepStatus' } }]
      @ObjectModel.text.element: ['StepStatusText']
      Stepstatus            : /xnfe/stepstat;

      @UI.hidden            : true
      StepStatusText        : val_text;

      @UI.hidden            : true
      StepstatusCriticality : abap.int1;

      @UI.lineItem          : [{ position: 60, label: 'Status', criticality: 'StatusCriticality', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.selectionField    : [{ position: 40 }]
      @UI.textArrangement   : #TEXT_LAST
      @EndUserText.label    : 'Status'
      @Consumption.valueHelpDefinition: [{ entity:  { name: 'ZI_TM_VH_MDFE_STATCODE', element: 'StatusCode' } }]
      @ObjectModel.text.element: ['StatusText']
      StatusCode            : /xnfe/statuscode;

      @UI.hidden            : true
      StatusText            : /xnfe/description;

      @UI.hidden            : true
      StatusCriticality     : abap.int1;

      @UI.lineItem          : [{ position: 70 }]
      @UI.selectionField    : [{ position: 10 }]
      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_MDF', element: 'BR_MDFeNumber' } }]
      BR_MDFeNumber         : ze_tm_mdfenum;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 80 }]
      Serie                 : j_1bseries;

      @UI.lineItem          : [{ position: 90 }]
      @EndUserText.label    : 'Empresa'
      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_CA_VH_BUKRS', element: 'Empresa' } }]
      Empresa               : bukrs;

      @UI.lineItem          : [{ position: 100 }]
      @UI.selectionField    : [{ position: 50 }]
      @EndUserText.label    : 'Local de expedição'
      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_VSTEL', element: 'LocalExpedicao' } }]
      //      LocalExpedicao        : /scmtms/pty_shipper;
      LocalExpedicao        : vstel;

      @UI.lineItem          : [{ position: 110 }]
      @UI.selectionField    : [{ position: 80 }]
      @EndUserText.label    : 'Placa veículo'
      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_EQUNR', element: 'Equipamento' } }]
      Placa                 : equnr;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 120 }]
      QtdNotas              : ze_qtd_nfe;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 130 }]
      QtdWriter             : ze_qtd_nfe_wrt;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 140 }]
      @EndUserText.label    : 'Contingência'
      Contingencia          : j_1bcontingency;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 150 }]
      @EndUserText.label    : 'Impressa'
      Impressa              : j_1bprintd;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 160 }]
      Regiao                : j_1bregio;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 170 }]
      Ano                   : j_1byear;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 180 }]
      Mes                   : j_1bmonth;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 190 }]
      @EndUserText.label    : 'Nº Id fiscal'
      IDFiscal              : j_1bstcd1;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 200 }]
      Modelo                : j_1bmodel;

      @UI.lineItem          : [{ position: 210 }]
      @UI.selectionField    : [{ position: 70 }]
      @Consumption.filter.selectionType: #INTERVAL
      @Consumption.filter.mandatory:true 
      DataCriacao           : j_1bcredat;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 220 }]
      @EndUserText.label    : 'Nº Log'
      Log                   : j_1bnfeauthcode;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 230 }]
      @EndUserText.label    : 'Chave de acesso'
      ChaveAcesso           : j_1b_nfe_access_key_dtel44;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 240 }]
      @EndUserText.label    : 'Motorista'
      @Consumption.valueHelpDefinition: [{ entity:  { name: 'ZI_TM_VH_MOTORISTA', element: 'Parceiro' } }]
      Motorista             : bu_partner;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 250 }]
      @EndUserText.label    : 'Nome do motorista'
      NomeMotorista         : bu_name1tx;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 260 }]
      @EndUserText.label    : 'UF início'
      UfInicio              : j_1b_shipment_place_uf;

      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 270 }]
      @EndUserText.label    : 'UF fim'
      UfFim                 : j_1b_shipment_place_uf;
      
      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 280 }]
      @EndUserText.label    : 'Placa Trailer 1'
      placa1                : abap.char( 20 );
      
      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 290 }]
      @EndUserText.label    : 'Placa Trailer 2'
      placa2                : abap.char( 20 );
      
      @Consumption.filter.hidden: true
      @UI.lineItem          : [{ position: 300 }]
      @EndUserText.label    : 'Placa Trailer 3'
      placa3                : abap.char( 20 );     
      

      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_TIPO_OPERACAO', element: 'Id' } }]
      @Consumption.filter   :  { mandatory:true }
      @UI.selectionField    : [{ position: 60 }]
      TipoOperacao          : ze_type_sel_mdfe;

      @Consumption.valueHelpDefinition:   [{ entity:  {name: 'ZI_TM_VH_PERIODO_VALIDO', element: 'PeriodoValido' } }]
      @UI.selectionField    : [{ position: 90 }]
      @Consumption.filter   :  { selectionType: #SINGLE, defaultValue: 'X' }
      PeriodoValido         : ze_mdf_periodo_valido;

      // ------------------------------------------------------
      // Buttons information
      // ------------------------------------------------------
      @UI.lineItem          : [{ position: 10, type: #FOR_ACTION, dataAction: 'verificar', label: 'Verificar/Atualizar' },
                               { position: 20, type: #FOR_ACTION, dataAction: 'enviarMdf', label: 'Enviar MDF-e', invocationGrouping: #ISOLATED },
                               { position: 30, type: #FOR_ACTION, dataAction: 'cancelar', label: 'Cancelar MDFe' },
                               { position: 40, type: #FOR_ACTION, dataAction: 'encerrar', label: 'Encerrar MDFe' },
                               { position: 50, type: #FOR_ACTION, dataAction: 'motorista', label: 'Motorista' },
                               { position: 60, type: #FOR_ACTION, dataAction: 'criarRefMdfe', label: 'Criar Referência MDFe' }]

      @UI.hidden            : true
      Action                : abap.char(1);

      _Motorista            : association [0..1] to ZI_TM_VH_MOTORISTA on _Motorista.Parceiro = $projection.Motorista;
}
