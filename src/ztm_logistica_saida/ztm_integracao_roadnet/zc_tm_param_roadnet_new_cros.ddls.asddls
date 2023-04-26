@EndUserText.label: 'Roadnet - Cross Docking'
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_PARAM_ROADNET_CROS_CE'

@UI: { headerInfo: { typeName: 'Sessão',
                     typeNamePlural: 'Sessões',
                     title:  { value: 'route_id' } } }

@UI.presentationVariant: [{ sortOrder: [{ by: 'centro', direction: #DESC },
                                        { by: 'session_data', direction: #DESC },
                                        { by: 'session_id', direction: #DESC } ] } ]

@UI.lineItem: [{criticality: 'criticality' }]

define custom entity ZC_TM_PARAM_ROADNET_NEW_CROS
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet             : [ { id:              'Item',
                                  purpose:         #STANDARD,
                                  type:            #IDENTIFICATION_REFERENCE,
                                  label:           'Items',
                                  position:        10 } ]

      // ------------------------------------------------------
      // Buttons information
      // ------------------------------------------------------

      @UI.lineItem          : [ { type: #FOR_ACTION, dataAction: 'importar_cros', label: 'Importar Cross Docking', invocationGrouping: #CHANGE_SET } ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @UI.hidden            : true
  key centro                : werks_d;

      @UI.hidden            : true
  key session_data          : ze_data_session;

      @UI.lineItem          : [ { position: 10 } ]
      @UI.identification    : [ { position: 10 } ]

      @EndUserText.label    : 'ID Sessão'
  key session_id            : ze_id_session_roadnet;

      @UI.lineItem          : [ { position: 20 } ]
      @UI.identification    : [ { position: 20 } ]
      @EndUserText.label    : 'ID Rota'
  key route_id              : ze_id_route_roadnet;

      @UI.lineItem          : [ { position: 30 } ]
      @UI.identification    : [ { position: 30 } ]
      @EndUserText.label    : 'Remessas'
      deliveries            : abap.numc(10);

      @UI.lineItem          : [ { position: 40 } ]
      @UI.identification    : [ { position: 40 } ]
      @EndUserText.label    : 'Descrição'
      description           : abap.char(100);

      @Consumption.semanticObject : 'FreightOrder'
      @UI.lineItem          : [ { position: 50, semanticObjectAction: 'displayRoad', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.identification    : [ { position: 50, semanticObjectAction: 'displayRoad', type: #WITH_INTENT_BASED_NAVIGATION } ]

      @EndUserText.label    : 'Ordem de Frete'
      FreightOrder          : /scmtms/tor_id;

      @UI.lineItem          : [ { position: 60 } ]
      @UI.identification    : [ { position: 60 } ]

      @EndUserText.label    : 'Criado por'
      @ObjectModel.text.element: ['created_by_name']
      created_by            : ze_created_by;

      @UI.hidden            : true
      created_by_name       : abap.char(100);

      @UI.lineItem          : [ { position: 70 } ]
      @UI.identification    : [ { position: 70 } ]

      @EndUserText.label    : 'Criado em'
      created_at            : ze_created_at;

      @UI.hidden            : true
      @EndUserText.label    : 'Alterado por'
      @ObjectModel.text.element: ['last_changed_by_name']
      last_changed_by       : ze_last_changed_by;

      @UI.hidden            : true
      last_changed_by_name  : abap.char(100);

      @UI.hidden            : true
      @EndUserText.label    : 'Alterado em'
      last_changed_at       : ze_last_changed_at;

      @UI.hidden            : true
      @EndUserText.label    : 'Registrado em'
      local_last_changed_at : timestampl;

      @UI.hidden            : true
      @EndUserText.label    : 'Criticalidade'
      criticality           : abap.int1;

      _Roadnet              : association to parent zc_tm_param_roadnet_new on  _Roadnet.centro       = $projection.centro
                                                                            and _Roadnet.session_data = $projection.session_data;
}
