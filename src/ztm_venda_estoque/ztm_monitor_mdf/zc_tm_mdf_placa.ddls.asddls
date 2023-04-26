@EndUserText.label: 'Informações MDF-e : Placas'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_PLACA
  as projection on ZI_TM_MDF_PLACA as Placa
{
  key Id,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_EQUNR', element: 'Equipamento' } }]
      @ObjectModel.text.element: ['PlacaText']
  key Placa,
      PlacaText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EQTYP', element: 'CategoriaEquip' } }]
      @ObjectModel.text.element: ['CategoriaEquipText']
      CategoriaEquip,
      CategoriaEquipText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_EQART', element: 'TipoEquip' } }]
      @ObjectModel.text.element: ['TipoEquipText']
      TipoEquip,
      TipoEquipText,
      Renavam,
      Tara,
      CapKg,
      CapM3,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPROD', element: 'TpRod' } }]
      @ObjectModel.text.element: ['TpRodText']
      TpRod,
      TpRodText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPCAR', element: 'TpCar' } }]
      @ObjectModel.text.element: ['TpCarText']
      TpCar,
      TpCarText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @ObjectModel.text.element: ['UfName']
      Uf,
      _Regio.RegionName     as UfName,
      Reboque,
      ReboqueCriticality,
      @EndUserText.label: 'Proprietário diferente do Emitente'
      Ativo,
      AtivoCriticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Proprietário'
      Proprietario,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'CPF' } }]
      @EndUserText.label: 'CPF'
      @ObjectModel.text.element: ['CPFText']
      CPF,
      CPFText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'CNPJ' } }]
      @EndUserText.label: 'CNPJ'
      @ObjectModel.text.element: ['CNPJText']
      CNPJ,
      CNPJText,
      @EndUserText.label: 'RNTRC'
      Rntrc,
      @EndUserText.label: 'Nome'
      Nome,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'InscricaoEstadual ' } }]
      @EndUserText.label: 'Inscrição Estadual'
      IE,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @ObjectModel.text.element: ['UfPropName']
      @EndUserText.label: 'UF'
      UfProp,
      _RegioProp.RegionName as UfPropName,
      @EndUserText.label: 'Tipo de Proprietário'
      TpProp,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _MDF         : redirected to parent ZC_TM_MDF,
      _Condutor    : redirected to composition child ZC_TM_MDF_PLACA_CONDUTOR,
      _ValePedagio : redirected to composition child ZC_TM_MDF_PLACA_VALE_PEDAGIO
}
