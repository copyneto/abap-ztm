@EndUserText.label: 'Projection Cockpit'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_TM_COCKPIT
  as projection on ZI_TM_COCKPIT001
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_ACCKEY', element: 'acckey' } }]
      @EndUserText.label: 'Chave de acesso'
  key acckey,
      @EndUserText.label: 'Tipo de documento'
      doctype,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'Empresa' } }]
      @EndUserText.label: 'Empresa'
      @ObjectModel.text.element: [ 'bukrs_txt']
      bukrs,
      bukrs_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      @EndUserText.label: 'Centro'
      @ObjectModel.text.element: [ 'werks_txt']
      werks,
      werks_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CENARIO', element: 'cenario' } }]
      @EndUserText.label: 'Cenário'
      @ObjectModel.text.element: [ 'cenario_txt']
      cenario,
      cenario_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CODSTATUS', element: 'codstatus' } }]
      @EndUserText.label: 'Status processamento'
      @ObjectModel.text.element: [ 'codstatus_txt']
      codstatus,
      codstatus_txt,
      codstatus_crit,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF remetente'
      @ObjectModel.text.element: [ 'rem_uf_txt']
      rem_uf,
      rem_uf_txt,
      @EndUserText.label: 'Município remetente'
      rem_mun,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF destinatário'
      @ObjectModel.text.element: [ 'dest_uf_txt']
      dest_uf,
      dest_uf_txt,
      @EndUserText.label: 'Município destinatário'
      dest_mun,
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_NFENUM', element: 'nfenum' } }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_NFNUM9_PREFNO', element: 'nfenum' } }]
      @EndUserText.label: 'Nº CT-e/NF-e'
      nfnum9,
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_PREFNO', element: 'prefno' } }]
      //      @EndUserText.label: 'Nº NFS-e'
      //      prefno,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_RE_BELNR', element: 'belnr' } }]
      @EndUserText.label: 'Nº Agrupamento Fatura'
      num_fatura,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_RE_BELNR', element: 'belnr' } }]
      @EndUserText.label: 'Fatura MIRO'
      SupplierInvoice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_GJAHR', element: 'CalendarYear' } }]
      @EndUserText.label: 'Ano Fiscal Faturamento'
      FiscalYear,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' } }]
      @EndUserText.label: 'Docnum MIRO'
      BR_NotaFiscal,
      @EndUserText.label: 'Data Vencimento Líquido'
      vct_gko,
      //      @EndUserText.label: 'Nome parceiro'
      //      first_name,
      @EndUserText.label: 'Contador histórico'
      counter,
      @EndUserText.label: 'Pago'
      pago,
      pago_criticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPDOC', element: 'tpdoc' } }]
      @EndUserText.label: 'Tipo Documento'
      @ObjectModel.text.element: [ 'tpdoc_txt']
      tpdoc,
      tpdoc_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DIRECT', element: 'Direct' } }]
      @EndUserText.label: 'Direção Mov. Mercadoria'
      @ObjectModel.text.element: [ 'direct_txt']
      direct,
      direct_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MODEL', element: 'model' } }]
      @EndUserText.label: 'Modelo NF'
      @ObjectModel.text.element: [ 'model_txt']
      model,
      model_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_PROD_ACABADO', element: 'prod_acabado' } }]
      @EndUserText.label: 'Produto Acabado'
      @ObjectModel.text.element: [ 'prod_acabado_desc']
      prod_acabado,
      prod_acabado_desc,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPRATEIO', element: 'tprateio' } }]
      @EndUserText.label: 'Tipo Rateio'
      @ObjectModel.text.element: [ 'rateio_txt']
      rateio,
      rateio_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CODEVENTO', element: 'codevento' } }]
      @EndUserText.label: 'Código do evento'
      @ObjectModel.text.element: [ 'codevento_txt']
      codevento,
      codevento_txt,
      @EndUserText.label: 'Registro'
      dhregevento,
      @EndUserText.label: 'Tipo de Evento'
      tpevento,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPCTE', element: 'tpcte' } }]
      @EndUserText.label: 'Tipo do CT-e'
      @ObjectModel.text.element: [ 'tpcte_txt']
      tpcte,
      //      tpcte_txt,
      _tpcte.tpcte_txt,
      @EndUserText.label: 'Código Status'
      @ObjectModel.text.element: [ 'xmotivo']
      cstat,
      xmotivo,
      @EndUserText.label: 'Valor total serviço'
      vtprest,
      @EndUserText.label: 'Valor a receber'
      vrec,
      @EndUserText.label: 'Base de cálculo ICMS'
      vbcicms,
      @EndUserText.label: 'Base de cálculo ISS'
      vbciss,
      @EndUserText.label: 'Alíquota ICMS'
      picms,
      @EndUserText.label: 'Alíquota ISS'
      piss,
      @EndUserText.label: 'Valor ICMS'
      vicms,
      @EndUserText.label: 'Valor ISS'
      viss,
      @EndUserText.label: 'Valor total da carga'
      vcarga,
      @EndUserText.label: 'Quantidade da carga'
      qcarga,
      @EndUserText.label: 'Séries'
      series,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CFOP', element: 'Cfop1' } }]
      @EndUserText.label: 'CFOP'
      cfop,
      @EndUserText.label: 'CFOP validado'
      cfop_ok,
      @EndUserText.label: 'Funrural'
      funrural,
      @EndUserText.label: 'Valor fiscal ISS'
      iss,
      @EndUserText.label: 'Moeda ISS'
      iss_curr,
      @EndUserText.label: 'Valor fiscal INSS'
      inss,
      @EndUserText.label: 'Moeda INSS'
      inss_curr,
      @EndUserText.label: 'Valor fiscal TRIO'
      trio,
      @EndUserText.label: 'Moeda TRIO'
      trio_curr,
      @EndUserText.label: 'Valor fiscal IRRF'
      irrf,
      @EndUserText.label: 'Moeda IRRF'
      irrf_curr,
      @EndUserText.label: 'Moeda'
      moeda,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Transportadora'
      emit_cod            as Driver,
      @EndUserText.label: 'Nome Transportadora'
      emit_cod_txt        as DriverName,
      @EndUserText.label: 'CNPJ/CPF Transportadora'
      emit_cnpj_cpf,
      @EndUserText.label: 'IE Transportadora'
      emit_ie,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF Transportadora'
      @ObjectModel.text.element: [ 'emit_uf_txt']
      emit_uf,
      emit_uf_txt,
      @EndUserText.label: 'Município Emitente'
      emit_mun,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Tomador'
      tom_cod             as Buyer,
      @EndUserText.label: 'Nome Tomador'
      tom_cod_txt         as BuyerName,
      @EndUserText.label: 'CNPJ/CPF Tomador'
      tom_cnpj_cpf,
      @EndUserText.label: 'IE Tomador'
      tom_ie,
      @EndUserText.label: 'Município Tomador'
      tom_mun,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF Tomador'
      @ObjectModel.text.element: [ 'tom_uf_txt']
      tom_uf,
      tom_uf_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Remetente'
      rem_cod             as Sender,
      @EndUserText.label: 'Nome Remetente'
      rem_cod_txt         as SenderName,
      @EndUserText.label: 'CNPJ/CPF Remetente'
      rem_cnpj_cpf,
      @EndUserText.label: 'IE Remetente'
      rem_ie,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Destinatário'
      dest_cod            as Consignee,
      @EndUserText.label: 'Nome Destinatário'
      dest_cod_txt        as ConsigneeName,
      @EndUserText.label: 'CNPJ/CPF Destinatário'
      dest_cnpj_cpf,
      @EndUserText.label: 'IE Destinatário'
      dest_ie,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Recebedor mercadoria'
      BusinessPartner     as Receiver,
      @EndUserText.label: 'Nome Parceiro de negócio'
      BusinessPartnerName as ReceiverName,
      
      @EndUserText.label: 'CNPJ/CPF Recebedor'
      receb_cnpj_cpf,
      @EndUserText.label: 'IE Recebedor'
      receb_ie,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF Recebedor'
      @ObjectModel.text.element: [ 'emit_uf_txt']
      receb_uf,
      receb_uf_txt,
      @EndUserText.label: 'Município Recebedor'
      receb_mun,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label: 'Expedidor'
      ShipperPartner      as Shipper,
      @EndUserText.label: 'Nome Expedidor'
      ShipperPartnerName  as ShipperName,
      
      @EndUserText.label: 'CNPJ/CPF Expedidor'
      exped_cnpj_cpf,
      @EndUserText.label: 'IE Expedidor'
      exped_ie,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF Expedidor'
      @ObjectModel.text.element: [ 'emit_uf_txt']
      exped_uf,
      exped_uf_txt,
      @EndUserText.label: 'Município Expedidor'
      exped_mun,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_VSTEL', element: 'LocalExpedicao' } }]
      @EndUserText.label: 'Local de expedição'
      @ObjectModel.text.element: [ 'vstel_txt']
      vstel,
      vstel_txt,
      @EndUserText.label: 'Anexo GNRE'
      possui_anexo_gnre,
      possui_anexo_gnre_crit,
      @EndUserText.label: 'Comprovante GNRE'
      possui_comprovante_gnre,
      possui_comprovante_gnre_crit,
      @EndUserText.label: 'Anexo NFS'
      possui_anexo_nfs,
      possui_anexo_nfs_crit,
      @EndUserText.label: 'Frete calculado'
      frete_calculado_gko,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } }]
      @EndUserText.label: 'Ordem de Frete'
      tor_id              as FreightOrder,
      @EndUserText.label: 'Doc. Faturamento Frete (DFF) '
      sfir_id,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_LIFECYCLE', element: 'lifecycle' } }]
      @EndUserText.label: 'Status DFF'
      @ObjectModel.text.element: [ 'lifecycle_txt']
      lifecycle,
      lifecycle_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_CONFIRMATION', element: 'confirmation' } }]
      @EndUserText.label: 'Status confirmação'
      @ObjectModel.text.element: [ 'confirmation_txt']
      confirmation,
      confirmation_txt,
      @EndUserText.label: 'Doc. Transação comercial (DTC)'
      btd_id,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LBLNI', element: 'lblni' } }]
      @EndUserText.label: 'Nº folha registro de serviços'
      lblni,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ACDOCA_BELNR', element: 'belnr' } }]
      @EndUserText.label: 'Nº Doc. Financeiro'
      belnr_fin,
      //      wbeln,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_SAKNR_PC3C', element: 'GLAccount' } }]
      @EndUserText.label: 'Conta razão'
      @ObjectModel.text.element: [ 'sakto_txt']
      sakto,
      sakto_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KOSTL', element: 'CentroCusto' } }]
      @EndUserText.label: 'Centro de custo'
      @ObjectModel.text.element: [ 'kostl_txt']
      kostl,
      kostl_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_USR_LIB', element: 'usr_lib' } }]
      @EndUserText.label: 'Usuário liberação'
      usr_lib,
      @EndUserText.label: 'Data faturamento'
      rbkp_budat,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label: 'Usuário'
      @ObjectModel.text.element: [ 'usnam_txt']
      usnam,
      usnam_txt,
      @EndUserText.label: 'Hora da entrada'
      cputm,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'Empresa' } }]
      @EndUserText.label: 'Empresa agrupamento'
      @ObjectModel.text.element: [ 'bukrs_doc_txt']
      bukrs_doc,
      bukrs_doc_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_BELNR', element: 'belnr' } }]
      @EndUserText.label: 'Documento contábil'
      belnr,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_GJAHR', element: 'CalendarYear' } }]
      @EndUserText.label: 'Ano contábil'
      gjahr,
      @EndUserText.label: 'Data de lançamento compensação'
      budat,
      @EndUserText.label: 'Data compensação'
      augdt,
      @EndUserText.label: 'Data de criação'
      credat,
      @EndUserText.label: 'Hora de criação'
      cretim,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label: 'Usuário criação'
      @ObjectModel.text.element: [ 'crenam_txt']
      crenam,
      crenam_txt,
      @EndUserText.label: 'Modificado em'
      chadat,
      @EndUserText.label: 'Modificado às'
      chatim,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label: 'Modificado por'
      @ObjectModel.text.element: [ 'chanam_txt']
      chanam,
      chanam_txt,
      @EndUserText.label: 'Desconto'
      desconto,
      @EndUserText.label: 'Valor PIS'
      pis,
      @EndUserText.label: 'Valor COFINS'
      cofins,
      @EndUserText.label: 'Frete Cotado FLUIG'
      frete_cotado_fluig,
      @EndUserText.label: 'Peso Bruto'
      gro_wei_val,
      @EndUserText.label: 'Unidade Peso Bruto'
      gro_wei_uni,
      @EndUserText.label: 'Autenticação Bancária'
      autenticacao_bancaria,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_tm_sh_motivo_rejeicao', element: 'not_code' } }]
      @EndUserText.label: 'Motivo rejeição'
      @ObjectModel.text.element: [ 'not_code_txt']
      not_code,
      _not_code.Text      as not_code_txt,
      @EndUserText.label: 'Local de negócios'
      @ObjectModel.text.element: [ 'branch_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' },
                                           additionalBinding: [{ localElement: 'bukrs', element: 'CompanyCode' }] }]
      branch,
      branch_txt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_SITUACAO', element: 'sitdoc' } }]
      @EndUserText.label: 'Situação'
      @ObjectModel.text.element: [ 'sitdoc_txt']
      sitdoc,
      sitdoc_txt,
      @EndUserText.label: 'Data emissão'
      dtemi,
      @EndUserText.label: 'Hora emissão'
      hremi,

      /* Campos para Botões */

      @Consumption.valueHelpDefinition: [ { entity:  { name: 'zi_tm_sh_motivo_rejeicao', element: 'not_code' } }]
      @EndUserText.label: 'Motivo da rejeição'
      motivoRejeicao,
      @EndUserText.label: 'Agrupamento'
      estornoAgrupamento,
      @EndUserText.label: 'Estorno MIRO'
      estornoMiro,
      @EndUserText.label: 'Estorno Doc. Fatura Frete'
      estornoPedido,

      @EndUserText.label: 'ID Doc. Faturamento Frete (DFF)'
      SuplrFrtInvcReqUUID,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_EBELN', element: 'ebeln' } }]
      @EndUserText.label: 'Pedido de compra'
      Pedido              as PurchaseOrder,
      @EndUserText.label: 'ID Ordem de frete'
      TransportationOrderUUID,
      @EndUserText.label: 'Último log'
      UltimoLog,

      /* Associations */

      _log : redirected to composition child zc_tm_cockpit_log

}
