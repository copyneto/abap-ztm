@AbapCatalog.sqlViewName: 'ZV_TM_OF_PLACA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Frete: Placas'

// -------------------------------------------------------------
// Placa Caminhão
// -------------------------------------------------------------
define view ZI_TM_VH_ORDEM_FRETE_PLACA
  as select from    /scmtms/d_torrot as FreightOrder

    left outer join /scmtms/d_torite as _Caminhao on  _Caminhao.parent_key = FreightOrder.db_key
                                                  and _Caminhao.item_cat   = 'AVR'

    left outer join ZI_TM_VH_EQUNR   as _Param    on _Param.Equipamento = _Caminhao.platenumber

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                 as FreightOrder,
      FreightOrder.db_key                 as FreightOrderUUID,

      _Caminhao.platenumber               as PlacaCaminhao,
      cast('' as /scmtms/resplatenr )     as PlacaReboque,

      case when _Param.Equipamento is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end as PlacaValidaParam

}
where
      FreightOrder.tor_cat  =  'TO'
  and FreightOrder.tor_id   <> ''
  and _Caminhao.platenumber is not initial

// -------------------------------------------------------------
// Placa Reboque - Trailer 1
// -------------------------------------------------------------

union select from /scmtms/d_torrot as FreightOrder

  left outer join /scmtms/d_torite as _Caminhao on  _Caminhao.parent_key = FreightOrder.db_key
                                                and _Caminhao.item_cat   = 'AVR'

  left outer join ZI_TM_VH_EQUNR   as _Param    on _Param.Equipamento = _Caminhao.ztrailer1

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                 as FreightOrder,
      FreightOrder.db_key                 as FreightOrderUUID,

      cast('' as /scmtms/resplatenr )     as PlacaCaminhao,
      _Caminhao.ztrailer1                 as PlacaReboque,

      case when _Param.Equipamento is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end as PlacaValidaParam

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _Caminhao.ztrailer1  is not initial

// -------------------------------------------------------------
// Placa Reboque - Trailer 2
// -------------------------------------------------------------

union select from /scmtms/d_torrot as FreightOrder

  left outer join /scmtms/d_torite as _Caminhao on  _Caminhao.parent_key = FreightOrder.db_key
                                                and _Caminhao.item_cat   = 'AVR'

  left outer join ZI_TM_VH_EQUNR   as _Param    on _Param.Equipamento = _Caminhao.ztrailer2

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                 as FreightOrder,
      FreightOrder.db_key                 as FreightOrderUUID,

      cast('' as /scmtms/resplatenr )     as PlacaCaminhao,
      _Caminhao.ztrailer2                 as PlacaReboque,

      case when _Param.Equipamento is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end as PlacaValidaParam

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _Caminhao.ztrailer2  is not initial

// -------------------------------------------------------------
// Placa Reboque - Trailer 3
// -------------------------------------------------------------

union select from /scmtms/d_torrot as FreightOrder

  left outer join /scmtms/d_torite as _Caminhao on  _Caminhao.parent_key = FreightOrder.db_key
                                                and _Caminhao.item_cat   = 'AVR'

  left outer join ZI_TM_VH_EQUNR   as _Param    on _Param.Equipamento = _Caminhao.ztrailer3

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                 as FreightOrder,
      FreightOrder.db_key                 as FreightOrderUUID,

      cast('' as /scmtms/resplatenr )     as PlacaCaminhao,
      _Caminhao.ztrailer3                 as PlacaReboque,

      case when _Param.Equipamento is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end as PlacaValidaParam

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _Caminhao.ztrailer3  is not initial

// -------------------------------------------------------------
// Placa Reboque
// -------------------------------------------------------------

union select from /scmtms/d_torrot as FreightOrder

  left outer join /scmtms/d_torite as _Reboque on  _Reboque.parent_key = FreightOrder.db_key
                                               and _Reboque.item_cat   = 'PVR'

  left outer join ZI_TM_VH_EQUNR   as _Param   on _Param.Equipamento = _Reboque.platenumber

{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder.tor_id                 as FreightOrder,
      FreightOrder.db_key                 as FreightOrderUUID,

      cast('' as /scmtms/resplatenr )     as PlacaCaminhao,
      _Reboque.platenumber                as PlacaReboque,

      case when _Param.Equipamento is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end as PlacaValidaParam

}
where
      FreightOrder.tor_cat =  'TO'
  and FreightOrder.tor_id  <> ''
  and _Reboque.platenumber is not initial
