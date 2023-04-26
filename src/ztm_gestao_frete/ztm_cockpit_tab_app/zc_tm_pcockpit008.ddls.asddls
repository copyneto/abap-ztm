@EndUserText.label: 'Projection Tabela 008'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT008
  as projection on ZI_TM_PCOCKPIT008
{
  key Guid,
//      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CFOP', element: 'Cfop' }}]
      @Consumption.valueHelpDefinition: [{ entity: { element: 'cfop', name: 'ZC_TM_VH_CFOP' } }]
      @ObjectModel.text.element: ['TextDc']
  key Dcfop,
//      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CFOP', element: 'Cfop' }}]
      @Consumption.valueHelpDefinition: [{ entity: { element: 'cfop', name: 'ZC_TM_VH_CFOP' } }]
      @ObjectModel.text.element: ['TextPc']
      pcfop,
      TextDc,
      TextPc,
      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB
}
