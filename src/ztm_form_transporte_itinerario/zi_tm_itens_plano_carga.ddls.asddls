@AbapCatalog.sqlViewName: 'ZVTMITPLANCARG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Plano de carga ordem de frete'
define view ZI_TM_ITENS_PLANO_CARGA
  as select from    /scmtms/d_torrot       as _OrdemFrete
    inner join      /scmtms/d_torite       as _OrdemFreteItem on  _OrdemFreteItem.parent_key      = _OrdemFrete.db_key
                                                              and _OrdemFreteItem.main_cargo_item = 'X'
                                                              and _OrdemFreteItem.base_btd_tco    = '73'
    left outer join I_DeliveryDocument     as _Remessa        on _Remessa.DeliveryDocument = right(
      _OrdemFreteItem.base_btd_id, 10
    )
    left outer join I_DeliveryDocumentItem as _RemessaItem    on  _RemessaItem.DeliveryDocument     = _Remessa.DeliveryDocument
                                                              and _RemessaItem.DeliveryDocumentItem = right(
      _OrdemFreteItem.trq_item_id, 6
    )
    left outer join I_Material             as _Material       on _Material.Material = _OrdemFreteItem.product_id
    left outer join mvke                   as _MaterialSD     on  _MaterialSD.matnr = _OrdemFreteItem.product_id
                                                              and _MaterialSD.vkorg = _Remessa.SalesOrganization
                                                              and _MaterialSD.vtweg = _RemessaItem.DistributionChannel

{
  key _OrdemFrete.db_key                as TransportationOrderKey,
  key _OrdemFreteItem.product_id        as Product,
      _OrdemFrete.tor_id                as TransportationOrder,
      _Remessa.DeliveryDocument         as DeliveryDocument,
      _OrdemFreteItem.item_descr        as ProductDescription,
      _Material.MaterialBaseUnit        as ProductBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'QtyItemUnit'
      _OrdemFreteItem.sales_qty_val     as QtyItem,
      _OrdemFreteItem.sales_qty_uni     as QtyItemUnit,
      _Material.MaterialBaseUnit        as QtyTotalUnit,
      _MaterialSD.schme                 as QtyWholesaleTotalUnit,
      _Material.MaterialBaseUnit        as QtyRetailTotalUnit,
      _Remessa.DeliveryDocument         as Remessa,
      _RemessaItem.DeliveryDocumentItem as RemessaItem,
      @Semantics.quantity.unitOfMeasure: 'GrossWeightUnit'
      _OrdemFreteItem.gro_wei_val       as GrossWeight,
      _OrdemFreteItem.gro_wei_uni       as GrossWeightUnit,
      _Material.MaterialWeightUnit      as GrossWeightTotalUnit,
      _OrdemFreteItem.net_wei_val       as FreightOrderWeight,
      _OrdemFreteItem.net_wei_uni       as FreightOrderWeightUnit



}
where
      _OrdemFrete.tor_cat           =  'TO'
  and _Remessa.DeliveryDocumentType <> 'Y026'
