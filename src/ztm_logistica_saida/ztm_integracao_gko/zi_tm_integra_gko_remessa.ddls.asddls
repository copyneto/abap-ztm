@AbapCatalog.sqlViewName: 'ZVTM_ITF_GKO_REM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface GKO: Remessa e Ordem de Frete'
define view ZI_TM_INTEGRA_GKO_REMESSA
  as select from    /scmtms/d_torite as _item
    left outer join vbfa             as _fluxo  on  _fluxo.vbelv   = right( _item.base_btd_id, 10 )
                                                and _fluxo.vbtyp_v = 'J'
                                                and _fluxo.vbtyp_n = 'M'
    left outer join j_1bnflin        as _nfe    on  _nfe.reftyp = 'BI'
                                                and _nfe.refkey = _fluxo.vbeln
    left outer join j_1bnfe_active   as _status on _status.docnum = _nfe.docnum
    left outer join j_1bnfdoc        as _hd     on _hd.docnum = _nfe.docnum
    left outer join vbrk             as _vbrk   on _vbrk.vbeln = _fluxo.vbeln
    left outer join likp             as _likp   on _likp.vbeln = right( _item.base_btd_id, 10 )
{
  key _item.base_btd_id                                   as base_btd_id,
      cast( right ( _item.base_btd_id, 10 ) as vbeln_vl ) as remessa,
      _fluxo.vbeln                                        as fatura,
      _nfe.docnum                                         as doc_nfe,
      _status.code                                        as status,
      concat( _status.regio,
      concat( _status.nfyear,
      concat( _status.nfmonth,
      concat( _status.stcd1,
      concat( _status.model,
      concat( _status.serie,
      concat( _status.nfnum9,
      concat( _status.docnum9,
      _status.cdv ) ) ) ) ) ) ) )                         as nfe_key,
      _hd.nftype                                          as nftype,
      _hd.nfenum                                          as nfenum,
      _hd.series                                          as series,
      _hd.docdat                                          as docdat,
      _hd.partyp                                          as partyp,
      _hd.bukrs                                           as bukrs,
      _hd.branch                                          as branch,
      _hd.parid                                           as parid,
      _hd.inco1                                           as inco1,
      _likp.lfart                                         as lfart

}
where (
     _item.base_btd_tco = '73'
  or _item.base_btd_tco = '58' )
  and _vbrk.fksto <> 'X'  -- Fatura estornada
  and _vbrk.fkart <> 'S1' -- Tipo de documento diferente de estorno
group by
  _item.base_btd_id,
  _fluxo.vbeln,
  _nfe.docnum,
  _status.code,
  _status.regio,
  _status.nfyear,
  _status.nfmonth,
  _status.stcd1,
  _status.model,
  _status.serie,
  _status.nfnum9,
  _status.docnum9,
  _status.cdv,
  _hd.nftype,
  _hd.nfenum,
  _hd.series,
  _hd.docdat,
  _hd.partyp,
  _hd.bukrs,
  _hd.branch,
  _hd.parid,
  _hd.inco1,
  _likp.lfart

union select from /scmtms/d_torite as _item

  left outer join vbfa             as _fluxo  on  _fluxo.vbelv   = right( _item.base_btd_id, 10 )
                                              and _fluxo.vbtyp_v = 'J'
                                              and _fluxo.vbtyp_n = 'R'
  left outer join j_1bnflin        as _nfe    on  _nfe.reftyp = 'MD'
                                              and _nfe.refkey = concat( _fluxo.vbeln, _fluxo.mjahr )
  left outer join j_1bnfe_active   as _status on _status.docnum = _nfe.docnum
  left outer join j_1bnfdoc        as _hd     on _hd.docnum = _nfe.docnum
  left outer join likp             as _likp   on _likp.vbeln = right( _item.base_btd_id, 10 )

{
  key _item.base_btd_id                                   as base_btd_id,
      cast( right ( _item.base_btd_id, 10 ) as vbeln_vl ) as remessa,
      _fluxo.vbeln                                        as fatura,
      _nfe.docnum                                         as doc_nfe,
      _status.code                                        as status,
      concat( _status.regio,
      concat( _status.nfyear,
      concat( _status.nfmonth,
      concat( _status.stcd1,
      concat( _status.model,
      concat( _status.serie,
      concat( _status.nfnum9,
      concat( _status.docnum9,
      _status.cdv ) ) ) ) ) ) ) )                         as nfe_key,
      _hd.nftype                                          as nftype,
      _hd.nfenum                                          as nfenum,
      _hd.series                                          as series,
      _hd.docdat                                          as docdat,
      _hd.partyp                                          as partyp,
      _hd.bukrs                                           as bukrs,
      _hd.branch                                          as branch,
      _hd.parid                                           as parid,
      _hd.inco1                                           as inco1,
      _likp.lfart                                         as lfart
}
where
     _item.base_btd_tco = '73'
  or _item.base_btd_tco = '58'
group by
  _item.base_btd_id,
  _fluxo.vbeln,
  _nfe.docnum,
  _status.code,
  _status.regio,
  _status.nfyear,
  _status.nfmonth,
  _status.stcd1,
  _status.model,
  _status.serie,
  _status.nfnum9,
  _status.docnum9,
  _status.cdv,
  _hd.nftype,
  _hd.nfenum,
  _hd.series,
  _hd.docdat,
  _hd.partyp,
  _hd.bukrs,
  _hd.branch,
  _hd.parid,
  _hd.inco1,
   _likp.lfart
