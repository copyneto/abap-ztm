@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados do Formulário (Virtual Elements)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_FORMULARIO_VE
  as select from ZI_TM_FORMULARIO_U_VE
{

  key acckey,
      chnfse,
      chcte,
      bukrs,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      natop,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfenum,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      serie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tp_oper,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      valor,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      lifnr,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      lifnr_name1,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      regio,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfyear,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nfmonth,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      stcd1,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      model,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tpemis,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      docnum8,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cdv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tpcte,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tpserv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tomador,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      inicio_prestsrv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      termino_prestsrv,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      modal,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      transportadora,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nome_transp,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      digest_value,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      nprot,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dhemi,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dtemi,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      hremi,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cstat,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      xmotivo,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_cnpj_cpf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      emit_ie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_cnpj_cpf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      rem_ie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_cnpj_cpf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      dest_ie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_nome,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_cnpj_cpf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_cep_bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_municipio_uf,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      tom_ie,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vtprest,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vrec,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cst,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      predbc,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vcred,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vbcicms,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      picms,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vicms,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vtottrib,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      vcarga,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      propred,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      xoutcat,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      xobs,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( viss as ze_gko_viss ) as viss,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_VE_FORMULARIO_CTE'
      cast( piss as ze_gko_piss ) as piss
}
