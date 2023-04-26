@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de despesas: Pneus'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_PNEUS
  as select from ZV_PM_ORDENS_CUSTO as Cost

    inner join   I_MaintenanceOrder as _MaintenanceOrder on  _MaintenanceOrder.MaintenanceOrder     = Cost.Aufnr
                                                         and _MaintenanceOrder.MaintenanceOrderType = Cost.Auart
{
  key cast( Cost.Equnr as /scmtms/resplatenr )     as Equipment,
      sum( cast( Cost.Wtgbtr as abap.dec(23,2) ) ) as TiresCost

}
where
  Cost.Auart = '3C13'       -- Pneus e reforma
group by
  Cost.Equnr
