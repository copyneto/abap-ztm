@AbapCatalog.sqlViewName: 'ZI_TM_ULT_STS_FU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Último status da Unidade de frete'
define view ZI_TM_STS_FN_FU
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
    inner join   /scmtms/d_torexe as _Exe on _Ite.parent_key = _Exe.parent_key
{
  key right(_Ite.base_btd_id, 10)  as ReferUnidadeFrete,
      _Exe.actual_date as Data,
      _Exe.event_code  as Evento
}
where
  (
        _Exe.event_code = $parameters.p_evento1
    and _Exe.event_code is not initial
  ) 
  or(
        _Exe.event_code = $parameters.p_evento2
    and _Exe.event_code is not initial
  )
  or(
        _Exe.event_code = $parameters.p_evento3
    and _Exe.event_code is not initial
  ) 
  or(
        _Exe.event_code = $parameters.p_evento4
    and _Exe.event_code is not initial
  ) 
  or(
        _Exe.event_code = $parameters.p_evento5
    and _Exe.event_code is not initial
  ) 
  or(
        _Exe.event_code = $parameters.p_evento6
    and _Exe.event_code is not initial
  ) 
group by
  _Ite.base_btd_id,
  _Exe.actual_date,
  _Exe.event_code
