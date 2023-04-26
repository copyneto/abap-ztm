@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados do formulário CTE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
 serviceQuality: #X,
 sizeCategory: #S,
 dataClass: #MIXED
}
define view entity ZI_TM_FORMULARIO_CTE
  as select from zttm_gkot001 as z001
    left outer join   zttm_gkot002 as z002 on  z002.acckey      = z001.acckey
                                      and z002.attach_type = '1' -- XML

{
  key z001.acckey                      as acckey,
      z002.attach_type                 as attach_type,
      z002.attach_content              as attach_content,
      z001.codstatus                   as codstatus,
      
      z001.bukrs                       as bukrs,
      z001.tpdoc                       as tpdoc, 
      
      z001.acckey                      as chcte,

      cast ( '' as abap.char( 60 ) )   as natop,
      cast ( '' as abap.char( 9 ) )    as nfenum,
      cast ( '' as abap.char( 3 ) )    as serie,
      cast ( '' as abap.char( 15 ) )   as tp_oper,
      cast ( 0 as abap.dec ( 15, 2 ) ) as valor,
      cast ( '' as abap.char( 10 ) )   as lifnr,
      cast ( '' as abap.char( 80 ) )   as lifnr_name1,
      cast ( '' as abap.char( 2 ) )    as regio,
      cast ( '' as abap.char( 2 ) )    as nfyear,
      cast ( '' as abap.char( 2 ) )    as nfmonth,
      cast ( '' as abap.char( 14 ) )   as stcd1,
      cast ( '' as j_1bmodel )         as model,
      cast ( '' as j_1bnfe_tpemis )    as tpemis,
      cast ( '' as abap.char( 8 ) )    as docnum8,
      cast ( '' as abap.char( 1 ) )    as cdv,
      cast ( '' as ze_gko_tpcte )      as tpcte,
      cast ( '' as ze_gko_tpserv )     as tpserv,
      cast ( '' as ze_gko_tomador )    as tomador,
      cast ( '' as abap.char( 65 ) )   as inicio_prestsrv,
      cast ( '' as abap.char( 65 ) )   as termino_prestsrv,
      cast ( '' as ze_gko_modal )      as modal,
      cast ( '' as abap.char( 60 ) )   as transportadora,
      cast ( '' as abap.char( 60 ) )   as nome_transp,
      cast ( '' as abap.char( 64 ) )   as digest_value,
      cast ( '' as abap.char( 15 ) )   as nprot,
      cast ( '' as abap.char( 25 ) )   as dhemi,
      cast ( '00000000' as abap.dats ) as dtemi,
      cast ( '000000' as abap.tims )   as hremi,
      cast ( '' as abap.numc( 3 ) )    as cstat,
      cast ( '' as abap.char( 255 ) )  as xmotivo,
      
      cast ( '' as abap.char( 10 ) )   as emit_cod,
      cast ( '' as abap.char( 60 ) )   as emit_nome,
      cast ( '' as abap.char( 14 ) )   as emit_cnpj_cpf,
      cast ( '' as abap.char( 120 ) )  as emit_endereco,
      cast ( '' as abap.char( 60 ) )   as emit_complemento,
      cast ( '' as abap.char( 70 ) )   as emit_cep_bairro,
      cast ( '' as abap.char( 65 ) )   as emit_municipio_uf,
      cast ( '' as j_1bstains )        as emit_ie,
      
      cast ( '' as abap.char( 10 ) )   as rem_cod,
      cast ( '' as abap.char( 60 ) )   as rem_nome,
      cast ( '' as abap.char( 14 ) )   as rem_cnpj_cpf,
      cast ( '' as abap.char( 120 ) )  as rem_endereco,
      cast ( '' as abap.char( 60 ) )   as rem_complemento,
      cast ( '' as abap.char( 70 ) )   as rem_cep_bairro,
      cast ( '' as abap.char( 65 ) )   as rem_municipio_uf,
      cast ( '' as j_1bstains )        as rem_ie,
      
      cast ( '' as abap.char( 10 ) )   as dest_cod,
      cast ( '' as abap.char( 60 ) )   as dest_nome,
      cast ( '' as abap.char( 14 ) )   as dest_cnpj_cpf,
      cast ( '' as abap.char( 120 ) )  as dest_endereco,
      cast ( '' as abap.char( 60 ) )   as dest_complemento,
      cast ( '' as abap.char( 70 ) )   as dest_cep_bairro,
      cast ( '' as abap.char( 65 ) )   as dest_municipio_uf,
      cast ( '' as j_1bstains )        as dest_ie,
      
      cast ( '' as abap.char( 10 ) )   as tom_cod,
      cast ( '' as abap.char( 60 ) )   as tom_nome,
      cast ( '' as abap.char( 14 ) )   as tom_cnpj_cpf,
      cast ( '' as abap.char( 120 ) )  as tom_endereco,
      cast ( '' as abap.char( 60 ) )   as tom_complemento,
      cast ( '' as abap.char( 70 ) )   as tom_cep_bairro,
      cast ( '' as abap.char( 65 ) )   as tom_municipio_uf,
      cast ( '' as j_1bstains )        as tom_ie,
      
      cast ( '' as abap.char( 10 ) )   as exped_cod,
      cast ( '' as abap.char( 60 ) )   as exped_nome,
      cast ( '' as abap.char( 14 ) )   as exped_cnpj_cpf,
      cast ( '' as abap.char( 120 ) )  as exped_endereco,
      cast ( '' as abap.char( 60 ) )   as exped_complemento,
      cast ( '' as abap.char( 70 ) )   as exped_cep_bairro,
      cast ( '' as abap.char( 65 ) )   as exped_municipio_uf,
      cast ( '' as j_1bstains )        as exped_ie,
      
      cast ( '' as abap.char( 10 ) )   as receb_cod,
      cast ( '' as abap.char( 60 ) )   as receb_nome,
      cast ( '' as abap.char( 14 ) )   as receb_cnpj_cpf,
      cast ( '' as abap.char( 120 ) )  as receb_endereco,
      cast ( '' as abap.char( 60 ) )   as receb_complemento,
      cast ( '' as abap.char( 70 ) )   as receb_cep_bairro,
      cast ( '' as abap.char( 65 ) )   as receb_municipio_uf,
      cast ( '' as j_1bstains )        as receb_ie,
      
      cast ( 0 as abap.dec ( 15,2 ) )  as vtprest,
      cast ( 0 as abap.dec ( 15,2 ) )  as vrec,
      cast ( '' as ze_gko_cst )        as cst,
      cast ( 0 as abap.dec ( 5,2 ) )   as predbc,
      cast ( 0 as abap.dec ( 15,2 ) )  as vcred,
      cast ( 0 as abap.dec ( 15,2 ) )  as vbcicms,
      cast ( 0 as abap.dec ( 5,2 ) )   as picms,
      cast ( 0 as abap.dec ( 15,2 ) )  as vicms,
      cast ( 0 as abap.dec ( 15,2 ) )  as vtottrib,
      cast ( 0 as abap.dec ( 15,2 ) )  as vcarga,
      cast ( '' as abap.char( 60 ) )   as propred,
      cast ( '' as abap.char( 30 ) )   as xoutcat,
      cast ( '' as abap.char( 300 ) )  as xobs

}
where
  z001.tpdoc = 'CTE'
