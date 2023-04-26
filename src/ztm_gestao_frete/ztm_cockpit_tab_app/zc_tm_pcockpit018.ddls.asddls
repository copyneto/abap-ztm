@EndUserText.label: 'Projection Tabela 018'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT018 as projection on ZI_TM_PCOCKPIT018 {
    key Guid,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'ShippingPoint', name: 'C_ShippingPointVH' } }] 
    key Vstel,
    
//    @Consumption.valueHelpDefinition: [{ entity: { element: 'mtart', name: 'ZI_TM_VH_TPMATERIAL' } }] 
    
    @Consumption.valueHelpDefinition: [{ entity: { element: 'MATKL', name: 'ZC_TM_VH_MATKL' } }] 
    @ObjectModel.text.element: ['TextoMATKL']
    key Mtart,
     @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    key Mwskz,
    TextoMATKL,
    /* Associations */
    _Cockpit: redirected to parent ZC_TM_COCKPIT_TAB
}
