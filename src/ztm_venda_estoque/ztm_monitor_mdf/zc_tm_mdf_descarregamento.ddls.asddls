@EndUserText.label: 'Informações MDF-e : Descarregamento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_DESCARREGAMENTO
  as projection on ZI_TM_MDF_DESCARREGAMENTO as Descarregamento
{
  key Id,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd'},
                                           additionalBinding: [{  element: 'Region', localElement: 'Uf' }]}]
      @ObjectModel.text.element: ['TaxJurCodeText']
  key TaxJurCode,
      TaxJurCodeText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Region' },
                                           additionalBinding: [{  element: 'Txjcd', localElement: 'TaxJurCode' }]}]
      @ObjectModel.text.element: ['UfName']
      Uf,
      UfName,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF
}
