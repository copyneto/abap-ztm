@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit para Prestação de Contas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_TM_COCKPIT_PRESTACAO_CONTAS
  as select from ZI_TM_PRESTACAO_CONTAS

  composition [0..*] of ZI_TM_COCKPIT_ITEM_EXECUCAO as _Execucao

{
  key cast( FreightOrderUUID as /bobf/conf_key preserving type ) as FreightOrderUUID,
  key cast( FreightUnitUUID as /bobf/conf_key preserving type )  as FreightUnitUUID,
      FreightUnit,
      FreightOrder,
      SalesDocument,
      SalesDocumentType,
      DeliveryDocument,
      BR_NotaFiscal,
      DriverUUID,
      DriverId,
      DriverName,
      PlateNumber,
      ConsigneeId,
      ConsigneeName,
      TranspOrdExecution,
      TranspOrdEventCode,
      TranspOrdEventCodeDesc,
      TranspOrdEventCodeSignature,
      CompanyCode,

      case when TranspOrdEventCode = 'ENTREGUE'       then 3
           when TranspOrdEventCode = 'DEVOLVIDO'      then 3
           when TranspOrdEventCode = 'PENDENTE'       then 3
           when TranspOrdEventCode = 'SINISTRO'       then 3
           when TranspOrdEventCode = 'COLETADO'       then 3
           when TranspOrdEventCode = 'NÃO COLETADO'   then 3
           else 0 end                                            as TranspOrdEventCodeCrit,

      TranspOrdEventStatus,
      TransportationActivity,
      TransportationActivityDesc,
      TranspOrdExecInfoSource,
      TranspOrdExecInfoSourceDesc,
      TranspOrdEvtActualDateTime,
      TranspOrdEvtActualDate,
      TranspOrdEvtActualTime,
      TranspOrdLifeCycleStatus,
      TranspOrdLifeCycleStatusDesc,

      case TranspOrdLifeCycleStatus
      when '00' then 0 -- Esboço
      when '01' then 0 -- Novo
      when '02' then 2 -- Em processamento
      when '05' then 3 -- Concluído
      when '10' then 1 -- Cancelado
                else 0 end                                       as TranspOrdLifeCycleStatusCrit,

      cast( case when TranspOrdEventCode = 'ENTREGUE'
                 then 'X'
                 when TranspOrdEventCodeSignature = 'X'
                  and TranspOrdEventCode <> 'ENTREGUE'
                  and TranspOrdEventCode <> 'DEVOLVIDO'
                  and TranspOrdEventCode <> 'PENDENTE'
                  and TranspOrdEventCode <> 'SINISTRO'
                  and TranspOrdEventCode <> 'COLETADO'
                  and TranspOrdEventCode <> 'NÃO COLETADO'
                 then 'X'
                 else ' '
                 end as abap.char(1) )                           as StatusEntregue,

      cast( case when TranspOrdEventCode = 'ENTREGUE'
                 then 'Sim'
                 when TranspOrdEventCodeSignature = 'X'
                  and TranspOrdEventCode <> 'ENTREGUE'
                  and TranspOrdEventCode <> 'DEVOLVIDO'
                  and TranspOrdEventCode <> 'PENDENTE'
                  and TranspOrdEventCode <> 'SINISTRO'
                  and TranspOrdEventCode <> 'COLETADO'
                  and TranspOrdEventCode <> 'NÃO COLETADO'
                 then 'Sim'
                 else ' ' end as abap.char(10) )                 as StatusEntregueText,

      case when TranspOrdEventCode = 'ENTREGUE'
           then 3
           when TranspOrdEventCodeSignature = 'X'
            and TranspOrdEventCode <> 'ENTREGUE'
            and TranspOrdEventCode <> 'DEVOLVIDO'
            and TranspOrdEventCode <> 'PENDENTE'
            and TranspOrdEventCode <> 'SINISTRO'
            and TranspOrdEventCode <> 'COLETADO'
            and TranspOrdEventCode <> 'NÃO COLETADO'
           then 3
           else 0  end                                           as StatusEntregueCriticality,

      cast( case TranspOrdEventCode
      when 'DEVOLVIDO'
      then 'X'
      else ' ' end as abap.char(1) )                             as StatusDevolvido,

      cast( case TranspOrdEventCode
      when 'DEVOLVIDO'
      then 'Sim'
      else ' ' end as abap.char(10) )                            as StatusDevolvidoText,

      case TranspOrdEventCode
      when 'DEVOLVIDO'
      then 3
      else 0 end                                                 as StatusDevolvidoCriticality,

      cast( case TranspOrdEventCode
      when 'PENDENTE'
      then 'X'
      else ' ' end as abap.char(1) )                             as StatusPendente,

      cast( case TranspOrdEventCode
      when 'PENDENTE'
      then 'Sim'
      else ' ' end as abap.char(10) )                            as StatusPendenteText,

      case TranspOrdEventCode
      when 'PENDENTE'
      then 3
      else 0 end                                                 as StatusPendenteCriticality,

      cast( case TranspOrdEventCode
      when 'SINISTRO'
      then 'X'
      else ' ' end as abap.char(1) )                             as StatusSinistro,

      cast( case TranspOrdEventCode
      when 'SINISTRO'
      then 'Sim'
      else ' ' end as abap.char(10) )                            as StatusSinistroText,

      case TranspOrdEventCode
      when 'SINISTRO'
      then 3
      else 0 end                                                 as StatusSinistroCriticality,

      cast( case TranspOrdEventCode
      when 'COLETADO'
      then 'X'
      else ' ' end as abap.char(1) )                             as StatusColetado,

      cast( case TranspOrdEventCode
      when 'COLETADO'
      then 'Sim'
      else ' ' end as abap.char(10) )                            as StatusColetadoText,

      case TranspOrdEventCode
      when 'COLETADO'
      then 3
      else 0 end                                                 as StatusColetadoCriticality,

      cast( case TranspOrdEventCode
      when 'NÃO COLETADO'
      then 'X'
      else ' ' end as abap.char(1) )                             as StatusNaoColetado,

      cast( case TranspOrdEventCode
      when 'NÃO COLETADO'
      then 'Sim'
      else ' ' end as abap.char(10) )                            as StatusNaoColetadoText,

      case TranspOrdEventCode
      when 'NÃO COLETADO'
      then 3
      else 0 end                                                 as StatusNaoColetadoCriticality,

      DestinationLocation,
      DestinationLocationLabel,
      BusinessPartnerUUID,
      BusinessPartner,
      LocationDescription,
      LocationType,
      Country,
      CityName,
      PostalCode,
      StreetName,
      HouseNumber,
      PaymentMethod,
      PaymentMethodDescription,
      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      BaseValue,
      BaseUnit,
      @Semantics.amount.currencyCode : 'AmountCurrency'
      AmountValue,
      AmountCurrency,


      ''                                                         as TranspOrdEventCodeNew, -- Usado no POP-UP da Abstract View
      FreightUnitType,
      /* composition */
      _Execucao

}
where
  (
      BR_NotaFiscal   is not initial
    or(
      FreightUnitType = 'F013'
    )
  )
