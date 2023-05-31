@AbapCatalog.sqlViewName: 'ZTM_REL_PED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface principal'
define view ZI_TM_REL_PLAN_ENTREGA_DIST
  as select from    ZI_TM_FLUXONF_ITEM         as _FluxoDocumentosNF
    left outer join /scmtms/d_torstp           as _Stop                on _FluxoDocumentosNF.DestinationStopUUID = _Stop.db_key
    left outer join ZI_TM_CLI_COMPRA           as _Cliente             on _Stop.log_locid = _Cliente.LocationId
    left outer join ZI_SD_VH_AREA_ATENDIMENTO  as _AreaAtendimento     on _AreaAtendimento.AreaAtendimento = _Cliente.AreaAtendimento
    left outer join ZI_TM_STOP                 as _StopOri             on  _FluxoDocumentosNF.SourceStopUUID = _StopOri.DbKey
                                                                       and _StopOri.stop_cat                 = 'O'
                                                                       and _StopOri.stop_seq_pos             = 'F'
  //left outer join C_BR_VerifyNotaFiscal      as _NotaFiscal          on _FluxoDocumentosNF.BR_NotaFiscal = _NotaFiscal.BR_NotaFiscal
    left outer join I_BillingDocument          as _BillingDocument     on _BillingDocument.BillingDocument = _FluxoDocumentosNF.InvoiceDocument
    left outer join I_BillingDocumentTypeText  as _BillingDocumentText on  _BillingDocument.BillingDocumentType = _BillingDocumentText.BillingDocumentType
                                                                       and _BillingDocumentText.Language        = $session.system_language
    left outer join ZI_TM_GESTAO_FROTA_DRIVER  as _MotoristaFrota      on _FluxoDocumentosNF.TransportationOrder = _MotoristaFrota.FreightOrder
    left outer join but000                     as _MotoristaBP         on _MotoristaFrota.Driver = _MotoristaBP.partner
  //left outer join ztsd_devolucao             as _Devolucao           on _FluxoDocumentosNF.SalesOrderDocument = _Devolucao.ordem
    left outer join ZI_SD_COCKPIT_DEVOLUCAO    as _Devolucao           on _FluxoDocumentosNF.BR_NFeAccessKey = _Devolucao.ChaveAcesso
    left outer join I_BillingDocument          as _BillingDocumentDev  on _BillingDocumentDev.BillingDocument = _Devolucao.Fatura
    left outer join ZI_SD_MOTIVOS_RESPONSAVEIS as _MotResponsaveis     on _Devolucao.Motivo = _MotResponsaveis.Augru
    left outer join I_SalesDocumentPartner     as _SalesDocPartner     on _FluxoDocumentosNF.SalesOrderDocument = _SalesDocPartner.SalesDocument
                                                                       and(
                                                                         _SalesDocPartner.PartnerFunction       = 'ZI'
                                                                         or _SalesDocPartner.PartnerFunction    = 'ZY'
                                                                         or _SalesDocPartner.PartnerFunction    = 'ZE'
                                                                       )
    left outer join I_BusinessPartner          as _BPVendedor          on _SalesDocPartner.Supplier = _BPVendedor.BusinessPartner
    left outer join I_DeliveryDocument         as _DeliveryDocument    on _DeliveryDocument.DeliveryDocument = right(
      _FluxoDocumentosNF.TranspOrdDocReferenceID, 10
    ) //Nº da Remessa
    left outer join tvlkt                      as _TVLKT               on  _DeliveryDocument.DeliveryDocumentType = _TVLKT.lfart
                                                                       and _TVLKT.spras                           = $session.system_language
    left outer join tvtwt                      as _TVTW                on  _TVTW.vtweg = _BillingDocumentDev.DistributionChannel
                                                                       and _TVTW.spras = $session.system_language
    left outer join t151t                      as _T151                on  _T151.kdgrp = _FluxoDocumentosNF.CustomerGroup
                                                                       and _T151.spras = $session.system_language
    left outer join ZI_TM_QTD_ENTREGAS         as _ZI_TM_QTD_ENTREGAS  on _FluxoDocumentosNF.SourceStopUUID = _ZI_TM_QTD_ENTREGAS.SourceStopUUID

  //association [0..1] to ZI_CO_VH_SIT_NF_DEV            as _SitNFDev     on  _Devolucao.situacao = _SitNFDev.Situation

  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO       on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO.ordem_venda
                                                                         and _CicloPO.medicao                      = '001'
  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO_004   on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO_004.ordem_venda
                                                                         and _CicloPO_004.medicao                  = '004'
  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO_007   on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO_007.ordem_venda
                                                                         and _CicloPO_007.medicao                  = '007'
  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO_008   on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO_008.ordem_venda
                                                                         and _CicloPO_008.medicao                  = '008'
  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO_009   on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO_009.ordem_venda
                                                                         and _CicloPO_009.medicao                  = '009'
  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO_010   on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO_010.ordem_venda
                                                                         and _CicloPO_010.medicao                  = '010'
  association [0..*] to ZI_SD_CICLO_PO_DIST            as _CicloPO_016   on  _FluxoDocumentosNF.SalesOrderDocument = _CicloPO_016.ordem_venda
                                                                         and _CicloPO_016.medicao                  = '016'

  association [0..*] to I_LocationBasic                as _Location      on  _Stop.log_locid        = _Location.Location
                                                                         and LocationAdditionalUUID = _Location.LocationAdditionalUUID
  association [0..1] to ZI_TM_BAIRRO                   as _Bairro        on  _Cliente.CodigoBP = _Bairro.partner 
                                                                         and _Bairro.addr_valid_to >= 99991231000000
                                                                         
  association [0..1] to I_SalesOrder                   as _SalesOrder    on  _SalesOrder.SalesOrder = _FluxoDocumentosNF.SalesOrderDocument
  association [0..*] to ZI_TM_STS_FN_OF                as _StatusOF      on  _FluxoDocumentosNF.TransportationOrder = _StatusOF.CodigoOrdemFrete
  association [0..1] to ZI_TM_STS_CK_FU                as _CheckStsFU    on  _FluxoDocumentosNF.TranspOrdDocReferenceID = _CheckStsFU.ReferUnidadeFrete
  association [0..1] to ZI_TM_DATA_FN_FU               as _DataStatusFU  on  _FluxoDocumentosNF.TranspOrdDocReferenceID = _DataStatusFU.ReferUnidadeFrete
  association [0..1] to ZI_TM_SUCC_KM                  as _SucessorStop  on  _FluxoDocumentosNF.TransportationOrderUUID = _SucessorStop.root_key
  association [0..*] to I_SDDocumentMultiLevelProcFlow as _RemessaDev    on  _Devolucao.Fatura                     = _RemessaDev.SubsequentDocument
                                                                         and _RemessaDev.PrecedingDocumentCategory = 'T'
  association [0..*] to C_BR_VerifyNotaFiscal          as _NotaFiscalDev on  _Devolucao.Fatura =  _NotaFiscalDev.ReferenceDocument
                                                                         and _Devolucao.Fatura <> '' //campo vazio
{
  key _FluxoDocumentosNF.TransportationOrderUUID                           as OrdemId,
  key _FluxoDocumentosNF.TranspOrdDocReferenceID                           as ReferUnidadeFrete,
      _FluxoDocumentosNF.SourceStopUUID                                    as SourceID,
      _FluxoDocumentosNF.DestinationStopUUID                               as DestinationID,
      _FluxoDocumentosNF.TransportationOrder                               as OrdemFreteNum,
      _FluxoDocumentosNF.BR_NFeAccessKey                                   as ChaveAcesso,
     
      //      case
      //        when _FluxoDocumentosNF.TranspOrdDocReferenceType = '58' then _ClienteCompra.CodigoBP
      //        else _FluxoDocumentosNF.Consignee
      //      end                                                                          as CodigoCliente,

      _Cliente.CodigoBP                                                    as CodigoCliente,

      //RN: Exibir apenas para cenário de Ordem de Venda
      //    Não exibir para cenário de compra e transferência
      case
      when _FluxoDocumentosNF.DeliveryDocumentType != 'ZNLC' and _FluxoDocumentosNF.TranspOrdDocReferenceType != '58'
      then
        _FluxoDocumentosNF.SalesOrderDocument
      else
        ''
      end                                                                  as DocumentoVendas,      

      _Stop.log_locid                                                      as UGDestino,
      _Location._Address.Region                                            as UFDestino,
      _Location._Address.CityName                                          as CidadeDestino,

      _FluxoDocumentosNF.SalesOrderType                                    as TipoDocVendas,

      tstmp_to_dats(_CicloPO.data_hora_registro,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                              as DataCriacaoPedidoSAP,
      tstmp_to_tims(_CicloPO.data_hora_registro,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                              as HoraCriacaoPedidoSAP,

      //tstmpl_to_utcl(_CicloPO.data_hora_registro, 'NULL', 'NULL')          as DataCriacaoPedidoSAP2,

      tstmp_to_dats(_CicloPO_004.data_hora_registro,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                              as DataExportadoRoadnet,

      _Cliente.AreaAtendimento                                             as CodAreaAtendimento,
      _AreaAtendimento.AreaAtendimentoTexto                                as DescAreaAtendimento,

      _FluxoDocumentosNF.PlateNumber                                       as Placa,

      _StopOri.CodigoLocalTransporte                                       as CodigoLocalTransporte,
      _StopOri.DescLocalTransporte                                         as DescLocalTransporte,
      _StopOri.CondicaoExpedicao                                           as CondicaoExpedicao,
      _StopOri.DescCondicaoExpedicao                                       as DescCondicaoExpedicao,
      _StopOri.TipoExpedicao                                               as TipoExpedicao,
      _StopOri.DescTipoExpedicao                                           as DescTipoExpedicao,

      _FluxoDocumentosNF.TranspOrdLifeCycleStatus                          as StatusOrdemFreteCicloVida,
      _FluxoDocumentosNF.TranspOrdLifeCycleStatusText                      as DescStatusOrdemFreteCicloVida,

      _FluxoDocumentosNF.TranspOrdPlanningStatus                           as StatusOrdemFretePlanejamento,
      _FluxoDocumentosNF.TranspOrdPlanningStatusDesc                       as DescStatusOrdemFretePlan,

      _FluxoDocumentosNF.TransportationOrderExecSts                        as StatusOrdemFreteExecucao,
      _FluxoDocumentosNF.TransportationOrderExecStsDesc                    as DescStatusOrdemFreteExecucao,

      _FluxoDocumentosNF.CreatedByUser                                     as CriadoPorOF,
      _FluxoDocumentosNF.CustomerGroup                                     as RegiaoVendas,
      _T151.ktext                                                          as DescRegiaoVendas,

      tstmp_to_dats( _FluxoDocumentosNF.CreationDateTime,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                     $session.client,
                     'NULL' )                                              as DataCriacaoOF,


      tstmp_to_tims( _FluxoDocumentosNF.CreationDateTime,
                       abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                             $session.client,
                                             'NULL' )                      as HoraCriacaoOF,

      //      _StatusOF( p_evento1: 'ENTREGA_PARCIAL',
      //                 p_evento2: 'ENTREGA_TOTAL',
      //                 p_evento3: 'DEVOLVIDO',
      //                 p_evento4: 'COLETADO',
      //                 p_evento5: 'NÃO COLETADO',
      //                 p_evento6: '' ).Evento
      ''                                                                   as StatusNFE,

      tstmp_to_dats( _DataStatusFU( p_evento1: 'ENTREGA_PARCIAL',
                 p_evento2: 'ENTREGA_TOTAL',
                 p_evento3: 'DEVOLVIDO',
                 p_evento4: 'COLETADO',
                 p_evento5: 'NÃO COLETADO',
                 p_evento6: '' ).Data,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                         $session.client,
                                         'NULL' )                          as DataStatusNfe,
      _DataStatusFU( p_evento1: 'ENTREGA_PARCIAL',
                 p_evento2: 'ENTREGA_TOTAL',
                 p_evento3: 'DEVOLVIDO',
                 p_evento4: 'COLETADO',
                 p_evento5: 'NÃO COLETADO',
                 p_evento6: '' ).Data                                      as DataStatusNfeTimS,


      tstmp_to_tims(
                _DataStatusFU( p_evento1: 'ENTREGA_PARCIAL',
                 p_evento2: 'ENTREGA_TOTAL',
                 p_evento3: 'DEVOLVIDO',
                 p_evento4: 'COLETADO',
                 p_evento5: 'NÃO COLETADO',
                 p_evento6: '' ).Data ,
                       abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                             $session.client,
                                             'NULL' )                      as HoraStatus,

      case
      when _StopOri.Lifecycle = '05'
      then tstmp_to_dats( _StopOri.DataEncerramentoOF,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                           $session.client,
                                           'NULL' )
      end                                                                  as DataEncerramentoOF,

      _FluxoDocumentosNF.Motorista                                         as Motorista,
      _FluxoDocumentosNF.Company                                           as Empresa,
      _FluxoDocumentosNF.CompanyDesc                                       as DescEmpresa,

      _FluxoDocumentosNF.BR_NotaFiscal                                     as DocNum,
      _Bairro.city2                                                        as BairroDestino,
      _FluxoDocumentosNF.TranspOrdDocReferenceID                           as NumeroRemessa,
      _DeliveryDocument.CreationDate                                       as DataCriacaoRemessa,
      _DeliveryDocument.CreationTime                                       as HoraCriacaoRemessa,
      _StopOri.NomeTransportadora                                          as NomeTransportadora,
      _SalesOrder.CustomerPurchaseOrderDate                                as DataCriacaoPedSirius,

      case
      when _FluxoDocumentosNF.DeliveryDocumentType != 'ZNLC' and _FluxoDocumentosNF.TranspOrdDocReferenceType != '58'
      then
        _FluxoDocumentosNF.InvoiceDocument
      else
        ''
      end                                                                  as DocumentoFaturamento,

      _FluxoDocumentosNF.BR_NFeDocumentStatus                              as StatusNotaFiscal,

      _BillingDocument.BillingDocumentType                                 as TipoFaturamento,
      _BillingDocumentText.BillingDocumentTypeName,
      _BillingDocument.CreationDate                                        as DataCriacaoDocumentoFat,

      tstmp_to_dats( _CicloPO_004.data_hora_registro,
        abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                              $session.client,
                              'NULL' )                                     as DataEnvioRoteirizacao,

      tstmp_to_tims(_CicloPO_004.data_hora_registro,
                abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                      $session.client, 'NULL')             as HoraEnvioRoteirizacao,

      tstmpl_to_utcl(_CicloPO_004.data_hora_registro, 'NULL', 'NULL')      as DataEnvioRoteirizacao2,

      //Data Liberação Ordem de Frete - OK
      tstmp_to_dats( _StatusOF( p_evento1: 'LIBERADO P/CARREGAR',
                                p_evento2: '',
                                p_evento3: '',
                                p_evento4: '',
                                p_evento5: '',
                                p_evento6: '' ).Data,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                           $session.client,
                                           'NULL' )                        as DataLiberacaoOF,

      _FluxoDocumentosNF.BR_NFIssueDate                                    as DataEmissaoNF,

      //Data Saida Veículo - Ok
      tstmp_to_dats( _StatusOF( p_evento1: 'ACTUAL_DEPARTURE',
                                p_evento2: '',
                                p_evento3: '',
                                p_evento4: '',
                                p_evento5: '',
                                p_evento6: '' ).Data,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                           $session.client,
                                           'NULL' )                        as DataSaidaVeiculo,

      //Hora Saida Veículo Ok
      _StatusOF( p_evento1: 'ACTUAL_DEPARTURE',
                p_evento2: '',
                p_evento3: '',
                p_evento4: '',
                p_evento5: '',
                p_evento6: '' ).Hora                                       as HoraSaidaVeiculo,

      tstmp_to_dats( _CicloPO_007.data_hora_planejada,
                    abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                          $session.client,
                                          'NULL' )                         as DataLimiteSaidaVeiculo,

      tstmp_to_tims( _CicloPO_007.data_hora_planejada,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                           $session.client,
                                           'NULL' )                        as HoraLimiteSaidaVeiculo,

      //Data Limite Entrega Cliente
      tstmp_to_dats( _CicloPO_008.data_hora_planejada,
                abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                      $session.client,
                                      'NULL' )                             as DataLimiteEntregaCliente,

      //Data Prest Conta
      tstmp_to_dats( _CicloPO_016.data_hora_registro,
                           abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                                 $session.client,
                                                 'NULL' )                  as DataPrestConta,

      _SalesOrder.RequestedDeliveryDate                                    as DataDesejadaCliente,

      tstmp_to_dats( _CicloPO_010.data_hora_planejada,
                          abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                                $session.client,
                                                'NULL' )                   as DataLimiteCicloInterno,

      _FluxoDocumentosNF.ShippingPoint                                     as LocalExpedicao,

      _MotoristaFrota.Driver                                               as CodigoMotorista,
      _MotoristaFrota.DriverName                                           as NomeMotorista,
      _MotoristaBP.crdat                                                   as DataAdmissao,

      _SalesOrder.SalesOrganization                                        as OrganizacaoVendas,

      //_Devolucao.DtLancamento                                          as DataFaturaDevolvida,
      _BillingDocumentDev.BillingDocumentDate                              as DataFaturaDevolvida,
      //Descricao Sit - ok
      //_SitNFDev.Description                                            as SitLancNFDevDescricao,
      //_Devolucao.situacao                                              as SitLancamentoNFDevolucao,

      _Devolucao.CodSituacao                                               as SitLancamentoNFDevolucao,
      _Devolucao.StatusText                                                as SitLancNFDevDescricao,

      //_Devolucao.nfe_fatura
      _NotaFiscalDev.BR_NFeNumber                                          as NotaFiscalDevolucao,

      _Devolucao.Fatura                                                    as DocFaturaDevolucao,

      _BillingDocumentDev.DistributionChannel                              as CanalDistribuicaoDevolucao,
      _TVTW.vtext                                                          as DescCanalDistribuicaoDevolucao,

      //Descrição Motivo Recusa - Ok
      _Devolucao.Motivo                                                    as CodigoMotivoRecusa,
      _MotResponsaveis._SDDocumentReasonText.SDDocumentReasonText          as DescricaoRecusa,

      _MotResponsaveis.Arearesp                                            as AreaResponsavel,

      _MotResponsaveis.Impacto                                             as Impacto,

      _MotResponsaveis.Embarque                                            as Embarque,

      //      case
      //      when _FluxoDocumentosNF.DeliveryDocumentType != 'ZNLC' and _FluxoDocumentosNF.TranspOrdDocReferenceType != '58'
      //      then
      _MotResponsaveis.Qualidade
      //      else
      //        ''
      //      end
                                                                           as Qualidade,

      _SalesDocPartner.Supplier                                            as CodigoVendedor,

      _BPVendedor.BusinessPartnerName                                      as NomeVendedor,

      case
       when _FluxoDocumentosNF.TranspOrdDocReferenceType = '58' then _Cliente.NomeBP
       else _FluxoDocumentosNF.BusinessPartnerName
      end                                                                  as NomeCliente,


      //Nº Remessa Devoluções
      _RemessaDev.PrecedingDocument                                        as NumeroRemessaDev,


      _StopOri.NumMDFe                                                     as NumMDFE,

      _FluxoDocumentosNF.BR_NFIsCreatedManually                            as NotaFiscalManual,

      _StopOri.CodigoTransportadora                                        as CodigoTransportadora,
      _FluxoDocumentosNF.TuresCat                                          as GrupoVeiculo,
      _FluxoDocumentosNF.TuresTco                                          as TipoVeiculo,

      _DeliveryDocument.DeliveryDocumentType                               as CodigoTipoEntrega,
      _TVLKT.vtext                                                         as DescTipoEntregra,

      _FluxoDocumentosNF.LastChangedByUser                                 as ModificadoPor,
      lpad(_FluxoDocumentosNF.BR_NFeNumber, 9, '0')                        as NotaFiscalNum,

      _FluxoDocumentosNF.TransportationMode                                as CodigoTipoTransporte,
      _FluxoDocumentosNF.TransportationModeDesc                            as DescTipoTransporte,

      case when _CheckStsFU( p_evento1: 'ENTREGA_TOTAL',
                             p_evento2: 'ENTREGA_PARCIAL',
                             p_evento3: 'DEVOLVIDO',
                             p_evento4: '',
                             p_evento5: '',
                             p_evento6: '' ).ContainsEvent = 'X' then 0
                             else _FluxoDocumentosNF.BR_NFTotalAmount end  as ValorNFPendente,


      _FluxoDocumentosNF.BR_NFTotalAmount                                  as ValorTotalNFeBruto,

      //Qtd Remessas da OF :: Calculado na CDs de consumo

      //_ZI_TM_QTD_ENTREGAS.totalEntregas                                as QtdEntregas,

      cast(_StopOri.CapacidadeMaxVeiculo as abap.dec( 15, 2 ) )            as CapacidadeMaxVeiculo,

      //      cast( round(_StopOri.OtimizacaoCapMax, 0) as abap.int1 )         as OtimizacaoCapMax, //Otimização % Capac. Máx.
      round(_StopOri.OtimizacaoCapMax, 0)                                  as OtimizacaoCapMax,
      
      cast ( sum ( _FluxoDocumentosNF.TranspOrdItemGrossWeight ) as abap.dec( 15, 3) ) as PesoTotalOF,     // Peso total por item - Na CDS de Consumo é feita agregação

      case
       when _ZI_TM_QTD_ENTREGAS.totalEntregas > 0
       then ( cast(_FluxoDocumentosNF.TranspOrdNetWeight as abap.fltp) / cast(_ZI_TM_QTD_ENTREGAS.totalEntregas as abap.fltp) )
       else 0
      end                                                                  as Dropsize,

      cast(_SucessorStop.total_dist_km as abap.dec( 15, 2 ) )              as Distancia,
      cast( sum ( _FluxoDocumentosNF.TranspOrdItemNetWeight ) as abap.dec( 15, 2)) as PesoLiquido,      
      _FluxoDocumentosNF.TranspOrdItemNetWeightUnit                        as PesoLiquidoUnidade,   //Unidade de medida

      tstmp_to_dats( _CicloPO_009.data_hora_planejada,
                          abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                                $session.client,
                                                'NULL' )                   as DataCicloExternoMeta,

      tstmp_to_dats( _CicloPO_010.data_hora_planejada,
                          abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                                $session.client,
                                                'NULL' )                   as DataCicloInternoMeta,

      tstmp_to_dats( _CicloPO_010.data_hora_realizada,
                          abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                                $session.client,
                                                'NULL' )                   as DataCicloInternoReal


}
group by
  _FluxoDocumentosNF.TransportationOrderUUID,
  _FluxoDocumentosNF.SourceStopUUID,
  _FluxoDocumentosNF.DestinationStopUUID,
  _FluxoDocumentosNF.TransportationOrder,
  _FluxoDocumentosNF.BR_NFeAccessKey,

  _FluxoDocumentosNF.TranspOrdDocReferenceType,
  _FluxoDocumentosNF.Consignee,
  _Cliente.CodigoBP,
  _FluxoDocumentosNF.SalesOrderDocument,
  _Stop.log_locid,
  _Location._Address.Region,
  _Location._Address.CityName,
  _FluxoDocumentosNF.SalesOrderType,
  _CicloPO.data_hora_registro,
  _CicloPO_004.data_hora_registro,
  _AreaAtendimento.AreaAtendimentoTexto,
  _FluxoDocumentosNF.PlateNumber,

  _StopOri.CodigoLocalTransporte,
  _StopOri.DescLocalTransporte,
  _StopOri.CondicaoExpedicao,
  _StopOri.DescCondicaoExpedicao,
  _StopOri.TipoExpedicao,
  _StopOri.DescTipoExpedicao,
  _StopOri.Lifecycle,

  _FluxoDocumentosNF.TranspOrdLifeCycleStatus,
  _FluxoDocumentosNF.TranspOrdLifeCycleStatusText,
  _FluxoDocumentosNF.TranspOrdPlanningStatus,
  _FluxoDocumentosNF.TranspOrdPlanningStatusDesc,
  _FluxoDocumentosNF.TransportationOrderExecSts,
  _FluxoDocumentosNF.TransportationOrderExecStsDesc,
  _FluxoDocumentosNF.CreatedByUser,
  _FluxoDocumentosNF.CustomerGroup,
  _FluxoDocumentosNF.CreationDateTime,
  _T151.ktext,

  _StatusOF( p_evento1: 'ENTREGUE',
             p_evento2: 'DEVOLVIDO',
             p_evento3: 'PENDENTE',
             p_evento4: 'SINISTRO',
             p_evento5: 'COLETADO',
             p_evento6: 'NÃO COLETADO' ).Data,

  //Data Liberação Ordem de Frete
  _StatusOF( p_evento1: 'LIBERADO P/CARREGAR',
             p_evento2: '',
             p_evento3: '',
             p_evento4: '',
             p_evento5: '',
             p_evento6: '' ).Data,

  //Data Saída Veículo
  _StatusOF( p_evento1: 'ACTUAL_DEPARTURE',
                p_evento2: '',
                p_evento3: '',
                p_evento4: '',
                p_evento5: '',
                p_evento6: '' ).Data,

  //Hora Saída Veículo
  _StatusOF( p_evento1: 'ACTUAL_DEPARTURE',
                p_evento2: '',
                p_evento3: '',
                p_evento4: '',
                p_evento5: '',
                p_evento6: '' ).Hora,

  //Hora Status
  _DataStatusFU( p_evento1: 'ENTREGA_PARCIAL',
                 p_evento2: 'ENTREGA_TOTAL',
                 p_evento3: 'DEVOLVIDO',
                 p_evento4: 'COLETADO',
                 p_evento5: 'NÃO COLETADO',
                 p_evento6: '' ).Data,

  _CheckStsFU( p_evento1: 'ENTREGA_TOTAL',
               p_evento2: 'ENTREGA_PARCIAL',
               p_evento3: 'DEVOLVIDO',
               p_evento4: '',
               p_evento5: '',
               p_evento6: '' ).ContainsEvent,

  _FluxoDocumentosNF.Motorista,
  _StopOri.DataEncerramentoOF,
  _FluxoDocumentosNF.Company,
  _FluxoDocumentosNF.CompanyDesc,
  _FluxoDocumentosNF.BR_NotaFiscal,
  _Bairro.city2,
  _FluxoDocumentosNF.TranspOrdDocReferenceID,
  _DeliveryDocument.CreationDate,
  _DeliveryDocument.CreationTime,
  _StopOri.NomeTransportadora,
  _SalesOrder.CustomerPurchaseOrderDate,
  _BillingDocument.BillingDocumentType,
  _BillingDocumentText.BillingDocumentTypeName,
  _BillingDocument.CreationDate,
  _FluxoDocumentosNF.BR_NFIssueDate,

  _CicloPO_007.data_hora_planejada,
  _CicloPO_008.data_hora_planejada,
  _CicloPO_016.data_hora_registro,
  _CicloPO_010.data_hora_planejada,
  _CicloPO_009.data_hora_planejada,
  _CicloPO_010.data_hora_realizada,

  _SalesOrder.RequestedDeliveryDate,
  _FluxoDocumentosNF.ShippingPoint,
  _MotoristaFrota.Driver,
  _MotoristaFrota.DriverName,
  _MotoristaBP.crdat,
  _SalesOrder.SalesOrganization,
  //_Devolucao.DtLancamento,
  _BillingDocumentDev.BillingDocumentDate,
  //_SitNFDev.Description,
  //_Devolucao.situacao,
  _Devolucao.CodSituacao,
  _Devolucao.StatusText,
  _NotaFiscalDev.BR_NFeNumber,
  _Devolucao.NfeComp,
  _Devolucao.Fatura,
  _BillingDocumentDev.DistributionChannel,
  _TVTW.vtext,
  _MotResponsaveis.Augru,
  _MotResponsaveis._SDDocumentReasonText.SDDocumentReasonText,
  _MotResponsaveis.Arearesp,
  _MotResponsaveis.Impacto,
  _MotResponsaveis.Embarque,
  _MotResponsaveis.Qualidade,
  _SalesDocPartner.Supplier,
  _BPVendedor.BusinessPartnerName,
  _FluxoDocumentosNF.BusinessPartnerName,
  _Cliente.NomeBP,
  _Cliente.AreaAtendimento,
  _Devolucao.Motivo,
  _RemessaDev.PrecedingDocument,
  _StopOri.NumMDFe,
  _FluxoDocumentosNF.BR_NFIsCreatedManually,
  _StopOri.CodigoTransportadora,
  _FluxoDocumentosNF.TuresCat,
  _FluxoDocumentosNF.TuresTco,
  _DeliveryDocument.DeliveryDocumentType,
  _TVLKT.vtext, //desc tipo entrega
  _FluxoDocumentosNF.LastChangedByUser,
  _FluxoDocumentosNF.BR_NFeNumber,
  _FluxoDocumentosNF.TransportationMode,
  _FluxoDocumentosNF.TransportationModeDesc,
  _StopOri.CapacidadeMaxVeiculo,
  _StopOri.OtimizacaoCapMax,
  _SucessorStop.total_dist_km,
  _FluxoDocumentosNF.BR_NFTotalAmount,
  _ZI_TM_QTD_ENTREGAS.totalEntregas,
  //_FluxoDocumentosNF.TranspOrdItemNetWeight,
  _FluxoDocumentosNF.TranspOrdItemNetWeightUnit,  
  _FluxoDocumentosNF.TranspOrdNetWeight,  
  _FluxoDocumentosNF.DeliveryDocumentType,
  _FluxoDocumentosNF.InvoiceDocument,
  _FluxoDocumentosNF.BR_NFeDocumentStatus
  
  //,_FluxoDocumentosNF.TranspOrdItemGrossWeight
