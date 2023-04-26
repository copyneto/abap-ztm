@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Alteração Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_MDF_MOTORISTA_CHANGE
  as select from j_1bnfdoc
  composition [0..*] of ZI_TM_MDF_HIST_MOTORISTA as _Historico
  association [0..1] to ZI_CA_VH_PARTNER_PF      as _PF     on  _PF.Parceiro = $projection.Motorista
  association [0..1] to ZI_CA_VH_BRANCH          as _Branch on  _Branch.BusinessPlace = $projection.LocalNegocio
                                                            and _Branch.CompanyCode   = $projection.CompanyCode

  association [0..1] to j_1bnfe_active           as _Active on  _Active.docnum = $projection.Docnum
{
  key docnum                                               as Docnum,

      concat( _Active.regio,
      concat( _Active.nfyear,
      concat( _Active.nfmonth,
      concat( _Active.stcd1,
      concat( _Active.model,
      concat( _Active.serie,
      concat( _Active.nfnum9,
      concat( _Active.docnum9, _Active.cdv ) ) ) ) ) ) ) ) as AccessKey,

      pstdat                                               as DataLancamento,
      crenam                                               as CriadoPor,
      vstel                                                as LocalNegocio,
      case
       when _Branch.BusinessPlaceName = ''
        then 'Not Available'
       else _Branch.BusinessPlaceName
      end                                                  as BusinessPlaceName,
      bukrs                                                as CompanyCode,
      case when nfenum is not initial
                then nfenum
                else nfnum end                             as NumeroNota,
      @EndUserText.label: 'Placa'
      //            zzplaca                  as Placa,
      cast( traid as equnr )                               as Placa,
      @EndUserText.label: 'Motorista'
      //      zzmotorista              as Motorista,
      cast( shpmrk as bu_partner )                         as Motorista,
      //      _PF.Nome                     as MotoristaNome,

      docnum                                               as BR_NotaFiscal,


      _PF,
      _Historico,
      _Branch
}
where
      manual  = 'X' -- Criado manualmente
  and cancel  = ''  -- Não cancelado
  and docstat = '1' -- Autorizado
