@EndUserText.label: 'Informações MDF-e: Placas x Vale Pedágio'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_PLACA_VALE_PEDAGIO
  as projection on ZI_TM_MDF_PLACA_VALE_PEDAGIO
{
  key Id,
  key Placa,
  key NCompra,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_PJ', element: 'Parceiro' } }]
      @ObjectModel.text.element: ['FornecedorNome']
      Fornecedor,
      _Fornecedor.Nome as FornecedorNome,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_PJ', element: 'CNPJ' } }]
      @ObjectModel.text.element: ['CnpjFornText']
      CnpjForn,
      CnpjFornText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @ObjectModel.text.element: ['PagadorNome']
      Pagador,
      _Pagador.Nome as PagadorNome,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'CNPJ' } }]
      @ObjectModel.text.element: ['CnpjPgText']
      CnpjPg,
      CnpjPgText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'CPF' } }]
      @ObjectModel.text.element: ['CpfPgText']
      CpfPg,
      CpfPgText,
      ValorValePed,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _MDF : redirected to ZC_TM_MDF,
      _Placa : redirected to parent ZC_TM_MDF_PLACA
}
