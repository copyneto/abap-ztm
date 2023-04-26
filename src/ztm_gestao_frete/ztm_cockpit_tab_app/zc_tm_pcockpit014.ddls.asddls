@EndUserText.label: 'Projection Tabela 014'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT014 as projection on ZI_TM_PCOCKPIT014 {
    key Guid,
    
    key EventoExtra,
    
    @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CENARIO' } }]
    @ObjectModel.text.element: ['TextoCenario']    
    TipoDoc,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'VH_TpCusto', name: 'ZC_TM_VH_TPCUSTO' } }]
    TpCustoTm,
    descricao,
    
    /* Associations */
    _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
    
    TextoCenario
}
