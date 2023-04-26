@AbapCatalog.sqlViewName: 'ZITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Obter dados fatura das unidades de frete'
define view ZI_TM_MIRO
  as select from    /scmtms/d_sf_itm as _SfItm
    left outer join /scmtms/d_sf_rot as _SfRoot on _SfItm.parent_key = _SfRoot.db_key
    left outer join /scmtms/d_sivitm as _SivItm on _SfItm.parent_key = _SivItm.root_key
{
  key _SfItm.tor_root_key   as TorRootKey,
      _SivItm.inv_id_year   as DocRefFatura,
      _SivItm.inv_fyear     as AnoExcercicio,
      _SfRoot.sfir_category as CategoriaFaturamentoFrete,
      _SfRoot.lifecycle     as StatusCicloVida

      // relacionamento -> _SfItm.tor_root_key :: _TorRoot.db_key
}
where
  cancelled_inv_id = ''
