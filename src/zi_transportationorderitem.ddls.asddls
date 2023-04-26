@AbapCatalog.sqlViewName: 'ZITORITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Transportation Order: Items'
define view ZI_TRANSPORTATIONORDERITEM
  as select from /scmtms/d_torite as item
  /* Business Object related Node Associations*/
  association [1..1] to I_TransportationOrder        as _TransportationOrder           on $projection.TransportationOrderUUID = _TransportationOrder.TransportationOrderUUID
  association [1..1] to I_TransportationOrder        as _PredTransportationOrder       on $projection.PredecessorTransportationOrder = _PredTransportationOrder.TransportationOrderUUID
  association [1..1] to ZI_TRANSPORTATIONORDERITEM   as _TranspOrdItemParentItem       on $projection.TranspOrdItemParentItemUUID = _TranspOrdItemParentItem.TransportationOrderItemUUID
  association [0..1] to I_TransportationOrderStop    as _SourceStop                    on $projection.SourceStopUUID = _SourceStop.TransportationOrderStopUUID
  association [0..1] to I_TransportationOrderStop    as _DestinationStop               on $projection.DestinationStopUUID = _DestinationStop.TransportationOrderStopUUID
  association [0..1] to I_BusinessPartner            as _Consignee                     on $projection.Consignee = _Consignee.BusinessPartner
  association [0..1] to I_BusinessPartner            as _Shipper                       on $projection.Shipper = _Shipper.BusinessPartner
  /* Foreign Key and Text Associations */
  association [0..1] to I_TranspOrdItemType          as _TranspOrdItemType             on $projection.TranspOrdItemType = _TranspOrdItemType.TranspOrdItemType
  association [0..1] to I_IsMultiItem                as _IsMultiItem                   on $projection.IsMultiItem = _IsMultiItem.IsMultiItem
  association [0..1] to I_TranspOrdItemCategory      as _TranspOrdItemCategory         on $projection.TranspOrdItemCategory = _TranspOrdItemCategory.TranspOrdItemCategory
  association [0..1] to I_MeansOfTransport           as _MeansOfTransport              on $projection.MeansOfTransport = _MeansOfTransport.MeansOfTransport
  association [0..1] to I_TransportationMode         as _TransportationMode            on $projection.TransportationMode = _TransportationMode.TransportationMode
  association [0..*] to I_TransportationModeText     as _TransportationModeText        on $projection.TransportationMode = _TransportationModeText.TransportationMode
  association [0..1] to I_TransportationModeCategory as _TransportationModeCategory    on $projection.TransportationModeCategory = _TransportationModeCategory.TransportationModeCategory
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemGrossWeightUnit  on $projection.TranspOrdItemGrossWeightUnit = _TranspOrdItemGrossWeightUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemGrossVolumeUnit  on $projection.TranspOrdItemGrossVolumeUnit = _TranspOrdItemGrossVolumeUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemNetWeightUnit    on $projection.TranspOrdItemNetWeightUnit = _TranspOrdItemNetWeightUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemQuantityUnit     on $projection.TranspOrdItemQuantityUnit = _TranspOrdItemQuantityUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemAltvQtyUnit      on $projection.TranspOrdItemAltvQtyUnit = _TranspOrdItemAltvQtyUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemBaseQtyUnit      on $projection.TranspOrdItemBaseQtyUnit = _TranspOrdItemBaseQtyUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemTareWeightUnit   on $projection.TranspOrdItemTareWeightUnit = _TranspOrdItemTareWeightUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemNumberOfCtnsUnit on $projection.TranspOrdItemNumberOfCtnsUnit = _TranspOrdItemNumberOfCtnsUnit.UnitOfMeasure
  association [1..1] to I_UnitOfMeasure              as _TranspOrdItemLengthUnit       on $projection.TranspOrdItemLengthUnit = _TranspOrdItemLengthUnit.UnitOfMeasure
  association [1..1] to I_Currency                   as _GoodsValCurrency              on $projection.TranspOrdItemGoodsValueCrcy = _GoodsValCurrency.Currency
  association [1..1] to I_TransportationGroup        as _TransportationGroup           on $projection.TransportationGroup = _TransportationGroup.TransportationGroup
  association [1..1] to I_MaterialFreightGroup       as _MaterialFreightGroup          on $projection.MaterialFreightGroup = _MaterialFreightGroup.MaterialFreightGroup
  association [1..1] to I_Product                    as _Product                       on $projection.ProductID = _Product.Product
  association [1..1] to I_BusTransDocTypeCode        as _BusTransDocTypeCode           on $projection.TranspOrdDocReferenceType = _BusTransDocTypeCode.BusinessTransactionDocType //----

  association [1..1] to I_Plant                      as _Plant                         on $projection.Plant = _Plant.Plant
  association [1..1] to I_IncotermsClassification    as _IncotermsClassification       on $projection.IncotermsClassification = _IncotermsClassification.IncotermsClassification
{
      /* Header */
      @ObjectModel.text.element:  [ 'TranspOrdItemDesc' ]
  key cast(db_key as /scmtms/toritmuuid preserving type)                                          as TransportationOrderItemUUID,
      @ObjectModel.foreignKey.association: '_TransportationOrder'
      cast(parent_key as /scmtms/vdm_tor_db_key preserving type)                                  as TransportationOrderUUID,
      item_id                                                                                     as TranspOrdItem,
      @ObjectModel.foreignKey.association: '_TranspOrdItemType'
      item_type                                                                                   as TranspOrdItemType,
      @ObjectModel.foreignKey.association: '_IsMultiItem'
      multi_item                                                                                  as IsMultiItem,
      @ObjectModel.foreignKey.association: '_TranspOrdItemParentItem'
      item_parent_key                                                                             as TranspOrdItemParentItemUUID,
      @ObjectModel.foreignKey.association: '_SourceStop'
      src_stop_key                                                                                as SourceStopUUID,
      @ObjectModel.foreignKey.association: '_DestinationStop'
      des_stop_key                                                                                as DestinationStopUUID,
      @Semantics.text: true
      item_descr                                                                                  as TranspOrdItemDesc,
      @ObjectModel.foreignKey.association: '_TranspOrdItemCategory'
      item_cat                                                                                    as TranspOrdItemCategory,
      main_cargo_item                                                                             as IsMainCargoItem,
      @ObjectModel.foreignKey.association: '_PredTransportationOrder'
      ref_root_key                                                                                as PredecessorTransportationOrder,
      @ObjectModel.foreignKey.association: '_Shipper'
      shipper_id                                                                                  as Shipper,
      @ObjectModel.foreignKey.association: '_Consignee'
      consignee_id                                                                                as Consignee,
      @ObjectModel.foreignKey.association: '_TransportationMode'
      //@ObjectModel.text.element: ['TransportationModeDesc']
      mot                                                                                         as TransportationMode,
      @ObjectModel.foreignKey.association: '_TransportationModeText'
      _TransportationModeText[Language = $session.system_language ].TransportationModeDesc        as TransportationModeDesc,
      @ObjectModel.foreignKey.association: '_TransportationModeCategory'
      mot_cat                                                                                     as TransportationModeCategory,
      @ObjectModel.foreignKey.association: '_MeansOfTransport'
      mtr                                                                                         as MeansOfTransport,

      /* Measures */
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemGrossWeightUnit'
      cast(gro_wei_val as /scmtms/vdm_itm_grwgt_val preserving type)                              as TranspOrdItemGrossWeight,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemGrossWeightUnit'
      cast(gro_wei_uni as /scmtms/vdm_itm_grwgt_unit preserving type)                             as TranspOrdItemGrossWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemGrossVolumeUnit'
      cast(gro_vol_val as /scmtms/vdm_itm_grvol_val preserving type)                              as TranspOrdItemGrossVolume,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemGrossVolumeUnit'
      cast(gro_vol_uni as /scmtms/vdm_itm_grvol_unit preserving type)                             as TranspOrdItemGrossVolumeUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemNetWeightUnit'
      cast(net_wei_val as /scmtms/vdm_itm_netwgt_val preserving type)                             as TranspOrdItemNetWeight,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemNetWeightUnit'
      cast(net_wei_uni as /scmtms/vdm_itm_netwgt_unit preserving type)                            as TranspOrdItemNetWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemQuantityUnit'
      cast(qua_pcs_val as /scmtms/vdm_itm_qty_val preserving type)                                as TranspOrdItemQuantity,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemQuantityUnit'
      cast(qua_pcs_uni as /scmtms/vdm_itm_qty_unit preserving type)                               as TranspOrdItemQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemAltvQtyUnit'
      cast(qua_pcs2_val as /scmtms/vdm_itm_qty_alt_val preserving type)                           as TranspOrdItemAltvQty,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemAltvQtyUnit'
      cast(qua_pcs2_uni as /scmtms/vdm_itm_qty_alt_unit preserving type)                          as TranspOrdItemAltvQtyUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemBaseQtyUnit'
      cast(base_uom_val as /scmtms/vdm_itm_base_val preserving type)                              as TranspOrdItemBaseQty,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemBaseQtyUnit'
      cast(base_uom_uni as /scmtms/vdm_itm_base_unit preserving type)                             as TranspOrdItemBaseQtyUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemTareWeightUnit'
      cast(pkgun_wei_val as /scmtms/vdm_itm_tare_wgt_val preserving type)                         as TranspOrdItemTareWeight,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemTareWeightUnit'
      cast(pkgun_wei_uni as /scmtms/vdm_itm_tare_wgt_unit preserving type)                        as TranspOrdItemTareWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemNumberOfCtnsUnit'
      cast(cont_cnt_val as /scmtms/vdm_itm_cont_val preserving type)                              as TranspOrdItemNumberOfCtns,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemNumberOfCtnsUnit'
      cast(cont_cnt_uni as /scmtms/vdm_itm_cont_unit preserving type)                             as TranspOrdItemNumberOfCtnsUnit,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemLengthUnit'
      length                                                                                      as TranspOrdItemLength,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemLengthUnit'
      width                                                                                       as TranspOrdItemWidth,
      @Semantics.quantity.unitOfMeasure: 'TranspOrdItemLengthUnit'
      height                                                                                      as TranspOrdItemHeight,
      @Semantics.unitOfMeasure: true
      @ObjectModel.foreignKey.association: '_TranspOrdItemLengthUnit'
      measuom                                                                                     as TranspOrdItemLengthUnit,
      @Semantics.amount.currencyCode: 'TranspOrdItemGoodsValueCrcy'
      //cast(amt_gdsv_val as /scmtms/amount preserving type ) * 10000                               as TranspOrdItemGoodsValue,
      cast( cast( amt_gdsv_val as abap.dec(31,6) ) * 10000 as abap.curr(31,2) )                   as TranspOrdItemGoodsValue,
      @Semantics.currencyCode: true
      amt_gdsv_cur                                                                                as TranspOrdItemGoodsValueCrcy,
      dgo_indicator                                                                               as TranspOrdItemIsDangerousGood,

      // Product attributes
      prd_frght_grp                                                                               as MaterialFreightGroup,
      // @ObjectModel.foreignKey.association: '_MaterialFreightGroup'
      _MaterialFreightGroup._Text[1:Language = $session.system_language].MaterialFreightGroupName as MaterialFreightGroupName,
      // @ObjectModel.foreignKey.association: '_TransportationGroup'
      prd_transp_grp                                                                              as TransportationGroup,
      _TransportationGroup._Text[1:Language = $session.system_language].TransportationGroupName   as TransportationGroupName,
      // @ObjectModel.foreignKey.association: '_Product'
      product_id                                                                                  as ProductID,
      @ObjectModel.text.element: [ 'ProductID' ]
      _Product._Text[1:Language = $session.system_language].ProductName                           as ProductName,

      _Product.ProductHierarchy                                                                   as ProductHierarchy,
      _Product.ProductGroup                                                                       as ProductGroup,
      _Product.ProductCategory                                                                    as ProductCategory,
      // Reference
      base_btd_id                                                                                 as TranspOrdDocReferenceID,
      base_btditem_id                                                                             as TranspOrdDocReferenceItmID,
      @ObjectModel.foreignKey.association: '_BusTransDocTypeCode'
      base_btd_tco                                                                                as TranspOrdDocReferenceType,
      base_btditem_tco                                                                            as TranspOrdDocReferenceItmType,

      // Supplements for Analytics
      item_sort_id                                                                                as TranspOrdItemSorting,
      cast(shipper_key as /scmtms/vdm_shipper_key preserving type)                                as ShipperUUID,
      cp_address_id                                                                               as ConsigneeAddressID,
      cast(consignee_key as /scmtms/vdm_consignee_key preserving type)                            as ConsigneeUUID,
      prd_key                                                                                     as ProductUUID,

      platenumber                                                                                 as PlateNumber,
      tures_cat                                                                                   as TuresCat,
      tures_tco                                                                                   as TuresTco,
      base_btd_id                                                                                 as BaseBtdId,
      _Shipper.BusinessPartner                                                                    as Motorista,

      @ObjectModel.foreignKey.association: '_IncotermsClassification'
      inc_class_code                                                                              as IncotermsClassification,
      voyage_id                                                                                   as TranspOrdItemVoyage,
      flight_code                                                                                 as TranspOrdItemFlight,
      vessel_id                                                                                   as TranspOrdItemVessel,
      imo_id                                                                                      as TranspOrdItemIMOShip,

      @Semantics.booleanIndicator:true
      amt_hval_car_ind                                                                            as CargoIsHighValue,

      @ObjectModel.foreignKey.association: '_Plant'
      erp_plant_id                                                                                as Plant,
      wm_wh_number                                                                                as TranspOrdItmWhseNmbr,

      /* Associations */
      @ObjectModel.association.type:  [ #TO_COMPOSITION_ROOT ]
      _TransportationOrder,
      @ObjectModel.association.type:  [ #TO_COMPOSITION_PARENT ]
      _TranspOrdItemParentItem,
      _SourceStop,
      _DestinationStop,
      _PredTransportationOrder,
      _Shipper,
      _Consignee,
      _TranspOrdItemType,
      _IsMultiItem,
      _TranspOrdItemCategory,
      _MeansOfTransport,
      _TransportationMode,
      _TransportationModeText,
      _TransportationModeCategory,
      _TranspOrdItemGrossWeightUnit,
      _TranspOrdItemGrossVolumeUnit,
      _TranspOrdItemNetWeightUnit,
      _TranspOrdItemQuantityUnit,
      _TranspOrdItemAltvQtyUnit,
      _TranspOrdItemBaseQtyUnit,
      _TranspOrdItemTareWeightUnit,
      _TranspOrdItemNumberOfCtnsUnit,
      _TranspOrdItemLengthUnit,
      _GoodsValCurrency,
      _BusTransDocTypeCode,

      _Product,
      _MaterialFreightGroup,
      _TransportationGroup,
      _Plant,
      _IncotermsClassification

}
