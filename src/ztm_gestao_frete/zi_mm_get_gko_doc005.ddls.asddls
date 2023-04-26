@AbapCatalog.sqlViewName: 'ZVMM_GKO_DOC005'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dados para criação MIRO - Pedidos'
define view ZI_MM_GET_GKO_DOC005
  as select from zttm_gkot005
{
  key acckey as acckey,
      ebeln  as ebeln,
      lblni  as lblni,
      ebelp  as ebelp
}
where
  ebeln is not initial

union select from ZI_TM_COCKPIT001 as Cockpit
  left outer join ekpo             as _Pedido on _Pedido.ebeln = Cockpit.Pedido
{
  key Cockpit.acckey,
      Cockpit.Pedido as ebeln,
      Cockpit.lblni,
      _Pedido.ebelp
}
where
  Cockpit.Pedido is not initial

union select from ZI_TM_MONITOR_GKO_DOCGER_U as DocGerado
  left outer join ekpo                       as _Pedido on _Pedido.ebeln = DocGerado.docgerado
  left outer join essr                       as _Folha  on  _Folha.ebeln = _Pedido.ebeln
                                                        and _Folha.ebelp = _Pedido.ebelp
{
  key DocGerado.acckey    as acckey,
      DocGerado.docgerado as ebeln,
      _Folha.lblni        as lblni,
      _Pedido.ebelp       as ebelp
}
where
  DocGerado.tipodoc = '1' -- Pedido
