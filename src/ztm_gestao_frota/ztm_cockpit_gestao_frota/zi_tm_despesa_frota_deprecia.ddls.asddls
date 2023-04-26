@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de despesas: Depreciação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_DEPRECIA
  as select from anla     as anla

    inner join   Faa_Anlp as _anlp on  _anlp.bukrs  = anla.bukrs
                                   and _anlp.anln1  = anla.anln1
                                   and _anlp.anln2  = anla.anln2
                                   and _anlp.afaber = '01'

{
  cast( anla.invnr as /scmtms/resplatenr  )     as Equipment,
  //  sum( cast( _anlp.nafaz  as dec23_2 ) ) as DepreciationCost
  sum( cast( _anlp.nafaz  as abap.dec(23,2) ) ) as DepreciationCost
}
where
  anla.invnr is not initial
group by
  anla.invnr
