@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_FATURA
  as select from    zttm_gkot001              as gkot001

    left outer join ZI_TM_COCKPIT001_DOCDFF_U as dff on  dff.tor_id             = gkot001.tor_id
                                                     and dff.tpevento           = gkot001.tpevento
                                                     and dff.btd_id_127_estorno is initial
{
  key gkot001.acckey as acckey,

      case when dff.btd_id_127 is not initial
           then dff.btd_id_127
           when gkot001.re_belnr is not initial
           then gkot001.re_belnr
           else cast( '' as re_belnr  )
      end            as re_belnr,

      case when dff.btd_id_127 is not initial
           then dff.btd_year
           when gkot001.re_belnr is not initial
           then gkot001.re_gjahr
           else cast( '' as gjahr   )
      end            as re_gjahr

}
