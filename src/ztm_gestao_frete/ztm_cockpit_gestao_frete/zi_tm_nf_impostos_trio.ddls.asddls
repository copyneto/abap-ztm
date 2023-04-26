@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Impostos - TRIO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_NF_IMPOSTOS_TRIO
  as select from zi_tm_nf_impostos
{
  key acckey,
      docnum,
      CurrencyCode,
      @Semantics.amount.currencyCode:'CurrencyCode'
      sum( taxval ) as taxval
}
where
     taxgrp = 'WHPI'
  or taxgrp = 'WHCO'
  or taxgrp = 'WHCS'
group by
  acckey,
  docnum,
  CurrencyCode
