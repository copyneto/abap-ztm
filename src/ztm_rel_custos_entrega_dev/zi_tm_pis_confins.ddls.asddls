@AbapCatalog.sqlViewName: 'ZTMTPC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Obter valor Taxa (PIS/COFINS)'
//define view ZI_TM_PIS_CONFINS
//  as select from ZI_TM_MIRO as _DocMIRO
//    inner join   rbkp       as _FaturaCabecalho     on  _DocMIRO.DocRefFatura  = _FaturaCabecalho.belnr
//                                                    and _DocMIRO.AnoExcercicio = _FaturaCabecalho.gjahr
//    inner join   j_1bnfdoc  as _NotaFiscalCabecalho on  _DocMIRO.DocRefFatura  = _NotaFiscalCabecalho.belnr
//                                                    and _DocMIRO.AnoExcercicio = _NotaFiscalCabecalho.gjahr
//    inner join   j_1bnfstx  as _ImpostoItemNFPIS    on  _NotaFiscalCabecalho.docnum = _ImpostoItemNFPIS.docnum
//                                                    and _ImpostoItemNFPIS.taxgrp    = 'PIS'
//    inner join   j_1bnfstx  as _ImpostoItemNFCOFI   on  _NotaFiscalCabecalho.docnum = _ImpostoItemNFCOFI.docnum
//                                                    and _ImpostoItemNFCOFI.taxgrp   = 'COFI'
//
//{
//  _DocMIRO.TorRootKey,
//  sum(_ImpostoItemNFPIS.rate)  as Pis,
//  sum(_ImpostoItemNFCOFI.rate) as Cofins
//}
//where
//  (
//       _DocMIRO.StatusCicloVida           = '04'
//    or _DocMIRO.StatusCicloVida           = '10'
//  )
//  and  _DocMIRO.CategoriaFaturamentoFrete = '10'
//  and  _FaturaCabecalho.stblg             = '' //Não houve estorno
//
//group by
//  _DocMIRO.TorRootKey

define view ZI_TM_PIS_CONFINS
  as select distinct from ZI_TM_DFF_FLOW as _DffDocument
    inner join            j_1bnfdoc      as _NotaFiscalCabecalho on  _DffDocument.SupplierInvoice = _NotaFiscalCabecalho.belnr
                                                                 and _DffDocument.FiscalYear      = _NotaFiscalCabecalho.gjahr
    inner join            j_1bnfstx      as _ImpostoItemNFPIS    on  _NotaFiscalCabecalho.docnum = _ImpostoItemNFPIS.docnum
                                                                 and _ImpostoItemNFPIS.taxgrp    = 'PIS'
    inner join            j_1bnfstx      as _ImpostoItemNFCOFI   on  _NotaFiscalCabecalho.docnum = _ImpostoItemNFCOFI.docnum
                                                                 and _ImpostoItemNFCOFI.taxgrp   = 'COFI'

{
  key _DffDocument.TransportationOrderId,
  key _DffDocument.TransportationOrderItemId,
      _DffDocument.TransportationOrder,
      _DffDocument.TransportationOrderItem,
      sum(_ImpostoItemNFPIS.taxval)  as Pis,
      sum(_ImpostoItemNFCOFI.taxval) as Cofins
}
where
      _DffDocument.ReverseDocument      = '' //Não houve estorno
  and _DffDocument.DFFDocumentLifeCycle = '07'

group by
  _DffDocument.TransportationOrderId,
  _DffDocument.TransportationOrderItemId,
  _DffDocument.TransportationOrder,
  _DffDocument.TransportationOrderItem
