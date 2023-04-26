@EndUserText.label: 'Cockpit de Frete - Log'
@UI.headerInfo.typeName: 'Log'
@UI.headerInfo.typeNamePlural: 'Logs'
@UI.headerInfo.title.type: #STANDARD
@UI.headerInfo.title.value: 'acckey'
@Metadata.allowExtensions: true
@ObjectModel:  { query.implementedBy: 'ABAP:ZCLTM_COCKPIT_FRETE_LOG_NEW_CE' }

@UI.lineItem: [{criticality: 'CodstatusCrit'}]

define custom entity ZC_TM_COCKPIT_LOG_NEW
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet     : [ { id:            'Log',
                          purpose:       #STANDARD,
                          type:          #IDENTIFICATION_REFERENCE,
                          label:         'Logs',
                          position:      10 }  ]

      @UI.hidden    : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ACCKEY', element: 'acckey' } }]
      @EndUserText.label: 'Chave de acesso'
  key Acckey        : j_1b_nfe_access_key_dtel44;

      @UI.lineItem  : [ { position: 20 } ]
      @UI.identification    : [ { position: 20 } ]
      @EndUserText.label: 'Contador'
  key Counter       : ze_1bnfe_history_counter;

      @UI.lineItem  :       [ { position: 30, criticality: 'CodstatusCrit', criticalityRepresentation: #WITHOUT_ICON } ]
      @UI.identification: [ { position: 30, criticality: 'CodstatusCrit', criticalityRepresentation: #WITHOUT_ICON } ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CODSTATUS', element: 'codstatus' } }]
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: [ 'CodstatusText']
      Codstatus     : ze_gko_codstatus;

      @UI.hidden    : true
      CodstatusText : val_text;

      @UI.hidden    : true
      CodstatusCrit : abap.int1;

      @UI.lineItem  :       [ { position: 40, criticality: 'TpprocessCrit', criticalityRepresentation: #WITHOUT_ICON } ]
      @UI.identification: [ { position: 40, criticality: 'TpprocessCrit', criticalityRepresentation: #WITHOUT_ICON } ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPPROCESS', element: 'tpprocess' } }]
      @EndUserText.label: 'Processamento '
      @ObjectModel.text.element: [ 'TpprocessText']
      Tpprocess     : ze_gko_tpprocess;

      @UI.hidden    : true
      TpprocessText : val_text;

      @UI.hidden    : true
      TpprocessCrit : abap.int1;

      @UI.lineItem  :       [ { position: 50 } ]
      @UI.identification: [ { position: 50 } ]
      @EndUserText.label: 'Documento'
      Newdoc        : abap.char(30);

      @UI.lineItem  :       [ { position: 60 } ]
      @UI.identification: [ { position: 60 } ]
      @EndUserText.label: 'Código'
      Codigo        : abap.char(3);

      @UI.lineItem  :       [ { position: 70 } ]
      @UI.identification: [ { position: 70 } ]
      @EndUserText.label: 'Descrição'
      DescCodigo    : abap.char(220);

      @UI.lineItem  :       [ { position: 80 } ]
      @UI.identification: [ { position: 80 } ]
      @EndUserText.label: 'Criado em'
      Credat        : j_1bcredat;

      @UI.lineItem  :       [ { position: 90 } ]
      @UI.identification: [ { position: 90 } ]
      @EndUserText.label: 'Criado às'
      Cretim        : j_1bcretim;

      @UI.lineItem  :       [ { position: 100 } ]
      @UI.identification: [ { position: 100 } ]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: [ 'CrenamText']
      Crenam        : j_1bcrenam;

      @UI.hidden    : true
      CrenamText    : ad_namtext;
}
