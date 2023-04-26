@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Configuração dos tipos de transportes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_tm_mdf_tipo_transporte
  as select from zttm_mdf_tptrans

  association [0..1] to ZI_CA_VH_EQART      as _Categoria on _Categoria.TipoEquip = $projection.Categoria
  association [0..1] to ZI_CA_VH_XNFE_TPROD as _TpRod     on _TpRod.TpRod = $projection.TpRod
  association [0..1] to ZI_CA_VH_XNFE_TPCAR as _TpCar     on _TpCar.TpCar = $projection.TpCar
{
      @EndUserText.label : 'Tipo do objeto técnico'
  key eqart                 as Categoria,
      _Categoria.Text       as CategoriaText,
      @EndUserText.label : 'Meio de transporte'
      tprod                 as TpRod,
      _TpRod.TpRodText      as TpRodText,
      @EndUserText.label : 'Tipo do reboque'
      tpcar                 as TpCar,
      _TpCar.TpCarText      as TpCarText,

      //Controle
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
