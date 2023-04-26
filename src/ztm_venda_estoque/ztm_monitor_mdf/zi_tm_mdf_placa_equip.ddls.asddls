@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Placas(Equipamentos)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_PLACA_EQUIP
  as select from equi as Equipamento
  association [0..1] to ZI_TM_VH_EQUNR as _Equi    on _Equi.Equipamento = $projection.Equipamento
  association [0..1] to ZI_CA_VH_EQTYP as _CatEqui on _CatEqui.CategoriaEquip = $projection.CategoriaEquip
  association [0..1] to ZI_CA_VH_EQART as _TipEqui on _TipEqui.TipoEquip = $projection.TipoEquip
{
  key Equipamento.equnr as Equipamento,
      _Equi.Text        as EquipamentoText,
      Equipamento.eqtyp as CategoriaEquip,
      _CatEqui.Text     as CategoriaEquipText,
      Equipamento.eqart as TipoEquip,
      _TipEqui.Text     as TipoEquipText,
      @Semantics.quantity.unitOfMeasure: 'Unidade'
      Equipamento.brgew as Peso,
      Equipamento.gewei as Unidade,
      _Equi.Rntrc       as Rntrc,

      /* associations */
      _Equi,
      _CatEqui,
      _TipEqui

}
