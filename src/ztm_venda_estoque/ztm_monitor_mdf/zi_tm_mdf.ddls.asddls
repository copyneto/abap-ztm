@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_MDF
  as select from zttm_mdf as Header
  composition [0..*] of ZI_TM_MDF_COMPLEMENTO        as _Complemento
  composition [0..*] of ZI_TM_MDF_EMITENTE           as _Emitente
  composition [0..*] of ZI_TM_MDF_MUNICIPIO          as _Municipio
  composition [0..*] of ZI_TM_MDF_HISTORICO          as _Historico
  composition [0..*] of ZI_TM_MDF_MOTORISTA          as _Motorista
  composition [0..*] of ZI_TM_MDF_PLACA              as _Placa
  composition [0..*] of ZI_TM_MDF_PERCURSO_DOC       as _Percurso
  composition [0..*] of ZI_TM_MDF_CARREGAMENTO       as _Carregamento
  composition [0..*] of ZI_TM_MDF_DESCARREGAMENTO    as _Descarregamento

  association [0..1] to ZI_TM_MDF_TOTALS             as _Total           on  _Total.Guid = $projection.Guid
  association [0..1] to ZI_TM_MDF_COMPLEMENTO        as _HeaderComp      on  _HeaderComp.Id = $projection.Guid
  association [0..1] to ZI_TM_VH_MDFE_STATCODE       as _Status          on  _Status.StatusCode = $projection.StatusCode
  association [0..1] to ZI_CA_VH_COMPANY             as _Company         on  _Company.CompanyCode = $projection.CompanyCode
  association [0..1] to ZI_CA_VH_BRANCH              as _Branch          on  _Branch.CompanyCode   = $projection.CompanyCode
                                                                         and _Branch.BusinessPlace = $projection.BusinessPlace
  association [0..1] to ZI_CA_VH_FREIGHT_MODE        as _ModFrete        on  _ModFrete.FreightMode = $projection.ModFrete
  association [0..1] to ZI_CA_VH_REGIO_BR            as _UfInicio        on  _UfInicio.Region = $projection.UfInicio
  association [0..1] to ZI_CA_VH_DOMICILIO_FISCAL    as _DomFiscalInicio on  _DomFiscalInicio.Country = 'BR'
                                                                         and _DomFiscalInicio.Txjcd   = $projection.DomFiscalInicio
  association [0..1] to ZI_CA_VH_REGIO_BR            as _UfFim           on  _UfFim.Region = $projection.UfFim
  association [0..1] to ZI_CA_VH_DOMICILIO_FISCAL    as _DomFiscalFim    on  _DomFiscalFim.Country = 'BR'
                                                                         and _DomFiscalFim.Txjcd   = $projection.DomFiscalFim
  association [0..1] to ZI_CA_VH_VSTEL               as _LclExp          on  _LclExp.LocalExpedicao = $projection.LocalExpedicao
  association [0..1] to ZI_TM_MDF_PLACA              as _PlacaPrincipal  on  _PlacaPrincipal.Id      = $projection.Guid
                                                                         and _PlacaPrincipal.Reboque = ''

  association [0..1] to ZI_TM_MDF_HISTORICO_MSG_LAST as _UltimoHistorico on  _UltimoHistorico.Id = $projection.Guid

{
  key Header.id                                                                                                                             as Guid,
      Header.docnum                                                                                                                         as Agrupador,
      Header.manual                                                                                                                         as Manual,
      _HeaderComp.TpEmis                                                                                                                    as TipoEmissao,
      _HeaderComp._TpEmis.TpEmisText                                                                                                        as TipoEmissaoText,
      Header.mdfenum                                                                                                                        as BR_MDFeNumber,
      Header.series                                                                                                                         as BR_MDFeSeries,
      Header.statcod                                                                                                                        as StatusCode,

      case Header.statcod
      when ''  then 'Novo'
               else _Status.StatusText
      end                                                                                                                                   as StatusText,

      case Header.statcod
      when ''    then 0
      when '100' then 3
                 else 1
      end                                                                                                                                   as StatusCriticality,

      Header.nprot                                                                                                                          as Protocol,

      Header.access_key                                                                                                                     as AccessKey,

      case Header.manual
      when 'X' then 'Manual'
               else 'Automático'
      end                                                                                                                                   as BR_MDFeNumberStatus,

      case Header.manual
      when 'X' then 2
               else 3
      end                                                                                                                                   as BR_MDFeNumberStatusCriticality,

      Header.bukrs                                                                                                                          as CompanyCode,
      _Company.CompanyCodeName                                                                                                              as CompanyCodeName,
      Header.branch                                                                                                                         as BusinessPlace,
      _Branch.BusinessPlaceName                                                                                                             as BusinessPlaceName,
      Header.modfrete                                                                                                                       as ModFrete,
      _ModFrete.FreightModeName                                                                                                             as ModFreteText,

      case
      when Header.domfiscalini is not initial
      then Header.domfiscalini
      else _Total.Carga
      end                                                                                                                                   as DomFiscalInicio,
      _DomFiscalInicio,

      case
      when Header.domfiscalini is not initial
      then cast( substring( Header.domfiscalini, 1, 2) as regio )
      else cast( substring( _Total.Carga, 1, 2) as regio )
      end                                                                                                                                   as UfInicio,
      _UfInicio,

      case
      when Header.domfiscalfim is not initial
      then Header.domfiscalfim
      else _Total.Descarga
      end                                                                                                                                   as DomFiscalFim,
      _DomFiscalFim,

      case
      when Header.domfiscalfim is not initial
      then cast( substring( Header.domfiscalfim, 1, 2) as regio )
      else cast( substring( _Total.Descarga, 1, 2) as regio )
      end                                                                                                                                   as UfFim,
      _UfFim,

      Header.dtini                                                                                                                          as DataInicioViagem,
      Header.hrini                                                                                                                          as HoraInicioViagem,
      Header.vstel                                                                                                                          as LocalExpedicao,
      _LclExp.Text                                                                                                                          as LocalExpedicaoText,
      _PlacaPrincipal.Rntrc                                                                                                                 as Rntrc,
      _Total.QtdNfe                                                                                                                         as QtdNfe,
      _Total.QtdNfeWrt                                                                                                                      as QtdNfeWrt,
      _Total.QtdNfeExt                                                                                                                      as QtdNfeExt,
      @Semantics.amount.currencyCode:'Moeda'
      cast( _Total.VlrCarga as j_1bnftot )                                                                                                  as VlrCarga,
      _Total.Moeda                                                                                                                          as Moeda,
      Header.correcao                                                                                                                       as Correcao,

      case Header.correcao
      when 'X' then 3
               else 1
               end                                                                                                                          as CorrecaoCriticality,

      Header.inf_ad_fisco                                                                                                                   as InfoFisco,
      Header.inf_cpl                                                                                                                        as InfoContrib,
      _PlacaPrincipal.Placa                                                                                                                 as Placa,
      Header.ref_of                                                                                                                         as RefOf, -- Indica que MDF-e foi criado com referência a uma OF
      Header.dhrecbto                                                                                                                       as DataHoraRecebimento,
      Header.xmotivo                                                                                                                        as Motivo,
      Header.cstat                                                                                                                          as Cstat,
      _UltimoHistorico.Procstep,
      _UltimoHistorico.ProcessStepText,
      _UltimoHistorico.Stepstatus,
      _UltimoHistorico.StepStatusText,
      _UltimoHistorico.StepstatusCriticality,

      @Semantics.user.createdBy: true
      Header.created_by                                                                                                                     as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Header.created_at                                                                                                                     as CreatedAt,
      //      cast( substring( cast( created_at as abap.char(30) ), 1, 14 ) as abap.dats )             as CreatedDate,
      tstmp_to_dats( cast( created_at as timestamp ), abap_system_timezone( $session.client,'NULL' ), $session.client, 'NULL' )             as CreatedDate,
      @Semantics.user.lastChangedBy: true
      Header.last_changed_by                                                                                                                as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Header.last_changed_at                                                                                                                as LastChangedAt,
      //      cast( substring( cast( Header.last_changed_at as abap.char(30) ), 1, 8 ) as abap.dats )                                   as LastChangedDate,
      tstmp_to_dats( cast( Header.last_changed_at as timestamp ), abap_system_timezone( $session.client,'NULL' ), $session.client, 'NULL' ) as LastChangedDate,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Header.local_last_changed_at                                                                                                          as LocalLastChangedAt,

      /* Campos Abstract*/
      cast( '' as bu_partner )                                                                                                              as Motorista,
      cast( '' as /scmtms/tor_id )                                                                                                          as FreightOrder,

      /* compositions*/
      _Complemento,
      _Emitente,
      _Municipio,
      _Historico,
      _Motorista,
      _Placa,
      _Percurso,
      _Carregamento,
      _Descarregamento

}
