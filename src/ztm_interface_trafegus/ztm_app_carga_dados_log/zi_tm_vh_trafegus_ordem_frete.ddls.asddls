@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Ordem de Frete Trafegus'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define view entity ZI_TM_VH_TRAFEGUS_ORDEM_FRETE
  as select from zttm_trafegus_l                as Log
    inner join   ZI_CA_VH_ORDEM_FRETE_UUID as _FreightOrder on _FreightOrder.TransportationOrder = Log.tor_id

{
      @Search.ranking: #HIGH
      @Search.defaultSearchElement: true
  key Log.tor_id as TransportationOrder,
      @ObjectModel.text.element: ['TransportationOrderCatDesc']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      _FreightOrder.TransportationOrderCategory,
      _FreightOrder.TransportationOrderCatDesc,
      @ObjectModel.text.element: ['TransportationOrderTypeDesc']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      _FreightOrder.TransportationOrderType,
      _FreightOrder.TransportationOrderTypeDesc,
      @ObjectModel.text.element: ['TranspOrdLifeCycleStatusDesc']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      _FreightOrder.TranspOrdLifeCycleStatus,
      _FreightOrder.TranspOrdLifeCycleStatusDesc,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      _FreightOrder.TransportationOrderUUID

}
group by
  Log.tor_id,
  _FreightOrder.TransportationOrderCategory,
  _FreightOrder.TransportationOrderCatDesc,
  _FreightOrder.TransportationOrderType,
  _FreightOrder.TransportationOrderTypeDesc,
  _FreightOrder.TranspOrdLifeCycleStatus,
  _FreightOrder.TranspOrdLifeCycleStatusDesc,
  _FreightOrder.TransportationOrderUUID
