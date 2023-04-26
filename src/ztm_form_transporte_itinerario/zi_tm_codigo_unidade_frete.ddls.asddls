@AbapCatalog.sqlViewName: 'ZITMCFO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Obtém código da unidade de frete'
define view ZI_TM_CODIGO_UNIDADE_FRETE
  as select from /scmtms/d_torite as _ItemOrdemFrete
    inner join   /scmtms/d_torrot as _UnidadeFrete on  _UnidadeFrete.db_key  = _ItemOrdemFrete.ref_root_key
                                                   and _UnidadeFrete.tor_cat = 'FU'
{
  key _ItemOrdemFrete.parent_key,
  _ItemOrdemFrete.item_id,
  _UnidadeFrete.tor_id
}
group by
  _ItemOrdemFrete.parent_key,
  _ItemOrdemFrete.item_id,
  _UnidadeFrete.tor_id
