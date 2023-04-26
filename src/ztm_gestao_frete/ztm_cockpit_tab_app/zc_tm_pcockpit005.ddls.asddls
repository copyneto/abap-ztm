@EndUserText.label: 'Projection Tabela 005'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT005 as projection on ZI_TM_PCOCKPIT005 {
    key Guid,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'bland', name: 'ZI_TM_VH_REGIO' } }]
    @ObjectModel.text.element: ['TextoFrom']
    key RegioFrom,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'bland', name: 'ZI_TM_VH_REGIO' } }]
    @ObjectModel.text.element: ['TextoTo']
    key RegioTo,
    
    @Consumption.valueHelpDefinition: [{ entity: { element: 'inco1', name: 'ZI_TM_VH_INCOTERMS' } }]
    @ObjectModel.text.element: ['TextoInco']
    key Incoterm,
    
    @ObjectModel.text.element: ['TxtEmp'] 
    @Consumption.valueHelpDefinition: [{ entity: { element: 'CompanyCode', name: 'C_CompanyCodeValueHelp' } }]
    key Burks,
    
    @ObjectModel.text.element: ['TxtVstel']    
    @Consumption.valueHelpDefinition: [{ entity: { element: 'ShippingPoint', name: 'C_ShippingPointVH' } }] 
    key Vstel,
    
    @ObjectModel.text.element: ['TxtIva']
    @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    Mwskz,
    /* Associations */
    _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
    TextoInco,
    TextoFrom,
    TextoTo,
    TxtIva,
    TxtVstel,
    TxtEmp
}
