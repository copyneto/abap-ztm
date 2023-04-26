@AbapCatalog.sqlViewName: 'ZVTM_ITF_GKO_REF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relacionamento documentos'
define view ZI_TM_INTEGRA_GKO_REF
  as select from /scmtms/d_torite as _item

    inner join   vbfa             as _fluxo on  _fluxo.vbelv   = right( _item.base_btd_id, 10 )
                                            and _fluxo.posnv   = right( _item.base_btditem_id, 6 )
                                            and _fluxo.vbtyp_v = 'J'
                                            and _fluxo.vbtyp_n = 'M'
    inner join   j_1bnflin        as _nfe   on  _nfe.reftyp = 'BI'
                                            and _nfe.refkey = _fluxo.vbeln
                                            and _nfe.refitm = _fluxo.posnn
    inner join   vbrk             as _vbrk  on _vbrk.vbeln = _fluxo.vbeln
{
  key _item.base_btd_id                                      as base_btd_id,
  key _item.base_btditem_id                                  as base_btditem_id,
      cast( right ( _item.base_btd_id, 10 ) as vbeln_vl )    as vbeln_vl,
      cast( right ( _item.base_btditem_id, 6 ) as posnr_vl ) as posnr_vl,
      _fluxo.vbeln                                           as vbeln_vf,
      _fluxo.posnn                                           as posnr_vf,
      _nfe.docnum                                            as docnum,
      _nfe.itmnum                                            as itmnum,
      _nfe.cfop                                              as cfop,
      _nfe.netwr                                             as netwr
}
where (
     _item.base_btd_tco = '73'
  or _item.base_btd_tco = '58' )
  and _vbrk.fksto <> 'X'  -- Fatura estornada
  and _vbrk.fkart <> 'S1' -- Tipo de documento diferente de estorno
group by
  _item.base_btd_id,
  _item.base_btditem_id,
  _fluxo.vbeln,
  _fluxo.posnn,
  _nfe.docnum,
  _nfe.itmnum,
  _nfe.cfop,
  _nfe.netwr

union select from /scmtms/d_torite as _item

  inner join      vbfa             as _fluxo on  _fluxo.vbelv   = right( _item.base_btd_id, 10 )
                                             and _fluxo.posnv   = right( _item.base_btditem_id, 6 )
                                             and _fluxo.vbtyp_v = 'J'
                                             and _fluxo.vbtyp_n = 'R'
  inner join      j_1bnflin        as _nfe   on  _nfe.reftyp = 'MD'
                                             and _nfe.refkey = concat( _fluxo.vbeln, _fluxo.mjahr )
                                             and _nfe.refitm = _fluxo.posnn
{
  key _item.base_btd_id                                      as base_btd_id,
  key _item.base_btditem_id                                  as base_btditem_id,
      cast( right ( _item.base_btd_id, 10 ) as vbeln_vl )    as vbeln_vl,
      cast( right ( _item.base_btditem_id, 6 ) as posnr_vl ) as posnr_vl,
      _fluxo.vbeln                                           as vbeln_vf,
      _fluxo.posnn                                           as posnr_vf,
      _nfe.docnum                                            as docnum,
      _nfe.itmnum                                            as itmnum,
      _nfe.cfop                                              as cfop,
      _nfe.netwr                                             as netwr
}
where (
     _item.base_btd_tco = '73'
  or _item.base_btd_tco = '58' )
group by
  _item.base_btd_id,
  _item.base_btditem_id,
  _fluxo.vbeln,
  _fluxo.posnn,
  _nfe.docnum,
  _nfe.itmnum,
  _nfe.cfop,
  _nfe.netwr
