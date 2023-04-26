@EndUserText.label: 'Informações MDF-e: Alteração Motorista'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Docnum']
define root view entity ZC_TM_MDF_MOTORISTA_CHANGE
  as projection on ZI_TM_MDF_MOTORISTA_CHANGE as _Writer
  association [0..1] to ZI_TM_VH_EQUNR     on ZI_TM_VH_EQUNR.Equipamento = $projection.Placa
  association [0..1] to ZI_TM_VH_MOTORISTA on ZI_TM_VH_MOTORISTA.Parceiro = $projection.Motorista

{
  key Docnum,
      DataLancamento,
      CriadoPor,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSTEL', element: 'LocalExpedicao' } }]
      @ObjectModel.text.element: ['BusinessPlaceName']
      LocalNegocio,
      BusinessPlaceName,
      NumeroNota,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_EQUNR', element: 'Equipamento' } } ]
      Placa,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MOTORISTA', element: 'Parceiro' } } ]
      @ObjectModel.text.element: ['MotoristaNome']
      Motorista,
      _PF.Nome as MotoristaNome,
      CompanyCode,
      BR_NotaFiscal,
      /* Associations */
      _PF,

      _Historico : redirected to composition child ZC_TM_MDF_HIST_MOTORISTA,
      ZI_TM_VH_EQUNR,
      ZI_TM_VH_MOTORISTA
}
