@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Integração GKO: Redespacho'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_INTEGRA_GKO_REDESPACHO
  as select from    /scmtms/d_torrot as _OrdemFreteCross

    inner join      /scmtms/d_tordrf as _OrdemFreteCrossRedespacho on  _OrdemFreteCrossRedespacho.parent_key = _OrdemFreteCross.db_key
                                                                   and _OrdemFreteCrossRedespacho.btd_tco    = 'OFFIL' -- Ordem de Frete Filha - 2ª Etapa

    inner join      /scmtms/d_torrot as _OrdemFreteRedespacho      on  _OrdemFreteRedespacho.tor_id  = right( _OrdemFreteCrossRedespacho.btd_id, 20 )
                                                                   and _OrdemFreteRedespacho.tor_cat = 'TO' -- Ordem de frete

    left outer join /scmtms/d_torite as _Entrega                   on _Entrega.parent_key     = _OrdemFreteRedespacho.db_key
                                                                   and( _Entrega.base_btd_tco = '73' -- Entrega
                                                                     or _Entrega.base_btd_tco = '58' -- Recebimento
                                                                   )

    left outer join vbfa             as fluxo                      on  fluxo.vbelv   = right( _Entrega.base_btd_id, 10 )
                                                                   and fluxo.vbtyp_v = 'J'
                                                                   and fluxo.vbtyp_n = 'M'
    left outer join j_1bnflin        as nfe                        on  nfe.reftyp = 'BI'
                                                                   and nfe.refkey = fluxo.vbeln
    left outer join j_1bnfe_active   as status                     on status.docnum = nfe.docnum
    left outer join j_1bnfdoc        as hd                         on hd.docnum = nfe.docnum
    left outer join vbrk             as vbrk                       on vbrk.vbeln = fluxo.vbeln

{
  key _OrdemFreteCross.tor_id                                                  as FreightOrder,
  key cast( right( _OrdemFreteCrossRedespacho.btd_id, 20 ) as /scmtms/tor_id ) as FreightOrderRed,
      cast( _OrdemFreteCross.db_key as /bobf/conf_key preserving type )        as FreightOrderId,
      cast( _OrdemFreteRedespacho.db_key as /bobf/conf_key preserving type )   as FreightOrderRedId,
      right( _Entrega.base_btd_id, 10 )                                        as remessa,
      fluxo.vbeln                                                              as fatura,
      nfe.docnum                                                               as docnum,
      status.code                                                              as status,
      concat( status.regio,
      concat( status.nfyear,
      concat( status.nfmonth,
      concat( status.stcd1,
      concat( status.model,
      concat( status.serie,
      concat( status.nfnum9,
      concat( status.docnum9, status.cdv ) ) ) ) ) ) ) )                       as nfe_key,
      hd.nftype                                                                as nftype,
      hd.nfenum                                                                as nfenum,
      hd.series                                                                as series,
      hd.docdat                                                                as docdat,
      hd.partyp                                                                as partyp,
      hd.branch                                                                as branch,
      hd.parid                                                                 as parid,
      hd.inco1                                                                 as inco1,
      _Entrega.parent_key                                                      as parent_key,
      _OrdemFreteRedespacho.tspid                                              as tspid

}
where
      _OrdemFreteCross.tor_id  is not initial
  and _OrdemFreteCross.tor_cat = 'TO' -- Ordem de frete
  and vbrk.fksto <> 'X'  -- Fatura estornada
  and vbrk.fkart <> 'S1' -- Tipo de documento diferente de estorno
group by
  _OrdemFreteCross.tor_id,
  _OrdemFreteCrossRedespacho.btd_id,
  _OrdemFreteCross.db_key,
  _OrdemFreteRedespacho.db_key,
  _Entrega.base_btd_id,
  fluxo.vbeln,
  nfe.docnum,
  status.code,
  status.regio,
  status.nfyear,
  status.nfmonth,
  status.stcd1,
  status.model,
  status.serie,
  status.nfnum9,
  status.docnum9,
  status.cdv,
  hd.nftype,
  hd.nfenum,
  hd.series,
  hd.docdat,
  hd.partyp,
  hd.branch,
  hd.parid,
  hd.inco1,
  _Entrega.parent_key,
  _OrdemFreteRedespacho.tspid
