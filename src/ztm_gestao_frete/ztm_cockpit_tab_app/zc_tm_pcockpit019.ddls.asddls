@EndUserText.label: 'Projection Tabela 019'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT019 as projection on ZI_TM_PCOCKPIT019 {
    key Guid,    
    @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CENARIO' } }]
    @ObjectModel.text.element: ['TextoCenario']
    key Cenario,
    key IcmsXml,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    @ObjectModel.text.element: ['TextoIvaNF']
    key IvaNf,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    @ObjectModel.text.element: ['TextoIvaFrete']
    key IvaFrete,
    movimentacao,
    
    TextoIvaNF,
    TextoIvaFrete,
    
    
    /* Associations */
    _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
    TextoCenario
}
