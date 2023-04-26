@EndUserText.label: 'Projection Tabela 003'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT003 as projection on ZI_TM_PCOCKPIT003 {
    key Guid,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'cfop', name: 'ZC_TM_VH_CFOP' } }]
    @ObjectModel.text.element: ['TextoCFOP']
    key Cfop,
//    @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CENARIO' } }]
//    @ObjectModel.text.element: ['TextoCenario']
    
    
//    key Cenario,
    

    @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    @ObjectModel.text.element: ['TxtIvaDe']
    key Dmwskz,
//    Cenario,
    @ObjectModel.text.element: ['TxtIvaPara']
    @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    Pmwskz,
    TextoCFOP,
    TxtIvaDe,
    TxtIvaPara,
    /* Associations */
    _Cockpit  : redirected to parent ZC_TM_COCKPIT_TAB
    
//    TextoCenario
    
}
