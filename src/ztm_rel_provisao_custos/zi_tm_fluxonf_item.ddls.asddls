@AbapCatalog.sqlViewName: 'ZITMFDITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de documentos x NF por item'

//bloco 1: cenários de compra de mercadorias (INBOUND MM)
//bloco 2: cenários para vendas (OUTBOUND SD)
//bloco 3: cenário para transferências

/*+[hideWarning] { "IDS" : [ "DOUBLE_JOIN" ]  } */
define view ZI_TM_FLUXONF_ITEM
  as select distinct from ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem
    inner join            A_InbDeliveryDocFlow       as _InboundDocFlow     on  _InboundDocFlow.PrecedingDocument     = right(
      _TransOrdemItem.TranspOrdDocReferenceID, 10
    )
                                                                            and _InboundDocFlow.PrecedingDocumentItem = right(
      _TransOrdemItem.TranspOrdDocReferenceItmID, 6
    )
    inner join            I_BR_NFDocumentFlow_C      as _NFDocFlow          on  _NFDocFlow.PredecessorReferenceDocument = _InboundDocFlow.SubsequentDocument
                                                                            and _NFDocFlow.PredecessorReferenceDocItem  = right(
      _InboundDocFlow.SubsequentDocumentItem, 4
    )
    left outer join       I_DeliveryDocument         as _Remessa            on _Remessa.DeliveryDocument = right(
      _TransOrdemItem.TranspOrdDocReferenceID, 10
    )
    left outer join       I_DeliveryDocumentItem     as _RemessaItem        on  _RemessaItem.DeliveryDocument     = _Remessa.DeliveryDocument
                                                                            and _RemessaItem.DeliveryDocumentItem = right(
      _TransOrdemItem.TranspOrdDocReferenceItmID, 6
    )
    left outer join       ZI_TRANSPORTATIONORDERITEM as _TransOrderItemTruc on  _TransOrderItemTruc.TransportationOrderUUID = _TransOrdemItem.TransportationOrderUUID
                                                                            and _TransOrderItemTruc.TranspOrdItemType       = 'TRUC'
    left outer join       I_BR_NFDocument            as _NotaFiscalHeader   on(
        _NFDocFlow.BR_NotaFiscal                   =  _NotaFiscalHeader.BR_NotaFiscal
        and _NotaFiscalHeader.BR_NFeDocumentStatus =  '1'
        and _NotaFiscalHeader.BR_NFIsCanceled      <> 'X'
        and _NotaFiscalHeader.BR_NFDocumentType    <> '5'
      )

    left outer join       I_BR_NFItem                as _NotaFiscalItem     on  _NotaFiscalItem.BR_NotaFiscal     = _NFDocFlow.BR_NotaFiscal
                                                                            and _NotaFiscalItem.BR_NotaFiscalItem = _NFDocFlow.BR_NotaFiscalItem
    left outer join       ZI_TM_TOTAL_ITENS_NF       as _TotalItensNF       on _NFDocFlow.BR_NotaFiscal = _TotalItensNF.BR_NotaFiscal

    left outer join       C_BR_VerifyNotaFiscal      as _VerifyNF           on _NFDocFlow.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
    left outer join       ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on  _TransOrdemItem.TransportationOrderUUID = _CodigoUnidadeFrete.parent_key
                                                                            and _TransOrdemItem.TranspOrdItem           = _CodigoUnidadeFrete.item_id
    left outer join       ZI_TM_TOTAL_VOLUME         as _TotalVolume        on  _TransOrdemItem.TransportationOrderUUID = _TotalVolume.TransportationOrderUUID
                                                                            and _TransOrdemItem.TranspOrdDocReferenceID = _TotalVolume.TranspOrdDocReferenceID
    left outer join       zttm_cubagem               as _Cubagem            on  _CodigoUnidadeFrete.tor_id        = _Cubagem.unidade_frete
                                                                            and _InboundDocFlow.PrecedingDocument = _Cubagem.remessa
{
  key _InboundDocFlow.PrecedingDocument                                                                                                        as DocReference,
  key _InboundDocFlow.PrecedingDocumentItem                                                                                                    as DocReferenceItem,
      cast( 'Compras' as abap.char( 15 ) )                                                                                                     as Scenario,
      _Remessa.DeliveryDocumentType,
      _Remessa._DeliveryDocumentType._Text[1:Language = $session.system_language].DeliveryDocumentTypeName,
      _Remessa.ShippingPoint,
      _RemessaItem.DistributionChannel,

      _RemessaItem.ReferenceSDDocument                                                                                                         as SalesOrderDocument,
      //cast( ' ' as vgbel )                                                                                  as SalesOrderDocument,

      _RemessaItem.ReferenceSDDocumentItem                                                                                                     as SalesOrderDocumentItem,
      cast( ' ' as salesofficename )                                                                                                           as SalesOfficeName,
      cast( ' ' as sales_order_type )                                                                                                          as SalesOrderType,
      cast( ' ' as kdgrp )                                                                                                                     as CustomerGroup,
      _NotaFiscalHeader.BR_NotaFiscal,
      _NFDocFlow.ReferenceDocument                                                                                                             as InvoiceDocument,
      _NotaFiscalHeader.BR_NFeNumber,
      _NotaFiscalHeader.BR_NFIssueDate,
      _NotaFiscalHeader.BR_NFSeries,
      _NotaFiscalHeader.BR_NFeDocumentStatus,
      _NotaFiscalHeader.BR_NFIsCreatedManually,
      _NotaFiscalHeader.BR_NFTotalAmount,
      _NotaFiscalItem.BR_NFValueAmountWithTaxes,
      _VerifyNF.BR_NFeAccessKey,
      _TransOrdemItem.TransportationOrderUUID,
      _TransOrdemItem._TransportationOrder.TransportationOrder,
      _TransOrdemItem.TransportationOrderItemUUID,
      _TransOrdemItem.TranspOrdItem,
      _TransOrdemItem.SourceStopUUID,
      _TransOrdemItem.DestinationStopUUID,
      _TransOrdemItem.Motorista,
      _TransOrdemItem.ProductName,
      _TransOrdemItem.Consignee,
      right(_TransOrdemItem.TranspOrdDocReferenceID, 10)                                                                                       as TranspOrdDocReferenceID,
      _TransOrdemItem.ProductID,
      _TransOrdemItem._TransportationOrder.CreationDateTime,
      _TransOrdemItem._TransportationOrder.CreatedByUser,
      _TransOrderItemTruc.PlateNumber,
      _TransOrderItemTruc.TuresCat,
      _TransOrderItemTruc.TuresTco,
      _TransOrdemItem._TransportationOrder.TranspOrdMaxUtilznRatio,
      _TransOrdemItem.ProductHierarchy,
      _TransOrdemItem._Consignee.BusinessPartnerName,
      _TransOrdemItem.ProductGroup,
      _TransOrdemItem._TransportationOrder.LastChangedByUser,
      _TransOrdemItem._Product._ProductGroupText[1:Language = $session.system_language].MaterialGroupText,
      _TransOrdemItem._TransportationOrder.TransportationMode,
      _TransOrdemItem._TransportationOrder._TransportationMode._Text[1:Language = $session.system_language].TransportationModeDesc,
      _TransOrdemItem._TransportationOrder.TranspOrdLifeCycleStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus._Text[1:Language = $session.system_language].TranspOrdLifeCycleStatusDesc as TranspOrdLifeCycleStatusText,
      _TransOrdemItem._TransportationOrder.TranspOrdPlanningStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdPlanningStatus._Text[1:Language = $session.system_language].TranspOrdPlanningStatusDesc,
      _TransOrdemItem._TransportationOrder.TransportationOrderType,
      _TransOrdemItem._TransportationOrder._TransportationOrderType._Text[1:Language = $session.system_language].TransportationOrderTypeDesc,
      _TransOrdemItem._TransportationOrder.TranspOrdNetWeight,
      _TransOrdemItem.TranspOrdItemGrossWeight,
      _TransOrdemItem.TranspOrdItemGrossWeightUnit,
      _TransOrdemItem.TranspOrdItemNetWeight,
      _TransOrdemItem.TranspOrdItemNetWeightUnit,
      _TransOrdemItem.IsMainCargoItem,
      _TransOrdemItem.TranspOrdDocReferenceType,
      _TransOrdemItem._TransportationOrder.TransportationOrderExecSts,
      _TransOrdemItem._TransportationOrder._TransportationOrderExecSts._Text[1:Language = $session.system_language].TransportationOrderExecStsDesc,
      _TransOrdemItem.PredecessorTransportationOrder                        as FreghtUnitId,
      _TransOrdemItem._TransportationOrder.PurgOrgCompanyCode               as Company2,
      _TransOrdemItem._TransportationOrder.PurgOrgCompanyCodeAux            as Company,
      _TransOrdemItem._TransportationOrder.CompanyText                      as CompanyDesc,
      _CodigoUnidadeFrete.tor_id                                                                                                               as FreghtUnit,
      _TotalVolume.PesoBrutoTotal,
      _Cubagem.peso_total,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
        * cast(coalesce( _Cubagem.volume, 0.00 ) as float)                                                                                     as VolumeCubadoEcom,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.peso_total, 0.00 ) as float)                                                                                   as PesoBrutoEcom,
      _TotalItensNF.TotalItensNF

}
where
      _TransOrdemItem.TranspOrdDocReferenceType = '58'
  --and _TransOrdemItem.TranspOrdItemType         = 'PRD'
  and _TransOrdemItem.TranspOrdItemCategory     = 'PRD'

union

select from       ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem
  inner join      I_DeliveryDocument         as _Remessa            on _Remessa.DeliveryDocument = right(
    _TransOrdemItem.TranspOrdDocReferenceID, 10
  )
  inner join      I_DeliveryDocumentItem     as _RemessaItem        on  _RemessaItem.DeliveryDocument      =  _Remessa.DeliveryDocument
                                                                    and _RemessaItem.DeliveryDocumentItem  = right(
    _TransOrdemItem.TranspOrdDocReferenceItmID, 6
  )
                                                                    and _RemessaItem.ItemIsBillingRelevant <> ' '
  left outer join I_BR_NFDocumentFlow_C      as _NFDocFlow2         on  _NFDocFlow2.PredecessorReferenceDocument = _RemessaItem.DeliveryDocument
                                                                    and _NFDocFlow2.PredecessorReferenceDocItem  = _RemessaItem.DeliveryDocumentItem
  left outer join ZI_TRANSPORTATIONORDERITEM as _TransOrderItemTruc on  _TransOrderItemTruc.TransportationOrderUUID = _TransOrdemItem.TransportationOrderUUID
                                                                    and _TransOrderItemTruc.TranspOrdItemType       = 'TRUC'
  left outer join I_BR_NFDocument            as _NotaFiscalHeader   on  _NFDocFlow2.BR_NotaFiscal              =  _NotaFiscalHeader.BR_NotaFiscal
                                                                    and _NotaFiscalHeader.BR_NFeDocumentStatus =  '1'
                                                                    and _NotaFiscalHeader.BR_NFIsCanceled      <> 'X'
                                                                    and _NotaFiscalHeader.BR_NFDocumentType    <> '5'
  left outer join I_BR_NFItem                as _NotaFiscalItem     on  _NotaFiscalItem.BR_NotaFiscal     = _NFDocFlow2.BR_NotaFiscal
                                                                    and _NotaFiscalItem.BR_NotaFiscalItem = _NFDocFlow2.BR_NotaFiscalItem
  left outer join ZI_TM_TOTAL_ITENS_NF       as _TotalItensNF       on _NFDocFlow2.BR_NotaFiscal = _TotalItensNF.BR_NotaFiscal
  left outer join C_BR_VerifyNotaFiscal      as _VerifyNF           on _NFDocFlow2.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
  left outer join ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on  _TransOrdemItem.TransportationOrderUUID = _CodigoUnidadeFrete.parent_key
                                                                    and _TransOrdemItem.TranspOrdItem           = _CodigoUnidadeFrete.item_id
  left outer join ZI_TM_TOTAL_VOLUME         as _TotalVolume        on  _TransOrdemItem.TransportationOrderUUID = _TotalVolume.TransportationOrderUUID
                                                                    and _TransOrdemItem.TranspOrdDocReferenceID = _TotalVolume.TranspOrdDocReferenceID
  left outer join zttm_cubagem               as _Cubagem            on  _CodigoUnidadeFrete.tor_id = _Cubagem.unidade_frete
                                                                    and _Remessa.DeliveryDocument  = _Cubagem.remessa
  left outer join I_SalesOrder               as _SalesOrder         on _SalesOrder.SalesOrder = _RemessaItem.ReferenceSDDocument

{
  key _Remessa.DeliveryDocument                                                                                                                as DocReference,
  key _RemessaItem.DeliveryDocumentItem                                                                                                        as DocReferenceItem,
      cast( 'Vendas' as abap.char( 15 ) )                                                                                                      as Scenario,
      _Remessa.DeliveryDocumentType,
      _Remessa._DeliveryDocumentType._Text[1:Language = $session.system_language].DeliveryDocumentTypeName,
      _Remessa.ShippingPoint,
      _RemessaItem.DistributionChannel,
      _RemessaItem.ReferenceSDDocument                                                                                                         as SalesOrderDocument,
      _RemessaItem.ReferenceSDDocumentItem                                                                                                     as SalesOrderDocumentItem,
      _SalesOrder._SalesOffice._Text[1:Language = $session.system_language].SalesOfficeName,
      _SalesOrder.SalesOrderType,
      _SalesOrder.CustomerGroup,
      _NotaFiscalHeader.BR_NotaFiscal,
      _NFDocFlow2.ReferenceDocument                                                                                                            as InvoiceDocument,
      _NotaFiscalHeader.BR_NFeNumber,
      _NotaFiscalHeader.BR_NFIssueDate,
      _NotaFiscalHeader.BR_NFSeries,
      _NotaFiscalHeader.BR_NFeDocumentStatus,
      _NotaFiscalHeader.BR_NFIsCreatedManually,
      _NotaFiscalHeader.BR_NFTotalAmount,
      _NotaFiscalItem.BR_NFValueAmountWithTaxes,
      _VerifyNF.BR_NFeAccessKey,
      _TransOrdemItem.TransportationOrderUUID,
      _TransOrdemItem._TransportationOrder.TransportationOrder,
      _TransOrdemItem.TransportationOrderItemUUID,
      _TransOrdemItem.TranspOrdItem,
      _TransOrdemItem.SourceStopUUID,
      _TransOrdemItem.DestinationStopUUID,
      _TransOrdemItem.Motorista,
      _TransOrdemItem.ProductName,
      _TransOrdemItem.Consignee,
      right( _TransOrdemItem.TranspOrdDocReferenceID, 10 )                                                                                     as TranspOrdDocReferenceID,
      _TransOrdemItem.ProductID,
      _TransOrdemItem._TransportationOrder.CreationDateTime,
      _TransOrdemItem._TransportationOrder.CreatedByUser,
      _TransOrderItemTruc.PlateNumber,
      _TransOrderItemTruc.TuresCat,
      _TransOrderItemTruc.TuresTco,
      _TransOrdemItem._TransportationOrder.TranspOrdMaxUtilznRatio,
      _TransOrdemItem.ProductHierarchy,
      _TransOrdemItem._Consignee.BusinessPartnerName,
      _TransOrdemItem.ProductGroup,
      _TransOrdemItem._TransportationOrder.LastChangedByUser,
      _TransOrdemItem._Product._ProductGroupText[1:Language = $session.system_language].MaterialGroupText,
      _TransOrdemItem._TransportationOrder.TransportationMode,
      _TransOrdemItem._TransportationOrder._TransportationMode._Text[1:Language = $session.system_language].TransportationModeDesc,
      _TransOrdemItem._TransportationOrder.TranspOrdLifeCycleStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus._Text[1:Language = $session.system_language].TranspOrdLifeCycleStatusDesc as TranspOrdLifeCycleStatusText,
      _TransOrdemItem._TransportationOrder.TranspOrdPlanningStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdPlanningStatus._Text[1:Language = $session.system_language].TranspOrdPlanningStatusDesc,
      _TransOrdemItem._TransportationOrder.TransportationOrderType,
      _TransOrdemItem._TransportationOrder._TransportationOrderType._Text[1:Language = $session.system_language].TransportationOrderTypeDesc,
      _TransOrdemItem._TransportationOrder.TranspOrdNetWeight,
      _TransOrdemItem.TranspOrdItemGrossWeight,
      _TransOrdemItem.TranspOrdItemGrossWeightUnit,
      _TransOrdemItem.TranspOrdItemNetWeight,
      _TransOrdemItem.TranspOrdItemNetWeightUnit,
      _TransOrdemItem.IsMainCargoItem,
      _TransOrdemItem.TranspOrdDocReferenceType,
      _TransOrdemItem._TransportationOrder.TransportationOrderExecSts,
      _TransOrdemItem._TransportationOrder._TransportationOrderExecSts._Text[1:Language = $session.system_language].TransportationOrderExecStsDesc,
      _TransOrdemItem.PredecessorTransportationOrder                        as FreghtUnitId,
      _TransOrdemItem._TransportationOrder.PurgOrgCompanyCode               as Company2,
      _TransOrdemItem._TransportationOrder.PurgOrgCompanyCodeAux            as Company,
      _TransOrdemItem._TransportationOrder.CompanyText                      as CompanyDesc,
      _CodigoUnidadeFrete.tor_id                                            as FreghtUnit,
      _TotalVolume.PesoBrutoTotal,
      _Cubagem.peso_total,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.volume, 0.00 ) as float)                                                                                       as VolumeCubadoEcom,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.peso_total, 0.00 ) as float)                                                                                   as PesoBrutoEcom,
      _TotalItensNF.TotalItensNF
}
where
      _TransOrdemItem.TranspOrdDocReferenceType = '73'
  //and _TransOrdemItem.TranspOrdItemType         = 'PRD'
  and _TransOrdemItem.TranspOrdItemCategory     = 'PRD'

union

select from       ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem
  inner join      I_DeliveryDocument         as _Remessa            on _Remessa.DeliveryDocument = right(
    _TransOrdemItem.BaseBtdId, 10
  )
  inner join      I_DeliveryDocumentItem     as _RemessaItem        on  _RemessaItem.DeliveryDocument      =  _Remessa.DeliveryDocument
                                                                    and _RemessaItem.DeliveryDocumentItem  = right(
    _TransOrdemItem.TranspOrdDocReferenceItmID, 6
  )
                                                                    and _RemessaItem.ItemIsBillingRelevant <> ' '
  left outer join ZI_TRANSPORTATIONORDERITEM as _TransOrderItemTruc on  _TransOrderItemTruc.TransportationOrderUUID = _TransOrdemItem.TransportationOrderUUID
                                                                    and _TransOrderItemTruc.TranspOrdItemType       = 'TRUC'
  left outer join ZI_TM_TOTAL_ITENS_NF       as _TotalItensNF       on _RemessaItem.ReferenceSDDocument = _TotalItensNF.PurchaseOrder
  left outer join I_BR_NFItem                as _NotaFiscalItem     on  _NotaFiscalItem.PurchaseOrder     = _RemessaItem.ReferenceSDDocument
                                                                    and _NotaFiscalItem.PurchaseOrderItem = right(
    _RemessaItem.ReferenceSDDocumentItem, 5
  )
  left outer join I_BR_NFDocument            as _NotaFiscalHeader   on  _NotaFiscalItem.BR_NotaFiscal          =  _NotaFiscalHeader.BR_NotaFiscal
                                                                    and _NotaFiscalHeader.BR_NFeDocumentStatus =  '1'
                                                                    and _NotaFiscalHeader.BR_NFDirection       =  '2'
                                                                    and _NotaFiscalHeader.BR_NFIsCanceled      <> 'X'
                                                                    and _NotaFiscalHeader.BR_NFDocumentType    <> '5'
  left outer join I_BR_NFDocumentFlow_C      as _NFDocFlow          on _NFDocFlow.BR_NotaFiscal = _NotaFiscalHeader.BR_NotaFiscal
  left outer join C_BR_VerifyNotaFiscal      as _VerifyNF           on _NotaFiscalItem.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
  left outer join ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on  _TransOrdemItem.TransportationOrderUUID = _CodigoUnidadeFrete.parent_key
                                                                    and _TransOrdemItem.TranspOrdItem           = _CodigoUnidadeFrete.item_id
  left outer join ZI_TM_TOTAL_VOLUME         as _TotalVolume        on  _TransOrdemItem.TransportationOrderUUID = _TotalVolume.TransportationOrderUUID
                                                                    and _TransOrdemItem.TranspOrdDocReferenceID = _TotalVolume.TranspOrdDocReferenceID
  left outer join zttm_cubagem               as _Cubagem            on  _CodigoUnidadeFrete.tor_id = _Cubagem.unidade_frete
                                                                    and _Remessa.DeliveryDocument  = _Cubagem.remessa
  left outer join I_SalesOrder               as _SalesOrder         on _SalesOrder.SalesOrder = _RemessaItem.ReferenceSDDocument
{
  key _Remessa.DeliveryDocument                                                                                                                as DocReference,
  key _RemessaItem.DeliveryDocumentItem                                                                                                        as DocReferenceItem,
      cast( 'Transferência' as abap.char( 15 ) )                                                                                               as Scenario,
      _Remessa.DeliveryDocumentType,
      _Remessa._DeliveryDocumentType._Text[1:Language = $session.system_language].DeliveryDocumentTypeName,
      _Remessa.ShippingPoint,
      _RemessaItem.DistributionChannel,

      _RemessaItem.ReferenceSDDocument                                                                                                         as SalesOrderDocument,
      //cast( ' ' as vgbel )                                                                                   as SalesOrderDocument,

      _RemessaItem.ReferenceSDDocumentItem                                                                                                     as SalesOrderDocumentItem,
      _SalesOrder._SalesOffice._Text[1:Language = $session.system_language].SalesOfficeName,
      _SalesOrder.SalesOrderType,
      _SalesOrder.CustomerGroup,
      //_NotaFiscalItem.BR_NotaFiscal,
      _NotaFiscalHeader.BR_NotaFiscal,
      _NFDocFlow.ReferenceDocument                                                                                                             as InvoiceDocument,
      _NotaFiscalHeader.BR_NFeNumber,
      _NotaFiscalHeader.BR_NFIssueDate,
      _NotaFiscalHeader.BR_NFSeries,
      _NotaFiscalHeader.BR_NFeDocumentStatus,
      _NotaFiscalHeader.BR_NFIsCreatedManually,
      _NotaFiscalHeader.BR_NFTotalAmount,
      _NotaFiscalItem.BR_NFValueAmountWithTaxes,
      _VerifyNF.BR_NFeAccessKey,
      _TransOrdemItem.TransportationOrderUUID,
      _TransOrdemItem._TransportationOrder.TransportationOrder,
      _TransOrdemItem.TransportationOrderItemUUID,
      _TransOrdemItem.TranspOrdItem,
      _TransOrdemItem.SourceStopUUID,
      _TransOrdemItem.DestinationStopUUID,
      _TransOrdemItem.Motorista,
      _TransOrdemItem.ProductName,
      _TransOrdemItem.Consignee,
      right(_TransOrdemItem.TranspOrdDocReferenceID, 10)                                                                                       as TranspOrdDocReferenceID,
      _TransOrdemItem.ProductID,
      _TransOrdemItem._TransportationOrder.CreationDateTime,
      _TransOrdemItem._TransportationOrder.CreatedByUser,
      _TransOrderItemTruc.PlateNumber,
      _TransOrderItemTruc.TuresCat,
      _TransOrderItemTruc.TuresTco,
      _TransOrdemItem._TransportationOrder.TranspOrdMaxUtilznRatio,
      _TransOrdemItem.ProductHierarchy,
      _TransOrdemItem._Consignee.BusinessPartnerName,
      _TransOrdemItem.ProductGroup,
      _TransOrdemItem._TransportationOrder.LastChangedByUser,
      _TransOrdemItem._Product._ProductGroupText[1:Language = $session.system_language].MaterialGroupText,
      _TransOrdemItem._TransportationOrder.TransportationMode,
      _TransOrdemItem._TransportationOrder._TransportationMode._Text[1:Language = $session.system_language].TransportationModeDesc,
      _TransOrdemItem._TransportationOrder.TranspOrdLifeCycleStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus._Text[1:Language = $session.system_language].TranspOrdLifeCycleStatusDesc as TranspOrdLifeCycleStatusText,
      _TransOrdemItem._TransportationOrder.TranspOrdPlanningStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdPlanningStatus._Text[1:Language = $session.system_language].TranspOrdPlanningStatusDesc,
      _TransOrdemItem._TransportationOrder.TransportationOrderType,
      _TransOrdemItem._TransportationOrder._TransportationOrderType._Text[1:Language = $session.system_language].TransportationOrderTypeDesc,
      _TransOrdemItem._TransportationOrder.TranspOrdNetWeight,
      _TransOrdemItem.TranspOrdItemGrossWeight,
      _TransOrdemItem.TranspOrdItemGrossWeightUnit,
      _TransOrdemItem.TranspOrdItemNetWeight,
      _TransOrdemItem.TranspOrdItemNetWeightUnit,
      _TransOrdemItem.IsMainCargoItem,
      _TransOrdemItem.TranspOrdDocReferenceType,
      _TransOrdemItem._TransportationOrder.TransportationOrderExecSts,
      _TransOrdemItem._TransportationOrder._TransportationOrderExecSts._Text[1:Language = $session.system_language].TransportationOrderExecStsDesc,
      _TransOrdemItem.PredecessorTransportationOrder                        as FreghtUnitId,
      _TransOrdemItem._TransportationOrder.PurgOrgCompanyCode               as Company2,
      _TransOrdemItem._TransportationOrder.PurgOrgCompanyCodeAux            as Company,
      _TransOrdemItem._TransportationOrder.CompanyText                      as CompanyDesc,      
      _CodigoUnidadeFrete.tor_id                                            as FreghtUnit,
      _TotalVolume.PesoBrutoTotal,
      _Cubagem.peso_total,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.volume, 0.00 ) as float)                                                                                       as VolumeCubadoEcom,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.peso_total, 0.00 ) as float)                                                                                   as PesoBrutoEcom,
      _TotalItensNF.TotalItensNF
}
where
      _Remessa.DeliveryDocumentType             = 'ZNLC' //Transferencia
  and _TransOrdemItem.TranspOrdDocReferenceType = '73'   //Saída (outbound)
  //and _TransOrdemItem.TranspOrdItemType         = 'PRD'
  and _TransOrdemItem.TranspOrdItemCategory     = 'PRD'
