@EndUserText.label: 'Projection Tabela 001'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT001 as projection on ZI_TM_PCOCKPIT001 {
    key Guid,
     @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID' } }]
     @ObjectModel.text.element: ['TextoParametro']
     key Id,    
    Parametro,   
    /* Associations */
    _Cockpit  : redirected to parent ZC_TM_COCKPIT_TAB,    
    
    TextoParametro
}
