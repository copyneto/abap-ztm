@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_DOCDFF_ACCKEY

  as select from    /scmtms/d_sf_rot as sf_rot

    inner join      /scmtms/d_sf_itm as sf_itm     on sf_itm.parent_key = sf_rot.db_key

    inner join      /scmtms/d_torrot as torrot     on torrot.db_key = sf_itm.tor_root_key

    left outer join wbrp             as wbrp       on  wbrp.ref_doc_nr_2 = torrot.tor_id
                                                   and wbrp.ref_doc_nr_1 = sf_rot.sfir_id

    left outer join /scmtms/d_sf_doc as sf_doc_056 on  sf_doc_056.parent_key     = sf_rot.db_key
                                                   and sf_doc_056.btd_tco        = '56'  -- Folha de registro de serviços
                                                   and sf_doc_056.fsd_btd_status = '01'  -- Ativo

    left outer join /scmtms/d_sf_doc as sf_doc_001 on  sf_doc_001.parent_key     = sf_rot.db_key
                                                   and sf_doc_001.btd_tco        = '001' -- Pedido
                                                   and sf_doc_001.fsd_btd_status = '01'  -- Ativo

    left outer join /scmtms/d_sf_doc as sf_doc_127 on  sf_doc_127.parent_key     = sf_rot.db_key
                                                   and sf_doc_127.btd_tco        = '127' -- Fatura
                                                   and sf_doc_127.fsd_btd_status = '01'  -- Ativo

    left outer join rbkp             as rbkp       on  rbkp.belnr = left(
      sf_doc_127.btd_id, 10
    )
                                                   and rbkp.gjahr = left(
      sf_rot.inv_dt, 4
    )

    left outer join j_1bnflin        as nf_lin     on nf_lin.refkey = concat(
      left(
        sf_doc_127.btd_id, 10
      ), left(
        sf_rot.inv_dt, 4
      )
    )

    left outer join j_1bnfdoc        as nf_doc     on nf_doc.docnum = nf_lin.docnum

    left outer join essr             as essr       on essr.lblni = left(
      sf_doc_056.btd_id, 10
    )

    left outer join esll             as esll       on esll.packno = essr.packno

    left outer join esll             as esll_sub   on  esll_sub.packno     = esll.sub_packno
                                                   and esll_sub.sub_packno is initial

    left outer join eskn             as eskn       on eskn.packno = essr.lblni

    left outer join acdoca           as acdoca     on  acdoca.rldnr  = '0L'
                                                   and acdoca.rbukrs = rbkp.bukrs
                                                   and acdoca.awref  = rbkp.belnr
                                                   and acdoca.gjahr  = rbkp.gjahr

{
  key sf_rot.zzacckey                                   as acckey,
      torrot.tor_id                                     as tor_id,
      bintohex( sf_rot.db_key )                         as db_key,
      wbrp.ref_doc_nr_1                                 as ref_doc_nr_1,

      case when esll.extsrvno is not initial
            then cast( esll.extsrvno as ze_gko_tpevento )
            when esll_sub.extsrvno is not initial
            then cast( esll_sub.extsrvno as ze_gko_tpevento )
            else cast( '' as ze_gko_tpevento )
       end                                              as tpevento,

      wbrp.wbeln                                        as wbeln,
      sf_rot.sfir_id                                    as sfir_id,
      bintohex( sf_rot.db_key )                         as sfir_key,
      sf_rot.lifecycle                                  as lifecycle,
      sf_rot.confirmation                               as confirmation,

      cast( left( sf_rot.inv_dt, 4) as gjahr )          as btd_year,
      cast( left( sf_doc_056.btd_id, 10 ) as lblni )    as btd_id_056,
      cast( left( sf_doc_001.btd_id, 10 ) as ebeln )    as btd_id_001,
      cast( left( sf_doc_127.btd_id, 10 ) as re_belnr ) as btd_id_127,

      case when rbkp.stblg is not null
           then rbkp.stblg
           else cast( '' as re_stblg ) end              as btd_id_127_estorno,

      nf_lin.docnum                                     as docnum,
      nf_doc.nfenum                                     as nfenum,
      essr.packno                                       as packno,
      esll.sub_packno                                   as sub_packno,
      eskn.sakto                                        as sakto,
      eskn.kostl                                        as kostl,
      acdoca.belnr                                      as belnr_fin
}
where
      torrot.tor_cat   =  'TO'
  and torrot.tor_id    is not initial
  and sf_rot.lifecycle <> '06'  -- Cancelado
  and sf_rot.lifecycle <> '16'  -- Estornado
  and sf_rot.lifecycle <> ''
  and sf_rot.zzacckey  is not initial
