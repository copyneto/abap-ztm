@AbapCatalog.sqlViewName: 'ZITMFD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de documentos x NF'

//bloco 1: cenários de compra de mercadorias (INBOUND MM)
//bloco 2: cenários para vendas (OUTBOUND SD)
//bloco 3: cenário para transferências

define view ZI_TM_FLUXONF
  as select distinct from ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem
    inner join            A_InbDeliveryDocFlow       as _InboundDocFlow     on _InboundDocFlow.PrecedingDocument = right(
      _TransOrdemItem.BaseBtdId, 10
    )

    inner join            I_BR_NFDocumentFlow_C      as _NFDocFlow          on  _NFDocFlow.PredecessorReferenceDocument = _InboundDocFlow.SubsequentDocument
                                                                            and _NFDocFlow.PredecessorReferenceDocItem  = right(
      _InboundDocFlow.SubsequentDocumentItem, 4
    )
    left outer join       I_BR_NFDocument            as _NotaFiscalHeader   on _NFDocFlow.BR_NotaFiscal = _NotaFiscalHeader.BR_NotaFiscal
  //  left outer join       I_BR_NFItem                as _NotaFiscalItem     on  _NotaFiscalItem.BR_NotaFiscal     = _NFDocFlow.BR_NotaFiscal
  //                                                                          and _NotaFiscalItem.BR_NotaFiscalItem = _NFDocFlow.BR_NotaFiscalItem
    left outer join       ZI_TM_TOT_ITENS_NF         as _TotalItensNF       on _NFDocFlow.BR_NotaFiscal = _TotalItensNF.BR_NotaFiscal
                                                                           and _TotalItensNF.BR_NotaFiscalItem = right(
                                                                               _TransOrdemItem.TranspOrdItem, 6 )
    left outer join       I_BR_NFElectronic_C        as _VerifyNF           on _NFDocFlow.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
    left outer join       ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on  _TransOrdemItem.TransportationOrderUUID = _CodigoUnidadeFrete.parent_key
                                                                            and _TransOrdemItem.TranspOrdItem           = _CodigoUnidadeFrete.item_id
    left outer join       ZI_TM_TOTAL_VOLUME         as _TotalVolume        on  _TransOrdemItem.TransportationOrderUUID = _TotalVolume.TransportationOrderUUID
                                                                            and _TransOrdemItem.TranspOrdDocReferenceID = _TotalVolume.TranspOrdDocReferenceID
    left outer join       zttm_cubagem               as _Cubagem            on  _CodigoUnidadeFrete.tor_id        = _Cubagem.unidade_frete
                                                                            and _InboundDocFlow.PrecedingDocument = _Cubagem.remessa
    association[0..1] to I_ProductGroupText_2        as _ProductGroupText2  on $projection.ProductGroup =  _ProductGroupText2.ProductGroup
                                                                            and _ProductGroupText2.Language = $session.system_language                                                                            
                                                                      
{
  key PrecedingDocument                                                      as DocReference,
      cast( ' ' as lfart )                                                   as DeliveryDocumentType,
      cast( ' ' as abap.char( 50 ) )                                         as DeliveryDocumentTypeName,
      _NFDocFlow.BR_NotaFiscal,                     //docnum
      _NotaFiscalHeader.BR_NFeNumber,
      _NotaFiscalHeader.BR_NFIssueDate,
      _VerifyNF.BR_NFeAccessKey,
      _TransOrdemItem.TransportationOrderUUID,
      _TransOrdemItem.TranspOrdItem,
      _TransOrdemItem._TransportationOrder.TransportationOrder,
      _TransOrdemItem.SourceStopUUID,
      _TransOrdemItem.DestinationStopUUID,
      _TransOrdemItem.Motorista,
      _TransOrdemItem.ProductName,
      _TransOrdemItem.Consignee,
      _TransOrdemItem.TranspOrdDocReferenceID,
      _TransOrdemItem.ProductID,
      _TransOrdemItem._TransportationOrder.CreationDateTime,
      _TransOrdemItem._TransportationOrder.CreatedByUser,
      
      _TransOrdemItem.TranspOrdItemParentItemUUID  as parentID,
      
      _TransOrdemItem._TranspOrdItemParentItem.PlateNumber,
      _TransOrdemItem._TranspOrdItemParentItem.TuresCat,
      _TransOrdemItem._TranspOrdItemParentItem.TuresTco,
      _TransOrdemItem._TransportationOrder.TranspOrdMaxUtilznRatio,
      _TransOrdemItem.ProductHierarchy, 
      _TransOrdemItem._Consignee.BusinessPartnerName,
      _TransOrdemItem.ProductGroup,
      _TransOrdemItem._TransportationOrder.LastChangedByUser,
      
      //_TransOrdemItem._Product._ProductGroupText[Language = $session.system_language].MaterialGroupText,
      _ProductGroupText2.ProductGroupText as MaterialGroupText,
      
      _TransOrdemItem._TranspOrdItemParentItem.TransportationMode,
      _TransOrdemItem._TranspOrdItemParentItem.TransportationModeDesc,

      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus.TranspOrdLifeCycleStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus._Text[Language = $session.system_language].TranspOrdLifeCycleStatusDesc as TranspOrdLifeCycleStatusText,

      _TransOrdemItem._TransportationOrder.TranspOrdPlanningStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdPlanningStatus._Text[Language = $session.system_language].TranspOrdPlanningStatusDesc,

      _TransOrdemItem._TransportationOrder.TransportationOrderExecSts,
      _TransOrdemItem._TransportationOrder._TransportationOrderExecSts._Text[Language = $session.system_language].TransportationOrderExecStsDesc,

      _TransOrdemItem._TransportationOrder.TransportationOrderType,
      _TransOrdemItem._TransportationOrder._TransportationOrderType._Text[Language = $session.system_language].TransportationOrderTypeDesc,
      _TransOrdemItem.TranspOrdItemGrossWeight,
      _TransOrdemItem.TranspOrdItemGrossWeightUnit,
      _TransOrdemItem.TranspOrdItemNetWeight,
      _TransOrdemItem.TranspOrdItemNetWeightUnit,
      _CodigoUnidadeFrete.tor_id                        as UnidadeFrete,
      
      //TODO: Obter valor pela CDS ZI_TM_FLUXONF_ITEM
      //_NotaFiscalItem.BR_NFValueAmountWithTaxes,
      0 as BR_NFValueAmountWithTaxes,
      
      _TotalVolume.PesoBrutoTotal,
      _Cubagem.peso_total,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
        * cast(coalesce( _Cubagem.volume, 0.00 ) as float)                                                                                   as VolumeCubadoEcom,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.peso_total, 0.00 ) as float)                                                                                 as PesoBrutoEcom,
      _TotalItensNF.TotalItensNF,
      _TotalItensNF.ItemValueTotal,
      _TransOrdemItem.TranspOrdDocReferenceType,
      _NFDocFlow.ReferenceDocument as DocFaturamento,
      _TransOrdemItem._Shipper.BusinessPartnerUUID,
      _TransOrdemItem._Shipper.LastName
}
where
      _TransOrdemItem.TranspOrdDocReferenceType = '58'
  and _TransOrdemItem.IsMainCargoItem           = 'X'
  and _TransOrdemItem.TranspOrdItemType         = 'PRD'

union

select from       ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem
  inner join      I_DeliveryDocument         as _Remessa            on _Remessa.DeliveryDocument = right(
    _TransOrdemItem.BaseBtdId, 10
  )
  inner join      I_DeliveryDocumentItem     as _RemessaItem        on  _RemessaItem.DeliveryDocument      =  _Remessa.DeliveryDocument
                                                                    and _RemessaItem.ItemIsBillingRelevant <> ' '

  inner join      I_BR_NFDocumentFlow_C      as _NFDocFlow2         on _NFDocFlow2.PredecessorReferenceDocument = _RemessaItem.DeliveryDocument
//  and _NFDocFlow.PredecessorReferenceDocItem  = right(
//   _RemessaItem.DeliveryDocumentItem, 4
//  )
  left outer join I_BR_NFDocument            as _NotaFiscalHeader   on _NFDocFlow2.BR_NotaFiscal = _NotaFiscalHeader.BR_NotaFiscal
  left outer join ZI_TM_TOT_ITENS_NF         as _TotalItensNF       on _NFDocFlow2.BR_NotaFiscal = _TotalItensNF.BR_NotaFiscal
                                                                   and _TotalItensNF.BR_NotaFiscalItem = right(
                                                                       _TransOrdemItem.TranspOrdItem, 6 )
  //C_BR_VerifyNotaFiscal
  left outer join I_BR_NFElectronic_C      as _VerifyNF           on _NFDocFlow2.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
  left outer join ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on  _TransOrdemItem.TransportationOrderUUID = _CodigoUnidadeFrete.parent_key
                                                                    and _TransOrdemItem.TranspOrdItem           = _CodigoUnidadeFrete.item_id
  left outer join ZI_TM_TOTAL_VOLUME         as _TotalVolume        on  _TransOrdemItem.TransportationOrderUUID = _TotalVolume.TransportationOrderUUID
                                                                    and _TransOrdemItem.TranspOrdDocReferenceID = _TotalVolume.TranspOrdDocReferenceID
  left outer join zttm_cubagem               as _Cubagem            on  _CodigoUnidadeFrete.tor_id = _Cubagem.unidade_frete
                                                                    and _Remessa.DeliveryDocument  = _Cubagem.remessa
  association[0..1] to I_ProductGroupText_2  as _ProductGroupText2  on $projection.ProductGroup =  _ProductGroupText2.ProductGroup
                                                                    and _ProductGroupText2.Language = $session.system_language                                                                            
                                                                        
{
  key _Remessa.DeliveryDocument                                                                                                              as DocReference,
      _Remessa.DeliveryDocumentType,
      _Remessa._DeliveryDocumentType._Text[1:Language = $session.system_language].DeliveryDocumentTypeName,
      _NFDocFlow2.BR_NotaFiscal,
      _NotaFiscalHeader.BR_NFeNumber,
      _NotaFiscalHeader.BR_NFIssueDate,
      _VerifyNF.BR_NFeAccessKey,
      _TransOrdemItem.TransportationOrderUUID,
      _TransOrdemItem.TranspOrdItem,
      _TransOrdemItem._TransportationOrder.TransportationOrder,
      _TransOrdemItem.SourceStopUUID,
      _TransOrdemItem.DestinationStopUUID,
      _TransOrdemItem.Motorista,
      _TransOrdemItem.ProductName,
      _TransOrdemItem.Consignee,
      _TransOrdemItem.TranspOrdDocReferenceID,
      _TransOrdemItem.ProductID,
      _TransOrdemItem._TransportationOrder.CreationDateTime,
      _TransOrdemItem._TransportationOrder.CreatedByUser,
      
      _TransOrdemItem.TranspOrdItemParentItemUUID  as parentID,
      
      _TransOrdemItem._TranspOrdItemParentItem.PlateNumber,
      _TransOrdemItem._TranspOrdItemParentItem.TuresCat,
      _TransOrdemItem._TranspOrdItemParentItem.TuresTco,
      _TransOrdemItem._TransportationOrder.TranspOrdMaxUtilznRatio,
      _TransOrdemItem.ProductHierarchy,
      _TransOrdemItem._Consignee.BusinessPartnerName,
      _TransOrdemItem.ProductGroup, 
      _TransOrdemItem._TransportationOrder.LastChangedByUser,
      //_TransOrdemItem._Product._ProductGroupText[Language = $session.system_language].MaterialGroupText,
      _ProductGroupText2.ProductGroupText as MaterialGroupText,
      
      _TransOrdemItem._TranspOrdItemParentItem.TransportationMode,
      _TransOrdemItem._TranspOrdItemParentItem.TransportationModeDesc,

      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus.TranspOrdLifeCycleStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus._Text[Language = $session.system_language].TranspOrdLifeCycleStatusDesc as TranspOrdLifeCycleStatusText,

      @ObjectModel.text.element: ['TranspOrdPlanningStatusDesc']
      _TransOrdemItem._TransportationOrder.TranspOrdPlanningStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdPlanningStatus._Text[Language = $session.system_language].TranspOrdPlanningStatusDesc,

      @ObjectModel.text.element: ['TransportationOrderExecStsDesc']
      _TransOrdemItem._TransportationOrder.TransportationOrderExecSts,
      _TransOrdemItem._TransportationOrder._TransportationOrderExecSts._Text[Language = $session.system_language].TransportationOrderExecStsDesc,

      _TransOrdemItem._TransportationOrder.TransportationOrderType,
      _TransOrdemItem._TransportationOrder._TransportationOrderType._Text[Language = $session.system_language].TransportationOrderTypeDesc,
      _TransOrdemItem.TranspOrdItemGrossWeight,
      _TransOrdemItem.TranspOrdItemGrossWeightUnit,
      _TransOrdemItem.TranspOrdItemNetWeight,
      _TransOrdemItem.TranspOrdItemNetWeightUnit,
      _CodigoUnidadeFrete.tor_id                                                                                                             as UnidadeFrete,
      
      //TODO: Obter valor pela CDS ZI_TM_FLUXONF_ITEM
      //_NotaFiscalItem.BR_NFValueAmountWithTaxes,
      0 as BR_NFValueAmountWithTaxes,
      
      _TotalVolume.PesoBrutoTotal,
      _Cubagem.peso_total,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.volume, 0.00 ) as float)                                                                                     as VolumeCubadoEcom,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.peso_total, 0.00 ) as float)                                                                                 as PesoBrutoEcom,
      _TotalItensNF.TotalItensNF,
      _TotalItensNF.ItemValueTotal,
      _TransOrdemItem.TranspOrdDocReferenceType,
            _NFDocFlow2.ReferenceDocument as DocFaturamento,
            _TransOrdemItem._Shipper.BusinessPartnerUUID,
      _TransOrdemItem._Shipper.LastName
}
where
      _TransOrdemItem.TranspOrdDocReferenceType = '73'
  and _TransOrdemItem.IsMainCargoItem           = 'X'
  and _TransOrdemItem.TranspOrdItemType         = 'PRD'


union

select from       ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem
  inner join      I_DeliveryDocument         as _Remessa            on _Remessa.DeliveryDocument = right(
    _TransOrdemItem.BaseBtdId, 10
  )
  inner join      I_DeliveryDocumentItem     as _RemessaItem        on _RemessaItem.DeliveryDocument = _Remessa.DeliveryDocument
  left outer join ZI_TM_TOT_ITENS_NF         as _TotalItensNF       on _RemessaItem.ReferenceSDDocument = _TotalItensNF.PurchaseOrder
                                                                   and _TotalItensNF.BR_NotaFiscalItem = right(
                                                                       _TransOrdemItem.TranspOrdItem, 6 )
  left outer join I_BR_NFItem                as _NotaFiscalItem     on  _NotaFiscalItem.PurchaseOrder     = _RemessaItem.ReferenceSDDocument
                                                                    and _NotaFiscalItem.PurchaseOrderItem = right(
    _RemessaItem.ReferenceSDDocumentItem, 5
  )
  left outer join I_BR_NFDocument            as _NotaFiscalHeader   on _NotaFiscalItem.BR_NotaFiscal = _NotaFiscalHeader.BR_NotaFiscal
  
  //C_BR_VerifyNotaFiscal
  left outer join I_BR_NFElectronic_C        as _VerifyNF           on _NotaFiscalItem.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
  left outer join ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on  _TransOrdemItem.TransportationOrderUUID = _CodigoUnidadeFrete.parent_key
                                                                    and _TransOrdemItem.TranspOrdItem           = _CodigoUnidadeFrete.item_id
  left outer join ZI_TM_TOTAL_VOLUME         as _TotalVolume        on  _TransOrdemItem.TransportationOrderUUID = _TotalVolume.TransportationOrderUUID
                                                                    and _TransOrdemItem.TranspOrdDocReferenceID = _TotalVolume.TranspOrdDocReferenceID
  left outer join zttm_cubagem               as _Cubagem            on  _CodigoUnidadeFrete.tor_id = _Cubagem.unidade_frete
                                                                    and _Remessa.DeliveryDocument  = _Cubagem.remessa
  association[0..1] to I_ProductGroupText_2  as _ProductGroupText2  on $projection.ProductGroup =  _ProductGroupText2.ProductGroup
                                                                    and _ProductGroupText2.Language = $session.system_language                                                                            
                                                                        
{
  key _Remessa.DeliveryDocument                                                                                                              as DocReference,
      _Remessa.DeliveryDocumentType,
      _Remessa._DeliveryDocumentType._Text[1:Language = $session.system_language].DeliveryDocumentTypeName,
      _NotaFiscalItem.BR_NotaFiscal,
      _NotaFiscalHeader.BR_NFeNumber,
      _NotaFiscalHeader.BR_NFIssueDate,
      _VerifyNF.BR_NFeAccessKey,
      _TransOrdemItem.TransportationOrderUUID,
      _TransOrdemItem.TranspOrdItem,
      _TransOrdemItem._TransportationOrder.TransportationOrder,
      _TransOrdemItem.SourceStopUUID,
      _TransOrdemItem.DestinationStopUUID,
      _TransOrdemItem.Motorista,
      _TransOrdemItem.ProductName,
      _TransOrdemItem.Consignee,
      _TransOrdemItem.TranspOrdDocReferenceID,
      _TransOrdemItem.ProductID,
      _TransOrdemItem._TransportationOrder.CreationDateTime,
      _TransOrdemItem._TransportationOrder.CreatedByUser,
      
      _TransOrdemItem.TranspOrdItemParentItemUUID as parentID, 
      
      _TransOrdemItem._TranspOrdItemParentItem.PlateNumber,
      _TransOrdemItem._TranspOrdItemParentItem.TuresCat,
      _TransOrdemItem._TranspOrdItemParentItem.TuresTco,
      _TransOrdemItem._TransportationOrder.TranspOrdMaxUtilznRatio,
      _TransOrdemItem.ProductHierarchy, 
      _TransOrdemItem._Consignee.BusinessPartnerName,
      _TransOrdemItem.ProductGroup,
      _TransOrdemItem._TransportationOrder.LastChangedByUser,
      
      //_TransOrdemItem._Product._ProductGroupText[Language = $session.system_language].MaterialGroupText,
      _ProductGroupText2.ProductGroupText as MaterialGroupText,
      
      _TransOrdemItem._TranspOrdItemParentItem.TransportationMode,
      _TransOrdemItem._TranspOrdItemParentItem.TransportationModeDesc,

      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus.TranspOrdLifeCycleStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdLifeCycleStatus._Text[Language = $session.system_language].TranspOrdLifeCycleStatusDesc as TranspOrdLifeCycleStatusText,

      @ObjectModel.text.element: ['TranspOrdPlanningStatusDesc']
      _TransOrdemItem._TransportationOrder.TranspOrdPlanningStatus,
      _TransOrdemItem._TransportationOrder._TranspOrdPlanningStatus._Text[Language = $session.system_language].TranspOrdPlanningStatusDesc,

      @ObjectModel.text.element: ['TransportationOrderExecStsDesc']
      _TransOrdemItem._TransportationOrder.TransportationOrderExecSts,
      _TransOrdemItem._TransportationOrder._TransportationOrderExecSts._Text[Language = $session.system_language].TransportationOrderExecStsDesc,

      _TransOrdemItem._TransportationOrder.TransportationOrderType,
      _TransOrdemItem._TransportationOrder._TransportationOrderType._Text[Language = $session.system_language].TransportationOrderTypeDesc,
      _TransOrdemItem.TranspOrdItemGrossWeight,
      _TransOrdemItem.TranspOrdItemGrossWeightUnit,
      _TransOrdemItem.TranspOrdItemNetWeight,
      _TransOrdemItem.TranspOrdItemNetWeightUnit,
      _CodigoUnidadeFrete.tor_id                                                                                                             as UnidadeFrete,
      
      //TODO: Obter valor pela CDS ZI_TM_FLUXONF_ITEM
      //_NotaFiscalItem.BR_NFValueAmountWithTaxes,
      0 as BR_NFValueAmountWithTaxes,
      
      _TotalVolume.PesoBrutoTotal,
      _Cubagem.peso_total,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.volume, 0.00 ) as float)                                                                                     as VolumeCubadoEcom,
      (cast(_TransOrdemItem.TranspOrdItemGrossWeight as float) / cast(_TotalVolume.PesoBrutoTotal as float))
      * cast(coalesce( _Cubagem.peso_total, 0.00 ) as float)                                                                                 as PesoBrutoEcom,
      _TotalItensNF.TotalItensNF,
      _TotalItensNF.ItemValueTotal,
      _TransOrdemItem.TranspOrdDocReferenceType,
      '' as DocFaturamento,
      _TransOrdemItem._Shipper.BusinessPartnerUUID,
      _TransOrdemItem._Shipper.LastName
}
where
      _Remessa.DeliveryDocumentType             = 'ZNLC' //Transferencia
  and _TransOrdemItem.TranspOrdDocReferenceType = '73'   //Saída (outbound)
  and _TransOrdemItem.IsMainCargoItem           = 'X'
  and _TransOrdemItem.TranspOrdItemType         = 'PRD'
