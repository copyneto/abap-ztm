@EndUserText.label: 'Parâmetros de Entrada: Interface Roadnet'
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_PARAM_ROADNET_CE'

@UI: { headerInfo: { typeName: 'Parâmetro de Entrada',
                     typeNamePlural: 'Parâmetros de Entrada' } }

@UI.lineItem: [{criticality: 'criticality' }]

@UI.presentationVariant: [{ sortOrder: [{ by: 'centro', direction: #DESC },
                                        { by: 'session_data', direction: #DESC }] }]

define root custom entity ZC_TM_PARAM_ROADNET_NEW
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet             : [ { id:              'HeaderCentro',
                                  purpose:         #HEADER,
                                  type:            #DATAPOINT_REFERENCE,
                                  targetQualifier: 'HeaderCentro',
                                  position:        10 },

                                { id :              'HeaderSessionData',
                                  purpose:         #HEADER,
                                  type:            #DATAPOINT_REFERENCE,
                                  targetQualifier: 'HeaderSessionData',
                                  position:        20 },

                                { id :              'Roadnet',
                                  purpose:         #STANDARD,
                                  type:            #IDENTIFICATION_REFERENCE,
                                  label:           'Parâmetros',
                                  position:        10 },

                                { id :              'Entrega',
                                  purpose:         #STANDARD,
                                  type:            #LINEITEM_REFERENCE,
                                  label:           'Entrega',
                                  position:        20,
                                  targetElement:   '_Entrega'},

                                { id :              'Redespacho',
                                  purpose:         #STANDARD,
                                  type:            #LINEITEM_REFERENCE,
                                  label:           'Redespacho',
                                  position:        30,
                                  targetElement:   '_Redespacho'},

                                { id :              'CrossDocking',
                                  purpose:         #STANDARD,
                                  type:            #LINEITEM_REFERENCE,
                                  label:           'Cross Docking',
                                  position:        40,
                                  targetElement:   '_CrossDocking'},

                                { id :              'Log',
                                  purpose:         #STANDARD,
                                  type:            #LINEITEM_REFERENCE,
                                  label:           'Log',
                                  position:        50,
                                  targetElement:   '_Log'} ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @UI.lineItem          : [ { position: 10 } ]
      @UI.identification    : [ { position: 10 } ]
      @UI.selectionField    : [ { position: 10 } ]
      @UI.dataPoint         : { qualifier: 'HeaderCentro' }
      @Consumption.filter   : { mandatory: true, multipleSelections: true }

      @EndUserText.label    : 'Centro'
      @ObjectModel.text.element: ['centro_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
  key centro                : werks_d;

      @UI.lineItem          : [ { position: 20 } ]
      @UI.identification    : [ { position: 20 } ]
      @UI.selectionField    : [ { position: 20 } ]
      @UI.dataPoint         : { qualifier: 'HeaderSessionData' }
      //      @Consumption.filter   : { mandatory: true, multipleSelections: false, selectionType: #SINGLE }
      @Consumption.filter   : { mandatory: true, multipleSelections: false }

      @EndUserText.label    : 'Data Sessão'
  key session_data          : ze_data_session;

      @UI.hidden            : true

      @EndUserText.label    : 'Descrição do Centro'
      centro_txt            : abap.char(30);

      @UI.hidden            : true

      @EndUserText.label    : 'ID Sessão'
      session_id            : ze_id_session_roadnet;

      @UI.lineItem          : [ { position: 30 } ]
      @UI.identification    : [ { position: 30 } ]


      @EndUserText.label    : 'Rotas'
      total_route_id        : ze_total_route_id;

      @UI.lineItem          : [ { position: 40, criticality: 'criticality', criticalityRepresentation: #WITHOUT_ICON } ]
      @UI.identification    : [ { position: 40, criticality: 'criticality', criticalityRepresentation: #WITHOUT_ICON } ]
      @Consumption.filter   : { hidden: true }

      @EndUserText.label    : 'Mensagem'
      mensagem              : abap.char(100);

      @UI.hidden            : true
      criticality           : abap.int1;

      @EndUserText.label    : 'Criado por'
      created_by            : ze_created_by;

      @EndUserText.label    : 'Criado em'
      created_at            : ze_created_at;

      @EndUserText.label    : 'Alterado por'
      last_changed_by       : ze_last_changed_by;

      @EndUserText.label    : 'Alterado em'
      last_changed_at       : ze_last_changed_at;

      @EndUserText.label    : 'Registrado em'
      local_last_changed_at : timestampl;

      _Entrega              : composition [0..*] of zc_tm_param_roadnet_new_entr;

      _CrossDocking         : composition [0..*] of zc_tm_param_roadnet_new_cros;

      _Redespacho           : composition [0..*] of zc_tm_param_roadnet_new_rede;

      _Log                  : composition [0..*] of zc_tm_param_roadnet_new_log;

}
