@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Impostos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity zi_tm_nf_impostos
  as select from j_1bnfstx      as _Impostos
    inner join   j_1bnfe_active as _Active on _Active.docnum = _Impostos.docnum
    inner join   j_1bnfdoc      as _Doc    on _Doc.docnum = _Impostos.docnum

{
  key concat( concat( concat( concat( concat( concat( concat( concat(
      _Active.regio,
      _Active.nfyear ),
      _Active.nfmonth ),
      _Active.stcd1 ),
      _Active.model ),
      _Active.serie ),
      _Active.nfnum9 ),
      _Active.docnum9 ),
      _Active.cdv )                                                    as acckey,
  key _Impostos.taxgrp                                                 as taxgrp,
      _Active.docnum                                                   as docnum,
      cast ('BRL' as abap.cuky)                                        as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      sum( currency_conversion( amount              => _Impostos.taxval,
                                source_currency     => _Doc.waerk,
                                target_currency     => cast ('BRL' as abap.cuky),
                                exchange_rate_date  => _Doc.docdat ) ) as taxval

}
group by
  _Active.regio,
  _Active.nfyear,
  _Active.nfmonth,
  _Active.stcd1,
  _Active.model,
  _Active.serie,
  _Active.nfnum9,
  _Active.docnum9,
  _Active.cdv,
  _Impostos.taxgrp,
  _Active.docnum
