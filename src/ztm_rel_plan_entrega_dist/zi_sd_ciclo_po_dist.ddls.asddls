@AbapCatalog.sqlViewName: 'ZI_SD_CICL_PO_DT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ciclo do pedido para relatório P.Entrega e Distribuição'
define view ZI_SD_CICLO_PO_DIST
  as select from ztsd_ciclo_po 
{
  key ordem_venda,
  key remessa,
  key data_hora_registro,
  key medicao,
      data_hora_planejada,
      data_hora_realizada
}
