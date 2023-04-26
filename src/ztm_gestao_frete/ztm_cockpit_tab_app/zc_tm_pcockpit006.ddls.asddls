@EndUserText.label: 'Projection Tabela 006'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT006
  as projection on ZI_TM_PCOCKPIT006
{
  key Guid,
//      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CFOP', element: 'Cfop' }}]
//      @ObjectModel.text.element: ['TextoCFOP']
    @Consumption.valueHelpDefinition: [{ entity: { element: 'cfop', name: 'ZC_TM_VH_CFOP' } }]
    @ObjectModel.text.element: ['TextoCFOP']
  key Cfop,
  TextoCFOP,
      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB
}
