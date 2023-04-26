@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dados para criação da MIRO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_GET_GKO_DOC_010
  as select from    ZI_TM_COCKPIT001 as _001

    left outer join eskn             as _Folha  on  _Folha.packno = _001.btd_id
                                                and _Folha.zekkn  = '01'

    left outer join zttm_pcockpit010 as _010_uf on  _010_uf.saknr  = _Folha.sakto
                                                and _010_uf.rem_uf = _001.rem_uf
                                                and _010_uf.rem_uf is not initial

    left outer join zttm_pcockpit010 as _010    on  _010.saknr  = _Folha.sakto
                                                and _010.rem_uf is initial
{
  key _001.acckey  as acckey,
      _Folha.sakto as sakto,

      max( case when _010_uf.mwskz is not null
           then _010_uf.mwskz
           when _010.mwskz is not null
           then _010.mwskz
           else cast( '' as mwskz )
           end )   as mwskz,

      max( case when _010_uf.nftype  is not null
           then _010_uf.nftype
           when _010.nftype is not null
           then _010.nftype
           else cast( '' as ze_j_1bnfetype  )
           end )   as nftype
}

group by
  _001.acckey,
  _Folha.sakto
