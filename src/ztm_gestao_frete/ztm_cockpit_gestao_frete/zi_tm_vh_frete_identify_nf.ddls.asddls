@AbapCatalog.sqlViewName: 'ZVTM_FRETE_ID_NF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Frete - Identificar NF'
@Search.searchable: true
define view ZI_TM_VH_FRETE_IDENTIFY_NF
  as select from    I_DeliveryDocument     as _Remessa

    left outer join I_DeliveryDocumentItem as _RemessaItem on _RemessaItem.DeliveryDocument = _Remessa.DeliveryDocument

    left outer join I_BillingDocumentItem  as _Fatura      on  _Fatura.SalesDocument       = _RemessaItem.ReferenceSDDocument
                                                           and _Fatura.ReferenceSDDocument = _Remessa.DeliveryDocument

    left outer join I_BR_NFItem            as _NFItem      on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                                           and _NFItem.BR_NFSourceDocumentNumber = _Fatura.BillingDocument
                                                           and _NFItem.BR_NFSourceDocumentItem   = _Fatura.BillingDocumentItem

    left outer join I_BR_NFDocument        as _NF          on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

    left outer join I_BR_NFeActive         as _NFActive    on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

{
      @Search.defaultSearchElement: true
  key _Remessa.DeliveryDocument        as DeliveryDocument,
      _RemessaItem.ReferenceSDDocument as SalesDocument,
      _Fatura.BillingDocument          as BillingDocument,
      cast('' as mblnr )               as MaterialDocument,
      cast('' as mjahr )               as MaterialDocumentYear,
      cast('' as ebeln )               as PurchaseOrder, 
      cast('' as belnr_d )             as AccountingDocument, 
      cast('' as gjahr )               as AccountingDocumentYear, 
      _NF.BR_NotaFiscal                as BR_NotaFiscal,
      
      _Remessa.DeliveryDocumentType    as DeliveryDocumentType,
      _Remessa.SDDocumentCategory      as SDDocumentCategory,
      _Remessa.IncotermsClassification as IncotermsClassification,
      
      _NF.BR_NFDocumentType            as BR_NFDocumentType,
      _NFItem.BR_NFSourceDocumentType  as BR_NFSourceDocumentType,
      _NFActive.BR_NFeDocumentStatus   as BR_NFeDocumentStatus,
      _NFActive.BR_NFIsCanceled        as BR_NFIsCanceled,
      _NF.BR_NFPostingDate             as BR_NFPostingDate
}
where
  _NFItem.BR_NotaFiscal is not null
group by
  _Remessa.DeliveryDocument,
  _RemessaItem.ReferenceSDDocument, 
  _Fatura.BillingDocument,          
  _NF.BR_NotaFiscal,   
  _Remessa.DeliveryDocumentType,
  _Remessa.SDDocumentCategory,
  _Remessa.IncotermsClassification,
  _NF.BR_NFDocumentType,
  _NFItem.BR_NFSourceDocumentType,
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _NF.BR_NFPostingDate

/* ----------------------------------------------------------------------
   Cenário de Transferência
---------------------------------------------------------------------- */

union select from I_DeliveryDocument     as _Remessa

  left outer join I_DeliveryDocumentItem as _RemessaItem   on _RemessaItem.DeliveryDocument = _Remessa.DeliveryDocument

  left outer join nsdm_e_mseg            as _Transferencia on  _Transferencia.ebeln    = _RemessaItem.ReferenceSDDocument
                                                           and _Transferencia.ebelp    = right( _RemessaItem.ReferenceSDDocumentItem, 5 )
                                                           and _Transferencia.vbeln_im = _RemessaItem.DeliveryDocument
                                                           and _Transferencia.vbelp_im = _RemessaItem.DeliveryDocumentItem

  left outer join I_BR_NFItem            as _NFItem        on  _NFItem.BR_NFSourceDocumentType   = 'MD'
                                                           and _NFItem.BR_NFSourceDocumentNumber = concat( left( _Transferencia.mblnr, 10 ), 
                                                                                                           left( _Transferencia.mjahr, 4 ) )

  left outer join I_BR_NFDocument        as _NF            on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer join I_BR_NFeActive         as _NFActive      on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal


{
      @Search.defaultSearchElement: true
  key _Remessa.DeliveryDocument        as DeliveryDocument,
      _RemessaItem.ReferenceSDDocument as SalesDocument,
      cast('' as vbeln_vf )            as BillingDocument, 
      _Transferencia.mblnr             as MaterialDocument,
      _Transferencia.mjahr             as MaterialDocumentYear,
      cast('' as ebeln )               as PurchaseOrder, 
      cast('' as belnr_d )             as AccountingDocument, 
      cast('' as gjahr )               as AccountingDocumentYear, 
      _NF.BR_NotaFiscal                as BR_NotaFiscal,
      
      _Remessa.DeliveryDocumentType    as DeliveryDocumentType,
      _Remessa.SDDocumentCategory      as SDDocumentCategory,
      _Remessa.IncotermsClassification as IncotermsClassification,
      
      _NF.BR_NFDocumentType            as BR_NFDocumentType,
      _NFItem.BR_NFSourceDocumentType  as BR_NFSourceDocumentType,
      _NFActive.BR_NFeDocumentStatus   as BR_NFeDocumentStatus,
      _NFActive.BR_NFIsCanceled        as BR_NFIsCanceled,
      _NF.BR_NFPostingDate             as BR_NFPostingDate
}
where
  _NFItem.BR_NotaFiscal is not null
group by
  _Remessa.DeliveryDocument,
  _RemessaItem.ReferenceSDDocument, 
  _Transferencia.mblnr,
  _Transferencia.mjahr,
  _NF.BR_NotaFiscal,   
  _Remessa.DeliveryDocumentType,
  _Remessa.SDDocumentCategory,
  _Remessa.IncotermsClassification,
  _NF.BR_NFDocumentType,
  _NFItem.BR_NFSourceDocumentType,
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _NF.BR_NFPostingDate

/* ----------------------------------------------------------------------
   Cenário de Venda Coligada
---------------------------------------------------------------------- */

union select from I_DeliveryDocument     as _Remessa

  left outer join I_DeliveryDocumentItem as _RemessaItem on _RemessaItem.DeliveryDocument = _Remessa.DeliveryDocument

  left outer join ekes                   as _Pedido      on _Pedido.vbeln = _Remessa.DeliveryDocument

  left outer join rseg                   as _Fatura      on  _Fatura.ebeln = _Pedido.ebeln
                                                         and _Fatura.ebelp = _Pedido.ebelp

  left outer join I_BR_NFItem            as _NFItem      on  _NFItem.BR_NFSourceDocumentType   = 'LI'
                                                         and _NFItem.BR_NFSourceDocumentNumber = concat( left( _Fatura.belnr, 10 ), 
                                                                                                         left( _Fatura.gjahr, 4 ) )

  left outer join I_BR_NFDocument        as _NF          on _NF.BR_NotaFiscal = _NFItem.BR_NotaFiscal

  left outer join I_BR_NFeActive         as _NFActive    on _NFActive.BR_NotaFiscal = _NFItem.BR_NotaFiscal

{
      @Search.defaultSearchElement: true
  key _Remessa.DeliveryDocument        as DeliveryDocument,
      _RemessaItem.ReferenceSDDocument as SalesDocument,
      cast('' as vbeln_vf )            as BillingDocument, 
      cast('' as mblnr )               as MaterialDocument,
      cast('' as mjahr )               as MaterialDocumentYear,
      _Pedido.ebeln                    as PurchaseOrder,
      _Fatura.belnr                    as AccountingDocument,
      _Fatura.gjahr                    as AccountingDocumentYear,
      _NF.BR_NotaFiscal                as BR_NotaFiscal,
      
      _Remessa.DeliveryDocumentType    as DeliveryDocumentType,
      _Remessa.SDDocumentCategory      as SDDocumentCategory,
      _Remessa.IncotermsClassification as IncotermsClassification,
      
      _NF.BR_NFDocumentType            as BR_NFDocumentType,
      _NFItem.BR_NFSourceDocumentType  as BR_NFSourceDocumentType,
      _NFActive.BR_NFeDocumentStatus   as BR_NFeDocumentStatus,
      _NFActive.BR_NFIsCanceled        as BR_NFIsCanceled,
      _NF.BR_NFPostingDate             as BR_NFPostingDate
}
where
  _NFItem.BR_NotaFiscal is not null
group by
  _Remessa.DeliveryDocument,
  _RemessaItem.ReferenceSDDocument, 
  _Pedido.ebeln,
  _Fatura.belnr,
  _Fatura.gjahr,
  _NF.BR_NotaFiscal,   
  _Remessa.DeliveryDocumentType,
  _Remessa.SDDocumentCategory,
  _Remessa.IncotermsClassification,
  _NF.BR_NFDocumentType,
  _NFItem.BR_NFSourceDocumentType,
  _NFActive.BR_NFeDocumentStatus,
  _NFActive.BR_NFIsCanceled,
  _NF.BR_NFPostingDate
