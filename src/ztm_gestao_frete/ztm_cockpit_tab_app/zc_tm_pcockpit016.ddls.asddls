@EndUserText.label: 'Projection Tabela 016'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT016 as projection on ZI_TM_PCOCKPIT016 {
    key Guid,
     @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_ACAO' } }]
     @ObjectModel.text.element: ['TextoAcao']
    key Acao,
     @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CODSTATUS' } }]
     @ObjectModel.text.element: ['TextoStatusDe']
    key CodstatusDe,
    @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CODSTATUS' } }]
     @ObjectModel.text.element: ['TextoStatusPara']
    CodstatusPara,
    /* Associations */
    _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
    
    TextoAcao,
    TextoStatusDe,
    TextoStatusPara
}
