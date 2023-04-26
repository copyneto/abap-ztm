@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CFOP para cenário GNRE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT007
  as select from zttm_pcockpit007
{
  key guid                                        as guid,
  key cast( left( cfop, 4 ) as ze_gko_cfop )      as cfop,
      cast( left( cfop_int , 4 ) as ze_gko_cfop ) as cfop_int
}
