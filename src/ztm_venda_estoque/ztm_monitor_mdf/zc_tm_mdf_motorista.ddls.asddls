@EndUserText.label: 'Informações MDF-e : Motorista'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_MOTORISTA
  as projection on ZI_TM_MDF_MOTORISTA as Motorista
{
      @EndUserText.label: 'Id'
  key Id,
      @EndUserText.label: 'Contador'
  key Line,
      @EndUserText.label: 'Parceiro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MOTORISTA', element: 'Parceiro' } }]
  key Motorista,
      @EndUserText.label: 'CPF'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MOTORISTA', element: 'CPF' } }]
      @ObjectModel.text.element: ['CPFText']
      CPF,
      CPFText,
      @EndUserText.label: 'Nome'
      Nome,
      @EndUserText.label: 'Atual motorista'
      AtualMotorista,
      @EndUserText.label: 'Criticalidade'
      Criticality,
      @EndUserText.label: 'Criado por'
      CreatedBy,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Alterado por'
      LastChangedBy,
      @EndUserText.label: 'Alterado em'
      LastChangedAt,
      @EndUserText.label: 'Registro'
      LocalLastChangedAt,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF
}
