@AbapCatalog.sqlViewName: 'ZITMVLRPRVCONTB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TM - Cálculo do valor da provisão contábil'
define view ZI_TM_VLR_PROVISAO_CONTAB
  as select distinct from ZI_TM_DFF_FLOW                                         as _DFFFlow
    inner join            bseg                                                   as _FinancialDocumentAccItem   on _FinancialDocumentAccItem.ebeln = _DFFFlow.FreightPurchaseOrder
    inner join            bkpf                                                   as _FinancialDocumentAccHeader on  _FinancialDocumentAccHeader.bukrs = _FinancialDocumentAccItem.bukrs
                                                                                                                and _FinancialDocumentAccHeader.belnr = _FinancialDocumentAccItem.belnr
                                                                                                                and _FinancialDocumentAccHeader.gjahr = _FinancialDocumentAccItem.gjahr
    inner join            ZI_CA_GET_PARAMETER(p_modulo: 'TM',
                                              p_chave1 : 'CONTA_PROVISAO',
                                              p_chave2 : 'HKONT', p_chave3 : '') as _ParameterAccount           on _ParameterAccount.Low = _FinancialDocumentAccItem.hkont

{
  key _DFFFlow.TransportationOrderId,
  key _DFFFlow.TransportationOrderItemId,
  key _DFFFlow.DFFDocumentId,
      _FinancialDocumentAccHeader.waers                    as Currency,
      @Semantics.amount.currencyCode:'Currency'
      sum( case when _FinancialDocumentAccItem.shkzg = 'H'
                then _FinancialDocumentAccItem.wrbtr * -1
                else _FinancialDocumentAccItem.wrbtr end ) as Value
      //  key _FinancialDocumentAccItem.bukrs as Company,
      //  key _FinancialDocumentAccItem.belnr as FinancialDocument,
      //  key _FinancialDocumentAccItem.gjahr as FiscalYear,
      //  key _FinancialDocumentAccItem.buzei as FinancialDocumentItem,
      //      _DFFFlow.TransportationOrder,
      //      _DFFFlow.DFFDocument,
      //      _DFFFlow.FreightPurchaseOrder
}
where
     _DFFFlow.DFFDocumentLifeCycle = '04'
  or _DFFFlow.DFFDocumentLifeCycle = '07'
group by
  TransportationOrderId,
  TransportationOrderItemId,
  DFFDocumentId,
  _FinancialDocumentAccHeader.waers
