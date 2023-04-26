@EndUserText.label: 'Gestão de Fretes - Monitor GKO'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_TM_MONITOR_GKO
  as projection on ZI_TM_MONITOR_GKO
{
  key acckey,
      chcte,
      chnfse, 

      /* Campos para controle de exibição */

      hiddenCTE,
      hiddenNFE,

      /* Campos informativos */
      
      @EndUserText.label: 'Tipo documento'
      tipo,
      tipo_criticality,      
      
      @EndUserText.label: 'Status processamento'
      @ObjectModel.text.element: ['codstatus_txt']
      codstatus,
      codstatus_txt,
      codstatus_criticality,
      
      @EndUserText.label: 'Status processamento'
      codstatus_label,
      
      /* Campos para controle de autorização */

      @EndUserText.label: 'Empresa'
      bukrs,

      /* [CTE] Monitor GKO: Detalhes CT-e */

      @EndUserText.label: 'Chave de acesso' 
      c0_chcte,
      @EndUserText.label: 'XML Encontrado'
      c0_xml_found,
      c0_xml_found_criticality,
      @EndUserText.label: 'Natureza da Operação'
      c0_natop,
      @EndUserText.label: 'Nota Fiscal'
      c0_nfenum,
      @EndUserText.label: 'Série'
      c0_serie,
      @EndUserText.label: 'Tipo Operação'
      c0_tp_oper,
      c0_tp_oper_criticality,
      @EndUserText.label: 'Valor'
      c0_valor,
      @EndUserText.label: 'Fornecedor'
      @ObjectModel.text.element: ['c0_lifnr_txt']
      c0_lifnr,
      c0_lifnr_txt,

      /* [NFE] Monitor GKO: Detalhes NFS-e */

      @EndUserText.label: 'Chave de acesso'
      n0_chnfse,
      @EndUserText.label: 'Data de emissão'
      n0_dtemiss,
      @EndUserText.label: 'Nota Fiscal'
      n0_nfenum,
      @EndUserText.label: 'Série'
      n0_serie,
      @EndUserText.label: 'Tipo  Operação'
      n0_tp_oper,
      n0_tp_oper_criticality,
      @EndUserText.label: 'Valor'
      n0_valor,
      @EndUserText.label: 'Fornecedor'
      @ObjectModel.text.element: ['n0_lifnr_txt']
      n0_lifnr,
      n0_lifnr_txt,

      /* [CTE] Síntese: Chave de acesso (SEFAZ) */

      @EndUserText.label: 'Região'
      c1_regio,
      @EndUserText.label: 'Ano do documento'
      c1_nfyear,
      @EndUserText.label: 'Mês do documento'
      c1_nfmonth,
      @EndUserText.label: 'CNPJ/CPF'
      @ObjectModel.text.element: ['c1_stcd1_txt']
      c1_stcd1,
      c1_stcd1_txt,
      @EndUserText.label: 'Modelo NF'
      @ObjectModel.text.element: ['c1_model_txt']
      c1_model,
      c1_model_txt,
      @EndUserText.label: 'Séries'
      c1_serie,
      @EndUserText.label: 'Nº 9 posições'
      c1_nfenum,
      @EndUserText.label: 'Tipo de emissão'
      @ObjectModel.text.element: ['c1_tpemis_txt']
      c1_tpemis,
      c1_tpemis_txt,
      @EndUserText.label: 'Nº aleatório'
      c1_docnum8,
      @EndUserText.label: 'Dígito verificador'
      c1_cdv,

      /* [CTE] Síntese: Protocolo */

      @EndUserText.label: 'Digest value'
      c1_digest_value,
      @EndUserText.label: 'Número do protocolo'
      c1_nprot,
      @EndUserText.label: 'Data/hora de emissão'
      c1_dhemi,
      @EndUserText.label: 'Código do status'
      c1_cstat,
      c1_cstat_criticality,
      @EndUserText.label: 'Desc. status resp.'
      c1_xmotivo,

      /* [CTE] Síntese: CT-e */

      @EndUserText.label: 'Tipo do CT-e'
      @ObjectModel.text.element: ['c1_tpcte_txt']
      c1_tpcte,
      c1_tpcte_txt,
      @EndUserText.label: 'Tipo do serviço'
      @ObjectModel.text.element: ['c1_tpserv_txt']
      c1_tpserv,
      c1_tpserv_txt,
      @EndUserText.label: 'Tomador do serviço'
      @ObjectModel.text.element: ['c1_tomador_txt']
      c1_tomador,
      c1_tomador_txt,
      @EndUserText.label: 'Início da prestação'
      c1_inicio_prestsrv,
      @EndUserText.label: 'Término da prestação'
      c1_termino_prestsrv,
      @EndUserText.label: 'Modal'
      @ObjectModel.text.element: ['c1_modal_txt']
      c1_modal,
      c1_modal_txt,

      /* [CTE/NFE] Emitente */

      @EndUserText.label: 'Parceiro'
      emit_cod,
      @EndUserText.label: 'Nome'
      emit_nome,
      @EndUserText.label: 'CNPJ / CPF'
      @ObjectModel.text.element: ['emit_cnpj_cpf_txt']
      emit_cnpj_cpf,
      emit_cnpj_cpf_txt,
      @EndUserText.label: 'Endereço'
      emit_endereco,
      @EndUserText.label: 'Complemento'
      emit_complemento,
      @EndUserText.label: 'CEP / Bairro'
      emit_cep_bairro,
      @EndUserText.label: 'Município / UF'
      emit_municipio_uf,
      @EndUserText.label: 'Inscrição Estadual'
      emit_ie,

      /* [CTE/NFE] Remetente */

      @EndUserText.label: 'Parceiro'
      rem_cod,
      @EndUserText.label: 'Nome'
      rem_nome,
      @EndUserText.label: 'CNPJ / CPF'
      @ObjectModel.text.element: ['rem_cnpj_cpf_txt']
      rem_cnpj_cpf,
      rem_cnpj_cpf_txt,
      @EndUserText.label: 'Endereço'
      rem_endereco,
      @EndUserText.label: 'Complemento'
      rem_complemento,
      @EndUserText.label: 'CEP / Bairro'
      rem_cep_bairro,
      @EndUserText.label: 'Município / UF'
      rem_municipio_uf,
      @EndUserText.label: 'Inscrição Estadual'
      rem_ie,

      /* [CTE/NFE] Destinatário */

      @EndUserText.label: 'Parceiro'
      dest_cod,
      @EndUserText.label: 'Nome'
      dest_nome,
      @EndUserText.label: 'CNPJ / CPF'
      @ObjectModel.text.element: ['dest_cnpj_cpf_txt']
      dest_cnpj_cpf,
      dest_cnpj_cpf_txt,
      @EndUserText.label: 'Endereço'
      dest_endereco,
      @EndUserText.label: 'Complemento'
      dest_complemento,
      @EndUserText.label: 'CEP / Bairro'
      dest_cep_bairro,
      @EndUserText.label: 'Município / UF'
      dest_municipio_uf,
      @EndUserText.label: 'Inscrição Estadual'
      dest_ie,

      /* [CTE/NFE] Tomador */

      @EndUserText.label: 'Parceiro'
      tom_cod,
      @EndUserText.label: 'Nome'
      tom_nome,
      @EndUserText.label: 'CNPJ / CPF'
      @ObjectModel.text.element: ['tom_cnpj_cpf_txt']
      tom_cnpj_cpf,
      tom_cnpj_cpf_txt,
      @EndUserText.label: 'Endereço'
      tom_endereco,
      @EndUserText.label: 'Complemento'
      tom_complemento,
      @EndUserText.label: 'CEP / Bairro'
      tom_cep_bairro,
      @EndUserText.label: 'Município / UF'
      tom_municipio_uf,
      @EndUserText.label: 'Inscrição Estadual'
      tom_ie,

      /* [CTE/NFE] Expedidor */

      @EndUserText.label: 'Parceiro'
      exped_cod,
      @EndUserText.label: 'Nome'
      exped_nome,
      @EndUserText.label: 'CNPJ / CPF'
      @ObjectModel.text.element: ['exped_cnpj_cpf_txt']
      exped_cnpj_cpf,
      exped_cnpj_cpf_txt,
      @EndUserText.label: 'Endereço'
      exped_endereco,
      @EndUserText.label: 'Complemento'
      exped_complemento,
      @EndUserText.label: 'CEP / Bairro'
      exped_cep_bairro,
      @EndUserText.label: 'Município / UF'
      exped_municipio_uf,
      @EndUserText.label: 'Inscrição Estadual'
      exped_ie,

      /* [CTE/NFE] Recebedor */

      @EndUserText.label: 'Parceiro'
      receb_cod,
      @EndUserText.label: 'Nome'
      receb_nome,
      @EndUserText.label: 'CNPJ / CPF'
      @ObjectModel.text.element: ['receb_cnpj_cpf_txt']
      receb_cnpj_cpf,
      receb_cnpj_cpf_txt,
      @EndUserText.label: 'Endereço'
      receb_endereco,
      @EndUserText.label: 'Complemento'
      receb_complemento,
      @EndUserText.label: 'CEP / Bairro'
      receb_cep_bairro,
      @EndUserText.label: 'Município / UF'
      receb_municipio_uf,
      @EndUserText.label: 'Inscrição Estadual'
      receb_ie,

      /* [NFE] Totais: Totais */

      @EndUserText.label: 'Valor total serviço'
      n5_vtpres,
      @EndUserText.label: 'Valor a receber'
      n5_vrec,

      /* [NFE] Totais: Impostos */

      @EndUserText.label: 'Valor ISS'
      n5_viss,
      @EndUserText.label: 'Alíquota ISS'
      n5_piss,

      /* [CTE] Totais: Totais */

      @EndUserText.label: 'Valor total do serviço'
      c6_vtpres,
      @EndUserText.label: 'Valor a receber'
      c6_vrec,

      /* [CTE] Totais: Impostos  */

      @EndUserText.label: 'CST'
      @ObjectModel.text.element: ['c6_cst_txt']
      c6_cst,
      c6_cst_txt,
      @EndUserText.label: 'Perc. Red. da BC'
      c6_predbc,
      @EndUserText.label: 'Valor do crédito'
      c6_vcred,
      @EndUserText.label: 'Base de cáculo ICMS'
      c6_vbcicms,
      @EndUserText.label: 'Alíquota ICMS'
      c6_picms,
      @EndUserText.label: 'Valor ICMS'
      c6_vicms,
      @EndUserText.label: 'Valor Total dos Tributos'
      c6_vtottrib,

      /* [CTE] Totais: Componentes do Valor da Prestação do Serviço */

      _cte_componente,

      /* [CTE] Carga: Informações da Carga  */

      @EndUserText.label: 'Valor total da carga'
      c7_vcarga,
      @EndUserText.label: 'Produto predominante'
      c7_propred,
      @EndUserText.label: 'Outras caract. carga'
      c7_xoutcat,

      /* [CTE] Carga: Informações Adicionais */

      @EndUserText.label: 'Informações Adicionais'
      c7_xobs,

      /* [CTE] Carga: Quantidade de Carga */

      _cte_carga,

      /* [CTE/NFE] Referências */

      _referencia : redirected to composition child ZC_TM_MONITOR_GKO_REF,

      /* [CTE/NFE] Doc. Gerados */

      _doc_gerado : redirected to composition child ZC_TM_MONITOR_GKO_DOCGER,

      /* [CTE] Eventos */

      _evento     : redirected to composition child ZC_TM_MONITOR_GKO_EVENTO,

      /* [CTE/NFE] Log */

      _log        : redirected to composition child ZC_TM_MONITOR_GKO_LOG

}
