@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos de referencia'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_REFERENCIA_S
  as select from zttm_gkot003
{
  key acckey          as acckey,

      sum( case when prod_acabado = '0'
                then 1
                else 0
                end ) as prod_acabado_nao,

      sum( case when prod_acabado = '1'
                then 1
                else 0
                end ) as prod_acabado_sim,

      sum( case when prod_acabado = '2'
                then 1
                else 0
                end ) as prod_acabado_parcial
}
group by
  acckey
