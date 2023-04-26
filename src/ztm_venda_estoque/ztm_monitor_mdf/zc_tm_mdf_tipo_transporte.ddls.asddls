@EndUserText.label: 'Configuração dos tipos de transporte'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_TM_MDF_TIPO_TRANSPORTE
  as projection on zi_tm_mdf_tipo_transporte
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EQART', element: 'TipoEquip' } } ]
      @ObjectModel.text.element: ['CategoriaText']
      @EndUserText.label: 'Tipo do objeto técnico'
  key Categoria,
      CategoriaText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPROD', element: 'TpRod' } } ]
      @ObjectModel.text.element: ['TpRodText']
      @EndUserText.label: 'Meio de transporte'
      TpRod,
      TpRodText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPCAR', element: 'TpCar' } } ]
      @ObjectModel.text.element: ['TpCarText']
      @EndUserText.label: 'Tipo do reboque'
      TpCar,
      TpCarText,

      //Controle
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
