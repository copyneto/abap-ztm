@EndUserText.label: 'Ordem de Frete (Pop-up)'
define abstract entity ZI_TM_MDF_ORDEM_FRETE_POPUP
{
  @EndUserText.label: 'Ordem de Frete'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } } ]
  FreightOrder : /scmtms/tor_id;

}
