@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados do formulário NFE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_FORMULARIO_NFE
  as select from    zttm_gkot001   as z001

    left outer join ZI_CA_VH_LIFNR as lfa1 on lfa1.LifnrCode = z001.emit_cod
    left outer join zttm_gkot004   as z004 on z004.acckey = z001.acckey

{
  key z001.acckey                                                  as acckey,
      z001.acckey                                                  as chnfse,
      z001.codstatus                                               as codstatus,

      z001.bukrs                                                   as bukrs,
      z001.tpdoc                                                   as tpdoc,

      case when z001.prefno is not initial
           then z001.prefno
           else cast( z001.nfnum9 as j_1bprefno )
           end                                                     as nfenum,
      cast ( '' as abap.char( 3 ) )                                as serie,
      cast ( 'Entrada' as abap.char( 15 ) )                        as tp_oper,
      z001.vtprest                                                 as valor,
      z001.emit_cod                                                as lifnr,
      lfa1.LifnrCodeName                                           as lifnr_name1,
      z001.dtemi                                                   as dtemi,
      z001.emit_cod                                                as emit_cod,
      z004.emit_nome                                               as emit_nome,
      z001.emit_cnpj_cpf                                           as emit_cnpj_cpf,
      concat( z004.emit_lgr, concat( ', ', z004.emit_nro ) )       as emit_endereco,
      z004.emit_cpl                                                as emit_complemento,
      concat( z004.emit_cep, concat( ' / ', z004.emit_bairro ) )   as emit_cep_bairro,
      concat( z004.emit_mun, concat( ' / ', z001.emit_uf ) )       as emit_municipio_uf,
      z001.emit_ie                                                 as emit_ie,
      z001.rem_cod                                                 as rem_cod,
      z004.rem_nome                                                as rem_nome,
      z001.rem_cnpj_cpf                                            as rem_cnpj_cpf,
      concat( z004.rem_lgr, concat( ', ', z004.rem_nro ) )         as rem_endereco,
      z004.rem_cpl                                                 as rem_complemento,
      concat( z004.rem_cep, concat( ' / ', z004.rem_bairro ) )     as rem_cep_bairro,
      concat( z004.rem_mun, concat( ' / ', z001.rem_uf ) )         as rem_municipio_uf,
      z001.rem_ie                                                  as rem_ie,
      z001.dest_cod                                                as dest_cod,
      z004.dest_nome                                               as dest_nome,

      case when z001.dest_cnpj is not initial
           then cast ( z001.dest_cnpj as abap.char( 14 ) )
           when z001.dest_cpf is not initial
           then cast ( z001.dest_cpf as abap.char( 14 ) )
           else cast ( '' as abap.char( 14 ) )  end                as dest_cnpj_cpf,

      concat( z004.dest_lgr, concat( ', ', z004.dest_nro ) )       as dest_endereco,
      z004.dest_cpl                                                as dest_complemento,
      concat( z004.dest_cep, concat( ' / ', z004.dest_bairro ) )   as dest_cep_bairro,
      concat( z004.dest_mun, concat( ' / ', z001.dest_uf ) )       as dest_municipio_uf,
      z001.dest_ie                                                 as dest_ie,

      z001.tom_cod                                                 as tom_cod,
      z004.tom_nome                                                as tom_nome,
      z001.tom_cnpj_cpf                                            as tom_cnpj_cpf,
      concat( z004.tom_lgr, concat( ', ', z004.tom_nro ) )         as tom_endereco,
      z004.tom_cpl                                                 as tom_complemento,
      concat( z004.tom_cep, concat( ' / ', z004.tom_bairro ) )     as tom_cep_bairro,
      concat( z004.tom_mun, concat( ' / ', z001.tom_uf ) )         as tom_municipio_uf,
      z001.tom_ie                                                  as tom_ie,

      z001.exped_cod                                               as exped_cod,
      z004.exped_nome                                              as exped_nome,
      case when z001.exped_cnpj is not initial
           then cast ( z001.exped_cnpj as abap.char( 14 ) )
           when z001.exped_cpf is not initial
           then cast ( z001.exped_cpf as abap.char( 14 ) )
           else cast ( '' as abap.char( 14 ) )  end                as exped_cnpj_cpf,
      concat( z004.exped_lgr, concat( ', ', z004.exped_nro ) )     as exped_endereco,
      z004.exped_cpl                                               as exped_complemento,
      concat( z004.exped_cep, concat( ' / ', z004.exped_bairro ) ) as exped_cep_bairro,
      concat( z004.exped_mun, concat( ' / ', z001.exped_uf ) )     as exped_municipio_uf,
      z001.exped_ie                                                as exped_ie,

      z001.receb_cod                                               as receb_cod,
      z004.receb_nome                                              as receb_nome,
      case when z001.receb_cnpj is not initial
           then cast ( z001.receb_cnpj as abap.char( 14 ) )
           when z001.receb_cpf is not initial
           then cast ( z001.receb_cpf as abap.char( 14 ) )
           else cast ( '' as abap.char( 14 ) )  end                as receb_cnpj_cpf,
      concat( z004.receb_lgr, concat( ', ', z004.receb_nro ) )     as receb_endereco,
      z004.receb_cpl                                               as receb_complemento,
      concat( z004.receb_cep, concat( ' / ', z004.receb_bairro ) ) as receb_cep_bairro,
      concat( z004.receb_mun, concat( ' / ', z001.receb_uf ) )     as receb_municipio_uf,
      z001.receb_ie                                                as receb_ie,

      z001.vtprest                                                 as vtprest,
      z001.vrec                                                    as vrec,
      z001.viss                                                    as viss,
      z001.piss                                                    as piss
}
where
     z001.tpdoc = 'NFE'
  or z001.tpdoc = 'NFS'
