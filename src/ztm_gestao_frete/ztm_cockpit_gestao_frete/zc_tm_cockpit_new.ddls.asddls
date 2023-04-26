@EndUserText.label: 'Cockpit de Frete'
@UI.headerInfo.typeName: 'Cockpit de Frete'
@UI.headerInfo.typeNamePlural: 'Cockpit de Frete'
@UI.headerInfo.title.type: #STANDARD
@UI.headerInfo.title.value: 'acckey'
@Metadata.allowExtensions: true
@ObjectModel:  { query.implementedBy: 'ABAP:ZCLTM_COCKPIT_FRETE_NEW_CE' }

@UI.lineItem: [{criticality: 'codstatus_crit'}]

define root custom entity ZC_TM_COCKPIT_NEW
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------

      @UI.facet                    : [
        { label                    : 'Informações Gerais',
          id                       : 'GeneralInfo',
          type                     : #COLLECTION,
          position                 : 10 },

        { label                    : 'Geral',
          purpose                  : #STANDARD,
          position                 :  10,
          type                     : #IDENTIFICATION_REFERENCE,
          parentId                 : 'GeneralInfo' },

        { label                    : 'Dados',
          purpose                  : #STANDARD,
          position                 : 30,
          type                     : #FIELDGROUP_REFERENCE,
          parentId                 : 'GeneralInfo',
          targetQualifier          : 'DatesGroup' },

        { id                       : 'Log',
          label                    : 'Log',
          purpose                  : #STANDARD,
          position                 : 20,
          type                     : #LINEITEM_REFERENCE,
          targetElement            : '_log' }
      ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_ACCKEY', element: 'acckey' } }]
      @EndUserText.label           : 'Chave de acesso'
      @UI.lineItem                 : [{ position: 10, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 40 }]
      @Consumption.semanticObject  : 'ZZ1_MONITOR_GKO'
  key acckey                       : j_1b_nfe_access_key_dtel44;

      @UI.hidden                   : true
      @EndUserText.label           : 'Tipo de documento'
      doctype                      : /xnfe/doctype;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CODSTATUS', element: 'codstatus' } }]
      @EndUserText.label           : 'Status processamento'
      @ObjectModel.text.element    : ['codstatus_txt']
      @UI.fieldGroup               : [{ position: 40, qualifier: 'DatesGroup' }]
      @UI.lineItem                 : [{ position: 20 }]
      @UI.selectionField           : [{ position: 20 }]
      codstatus                    : ze_gko_codstatus;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Status processamento'
      codstatus_txt                : val_text;

      @UI.hidden                   : true
      codstatus_crit               : abap.int1;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'Empresa' } }]
      @EndUserText.label           : 'Empresa'
      @ObjectModel.text.element    : ['bukrs_txt']
      @UI.lineItem                 : [{ position: 30 }]
      @UI.selectionField           : [{ position: 30 }]
      @UI.fieldGroup               : [{ position: 10, qualifier: 'DatesGroup' }]
      bukrs                        : bukrs;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Empresa'
      bukrs_txt                    : butxt;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      @EndUserText.label           : 'Centro'
      @ObjectModel.text.element    : ['werks_txt']
      @UI.lineItem                 : [{ position: 40 }]
      @UI.fieldGroup               : [{ qualifier: 'DatesGroup', position: 15 }]
      werks                        : werks_d;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Centro'
      werks_txt                    : name1;

      @EndUserText.label           : 'Local de negócios'
      @ObjectModel.text.element    : ['branch_txt']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' },
                                           additionalBinding: [{ localElement: 'bukrs', element: 'CompanyCode' }] }]
      @UI.lineItem                 : [{ position: 50 }]
      @UI.selectionField           : [{ position: 30 }]
      @UI.fieldGroup               : [{ qualifier: 'DatesGroup', position: 20 }]
      branch                       : j_1bbranc_;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Local de negócios'
      branch_txt                   : name1;

      @EndUserText.label           : 'Data Integração'
      @UI.lineItem                 : [{ position: 60 }]
      @UI.selectionField           : [{ position: 60 }]
      @UI.fieldGroup               : [{ qualifier: 'DatesGroup', position: 30 }]
      @Consumption.filter.selectionType: #INTERVAL
      credat                       : j_1bcredat;

      @EndUserText.label           : 'Hora Integração'
      @Consumption.filter.selectionType: #INTERVAL
      cretim                       : j_1bcretim;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CENARIO', element: 'cenario' } }]
      @EndUserText.label           : 'Cenário'
      @ObjectModel.text.element    : ['cenario_txt']
      @UI.lineItem                 : [{ position: 70 }]
      @UI.selectionField           : [{ position: 70 }]
      cenario                      : ze_gko_cenario;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Cenário'
      cenario_txt                  : val_text;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LBLNI', element: 'lblni' } }]
      @EndUserText.label           : 'Nº folha registro de serviços'
      @UI.lineItem                 : [{ position: 80, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 80 }]
      @Consumption.semanticObject  : 'ServiceEntrySheet'
      lblni                        : lblni;

      @UI.hidden                   : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_BELNR', element: 'belnr' } }]
      @EndUserText.label           : 'Documento contábil'
      belnr                        : belnr_d;


      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ACDOCA_BELNR', element: 'belnr' } }]
      @EndUserText.label           : 'Nº Doc. Financeiro'
      @Consumption.semanticObject  : 'ZAccountingDocument'
      @UI.lineItem                 : [{ semanticObjectAction: 'displayDocument', type: #WITH_INTENT_BASED_NAVIGATION }]
      belnr_fin                    : belnr_d;


      @UI.hidden                   : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_GJAHR', element: 'CalendarYear' } }]
      @EndUserText.label           : 'Ano contábil'
      gjahr                        : gjahr;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_RE_BELNR', element: 'belnr' } }]
      @EndUserText.label           : 'Fatura MIRO'
      @Consumption.semanticObject  : 'SupplierInvoice'
      @UI.lineItem                 : [{ position: 90, semanticObjectAction: 'displayAdvanced', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 90 }]
      SupplierInvoice              : re_belnr;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_GJAHR', element: 'CalendarYear' } }]
      @EndUserText.label           : 'Ano Fiscal Faturamento'
      @UI.lineItem                 : [{ position: 100 }]
      @UI.selectionField           : [{ position: 100 }]
      FiscalYear                   : gjahr;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' } }]
      @EndUserText.label           : 'Docnum MIRO'
      @Consumption.semanticObject  : 'NotaFiscal'
      @UI.lineItem                 : [{ position: 110, semanticObjectAction: 'zzdisplay', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 110 }]
      BR_NotaFiscal                : j_1bdocnum;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label           : 'Transportadora'
      @Consumption.semanticObject  : 'BusinessPartnerDriver'
      @UI.lineItem                 : [{ position: 120, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 120 }]
      Driver                       : ze_gko_cod_emit_cnpj_cpf;

      @EndUserText.label           : 'Nome Transportadora'
      @UI.lineItem                 : [{ position: 130 }]
      @UI.selectionField           : [{ position: 130 }]
      DriverName                   : bu_name1tx;

      @EndUserText.label           : 'CNPJ/CPF Transportadora'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_CNPJ_CPF', element: 'cnpj_cpf' } }]
      emit_cnpj_cpf                : ze_gko_emit_cnjp_cpf;

      @EndUserText.label           : 'IE Transportadora'
      emit_ie                      : ze_gko_emit_ie;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label           : 'UF Transportadora'
      @ObjectModel.text.element    : ['emit_uf_txt']
      emit_uf                      : ze_gko_emit_uf;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição UF Transportadora'
      emit_uf_txt                  : bezei20;
      
      @EndUserText.label           : 'Município Emitente'
      emit_mun                      : ze_gko_emit_mun;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label           : 'Tomador'
      @Consumption.semanticObject  : 'BusinessPartnerBuyer'
      @UI.lineItem                 : [{ position: 140, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 140 }]
      Buyer                        : ze_gko_tom_cod;

      @EndUserText.label           : 'Nome Tomador'
      @UI.lineItem                 : [{ position: 150 }]
      @UI.selectionField           : [{ position: 150 }]
      BuyerName                    : bu_name1tx;

      @EndUserText.label           : 'CNPJ/CPF Tomador'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_CNPJ_CPF', element: 'cnpj_cpf' } }]
      tom_cnpj_cpf                 : ze_gko_tom_cnjp_cpf;

      @EndUserText.label           : 'IE Tomador'
      tom_ie                       : ze_gko_tom_ie;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label           : 'UF Tomador'
      @ObjectModel.text.element    : ['tom_uf_txt']
      tom_uf                       : ze_gko_tom_uf;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição UF Tomador'
      tom_uf_txt                   : bezei20;
      
      @EndUserText.label           : 'Município Tomador'
      tom_mun                      : ze_gko_tom_mun;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label           : 'Remetente'
      @Consumption.semanticObject  : 'BusinessPartnerSender'
      @UI.lineItem                 : [{ position: 160, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 160 }]
      Sender                       : ze_gko_rem_cod;

      @EndUserText.label           : 'Nome Remetente'
      @UI.lineItem                 : [{ position: 170 }]
      SenderName                   : bu_name1tx;

      @EndUserText.label           : 'CNPJ/CPF Remetente'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_CNPJ_CPF', element: 'cnpj_cpf' } }]
      rem_cnpj_cpf                 : ze_gko_rem_cnjp_cpf;

      @EndUserText.label           : 'IE Remetente'
      rem_ie                       : ze_gko_rem_ie;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label           : 'UF remetente'
      @ObjectModel.text.element    : ['rem_uf_txt']
      rem_uf                       : ze_gko_rem_uf;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição UF remetente'
      rem_uf_txt                   : bezei20;

      @EndUserText.label           : 'Município remetente'
      rem_mun                      : ze_gko_rem_mun;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label           : 'Destinatário'
      @Consumption.semanticObject  : 'BusinessPartnerConsignee'
      @UI.lineItem                 : [{ position: 180, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 180 }]
      Consignee                    : ze_gko_dest_cod;

      @EndUserText.label           : 'Nome Destinatário'
      @UI.lineItem                 : [{ position: 190 }]
      ConsigneeName                : bu_name1tx;

      @EndUserText.label           : 'CNPJ/CPF Destinatário'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_CNPJ_CPF', element: 'cnpj_cpf' } }]
      dest_cnpj_cpf                : ze_gko_dest_cnjp;

      @EndUserText.label           : 'IE Destinatário'
      dest_ie                      : ze_gko_dest_ie;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label           : 'UF destinatário'
      @ObjectModel.text.element    : ['dest_uf_txt']
      dest_uf                      : ze_gko_dest_uf;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição UF destinatário'
      dest_uf_txt                  : bezei20;

      @EndUserText.label           : 'Município destinatário'
      dest_mun                     : ze_gko_dest_mun;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label           : 'Recebedor mercadoria'
      @Consumption.semanticObject  : 'BusinessPartnerReceiver'
      @UI.lineItem                 : [{ position: 200, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 200 }]
      Receiver                     : /scmtms/pty_consignee;

      @EndUserText.label           : 'Nome Recebedor mercadoria'
      @UI.lineItem                 : [{ position: 210 }]
      ReceiverName                 : bu_name1tx;
      
      @EndUserText.label           : 'CNPJ/CPF Recebedor'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_CNPJ_CPF', element: 'cnpj_cpf' } }]
      receb_cnpj_cpf                : ze_gko_dest_cnjp;

      @EndUserText.label           : 'IE Destinatário'
      receb_ie                      : ze_gko_receb_ie;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label           : 'UF Recebedor'
      @ObjectModel.text.element    : ['dest_uf_txt']
      receb_uf                      : ze_gko_receb_uf;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição UF destinatário'
      receb_uf_txt                  : bezei20;

      @EndUserText.label           : 'Município Recebedor'
      receb_mun                     : ze_gko_receb_mun;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER', element: 'Parceiro' } }]
      @EndUserText.label           : 'Expedidor'
      @Consumption.semanticObject  : 'BusinessPartnerShipper'
      @UI.lineItem                 : [{ position: 220, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 220 }]
      Shipper                      : /scmtms/pty_shipper;

      @EndUserText.label           : 'Nome Expedidor'
      @UI.lineItem                 : [{ position: 230 }]
      ShipperName                  : bu_name1tx;
      
      @EndUserText.label           : 'CNPJ/CPF Expedidor'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARTNER_CNPJ_CPF', element: 'cnpj_cpf' } }]
      exped_cnpj_cpf                : ze_gko_exped_cnjp;

      @EndUserText.label           : 'IE Expedidor'
      exped_ie                      : ze_gko_exped_ie;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label           : 'UF Expedidor'
      @ObjectModel.text.element    : ['dest_uf_txt']
      exped_uf                      : ze_gko_exped_uf;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição UF destinatário'
      exped_uf_txt                  : bezei20;

      @EndUserText.label           : 'Município Expedidor'
      exped_mun                     : ze_gko_exped_mun;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_NFNUM9_PREFNO', element: 'nfnum9' } }]
      @EndUserText.label           : 'Nº CT-e/NF-e'
      @UI.lineItem                 : [{ position: 240 }]
      @UI.selectionField           : [{ position: 240 }]
      nfnum9                       : j_1bprefno;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_tm_sh_motivo_rejeicao', element: 'not_code' } }]
      @EndUserText.label           : 'Motivo rejeição'
      @ObjectModel.text.element    : ['not_code_txt']
      @UI.lineItem                 : [{ position: 250 }]
      @UI.selectionField           : [{ position: 250 }]
      not_code                     : ze_gko_not_code;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Motivo rejeição'
      not_code_txt                 : /xnfe/notification;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CFOP', element: 'Cfop1' } }]
      @EndUserText.label           : 'CFOP'
      @UI.lineItem                 : [{ position: 260 }]
      @UI.selectionField           : [{ position: 260 }]
      cfop                         : ze_gko_cfop;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_SITUACAO', element: 'sitdoc' } }]
      @EndUserText.label           : 'Situação CTe / Nfe'
      @ObjectModel.text.element    : ['sitdoc_txt']
      @UI.lineItem                 : [{ position: 270 }]
      @UI.selectionField           : [{ position: 270 }]
      sitdoc                       : ze_gko_sitdoc;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Situação CTe / Nfe'
      sitdoc_txt                   : val_text;

      @EndUserText.label           : 'Data emissão'
      @UI.lineItem                 : [{ position: 280 }]
      @UI.selectionField           : [{ position: 280 }]
      @Consumption.filter.selectionType: #INTERVAL
      @Consumption.filter.mandatory: true
      dtemi                        : ze_gko_dtemi;

      @EndUserText.label           : 'Hora emissão'
      @UI.lineItem                 : [{ position: 290 }]
      hremi                        : ze_gko_hremi;

      @EndUserText.label           : 'Modificado em'
      @UI.lineItem                 : [{ position: 300 }]
      @UI.selectionField           : [{ position: 300 }]
      @Consumption.filter.selectionType: #INTERVAL
      chadat                       : j_1bchadat;

      @EndUserText.label           : 'Modificado às'
      @Consumption.filter.selectionType: #INTERVAL
      chatim                       : j_1bchatim;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_USR_LIB', element: 'usr_lib' } }]
      @EndUserText.label           : 'Usuário liberação'
      @UI.lineItem                 : [{ position: 310 }]
      @UI.selectionField           : [{ position: 310 }]
      usr_lib                      : ze_gko_usr_liberacao;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label           : 'Usuário'
      @ObjectModel.text.element    : ['usnam_txt']
      @UI.lineItem                 : [{ position: 320 }]
      @UI.selectionField           : [{ position: 320 }]
      usnam                        : usnam;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Usuário'
      usnam_txt                    : ad_namtext;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPDOC', element: 'tpdoc' } }]
      @EndUserText.label           : 'Tipo Documento'
      @ObjectModel.text.element    : ['tpdoc_txt']
      @UI.lineItem                 : [{ position: 330 }]
      @UI.selectionField           : [{ position: 330 }]
      @Consumption.filter.selectionType: #SINGLE
      tpdoc                        : ze_gko_tpdoc;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Tipo Documento'
      tpdoc_txt                    : val_text;

      @EndUserText.label           : 'Anexo GNRE'
      @UI.lineItem                 : [{ position: 340, criticality: 'possui_anexo_gnre_crit', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.selectionField           : [{ position: 340 }]
      @Consumption.filter.selectionType: #SINGLE
      possui_anexo_gnre            : boole_d;

      @UI.hidden                   : true
      possui_anexo_gnre_crit       : abap.int1;

      @EndUserText.label           : 'Comprovante GNRE'
      @UI.lineItem                 : [{ position: 350, criticality: 'possui_comprovante_gnre_crit', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.selectionField           : [{ position: 350 }]
      @Consumption.filter.selectionType: #SINGLE
      possui_comprovante_gnre      : boole_d;

      @UI.hidden                   : true
      possui_comprovante_gnre_crit : abap.int1;

      @EndUserText.label           : 'Anexo NFS'
      @UI.lineItem                 : [{ position: 360, criticality: 'possui_anexo_nfs_crit', criticalityRepresentation: #WITHOUT_ICON }]
      @UI.selectionField           : [{ position: 360 }]
      @Consumption.filter.selectionType: #SINGLE
      possui_anexo_nfs             : boole_d;

      @UI.hidden                   : true
      possui_anexo_nfs_crit        : abap.int1;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_NUM_FATURA', element: 'num_fatura' } }]
      @EndUserText.label           : 'Nº Agrupamento Fatura'
      num_fatura                   : ze_gko_num_fatura;

      @EndUserText.label           : 'Data Vencimento GKO'
      @UI.lineItem                 : [{ position: 370 }]
      vct_gko                      : ze_gko_vct_gko;

      @EndUserText.label           : 'Data Vencimento Fornecedor' -- Campo calculado
      @UI.lineItem                 : [{ position: 380 }]
      vct_forn                     : abap.dats;

      @EndUserText.label           : 'Data Vencimento Líquido' -- Campo calculado
      @UI.lineItem                 : [{ position: 390 }]
      vct_liq                      : abap.dats;

      @EndUserText.label           : 'Contador histórico'
      counter                      : abap.numc(3);

      @EndUserText.label           : 'Pago'
      @UI.lineItem                 : [{ position: 440, criticality: 'pago_criticality', criticalityRepresentation: #WITHOUT_ICON }]
      pago                         : ze_gko_pago;

      @UI.hidden                   : true
      pago_criticality             : abap.int1;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DIRECT', element: 'Direct' } }]
      @EndUserText.label           : 'Direção Mov. Mercadoria'
      @ObjectModel.text.element    : ['direct_txt']
      direct                       : j_1bdirect;

      @UI.hidden                   : true
      direct_txt                   : val_text;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MODEL', element: 'model' } }]
      @EndUserText.label           : 'Modelo NF'
      @ObjectModel.text.element    : ['model_txt']
      model                        : j_1bmodel;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Modelo NF'
      model_txt                    : val_text;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_PROD_ACABADO', element: 'prod_acabado' } }]
      @EndUserText.label           : 'Produto Acabado'
      @ObjectModel.text.element    : ['prod_acabado_desc']
      prod_acabado                 : ze_gko_prod_acabado;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Produto Acabado'
      prod_acabado_desc            : val_text;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPRATEIO', element: 'tprateio' } }]
      @EndUserText.label           : 'Tipo Rateio'
      @ObjectModel.text.element    : ['rateio_txt']
      rateio                       : ze_gko_tprateio;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Tipo Rateio'
      rateio_txt                   : val_text;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_CODEVENTO', element: 'codevento' } }]
      @EndUserText.label           : 'Código do evento'
      @ObjectModel.text.element    : ['codevento_txt']
      codevento                    : ze_gko_codevento;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Código do evento'
      codevento_txt                : val_text;

      @EndUserText.label           : 'Registro'
      dhregevento                  : ze_gko_dhregevento;

      @EndUserText.label           : 'Tipo de Evento'
      tpevento                     : ze_gko_tpevento;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_TPCTE', element: 'tpcte' } }]
      @EndUserText.label           : 'Tipo do CT-e'
      @ObjectModel.text.element    : ['tpcte_txt']
      tpcte                        : abap.char(1);

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Tipo do CT-e'
      tpcte_txt                    : val_text;

      @EndUserText.label           : 'Código Status'
      @ObjectModel.text.element    : ['xmotivo']
      cstat                        : ze_gko_cstat;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Código Status'
      xmotivo                      : ze_gko_xmotivo;

      @EndUserText.label           : 'Valor total serviço'
      @UI.lineItem                 : [{ position: 380 }]
      @UI.selectionField           : [{ position: 280 }]
      vtprest                      : ze_gko_vtprest;

      @EndUserText.label           : 'Valor a receber'
      vrec                         : ze_gko_vrec;

      @EndUserText.label           : 'Base de cálculo ICMS'
      vbcicms                      : ze_gko_vbcicms;

      @EndUserText.label           : 'Base de cálculo ISS'
      vbciss                       : ze_gko_vbciss;

      @EndUserText.label           : 'Alíquota ICMS'
      picms                        : ze_gko_picms;

      @EndUserText.label           : 'Alíquota ISS'
      piss                         : ze_gko_piss;

      @EndUserText.label           : 'Valor ICMS'
      vicms                        : ze_gko_vicms;

      @EndUserText.label           : 'Valor ISS'
      viss                         : ze_gko_viss;

      @EndUserText.label           : 'Valor total da carga'
      vcarga                       : ze_gko_vcarga;

      @EndUserText.label           : 'Quantidade da carga'
      qcarga                       : ze_gko_qcarga;

      @EndUserText.label           : 'Séries'
      series                       : j_1bseries;

      @EndUserText.label           : 'Funrural'
      funrural                     : abap.char(1);

      @EndUserText.label           : 'Valor fiscal ISS'
      @Semantics.amount.currencyCode: 'iss_curr'
      iss                          : wrbtr;

      @UI.hidden                   : true
      @EndUserText.label           : 'Moeda ISS'
      iss_curr                     : waerk;

      @EndUserText.label           : 'Valor fiscal INSS'
      @Semantics.amount.currencyCode: 'inss_curr'
      inss                         : wrbtr;

      @EndUserText.label           : 'Moeda INSS'
      inss_curr                    : waerk;

      @EndUserText.label           : 'Valor fiscal TRIO'
      @Semantics.amount.currencyCode: 'trio_curr'
      trio                         : wrbtr;

      @UI.hidden                   : true
      @EndUserText.label           : 'Moeda TRIO'
      trio_curr                    : waerk;

      @EndUserText.label           : 'Valor fiscal IRRF'
      @Semantics.amount.currencyCode: 'irrf_curr'
      irrf                         : wrbtr;

      @UI.hidden                   : true
      @EndUserText.label           : 'Moeda IRRF'
      irrf_curr                    : waerk;

      @EndUserText.label           : 'Moeda'
      moeda                        : waerk;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_VSTEL', element: 'LocalExpedicao' } }]
      @EndUserText.label           : 'Local de expedição'
      @ObjectModel.text.element    : ['vstel_txt']
      vstel                        : vstel;

      @UI.hidden                   : true
      vstel_txt                    : bezei30;

      @EndUserText.label           : 'Frete calculado'
      frete_calculado_gko          : abap.char(1);

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } }]
      @EndUserText.label           : 'Ordem de Frete'
      @Consumption.semanticObject  : 'FreightOrder'
      @UI.lineItem                 : [{ position: 390, semanticObjectAction: 'displayRoad', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 390 }]
      FreightOrder                 : /scmtms/tor_id;

      @EndUserText.label           : 'Doc. Faturamento Frete (DFF)'
      @Consumption.semanticObject  : 'FreightSettlementDocument'
      @UI.lineItem                 : [{ position: 400, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION }]
      sfir_id                      : /scmtms/sfir_id;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_LIFECYCLE', element: 'lifecycle' } }]
      @EndUserText.label           : 'Status DFF'
      @ObjectModel.text.element    : ['lifecycle_txt']
      lifecycle                    : /scmtms/sfir_lc_status;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Status DFF'
      lifecycle_txt                : val_text;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_CONFIRMATION', element: 'confirmation' } }]
      @EndUserText.label           : 'Status confirmação DFF'
      @ObjectModel.text.element    : ['confirmation_txt']
      confirmation                 : /scmtms/sfir_confirm_status;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Status confirmação DFF'
      confirmation_txt             : val_text;

      @EndUserText.label           : 'Doc. Transação comercial (DTC)'
      btd_id                       : lblni;

      @UI.hidden                   : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WBELN', element: 'wbeln' } }]
      @EndUserText.label           : 'Nº Documento '
      wbeln                        : wbeln_ag;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_SAKNR_PC3C', element: 'GLAccount' } }]
      @EndUserText.label           : 'Conta razão'
      @ObjectModel.text.element    : ['sakto_txt']
      sakto                        : saknr;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Conta razão'
      sakto_txt                    : txt50_skat;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KOSTL', element: 'CentroCusto' } }]
      @EndUserText.label           : 'Centro de custo'
      @ObjectModel.text.element    : ['kostl_txt']
      kostl                        : kostl;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Centro de custo'
      kostl_txt                    : ktext;

      @EndUserText.label           : 'Data faturamento'
      @Consumption.filter.selectionType: #INTERVAL
      rbkp_budat                   : budat;

      @EndUserText.label           : 'Hora da entrada'
      cputm                        : cputm;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUKRS', element: 'Empresa' } }]
      @EndUserText.label           : 'Empresa agrupamento'
      @ObjectModel.text.element    : ['bukrs_doc_txt']
      bukrs_doc                    : ze_gko_bukrs_doc;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Empresa agrupamento'
      bukrs_doc_txt                : butxt;

      @EndUserText.label           : 'Data do documento'
      @Consumption.filter.selectionType: #INTERVAL
      budat                        : budat;

      @EndUserText.label           : 'Data compensação'
      @Consumption.filter.selectionType: #INTERVAL
      augdt                        : augdt;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label           : 'Usuário Integração'
      @ObjectModel.text.element    : ['crenam_txt']
      crenam                       : j_1bcrenam;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Usuário Integração'
      crenam_txt                   : bu_name1tx;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      @EndUserText.label           : 'Modificado por'
      @ObjectModel.text.element    : ['chanam_txt']
      chanam                       : j_1bchanam;

      @UI.hidden                   : true
      @EndUserText.label           : 'Descrição Modificado por'
      chanam_txt                   : bu_name1tx;

      @EndUserText.label           : 'Desconto'
      desconto                     : abap.dec( 15, 2 );

      @EndUserText.label           : 'Valor PIS'
      pis                          : abap.dec( 15, 2 );

      @EndUserText.label           : 'Valor COFINS'
      cofins                       : abap.dec( 15, 2 );

      @EndUserText.label           : 'Frete Cotado FLUIG'
      @UI.lineItem                 : [{ position: 430 }]
      frete_cotado_fluig           : ze_vlr_frete;

      @EndUserText.label           : 'Peso Bruto'
      @Semantics.quantity.unitOfMeasure: 'gro_wei_uni'
      gro_wei_val                  : abap.quan(31,3);

      @EndUserText.label           : 'Unidade Peso Bruto'
      gro_wei_uni                  : /scmtms/qua_gro_wei_uni;

      @EndUserText.label           : 'Autenticação Bancária'
      autenticacao_bancaria        : ze_autentic_bancaria;

      @EndUserText.label           : 'ID Doc. Faturamento Frete (DFF)'
      @UI.lineItem                 : [{ position: 440, hidden: true }]
      @UI.selectionField           : [{ position: 440 }]
      SuplrFrtInvcReqUUID          : abap.char(32);

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_FRETE_EBELN', element: 'ebeln' } }]
      @EndUserText.label           : 'Pedido de compra'
      @Consumption.semanticObject  : 'ZPurchaseOrder'
      @UI.lineItem                 : [{ position: 400, semanticObjectAction: 'zzdisplay', type: #WITH_INTENT_BASED_NAVIGATION }]
      @UI.selectionField           : [{ position: 400 }]
      PurchaseOrder                : ebeln;

      @EndUserText.label           : 'ID Ordem de frete'
      @UI.lineItem                 : [{ position: 420, hidden: true }]
      @UI.selectionField           : [{ position: 420 }]
      TransportationOrderUUID      : abap.char(32);

      @EndUserText.label           : 'Último log'
      @UI.lineItem                 : [{ position: 430, criticality: 'codstatus_crit', criticalityRepresentation: #WITHOUT_ICON }]
      UltimoLog                    : abap.char(220);

      // ------------------------------------------------------
      // Field Information (Item)
      // ------------------------------------------------------

      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' } }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_MONITOR_GKO_REF', element: 'acckey_ref' } }]
      @EndUserText.label           : 'Nº Documento Referência'
      @UI.selectionField           : [{ position: 110 }]
      //      docnum_ref                   : j_1bdocnum;
      docnum_ref                   : ze_gko_acckey_ref;

      // ------------------------------------------------------
      // Buttons information
      // ------------------------------------------------------

      @UI.lineItem                 : [{ type: #FOR_ACTION, dataAction: 'estorno',     label: 'Estorno' },
                                      { type: #FOR_ACTION, dataAction: 'reprocessar', label: 'Reprocessar' },
                                      { type: #FOR_ACTION, dataAction: 'agrupamento', label: 'Agrupamento de Faturas' },
                                      { type: #FOR_ACTION, dataAction: 'evento_cte',  label: 'Evento CTE' },
                                      { type: #FOR_ACTION, dataAction: 'consultar_status',  label: 'Consultar Status' }]

      @UI.hidden                   : true
      @Consumption.valueHelpDefinition: [{ entity:  { name: 'zi_tm_sh_motivo_rejeicao', element: 'not_code' } }]
      @EndUserText.label           : 'Motivo da rejeição'
      motivoRejeicao               : /xnfe/not_code;

      @UI.hidden                   : true
      @EndUserText.label           : 'Agrupamento'
      estornoAgrupamento           : boole_d;

      @UI.hidden                   : true
      @EndUserText.label           : 'Estorno MIRO'
      estornoMiro                  : boole_d;

      @UI.hidden                   : true
      @EndUserText.label           : 'Estorno Doc. Fatura Frete'
      estornoPedido                : boole_d;

      // ------------------------------------------------------
      // Validate information
      // ------------------------------------------------------

      @EndUserText.label           : '(Regra CFOP)'
      @UI.lineItem                 : [{ position: 900 }]
      cfop_ok                      : boole_d;

      @EndUserText.label           : '(Regra Agrupamento)'
      @UI.lineItem                 : [{ position: 900 }]
      agrupamento_ok               : boole_d;

      _log                         : association [0..*] to zc_tm_cockpit_log_new on _log.Acckey = $projection.acckey;

}
