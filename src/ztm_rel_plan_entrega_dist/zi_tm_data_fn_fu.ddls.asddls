@AbapCatalog.sqlViewName: 'ZI_TM_DAT_FN_FU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Obter max data Un. de frete por evento.'
define view ZI_TM_DATA_FN_FU
  with parameters
    p_evento1 : /scmtms/tor_event,
    p_evento2 : /scmtms/tor_event,
    p_evento3 : /scmtms/tor_event,
    p_evento4 : /scmtms/tor_event,
    p_evento5 : /scmtms/tor_event,
    p_evento6 : /scmtms/tor_event
  as select from /scmtms/d_torite as _Ite
    inner join   /scmtms/d_torrot as _Rot on  _Ite.parent_key = _Rot.db_key
                                          and tor_cat         = 'FU'

  association [1..1] to ZI_TM_DATA_STS_FN_OF as _Status on _Ite.parent_key = _Status.IdOrdemFrete

{
  key right(_Ite.base_btd_id , 10)                                    as ReferUnidadeFrete,
      _Ite.parent_key                                                 as IteParentKey,
      _Status( p_evento1 : $parameters.p_evento1,
                             p_evento2 : $parameters.p_evento2,
                             p_evento3 : $parameters.p_evento3,
                             p_evento4 : $parameters.p_evento4,
                             p_evento5 : $parameters.p_evento5,
                             p_evento6 : $parameters.p_evento6 ).Data as Data
}

group by
  _Ite.base_btd_id,
  _Ite.parent_key,
  _Status( p_evento1 : $parameters.p_evento1,
                       p_evento2 : $parameters.p_evento2,
                       p_evento3 : $parameters.p_evento3,
                       p_evento4 : $parameters.p_evento4,
                       p_evento5 : $parameters.p_evento5,
                       p_evento6 : $parameters.p_evento6 ).Data
