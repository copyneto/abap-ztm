@EndUserText.label: 'CDS de Projeção - Manutenção de Placas'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_TM_CONFIG_PLACA
  as projection on ZI_TM_CONFIG_PLACA
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_EQUNR', element: 'Equipamento' },
                                           additionalBinding: [{ element: 'Text', localElement: 'Placatext' }] }]
      @ObjectModel.text.element: ['PlacaText']
  key Placa,
      Placatext,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EQTYP', element: 'CategoriaEquip' },
                                           additionalBinding: [{ element: 'Text', localElement: 'CategoriaEquipText' }] }]
      @ObjectModel.text.element: ['CategoriaEquipText']
      CategoriaEquip,
      CategoriaEquipText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EQART', element: 'TipoEquip' },
                                           additionalBinding: [{ element: 'Text', localElement: 'TipoEquipText' }] }]
      @ObjectModel.text.element: ['TipoEquipText']
      TipoEquip,
      TipoEquipText,
      Renavam,
      Tara,
      CapKg,
      CapM3,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPROD', element: 'TpRod' },
                                           additionalBinding: [{ element: 'TpRodText', localElement: 'TpRodText' }] }]
      @ObjectModel.text.element: ['TpRodText']
      TpRod,
      TpRodText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPCAR', element: 'TpCar' },
                                           additionalBinding: [{ element: 'TpCarText', localElement: 'TpCarText' }] }]
      
      @ObjectModel.text.element: ['TpCarText']
      TpCar,
      TpCarText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' },
                                           additionalBinding: [{ element: 'RegionName', localElement: 'UfName' }] }]
      @ObjectModel.text.element: ['UfName']
      @EndUserText.label: 'Região'
      Uf,
      UfName,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
