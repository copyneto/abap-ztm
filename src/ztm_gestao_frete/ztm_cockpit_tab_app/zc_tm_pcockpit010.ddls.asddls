@EndUserText.label: 'Projection Tabela 010'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT010 as projection on ZI_TM_PCOCKPIT010 {
    key Guid,
    key Guid10,
     @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
    @ObjectModel.text.element: ['TextoIva']  
    key Mwskz,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'nftype', name: 'ZC_TM_VH_NFTYPE' } }]
    @ObjectModel.text.element: ['TextoNFType']     
    key Nftype,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'saknr', name: 'ZC_TM_VH_CONTAS_RAZAO' } }]
    @ObjectModel.text.element: ['TextoConta']  
     Saknr,
//    key RemUf,
    RemUf,
   
    /* Associations */
    _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
    TextoConta,
    TextoNFType,
    TextoIva
}
