@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCLTM_APP_CARGA_DADOS'
    }
}
@UI.headerInfo: { typeName: 'Carga Dados' ,
                  typeNamePlural: 'Carga de dados' }

@EndUserText.label: 'Carga Dados'
define root custom entity ZC_TM_CARGA_DADOS
{
      @UI.selectionField   : [{position: 10 }]
      @Consumption.filter.mandatory: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_TPCARGA', element: 'TipoCarga' } }]
      @Consumption.filter.selectionType: #SINGLE
  key tipo_carga    : ze_tipo_carga_tmv;
      @UI.selectionField   : [{position: 20 }]
      @Consumption.filter.mandatory: true
      @Consumption.filter.selectionType: #SINGLE
  key modo_teste    : ze_modo_teste;
      @UI.selectionField   : [{position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_tm_vh_motorista_trafegus', element: 'BusinessPartner' } }]
  key motorista     : ze_motorista_f;
      @UI.selectionField   : [{position: 40 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_tm_vh_transp_trafegus', element: 'BusinessPartner' } }]      
  key transportador : ze_transportador_f;
      @UI.selectionField   : [{position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_VEICULO_TRAFEGUS', element: 'equnr' } }]            
  key veiculo       : ze_veiculo_f;
      @UI.lineItem  :  [{ position: 60 }]
      id            : ze_id_tm;
      @UI.lineItem  :  [{position: 70 }]
      descricao     : ze_descricao_tm;
}
