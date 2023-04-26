@AbapCatalog.sqlViewName: 'ZVTMPLANCARGPAG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Resumo de pagamentos plano de carga'
define view ZI_TM_PLANO_CARGA_PAG
  as select distinct from /scmtms/d_torrot      as _OrdemFrete
    left outer join       /scmtms/d_tordrf      as _DocsReferencia     on  _DocsReferencia.parent_key = _OrdemFrete.db_key
                                                                       and _DocsReferencia.btd_tco    = '73'
    inner join            I_DeliveryDocument    as _CabRemessa         on _CabRemessa.DeliveryDocument = right(
      _DocsReferencia.btd_id, 10
    )
    inner join            I_BR_NFDocumentFlow_C as _NFDocumentFlow     on _NFDocumentFlow.PredecessorReferenceDocument = right(
      _DocsReferencia.btd_id, 10
    )
    left outer join       vbrk                  as _Fatura             on _Fatura.vbeln = _NFDocumentFlow.ReferenceDocument
    left outer join       t042zt                as _PaymentFormText    on  _PaymentFormText.zlsch = _Fatura.zlsch
                                                                       and _PaymentFormText.land1 = 'BR'
                                                                       and _PaymentFormText.spras = $session.system_language
    left outer join       vbak                  as _OrdemVenda         on _OrdemVenda.vbeln = _NFDocumentFlow.OriginReferenceDocument
    left outer join       tvakt                 as _OrdemVendaTypeText on  _OrdemVendaTypeText.auart = _OrdemVenda.auart
                                                                       and _OrdemVendaTypeText.spras = $session.system_language
{
  key _OrdemFrete.db_key                as TransportationOrderKey,
  key case
        when _Fatura.zlsch = ' ' then '2'
        else '1' end                    as PaymentFormType,
      _OrdemFrete.tor_id                as TransportationOrder,
      _NFDocumentFlow.ReferenceDocument as InvoiceDocument,
      _Fatura.zlsch                     as PaymentForms,
      case
        when _Fatura.zlsch = 'D' or _Fatura.zlsch = 'Z' then 'Boleto'
        when _Fatura.zlsch = '6' or _Fatura.zlsch = '7' then 'Crédito em conta'
        when _Fatura.zlsch = 'C' then 'Cheque'
        when _Fatura.zlsch = 'A' then 'À Vista'
        when _Fatura.zlsch = 'M' then 'Pagamento Antecipado'
        when _Fatura.zlsch = 'K' or _Fatura.zlsch = 'E' then 'Cartão'
        when _Fatura.zlsch = '1' then 'Coligada'
        when _Fatura.zlsch = ' ' then
        case
            when _OrdemVenda.auart = 'Y001' or _OrdemVenda.auart = 'Y002' then 'Bonificação'
            when _OrdemVenda.auart = 'Y009' then 'Degustação'
            when _OrdemVenda.auart = 'Y003' or _OrdemVenda.auart = 'Y004' or _OrdemVenda.auart = 'Y005' or
                 _OrdemVenda.auart = 'Y006' or _OrdemVenda.auart = 'Y010' or _OrdemVenda.auart = 'Y011' or
                 _OrdemVenda.auart = 'Y012' or _OrdemVenda.auart = 'Y013' or _OrdemVenda.auart = 'Y014' or
                 _OrdemVenda.auart = 'Y015' or _OrdemVenda.auart = 'Y016' then 'Marketing'
            when _OrdemVenda.auart = 'Y019' then 'Doação'
            else _OrdemVendaTypeText.bezei
        end
        else _PaymentFormText.text2
      end                               as PaymentDescription,
      @Semantics.amount.currencyCode : 'Moeda'
      _Fatura.netwr + _Fatura.mwsbk     as PaymentValue,
      _Fatura.waerk                     as Moeda
}
where
      _OrdemFrete.tor_cat              =  'TO'
  and _CabRemessa.DeliveryDocumentType <> 'Y026'
