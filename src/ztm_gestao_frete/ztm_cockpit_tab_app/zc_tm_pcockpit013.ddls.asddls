@EndUserText.label: 'Projection Tabela 013'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT013
  as projection on ZI_TM_PCOCKPIT013
{
  key Guid,
  key Guid013,
      Uforig,
      Ufdest,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'branch', name: 'ZI_TM_VH_BRANCH' } }]
      @ObjectModel.text.element: ['TextoRem']
      RemBranch,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'branch', name: 'ZI_TM_VH_BRANCH' } }]
      @ObjectModel.text.element: ['TextoTom']
      TomBranch,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'branch', name: 'ZI_TM_VH_BRANCH' } }]
      @ObjectModel.text.element: ['TextoDest']
      DestBranch,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'branch', name: 'ZI_TM_VH_BRANCH' } }]
      @ObjectModel.text.element: ['TextoRet']
      LocRet,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'branch', name: 'ZI_TM_VH_BRANCH' } }]
      @ObjectModel.text.element: ['TextoEnt']
      LocEnt,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CENARIO' } }]
      @ObjectModel.text.element: ['TextoCenario']
      Cenario,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'CostCenter', name: 'I_CostCenter' } }]
      @ObjectModel.text.element: ['TextoCC']
      Kostl,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'saknr', name: 'ZC_TM_VH_CONTAS_RAZAO' } }]
      //    @ObjectModel.text.element: ['TextoConta']
      Saknr,

      descop,

      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
      TextoCenario,

      TextoRem,
      TextoTom,
      TextoDest,
      TextoRet,
      TextoEnt,
      //     TextoConta,
      TextoCC
}
