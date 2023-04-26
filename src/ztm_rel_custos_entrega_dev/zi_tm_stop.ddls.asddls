@AbapCatalog.sqlViewName: 'ZITMSTOP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transportation Order: Stop'

/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define view ZI_TM_STOP
  as select from    /scmtms/d_torstp          as _Stop
    left outer join /scmtms/d_torrot          as _TorRoot                 on _Stop.parent_key = _TorRoot.db_key
    left outer join /scmtms/d_torite          as _Veiculo                 on  _Veiculo.parent_key = _TorRoot.db_key
                                                                          and _Veiculo.item_type  = 'TRUC'
    left outer join /scmtms/d_tordrf          as _DocumentRef             on  _TorRoot.db_key      = _DocumentRef.parent_key
                                                                          and _DocumentRef.btd_tco = '114' // 'STO'
    left outer join C_FrtOrdGenDataBasicFacts as _FreightOrderGD          on _FreightOrderGD.FreightOrder = _TorRoot.tor_id

    left outer join I_LocationBasic           as _LocationAdtl_Origem     on  _LocationAdtl_Origem.Location               = _Stop.log_locid
                                                                          and _LocationAdtl_Origem.LocationAdditionalUUID = LocationAdditionalUUID
    left outer join I_LocationText            as _LocationAdtl_OrigemText on  _LocationAdtl_OrigemText.LocationUUID = _LocationAdtl_Origem.LocationUUID
                                                                          and _LocationAdtl_OrigemText.Language     = $session.system_language
  // left outer join ZI_TM_CODIGO_UNIDADE_FRETE as _CodigoUnidadeFrete on _TorRoot.db_key = _CodigoUnidadeFrete.parent_key

  //  association [0..1] to I_LocationBasic      as _LocationAdtl_Origem on  _Stop.log_locid        = _LocationAdtl_Origem.Location
  //                                                                     and LocationAdditionalUUID = _LocationAdtl_Origem.LocationAdditionalUUID
  association [0..1] to I_TranspOrdExecution as _TranspOrdExecution on _Stop.db_key = _TranspOrdExecution.TransportationOrderStopUUID

  association [0..1] to ZI_TM_VH_TIPO_EXPED  as _TipoExped          on _TorRoot.zz1_tipo_exped = _TipoExped.TipoExped
  association [0..1] to ZI_TM_VH_COND_EXP    as _CondExped          on _TorRoot.zz1_cond_exped = _CondExped.CondExped

{
  key   _Stop.db_key                                        as DbKey,
  key   _TorRoot.db_key                                     as ParentKey,
        _TorRoot.tor_id                                     as OrdemFrete,
        _Stop.log_locid                                     as UG,
        _LocationAdtl_Origem._Address.Region                as UF,
        _LocationAdtl_Origem._Address.CityName              as Cidade,

        // cast(substring(cast(_Stop.plan_trans_time as abap.char( 17 )), 1, 8) as abap.dats)                               as DataPlanejada,

        _Stop.plan_trans_time                               as DataPlanejada,
        max(_TranspOrdExecution.TranspOrdEvtActualDateTime) as DataReal,

        _TorRoot.blk_plan                                   as BloqueioPlanejamento,
        _TorRoot.blk_exec                                   as BloqueioExecucao,

        _TorRoot.zz1_tipo_exped                             as TipoExpedicao,
        _TipoExped.Descricao                                as DescTipoExpedicao,

        _TorRoot.zznr_saga                                  as NumeroCargaSAGA,
        _TorRoot.zz_motorista                               as Motorista,


        //@ObjectModel.foreignKey.association: '_CondExpedVH'
        _TorRoot.zz1_cond_exped                             as CondicaoExpedicao,
        _CondExped.Descricao                                as DescCondicaoExpedicao,

        _FreightOrderGD.SourceLocation                      as CodigoLocalTransporte,
        //        _FreightOrderGD.SourceLocationLabel                 as DescLocalTransporte,
        _LocationAdtl_OrigemText.LocationDescription        as DescLocalTransporte,
        _FreightOrderGD.Carrier                             as CodigoTransportadora,
        _FreightOrderGD.CarrierName                         as NomeTransportadora,
        _TorRoot.datetime_chlc                              as DataEncerramentoOF,
        _TorRoot.lifecycle                                  as Lifecycle,
        _TorRoot.zz_mdf                                     as NumMDFe,
        
        _Veiculo.pkgun_wei_val                              as CapacidadeMaxVeiculo,
        _TorRoot.max_util                                   as OtimizacaoCapMax,
        
        _Stop.stop_cat,
        _Stop.stop_seq_pos



}
group by
  _Stop.db_key,
  _TorRoot.db_key,
  //_Stop.parent_key,
  _TorRoot.tor_id,
  _Stop.log_locid,
  _LocationAdtl_Origem._Address.Region,
  _LocationAdtl_Origem._Address.CityName,
  _Stop.plan_trans_time,
  _TorRoot.blk_plan,
  _TorRoot.blk_exec,
  _TorRoot.zz1_tipo_exped,
  _TorRoot.zznr_saga,
  _TorRoot.zz_motorista,
  _TorRoot.zz1_cond_exped,
  _TipoExped.Descricao,
  _CondExped.Descricao,
  _FreightOrderGD.SourceLocation,
  //  _FreightOrderGD.SourceLocationLabel,
  _LocationAdtl_OrigemText.LocationDescription,
  _FreightOrderGD.Carrier,
  _FreightOrderGD.CarrierName,
  _TorRoot.datetime_chlc,
  _TorRoot.lifecycle,
  _TorRoot.zz_mdf,
  
  _Veiculo.pkgun_wei_val,
  _TorRoot.max_util,

  _Stop.stop_cat,
  _Stop.stop_seq_pos
