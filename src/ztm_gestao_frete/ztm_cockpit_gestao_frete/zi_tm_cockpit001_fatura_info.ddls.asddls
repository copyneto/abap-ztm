@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - Dados de Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_FATURA_INFO
  as select from    ZI_TM_COCKPIT001_FATURA as fatura

    left outer join rbkp                    as _rbkp   on  _rbkp.belnr = fatura.re_belnr
                                                       and _rbkp.gjahr = fatura.re_gjahr

    left outer join ZI_CA_VH_USER           as _usnam  on _usnam.Bname = _rbkp.usnam

    left outer join acdoca                  as _acdoca on  _acdoca.rldnr  = '0L'
                                                       and _acdoca.rbukrs = _rbkp.bukrs
                                                       and _acdoca.awref  = fatura.re_belnr
                                                       and _acdoca.gjahr  = _rbkp.gjahr

{
  key fatura.acckey   as acckey,
      fatura.re_belnr as re_belnr,
      fatura.re_gjahr as re_gjahr,
      _rbkp.bukrs     as bukrs,
      _rbkp.rbstat    as rbstat,
      _rbkp.budat     as budat,
      _rbkp.usnam     as usnam,
      _usnam.Text     as usnam_txt,
      _rbkp.cputm     as cputm,
      _acdoca.belnr   as belnr_fin
}
group by
  fatura.acckey,
  fatura.re_belnr,
  fatura.re_gjahr,
  _rbkp.bukrs,
  _rbkp.rbstat,
  _rbkp.budat,
  _rbkp.usnam,
  _usnam.Text,
  _rbkp.cputm,
  _acdoca.belnr
