@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Recupera Equipamento e Reboque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GET_PLATENUMBER
  as select from    /scmtms/d_torrot as FreightOrder

    left outer join /scmtms/d_torite as _Caminhao on  _Caminhao.parent_key = FreightOrder.db_key
                                                  and _Caminhao.item_cat   = 'AVR'

    left outer join /scmtms/d_torite as _Reboque  on  _Reboque.parent_key = FreightOrder.db_key
                                                  and _Reboque.item_cat   = 'PVR'

    left outer join ZI_TM_VH_EQUNR   as _Param    on _Param.Equipamento = _Caminhao.platenumber

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                 as FreightOrder,
      FreightOrder.db_key                 as FreightOrderUUID,

      _Caminhao.platenumber               as PlacaCaminhao,
      _Reboque.platenumber                as PlacaReboque,

      case when _Param.Equipamento is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end as PlacaValidaParam

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
