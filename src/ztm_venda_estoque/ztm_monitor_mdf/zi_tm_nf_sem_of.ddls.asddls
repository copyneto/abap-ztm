@AbapCatalog.sqlViewName: 'ZVTM_NF_SEM_OF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Listagem NF sem OF'

define view ZI_TM_NF_SEM_OF
  as select from    j_1bnfdoc           as NF

    left outer join j_1bnfe_active      as _Active    on _Active.docnum = NF.docnum

//    left outer join but000              as _Motorista on _Motorista.partner = NF.zzmotorista
    left outer join but000              as _Motorista on _Motorista.partner = NF.shpmrk

    left outer join ZI_TM_VH_MDF_NF_OF  as _NFOF      on _NFOF.BR_NotaFiscal = NF.docnum      -- Validar se NF sem OF

    left outer join ZI_TM_MDF_MUNICIPIO as _Municipio on _Municipio.BR_NotaFiscal = NF.docnum -- Validar se NF sem MDFe criada

{
  key NF.docnum                                      as BR_NotaFiscal,
      cast( '' as traid )                            as OrdemFrete,
      hextobin( '00000000000000000000000000000000' ) as Guid,
      concat_with_space( 'NF' , NF.docnum, 1)        as Titulo,

      cast( '0000000000' as j_1bdocnum )             as Agrupador,

      cast( '' as /xnfe/stepstat  )                  as Stepstatus,
      cast( '' as val_text )                         as StepStatusText,
      cast( 0 as abap.int1 )                         as StepstatusCriticality,

      cast( '' as /xnfe/statuscode )                 as StatusCode,
      cast( '' as /xnfe/description )                as StatusText,
      cast( 0 as abap.int1 )                         as StatusCriticality,
      cast( '' as ze_tm_mdfenum )                    as BR_MDFeNumber,
      cast( '' as j_1bseries )                       as Serie,
      NF.vstel                                       as LocalExpedicao,
      NF.traid                                       as Placa,
      cast( 1 as ze_qtd_nfe )                        as QtdNotas,

      case when NF.manual is not initial
           then cast( 1 as ze_qtd_nfe )
           else cast( 0 as ze_qtd_nfe ) end          as QtdWriter,

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
//      NF.zzmotorista                                 as Motorista,
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
where
      _NFOF.BR_NotaFiscal      is null        -- NF sem OF
  and _Municipio.BR_NotaFiscal is null        -- NF sem MDFe criada
  and NF.manual                = 'X'          -- Criado manualmente
  //  and NF.direct                = '2'            -- Saída
  and NF.cancel                = ''           -- Não cancelado
  and NF.docstat               = '1'          -- Autorizado
  and NF.shpmrk               is not initial -- Motorista preenchido
  and NF.traid                is not initial -- Placa preenchida
