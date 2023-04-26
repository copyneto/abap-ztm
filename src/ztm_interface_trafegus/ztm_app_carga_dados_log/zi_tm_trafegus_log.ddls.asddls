@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Trafegus - Mensagens de log'

define root view entity ZI_TM_TRAFEGUS_LOG
  as select from zttm_trafegus_l as log

  association [0..1] to ZI_TM_VH_TRAFEGUS_ORDEM_FRETE as _FreightOrder  on _FreightOrder.TransportationOrder = $projection.FreightOrder
  association [0..1] to ZI_CA_VH_MSGTY                as _TipoMensagem  on _TipoMensagem.msgty = $projection.TipoMensagem
  association [0..1] to ZI_CA_VH_USER                 as _CreatedBy     on _CreatedBy.Bname = $projection.CreatedBy
  association [0..1] to ZI_CA_VH_USER                 as _LastChangedBy on _LastChangedBy.Bname = $projection.LastChangedBy

{
  key tor_id                                as FreightOrder,
  key contador_itf                          as ContadorItf,
  key contador_msg                          as ContadorMsg,
      cod_status                            as CodStatus,
      cod_viagem                            as CodViagem,
      tipo_mensagem                         as TipoMensagem,
      _TipoMensagem.msgty_text              as TipoMensagemTxt,

      case tipo_mensagem
      when 'S' then 3  -- Mensagem na tela seguinte
      when 'I' then 0  -- Informação
      when 'A' then 1  -- Cancelamento
      when 'E' then 1  -- Erro
      when 'W' then 2  -- Advertência
               else 0 end                   as TipoMensagemCrit,

      mensagem                              as Mensagem,
      valor                                 as Valor,
      campo                                 as Campo,
      link_mapa_veiculo_viagem              as LinkMapaVeiculoViagem,

      @Semantics.user.createdBy: true
      created_by                            as CreatedBy,
      _CreatedBy.Text                       as CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      created_at                            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                       as LastChangedBy,
      _LastChangedBy.Text                   as LastChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                 as LocalLastChangedAt,

      _FreightOrder.TransportationOrderUUID as TransportationOrderUUID

}
