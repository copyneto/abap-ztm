@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Impostos - INSS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_NF_IMPOSTOS_INSS
  as select from j_1bnfe_active as _Active
    inner join   j_1bnfdoc      as _Doc    on _Doc.docnum = _Active.docnum
    inner join   j_1bnflin      as _Lin    on _Lin.docnum = _Active.docnum
    inner join   bseg           as _Contab on  _Contab.awkey = _Lin.refkey
                                           and _Contab.qsskz = 'IJ' -- INSS
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
      _Active.docnum                                                   as docnum,
      cast ('BRL' as abap.cuky)                                        as CurrencyCode,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      sum( currency_conversion( amount              => _Contab.wrbtr,
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
  _Active.docnum
