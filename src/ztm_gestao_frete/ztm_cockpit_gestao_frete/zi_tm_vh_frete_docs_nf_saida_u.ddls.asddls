@AbapCatalog.sqlViewName: 'ZVTM_NF_SAIDA_U'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos relacionados à NF de saída'
define view ZI_TM_VH_FRETE_DOCS_NF_SAIDA_U
  as select from           /scmtms/d_torrot as _of

    left outer join        /scmtms/d_torite as _lips_ref on  _lips_ref.parent_key   = _of.db_key
                                                         and _lips_ref.base_btd_tco = '73'  -- Entrega

    left outer join        lips             as _lips     on _lips.vbeln = right( _lips_ref.base_btd_id, 10 )

    left outer to one join /scmtms/d_torrot as _uf       on  _uf.db_key  = _lips_ref.fu_root_key
                                                         and _uf.tor_cat = 'FU'             -- Unidade de Frete

    left outer to one join /scmtms/d_tordrf as _vbap_ref on  _vbap_ref.parent_key = _uf.db_key
                                                         and _vbap_ref.btd_tco    = '114'   -- Ordem de Venda

    left outer to one join vbrp             as _vbrp     on  _vbrp.aubel = _lips.vgbel
                                                         and _vbrp.aupos = _lips.vgpos
                                                         and _vbrp.vgbel = _lips.vbeln
                                                         and _vbrp.vgpos = _lips.posnr

    left outer join        j_1bnflin        as _lin      on  _lin.reftyp = 'BI'
                                                         and _lin.refkey = _vbrp.vbeln
                                                         and _lin.refitm = _vbrp.posnr

    left outer join        j_1bnfdoc        as _doc      on _doc.docnum = _lin.docnum

    left outer join        j_1bnfe_active   as _active   on _active.docnum = _lin.docnum

{
       -- Remessa
  key  cast( right( _lips_ref.base_btd_id, 10 ) as vbeln_vl ) as vbeln_vl,
  key  _lips.posnr                                            as posnr_vl,

       -- Ordem de Venda
       case when _vbap_ref.btd_id is not null
            then cast( right( _vbap_ref.btd_id, 10 ) as vbeln_va )
            else _lips.vgbel
            end                                               as vbeln_va,
       _lips.vgpos                                            as posnr_va,

       -- Fatura
       _vbrp.vbeln                                            as vbeln_vf,
       _vbrp.posnr                                            as posnr_vf,

       -- Documento Material
       cast( '' as mblnr )                                    as mblnr,
       cast( '0000' as mjahr )                                as mjahr,
       cast( '000000' as j_1brefitm )                         as zeile,

       -- Nota Fiscal Saída
       _lin.reftyp                                            as reftyp,
       _lin.refkey                                            as refkey,
       _lin.refitm                                            as refitm,
       _lin.docnum                                            as docnum,
       _lin.itmnum                                            as itmnum,
       _doc.cancel                                            as cancel,

       concat( _active.regio,
       concat( _active.nfyear,
       concat( _active.nfmonth,
       concat( _active.stcd1,
       concat( _active.model,
       concat( _active.serie,
       concat( _active.nfnum9,
       concat( _active.docnum9,
               _active.cdv ) ) ) ) ) ) ) )                    as acckey,
              
       case when _lin.mwskz is not null and _lin.mwskz is not initial
            then _lin.mwskz
            when _vbrp.mwskz is not null and _vbrp.mwskz is not initial
            then _vbrp.mwskz
            when _lips.j_1btxsdc is not null and _lips.j_1btxsdc is not initial
            then _lips.j_1btxsdc 
            else cast( '' as mwskz ) 
            end                                               as mwskz,

       -- Ordem de Frete
       cast( _of.db_key as /bobf/conf_key preserving type )   as of_db_key,
       _of.tor_id                                             as of_tor_id,
       _of.tor_cat                                            as of_tor_cat,
       _of.tor_type                                           as of_tor_type,
       
       -- Unidade de Frete
       _uf.tor_id                                             as uf_tor_id

}
where
      _of.tor_id  is not initial
  and _of.tor_cat = 'TO' -- Ordem de frete

union select from /scmtms/d_torrot as _of

  left outer join /scmtms/d_torite as _lips_ref on  _lips_ref.parent_key   = _of.db_key
                                                and _lips_ref.base_btd_tco = '73' -- Entrega

  left outer join lips             as _lips     on _lips.vbeln = right( _lips_ref.base_btd_id, 10 )

  left outer join nsdm_e_mseg      as _mseg     on  _mseg.ebeln    = _lips.vgbel
                                                and _mseg.ebelp    = right( _lips.vgpos, 5 )
                                                and _mseg.vbeln_im = _lips.vbeln
                                                and _mseg.vbelp_im = _lips.posnr

  left outer join j_1bnflin        as _lin      on  _lin.reftyp = 'MD'
                                                and _lin.refkey = concat( left( _mseg.mblnr, 10 ), left( _mseg.mjahr, 4 ) )

  left outer join j_1bnfe_active   as _active   on _active.docnum = _lin.docnum

  left outer join j_1bnfdoc        as _doc      on _doc.docnum = _lin.docnum

{
       -- Remessa
  key  cast( right( _lips_ref.base_btd_id, 10 ) as vbeln_vl ) as vbeln_vl,
  key  _lips.posnr                                            as posnr_vl,

       -- Ordem de Venda
       _lips.vgbel                                            as vbeln_va,
       _lips.vgpos                                            as posnr_va,

       -- Fatura
       cast( '' as vbeln_vf )                                 as vbeln_vf,
       cast( '000000' as posnr_vf )                           as posnr_vf,

       -- Documento Material
       _mseg.mblnr                                            as mblnr,
       _mseg.mjahr                                            as mjahr,
       cast( concat( '00', _mseg.zeile ) as j_1brefitm )      as zeile,

       -- Nota Fiscal Saída
       _lin.reftyp                                            as reftyp,
       _lin.refkey                                            as refkey,
       _lin.refitm                                            as refitm,

       _lin.docnum                                            as docnum,
       _lin.itmnum                                            as itmnum,
       _doc.cancel                                            as cancel,

       concat( _active.regio,
       concat( _active.nfyear,
       concat( _active.nfmonth,
       concat( _active.stcd1,
       concat( _active.model,
       concat( _active.serie,
       concat( _active.nfnum9,
       concat( _active.docnum9,
               _active.cdv ) ) ) ) ) ) ) )                    as acckey,
              
       case when _lin.mwskz is not null and _lin.mwskz is not initial
            then _lin.mwskz
            when _mseg.mwskz is not null and _mseg.mwskz is not initial
            then _mseg.mwskz
            when _lips.j_1btxsdc is not null and _lips.j_1btxsdc is not initial
            then _lips.j_1btxsdc 
            else cast( '' as mwskz ) 
            end                                               as mwskz,

       -- Ordem de Frete
       cast( _of.db_key as /bobf/conf_key preserving type )   as of_db_key,
       _of.tor_id                                             as of_tor_id,
       _of.tor_cat                                            as of_tor_cat,
       _of.tor_type                                           as of_tor_type,
       
       -- Unidade de Frete
       cast( '' as  /scmtms/tor_id )                          as uf_tor_id
      
}
where
      _of.tor_id  is not initial
  and _of.tor_cat = 'TO' -- Ordem de frete
  and _lin.docnum is not initial
