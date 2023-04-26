@AbapCatalog.sqlViewName: 'ZITMDFFFLOW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'TM - Fluxo documento de faturamento de frete'

//bloco 1: cenários para vendas (OUTBOUND SD) e cenário para transferências
//bloco 2: cenários de compra de mercadorias (INBOUND MM)

define view ZI_TM_DFF_FLOW
  as select distinct from I_TransportationOrder      as _TransportationOrdem
    inner join            ZI_TRANSPORTATIONORDERITEM as _TransportationOrdemItem on  _TransportationOrdemItem.TransportationOrderUUID   = _TransportationOrdem.TransportationOrderUUID
                                                                                 and _TransportationOrdemItem.TranspOrdDocReferenceType = '73' //Remessa
    inner join            I_DeliveryDocumentItem     as _DeliveryItem            on  _DeliveryItem.DeliveryDocument      = right(
      _TransportationOrdemItem.BaseBtdId, 10
    )
                                                                                 and _DeliveryItem.DeliveryDocumentItem  = right(
      _TransportationOrdemItem.TranspOrdDocReferenceItmID, 6
    )
                                                                                 and _DeliveryItem.ItemIsBillingRelevant <> ' '
    left outer join       /scmtms/d_tcditm           as _ChargeDistributionItem  on _ChargeDistributionItem.orig_ref_root = _TransportationOrdemItem.TranspOrdDocReferenceKey
    inner join            /scmtms/d_tcdrot           as _ChargeDistribution      on _ChargeDistribution.db_key = _ChargeDistributionItem.parent_key
    inner join            /scmtms/d_sf_rot           as _DFFDocument             on _DFFDocument.db_key = _ChargeDistribution.host_key
    left outer join       /scmtms/d_sf_doc           as _ServiceDocument         on  _ServiceDocument.parent_key     = _DFFDocument.db_key
                                                                                 and _ServiceDocument.btd_tco        = '56' //Folha de serviço
                                                                                 and _ServiceDocument.fsd_btd_status = '01' //Ativo
    left outer join       eskn                       as _ServiceDocumentData     on _ServiceDocumentData.packno = _ServiceDocument.btd_id
    left outer join       /scmtms/d_sf_doc           as _FreightPurchaseOrder    on  _FreightPurchaseOrder.parent_key     = _DFFDocument.db_key
                                                                                 and _FreightPurchaseOrder.btd_tco        = '001' //Pedido de compras
                                                                                 and _FreightPurchaseOrder.fsd_btd_status = '01' //Ativo
    left outer join       I_CostCenterText           as _CostCenterName          on  _CostCenterName.ControllingArea = 'AC3C'
                                                                                 and _CostCenterName.CostCenter      = _ServiceDocumentData.kostl
                                                                                 and _CostCenterName.Language        = $session.system_language
                                                                                 and _CostCenterName.ValidityEndDate = '99991231'
    left outer join       I_GLAccountTextRawData     as _AccountText             on  _AccountText.Language        = $session.system_language
                                                                                 and _AccountText.ChartOfAccounts = 'PC3C'
                                                                                 and _AccountText.GLAccount       = _ServiceDocumentData.sakto
    left outer join       rseg                       as _InvoiceDocumentItem     on _InvoiceDocumentItem.ebeln = _FreightPurchaseOrder.btd_id
    left outer join       I_SupplierInvoice          as _InvoiceDocument         on  _InvoiceDocument.SupplierInvoice = _InvoiceDocumentItem.belnr
                                                                                 and _InvoiceDocument.FiscalYear      = _InvoiceDocumentItem.gjahr

{
  key _TransportationOrdem.TransportationOrderUUID            as TransportationOrderId,
  key _TransportationOrdemItem.TransportationOrderItemUUID    as TransportationOrderItemId,
  key _DFFDocument.db_key                                     as DFFDocumentId,
      cast( 'Vendas/Transferência' as abap.char( 20 ) )       as Scenario,
      _TransportationOrdem.TransportationOrder                as TransportationOrder,
      _TransportationOrdemItem.TranspOrdItem                  as TransportationOrderItem,
      _DeliveryItem.DeliveryDocument,
      _DeliveryItem.DeliveryDocumentItem,
      _DFFDocument.sfir_id                                    as DFFDocument,
      _DFFDocument.sfir_type                                  as DFFDocumentType,
      _DFFDocument.sfir_category                              as DFFDocumentCategory,
      cast ( right( _ServiceDocument.btd_id, 10 ) as packno ) as ServiceDocument,
      _ServiceDocumentData.sakto                              as ServiceDocumentAccount,
      _AccountText.GLAccountLongName                          as ServiceDocumentAccountName,
      _ServiceDocumentData.kostl                              as ServiceDocumentCostCenter,
      _CostCenterName.CostCenterDescription                   as ServiceDocumentCostCenterName,
      cast( _FreightPurchaseOrder.btd_id as ebeln )           as FreightPurchaseOrder,
      _DFFDocument.lifecycle                                  as DFFDocumentLifeCycle,
      _InvoiceDocument.SupplierInvoice,
      _InvoiceDocument.FiscalYear,
      _InvoiceDocument.ReverseDocument
}
where
  (
        _InvoiceDocument.ReverseDocument = ''
    and _InvoiceDocumentItem.belnr       is not null
  )
  or    _InvoiceDocumentItem.belnr       is null

union

select distinct from I_TransportationOrder      as _TransportationOrdem
  inner join         ZI_TRANSPORTATIONORDERITEM as _TransportationOrdemItem on  _TransportationOrdemItem.TransportationOrderUUID   = _TransportationOrdem.TransportationOrderUUID
                                                                            and _TransportationOrdemItem.TranspOrdDocReferenceType = '58' //Recebimento
  left outer join    /scmtms/d_tcditm           as _ChargeDistributionItem  on _ChargeDistributionItem.orig_ref_root = _TransportationOrdemItem.TranspOrdDocReferenceKey //_TransportationOrdemItem.TranspOrigRefRoot
  inner join         /scmtms/d_tcdrot           as _ChargeDistribution      on _ChargeDistribution.db_key = _ChargeDistributionItem.parent_key
  inner join         /scmtms/d_sf_rot           as _DFFDocument             on _DFFDocument.db_key = _ChargeDistribution.host_key
  left outer join    /scmtms/d_sf_doc           as _ServiceDocument         on  _ServiceDocument.parent_key     = _DFFDocument.db_key
                                                                            and _ServiceDocument.btd_tco        = '56'      //Folha de serviço
                                                                            and _ServiceDocument.fsd_btd_status = '01'      //Ativo
  left outer join    eskn                       as _ServiceDocumentData     on _ServiceDocumentData.packno = _ServiceDocument.btd_id
  left outer join    /scmtms/d_sf_doc           as _FreightPurchaseOrder    on  _FreightPurchaseOrder.parent_key     = _DFFDocument.db_key
                                                                            and _FreightPurchaseOrder.btd_tco        = '001' //Pedido de compras
                                                                            and _FreightPurchaseOrder.fsd_btd_status = '01' //Ativo
  left outer join    I_CostCenterText           as _CostCenterName          on  _CostCenterName.ControllingArea = 'AC3C'
                                                                            and _CostCenterName.CostCenter      = _ServiceDocumentData.kostl
                                                                            and _CostCenterName.Language        = $session.system_language
                                                                            and _CostCenterName.ValidityEndDate = '99991231'
  left outer join    I_GLAccountTextRawData     as _AccountText             on  _AccountText.Language        = $session.system_language
                                                                            and _AccountText.ChartOfAccounts = 'PC3C'
                                                                            and _AccountText.GLAccount       = _ServiceDocumentData.sakto
  left outer join    rseg                       as _InvoiceDocumentItem     on _InvoiceDocumentItem.ebeln = _FreightPurchaseOrder.btd_id
  left outer join    I_SupplierInvoice          as _InvoiceDocument         on  _InvoiceDocument.SupplierInvoice = _InvoiceDocumentItem.belnr
                                                                            and _InvoiceDocument.FiscalYear      = _InvoiceDocumentItem.gjahr

{
  key _TransportationOrdem.TransportationOrderUUID            as TransportationOrderId,
  key _TransportationOrdemItem.TransportationOrderItemUUID    as TransportationOrderItemId,
  key _DFFDocument.db_key                                     as DFFDocumentId,
      cast( 'Compras' as abap.char( 20 ) )                    as Scenario,
      _TransportationOrdem.TransportationOrder                as TransportationOrder,
      _TransportationOrdemItem.TranspOrdItem                  as TransportationOrderItem,
      cast( ' ' as vbeln_vl )                                 as DeliveryDocument,
      cast( '000000' as posnr_vl )                            as DeliveryDocumentItem,
      _DFFDocument.sfir_id                                    as DFFDocument,
      _DFFDocument.sfir_type                                  as DFFDocumentType,
      _DFFDocument.sfir_category                              as DFFDocumentCategory,
      cast ( right( _ServiceDocument.btd_id, 10 ) as packno ) as ServiceDocument,
      _ServiceDocumentData.sakto                              as ServiceDocumentAccount,
      _AccountText.GLAccountLongName                          as ServiceDocumentAccountName,
      _ServiceDocumentData.kostl                              as ServiceDocumentCostCenter,
      _CostCenterName.CostCenterDescription                   as ServiceDocumentCostCenterName,
      cast( _FreightPurchaseOrder.btd_id as ebeln )           as FreightPurchaseOrder,
      _DFFDocument.lifecycle                                  as DFFDocumentLifeCycle,
      _InvoiceDocument.SupplierInvoice,
      _InvoiceDocument.FiscalYear,
      _InvoiceDocument.ReverseDocument
}
where
  (
        _InvoiceDocument.ReverseDocument = ''
    and _InvoiceDocumentItem.belnr       is not null
  )
  or    _InvoiceDocumentItem.belnr       is null
