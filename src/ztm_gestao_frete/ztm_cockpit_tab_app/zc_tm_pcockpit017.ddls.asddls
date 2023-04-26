@EndUserText.label: 'Projection Tabela 017'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT017
  as projection on ZI_TM_PCOCKPIT017
{
  key Guid,
  key Guid17,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'bsart', name: 'ZI_TM_VH_TPDOCCOMP' } }]
      @ObjectModel.text.element: ['TextoTpDocComp']
  key Bsart,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'ekgrp', name: 'ZI_TM_VH_GRP_COMPRADORES' } }]
      @ObjectModel.text.element: ['TextoGrp']
      Ekgrp,
      @Consumption.valueHelpDefinition: [{ entity: { element: 'mtart', name: 'ZI_TM_VH_TPMATERIAL' } }]
      @ObjectModel.text.element: ['TextoTpMat']
      Mtart,
      FornExt,
      EmpGrupo,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'DomvalueL', name: 'ZI_TM_VH_ID_CENARIO' } }]
      @ObjectModel.text.element: ['TextoCenario']
      Operacao,
      tipooperacao,
      manual,
      iva,
      icms_xml,
      
      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB,
      TextoCenario,
      TextoGrp,
      TextoTpDocComp,
      TextoTpMat
}
