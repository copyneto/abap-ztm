@AbapCatalog.sqlViewName: 'ZVTM_FRETE_ID_OF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Frete - Identificar OF'
@Search.searchable: true
define view ZI_TM_VH_FRETE_IDENTIFY_FO
  as select from           /scmtms/d_torrot       as _OrdemFrete -- Referência: C_FrtUnitGenDataBasicFacts

    left outer join        /scmtms/d_torite       as _Entrega      on _Entrega.parent_key     = _OrdemFrete.db_key
                                                                   and(
                                                                     _Entrega.base_btd_tco    = '73' -- Entrega
                                                                     or _Entrega.base_btd_tco = '58' -- Recebimento
                                                                   )

    left outer to one join /scmtms/d_torrot       as _UnidadeFrete on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                                   and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

    left outer to one join /scmtms/d_tordrf       as _OrdemVenda   on _OrdemVenda.parent_key = _UnidadeFrete.db_key
                                                                   and(
                                                                     _OrdemVenda.btd_tco     = '114' -- Ordem de Venda
                                                                     or _OrdemVenda.btd_tco  = '32' -- Devolução
                                                                   )

    left outer to one join I_BillingDocumentItem  as _Fatura       on  _Fatura.SalesDocument       = right(
      _OrdemVenda.btd_id, 10
    )
                                                                   and _Fatura.ReferenceSDDocument = right(
      _Entrega.base_btd_id, 10
    )

    left outer join        I_BR_NFItem            as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                                                   and _NFItem.BR_NFSourceDocumentNumber = _Fatura.BillingDocument
                                                                   and _NFItem.BR_NFSourceDocumentItem   = _Fatura.BillingDocumentItem

    left outer join        I_BR_NFDocument        as _NF           on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

    left outer join        I_BR_NFeActive         as _NFActive     on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

    left outer join        I_DeliveryDocument     as _Remessa      on _Remessa.DeliveryDocument = right(
      _Entrega.base_btd_id, 10
    )

    left outer join        I_DeliveryDocumentItem as _RemessaItem  on _RemessaItem.DeliveryDocument = _Remessa.DeliveryDocument

{
      @Search.defaultSearchElement: true
  key cast( concat( _NFActive.Region,
      concat( _NFActive.BR_NFeIssueYear,
      concat( _NFActive.BR_NFeIssueMonth,
      concat( _NFActive.BR_NFeAccessKeyCNPJOrCPF,
      concat( _NFActive.BR_NFeModel,
      concat( _NFActive.BR_NFeSeries,
      concat( _NFActive.BR_NFeNumber,
      concat( _NFActive.BR_NFeRandomNumber,
      _NFActive.BR_NFeCheckDigit ) ) ) ) ) ) ) ) as j_1b_nfe_access_key_dtel44 ) as AccessKey,
      @Search.defaultSearchElement: true
  key _NFItem.BR_NotaFiscal                                                      as BR_NotaFiscal,
      @Search.defaultSearchElement: true
  key _OrdemFrete.tor_id                                                         as FreightOrder,
  key cast( right( _Entrega.base_btd_id, 10 ) as vbeln_vl )                      as DeliveryDocument,
      _RemessaItem.ReferenceSDDocument                                           as SalesDocument,
      _Fatura.BillingDocument                                                    as BillingDocument,
      cast('' as mblnr )                                                         as MaterialDocument,
      cast('' as mjahr )                                                         as MaterialDocumentYear,
      cast('' as ebeln )                                                         as PurchaseOrder,
      cast('' as belnr_d )                                                       as AccountingDocument,
      cast('' as gjahr )                                                         as AccountingDocumentYear,

      _OrdemFrete.tspid                                                          as Carrier,
      _OrdemFrete.tor_cat                                                        as FreightOrderCategory,
      _OrdemFrete.tor_type                                                       as FreightOrderType,
      _NF.BR_NFDocumentType                                                      as BR_NFDocumentType,
      _NFItem.BR_NFSourceDocumentType                                            as BR_NFSourceDocumentType,
      _NFActive.BR_NFeDocumentStatus                                             as BR_NFeDocumentStatus,
      _NFActive.BR_NFIsCanceled                                                  as BR_NFIsCanceled,
      _Remessa.DeliveryDocumentType                                              as DeliveryDocumentType,
      _Remessa.SDDocumentCategory                                                as SDDocumentCategory,
      _Remessa.IncotermsClassification                                           as IncotermsClassification
}
where
      _OrdemFrete.tor_id      is not initial
  and _OrdemFrete.tor_cat     =  'TO' -- Ordem de frete
  and _NFItem.BR_NotaFiscal   is not initial
  and _UnidadeFrete.lifecycle <> '10' -- Unidade de Frete cancelada
group by
  _NFItem.BR_NotaFiscal,
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _Entrega.base_btd_id,
  _RemessaItem.ReferenceSDDocument,
  _Fatura.BillingDocument,
  _OrdemFrete.tspid,
  _OrdemFrete.tor_cat,
  _OrdemFrete.tor_type,
  _NFActive.Region,
  _NFActive.BR_NFeIssueYear,
  _NFActive.BR_NFeIssueMonth,
  _NFActive.BR_NFeAccessKeyCNPJOrCPF,
  _NFActive.BR_NFeModel,
  _NFActive.BR_NFeSeries,
  _NFActive.BR_NFeNumber,
  _NFActive.BR_NFeRandomNumber,
  _NFActive.BR_NFeCheckDigit,
  _NF.BR_NFDocumentType,
  _NFItem.BR_NFSourceDocumentType,
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _Remessa.DeliveryDocumentType,
  _Remessa.SDDocumentCategory,
  _Remessa.IncotermsClassification

/* ----------------------------------------------------------------------
   Cenário de Transferência
---------------------------------------------------------------------- */

union select from        /scmtms/d_torrot   as _OrdemFrete

  left outer join        /scmtms/d_torite   as _Entrega       on _Entrega.parent_key     = _OrdemFrete.db_key
                                                              and(
                                                                _Entrega.base_btd_tco    = '73'      -- Entrega
                                                                or _Entrega.base_btd_tco = '58'      -- Recebimento
                                                              )

  left outer to one join /scmtms/d_torrot   as _UnidadeFrete  on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                              and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

  left outer join        lips               as _RemessaItem   on _RemessaItem.vbeln = right(
    _Entrega.base_btd_id, 10
  )

  left outer join        I_DeliveryDocument as _Remessa       on _Remessa.DeliveryDocument = right(
    _Entrega.base_btd_id, 10
  )

  left outer join        nsdm_e_mseg        as _Transferencia on  _Transferencia.ebeln    = _RemessaItem.vgbel
                                                              and _Transferencia.ebelp    = right(
    _RemessaItem.vgpos, 5
  )
                                                              and _Transferencia.vbeln_im = _RemessaItem.vbeln
                                                              and _Transferencia.vbelp_im = _RemessaItem.posnr

  left outer join        I_BR_NFItem        as _NFItem        on  _NFItem.BR_NFSourceDocumentType   = 'MD'
                                                              and _NFItem.BR_NFSourceDocumentNumber = concat(
    left(
      _Transferencia.mblnr, 10
    ), left(
      _Transferencia.mjahr, 4
    )
  )

  left outer join        I_BR_NFDocument    as _NF            on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer join        I_BR_NFeActive     as _NFActive      on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal


{
      @Search.defaultSearchElement: true
  key cast( concat( _NFActive.Region,
        concat( _NFActive.BR_NFeIssueYear,
        concat( _NFActive.BR_NFeIssueMonth,
        concat( _NFActive.BR_NFeAccessKeyCNPJOrCPF,
        concat( _NFActive.BR_NFeModel,
        concat( _NFActive.BR_NFeSeries,
        concat( _NFActive.BR_NFeNumber,
        concat( _NFActive.BR_NFeRandomNumber,
        _NFActive.BR_NFeCheckDigit ) ) ) ) ) ) ) ) as j_1b_nfe_access_key_dtel44 ) as AccessKey,
      @Search.defaultSearchElement: true
  key _NFItem.BR_NotaFiscal                                                        as BR_NotaFiscal,
      @Search.defaultSearchElement: true
  key _OrdemFrete.tor_id                                                           as FreightOrder,
  key cast( right( _Entrega.base_btd_id, 10 ) as vbeln_vl )                        as DeliveryDocument,
      _RemessaItem.vgbel                                                           as SalesDocument,
      cast('' as vbeln_vf )                                                        as BillingDocument,
      _Transferencia.mblnr                                                         as MaterialDocument,
      _Transferencia.mjahr                                                         as MaterialDocumentYear,
      cast('' as ebeln )                                                           as PurchaseOrder,
      cast('' as belnr_d )                                                         as AccountingDocument,
      cast('' as gjahr )                                                           as AccountingDocumentYear,

      _OrdemFrete.tspid                                                            as Carrier,
      _OrdemFrete.tor_cat                                                          as FreightOrderCategory,
      _OrdemFrete.tor_type                                                         as FreightOrderType,
      _NF.BR_NFDocumentType                                                        as BR_NFDocumentType,
      _NFItem.BR_NFSourceDocumentType                                              as BR_NFSourceDocumentType,
      _NFActive.BR_NFeDocumentStatus                                               as BR_NFeDocumentStatus,
      _NFActive.BR_NFIsCanceled                                                    as BR_NFIsCanceled,
      _Remessa.DeliveryDocumentType                                                as DeliveryDocumentType,
      _Remessa.SDDocumentCategory                                                  as SDDocumentCategory,
      _Remessa.IncotermsClassification                                             as IncotermsClassification
}
where
      _OrdemFrete.tor_id      is not initial
  and _OrdemFrete.tor_cat     =  'TO' -- Ordem de frete
  and _NFItem.BR_NotaFiscal   is not initial
  and _UnidadeFrete.lifecycle <> '10' -- Unidade de Frete cancelada
group by
  _NFItem.BR_NotaFiscal,
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _Entrega.base_btd_id,
  _RemessaItem.vgbel,
  _Transferencia.mblnr,
  _Transferencia.mjahr,
  _OrdemFrete.tspid,
  _OrdemFrete.tor_cat,
  _OrdemFrete.tor_type,
  _NFActive.Region,
  _NFActive.BR_NFeIssueYear,
  _NFActive.BR_NFeIssueMonth,
  _NFActive.BR_NFeAccessKeyCNPJOrCPF,
  _NFActive.BR_NFeModel,
  _NFActive.BR_NFeSeries,
  _NFActive.BR_NFeNumber,
  _NFActive.BR_NFeRandomNumber,
  _NFActive.BR_NFeCheckDigit,
  _NF.BR_NFDocumentType,
  _NFItem.BR_NFSourceDocumentType,
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _Remessa.DeliveryDocumentType,
  _Remessa.SDDocumentCategory,
  _Remessa.IncotermsClassification

/* ----------------------------------------------------------------------
   Cenário de Venda Coligada
---------------------------------------------------------------------- */

union select from        /scmtms/d_torrot   as _OrdemFrete

  left outer join        /scmtms/d_torite   as _Entrega      on _Entrega.parent_key     = _OrdemFrete.db_key
                                                             and(
                                                               _Entrega.base_btd_tco    = '73'       -- Entrega
                                                               or _Entrega.base_btd_tco = '58'       -- Recebimento
                                                             )

  left outer to one join /scmtms/d_torrot   as _UnidadeFrete on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                             and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

  left outer join        lips               as _RemessaItem  on _RemessaItem.vbeln = right(
    _Entrega.base_btd_id, 10
  )

  left outer join        I_DeliveryDocument as _Remessa      on _Remessa.DeliveryDocument = right(
    _Entrega.base_btd_id, 10
  )

  left outer join        ekes               as _Pedido       on _Pedido.vbeln = right(
    _Entrega.base_btd_id, 10
  )

  left outer join        rseg               as _Fatura       on  _Fatura.ebeln = _Pedido.ebeln
                                                             and _Fatura.ebelp = _Pedido.ebelp

  left outer join        I_BR_NFItem        as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'LI'
                                                             and _NFItem.BR_NFSourceDocumentNumber = concat(
    left(
      _Fatura.belnr, 10
    ), left(
      _Fatura.gjahr, 4
    )
  )

  left outer join        I_BR_NFDocument    as _NF           on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer join        I_BR_NFeActive     as _NFActive     on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

{
      @Search.defaultSearchElement: true
  key cast( concat( _NFActive.Region,
        concat( _NFActive.BR_NFeIssueYear,
        concat( _NFActive.BR_NFeIssueMonth,
        concat( _NFActive.BR_NFeAccessKeyCNPJOrCPF,
        concat( _NFActive.BR_NFeModel,
        concat( _NFActive.BR_NFeSeries,
        concat( _NFActive.BR_NFeNumber,
        concat( _NFActive.BR_NFeRandomNumber,
        _NFActive.BR_NFeCheckDigit ) ) ) ) ) ) ) ) as j_1b_nfe_access_key_dtel44 ) as AccessKey,
      @Search.defaultSearchElement: true
  key _NFItem.BR_NotaFiscal                                                        as BR_NotaFiscal,
      @Search.defaultSearchElement: true
  key _OrdemFrete.tor_id                                                           as FreightOrder,
  key cast( right( _Entrega.base_btd_id, 10 ) as vbeln_vl )                        as DeliveryDocument,
      _RemessaItem.vgbel                                                           as SalesDocument,
      cast('' as vbeln_vf )                                                        as BillingDocument,
      cast('' as mblnr )                                                           as MaterialDocument,
      cast('' as mjahr )                                                           as MaterialDocumentYear,
      _Pedido.ebeln                                                                as PurchaseOrder,
      _Fatura.belnr                                                                as AccountingDocument,
      _Fatura.gjahr                                                                as AccountingDocumentYear,

      _OrdemFrete.tspid                                                            as Carrier,
      _OrdemFrete.tor_cat                                                          as FreightOrderCategory,
      _OrdemFrete.tor_type                                                         as FreightOrderType,
      _NF.BR_NFDocumentType                                                        as BR_NFDocumentType,
      _NFItem.BR_NFSourceDocumentType                                              as BR_NFSourceDocumentType,
      _NFActive.BR_NFeDocumentStatus                                               as BR_NFeDocumentStatus,
      _NFActive.BR_NFIsCanceled                                                    as BR_NFIsCanceled,
      _Remessa.DeliveryDocumentType                                                as DeliveryDocumentType,
      _Remessa.SDDocumentCategory                                                  as SDDocumentCategory,
      _Remessa.IncotermsClassification                                             as IncotermsClassification
}
where
      _OrdemFrete.tor_id      is not initial
  and _OrdemFrete.tor_cat     =  'TO' -- Ordem de frete
  and _NFItem.BR_NotaFiscal   is not initial
  and _UnidadeFrete.lifecycle <> '10' -- Unidade de Frete cancelada
group by
  _NFItem.BR_NotaFiscal,
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _Entrega.base_btd_id,
  _RemessaItem.vgbel,
  _Pedido.ebeln,
  _Fatura.belnr,
  _Fatura.gjahr,
  _OrdemFrete.tspid,
  _OrdemFrete.tor_cat,
  _OrdemFrete.tor_type,
  _NFActive.Region,
  _NFActive.BR_NFeIssueYear,
  _NFActive.BR_NFeIssueMonth,
  _NFActive.BR_NFeAccessKeyCNPJOrCPF,
  _NFActive.BR_NFeModel,
  _NFActive.BR_NFeSeries,
  _NFActive.BR_NFeNumber,
  _NFActive.BR_NFeRandomNumber,
  _NFActive.BR_NFeCheckDigit,
  _NF.BR_NFDocumentType,
  _NFItem.BR_NFSourceDocumentType,
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _Remessa.DeliveryDocumentType,
  _Remessa.SDDocumentCategory,
  _Remessa.IncotermsClassification
