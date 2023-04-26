@EndUserText.label: 'Informações MDF-e : Dados Complementares'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_COMPLEMENTO
  as projection on ZI_TM_MDF_COMPLEMENTO
{
  key Id,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @ObjectModel.text.element: ['UfText']
      @EndUserText.label: 'UF'
      Uf,
      @EndUserText.label: 'UF'
      _Regio.RegionName      as UfText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPAMB', element: 'TpAmb' } }]
      @ObjectModel.text.element: ['TpAmbText']
      @EndUserText.label: 'Ambiente de Sistema'
      TpAmb,
      @EndUserText.label: 'Ambiente de Sistema'
      _TpAmb.TpAmbText       as TpAmbText,
      TpAmbCriticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPEMIT', element: 'TpEmit' } }]
      @ObjectModel.text.element: ['TpEmitText']
      @EndUserText.label: 'Tipo de Emitente'
      TpEmit,
      @EndUserText.label: 'Tipo de Emitente'
      _TpEmit.TpEmitText     as TpEmitText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPTRANSP', element: 'TpTransp' } }]
      @ObjectModel.text.element: ['TpTranspText']
      @EndUserText.label: 'Tipo de Transportadora'
      TpTransp,
      @EndUserText.label: 'Tipo de Transportadora'
      _TpTransp.TpTranspText as TpTranspText,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_MOD', element: 'Mod' } }]
      @ObjectModel.text.element: ['ModText']
      @EndUserText.label: 'Modelo MDF-e'
      Mod,
      @EndUserText.label: 'Modelo MDF-e'
      _Mod.ModText           as ModText,
      @EndUserText.label: 'Nº Aleatório'
      CMdf,
      @EndUserText.label: 'Dígito Verificador'
      CDv,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_MODAL', element: 'Modal' } }]
      @ObjectModel.text.element: ['ModalText']
      @EndUserText.label: 'Tipo de Transporte'
      Modal,
      @EndUserText.label: 'Tipo de Transporte'
      _Modal.ModalText       as ModalText,
      @EndUserText.label: 'Data/Hora da Emissão'
      DhEmi,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_XNFE_TPEMIS', element: 'TpEmis' } }]
      @ObjectModel.text.element: ['TpEmisText']
      @EndUserText.label: 'Tipo de emissão'
      TpEmis,
      @EndUserText.label: 'Tipo de emissão'
      _TpEmis.TpEmisText     as TpEmisText,
      TpEmisCriticality,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF,
      _TpAmb
}
