@AbapCatalog.sqlViewName: 'ZI_TM_SUCCKM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Distância total'
define view ZI_TM_SUCC_KM 
as select from /scmtms/d_torsts 
{
    key root_key,
    stop_succ_cat,
    sum( distance_km ) as total_dist_km
    
}
where stop_succ_cat = 'L'
group by root_key, stop_succ_cat
