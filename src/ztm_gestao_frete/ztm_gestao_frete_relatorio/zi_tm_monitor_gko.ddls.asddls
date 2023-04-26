@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes - Monitor GKO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_MONITOR_GKO
  as select from ZI_TM_FORMULARIO_U

  composition [0..*] of ZI_TM_MONITOR_GKO_REF       as _referencia
  composition [0..*] of ZI_TM_MONITOR_GKO_DOCGER    as _doc_gerado
  composition [0..*] of ZI_TM_MONITOR_GKO_EVENTO    as _evento
  composition [0..*] of ZI_TM_MONITOR_GKO_LOG       as _log

  association [0..*] to zc_tm_monitor_gko_cte_comp  as _cte_componente on _cte_componente.acckey = $projection.acckey
  association [0..*] to zc_tm_monitor_gko_cte_carga as _cte_carga      on _cte_carga.acckey = $projection.acckey

  association [0..1] to ZI_TM_VH_FRETE_CODSTATUS    as _codstatus      on _codstatus.codstatus = $projection.codstatus

{
  key acckey,
      chcte,
      chnfse,

      /* Campos para controle de exibição */

      case when chcte is initial
           then 'X'
           else ' ' end           as hiddenCTE,

      case when chnfse is initial
           then 'X'
           else ' ' end           as hiddenNFE,

      /* Campos informativos */

      case tpdoc
           when 'CTE'
           then 'CT-e'
           when 'NFE'
           then 'NF-e'
           when 'NFS'
           then 'NFS-e'
           else 'Não definido'
           end                    as tipo,

      case when chcte is not initial
           then 3
           when chnfse is not initial
           then 3
           else 1
           end                    as tipo_criticality,

      codstatus,
      _codstatus.codstatus_txt    as codstatus_txt,

      case when codstatus is not initial
           then concat_with_space( codstatus, concat_with_space( '-', _codstatus.codstatus_txt, 1 ), 1)
           else ''
      end                         as codstatus_label,


      case left( codstatus, 1 )
      when 'E' then 1
               else 0
      end                         as codstatus_criticality,

      /* Campos para controle de autorização */

      bukrs                       as bukrs,
      tpdoc                       as tpdoc,

      /* [CTE] Monitor GKO: Detalhes CT-e */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      chcte                       as c0_chcte,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast('' as boole_d)         as c0_xml_found,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( 0 as int4)            as c0_xml_found_criticality,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      natop                       as c0_natop,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfenum                      as c0_nfenum,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      serie                       as c0_serie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tp_oper                     as c0_tp_oper,

      case tp_oper
      when 'Entrada' then 3
      when 'Saída'   then 1
                     else 0 end   as c0_tp_oper_criticality,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      valor                       as c0_valor,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      lifnr                       as c0_lifnr,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      lifnr_name1                 as c0_lifnr_txt,

      /* [NFE] Monitor GKO: Detalhes NFS-e */

      chnfse                      as n0_chnfse,
      dtemi                       as n0_dtemiss,
      nfenum                      as n0_nfenum,
      serie                       as n0_serie,
      tp_oper                     as n0_tp_oper,

      case tp_oper
      when 'Entrada' then 3
      when 'Saída'   then 1
                     else 0 end   as n0_tp_oper_criticality,

      valor                       as n0_valor,
      lifnr                       as n0_lifnr,
      lifnr_name1                 as n0_lifnr_txt,

      /* [CTE] Síntese: Chave de acesso (SEFAZ) */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      regio                       as c1_regio,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfyear                      as c1_nfyear,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfmonth                     as c1_nfmonth,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      stcd1                       as c1_stcd1,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      case when length(stcd1) = 14  -- CNPJ
           then concat( substring( stcd1, 1, 2),
                concat( '.',
                concat( substring( stcd1, 3, 3),
                concat( '.',
                concat( substring( stcd1, 6, 3),
                concat( '/',
                concat( substring( stcd1, 9, 4),
                concat( '-',  substring( stcd1, 13, 2) ) ) ) ) ) ) ) )
           when length(stcd1) = 11  -- CPF
           then concat( substring( stcd1, 1, 3),
                concat( '.',
                concat( substring( stcd1, 4, 3),
                concat( '.',
                concat( substring( stcd1, 7, 3),
                concat( '/', substring( stcd1, 9, 2) ) ) ) ) ) )
           else stcd1 end         as c1_stcd1_txt,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      model                       as c1_model,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c1_model_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      serie                       as c1_serie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfenum                      as c1_nfenum,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tpemis                      as c1_tpemis,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c1_tpemis_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      docnum8                     as c1_docnum8,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cdv                         as c1_cdv,

      /* [CTE] Síntese: Protocolo */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      digest_value                as c1_digest_value,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nprot                       as c1_nprot,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dhemi                       as c1_dhemi,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cstat                       as c1_cstat,

      case cstat
      when '100' then 3
                 else 0 end       as c1_cstat_criticality,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      xmotivo                     as c1_xmotivo,

      /* [CTE] Síntese: CT-e */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tpcte                       as c1_tpcte,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c1_tpcte_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tpserv                      as c1_tpserv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c1_tpserv_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tomador                     as c1_tomador,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c1_tomador_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      inicio_prestsrv             as c1_inicio_prestsrv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      termino_prestsrv            as c1_termino_prestsrv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      modal                       as c1_modal,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c1_modal_txt,

      /* [CTE/NFE] Emitente */
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_cod                    as emit_cod,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_nome                   as emit_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_cnpj_cpf               as emit_cnpj_cpf,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as abap.char(20) ) as emit_cnpj_cpf_txt,
      //      case when length(emit_cnpj_cpf) = 14  -- CNPJ
      //           then concat( substring( emit_cnpj_cpf, 1, 2),
      //                concat( '.',
      //                concat( substring( emit_cnpj_cpf, 3, 3),
      //                concat( '.',
      //                concat( substring( emit_cnpj_cpf, 6, 3),
      //                concat( '/',
      //                concat( substring( emit_cnpj_cpf, 9, 4),
      //                concat( '-',  substring( emit_cnpj_cpf, 13, 2) ) ) ) ) ) ) ) )
      //           when length(emit_cnpj_cpf) = 11  -- CPF
      //           then concat( substring( emit_cnpj_cpf, 1, 3),
      //                concat( '.',
      //                concat( substring( emit_cnpj_cpf, 4, 3),
      //                concat( '.',
      //                concat( substring( emit_cnpj_cpf, 7, 3),
      //                concat( '/', substring( emit_cnpj_cpf, 9, 2) ) ) ) ) ) )
      //           else emit_cnpj_cpf end as emit_cnpj_cpf_txt,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_endereco               as emit_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_complemento            as emit_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_cep_bairro             as emit_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_municipio_uf           as emit_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_ie                     as emit_ie,

      /* [CTE/NFE] Remetente */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_cod                     as rem_cod,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_nome                    as rem_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_cnpj_cpf                as rem_cnpj_cpf,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as abap.char(20) ) as rem_cnpj_cpf_txt,
      //      case when length(rem_cnpj_cpf) = 14  -- CNPJ
      //           then concat( substring( rem_cnpj_cpf, 1, 2),
      //                concat( '.',
      //                concat( substring( rem_cnpj_cpf, 3, 3),
      //                concat( '.',
      //                concat( substring( rem_cnpj_cpf, 6, 3),
      //                concat( '/',
      //                concat( substring( rem_cnpj_cpf, 9, 4),
      //                concat( '-',  substring( rem_cnpj_cpf, 13, 2) ) ) ) ) ) ) ) )
      //           when length(rem_cnpj_cpf) = 11  -- CPF
      //           then concat( substring( rem_cnpj_cpf, 1, 3),
      //                concat( '.',
      //                concat( substring( rem_cnpj_cpf, 4, 3),
      //                concat( '.',
      //                concat( substring( rem_cnpj_cpf, 7, 3),
      //                concat( '/', substring( rem_cnpj_cpf, 9, 2) ) ) ) ) ) )
      //           else rem_cnpj_cpf end  as rem_cnpj_cpf_txt,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_endereco                as rem_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_complemento             as rem_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_cep_bairro              as rem_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_municipio_uf            as rem_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_ie                      as rem_ie,

      /* [CTE/NFE] Destinatário */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_cod                    as dest_cod,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_nome                   as dest_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_cnpj_cpf               as dest_cnpj_cpf,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as abap.char(20) ) as dest_cnpj_cpf_txt,
      //      case when length(dest_cnpj_cpf) = 14  -- CNPJ
      //           then concat( substring( dest_cnpj_cpf, 1, 2),
      //                concat( '.',
      //                concat( substring( dest_cnpj_cpf, 3, 3),
      //                concat( '.',
      //                concat( substring( dest_cnpj_cpf, 6, 3),
      //                concat( '/',
      //                concat( substring( dest_cnpj_cpf, 9, 4),
      //                concat( '-',  substring( dest_cnpj_cpf, 13, 2) ) ) ) ) ) ) ) )
      //           when length(dest_cnpj_cpf) = 11  -- CPF
      //           then concat( substring( dest_cnpj_cpf, 1, 3),
      //                concat( '.',
      //                concat( substring( dest_cnpj_cpf, 4, 3),
      //                concat( '.',
      //                concat( substring( dest_cnpj_cpf, 7, 3),
      //                concat( '/', substring( dest_cnpj_cpf, 9, 2) ) ) ) ) ) )
      //           else dest_cnpj_cpf end as dest_cnpj_cpf_txt,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_endereco               as dest_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_complemento            as dest_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_cep_bairro             as dest_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_municipio_uf           as dest_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_ie                     as dest_ie,

      /* [CTE/NFE] Tomador */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_cod                     as tom_cod,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_nome                    as tom_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_cnpj_cpf                as tom_cnpj_cpf,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as abap.char(20) ) as tom_cnpj_cpf_txt,
      //      case when length(tom_cnpj_cpf) = 14  -- CNPJ
      //           then concat( substring( tom_cnpj_cpf, 1, 2),
      //                concat( '.',
      //                concat( substring( tom_cnpj_cpf, 3, 3),
      //                concat( '.',
      //                concat( substring( tom_cnpj_cpf, 6, 3),
      //                concat( '/',
      //                concat( substring( tom_cnpj_cpf, 9, 4),
      //                concat( '-',  substring( tom_cnpj_cpf, 13, 2) ) ) ) ) ) ) ) )
      //           when length(tom_cnpj_cpf) = 11  -- CPF
      //           then concat( substring( tom_cnpj_cpf, 1, 3),
      //                concat( '.',
      //                concat( substring( tom_cnpj_cpf, 4, 3),
      //                concat( '.',
      //                concat( substring( tom_cnpj_cpf, 7, 3),
      //                concat( '/', substring( tom_cnpj_cpf, 9, 2) ) ) ) ) ) )
      //           else tom_cnpj_cpf end  as tom_cnpj_cpf_txt,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_endereco                as tom_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_complemento             as tom_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_cep_bairro              as tom_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_municipio_uf            as tom_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_ie                      as tom_ie,

      /* [CTE/NFE] Expedidor */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_cod                   as exped_cod,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_nome                  as exped_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_cnpj_cpf              as exped_cnpj_cpf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as abap.char(20) ) as exped_cnpj_cpf_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_endereco              as exped_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_complemento           as exped_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_cep_bairro            as exped_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_municipio_uf          as exped_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      exped_ie                    as exped_ie,

      /* [CTE/NFE] Recebedor */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_cod                   as receb_cod,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_nome                  as receb_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_cnpj_cpf              as receb_cnpj_cpf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as abap.char(20) ) as receb_cnpj_cpf_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_endereco              as receb_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_complemento           as receb_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_cep_bairro            as receb_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_municipio_uf          as receb_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      receb_ie                    as receb_ie,


      /* [NFE] Totais: Totais */

      vtprest                     as n5_vtpres,
      vrec                        as n5_vrec,

      /* [NFE] Totais: Impostos */

      viss                        as n5_viss,
      piss                        as n5_piss,

      /* [CTE] Totais: Totais */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vtprest                     as c6_vtpres,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vrec                        as c6_vrec,

      /* [CTE] Totais: Impostos  */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cst                         as c6_cst,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( '' as val_text )      as c6_cst_txt,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      predbc                      as c6_predbc,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vcred                       as c6_vcred,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vbcicms                     as c6_vbcicms,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      picms                       as c6_picms,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vicms                       as c6_vicms,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vtottrib                    as c6_vtottrib,

      /* [CTE] Totais: Componentes do Valor da Prestação do Serviço */

      _cte_componente,

      /* [CTE] Carga: Informações da Carga  */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vcarga                      as c7_vcarga,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      propred                     as c7_propred,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      xoutcat                     as c7_xoutcat,

      /* [CTE] Carga: Informações Adicionais */

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      xobs                        as c7_xobs,

      /* [CTE] Carga: Quantidade de Carga */

      _cte_carga,

      /* [CTE/NFE] Referências */

      _referencia,

      /* [CTE/NFE] Doc. Gerados */

      _doc_gerado,

      /* [CTE] Eventos */

      _evento,

      /* [CTE/NFE] Log */

      _log
}
