@EndUserText.label: 'Informações MDF-e : Placas x Condutores'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_PLACA_CONDUTOR
  as projection on ZI_TM_MDF_PLACA_CONDUTOR
{
  key Id,
  key Placa,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_PF', element: 'Parceiro' } }]
  key Condutor,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_PF', element: 'CPF' } }]
      @ObjectModel.text.element: ['CPFText']
      Cpf,
      CPFText,
      Nome,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _MDF   : redirected to ZC_TM_MDF,
      _Placa : redirected to parent ZC_TM_MDF_PLACA
}
