@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Listagem dos MDF-e Criados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_CRIADOS
  as select from    ZI_TM_MDF             as MDF

    left outer join ZI_TM_MDF_EMITENTE    as _Emitente      on _Emitente.id = MDF.Guid

    left outer join ZI_TM_MDF_COMPLEMENTO as _Complemento   on _Complemento.Id = MDF.Guid

    left outer join ZI_TM_MDF_PLACA       as _Placa         on  _Placa.Id      = MDF.Guid
                                                            and _Placa.Reboque = ''

    left outer join ZI_TM_MDF_MUNICIPIO   as _Municipio     on _Municipio.Guid = MDF.Guid

    left outer join I_BR_NFDocument       as _Doc           on _Doc.BR_NotaFiscal = _Municipio.BR_NotaFiscal

    left outer join ZI_TM_MDF_MOTORISTA   as _Motorista     on _Motorista.Id = MDF.Guid

    left outer join ZI_TM_VH_MOTORISTA    as _NomeMotorista on _NomeMotorista.Parceiro = _Motorista.Motorista

  association [0..1] to ZI_TM_MDF_HISTORICO_MSG_LAST as _UltimoHistorico on _UltimoHistorico.Id = $projection.Guid
{
  key _Municipio.BR_NotaFiscal                                  as BR_NotaFiscal,

  key case when lpad( right( _Municipio.FreightOrder, 10 ), 10, '0' ) <> '0000000000'
           then lpad( right( _Municipio.FreightOrder, 10 ), 10, '0' )
           else '          '  end                               as OrdemFrete,
  key MDF.Guid                                                  as Guid,

      case when lpad( right( _Municipio.FreightOrder, 10 ), 10, '0' ) <> '0000000000'
           then concat_with_space( 'OF' , right( _Municipio.FreightOrder, 10), 1)
      //           when _Municipio.BR_NotaFiscal is not initial
           when _Municipio.Manual is not initial
           then concat_with_space( 'NF' , _Municipio.BR_NotaFiscal, 1)
           else ''      end                                     as Titulo,

      MDF.Agrupador                                             as Agrupador,

      _UltimoHistorico.Stepstatus                               as Stepstatus,
      _UltimoHistorico.StepStatusText                           as StepStatusText,
      _UltimoHistorico.StepstatusCriticality                    as StepstatusCriticality,

      MDF.StatusCode                                            as StatusCode,
      MDF.StatusText                                            as StatusText,
      MDF.StatusCriticality                                     as StatusCriticality,
      MDF.BR_MDFeNumber                                         as BR_MDFeNumber,
      MDF.BR_MDFeSeries                                         as Serie,
      MDF.LocalExpedicao                                        as LocalExpedicao,
      _Placa.Placa                                              as Placa,
      MDF.QtdNfe                                                as QtdNotas,
      MDF.QtdNfeWrt                                             as QtdWriter,
      _Doc.BR_NFIsContingency                                   as Contingencia,
      _Doc.BR_NFIsPrinted                                       as Impressa,
      cast( '' as j_1bregio )                                   as Regiao,   -- Preenchido no código

      case when MDF.AccessKey is not initial
           then substring( MDF.AccessKey, 3, 2 )
           else substring( cast( MDF.CreatedAt as abap.char(30) ), 3, 2 )
           end                                                  as Ano,

      case when MDF.AccessKey is not initial
           then substring( MDF.AccessKey, 5, 2 )
           else substring( cast( MDF.CreatedAt as abap.char(30) ), 5, 2 )
           end                                                  as Mes,
      cast( '' as j_1bstcd1 )                                   as IDFiscal, -- Preenchido no código
      _Complemento.Mod                                          as Modelo,
      substring( cast( MDF.CreatedAt as abap.char(30) ), 1, 8 ) as DataCriacao,
      _Doc.BR_NFAuthznProtocolNumber                            as Log,
      MDF.AccessKey                                             as ChaveAcesso,
      MDF.UfInicio                                              as UfInicio,
      MDF.UfFim                                                 as UfFim,
      _Motorista.Motorista                                      as Motorista,
      _NomeMotorista.Nome                                       as NomeMotorista,
      cast( '2' as ze_type_sel_mdfe )                           as TipoOperacao,
      MDF.BusinessPlace                                         as BusinessPlace,
      MDF.CompanyCode                                           as Empresa,
      _Municipio.FreightOrder

}
where
     _Municipio.FreightOrder  is not initial
  or _Municipio.BR_NotaFiscal is not initial
  or _Municipio.BR_NFeNumber  is not initial
