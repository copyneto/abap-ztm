@AbapCatalog.sqlViewName: 'ZTM_REL_CED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface principal'
define view ZI_TM_REL_CUSTOS_ENTREGA_DEV
  as select from    ZI_TM_FLUXONF_ITEM    as _FluxoDocumentosNF //ZI_TM_FLUXONF - Cds versao 1 (funcional)
    left outer join C_BR_VerifyNotaFiscal as _VerifyNF      on _FluxoDocumentosNF.BR_NotaFiscal = _VerifyNF.BR_NotaFiscal
    left outer join zttm_gkot003          as _GKO_t003      on _FluxoDocumentosNF.BR_NotaFiscal = _GKO_t003.docnum
    left outer join zttm_gkot001          as _GKO_t001      on _GKO_t003.acckey = _GKO_t001.acckey
    left outer join ZI_TM_STOP            as _StopOri       on  _FluxoDocumentosNF.SourceStopUUID = _StopOri.DbKey
                                                            and _StopOri.stop_cat                 = 'O'
                                                            and _StopOri.stop_seq_pos             = 'F'
    left outer join ZI_TM_STOP            as _StopDest      on  _FluxoDocumentosNF.DestinationStopUUID =  _StopDest.DbKey
                                                            and _StopDest.stop_cat                     <> 'O'
                                                            and _StopDest.stop_seq_pos                 <> 'F'
    left outer join ZI_TM_MIRO            as _DocMIRO       on  _StopDest.ParentKey                = _DocMIRO.TorRootKey
                                                            and (
                                                               _DocMIRO.StatusCicloVida            = '04'
                                                               or _DocMIRO.StatusCicloVida         = '10'
                                                             )
                                                            and _DocMIRO.CategoriaFaturamentoFrete = '10'
  //    left outer join ZI_TM_PIS_CONFINS     as _PisCofins     on _StopDest.ParentKey = _DocMIRO.TorRootKey
    left outer join ZI_TM_PIS_CONFINS     as _PisCofins     on  _PisCofins.TransportationOrderId     = _FluxoDocumentosNF.TransportationOrderUUID
                                                            and _PisCofins.TransportationOrderItemId = _FluxoDocumentosNF.TransportationOrderItemUUID
    left outer join ZI_TM_CLI_COMPRA      as _ClienteCompra on _StopDest.UG = _ClienteCompra.LocationId
{
  key _FluxoDocumentosNF.TransportationOrderUUID                                                    as OrdemId,
      _FluxoDocumentosNF.DestinationStopUUID                                                        as DestID,
      _FluxoDocumentosNF.TransportationOrder                                                        as OrdemFreteNum,

      tstmp_to_dats(_FluxoDocumentosNF.CreationDateTime,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                                                       as DataCriacaoOF,

      _FluxoDocumentosNF.CreatedByUser                                                              as CriadoPorOF,
      _FluxoDocumentosNF.PlateNumber                                                                as Placa,
      _FluxoDocumentosNF.TuresCat                                                                   as GrupoVeiculo,
      _FluxoDocumentosNF.TuresTco                                                                   as TipoVeiculo,

      _FluxoDocumentosNF.BR_NotaFiscal                                                              as DocNum,
      lpad(_FluxoDocumentosNF.BR_NFeNumber, 9, '0')                                                 as NotaFiscalNum,
      _FluxoDocumentosNF.BR_NFIssueDate                                                             as DataEmissaoNFe,
      _FluxoDocumentosNF.BR_NFeAccessKey                                                            as ChaveAcessoNfe,


      _StopOri.Motorista                                                                            as Motorista,

      _GKO_t001.dtemi                                                                               as DataEmissaoDocFrete,
      _GKO_t001.acckey                                                                              as ChaveAcessoDocFrete,
      _GKO_t001.nfnum9                                                                              as CTENum, //Número de 9 posições
      _GKO_t001.prefno                                                                              as NFSDanfeNum,

      _StopOri.UG                                                                                   as UGOrigem,
      _StopOri.UF                                                                                   as UFOrigem,
      _StopOri.Cidade                                                                               as CidadeOrigem,

      //_StopOri.DataPlanejada                                                                        as DataSaidaPlanejada,
      tstmp_to_dats(_StopOri.DataPlanejada,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                                                       as DataSaidaPlanejada,

      //_StopOri.DataReal                                                                             as DataSaidaReal,
      tstmp_to_dats(_StopOri.DataReal,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                                                       as DataSaidaReal,

      _StopDest.UG                                                                                  as UGDestino,
      _StopDest.UF                                                                                  as UFDestino,
      _StopDest.Cidade                                                                              as CidadeDestino,

      //_StopDest.DataPlanejada                                                                       as DataChegadaPlanejada,
      tstmp_to_dats(_StopDest.DataPlanejada,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                                                       as DataChegadaPlanejada,

      tstmp_to_dats(_StopDest.DataReal,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                                                       as DataChegadaReal,

      _StopDest.BloqueioPlanejamento                                                                as BloqueioPlanejamento,
      _StopDest.BloqueioExecucao                                                                    as BloqueioExecucao,
      round(_FluxoDocumentosNF.TranspOrdMaxUtilznRatio, 0)                                          as UtilizacaoMaximaOF,

      _StopOri.CondicaoExpedicao                                                                    as CondicaoExpedicao,
      _StopOri.DescCondicaoExpedicao                                                                as DescCondicaoExpedicao,
      _StopOri.CodigoLocalTransporte                                                                as CodigoLocalTransporte,
      _StopOri.DescLocalTransporte                                                                  as DescLocalTransporte,
      _StopOri.CodigoTransportadora                                                                 as CodigoTransportadora,
      _StopOri.NomeTransportadora                                                                   as NomeTransportadora,
      _FluxoDocumentosNF.ProductName                                                                as NomeProduto,
      substring(_FluxoDocumentosNF.ProductHierarchy, 1, 5)                                          as ProductHierarchy5,

      _StopOri.TipoExpedicao                                                                        as TipoExpedicao,
      _StopOri.DescTipoExpedicao                                                                    as DescTipoExpedicao,

      case
       when _FluxoDocumentosNF.TranspOrdDocReferenceType = '58' then _ClienteCompra.CodigoBP
       else _FluxoDocumentosNF.Consignee
      end                                                                                           as CodigoCliente,

      case
       when _FluxoDocumentosNF.TranspOrdDocReferenceType = '58' then _ClienteCompra.NomeBP
       else _FluxoDocumentosNF.BusinessPartnerName
      end                                                                                           as NomeCliente,

      _FluxoDocumentosNF.TranspOrdDocReferenceID                                                    as NumeroRemessa,
      _FluxoDocumentosNF.DeliveryDocumentType                                                       as TipoRemessa,
      _FluxoDocumentosNF.DeliveryDocumentTypeName                                                   as DescTipoRemessa,

      _FluxoDocumentosNF.ProductGroup                                                               as CodigoGrupoMercadorias,
      _FluxoDocumentosNF.ProductID                                                                  as CodigoProduto,

      substring(_FluxoDocumentosNF.ProductHierarchy, 1, 10)                                         as ProductHierarchy10,

      _FluxoDocumentosNF.LastChangedByUser                                                          as ModificadoPor,
      _FluxoDocumentosNF.ProductHierarchy                                                           as ProductHierarchy,
      _FluxoDocumentosNF.MaterialGroupText                                                          as DescGrupoMercadoria,

      //     @ObjectModel.text.element: ['DescTipoTransporte']
      _FluxoDocumentosNF.TransportationMode                                                         as CodigoTipoTransporte,
      _FluxoDocumentosNF.TransportationModeDesc                                                     as DescTipoTransporte,

      _GKO_t001.num_fatura                                                                          as NumeroFaturaGKO,
      _FluxoDocumentosNF.TranspOrdLifeCycleStatus                                                   as StatusOrdemFreteCicloVida,
      _FluxoDocumentosNF.TranspOrdLifeCycleStatusText                                               as DescStatusOrdemFreteCicloVida,

      _FluxoDocumentosNF.TranspOrdPlanningStatus                                                    as StatusOrdemFretePlanejamento,


      _FluxoDocumentosNF.TranspOrdPlanningStatusDesc                                                as DescStatusOrdemFretePlan,
      //''                                                                                            as DescStatusOrdemFretePlan,

      _FluxoDocumentosNF.TransportationOrderExecSts                                                 as StatusOrdemFreteExecucao,
      _FluxoDocumentosNF.TransportationOrderExecStsDesc                                             as DescStatusOrdemFreteExecucao,

      _StopOri.NumeroCargaSAGA                                                                      as NumeroCargaSAGA,

      _FluxoDocumentosNF.TransportationOrderType                                                    as TipoOrdemFrete,
      _FluxoDocumentosNF.TransportationOrderTypeDesc                                                as DescTipoOrdemFrete,

      _FluxoDocumentosNF.FreghtUnit                                                                 as UnidadeFrete,
      //_FluxoDocumentosNF.UnidadeFrete                                                               as UnidadeFrete,

      cast(_FluxoDocumentosNF.TranspOrdItemGrossWeight as abap.dec( 15, 2))                         as PesoBruto,
      _FluxoDocumentosNF.TranspOrdItemGrossWeightUnit                                               as PesoBrutoUnidade,
      cast(_FluxoDocumentosNF.TranspOrdItemNetWeight as abap.dec( 15, 2))                           as PesoLiquido,
      _FluxoDocumentosNF.TranspOrdItemNetWeightUnit                                                 as PesoLiquidoUnidade,

      _FluxoDocumentosNF.VolumeCubadoEcom,
      _FluxoDocumentosNF.PesoBrutoEcom,

      _DocMIRO.DocRefFatura,
      _DocMIRO.AnoExcercicio,

      _FluxoDocumentosNF.TotalItensNF,

      ////TODO: Obter valor pela CDS ZI_TM_FLUXONF_ITEM
      _FluxoDocumentosNF.BR_NFValueAmountWithTaxes                                                  as ValorNFITEM, //Valor Nota Fiscal (R$) Item,

      _PisCofins.Pis                                                                                as Pis,
      _PisCofins.Cofins                                                                             as Cofins,
      _GKO_t001.vtprest                                                                             as ValorFreteBruto,
      _GKO_t001.vicms                                                                               as ValorICMS,
      _GKO_t001.viss                                                                                as ValorISS,
      _GKO_t001.vrec                                                                                as ValorCreditoICMS,

      //Custo da Entrega Líquido (R$) - Formula = VTPREST - ((VICMS + VISS)+(Valor PIS + Valor COFINS))
      _GKO_t001.vtprest - ( (_GKO_t001.vicms + _GKO_t001.viss) + (_PisCofins.Pis + _PisCofins.Cofins) ) as CustoEntregaLiquidoRS

}
