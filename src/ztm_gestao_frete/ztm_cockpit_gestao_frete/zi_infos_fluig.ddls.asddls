@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações FLUIG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INFOS_FLUIG
  as select from ztm_infos_fluig
{
  key remessa                                              as Remessa,
  key pedido_fluig                                         as PedidoFluig,
      pedido_mm                                            as PedidoMm,
      ordem_sd                                             as OrdemSd,
      unid_frete                                           as UnidFrete,
      lpad( cast( ordem_frete as /scmtms/tor_id), 20, '0') as OrdemFrete,
      transportadora                                       as Transportadora,
      modal                                                as Modal,
      vlr_frete                                            as VlrFrete,
      custo_adicional                                      as CustoAdicional,
      centro_custo                                         as CentroCusto,
      conta_contabil                                       as ContaContabil,
      chave_nfe                                            as ChaveNfe,
      data_pedido                                          as DataPedido,
      tipo_frete                                           as TipoFrete,
      tipo_operacao                                        as TipoOperacao
}
where
  ordem_frete is not initial
