@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Manutenção de Placas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_CONFIG_PLACA
  as select from zttm_conf_placa

  association [0..1] to ZI_TM_MDF_PLACA_EQUIP as _Equipamento on _Equipamento.Equipamento = $projection.Placa
  association [0..1] to ZI_CA_VH_XNFE_TPROD   as _TpRod       on _TpRod.TpRod = $projection.TpRod
  association [0..1] to ZI_CA_VH_XNFE_TPCAR   as _TpCar       on _TpCar.TpCar = $projection.TpCar
  association [0..1] to ZI_CA_VH_REGIO_BR     as _Regio       on _Regio.Region = $projection.Uf

{
  key placa                           as Placa,
      _Equipamento.EquipamentoText    as Placatext,
      categoriaequip                  as CategoriaEquip,
      _Equipamento.CategoriaEquipText as CategoriaEquipText,
      tipoequip                       as TipoEquip,
      _Equipamento.TipoEquipText      as TipoEquipText,
      renavam                         as Renavam,
      tara                            as Tara,
      capkg                           as CapKg,
      capm3                           as CapM3,
      tprod                           as TpRod,
      _TpRod.TpRodText,
      tpcar                           as TpCar,
      _TpCar.TpCarText,
      uf                              as Uf,
      _Regio.RegionName               as UfName,
      @Semantics.user.createdBy: true
      created_by                      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                 as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                 as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at           as LocalLastChangedAt
}
