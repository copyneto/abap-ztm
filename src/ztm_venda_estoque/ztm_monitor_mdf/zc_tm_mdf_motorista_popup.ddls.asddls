@EndUserText.label: 'Informações MDF-e : Motorista (Pop-up)'
@Metadata.allowExtensions: true

define abstract entity ZC_TM_MDF_MOTORISTA_POPUP
{
      @EndUserText.label: 'Motorista'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MOTORISTA', element: 'Parceiro' } } ]
  Motorista : bu_partner;
}
