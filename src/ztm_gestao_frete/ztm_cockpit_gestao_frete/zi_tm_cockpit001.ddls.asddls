@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_COCKPIT001
  as select from    zttm_gkot001                 as gkot001

    left outer join ZI_TM_COCKPIT001_REFERENCIA  as gkot003     on gkot003.acckey = gkot001.acckey
    left outer join zttm_gkot004                 as gkot004     on gkot004.acckey = gkot001.acckey
    left outer join ZI_TM_GKOT006_LOG            as gkot006     on gkot006.acckey = gkot001.acckey
    left outer join zttm_gkot007                 as gkot007     on  gkot007.acckey    = gkot001.acckey
                                                                and gkot007.codevento = gkot001.codevento

    left outer join ZI_INFOS_FLUIG               as infos_fluig on  infos_fluig.OrdemFrete = gkot001.tor_id
                                                                and gkot001.cenario        = '06' -- Fretes Diversos

    left outer join /scmtms/d_torrot             as torrot      on  torrot.tor_id =  gkot001.tor_id
                                                                and torrot.tor_id <> ''

    left outer join bseg                         as bseg        on  bseg.bukrs = gkot001.bukrs
                                                                and bseg.belnr = gkot001.belnr
                                                                and bseg.gjahr = gkot001.gjahr
                                                                and bseg.buzei = '001'

    left outer join ztfi_retpag_segz             as retpag_segz on  retpag_segz.bukrs  = gkot001.bukrs_doc
                                                                and retpag_segz.lifnr  = gkot001.emit_cod
                                                                and retpag_segz.belnr  = gkot001.belnr
                                                                and retpag_segz.zgjahr = gkot001.gjahr

    left outer join zttm_gkot010                 as gkot010     on gkot010.acckey = gkot001.acckey

    left outer join zttm_gkot009                 as gkot009     on  gkot009.xblnr = gkot010.xblnr
                                                                and gkot009.stcd1 = gkot010.stcd1
                                                                and gkot009.bldat = gkot010.bldat

    left outer join ZI_TM_COCKPIT001_FATURA_INFO as _fatura     on _fatura.acckey = gkot001.acckey

    left outer join ZI_TM_COCKPIT001_DFF         as dff         on dff.acckey = gkot001.acckey

    left outer join essr                         as essr        on essr.ebeln = substring(
      dff.btd_id_001, 1, 10
    )
    left outer join ekpo                         as ekpo        on  ekpo.ebeln = essr.ebeln
                                                                and ekpo.ebelp = '00010'

    left outer join j_1bnflin                    as nf_lin      on nf_lin.refkey = concat(
      gkot001.re_belnr, gkot001.re_gjahr
    )

    left outer join j_1bnfdoc                    as nf_doc      on nf_doc.docnum = nf_lin.docnum


  composition [0..*] of ZI_TM_COCKPIT006            as _log

  /* Relacionamentos */

  association [0..1] to ZI_TM_ATTACHMENT_FILE       as attachment_file    on  attachment_file.tor_id = $projection.tor_id
                                                                          and attachment_file.acckey = $projection.acckey
  association [0..1] to zi_tm_nf_impostos           as nf_impostos_iss    on  nf_impostos_iss.acckey = $projection.acckey
                                                                          and nf_impostos_iss.taxgrp = 'ISSS' -- 'ISS'
  association [0..1] to ZI_TM_NF_IMPOSTOS_INSS      as nf_impostos_inss   on  nf_impostos_inss.acckey = $projection.acckey
  association [0..1] to ZI_TM_NF_IMPOSTOS_TRIO      as nf_impostos_trio   on  nf_impostos_trio.acckey = $projection.acckey
  association [0..1] to zi_tm_nf_impostos           as nf_impostos_irrf   on  nf_impostos_irrf.acckey = $projection.acckey
                                                                          and nf_impostos_irrf.taxgrp = 'WHIR' -- 'IRRF'
  association [0..1] to zi_tm_nf_impostos           as nf_impostos_pis    on  nf_impostos_pis.acckey = $projection.acckey
                                                                          and nf_impostos_pis.taxgrp = 'PIS'
  association [0..1] to zi_tm_nf_impostos           as nf_impostos_cofins on  nf_impostos_cofins.acckey = $projection.acckey
                                                                          and nf_impostos_cofins.taxgrp = 'COFI'

  /* Descrições */

  association [0..1] to ZI_CA_VH_BUKRS              as _bukrs             on  _bukrs.Empresa = $projection.bukrs
  association [0..1] to ZI_CA_VH_WERKS              as _werks             on  _werks.WerksCode = $projection.werks
  association [0..1] to ZI_TM_VH_FRETE_CENARIO      as _cenario           on  _cenario.cenario = $projection.cenario
  association [0..1] to ZI_TM_VH_FRETE_CODSTATUS    as _codstatus         on  _codstatus.codstatus = $projection.codstatus
  association [0..1] to ZI_CA_VH_REGIO_BR           as _rem_uf            on  _rem_uf.Region = $projection.rem_uf
  association [0..1] to ZI_CA_VH_PARTNER            as _rem_cod           on  _rem_cod.Parceiro = $projection.rem_cod
  association [0..1] to ZI_CA_VH_REGIO_BR           as _dest_uf           on  _dest_uf.Region = $projection.dest_uf
  association [0..1] to ZI_CA_VH_PARTNER            as _dest_cod          on  _dest_cod.Parceiro = $projection.dest_cod
  association [0..1] to ZI_TM_VH_FRETE_TPDOC        as _tpdoc             on  _tpdoc.tpdoc = $projection.tpdoc
  association [0..1] to ZI_CA_VH_MODEL              as _model             on  _model.model = $projection.model
  association [0..1] to ZI_CA_VH_DIRECT             as _direct            on  _direct.Direct = $projection.direct
  association [0..1] to ZI_TM_VH_FRETE_PROD_ACABADO as _prod_acabado      on  _prod_acabado.prod_acabado = $projection.prod_acabado
  association [0..1] to ZI_TM_VH_FRETE_TPRATEIO     as _tprateio          on  _tprateio.tprateio = $projection.rateio
  association [0..1] to ZI_TM_VH_FRETE_CODEVENTO    as _codevento         on  _codevento.codevento = $projection.codevento
  association [0..1] to ZI_TM_VH_FRETE_TPCTE        as _tpcte             on  _tpcte.tpcte = $projection.tpcte
  association [0..1] to ZI_CA_VH_PARTNER            as _emit_cod          on  _emit_cod.Parceiro = $projection.emit_cod
  association [0..1] to ZI_CA_VH_REGIO_BR           as _emit_uf           on  _emit_uf.Region = $projection.emit_uf
  association [0..1] to ZI_CA_VH_PARTNER            as _tom_cod           on  _tom_cod.Parceiro = $projection.tom_cod
  association [0..1] to ZI_CA_VH_REGIO_BR           as _tom_uf            on  _tom_uf.Region = $projection.tom_uf
  association [0..1] to ZI_CA_VH_PARTNER            as _BusinessPartner   on  _BusinessPartner.Parceiro = $projection.BusinessPartner
  association [0..1] to ZI_CA_VH_REGIO_BR           as _receb_uf          on  _receb_uf.Region = $projection.receb_uf
  association [0..1] to ZI_CA_VH_PARTNER            as _ShipperPartner    on  _ShipperPartner.Parceiro = $projection.ShipperPartner
  association [0..1] to ZI_CA_VH_REGIO_BR           as _exped_uf          on  _exped_uf.Region = $projection.exped_uf
  association [0..1] to ZI_TM_VH_VSTEL              as _vstel             on  _vstel.LocalExpedicao = $projection.vstel
  association [0..1] to ZI_TM_VH_LIFECYCLE          as _lifecycle         on  _lifecycle.lifecycle = $projection.lifecycle
  association [0..1] to ZI_TM_VH_CONFIRMATION       as _confirmation      on  _confirmation.confirmation = $projection.confirmation
  association [0..1] to ZI_CA_VH_SAKNR_PC3C         as _sakto             on  _sakto.GLAccount = $projection.sakto
  association [0..1] to ZI_CA_VH_KOSTL              as _kostl             on  _kostl.CentroCusto = $projection.kostl
  association [0..1] to ZI_CA_VH_BUKRS              as _bukrs_doc         on  _bukrs_doc.Empresa = $projection.bukrs_doc
  association [0..1] to ZI_CA_VH_PARTNER            as _crenam            on  _crenam.Parceiro = $projection.crenam
  association [0..1] to ZI_CA_VH_PARTNER            as _chanam            on  _chanam.Parceiro = $projection.chanam
  association [0..1] to zi_tm_sh_motivo_rejeicao    as _not_code          on  _not_code.doctype  = $projection.doctype
                                                                          and _not_code.not_code = $projection.not_code

  association [0..1] to ZI_CA_VH_BRANCH             as _branch            on  _branch.CompanyCode   = $projection.bukrs
                                                                          and _branch.BusinessPlace = $projection.branch
  association [0..1] to ZI_TM_VH_FRETE_SITUACAO     as _sitdoc            on  _sitdoc.sitdoc = $projection.sitdoc

  association [0..1] to ZI_TM_MONITOR_GKO_LOG_LAST  as _UltimoLog         on  _UltimoLog.acckey = $projection.acckey

  association [0..1] to ZI_TM_VH_FRETE_CFOP_CONFIG  as _cfop_config       on  _cfop_config.cfop = $projection.cfop

{
  key gkot001.acckey                                         as acckey,
      dff.db_key                                             as dff_db_key,
      gkot001.tpevento                                       as tpevento,

      case gkot001.tpdoc
      when 'CTE' then cast( 'CTE' as /xnfe/doctype )
      when 'NFS' then cast( 'NFE' as /xnfe/doctype)
      else cast( '' as /xnfe/doctype)  end                   as doctype,

      gkot001.bukrs                                          as bukrs,
      _bukrs.EmpresaText                                     as bukrs_txt,
      gkot001.werks                                          as werks,
      _werks.WerksCodeName                                   as werks_txt,
      gkot001.cenario                                        as cenario,
      _cenario.cenario_txt                                   as cenario_txt,
      gkot001.codstatus                                      as codstatus,
      _codstatus.codstatus_txt                               as codstatus_txt,

      case left( gkot001.codstatus, 1 )
      when 'E' then 1
               else 0
      end                                                    as codstatus_crit,

      gkot001.rem_uf                                         as rem_uf,
      _rem_uf.RegionName                                     as rem_uf_txt,
      gkot004.rem_mun                                        as rem_mun,
      gkot001.dest_uf                                        as dest_uf,
      _dest_uf.RegionName                                    as dest_uf_txt,
      gkot004.dest_mun                                       as dest_mun,

      case when gkot001.nfnum9 is not initial
           then gkot001.nfnum9
           when gkot001.prefno is not initial
           then gkot001.prefno
           else cast( '' as j_1bprefno )  end                as nfnum9,

      gkot001.prefno                                         as prefno,
      gkot001.num_fatura                                     as num_fatura,

      _fatura.re_belnr                                       as SupplierInvoice,
      _fatura.re_gjahr                                       as FiscalYear,
      _fatura.rbstat                                         as rbstat,

      case when cast( gkot001.vct_gko as abap.char(8) ) = ''
           then cast( '00000000' as abap.dats )
           else gkot001.vct_gko end                          as vct_gko,
      //      businesspartner.FirstName                              as first_name,
      gkot006.counter                                        as counter,
      gkot001.pago                                           as pago,

      case gkot001.pago
      when 'X' then 3
               else 1 end                                    as pago_criticality,

      gkot001.tpdoc                                          as tpdoc,
      _tpdoc.tpdoc_txt                                       as tpdoc_txt,
      gkot001.direct                                         as direct,
      _direct.DirectText                                     as direct_txt,
      gkot001.model                                          as model,
      _model.model_txt                                       as model_txt,
      gkot003.prod_acabado                                   as prod_acabado,
      _prod_acabado.prod_acabado_txt                         as prod_acabado_desc,

      // Link para lista da tabela Zttm_Cockpit006,
      gkot001.rateio                                         as rateio,
      _tprateio.tprateio_txt                                 as rateio_txt,
      gkot007.codevento                                      as codevento,
      _codevento.codevento_txt                               as codevento_txt,
      gkot007.dhregevento                                    as dhregevento,
      cast( gkot001.tpcte as abap.char(1) )                  as tpcte,
      _tpcte,

      //gkot007.DHREGEVENTO, // (data)
      //gkot007.DHREGEVENTO, // (hora)

      gkot007.cstat                                          as cstat,
      gkot007.xmotivo                                        as xmotivo,
      gkot001.vtprest                                        as vtprest,
      gkot001.vrec                                           as vrec,
      gkot001.vbcicms                                        as vbcicms,
      gkot001.vbciss                                         as vbciss,
      gkot001.picms                                          as picms,
      gkot001.piss                                           as piss,
      gkot001.vicms                                          as vicms,
      gkot001.viss                                           as viss,
      gkot001.vcarga                                         as vcarga,
      gkot001.qcarga                                         as qcarga,
      //Dir.movim.mercads. vtprest,
      gkot001.series                                         as series,
      gkot001.cfop                                           as cfop,

      case when gkot001.tpdoc = 'NFS'
           then cast( 'X' as boole_d )
           when gkot001.tpdoc = 'NFE'
           then cast( 'X' as boole_d )
           when gkot001.tpdoc = 'CTE' and _cfop_config.cfop is not null
           then cast( 'X' as boole_d )
           else cast( '' as boole_d )
           end                                               as cfop_ok,

      ''                                                     as funrural,
      //Funrural
      //Soma dos itens J_1BNFSTX-TAXVAL
      //(Com TAXGRP   =ISS e DOCNUM = J_1BNFE_ACTIVE-DOCNUM
      //quando campos que compõem chave da NF forem igual a
      //ZTTM_COCKPIT001-ACCKEY )
      //Inserir valor da retenção

      //      cast( nf_impostos_iss.taxval as abap.dec( 15, 2 ) )    as iss,
      //      cast( nf_impostos_inss.taxval as abap.dec( 15, 2 ) )   as inss,
      //      cast( nf_impostos_trio.taxval as abap.dec( 15, 2 ) )   as trio,
      //      cast( nf_impostos_irrf.taxval as abap.dec( 15, 2 ) )   as irrf,

      @Semantics.amount.currencyCode: 'iss_curr'
      nf_impostos_iss.taxval                                 as iss,
      nf_impostos_iss.CurrencyCode                           as iss_curr,
      @Semantics.amount.currencyCode: 'inss_curr'
      nf_impostos_inss.taxval                                as inss,
      nf_impostos_inss.CurrencyCode                          as inss_curr,
      @Semantics.amount.currencyCode: 'trio_curr'
      nf_impostos_trio.taxval                                as trio,
      nf_impostos_trio.CurrencyCode                          as trio_curr,
      @Semantics.amount.currencyCode: 'irrf_curr'
      nf_impostos_irrf.taxval                                as irrf,
      nf_impostos_irrf.CurrencyCode                          as irrf_curr,
      cast ('BRL' as abap.cuky)                              as moeda,

      gkot001.emit_cod                                       as emit_cod,
      _emit_cod.Nome                                         as emit_cod_txt,
      gkot001.emit_cnpj_cpf                                  as emit_cnpj_cpf,
      gkot001.emit_ie                                        as emit_ie,
      gkot001.emit_uf                                        as emit_uf,
      _emit_uf.RegionName                                    as emit_uf_txt,
      gkot004.emit_mun                                       as emit_mun,

      gkot001.tom_cod                                        as tom_cod,
      _tom_cod.Nome                                          as tom_cod_txt,
      gkot001.tom_cnpj_cpf                                   as tom_cnpj_cpf,
      gkot001.tom_ie                                         as tom_ie,
      gkot001.tom_uf                                         as tom_uf,
      _tom_uf.RegionName                                     as tom_uf_txt,
      gkot004.tom_mun                                        as tom_mun,

      gkot001.rem_cod                                        as rem_cod,
      _rem_cod.Nome                                          as rem_cod_txt,
      gkot001.rem_cnpj_cpf                                   as rem_cnpj_cpf,
      gkot001.rem_ie                                         as rem_ie,

      gkot001.dest_cod                                       as dest_cod,
      _dest_cod.Nome                                         as dest_cod_txt,

      case when gkot001.dest_cnpj is not initial
           then gkot001.dest_cnpj
           else cast( cast( gkot001.dest_cpf as abap.char(14) ) as abap.numc(14) )
           end                                               as dest_cnpj_cpf,
      gkot001.dest_ie                                        as dest_ie,

      gkot001.receb_cod                                      as BusinessPartner,
      _BusinessPartner.Nome                                  as BusinessPartnerName,

      case when gkot001.receb_cnpj is not initial
           then gkot001.receb_cnpj
           else cast( cast( gkot001.receb_cpf as abap.char(14) ) as abap.numc(14) )
           end                                               as receb_cnpj_cpf,

      gkot001.receb_ie                                       as receb_ie,
      gkot001.receb_uf                                       as receb_uf,
      _receb_uf.RegionName                                   as receb_uf_txt,
      gkot004.receb_mun                                      as receb_mun,

      gkot001.exped_cod                                      as ShipperPartner,
      _ShipperPartner.Nome                                   as ShipperPartnerName,

      case when gkot001.exped_cnpj is not initial
           then gkot001.exped_cnpj
           else cast( cast( gkot001.receb_cpf as abap.char(14) ) as abap.numc(14) )
           end                                               as exped_cnpj_cpf,

      gkot001.exped_ie                                       as exped_ie,
      gkot001.exped_uf                                       as exped_uf,
      _exped_uf.RegionName                                   as exped_uf_txt,
      gkot004.exped_mun                                      as exped_mun,

      gkot001.vstel                                          as vstel,
      _vstel.Text                                            as vstel_txt,

      case when attachment_file.anexo_gnre > 0
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end                    as possui_anexo_gnre,

      case when attachment_file.anexo_gnre > 0
           then 3
           else 1 end                                        as possui_anexo_gnre_crit,

      case when attachment_file.comprovante_gnre > 0
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end                    as possui_comprovante_gnre,

      case when attachment_file.comprovante_gnre > 0
           then 3
           else 1 end                                        as possui_comprovante_gnre_crit,

      case when attachment_file.comprovante_nfs > 0
           then cast( 'X' as boole_d )
           else cast( '' as boole_d ) end                    as possui_anexo_nfs,

      case when attachment_file.comprovante_nfs > 0
           then 3
           else 1 end                                        as possui_anexo_nfs_crit,

      ''                                                     as frete_calculado_gko, //* TABELA PENDENTE DE INTEGRAÇÂO DA PROVISÃO!
                                                                                     //RM AINDA NÃO ESPECIFICADA (RM.1044 - PROVISÃO INTEGRAÇÃO GKO)

      case when dff.btd_id_127 is not initial
           then dff.docnum
           when gkot001.re_belnr is not initial
           then nf_doc.docnum
           else cast( '' as j_1bdocnum )
      end                                                    as BR_NotaFiscal,

      gkot001.tor_id                                         as tor_id,
      dff.sfir_id                                            as sfir_id,
      dff.lifecycle                                          as lifecycle,
      _lifecycle.lifecycle_txt                               as lifecycle_txt,
      dff.confirmation                                       as confirmation,
      _confirmation.confirmation_txt                         as confirmation_txt,
      dff.btd_id_056                                         as btd_id,

      essr.lblni                                             as lblni,
      dff.ref_doc_nr_1                                       as ref_doc_nr_1,
      dff.wbeln                                              as wbeln,
      gkot001.belnr                                          as belnr_fin,
      //      _fatura.belnr_fin                                      as belnr_fin,
      //      ekpo.sakto                                             as sakto,
      dff.sakto                                              as sakto,
      _sakto.GLAccountLongName                               as sakto_txt,
      //      ekpo.kostl                                             as kostl,
      dff.kostl                                              as kostl,
      _kostl.Denominacao                                     as kostl_txt,

      gkot001.usr_lib                                        as usr_lib,
      gkot001.re_belnr                                       as re_belnr,
      _fatura.re_gjahr                                       as rbkp_gjahr,
      _fatura.budat                                          as rbkp_budat,
      _fatura.usnam                                          as usnam,
      _fatura.usnam_txt                                      as usnam_txt,
      _fatura.cputm                                          as cputm,
      gkot001.bukrs_doc                                      as bukrs_doc,
      _bukrs_doc.EmpresaText                                 as bukrs_doc_txt,
      gkot001.belnr                                          as belnr,
      gkot001.gjahr                                          as gjahr,
      gkot001.budat                                          as budat,
      gkot001.augdt                                          as augdt,
      gkot001.credat                                         as credat,
      gkot001.cretim                                         as cretim,
      gkot001.crenam                                         as crenam,
      _crenam.Nome                                           as crenam_txt,
      gkot001.chadat                                         as chadat,
      gkot001.chatim                                         as chatim,
      gkot001.chanam                                         as chanam,
      _chanam.Nome                                           as chanam_txt,
      gkot001.desconto                                       as desconto, -- Desconto (rateado por peso do CT-e no agrupamento)

      //Rateio do Desconto do agrupamento do
      //ZTTM_COCKPIT009 proporcional aos valores de
      //Documentos agrupados listados nas tabelas Z*010 e Z*011
      cast( nf_impostos_pis.taxval as abap.dec( 15, 2 ) )    as pis,
      cast( nf_impostos_cofins.taxval as abap.dec( 15, 2 ) ) as cofins,

      infos_fluig.VlrFrete                                   as frete_cotado_fluig,

      @Semantics.quantity.unitOfMeasure: 'gro_wei_uni'
      cast( torrot.gro_wei_val as abap.quan(31,3))           as gro_wei_val,
      torrot.gro_wei_uni                                     as gro_wei_uni,

      //ZTFI_RETPAG_SEGZ-ZAUTENTICABAN (Seleção conforme step3 da RICEFW 32Z-198R17)
      retpag_segz.zautenticaban                              as autenticacao_bancaria,
      gkot001.not_code                                       as not_code,
      _not_code,
      gkot001.branch                                         as branch,
      _branch.BusinessPlaceName                              as branch_txt,
      gkot001.sitdoc                                         as sitdoc,
      _sitdoc.sitdoc_txt                                     as sitdoc_txt,
      gkot001.dtemi                                          as dtemi,
      gkot001.hremi                                          as hremi,

      /* Campos para Botões */

      cast( '' as /xnfe/not_code )                           as motivoRejeicao,
      cast( '' as boole_d )                                  as estornoAgrupamento,
      cast( '' as boole_d )                                  as estornoMiro,
      cast( '' as boole_d )                                  as estornoPedido,

      dff.sfir_key                                           as SuplrFrtInvcReqUUID,

      cast( substring( dff.btd_id_001, 1, 10 ) as ebeln )    as Pedido, -- Pedido de Compra

      _UltimoLog._Log.desc_codigo                            as UltimoLog,

      /* Associations */

      _log,

      bintohex( torrot.db_key )                              as TransportationOrderUUID

}
