@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos relacionados à NF de entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_FRETE_DOCS_NF_ENTRA_U

  as select from           lips

    left outer join        ekes             as _ekes     on  _ekes.vbeln = lips.vbeln
                                                         and _ekes.vbelp = lips.posnr

    left outer join        ekpo             as _ekpo     on _ekpo.ebeln = _ekes.ebeln

    left outer join        rseg             as _rseg     on  _rseg.ebeln = _ekes.ebeln
                                                         and _rseg.ebelp = _ekes.ebelp

    left outer join        rbkp             as _rbkp     on  _rbkp.belnr = _rseg.belnr
                                                         and _rbkp.gjahr = _rseg.gjahr

    left outer join        j_1bnflin        as _lin      on  _lin.refkey = concat(
      _rseg.belnr, _rseg.gjahr
    )
                                                         and _lin.refitm = _rseg.buzei

    left outer join        j_1bnfdoc        as _doc      on _doc.docnum = _lin.docnum

    left outer join        j_1bnfe_active   as _active   on _active.docnum = _lin.docnum

    left outer join        /scmtms/d_torite as _lips_ref on  _lips_ref.base_btd_id  = lpad( lips.vbeln, 35, '0' )
                                                         and _lips_ref.base_btd_tco = '58' -- Recebimento

    left outer join        /scmtms/d_torrot as _of       on  _of.db_key = _lips_ref.parent_key
                                                         and _of.tor_cat  = 'TO' -- Ordem de Frete

    left outer join        /scmtms/d_torrot as _uf       on  _uf.db_key  = _lips_ref.fu_root_key
                                                         and _uf.tor_cat = 'FU' -- Unidade de Frete

{
      -- Remessa
  key lips.vbeln                                           as vbeln_vl,
  key lips.posnr                                           as posnr_vl,

      -- Ordem de Venda
      lips.vgbel                                           as vbeln_va,
      lips.vgpos                                           as posnr_va,

      -- Pedido
      _ekes.ebeln                                          as ebeln,
      _ekes.ebelp                                          as ebelp,
      _ekes.etens                                          as etens,

      -- Fatura
      _rseg.belnr                                          as belnr,
      _rseg.gjahr                                          as gjahr,
      _rseg.buzei                                          as buzei,

      -- Fatura (estorno)
      _rbkp.stblg                                          as stblg,
      _rbkp.stjah                                          as stjah,

      -- Nota Fiscal Entrada
      _lin.docnum                                          as docnum,
      _lin.itmnum                                          as itmnum,
      _doc.cancel                                          as cancel,

      concat( _active.regio,
      concat( _active.nfyear,
      concat( _active.nfmonth,
      concat( _active.stcd1,
      concat( _active.model,
      concat( _active.serie,
      concat( _active.nfnum9,
      concat( _active.docnum9,
              _active.cdv ) ) ) ) ) ) ) )                  as acckey,

      case when _lin.mwskz is not null and _lin.mwskz is not initial
           then _lin.mwskz
           when _ekpo.mwskz is not null and _ekpo.mwskz is not initial
           then _ekpo.mwskz
           when lips.j_1btxsdc is not null and lips.j_1btxsdc is not initial
           then lips.j_1btxsdc
           else cast( '' as mwskz )
           end                                             as mwskz,

      -- Ordem de Frete
      cast( _of.db_key as /bobf/conf_key preserving type ) as of_db_key,
      _of.tor_id                                           as of_tor_id,
      _of.tor_cat                                          as of_tor_cat,
      _of.tor_type                                         as of_tor_type,

      -- Unidade de Frete
      _uf.tor_id                                           as uf_tor_id
}
