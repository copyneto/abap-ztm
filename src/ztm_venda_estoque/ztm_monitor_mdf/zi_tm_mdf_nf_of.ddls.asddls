@AbapCatalog.sqlViewName: 'ZVTM_MDF_NF_OF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Fiscal X Ordem de Frete'
define view ZI_TM_MDF_NF_OF
  as select from           /scmtms/d_torrot      as _OrdemFrete -- Referência: C_FrtUnitGenDataBasicFacts

    left outer join        /scmtms/d_torite      as _Entrega               on _Entrega.parent_key     = _OrdemFrete.db_key
                                                                           and( _Entrega.base_btd_tco = '73' -- Entrega
                                                                             or _Entrega.base_btd_tco = '58' -- Recebimento
                                                                           )

    left outer to one join /scmtms/d_torrot      as _UnidadeFrete          on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                                           and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

    left outer to one join /scmtms/d_tordrf      as _OrdemVenda            on  _OrdemVenda.parent_key = _UnidadeFrete.db_key
                                                                           and _OrdemVenda.btd_tco    = '114' -- Ordem de Venda

    left outer to one join I_BillingDocumentItem as _Fatura                on  _Fatura.SalesDocument       = right( _OrdemVenda.btd_id, 10 )
                                                                           and _Fatura.ReferenceSDDocument = right( _Entrega.base_btd_id, 10 )
    
    left outer to one join I_BillingDocument     as _FaturaCab             on _FaturaCab.BillingDocument = _Fatura.BillingDocument

    left outer join        I_BR_NFItem           as _NFItem                on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                                                           and _NFItem.BR_NFSourceDocumentNumber = _Fatura.BillingDocument
                                                                           and _NFItem.BR_NFSourceDocumentItem   = _Fatura.BillingDocumentItem

    left outer join        I_BR_NFeActive        as _NFActive              on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

    left outer join        ZI_CA_VH_DOCSTA       as _NFeDocumentStatusText on _NFeDocumentStatusText.StatusDoc = _NFActive.BR_NFeDocumentStatus

{
       @Search.defaultSearchElement: true
  key  _NFItem.BR_NotaFiscal                                                      as BR_NotaFiscal,
       @Search.defaultSearchElement: true
  key  _OrdemFrete.tor_id                                                         as FreightOrder,
  key  cast( right( _Entrega.base_btd_id, 10 ) as vbeln_vl )                      as DeliveryDocument,
       _OrdemFrete.tor_cat                                                        as FreightOrderCategory,
       _OrdemFrete.tor_type                                                       as FreightOrderType,
       @UI.hidden: true
       cast( _OrdemFrete.db_key as /bobf/conf_key preserving type )               as FreightOrderUUID,
       @ObjectModel.text.element: ['BR_NFeDocumentStatusText']
       cast( concat( _NFActive.Region,
       concat( _NFActive.BR_NFeIssueYear,
       concat( _NFActive.BR_NFeIssueMonth,
       concat( _NFActive.BR_NFeAccessKeyCNPJOrCPF,
       concat( _NFActive.BR_NFeModel,
       concat( _NFActive.BR_NFeSeries,
       concat( _NFActive.BR_NFeNumber,
       concat( _NFActive.BR_NFeRandomNumber,
       _NFActive.BR_NFeCheckDigit ) ) ) ) ) ) ) ) as j_1b_nfe_access_key_dtel44 ) as AccessKey,
       _NFActive.BR_NFeDocumentStatus                                             as BR_NFeDocumentStatus,
       _NFActive.BR_NFIsCanceled                                                  as BR_NFIsCanceled,
       _NFeDocumentStatusText.StatusDocText                                       as BR_NFeDocumentStatusText,
       _FaturaCab.BillingDocumentIsCancelled                                      as BillingDocumentIsCancelled,
       _FaturaCab.BillingDocumentType                                             as BillingDocumentType
}
where
      _OrdemFrete.tor_id                    is not initial
  and _OrdemFrete.tor_cat                   =  'TO' -- Ordem de frete
  and _NFItem.BR_NotaFiscal                 is not initial
  and _UnidadeFrete.lifecycle               <> '10' -- Unidade de Frete cancelada
  and _FaturaCab.BillingDocumentIsCancelled <> 'X' -- Fatura estornada
  and _FaturaCab.BillingDocumentType        <> 'S1' -- Tipo de documento diferente de estorno
group by
  _NFItem.BR_NotaFiscal,
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id,
  _Entrega.base_btd_id,
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
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _NFeDocumentStatusText.StatusDocText,
  _FaturaCab.BillingDocumentIsCancelled,  
  _FaturaCab.BillingDocumentType          
  

union select from        /scmtms/d_torrot as _OrdemFrete

  left outer join        /scmtms/d_torite as _Entrega               on _Entrega.parent_key     = _OrdemFrete.db_key
                                                                    and( _Entrega.base_btd_tco = '73' -- Entrega
                                                                      or _Entrega.base_btd_tco = '58' -- Recebimento
                                                                    )

  left outer to one join /scmtms/d_torrot as _UnidadeFrete          on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                                    and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

  left outer join        lips             as _Remessa               on _Remessa.vbeln = right( _Entrega.base_btd_id, 10 )

  left outer join        nsdm_e_mseg      as _Transferencia         on  _Transferencia.ebeln    = _Remessa.vgbel
                                                                    and _Transferencia.ebelp    = right( _Remessa.vgpos, 5 )
                                                                    and _Transferencia.vbeln_im = _Remessa.vbeln
                                                                    and _Transferencia.vbelp_im = _Remessa.posnr

  left outer join        I_BR_NFItem      as _NFItem                on  _NFItem.BR_NFSourceDocumentType   = 'MD'
                                                                    and _NFItem.BR_NFSourceDocumentNumber = concat( left( _Transferencia.mblnr, 10 ), left( _Transferencia.mjahr, 4 ) )

  left outer join        I_BR_NFeActive   as _NFActive              on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer join        ZI_CA_VH_DOCSTA  as _NFeDocumentStatusText on _NFeDocumentStatusText.StatusDoc = _NFActive.BR_NFeDocumentStatus

{
       @Search.defaultSearchElement: true
  key  _NFItem.BR_NotaFiscal                                                      as BR_NotaFiscal,
       @Search.defaultSearchElement: true
  key  _OrdemFrete.tor_id                                                         as FreightOrder,
  key  cast( right( _Entrega.base_btd_id, 10 ) as vbeln_vl )                      as DeliveryDocument,
       _OrdemFrete.tor_cat                                                        as FreightOrderCategory,
       _OrdemFrete.tor_type                                                       as FreightOrderType,
       @UI.hidden: true
       cast( _OrdemFrete.db_key as /bobf/conf_key preserving type )               as FreightOrderUUID,
       @ObjectModel.text.element: ['BR_NFeDocumentStatusText']
       cast( concat( _NFActive.Region,
       concat( _NFActive.BR_NFeIssueYear,
       concat( _NFActive.BR_NFeIssueMonth,
       concat( _NFActive.BR_NFeAccessKeyCNPJOrCPF,
       concat( _NFActive.BR_NFeModel,
       concat( _NFActive.BR_NFeSeries,
       concat( _NFActive.BR_NFeNumber,
       concat( _NFActive.BR_NFeRandomNumber,
       _NFActive.BR_NFeCheckDigit ) ) ) ) ) ) ) ) as j_1b_nfe_access_key_dtel44 ) as AccessKey,
       _NFActive.BR_NFeDocumentStatus                                             as BR_NFeDocumentStatus,
       _NFActive.BR_NFIsCanceled                                                  as BR_NFIsCanceled,
       _NFeDocumentStatusText.StatusDocText                                       as BR_NFeDocumentStatusText,
       cast( '' as fksto )                                                        as BillingDocumentIsCancelled,
       cast( '' as fkart  )                                                       as BillingDocumentType
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
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _NFeDocumentStatusText.StatusDocText
