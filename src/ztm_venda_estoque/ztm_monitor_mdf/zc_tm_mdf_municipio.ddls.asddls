@EndUserText.label: 'Informações MDF-e : Município'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_MUNICIPIO
  as projection on ZI_TM_MDF_MUNICIPIO as Municipio
{
      @EndUserText.label: 'GUID'
  key Guid,
      @EndUserText.label: 'Chave de Acesso'
  key AccessKey, 
      @EndUserText.label: 'Ordem de Frete (Interno)'
  key OrdemFrete,
      @EndUserText.label: 'Nº documento'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MDF_NF_OF', element: 'BR_NotaFiscal' },
                                           additionalBinding: [{ element: 'FreightOrder', localElement: 'FreightOrder' }] }]
      BR_NotaFiscal,
      @EndUserText.label: 'NF-e'
      BR_NFeNumber,
      @EndUserText.label: 'Ordem de Frete'
      FreightOrder,
      @EndUserText.label: '2º Código de Barras'
      SegCodigoBarra,
      @EndUserText.label: 'Carga'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' } }]
      @ObjectModel.text.element: ['CargaText']
      Carga,
      CargaText,
      @EndUserText.label: 'Descarga'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' } }]
      @ObjectModel.text.element: ['DescargaText']
      Descarga,
      DescargaText,
      @EndUserText.label: 'Reentrega'
      Reentrega,
      ReentregaCriticality,
      @EndUserText.label: 'Emissão manual'
      Manual,
      ManualCriticality,
      @EndUserText.label: 'Cancelado'
      Cancel,
      CancelCriticality,
      
      @EndUserText.label: 'Nota Externa'
      NfExtrn,
      NfExtrnCriticality,

      @EndUserText.label: 'Moeda'
      SalesDocumentCurrency,
      @EndUserText.label: 'Valor total'
      BR_NFTotalAmount,
      @EndUserText.label: 'Unidade de Medida'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_MDF_NF_EXT_UM', element: 'msehi' } }]
      HeaderWeightUnit,
      HeaderWeightUnitCriticality,
      @EndUserText.label: 'Qtde. liq. total'
      HeaderNetWeight,
      @EndUserText.label: 'Quantidade total'
      HeaderGrossWeight,

      @EndUserText.label: 'Criado por'
      CreatedBy,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Modificado por'
      LastChangedBy,
      @EndUserText.label: 'Modificado em'
      LastChangedAt,
      @EndUserText.label: 'Última modificação'
      LocalLastChangedAt,

      /* navegation */
      @EndUserText.label: 'Ordem de Frete UUID'
      _FreightOrder.TransportationOrderUUID as TransportationOrderUUID,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF

}
