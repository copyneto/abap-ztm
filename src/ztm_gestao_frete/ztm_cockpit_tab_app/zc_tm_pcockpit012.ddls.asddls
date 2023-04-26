@EndUserText.label: 'Projection Tabela 012'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT012 as projection on ZI_TM_PCOCKPIT012 {
    key Guid,
     @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_TPDOC' } }]
     @ObjectModel.text.element: ['TextoTpDoc']
    key Tpdoc,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_MOD_NF' } }]
    @ObjectModel.text.element: ['TextoModel']
    key Model, 
    @Consumption.valueHelpDefinition: [{ entity: { element: 'nftype', name: 'ZC_TM_VH_NFTYPE' } }]
    @ObjectModel.text.element: ['TextoNFType']
    Nftype,
    /* Associations */
    _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
    TextoTpDoc,
    TextoNFType,
    TextoModel
//    TextoNFType
}
