@EndUserText.label: 'Projection Tabela 009'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_TM_PCOCKPIT009
  as projection on ZI_TM_PCOCKPIT009
{
  key Guid,

      @Consumption.valueHelpDefinition: [{ entity: { element: 'mtart', name: 'ZI_TM_VH_TPMATERIAL' } }]
      @ObjectModel.text.element: [ 'TipoMatDesc']
  key TipoMat,
      _TpMat.mtart_txt as TipoMatDesc,
      //       key Categoria,

      /* Associations */
      _Cockpit : redirected to parent ZC_TM_COCKPIT_TAB
}
