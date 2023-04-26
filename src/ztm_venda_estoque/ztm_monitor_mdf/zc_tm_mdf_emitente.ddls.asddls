@EndUserText.label: 'Informações MDF-e : Emitente'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_EMITENTE
  as projection on ZI_TM_MDF_EMITENTE as Emitente
{
  key Id,
      CompanyCode,
      BusinessPlace,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'CNPJ' } }]
      @ObjectModel.text.element: ['CnpjText']
      Cnpj,
      CnpjText,
      InscricaoEstadual,
      NomeEmpresa,
      Endereco,
      Rua,
      Numero,
      Complemento,
      Bairro,
      TaxJurCode,
      Cidade,
      Cep,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF
}
