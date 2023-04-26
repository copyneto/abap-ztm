@AbapCatalog.sqlViewAppendName: 'ZZTM_FUNITEXT'
@EndUserText.label: 'Inclusão de campos no search help de unidade de frete'
extend view I_FreightUnitVH with zi_tm_unidade_frete_ext
{
  I_TransportationOrder.TranspOrdPlanningStatus,
  I_TransportationOrder._Carrier.BusinessPartner as Carrier
}
