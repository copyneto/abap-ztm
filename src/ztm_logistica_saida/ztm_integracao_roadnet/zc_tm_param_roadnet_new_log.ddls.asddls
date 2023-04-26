@EndUserText.label: 'Roadnet - Logs'
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_PARAM_ROADNET_LOG_CE'

@UI: { headerInfo: { typeName: 'Log',
                     typeNamePlural: 'Logs' } }

@UI.lineItem: [{criticality: 'criticality' }]

@UI.presentationVariant: [{ sortOrder: [{ by: 'centro', direction: #DESC },
                                        { by: 'session_data', direction: #DESC },
                                        { by: 'session_id', direction: #DESC },
                                        { by: 'line', direction: #DESC } ] } ]

@UI.selectionVariant: [{ id: 'ENTREGA', text: 'Entrega', filter: 'description EQ "ENTREGA"' },
                       { id: 'CROSSDOCKING', text: 'Cross Docking', filter: 'description EQ "CROSSDOCKING" OR 
                                                                             description EQ "CROSS"'  },
                       { id: 'REDESPACHO', text: 'Redespacho', filter: 'description EQ "REDESPACHO"' } ]

@UI.selectionPresentationVariant: [{ id: 'ENTREGA', selectionVariantQualifier: 'ENTREGA', text: 'Entrega' },
                                   { id: 'CROSSDOCKING', selectionVariantQualifier: 'CROSSDOCKING', text: 'Cross Docking' },
                                   { id: 'REDESPACHO', selectionVariantQualifier: 'REDESPACHO', text: 'Redespacho' } ]

define custom entity ZC_TM_PARAM_ROADNET_NEW_LOG
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet             : [ { id:              'Log',
                                  purpose:         #STANDARD,
                                  type:            #IDENTIFICATION_REFERENCE,
                                  label:           'Logs',
                                  position:        10 } ]

      // ------------------------------------------------------
      // Buttons information
      // ------------------------------------------------------

      @UI.lineItem          : [ { type: #FOR_ACTION, dataAction: 'apagar_log', label: 'Apagar histórico', invocationGrouping: #CHANGE_SET } ]
      
      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @UI.hidden            : true
  key centro                : werks_d;

      @UI.hidden            : true
  key session_data          : ze_data_session;

      @UI.lineItem          : [ { position: 10 } ]
      @UI.identification    : [ { position: 10 } ]

      @UI.hidden            : true
  key session_id            : ze_id_session_roadnet;

      @UI.lineItem          : [ { position: 20 } ]
      @UI.identification    : [ { position: 20 } ]

      @EndUserText.label    : 'Linha'
  key line                  : bapi_line;

      @UI.lineItem          : [ { position: 30 } ]
      @UI.identification    : [ { position: 30 } ]
      @EndUserText.label    : 'ID Rota'
      route_id              : ze_id_route_roadnet;

      @EndUserText.label    : 'Descrição'
      description           : abap.char(100);

      @UI.hidden            : true
      @EndUserText.label    : 'Tipo mensagem'
      msgty                 : bapi_mtype;

      @UI.hidden            : true
      @EndUserText.label    : 'ID mensagem'
      msgid                 : symsgid;

      @UI.hidden            : true
      @EndUserText.label    : 'Nº mensagem'
      msgno                 : symsgno;

      @UI.hidden            : true
      @EndUserText.label    : 'Val. l Mensagem'
      msgv1                 : symsgv;

      @UI.hidden            : true
      @EndUserText.label    : 'Val. 2 Mensagem'
      msgv2                 : symsgv;

      @UI.hidden            : true
      @EndUserText.label    : 'Val. 3 Mensagem'
      msgv3                 : symsgv;

      @UI.hidden            : true
      @EndUserText.label    : 'Val. 4 Mensagem'
      msgv4                 : symsgv;

      @UI.lineItem          : [ { position: 40 } ]
      @UI.identification    : [ { position: 40 } ]

      @EndUserText.label    : 'Mensagem'
      message               : bapi_msg;

      @UI.lineItem          : [ { position: 50 } ]
      @UI.identification    : [ { position: 50 } ]

      @EndUserText.label    : 'Criado por'
      @ObjectModel.text.element: ['created_by_name']
      created_by            : ze_created_by;

      @UI.hidden            : true
      created_by_name       : abap.char(100);

      @UI.lineItem          : [ { position: 60 } ]
      @UI.identification    : [ { position: 60 } ]

      @EndUserText.label    : 'Criado em'
      created_at            : ze_created_at;

      @EndUserText.label    : 'Alterado por'
      @ObjectModel.text.element: ['last_changed_by_name']
      last_changed_by       : ze_last_changed_by;

      @UI.hidden            : true
      last_changed_by_name  : abap.char(100);

      @EndUserText.label    : 'Alterado em'
      last_changed_at       : ze_last_changed_at;

      @EndUserText.label    : 'Registrado em'
      local_last_changed_at : timestampl;

      @UI.hidden            : true
      @EndUserText.label    : 'Criticalidade'
      criticality           : abap.int1;

      _Roadnet              : association to parent zc_tm_param_roadnet_new on  _Roadnet.centro       = $projection.centro
                                                                            and _Roadnet.session_data = $projection.session_data;

}
