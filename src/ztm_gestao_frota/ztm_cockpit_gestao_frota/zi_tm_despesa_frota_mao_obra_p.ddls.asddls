@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Despesas: Mão-de-obra (Parâmetro)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_MAO_OBRA_P
  as select from    ZI_DESPESA_FRT_MAO_OBRA_AUX as Param

    left outer join acdoca                      as _Entry on  _Entry.racct     = Param.Low -- Conta razão
                                                          and _Entry.rcntr     = Param.Chave2  -- Centro de custo
                                                          and _Entry.ktopl     = 'PC3C'
                                                          and _Entry.kokrs     = 'AC3C'
                                                          and _Entry.xreversed is initial
{
  key _Entry.werks                                as Plant,
  key cast( Param.Chave3 as bukrs )               as CompanyCode,
  key _Entry.budat                                as Period,
      substring( _Entry.budat, 1, 6 )             as PeriodYearMonth,
      sum( cast( _Entry.hsl as abap.dec(31,2) ) ) as LaborCost,
      sum( cast( 1 as abap.int4 ) )               as Documents
}

where
      Param.Modulo = 'TM'
  and Param.Chave1 = 'FRT_MAO_DE_OBRA'

group by
  Param.Chave3,
  _Entry.werks,
  _Entry.budat
