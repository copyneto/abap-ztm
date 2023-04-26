@EndUserText.label: 'Projection Tabela 011'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT011
  as projection on ZI_TM_PCOCKPIT011
{
  key Guid,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CENARIO' } }]
      @ObjectModel.text.element: ['TextoCenario']
      @EndUserText.label: 'Cenário/processo'
  key Cenario,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'inco1', name: 'ZI_TM_VH_INCOTERMS' } }]
      @ObjectModel.text.element: ['TextoIncoterms']
      @EndUserText.label: 'Incoterms'
  key Incoterms,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_TPRATEIO' } }]
      @ObjectModel.text.element: ['TextoRateio']
      @EndUserText.label: 'Rateio'
  key Rateio,
      
      TextoCenario,
      TextoRateio,
      TextoIncoterms,
  
      @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
      @ObjectModel.text.element: ['TextoDmwskz']
      @EndUserText.label: 'IVA com ICMS destacado no XML'
      Dmwskz,
      TextoDmwskz,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
      @ObjectModel.text.element: ['TextoPmwskz']
      @EndUserText.label: 'IVA sem ICMS destacado no XML'
      Pmwskz,
      TextoPmwskz,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'IVACode', name: 'ZC_MM_VH_MWSKZ' } }]
      @ObjectModel.text.element: ['TextoGmwskz']
      @EndUserText.label: 'IVA NF sem Produto Acabado'
      Gmwskz,
      TextoGmwskz,
      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB
}
