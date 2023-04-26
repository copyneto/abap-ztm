@EndUserText.label: 'Informações MDF-e: Placa (Popup)'
@Metadata.allowExtensions: true

define abstract entity ZC_TM_MDF_PLACA_POPUP
{
      @EndUserText.label: 'Placa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_EQUNR', element: 'Equipamento' } } ]
  Placa : equnr;
}
