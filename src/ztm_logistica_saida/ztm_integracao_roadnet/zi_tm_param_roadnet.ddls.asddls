@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros de Entrada para Roadnet'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_PARAM_ROADNET
  as select from zttm_road_sessio

  association [0..1] to ZI_CA_VH_WERKS as _centro on _centro.WerksCode = $projection.centro

{
  key werks                 as centro,
  key dtsession             as session_data,
      id_session_roadnet    as session_id,
      total_route_id        as total_route_id,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* Association */
      _centro
}
