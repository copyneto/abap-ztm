@AbapCatalog.sqlViewName: 'ZITMRPROV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: false
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Relatório Provisão de Custos'
@VDM.viewType: #COMPOSITE
define view ZI_TM_PROVISAO_CUSTOS
  as select from    ZI_TM_FLUXONF_ITEM         as _FluxoItemDocumentosNF
    inner join      ZI_TRANSPORTATIONORDERITEM as _TransportationOrderItem on  _TransportationOrderItem.TransportationOrderUUID     = _FluxoItemDocumentosNF.TransportationOrderUUID
                                                                           and _TransportationOrderItem.TransportationOrderItemUUID = _FluxoItemDocumentosNF.TransportationOrderItemUUID
    inner join      /scmtms/d_torrot           as _TransportationOrder     on _TransportationOrder.db_key = _FluxoItemDocumentosNF.TransportationOrderUUID
    inner join      I_TransportationOrder      as _TransportationOrderCds  on _TransportationOrderCds.TransportationOrderUUID = _FluxoItemDocumentosNF.TransportationOrderUUID
    left outer join C_BR_VerifyNotaFiscal      as _VerifyNF                on _FluxoItemDocumentosNF.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal

    left outer join zttm_gkot003               as _GKO_t003                on _FluxoItemDocumentosNF.BR_NotaFiscal = _GKO_t003.docnum
    left outer join zttm_gkot001               as _GKO_t001                on _GKO_t003.acckey = _GKO_t001.acckey
    
    //left outer join zttm_gkot001               as _GKO_t001                on _FluxoItemDocumentosNF.TransportationOrder = _GKO_t001.tor_id      
    //left outer join zttm_gkot003               as _GKO_t003                on _GKO_t003.acckey = _GKO_t001.acckey
    
    left outer join /scmtms/d_torstp           as _StopOri                 on  _StopOri.db_key       = _FluxoItemDocumentosNF.SourceStopUUID
                                                                           and _StopOri.stop_cat     = 'O'
                                                                           and _StopOri.stop_seq_pos = 'F'
    left outer join /scmtms/d_torstp           as _StopDest                on  _StopDest.db_key       =  _FluxoItemDocumentosNF.DestinationStopUUID
                                                                           and _StopDest.stop_cat     <> 'O'
                                                                           and _StopDest.stop_seq_pos <> 'F'
    left outer join ZI_TM_PIS_CONFINS          as _PisCofins               on  _PisCofins.TransportationOrderId     = _FluxoItemDocumentosNF.TransportationOrderUUID
                                                                           and _PisCofins.TransportationOrderItemId = _FluxoItemDocumentosNF.TransportationOrderItemUUID
    left outer join t179t                      as _FamiliaProdutoNivel1    on  _FamiliaProdutoNivel1.prodh = substring(
      _FluxoItemDocumentosNF.ProductHierarchy, 1, 5
    )
                                                                           and _FamiliaProdutoNivel1.spras = $session.system_language
    left outer join I_DistributionChannelText  as _DistributionChannel     on  _DistributionChannel.DistributionChannel = _FluxoItemDocumentosNF.DistributionChannel
                                                                           and _DistributionChannel.Language            = $session.system_language
    left outer join ZI_GKO_VH_STATUSCODE       as _GKOStatusCode           on _GKOStatusCode.StatusCode = _GKO_t001.codstatus
    left outer join ZI_TM_DFF_FLOW             as _DFFFlow                 on  _DFFFlow.TransportationOrderId     = _FluxoItemDocumentosNF.TransportationOrderUUID
                                                                           and _DFFFlow.TransportationOrderItemId = _FluxoItemDocumentosNF.TransportationOrderItemUUID
                                                                           and (
                                                                              _DFFFlow.DFFDocumentLifeCycle       = '04'
                                                                              or _DFFFlow.DFFDocumentLifeCycle    = '07'
                                                                            )
    left outer join ZI_TM_VLR_PROVISAO_CONTAB  as _CostProvisionValue      on  _CostProvisionValue.TransportationOrderId     = _FluxoItemDocumentosNF.TransportationOrderUUID
                                                                           and _CostProvisionValue.TransportationOrderItemId = _FluxoItemDocumentosNF.TransportationOrderItemUUID
                                                                           and _CostProvisionValue.DFFDocumentId             = _DFFFlow.DFFDocumentId
    left outer join I_LocationBasic            as _LocationAdtlOrigem      on _LocationAdtlOrigem.LocationAdditionalUUID = _StopOri.log_loc_uuid
    left outer join I_LocationBasic            as _LocationAdtlDestino     on _LocationAdtlDestino.LocationAdditionalUUID = _StopDest.log_loc_uuid
    left outer join ZI_TM_VH_TIPO_EXPED        as _TipoExped               on _TipoExped.TipoExped = _TransportationOrder.zz1_tipo_exped
    left outer join ZI_TM_VH_COND_EXP          as _CondExped               on _CondExped.CondExped = _TransportationOrder.zz1_cond_exped
    left outer join ZI_GKO_VH_CENARIO          as _GKOCenario              on _GKOCenario.CenarioCode = _GKO_t001.cenario

  association [0..1] to ZI_TM_VH_UG as _UGFrom on _UGFrom.LocationId = $projection.UGFrom
  association [0..1] to ZI_TM_VH_UG as _UGTo   on _UGTo.LocationId = $projection.UGTo


{
  key _FluxoItemDocumentosNF.TransportationOrder,
  key _TransportationOrderItem.TranspOrdItem                                    as TransportationOrderItem,
  key _DFFFlow.DFFDocument,
      _FluxoItemDocumentosNF.TransportationOrderUUID                            as TransportationOrderId,
      _FluxoItemDocumentosNF.TransportationOrderItemUUID                        as TransportationOrderItemId,
      _DFFFlow.DFFDocumentId,
      _FluxoItemDocumentosNF.ProductID,
      _FluxoItemDocumentosNF.ProductName,
      _FamiliaProdutoNivel1.vtext                                               as FamiliaProdutosNivel1,
      _FluxoItemDocumentosNF.BR_NotaFiscal,
      lpad( _FluxoItemDocumentosNF.BR_NFeNumber , 9, '0' )                      as BR_NFeNumber,
      _FluxoItemDocumentosNF.BR_NFIssueDate,
      _FluxoItemDocumentosNF.BR_NFeAccessKey,
      lpad( _FluxoItemDocumentosNF.BR_NFSeries, 3, '0' )                        as BR_NFSeries,
      _TransportationOrderCds.Carrier                                           as CarrierCode,
      _TransportationOrderCds._Carrier.BusinessPartnerFullName                  as CarrierName,
      _TransportationOrderItem.TranspOrdItemQuantityUnit,
      @ObjectModel.foreignKey.association: '_UGFrom'
      _StopOri.log_locid                                                        as UGFrom,
      @ObjectModel.foreignKey.association: '_UGTo'
      _StopDest.log_locid                                                       as UGTo,
      _LocationAdtlOrigem._Address.CityName                                     as CityFrom,
      _LocationAdtlDestino._Address.CityName                                    as CityTo,
      _LocationAdtlOrigem._Address.Region                                       as UFFrom,
      _LocationAdtlDestino._Address.Region                                      as UFTo,
      _FluxoItemDocumentosNF.TransportationOrderType,
      _FluxoItemDocumentosNF.DocReference                                       as DeliveryDocument,
      _DistributionChannel.DistributionChannelName,
      _TransportationOrder.zz1_tipo_exped                                       as ExpeditionType,
      _TipoExped.Descricao                                                      as ExpeditionTypeText,
      _TransportationOrder.zz1_cond_exped                                       as ShippingCondition,
      _CondExped.Descricao                                                      as ShippingConditionText,
      _GKO_t001.cenario                                                         as Scenario,
      _GKOCenario.Name                                                          as ScenarioName,
      tstmp_to_dats( _FluxoItemDocumentosNF.CreationDateTime ,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                                   as TranspOrderCreationDate,
      _GKO_t001.dtemi                                                           as DataEmissaoDocFrete,
      _GKO_t001.acckey                                                          as ChaveAcessoDocFrete,
      _GKO_t001.nfnum9                                                          as CTENum, //Número de 9 posições
      _GKO_t001.prefno                                                          as NFSDanfeNum,
      _GKO_t001.num_fatura                                                      as NumeroFaturaGKO,
      _GKO_t001.bukrs                                                           as CompanyCode,
      _GKO_t001.tom_cod                                                         as BranchReceivingService,
      //      _FluxoItemDocumentosNF.TranspOrdItemGrossWeight,
      cast( _FluxoItemDocumentosNF.TranspOrdItemGrossWeight as abap.dec(17,2) ) as TranspOrdItemGrossWeight,
      _FluxoItemDocumentosNF.TranspOrdItemGrossWeightUnit,
      //      _FluxoItemDocumentosNF.TranspOrdItemNetWeight,
      cast( _FluxoItemDocumentosNF.TranspOrdItemNetWeight as abap.dec(17,2) )   as TranspOrdItemNetWeight,
      _FluxoItemDocumentosNF.TranspOrdItemNetWeightUnit,
      _FluxoItemDocumentosNF.SalesOfficeName,
      _FluxoItemDocumentosNF.BR_NFValueAmountWithTaxes,
      _FluxoItemDocumentosNF.TuresTco                                           as VehicleType,
      case
        when _PisCofins.Pis is null then 0
        else _PisCofins.Pis
      end                                                                       as PisValue,
      //      _PisCofins.Pis                                                                                                                                                    as PisValue,
      //      _PisCofins.Cofins                                                                                                                                                 as CofinsValue,
      case
        when _PisCofins.Cofins is null then 0
        else _PisCofins.Cofins
      end                                                                       as CofinsValue,
      _GKO_t001.vtprest                                                         as GrossFreightValue,
      _GKO_t001.vicms                                                           as ICMSValue,
      _GKO_t001.picms                                                           as ICMSAliquot,
      _GKO_t001.viss                                                            as ISSValue,
      _GKO_t001.piss                                                            as ISSAliquot,
      _GKO_t001.vrec                                                            as ICMSCreditValue,
      // ( _GKO_t001.vtprest - ( _GKO_t001.vicms + _GKO_t001.viss + $projection.pisvalue + $projection.cofinsvalue ) ) as NetFreightValue,
      //      _TransportationOrderItem.TranspOrdItemQuantity,
      cast( _TransportationOrderItem.TranspOrdItemQuantity as abap.dec(17,2) )  as TranspOrdItemQuantity,
      _GKO_t001.re_belnr                                                        as InvoiceDocument,
      _GKO_t001.vct_gko                                                         as InvoiceDueDate,
      _GKO_t001.budat                                                           as InvoicePostingDate,
      _GKO_t001.belnr                                                           as FinancialDocument,
      _GKO_t001.augdt                                                           as ClearingDate,
      _GKO_t001.tpevento                                                        as EventType,
      _GKO_t001.tpdoc                                                           as FreightDocumentType,
      _GKO_t001.codstatus                                                       as CockpitProcessStatus,
      _GKOStatusCode.Name                                                       as CockpitProcessStatusName,
      _DFFFlow.FreightPurchaseOrder,
      _DFFFlow.ServiceDocument,
      _DFFFlow.ServiceDocumentCostCenter,
      _DFFFlow.ServiceDocumentCostCenterName,
      _DFFFlow.ServiceDocumentAccount,
      _DFFFlow.ServiceDocumentAccountName,
      substring(_FluxoItemDocumentosNF.ProductHierarchy, 1, 5)                  as ProductHierarchy5,
      _TipoExped.Descricao                                                      as DescTipoExpedicao,
      substring(_FluxoItemDocumentosNF.ProductHierarchy, 1, 10)                 as ProductHierarchy10,
      _CostProvisionValue.Currency                                              as CostProvisionCurrencyValue,
      _CostProvisionValue.Value                                                 as CostProvisionValue,
      _TransportationOrderCds.CreatedByUser,
      _FluxoItemDocumentosNF.TransportationOrderExecSts,
      _FluxoItemDocumentosNF.TransportationOrderExecStsDesc,

      //Associations
      _UGFrom,
      _UGTo
}
where
  _FluxoItemDocumentosNF.TransportationOrder <> ' '
