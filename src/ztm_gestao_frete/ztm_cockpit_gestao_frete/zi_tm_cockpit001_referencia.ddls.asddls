@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos de referencia'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_REFERENCIA
  as select from ZI_TM_COCKPIT001_REFERENCIA_S
{
  key acckey,

      case when prod_acabado_nao     is not initial
            and prod_acabado_sim     is initial
            and prod_acabado_parcial is initial
           then cast( '0' as ze_gko_prod_acabado )

           when prod_acabado_nao     is initial
            and prod_acabado_sim     is not initial
            and prod_acabado_parcial is initial
           then cast( '1' as ze_gko_prod_acabado )

           when prod_acabado_nao     is initial
            and prod_acabado_sim     is initial
            and prod_acabado_parcial is not initial
           then cast( '2' as ze_gko_prod_acabado )

           else cast( '2' as ze_gko_prod_acabado )

           end as prod_acabado
}
