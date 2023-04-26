@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de Contas - Documentos (Dados)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_DOCUMENTOS_INF
  as select from           ZI_TM_PRESTACAO_DOCUMENTOS     as _Documentos

    left outer to one join ZI_TM_PRESTACAO_CONTAS_ULT_EXE as _UltimaExecucao on _UltimaExecucao.TransportationOrderUUID = _Documentos.FreightUnitUUID

    left outer to one join I_SalesDocumentBasic           as _OrdemVendaInfo on _OrdemVendaInfo.SalesDocument = _Documentos.SalesDocument

    left outer to one join I_DeliveryDocument             as _DeliveryInfo   on _DeliveryInfo.DeliveryDocument = _Documentos.DeliveryDocument

  //  association [0..1] to /scmtms/d_torite          as _Motorista          on  _Motorista.parent_key = $projection.FreightOrderUUID
  //                                                                         and _Motorista.item_cat   = 'DRI' -- Motorista

  association [0..1] to ZI_TM_PRESTACAO_MOTO_ALL  as _Motorista                   on  _Motorista.ParentUUID = $projection.FreightOrderUUID

  association [0..1] to /scmtms/d_torite          as _Veiculo                     on  _Veiculo.parent_key = $projection.FreightOrderUUID
                                                                                  and _Veiculo.item_cat   = 'AVR' -- Recurso de veículo

  association [0..1] to I_TransportationOrder     as _FreightOrder                on  _FreightOrder.TransportationOrderUUID = $projection.FreightOrderUUID

  association [0..1] to I_TransportationOrder     as _FreightUnit                 on  _FreightUnit.TransportationOrderUUID = $projection.FreightUnitUUID

  association [0..1] to ZI_TM_PRESTACAO_PAGAMENTO as _Pagamento                   on  _Pagamento.FreightOrderUUID = $projection.FreightOrderUUID
                                                                                  and _Pagamento.FreightOrder     = $projection.FreightOrder
                                                                                  and _Pagamento.DeliveryDocument = $projection.DeliveryDocument

  association [0..1] to I_TranspOrdExecution      as _TranspOrdExecution          on  _TranspOrdExecution.TransportationOrderUUID = $projection.FreightUnitUUID
                                                                                  and _TranspOrdExecution.TranspOrdExecution      = $projection.TranspOrdExecution

  -- Evento: Canhoto Assinado
  association [0..1] to I_TranspOrdExecution      as _TranspOrdExecutionSignature on  _TranspOrdExecutionSignature.TransportationOrderUUID = $projection.FreightUnitUUID
                                                                                  and _TranspOrdExecutionSignature.TranspOrdEventCode      = 'HASSIGNATURE'

  association [0..1] to I_TransportationOrderStop as _DestinationStop             on  _DestinationStop.TransportationOrderUUID       = $projection.FreightUnitUUID
                                                                                  and _DestinationStop.TranspOrdStopSequencePosition = 'L'
{
  key
  cast( _Documentos.FreightOrderUUID as /bobf/conf_key preserving type )              as FreightOrderUUID,
  _Documentos.FreightOrder,
  _Documentos.FreightOrderCategory,
  _Documentos.FreightOrderType,
  _Documentos.DeliveryDocument,
  _Documentos.DeliveryItemCat,
  @Semantics.quantity.unitOfMeasure : 'BaseUnit'
  _Documentos.BaseValue,
  _Documentos.BaseUnit,
  @Semantics.amount.currencyCode : 'AmountCurrency'
  _Documentos.AmountValue,
  _Documentos.AmountCurrency,
  cast( _Documentos.FreightUnitUUID as /scmtms/tor_key    preserving type )           as FreightUnitUUID,
  _Documentos.FreightUnit,
  _Documentos.FreightUnitCategory,
  _Documentos.FreightUnitType,
  _Documentos.SalesDocument,
  _Documentos.BR_NotaFiscal,

  cast( _Motorista.DriverUUID as /scmtms/uuid_id preserving type )                    as DriverUUID,
  _Motorista.DriverName                                                               as DriverName,
  _Motorista.DriverId                                                                 as DriverId,
  _Veiculo.platenumber                                                                as PlateNumber,

  _OrdemVendaInfo.SalesDocumentType                                                   as SalesDocumentType,

  _DeliveryInfo._SalesOrganization.CompanyCode                                        as CompanyCode,

  _FreightUnit.Consignee                                                              as ConsigneeId,
  _FreightUnit._Consignee.BusinessPartnerName                                         as ConsigneeName,
  _FreightOrder.TranspOrdLifeCycleStatus                                              as TranspOrdLifeCycleStatus,
  _FreightOrder._TranspOrdLifeCycleStatus.
      _Text[ 1:Language = $session.system_language ].TranspOrdLifeCycleStatusDesc     as TranspOrdLifeCycleStatusDesc,
  _UltimaExecucao.TranspOrdExecution                                                  as TranspOrdExecution,
  _TranspOrdExecution.TranspOrdEventCode                                              as TranspOrdEventCode,
  _TranspOrdExecution._TranspOrdEventCode.
  _Text[ 1:Language = $session.system_language ].TranspOrdEventCodeDesc               as TranspOrdEventCodeDesc,
  case when _TranspOrdExecutionSignature.TranspOrdReferenceEventCode is not null
       then cast('X' as boole_d)
       else cast('' as boole_d)
       end                                                                            as TranspOrdEventCodeSignature,
  _TranspOrdExecution.TranspOrdEventStatus                                            as TranspOrdEventStatus,
  _TranspOrdExecution._TranspOrdEventStatus.
  _Text[ 1:Language = $session.system_language ].TranspOrdEventStatusDesc             as TranspOrdEventStatusDesc,
  _TranspOrdExecution.TransportationActivity                                          as TransportationActivity,
  _TranspOrdExecution._TransportationActivity.
  _Text[ 1:Language = $session.system_language ].TransportationActivityDesc           as TransportationActivityDesc,
  _TranspOrdExecution.TranspOrdExecInfoSource                                         as TranspOrdExecInfoSource,
  _TranspOrdExecution._TranspOrdExecInfoSource.
  _Text[ 1:Language = $session.system_language ].ExecInfoSourceDesc                   as TranspOrdExecInfoSourceDesc,
  _TranspOrdExecution.TranspOrdEvtActualDateTime,

  tstmp_to_dats( _TranspOrdExecution.TranspOrdEvtActualDateTime,
                 abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                 $session.client,
                 'NULL' )                                                             as TranspOrdEvtActualDate,

  tstmp_to_tims( _TranspOrdExecution.TranspOrdEvtActualDateTime,
                 abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                 $session.client,
                 'NULL' )                                                             as TranspOrdEvtActualTime,

  _DestinationStop.LocationId                                                         as DestinationLocation,
  _DestinationStop._Locationdescr.AddressObjectDescription                            as DestinationLocationLabel,

  _Pagamento.PaymentMethod                                                            as PaymentMethod,
  _Pagamento.
  _PaymentMethodText[ 1:Language = $session.system_language].PaymentMethodDescription as PaymentMethodDescription


}
