@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_NOTA_FISCAL 
  as select from    j_1bnfdoc           as NF

    left outer join j_1bnfe_active      as _Active    on _Active.docnum = NF.docnum

//    left outer join but000              as _Motorista on _Motorista.partner = NF.zzmotorista
    left outer join but000              as _Motorista on _Motorista.partner = NF.shpmrk
{
  key NF.docnum                                      as BR_NotaFiscal,
      NF.vstel                                       as LocalExpedicao,
      NF.traid                                       as Placa,
      NF.conting                                     as Contingencia,
      NF.printd                                      as Impressa,
      _Active.regio                                  as Regiao,
      _Active.nfyear                                 as Ano,
      _Active.nfmonth                                as Mes,
      _Active.stcd1                                  as IDFiscal, -- Preenchido no código
      _Active.model                                  as Modelo,
      NF.credat                                      as DataCriacao,
      NF.authcod                                     as Log,
      concat( _Active.regio,
      concat( _Active.nfyear,
      concat( _Active.nfmonth,
      concat( _Active.stcd1,
      concat( _Active.model,
      concat( _Active.serie,
      concat( _Active.nfnum9,
      concat( _Active.docnum9,
      _Active.cdv ) ) ) ) ) ) ) )                    as ChaveAcesso,
      NF.shpmrk                                 as Motorista,

      case when _Motorista.name1_text is initial
           then concat_with_space( _Motorista.name_first,
                                   _Motorista.name_last, 1 )
           else _Motorista.name1_text
           end                                       as NomeMotorista,

      substring( NF.txjcd, 1, 3)                     as UfInicio,
      substring( NF.txjcd, 1, 3)                     as UfFim,
      cast( '3' as ze_type_sel_mdfe )                as TipoOperacao,
      NF.branch                                      as BusinessPlace,
      NF.bukrs                                       as Empresa
}
where NF.manual                = 'X'          -- Criado manualmente
  and NF.cancel                = ''           -- Não cancelado
  and NF.docstat               = '1'          -- Autorizado
