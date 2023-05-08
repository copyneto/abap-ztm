class ZCLTM_GKO_PROCESS definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_s_bsak,
        bukrs TYPE bsak_view-bukrs,
        augbl TYPE bsak_view-augbl,
        auggj TYPE bsak_view-auggj,
        augdt TYPE bsak_view-augdt,
      END OF ty_s_bsak .
  types:
    BEGIN OF ty_s_012k,
        bukrs TYPE t012k-bukrs,
        hkont TYPE t012k-hkont,
      END OF ty_s_012k .
  types:
    BEGIN OF ty_accounts,
        bukrs TYPE t012k-bukrs,
        hkont TYPE t012k-hkont,
      END OF ty_accounts .
  types:
    BEGIN OF ty_s_po_ref_nf_data,
        docnum TYPE j_1bnfdoc-docnum,
        itmnum TYPE j_1bnflin-itmnum,
        nftot  TYPE j_1bnfdoc-nftot,
        nfnet  TYPE j_1bnflin-nfnet,
      END OF ty_s_po_ref_nf_data .
  types:
    BEGIN OF ty_s_material_data,
        matnr   TYPE mara-matnr, "zgkop007-matnr,
        meins   TYPE mara-meins,
        steuc   TYPE marc-steuc,
        indus   TYPE marc-indus,
        mtuse   TYPE mbew-mtuse,
        mtorg   TYPE mbew-mtorg,
        matnr_g TYPE mara-matnr, "zgkop007-matnr,
        meins_g TYPE mara-meins,
        steuc_g TYPE marc-steuc,
        indus_g TYPE marc-indus,
        mtuse_g TYPE mbew-mtuse,
        mtorg_g TYPE mbew-mtorg,
      END OF ty_s_material_data .
  types:
    BEGIN OF ty_s_po_iva_detailed,
        docnum TYPE j_1bnflin-docnum,
        itmnum TYPE j_1bnflin-itmnum,
        mwskz  TYPE ekpo-mwskz,
      END OF ty_s_po_iva_detailed .
  types:
    BEGIN OF ty_s_j_1bnflin,
        docnum    TYPE j_1bnflin-docnum,
        itmnum    TYPE j_1bnflin-itmnum,
        matnr     TYPE j_1bnflin-matnr,
        cfop      TYPE j_1bnflin-cfop,
        menge     TYPE j_1bnflin-menge,
        meins     TYPE j_1bnflin-meins,
        netwr     TYPE j_1bnflin-netwr,
        nfnet     TYPE j_1bnflin-nfnet,
        mwskz     TYPE j_1bnflin-mwskz,
        xped      TYPE j_1bnflin-xped,
        nitemped  TYPE j_1bnflin-nitemped,
        refkey    TYPE j_1bnflin-refkey,
        refitm    TYPE j_1bnflin-refitm,
        ebeln     TYPE ekpo-ebeln,
        ebelp     TYPE ekpo-ebelp,
        refkey_po TYPE j_1bnflin-refkey,
        refitm_po TYPE j_1bnflin-refitm,
        mblnr     TYPE mseg-mblnr,
        mjahr     TYPE mseg-mjahr,
        zeile     TYPE mseg-zeile,
        refkey_mb TYPE j_1bnflin-refkey,
        refitm_mb TYPE j_1bnflin-refitm,
        belnr     TYPE rseg-belnr,
        gjahr     TYPE rseg-gjahr,
        buzei     TYPE rseg-buzei,
        mtart_pa  TYPE zttm_pcockpit009-tipo_mat, " zgkop002-mtart,
      END OF ty_s_j_1bnflin .
  types:
    BEGIN OF ty_s_po_data_col,
        ebeln   TYPE ekpo-ebeln,
        ebelp   TYPE ekpo-ebelp,
        mwskz   TYPE ekpo-mwskz,
        gjahr   TYPE ekbe-gjahr,
        belnr   TYPE ekbe-belnr,
        buzei   TYPE ekbe-buzei,
        belnr_r TYPE rseg-belnr,
        gjahr_r TYPE rseg-gjahr,
        buzei_r TYPE rseg-buzei,
        refkey  TYPE j_1bnflin-refkey,
        refitm  TYPE j_1bnflin-refitm,
      END OF ty_s_po_data_col .
  types:
    BEGIN OF ty_s_items_post,
        docnum        TYPE j_1bnflin-docnum,
        itmnum        TYPE j_1bnflin-itmnum,
        matnr         TYPE j_1bnflin-matnr,
        cfop          TYPE j_1bnflin-cfop,
        tax_code      TYPE mwskz_mrm,
        item_amount   TYPE bapiwrbtr,
        tax_amount    TYPE j_1bnflin-vtottrib,
        item_amount_r TYPE ze_gko_vtprest,
        quantity      TYPE ekpo-menge,
        unit          TYPE ekpo-meins,
        po_pr_uom     TYPE ekpo-bprme,
        ebeln         TYPE ekpo-ebeln,
        ebelp         TYPE ekpo-ebelp,
        ref_doc       TYPE rseg-lfbnr,
        ref_doc_it    TYPE rseg-lfpos,
        ref_doc_year  TYPE rseg-lfgja,
        docnum_out    TYPE j_1bnflin-docnum,
        itmnum_out    TYPE j_1bnflin-itmnum,
        mtart_pa      TYPE zttm_pcockpit009-tipo_mat, " zgkop002-mtart,
      END OF ty_s_items_post .
  types TY_S_ITEM_ARREDONDAMENTO type ZSTM_GKO_ARREDONDAMENTO .
  types:
*    BEGIN OF ty_s_item_arredondamento,
*        ebeln     TYPE ekpo-ebeln,
*        ebelp     TYPE ekpo-ebelp,
*        diferenca TYPE zttm_gkot001-vtprest,
*      END OF ty_s_item_arredondamento .
    ty_t_zgkot001            TYPE STANDARD TABLE OF zttm_gkot001             WITH DEFAULT KEY .
  types:
    ty_t_zgkot002            TYPE STANDARD TABLE OF zttm_gkot002             WITH DEFAULT KEY .
  types:
    ty_t_zgkot003            TYPE STANDARD TABLE OF zttm_gkot003             WITH DEFAULT KEY .
  types:
    ty_t_zgkot005            TYPE STANDARD TABLE OF zttm_gkot005             WITH DEFAULT KEY .
  types:
    ty_t_zgkot006            TYPE STANDARD TABLE OF zttm_gkot006             WITH DEFAULT KEY .
  types:
    ty_t_zgkot007            TYPE STANDARD TABLE OF zttm_gkot007             WITH DEFAULT KEY .
  types:
    ty_t_po_item             TYPE STANDARD TABLE OF bapimepoitem             WITH DEFAULT KEY .
  types:
    ty_t_po_itemx            TYPE STANDARD TABLE OF bapimepoitemx            WITH DEFAULT KEY .
  types:
    ty_t_po_cond             TYPE STANDARD TABLE OF bapimepocond             WITH DEFAULT KEY .
  types:
    ty_t_po_condx            TYPE STANDARD TABLE OF bapimepocondx            WITH DEFAULT KEY .
  types:
    ty_t_po_account          TYPE STANDARD TABLE OF bapimepoaccount          WITH DEFAULT KEY .
  types:
    ty_t_po_accountx         TYPE STANDARD TABLE OF bapimepoaccountx         WITH DEFAULT KEY .
  types:
    ty_t_acckey              TYPE STANDARD TABLE OF zttm_gkot001-acckey      WITH DEFAULT KEY .
  types:
    ty_t_miro_itemdata       TYPE STANDARD TABLE OF bapi_incinv_create_item  WITH DEFAULT KEY .
  types:
    ty_t_012k                TYPE STANDARD TABLE OF ty_s_012k .
  types:
    ty_t_po_ref_nf_data      TYPE STANDARD TABLE OF ty_s_po_ref_nf_data      WITH DEFAULT KEY .
  types:
    ty_t_po_iva_detailed     TYPE STANDARD TABLE OF ty_s_po_iva_detailed     WITH DEFAULT KEY .
  types:
    ty_t_j_1bnflin           TYPE STANDARD TABLE OF ty_s_j_1bnflin           WITH DEFAULT KEY .
  types:
    ty_t_po_data_col         TYPE STANDARD TABLE OF ty_s_po_data_col         WITH DEFAULT KEY .
  types:
    ty_t_items_post          TYPE STANDARD TABLE OF ty_s_items_post          WITH DEFAULT KEY .
  types:
    ty_t_item_arredondamento TYPE STANDARD TABLE OF ty_s_item_arredondamento WITH DEFAULT KEY .
  types:
    ty_t_formulario_cte TYPE STANDARD TABLE OF zi_tm_formulario_cte .
  types TY_COMP type ZC_TM_MONITOR_GKO_CTE_COMP .
  types:
    ty_t_comp  TYPE STANDARD TABLE OF ty_comp .
  types TY_CARGA type ZC_TM_MONITOR_GKO_CTE_CARGA .
  types:
    ty_t_carga TYPE STANDARD TABLE OF ty_carga .
  types:
    BEGIN OF ty_parameter,
        r_zgko_local TYPE RANGE OF zclsd_dt_nota_fiscal_servico-zgko_local,
      END OF ty_parameter .

  data GS_GKO_HEADER type ZTTM_GKOT001 .
  constants:
    BEGIN OF gc_param_zgko_local,
        modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
        chave1 TYPE ztca_param_val-chave1 VALUE 'COCKPIT_FRETE' ##NO_TEXT,
        chave2 TYPE ztca_param_val-chave2 VALUE 'ZGKO_LOCAL' ##NO_TEXT,
        chave3 TYPE ztca_param_val-chave3 VALUE '' ##NO_TEXT,
      END OF gc_param_zgko_local .
  constants:
    BEGIN OF gc_tpdoc,
        cte TYPE ze_gko_tpdoc VALUE 'CTE',
        nfs TYPE ze_gko_tpdoc VALUE 'NFS',
        nfe TYPE ze_gko_tpdoc VALUE 'NFE',
      END OF gc_tpdoc .
  constants:
    BEGIN OF gc_prod_acabado,
        nao     TYPE ze_gko_prod_acabado VALUE '0',
        sim     TYPE ze_gko_prod_acabado VALUE '1',
        parcial TYPE ze_gko_prod_acabado VALUE '2',
      END OF gc_prod_acabado .
  constants:
    BEGIN OF gc_codstatus,
        documento_integrado            TYPE ze_gko_codstatus VALUE '100',
        aguardando_dados_adicionais    TYPE ze_gko_codstatus VALUE '101',
        of_identificada                TYPE ze_gko_codstatus VALUE '200',
        cenario_identificado           TYPE ze_gko_codstatus VALUE '210',
        calculo_custo_efetuado         TYPE ze_gko_codstatus VALUE '211',
        frete_faturado                 TYPE ze_gko_codstatus VALUE '300',
        aguardando_faturamento_frete   TYPE ze_gko_codstatus VALUE '301',
        pedido_compra_aprovado         TYPE ze_gko_codstatus VALUE 'E99',
        miro_memorizada                TYPE ze_gko_codstatus VALUE '400',
        miro_confirmada                TYPE ze_gko_codstatus VALUE '401',
        agrupamento_efetuado           TYPE ze_gko_codstatus VALUE '500',
        aguardando_reagrupamento       TYPE ze_gko_codstatus VALUE '501',
        aguardando_aprovacao_wf        TYPE ze_gko_codstatus VALUE '502',
        pagamento_efetuado             TYPE ze_gko_codstatus VALUE '600',
        evt_rejeicao_aguard_sefaz      TYPE ze_gko_codstatus VALUE '700',
        evt_rejeicao_confirmado_sefaz  TYPE ze_gko_codstatus VALUE '701',
        estorno_total_realizado        TYPE ze_gko_codstatus VALUE '800',
        estorno_realizado              TYPE ze_gko_codstatus VALUE '801',
        estorno_miro_deb_p_realizado   TYPE ze_gko_codstatus VALUE '802',
        estorno_agrupamento_realizado  TYPE ze_gko_codstatus VALUE '803',
        estorno_miro_realizado_n       TYPE ze_gko_codstatus VALUE '804',
        estorno_miro_deb_p_realizado_n TYPE ze_gko_codstatus VALUE '805',
        pedido_eliminado               TYPE ze_gko_codstatus VALUE '806',
        erro_faturamento_frete         TYPE ze_gko_codstatus VALUE '810',
        documento_cancelado            TYPE ze_gko_codstatus VALUE '900',
        documento_cancelado_reversao_r TYPE ze_gko_codstatus VALUE '901',
        aguardando_estorno_agrupamento TYPE ze_gko_codstatus VALUE '902',
        dff_estornada                  TYPE ze_gko_codstatus VALUE '903',
        aguardando_estorno_dff         TYPE ze_gko_codstatus VALUE '904',
        cenario_nao_identificado       TYPE ze_gko_codstatus VALUE 'E01',
        cod_transp_nao_encontrado      TYPE ze_gko_codstatus VALUE 'E02',
        cod_tomador_nao_encontrado     TYPE ze_gko_codstatus VALUE 'E03',
        cod_remetente_nao_encontrado   TYPE ze_gko_codstatus VALUE 'E04',
        cod_dest_nao_encontrado        TYPE ze_gko_codstatus VALUE 'E05',
        empresa_filial_nao_encontrado  TYPE ze_gko_codstatus VALUE 'E06',
        cenario_nao_configurado        TYPE ze_gko_codstatus VALUE 'E07',
        erro_ao_identificar_of         TYPE ze_gko_codstatus VALUE 'E08',
        erro_ao_criar_miro             TYPE ze_gko_codstatus VALUE 'E09',
        erro_ao_realizar_estorno_total TYPE ze_gko_codstatus VALUE 'E10',
        erro_ao_realizar_estorno       TYPE ze_gko_codstatus VALUE 'E11',
        erro_ao_criar_miro_deb_post    TYPE ze_gko_codstatus VALUE 'E12',
        sem_anexo_atribuido            TYPE ze_gko_codstatus VALUE 'E13',
        sem_anexo_atribuido_miro_deb_p TYPE ze_gko_codstatus VALUE 'E14',
        erro_estorno_agrupamento       TYPE ze_gko_codstatus VALUE 'E15',
        erro_estorno_miro_deb_post     TYPE ze_gko_codstatus VALUE 'E16',
        erro_estorno_miro              TYPE ze_gko_codstatus VALUE 'E17',
        erro_ao_eliminar_pedido        TYPE ze_gko_codstatus VALUE 'E18',
        erro_ao_realizar_estorno_canc  TYPE ze_gko_codstatus VALUE 'E19',
        erro_ao_confirmar_evt_rejeicao TYPE ze_gko_codstatus VALUE 'E20',
        vlrtot_miro_igual_vlrtot_xml   TYPE ze_gko_codstatus VALUE 'E21',
        cnpj_xml_igual_cnpj_esct_cte   TYPE ze_gko_codstatus VALUE 'E22',
        vlr_icms_cte_maior_icms_xml    TYPE ze_gko_codstatus VALUE 'E23',
        arredondm_n_realizado          TYPE ze_gko_codstatus VALUE 'E24',
        erro_calc_custo                TYPE ze_gko_codstatus VALUE 'E31',
        erro_fat_frete                 TYPE ze_gko_codstatus VALUE 'E32',
        erro_lancamento_frete          TYPE ze_gko_codstatus VALUE 'E33',
        erro_calc_cust_extra           TYPE ze_gko_codstatus VALUE 'E34',
        erro_distribuicao_custo        TYPE ze_gko_codstatus VALUE 'E35',
        erro_liberar_abd               TYPE ze_gko_codstatus VALUE 'E36',
        erro_nf_ref_nao_encontrada     TYPE ze_gko_codstatus VALUE 'E37',
        erro_ao_eliminar_dff           TYPE ze_gko_codstatus VALUE 'E38',
        erro_carregar_arquivo          TYPE ze_gko_codstatus VALUE 'E39',
        erro_agrupamento_manual        TYPE ze_gko_codstatus VALUE 'E40',
        erro_agrupamento               TYPE ze_gko_codstatus VALUE 'E41',
        cod_expedidor_nao_encontrado   TYPE ze_gko_codstatus VALUE 'E42',
        cod_recebedor_nao_encontrado   TYPE ze_gko_codstatus VALUE 'E43',
        bloqueio_usuario_criacao_custo TYPE ze_gko_codstatus VALUE 'E44',
        bloqueio_usuario_faturam_frete TYPE ze_gko_codstatus VALUE 'E45',
      END OF gc_codstatus .
  constants:
    BEGIN OF gc_attach_type,
        xml            TYPE ze_gko_attach_type VALUE '1',
        gnre           TYPE ze_gko_attach_type VALUE '2',
        comp_pgto_gnre TYPE ze_gko_attach_type VALUE '3',
        nfs            TYPE ze_gko_attach_type VALUE '4',
      END OF gc_attach_type .
  constants:
    BEGIN OF gc_attach_type_new,
        xml            TYPE /bobf/attachment_type  VALUE 'XML',
        gnre           TYPE /bobf/attachment_type  VALUE 'GNRE',
        comp_pgto_gnre TYPE /bobf/attachment_type  VALUE 'CGNRE',
        nfs            TYPE /bobf/attachment_type  VALUE 'NFS',
      END OF gc_attach_type_new .
  constants:
    BEGIN OF gc_params,
        qtd_dias_criacao_pedido     TYPE ze_gko_id VALUE '01',
        diretorio_origem            TYPE ze_gko_id VALUE '02',
        diretorio_processados       TYPE ze_gko_id VALUE '03',
        moeda                       TYPE ze_gko_id VALUE '04',
        tipo_documento_fatura       TYPE ze_gko_id VALUE '05',
        texto_cab_document_fatura   TYPE ze_gko_id VALUE '06',
        condicao_pagamento_fatura   TYPE ze_gko_id VALUE '07',
        texto_item_fatura           TYPE ze_gko_id VALUE '08',
        chave_lancamento            TYPE ze_gko_id VALUE '09',
        texto_item_desconto_fatura  TYPE ze_gko_id VALUE '10',
        chave_desconto              TYPE ze_gko_id VALUE '11',
        conta_desconto_fatura       TYPE ze_gko_id VALUE '12',
        destino_rfc_grc             TYPE ze_gko_id VALUE '13',
        tipo_pedido                 TYPE ze_gko_id VALUE '14',
        organizacao_compras         TYPE ze_gko_id VALUE '15',
        grupo_compras               TYPE ze_gko_id VALUE '16',
        tipo_documento_miro         TYPE ze_gko_id VALUE '17',
        chave_bloqueio_pagamento    TYPE ze_gko_id VALUE '18',
        diretorio_cte_gko           TYPE ze_gko_id VALUE '19',
        data_corte_recebimento_doc  TYPE ze_gko_id VALUE '20',
        diferenca_maxima_arredonda  TYPE ze_gko_id VALUE '21',
        diretorio_destino           TYPE ze_gko_id VALUE '23',
        diretorio_arquivo_OF        TYPE ze_gko_id VALUE '24',
        diretorio_anexos_job        TYPE ze_gko_id VALUE '25',
        texto_cab_document_fatura_m TYPE ze_gko_id VALUE '26',
      END OF gc_params .
  constants:
    BEGIN OF gc_cenario,
        transferencia  TYPE ze_gko_cenario VALUE '01',
        e_commerce     TYPE ze_gko_cenario VALUE '02',
        venda_coligada TYPE ze_gko_cenario VALUE '03',
        venda_cliente  TYPE ze_gko_cenario VALUE '04',
        venda_direta   TYPE ze_gko_cenario VALUE '05',
        frete_diversos TYPE ze_gko_cenario VALUE '06',
        entradas       TYPE ze_gko_cenario VALUE '07',
      END OF gc_cenario .
  constants:
    BEGIN OF gc_tpprocess,
        automatico TYPE ze_gko_tpprocess VALUE '1',
        manual     TYPE ze_gko_tpprocess VALUE '2',
      END OF gc_tpprocess .
  constants:
      " Formulários
    BEGIN OF gc_smartforms,
        dacte       TYPE tdsfname VALUE 'ZSFTM_DACTE',
        dacte_compl TYPE tdsfname VALUE 'ZSFTM_DACTE_COMPL',
      END OF gc_smartforms .
  constants:
    BEGIN OF gc_sitdoc,
        autorizado TYPE ze_gko_sitdoc VALUE '1',
        cancelado  TYPE ze_gko_sitdoc VALUE '2',
        desacordo  TYPE ze_gko_sitdoc VALUE '3',
      END OF gc_sitdoc .
  constants:
    BEGIN OF gc_tprateio,
        detalhado TYPE ze_gko_tprateio VALUE 'R01',
        unificado TYPE ze_gko_tprateio VALUE 'R02',
      END OF gc_tprateio .
  constants:
    BEGIN OF gc_docger,
        pedido_miro        TYPE ze_gko_docgerado VALUE 'D001',
        miro_deb_posterior TYPE ze_gko_docgerado VALUE 'D002',
      END OF gc_docger .
  constants:
    BEGIN OF gc_tipo_docger,
        pedido             TYPE ze_gko_tipo_doc VALUE '1',
        fatura             TYPE ze_gko_tipo_doc VALUE '2',
        agrupamento_fatura TYPE ze_gko_tipo_doc VALUE '3',
      END OF gc_tipo_docger .
  constants:
    BEGIN OF gc_acao,
        reprocessar      TYPE ze_gko_acao VALUE 'R',
        estorno_fiscal   TYPE ze_gko_acao VALUE 'F',
        estorno_completo TYPE ze_gko_acao VALUE 'C',
        evento_cte       TYPE ze_gko_acao VALUE 'E',
        estorno          TYPE ze_gko_acao VALUE 'S',
      END OF gc_acao .
  constants:
    BEGIN OF gc_tipo_retencao,
        iss      TYPE ze_gko_tipo_retencao VALUE '1',
        funrural TYPE ze_gko_tipo_retencao VALUE '2',
        inss     TYPE ze_gko_tipo_retencao VALUE '3',
        trio     TYPE ze_gko_tipo_retencao VALUE '4',
        irrf     TYPE ze_gko_tipo_retencao VALUE '5',
      END OF gc_tipo_retencao .
  constants:
    BEGIN OF gc_memory_id,
        acckey              TYPE memory_id VALUE 'ZMID_GKO_ACCKEY',
        acckey_header_tab   TYPE memory_id VALUE 'ZMID_GKO_ACCKEY_HEADER_TAB',
        item_arredondamento TYPE memory_id VALUE 'ZMID_GKO_ITEM_ARREDONDAMENTO',
      END OF gc_memory_id .
  constants:
    BEGIN OF gc_invoice_status,
        registrado         TYPE rbkp-rbstat VALUE '5',
        memorizado_entrado TYPE rbkp-rbstat VALUE 'D',
      END OF gc_invoice_status .
  constants:
    BEGIN OF gc_tpcte,
        normal                 TYPE ze_gko_tpcte VALUE '0',
        complemento_de_valores TYPE ze_gko_tpcte VALUE '1',
        anulacao_de_valores    TYPE ze_gko_tpcte VALUE '2',
        substituto             TYPE ze_gko_tpcte VALUE '3',
      END OF gc_tpcte .

  methods ADD_TO_LOG
    importing
      !IV_NEWDOC type ZTTM_GKOT006-NEWDOC optional
      !IV_CODIGO type ZTTM_GKOT006-CODIGO optional
      !IV_DESC_COD type ZTTM_GKOT006-DESC_CODIGO optional
      !IT_BAPI_RET type BAPIRET2_T optional .
  class-methods SAVE_TO_LOG
    importing
      !IV_ACCKEY type J_1B_NFE_ACCESS_KEY_DTEL44
      !IV_NEWDOC type ZTTM_GKOT006-NEWDOC optional
      !IV_CODIGO type ZTTM_GKOT006-CODIGO optional
      !IV_CODSTATUS type ZTTM_GKOT006-CODSTATUS optional
      !IV_DESC_COD type ZTTM_GKOT006-DESC_CODIGO optional
      !IV_TPDOC type ZE_GKO_TPDOC default GC_TPDOC-CTE
      !IV_TPPROCESS type ZE_GKO_TPPROCESS default GC_TPPROCESS-MANUAL
      !IT_BAPI_RET type BAPIRET2_T optional .
  methods ATTACH_FILE
    importing
      !IV_ATTACH_TYPE type ZE_GKO_ATTACH_TYPE
      !IV_REPLACE type ABAP_BOOL default ABAP_FALSE
      !IV_FILE_NAME type STRING optional
      !IV_DATA_XSTRING type XSTRING optional
      !IV_DATA_LENGTH type I optional
      !IT_DATA_TAB type STANDARD TABLE optional
    raising
      ZCXTM_GKO_PROCESS .
  class-methods CHECK_BANK_ACCOUNT .
  class-methods CHECK_INVOICE_GKO
    importing
      !IV_BELNR type RE_BELNR optional
      !IV_GJAHR type GJAHR optional
    exporting
      !EV_ACCKEY type ZTTM_GKOT001-ACCKEY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  class-methods CHECK_PURCHASE_ORDER_GKO
    importing
      !IV_EBELN type EKKO-EBELN
    exporting
      !ET_GKO_HEADER type TY_T_ZGKOT001
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods CHECK_STATUS_SEFAZ_DIRECT
    importing
      value(IV_ACCKEY) type J_1B_NFE_ACCESS_KEY_DTEL44
    raising
      ZCXTM_GKO_PROCESS .
  class-methods CHECK_STATUS_FROM_ACTION
    importing
      !IV_ACTION type ZTTM_PCOCKPIT016-ACAO
      !IV_STATUS type ZTTM_GKOT001-CODSTATUS
    raising
      ZCXTM_GKO_PROCESS .
  class-methods CLEAR_GLOBAL_DATA
    importing
      !IV_REPID type SY-REPID .
  methods CONSTRUCTOR
    importing
      !IV_ACCKEY type ZTTM_GKOT001-ACCKEY optional
      !IV_NEW type ABAP_BOOL default ABAP_FALSE
      !IV_TPDOC type ZE_GKO_TPDOC default GC_TPDOC-CTE
      !IV_TPPROCESS type ZE_GKO_TPPROCESS default GC_TPPROCESS-MANUAL
      !IV_XML type J_1B_NFE_XML_CONTENT optional
      !IS_NFS_DATA type ZCLSD_DT_NOTA_FISCAL_SERVICO optional
      !IV_LOCKED_IN_TAB type ABAP_BOOL default ABAP_FALSE
      !IV_WO_LOCK type ABAP_BOOL default ABAP_FALSE
      !IV_MIN_DATA_LOAD type ABAP_BOOL default ABAP_TRUE
    raising
      ZCXTM_GKO_PROCESS .
  methods FREE .
  methods GET_DATA
    exporting
      !ES_GKO_HEADER type ZTTM_GKOT001
      !ES_GKO_COMPL type ZTTM_GKOT004
      !ET_GKO_ATTACHMENTS type TY_T_ZGKOT002
      !ET_GKO_REFERENCES type TY_T_ZGKOT003
      !ET_GKO_ACCKEY_PO type TY_T_ZGKOT005
      !ET_GKO_LOGS type TY_T_ZGKOT006
      !ET_GKO_EVENTS type TY_T_ZGKOT007 .
  class-methods GET_ICON_FROM_CODSTATUS
    importing
      !IV_CODSTATUS type ZE_GKO_CODSTATUS
    returning
      value(RV_ICON) type ZE_GKO_ICON_STATUS .
  methods GET_ITEMS_POST
    returning
      value(RT_ITEMS_POST) type TY_T_ITEMS_POST
    raising
      ZCXTM_GKO_PROCESS .
  class-methods GET_PARAMETER
    importing
      !IV_ID type ZTTM_PCOCKPIT001-ID
    returning
      value(RV_VALUE) type ZTTM_PCOCKPIT001-PARAMETRO
    raising
      ZCXTM_GKO_PROCESS .
  methods GET_PAYMENT_DOCUMENT
    importing
      !IT_DOC type TY_T_ZGKOT001
    returning
      value(RT_GKOT001) type TY_T_ZGKOT001 .
  methods GET_PO_DATA
    importing
      !IV_ITEM_INTVL type BAPIMEPOHEADER-ITEM_INTVL default '10'
    changing
      !CV_LAST_ITEM_NUM type BAPIMEPOITEM-PO_ITEM
      !CT_PO_ITEM type TY_T_PO_ITEM
      !CT_PO_ITEMX type TY_T_PO_ITEMX
      !CT_PO_COND type TY_T_PO_COND
      !CT_PO_CONDX type TY_T_PO_CONDX
      !CT_PO_ACCOUNT type TY_T_PO_ACCOUNT
      !CT_PO_ACCOUNTX type TY_T_PO_ACCOUNTX
    raising
      ZCXTM_GKO_PROCESS .
  class-methods GET_RFC_DESTINATION
    returning
      value(RV_RFC_DEST) type RFCDEST
    raising
      ZCXTM_GKO_PROCESS .
  class-methods GET_STATUS_DESCRIPTION
    importing
      !IV_STATUS type ZTTM_GKOT001-CODSTATUS
    returning
      value(RV_DESCRIPTION) type VAL_TEXT .
  class-methods GET_VALUE_FROM_XML
    importing
      !IV_XML type XSTRING optional
      !IO_XSLT_PROCESSOR type ref to CL_XSLT_PROCESSOR optional
      !IV_EXPRESSION type STRING
    exporting
      !EO_NODES type ref to IF_IXML_NODE_COLLECTION
    returning
      value(RV_VALUE) type STRING
    raising
      ZCXTM_GKO_PROCESS .
  class-methods GET_XML_FROM_REF_NF
    importing
      !IV_BUKRS type T001-BUKRS
      !IV_BRANCH type J_1BBRANCH-BRANCH
      !IV_ACCKEY type J_1B_NFE_ACCESS_KEY_DTEL44
      !IV_DIRECTION type J_1B_NFE_DIRECTION default 'OUTB'
      !IV_DOCTYPE type J_1B_NFE_DOCTYPE default 'NFE'
    returning
      value(RV_XML) type J_1B_NFE_XML_CONTENT
    raising
      ZCXTM_GKO_PROCESS .
  methods PERSIST
    raising
      ZCXTM_GKO_PROCESS .
  methods PRINT
    exporting
      !EV_PDF type XSTRING
    raising
      ZCXTM_GKO_PROCESS .
  class-methods PRINT_DACTE_FROM_XSTRING
    importing
      !IV_XML type XSTRING
    exporting
      !EV_PDF type XSTRING
    raising
      ZCXTM_GKO_PROCESS .
  methods PROCESS
    raising
      ZCXTM_GKO_PROCESS .
  class-methods PROCESS_PAYMENT
    importing
      !IT_DOC type TY_T_ZGKOT001 .
  methods REJECT
    importing
      !IV_NOT_CODE type ZE_GKO_NOT_CODE
    raising
      ZCXTM_GKO_PROCESS .
  methods REPROCESS
    raising
      ZCXTM_GKO_PROCESS .
  methods REVERSAL
    importing
      !IV_TIPO_DOC type ZE_GKO_TIPO_DOC optional
      !IV_STGRD type STGRD optional
      !IV_BUDAT type BUDAT optional
    raising
      ZCXTM_GKO_PROCESS .
  methods REVERSAL_INVOICE
    importing
      !IV_STGRD type STGRD optional
      !IV_BUDAT type BUDAT optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL
    raising
      ZCXTM_GKO_PROCESS .
  methods CHECK_INVOICE_BEFORE_REVERSAL
    importing
      !IV_BELNR type RBKP-BELNR
      !IV_GJAHR type RBKP-GJAHR
    exporting
      !EV_STBLG type RBKP-STBLG
      !EV_STJAH type RBKP-STJAH
    returning
      value(RV_SUCCESS) type ABAP_BOOL .
  methods REVERSAL_INVOICE_GROUPING
    importing
      !IV_STGRD type STGRD optional
      !IV_BUDAT type BUDAT optional
    returning
      value(RV_SUCCESS) type ABAP_BOOL
    raising
      ZCXTM_GKO_PROCESS .
  methods REVERSAL_PURCHASE_ORDER
    exporting
      !ET_RETURN type BAPIRET2_T
    returning
      value(RV_SUCCESS) type ABAP_BOOL
    raising
      ZCXTM_GKO_PROCESS .
  methods REVERSAL_PURCHASE_ORDER_EX
    exporting
      !ET_RETURN type BAPIRET2_T
    returning
      value(RV_SUCCESS) type ABAP_BOOL
    raising
      ZCXTM_GKO_PROCESS .
  class-methods SEND_DATE_PAYMENT_TO_GKO
    importing
      !IT_AUSZ1 type AUSZ1_TAB
      !IT_AUSZ2 type AUSZ2_TAB
      !IT_BSEG type BSEG_T
    exporting
      !EV_AUGDT type BSAK_VIEW-AUGDT
      !EV_PAID type ABAP_BOOL
    raising
      ZCXTM_GKO_PROCESS .
  methods SET_CANCEL
    raising
      ZCXTM_GKO_PROCESS .
  methods SET_INVOICE_AS_PAID
    importing
      !IV_AUGDT type ZTTM_GKOT001-AUGDT
      !IV_PAGO type ZTTM_GKOT001-PAGO .
  methods SET_INVOICE_DATA
    importing
      !IV_NUM_FATURA type ZTTM_GKOT001-NUM_FATURA
      !IV_VCT_GKO type ZTTM_GKOT001-VCT_GKO
      !IV_USR_LIB type ZTTM_GKOT001-USR_LIB .
  methods SET_INVOICE_GROUPING
    importing
      !IV_NUM_FATURA type ZTTM_GKOT001-NUM_FATURA
      !IV_VCT_GKO type ZTTM_GKOT001-VCT_GKO
      !IV_USR_LIB type ZTTM_GKOT001-USR_LIB
      !IV_BUKRS type ZTTM_GKOT001-BUKRS_DOC
      !IV_BELNR type ZTTM_GKOT001-BELNR
      !IV_GJAHR type ZTTM_GKOT001-GJAHR
      !IV_DESCONTO type WRBTR optional .
  methods SET_INVOICE_REGISTERED .
  methods SET_PO
    importing
      !IV_PO_NUMBER type EKKO-EBELN
      !IT_PO_ITEM type TY_T_PO_ITEM .
  methods SET_PO_APPROVED .
  methods SET_REVERSAL_INVOICE_GROUPING
    raising
      ZCXTM_GKO_PROCESS .
  methods SET_STATUS
    importing
      !IV_STATUS type ZE_GKO_CODSTATUS
      !IV_NEWDOC type ZTTM_GKOT006-NEWDOC optional
      !IV_CODIGO type ZTTM_GKOT006-CODIGO optional
      !IV_DESC_COD type ZTTM_GKOT006-DESC_CODIGO optional
      !IT_BAPI_RET type BAPIRET2_T optional .
  methods SET_STATUS_PAYMENT
    importing
      !IV_AUGDT type ZTTM_GKOT001-AUGDT
      !IV_PAGO type ZTTM_GKOT001-PAGO .
  class-methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .
    "! Recupera detalhes do XML, utilizado no relatório
    "! @parameter ct_cte | Formulário CTE
  methods FILL_RELATORIO_CTE
    changing
      !CT_CTE type TY_T_FORMULARIO_CTE
    raising
      ZCXTM_GKO_PROCESS .
    "! Monta o relatório CTE - Componentes do Valor da Prestação do Serviço
    "! @parameter iv_filter | Filtro de seleção
    "! @parameter et_comp | Tabela de dados complementares
  methods FILL_RELATORIO_CTE_COMP
    importing
      !IV_FILTER type STRING
    exporting
      !ET_COMP type TY_T_COMP
    raising
      ZCXTM_GKO_PROCESS .
    "! Monta o relatório CTE - Quantidade de carga
    "! @parameter iv_filter | Filtro de seleção
    "! @parameter et_carga| Tabela de quantidade de carga
  methods FILL_RELATORIO_CTE_CARGA
    importing
      !IV_FILTER type STRING
    exporting
      !ET_CARGA type TY_T_CARGA
    raising
      ZCXTM_GKO_PROCESS .
  methods FATURAR_ETAPA
    importing
      !IV_TORID type /SCMTMS/TOR_ID .
  methods FATURAR_ETAPA_V2 .
  methods FATURAR_ETAPA_VALID_CALC_CUSTO
    importing
      !IV_TORID type /SCMTMS/TOR_ID
    returning
      value(RV_SUCCESS) type FLAG .
  methods VALIDATE_PO_MIRO
    importing
      !IT_ITEM_DATA type TY_T_MIRO_ITEMDATA
    raising
      ZCXTM_GKO_PROCESS .
  methods ATTACH_IS_VALID
    returning
      value(RV_VALID) type ABAP_BOOL
    raising
      ZCXTM_GKO_PROCESS .
  methods CHECK_DOC_ORIG_IS_POSTED
    raising
      ZCXTM_GKO_PROCESS .
  class-methods DETERMINA_CONFIGURACAO_P013
    importing
      !IV_ACCKEY type ZTTM_GKOT001-ACCKEY optional
      !IV_TOR_ID type ZTTM_GKOT001-TOR_ID optional
      !IS_HEADER type ZTTM_GKOT001 optional
    exporting
      !ES_HEADER type ZTTM_GKOT001
      !EV_TOM_BRANCH type T001W-J_1BBRANCH
      !EV_REM_BRANCH type T001W-J_1BBRANCH
      !EV_DEST_BRANCH type T001W-J_1BBRANCH
      !ES_P013 type ZTTM_PCOCKPIT013 .
    "! Recupera parâmetro na tabela de parâmetros
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
  methods GET_T_PARAMETER
    importing
      !IS_PARAM type ZTCA_PARAM_VAL
    exporting
      !ET_VALUE type ANY .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
  methods GET_CONFIGURATION
    exporting
      !ES_PARAMETER type TY_PARAMETER
      !ET_RETURN type BAPIRET2_T .
  methods EXTRA_CHARGE_AND_STEP .
  methods RELEASE_CHARGE_STEP
    importing
      !IS_GKO_HEADER type ZTTM_GKOT001
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods GET_MESSAGE
    importing
      !IO_MESSAGE type ref to /BOBF/IF_FRW_MESSAGE
    changing
      !CT_RETURN type BAPIRET2_T .
  class-methods DETERMINE_CHARGE
    importing
      !IS_GKO_HEADER type ZTTM_GKOT001
    returning
      value(RV_EVENTO) type /SCMTMS/TRCHARG_ELMNT_TYPECD .
  methods CHECK_DOC_MEMO_MIRO .
  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA gt_gko_references TYPE ty_t_zgkot003 .
    DATA gt_gko_attachments TYPE ty_t_zgkot002 .
    DATA gt_gko_acckey_po TYPE ty_t_zgkot005 .
    DATA gt_gko_acckey_po_del TYPE ty_t_zgkot005 .
    DATA gt_gko_logs TYPE ty_t_zgkot006 .
    DATA gt_gko_events TYPE ty_t_zgkot007 .
    DATA gs_gko_compl TYPE zttm_gkot004 .
    DATA:
      gt_009_del TYPE STANDARD TABLE OF zttm_gkot009 .
    DATA gs_parameter TYPE ty_parameter .
*  data GS_NFS_DATA type ANY .
    DATA gs_nfs_data TYPE zclsd_dt_nota_fiscal_servico .
    DATA gv_acckey TYPE zttm_gkot001-acckey .
    DATA gv_xml_content TYPE j_1b_nfe_xml_content .
    DATA gv_tpprocess TYPE ze_gko_tpprocess .
    DATA gv_wo_lock TYPE abap_bool .
    DATA gv_min_data_load TYPE abap_bool .
    DATA go_xslt_processor TYPE REF TO cl_xslt_processor .
    DATA gv_locked_in_tab TYPE abap_bool .
    CLASS-DATA gv_wait_async TYPE abap_bool .
    CLASS-DATA gv_check TYPE abap_bool .
    CLASS-DATA gt_sfir_id TYPE /scmtms/t_sfir_id .
    CLASS-DATA gv_success TYPE char1 .
    CLASS-DATA gt_return TYPE bapiret2_t .
    CLASS-DATA gt_bapi_return TYPE bapiret2_t .
    CLASS-DATA gv_invnumber_reversal TYPE bapi_incinv_fld-inv_doc_no .
    CLASS-DATA gv_fiscalyear_reversal TYPE bapi_incinv_fld-fisc_year .
    CLASS-DATA gv_success2 TYPE char1 .
    CLASS-DATA gv_subrc TYPE sy-subrc .
    CLASS-DATA gs_return TYPE bapiret2 .
    CLASS-DATA gt_itemdata TYPE bapi_incinv_create_item_t .
    CLASS-DATA gv_belnr TYPE re_belnr .
    CLASS-DATA gv_gjahr TYPE gjahr .
    CONSTANTS gc_msg_id TYPE sy-msgid VALUE 'ZTM_GKO' ##NO_TEXT.
    CONSTANTS gc_error TYPE sy-msgty VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_sucess TYPE sy-msgty VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_msg_of_ident TYPE sy-msgno VALUE '099' ##NO_TEXT.
    CONSTANTS gc_msg_transp_err TYPE sy-msgno VALUE '100' ##NO_TEXT.

    METHODS set_reject
      IMPORTING
        !iv_cteid    TYPE /xnfe/cteid
        !iv_not_code TYPE /xnfe/not_code
      EXPORTING
        !ev_rc       TYPE syst_subrc
        !ev_message  TYPE bapi_msg .
    METHODS status_check
      IMPORTING
        !iv_cteid       TYPE /xnfe/id
      EXPORTING
        !es_infprot     TYPE /xnfe/infprot_cte_status
        !et_events_prot TYPE /xnfe/events_prot_t
        !ev_subrc       TYPE syst_subrc .
    METHODS check_doc_is_valid
      EXPORTING
        !ev_acabado TYPE char1
      RAISING
        zcxtm_gko_process .
    METHODS check_miro_registered .
    METHODS check_po_approved .
    METHODS check_status_sefaz .
    METHODS check_estorno_dff .
    METHODS check_dff_confirmed.
    METHODS clear_reversal_fi_documents
      IMPORTING
        !iv_re_belnr  TYPE zttm_gkot001-re_belnr
        !iv_re_gjahr  TYPE zttm_gkot001-re_gjahr
        !iv_rev_belnr TYPE zttm_gkot001-re_belnr
        !iv_rev_gjahr TYPE zttm_gkot001-re_gjahr
      EXPORTING
        !et_return    TYPE bapiret2_t .
    METHODS clear_reversal_fi_documents_ex
      IMPORTING
        !iv_re_belnr  TYPE zttm_gkot001-re_belnr
        !iv_re_gjahr  TYPE zttm_gkot001-re_gjahr
        !iv_rev_belnr TYPE zttm_gkot001-re_belnr
        !iv_rev_gjahr TYPE zttm_gkot001-re_gjahr
      EXPORTING
        !et_return    TYPE bapiret2_t .
    METHODS create_miro_po
      IMPORTING
        !iv_invoicestatus TYPE rbstat .
    METHODS create_miro_subsequent_debit
      IMPORTING
        !iv_invoicestatus TYPE rbstat .
    METHODS dequeue_acckey .
    METHODS enqueue_acckey
      IMPORTING
        !iv_locked_in_tab TYPE abap_bool
      RAISING
        zcxtm_gko_process .
    METHODS fill_add_data .
    METHODS fill_data_cte
      RAISING
        zcxtm_gko_process .
    METHODS fill_data_nfs
      RAISING
        zcxtm_gko_process .
    METHODS get_account_cost_center
      EXPORTING
        !ev_saknr TYPE zttm_pcockpit013-saknr
        !ev_kostl TYPE zttm_pcockpit013-kostl
      RAISING
        zcxtm_gko_process .
    METHODS get_desc_attach_type
      IMPORTING
        !iv_attach_type LIKE zcltm_gko_process=>gc_attach_type-comp_pgto_gnre
      RETURNING
        VALUE(rv_desc)  TYPE val_text .
    METHODS get_emit_vendor
      RETURNING
        VALUE(rv_vendor) TYPE lifnr
      RAISING
        zcxtm_gko_process .
    METHODS get_items_post_others
      IMPORTING
        !it_nf_saida   TYPE ty_t_j_1bnflin
      CHANGING
        !ct_items_post TYPE ty_t_items_post .
    METHODS get_items_post_transferencia
      IMPORTING
        !it_nf_saida   TYPE ty_t_j_1bnflin
      CHANGING
        !ct_items_post TYPE ty_t_items_post .
    METHODS get_items_post_venda_coligada
      IMPORTING
        !it_nf_saida   TYPE ty_t_j_1bnflin
      CHANGING
        !ct_items_post TYPE ty_t_items_post .
    METHODS get_items_post_wo_pa
      IMPORTING
        !it_nf_saida   TYPE ty_t_j_1bnflin
      CHANGING
        !ct_items_post TYPE ty_t_items_post .
    METHODS get_iva_detailed
      IMPORTING
        !it_items_post TYPE ty_t_items_post
        !iv_saknr      TYPE zttm_pcockpit013-saknr OPTIONAL
      RETURNING
        VALUE(rt_iva)  TYPE ty_t_po_iva_detailed
      RAISING
        zcxtm_gko_process .
    METHODS get_iva_from_info_record
      RETURNING
        VALUE(rv_iva) TYPE mwskz .
    METHODS get_iva_unified
      IMPORTING
        !iv_saknr     TYPE zttm_pcockpit013-saknr OPTIONAL
      RETURNING
        VALUE(rv_iva) TYPE mwskz
      RAISING
        zcxtm_gko_process .
    METHODS get_miro_nf_type
      IMPORTING
        !iv_saknr         TYPE zttm_pcockpit013-saknr OPTIONAL
      RETURNING
        VALUE(rv_nf_type) TYPE bapi_incinv_create_header-j_1bnftype
      RAISING
        zcxtm_gko_process .
    METHODS get_miro_po_item_data
      RETURNING
        VALUE(rt_item_data) TYPE ty_t_miro_itemdata
      RAISING
        zcxtm_gko_process .
    METHODS get_miro_po_payment_condition
      RETURNING
        VALUE(rv_payment_condition) TYPE bapi_incinv_create_header-pmnttrms .
    METHODS get_miro_ref_doc_no
      RETURNING
        VALUE(rv_ref_doc_no) TYPE bapi_incinv_create_header-ref_doc_no .
    METHODS get_miro_sub_payment_condition
      RETURNING
        VALUE(rv_pmnttrms) TYPE bapi_incinv_create_header-pmnttrms
      RAISING
        zcxtm_gko_process .
    METHODS get_po_material_data
      IMPORTING
        !iv_werks               TYPE t001w-werks
      RETURNING
        VALUE(rv_material_data) TYPE ty_s_material_data
      RAISING
        zcxtm_gko_process .
    METHODS get_po_werks
      EXPORTING
        !et_werks       TYPE t_werks
      RETURNING
        VALUE(rv_werks) TYPE t001w-werks
      RAISING
        zcxtm_gko_process .
    METHODS identify_scenario .
    METHODS identify_freight_order .
    METHODS load_data_from_acckey
      RAISING
        zcxtm_gko_process .
    METHODS load_gko_attachments .
    METHODS load_gko_logs .
    METHODS load_gko_po .
    METHODS load_gko_references .
    METHODS read_file
      IMPORTING
        !iv_file_name          TYPE string
      RETURNING
        VALUE(rv_file_content) TYPE xstring
      RAISING
        zcxtm_gko_process .
    METHODS reversal_documents .
    METHODS send_cte_to_gko
      RAISING
        zcxtm_gko_process .
    METHODS extra_charge .
    METHODS extra_charge_v2.
    METHODS calc_custo_tor
      IMPORTING
        !is_gko_header TYPE zttm_gkot001 .
    METHODS check_dff
      IMPORTING
        !iv_torid       TYPE /scmtms/tor_id
      RETURNING
        VALUE(rv_check) TYPE abap_boolean .
    METHODS create_miro.
    METHODS create_extra_charge_and_step.

    METHODS get_partner
      IMPORTING iv_cnpj    TYPE dfkkbptaxnum-taxnum
                iv_cpf     TYPE dfkkbptaxnum-taxnum OPTIONAL
                iv_ie      TYPE dfkkbptaxnum-taxnum OPTIONAL
      EXPORTING ev_partner TYPE any.
ENDCLASS.



CLASS ZCLTM_GKO_PROCESS IMPLEMENTATION.


  METHOD read_file.

    DATA: lt_file_tab      TYPE swxmlcont,
          lv_file_line     TYPE xstring,
          lv_filelength    TYPE i,
          lv_actual_length TYPE i,
          lv_message       TYPE string.

    IF sy-batch IS INITIAL.

      cl_gui_frontend_services=>gui_upload(
        EXPORTING
          filename                = iv_file_name
          filetype                = 'BIN'
        IMPORTING
          filelength              = lv_filelength
        CHANGING
          data_tab                = lt_file_tab
        EXCEPTIONS
          file_open_error         = 1
          file_read_error         = 2
          no_batch                = 3
          gui_refuse_filetransfer = 4
          invalid_type            = 5
          no_authority            = 6
          unknown_error           = 7
          bad_data_format         = 8
          header_not_allowed      = 9
          separator_not_allowed   = 10
          header_too_long         = 11
          unknown_dp_error        = 12
          access_denied           = 13
          dp_out_of_memory        = 14
          disk_full               = 15
          dp_timeout              = 16
          not_supported_by_gui    = 17
          error_no_gui            = 18
          OTHERS                  = 19 ).

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            gt_bapi_return = VALUE #( ( id         = sy-msgid
                                        number     = sy-msgno
                                        type       = sy-msgty
                                        message_v1 = sy-msgv1
                                        message_v2 = sy-msgv2
                                        message_v3 = sy-msgv3
                                        message_v4 = sy-msgv4 ) ).
      ENDIF.

      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          input_length = lv_filelength
        IMPORTING
          buffer       = rv_file_content
        TABLES
          binary_tab   = lt_file_tab
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            gt_bapi_return = VALUE #( ( id         = sy-msgid
                                        number     = sy-msgno
                                        type       = sy-msgty
                                        message_v1 = sy-msgv1
                                        message_v2 = sy-msgv2
                                        message_v3 = sy-msgv3
                                        message_v4 = sy-msgv4 ) ).
      ENDIF.

    ELSE.

      OPEN DATASET iv_file_name FOR INPUT IN BINARY MODE
                                MESSAGE lv_message.

      IF sy-subrc <> 0.
        " Erro ao abrir o arquivo &, &.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            textid   = zcxtm_gko_process=>gc_error_on_open_file
            gv_msgv1 = CONV #( iv_file_name )
            gv_msgv2 = CONV #( lv_message ).
      ENDIF.

      READ DATASET iv_file_name INTO rv_file_content.
      CLOSE DATASET iv_file_name.

    ENDIF.

  ENDMETHOD.


  METHOD process_payment.

    TYPES: ty_ausz1 TYPE ausz1_tab,
           ty_ausz2 TYPE ausz2_tab,
           ty_bseg2 TYPE bseg_t.

    DATA: lt_bseg  TYPE ty_bseg2,
          lt_bseg2 TYPE ty_bseg2.

    DATA: lr_hkont TYPE RANGE OF bseg-hkont,
          lr_bukrs TYPE RANGE OF bukrs.

    DATA(lt_doc) = it_doc.

    lr_bukrs = VALUE #( FOR ls_doc IN lt_doc ( sign   = 'I'
                                               option = 'EQ'
                                               low    = ls_doc-bukrs ) ).

    SORT lr_bukrs BY low ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lr_bukrs COMPARING low.

    " Selecionar contas bancarias
    SELECT bukrs, hkont
      FROM t012k
      INTO TABLE @DATA(lt_t012k)
     WHERE bukrs IN @lr_bukrs.

    SORT lt_t012k BY bukrs ASCENDING hkont ASCENDING.

    DELETE ADJACENT DUPLICATES FROM lt_t012k COMPARING bukrs hkont.

    LOOP AT lt_t012k ASSIGNING FIELD-SYMBOL(<fs_t012k>).

      " BR - Entrada
      DATA(ls_ikofi_in) = VALUE ikofi( anwnd = '0001'
                                       eigr1 = 'B00D'
                                       eigr2 = '1'
                                       komo1 = '+'
                                       komo2 = 'BRL'
                                       ktopl = 'PC01'
                                       sakin = <fs_t012k>-hkont ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_in-anwnd
          i_eigr1  = ls_ikofi_in-eigr1
          i_eigr2  = ls_ikofi_in-eigr2
          i_eigr3  = ls_ikofi_in-eigr3
          i_eigr4  = ls_ikofi_in-eigr4
          i_komo1  = ls_ikofi_in-komo1
          i_komo1b = ls_ikofi_in-komo1b
          i_komo2  = ls_ikofi_in-komo2
          i_komo2b = ls_ikofi_in-komo2b
          i_ktopl  = ls_ikofi_in-ktopl
          i_sakin  = ls_ikofi_in-sakin
          i_sakinb = ls_ikofi_in-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_in
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc IS INITIAL
     AND ls_ikofi_in-sakn1 IS NOT INITIAL.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING FIELD-SYMBOL(<fs_r_hkont>).
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_in-sakn1.
      ENDIF.

      " BR - Saida
      DATA(ls_ikofi_out) = VALUE ikofi( anwnd = '0001'
                                        eigr1 = 'B00C'
                                        eigr2 = '1'
                                        komo1 = '+'
                                        komo2 = 'BRL'
                                        ktopl = 'PC01'
                                        sakin = <fs_t012k>-hkont ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_out-anwnd
          i_eigr1  = ls_ikofi_out-eigr1
          i_eigr2  = ls_ikofi_out-eigr2
          i_eigr3  = ls_ikofi_out-eigr3
          i_eigr4  = ls_ikofi_out-eigr4
          i_komo1  = ls_ikofi_out-komo1
          i_komo1b = ls_ikofi_out-komo1b
          i_komo2  = ls_ikofi_out-komo2
          i_komo2b = ls_ikofi_out-komo2b
          i_ktopl  = ls_ikofi_out-ktopl
          i_sakin  = ls_ikofi_out-sakin
          i_sakinb = ls_ikofi_out-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_out
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc IS INITIAL
     AND ls_ikofi_out-sakn1 IS NOT INITIAL.
        UNASSIGN <fs_r_hkont>.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING <fs_r_hkont>.
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_out-sakn1.
      ENDIF.
    ENDLOOP.

    " Identificar Documento de compensação e pagamento
    DO 4 TIMES.

      IF lt_doc IS INITIAL.
        EXIT.
      ENDIF.

      " Selecionar informações do documento de FI
      SELECT bukrs,
             belnr,
             gjahr,
             augdt,
             augbl,
             hkont
        FROM bseg
        INTO CORRESPONDING FIELDS OF TABLE @lt_bseg2
        FOR ALL ENTRIES IN @lt_doc
        WHERE bukrs = @lt_doc-bukrs_doc
          AND belnr = @lt_doc-belnr
          AND gjahr = @lt_doc-gjahr.

      CHECK sy-subrc IS INITIAL.

      CLEAR: lt_doc.

      LOOP AT lt_bseg2 INTO DATA(ls_bseg_aux).

        CHECK ls_bseg_aux-belnr <> ls_bseg_aux-augbl.

        LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg>) WHERE augbl = ls_bseg_aux-belnr.
          IF ls_bseg_aux-hkont IN lr_hkont.
            <fs_bseg>-hkont = ls_bseg_aux-hkont.
          ENDIF.

          IF NOT ls_bseg_aux-augbl IS INITIAL.
            <fs_bseg>-augbl = ls_bseg_aux-augbl.
          ENDIF.
        ENDLOOP.

        IF NOT sy-subrc IS INITIAL.
          APPEND INITIAL LINE TO lt_bseg ASSIGNING <fs_bseg>.
          <fs_bseg> = ls_bseg_aux.
        ENDIF.

        IF NOT ls_bseg_aux-augbl IS INITIAL.
          APPEND INITIAL LINE TO lt_doc ASSIGNING FIELD-SYMBOL(<fs_doc>).
          <fs_doc>-bukrs_doc = ls_bseg_aux-bukrs.
          <fs_doc>-belnr     = ls_bseg_aux-augbl.
          <fs_doc>-gjahr     = ls_bseg_aux-augdt(4).
        ENDIF.

        UNASSIGN: <fs_doc>, <fs_bseg>.
      ENDLOOP.

      CLEAR: lt_bseg2.

      DELETE ADJACENT DUPLICATES FROM lt_doc COMPARING belnr.
    ENDDO.

    CHECK NOT lt_bseg IS INITIAL.

    DATA(lt_bseg_aux) = lt_bseg.

    DELETE lt_bseg_aux WHERE augbl = abap_false.

    LOOP AT lt_bseg_aux INTO DATA(ls_bseg).

      CHECK ls_bseg-belnr <> ls_bseg-augbl.

      DATA(lt_ausz1) = VALUE ty_ausz1( ( bukrs = ls_bseg-bukrs
                                         belnr = ls_bseg-belnr
                                         gjahr = ls_bseg-gjahr ) ).

      DATA(lt_ausz2) = VALUE ty_ausz2( ( bukrs = ls_bseg-bukrs
                                         augdt = ls_bseg-augdt
                                         augbl = ls_bseg-augbl ) ).

      lt_bseg2 = VALUE ty_bseg2( FOR ls_bseg2 IN lt_bseg WHERE ( bukrs = ls_bseg-bukrs AND belnr = ls_bseg-belnr AND gjahr = ls_bseg-gjahr )
                                                               ( bukrs = ls_bseg-bukrs
                                                                 belnr = ls_bseg-belnr
                                                                 gjahr = ls_bseg-gjahr
                                                                 hkont = ls_bseg-hkont ) ).

      TRY.
          DATA(lr_gko_process) = NEW zcltm_gko_process( ).
          lr_gko_process->send_date_payment_to_gko( it_ausz1 = lt_ausz1[]
                                                    it_ausz2 = lt_ausz2[]
                                                    it_bseg  = lt_bseg2[] ).
        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD process.

    " Recupera documentos listados no cockpit
    SELECT SINGLE acckey, tor_id, lblni, num_fatura, rbstat
      FROM zi_tm_cockpit001
      WHERE acckey = @gs_gko_header-acckey
      INTO @DATA(ls_cockpit).

    IF sy-subrc NE 0.
      CLEAR ls_cockpit.
    ENDIF.

    CASE gs_gko_header-codstatus.

      WHEN gc_codstatus-aguardando_dados_adicionais.

        fill_add_data( ).

      WHEN gc_codstatus-documento_integrado.

        identify_freight_order( ).

        IF gs_gko_header-codstatus EQ gc_codstatus-of_identificada.

          identify_scenario( ).

        ENDIF.

      WHEN gc_codstatus-cenario_identificado.

        " Verifica Ordem de frete
        IF ls_cockpit-tor_id IS INITIAL.
          me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-documento_integrado ).
          RETURN.
        ENDIF.

        " Se Folha de Serviço já está criado, não há necessidade criar documento
        IF ls_cockpit-lblni IS NOT INITIAL.
          me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-frete_faturado ).
          RETURN.
        ENDIF.

        " ------------------------------------------------
        " Processo para cálculo de custo na ordem de frete
        " ------------------------------------------------
        me->calc_custo_tor( EXPORTING is_gko_header = gs_gko_header ).

        IF me->check_dff( iv_torid = gs_gko_header-tor_id ) EQ abap_true.

* BEGIN OF CHANGE - JWSILVA - 29.02.2023
          " ------------------------------------------------
          " Processo para criação do custo extra e faturamento da ordem de frete
          " ------------------------------------------------
          IF gs_gko_header-codstatus EQ gc_codstatus-calculo_custo_efetuado.
            me->create_extra_charge_and_step( ).
          ENDIF.
* END OF CHANGE - JWSILVA - 29.02.2023

        ENDIF.

        " ------------------------------------------------------------------------------
        " Caso o Documento de faturamente de frete (DFF) já foi criado, atualizar status
        " ------------------------------------------------------------------------------
        IF ls_cockpit-num_fatura IS NOT INITIAL AND ls_cockpit-rbstat = '5'.        " Registrado

          me->set_status( EXPORTING iv_status  = me->gc_codstatus-miro_confirmada ).
          RETURN.

        ELSEIF ls_cockpit-num_fatura IS NOT INITIAL AND ls_cockpit-rbstat = 'D'.    " Memorizado e entrado

          me->set_status( EXPORTING iv_status  = me->gc_codstatus-miro_memorizada ).
          RETURN.
        ENDIF.

      WHEN gc_codstatus-calculo_custo_efetuado.

        IF me->check_dff( iv_torid = gs_gko_header-tor_id ) EQ abap_true.

* BEGIN OF CHANGE - JWSILVA - 29.02.2023
          " ------------------------------------------------
          " Processo para criação do custo extra e faturamento da ordem de frete
          " ------------------------------------------------
          IF gs_gko_header-codstatus EQ gc_codstatus-calculo_custo_efetuado.
            me->create_extra_charge_and_step( ).
          ENDIF.
* END OF CHANGE - JWSILVA - 29.02.2023

        ENDIF.

      WHEN gc_codstatus-miro_memorizada.

        check_miro_registered( ).

      WHEN gc_codstatus-evt_rejeicao_aguard_sefaz.

        check_status_sefaz( ).

      WHEN gc_codstatus-documento_cancelado.

        reversal_documents( ).

      WHEN gc_codstatus-frete_faturado.

        me->create_miro( ).

      WHEN gc_codstatus-aguardando_estorno_dff.

        me->check_estorno_dff( ).

      WHEN gc_codstatus-aguardando_reagrupamento.

        me->check_estorno_dff( ).

      WHEN gc_codstatus-aguardando_faturamento_frete.

        me->check_dff_confirmed( ).

    ENDCASE.

  ENDMETHOD.


  METHOD print_dacte_from_xstring.

    DATA: ls_dados_dacte        TYPE zstm_gko_008,
          lv_smartforms_fm_name TYPE rs38l_fnam.

    DEFINE _fill_tmd_data.
      ls_dados_dacte-tmd_nome   = ls_dados_dacte-&1_nome.
      ls_dados_dacte-tmd_cnpj   = ls_dados_dacte-&1_cnpj.
      ls_dados_dacte-tmd_cpf    = ls_dados_dacte-&1_cpf.
      ls_dados_dacte-tmd_ie     = ls_dados_dacte-&1_ie.
      ls_dados_dacte-tmd_fone   = ls_dados_dacte-&1_fone.
      ls_dados_dacte-tmd_lgr    = ls_dados_dacte-&1_lgr.
      ls_dados_dacte-tmd_nro    = ls_dados_dacte-&1_nro.
      ls_dados_dacte-tmd_bairro = ls_dados_dacte-&1_bairro.
      ls_dados_dacte-tmd_mun    = ls_dados_dacte-&1_mun.
      ls_dados_dacte-tmd_uf     = ls_dados_dacte-&1_uf.
      ls_dados_dacte-tmd_cep    = ls_dados_dacte-&1_cep.
      ls_dados_dacte-tmd_pais   = ls_dados_dacte-&1_pais.
    END-OF-DEFINITION.

    DEFINE _fill_dacte_from_xml.
      IF &3 <> ''.
        ls_dados_dacte-&1 = get_value_from_xml( iv_xml        = iv_xml
                                                iv_expression = &2     ) && | - | &&
                            get_value_from_xml( iv_xml        = iv_xml
                                                iv_expression = &3     ).
      ELSE.
        ls_dados_dacte-&1 = get_value_from_xml( iv_xml        = iv_xml
                                                iv_expression = &2     ).
      ENDIF.
    END-OF-DEFINITION.

    _fill_dacte_from_xml: chcte            '//*:protCTe/*:infProt/*:chCTe'       '',
                          cfop             '//*:CFOP'                            '',
                          nprot            '//*:nProt'                           '',
                          dhrecbto         '//*:dhRecbto'                        '',
                          xobs             '//*:xObs'                            '',
                          tomador          '//*:ide//*:toma'                     '',
                          natop            '//*:ide/*:natOp'                     '',
                          nfenum           '//*:ide/*:nCT'                       '',
                          serie            '//*:ide/*:serie'                     '',
                          modal            '//*:ide/*:modal'                     '',
                          model            '//*:ide/*:mod'                       '',
                          dhemi            '//*:ide/*:dhEmi'                     '',
                          tpcte            '//*:ide/*:tpCTe'                     '',
                          tpserv           '//*:ide/*:tpServ'                    '',
                          inicio_prestsrv  '//*:ide/*:xMunIni'                   '//*:ide/*:UFIni',
                          termino_prestsrv '//*:ide/*:xMunFim'                   '//*:ide/*:UFFim',
                          isuf             '//*:dest/*:ISUF'                     '',
                          propred          '//*:infCTeNorm/*:infCarga/*:proPred' '',
                          xoutcat          '//*:infCTeNorm/*:infCarga/*:xOutCat' '',
                          vcarga           '//*:infCTeNorm/*:infCarga/*:vCarga'  '',
                          xseg             '//*:infCTeNorm/*:seg/*:xSeg'         '',
                          respseg          '//*:infCTeNorm/*:seg/*:respSeg'      '',
                          napol            '//*:infCTeNorm/*:seg/*:nApol'        '',
                          naver            '//*:infCTeNorm/*:seg/*:nAver'        '',
                          vtprest          '//*:vPrest/*:vTPrest'                '',
                          vrec             '//*:vPrest/*:vRec'                   '',
                          chcte_compl      '//*:infCteComp/*:chCTe'              '',
                          cst              '//*:imp//*:CST'                      '',
                          vicmsstret       '//*:imp//*:vICMSSTRet'               '',
                          rntrc            '//*:rodo/*:RNTRC'                    '',
                          ciot             '//*:rodo/*:CIOT'                     '',
                          dprev            '//*:rodo/*:dPrev'                    '',
                          emit_nome        '//*:emit/*:xNome'                    '',
                          emit_cnpj        '//*:emit/*:CNPJ'                     '',
                          emit_cpf         '//*:emit/*:CPF'                      '',
                          emit_ie          '//*:emit/*:IE'                       '',
                          emit_lgr         '//*:emit/*:enderEmit/*:xLgr'         '',
                          emit_nro         '//*:emit/*:enderEmit/*:nro'          '',
                          emit_bairro      '//*:emit/*:enderEmit/*:xBairro'      '',
                          emit_mun         '//*:emit/*:enderEmit/*:xMun'         '',
                          emit_uf          '//*:emit/*:enderEmit/*:UF'           '',
                          emit_cep         '//*:emit/*:enderEmit/*:CEP'          '',
                          emit_pais        '//*:emit/*:enderEmit/*:xPais'        '',
                          emit_fone        '//*:emit/*:enderEmit/*:fone'         '',
                          rem_nome         '//*:rem/*:xNome'                     '',
                          rem_cnpj         '//*:rem/*:CNPJ'                      '',
                          rem_cpf          '//*:rem/*:CPF'                       '',
                          rem_ie           '//*:rem/*:IE'                        '',
                          rem_fone         '//*:rem/*:fone'                      '',
                          rem_lgr          '//*:rem/*:enderReme/*:xLgr'          '',
                          rem_nro          '//*:rem/*:enderReme/*:nro'           '',
                          rem_bairro       '//*:rem/*:enderReme/*:xBairro'       '',
                          rem_mun          '//*:rem/*:enderReme/*:xMun'          '',
                          rem_uf           '//*:rem/*:enderReme/*:UF'            '',
                          rem_cep          '//*:rem/*:enderReme/*:CEP'           '',
                          rem_pais         '//*:rem/*:enderReme/*:xPais'         '',
                          dest_nome        '//*:dest/*:xNome'                    '',
                          dest_cnpj        '//*:dest/*:CNPJ'                     '',
                          dest_cpf         '//*:dest/*:CPF'                      '',
                          dest_ie          '//*:dest/*:IE'                       '',
                          dest_fone        '//*:dest/*:fone'                     '',
                          dest_lgr         '//*:dest/*:enderDest/*:xLgr'         '',
                          dest_nro         '//*:dest/*:enderDest/*:nro'          '',
                          dest_bairro      '//*:dest/*:enderDest/*:xBairro'      '',
                          dest_mun         '//*:dest/*:enderDest/*:xMun'         '',
                          dest_uf          '//*:dest/*:enderDest/*:UF'           '',
                          dest_cep         '//*:dest/*:enderDest/*:CEP'          '',
                          dest_pais        '//*:dest/*:enderDest/*:xPais'        '',
                          exp_nome         '//*:exped/*:xNome'                   '',
                          exp_cnpj         '//*:exped/*:CNPJ'                    '',
                          exp_cpf          '//*:exped/*:CPF'                     '',
                          exp_ie           '//*:exped/*:IE'                      '',
                          exp_fone         '//*:exped/*:fone'                    '',
                          exp_lgr          '//*:exped/*:enderExped/*:xLgr'       '',
                          exp_nro          '//*:exped/*:enderExped/*:nro'        '',
                          exp_bairro       '//*:exped/*:enderExped/*:xBairro'    '',
                          exp_mun          '//*:exped/*:enderExped/*:xMun'       '',
                          exp_uf           '//*:exped/*:enderExped/*:UF'         '',
                          exp_cep          '//*:exped/*:enderExped/*:CEP'        '',
                          exp_pais         '//*:exped/*:enderExped/*:xPais'      '',
                          rec_nome         '//*:receb/*:xNome'                   '',
                          rec_cnpj         '//*:receb/*:CNPJ'                    '',
                          rec_cpf          '//*:receb/*:CPF'                     '',
                          rec_ie           '//*:receb/*:IE'                      '',
                          rec_fone         '//*:receb/*:fone'                    '',
                          rec_lgr          '//*:receb/*:enderReceb/*:xLgr'       '',
                          rec_nro          '//*:receb/*:enderReceb/*:nro'        '',
                          rec_bairro       '//*:receb/*:enderReceb/*:xBairro'    '',
                          rec_mun          '//*:receb/*:enderReceb/*:xMun'       '',
                          rec_uf           '//*:receb/*:enderReceb/*:UF'         '',
                          rec_cep          '//*:receb/*:enderReceb/*:CEP'        '',
                          rec_pais         '//*:receb/*:enderReceb/*:xPais'      ''.

    CASE ls_dados_dacte-tomador.
      WHEN '0'. "Remetente
        _fill_tmd_data rem.
      WHEN '1'. "Expedidor
        _fill_tmd_data exp.
      WHEN '2'. "Recebedor
        _fill_tmd_data rec.
      WHEN '3'. "Destinatário
        _fill_tmd_data dest.
      WHEN '4'. "Outros
        _fill_dacte_from_xml: tmd_nome   '//*:toma4/*:xNome'               '',
                              tmd_cnpj   '//*:toma4/*:CNPJ'                '',
                              tmd_cpf    '//*:toma4/*:CPF'                 '',
                              tmd_ie     '//*:toma4/*:IE'                  '',
                              tmd_fone   '//*:toma4/*:fone'                '',
                              tmd_lgr    '//*:toma4/*:enderToma/*:xLgr'    '',
                              tmd_nro    '//*:toma4/*:enderToma/*:nro'     '',
                              tmd_bairro '//*:toma4/*:enderToma/*:xBairro' '',
                              tmd_mun    '//*:toma4/*:enderToma/*:xMun'    '',
                              tmd_uf     '//*:toma4/*:enderToma/*:UF'      '',
                              tmd_cep    '//*:toma4/*:enderToma/*:CEP'     '',
                              tmd_pais   '//*:toma4/*:enderToma/*:xPais'   ''.
    ENDCASE.

    _fill_dacte_from_xml: vbcicms '//*:imp/*:ICMS//*:vBC'    '',
                          picms   '//*:imp/*:ICMS//*:pICMS'  '',
                          vicms   '//*:imp/*:ICMS//*:vICMS'  '',
                          predbc  '//*:imp/*:ICMS//*:pRedBC' ''.

    IF ls_dados_dacte-vbcicms IS INITIAL.
      _fill_dacte_from_xml: vbcicms '//*:imp/*:ICMS/*:ICMS60/*:vBCSTRet' ''.
      IF ls_dados_dacte-vbcicms IS INITIAL.
        _fill_dacte_from_xml: vbcicms '//*:imp/*:ICMS/*:ICMSOutraUF/*:vBCOutraUF' ''.
      ENDIF.
    ENDIF.

    IF ls_dados_dacte-picms IS INITIAL.
      _fill_dacte_from_xml: picms '//*:imp/*:ICMS/*:ICMS60/*:pICMSSTRet' ''.
      IF ls_dados_dacte-picms IS INITIAL.
        _fill_dacte_from_xml: picms '//*:imp/*:ICMS/*:ICMSOutraUF/*:pICMSOutraUF' ''.
      ENDIF.
    ENDIF.

    IF ls_dados_dacte-vicms IS INITIAL.
      _fill_dacte_from_xml: vicms '//*:imp/*:ICMS/*:ICMS60/*:vICMSSTRet' ''.
      IF ls_dados_dacte-vicms IS INITIAL.
        _fill_dacte_from_xml: vicms '//*:imp/*:ICMS/*:ICMSOutraUF/*:vICMSOutraUF' ''.
      ENDIF.
    ENDIF.

    IF ls_dados_dacte-predbc IS INITIAL.
      _fill_dacte_from_xml: predbc '//*:imp/*:ICMS/*:ICMSOutraUF/*:pRedBCOutraUF' ''.
    ENDIF.

    get_value_from_xml( EXPORTING iv_xml        = iv_xml
                                  iv_expression = '//*:infCTeNorm/*:infCarga/*:infQ'
                        IMPORTING eo_nodes = DATA(lo_nodes) ).

    IF lo_nodes IS BOUND.

      DATA(lv_length) = lo_nodes->get_length( ).

      DO lv_length TIMES.

        APPEND INITIAL LINE TO ls_dados_dacte-qtd_carga ASSIGNING FIELD-SYMBOL(<fs_s_qtd_carga>).

        DATA(lr_node) = lo_nodes->get_item( sy-index - 1 )->get_children( ).
        DATA(lr_iterator) = lr_node->create_iterator( ).

        DO 3 TIMES.

          DATA(lr_next_node) = lr_iterator->get_next( ).
          DATA(lv_name) = lr_next_node->get_name( ).

          CASE lv_name.
            WHEN 'cUnid'.
              <fs_s_qtd_carga>-cunid = lr_next_node->get_value( ).
            WHEN 'tpMed'.
              <fs_s_qtd_carga>-tpmed = lr_next_node->get_value( ).
            WHEN 'qCarga'.

              DATA(lv_qcarga) = lr_next_node->get_value( ).

              FIND '.' IN lv_qcarga.
              IF sy-subrc <> 0.
                lv_qcarga = |{ lv_qcarga }.00|.
              ENDIF.

              <fs_s_qtd_carga>-qcarga = lv_qcarga.

          ENDCASE.

        ENDDO.

      ENDDO.

    ENDIF.

    get_value_from_xml( EXPORTING iv_xml        = iv_xml
                                  iv_expression = '//*:vPrest/*:Comp'
                        IMPORTING eo_nodes = lo_nodes ).

    IF lo_nodes IS BOUND.

      lv_length = lo_nodes->get_length( ).

      DO lv_length TIMES.

        APPEND INITIAL LINE TO ls_dados_dacte-comps_vlr_prest ASSIGNING FIELD-SYMBOL(<fs_s_comp_vlr_prest>).

        lr_node = lo_nodes->get_item( sy-index - 1 )->get_children( ).
        lr_iterator = lr_node->create_iterator( ).

        DO 2 TIMES.

          lr_next_node = lr_iterator->get_next( ).
          lv_name = lr_next_node->get_name( ).

          CASE lv_name.
            WHEN 'xNome'.
              <fs_s_comp_vlr_prest>-xnome = lr_next_node->get_value( ).
            WHEN 'vComp'.
              <fs_s_comp_vlr_prest>-vcomp = lr_next_node->get_value( ).
          ENDCASE.

        ENDDO.

      ENDDO.

    ENDIF.

    get_value_from_xml( EXPORTING iv_xml        = iv_xml
                                  iv_expression = '//*:infCTeNorm/*:infDoc/*:infNFe/*:chave'
                        IMPORTING eo_nodes = lo_nodes ).

    IF lo_nodes IS BOUND.

      lv_length = lo_nodes->get_length( ).

      DO lv_length TIMES.

        APPEND INITIAL LINE TO ls_dados_dacte-docs_originarios ASSIGNING FIELD-SYMBOL(<fs_s_doc_originario>).

        DATA(lo_node_it) = lo_nodes->get_item( sy-index - 1 ).
        lr_iterator = lo_node_it->create_iterator( ).

        lr_next_node = lr_iterator->get_next( ).
        lv_name = lr_next_node->get_name( ).

        <fs_s_doc_originario>-acckey = lr_next_node->get_value( ).
        <fs_s_doc_originario>-tpdoc  = 'NFE'.
        <fs_s_doc_originario>-serie  = <fs_s_doc_originario>-acckey+22(3).
        <fs_s_doc_originario>-nfenum = <fs_s_doc_originario>-acckey+25(9).

      ENDDO.

    ENDIF.

    CHECK ls_dados_dacte IS NOT INITIAL.

*    " CT-e Complementar?
*    IF ls_dados_dacte-tpcte = '1'.
*      DATA(lv_smartforms_name) = gc_smartforms-dacte_compl.
*    ELSE.
*      lv_smartforms_name       = gc_smartforms-dacte.
*    ENDIF.
*
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = lv_smartforms_name
*      IMPORTING
*        fm_name            = lv_smartforms_fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*
*    IF sy-subrc <> 0.
*      RAISE EXCEPTION TYPE zcxtm_gko_process
*        EXPORTING
*          gt_bapi_return = VALUE #( ( id         = sy-msgid
*                                      number     = sy-msgno
*                                      type       = sy-msgty
*                                      message_v1 = sy-msgv1
*                                      message_v2 = sy-msgv2
*                                      message_v3 = sy-msgv3
*                                      message_v4 = sy-msgv4 ) ).
*    ENDIF.
*
*    CALL FUNCTION lv_smartforms_fm_name
*      EXPORTING
*        dados_cte        = ls_dados_dacte
*      EXCEPTIONS
*        formatting_error = 1
*        internal_error   = 2
*        send_error       = 3
*        user_canceled    = 4
*        OTHERS           = 5.
*
*    IF sy-subrc <> 0.
*      RAISE EXCEPTION TYPE zcxtm_gko_process
*        EXPORTING
*          gt_bapi_return = VALUE #( ( id         = sy-msgid
*                                      number     = sy-msgno
*                                      type       = sy-msgty
*                                      message_v1 = sy-msgv1
*                                      message_v2 = sy-msgv2
*                                      message_v3 = sy-msgv3
*                                      message_v4 = sy-msgv4 ) ).
*    ENDIF.
    DATA(lo_download_pdf) = NEW zcltm_gestao_frete_relat( ).

    lo_download_pdf->cte_process( EXPORTING iv_tp_cte      = ls_dados_dacte-tpcte
                                            is_dados_dacte = ls_dados_dacte
                                  IMPORTING ev_pdf    = ev_pdf
                                            et_return = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          gt_bapi_return = lt_return.
    ENDIF.
  ENDMETHOD.


  METHOD print.


    SELECT SINGLE acckey, branch, bukrs
      FROM zttm_gkot001
      INTO @DATA(ls_001)
      WHERE acckey = @gv_acckey.

    IF sy-subrc NE 0.
      " Para a chave &, o xml não foi encontrado.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>gc_xml_not_found
          gv_msgv1 = CONV #( gv_acckey ).
    ENDIF.

    TRY.
        DATA(lv_xml_ref) = get_xml_from_ref_nf( iv_bukrs     = ls_001-bukrs
                                                iv_branch    = ls_001-branch
                                                iv_acckey    = ls_001-acckey
                                                iv_direction = 'INBD'
                                                iv_doctype   = 'CTE' ).
      CATCH cx_root.
        " Para a chave &, o xml não foi encontrado.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            textid   = zcxtm_gko_process=>gc_xml_not_found
            gv_msgv1 = CONV #( gv_acckey ).
    ENDTRY.

    print_dacte_from_xstring( EXPORTING iv_xml = lv_xml_ref
                              IMPORTING ev_pdf = ev_pdf ).

  ENDMETHOD.


  METHOD persist.

    DATA: lv_message TYPE char200.

    CHECK gv_wo_lock = abap_false.
    CHECK gs_gko_header IS NOT INITIAL.

    FREE: gv_wait_async, gt_return.

    CALL FUNCTION 'ZFMTM_GKO_PERSIST'
      STARTING NEW TASK 'GKO_PERSIST'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_gko_header        = gs_gko_header
        is_gko_compl         = gs_gko_compl
      TABLES
        it_gko_references    = gt_gko_references
        it_gko_acckey_po_del = gt_gko_acckey_po_del
        it_gko_acckey_po     = gt_gko_acckey_po
        it_gko_logs          = gt_gko_logs
        it_gko_agrup_del     = gt_009_del.

    WAIT UNTIL gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD load_gko_references.

    IF gt_gko_references IS INITIAL.

      SELECT *
        FROM zttm_gkot003
        INTO TABLE gt_gko_references
       WHERE acckey = gv_acckey.

    ENDIF.

  ENDMETHOD.


  METHOD load_gko_po.

    IF gt_gko_acckey_po IS INITIAL.

      SELECT *
        FROM zttm_gkot005
        INTO TABLE gt_gko_acckey_po
       WHERE acckey = gv_acckey.

    ENDIF.

  ENDMETHOD.


  METHOD load_gko_logs.

    IF gt_gko_logs[] IS INITIAL.

      SELECT mandt,
             acckey,
             counter,
             codstatus,
             tpprocess,
             newdoc,
             codigo,
             desc_codigo,
             credat,
             cretim,
             crenam
        FROM zttm_gkot006
       WHERE acckey = @gv_acckey
        INTO TABLE @gt_gko_logs.

    ENDIF.

  ENDMETHOD.


  METHOD load_gko_attachments.

    IF gt_gko_attachments IS INITIAL.

      SELECT *
        FROM zttm_gkot002
        INTO TABLE gt_gko_attachments
       WHERE acckey = gv_acckey.

    ENDIF.

  ENDMETHOD.


  METHOD load_data_from_acckey.

    SELECT SINGLE *
      FROM zttm_gkot001
      INTO gs_gko_header
      WHERE acckey = gv_acckey.

    IF gv_min_data_load = abap_false.

      SELECT *
        FROM zttm_gkot006
        INTO TABLE gt_gko_logs
        WHERE acckey = gv_acckey.

      SELECT *
        FROM zttm_gkot002
        INTO TABLE gt_gko_attachments
        WHERE acckey = gv_acckey.

      SELECT *
        FROM zttm_gkot003
        INTO TABLE gt_gko_references
        WHERE acckey = gv_acckey.

      SELECT SINGLE *
        FROM zttm_gkot004
        INTO gs_gko_compl
        WHERE acckey = gv_acckey.

      SELECT *
        FROM zttm_gkot005
        INTO TABLE gt_gko_acckey_po
        WHERE acckey = gv_acckey.

      SELECT *
        FROM zttm_gkot007
        INTO TABLE gt_gko_events
        WHERE acckey = gv_acckey.

    ENDIF.

  ENDMETHOD.


  METHOD identify_scenario.

    TYPES: BEGIN OF ty_pedido,
             ebeln TYPE ekko-ebeln,
           END OF ty_pedido,

           BEGIN OF ty_material,
             matnr TYPE mara-matnr,
           END OF ty_material,

           BEGIN OF ty_ungrenc,
             un_gerenc TYPE /scmtms/source_location,
           END OF ty_ungrenc,

           BEGIN OF ty_torite,
             base_btd_id TYPE /scmtms/d_torite-base_btd_id,
           END OF ty_torite.

    DATA: lt_pedido       TYPE STANDARD TABLE OF ty_pedido,
          lt_material     TYPE STANDARD TABLE OF ty_material,
          lt_ungrenc      TYPE STANDARD TABLE OF ty_ungrenc,
          lt_link_stop_fu TYPE /bobf/t_frw_key_link,
          lt_tor_loc_log  TYPE /scmtms/t_bo_loc_root_k,
          lt_totite_key   TYPE STANDARD TABLE OF ty_torite,
          lt_tor_root_key TYPE /bobf/t_frw_key,
          lt_stop_adr     TYPE /scmtms/t_bo_loc_addr_detailsk,
          lt_stop_loc_log TYPE /scmtms/t_bo_loc_root_k,
          lt_tcc_root_key TYPE /bobf/t_frw_key,
          lt_assigned_fus TYPE /scmtms/t_tor_root_k.

    DATA: lo_srv_tor TYPE REF TO /bobf/if_tra_service_manager.

    DATA: lt_docflow    TYPE tdt_docflow,
          lt_key        TYPE /bobf/t_frw_key,
          lt_parameters TYPE /bobf/t_frw_query_selparam,
          lt_tor        TYPE /scmtms/t_tor_root_k,
          lt_itmtr      TYPE /scmtms/t_tor_item_tr_k.

    DATA: lv_key       TYPE /bobf/conf_key,
          lv_exterior  TYPE char1,
          lv_ngroup    TYPE char1,
          lv_nentradas TYPE char1,
          lv_tor_type  TYPE /scmtms/tor_type,
          lv_tor_fo    TYPE ze_ordem_frete,
          lv_codigo	   TYPE zttm_gkot006-codigo.

    load_gko_references( ).

* BEGIN OF INSERT - JWSILVA - 13.03.2023
    DATA(lv_emitente_cnpj)     = COND #( WHEN gs_gko_header-exped_cnpj IS NOT INITIAL
                                         THEN gs_gko_header-exped_cnpj
                                         ELSE gs_gko_header-emit_cnpj_cpf ).

    DATA(lv_destinatario_cnpj) = COND #( WHEN gs_gko_header-receb_cnpj IS NOT INITIAL
                                         THEN gs_gko_header-receb_cnpj
                                         ELSE gs_gko_header-dest_cnpj ).
* END OF INSERT - JWSILVA - 13.03.2023

    "***********************
    " Select da Raiz CNPJ
    "***********************
    " Emitente/Expedidor
    SELECT SINGLE bukrs, paval
      FROM t001z
      INTO @DATA(ls_emitente)
      WHERE party = 'J_1BCG'
        AND paval = @lv_emitente_cnpj(8).

    IF sy-subrc IS INITIAL.
      SELECT SINGLE bukrs, branch, cgc_branch, industry, stcd1
        FROM j_1bbranch
        INTO @DATA(ls_emitente_local)
        WHERE bukrs      = @ls_emitente-bukrs
          AND cgc_branch = @lv_emitente_cnpj+8(4).
    ENDIF.

    " Remetente
    SELECT SINGLE bukrs, paval
      FROM t001z
      INTO @DATA(ls_remetente_3c)
      WHERE party = 'J_1BCG'
        AND paval = @gs_gko_header-rem_cnpj_cpf(8).

    IF sy-subrc IS INITIAL.
      SELECT SINGLE bukrs, branch, cgc_branch, industry, stcd1
        FROM j_1bbranch
        INTO @DATA(ls_remetente_local)
        WHERE bukrs      = @ls_remetente_3c-bukrs
          AND cgc_branch = @gs_gko_header-rem_cnpj_cpf+8(4).
    ENDIF.

    " Destinatário/Recebedor
    SELECT SINGLE bukrs, paval
      FROM t001z
      INTO @DATA(ls_destinatario_3c)
      WHERE party = 'J_1BCG'
        AND paval = @lv_destinatario_cnpj(8).

    IF sy-subrc IS INITIAL.
      SELECT SINGLE bukrs, branch, cgc_branch, industry, stcd1
        FROM j_1bbranch
        INTO @DATA(ls_destinatario_local)
        WHERE bukrs      = @ls_destinatario_3c-bukrs
          AND cgc_branch = @lv_destinatario_cnpj+8(4).
    ENDIF.

    lv_tor_fo = |{ gs_gko_header-tor_id ALPHA = OUT }|.

    " Verifica se chave é Frete Diversos
    SELECT chave_nfe
      FROM ztm_infos_fluig
      FOR ALL ENTRIES IN @gt_gko_references
      WHERE chave_nfe   = @gt_gko_references-acckey_ref
      INTO TABLE @DATA(lt_chave_nfe).

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
    <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
    <fs_parameters>-sign   = 'I'.
    <fs_parameters>-option = 'EQ'.
    <fs_parameters>-low    = gs_gko_header-tor_id.

    lo_srv_tor->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                                 it_selection_parameters = lt_parameters
                                 iv_fill_data            = abap_true
                       IMPORTING et_key                  = lt_key
                                 et_data                 = lt_tor ).

    lo_srv_tor->retrieve_by_association( EXPORTING
                                            iv_node_key     = /scmtms/if_tor_c=>sc_node-root
                                            it_key          = lt_key
                                            iv_association  = /scmtms/if_tor_c=>sc_association-root-assigned_fus
                                            iv_edit_mode    = /bobf/if_conf_c=>sc_edit_read_only
                                         IMPORTING
                                            et_target_key   = lt_tor_root_key ).

    lo_srv_tor->retrieve( EXPORTING
                            iv_node_key  = /scmtms/if_tor_c=>sc_node-root
                            it_key       = lt_tor_root_key
                            iv_fill_data = abap_true
                         IMPORTING
                           et_data      = lt_assigned_fus ).

    IF line_exists( lt_assigned_fus[ 1 ] ).
      lv_tor_type = lt_assigned_fus[ 1 ]-tor_type.
    ENDIF.

    IF lt_chave_nfe IS NOT INITIAL.

      " Fretes diversos
      gs_gko_header-cenario = gc_cenario-frete_diversos.

    ELSEIF gs_gko_header-rem_cnpj_cpf(8) EQ gs_gko_header-dest_cnpj(8).

      " Transferência
      gs_gko_header-cenario = gc_cenario-transferencia.

    ELSEIF ls_remetente_3c-paval    IS NOT INITIAL
       AND ls_destinatario_3c-paval IS NOT INITIAL
       AND ls_destinatario_3c-paval NE ls_remetente_3c-paval.

      " Venda coligada
      gs_gko_header-cenario = gc_cenario-venda_coligada.

    ELSEIF ls_remetente_3c    IS NOT INITIAL
       AND ls_destinatario_3c IS INITIAL
       AND lv_tor_type        EQ 'F006'.

      " Venda direta - Ecommerce
      gs_gko_header-cenario = gc_cenario-e_commerce.

    ELSEIF ls_remetente_3c    IS NOT INITIAL
       AND ls_destinatario_3c IS INITIAL
       AND ls_remetente_local-industry EQ '05'.

      " Venda direta - Fábrica
      gs_gko_header-cenario = gc_cenario-venda_direta.

    ELSEIF ls_remetente_3c    IS NOT INITIAL
       AND ls_destinatario_3c IS INITIAL
       AND ls_remetente_local-industry NE '05'.

* BEGIN OF INSERT - JWSILVA - 20.03.2023
*      IF gs_gko_header-emit_cnpj_cpf EQ gs_gko_header-tom_cnpj_cpf.
*        " Compra
*        gs_gko_header-cenario = gc_cenario-entradas.
*      ELSE.
* END OF INSERT - JWSILVA - 20.03.2023

      " Venda direta - Cliente
      gs_gko_header-cenario = gc_cenario-venda_cliente.

* BEGIN OF INSERT - JWSILVA - 20.03.2023
*      ENDIF.
* END OF INSERT - JWSILVA - 20.03.2023

    ELSEIF ls_remetente_3c    IS INITIAL
       AND ls_destinatario_3c IS NOT INITIAL
       AND lv_tor_type        EQ 'F005'.

      " Venda cliente - Devolução
      gs_gko_header-cenario = gc_cenario-venda_cliente.

    ELSEIF ls_remetente_3c    IS INITIAL
       AND ls_destinatario_3c IS NOT INITIAL
       AND ls_remetente_local-industry NE '05'.

      " Compra
      gs_gko_header-cenario = gc_cenario-entradas.

    ENDIF.

    " Nenhum cenário identificado?
    IF gs_gko_header-cenario IS INITIAL.
      set_status( gc_codstatus-cenario_nao_identificado ).
    ELSE.
      set_status( gc_codstatus-cenario_identificado ).
    ENDIF.

    GET TIME.

    gs_gko_header-chadat = sy-datum.
    gs_gko_header-chatim = sy-uzeit.
    gs_gko_header-chanam = sy-uname.

    lv_codigo = gs_gko_header-cenario.
    add_to_log( EXPORTING iv_codigo   = lv_codigo
                          iv_desc_cod = TEXT-t01 ).

  ENDMETHOD.


  METHOD identify_freight_order.

    DATA: lt_docflow TYPE tdt_docflow,
          lt_root    TYPE /scmtms/t_tor_root_k,
          lv_doc     TYPE vbeln,
          lv_docnum  TYPE vbeln,
          lt_return  TYPE bapiret2_t.

    CONSTANTS: lc_reftyp_md    TYPE j_1bnflin-reftyp VALUE 'MD',
               lc_reftyp_bi    TYPE j_1bnflin-reftyp VALUE 'BI',
               lc_reftyp_li    TYPE j_1bnflin-reftyp VALUE 'LI',
               lc_docflow_f    TYPE vbtypl           VALUE 'J',
               lc_docflow_tmfo TYPE vbtypl           VALUE 'TMFO'.

    FREE: gs_gko_header-tor_id.

    load_gko_references( ).

    " Remove chaves duplicadas
    DATA(lt_gko_ref_fae) = gt_gko_references[].
    SORT lt_gko_ref_fae BY acckey_ref.
    DELETE ADJACENT DUPLICATES FROM lt_gko_ref_fae COMPARING acckey_ref.

* ---------------------------------------------------------------------------
* Recupera o fluxo dos documentos
* ---------------------------------------------------------------------------
    IF lt_gko_ref_fae IS NOT INITIAL.

      SELECT *
        FROM zi_tm_vh_frete_identify_fo
        FOR ALL ENTRIES IN @lt_gko_ref_fae
        WHERE AccessKey       EQ @lt_gko_ref_fae-acckey_ref
          AND BR_NFIsCanceled IS INITIAL
        INTO TABLE @DATA(lt_fluxo).

      IF sy-subrc EQ 0.
        SORT lt_fluxo BY Carrier BR_NotaFiscal.
      ENDIF.
    ENDIF.

    LOOP AT lt_fluxo ASSIGNING FIELD-SYMBOL(<fs_fluxo>) WHERE Carrier = gs_gko_header-emit_cod.

* ---------------------------------------------------------------------------
* Cenário de Entrada (NF inbound)
* ---------------------------------------------------------------------------
      IF <fs_fluxo>-BR_NFSourceDocumentType  = lc_reftyp_li.

        IF  <fs_fluxo>-SDDocumentCategory      EQ '7'     " Aviso de remessa/entrega
        AND <fs_fluxo>-IncotermsClassification EQ 'FOB'.

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.

* ---------------------------------------------------------------------------
* Cenário de Transferência
* ---------------------------------------------------------------------------
      ELSEIF <fs_fluxo>-BR_NFSourceDocumentType = lc_reftyp_md.

        IF  <fs_fluxo>-SDDocumentCategory      EQ '7'     " Aviso de remessa/entrega
        AND <fs_fluxo>-IncotermsClassification EQ 'FOB'.

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.

        IF  <fs_fluxo>-SDDocumentCategory      EQ 'J'  " Fornecimento
        AND <fs_fluxo>-IncotermsClassification EQ 'CIF'.

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.

* ---------------------------------------------------------------------------
* Cenário de devolução / principal
* ---------------------------------------------------------------------------
      ELSEIF <fs_fluxo>-BR_NFSourceDocumentType = lc_reftyp_bi.

* BEGIN OF CHANGE - JWSILVA - 04.05.2023
        " Cenário de devolução
        IF <fs_fluxo>-SDDocumentCategory           EQ 'T'     " Recebimento de devoluções para ordem
        AND ( <fs_fluxo>-DeliveryDocumentType+0(2) EQ 'ZD'    " Remessa de Devolução
           OR <fs_fluxo>-DeliveryDocumentType+0(2) EQ 'ZR' ). " Remessa de Retorno

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.

        IF  <fs_fluxo>-SDDocumentCategory      EQ '7'         " Aviso de remessa/entrega
        AND <fs_fluxo>-IncotermsClassification EQ 'FOB'.

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.

        IF  <fs_fluxo>-SDDocumentCategory      EQ 'J'         " Fornecimento
        AND <fs_fluxo>-IncotermsClassification EQ 'CIF'.

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.
* END OF CHANGE - JWSILVA - 04.05.2023

* ---------------------------------------------------------------------------
* Cenário de Saída (NF Outbound)
* ---------------------------------------------------------------------------
      ELSE.

        IF  <fs_fluxo>-SDDocumentCategory      EQ 'J'  " Fornecimento
        AND <fs_fluxo>-IncotermsClassification EQ 'CIF'.

          gs_gko_header-tor_id = <fs_fluxo>-FreightOrder.

        ENDIF.

      ENDIF.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Cenário de Fretes diversos
* ---------------------------------------------------------------------------
    IF gs_gko_header-tor_id IS INITIAL AND lt_gko_ref_fae IS NOT INITIAL.

      SELECT ordem_frete
        FROM ztm_infos_fluig
        FOR ALL ENTRIES IN @lt_gko_ref_fae
        WHERE chave_nfe = @lt_gko_ref_fae-acckey_ref
        INTO TABLE @DATA(lt_fo).

      IF sy-subrc EQ 0.
        SORT lt_fo BY ordem_frete DESCENDING.
      ENDIF.

      TRY.
          gs_gko_header-tor_id = lt_fo[ 1 ]-ordem_frete.
        CATCH cx_root.
      ENDTRY.

    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza status e mensagem de retorno
* ---------------------------------------------------------------------------
    IF gs_gko_header-tor_id IS NOT INITIAL.

      " Cenário OF identificada
      set_status( iv_status   = gc_codstatus-of_identificada
                  iv_desc_cod = TEXT-m02 ).  " OF Identificada

      add_to_log( it_bapi_ret = VALUE #( ( id         = gc_msg_id
                                           number     = gc_msg_of_ident
                                           type       = gc_sucess ) ) ).

    ELSE.

      LOOP AT lt_fluxo ASSIGNING <fs_fluxo> WHERE Carrier = gs_gko_header-emit_cod.
        " Recebimento não encontrado ( Remessa &2 encontrada com Incoterms &1 ).
        lt_return = VALUE #( BASE lt_return ( type   = 'I'
                                              id     = 'ZTM_IF_GKO'
                                              number = '012'
                                              message_v1 = <fs_fluxo>-IncotermsClassification
                                              message_v2 = |{ <fs_fluxo>-DeliveryDocument ALPHA = OUT }| ) ).
      ENDLOOP.

      IF sy-subrc NE 0.
        " Nenhuma remessa encontrada.
        lt_return = VALUE #( BASE lt_return ( type   = 'I'
                                              id     = 'ZTM_IF_GKO'
                                              number = '013' ) ).
      ENDIF.

      " ERRO Identificar OF
      set_status( iv_status   = gc_codstatus-erro_ao_identificar_of
                  it_bapi_ret = lt_return ).

    ENDIF.

  ENDMETHOD.


  METHOD get_xml_from_ref_nf.

    DATA: lv_rfcdest    TYPE rfcdest,
          lv_xnfeactive TYPE j_1bxnfeactive.

    CALL FUNCTION 'J_1B_NFE_CHECK_RFC_DESTINATION'
      EXPORTING
        i_bukrs      = iv_bukrs         " Código da companhia
        i_branch     = iv_branch        " Local de negócios
        i_model      = '55'             " Modelo de Nota Fiscal
      IMPORTING
        e_rfcdest    = lv_rfcdest       " Destino Lógico (Especificado na Chamada de Função)
        e_xnfeactive = lv_xnfeactive    " SAP xNFe ativo
      EXCEPTIONS
        rfc_error    = 1
        OTHERS       = 2.

    IF sy-subrc <> 0
    OR lv_xnfeactive IS INITIAL.

      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          gt_bapi_return = VALUE #( ( id         = sy-msgid
                                      number     = sy-msgno
                                      type       = sy-msgty
                                      message_v1 = sy-msgv1
                                      message_v2 = sy-msgv2
                                      message_v3 = sy-msgv3
                                      message_v4 = sy-msgv4 ) ).
    ENDIF.

    DATA(lr_xml_nfe)    = cl_j_1bnfe_xml_download_da=>get_instance( ).
    DATA(lv_direction)  = iv_direction.
    DATA(lv_doctype)    = iv_doctype.

    TRY.
        lr_xml_nfe->xml_read(
          EXPORTING
            iv_xml_key   = iv_acckey
            iv_direction = lv_direction
            iv_doctype   = lv_doctype
            iv_rfc_dest  = lv_rfcdest
          IMPORTING
            et_messages  = DATA(lt_messages)
            ev_xml       = rv_xml ).

        " RFC connection failure
      CATCH cx_j1bnfe_rfc_conn INTO DATA(lr_cx_rfc).

        " Messages from GRC
      CATCH cx_j1bnfe_messages INTO DATA(lr_cx_messages).

    ENDTRY.

  ENDMETHOD.


  METHOD get_value_from_xml.

    DATA: lr_xslt_processor TYPE REF TO cl_xslt_processor.

    IF io_xslt_processor IS BOUND.
      lr_xslt_processor = io_xslt_processor.
    ELSE.
      lr_xslt_processor = NEW #( ).
      lr_xslt_processor->set_source_xstring( iv_xml ).
    ENDIF.

    lr_xslt_processor->set_expression( expression = iv_expression ).

    TRY.
        lr_xslt_processor->run( '' ).

        eo_nodes = lr_xslt_processor->get_nodes( ).

        CHECK eo_nodes IS BOUND.

        DATA(lr_iterator) = eo_nodes->create_iterator( ).
        DATA(lr_node)     = lr_iterator->get_next( ).

        CHECK lr_node IS BOUND.

        rv_value = lr_node->get_value( ).

        IF rv_value IS NOT INITIAL
       AND iv_expression = '//*:xObs'.
          REPLACE ALL OCCURRENCES OF REGEX '&' IN rv_value WITH ''.
        ENDIF.

      CATCH cx_xslt_exception INTO DATA(lr_cx_xslt_exception).

        " Erro ao obter o valor do campo &, &.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            textid   = zcxtm_gko_process=>gc_error_on_get_xml_value
            gv_msgv1 = CONV #( iv_expression )
            gv_msgv2 = CONV #( lr_cx_xslt_exception->get_text( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD get_status_description.

    DATA: lv_val_text TYPE val_text.

    CALL FUNCTION 'DOMAIN_VALUE_GET'
      EXPORTING
        i_domname  = 'ZD_GKO_CODSTATUS'
        i_domvalue = CONV domvalue_l( iv_status )
      IMPORTING
        e_ddtext   = lv_val_text
      EXCEPTIONS
        not_exist  = 1
        OTHERS     = 2.

    IF sy-subrc IS INITIAL.
      rv_description = lv_val_text.
    ENDIF.

  ENDMETHOD.


  METHOD get_rfc_destination.

    SELECT parametro
      FROM zttm_pcockpit001
     WHERE id = @gc_params-destino_rfc_grc
      INTO @rv_rfc_dest
     UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS NOT INITIAL.

      " Destino RFC não configurado na tabela de parâmetros.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>gc_rfc_destination_not_found.

    ENDIF.

  ENDMETHOD.


  METHOD get_po_werks.

    DATA: lv_cnpj TYPE j_1bcgc.

    FREE: et_werks.

* ---------------------------------------------------------------------------
* Valida inscrição estadual do tomador
* ---------------------------------------------------------------------------
    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).

    SELECT branch~bukrs, branch~branch, t001w~werks, branch~state_insc, branch~stcd1, t001w~regio
        FROM j_1bbranch AS branch
        INNER JOIN t001w
            ON t001w~j_1bbranch EQ branch~branch
*        WHERE branch~bukrs      EQ @gs_gko_header-bukrs            " DELETE - JWSILVA - 04.02.2023
*          AND branch~branch     EQ @gs_gko_header-branch           " DELETE - JWSILVA - 04.02.2023
        WHERE branch~state_insc LIKE @lv_tom_ie
          AND t001w~regio       EQ @gs_gko_header-tom_uf
        INTO TABLE @DATA(lt_branch).

    IF sy-subrc NE 0.

      me->add_to_log( it_bapi_ret = VALUE #( ( type   = 'E'
                                               id     = zcxtm_gko_process=>tom_werks_not_found-msgid
                                               number = zcxtm_gko_process=>tom_werks_not_found-msgno ) ) ).

      " Centro do tomador não encontrado.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>tom_werks_not_found.
    ENDIF.

    TRY.
        DATA(ls_branch) = lt_branch[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Valida CNPJ
* ---------------------------------------------------------------------------
    CALL FUNCTION 'J_1B_BRANCH_READ'
      EXPORTING
        branch            = ls_branch-branch " gs_gko_header-branch
        company           = ls_branch-bukrs  " gs_gko_header-bukrs
      IMPORTING
        cgc_number        = lv_cnpj
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.

    IF sy-subrc <> 0.

      me->add_to_log( it_bapi_ret = VALUE #( ( type   = 'E'
                                               id     = zcxtm_gko_process=>tom_cnpj_not_found-msgid
                                               number = zcxtm_gko_process=>tom_cnpj_not_found-msgno ) ) ).

      " CNPJ do centro não encontrado.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>tom_cnpj_not_found.
    ENDIF.

    IF lv_cnpj NE gs_gko_header-tom_cnpj_cpf.

      me->add_to_log( it_bapi_ret = VALUE #( ( type   = 'E'
                                               id     = zcxtm_gko_process=>tom_cnpj_not_equal-msgid
                                               number = zcxtm_gko_process=>tom_cnpj_not_equal-msgno ) ) ).

      " CNPJ do tomador diferente do CNPJ do centro.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>tom_cnpj_not_equal.
    ENDIF.

    SORT lt_branch BY werks.

    TRY.
        et_werks = VALUE #( FOR ls_brch IN lt_branch ( ls_brch-werks ) ).
        SORT et_werks BY table_line.

        rv_werks = lt_branch[ 1 ]-werks.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD get_po_material_data.

    RETURN.

*    SELECT SINGLE zgkop007~matnr,
*                  mara~meins,
*                  marc~steuc,
*                  marc~indus,
*                  mbew~mtuse,
*                  mbew~mtorg,
*                  zgkop007~gmatnr,
*                  gmara~meins,
*                  gmarc~steuc,
*                  gmarc~indus,
*                  gmbew~mtuse,
*                  gmbew~mtorg
*      FROM zgkop007
*     INNER JOIN mara
*             ON ( mara~matnr = zgkop007~matnr )
*     INNER JOIN marc
*             ON ( marc~matnr = mara~matnr )
*     INNER JOIN mbew
*             ON ( mbew~matnr = mara~matnr
*            AND  mbew~bwkey = marc~werks )
*     LEFT JOIN mara AS gmara
*            ON ( gmara~matnr = zgkop007~gmatnr )
*     LEFT JOIN marc AS gmarc
*            ON ( gmarc~matnr = gmara~matnr )
*     LEFT JOIN mbew AS gmbew
*            ON ( gmbew~matnr = gmara~matnr
*           AND  gmbew~bwkey = gmarc~werks )
*      INTO @rv_material_data
*     WHERE zgkop007~cenario = @gs_gko_header-cenario
*       AND zgkop007~tpdoc   = @gs_gko_header-tpdoc
*       AND marc~werks       = @iv_werks.
*
*    IF sy-subrc IS NOT INITIAL.
*
*      " Cenário &  tp. doc. &,  dados do material não encontrados.
*      RAISE EXCEPTION TYPE zcxtm_gko_process
*        EXPORTING
*          textid   = zcxtm_gko_process=>for_scenar_mat_data_not_found
*          gv_msgv1 = gs_gko_header-cenario
*          gv_msgv2 = gs_gko_header-tpdoc.
*
*    ENDIF.

  ENDMETHOD.


  METHOD get_po_data.

    DATA: lv_gsber        TYPE gsber,
          lv_net_price    TYPE p LENGTH 15 DECIMALS 2,
          lv_tot_netprice TYPE p LENGTH 15 DECIMALS 2,
          ls_greater_item LIKE LINE OF ct_po_item,
          lt_errors       TYPE zcxtm_gko=>ty_t_errors.

    FIELD-SYMBOLS: <fs_s_po_item>     LIKE LINE OF ct_po_item,
                   <fs_s_po_itemx>    LIKE LINE OF ct_po_itemx,
                   <fs_s_po_cond>     LIKE LINE OF ct_po_cond,
                   <fs_s_po_condx>    LIKE LINE OF ct_po_condx,
                   <fs_s_po_account>  LIKE LINE OF ct_po_account,
                   <fs_s_po_accountx> LIKE LINE OF ct_po_accountx.

    DEFINE _fill_bapi_tab.
      IF &1 = 'X'.
        APPEND INITIAL LINE TO ct_po_&2  ASSIGNING <fs_s_po_&2>.
        APPEND INITIAL LINE TO ct_po_&2x ASSIGNING <fs_s_po_&2x>.
      ENDIF.
      <fs_s_po_&2>-&3  = &4.
      <fs_s_po_&2x>-&3 = &5.
    END-OF-DEFINITION.

    load_gko_references( ).

    SELECT gsber
      FROM ztmm_divisao
     WHERE bupla = @gs_gko_header-branch
      INTO @lv_gsber
     UP TO 1 ROWS.
    ENDSELECT.

    DATA(lv_tom_werks) = get_po_werks( ).

    DATA(ls_material_data) = get_po_material_data( iv_werks = lv_tom_werks ).

    get_account_cost_center( IMPORTING ev_saknr = DATA(lv_saknr)
                                       ev_kostl = DATA(lv_kostl) ).

    DATA(lt_items_post) = get_items_post( ).

    SORT lt_items_post BY docnum.

    DATA(lv_amount_doc) = COND ze_gko_vtprest( WHEN gs_gko_header-tpdoc = zcltm_gko_process=>gc_tpdoc-nfs
                                                    THEN gs_gko_header-vrec
                                                    ELSE gs_gko_header-vtprest ).

    CASE gs_gko_header-rateio.

      WHEN gc_tprateio-detalhado.
        DATA(lt_iva) = get_iva_detailed( iv_saknr      = lv_saknr
                                         it_items_post = lt_items_post ).

        DATA(lv_items_tot) = REDUCE j_1bnfdoc-nftot( INIT lr_result = CONV j_1bnfdoc-nftot( '0' )
                                                      FOR <fs_red_item_post> IN lt_items_post
                                                     NEXT lr_result = lr_result + <fs_red_item_post>-item_amount + <fs_red_item_post>-tax_amount ).

        DATA(lv_las_item_num_aux) = cv_last_item_num.

        LOOP AT gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_gko_ref>).

          READ TABLE lt_items_post TRANSPORTING NO FIELDS
                                                 WITH KEY docnum = <fs_s_gko_ref>-docnum
                                                 BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>) FROM sy-tabix.
              IF <fs_s_item_post>-docnum NE <fs_s_gko_ref>-docnum.
                EXIT.
              ENDIF.

              TRY.
                  lv_net_price = lv_amount_doc * ( ( <fs_s_item_post>-item_amount + <fs_s_item_post>-tax_amount ) / lv_items_tot ).

                  IF lv_net_price < '0.01'.
                    lv_net_price = '0.01'.
                  ENDIF.

                  lv_tot_netprice = lv_tot_netprice + lv_net_price.

                  cv_last_item_num = cv_last_item_num + iv_item_intvl.

                  ASSIGN lt_iva[ docnum = <fs_s_item_post>-docnum
                                 itmnum = <fs_s_item_post>-itmnum ] TO FIELD-SYMBOL(<fs_s_iva>).
                  IF sy-subrc IS NOT INITIAL.

                    " Não foi possivel determinar o IVA para a NF & item &.
                    RAISE EXCEPTION TYPE zcxtm_gko_process
                      EXPORTING
                        textid   = zcxtm_gko_process=>for_nf_item_iva_not_found
                        gv_msgv1 = CONV #( <fs_s_item_post>-docnum )
                        gv_msgv2 = CONV #( <fs_s_item_post>-itmnum ).

                  ENDIF.

                  " Para os registros que não são produtos acabados, altera o material utilizado
                  IF <fs_s_item_post>-mtart_pa IS INITIAL.
                    DATA(lv_matnr) = ls_material_data-matnr_g.
                    DATA(lv_meins) = ls_material_data-meins_g.
                    DATA(lv_steuc) = ls_material_data-steuc_g.
                    DATA(lv_indus) = ls_material_data-indus_g.
                    DATA(lv_mtuse) = ls_material_data-mtuse_g.
                    DATA(lv_mtorg) = ls_material_data-mtorg_g.
                  ELSE.
                    lv_matnr = ls_material_data-matnr.
                    lv_meins = ls_material_data-meins.
                    lv_steuc = ls_material_data-steuc.
                    lv_indus = ls_material_data-indus.
                    lv_mtuse = ls_material_data-mtuse.
                    lv_mtorg = ls_material_data-mtorg.
                  ENDIF.

                  _fill_bapi_tab: 'X' item    po_item      cv_last_item_num         cv_last_item_num       ,    "Nº item do documento
                                  ' ' item    material     lv_matnr                 'X'                    ,    "Código material
                                  ' ' item    plant        lv_tom_werks             'X'                    ,    "Centro
                                  ' ' item    quantity     '1'                      'X'                    ,    "Quantidade do pedido
                                  ' ' item    po_unit      lv_meins                 'X'                    ,    "Unidade medida
                                  ' ' item    net_price    lv_net_price             'X'                    ,    "Preço liquido
                                  ' ' item    price_unit   '1'                      'X'                    ,    "Unidade de preço
                                  ' ' item    tax_code     <fs_s_iva>-mwskz         'X'                    ,    "Código do IVA
                                  ' ' item    matl_usage   lv_mtuse                 'X'                    ,    "Utilização de material
                                  ' ' item    mat_origin   lv_mtorg                 'X'                    ,    "Origem de material
                                  ' ' item    bras_nbm     lv_steuc                 'X'                    ,    "Código NCM brasileiro
                                  ' ' item    indus3       lv_indus                 'X'                    ,    "Material: categoria CFOP
                                  ' ' item    gr_ind       space                    'X'                    ,    "Código de entrada de mercadoria
                                  ' ' item    acctasscat   'K'                      'X'                    ,    "Categoria de classificação contábil
                                  ' ' item    info_upd     space                    'X'                    ,    "Código: atualizar registro info

                                  'X' cond    itm_number   <fs_s_po_item>-po_item   <fs_s_po_item>-po_item ,    "Nº item do documento
                                  ' ' cond    cond_st_no   '001'                    'X'                    ,    "Seq.
                                  ' ' cond    cond_type    'PB00'                   'X'                    ,    "Tipo condição
                                  ' ' cond    cond_value   <fs_s_po_item>-net_price 'X'                    ,    "Valor condição
                                  ' ' cond    currency     'BRL'                    'X'                    ,    "Moeda
                                  ' ' cond    currency_iso 'BRL'                    'X'                    ,    "Moeda
                                  ' ' cond    cond_unit    <fs_s_po_item>-po_unit   'X'                    ,    "Unidade medida
                                  ' ' cond    cond_p_unt   '1'                      'X'                    ,    "Por
                                  ' ' cond    change_id    'U'                      'X'                    ,

                                  'X' account po_item      <fs_s_po_item>-po_item   <fs_s_po_item>-po_item ,    "Nº item do documento
                                  ' ' account serial_no    '01'                     '01'                   ,    "Sequencial
                                  ' ' account quantity     <fs_s_po_item>-quantity  'X'                    ,    "Quantidade do pedido
                                  ' ' account net_value    <fs_s_po_item>-net_price 'X'                    ,    "Valor condição
                                  ' ' account gl_account   lv_saknr                 'X'                    ,    "Conta do Razão
                                  ' ' account bus_area     lv_gsber                 'X'                    ,    "Área contab.custos
                                  ' ' account costcenter   lv_kostl                 'X'                    .    "Centro custo

                  IF gs_gko_header-tom_uf <> gs_gko_header-dest_uf.

                    SELECT adrc~taxjurcode
                      FROM but020
                     INNER JOIN adrc ON ( adrc~addrnumber = but020~addrnumber )
                     WHERE but020~partner  =  @gs_gko_header-dest_cod
                       AND adrc~taxjurcode <> @space
                      INTO @DATA(lv_taxjurcode)
                     UP TO 1 ROWS.
                    ENDSELECT.

                    IF sy-subrc IS INITIAL.
                      " Validar o Domicílio Fiscal
                      CALL FUNCTION 'J_1B_TAX_JURISDIC_CODE_CHECK'
                        EXPORTING
                          iv_company_code      = gs_gko_header-bukrs
                          iv_tax_jurisdic_code = lv_taxjurcode
                        EXCEPTIONS
                          is_invalid           = 1
                          OTHERS               = 2.

                      IF sy-subrc <> 0.
                        RAISE EXCEPTION TYPE zcxtm_gko_process
                          EXPORTING
                            textid   = VALUE scx_t100key( msgid = sy-msgid msgno = sy-msgno attr1 = 'MV_MSGV1' attr2 = 'MV_MSGV2' attr3 = 'MV_MSGV3' attr4 = 'MV_MSGV4' )
                            gv_msgv1 = sy-msgv1
                            gv_msgv2 = sy-msgv2
                            gv_msgv3 = sy-msgv3
                            gv_msgv4 = sy-msgv4.
                      ENDIF.

                      _fill_bapi_tab: ' ' item taxjurcode lv_taxjurcode 'X'.    "Domicílio fiscal

                    ENDIF.

                  ENDIF.

                  " Armazena o maior item
                  IF <fs_s_po_item>-net_price > ls_greater_item-net_price.
                    ls_greater_item = <fs_s_po_item>.
                  ENDIF.

                CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
                  APPEND lr_cx_gko_process TO lt_errors.
              ENDTRY.

            ENDLOOP.
          ENDIF.
        ENDLOOP.

        " Se houver diferença, soma o valor ao total do item com maior valor
        IF lv_tot_netprice <> lv_amount_doc.

          lv_tot_netprice = lv_amount_doc - lv_tot_netprice.

          " Obtêm o item com o maior valor
          ASSIGN ct_po_item[ po_item = ls_greater_item-po_item ] TO <fs_s_po_item>.
          IF sy-subrc IS INITIAL.

            <fs_s_po_item>-net_price = <fs_s_po_item>-net_price + lv_tot_netprice.

            TRY.
                ct_po_cond[ itm_number = <fs_s_po_item>-po_item ]-cond_value = <fs_s_po_item>-net_price.
                ct_po_account[ po_item = <fs_s_po_item>-po_item ]-net_value  = <fs_s_po_item>-net_price.
              CATCH cx_sy_itab_line_not_found.
            ENDTRY.

          ELSE.

            LOOP AT ct_po_item ASSIGNING <fs_s_po_item> WHERE po_item > lv_las_item_num_aux.

              " Se o valor for negativo, verifica se o valor do item é maior
              IF lv_tot_netprice < 0.
                CHECK <fs_s_po_item>-net_price > abs( lv_tot_netprice ).
              ENDIF.

              <fs_s_po_item>-net_price = <fs_s_po_item>-net_price + lv_tot_netprice.

              ct_po_cond[ itm_number = <fs_s_po_item>-po_item ]-cond_value = <fs_s_po_item>-net_price.
              ct_po_account[ po_item = <fs_s_po_item>-po_item ]-net_value  = <fs_s_po_item>-net_price.

              EXIT.

            ENDLOOP.

          ENDIF.

        ENDIF.

        IF lt_errors IS NOT INITIAL.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              gt_errors = lt_errors.
        ENDIF.

      WHEN gc_tprateio-unificado.

        DATA(lv_iva) = get_iva_unified( iv_saknr = lv_saknr ).

        lv_net_price = lv_amount_doc.

        cv_last_item_num = cv_last_item_num + iv_item_intvl.

        _fill_bapi_tab: 'X' item    po_item      cv_last_item_num         cv_last_item_num       ,    "Nº item do documento
                        ' ' item    material     ls_material_data-matnr   'X'                    ,    "Código material
                        ' ' item    plant        lv_tom_werks             'X'                    ,    "Centro
                        ' ' item    quantity     '1'                      'X'                    ,    "Quantidade do pedido
                        ' ' item    po_unit      ls_material_data-meins   'X'                    ,    "Unidade medida
                        ' ' item    net_price    lv_net_price             'X'                    ,    "Preço liquido
                        ' ' item    price_unit   '1'                      'X'                    ,    "Unidade de preço
                        ' ' item    tax_code     lv_iva                   'X'                    ,    "Código do IVA
                        ' ' item    matl_usage   ls_material_data-mtuse   'X'                    ,    "Utilização de material
                        ' ' item    mat_origin   ls_material_data-mtorg   'X'                    ,    "Origem de material
                        ' ' item    bras_nbm     ls_material_data-steuc   'X'                    ,    "Código NCM brasileiro
                        ' ' item    indus3       ls_material_data-indus   'X'                    ,    "Material: categoria CFOP
                        ' ' item    gr_ind       space                    'X'                    ,    "Código de entrada de mercadoria
                        ' ' item    acctasscat   'K'                      'X'                    ,    "Categoria de classificação contábil
                        ' ' item    info_upd     space                    'X'                    ,    "Código: atualizar registro info

                        'X' cond    itm_number   <fs_s_po_item>-po_item   <fs_s_po_item>-po_item ,    "Nº item do documento
                        ' ' cond    cond_st_no   '001'                    'X'                    ,    "Seq.
                        ' ' cond    cond_type    'PB00'                   'X'                    ,    "Tipo condição
                        ' ' cond    cond_value   <fs_s_po_item>-net_price 'X'                    ,    "Valor condição
                        ' ' cond    currency     'BRL'                    'X'                    ,    "Moeda
                        ' ' cond    currency_iso 'BRL'                    'X'                    ,    "Moeda
                        ' ' cond    cond_unit    <fs_s_po_item>-po_unit   'X'                    ,    "Unidade medida
                        ' ' cond    cond_p_unt   '1'                      'X'                    ,    "Por
                        ' ' cond    change_id    'U'                      'X'                    ,

                        'X' account po_item      <fs_s_po_item>-po_item   <fs_s_po_item>-po_item ,    "Nº item do documento
                        ' ' account serial_no    '01'                     '01'                   ,    "Sequencial
                        ' ' account quantity     <fs_s_po_item>-quantity  'X'                    ,    "Quantidade do pedido
                        ' ' account net_value    <fs_s_po_item>-net_price 'X'                    ,    "Valor condição
                        ' ' account gl_account   lv_saknr                 'X'                    ,    "Conta do Razão
                        ' ' account bus_area     lv_gsber                 'X'                    ,    "Área contab.custos
                        ' ' account costcenter   lv_kostl                 'X'                    .    "Centro custo

        IF gs_gko_header-tom_uf <> gs_gko_header-dest_uf.

          SELECT adrc~taxjurcode
            FROM but020
           INNER JOIN adrc ON ( adrc~addrnumber = but020~addrnumber )
           WHERE but020~partner  =  @gs_gko_header-dest_cod
             AND adrc~taxjurcode <> @space
            INTO @lv_taxjurcode
           UP TO 1 ROWS.
          ENDSELECT.

          IF sy-subrc IS INITIAL.
            " Validar o Domicílio Fiscal
            CALL FUNCTION 'J_1B_TAX_JURISDIC_CODE_CHECK'
              EXPORTING
                iv_company_code      = gs_gko_header-bukrs
                iv_tax_jurisdic_code = lv_taxjurcode
              EXCEPTIONS
                is_invalid           = 1
                OTHERS               = 2.

            IF sy-subrc <> 0.
              RAISE EXCEPTION TYPE zcxtm_gko_process
                EXPORTING
                  textid   = VALUE scx_t100key( msgid = sy-msgid msgno = sy-msgno attr1 = 'MV_MSGV1' attr2 = 'MV_MSGV2' attr3 = 'MV_MSGV3' attr4 = 'MV_MSGV4' )
                  gv_msgv1 = sy-msgv1
                  gv_msgv2 = sy-msgv2
                  gv_msgv3 = sy-msgv3
                  gv_msgv4 = sy-msgv4.
            ENDIF.

            _fill_bapi_tab: ' ' item taxjurcode lv_taxjurcode 'X'.    " Domicílio fiscal

          ENDIF.

        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD get_payment_document.

    TYPES: ty_bseg2 TYPE bseg_t.

    DATA: lt_bseg  TYPE ty_bseg2,
          lt_bseg2 TYPE ty_bseg2.

    DATA: ls_gkot001 TYPE zttm_gkot001.

    DATA: lr_hkont TYPE RANGE OF bseg-hkont,
          lr_bukrs TYPE RANGE OF bukrs.

    DATA(lt_doc) = it_doc.

    lr_bukrs = VALUE #( FOR ls_doc IN lt_doc ( sign   = 'I'
                                               option = 'EQ'
                                               low    = ls_doc-bukrs ) ).

    SORT lr_bukrs BY low ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lr_bukrs COMPARING low.

    " Selecionar contas bancarias
    SELECT bukrs,
           hkont
      FROM t012k
      INTO TABLE @DATA(lt_t012k)
      WHERE bukrs IN @lr_bukrs.

    SORT lt_t012k BY bukrs ASCENDING hkont ASCENDING.

    DELETE ADJACENT DUPLICATES FROM lt_t012k COMPARING bukrs hkont.

    LOOP AT lt_t012k ASSIGNING FIELD-SYMBOL(<fs_t012k>).

      " BR - Entrada
      DATA(ls_ikofi_in) = VALUE ikofi( anwnd = '0001'
                                       eigr1 = 'B00D'
                                       eigr2 = '1'
                                       komo1 = '+'
                                       komo2 = 'BRL'
                                       ktopl = 'PC01'
                                       sakin = <fs_t012k>-hkont ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_in-anwnd
          i_eigr1  = ls_ikofi_in-eigr1
          i_eigr2  = ls_ikofi_in-eigr2
          i_eigr3  = ls_ikofi_in-eigr3
          i_eigr4  = ls_ikofi_in-eigr4
          i_komo1  = ls_ikofi_in-komo1
          i_komo1b = ls_ikofi_in-komo1b
          i_komo2  = ls_ikofi_in-komo2
          i_komo2b = ls_ikofi_in-komo2b
          i_ktopl  = ls_ikofi_in-ktopl
          i_sakin  = ls_ikofi_in-sakin
          i_sakinb = ls_ikofi_in-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_in
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc IS INITIAL
     AND ls_ikofi_in-sakn1 IS NOT INITIAL.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING FIELD-SYMBOL(<fs_r_hkont>).
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_in-sakn1.
      ENDIF.

      " BR - Saida
      DATA(ls_ikofi_out) =  VALUE ikofi( anwnd = '0001'
                                         eigr1 = 'B00C'
                                         eigr2 = '1'
                                         komo1 = '+'
                                         komo2 = 'BRL'
                                         ktopl = 'PC01'
                                         sakin =  <fs_t012k>-hkont ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_out-anwnd
          i_eigr1  = ls_ikofi_out-eigr1
          i_eigr2  = ls_ikofi_out-eigr2
          i_eigr3  = ls_ikofi_out-eigr3
          i_eigr4  = ls_ikofi_out-eigr4
          i_komo1  = ls_ikofi_out-komo1
          i_komo1b = ls_ikofi_out-komo1b
          i_komo2  = ls_ikofi_out-komo2
          i_komo2b = ls_ikofi_out-komo2b
          i_ktopl  = ls_ikofi_out-ktopl
          i_sakin  = ls_ikofi_out-sakin
          i_sakinb = ls_ikofi_out-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_out
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc IS INITIAL
     AND ls_ikofi_out-sakn1 IS NOT INITIAL.
        UNASSIGN <fs_r_hkont>.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING <fs_r_hkont>.
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_out-sakn1.
      ENDIF.
    ENDLOOP.

    " Identificar Documento de compensação e pagamento
    DO 4 TIMES.

      IF lt_doc IS INITIAL.
        EXIT.
      ENDIF.

      " Selecionar informações do documento de FI
      SELECT bukrs, belnr, gjahr, augdt, augbl, hkont
        FROM bseg
         FOR ALL ENTRIES IN @lt_doc
       WHERE bukrs = @lt_doc-bukrs_doc
         AND belnr = @lt_doc-belnr
         AND gjahr = @lt_doc-gjahr
        INTO CORRESPONDING FIELDS OF TABLE @lt_bseg2.

      CHECK sy-subrc IS INITIAL.

      CLEAR: lt_doc.

      LOOP AT lt_bseg2 INTO DATA(ls_bseg_aux).

        CHECK ls_bseg_aux-belnr <> ls_bseg_aux-augbl.

        LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg>) WHERE augbl = ls_bseg_aux-belnr.
          IF ls_bseg_aux-hkont IN lr_hkont.
            ls_gkot001-belnr    = <fs_bseg>-belnr.
            ls_gkot001-re_belnr = <fs_bseg>-augbl.
            ls_gkot001-augdt    = <fs_bseg>-augdt.

            APPEND ls_gkot001 TO rt_gkot001.
            CLEAR ls_gkot001.
          ENDIF.

          IF NOT ls_bseg_aux-augbl IS INITIAL.
            <fs_bseg>-augbl = ls_bseg_aux-augbl.
            <fs_bseg>-augdt = ls_bseg_aux-augdt.
          ENDIF.
        ENDLOOP.

        IF NOT sy-subrc IS INITIAL.
          APPEND INITIAL LINE TO lt_bseg ASSIGNING <fs_bseg>.
          <fs_bseg> = ls_bseg_aux.
        ENDIF.

        IF NOT ls_bseg_aux-augbl IS INITIAL.
          APPEND INITIAL LINE TO lt_doc ASSIGNING FIELD-SYMBOL(<fs_doc>).
          <fs_doc>-bukrs_doc = ls_bseg_aux-bukrs.
          <fs_doc>-belnr     = ls_bseg_aux-augbl.
          <fs_doc>-gjahr     = ls_bseg_aux-augdt(4).
        ENDIF.

        UNASSIGN: <fs_doc>, <fs_bseg>.
      ENDLOOP.

      CLEAR: lt_bseg2.

      DELETE ADJACENT DUPLICATES FROM lt_doc COMPARING belnr.
    ENDDO.

  ENDMETHOD.


  METHOD get_parameter.

    DATA: lv_ddtext TYPE val_text.

    SELECT SINGLE parametro
      FROM zttm_pcockpit001
      WHERE id = @iv_id
      INTO @rv_value.

    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

    CALL FUNCTION 'DOMAIN_VALUE_GET'
      EXPORTING
        i_domname  = 'ZD_GKO_ID'
        i_domvalue = CONV domvalue_l( iv_id )
      IMPORTING
        e_ddtext   = lv_ddtext
      EXCEPTIONS
        not_exist  = 1
        OTHERS     = 2.

    IF sy-subrc IS INITIAL AND lv_ddtext IS INITIAL.
      lv_ddtext = iv_id.
    ENDIF.

    " Parâmetro & não encontrado na tabela de parâmetros.
    RAISE EXCEPTION TYPE zcxtm_gko_process
      EXPORTING
        textid   = zcxtm_gko_process=>parameter_not_found
        gv_msgv1 = CONV #( lv_ddtext ).

  ENDMETHOD.


  METHOD get_miro_sub_payment_condition.

    DATA(lv_ekorg) = CONV lfm1-ekorg( get_parameter( gc_params-organizacao_compras ) ).

    SELECT SINGLE zterm
      FROM but000
     INNER JOIN cvi_vend_link
             ON ( cvi_vend_link~partner_guid = but000~partner_guid )
     INNER JOIN lfm1
             ON ( lfm1~lifnr = cvi_vend_link~vendor )
      INTO rv_pmnttrms
     WHERE but000~partner =  gs_gko_header-emit_cod
       AND lfm1~ekorg     =  lv_ekorg
       AND lfm1~zterm     <> space.

    IF sy-subrc IS NOT INITIAL.

      " Condição de pagamento do transportadora não encontrada & &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>pmnt_cond_not_found_for_transp
          gv_msgv1 = CONV #( gs_gko_header-emit_cod )
          gv_msgv2 = CONV #( lv_ekorg ).

    ENDIF.

  ENDMETHOD.


  METHOD validate_po_miro.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.

    load_gko_references( ).

    CHECK it_item_data IS NOT INITIAL.

*    DATA(lv_po_werks) = get_po_werks( ).
*
*    SELECT DISTINCT ebeln,
*                    werks
*      FROM ekpo
*      INTO TABLE @DATA(lt_ekpo)
*       FOR ALL ENTRIES IN @it_item_data
*     WHERE ebeln =  @it_item_data-po_number
*       AND ebelp =  @it_item_data-po_item
*       AND werks <> @lv_po_werks.
*
*    LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_s_ekpo>).
*
*      " O centro & do pedido &, difere do centro do tomador &.
*      APPEND NEW zcxtm_gko_process( textid = zcxtm_gko_process=>werks_po_differs_from_werks_to
*                                    gv_msgv1  = CONV #( <fs_s_ekpo>-werks )
*                                    gv_msgv2  = CONV #( <fs_s_ekpo>-ebeln )
*                                    gv_msgv3  = CONV #( lv_po_werks ) ) TO lt_errors.
*
*    ENDLOOP.

    me->get_po_werks( IMPORTING et_werks = DATA(lt_werks) ).

    SELECT DISTINCT ebeln, ebelp, werks
      FROM ekpo
      INTO TABLE @DATA(lt_ekpo)
       FOR ALL ENTRIES IN @it_item_data
     WHERE ebeln =  @it_item_data-po_number
       AND ebelp =  @it_item_data-po_item.

    LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_s_ekpo>).

      READ TABLE lt_werks TRANSPORTING NO FIELDS WITH KEY table_line = <fs_s_ekpo>-werks.

      IF sy-subrc NE 0.

        me->add_to_log( it_bapi_ret = VALUE #( ( type       = 'E'
                                                 id         = zcxtm_gko_process=>werks_po_differs_from_werks_to-msgid
                                                 number     = zcxtm_gko_process=>werks_po_differs_from_werks_to-msgno
                                                 message_v1 = <fs_s_ekpo>-werks
                                                 message_v2 = <fs_s_ekpo>-ebeln
                                                 message_v3 = gs_gko_header-tom_cod ) ) ).

        " O centro & do pedido &, difere do centro do tomador &.
        APPEND NEW zcxtm_gko_process( textid = zcxtm_gko_process=>werks_po_differs_from_werks_to
                                      gv_msgv1  = CONV #( <fs_s_ekpo>-werks )
                                      gv_msgv2  = CONV #( <fs_s_ekpo>-ebeln )
                                      gv_msgv3  = CONV #( gs_gko_header-tom_cod )
                                      ) TO lt_errors.
      ENDIF.

    ENDLOOP.

    IF gs_gko_header-tpcte = gc_tpcte-substituto.

      DATA(lt_references_orig) = gt_gko_references.
      SORT lt_references_orig BY acckey_orig.
      DELETE ADJACENT DUPLICATES FROM lt_references_orig COMPARING acckey_orig.

      " Conta quantos registros estão no status de Rejeição confirmada
      SELECT acckey
        FROM zttm_gkot001
        INTO TABLE @DATA(lt_acckey_rej_conf)
         FOR ALL ENTRIES IN @lt_references_orig
       WHERE acckey    = @lt_references_orig-acckey_orig
         AND codstatus = @gc_codstatus-evt_rejeicao_confirmado_sefaz.

      IF lines( lt_acckey_rej_conf ) <> lines( lt_references_orig ).

        LOOP AT lt_references_orig ASSIGNING FIELD-SYMBOL(<fs_s_references_orig>).

          IF NOT line_exists( lt_acckey_rej_conf[ acckey = <fs_s_references_orig>-acckey_orig ] ).

            me->add_to_log( it_bapi_ret = VALUE #( ( type       = 'E'
                                                     id         = zcxtm_gko_process=>acckey_wo_conf_rej_evt-msgid
                                                     number     = zcxtm_gko_process=>acckey_wo_conf_rej_evt-msgno
                                                     message_v1 = <fs_s_references_orig>-acckey_orig ) ) ).

            " A chave de acesso &, não está com o evento de rejeição confirmado.
            APPEND NEW zcxtm_gko_process( textid   = zcxtm_gko_process=>acckey_wo_conf_rej_evt
                                          gv_msgv1 = CONV #( <fs_s_references_orig>-acckey_orig ) ) TO lt_errors.

          ENDIF.

        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lt_errors IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          gt_errors = lt_errors.
    ENDIF.

  ENDMETHOD.


  METHOD status_check.

    DATA: lv_messageid TYPE /xnfe/sxmsmguid.

    " CT-e Incoming Header Data
    SELECT cteid,
           cuf,
           tpamb,
           tpemis
      FROM /xnfe/inctehd
     WHERE cteid = @iv_cteid
      INTO @DATA(ls_inctehd)
     UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS NOT INITIAL.
      ev_subrc = 4.
    ENDIF.

    " Send CT-e Status Check - Synchron
    CALL FUNCTION '/XNFE/CTE_STATUS_CHECK_SYNC'
      EXPORTING
        iv_cuf                 = ls_inctehd-cuf
        iv_tpamb               = ls_inctehd-tpamb
        iv_tpemis              = ls_inctehd-tpemis
        iv_cteid               = iv_cteid
*       IV_XMLVERSION          =
      IMPORTING
        ev_messageid           = lv_messageid
        es_infprot             = es_infprot
        et_events_prot         = et_events_prot
      EXCEPTIONS
        version_not_maintained = 1
        error_proxy_call       = 2
        transformation_error   = 3.

    IF sy-subrc IS NOT INITIAL.
      CASE sy-subrc.
        WHEN 1.
          ev_subrc = 1.
        WHEN 2.
          ev_subrc = 3.
        WHEN OTHERS.
          ev_subrc = 2.
      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD set_status_payment.

    gs_gko_header-augdt = iv_augdt.
    gs_gko_header-pago  = iv_pago.

    IF iv_pago IS NOT INITIAL.
      set_status( iv_status = gc_codstatus-pagamento_efetuado
                  iv_newdoc = |{ iv_augdt DATE = USER }| ).
    ENDIF.

  ENDMETHOD.


  METHOD set_status.

* BEGIN OF INSERT - JWSILVA - 09.02.2023
    IF gs_gko_header-codstatus NE iv_status
    OR iv_newdoc IS NOT INITIAL
    OR iv_codigo IS NOT INITIAL
    OR iv_desc_cod IS NOT INITIAL
    OR it_bapi_ret IS NOT INITIAL.
* END OF INSERT - JWSILVA - 09.02.2023
      gs_gko_header-codstatus = iv_status.

      add_to_log( iv_newdoc   = iv_newdoc
                  iv_codigo   = iv_codigo
                  iv_desc_cod = iv_desc_cod
                  it_bapi_ret = it_bapi_ret ).
* END OF INSERT - JWSILVA - 09.02.2023
    ENDIF.
* END OF INSERT - JWSILVA - 09.02.2023

    gs_gko_header-chadat = sy-datum.
    gs_gko_header-chatim = sy-uzeit.
    gs_gko_header-chanam = sy-uname.

  ENDMETHOD.


  METHOD set_reversal_invoice_grouping.

    set_status( iv_status = gc_codstatus-estorno_agrupamento_realizado ).

    " Recupera os dados de agrupamento que serão apagados
    SELECT *
      FROM zttm_gkot009
      INTO TABLE @gt_009_del
      WHERE xblnr = @gs_gko_header-num_fatura
        AND stcd1 = @gs_gko_header-emit_cnpj_cpf.

    IF sy-subrc NE 0.
      FREE gt_009_del.
    ENDIF.

    FREE: gs_gko_header-bukrs_doc,
          gs_gko_header-belnr,
          gs_gko_header-gjahr,
          gs_gko_header-pago,
          gs_gko_header-augdt,
          gs_gko_header-num_fatura,
          gs_gko_header-desconto.

  ENDMETHOD.


  METHOD set_reject.

    DATA: lv_guid TYPE /xnfe/guid_16.

    " CT-e Incoming Header Data
    SELECT SINGLE guid
      INTO lv_guid
      FROM /xnfe/inctehd
     WHERE cteid = iv_cteid.

    IF sy-subrc IS NOT INITIAL.
      ev_rc = sy-subrc.
      MESSAGE ID '/XNFE/APPB2B_CTE' TYPE 'E' NUMBER '011' WITH iv_cteid
                                                          INTO  ev_message.
    ENDIF.

    " CT-e Set Rejected Function
*    CALL FUNCTION '/XNFE/CTE_SET_REJECTED'
*      EXPORTING
*        iv_guid              = lv_guid
*        iv_not_code          = iv_not_code
**       IV_OVERWRITE         =
*      EXCEPTIONS
*        no_proc_allowed      = 1
*        error_reading_cte    = 2
*        error_creating_event = 3
*        technical_error      = 4.

    CLEAR: gv_subrc,
           gs_return.

    CALL FUNCTION 'ZFMTM_GKO_CTE_SET_REJECTED'
      STARTING NEW TASK 'TM_SET_REJECTED'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_guid     = lv_guid
        iv_not_code = iv_not_code.

    WAIT UNTIL gv_wait_async = abap_true.
    FREE: gv_wait_async.

    ev_rc = gv_subrc.

    IF gv_subrc IS NOT INITIAL.
      MESSAGE ID gs_return-id TYPE gs_return-type NUMBER gs_return-number WITH gs_return-message_v1
                                                                               gs_return-message_v2
                                                                               gs_return-message_v3
                                                                               gs_return-message_v4
                                                                          INTO ev_message.
    ENDIF.

  ENDMETHOD.


  METHOD set_po_approved.

    RETURN.
*    CHECK gs_gko_header-codstatus = gc_codstatus-pedido_compra_criado.
*
*    set_status( iv_status = gc_codstatus-pedido_compra_aprovado ).

  ENDMETHOD.


  METHOD set_po.

    RETURN.
*
*    IF iv_po_number IS INITIAL
*    OR it_po_item[] IS INITIAL.
*      RETURN.
*    ENDIF.
*
*    gt_gko_acckey_po = VALUE #( FOR <fs_s_item> IN it_po_item
*                                  ( acckey = gv_acckey
*                                    ebeln  = iv_po_number
*                                    ebelp  = <fs_s_item>-po_item ) ).
*
*    set_status( iv_status = gc_codstatus-pedido_compra_criado
*                iv_newdoc = CONV #( iv_po_number )           ).
*

  ENDMETHOD.


  METHOD set_invoice_registered.

    IF gs_gko_header-num_fatura IS INITIAL.
      set_status( iv_status = zcltm_gko_process=>gc_codstatus-miro_confirmada
                  iv_newdoc = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).
    ELSE.

      " Verifica se os dados da fatura foram preenchidos
      SELECT COUNT(*)
        FROM zttm_gkot009
        WHERE xblnr = gs_gko_header-num_fatura.

      IF sy-subrc IS INITIAL.
        set_status( iv_status = zcltm_gko_process=>gc_codstatus-aguardando_reagrupamento
                    iv_newdoc = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).
      ELSE.
        set_status( iv_status = zcltm_gko_process=>gc_codstatus-miro_confirmada
                    iv_newdoc = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD set_invoice_grouping.

    gs_gko_header-num_fatura = iv_num_fatura.
    gs_gko_header-vct_gko    = iv_vct_gko.
    gs_gko_header-usr_lib    = COND #( WHEN iv_usr_lib IS NOT INITIAL
                                       THEN iv_usr_lib
                                       ELSE sy-uname ).
    gs_gko_header-bukrs_doc  = iv_bukrs.
    gs_gko_header-belnr      = iv_belnr.
    gs_gko_header-gjahr      = iv_gjahr.
    gs_gko_header-desconto   = iv_desconto.

    set_status( iv_status = gc_codstatus-agrupamento_efetuado
                iv_newdoc = |{ iv_num_fatura }/{ iv_belnr }{ iv_gjahr }| ).

  ENDMETHOD.


  METHOD set_invoice_data.

    gs_gko_header-num_fatura = iv_num_fatura.
    gs_gko_header-usr_lib    = iv_usr_lib.
    gs_gko_header-vct_gko    = iv_vct_gko.

  ENDMETHOD.


  METHOD set_invoice_as_paid.

    gs_gko_header-augdt = iv_augdt.
    gs_gko_header-pago  = iv_pago.

    IF iv_pago IS NOT INITIAL.
      set_status( iv_status = gc_codstatus-pagamento_efetuado
                  iv_newdoc = |{ iv_augdt DATE = USER }| ).
    ENDIF.

  ENDMETHOD.


  METHOD set_cancel.

    gs_gko_header-sitdoc = gc_sitdoc-cancelado.

    set_status( iv_status = gc_codstatus-documento_cancelado ).

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.
      WHEN 'TM_INCM_DELETE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_INCM_DELETE'
         IMPORTING
           ev_sucess = gv_success
           et_return = gt_return.

        gv_wait_async = abap_true.

      WHEN 'TM_INCM_CANCEL'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_INCM_CANCEL'
         IMPORTING
           ev_invnumber_reversal  = gv_invnumber_reversal
           ev_fiscalyear_reversal = gv_fiscalyear_reversal
           et_return              = gt_return.

        gv_wait_async = abap_true.

      WHEN 'TM_REVERSE_FI_DOCS'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_REVERSE_FI_DOCS'
            IMPORTING
                et_return      = gt_return
                et_bapi_return = gt_bapi_return.

        gv_wait_async = abap_true.

      WHEN 'TM_PO_CHANGE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_PO_CHANGE'
         IMPORTING
           et_return = gt_return
           ev_sucess = gv_success2.

        gv_wait_async = abap_true.

      WHEN 'TM_SET_REJECTED'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_CTE_SET_REJECTED'
         IMPORTING
           ev_subrc  = gv_subrc
           es_return = gs_return.

        gv_wait_async = abap_true.

      WHEN 'TM_INCM_CREATE1'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
         IMPORTING
           ev_invoicedocnumber = gv_belnr
           ev_fiscalyear       = gv_gjahr
         CHANGING
           ct_itemdata         = gt_itemdata
           ct_return           = gt_return.

        gv_wait_async = abap_true.

      WHEN 'TM_ACTIVE_LOCK'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_NFE_ACTIVE_LOCK'
          IMPORTING
            ev_subrc = gv_subrc.

        gv_wait_async = abap_true.

      WHEN 'GKO_PERSIST'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_PERSIST'
          IMPORTING
            et_return = gt_return.

        gv_wait_async = abap_true.

      WHEN 'GKO_SAVE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_SAVE'
          IMPORTING
            et_return = gt_return.

        gv_wait_async = abap_true.

      WHEN 'GKO_EXTRA_CHARGE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_EXTRA_CHARGE_SAVE'
        IMPORTING
          et_return = gt_return.

        gv_wait_async = abap_true.

      WHEN 'GKO_FATURAR_ETAPA'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_FATURAR_ETAPA'
        IMPORTING
          et_return = gt_return.

        gv_wait_async = abap_true.

      WHEN 'REVERSAL_PURCHASE_ORDER'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_REVERSAL_PURCHASE_ORDER'
        IMPORTING
          ev_success     = gv_success
          et_return      = gt_return
          et_bapi_return = gt_bapi_return.

        gv_wait_async = abap_true.

      WHEN 'GKO_CHECK_DFF'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_GKO_CHECK_DFF'
        IMPORTING
          ev_check   = gv_check
          et_sfir_id = gt_sfir_id
          et_return  = gt_return.

        gv_wait_async = abap_true.

      WHEN 'EXTRA_CHARGE_AND_STEP'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_EXTRA_CHARGE_AND_STEP'
        IMPORTING
          et_return  = gt_return.

        gv_wait_async = abap_true.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD send_date_payment_to_gko.

    DATA: lt_t012k   TYPE ty_t_012k,
          lt_bseg    TYPE STANDARD TABLE OF bseg,
          lt_gkot001 TYPE STANDARD TABLE OF zttm_gkot001.

    DATA: ls_gko_header TYPE zttm_gkot001,
          ls_bsak       TYPE ty_s_bsak.

    DATA: lv_num_fatura TYPE zttm_gkot001-num_fatura.

    DATA: lr_hkont TYPE RANGE OF bseg-hkont.

    FIELD-SYMBOLS: <fs_zgkot001> TYPE zttm_gkot001.

    " Selecionar documentos contabeis na tabela ZTTM_GKOT001
    SELECT *
      FROM zttm_gkot001
      FOR ALL ENTRIES IN @it_ausz1
      WHERE bukrs_doc EQ @it_ausz1-bukrs
        AND belnr     EQ @it_ausz1-belnr
        AND gjahr     EQ @it_ausz1-gjahr
       INTO TABLE @lt_gkot001.

    CHECK NOT lt_gkot001[] IS INITIAL.

    " Verificar compensação de Documento
    READ TABLE it_ausz2 ASSIGNING FIELD-SYMBOL(<fs_ausz2>) INDEX 1.
    CHECK sy-subrc = 0.

    CHECK NOT <fs_ausz2>-augbl IS INITIAL.
    CHECK NOT <fs_ausz2>-augdt IS INITIAL.

    " Selecionar contas bancarias
    SELECT bukrs
           hkont
      FROM t012k
      INTO TABLE lt_t012k
     WHERE bukrs EQ <fs_ausz2>-bukrs.

    IF sy-subrc IS INITIAL.
      SORT lt_t012k.
    ENDIF.

    DELETE ADJACENT DUPLICATES FROM lt_t012k.

    LOOP AT lt_t012k ASSIGNING FIELD-SYMBOL(<fs_t012k>).

      " BR - Entrada
      DATA(ls_ikofi_in) = VALUE ikofi( anwnd = '0001'
                                       eigr1 = 'B00D'
                                       eigr2 = '1'
                                       komo1 = '+'
                                       komo2 = 'BRL'
                                       ktopl = 'PC01'
                                       sakin =  <fs_t012k>-hkont ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_in-anwnd
          i_eigr1  = ls_ikofi_in-eigr1
          i_eigr2  = ls_ikofi_in-eigr2
          i_eigr3  = ls_ikofi_in-eigr3
          i_eigr4  = ls_ikofi_in-eigr4
          i_komo1  = ls_ikofi_in-komo1
          i_komo1b = ls_ikofi_in-komo1b
          i_komo2  = ls_ikofi_in-komo2
          i_komo2b = ls_ikofi_in-komo2b
          i_ktopl  = ls_ikofi_in-ktopl
          i_sakin  = ls_ikofi_in-sakin
          i_sakinb = ls_ikofi_in-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_in
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc IS INITIAL
     AND ls_ikofi_in-sakn1 IS NOT INITIAL.

        APPEND INITIAL LINE TO lr_hkont ASSIGNING FIELD-SYMBOL(<fs_r_hkont>).
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_in-sakn1.
      ENDIF.

      " BR - Saida
      DATA(ls_ikofi_out) =  VALUE ikofi( anwnd = '0001'
                                         eigr1 = 'B00C'
                                         eigr2 = '1'
                                         komo1 = '+'
                                         komo2 = 'BRL'
                                         ktopl = 'PC01'
                                         sakin =  <fs_t012k>-hkont ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_out-anwnd
          i_eigr1  = ls_ikofi_out-eigr1
          i_eigr2  = ls_ikofi_out-eigr2
          i_eigr3  = ls_ikofi_out-eigr3
          i_eigr4  = ls_ikofi_out-eigr4
          i_komo1  = ls_ikofi_out-komo1
          i_komo1b = ls_ikofi_out-komo1b
          i_komo2  = ls_ikofi_out-komo2
          i_komo2b = ls_ikofi_out-komo2b
          i_ktopl  = ls_ikofi_out-ktopl
          i_sakin  = ls_ikofi_out-sakin
          i_sakinb = ls_ikofi_out-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_out
        EXCEPTIONS
          OTHERS   = 1.

      IF sy-subrc IS INITIAL
     AND ls_ikofi_out-sakn1 IS NOT INITIAL.
        UNASSIGN <fs_r_hkont>.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING <fs_r_hkont>.
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_out-sakn1.
      ENDIF.
    ENDLOOP.

    " Verificar contas de bancos na compensação
    lt_bseg[] = it_bseg[].
    DELETE lt_bseg WHERE hkont NOT IN lr_hkont.

    IF lt_bseg[] IS NOT INITIAL.
      ev_paid  = abap_true.      " Status compensada e paga.
    ELSE.
      ev_paid  = abap_false.     " Status compensada (mas não paga).
    ENDIF.

    ev_augdt = <fs_ausz2>-augdt. " Data de Compensação

    " Atualizar registros encontrados
    LOOP AT lt_gkot001 ASSIGNING <fs_zgkot001>.

      " Atualiza o status de compensação no Monitor de Acompanhamento
      DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey = <fs_zgkot001>-acckey ).

      lr_gko_process->set_invoice_as_paid( iv_augdt  = ev_augdt
                                           iv_pago   = ev_paid   ).
      lr_gko_process->persist( ).
      lr_gko_process->free( ).

      " Remover da tabela de reprocessamento
      IF sy-tabix EQ 1. "Executar apenas a primeira vez
        DATA(lr_gko_incoming_invoice) = NEW zclfi_gko_incoming_invoice( ).

        lr_gko_incoming_invoice->set_invoice( iv_invoice_number = CONV #( <fs_zgkot001>-num_fatura )
                                              iv_cnpj_issue     = CONV #( <fs_zgkot001>-emit_cnpj_cpf ) ).
        CHECK lr_gko_incoming_invoice->get_errors( ) IS INITIAL.
        lr_gko_incoming_invoice->remove( ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD send_cte_to_gko.

    DATA: lv_filename TYPE string,
          lv_message  TYPE string.

    DATA(lv_dir_cte_gko) = get_parameter( zcltm_gko_process=>gc_params-diretorio_cte_gko ).

    lv_filename = |{ lv_dir_cte_gko }/{ gs_gko_header-acckey }.xml|.

    " Cria o arquivo de destino
    OPEN DATASET lv_filename FOR OUTPUT IN BINARY MODE
                             MESSAGE lv_message.
    IF sy-subrc IS NOT INITIAL.

      " Erro ao criar o arquivo &, &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>gc_error_create_file
          gv_msgv1 = CONV #( lv_filename )
          gv_msgv2 = CONV #( lv_message ).

    ENDIF.

    TRANSFER gv_xml_content TO lv_filename.

    CLOSE DATASET lv_filename.

  ENDMETHOD.


  METHOD reversal_purchase_order_ex.

    FREE: et_return.

    dequeue_acckey( ).

* ----------------------------------------------------------------------
* Método criado para chamada RFC da BAPI de compensação FI
* ----------------------------------------------------------------------
    FREE: gt_return, gv_wait_async, gv_success.

    CALL FUNCTION 'ZFMTM_REVERSAL_PURCHASE_ORDER'
      STARTING NEW TASK 'REVERSAL_PURCHASE_ORDER'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_acckey    = me->gv_acckey
        iv_tpprocess = me->gv_tpprocess.

    WAIT UNTIL gv_wait_async = abap_true.


    " Mensagens do processo
    IF gt_return IS NOT INITIAL.
      me->add_to_log( it_bapi_ret = gt_return ).
      et_return = gt_return.
    ENDIF.

    IF gt_return IS NOT INITIAL AND gt_bapi_return IS INITIAL.
      RETURN.
    ENDIF.

    " Mensagens do retorno da bapi de compensação
    IF line_exists( gt_bapi_return[ type = 'E' ] ).
      me->set_status( iv_status   = zcltm_gko_process=>gc_codstatus-erro_ao_eliminar_pedido
                      it_bapi_ret = gt_bapi_return ).
    ELSE.
      DATA(lt_return) = gt_bapi_return.
    ENDIF.

    " Muda status do documento
    IF gv_success EQ abap_true.
* BEGIN OF DELETE - JWSILVA - 30.03.2023
*      me->set_status( iv_status   = zcltm_gko_process=>gc_codstatus-aguardando_estorno_dff
*                      it_bapi_ret = lt_return ).
* BEGIN OF DELETE - JWSILVA - 30.03.2023
* BEGIN OF INSERT - JWSILVA - 30.03.2023
      " Em caso de estorno, a determination ZCLTM_INVOICING_STATUS vai calcular o novo status.
      " Precisamos atualizar o relatório
      gv_min_data_load = abap_false.
      me->load_data_from_acckey( ).
* END OF INSERT - JWSILVA - 30.03.2023

    ELSEIF NOT line_exists( gt_bapi_return[ id = 'ZTM_GKO' number = '013' ] ).
      me->set_status( iv_status   = zcltm_gko_process=>gc_codstatus-erro_ao_eliminar_dff
                      it_bapi_ret = lt_return ).
    ENDIF.

    TRY.
        me->enqueue_acckey( iv_locked_in_tab = gv_locked_in_tab ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD reversal_purchase_order.

    DATA: lt_changed     TYPE /bobf/t_frw_name,
          lt_mod         TYPE /bobf/t_frw_modification,
          lt_bapi_return TYPE bapiret2_t,
          lt_return      TYPE bapiret2_t,
          lt_tcc         TYPE /scmtms/t_tcc_root_k.

    FREE et_return.

    IF gs_gko_header-re_belnr IS NOT INITIAL.
      " Não é possível estornar o pedido antes da fatura.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GKO' number = '105' ) ).
      RETURN.
    ENDIF.

* Tabelas internas
    DATA: lt_seltab    TYPE TABLE OF rsparams,
          lt_tor_id    TYPE /scmtms/t_tor_id,
          lt_sfir_root TYPE /scmtms/t_sfir_root_k,
          lt_chrg_elem TYPE /scmtms/t_tcc_trchrg_element_k.

    IF gv_acckey IS INITIAL.
      RETURN.
    ENDIF.

    " Recupera Documento de faturamento de frete (DFF) e Ordem de Frete (OF)
    SELECT SINGLE tor_id, sfir_id, TransportationOrderUUID
      FROM zi_tm_cockpit001
      WHERE acckey = @gv_acckey
      INTO @DATA(ls_001).

    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    " -----------------------------------------------------------------------
    " 1. Busca os dados de DFF
    " -----------------------------------------------------------------------
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = ls_001-TransportationOrderUUID ) ) " it_torkey
        iv_association = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_sfir_root ).

    IF lt_sfir_root IS INITIAL.
      RETURN.
    ENDIF.

    DELETE lt_sfir_root WHERE zzacckey <> gv_acckey.     " Chave de acesso
    DELETE lt_sfir_root WHERE sfir_id <> ls_001-sfir_id. " Documento de faturamente de frete (DFF)
    DELETE lt_sfir_root WHERE lifecycle = 06.            " Ciclo de vida: Cancelado

    IF lt_sfir_root IS INITIAL.
      " Nenhum documento DFF encontrado para estorno.
      RETURN.
*      RAISE EXCEPTION TYPE zcxtm_gko_process
*        EXPORTING
*          textid         = zcxtm_gko_process=>error_on_reversal_po
*          gt_bapi_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '106' ) ).
    ENDIF.

    " -----------------------------------------------------------------------
    " 1. Inicia processo de "CANCELAMENTO" do pedido de compra e DFF
    " -----------------------------------------------------------------------
    DATA(lo_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key ).

    lo_srvmgr_tor->do_action( EXPORTING iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-cancel
                                        it_key        = CORRESPONDING #( lt_sfir_root MAPPING key = key )
                              IMPORTING eo_message    = DATA(lo_message)
                                        et_failed_key = DATA(lt_failed_key) ).

* BEGIN OF CHANGE - JWSILVA - 30.03.2023
    IF lt_failed_key IS NOT INITIAL
    OR line_exists( lt_sfir_root[ lifecycle = '24' ] ). "  Depuraração de lançamento inciado

      " -----------------------------------------------------------------------
      " 1.2 Em caso de erro no "CANCELAMENTO" provavelmente o status atual não
      "     está habilitado pra isso. Então temos que voltar para o status
      "     "EM PROCESSAMENTO"
      " -----------------------------------------------------------------------
      lo_srvmgr_tor->do_action( EXPORTING iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-set_ready_for_accruals
                                          it_key        = CORRESPONDING #( lt_sfir_root MAPPING key = key )
                                IMPORTING eo_message    = lo_message
                                          et_failed_key = lt_failed_key ).

      IF lt_failed_key IS INITIAL.

        /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING ev_rejected = DATA(lv_rejected)
                                                                                    eo_message  = lo_message ).

        WAIT UP TO 2 SECONDS.

        " -----------------------------------------------------------------------
        " 1.3 Caso "EM PROCESSAMENTO" funcione, tentamos o "CANCELAMENTO" novamente
        " -----------------------------------------------------------------------
        lo_srvmgr_tor->do_action( EXPORTING iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-cancel
                                            it_key        = CORRESPONDING #( lt_sfir_root MAPPING key = key )
                                  IMPORTING eo_message    = lo_message
                                            et_failed_key = lt_failed_key ).
      ENDIF.
    ENDIF.


    IF lt_failed_key IS INITIAL.

      /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING ev_rejected = lv_rejected
                                                                                  eo_message  = lo_message ).

      WAIT UP TO 2 SECONDS.

      " Como existe uma determination que também atualiza o status do Cockpit,
      " precisamos carregar os dados novamente
      gv_min_data_load = abap_false.
      me->load_data_from_acckey( ).

    ELSE.

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return ).

      rv_success = abap_false.

      set_status( iv_status   = gc_codstatus-erro_ao_eliminar_dff
                  it_bapi_ret = lt_return ).

    ENDIF.

* END OF CHANGE - JWSILVA - 30.03.2023

    " -----------------------------------------------------------------------
    " 2. Remove custo EXTRA ou NORMAL
    " -----------------------------------------------------------------------

* BEGIN OF CHANGE - JWSILVA - 27.03.2023
*
*    " O passo (2.) foi removido da execução, pois havia inconsitências ao chamar por aqui.
*    " A nova regra será feito via DETERMINATION da BOBF pela classe: ZCLTM_INVOICING_STATUS
*    " O custo extra/normal será removido quando o DFF mudar para o status "Cancelado".
*
* END OF CHANGE - JWSILVA - 27.03.2023

    IF line_exists( lt_return[ type = 'E' ] ).

      " Falha ao eliminar automaticamente o custo extra &1.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid         = zcxtm_gko_process=>error_on_reversal_po
          gt_bapi_return = VALUE #( ( type = 'W' id = 'ZTM_GKO' number = '145' message_v1 = gs_gko_header-tpevento ) ).

    ENDIF.

  ENDMETHOD.


  METHOD reversal_invoice_grouping.

    DATA(lv_stgrd) = iv_stgrd.
    DATA(lv_budat) = iv_budat.

    check_status_from_action( iv_action = gc_acao-estorno
                              iv_status = gs_gko_header-codstatus ).

    TRY.
        IF gs_gko_header-belnr IS NOT INITIAL.

          IF lv_stgrd IS INITIAL.
            lv_stgrd = '01'.
            SELECT SINGLE
                   budat
              FROM bkpf
              INTO lv_budat
             WHERE bukrs = gs_gko_header-bukrs_doc
               AND belnr = gs_gko_header-belnr
               AND gjahr = gs_gko_header-gjahr.
          ENDIF.

          CALL FUNCTION 'CALL_FBRA'
            EXPORTING
              i_bukrs      = gs_gko_header-bukrs_doc
              i_augbl      = gs_gko_header-belnr
              i_gjahr      = gs_gko_header-gjahr
              i_update     = 'S'
              i_mode       = 'N'
              i_no_auth    = space
            EXCEPTIONS
              not_possible = 1
              OTHERS       = 2.

          IF sy-subrc <> 0
         AND sy-msgid <> 'F0'
         AND sy-msgno <> '604'
         AND sy-msgty = 'E'.

            " Erro ao realizar a anulação do doc. de agrupamento de fatura &.
            RAISE EXCEPTION TYPE zcxtm_gko_process
              EXPORTING
                textid         = zcxtm_gko_process=>error_on_cancel_doc_group_inv
                gv_msgv1       = |{ gs_gko_header-bukrs_doc }{ gs_gko_header-belnr }{ gs_gko_header-gjahr }|
                gt_bapi_return = VALUE #( ( id         = sy-msgid
                                            number     = sy-msgno
                                            type       = sy-msgty
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
          ENDIF.

          CALL FUNCTION 'CALL_FB08'
            EXPORTING
              i_bukrs      = gs_gko_header-bukrs_doc
              i_belnr      = gs_gko_header-belnr
              i_gjahr      = gs_gko_header-gjahr
              i_stgrd      = lv_stgrd
              i_budat      = lv_budat
              i_update     = 'S'
              i_mode       = 'N'
              i_no_auth    = space
            EXCEPTIONS
              not_possible = 1
              OTHERS       = 2.

          IF sy-subrc <> 0.

            " Erro ao realizar o estorno do doc. de agrupamento de fatura &.
            RAISE EXCEPTION TYPE zcxtm_gko_process
              EXPORTING
                textid         = zcxtm_gko_process=>error_on_rev_doc_group_inv
                gv_msgv1       = |{ gs_gko_header-bukrs_doc }{ gs_gko_header-belnr }{ gs_gko_header-gjahr }|
                gt_bapi_return = VALUE #( ( id         = sy-msgid
                                            number     = sy-msgno
                                            type       = sy-msgty
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
          ENDIF.

          " Documento de agrupamento &, estornado com sucesso.
          MESSAGE s074(ztm_gko)
            WITH |{ gs_gko_header-bukrs_doc }{ gs_gko_header-belnr }{ gs_gko_header-gjahr }|
            INTO DATA(lv_message).

          FREE: gs_gko_header-bukrs_doc, gs_gko_header-belnr, gs_gko_header-gjahr.

          set_status( iv_status   = gc_codstatus-estorno_agrupamento_realizado
                      iv_desc_cod = CONV #( lv_message ) ).

        ENDIF.

        rv_success = abap_true.

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        set_status( iv_status   = gc_codstatus-erro_estorno_agrupamento
                    it_bapi_ret = lr_cx_gko_process->get_bapi_return( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD reversal_invoice.

    DATA: lt_return         TYPE bapiret2_t,
          lv_reversal_belnr TYPE bapi_incinv_fld-inv_doc_no,
          lv_reversal_gjahr TYPE bapi_incinv_fld-fisc_year.

    check_status_from_action( iv_action = gc_acao-estorno
                              iv_status = gs_gko_header-codstatus ).

    TRY.
        DATA(lv_stgrd) = iv_stgrd.
        DATA(lv_budat) = iv_budat.

        IF gs_gko_header-re_belnr IS NOT INITIAL AND gs_gko_header-belnr IS INITIAL.

          SELECT SINGLE
                 budat,
                 rbstat
            FROM rbkp
            INTO @DATA(ls_rbkp)
            WHERE belnr = @gs_gko_header-re_belnr
              AND gjahr = @gs_gko_header-re_gjahr.

          IF lv_stgrd IS INITIAL.
            lv_stgrd = '01'.
            lv_budat = ls_rbkp-budat.
          ENDIF.

          " Verifica se documento já foi estornado manualmente
          gv_success = check_invoice_before_reversal( EXPORTING iv_belnr = gs_gko_header-re_belnr
                                                                iv_gjahr = gs_gko_header-re_gjahr
                                                      IMPORTING ev_stblg = lv_reversal_belnr
                                                                ev_stjah = lv_reversal_gjahr ).
          IF gv_success NE abap_true.

            " Memorizado?
            IF ls_rbkp-rbstat IS NOT INITIAL AND ls_rbkp-rbstat <> gc_invoice_status-registrado.

              CLEAR gv_success.

              CALL FUNCTION 'ZFMTM_GKO_INCM_DELETE'
                STARTING NEW TASK 'TM_INCM_DELETE'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  iv_invnumber  = gs_gko_header-re_belnr
                  iv_fiscalyear = gs_gko_header-re_gjahr.

              WAIT UNTIL gv_wait_async = abap_true.
              lt_return = gt_return.

              FREE: gt_return[],
                    gv_wait_async.

            ELSE.

              " Limpa a estrutura para evitar o erro 8B 247 'Não é possível criar nota fiscal de referência'
              ASSIGN ('(SAPLJ1BI)NFHEADER') TO FIELD-SYMBOL(<fs_nfheader>).
              IF sy-subrc IS INITIAL.
                FREE: <fs_nfheader>.
              ENDIF.

              FREE: gv_success,
                    gt_return[],
                    gv_wait_async,
                    gv_invnumber_reversal,
                    gv_fiscalyear_reversal.

              CALL FUNCTION 'ZFMTM_GKO_INCM_CANCEL'
                STARTING NEW TASK 'TM_INCM_CANCEL'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  iv_invoicedocnumber = gs_gko_header-re_belnr
                  iv_fiscalyear       = gs_gko_header-re_gjahr
                  iv_reasonreversal   = lv_stgrd
                  iv_postingdate      = lv_budat.

              WAIT UNTIL gv_wait_async = abap_true.
              lt_return         = gt_return.
              lv_reversal_belnr = gv_invnumber_reversal.
              lv_reversal_gjahr = gv_fiscalyear_reversal.

              IF gv_invnumber_reversal IS NOT INITIAL.
                gv_success = abap_true.
              ENDIF.

              FREE: gt_return[],
                    gv_wait_async,
                    gv_invnumber_reversal,
                    gv_fiscalyear_reversal.

            ENDIF.

*          IF line_exists( lt_return[ type = 'E' ] )
*          OR ( lv_reversal_belnr IS INITIAL AND ls_rbkp-rbstat = gc_invoice_status-registrado ).
            IF gv_success IS INITIAL.

              DELETE lt_return WHERE type = 'S'
                                 OR  type = 'W'
                                 OR  type = 'I'.

              " Erro ao realizar o estorno da Fatura &.
              RAISE EXCEPTION TYPE zcxtm_gko_process
                EXPORTING
                  textid         = zcxtm_gko_process=>error_on_reversal_inc_invoice
                  gv_msgv1       = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }|
                  gt_bapi_return = lt_return.

            ELSE.

              " Fatura &, estornada com sucesso.
              MESSAGE s075(ztm_gko)
                 WITH |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }|
                 INTO DATA(lv_message).

            ENDIF.

          ELSE.
            " Fatura &1 já foi estornada.
            MESSAGE s129(ztm_gko)
               WITH |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }|
               INTO lv_message.
          ENDIF.

          IF gs_gko_header-docger = gc_docger-miro_deb_posterior.
            set_status( iv_status   = gc_codstatus-estorno_miro_deb_p_realizado_n
                        iv_desc_cod = CONV #( lv_message ) ).
          ELSE.
            set_status( iv_status   = gc_codstatus-estorno_miro_realizado_n
                        iv_desc_cod = CONV #( lv_message ) ).
          ENDIF.

          IF lv_reversal_belnr IS NOT INITIAL.

            clear_reversal_fi_documents_ex( iv_re_belnr  = gs_gko_header-re_belnr
                                            iv_re_gjahr  = gs_gko_header-re_gjahr
                                            iv_rev_belnr = lv_reversal_belnr
                                            iv_rev_gjahr = lv_reversal_gjahr ).

          ENDIF.

          FREE: gs_gko_header-re_belnr,
                gs_gko_header-re_gjahr.

        ENDIF.

        rv_success = abap_true.

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        IF gs_gko_header-docger = gc_docger-miro_deb_posterior.
          set_status( iv_status   = gc_codstatus-erro_estorno_miro_deb_post
                      it_bapi_ret = lr_cx_gko_process->get_bapi_return( )  ).
        ELSE.
          set_status( iv_status   = gc_codstatus-erro_estorno_miro
                      it_bapi_ret = lr_cx_gko_process->get_bapi_return( ) ).
        ENDIF.

    ENDTRY.

    " Limpa documentos estornados.
    IF gv_success EQ abap_true.
      CLEAR: gs_gko_header-re_belnr, gs_gko_header-re_gjahr.
    ENDIF.

  ENDMETHOD.


  METHOD check_invoice_before_reversal.

    FREE: ev_stblg, ev_stjah.

    CHECK iv_belnr IS NOT INITIAL.
    CHECK iv_gjahr IS NOT INITIAL.

    SELECT SINGLE stblg, stjah
        FROM rbkp
        INTO @DATA(ls_rbkp)
        WHERE belnr EQ @iv_belnr
          AND gjahr EQ @iv_gjahr.

    IF sy-subrc NE 0.
      CLEAR ls_rbkp.
    ENDIF.

    ev_stblg = ls_rbkp-stblg.
    ev_stjah = ls_rbkp-stjah.

    " Retorna se fatura foi estornada com sucesso
    rv_success = COND #( WHEN ev_stblg IS NOT INITIAL
                         THEN abap_true
                         ELSE abap_false ).

  ENDMETHOD.


  METHOD reversal_documents.

    IF gs_gko_header-belnr IS NOT INITIAL.

      set_status( gc_codstatus-aguardando_estorno_agrupamento ).

    ELSE.

      TRY.
          IF reversal_invoice( ) <> abap_true.

            set_status( iv_status = gc_codstatus-erro_ao_realizar_estorno_canc ).

          ELSE.

            IF reversal_purchase_order( ) <> abap_true.

              set_status( iv_status = gc_codstatus-erro_ao_realizar_estorno_canc ).

            ELSE.

              set_status( gc_codstatus-documento_cancelado_reversao_r ).

            ENDIF.

          ENDIF.

        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

          set_status( iv_status = gc_codstatus-erro_ao_realizar_estorno_canc
                      it_bapi_ret = lr_cx_gko_process->get_bapi_return( ) ).

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD reversal.

    IF iv_tipo_doc IS INITIAL.

      check_status_from_action( iv_action = gc_acao-estorno_completo
                                iv_status = gs_gko_header-codstatus ).

      TRY.
          reversal_invoice_grouping( iv_stgrd = iv_stgrd
                                     iv_budat = iv_budat ).

          reversal_invoice( iv_stgrd = iv_stgrd
                            iv_budat = iv_budat ).

          reversal_purchase_order( ).

          set_status( iv_status = gc_codstatus-estorno_total_realizado ).

        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

          set_status( iv_status   = gc_codstatus-erro_ao_realizar_estorno_total
                      it_bapi_ret = lr_cx_gko_process->get_bapi_return( )      ).

      ENDTRY.

    ELSE.

      check_status_from_action( iv_action = gc_acao-estorno_fiscal
                                iv_status = gs_gko_header-codstatus ).

      TRY.
          CASE iv_tipo_doc.

            WHEN gc_tipo_docger-agrupamento_fatura.
              reversal_invoice_grouping( iv_stgrd = iv_stgrd
                                         iv_budat = iv_budat ).

            WHEN gc_tipo_docger-fatura.
              reversal_invoice( iv_stgrd = iv_stgrd
                                iv_budat = iv_budat ).

            WHEN gc_tipo_docger-pedido.
              reversal_purchase_order( ).

          ENDCASE.

          IF gs_gko_header-docger = gc_docger-miro_deb_posterior.

            set_status( iv_status = gc_codstatus-estorno_miro_deb_p_realizado ).

          ELSE.

            set_status( iv_status = gc_codstatus-estorno_realizado ).

          ENDIF.

        CATCH zcxtm_gko_process INTO lr_cx_gko_process.

          set_status( iv_status   = gc_codstatus-erro_ao_realizar_estorno
                      it_bapi_ret = lr_cx_gko_process->get_bapi_return( ) ).

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD reprocess.

    DATA: lv_codstatus_ate TYPE zttm_pcockpit016-codstatus_para.

    SELECT codstatus_para
      FROM zttm_pcockpit016
     WHERE acao          = @gc_acao-reprocessar
       AND codstatus_de  = @gs_gko_header-codstatus
       AND codstatus_para <> @space
      INTO @lv_codstatus_ate
     UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS NOT INITIAL.

      " O Código de Status &, não permite o Reprocessamento.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>status_not_allowed_for_reproc
          gv_msgv1 = CONV #( gs_gko_header-codstatus ).

    ENDIF.

    set_status( iv_status = lv_codstatus_ate ).

    process( ).

  ENDMETHOD.


  METHOD reject.

    DATA: lv_message TYPE bapi_msg,
          lv_rc      TYPE sy-subrc.

    IF gs_gko_header-tpdoc <> gc_tpdoc-cte.

      " O evento não é permitido para o tipo de documento &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>gc_event_not_allowed_for_tpdoc
          gv_msgv1 = CONV #( gs_gko_header-tpdoc ).

    ENDIF.

    check_status_from_action( iv_action = gc_acao-evento_cte
                              iv_status = gs_gko_header-codstatus ).

    set_reject( EXPORTING iv_cteid    = gs_gko_header-acckey
                          iv_not_code = iv_not_code
                IMPORTING ev_rc       = lv_rc
                          ev_message  = lv_message ).

    IF sy-subrc IS INITIAL
   AND lv_rc IS INITIAL.

      set_status( gc_codstatus-evt_rejeicao_aguard_sefaz ).

    ELSE.

      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko=>gc_zcxtm_gko
          gv_msgv1 = lv_message(50)
          gv_msgv2 = lv_message+50(50)
          gv_msgv3 = lv_message+100(50)
          gv_msgv4 = lv_message+150(50).

    ENDIF.

  ENDMETHOD.


  METHOD fill_add_data.

    DATA: lt_zgkop006 TYPE STANDARD TABLE OF zttm_pcockpit013.

    DATA: lt_j1_doc   TYPE STANDARD TABLE OF j_1bnfdoc.

    DATA: lv_branch_entrega  TYPE j_1bbranch-branch,
          lv_branch_retirada TYPE j_1bbranch-branch.

    DO 1 TIMES.

      " Obtêm o código da transportadora
      me->get_partner( EXPORTING iv_cnpj    = CONV #( gs_gko_header-emit_cnpj_cpf )
                       IMPORTING ev_partner = gs_gko_header-emit_cod ).

      IF gs_gko_header-emit_cod IS INITIAL.
        set_status( gc_codstatus-cod_transp_nao_encontrado ).
        CONTINUE.
      ENDIF.

      " Obtêm o código do tomador
      me->get_partner( EXPORTING iv_cnpj    = CONV #( gs_gko_header-tom_cnpj_cpf )
                                 iv_ie      = CONV #( gs_gko_header-tom_ie )
                       IMPORTING ev_partner = gs_gko_header-tom_cod ).

      IF gs_gko_header-tom_cod IS INITIAL.
        set_status( gc_codstatus-cod_tomador_nao_encontrado ).
        CONTINUE.
      ENDIF.

      " Obtêm o código do remetente
      me->get_partner( EXPORTING iv_cnpj    = CONV #( gs_gko_header-rem_cnpj_cpf )
                       IMPORTING ev_partner = gs_gko_header-rem_cod ).

      IF gs_gko_header-rem_cod IS INITIAL.
        set_status( gc_codstatus-cod_remetente_nao_encontrado ).
        CONTINUE.
      ENDIF.

      " Obtêm o código do destinatário
      me->get_partner( EXPORTING iv_cnpj    = CONV #( gs_gko_header-dest_cnpj )
                                 iv_cpf     = CONV #( gs_gko_header-dest_cpf )
                       IMPORTING ev_partner = gs_gko_header-dest_cod ).

      IF gs_gko_header-dest_cod IS INITIAL.
        set_status( gc_codstatus-cod_dest_nao_encontrado ).
        CONTINUE.
      ENDIF.

      " Obtêm o código do expedidor (Opcional)
      IF gs_gko_header-exped_cnpj IS NOT INITIAL OR gs_gko_header-exped_cpf IS NOT INITIAL.

        me->get_partner( EXPORTING iv_cnpj    = CONV #( gs_gko_header-exped_cnpj )
                                   iv_cpf     = CONV #( gs_gko_header-exped_cpf )
                         IMPORTING ev_partner = gs_gko_header-exped_cod ).

        IF gs_gko_header-exped_cod IS INITIAL.
          set_status( gc_codstatus-cod_expedidor_nao_encontrado ).
          CONTINUE.
        ENDIF.
      ENDIF.

      " Obtêm o código do recebedor (Opcional)
      IF gs_gko_header-receb_cnpj IS NOT INITIAL OR gs_gko_header-receb_cpf IS NOT INITIAL.

        me->get_partner( EXPORTING iv_cnpj    = CONV #( gs_gko_header-receb_cnpj )
                                   iv_cpf     = CONV #( gs_gko_header-receb_cpf )
                         IMPORTING ev_partner = gs_gko_header-receb_cod ).

        IF gs_gko_header-receb_cod IS INITIAL.
          set_status( gc_codstatus-cod_recebedor_nao_encontrado ).
          CONTINUE.
        ENDIF.
      ENDIF.

      DATA(lv_rem_ie)  = CONV j_1bstains( |%{ gs_gko_header-rem_ie }| ).
      DATA(lv_dest_ie) = CONV j_1bstains( |%{ gs_gko_header-dest_ie }| ).

      " Obtêm a empresa e filial remetente
      SELECT SINGLE bukrs, branch
        FROM j_1bbranch
        INTO (@gs_gko_header-bukrs, @gs_gko_header-branch)
       WHERE cgc_branch EQ   @gs_gko_header-rem_cnpj_cpf+8(4)
         AND state_insc LIKE @lv_rem_ie.

      IF sy-subrc IS NOT INITIAL.

        " Obtêm a empresa e filial destinataria
        SELECT SINGLE bukrs, branch
          FROM j_1bbranch
          INTO (@gs_gko_header-bukrs, @gs_gko_header-branch)
         WHERE cgc_branch EQ   @gs_gko_header-dest_cnpj+8(4)
           AND state_insc LIKE @lv_dest_ie.

      ENDIF.

      IF sy-subrc IS NOT INITIAL.

        set_status( gc_codstatus-empresa_filial_nao_encontrado ).
        CONTINUE.

      ENDIF.

      " Se encontrou os dados, seta o status como integrado
      set_status( gc_codstatus-documento_integrado ).

    ENDDO.

    " Local de Negócio de Retirada e Entrega
    LOOP AT gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_reference>).

      SELECT SINGLE *
        INTO @DATA(ls_j1_doc) FROM j_1bnfdoc
        WHERE docnum = @<fs_s_reference>-docnum.

      IF sy-subrc IS INITIAL.

        IF ls_j1_doc-direct EQ '1'. "NF Entrada"
          lv_branch_entrega = ls_j1_doc-branch.

          SELECT SINGLE j_1bbranch
            FROM T001w
            INTO @lv_branch_retirada
            WHERE werks       = @ls_j1_doc-parid(4) AND
                  j_1bbranch  = @ls_j1_doc-parid+4(4).


        ELSE. "NF Saída"
          lv_branch_retirada = ls_j1_doc-branch.

          SELECT SINGLE j_1bbranch
           FROM T001w
           INTO @lv_branch_entrega
           WHERE werks       = @ls_j1_doc-parid(4) AND
                 j_1bbranch  = @ls_j1_doc-parid+4(4).
        ENDIF.
      ENDIF.

      " Se algum local foi encontrado, considera-se o mesmo para a busca
      IF lv_branch_entrega IS NOT INITIAL
      OR lv_branch_retirada IS NOT INITIAL.
        EXIT.
      ENDIF.

    ENDLOOP.

    gs_gko_header-ret_loc = lv_branch_retirada.
    gs_gko_header-ent_loc = lv_branch_entrega.

    GET TIME.

    gs_gko_header-sitdoc = gc_sitdoc-autorizado.
    gs_gko_header-chadat = sy-datum.
    gs_gko_header-chatim = sy-uzeit.
    gs_gko_header-chanam = sy-uname.

  ENDMETHOD.


  METHOD faturar_etapa.

* ---------------------------------------------------------------------------
* Verifica se foi feito o cálculo de custo
* ---------------------------------------------------------------------------
* Determinado na classe ZCLTM_TCC_RULES->/scmtms/if_tcc_rules~charge_calc_through_formula
* ---------------------------------------------------------------------------
    DATA(lv_success) = me->faturar_etapa_valid_calc_custo( iv_torid = iv_torid ).
    CHECK lv_success EQ abap_true.

    TRY.
        me->persist( ).
        me->dequeue_acckey( ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Inicia processo de documento de faturamente de frete (DFF)
* ---------------------------------------------------------------------------
    DATA(lv_dest_cod) = gs_gko_header-dest_cod.
    DATA(lv_rem_cod) = gs_gko_header-rem_cod.

* ---------------------------------------------------------------------------
* Recupera o último contador
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_gko_logs) = gt_gko_logs.
        SORT lt_gko_logs BY counter DESCENDING.
        DATA(lv_counter) = lt_gko_logs[ 1 ]-counter.
      CATCH cx_root.
        CLEAR lv_counter.
    ENDTRY.

    FREE: gv_wait_async, gt_return.

    CALL FUNCTION 'ZFMTM_GKO_FATURAR_ETAPA'
      STARTING NEW TASK 'GKO_FATURAR_ETAPA'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_gko_header = gs_gko_header.

    WAIT UNTIL gv_wait_async = abap_true.
    DATA(lt_return) = gt_return.

    " Remove linha de log 'Lançamento FRS iniciado' do tipo erro
    DELETE lt_return WHERE type       = 'E'
                       AND id         = '00'
                       AND number     = '208'
                       AND message_v1 = 'Lançamento FRS iniciado'.

    TRY.
        me->enqueue_acckey( gv_locked_in_tab ).
        gv_min_data_load = abap_false.
        me->load_data_from_acckey( ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Separa as mensagens de logs que foram salvos durante etapa de fatura
* ---------------------------------------------------------------------------
    DATA(lt_gko_logs_new) = gt_gko_logs.
    DELETE lt_gko_logs_new WHERE counter <= lv_counter.
    DELETE gt_gko_logs WHERE counter > lv_counter.

    " Caso a mensagem for um erro, atualizar com erro as próximas linhas
    LOOP AT lt_gko_logs_new INTO DATA(ls_gko_logs). "#EC CI_LOOP_INTO_WA
      CHECK ls_gko_logs-codstatus+0(1) = 'E'.
      EXIT.
    ENDLOOP.

    IF ls_gko_logs-codstatus+0(1) = 'E'.
      LOOP AT lt_return REFERENCE INTO DATA(ls_return).
        ls_return->type = 'E'.
      ENDLOOP.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica mensagens de retorno
* ---------------------------------------------------------------------------
    IF line_exists( lt_return[ id = '/SCMTMS/MSG' number = '252' ] )
    OR line_exists( lt_return[ id = '/SCMTMS/MSG' number = '253' ] ).

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-bloqueio_usuario_faturam_frete
                                it_bapi_ret = lt_return ).

    ELSEIF NOT line_exists( lt_return[ type = 'E' ] ).

      me->set_status( EXPORTING iv_status = COND #( WHEN gs_gko_header-codstatus = zcltm_gko_process=>gc_codstatus-frete_faturado
                                                    THEN zcltm_gko_process=>gc_codstatus-frete_faturado
                                                    ELSE zcltm_gko_process=>gc_codstatus-aguardando_faturamento_frete ) ).

    ELSE.

      DELETE ADJACENT DUPLICATES FROM lt_return COMPARING id number message_v1 message_v2 message_v3 message_v4.

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_fat_frete
                                it_bapi_ret = lt_return ).

    ENDIF.

* ---------------------------------------------------------------------------
* Salva as mensages da funcão no final da lista
* ---------------------------------------------------------------------------
    TRY.
        lt_gko_logs = gt_gko_logs.
        SORT lt_gko_logs BY counter DESCENDING.
        lv_counter = lt_gko_logs[ 1 ]-counter.
      CATCH cx_root.
        CLEAR lv_counter.
    ENDTRY.

    LOOP AT lt_gko_logs_new REFERENCE INTO DATA(ls_gko_logs_new).
      ls_gko_logs_new->codstatus = gs_gko_header-codstatus.
      ls_gko_logs_new->counter   = lv_counter = lv_counter + 1.
      ls_gko_logs_new->credat    = sy-datum.
      ls_gko_logs_new->cretim    = sy-uzeit.
      ls_gko_logs_new->crenam    = sy-uname.
    ENDLOOP.

    INSERT LINES OF lt_gko_logs_new INTO TABLE gt_gko_logs.

  ENDMETHOD.


  METHOD faturar_etapa_valid_calc_custo.

    DATA: lv_tor_id TYPE /scmtms/d_torrot-tor_id.

    FREE: rv_success.

    lv_tor_id = |{ iv_torid ALPHA = IN }|.

* ---------------------------------------------------------------------------
* Recupera valor do custo
* ---------------------------------------------------------------------------
    SELECT SINGLE
           root~db_key,
           root~tor_id,
           charge~net_amount
       FROM /scmtms/d_torrot AS root
       LEFT OUTER JOIN /scmtms/d_tchrgr AS charge
       ON charge~host_key = root~db_key
       WHERE root~tor_id EQ @lv_tor_id
       INTO @DATA(ls_root).

* ---------------------------------------------------------------------------
* Aplica validações
* ---------------------------------------------------------------------------
    IF sy-subrc NE 0.
      " Ordem de frete &1 não encontrado para validação do cálculo de custos.
      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_calc_custo
                                it_bapi_ret = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '131' message_v1 = iv_torid ) ) ).
      RETURN.
    ENDIF.

    IF ls_root-net_amount EQ 0.
      " Ordem de frete &1 com cálculo de custos zerado.
      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_calc_custo
                                it_bapi_ret = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '132' message_v1 = iv_torid ) ) ).
      RETURN.
    ENDIF.

    rv_success = abap_true.

  ENDMETHOD.


  METHOD extra_charge.

    DATA  lv_tipo_custo TYPE /scmtms/trcharg_elmnt_typecd.

    IF gs_gko_header-tpdoc EQ gc_tpdoc-cte AND gs_gko_header-tpcte EQ gc_tpcte-complemento_de_valores.
      lv_tipo_custo = 'CTE_COMPLEMENTA'.
    ENDIF.

    IF lv_tipo_custo IS INITIAL.
      SELECT SINGLE tp_custo_tm
        FROM zttm_pcockpit014
        INTO lv_tipo_custo
       WHERE evento_extra EQ gs_gko_header-tpevento.

      "Se houver algum caractere no campo evento e não for encontrado na tabela de eventos extras, considera o tipo de custo VAZIO.
      IF lv_tipo_custo IS INITIAL.
        lv_tipo_custo = 'VAZIO'.
      ENDIF.
    ENDIF.


    FREE: gv_wait_async, gt_return.

    CALL FUNCTION 'ZFMTM_EXTRA_CHARGE_SAVE'
      STARTING NEW TASK 'GKO_EXTRA_CHARGE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_cod_evento = lv_tipo_custo
        is_gko_header = gs_gko_header.

    WAIT UNTIL gv_wait_async = abap_true.
    DATA(lt_return) = gt_return.

    IF line_exists( lt_return[ id = '/SCMTMS/MSG' number = '252' ] )
    OR line_exists( lt_return[ id = '/SCMTMS/MSG' number = '253' ] ).

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-bloqueio_usuario_criacao_custo
                                it_bapi_ret = lt_return ).

    ELSEIF line_exists( lt_return[ type = 'E' ] ).

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_calc_cust_extra
                                it_bapi_ret = lt_return ).

    ELSEIF line_exists( lt_return[ type = 'W' ] ).

      me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-calculo_custo_efetuado
                                it_bapi_ret = lt_return ).

    ELSE.

      me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-calculo_custo_efetuado ).

    ENDIF.

  ENDMETHOD.


  METHOD enqueue_acckey.

    CHECK gv_wo_lock = abap_false.

* ---------------------------------------------------------------------------
* Objeto de bloqueio por Chave de Acesso
* ---------------------------------------------------------------------------
    IF gv_acckey IS NOT INITIAL.

      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          tabname        = 'ZTTM_GKOT001'
          varkey         = CONV rstable-varkey( |{ sy-mandt }{ gv_acckey }| )
          _scope         = '1'
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.

      IF sy-subrc <> 0.

        IF sy-msgid = 'MC' AND sy-msgno = '601'.

          " Chave de acesso & bloqueada pelo usuário &.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              textid   = zcxtm_gko_process=>gc_acckey_blocked
              gv_msgv1 = CONV #( gv_acckey )
              gv_msgv2 = sy-msgv1.

        ELSE.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              gt_bapi_return = VALUE #( ( id         = sy-msgid
                                          number     = sy-msgno
                                          type       = sy-msgty
                                          message_v1 = sy-msgv1
                                          message_v2 = sy-msgv2
                                          message_v3 = sy-msgv3
                                          message_v4 = sy-msgv4 ) ).
        ENDIF.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Objeto de bloqueio por Ordem de Frete
* ---------------------------------------------------------------------------
    IF gv_acckey IS NOT INITIAL.

      SELECT SINGLE 001~acckey, tor~db_key, tor~tor_id
          FROM zttm_gkot001 AS 001
          INNER JOIN /scmtms/d_torrot AS tor
          ON 001~tor_id = tor~tor_id
          WHERE 001~acckey EQ @gv_acckey
            AND tor~tor_id IS NOT INITIAL
            AND tor_cat    EQ 'TO'
          INTO @DATA(ls_tor).

      IF sy-subrc NE 0.
        CLEAR ls_tor.
      ENDIF.
    ENDIF.

    IF ls_tor-db_key IS NOT INITIAL.

      CALL FUNCTION 'ENQUEUE_E_TABLE'
        EXPORTING
          tabname        = '/SCMTMS/D_TORROT'
          varkey         = CONV rstable-varkey( |{ sy-mandt }{ ls_tor-db_key }| )
          _scope         = '1'
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.

      IF sy-subrc <> 0.

        IF sy-msgid = 'MC' AND sy-msgno = '601'.

          " Ordem de Frete &1 bloqueada pelo usuário &2.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              textid   = zcxtm_gko_process=>gc_acckey_blocked_fo
              gv_msgv1 = CONV #( |{ ls_tor-tor_id ALPHA = OUT }| )
              gv_msgv2 = sy-msgv1.

        ELSE.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              gt_bapi_return = VALUE #( ( id         = sy-msgid
                                          number     = sy-msgno
                                          type       = sy-msgty
                                          message_v1 = sy-msgv1
                                          message_v2 = sy-msgv2
                                          message_v3 = sy-msgv3
                                          message_v4 = sy-msgv4 ) ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD dequeue_acckey.

    CHECK gv_wo_lock = abap_false.

* ---------------------------------------------------------------------------
* Libera bloqueio da Chave de acesso
* ---------------------------------------------------------------------------
    CALL FUNCTION 'DEQUEUE_E_TABLE'
      EXPORTING
        tabname   = 'ZTTM_GKOT001'
        varkey    = CONV rstable-varkey( |{ sy-mandt }{ gv_acckey }| )
        _synchron = abap_true.

* ---------------------------------------------------------------------------
* Libera bloqueio da Ordem de Frete
* ---------------------------------------------------------------------------
    IF gv_acckey IS NOT INITIAL.

      SELECT SINGLE 001~acckey, tor~db_key, tor~tor_id
          FROM zttm_gkot001 AS 001
          INNER JOIN /scmtms/d_torrot AS tor
          ON 001~tor_id = tor~tor_id
          WHERE 001~acckey EQ @gv_acckey
            AND tor~tor_id IS NOT INITIAL
            AND tor_cat    EQ 'TO'
          INTO @DATA(ls_tor).

      IF sy-subrc NE 0.
        CLEAR ls_tor.
      ENDIF.
    ENDIF.

    IF ls_tor-db_key IS NOT INITIAL.

      CALL FUNCTION 'DEQUEUE_E_TABLE'
        EXPORTING
          tabname   = '/SCMTMS/D_TORROT'
          varkey    = CONV rstable-varkey( |{ sy-mandt }{ ls_tor-db_key }| )
          _synchron = abap_true.

    ENDIF.


  ENDMETHOD.


  METHOD create_miro_subsequent_debit.

    DATA: lt_docnum   TYPE STANDARD TABLE OF j_1bnflin-docnum,
          lt_itemdata TYPE ty_t_miro_itemdata,
          lt_return   TYPE STANDARD TABLE OF bapiret2.

    DATA: ls_header          TYPE bapi_incinv_create_header,
          ls_j_1bnfe_active  TYPE j_1bnfe_active,
          ls_j_1bnfe_history TYPE j_1bnfe_history,
          ls_greater_item    LIKE LINE OF lt_itemdata.

    load_gko_references( ).

    load_gko_attachments( ).

    CHECK gt_gko_references IS NOT INITIAL.

    TRY.

        " Verifica se os registros possuem os anexos necessários
        CHECK attach_is_valid( ) = abap_true.

        IF gs_gko_header-tpcte = gc_tpcte-complemento_de_valores.
          check_doc_orig_is_posted( ).
        ENDIF.

        DATA(lt_items_post) = get_items_post( ).

        IF gs_gko_header-cenario = gc_cenario-venda_coligada.

          SELECT bukrs
            FROM ekko
            INTO TABLE @DATA(lt_ekko_bukrs)
             FOR ALL ENTRIES IN @lt_items_post
           WHERE ebeln =  @lt_items_post-ebeln
             AND bukrs <> @space
             AND bukrs IS NOT NULL.

          IF sy-subrc IS INITIAL.

            ls_header-comp_code = lt_ekko_bukrs[ 1 ]-bukrs.

          ENDIF.

        ELSE.
          ls_header-comp_code = gs_gko_header-bukrs.
        ENDIF.

        DATA(lv_amount_doc) = COND ze_gko_vtprest( WHEN gs_gko_header-tpdoc = zcltm_gko_process=>gc_tpdoc-nfs
                                                        THEN gs_gko_header-vrec
                                                        ELSE gs_gko_header-vtprest ).

        ls_header-diff_inv     = get_emit_vendor( ).
        ls_header-gross_amount = lv_amount_doc.
        ls_header-doc_date     = gs_gko_header-dtemi.
        ls_header-pstng_date   = sy-datum.

        ls_header-invoice_ind  = abap_true.
        ls_header-calc_tax_ind = abap_true.

        ls_header-pmnt_block   = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-chave_bloqueio_pagamento ).
        ls_header-doc_type     = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-tipo_documento_miro ).
        ls_header-currency     =
        ls_header-currency_iso = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-moeda ).
        ls_header-item_text    = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-texto_cab_document_fatura ).

        ls_header-ref_doc_no =
        ls_header-header_txt = get_miro_ref_doc_no( ).
        ls_header-pmnttrms   = get_miro_sub_payment_condition( ).

        IF iv_invoicestatus = gc_invoice_status-registrado.

          ls_header-j_1bnftype = get_miro_nf_type( ).

        ENDIF.

        CASE gs_gko_header-rateio.

          WHEN gc_tprateio-detalhado.
            DATA(lt_iva_det) = get_iva_detailed( lt_items_post ).

          WHEN gc_tprateio-unificado.
            DATA(lv_iva_unif) = get_iva_unified( ).

        ENDCASE.

        LOOP AT lt_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>) WHERE mtart_pa IS NOT INITIAL.

          APPEND INITIAL LINE TO lt_itemdata ASSIGNING FIELD-SYMBOL(<fs_s_itemdata>).

          <fs_s_itemdata>-invoice_doc_item = sy-tabix.
          <fs_s_itemdata>-de_cre_ind       = abap_true.

          <fs_s_itemdata>-po_number    = <fs_s_item_post>-ebeln.
          <fs_s_itemdata>-po_item      = <fs_s_item_post>-ebelp.
          <fs_s_itemdata>-po_unit      = <fs_s_item_post>-unit.
          <fs_s_itemdata>-po_pr_uom    = <fs_s_item_post>-po_pr_uom.
          <fs_s_itemdata>-ref_doc      = <fs_s_item_post>-ref_doc.
          <fs_s_itemdata>-ref_doc_it   = <fs_s_item_post>-ref_doc_it.
          <fs_s_itemdata>-ref_doc_year = <fs_s_item_post>-ref_doc_year.
          <fs_s_itemdata>-quantity     = <fs_s_item_post>-quantity.

          DATA(lv_item_amount_bapi) = CONV bapiwrbtr( <fs_s_item_post>-item_amount_r ).

          IF lv_item_amount_bapi < '0.01'.
            lv_item_amount_bapi = '0.01'.
          ENDIF.

          <fs_s_itemdata>-item_amount = lv_item_amount_bapi.

          CASE gs_gko_header-rateio.

            WHEN gc_tprateio-detalhado.
              ASSIGN lt_iva_det[ docnum = <fs_s_item_post>-docnum
                                 itmnum = <fs_s_item_post>-itmnum ] TO FIELD-SYMBOL(<fs_s_iva_det>).
              IF sy-subrc IS INITIAL.
                <fs_s_itemdata>-tax_code = <fs_s_iva_det>-mwskz.
              ENDIF.

            WHEN gc_tprateio-unificado.
              <fs_s_itemdata>-tax_code = lv_iva_unif.

          ENDCASE.

          " Armazena o item com o maior valor
          IF <fs_s_itemdata>-item_amount > ls_greater_item-item_amount.
            ls_greater_item = <fs_s_itemdata>.
          ENDIF.

        ENDLOOP.

        " Realiza as validações do pedido, antes de gerar a MIRO
        validate_po_miro( lt_itemdata ).

        " Limpa a variável para evitar o erro 8B 219 'Documento de referência  não encontrado'
        " O mesmo ocorre quando o estorno é realizado e em seguida é realizada a criação da fatura
        ASSIGN ('(SAPLJ1BI)STORNO_FLAG') TO FIELD-SYMBOL(<fs_storno_flag>).
        IF sy-subrc IS INITIAL.
          FREE: <fs_storno_flag>.
        ENDIF.

*        " Exporta a chave de acesso, para o correto processamento do ENHANCEMENT ZENH_GKO_NF_MIRO
*        EXPORT gko_acckey = gs_gko_header-acckey TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
*
*        CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*          EXPORTING
*            headerdata       = ls_header
*            invoicestatus    = iv_invoicestatus
*          IMPORTING
*            invoicedocnumber = gs_gko_header-re_belnr
*            fiscalyear       = gs_gko_header-re_gjahr
*          TABLES
*            itemdata         = lt_itemdata
*            return           = lt_return.

        CALL FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
          STARTING NEW TASK 'TM_INCM_CREATE1'
          CALLING setup_messages ON END OF TASK
          EXPORTING
            is_headerdata    = ls_header
            iv_invoicestatus = iv_invoicestatus
            iv_acckey        = gs_gko_header-acckey
          CHANGING
            ct_itemdata      = lt_itemdata.

        WAIT UNTIL gv_wait_async = abap_true.

        gs_gko_header-re_belnr = gv_belnr.
        gs_gko_header-re_gjahr = gv_gjahr.
        lt_itemdata[]          = gt_itemdata[].
        lt_return[]            = gt_return[].

        FREE: gv_wait_async,
              gv_belnr,
              gv_gjahr,
              gt_itemdata[],
              gt_return[].

        LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_s_return>) WHERE ( id     = 'ZTM_GKO'
                                                                  AND   number = '084'  )
                                                                  OR  ( id     = 'M8'
                                                                  AND   number = '534'  ).
          EXIT.
        ENDLOOP.

        IF sy-subrc IS INITIAL.

          DATA(lv_diferenca_str) = <fs_s_return>-message_v1.
          TRANSLATE lv_diferenca_str USING ',.. '.
          CONDENSE lv_diferenca_str NO-GAPS.

          DATA(lv_diferenca) = CONV zttm_gkot001-vtprest( lv_diferenca_str ).

          SELECT SINGLE
                 parametro
            FROM zttm_pcockpit001
            INTO @DATA(lv_p_max_diferenca)
           WHERE id = @gc_params-diferenca_maxima_arredonda. " Diferença máxima arredondamento.

          DATA(lv_max_diferenca) = CONV zttm_gkot001-vtprest( lv_p_max_diferenca ).

          " Caso o valor do parâmetro seja negativo, aceitar apenas diferenças negativas,
          " Caso contrário, aceitar ambos os valores
          IF ( lv_max_diferenca < 0 AND lv_diferenca >= lv_max_diferenca ) OR
             ( lv_max_diferenca > 0 AND abs( lv_diferenca ) <= lv_max_diferenca ).

            " Atribui a diferença ao item de maior valor e que possua valor de ICMS
            DATA(lt_itemdata_aux) = lt_itemdata.
            SORT lt_itemdata_aux BY tax_code.
            DELETE ADJACENT DUPLICATES FROM lt_itemdata_aux COMPARING tax_code.

            " Obtêm os IVAs com valor de ICMS
            SELECT mwskz
              FROM a003
             INNER JOIN j_1baj
                     ON ( j_1baj~taxtyp = a003~kschl )
               FOR ALL ENTRIES IN @lt_itemdata_aux
             WHERE a003~kappl    =  'TX'
               AND a003~aland    =  'BR'
               AND a003~mwskz    =  @lt_itemdata_aux-tax_code
               AND j_1baj~taxtyp <> 'ICM0'
               AND j_1baj~taxgrp =  'ICMS'
              INTO TABLE @DATA(lt_ivas_w_icms).

            IF sy-subrc IS INITIAL.
              SORT lt_ivas_w_icms BY mwskz.
            ENDIF.

            SORT lt_itemdata BY item_amount DESCENDING.

            " Obtêm o item de maior valor e que possua ICMS
            LOOP AT lt_itemdata ASSIGNING FIELD-SYMBOL(<fs_s_item_data>).

              READ TABLE lt_ivas_w_icms TRANSPORTING NO FIELDS
                                                      WITH KEY mwskz = <fs_s_item_data>-tax_code
                                                      BINARY SEARCH.
              CHECK sy-subrc IS INITIAL.

              DATA(lv_found) = abap_true.
              EXIT.

            ENDLOOP.

            IF lv_found = abap_true
           AND <fs_s_item_data> IS ASSIGNED.

              DATA(ls_item_arredondamento) = VALUE ty_s_item_arredondamento( ebeln     = <fs_s_item_data>-po_number
                                                                             ebelp     = <fs_s_item_data>-po_item
                                                                             diferenca = lv_diferenca               ).

*              " Utilizado na BAdI ZCL_J_1BNF_ADD_DATA para distribuir o valor da diferença
*              EXPORT item_arredondamento = ls_item_arredondamento TO MEMORY ID gc_memory_id-item_arredondamento.

              SORT lt_itemdata BY invoice_doc_item ASCENDING.

*              CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*                EXPORTING
*                  headerdata       = ls_header
*                  invoicestatus    = iv_invoicestatus
*                IMPORTING
*                  invoicedocnumber = gs_gko_header-re_belnr
*                  fiscalyear       = gs_gko_header-re_gjahr
*                TABLES
*                  itemdata         = lt_itemdata
*                  return           = lt_return.

              CALL FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
                STARTING NEW TASK 'TM_INCM_CREATE1'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  is_headerdata     = ls_header
                  iv_invoicestatus  = iv_invoicestatus
                  iv_acckey         = gs_gko_header-acckey
                  is_arredondamento = ls_item_arredondamento
                CHANGING
                  ct_itemdata       = lt_itemdata.

              WAIT UNTIL gv_wait_async = abap_true.

              gs_gko_header-re_belnr = gv_belnr.
              gs_gko_header-re_gjahr = gv_gjahr.
              lt_itemdata[]          = gt_itemdata[].
              lt_return[]            = gt_return[].

              FREE: gv_wait_async,
                    gv_belnr,
                    gv_gjahr,
                    gt_itemdata[],
                    gt_return[].

*              FREE MEMORY ID gc_memory_id-item_arredondamento.

            ENDIF.
          ENDIF.
        ENDIF.

        IF line_exists( lt_return[ type = 'E' ] )
        OR gs_gko_header-re_belnr IS INITIAL.

*          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          DELETE lt_return WHERE type = 'S'
                             OR  type = 'W'
                             OR  type = 'I'.

          DATA(lt_return_aux) = lt_return.

          IF iv_invoicestatus = gc_invoice_status-registrado AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                             number = '020' ] )  "O material & está bloqueado pelo usuário
                                                             AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                  number = '022' ] )  "Dados de grupo de empresas do material & bloqueados pelo usuário &
                                                  AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                  number = '023' ] )  "Os dados do centro estão bloqueados por usuário &
                                                  AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                  number = '024' ] )  "Dados de avaliação p/o material & bloqueados pelo usuário &
                                                  AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                  number = '025' ] )  "Dados SAD p/o material & bloqueados pelo usuário &
                                                  AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                  number = '026' ] )  "Dados de venda e distr.p/o material & bloqueados pelo usuário &
                                                  AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                  number = '029' ] ). "Material & no centro & está sendo processado

            FREE: ls_header-j_1bnftype.

            SORT lt_itemdata BY invoice_doc_item ASCENDING.

*            CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*              EXPORTING
*                headerdata       = ls_header
*                invoicestatus    = gc_invoice_status-memorizado_entrado
*              IMPORTING
*                invoicedocnumber = gs_gko_header-re_belnr
*                fiscalyear       = gs_gko_header-re_gjahr
*              TABLES
*                itemdata         = lt_itemdata
*                return           = lt_return.

            CALL FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
              STARTING NEW TASK 'TM_INCM_CREATE1'
              CALLING setup_messages ON END OF TASK
              EXPORTING
                is_headerdata    = ls_header
                iv_invoicestatus = gc_invoice_status-memorizado_entrado
                iv_acckey        = gs_gko_header-acckey
              CHANGING
                ct_itemdata      = lt_itemdata.

            WAIT UNTIL gv_wait_async = abap_true.

            gs_gko_header-re_belnr = gv_belnr.
            gs_gko_header-re_gjahr = gv_gjahr.
            lt_itemdata[]          = gt_itemdata[].
            lt_return[]            = gt_return[].

            FREE: gv_wait_async,
                  gv_belnr,
                  gv_gjahr,
                  gt_itemdata[],
                  gt_return[].

            IF line_exists( lt_return[ type = 'E' ] )
            OR gs_gko_header-re_belnr IS INITIAL.

*              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

              DELETE lt_return WHERE type = 'S'
                                  OR type = 'W'
                                  OR type = 'I'.

              RAISE EXCEPTION TYPE zcxtm_gko_process
                EXPORTING
                  gt_bapi_return = lt_return.

            ELSE.

*              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*                EXPORTING
*                  wait = abap_true.

              IF lv_found = abap_false AND ( line_exists( lt_return_aux[ id = 'M8'   number = '534' ] ) OR
                                             line_exists( lt_return_aux[ id = 'ZTM_GKO' number = '084' ] ) ).

                " Não foi possível realizar o arredondamento.
                MESSAGE e098(ztm_gko) INTO DATA(lv_message).

                set_status( iv_status   = gc_codstatus-miro_memorizada
                            iv_newdoc   = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }|
                            iv_desc_cod = CONV #( lv_message ) ).

              ELSE.

                set_status( iv_status   = gc_codstatus-miro_memorizada
                            iv_newdoc   = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }|
                            it_bapi_ret = lt_return_aux ).

              ENDIF.
            ENDIF.

          ELSE.

            RAISE EXCEPTION TYPE zcxtm_gko_process
              EXPORTING
                gt_bapi_return = lt_return.

          ENDIF.

        ELSE.

*          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*            EXPORTING
*              wait = abap_true.

          IF gs_gko_header-tpdoc = gc_tpdoc-cte.

            DATA(lv_refkey) = CONV j_1bnflin-refkey( |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).

            SELECT SINGLE *
              FROM j_1bnfe_active
              INTO ls_j_1bnfe_active
             WHERE docnum IN ( SELECT docnum
                                 FROM j_1bnflin
                                WHERE refkey = lv_refkey ).

            IF sy-subrc IS INITIAL.

              DATA(ls_j_1b_nfe_access_key) = CONV j_1b_nfe_access_key( gs_gko_header-acckey ).
              MOVE-CORRESPONDING ls_j_1b_nfe_access_key TO ls_j_1bnfe_active.
              ls_j_1bnfe_active-authcod  = get_value_from_xml( iv_xml        = gt_gko_attachments[ attach_type = gc_attach_type-xml ]-attach_content
                                                               iv_expression = '//*:nProt'                                                          ).
              ls_j_1bnfe_active-authdate = gs_gko_header-dtemi.
              ls_j_1bnfe_active-authtime = gs_gko_header-hremi.

*              " Check existing key entries for history table
*              CALL FUNCTION 'J_1B_NFE_HISTORY_COUNT'
*                CHANGING
*                  ch_history = ls_j_1bnfe_history.
*
*              CALL FUNCTION 'J_1B_NFE_UPDATE_ACTIVE_W_LOCK'
*                EXPORTING
*                  is_acttab            = ls_j_1bnfe_active
*                  is_histtab           = ls_j_1bnfe_history
*                  iv_updmode           = 'U'
*                  iv_wait_after_commit = 'X'
*                EXCEPTIONS
*                  update_error         = 1
*                  lock_error           = 2
*                  OTHERS               = 3.

              CALL FUNCTION 'ZFMTM_GKO_NFE_ACTIVE_LOCK'
                STARTING NEW TASK 'TM_ACTIVE_LOCK'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  is_acttab            = ls_j_1bnfe_active
                  is_histtab           = ls_j_1bnfe_history
                  iv_updmode           = 'U'
                  iv_wait_after_commit = 'X'
                  is_history           = ls_j_1bnfe_history.

              WAIT UNTIL gv_wait_async = abap_true.

              CLEAR gv_wait_async.

            ENDIF.
          ENDIF.

          IF iv_invoicestatus = gc_invoice_status-memorizado_entrado.
            set_status( iv_status = gc_codstatus-miro_memorizada
                        iv_newdoc = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).
          ELSE.
            set_invoice_registered( ).
          ENDIF.

        ENDIF.

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        set_status( iv_status   = gc_codstatus-erro_ao_criar_miro_deb_post
                    it_bapi_ret = lr_cx_gko_process->get_bapi_return( )   ).

    ENDTRY.

*    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

  ENDMETHOD.


  METHOD create_miro_po.

    DATA: lt_docnum   TYPE TABLE OF j_1bnflin-docnum,
          lt_itemdata TYPE STANDARD TABLE OF bapi_incinv_create_item,
          lt_return   TYPE STANDARD TABLE OF bapiret2.

    DATA: ls_header          TYPE bapi_incinv_create_header,
          ls_j_1bnfe_active  TYPE j_1bnfe_active,
          ls_j_1bnfe_history TYPE j_1bnfe_history.

    load_gko_references( ).

    load_gko_attachments( ).

    load_gko_po( ).

    CHECK gt_gko_acckey_po IS NOT INITIAL.

    TRY.
        CHECK attach_is_valid( ) = abap_true.

        IF gs_gko_header-tpcte = gc_tpcte-complemento_de_valores.
          check_doc_orig_is_posted( ).
        ENDIF.

        DATA(lv_amount_doc) = COND ze_gko_vtprest( WHEN gs_gko_header-tpdoc = zcltm_gko_process=>gc_tpdoc-nfs
                                                        THEN gs_gko_header-vrec
                                                        ELSE gs_gko_header-vtprest ).

        ls_header-diff_inv     = get_emit_vendor( ).
        ls_header-comp_code    = gs_gko_header-bukrs.
        ls_header-gross_amount = lv_amount_doc.
        ls_header-doc_date     = gs_gko_header-dtemi.
        ls_header-pstng_date   = sy-datum.

        ls_header-calc_tax_ind = abap_true.
        ls_header-invoice_ind  = abap_true.

        ls_header-pmnt_block   = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-chave_bloqueio_pagamento ).
        ls_header-doc_type     = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-tipo_documento_miro ).
        ls_header-currency     =
        ls_header-currency_iso = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-moeda ).
        ls_header-item_text    = zcltm_gko_process=>get_parameter( zcltm_gko_process=>gc_params-texto_cab_document_fatura ).

        ls_header-ref_doc_no =
        ls_header-header_txt = get_miro_ref_doc_no( ).
        ls_header-pmnttrms   = get_miro_po_payment_condition( ).

        IF iv_invoicestatus = gc_invoice_status-registrado.

          get_account_cost_center( IMPORTING ev_saknr = DATA(lv_saknr) ).

          ls_header-j_1bnftype = get_miro_nf_type( iv_saknr = lv_saknr ).

        ENDIF.

        lt_itemdata = get_miro_po_item_data( ).

        " Realiza as validações do pedido, antes de gerar a MIRO
        validate_po_miro( lt_itemdata ).

        " Limpa a variável para evitar o erro 8B 219 'Documento de referência  não encontrado'
        " O mesmo ocorre quando o estorno é realizado e em seguida é realizada a criação da fatura
        ASSIGN ('(SAPLJ1BI)STORNO_FLAG') TO FIELD-SYMBOL(<fs_storno_flag>).
        IF sy-subrc IS INITIAL.
          FREE: <fs_storno_flag>.
        ENDIF.

*        " Exporta a chave de acesso, para o correto processamento do ENHANCEMENT ZENH_GKO_NF_MIRO
*        EXPORT gko_acckey = gs_gko_header-acckey TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
*
*        CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*          EXPORTING
*            headerdata       = ls_header
*            invoicestatus    = iv_invoicestatus
*          IMPORTING
*            invoicedocnumber = gs_gko_header-re_belnr
*            fiscalyear       = gs_gko_header-re_gjahr
*          TABLES
*            itemdata         = lt_itemdata
*            return           = lt_return.

        CALL FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
          STARTING NEW TASK 'TM_INCM_CREATE1'
          CALLING setup_messages ON END OF TASK
          EXPORTING
            is_headerdata    = ls_header
            iv_invoicestatus = iv_invoicestatus
            iv_acckey        = gs_gko_header-acckey
          CHANGING
            ct_itemdata      = lt_itemdata.

        WAIT UNTIL gv_wait_async = abap_true.

        gs_gko_header-re_belnr = gv_belnr.
        gs_gko_header-re_gjahr = gv_gjahr.
        lt_itemdata[]          = gt_itemdata[].
        lt_return[]            = gt_return[].

        FREE: gv_wait_async,
              gv_belnr,
              gv_gjahr,
              gt_itemdata[],
              gt_return[].

        LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_s_return>) WHERE ( id     = 'ZTM_GKO'
                                                                  AND   number = '084'  )
                                                                  OR  ( id     = 'M8'
                                                                  AND   number = '534'  ).
          EXIT.
        ENDLOOP.

        IF sy-subrc IS INITIAL.

          DATA(lv_diferenca_str) = <fs_s_return>-message_v1.
          TRANSLATE lv_diferenca_str USING ',.. '.
          CONDENSE lv_diferenca_str NO-GAPS.

          DATA(lv_diferenca) = CONV zttm_gkot001-vtprest( lv_diferenca_str ).

          SELECT SINGLE parametro
            FROM zttm_pcockpit001
            INTO @DATA(lv_p_max_diferenca)
           WHERE id = @gc_params-diferenca_maxima_arredonda. " Diferença máxima arredondamento.

          DATA(lv_max_diferenca) = CONV zttm_gkot001-vtprest( lv_p_max_diferenca ).

          " Caso o valor do parâmetro seja negativo, aceitar apenas diferenças negativas,
          " Caso contrário, aceitar ambos os valores
          IF ( lv_max_diferenca < 0 AND lv_diferenca >= lv_max_diferenca ) OR
             ( lv_max_diferenca > 0 AND abs( lv_diferenca ) <= lv_max_diferenca ).

            " Atribui a diferença ao item de maior valor e que possua valor de ICMS

            DATA(lt_itemdata_aux) = lt_itemdata.
            SORT lt_itemdata_aux BY tax_code.
            DELETE ADJACENT DUPLICATES FROM lt_itemdata_aux COMPARING tax_code.

            " Obtêm os IVAs com valor de ICMS
            SELECT mwskz
              FROM a003
             INNER JOIN j_1baj
                     ON ( j_1baj~taxtyp = a003~kschl )
               FOR ALL ENTRIES IN @lt_itemdata_aux
             WHERE a003~kappl    =  'TX'
               AND a003~aland    =  'BR'
               AND a003~mwskz    =  @lt_itemdata_aux-tax_code
               AND j_1baj~taxtyp <> 'ICM0'
               AND j_1baj~taxgrp =  'ICMS'
              INTO TABLE @DATA(lt_ivas_w_icms).

            IF sy-subrc IS INITIAL.
              SORT lt_ivas_w_icms BY mwskz.
            ENDIF.

            SORT lt_itemdata BY item_amount DESCENDING.

            " Obtêm o item de maior valor e que possua ICMS
            LOOP AT lt_itemdata ASSIGNING FIELD-SYMBOL(<fs_s_item_data>).

              READ TABLE lt_ivas_w_icms TRANSPORTING NO FIELDS
                                                      WITH KEY mwskz = <fs_s_item_data>-tax_code
                                                      BINARY SEARCH.
              CHECK sy-subrc IS INITIAL.

              DATA(lv_found) = abap_true.
              EXIT.

            ENDLOOP.

            IF lv_found = abap_true
           AND <fs_s_item_data> IS ASSIGNED.

              DATA(ls_item_arredondamento) = VALUE ty_s_item_arredondamento( ebeln     = <fs_s_item_data>-po_number
                                                                             ebelp     = <fs_s_item_data>-po_item
                                                                             diferenca = lv_diferenca ).

*              " Utilizado na BAdI ZCL_J_1BNF_ADD_DATA para distribuir o valor da diferença
*              EXPORT item_arredondamento = ls_item_arredondamento TO MEMORY ID gc_memory_id-item_arredondamento.

              SORT lt_itemdata BY invoice_doc_item ASCENDING.

*              CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*                EXPORTING
*                  headerdata       = ls_header
*                  invoicestatus    = iv_invoicestatus
*                IMPORTING
*                  invoicedocnumber = gs_gko_header-re_belnr
*                  fiscalyear       = gs_gko_header-re_gjahr
*                TABLES
*                  itemdata         = lt_itemdata
*                  return           = lt_return.

              CALL FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
                STARTING NEW TASK 'TM_INCM_CREATE1'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  is_headerdata     = ls_header
                  iv_invoicestatus  = iv_invoicestatus
                  iv_acckey         = gs_gko_header-acckey
                  is_arredondamento = ls_item_arredondamento
                CHANGING
                  ct_itemdata       = lt_itemdata.

              WAIT UNTIL gv_wait_async = abap_true.

              gs_gko_header-re_belnr = gv_belnr.
              gs_gko_header-re_gjahr = gv_gjahr.
              lt_itemdata[]          = gt_itemdata[].
              lt_return[]            = gt_return[].

              FREE: gv_wait_async,
                    gv_belnr,
                    gv_gjahr,
                    gt_itemdata[],
                    gt_return[].

*              FREE MEMORY ID gc_memory_id-item_arredondamento.

            ENDIF.
          ENDIF.
        ENDIF.

        IF line_exists( lt_return[ type = 'E' ] )
        OR gs_gko_header-re_belnr IS INITIAL.

*          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          DELETE lt_return WHERE type = 'S'
                              OR type = 'W'
                              OR type = 'I'.

          DATA(lt_return_aux) = lt_return.

          IF iv_invoicestatus = gc_invoice_status-registrado AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                             number = '020' ] )  " O material & está bloqueado pelo usuário
                                                             AND NOT line_exists( lt_return[ id     = 'M3'
                                                                           number = '022' ] )  " Dados de grupo de empresas do material & bloqueados pelo usuário &
                                           AND NOT line_exists( lt_return[ id     = 'M3'
                                                                           number = '023' ] )  " Os dados do centro estão bloqueados por usuário &
                                           AND NOT line_exists( lt_return[ id     = 'M3'
                                                                           number = '024' ] )  " Dados de avaliação p/o material & bloqueados pelo usuário &
                                           AND NOT line_exists( lt_return[ id     = 'M3'
                                                                           number = '025' ] )  " Dados SAD p/o material & bloqueados pelo usuário &
                                           AND NOT line_exists( lt_return[ id     = 'M3'
                                                                           number = '026' ] )  " Dados de venda e distr.p/o material & bloqueados pelo usuário &
                                           AND NOT line_exists( lt_return[ id     = 'M3'
                                                                           number = '029' ] ). " Material & no centro & está sendo processado )..

            FREE: ls_header-j_1bnftype.

*            CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*              EXPORTING
*                headerdata       = ls_header
*                invoicestatus    = gc_invoice_status-memorizado_entrado
*              IMPORTING
*                invoicedocnumber = gs_gko_header-re_belnr
*                fiscalyear       = gs_gko_header-re_gjahr
*              TABLES
*                itemdata         = lt_itemdata
*                return           = lt_return.

            CALL FUNCTION 'ZFMTM_GKO_INCM_CREATE1'
              STARTING NEW TASK 'TM_INCM_CREATE1'
              CALLING setup_messages ON END OF TASK
              EXPORTING
                is_headerdata    = ls_header
                iv_invoicestatus = gc_invoice_status-memorizado_entrado
                iv_acckey        = gs_gko_header-acckey
              CHANGING
                ct_itemdata      = lt_itemdata.

            WAIT UNTIL gv_wait_async = abap_true.

            gs_gko_header-re_belnr = gv_belnr.
            gs_gko_header-re_gjahr = gv_gjahr.
            lt_itemdata[]          = gt_itemdata[].
            lt_return[]            = gt_return[].

            FREE: gv_wait_async,
                  gv_belnr,
                  gv_gjahr,
                  gt_itemdata[],
                  gt_return[].

            IF line_exists( lt_return[ type = 'E' ] )
            OR gs_gko_header-re_belnr IS INITIAL.

*              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

              DELETE lt_return WHERE type = 'S'
                                  OR type = 'W'
                                  OR type = 'I'.

              RAISE EXCEPTION TYPE zcxtm_gko_process
                EXPORTING
                  gt_bapi_return = lt_return.

            ELSE.

*              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*                EXPORTING
*                  wait = abap_true.

              set_status( iv_status   = gc_codstatus-miro_memorizada
                          iv_newdoc   = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }|
                          it_bapi_ret = lt_return_aux                                          ).

            ENDIF.

          ELSE.

            RAISE EXCEPTION TYPE zcxtm_gko_process
              EXPORTING
                gt_bapi_return = lt_return.

          ENDIF.

        ELSE.

*          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*            EXPORTING
*              wait = abap_true.

          IF gs_gko_header-tpdoc = gc_tpdoc-cte.

            DATA(lv_refkey) = CONV j_1bnflin-refkey( |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).

            SELECT SINGLE *
              FROM j_1bnfe_active
              INTO ls_j_1bnfe_active
             WHERE docnum IN ( SELECT docnum
                                 FROM j_1bnflin
                                WHERE refkey = lv_refkey ).
            IF sy-subrc IS INITIAL.

              DATA(ls_j_1b_nfe_access_key) = CONV j_1b_nfe_access_key( gs_gko_header-acckey ).
              MOVE-CORRESPONDING ls_j_1b_nfe_access_key TO ls_j_1bnfe_active.
              ls_j_1bnfe_active-authcod  = get_value_from_xml( iv_xml        = gt_gko_attachments[ attach_type = gc_attach_type-xml ]-attach_content
                                                               iv_expression = '//*:nProt'                                                          ).
              ls_j_1bnfe_active-authdate = gs_gko_header-dtemi.
              ls_j_1bnfe_active-authtime = gs_gko_header-hremi.

*              " Check existing key entries for history table
*              CALL FUNCTION 'J_1B_NFE_HISTORY_COUNT'
*                CHANGING
*                  ch_history = ls_j_1bnfe_history.
*
*              CALL FUNCTION 'J_1B_NFE_UPDATE_ACTIVE_W_LOCK'
*                EXPORTING
*                  is_acttab            = ls_j_1bnfe_active
*                  is_histtab           = ls_j_1bnfe_history
*                  iv_updmode           = 'U'
*                  iv_wait_after_commit = 'X'
*                EXCEPTIONS
*                  update_error         = 1
*                  lock_error           = 2
*                  OTHERS               = 3.

              CALL FUNCTION 'ZFMTM_GKO_NFE_ACTIVE_LOCK'
                STARTING NEW TASK 'TM_ACTIVE_LOCK'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  is_acttab            = ls_j_1bnfe_active
                  is_histtab           = ls_j_1bnfe_history
                  iv_updmode           = 'U'
                  iv_wait_after_commit = 'X'
                  is_history           = ls_j_1bnfe_history.

              WAIT UNTIL gv_wait_async = abap_true.

              CLEAR gv_wait_async.

            ENDIF.
          ENDIF.

          IF iv_invoicestatus = gc_invoice_status-memorizado_entrado.
            set_status( iv_status = gc_codstatus-miro_memorizada
                        iv_newdoc = |{ gs_gko_header-re_belnr }{ gs_gko_header-re_gjahr }| ).
          ELSE.
            set_invoice_registered( ).
          ENDIF.

        ENDIF.

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        set_status( iv_status   = gc_codstatus-erro_ao_criar_miro
                    it_bapi_ret = lr_cx_gko_process->get_bapi_return( ) ).

    ENDTRY.

*    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

  ENDMETHOD.


  METHOD constructor.

    gv_acckey        = iv_acckey.
    gv_xml_content   = iv_xml.
    gv_tpprocess     = iv_tpprocess.
    gv_wo_lock       = iv_wo_lock.
    gv_min_data_load = iv_min_data_load.
    gs_nfs_data      = is_nfs_data.
    gv_locked_in_tab = iv_locked_in_tab.

    IF iv_new = abap_false.

      enqueue_acckey( gv_locked_in_tab ).

      load_data_from_acckey( ).

    ELSE.

      CASE iv_tpdoc.

        WHEN gc_tpdoc-cte.
          fill_data_cte( ).
        WHEN gc_tpdoc-nfs.
          fill_data_nfs( ).

      ENDCASE.

      check_doc_is_valid( IMPORTING ev_acabado = DATA(lv_acabado) ).

      IF iv_tpdoc   = gc_tpdoc-cte
     AND lv_acabado = abap_true. " Verificação se contem produto acabado = TRUE
        send_cte_to_gko( ).
      ENDIF.

      enqueue_acckey( gv_locked_in_tab ).

      fill_add_data( ).

    ENDIF.

  ENDMETHOD.


  METHOD clear_reversal_fi_documents.

    FREE: et_return.

    TRY.
*        SELECT SINGLE bukrs,
*                      budat
*          FROM rbkp
*          INTO @DATA(ls_rbkp_rev)
*          WHERE belnr = @iv_rev_belnr
*            AND gjahr = @iv_rev_gjahr.
*
*        SELECT SINGLE buzei
*          FROM bseg
*          INTO @DATA(lv_buzei_orig)
*         WHERE bukrs = @ls_rbkp_rev-bukrs
*           AND belnr = @iv_re_belnr
*           AND gjahr = @iv_re_gjahr
*           AND koart = 'K'.
*
*        SELECT SINGLE buzei
*          FROM bseg
*          INTO @DATA(lv_buzei_rev)
*         WHERE bukrs = @ls_rbkp_rev-bukrs
*           AND belnr = @iv_rev_belnr
*           AND gjahr = @iv_rev_gjahr
*           AND koart = 'K'.

        " Recupera documento original
        SELECT SINGLE rbkp~belnr,
                      rbkp~gjahr,
                      rbkp~bukrs,
                      rbkp~budat,
                      bseg~bukrs AS b_bukrs,
                      bseg~belnr AS b_belnr,
                      bseg~gjahr AS b_gjahr,
                      bseg~buzei AS b_buzei,
                      bseg~koart
          FROM rbkp
          INNER JOIN bseg
            ON  bseg~lifnr = rbkp~lifnr
            AND bseg~awkey = concat( rbkp~belnr, rbkp~gjahr )
            AND bseg~koart = 'K'
          WHERE rbkp~belnr = @iv_re_belnr
            AND rbkp~gjahr = @iv_re_gjahr
          INTO @DATA(ls_rbkp_re).

        IF sy-subrc NE 0.
          CLEAR ls_rbkp_re.
        ENDIF.

        " Recupera documento de estorno
        SELECT SINGLE rbkp~belnr,
                      rbkp~gjahr,
                      rbkp~bukrs,
                      rbkp~budat,
                      bseg~bukrs AS b_bukrs,
                      bseg~belnr AS b_belnr,
                      bseg~gjahr AS b_gjahr,
                      bseg~buzei AS b_buzei,
                      bseg~koart
          FROM rbkp
          INNER JOIN bseg
            ON  bseg~lifnr = rbkp~lifnr
            AND bseg~awkey = concat( rbkp~belnr, rbkp~gjahr )
            AND bseg~koart = 'K'
          WHERE rbkp~belnr = @iv_rev_belnr
            AND rbkp~gjahr = @iv_rev_gjahr
          INTO @DATA(ls_rbkp_rev).

        IF sy-subrc NE 0.
          CLEAR ls_rbkp_rev.
        ENDIF.

        DATA(lr_gko_clearing) = NEW zclfi_gko_clearing( iv_augvl = 'UMBUCHNG' ).

        lr_gko_clearing->set_header_data( VALUE #( bukrs = ls_rbkp_rev-bukrs
                                                   blart = 'KP'
                                                   budat = ls_rbkp_rev-budat
                                                   bldat = ls_rbkp_rev-budat
                                                   monat = ls_rbkp_rev-budat+4(2)
                                                   waers = 'BRL'
                                                   bktxt = 'ESTORNO FATURA GKO'
                                                 ) ).

        lr_gko_clearing->set_documents( VALUE #( ( bukrs = ls_rbkp_re-b_bukrs
                                                   belnr = ls_rbkp_re-b_belnr
                                                   gjahr = ls_rbkp_re-b_gjahr
                                                   buzei = ls_rbkp_re-b_buzei
                                                   koart = ls_rbkp_re-koart )
                                                 ( bukrs = ls_rbkp_rev-b_bukrs
                                                   belnr = ls_rbkp_rev-b_belnr
                                                   gjahr = ls_rbkp_rev-b_gjahr
                                                   buzei = ls_rbkp_rev-b_buzei
                                                   koart = ls_rbkp_rev-koart )
                                                 ) ).

        DATA(lt_result) = lr_gko_clearing->clear_documents( ).

        ASSIGN lt_result[ 1 ] TO FIELD-SYMBOL(<fs_s_result>).

        IF sy-subrc IS INITIAL.
          DATA(lv_bukrs) = <fs_s_result>-bukrs.
          DATA(lv_belnr) = <fs_s_result>-belnr.
          DATA(lv_gjahr) = <fs_s_result>-gjahr.
        ENDIF.

        et_return = VALUE #( ( id         = 'ZTM_GKO'
                               number     = '085'
                               type       = 'S'
                               message_v1 = |{ lv_bukrs }{ lv_belnr }{ lv_gjahr }| ) ).

        " Documento de estorno compensado com sucesso, &.
        add_to_log( it_bapi_ret = et_return ).

      CATCH zcxtm_gko_clearing INTO DATA(lr_cx_gko_clearing).

        et_return = VALUE #( ( id         = 'ZTM_GKO'
                               number     = '086'
                               type       = 'S'
                               message_v1 = |{ ls_rbkp_rev-bukrs }{ iv_rev_belnr }{ iv_rev_gjahr }| ) ).

        " Compensar manualmente o documento de estorno, &.
        add_to_log( it_bapi_ret = et_return ).

        add_to_log( it_bapi_ret = lr_cx_gko_clearing->get_bapi_return( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD clear_reversal_fi_documents_ex.

    dequeue_acckey( ).

* ----------------------------------------------------------------------
* Método criado para chamada RFC da BAPI de compensação FI
* ----------------------------------------------------------------------
    FREE: gt_return, gt_bapi_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_GKO_REVERSE_FI_DOCS'
      STARTING NEW TASK 'TM_REVERSE_FI_DOCS'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_re_belnr  = iv_re_belnr
        iv_re_gjahr  = iv_re_gjahr
        iv_rev_belnr = iv_rev_belnr
        iv_rev_gjahr = iv_rev_gjahr.

    WAIT UNTIL gv_wait_async = abap_true.

    " Mensagens do processo
    IF gt_return IS NOT INITIAL.
      add_to_log( it_bapi_ret = gt_return ).
    ENDIF.

    " Mensagens do retorno da bapi de compensação
    IF gt_bapi_return IS NOT INITIAL.
      add_to_log( it_bapi_ret = gt_bapi_return ).
    ENDIF.

    TRY.
        me->enqueue_acckey( iv_locked_in_tab = gv_locked_in_tab ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD clear_global_data.

    DATA: lt_globals TYPE STANDARD TABLE OF rfieldlist.

    DATA: lv_fieldname TYPE string.

    FIELD-SYMBOLS: <fs_global> LIKE LINE OF lt_globals,
                   <fs_field>  TYPE any,
                   <fs_table>  TYPE ANY TABLE.

    CALL FUNCTION 'GET_GLOBAL_SYMBOLS'
      EXPORTING
        program   = iv_repid
      TABLES
        fieldlist = lt_globals.

    LOOP AT lt_globals ASSIGNING <fs_global> WHERE name(1) NA '<%'   "// Don't touch field-symbols
                                               AND name    <> 'SY'
                                               AND name    <> 'SYST'
                                               AND flitl IS INITIAL. "// neither read-only variables

      "// Cross-program field-symbols access, format: '(PROGRAM)VARIABLE'
      CONCATENATE '(' iv_repid ')' <fs_global>-name INTO lv_fieldname.

      CASE <fs_global>-type.

        WHEN cl_abap_typedescr=>typekind_table. "// Table
          ASSIGN (lv_fieldname) TO <fs_table>.
          IF sy-subrc = 0.
            FREE <fs_table>.
          ENDIF.

        WHEN OTHERS. "// Anything else
          ASSIGN (lv_fieldname) TO <fs_field>.
          IF sy-subrc = 0.
            FREE <fs_field>.
          ENDIF.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_status_sefaz.

    DATA: lt_events_prot TYPE zctgtm_gko_014.

    TRY.

        status_check( EXPORTING iv_cteid       = gs_gko_header-acckey
                      IMPORTING es_infprot     = DATA(ls_infprot)
                                et_events_prot = lt_events_prot
                                ev_subrc       = DATA(lv_subrc) ).

        IF lv_subrc IS NOT INITIAL.

          CASE lv_subrc.
            WHEN 1.
              DATA(lv_desc_cod_sysubrc) = 'VERSION_NOT_MAINTAINED'.
            WHEN 2.
              lv_desc_cod_sysubrc = 'ERROR_PROXY_CALL'.
            WHEN 3.
              lv_desc_cod_sysubrc = 'TRANSFORMATION_ERROR'.
            WHEN 4.
              lv_desc_cod_sysubrc = 'ERROR_READING_CTE'.
            WHEN OTHERS.
              lv_desc_cod_sysubrc = 'ERROR_ON_CALL_RFC'.
          ENDCASE.

          " Erro ao confirmar o evento de rejeição na SEFAZ
          set_status( iv_status   = gc_codstatus-erro_ao_confirmar_evt_rejeicao
                      iv_codigo   = CONV #( sy-subrc )
                      iv_desc_cod = CONV #( lv_desc_cod_sysubrc ) ).

        ELSE.

          " Verifica se o evento de desacordo foi registrado
          LOOP AT lt_events_prot ASSIGNING FIELD-SYMBOL(<fs_s_event_prot>)
                                                  WHERE tpevento = '610110'    " Desacordo de Entrega de Serviço
                                                    AND ( cstat  = '134'       " Evento registrado e vinculado ao CT-e com alerta para situação do documento.
                                                       OR cstat  = '135'       " Evento registrado e vinculado a CT-e
                                                       OR cstat  = '136'    ). " Evento registrado, mas não vinculado a CT-e
            EXIT.
          ENDLOOP.

          IF sy-subrc IS INITIAL.

            " Evento de rejeição realizado e confirmado pela SEFAZ
            set_status( iv_status   = gc_codstatus-evt_rejeicao_confirmado_sefaz
                        iv_codigo   = <fs_s_event_prot>-cstat
                        iv_desc_cod = CONV #( <fs_s_event_prot>-xmotivo )       ).

          ELSE.

            READ TABLE lt_events_prot ASSIGNING <fs_s_event_prot> WITH KEY tpevento = '610110'.
            IF sy-subrc IS INITIAL.

              DATA(lv_cstat) = <fs_s_event_prot>-cstat.
              DATA(lv_xmotivo) = <fs_s_event_prot>-xmotivo.

            ELSEIF ls_infprot-c_stat <> '100'.

              lv_cstat   = ls_infprot-c_stat.
              lv_xmotivo = ls_infprot-x_motivo.

            ENDIF.

            " Erro ao confirmar o evento de rejeição na SEFAZ
            set_status( iv_status   = gc_codstatus-erro_ao_confirmar_evt_rejeicao
                        iv_codigo   = lv_cstat
                        iv_desc_cod = CONV #( lv_xmotivo ) ).

          ENDIF.

        ENDIF.

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        add_to_log( it_bapi_ret = lr_cx_gko_process->get_bapi_return( ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD check_estorno_dff.

    SELECT SINGLE acckey, sfir_id
        FROM zi_tm_cockpit001
        WHERE acckey = @gs_gko_header-acckey
        INTO @DATA(ls_001).

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    IF ls_001-sfir_id IS INITIAL.
      me->set_status( EXPORTING iv_status  = me->gc_codstatus-dff_estornada ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD check_dff_confirmed.

    SELECT SINGLE acckey, confirmation
        FROM zi_tm_cockpit001
        WHERE acckey = @gs_gko_header-acckey
        INTO @DATA(ls_001).

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    IF ls_001-confirmation = '03'.  " Confirmado
      me->set_status( EXPORTING iv_status  = me->gc_codstatus-frete_faturado  ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD check_status_from_action.

    DATA: lv_val_text TYPE val_text.

    SELECT COUNT(*)
      FROM zttm_pcockpit016
     WHERE acao         = iv_action
       AND codstatus_de = iv_status.

    IF sy-subrc IS NOT INITIAL.

      CALL FUNCTION 'DOMAIN_VALUE_GET'
        EXPORTING
          i_domname  = 'ZD_GKO_ACAO'
          i_domvalue = CONV domvalue_l( iv_action )
        IMPORTING
          e_ddtext   = lv_val_text
        EXCEPTIONS
          not_exist  = 1
          OTHERS     = 2.

      IF sy-subrc <> 0
      OR lv_val_text IS INITIAL.
        lv_val_text = iv_action.
      ENDIF.

      " O status &1 não permite &1.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>for_status_action_not_allowed
          gv_msgv1 = CONV #( iv_status )
          gv_msgv2 = CONV #( lv_val_text ).

    ENDIF.

  ENDMETHOD.


  METHOD check_purchase_order_gko.

    IF iv_ebeln IS NOT INITIAL.

      " Necessário todos os campos para exportar utilizar a tabela completa
      SELECT t1~*
        FROM zttm_gkot005 AS t5
       INNER JOIN zttm_gkot001 AS t1 ON ( t1~acckey = t5~acckey )
        INTO TABLE @et_gko_header
       WHERE ebeln = @iv_ebeln.

      IF sy-subrc IS INITIAL.
        rv_result = abap_true.
      ELSE.
        rv_result = abap_false.
      ENDIF.

    ELSE.

      IMPORT gko_header_tab = et_gko_header FROM MEMORY ID zcltm_gko_process=>gc_memory_id-acckey_header_tab.

      IF et_gko_header[] IS NOT INITIAL.
        rv_result = abap_true.
      ELSE.
        rv_result = abap_false.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_po_approved.

    load_gko_po( ).

    ASSIGN gt_gko_acckey_po[ 1 ] TO FIELD-SYMBOL(<fs_s_gko_acckey_po>).
    CHECK sy-subrc IS INITIAL.

    " Verifica se o pedido foi aprovado
    SELECT COUNT(*)
      FROM ekko
     WHERE ebeln = <fs_s_gko_acckey_po>-ebeln
       AND frgke = '1'.

    IF sy-subrc IS INITIAL.

      set_po_approved( ).

    ENDIF.

  ENDMETHOD.


  METHOD check_miro_registered.

    CHECK gs_gko_header-re_belnr IS NOT INITIAL
      AND gs_gko_header-re_gjahr IS NOT INITIAL.

    " Verifica se a MIRO foi confirmada
    SELECT COUNT(*)
      FROM rbkp
     WHERE belnr  = gs_gko_header-re_belnr
       AND gjahr  = gs_gko_header-re_gjahr
       AND rbstat = gc_invoice_status-registrado.

    IF sy-subrc IS INITIAL.

      set_invoice_registered( ).

    ENDIF.

  ENDMETHOD.


  METHOD check_invoice_gko.

    IF iv_belnr IS NOT INITIAL
   AND iv_gjahr IS NOT INITIAL.

      SELECT acckey
        FROM zttm_gkot001
       WHERE re_belnr = @iv_belnr
         AND re_gjahr = @iv_gjahr
        INTO @ev_acckey
       UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.
        rv_result = abap_true.
      ELSE.
        rv_result = abap_false.
      ENDIF.

    ELSE.

      IMPORT gko_acckey = ev_acckey FROM MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
      IF ev_acckey IS NOT INITIAL.
        rv_result = abap_true.
      ELSE.
        rv_result = abap_false.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_doc_orig_is_posted.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.

    load_gko_references( ).

    DATA(lt_gko_orig_acckey) = gt_gko_references.
    SORT lt_gko_orig_acckey BY acckey_orig.
    DELETE ADJACENT DUPLICATES FROM lt_gko_orig_acckey COMPARING acckey_orig.

    CHECK lt_gko_orig_acckey IS NOT INITIAL.

    " Verifica se a MIRO do Documento de origem, foi confirmada
    SELECT acckey
      FROM zttm_gkot001
     INNER JOIN rbkp
             ON ( rbkp~belnr = zttm_gkot001~re_belnr AND
                  rbkp~gjahr = zttm_gkot001~re_gjahr )
      INTO TABLE @DATA(lt_gko_orig_acckey_posted)
       FOR ALL ENTRIES IN @lt_gko_orig_acckey
     WHERE zttm_gkot001~acckey = @lt_gko_orig_acckey-acckey_orig
       AND rbkp~rbstat         = @gc_invoice_status-registrado.

    IF sy-subrc IS INITIAL.
      SORT lt_gko_orig_acckey_posted BY acckey.
    ENDIF.

    IF lines( lt_gko_orig_acckey ) <> lines( lt_gko_orig_acckey_posted ).

      LOOP AT lt_gko_orig_acckey ASSIGNING FIELD-SYMBOL(<fs_s_acckey_orig>).

        READ TABLE lt_gko_orig_acckey_posted TRANSPORTING NO FIELDS
                                                           WITH KEY acckey = <fs_s_acckey_orig>-acckey_orig
                                                           BINARY SEARCH.
        CHECK sy-subrc IS NOT INITIAL.

        me->add_to_log( it_bapi_ret = VALUE #( ( type       = 'E'
                                                 id         = zcxtm_gko_process=>orig_acckey_not_posted-msgid
                                                 number     = zcxtm_gko_process=>orig_acckey_not_posted-msgno
                                                 message_v1 = <fs_s_acckey_orig>-acckey_orig ) ) ).

        " A chave de origem & não possui MIRO Confirmada.
        APPEND NEW zcxtm_gko_process( textid    = zcxtm_gko_process=>orig_acckey_not_posted
                                      gv_msgv1  = CONV #( <fs_s_acckey_orig>-acckey_orig ) )
                                    TO lt_errors.

      ENDLOOP.

      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          gt_errors = lt_errors.

    ENDIF.

  ENDMETHOD.


  METHOD check_doc_is_valid.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.

    DATA: lv_nacab TYPE char1.

    load_gko_references( ).

    DATA(lv_data_corte) = CONV sy-datum( get_parameter( gc_params-data_corte_recebimento_doc ) ).

    IF gs_gko_header-dtemi < lv_data_corte.

      " Só é permitida a entrada de documentos emitidos a partir de &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>doc_emis_date_not_allowed
          gv_msgv1 = |{ lv_data_corte DATE = USER }|.

    ENDIF.

    SELECT COUNT(*)
      FROM zttm_gkot001
     WHERE acckey = gv_acckey.

    IF sy-subrc IS INITIAL.
      " O documento já está em processamento.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>gc_doc_in_process.
    ENDIF.

    IF gt_gko_references IS INITIAL.

      " Para o documento, nenhuma referência foi informada.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>gc_ref_docs_not_informed.

    ELSE.

      LOOP AT gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_gko_reference>) WHERE acckey_orig IS NOT INITIAL
                                                                               AND acckey_ref  IS INITIAL.
        " Não foram encontradas referências para a chave de origem &.
        APPEND NEW zcxtm_gko_process( textid    = zcxtm_gko_process=>ref_docs_not_found_for_acckey
                                      gv_msgv1  = CONV #( <fs_s_gko_reference>-acckey_orig ) )
                                      TO lt_errors.
      ENDLOOP.

      IF lt_errors IS NOT INITIAL.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            gt_errors = lt_errors.
      ENDIF.


* JFUJII - Inserir regra para validação
*
*    Selecionar o PARTNER na tabela DFKKBPTAXNUM
*    	onde TAXNUM = @gs_gko_header-rem_cnpj_cpf e TAXTYPE = 'BR1'
*
*    Com o PARTNER, selecionar na tabela T001W o local de negócios (J_1BBRANCH) e centro (WERKS)
*        onde KUNNR ou LIFNR = DFKKBPTAXNUM-PARTNER
*
*    Atribuir o J_1BBRANCH e o WERKS para a estrutura GS-GKO
*
*    Executar seleção acima com REM_CNPJ e DEST_CNPJ.
*    Se for encontrado centro/local de negócio apenas com o destinatário: ZTTM_GKO001-DIRECT = 1(inbound)
*    Se for encontrado centro/local de negócio apenas com o remetente : ZTTM_GKO001-DIRECT = 2(outbound)
*    Se for encontrado centro/local de negócio com remetente e destinatáiro: ZTTM_GKO001-DIRECT = 5(transferencia)

      " Validação do Remetente
      SELECT partner
        FROM dfkkbptaxnum
       WHERE taxnum = @gs_gko_header-rem_cnpj_cpf
         AND ( taxtype = 'BR1' OR taxtype = 'BR3' )
        INTO @DATA(lv_partner_rem)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.
        SELECT kunnr,
               lifnr,
               j_1bbranch,
               werks
          FROM t001w
         WHERE ( kunnr = @lv_partner_rem OR
                 lifnr = @lv_partner_rem )
          INTO TABLE @DATA(lt_t001w_rem).

        IF sy-subrc IS INITIAL.
          READ TABLE lt_t001w_rem ASSIGNING FIELD-SYMBOL(<fs_t001w_rem>) INDEX 1.
          IF sy-subrc IS INITIAL.
            gs_gko_header-branch = <fs_t001w_rem>-j_1bbranch.
            gs_gko_header-werks  = <fs_t001w_rem>-werks.
          ENDIF.
        ENDIF.
      ENDIF.

      " Validação do Destinatário
      SELECT partner
        FROM dfkkbptaxnum
       WHERE taxnum = @gs_gko_header-dest_cnpj
         AND taxtype = 'BR1'
        INTO @DATA(lv_partner_dest)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.
        SELECT kunnr,
               lifnr,
               j_1bbranch,
               werks
          FROM t001w
         WHERE ( kunnr = @lv_partner_dest OR
                 lifnr = @lv_partner_dest )
          INTO TABLE @DATA(lt_t001w_dest).

        IF sy-subrc IS INITIAL.
          IF gs_gko_header-branch IS INITIAL.
            READ TABLE lt_t001w_dest ASSIGNING FIELD-SYMBOL(<fs_t001w_dest>) INDEX 1.
            IF sy-subrc IS INITIAL.
              gs_gko_header-branch = <fs_t001w_dest>-j_1bbranch.
              gs_gko_header-werks  = <fs_t001w_dest>-werks.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lt_t001w_rem[]  IS NOT INITIAL
     AND lt_t001w_dest[] IS NOT INITIAL.

        gs_gko_header-direct = '5'. " (transferencia)

      ELSEIF lt_t001w_rem[]  IS NOT INITIAL
         AND lt_t001w_dest[] IS INITIAL.

        gs_gko_header-direct = '2'. " (outbound)

      ELSEIF lt_t001w_rem[]  IS INITIAL
         AND lt_t001w_dest[] IS NOT INITIAL.

        gs_gko_header-direct = '1'. " (inbound)

      ELSE.
        CLEAR gs_gko_header-direct.
      ENDIF.

*      DATA(lv_rem_ie) = CONV j_1bstains( |%{ gs_gko_header-rem_ie }| ).
*
*      " Obtêm a empresa e filial
*      SELECT COUNT(*)
*        FROM j_1bbranch
*        WHERE stcd1      =    gs_gko_header-rem_cnpj_cpf
*          AND state_insc LIKE lv_rem_ie.
*
*      IF sy-subrc IS NOT INITIAL.
*
*        " Para o documento, o remetente não é um local de negócios.
*        RAISE EXCEPTION TYPE zcxtm_gko_process
*          EXPORTING
*            textid = zcxtm_gko_process=>for_doc_rem_is_not_a_bus_pl.
*
*      ENDIF.
*
*      SELECT DISTINCT j_1bnfe_active~docnum,
*                      j_1bnfe_active~regio,
*                      j_1bnfe_active~nfyear,
*                      j_1bnfe_active~nfmonth,
*                      j_1bnfe_active~stcd1,
*                      j_1bnfe_active~model,
*                      j_1bnfe_active~serie,
*                      j_1bnfe_active~nfnum9,
*                      j_1bnfe_active~docnum9,
*                      j_1bnfe_active~cdv,
*                      zttm_pcockpit009~tipo_mat
*        FROM j_1bnfe_active
*       INNER JOIN j_1bnflin
*               ON ( j_1bnflin~docnum = j_1bnfe_active~docnum )
*       INNER JOIN mara
*               ON ( mara~matnr = j_1bnflin~matnr )
*        LEFT JOIN zttm_pcockpit009
*               ON ( zttm_pcockpit009~tipo_mat = mara~matnr )
*        INTO TABLE @DATA(lt_ref_nf_data)
*         FOR ALL ENTRIES IN @gt_gko_references
*       WHERE j_1bnfe_active~regio   = @gt_gko_references-regio
*         AND j_1bnfe_active~nfyear  = @gt_gko_references-nfyear
*         AND j_1bnfe_active~nfmonth = @gt_gko_references-nfmonth
*         AND j_1bnfe_active~stcd1   = @gt_gko_references-stcd1
*         AND j_1bnfe_active~model   = @gt_gko_references-model
*         AND j_1bnfe_active~serie   = @gt_gko_references-serie
*         AND j_1bnfe_active~nfnum9  = @gt_gko_references-nfnum9
*         AND j_1bnfe_active~docnum9 = @gt_gko_references-docnum9
*         AND j_1bnfe_active~cdv     = @gt_gko_references-cdv.


      SELECT j_1bnfe_active~docnum,
             j_1bnfe_active~regio,
             j_1bnfe_active~nfyear,
             j_1bnfe_active~nfmonth,
             j_1bnfe_active~stcd1,
             j_1bnfe_active~model,
             j_1bnfe_active~serie,
             j_1bnfe_active~nfnum9,
             j_1bnfe_active~docnum9,
             j_1bnfe_active~cdv
        FROM j_1bnfe_active
        INTO TABLE @DATA(lt_active)
         FOR ALL ENTRIES IN @gt_gko_references
       WHERE j_1bnfe_active~regio   = @gt_gko_references-regio
         AND j_1bnfe_active~nfyear  = @gt_gko_references-nfyear
         AND j_1bnfe_active~nfmonth = @gt_gko_references-nfmonth
         AND j_1bnfe_active~stcd1   = @gt_gko_references-stcd1
         AND j_1bnfe_active~model   = @gt_gko_references-model
         AND j_1bnfe_active~serie   = @gt_gko_references-serie
         AND j_1bnfe_active~nfnum9  = @gt_gko_references-nfnum9
         AND j_1bnfe_active~docnum9 = @gt_gko_references-docnum9
         AND j_1bnfe_active~cdv     = @gt_gko_references-cdv.

      IF sy-subrc IS INITIAL.

        SORT lt_active BY regio
                          nfyear
                          nfmonth
                          stcd1
                          model
                          serie
                          nfnum9
                          docnum9
                          cdv.

        DATA(lt_active_fae) = lt_active[].

        SORT lt_active_fae BY docnum.
        DELETE ADJACENT DUPLICATES FROM lt_active_fae COMPARING docnum.

        SELECT a~docnum,
               a~matnr,
               b~mtart
          FROM j_1bnflin AS a
         INNER JOIN mara AS b ON b~matnr = a~matnr
           FOR ALL ENTRIES IN @lt_active_fae
         WHERE docnum = @lt_active_fae-docnum
          INTO TABLE @DATA(lt_lin).

        IF sy-subrc IS INITIAL.

          SORT lt_lin BY docnum.

          DATA(lt_lin_fae) = lt_lin[].

          SORT lt_lin_fae BY mtart.
          DELETE ADJACENT DUPLICATES FROM lt_lin_fae COMPARING mtart.

          SELECT tipo_mat
            FROM zttm_pcockpit009
             FOR ALL ENTRIES IN @lt_lin_fae
           WHERE tipo_mat = @lt_lin_fae-mtart
            INTO TABLE @DATA(lt_009).

          IF sy-subrc IS INITIAL.
            SORT lt_009 BY tipo_mat.
          ENDIF.

        ENDIF.
      ENDIF.

      IF lt_active IS INITIAL.
        " Nota Fiscal de referência, não encontrada.
*        RAISE EXCEPTION TYPE zcxtm_gko_process
*          EXPORTING
*            textid = zcxtm_gko_process=>ref_nf_not_found.
        set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_nf_ref_nao_encontrada " Código status de processamento
                              iv_desc_cod = TEXT-e37 ).
        RETURN.
      ENDIF.

      " Mais abaixo verifica se está acabado
      ev_acabado = abap_true.

      LOOP AT gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_gko_ref>).

        CLEAR lv_nacab.
        READ TABLE lt_active ASSIGNING FIELD-SYMBOL(<fs_active>)
                                           WITH KEY regio   = <fs_s_gko_ref>-regio
                                                    nfyear  = <fs_s_gko_ref>-nfyear
                                                    nfmonth = <fs_s_gko_ref>-nfmonth
                                                    stcd1   = <fs_s_gko_ref>-stcd1
                                                    model   = <fs_s_gko_ref>-model
                                                    serie   = <fs_s_gko_ref>-serie
                                                    nfnum9  = <fs_s_gko_ref>-nfnum9
                                                    docnum9 = <fs_s_gko_ref>-docnum9
                                                    cdv     = <fs_s_gko_ref>-cdv
                                                    BINARY SEARCH.
        IF sy-subrc IS INITIAL.

          <fs_s_gko_ref>-docnum = <fs_active>-docnum.

          " Verifica se a nota possui produtos acabados
          READ TABLE lt_lin TRANSPORTING NO FIELDS
                                          WITH KEY docnum = <fs_s_gko_ref>-docnum
                                          BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) FROM sy-tabix.
              IF <fs_lin>-docnum NE <fs_s_gko_ref>-docnum.
                EXIT.
              ENDIF.

              IF <fs_lin>-mtart IS INITIAL.

                " Existencia de itens não acabados
                CLEAR ev_acabado.

                IF <fs_s_gko_ref>-prod_acabado EQ gc_prod_acabado-parcial
                OR <fs_s_gko_ref>-prod_acabado EQ gc_prod_acabado-sim.
                  <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-parcial.
                ELSE.
                  <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-nao.
                ENDIF.

              ELSE.
                READ TABLE lt_009 TRANSPORTING NO FIELDS
                                                WITH KEY tipo_mat = <fs_lin>-mtart
                                                BINARY SEARCH.
                IF sy-subrc IS INITIAL.

                  IF <fs_s_gko_ref>-prod_acabado EQ gc_prod_acabado-nao
                  OR <fs_s_gko_ref>-prod_acabado EQ gc_prod_acabado-parcial.
                    <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-parcial.
                  ELSE.
                    <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-sim.
                  ENDIF.

                ELSE.

                  " Existencia de itens não acabados
                  CLEAR ev_acabado.

                  IF <fs_s_gko_ref>-prod_acabado EQ gc_prod_acabado-parcial
                  OR <fs_s_gko_ref>-prod_acabado EQ gc_prod_acabado-sim.
                    <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-parcial.
                  ELSE.
                    <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-nao.
                  ENDIF.

                  " Existencia de itens não acabados
                  CLEAR ev_acabado.
                  EXIT.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

        ELSE.

          " Nota Fiscal de referência, não encontrada.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              textid = zcxtm_gko_process=>gc_ref_nf_not_found.

        ENDIF.
      ENDLOOP.

*      LOOP AT gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_gko_ref>).
*
*        CLEAR lv_nacab.
*
*        ASSIGN lt_ref_nf_data[ regio   = <fs_s_gko_ref>-regio
*                               nfyear  = <fs_s_gko_ref>-nfyear
*                               nfmonth = <fs_s_gko_ref>-nfmonth
*                               stcd1   = <fs_s_gko_ref>-stcd1
*                               model   = <fs_s_gko_ref>-model
*                               serie   = <fs_s_gko_ref>-serie
*                               nfnum9  = <fs_s_gko_ref>-nfnum9
*                               docnum9 = <fs_s_gko_ref>-docnum9
*                               cdv     = <fs_s_gko_ref>-cdv     ] TO FIELD-SYMBOL(<fs_s_ref_nf_data>).
*
*        CHECK sy-subrc IS INITIAL.
*
*        <fs_s_gko_ref>-docnum = <fs_s_ref_nf_data>-docnum.
*
*        " Verifica se a nota possui produtos acabados
*        READ TABLE lt_ref_nf_data ASSIGNING FIELD-SYMBOL(<fs_nf_data>)
*                                                WITH KEY docnum = <fs_s_gko_ref>-docnum
*                                                BINARY SEARCH.
*
*        IF sy-subrc IS NOT INITIAL
*        OR ( sy-subrc IS INITIAL AND <fs_nf_data>-tipo_mat IS INITIAL ).
*          <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-nao.
*        ELSE.
*
*          DATA(lv_prod_acabado) = abap_true.
*
*          " Verifica se a nota possui itens que não são produtos acabados
*          LOOP AT lt_ref_nf_data ASSIGNING <fs_nf_data> FROM sy-tabix.
*            IF <fs_nf_data>-docnum NE <fs_s_gko_ref>-docnum.
*              EXIT.
*            ENDIF.
*
*            IF <fs_nf_data>-tipo_mat IS INITIAL.
*              lv_nacab = abap_true.
*
*              " Existencia de itens não acabados
*              CLEAR ev_acabado.
*              EXIT.
*            ENDIF.
*
*          ENDLOOP.
*
*          IF lv_nacab IS NOT INITIAL.
*            <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-parcial.
*          ELSE.
*            <fs_s_gko_ref>-prod_acabado = gc_prod_acabado-sim.
*          ENDIF.
*
*        ENDIF.
*      ENDLOOP.
*
* JFUJII - RETIRADO
*
*     IF lv_prod_acabado = abap_false.
*        " O documento não possui produtos acabados.
*        RAISE EXCEPTION TYPE zcxtm_gko_process
*          EXPORTING
*            textid = zcxtm_gko_process=>document_wo_finished_products.
*      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_bank_account.

    RETURN.

  ENDMETHOD.


  METHOD calc_custo_tor.

* ---------------------------------------------------------------------------
* Processo para cálculo de custo na ordem de frete
* ---------------------------------------------------------------------------
    FREE: gv_wait_async, gt_return.

    CALL FUNCTION 'ZFMTM_GKO_SAVE'
      STARTING NEW TASK 'GKO_SAVE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_gko_header = is_gko_header.

    WAIT UNTIL gv_wait_async = abap_true.
    DATA(lt_return) = gt_return.

* ---------------------------------------------------------------------------
* Verifica mensagens de retorno
* ---------------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'E' ] ).
      set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-calculo_custo_efetuado ).
    ELSE.
      set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_calc_custo
                            it_bapi_ret = gt_return ).
    ENDIF.

  ENDMETHOD.


  METHOD attach_is_valid.

    DATA: lv_crtn TYPE lfa1-crtn.

*    load_gko_attachments( ).

    SELECT *
        FROM zi_tm_attachment
        WHERE tor_id      EQ @gs_gko_header-tor_id
          AND description EQ @gs_gko_header-acckey       " INSERT - JWSILVA - 06.04.2023
        INTO TABLE @DATA(lt_attachment).

    IF sy-subrc NE 0.
      FREE lt_attachment.
    ENDIF.

    rv_valid = abap_false.

    IF gs_gko_header-tpdoc = gc_tpdoc-nfs.

      " Verifica se a NFS está anexada
      IF NOT line_exists( lt_attachment[ attachment_type = gc_attach_type_new-nfs ] ).

        IF gs_gko_header-docger = gc_docger-miro_deb_posterior.
          set_status( iv_status   = gc_codstatus-sem_anexo_atribuido_miro_deb_p
                      iv_desc_cod = get_desc_attach_type( gc_attach_type-nfs ) ).
        ELSE.
          set_status( iv_status   = gc_codstatus-sem_anexo_atribuido
                      iv_desc_cod = get_desc_attach_type( gc_attach_type-nfs ) ).
        ENDIF.

        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            gt_errors = VALUE #( ( NEW zcxtm_gko_process( textid = zcxtm_gko_process=>acckey_no_attachment ) ) ).

      ENDIF.

    ELSE.

      " Verifica se é o cenário de GNRE
      SELECT COUNT(*)
        FROM zi_tm_cockpit007
        WHERE cfop = @gs_gko_header-cfop.

      IF sy-subrc IS INITIAL.

        CLEAR lv_crtn.

        SELECT SINGLE crtn
          FROM lfa1
          INTO lv_crtn
         WHERE stcd1 = gs_gko_header-emit_cnpj_cpf.

        IF lv_crtn NE '1'
       AND lv_crtn NE '2'.
          " Verifica se a GNRE e comp. pgto. estão anexados
          IF NOT line_exists( lt_attachment[ attachment_type = gc_attach_type_new-gnre ] ).

            IF gs_gko_header-docger = gc_docger-miro_deb_posterior.
              set_status( iv_status   = gc_codstatus-sem_anexo_atribuido_miro_deb_p
                          iv_desc_cod = get_desc_attach_type( gc_attach_type-gnre ) ).
            ELSE.
              set_status( iv_status   = gc_codstatus-sem_anexo_atribuido
                          iv_desc_cod = get_desc_attach_type( gc_attach_type-gnre ) ).
            ENDIF.

            RAISE EXCEPTION TYPE zcxtm_gko_process
              EXPORTING
                gt_errors = VALUE #( ( NEW zcxtm_gko_process( textid = zcxtm_gko_process=>acckey_no_attachment ) ) ).

          ELSEIF NOT line_exists( lt_attachment[ attachment_type = gc_attach_type_new-comp_pgto_gnre ] ).

            IF gs_gko_header-docger = gc_docger-miro_deb_posterior.
              set_status( iv_status   = gc_codstatus-sem_anexo_atribuido_miro_deb_p
                          iv_desc_cod = get_desc_attach_type( gc_attach_type-comp_pgto_gnre ) ).
            ELSE.
              set_status( iv_status   = gc_codstatus-sem_anexo_atribuido
                          iv_desc_cod = get_desc_attach_type( gc_attach_type-comp_pgto_gnre ) ).
            ENDIF.

            RAISE EXCEPTION TYPE zcxtm_gko_process
              EXPORTING
                gt_errors = VALUE #( ( NEW zcxtm_gko_process( textid = zcxtm_gko_process=>acckey_no_attachment ) ) ).

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD attach_file.

    DATA: lt_extension      TYPE string_table.

    DATA: ls_gko_attachment TYPE zttm_gkot002.

    DATA: lv_val_text       TYPE dd07v-ddtext.

    load_gko_attachments( ).

    IF iv_replace = abap_false.

      " Verifica se já existe um anexo para o tipo informado
      IF line_exists( gt_gko_attachments[ attach_type = iv_attach_type ] ).

        " Já existe um anexo para o tipo informado.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            textid = zcxtm_gko_process=>gc_attachment_already_imported.

      ENDIF.

    ENDIF.

    IF it_data_tab[] IS NOT INITIAL.

      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          input_length = iv_data_length
        IMPORTING
          buffer       = ls_gko_attachment-attach_content
        TABLES
          binary_tab   = it_data_tab
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.

      IF sy-subrc <> 0.

        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            gt_bapi_return = VALUE #( ( id         = sy-msgid
                                        number     = sy-msgno
                                        type       = sy-msgty
                                        message_v1 = sy-msgv1
                                        message_v2 = sy-msgv2
                                        message_v3 = sy-msgv3
                                        message_v4 = sy-msgv4 ) ).

      ENDIF.

    ELSEIF iv_data_xstring IS NOT INITIAL.

      ls_gko_attachment-attach_content = iv_data_xstring.

    ELSE.

      ls_gko_attachment-attach_content = read_file( iv_file_name ).

      " Obtêm a extensão através do nome do arquivo
      SPLIT iv_file_name AT '.' INTO TABLE lt_extension.

      IF lt_extension IS NOT INITIAL.
        ls_gko_attachment-attach_extension = lt_extension[ lines( lt_extension ) ].
      ENDIF.

    ENDIF.

    CALL FUNCTION 'DOMAIN_VALUE_GET'
      EXPORTING
        i_domname  = 'ZD_GKO_ATTACH_TYPE'
        i_domvalue = CONV domvalue_l( iv_attach_type )
      IMPORTING
        e_ddtext   = lv_val_text
      EXCEPTIONS
        not_exist  = 1
        OTHERS     = 2.

    IF sy-subrc <> 0
    OR lv_val_text IS INITIAL.
      lv_val_text = iv_attach_type.
    ENDIF.

    add_to_log( it_bapi_ret = VALUE #( ( id         = 'ZTM_GKO'
                                         number     = '070'
                                         type       = 'S'
                                         message_v1 = lv_val_text
                                         message_v2 = iv_file_name ) ) ).

    ls_gko_attachment-acckey      = gv_acckey.
    ls_gko_attachment-attach_type = iv_attach_type.
    ls_gko_attachment-crenam      = sy-uname.
    ls_gko_attachment-credat      = sy-datum.
    ls_gko_attachment-cretim      = sy-uzeit.

    APPEND ls_gko_attachment TO gt_gko_attachments.

  ENDMETHOD.


  METHOD add_to_log.

    DATA: ls_gko_log LIKE LINE OF gt_gko_logs.

    me->load_gko_logs( ).

    SORT gt_gko_logs BY acckey
                        counter DESCENDING.

    READ TABLE gt_gko_logs ASSIGNING FIELD-SYMBOL(<fs_s_gko_log>)
                                         WITH KEY acckey = gv_acckey
                                         BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      DATA(lv_counter) = <fs_s_gko_log>-counter.
    ELSE.
      lv_counter = 0.
    ENDIF.

    GET TIME.

    IF it_bapi_ret IS NOT INITIAL.

      LOOP AT it_bapi_ret ASSIGNING FIELD-SYMBOL(<fs_s_bapi_ret>).

        MESSAGE ID <fs_s_bapi_ret>-id
              TYPE <fs_s_bapi_ret>-type
            NUMBER <fs_s_bapi_ret>-number
              WITH <fs_s_bapi_ret>-message_v1
                   <fs_s_bapi_ret>-message_v2
                   <fs_s_bapi_ret>-message_v3
                   <fs_s_bapi_ret>-message_v4
              INTO DATA(lv_message).

        lv_counter = lv_counter + 1.

        ls_gko_log-acckey      = gv_acckey.
        ls_gko_log-counter     = lv_counter.
        ls_gko_log-codstatus   = gs_gko_header-codstatus.
        ls_gko_log-tpprocess   = gv_tpprocess.
        ls_gko_log-newdoc      = <fs_s_bapi_ret>-id.
        ls_gko_log-codigo      = <fs_s_bapi_ret>-number.
        ls_gko_log-desc_codigo = |{ lv_message }|.
        ls_gko_log-credat      = sy-datum.
        ls_gko_log-cretim      = sy-uzeit.
        ls_gko_log-crenam      = sy-uname.

        APPEND ls_gko_log TO gt_gko_logs.

      ENDLOOP.

    ELSE.

      ls_gko_log-acckey      = gv_acckey.
      ls_gko_log-counter     = lv_counter + 1.
      ls_gko_log-codstatus   = gs_gko_header-codstatus.
      ls_gko_log-tpprocess   = gv_tpprocess.
      ls_gko_log-newdoc      = iv_newdoc.
      ls_gko_log-codigo      = iv_codigo.
      ls_gko_log-desc_codigo = iv_desc_cod.
      ls_gko_log-credat      = sy-datum.
      ls_gko_log-cretim      = sy-uzeit.
      ls_gko_log-crenam      = sy-uname.

      APPEND ls_gko_log TO gt_gko_logs.

    ENDIF.

  ENDMETHOD.


  METHOD save_to_log.

    DATA: ls_gko_log  TYPE zttm_gkot006,
          lt_gko_logs TYPE STANDARD TABLE OF zttm_gkot006.

    SELECT MAX( counter )
        FROM zttm_gkot006
        WHERE acckey = @iv_acckey
        INTO @DATA(lv_counter).

    IF sy-subrc NE 0.
      CLEAR lv_counter.
    ENDIF.

    SELECT SINGLE acckey, codstatus
        FROM zttm_gkot001
        WHERE acckey = @iv_acckey
        INTO @DATA(ls_001).

    IF sy-subrc NE 0.
      CLEAR ls_001.
    ENDIF.

    IF iv_codstatus IS NOT INITIAL.
      ls_001-codstatus = iv_codstatus.
    ENDIF.

    GET TIME.

    IF it_bapi_ret IS NOT INITIAL.

      LOOP AT it_bapi_ret ASSIGNING FIELD-SYMBOL(<fs_s_bapi_ret>).

        MESSAGE ID <fs_s_bapi_ret>-id
              TYPE <fs_s_bapi_ret>-type
            NUMBER <fs_s_bapi_ret>-number
              WITH <fs_s_bapi_ret>-message_v1
                   <fs_s_bapi_ret>-message_v2
                   <fs_s_bapi_ret>-message_v3
                   <fs_s_bapi_ret>-message_v4
              INTO DATA(lv_message).

        lv_counter = lv_counter + 1.

        ls_gko_log-acckey      = iv_acckey.
        ls_gko_log-counter     = lv_counter.
        ls_gko_log-codstatus   = ls_001-codstatus.
        ls_gko_log-tpprocess   = iv_tpprocess.
        ls_gko_log-newdoc      = <fs_s_bapi_ret>-id.
        ls_gko_log-codigo      = <fs_s_bapi_ret>-number.
        ls_gko_log-desc_codigo = |{ lv_message }|.
        ls_gko_log-credat      = sy-datum.
        ls_gko_log-cretim      = sy-uzeit.
        ls_gko_log-crenam      = sy-uname.

        APPEND ls_gko_log TO lt_gko_logs.

      ENDLOOP.

    ELSE.

      ls_gko_log-acckey      = iv_acckey.
      ls_gko_log-counter     = lv_counter + 1.
      ls_gko_log-codstatus   = ls_001-codstatus.
      ls_gko_log-tpprocess   = iv_tpprocess.
      ls_gko_log-newdoc      = iv_newdoc.
      ls_gko_log-codigo      = iv_codigo.
      ls_gko_log-desc_codigo = iv_desc_cod.
      ls_gko_log-credat      = sy-datum.
      ls_gko_log-cretim      = sy-uzeit.
      ls_gko_log-crenam      = sy-uname.

      APPEND ls_gko_log TO lt_gko_logs.

    ENDIF.

    IF lt_gko_logs IS NOT INITIAL.
      MODIFY zttm_gkot006 FROM TABLE lt_gko_logs.
      UPDATE zttm_gkot001 SET codstatus = ls_001-codstatus WHERE acckey = iv_acckey.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD get_miro_ref_doc_no.

    IF gs_gko_header-prefno IS NOT INITIAL.

      IF gs_gko_header-series IS NOT INITIAL.

        rv_ref_doc_no = |{ CONV num9( gs_gko_header-prefno ) }-{ CONV numc3( gs_gko_header-series ) }|.

      ELSE.

        DATA(lv_len_prefno) = strlen( gs_gko_header-prefno ).
        IF lv_len_prefno > 9.

          lv_len_prefno = strlen( gs_gko_header-prefno ) - 9.
          rv_ref_doc_no = |{ gs_gko_header-prefno+lv_len_prefno(9) }|.

        ELSEIF lv_len_prefno < 9.

          rv_ref_doc_no = gs_gko_header-prefno.

        ELSE.

          rv_ref_doc_no = gs_gko_header-prefno.

        ENDIF.
      ENDIF.

    ELSE.

      rv_ref_doc_no = |{ gs_gko_header-acckey+25(9) }-{ gs_gko_header-acckey+22(3) }|.

    ENDIF.

  ENDMETHOD.


  METHOD get_miro_po_payment_condition.

    load_gko_po( ).

    ASSIGN gt_gko_acckey_po[ 1 ] TO FIELD-SYMBOL(<fs_s_acckey_po>).
    IF sy-subrc IS INITIAL.

      SELECT SINGLE zterm
        FROM ekko
        INTO rv_payment_condition
       WHERE ebeln = <fs_s_acckey_po>-ebeln.

    ENDIF.

  ENDMETHOD.


  METHOD get_miro_po_item_data.

    load_gko_po( ).

    CHECK gt_gko_acckey_po IS NOT INITIAL.

    SELECT ebeln AS po_number
           ebelp AS po_item
           netwr AS item_amount
           menge AS quantity
           meins AS po_unit
           mwskz AS tax_code
           txjcd AS taxjurcode
      FROM ekpo
      INTO CORRESPONDING FIELDS OF TABLE rt_item_data
       FOR ALL ENTRIES IN gt_gko_acckey_po
     WHERE ebeln = gt_gko_acckey_po-ebeln
       AND ebelp = gt_gko_acckey_po-ebelp.

    LOOP AT rt_item_data ASSIGNING FIELD-SYMBOL(<fs_s_itemdata>).

      <fs_s_itemdata>-invoice_doc_item = sy-tabix.

    ENDLOOP.

    IF rt_item_data IS INITIAL.

      " Não foi possível determ. os itens da MIRO a partir das NFs de referência.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>miro_items_not_found_for_nfs.

    ENDIF.

  ENDMETHOD.


  METHOD get_miro_nf_type.

    CASE gs_gko_header-tpdoc.

      WHEN gc_tpdoc-cte.

        SELECT SINGLE nftype
          FROM zttm_pcockpit012
          INTO rv_nf_type
         WHERE tpdoc  =  gs_gko_header-tpdoc
           AND model  =  gs_gko_header-model
           AND nftype <> space.

        IF sy-subrc IS NOT INITIAL.

          "Erro ao determinar a categoria da nota fiscal &.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              textid   = zcxtm_gko_process=>error_on_determine_nf_type
              gv_msgv1 = |{ gs_gko_header-tpdoc } { gs_gko_header-model }|.

        ENDIF.

      WHEN gc_tpdoc-nfs.

        SELECT SINGLE nftype
          FROM zttm_pcockpit010
          INTO rv_nf_type
         WHERE saknr  =  iv_saknr
           AND rem_uf =  gs_gko_header-rem_uf
           AND nftype <> space.

        IF sy-subrc IS NOT INITIAL.

          SELECT SINGLE nftype
            FROM zttm_pcockpit010
            INTO rv_nf_type
           WHERE saknr  =  iv_saknr
             AND rem_uf =  space
             AND nftype <> space.

        ENDIF.

        IF sy-subrc IS NOT INITIAL.

          " Erro ao determinar a categoria da nota fiscal &.
          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              textid   = zcxtm_gko_process=>error_on_determine_nf_type
              gv_msgv1 = |{ iv_saknr } { gs_gko_header-rem_uf }|.

        ENDIF.

    ENDCASE.

    IF rv_nf_type IS INITIAL.

      " Erro ao determinar a categoria da nota fiscal &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>error_on_determine_nf_type.

    ENDIF.

  ENDMETHOD.


  METHOD get_iva_unified.

    RETURN.

*    IF gs_gko_header-tpdoc <> gc_tpdoc-nfs.
*      SELECT SINGLE mwskz
*        FROM zttm_pcockpit005
*        INTO @rv_iva
*       WHERE regio_from = @gs_gko_header-emit_uf
*         AND regio_to   = @gs_gko_header-dest_uf
*         AND burks      = @gs_gko_header-bukrs
*         AND vstel      = @gs_gko_header-branch.
*    ENDIF.
*
*    IF rv_iva IS INITIAL.
*
*      IF gs_gko_header-vicms IS INITIAL
*     AND gs_gko_header-tpdoc <> gc_tpdoc-nfs.
*
*        SELECT SINGLE pmwskz
*          FROM zttm_pcockpit011
*          INTO @rv_iva
*         WHERE cenario =  @gs_gko_header-cenario
*           AND rateio  =  @gc_tprateio-unificado
*           AND pmwskz  <> @space.
*
*        IF sy-subrc IS NOT INITIAL.
*
*          " Não foi possível determinar o IVA para a Nota Fiscal &.
*          RAISE EXCEPTION TYPE zcxtm_gko_process
*            EXPORTING
*              textid   = zcxtm_gko_process=>for_nfs_iva_not_found
*              gv_msgv1 = |{ gs_gko_header-cenario } { gc_tprateio-unificado }|.
*
*        ENDIF.
*
*      ELSE.
*
*        IF gs_gko_header-tpdoc <> gc_tpdoc-nfs.
*
*          DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).
*
*          " Obtêm o IVA por Empresa/Filial e Cenário
*          SELECT SINGLE zgkop005~mwskz
*            FROM j_1bbranch
*           INNER JOIN zgkop005
*                   ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*                  AND zgkop005~branch = j_1bbranch~branch )
*            INTO @re_iva
*           WHERE j_1bbranch~stcd1      =    @gs_gko_header-tom_cnpj_cpf
*             AND j_1bbranch~state_insc LIKE @lv_tom_ie
*             AND zgkop005~cenario      =    @gs_gko_header-cenario.
*
*          CHECK rv_iva IS INITIAL.
*
*        ENDIF.
*
*        " Para todos os casos, realiza a busca no registro INFO
*        rv_iva = get_iva_from_info_record( ).
*
*        CHECK rv_iva IS INITIAL.
*
*        IF gs_gko_header-tpdoc = gc_tpdoc-nfs.
*
*          SELECT SINGLE mwskz
*            FROM zttm_pcockpit010
*            INTO rv_iva
*           WHERE saknr  = iv_saknr
*             AND rem_uf = gs_gko_header-rem_uf
*             AND mwskz  <> space.
*
*          IF sy-subrc IS NOT INITIAL.
*
*            SELECT SINGLE mwskz
*              FROM zttm_pcockpit010
*              INTO rv_iva
*             WHERE saknr  =  iv_saknr
*               AND rem_uf =  space
*               AND mwskz  <> space.
*
*          ENDIF.
*
*          IF sy-subrc IS NOT INITIAL.
*
*            " Não foi possível determinar o IVA para a Nota Fiscal &.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                textid   = zcxtm_gko_process=>for_nfs_iva_not_found
*                gv_msgv1 = |{ iv_saknr } { gs_gko_header-rem_uf }|.
*
*          ENDIF.
*
*        ELSE.
*
*          SELECT SINGLE *
*            FROM zttm_pcockpit011
*            INTO @DATA(ls_zgkop009)
*           WHERE cenario =  @gs_gko_header-cenario
*             AND rateio  =  @gc_tprateio-unificado
*             AND dmwskz  <> @space
*             AND pmwskz  <> @space.
*
*          IF sy-subrc IS NOT INITIAL.
*
*            " Para o tipo de rateio &, não foi possível determinar o IVA.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                textid   = zcxtm_gko_process=>for_rateio_iva_not_found
*                gv_msgv1 = CONV #( gs_gko_header-rateio ).
*
*          ENDIF.
*
*          IF gs_gko_header-vicms IS NOT INITIAL.
*            rv_iva = ls_zgkop009-dmwskz.
*          ELSE.
*            rv_iva = ls_zgkop009-pmwskz.
*          ENDIF.
*
*        ENDIF.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD get_iva_from_info_record.

    TRY.
        DATA(lv_lifnr) = get_emit_vendor( ).
        DATA(lv_werks) = get_po_werks( ).
        DATA(lv_ekorg) = CONV eine-ekorg( get_parameter( zcltm_gko_process=>gc_params-organizacao_compras ) ).
        DATA(ls_material_data) = get_po_material_data( lv_werks ).

        SELECT SINGLE eine~mwskz
          FROM eina
         INNER JOIN eine
                 ON ( eine~infnr = eina~infnr )
          INTO @rv_iva
         WHERE eina~matnr = @ls_material_data-matnr
           AND eina~lifnr = @lv_lifnr
           AND eina~loekz = @space
           AND eine~ekorg = @lv_ekorg
           AND eine~werks = @lv_werks.

      CATCH zcxtm_gko_process.
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD get_iva_detailed.

    RETURN.

*    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.
*
*    DATA: ls_zgkop016 TYPE zttm_pcockpit005.
*
*    IF gs_gko_header-tpdoc <> gc_tpdoc-nfs.
*      SELECT SINGLE *
*        FROM zttm_pcockpit005
*        INTO @ls_zgkop016
*       WHERE regio_from = @gs_gko_header-emit_uf
*         AND regio_to   = @gs_gko_header-dest_uf
*         AND burks      = @gs_gko_header-bukrs
*         AND vstel      = @gs_gko_header-branch.
*    ENDIF.
*
*    rt_iva = CORRESPONDING #( it_items_post MAPPING mwskz = tax_code ).
*    IF ls_zgkop016 IS INITIAL.
*
*      " Obtêm as configurações do IVA de acordo com o cenário e rateio
*      SELECT SINGLE *
*        FROM zttm_pcockpit011
*        INTO @DATA(ls_zgkop009)
*        WHERE cenario = @gs_gko_header-cenario
*          AND rateio  = @gc_tprateio-detalhado.
*
*      " Casos onde não há ICMS destacado no documento,
*      IF gs_gko_header-vicms IS INITIAL
*     AND gs_gko_header-tpdoc <> gc_tpdoc-nfs.
*
*        IF ls_zgkop009-pmwskz IS INITIAL
*       AND ls_zgkop009-gmwskz IS INITIAL.
*
*          " Não foi possível determinar o IVA para a Nota Fiscal &.
*          RAISE EXCEPTION TYPE zcxtm_gko_process
*            EXPORTING
*              textid   = zcxtm_gko_process=>for_nfs_iva_not_found
*              gv_msgv1 = |{ gs_gko_header-cenario } { gc_tprateio-detalhado }|.
*
*        ENDIF.
*
*        LOOP AT rt_iva ASSIGNING FIELD-SYMBOL(<fs_s_iva>).
*
*          ASSIGN it_items_post[ docnum = <fs_s_iva>-docnum
*                                itmnum = <fs_s_iva>-itmnum ] TO FIELD-SYMBOL(<fs_s_item_post>).
*          CHECK sy-subrc IS INITIAL.
*
*          FREE: <fs_s_iva>-mwskz.
*
*          IF <fs_s_item_post>-mtart_pa IS INITIAL.
*            <fs_s_iva>-mwskz = ls_zgkop009-gmwskz.
*          ELSE.
*            <fs_s_iva>-mwskz = ls_zgkop009-pmwskz.
*          ENDIF.
*
*          IF <fs_s_iva>-mwskz IS INITIAL.
*
*            " Não foi possível determinar o IVA para a Nota Fiscal &.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                textid   = zcxtm_gko_process=>for_nfs_iva_not_found
*                gv_msgv1 = |{ gs_gko_header-cenario } { gc_tprateio-detalhado }|.
*
*          ENDIF.
*
*        ENDLOOP.
*
*      ELSE.
*
*        " Para Notas Fiscais de serviço, o IVA é determinado de forma Unificada
*        IF gs_gko_header-tpdoc = gc_tpdoc-nfs.
*
*          DATA(lv_iva) = get_iva_unified( iv_saknr = iv_saknr ).
*
*          LOOP AT rt_iva ASSIGNING <fs_s_iva>.
*
*            <fs_s_iva>-mwskz = lv_iva.
*
*          ENDLOOP.
*
*        ELSE.
*
*          " Determinação do IVA
*          CASE gs_gko_header-cenario.
*
*              " Transferência e venda coligada, realizam a busca do De x Para de IVA
*            WHEN gc_cenario-transferencia
*              OR gc_cenario-venda_coligada.
*
*              SELECT *
*                FROM zttm_pcockpit003
*                INTO TABLE @DATA(lt_zgkop004)
*                 FOR ALL ENTRIES IN @rt_iva
*               WHERE dmwskz = @rt_iva-mwskz.
*
*              " Demais casos, realiza a busca do IVA de acordo com o cenário e tipo de rateio
*            WHEN OTHERS.
*
*              SELECT SINGLE *
*                FROM zttm_pcockpit011
*                INTO @DATA(ls_zgko009)
*               WHERE cenario =  @gs_gko_header-cenario
*                 AND rateio  =  @gc_tprateio-detalhado
*                 AND dmwskz  <> @space
*                 AND pmwskz  <> @space.
*
*              lv_iva = COND #( WHEN gs_gko_header-vicms IS NOT INITIAL
*                                    THEN ls_zgko009-dmwskz
*                                    ELSE ls_zgko009-pmwskz ).
*
*          ENDCASE.
*
*          DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).
*
*          " Obtêm o IVA por Empresa/Filial e Cenário
*          SELECT SINGLE zgkop005~mwskz
*            FROM j_1bbranch
*           INNER JOIN zgkop005
*                   ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*                  AND zgkop005~branch = j_1bbranch~branch )
*            INTO @DATA(lv_tom_mwskz)
*           WHERE j_1bbranch~stcd1      =    @gs_gko_header-tom_cnpj_cpf
*             AND j_1bbranch~state_insc LIKE @lv_tom_ie
*             AND zgkop005~cenario      =    @gs_gko_header-cenario.
*
*          " Para todos os casos, realiza a busca no registro INFO
*          DATA(lv_iva_info_record) = get_iva_from_info_record( ).
*
*          LOOP AT rt_iva ASSIGNING <fs_s_iva>.
*
*            ASSIGN it_items_post[ docnum = <fs_s_iva>-docnum
*                                  itmnum = <fs_s_iva>-itmnum ] TO <fs_s_item_post>.
*            CHECK sy-subrc IS INITIAL.
*
*            TRY.
*                IF <fs_s_item_post>-mtart_pa IS INITIAL.
*
*                  IF ls_zgkop009-gmwskz IS INITIAL.
*
*                    " Não foi possivel determinar o IVA para a NF & item &.
*                    RAISE EXCEPTION TYPE zcxtm_gko_process
*                      EXPORTING
*                        textid   = zcxtm_gko_process=>for_nf_item_iva_not_found
*                        gv_msgv1 = CONV #( <fs_s_iva>-docnum )
*                        gv_msgv2 = CONV #( <fs_s_iva>-itmnum )
*                        gv_msgv3 = CONV #( <fs_s_iva>-mwskz ).
*
*                  ENDIF.
*
*                  <fs_s_iva>-mwskz = ls_zgkop009-gmwskz.
*
*                ELSEIF lv_tom_mwskz IS NOT INITIAL.
*
*                  <fs_s_iva>-mwskz = lv_tom_mwskz.
*
*                ELSEIF lv_iva_info_record IS NOT INITIAL
*                   AND gs_gko_header-cenario <> gc_cenario-venda_coligada.
*
*                  <fs_s_iva>-mwskz = lv_iva_info_record.
*
*                ELSE.
*                  ASSIGN lt_zgkop004[ cfop   = <fs_s_item_post>-cfop(4)
*                                      dmwskz = <fs_s_iva>-mwskz         ] TO FIELD-SYMBOL(<fs_s_zgkop004>).
*                  IF sy-subrc IS INITIAL.
*
*                    <fs_s_iva>-mwskz = <fs_s_zgkop004>-pmwskz.
*
*                  ELSE.
*
*                    ASSIGN lt_zgkop004[ dmwskz = <fs_s_iva>-mwskz ] TO <fs_s_zgkop004>.
*                    IF sy-subrc IS INITIAL.
*
*                      <fs_s_iva>-mwskz = <fs_s_zgkop004>-pmwskz.
*
*                    ELSE.
*
*                      IF lv_iva IS NOT INITIAL.
*
*                        <fs_s_iva>-mwskz = lv_iva.
*
*                      ELSE.
*
*                        " Não foi possivel determinar o IVA para a NF & item &.
*                        RAISE EXCEPTION TYPE zcxtm_gko_process
*                          EXPORTING
*                            textid   = zcxtm_gko_process=>for_nf_item_iva_not_found
*                            gv_msgv1 = CONV #( <fs_s_iva>-docnum )
*                            gv_msgv2 = CONV #( <fs_s_iva>-itmnum )
*                            gv_msgv3 = CONV #( <fs_s_iva>-mwskz ).
*
*                      ENDIF.
*                    ENDIF.
*                  ENDIF.
*                ENDIF.
*
*              CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
*                APPEND lr_cx_gko_process TO lt_errors.
*            ENDTRY.
*
*          ENDLOOP.
*
*          IF lt_errors IS NOT INITIAL.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                gt_errors = lt_errors.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*
*    ELSE.
*      LOOP AT rt_iva ASSIGNING FIELD-SYMBOL(<fs_s_iva_aux>).
*        <fs_s_iva_aux>-mwskz = ls_zgkop016-mwskz.
*      ENDLOOP.
*    ENDIF.

  ENDMETHOD.


  METHOD get_items_post_wo_pa.

    RETURN.

*    CHECK it_nf_saida IS NOT INITIAL.
*
*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).
*
*    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      =    @gs_gko_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      =    @gs_gko_header-cenario.
*
*    " Obtêm os CFOPs com Crédito de ICMS
*    SELECT *
*      FROM zttm_pcockpit006
*      INTO TABLE @DATA(lt_zgkop015).
*
*    DATA(lt_nf_saida_wo_pa) = it_nf_saida.
*
*    DATA(lt_nf_saida_aux) = lt_nf_saida_wo_pa.
*    SORT lt_nf_saida_aux BY docnum.
*    DELETE ADJACENT DUPLICATES FROM lt_nf_saida_aux COMPARING docnum.
*
*    " Verifica se foi realizada a entrada da NF de acordo com o número, serie e CNPJ da NF de saída
*    SELECT nfdoc_saida~docnum   AS docnum_saida,
*           nflin_entrada~docnum AS docnum_entrada,
*           nflin_entrada~itmnum AS itmnum_entrada,
*           nflin_entrada~cfop,
*           nflin_entrada~mwskz,
*           nflin_entrada~netwr,
*           nflin_entrada~nfnet,
*           nflin_entrada~menge,
*           nflin_entrada~meins
*      FROM j_1bnfdoc AS nfdoc_saida
*     INNER JOIN j_1bnfdoc AS nfdoc_entrada
*             ON ( nfdoc_entrada~direct     = '1'
*            AND nfdoc_entrada~series     = nfdoc_saida~series
*            AND nfdoc_entrada~nfenum     = nfdoc_saida~nfenum
*            AND nfdoc_entrada~cnpj_bupla = nfdoc_saida~cgc    )
*     INNER JOIN j_1bnflin AS nflin_entrada
*             ON ( nflin_entrada~docnum = nfdoc_entrada~docnum )
*      INTO TABLE @DATA(lt_nf_entrada)
*       FOR ALL ENTRIES IN @lt_nf_saida_aux
*     WHERE nfdoc_saida~docnum = @lt_nf_saida_aux-docnum
*       AND nfdoc_saida~cancel = @abap_false.
*
*    LOOP AT lt_nf_saida_wo_pa ASSIGNING FIELD-SYMBOL(<fs_s_nf_saida>).
*
*      " Verifica se foi realizada a entrada da NF
*      CHECK line_exists( lt_nf_entrada[ docnum_saida = <fs_s_nf_saida>-docnum ] ) OR
*            ( gs_gko_header-cenario <> gc_cenario-transferencia                   AND
*              gs_gko_header-cenario <> gc_cenario-venda_coligada ).
*
*      APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).
*
*      <fs_s_item_post>-docnum   = <fs_s_nf_saida>-docnum.
*      <fs_s_item_post>-itmnum   = <fs_s_nf_saida>-itmnum.
*      <fs_s_item_post>-matnr    = <fs_s_nf_saida>-matnr.
*      <fs_s_item_post>-cfop     = <fs_s_nf_saida>-cfop.
*      <fs_s_item_post>-tax_code = <fs_s_nf_saida>-mwskz.
*
*      " nfnet = bruto
*      IF gs_gko_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_saida>-cfop ] )
*                                            OR    lv_count_zgkop005 IS NOT INITIAL ).
*        <fs_s_item_post>-item_amount = <fs_s_nf_saida>-nfnet * ( ( 100 - gs_gko_header-picms ) / 100 ).
*        <fs_s_item_post>-tax_amount  = <fs_s_nf_saida>-nfnet - <fs_s_item_post>-item_amount.
*      ELSE.
*        <fs_s_item_post>-item_amount = <fs_s_nf_saida>-nfnet .
*      ENDIF.
*
*      <fs_s_item_post>-quantity     = <fs_s_nf_saida>-menge.
*      <fs_s_item_post>-unit         = <fs_s_nf_saida>-meins.
*      <fs_s_item_post>-ebeln        = <fs_s_nf_saida>-ebeln.
*      <fs_s_item_post>-ebelp        = <fs_s_nf_saida>-ebelp.
*      <fs_s_item_post>-ref_doc      = <fs_s_nf_saida>-mblnr.
*      <fs_s_item_post>-ref_doc_it   = <fs_s_nf_saida>-zeile.
*      <fs_s_item_post>-ref_doc_year = <fs_s_nf_saida>-mjahr.
*
*      <fs_s_item_post>-docnum_out   = <fs_s_item_post>-docnum.
*      <fs_s_item_post>-itmnum_out   = <fs_s_item_post>-itmnum.
*      <fs_s_item_post>-mtart_pa     = <fs_s_nf_saida>-mtart_pa.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD get_items_post_venda_coligada.

    RETURN.

*    TYPES: BEGIN OF ty_s_ekbe_key_aux,
*             ebeln      TYPE ekbe-ebeln,
*             ebelp      TYPE ekbe-ebelp,
*             gjahr      TYPE ekbe-gjahr,
*             belnr      TYPE ekbe-belnr,
*             buzei      TYPE ekbe-buzei,
*             belnr_conv TYPE rseg-belnr,
*             gjahr_conv TYPE rseg-gjahr,
*             buzei_conv TYPE rseg-buzei,
*             refkey     TYPE j_1bnflin-refkey,
*             refitm     TYPE j_1bnflin-refitm,
*           END OF ty_s_ekbe_key_aux,
*
*           ty_t_ekbe_key_aux TYPE TABLE OF ty_s_ekbe_key_aux WITH DEFAULT KEY.
*
*    CHECK it_nf_saida IS NOT INITIAL.
*
*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).
*
*    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      =    @gs_gko_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      =    @gs_gko_header-cenario.
*
*    " Obtêm os CFOPs com Crédito de ICMS
*    SELECT *
*      FROM ZTTM_PCOCKPIT006
*      INTO TABLE @DATA(lt_zgkop015).
*
*    DATA(lt_nf_saida) = it_nf_saida.
*
*    DATA(lt_nf_saida_aux) = lt_nf_saida.
*    SORT lt_nf_saida_aux BY ebeln.
*    DELETE ADJACENT DUPLICATES FROM lt_nf_saida_aux COMPARING ebeln.
*
*    " Obtêm o histórico do pedido
*    SELECT ekbe~ebeln,
*           ekbe~ebelp,
*           ekbe~gjahr,
*           ekbe~belnr,
*           ekbe~buzei,
*           ekbe~menge,
*           ekbe~wrbtr,
*           ekbe~shkzg,
*           ekbe~cpudt,
*           ekbe~cputm,
*           ekpo~mwskz,
*           rbkp~xrech
*      FROM ekbe
*     INNER JOIN ekpo
*             ON ( ekpo~ebeln = ekbe~ebeln AND ekpo~ebelp = ekbe~ebelp )
*     INNER JOIN rbkp
*             ON ( rbkp~belnr = ekbe~belnr AND rbkp~gjahr = ekbe~gjahr )
*      INTO TABLE @DATA(lt_ekbe)
*       FOR ALL ENTRIES IN @lt_nf_saida_aux
*     WHERE ekbe~ebeln = @lt_nf_saida_aux-ebeln
*       AND ekbe~zekkn = '00'
*       AND ekbe~vgabe = '2'  "Entrada de fatura
*       AND ekbe~bewtp = 'Q'
*       AND ekpo~loekz = @space.
*
*    DATA(lt_ekbe_aux) = lt_ekbe.
*    DELETE lt_ekbe_aux WHERE xrech IS INITIAL.
*    SORT lt_ekbe_aux BY ebeln ASCENDING  ebelp ASCENDING
*                        belnr DESCENDING gjahr DESCENDING buzei ASCENDING.
*    DELETE ADJACENT DUPLICATES FROM lt_ekbe_aux COMPARING ebeln ebelp.
*
*    DATA(lt_ekbe_key_aux) = VALUE ty_t_ekbe_key_aux( FOR <ekbe_aux> IN lt_ekbe_aux
*                                                       LET belnr_conv = CONV rseg-belnr( <ekbe_aux>-belnr )
*                                                           gjahr_conv = CONV rseg-gjahr( <ekbe_aux>-gjahr )
*                                                           buzei_conv = CONV rseg-buzei( <ekbe_aux>-buzei ) IN
*                                                       ( ebeln      = <ekbe_aux>-ebeln
*                                                         ebelp      = <ekbe_aux>-ebelp
*                                                         gjahr      = <ekbe_aux>-gjahr
*                                                         belnr      = <ekbe_aux>-belnr
*                                                         buzei      = <ekbe_aux>-buzei
*                                                         belnr_conv = belnr_conv
*                                                         gjahr_conv = gjahr_conv
*                                                         buzei_conv = buzei_conv
*                                                         refkey     = |{ belnr_conv }{ gjahr_conv }|
*                                                         refitm     = buzei_conv                     ) ).
*
*    IF lt_ekbe_key_aux IS NOT INITIAL.
*
*      " Obtêm os dados dos itens da fatura mais recente
*      SELECT belnr,
*             gjahr,
*             buzei,
*             lfbnr,
*             lfpos,
*             lfgja,
*             bprme
*        FROM rseg
*        INTO TABLE @DATA(lt_rseg)
*         FOR ALL ENTRIES IN @lt_ekbe_key_aux
*       WHERE belnr = @lt_ekbe_key_aux-belnr_conv
*         AND gjahr = @lt_ekbe_key_aux-gjahr_conv
*         AND buzei = @lt_ekbe_key_aux-buzei_conv.
*
*      " Obtêm a NF de entrada de acordo com a fatura mais recente
*      SELECT docnum,
*             itmnum,
*             refkey,
*             refitm,
*             cfop,
*             mwskz,
*             netwr,
*             nfnet,
*             menge,
*             meins
*        FROM j_1bnflin
*        INTO TABLE @DATA(lt_nf_entrada)
*         FOR ALL ENTRIES IN @lt_ekbe_key_aux
*       WHERE refkey = @lt_ekbe_key_aux-refkey
*         AND refitm = @lt_ekbe_key_aux-refitm.
*
*      SORT lt_nf_entrada BY refkey refitm.
*
*      LOOP AT lt_nf_entrada ASSIGNING FIELD-SYMBOL(<fs_s_nf_entrada>).
*
*        DATA(lv_item_counter) = sy-tabix.
*
*        READ TABLE lt_ekbe_key_aux ASSIGNING FIELD-SYMBOL(<fs_s_ekbe_key_aux>) WITH KEY refkey = <fs_s_nf_entrada>-refkey
*                                                                                        refitm = <fs_s_nf_entrada>-refitm.
*        CHECK sy-subrc IS INITIAL.
*
*        READ TABLE lt_rseg ASSIGNING FIELD-SYMBOL(<fs_s_rseg>) WITH KEY belnr = <fs_s_ekbe_key_aux>-belnr_conv
*                                                                        gjahr = <fs_s_ekbe_key_aux>-gjahr_conv
*                                                                        buzei = <fs_s_ekbe_key_aux>-buzei_conv.
*        CHECK sy-subrc IS INITIAL.
*
*        DATA(lv_menge_miro) = CONV ekpo-menge( '0.00' ).
*
*        " Obtêm a quantidade a ser lançada
*        LOOP AT lt_ekbe ASSIGNING FIELD-SYMBOL(<fs_s_ekbe>) WHERE ebeln = <fs_s_ekbe_key_aux>-ebeln
*                                                              AND ebelp = <fs_s_ekbe_key_aux>-ebelp.
*
*          CASE <fs_s_ekbe>-shkzg.
*            WHEN 'S'.
*              lv_menge_miro = lv_menge_miro + abs( <fs_s_ekbe>-menge ).
*            WHEN 'H'.
*              lv_menge_miro = lv_menge_miro - abs( <fs_s_ekbe>-menge ).
*            WHEN OTHERS.
*              lv_menge_miro = lv_menge_miro + abs( <fs_s_ekbe>-menge ).
*          ENDCASE.
*
*          " Obtêm o registro com os dados da fatura mais recente
*          IF <fs_s_ekbe>-gjahr = <fs_s_ekbe_key_aux>-gjahr AND
*             <fs_s_ekbe>-belnr = <fs_s_ekbe_key_aux>-belnr AND
*             <fs_s_ekbe>-buzei = <fs_s_ekbe_key_aux>-buzei.
*            DATA(ls_ekbe_miro) = <fs_s_ekbe>.
*          ENDIF.
*
*        ENDLOOP.
*
*        APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).
*
*        <fs_s_item_post>-docnum   = <fs_s_nf_entrada>-docnum.
*        <fs_s_item_post>-itmnum   = <fs_s_nf_entrada>-itmnum.
*        <fs_s_item_post>-cfop     = <fs_s_nf_entrada>-cfop.
*        <fs_s_item_post>-tax_code = ls_ekbe_miro-mwskz.
*        <fs_s_item_post>-quantity = lv_menge_miro.
*        <fs_s_item_post>-unit     = <fs_s_nf_entrada>-meins.
*
*        IF <fs_s_item_post>-quantity > 0.
*
*          " nfnet = bruto
*          IF gs_gko_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_entrada>-cfop ] )
*                                                OR    lv_count_zgkop005 IS NOT INITIAL                                ).
*            <fs_s_item_post>-item_amount = <fs_s_nf_entrada>-nfnet * ( ( 100 - gs_gko_header-picms ) / 100 ).
*            <fs_s_item_post>-tax_amount  = <fs_s_nf_entrada>-nfnet - <fs_s_item_post>-item_amount.
*          ELSE.
*            <fs_s_item_post>-item_amount = <fs_s_nf_entrada>-nfnet .
*          ENDIF.
*
*        ENDIF.
*
*        <fs_s_item_post>-ebeln        = <fs_s_ekbe_key_aux>-ebeln.
*        <fs_s_item_post>-ebelp        = <fs_s_ekbe_key_aux>-ebelp.
*        <fs_s_item_post>-ref_doc      = <fs_s_rseg>-lfbnr.
*        <fs_s_item_post>-ref_doc_it   = <fs_s_rseg>-lfpos.
*        <fs_s_item_post>-ref_doc_year = <fs_s_rseg>-lfgja.
*        <fs_s_item_post>-po_pr_uom    = <fs_s_rseg>-bprme.
*
*        READ TABLE lt_nf_saida INDEX lv_item_counter ASSIGNING FIELD-SYMBOL(<fs_s_nf_saida>).
*        IF sy-subrc IS NOT INITIAL AND ( lv_item_counter - 1 ) > 0.
*          READ TABLE lt_nf_saida INDEX ( lv_item_counter - 1 ) ASSIGNING <fs_s_nf_saida>.
*        ENDIF.
*
*        IF sy-subrc IS INITIAL.
*
*          <fs_s_item_post>-matnr        = <fs_s_nf_saida>-matnr.
*          <fs_s_item_post>-docnum_out   = <fs_s_nf_saida>-docnum.
*          <fs_s_item_post>-itmnum_out   = <fs_s_nf_saida>-itmnum.
*          <fs_s_item_post>-mtart_pa     = <fs_s_nf_saida>-mtart_pa.
*
*        ENDIF.
*      ENDLOOP.
*    ENDIF.

  ENDMETHOD.


  METHOD get_items_post_transferencia.

    RETURN.

*    CHECK it_nf_saida IS NOT INITIAL.
*
*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).
*
*    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      = @gs_gko_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      = @gs_gko_header-cenario.
*
*    " Obtêm os CFOPs com Crédito de ICMS
*    SELECT *
*      FROM zttm_pcockpit006
*      INTO TABLE @DATA(lt_zgkop015).
*
*    DATA(lt_nf_saida) = it_nf_saida.
*    SORT lt_nf_saida BY xped ASCENDING nitemped ASCENDING.
*
*    " Obtêm a nota fiscal de entrada para os registros com pedido
*    DATA(lt_j_1bnflin_w_po) = lt_nf_saida.
*    DELETE lt_j_1bnflin_w_po WHERE ebeln IS INITIAL.
*
*    IF lt_j_1bnflin_w_po IS NOT INITIAL.
*
*      SORT lt_j_1bnflin_w_po BY ebeln.
*      DELETE ADJACENT DUPLICATES FROM lt_j_1bnflin_w_po COMPARING ebeln.
*
*      SELECT ebeln,
*             ebelp,
*             gjahr,
*             belnr,
*             buzei
*        FROM ekbe AS ekbe_orig
*        INTO TABLE @DATA(lt_ekbe_transf)
*         FOR ALL ENTRIES IN @lt_j_1bnflin_w_po
*       WHERE ekbe_orig~ebeln = @lt_j_1bnflin_w_po-ebeln
*         AND ekbe_orig~zekkn = '00'
*         AND ekbe_orig~vgabe = '1'    " Entrada de mercadorias
*         AND NOT EXISTS ( SELECT ebeln
*                            FROM ekbe
*                           WHERE ebeln =  ekbe_orig~ebeln
*                             AND ebelp =  ekbe_orig~ebelp
*                             AND zekkn =  ekbe_orig~zekkn
*                             AND vgabe =  ekbe_orig~vgabe
*                             AND gjahr <> ekbe_orig~gjahr
*                             AND belnr <> ekbe_orig~belnr
*                             AND buzei <> ekbe_orig~buzei
*                             AND lfgja =  ekbe_orig~gjahr
*                             AND lfbnr =  ekbe_orig~belnr
*                             AND lfpos =  ekbe_orig~buzei ).
*
*      IF sy-subrc IS INITIAL.
*
*        " Preenche o pedido na tabela interna de acordo com a ordem dos itens
*        LOOP AT lt_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin>)
*                                          GROUP BY <fs_s_nf_lin>-ebeln.
*
*          CHECK <fs_s_nf_lin>-ebeln IS NOT INITIAL.
*
*          DATA(lt_ekbe_transf_aux) = lt_ekbe_transf.
*          DELETE lt_ekbe_transf_aux WHERE ebeln <> <fs_s_nf_lin>-ebeln.
*          SORT lt_ekbe_transf_aux BY ebelp ASCENDING.
*
*          DATA(lv_item_counter) = 0.
*
*          LOOP AT GROUP <fs_s_nf_lin> ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin_mbr>).
*
*            lv_item_counter = lv_item_counter + 1.
*
*            ASSIGN lt_ekbe_transf_aux[ lv_item_counter ] TO FIELD-SYMBOL(<fs_s_ekbe_transf_aux>).
*            IF sy-subrc IS INITIAL.
*              <fs_s_nf_lin_mbr>-ebeln     = <fs_s_ekbe_transf_aux>-ebeln.
*              <fs_s_nf_lin_mbr>-ebelp     = <fs_s_ekbe_transf_aux>-ebelp.
*              <fs_s_nf_lin_mbr>-refkey_po = |{ <fs_s_ekbe_transf_aux>-belnr }{ <fs_s_ekbe_transf_aux>-gjahr }|.
*              <fs_s_nf_lin_mbr>-refitm_po = <fs_s_ekbe_transf_aux>-buzei.
*            ENDIF.
*
*          ENDLOOP.
*        ENDLOOP.
*
*        lt_j_1bnflin_w_po = lt_nf_saida.
*        DELETE lt_j_1bnflin_w_po WHERE refkey_po IS INITIAL.
*        IF lt_j_1bnflin_w_po IS NOT INITIAL.
*
*          SELECT out_mwskz,
*                 in_mwskz
*            FROM j_1bt007
*            INTO TABLE @DATA(lt_j1bt007)
*             FOR ALL ENTRIES IN @lt_j_1bnflin_w_po
*           WHERE out_mwskz = @lt_j_1bnflin_w_po-mwskz.
*
*          " Obtêm a NF de entrada de acordo com o pedido
*          SELECT docnum,
*                 itmnum,
*                 refkey,
*                 refitm,
*                 cfop,
*                 mwskz,
*                 netwr,
*                 nfnet,
*                 menge,
*                 meins
*            FROM j_1bnflin
*            INTO TABLE @DATA(lt_nf_entrada)
*             FOR ALL ENTRIES IN @lt_j_1bnflin_w_po
*           WHERE refkey = @lt_j_1bnflin_w_po-refkey_po
*             AND refitm = @lt_j_1bnflin_w_po-refitm_po.
*
*          IF sy-subrc IS INITIAL.
*
*            LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS NOT INITIAL.
*
*              ASSIGN lt_nf_entrada[ refkey = <fs_s_nf_lin>-refkey_po
*                                    refitm = <fs_s_nf_lin>-refitm_po ] TO FIELD-SYMBOL(<fs_s_nf_lin_entrada>).
*              CHECK sy-subrc IS INITIAL.
*
*              ASSIGN lt_j1bt007[ out_mwskz = <fs_s_nf_lin>-mwskz ] TO FIELD-SYMBOL(<fs_s_j1bt007>).
*              IF sy-subrc IS INITIAL.
*                DATA(lv_iva) = <fs_s_j1bt007>-in_mwskz.
*              ENDIF.
*
*              APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).
*
*              <fs_s_item_post>-docnum   = <fs_s_nf_lin>-docnum.
*              <fs_s_item_post>-itmnum   = <fs_s_nf_lin>-itmnum.
*              <fs_s_item_post>-matnr    = <fs_s_nf_lin>-matnr.
*              <fs_s_item_post>-cfop     = <fs_s_nf_lin_entrada>-cfop.
*              <fs_s_item_post>-tax_code = lv_iva.
*
*              " nfnet = bruto
*              IF gs_gko_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_lin_entrada>-cfop ] )
*                                                    OR    lv_count_zgkop005 IS NOT INITIAL                                ).
*                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet * ( ( 100 - gs_gko_header-picms ) / 100 ).
*                <fs_s_item_post>-tax_amount  = <fs_s_nf_lin_entrada>-nfnet - <fs_s_item_post>-item_amount.
*              ELSE.
*                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet .
*              ENDIF.
*
*              <fs_s_item_post>-quantity     = <fs_s_nf_lin_entrada>-menge.
*              <fs_s_item_post>-unit         = <fs_s_nf_lin_entrada>-meins.
*              <fs_s_item_post>-ebeln        = <fs_s_nf_lin>-ebeln.
*              <fs_s_item_post>-ebelp        = <fs_s_nf_lin>-ebelp.
*              <fs_s_item_post>-ref_doc      = <fs_s_nf_lin>-mblnr.
*              <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin>-zeile.
*              <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin>-mjahr.
*
*              <fs_s_item_post>-docnum_out   = <fs_s_nf_lin>-docnum.
*              <fs_s_item_post>-itmnum_out   = <fs_s_nf_lin>-itmnum.
*              <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin>-mtart_pa.
*
*            ENDLOOP.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    " Obtêm a nota fiscal de entrada para os registros sem pedido
*    DATA(lt_j_1bnflin_wo_po) = lt_nf_saida.
*    DELETE lt_j_1bnflin_wo_po WHERE ebeln IS NOT INITIAL.
*
*    IF lt_j_1bnflin_wo_po IS NOT INITIAL.
*
*      " Obtêm a MIGO de entrada
*      SELECT mblnr,
*             mjahr,
*             zeile,
*             mwskz
*        FROM mseg
*        INTO TABLE @DATA(lt_mseg_transf_entrada)
*         FOR ALL ENTRIES IN @lt_j_1bnflin_wo_po
*       WHERE mblnr = @lt_j_1bnflin_wo_po-mblnr
*         AND mjahr = @lt_j_1bnflin_wo_po-mjahr
*         AND zeile = @lt_j_1bnflin_wo_po-zeile
*         AND xauto = @space.
*
*      IF sy-subrc IS INITIAL.
*
*        LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS INITIAL.
*          ASSIGN lt_mseg_transf_entrada[ mblnr = <fs_s_nf_lin>-mblnr
*                                         mjahr = <fs_s_nf_lin>-mjahr
*                                         zeile = <fs_s_nf_lin>-zeile ] TO FIELD-SYMBOL(<fs_s_mseg_transf_ent>).
*          CHECK sy-subrc IS INITIAL.
*          <fs_s_nf_lin>-refkey_mb = |{ <fs_s_nf_lin>-mblnr }{ <fs_s_nf_lin>-mjahr }|.
*          <fs_s_nf_lin>-refitm_mb = <fs_s_nf_lin>-zeile.
*        ENDLOOP.
*
*        lt_j_1bnflin_wo_po = lt_nf_saida.
*        DELETE lt_j_1bnflin_wo_po WHERE ebeln     IS NOT INITIAL
*                                     OR refkey_mb IS INITIAL.
*        IF lt_j_1bnflin_wo_po IS NOT INITIAL.
*
*          " Obtêm a NF de entrada de acordo com a MIGO
*          SELECT docnum,
*                 itmnum,
*                 refkey,
*                 refitm,
*                 cfop,
*                 mwskz,
*                 netwr,
*                 nfnet,
*                 menge,
*                 meins
*            FROM j_1bnflin
*            APPENDING TABLE @lt_nf_entrada
*             FOR ALL ENTRIES IN @lt_j_1bnflin_wo_po
*           WHERE docnum <> @lt_j_1bnflin_wo_po-docnum
*             AND refkey =  @lt_j_1bnflin_wo_po-refkey_mb
*             AND refitm =  @lt_j_1bnflin_wo_po-refitm_mb.
*
*          IF sy-subrc IS INITIAL.
*
*            LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS INITIAL.
*
*              ASSIGN lt_nf_entrada[ refkey = <fs_s_nf_lin>-refkey_mb
*                                    refitm = <fs_s_nf_lin>-refitm_mb ] TO <fs_s_nf_lin_entrada>.
*              CHECK sy-subrc IS INITIAL.
*
*              APPEND INITIAL LINE TO ct_items_post ASSIGNING <fs_s_item_post>.
*
*              <fs_s_item_post>-docnum   = <fs_s_nf_lin>-docnum.
*              <fs_s_item_post>-itmnum   = <fs_s_nf_lin>-itmnum.
*              <fs_s_item_post>-matnr    = <fs_s_nf_lin>-matnr.
*              <fs_s_item_post>-cfop     = <fs_s_nf_lin_entrada>-cfop.
*              <fs_s_item_post>-tax_code = <fs_s_nf_lin_entrada>-mwskz.
*
*              " nfnet = bruto
*              IF gs_gko_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_lin_entrada>-cfop ] )
*                                                    OR    lv_count_zgkop005 IS NOT INITIAL                                ).
*                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet * ( ( 100 - gs_gko_header-picms ) / 100 ).
*                <fs_s_item_post>-tax_amount  = <fs_s_nf_lin_entrada>-nfnet - <fs_s_item_post>-item_amount.
*              ELSE.
*                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet .
*              ENDIF.
*
*              <fs_s_item_post>-quantity     = <fs_s_nf_lin_entrada>-menge.
*              <fs_s_item_post>-unit         = <fs_s_nf_lin_entrada>-meins.
*              <fs_s_item_post>-ebeln        = <fs_s_nf_lin>-ebeln.
*              <fs_s_item_post>-ebelp        = <fs_s_nf_lin>-ebelp.
*              <fs_s_item_post>-ref_doc      = <fs_s_nf_lin>-mblnr.
*              <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin>-zeile.
*              <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin>-mjahr.
*
*              <fs_s_item_post>-docnum_out   = <fs_s_nf_lin>-docnum.
*              <fs_s_item_post>-itmnum_out   = <fs_s_nf_lin>-itmnum.
*              <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin>-mtart_pa.
*
*            ENDLOOP.
*
*          ELSE.
*
*            DATA(lt_j_1bnflin_wo_po_aux) = lt_j_1bnflin_wo_po.
*            SORT lt_j_1bnflin_wo_po_aux BY docnum.
*            DELETE ADJACENT DUPLICATES FROM lt_j_1bnflin_wo_po_aux COMPARING docnum.
*
*            " Caso não encontre na seleção anterior, obtêm a NF de entrada de acordo com o número, serie e CNPJ da NF de saída
*            SELECT nfdoc_saida~docnum   AS docnum_saida,
*                   nflin_entrada~docnum AS docnum_entrada,
*                   nflin_entrada~itmnum AS itmnum_entrada,
*                   nflin_entrada~cfop,
*                   nflin_entrada~mwskz,
*                   nflin_entrada~netwr,
*                   nflin_entrada~nfnet,
*                   nflin_entrada~menge,
*                   nflin_entrada~meins
*              FROM j_1bnfdoc AS nfdoc_saida
*             INNER JOIN j_1bnfdoc AS nfdoc_entrada
*                     ON ( nfdoc_entrada~direct   = '1'
*                    AND nfdoc_entrada~series     = nfdoc_saida~series
*                    AND nfdoc_entrada~nfenum     = nfdoc_saida~nfenum
*                    AND nfdoc_entrada~cnpj_bupla = nfdoc_saida~cgc    )
*             INNER JOIN j_1bnflin AS nflin_entrada
*                     ON ( nflin_entrada~docnum = nfdoc_entrada~docnum )
*              INTO TABLE @DATA(lt_nf_entrada_wo_po)
*               FOR ALL ENTRIES IN @lt_j_1bnflin_wo_po_aux
*             WHERE nfdoc_saida~docnum = @lt_j_1bnflin_wo_po_aux-docnum
*               AND nfdoc_saida~cancel = @abap_false.
*
*            IF sy-subrc IS INITIAL.
*
*              LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS INITIAL
*                                                       GROUP BY <fs_s_nf_lin>-docnum.
*
*                DATA(lt_nf_entrada_wo_po_aux) = lt_nf_entrada_wo_po.
*                DELETE lt_nf_entrada_wo_po_aux WHERE docnum_saida <> <fs_s_nf_lin>-docnum.
*                SORT lt_nf_entrada_wo_po_aux BY itmnum_entrada.
*
*                lv_item_counter = 0.
*
*                LOOP AT GROUP <fs_s_nf_lin> ASSIGNING <fs_s_nf_lin_mbr>.
*
*                  lv_item_counter = lv_item_counter + 1.
*
*                  ASSIGN lt_nf_entrada_wo_po_aux[ lv_item_counter ] TO FIELD-SYMBOL(<fs_s_nf_entrada_wo_po>).
*                  IF sy-subrc IS INITIAL.
*
*                    APPEND INITIAL LINE TO ct_items_post ASSIGNING <fs_s_item_post>.
*
*                    <fs_s_item_post>-docnum   = <fs_s_nf_lin_mbr>-docnum.
*                    <fs_s_item_post>-itmnum   = <fs_s_nf_lin_mbr>-itmnum.
*                    <fs_s_item_post>-matnr    = <fs_s_nf_lin_mbr>-matnr.
*                    <fs_s_item_post>-cfop     = <fs_s_nf_entrada_wo_po>-cfop.
*                    <fs_s_item_post>-tax_code = <fs_s_nf_entrada_wo_po>-mwskz.
*
*                    " nfnet = bruto
*                    IF gs_gko_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_entrada_wo_po>-cfop ] )
*                                                          OR    lv_count_zgkop005 IS NOT INITIAL                                ).
*                      <fs_s_item_post>-item_amount = <fs_s_nf_entrada_wo_po>-nfnet * ( ( 100 - gs_gko_header-picms ) / 100 ).
*                      <fs_s_item_post>-tax_amount  = <fs_s_nf_entrada_wo_po>-nfnet - <fs_s_item_post>-item_amount.
*                    ELSE.
*                      <fs_s_item_post>-item_amount = <fs_s_nf_entrada_wo_po>-nfnet .
*                    ENDIF.
*
*                    <fs_s_item_post>-quantity     = <fs_s_nf_entrada_wo_po>-menge.
*                    <fs_s_item_post>-unit         = <fs_s_nf_entrada_wo_po>-meins.
*                    <fs_s_item_post>-ebeln        = <fs_s_nf_lin_mbr>-ebeln.
*                    <fs_s_item_post>-ebelp        = <fs_s_nf_lin_mbr>-ebelp.
*                    <fs_s_item_post>-ref_doc      = <fs_s_nf_lin_mbr>-mblnr.
*                    <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin_mbr>-zeile.
*                    <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin_mbr>-mjahr.
*
*                    <fs_s_item_post>-docnum_out   = <fs_s_nf_lin_mbr>-docnum.
*                    <fs_s_item_post>-itmnum_out   = <fs_s_nf_lin_mbr>-itmnum.
*                    <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin_mbr>-mtart_pa.
*
*                  ENDIF.
*
*                ENDLOOP.
*              ENDLOOP.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD get_items_post_others.

    RETURN.

*    CHECK iv_nf_saida IS NOT INITIAL.
*
*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).
*
*    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      =    @gs_gko_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      =    @gs_gko_header-cenario.
*
*    " Obtêm os CFOPs com Crédito de ICMS
*    SELECT *
*      FROM zttm_pcockpit006
*      INTO TABLE @DATA(lt_zgkop015).
*
*    LOOP AT in_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin_saida>) .
*
*      APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).
*
*      <fs_s_item_post>-docnum   = <fs_s_nf_lin_saida>-docnum.
*      <fs_s_item_post>-itmnum   = <fs_s_nf_lin_saida>-itmnum.
*      <fs_s_item_post>-matnr    = <fs_s_nf_lin_saida>-matnr.
*      <fs_s_item_post>-cfop     = <fs_s_nf_lin_saida>-cfop.
*      <fs_s_item_post>-tax_code = <fs_s_nf_lin_saida>-mwskz.
*
*      " nfnet = bruto
*      IF gs_gko_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_lin_saida>-cfop ] )
*                                             OR   lv_count_zgkop005 IS NOT INITIAL                                ).
*        <fs_s_item_post>-item_amount = <fs_s_nf_lin_saida>-nfnet * ( ( 100 - gs_gko_header-picms ) / 100 ).
*        <fs_s_item_post>-tax_amount  = <fs_s_nf_lin_saida>-nfnet - <fs_s_item_post>-item_amount.
*      ELSE.
*        <fs_s_item_post>-item_amount = <fs_s_nf_lin_saida>-nfnet .
*      ENDIF.
*
*      <fs_s_item_post>-quantity     = <fs_s_nf_lin_saida>-menge.
*      <fs_s_item_post>-unit         = <fs_s_nf_lin_saida>-meins.
*      <fs_s_item_post>-ebeln        = <fs_s_nf_lin_saida>-ebeln.
*      <fs_s_item_post>-ebelp        = <fs_s_nf_lin_saida>-ebelp.
*      <fs_s_item_post>-ref_doc      = <fs_s_nf_lin_saida>-mblnr.
*      <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin_saida>-zeile.
*      <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin_saida>-mjahr.
*
*      <fs_s_item_post>-docnum_out   = <fs_s_item_post>-docnum.
*      <fs_s_item_post>-itmnum_out   = <fs_s_item_post>-itmnum.
*      <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin_saida>-mtart_pa.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD get_items_post.

    DATA: lt_nf_saida       TYPE ty_t_j_1bnflin,
          lt_nf_saida_w_pa  TYPE ty_t_j_1bnflin,
          lt_nf_saida_wo_pa TYPE ty_t_j_1bnflin,
          lt_errors         TYPE zcxtm_gko=>ty_t_errors,
          lt_po_data_col    TYPE ty_t_po_data_col.

    load_gko_references( ).

    DATA(lt_gko_references_fae) = gt_gko_references[].

    SORT lt_gko_references_fae BY docnum.

    DELETE ADJACENT DUPLICATES FROM lt_gko_references_fae COMPARING docnum.

    IF lt_gko_references_fae[] IS NOT INITIAL.

      " Obtêm os dados da NF de referência
      SELECT j_1bnflin~docnum
             j_1bnflin~itmnum
             j_1bnflin~matnr
             j_1bnflin~cfop
             j_1bnflin~menge
             j_1bnflin~meins
             j_1bnflin~netwr
             j_1bnflin~nfnet
             j_1bnflin~mwskz
             j_1bnflin~xped
             j_1bnflin~nitemped
             j_1bnflin~refkey
             j_1bnflin~refitm
             t9~tipo_mat AS mtart_pa
        FROM j_1bnflin
       INNER JOIN mara ON ( mara~matnr = j_1bnflin~matnr )
        LEFT JOIN zttm_pcockpit009 AS t9 ON ( t9~tipo_mat = mara~mtart )
        INTO CORRESPONDING FIELDS OF TABLE lt_nf_saida
         FOR ALL ENTRIES IN lt_gko_references_fae
       WHERE docnum = lt_gko_references_fae-docnum.

      IF sy-subrc IS INITIAL.
        SORT lt_nf_saida BY docnum.
      ENDIF.
    ENDIF.

    " Ajusta o tamanho dos campos, para as buscas posteriores
    LOOP AT lt_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin>).

      <fs_s_nf_lin>-ebeln = <fs_s_nf_lin>-xped.
      <fs_s_nf_lin>-ebelp = <fs_s_nf_lin>-nitemped+1.
      <fs_s_nf_lin>-mblnr = <fs_s_nf_lin>-refkey(10).
      <fs_s_nf_lin>-mjahr = <fs_s_nf_lin>-refkey+10(4).
      <fs_s_nf_lin>-zeile = <fs_s_nf_lin>-refitm.

      " Separa os registros sem e com Produdo Acabado
      IF <fs_s_nf_lin>-mtart_pa IS INITIAL.
        APPEND <fs_s_nf_lin> TO lt_nf_saida_wo_pa.
      ELSE.
        APPEND <fs_s_nf_lin> TO lt_nf_saida_w_pa.
      ENDIF.

    ENDLOOP.

    " Obtêm os items para os registros que não possuem produto acabado
    get_items_post_wo_pa( EXPORTING it_nf_saida = lt_nf_saida_wo_pa
                           CHANGING ct_items_post = rt_items_post ).

    CASE gs_gko_header-cenario.

      WHEN gc_cenario-transferencia.
        " Obtêm os itens para o cenário Transferência - Registros com Produto Acabado
        get_items_post_transferencia( EXPORTING it_nf_saida = lt_nf_saida_w_pa
                                       CHANGING ct_items_post = rt_items_post ).

      WHEN gc_cenario-venda_coligada.
        " Obtêm os itens para o cenário Venda Coligada - Registros com Produto Acabado
        get_items_post_venda_coligada( EXPORTING it_nf_saida = lt_nf_saida_w_pa
                                        CHANGING ct_items_post = rt_items_post ).

      WHEN OTHERS.
        " Para os demais casos com Produto Acabado, replica os itens da NF de saída
        get_items_post_others( EXPORTING it_nf_saida = lt_nf_saida_w_pa
                                CHANGING ct_items_post = rt_items_post ).

    ENDCASE.

    DATA(lv_amount_doc) = COND ze_gko_vtprest( WHEN gs_gko_header-tpdoc = zcltm_gko_process=>gc_tpdoc-nfs
                                                    THEN gs_gko_header-vrec
                                                    ELSE gs_gko_header-vtprest ).

    DATA(lv_item_amount_tot) = REDUCE ze_gko_vtprest( INIT lr_result = CONV ze_gko_vtprest( '0' )
                                                       FOR <fs_red_item_post> IN rt_items_post
                     NEXT lr_result = lr_result + <fs_red_item_post>-item_amount + <fs_red_item_post>-tax_amount ).

    LOOP AT lt_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_saida>).

      TRY.
          ASSIGN rt_items_post[ docnum_out = <fs_s_nf_saida>-docnum
                                itmnum_out = <fs_s_nf_saida>-itmnum ] TO FIELD-SYMBOL(<fs_s_item_post>).

          IF sy-subrc IS NOT INITIAL.

            " Não foi realizada a entrada da nota &.
            ASSIGN gt_gko_references[ docnum = <fs_s_nf_saida>-docnum ] TO FIELD-SYMBOL(<fs_s_gko_reference>).
            IF sy-subrc IS INITIAL.

              RAISE EXCEPTION TYPE zcxtm_gko_process
                EXPORTING
                  textid   = zcxtm_gko_process=>no_entry_was_made_for_nf
                  gv_msgv1 = |{ <fs_s_gko_reference>-nfnum9 }-{ <fs_s_gko_reference>-serie }|.

            ENDIF.

          ELSE.

            <fs_s_item_post>-item_amount_r = lv_amount_doc * ( <fs_s_item_post>-item_amount / lv_item_amount_tot ).

          ENDIF.

        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

          APPEND lr_cx_gko_process TO lt_errors.

      ENDTRY.

    ENDLOOP.

    " Remove os itens com quantidade igual a zero (devolução)
    DELETE rt_items_post WHERE quantity IS INITIAL.

    IF lt_errors IS NOT INITIAL.

      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          gt_errors = lt_errors.

    ENDIF.

  ENDMETHOD.


  METHOD get_icon_from_codstatus.

    DEFINE _set_icon.
      IF iv_codstatus = &1.
        rv_icon = &2.
      ENDIF.
    END-OF-DEFINITION.

    _set_icon: gc_codstatus-documento_integrado            icon_activity,
*               gc_codstatus-aguardando_dados_adicionais    icon_activity,
               gc_codstatus-cenario_identificado           icon_action_success,
*               gc_codstatus-pedido_compra_criado           icon_initial,
*               gc_codstatus-pedido_compra_aprovado         icon_release,
*               gc_codstatus-miro_memorizada                icon_initial,
               gc_codstatus-miro_confirmada                icon_release,
               gc_codstatus-agrupamento_efetuado           icon_complete,
               gc_codstatus-aguardando_reagrupamento       icon_initial,
               gc_codstatus-pagamento_efetuado             icon_complete,
               gc_codstatus-evt_rejeicao_aguard_sefaz      icon_activity,
               gc_codstatus-evt_rejeicao_confirmado_sefaz  icon_complete,
*               gc_codstatus-estorno_total_realizado        icon_reject,
*               gc_codstatus-estorno_realizado              icon_reject,
               gc_codstatus-estorno_agrupamento_realizado  icon_reject,
*               gc_codstatus-estorno_miro_deb_p_realizado   icon_reject,
*               gc_codstatus-estorno_miro_deb_p_realizado_n icon_reject,
               gc_codstatus-estorno_miro_realizado_n       icon_reject,
*               gc_codstatus-pedido_eliminado               icon_reject,
               gc_codstatus-documento_cancelado            icon_reject,
*               gc_codstatus-documento_cancelado_reversao_r icon_reject,
*               gc_codstatus-aguardando_estorno_agrupamento icon_reject,
               gc_codstatus-cenario_nao_identificado       icon_alert,
               gc_codstatus-cod_transp_nao_encontrado      icon_alert,
               gc_codstatus-cod_tomador_nao_encontrado     icon_alert,
               gc_codstatus-cod_remetente_nao_encontrado   icon_alert,
               gc_codstatus-cod_dest_nao_encontrado        icon_alert,
               gc_codstatus-empresa_filial_nao_encontrado  icon_alert,
*               gc_codstatus-cenario_nao_configurado        icon_alert,
*               gc_codstatus-erro_ao_criar_pedido_compras   icon_alert,
*               gc_codstatus-erro_ao_criar_miro             icon_alert,
*               gc_codstatus-erro_ao_realizar_estorno       icon_alert,
*               gc_codstatus-erro_ao_realizar_estorno_total icon_alert,
*               gc_codstatus-erro_ao_criar_miro_deb_post    icon_alert,
               gc_codstatus-erro_estorno_agrupamento       icon_alert,
               gc_codstatus-erro_estorno_miro              icon_alert,
*               gc_codstatus-erro_estorno_miro_deb_post     icon_alert,
               gc_codstatus-erro_ao_eliminar_pedido        icon_alert,
               gc_codstatus-erro_ao_realizar_estorno_canc  icon_alert,
               gc_codstatus-erro_ao_confirmar_evt_rejeicao icon_alert,
               gc_codstatus-sem_anexo_atribuido            icon_message_warning_small.
*               gc_codstatus-sem_anexo_atribuido_miro_deb_p icon_message_warning_small.

    IF rv_icon IS INITIAL.
      rv_icon = icon_dummy.
    ENDIF.

  ENDMETHOD.


  METHOD get_emit_vendor.

    SELECT SINGLE vendor
      FROM but000
     INNER JOIN cvi_vend_link
             ON ( cvi_vend_link~partner_guid = but000~partner_guid )
      INTO rv_vendor
     WHERE partner = gs_gko_header-emit_cod.

    IF sy-subrc IS NOT INITIAL.

      " Emitente & não ampliado para fornecedor.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>emit_not_expanded_for_vendor
          gv_msgv1 = CONV #( gs_gko_header-emit_cod ).

      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD get_desc_attach_type.

    CALL FUNCTION 'DOMAIN_VALUE_GET'
      EXPORTING
        i_domname  = 'ZD_GKO_ATTACH_TYPE'
        i_domvalue = CONV domvalue_l( iv_attach_type )
      IMPORTING
        e_ddtext   = rv_desc
      EXCEPTIONS
        not_exist  = 1
        OTHERS     = 2.

    IF sy-subrc <> 0
    OR rv_desc IS INITIAL.
      rv_desc = iv_attach_type.
    ENDIF.

  ENDMETHOD.


  METHOD get_data.

    es_gko_header        = gs_gko_header.
    es_gko_compl         = gs_gko_compl.
    et_gko_attachments[] = gt_gko_attachments[].
    et_gko_references[]  = gt_gko_references[].
    et_gko_acckey_po[]   = gt_gko_acckey_po[].
    et_gko_logs[]        = gt_gko_logs[].
    et_gko_events[]      = gt_gko_events[].

  ENDMETHOD.


  METHOD get_account_cost_center.

    DATA: lv_uforig          TYPE zttm_pcockpit013-uforig,
          lv_ufdest          TYPE zttm_pcockpit013-ufdest,
          lv_branch_tom      TYPE j_1bbranch-branch,
          lv_branch_dest     TYPE j_1bbranch-branch,
          lv_branch_entrega  TYPE j_1bbranch-branch,
          lv_branch_retirada TYPE j_1bbranch-branch.

    load_gko_attachments( ).

    load_gko_references( ).

    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).

    SELECT SINGLE branch
      FROM j_1bbranch
      INTO lv_branch_tom
     WHERE stcd1      =    gs_gko_header-tom_cnpj_cpf
       AND state_insc LIKE lv_tom_ie.

    IF sy-subrc IS NOT INITIAL.

      " Filial do tomador não encontrada.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid = zcxtm_gko_process=>branch_tom_not_found.

    ENDIF.

    DATA(lv_dest_ie) = CONV j_1bstains( |%{ gs_gko_header-dest_ie }| ).

    SELECT SINGLE branch
      FROM j_1bbranch
      INTO lv_branch_dest
     WHERE stcd1      =    gs_gko_header-dest_cnpj
       AND state_insc LIKE lv_dest_ie.

    IF gs_gko_header-tpdoc = gc_tpdoc-cte.

      TRY.
          DATA(lv_xml_content) = gt_gko_attachments[ attach_type = gc_attach_type-xml ]-attach_content.

          lv_uforig = get_value_from_xml( iv_xml        = lv_xml_content
                                          iv_expression = '//*:ide/*:UFIni' ).
          lv_ufdest = get_value_from_xml( iv_xml        = lv_xml_content
                                          iv_expression = '//*:ide/*:UFFim' ).
        CATCH cx_sy_itab_line_not_found.

          lv_uforig = gs_gko_header-rem_uf .
          lv_ufdest = gs_gko_header-dest_uf.

        CATCH zcxtm_gko_process.

          lv_uforig = gs_gko_header-rem_uf .
          lv_ufdest = gs_gko_header-dest_uf.

      ENDTRY.

    ELSE.

      lv_uforig = gs_gko_header-rem_uf .
      lv_ufdest = gs_gko_header-dest_uf.

    ENDIF.

    SELECT mandt,
           guid,
           guid013,
           uforig,
           ufdest,
           rem_branch,
           tom_branch,
           cenario,
           dest_branch,
           loc_ret,
           loc_ent,
           kostl,
           saknr,
           descop
      FROM zttm_pcockpit013
     WHERE uforig      = @lv_uforig
       AND ufdest      = @lv_ufdest
       AND rem_branch  = @gs_gko_header-branch
       AND tom_branch  = @lv_branch_tom
       AND dest_branch = @lv_branch_dest
      INTO TABLE @DATA(lt_zgkop006).

    IF sy-subrc IS NOT INITIAL.

      " Não foi possível determinar o Centro de Custo e Conta Contábil &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>not_able_to_determ_cc_account
          gv_msgv1 = |{ gs_gko_header-rem_uf } { gs_gko_header-dest_uf } { gs_gko_header-branch } { lv_branch_tom } { lv_branch_dest }|.

    ENDIF.

    LOOP AT gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_reference>).

      TRY.
          DATA(lv_xml_ref) = get_xml_from_ref_nf( iv_bukrs  = gs_gko_header-bukrs
                                                  iv_branch = gs_gko_header-branch
                                                  iv_acckey = <fs_s_reference>-acckey_ref ).
          CHECK lv_xml_ref IS NOT INITIAL.

          " CNPJ e IE do local de entrega
          DATA(lv_entrega_cnpj) = get_value_from_xml( iv_xml        = lv_xml_ref
                                                      iv_expression = '//*:entrega/*:CNPJ' ).
          DATA(lv_entrega_ie)   = |%{ get_value_from_xml( iv_xml        = lv_xml_ref
                                                          iv_expression = '//*:entrega/*:IE' ) }|.
          IF lv_entrega_cnpj IS NOT INITIAL.
            SELECT SINGLE branch
              FROM j_1bbranch
              INTO lv_branch_entrega
             WHERE stcd1      =    lv_entrega_cnpj
               AND state_insc LIKE lv_entrega_ie.
          ENDIF.

          " CNPJ e IE do local de retirada
          DATA(lv_retirada_cnpj) = get_value_from_xml( iv_xml        = lv_xml_ref
                                                       iv_expression = '//*:retirada/*:CNPJ' ).
          DATA(lv_retirada_ie)   = |%{ get_value_from_xml( iv_xml        = lv_xml_ref
                                                           iv_expression = '//*:retirada/*:IE' ) }|.
          IF lv_retirada_cnpj IS NOT INITIAL.
            SELECT SINGLE branch
              FROM j_1bbranch
              INTO lv_branch_retirada
             WHERE stcd1      =    lv_retirada_cnpj
               AND state_insc LIKE lv_retirada_ie.
          ENDIF.

          " Se algum local foi encontrado, considera-se o mesmo para a busca
          IF lv_branch_entrega IS NOT INITIAL
          OR lv_branch_retirada IS NOT INITIAL.
            EXIT.
          ENDIF.
        CATCH zcxtm_gko_process.
          CONTINUE.
      ENDTRY.

    ENDLOOP.


    ASSIGN lt_zgkop006[ cenario = gs_gko_header-cenario
                        loc_ret = lv_branch_retirada
                        loc_ent = lv_branch_entrega     ] TO FIELD-SYMBOL(<fs_s_zgkop006>).
    IF sy-subrc IS NOT INITIAL.
      ASSIGN lt_zgkop006[ loc_ret = lv_branch_retirada
                          loc_ent = lv_branch_entrega     ] TO <fs_s_zgkop006>.
    ENDIF.

    IF sy-subrc IS NOT INITIAL.

      " Não foi possível determinar o Centro de Custo e Conta Contábil &.
      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          textid   = zcxtm_gko_process=>not_able_to_determ_cc_account
          gv_msgv1 = |{ gs_gko_header-rem_uf } { gs_gko_header-dest_uf } { gs_gko_header-branch } { lv_branch_tom } { lv_branch_dest } { lv_branch_retirada } { lv_branch_entrega }|.
    ENDIF.

    ev_kostl = <fs_s_zgkop006>-kostl.
    ev_saknr = <fs_s_zgkop006>-saknr.

  ENDMETHOD.


  METHOD free.

    dequeue_acckey( ).

    FREE: gt_gko_references[],
          gt_gko_attachments[],
          gt_gko_logs[],
          gs_gko_header,
          gs_gko_compl,
          gv_acckey,
          gv_xml_content,
          go_xslt_processor.

  ENDMETHOD.


  METHOD fill_relatorio_cte_comp.

    DATA: lt_acckey TYPE STANDARD TABLE OF zttm_gkot001-acckey,
          ls_comp   TYPE ty_comp.

    FREE: et_comp.

* ---------------------------------------------------------------------------
* Recupera as chaves da CDS anterior
* ---------------------------------------------------------------------------
    FIND ALL OCCURRENCES OF REGEX `ACCKEY = '([^\']*)'` IN iv_filter RESULTS DATA(lt_result).

    LOOP AT lt_result REFERENCE INTO DATA(ls_result).

      LOOP AT ls_result->submatches REFERENCE INTO DATA(ls_submatches).

        TRY.
            DATA(lv_acckey) = CONV j_1b_nfe_access_key_dtel44( iv_filter+ls_submatches->offset(ls_submatches->length) ).
            lt_acckey[] = VALUE #( BASE lt_acckey ( lv_acckey ) ).
          CATCH cx_root.
        ENDTRY.

      ENDLOOP.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Remove duplicatas
* ---------------------------------------------------------------------------
    SORT lt_acckey BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_acckey COMPARING table_line.

* ---------------------------------------------------------------------------
* Recupera campos para busca dos arquivos XML
* ---------------------------------------------------------------------------
    IF lt_acckey[] IS NOT INITIAL.

      SELECT 001~acckey,
             001~bukrs,
             001~branch
        FROM zttm_gkot001 AS 001
        INTO TABLE @DATA(lt_001)
        FOR ALL ENTRIES IN @lt_acckey
        WHERE 001~acckey = @lt_acckey-table_line.

      IF sy-subrc EQ 0.
        SORT lt_001 BY acckey.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Extrai os dados CTE - Componentes
* ---------------------------------------------------------------------------
    LOOP AT lt_001 REFERENCE INTO DATA(ls_001).

      TRY.
          DATA(lv_xml_ref) = get_xml_from_ref_nf( iv_bukrs     = ls_001->bukrs
                                                  iv_branch    = ls_001->branch
                                                  iv_acckey    = ls_001->acckey
                                                  iv_direction = 'INBD'
                                                  iv_doctype   = 'CTE' ).
        CATCH cx_root.
          CONTINUE.
      ENDTRY.


      get_value_from_xml(
        EXPORTING
          iv_xml        = lv_xml_ref
          iv_expression = '//*:vPrest/*:Comp'
        IMPORTING
          eo_nodes      = DATA(lr_nodes) ).

      DATA(lv_length) = lr_nodes->get_length( ).

      DO lv_length TIMES.

        CLEAR ls_comp.
        ls_comp-acckey = ls_001->acckey.

        DATA(lr_node) = lr_nodes->get_item( sy-index - 1 )->get_children( ).
        DATA(lr_iterator) = lr_node->create_iterator( ).

        DO 2 TIMES.

          DATA(lr_next_node) = lr_iterator->get_next( ).
          DATA(lv_name) = lr_next_node->get_name( ).

          CASE lv_name.
            WHEN 'xNome'.
              ls_comp-xnome = lr_next_node->get_value( ).
            WHEN 'vComp'.
              ls_comp-vcomp = lr_next_node->get_value( ).
          ENDCASE.

        ENDDO.

        APPEND ls_comp TO et_comp.

      ENDDO.

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_relatorio_cte_carga.

    DATA: lt_acckey TYPE STANDARD TABLE OF zttm_gkot001-acckey,
          ls_carga  TYPE ty_carga.

    FREE: et_carga.

* ---------------------------------------------------------------------------
* Recupera as chaves da CDS anterior
* ---------------------------------------------------------------------------
    FIND ALL OCCURRENCES OF REGEX `ACCKEY = '([^\']*)'` IN iv_filter RESULTS DATA(lt_result).

    LOOP AT lt_result REFERENCE INTO DATA(ls_result).

      LOOP AT ls_result->submatches REFERENCE INTO DATA(ls_submatches).

        TRY.
            DATA(lv_acckey) = CONV j_1b_nfe_access_key_dtel44( iv_filter+ls_submatches->offset(ls_submatches->length) ).
            lt_acckey[] = VALUE #( BASE lt_acckey ( lv_acckey ) ).
          CATCH cx_root.
        ENDTRY.

      ENDLOOP.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Remove duplicatas
* ---------------------------------------------------------------------------
    SORT lt_acckey BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_acckey COMPARING table_line.

* ---------------------------------------------------------------------------
* Recupera campos para busca dos arquivos XML
* ---------------------------------------------------------------------------
    IF lt_acckey[] IS NOT INITIAL.

      SELECT 001~acckey,
             001~bukrs,
             001~branch
        FROM zttm_gkot001 AS 001
        INTO TABLE @DATA(lt_001)
        FOR ALL ENTRIES IN @lt_acckey
        WHERE 001~acckey = @lt_acckey-table_line.

      IF sy-subrc EQ 0.
        SORT lt_001 BY acckey.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Extrai os dados CTE - Carga
* ---------------------------------------------------------------------------
    LOOP AT lt_001 REFERENCE INTO DATA(ls_001).

      TRY.
          DATA(lv_xml_ref) = get_xml_from_ref_nf( iv_bukrs     = ls_001->bukrs
                                                  iv_branch    = ls_001->branch
                                                  iv_acckey    = ls_001->acckey
                                                  iv_direction = 'INBD'
                                                  iv_doctype   = 'CTE' ).
        CATCH cx_root.
          CONTINUE.
      ENDTRY.

      get_value_from_xml(
        EXPORTING
          iv_xml        = lv_xml_ref
          iv_expression = '//*:infCTeNorm/*:infCarga/*:infQ'
        IMPORTING
          eo_nodes      = DATA(lr_nodes) ).

      DATA(lv_length) = lr_nodes->get_length( ).

      DO lv_length TIMES.

        CLEAR ls_carga.
        ls_carga-acckey = ls_001->acckey.

        DATA(lr_node) = lr_nodes->get_item( sy-index - 1 )->get_children( ).
        DATA(lr_iterator) = lr_node->create_iterator( ).

        DO 3 TIMES.

          DATA(lr_next_node) = lr_iterator->get_next( ).
          DATA(lv_name) = lr_next_node->get_name( ).

          CASE lv_name.
            WHEN 'cUnid'.
              ls_carga-cunid = lr_next_node->get_value( ).
            WHEN 'tpMed'.
              ls_carga-tpmed = lr_next_node->get_value( ).
            WHEN 'qCarga'.
              DATA(lv_qcarga) = lr_next_node->get_value( ).

              FIND '.' IN lv_qcarga.
              IF sy-subrc <> 0.
                lv_qcarga = |{ lv_qcarga }.00|.
              ENDIF.

              ls_carga-qcarga = lv_qcarga.
          ENDCASE.

        ENDDO.

        APPEND ls_carga TO et_carga.

      ENDDO.

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_relatorio_cte.

    DATA: lt_zgkot005 TYPE TABLE OF zttm_gkot005,
          lv_ddtext   TYPE val_text.

    DEFINE _fill_value_from_xml.
      IF &3 <> ''.
        ls_cte->&1 = get_value_from_xml( iv_xml        = ls_cte->attach_content
                                         iv_expression = &2     ) && | - | &&
                     get_value_from_xml( iv_xml        = ls_cte->attach_content
                                         iv_expression = &3     ).
      ELSE.
        ls_cte->&1 = get_value_from_xml( iv_xml        = ls_cte->attach_content
                                         iv_expression = &2     ).
      ENDIF.
    END-OF-DEFINITION.

    DEFINE _fill_tom_data.
      ls_cte->tom_nome         = ls_cte->&1_nome.
      ls_cte->tom_cnpj_cpf     = ls_cte->&1_cnpj_cpf.
      ls_cte->tom_endereco     = ls_cte->&1_endereco.
      ls_cte->tom_complemento  = ls_cte->&1_complemento.
      ls_cte->tom_cep_bairro   = ls_cte->&1_cep_bairro.
      ls_cte->tom_municipio_uf = ls_cte->&1_municipio_uf.
      ls_cte->tom_ie           = ls_cte->&1_ie.
    END-OF-DEFINITION.

    IF ct_cte IS NOT INITIAL.

      SELECT 001~acckey,
             001~emit_cod,
             000~mc_name1,
             001~bukrs,
             001~branch
        FROM zttm_gkot001 AS 001
        LEFT OUTER JOIN but000 AS 000
          ON 000~partner = 001~emit_cod
        INTO TABLE @DATA(lt_partner)
        FOR ALL ENTRIES IN @ct_cte
        WHERE 001~acckey = @ct_cte-acckey.

      IF sy-subrc EQ 0.
        SORT lt_partner BY acckey.
      ENDIF.

      SELECT 003~acckey,
             003~acckey_ref
       FROM zttm_gkot003 AS 003
       FOR ALL ENTRIES IN @ct_cte
       WHERE 003~acckey      = @ct_cte-acckey
       INTO TABLE @DATA(lt_ref).

      IF sy-subrc EQ 0.
        SORT lt_ref BY acckey.
      ENDIF.

    ENDIF.


    LOOP AT ct_cte REFERENCE INTO DATA(ls_cte).

      READ TABLE lt_ref REFERENCE INTO DATA(ls_ref) WITH KEY acckey = ls_cte->acckey BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      READ TABLE lt_partner INTO DATA(ls_001) WITH KEY acckey = ls_cte->acckey BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_001.
      ENDIF.

      TRY.
          DATA(lv_xml_ref) = get_xml_from_ref_nf( iv_bukrs     = ls_001-bukrs
                                                  iv_branch    = ls_001-branch
                                                  iv_acckey    = ls_ref->acckey
                                                  iv_direction = 'INBD'
                                                  iv_doctype   = 'CTE' ).
        CATCH cx_root.
          CONTINUE.
      ENDTRY.

      ls_cte->attach_type    = 1. " XML
      ls_cte->attach_content = lv_xml_ref.

      _fill_value_from_xml: "chcte             '//*:protCTe/*:infProt/*:chCTe'   '',
                            natop             '//*:ide/*:natOp'                 '',
                            serie             '//*:ide/*:serie'                 '',
                            valor             '//*:vRec'                        '',
                            tpcte             '//*:ide/*:tpCTe'                 '',
                            tpserv            '//*:ide/*:tpServ'                '',
                            tomador           '//*:ide//*:toma'                 '',
                            inicio_prestsrv   '//*:ide/*:xMunIni'               '//*:ide/*:UFIni',
                            termino_prestsrv  '//*:ide/*:xMunFim'               '//*:ide/*:UFFim',
                            modal             '//*:ide/*:modal'                 '',
                            digest_value      '//*:protCTe/*:infProt/*:digVal'  '',
                            nprot             '//*:nProt'                       '',
                            dhemi             '//*:ide/*:dhEmi'                 '',
                            cstat             '//*:protCTe/*:infProt/*:cStat'   '',
                            xmotivo           '//*:protCTe/*:infProt/*:xMotivo' '',
                            emit_nome         '//*:emit/*:xNome'                '',
                        emit_endereco     '//*:emit/*:enderEmit/*:xLgr'     '//*:emit/*:enderEmit/*:nro',
                        emit_complemento  '//*:emit/*:enderEmit/*:xCpl'     '',
                    emit_cep_bairro   '//*:emit/*:enderEmit/*:CEP'      '//*:emit/*:enderEmit/*:xBairro',
                    emit_municipio_uf '//*:emit/*:enderEmit/*:xMun'     '//*:emit/*:enderEmit/*:UF',
                    emit_ie           '//*:emit/*:IE'                   '',
                    rem_nome          '//*:rem/*:xNome'                 '',
                    rem_endereco      '//*:rem/*:enderReme/*:xLgr'      '//*:rem/*:enderReme/*:nro',
                    rem_complemento   '//*:rem/*:enderReme/*:xCpl'      '',
                    rem_cep_bairro    '//*:rem/*:enderReme/*:CEP'       '//*:rem/*:enderReme/*:xBairro',
                    rem_municipio_uf  '//*:rem/*:enderReme/*:xMun'      '//*:rem/*:enderReme/*:UF',
                    rem_ie            '//*:rem/*:IE'                    '',
                    dest_nome         '//*:dest/*:xNome'                '',
                    dest_endereco     '//*:dest/*:enderDest/*:xLgr'     '//*:dest/*:enderDest/*:nro',
                    dest_complemento  '//*:dest/*:enderDest/*:xCpl'     '',
                    dest_cep_bairro   '//*:dest/*:enderDest/*:CEP'      '//*:dest/*:enderDest/*:xBairro',
                    dest_municipio_uf '//*:dest/*:enderDest/*:xMun'     '//*:dest/*:enderDest/*:UF',
                    dest_ie           '//*:dest/*:IE'                   '',

                    exped_nome         '//*:exped/*:xNome'              '',
                    exped_endereco     '//*:exped/*:enderExped/*:xLgr'  '//*:dest/*:enderExped/*:nro',
                    exped_complemento  '//*:exped/*:enderExped/*:xCpl'  '',
                   exped_cep_bairro   '//*:exped/*:enderExped/*:CEP'   '//*:dest/*:enderExped/*:xBairro',
                   exped_municipio_uf '//*:exped/*:enderExped/*:xMun'  '//*:dest/*:enderExped/*:UF',
                   exped_ie           '//*:exped/*:IE'                 '',

                   receb_nome         '//*:receb/*:xNome'              '',
                   receb_endereco     '//*:receb/*:enderReceb/*:xLgr'  '//*:dest/*:enderReceb/*:nro',
                   receb_complemento  '//*:receb/*:enderReceb/*:xCpl'  '',
                   receb_cep_bairro   '//*:receb/*:enderReceb/*:CEP'   '//*:dest/*:enderReceb/*:xBairro',
                   receb_municipio_uf '//*:receb/*:enderReceb/*:xMun'  '//*:dest/*:enderReceb/*:UF',
                   receb_ie           '//*:receb/*:IE'                 '',

                   vtprest           '//*:vPrest/*:vTPrest'            '',
                   vrec              '//*:vPrest/*:vRec'               '',
                   cst               '//*:imp//*:CST'                  '',
                   vtottrib          '//*:vTotTrib'                    '',
                   vcred             '//*:vCred'                       '',
                   vcarga            '//*:infCarga/*:vCarga'           '',
                   propred           '//*:infCarga/*:proPred'          '',
                   xoutcat           '//*:infCarga/*:xOutCarga'        '',
                   xobs              '//*:xObs'                        ''.

      _fill_value_from_xml: predbc            '//*:pRedBC'                      '',
                            vbcicms           '//*:vBC'                         '',
                            picms             '//*:pICMS'                       '',
                            vicms             '//*:vICMS'                       ''.

      IF ls_cte->predbc IS INITIAL.
        _fill_value_from_xml: predbc '//*:imp/*:ICMS//*:pRedBCOutraUF' ''.
      ENDIF.

      IF ls_cte->vbcicms IS INITIAL.
        _fill_value_from_xml: vbcicms '//*:imp/*:ICMS//*:vBCSTRet' ''.
        IF ls_cte->vbcicms IS INITIAL.
          _fill_value_from_xml: vbcicms '//*:imp/*:ICMS//*:vBCOutraUF' ''.
        ENDIF.
      ENDIF.

      IF ls_cte->picms IS INITIAL.
        _fill_value_from_xml: picms '//*:imp/*:ICMS//*:pICMSSTRet' ''.
        IF ls_cte->picms IS INITIAL.
          _fill_value_from_xml: picms '//*:imp/*:ICMS//*:pICMSOutraUF' ''.
        ENDIF.
      ENDIF.

      IF ls_cte->vicms IS INITIAL.
        _fill_value_from_xml: vicms '//*:imp/*:ICMS//*:vICMSSTRet' ''.
        IF ls_cte->vicms IS INITIAL.
          _fill_value_from_xml: vicms '//*:imp/*:ICMS//*:vICMSOutraUF' ''.
        ENDIF.
      ENDIF.

      READ TABLE lt_partner REFERENCE INTO DATA(ls_partner) WITH KEY acckey = ls_cte->acckey BINARY SEARCH.

      IF sy-subrc EQ 0.
        ls_cte->lifnr       = ls_partner->emit_cod.
        ls_cte->lifnr_name1 = ls_partner->mc_name1.
      ENDIF.

      ls_cte->tp_oper = 'Entrada' ##NO_TEXT.

      DATA(ls_acckey) = CONV j_1b_nfe_access_key( ls_cte->acckey ).
      MOVE-CORRESPONDING ls_acckey TO ls_cte->*.
      ls_cte->nfenum  = ls_acckey-nfnum9.
      ls_cte->tpemis  = ls_acckey-docnum9(1).
      ls_cte->docnum8 = ls_acckey-docnum9+1.

      _fill_value_from_xml: emit_cnpj_cpf '//*:emit/*:CNPJ' ''.
      IF ls_cte->emit_cnpj_cpf IS INITIAL.
        _fill_value_from_xml: emit_cnpj_cpf '//*:emit/*:CPF' ''.
      ENDIF.

      _fill_value_from_xml: rem_cnpj_cpf '//*:rem/*:CNPJ' ''.
      IF ls_cte->rem_cnpj_cpf IS INITIAL.
        _fill_value_from_xml: rem_cnpj_cpf '//*:rem/*:CPF' ''.
      ENDIF.

      _fill_value_from_xml: dest_cnpj_cpf '//*:dest/*:CNPJ' ''.
      IF ls_cte->dest_cnpj_cpf IS INITIAL.
        _fill_value_from_xml: dest_cnpj_cpf '//*:dest/*:CPF' ''.
      ENDIF.

      _fill_value_from_xml: exped_cnpj_cpf '//*:exped/*:CNPJ' ''.
      IF ls_cte->exped_cnpj_cpf IS INITIAL.
        _fill_value_from_xml: exped_cnpj_cpf '//*:exped/*:CPF' ''.
      ENDIF.

      _fill_value_from_xml: receb_cnpj_cpf '//*:receb/*:CNPJ' ''.
      IF ls_cte->receb_cnpj_cpf IS INITIAL.
        _fill_value_from_xml: receb_cnpj_cpf '//*:receb/*:CPF' ''.
      ENDIF.

      DATA(lv_tomador) = get_value_from_xml( iv_xml        = ls_cte->attach_content
                                             iv_expression = '//*:ide//*:toma' ).

      CASE lv_tomador.

        WHEN '0'. "Remetente
          _fill_tom_data rem.

        WHEN '1'. "Expedidor
          _fill_tom_data exped.

        WHEN '2'. "Recebedor
          _fill_tom_data receb.

        WHEN '3'. "Destinatário
          _fill_tom_data dest.

        WHEN '4'. "Outros
          _fill_value_from_xml: tom_nome         '//*:toma4/*:xNome'                    '',
                   tom_endereco     '//*:toma4/*:enderToma/*:xLgr'         '//*:toma4/*:enderToma/*:nro',
                   tom_complemento  '//*:toma4/*:enderToma/*:xCpl'         '',
               tom_cep_bairro   '//*:toma4/*:enderToma/*:CEP'          '//*:toma4/*:enderToma/*:xBairro',
               tom_municipio_uf '//*:toma4/*:enderToma/*:xMun'         '//*:toma4/*:enderToma/*:UF',
               tom_ie           '//*:toma4/*:IE'                       ''.

          _fill_value_from_xml: tom_cnpj_cpf '//*:toma4/*:CNPJ' ''.
          IF ls_cte->dest_cnpj_cpf IS INITIAL.
            _fill_value_from_xml: tom_cnpj_cpf '//*:toma4/*:CPF' ''.
          ENDIF.

      ENDCASE.

      " Formato AAAA-MM-DDTHH:MM:DD TZD
      ls_cte->dtemi = ls_cte->dhemi(4)    && ls_cte->dhemi+5(2)  && ls_cte->dhemi+8(2).
      ls_cte->hremi = ls_cte->dhemi+11(2) && ls_cte->dhemi+14(2) && ls_cte->dhemi+17(2).

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_data_nfs.

    DATA: lv_counter      TYPE i,
          lv_counter_conv TYPE n LENGTH 10,
          lv_acckey       TYPE string,
          lr_municipio    TYPE RANGE OF char40.

    CONSTANTS: gc_modulo       TYPE ze_param_modulo       VALUE 'TM',
               gc_chave1       TYPE ze_param_chave        VALUE 'COCKPIT_FRETE',
               gc_municipio_nf TYPE ze_param_chave        VALUE 'MUNICIPIO_NF'.

    FREE: gs_gko_header,
          gs_gko_compl,
          gt_gko_references.

    IF gs_nfs_data-dschaveacesso IS NOT INITIAL.
      lv_acckey = gs_nfs_data-dschaveacesso.
    ELSE.
      lv_acckey = |NFS{ gs_nfs_data-docdat }{ CONV num9( gs_nfs_data-zgko_nfs ) }{ gs_nfs_data-zgko_emit-zgko_emit_cnjp_cpf }%|.
    ENDIF.
    " Verifica se existe um registro com a mesma chave
    SELECT COUNT(*)
      FROM zttm_gkot001
      INTO lv_counter
      WHERE acckey LIKE lv_acckey.

    IF sy-subrc IS INITIAL.

      " Verifica se o registro é duplicado
      SELECT COUNT(*)
        FROM zttm_gkot001
        INNER JOIN zttm_gkot004
          ON ( zttm_gkot004~acckey = zttm_gkot001~acckey )
        WHERE zttm_gkot001~acckey  LIKE lv_acckey
          AND zttm_gkot004~rem_mun = gs_nfs_data-zgko_rem-zgko_rem_municipio.

      IF sy-subrc IS INITIAL.

        " O documento já está em processamento.
        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
            textid = zcxtm_gko_process=>gc_doc_in_process.
      ENDIF.
    ENDIF.

    lv_counter = lv_counter + 1.

    lv_counter_conv = lv_counter.
    IF gs_nfs_data-dschaveacesso IS NOT INITIAL.
      gv_acckey                 =
      gs_gko_header-acckey      = gs_nfs_data-dschaveacesso.
    ELSE.
      gv_acckey                 =
gs_gko_header-acckey      = |NFS{ gs_nfs_data-docdat }{ CONV num9( gs_nfs_data-zgko_nfs ) }{ gs_nfs_data-zgko_emit-zgko_emit_cnjp_cpf }{ lv_counter_conv }|.
    ENDIF.
    gs_gko_header-dtemi         = gs_nfs_data-docdat.
    gs_gko_header-hremi         = gs_nfs_data-zgko_hrrec.
    gs_gko_header-vtprest       = gs_nfs_data-zgko_vfretetotal.
    gs_gko_header-vrec          = gs_nfs_data-zgko_vfretepag.
    gs_gko_header-vbciss        = gs_nfs_data-zgko_vbciss.
    gs_gko_header-piss          = gs_nfs_data-zgko_piss.
    gs_gko_header-viss          = gs_nfs_data-zgko_viss.
    gs_gko_header-vcarga        = gs_nfs_data-netwr.
    gs_gko_header-qcarga        = gs_nfs_data-brgew.
    gs_gko_header-nfnum9        = gs_nfs_data-zgko_nfs.
    gs_gko_header-series        = gs_nfs_data-zgko_serie.
    gs_gko_header-emit_cnpj_cpf = gs_nfs_data-zgko_emit-zgko_emit_cnjp_cpf.
    gs_gko_header-emit_ie       = gs_nfs_data-zgko_emit-zgko_emit_ie.
    gs_gko_header-emit_uf       = gs_nfs_data-zgko_emit-zgko_emit_uf.
    gs_gko_header-tom_cnpj_cpf  = gs_nfs_data-zgko_tom-zgko_tom_cnjp_cpf.
    gs_gko_header-tom_ie        = gs_nfs_data-zgko_tom-zgko_tom_ie.
    gs_gko_header-tom_uf        = gs_nfs_data-zgko_tom-zgko_tom_uf.
    gs_gko_header-rem_cnpj_cpf  = gs_nfs_data-zgko_rem-zgko_rem_cnjp_cpf.
    gs_gko_header-rem_ie        = gs_nfs_data-zgko_rem-zgko_rem_ie.
    gs_gko_header-rem_uf        = gs_nfs_data-zgko_rem-zgko_rem_uf.
    gs_gko_header-dest_uf       = gs_nfs_data-zgko_dest-zgko_dest_uf.
    gs_gko_header-dest_ie       = gs_nfs_data-zgko_dest-zgko_dest_ie.

    gs_gko_header-receb_uf      = gs_nfs_data-zgko_dest-zgko_dest_uf.
    gs_gko_header-receb_ie      = gs_nfs_data-zgko_dest-zgko_dest_ie.

    gs_gko_header-exped_cnpj    = COND #( WHEN strlen( gs_nfs_data-zgko_rem-zgko_rem_cnjp_cpf ) = 14
                                          THEN gs_nfs_data-zgko_rem-zgko_rem_cnjp_cpf
                                          ELSE space ).
    gs_gko_header-exped_cpf     = COND #( WHEN strlen( gs_nfs_data-zgko_rem-zgko_rem_cnjp_cpf ) = 11
                                          THEN gs_nfs_data-zgko_rem-zgko_rem_cnjp_cpf
                                          ELSE space ).
    gs_gko_header-exped_ie      = gs_nfs_data-zgko_rem-zgko_rem_ie.
    gs_gko_header-exped_uf      = gs_nfs_data-zgko_rem-zgko_rem_uf.

    gs_gko_header-tpevento      = gs_nfs_data-tpevento.

    IF gs_nfs_data-zgko_dest-zgko_tp_pessoa = '1'.

      " Pessoa Física
      gs_gko_header-dest_cpf   = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf+3(11).
      gs_gko_header-receb_cpf  = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf+3(11).

    ELSEIF gs_nfs_data-zgko_dest-zgko_tp_pessoa = '2'.

      " Pessoa Jurídica
      gs_gko_header-dest_cnpj   = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf.
      gs_gko_header-receb_cnpj  = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf.

    ELSE.
      CALL FUNCTION 'CONVERSION_EXIT_CGCBR_INPUT'
        EXPORTING
          input     = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf
        EXCEPTIONS
          not_valid = 1
          OTHERS    = 2.

      IF sy-subrc IS INITIAL.

        gs_gko_header-dest_cnpj  = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf.
        gs_gko_header-receb_cnpj = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf.

      ELSE.

        CALL FUNCTION 'CONVERSION_EXIT_CPFBR_INPUT'
          EXPORTING
            input     = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf+3(11)
          EXCEPTIONS
            not_valid = 1
            OTHERS    = 2.

        IF sy-subrc IS INITIAL.

          gs_gko_header-dest_cpf  = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf+3(11).
          gs_gko_header-receb_cpf = gs_nfs_data-zgko_dest-zgko_dest_cnjp_cpf+3(11).

        ELSE.

          RAISE EXCEPTION TYPE zcxtm_gko_process
            EXPORTING
              gt_bapi_return = VALUE #( ( id         = sy-msgid
                                          number     = sy-msgno
                                          type       = sy-msgty
                                          message_v1 = sy-msgv1
                                          message_v2 = sy-msgv2
                                          message_v3 = sy-msgv3
                                          message_v4 = sy-msgv4 ) ).

        ENDIF.

      ENDIF.
    ENDIF.

    gs_gko_compl-acckey      = gs_gko_header-acckey.
    gs_gko_compl-emit_nome   = gs_nfs_data-zgko_emit-zgko_emit_razao.
    gs_gko_compl-emit_lgr    = gs_nfs_data-zgko_emit-zgko_emit_endereco.
    gs_gko_compl-emit_nro    = gs_nfs_data-zgko_emit-zgko_emit_numero.
    gs_gko_compl-emit_bairro = gs_nfs_data-zgko_emit-zgko_emit_bairro.
    gs_gko_compl-emit_mun    = gs_nfs_data-zgko_emit-zgko_emit_municipio.
    gs_gko_compl-emit_cep    = gs_nfs_data-zgko_emit-zgko_emit_cep.
    gs_gko_compl-emit_cpl    = gs_nfs_data-zgko_emit-zgko_emit_compl.
    gs_gko_compl-rem_nome    = gs_nfs_data-zgko_rem-zgko_rem_razao.
    gs_gko_compl-rem_lgr     = gs_nfs_data-zgko_rem-zgko_rem_endereco.
    gs_gko_compl-rem_nro     = gs_nfs_data-zgko_rem-zgko_rem_numero.
    gs_gko_compl-rem_bairro  = gs_nfs_data-zgko_rem-zgko_rem_bairro.
    gs_gko_compl-rem_mun     = gs_nfs_data-zgko_rem-zgko_rem_municipio.
    gs_gko_compl-rem_cep     = gs_nfs_data-zgko_rem-zgko_rem_cep.
    gs_gko_compl-rem_cpl     = gs_nfs_data-zgko_rem-zgko_rem_compl.
    gs_gko_compl-dest_nome   = gs_nfs_data-zgko_dest-zgko_dest_razao.
    gs_gko_compl-dest_lgr    = gs_nfs_data-zgko_dest-zgko_dest_endereco.
    gs_gko_compl-dest_nro    = gs_nfs_data-zgko_dest-zgko_dest_numero.
    gs_gko_compl-dest_bairro = gs_nfs_data-zgko_dest-zgko_dest_bairro.
    gs_gko_compl-dest_mun    = gs_nfs_data-zgko_dest-zgko_dest_municipio.
    gs_gko_compl-dest_cep    = gs_nfs_data-zgko_dest-zgko_dest_cep.
    gs_gko_compl-dest_cpl    = gs_nfs_data-zgko_dest-zgko_dest_compl.
    gs_gko_compl-tom_nome    = gs_nfs_data-zgko_tom-zgko_tom_razao.
    gs_gko_compl-tom_lgr     = gs_nfs_data-zgko_tom-zgko_tom_endereco.
    gs_gko_compl-tom_nro     = gs_nfs_data-zgko_tom-zgko_tom_numero.
    gs_gko_compl-tom_bairro  = gs_nfs_data-zgko_tom-zgko_tom_bairro.
    gs_gko_compl-tom_mun     = gs_nfs_data-zgko_tom-zgko_tom_municipio.
    gs_gko_compl-tom_cep     = gs_nfs_data-zgko_tom-zgko_tom_cep.
    gs_gko_compl-tom_cpl     = gs_nfs_data-zgko_tom-zgko_tom_compl.

    gs_gko_compl-exped_nome    = gs_nfs_data-zgko_rem-zgko_rem_razao.
    gs_gko_compl-exped_lgr     = gs_nfs_data-zgko_rem-zgko_rem_endereco.
    gs_gko_compl-exped_nro     = gs_nfs_data-zgko_rem-zgko_rem_numero.
    gs_gko_compl-exped_bairro  = gs_nfs_data-zgko_rem-zgko_rem_bairro.
    gs_gko_compl-exped_mun     = gs_nfs_data-zgko_rem-zgko_rem_municipio.
    gs_gko_compl-exped_cep     = gs_nfs_data-zgko_rem-zgko_rem_cep.
    gs_gko_compl-exped_cpl     = gs_nfs_data-zgko_rem-zgko_rem_compl.

    gs_gko_compl-receb_nome    = gs_nfs_data-zgko_dest-zgko_dest_razao.
    gs_gko_compl-receb_lgr     = gs_nfs_data-zgko_dest-zgko_dest_endereco.
    gs_gko_compl-receb_nro     = gs_nfs_data-zgko_dest-zgko_dest_numero.
    gs_gko_compl-receb_bairro  = gs_nfs_data-zgko_dest-zgko_dest_bairro.
    gs_gko_compl-receb_mun     = gs_nfs_data-zgko_dest-zgko_dest_municipio.
    gs_gko_compl-receb_cep     = gs_nfs_data-zgko_dest-zgko_dest_cep.
    gs_gko_compl-receb_cpl     = gs_nfs_data-zgko_dest-zgko_dest_compl.



    LOOP AT gs_nfs_data-zgko_acckey ASSIGNING FIELD-SYMBOL(<fs_s_acckey>).

      APPEND INITIAL LINE TO gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_gko_ref>).

      <fs_s_gko_ref>-acckey     = gs_gko_header-acckey.
      <fs_s_gko_ref>-acckey_ref = <fs_s_acckey>-zgko_acckey_ref.

      DATA(ls_acckey) = CONV j_1b_nfe_access_key( <fs_s_gko_ref>-acckey_ref ).
      MOVE-CORRESPONDING ls_acckey TO <fs_s_gko_ref>.

    ENDLOOP.

    GET TIME.
    TRY.
        CLEAR: lr_municipio.
        NEW zclca_tabela_parametros( )->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_chave1
            iv_chave2 = gc_municipio_nf
          IMPORTING
            et_range  = lr_municipio ).

      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
*        RETURN.                                                                " DELETE - JWSILVA - 01.03.2023
    ENDTRY.


*    IF gs_nfs_data-zgko_local EQ 'BRASILIA'.
    IF gs_nfs_data-zgko_local IN lr_municipio AND lr_municipio IS NOT INITIAL.  " CHANGE - JWSILVA - 01.03.2023
      gs_gko_header-tpdoc  = gc_tpdoc-nfe.
      gs_gko_header-model  = '55'.
    ELSE.
      gs_gko_header-tpdoc  = gc_tpdoc-nfs.
    ENDIF.

*    gs_gko_header-tpdoc  = gc_tpdoc-nfs.
    gs_gko_header-crenam = sy-uname.
    gs_gko_header-credat = sy-datum.
    gs_gko_header-cretim = sy-uzeit.

  ENDMETHOD.


  METHOD fill_data_cte.

    DATA: lt_acckey_orig TYPE TABLE OF zttm_gkot003-acckey_orig.

    DATA: lv_tomador TYPE numc1,
          lv_qcarga  TYPE zttm_gkot001-qcarga,
          lv_dhemi   TYPE string.

    FREE: gs_gko_header,
          gt_gko_references.

    go_xslt_processor = NEW cl_xslt_processor( ).
    go_xslt_processor->set_source_xstring( sstring = gv_xml_content ).

    _fill_gko_header_from_xml: acckey        '//*:protCTe/*:infProt/*:chCTe'      '' ''.

    gv_acckey = gs_gko_header-acckey.

    attach_file( iv_attach_type  = gc_attach_type-xml
                 iv_data_xstring = gv_xml_content    ).

    _fill_gko_header_from_xml: model         '//*:ide/*:mod'                      ''                             '',
                               nfnum9        '//*:ide/*:nCT'                      ''                             '',
                               series        '//*:ide/*:serie'                    ''                             '',
                               tpcte         '//*:ide/*:tpCTe'                    ''                             '',
                               vtprest       '//*:vPrest/*:vTPrest'               ''                             '',
                               vcarga        '//*:infCTeNorm/*:infCarga/*:vCarga' ''                             '',
                               cfop          '//*:CFOP'                           ''                             '',
                               emit_cnpj_cpf '//*:emit/*:CNPJ'                    '//*:emit/*:CPF'               '',
                               emit_ie       '//*:emit/*:IE'                      ''                             '',
                               emit_uf       '//*:emit/*:enderEmit/*:UF'          ''                             '',
                               rem_cnpj_cpf  '//*:rem/*:CNPJ'                     '//*:rem/*:CPF'                '',
                               rem_ie        '//*:rem/*:IE'                       ''                             '',
                               rem_uf        '//*:rem/*:enderReme/*:UF'           ''                             '',
                               dest_cnpj     '//*:dest/*:CNPJ'                    ''                             '',
                               dest_cpf      '//*:dest/*:CPF'                     ''                             '',
                               dest_ie       '//*:dest/*:IE'                      ''                             '',
                               dest_uf       '//*:dest/*:enderDest/*:UF'          ''                             '',
                               exped_cnpj    '//*:exped/*:CNPJ'                   ''                             '',
                               exped_cpf     '//*:exped/*:CPF'                    ''                             '',
                               exped_ie      '//*:exped/*:IE'                     ''                             '',
                               exped_uf      '//*:exped/*:enderExped/*:UF'        ''                             '',
                               receb_cnpj    '//*:receb/*:CNPJ'                   ''                             '',
                               receb_cpf     '//*:receb/*:CPF'                    ''                             '',
                               receb_ie      '//*:receb/*:IE'                     ''                             '',
                               receb_uf      '//*:receb/*:enderReceb/*:UF'        ''                             '',
                            vbcicms       '//*:imp/*:ICMS//*:vBC'              '//*:imp/*:ICMS//*:vBCSTRet'   '//*:imp/*:ICMS//*:vBCOutraUF'  ,
                            picms         '//*:imp/*:ICMS//*:pICMS'            '//*:imp/*:ICMS//*:pICMSSTRet' '//*:imp/*:ICMS//*:pICMSOutraUF',
                            vicms         '//*:imp/*:ICMS//*:vICMS'            '//*:imp/*:ICMS//*:vICMSSTRet' '//*:imp/*:ICMS//*:vICMSOutraUF',
                            tpevento      '//*:compl/*:xCaracAd'               ''                             ''.

    gs_gko_header-nfnum9 = |{ gs_gko_header-nfnum9 ALPHA = IN }|.

    IF gs_gko_header-tpevento IS INITIAL.
      gs_gko_header-tpevento = 'VAZIO'.
    ENDIF.

    gs_gko_header-tpevento = |{ gs_gko_header-tpevento CASE = UPPER }|.


    " Formato AAAA-MM-DDTHH:MM:DD TZD
    lv_dhemi            = get_value_from_xml( io_xslt_processor = go_xslt_processor
                                              iv_expression     = '//*:ide/*:dhEmi' ).
    gs_gko_header-dtemi = lv_dhemi(4)    && lv_dhemi+5(2)  && lv_dhemi+8(2).
    gs_gko_header-hremi = lv_dhemi+11(2) && lv_dhemi+14(2) && lv_dhemi+17(2).

    lv_tomador = get_value_from_xml( io_xslt_processor = go_xslt_processor
                                     iv_expression     = '//*:ide//*:toma' ).

    CASE lv_tomador.

      WHEN '0'. " Remetente
        gs_gko_header-tom_cnpj_cpf = gs_gko_header-rem_cnpj_cpf.
        gs_gko_header-tom_ie       = gs_gko_header-rem_ie.
        gs_gko_header-tom_uf       = gs_gko_header-rem_uf.

      WHEN '1'. " Expedidor
        _fill_gko_header_from_xml: tom_cnpj_cpf '//*:exped/*:CNPJ'            '//*:exped/*:CPF' '',
                                   tom_ie       '//*:exped/*:IE'              ''                '',
                                   tom_uf       '//*:exped/*:enderExped/*:UF' ''                ''.

      WHEN '2'. " Recebedor
        _fill_gko_header_from_xml: tom_cnpj_cpf '//*:receb/*:CNPJ'            '//*:receb/*:CPF' '',
                                   tom_ie       '//*:receb/*:IE'              ''                '',
                                   tom_uf       '//*:receb/*:enderReceb/*:UF' ''                ''.

      WHEN '3'. " Destinatário
        gs_gko_header-tom_cnpj_cpf = COND #( WHEN gs_gko_header-dest_cnpj IS NOT INITIAL
                                             THEN gs_gko_header-dest_cnpj
                                             ELSE gs_gko_header-dest_cpf ).

        gs_gko_header-tom_ie = gs_gko_header-dest_ie.
        gs_gko_header-tom_uf = gs_gko_header-dest_uf.

      WHEN '4'. "Outros
        _fill_gko_header_from_xml: tom_cnpj_cpf '//*:toma4/*:CNPJ'            '//*:toma4/*:CPF' '',
                                   tom_ie       '//*:toma4/*:IE'              ''                '',
                                   tom_uf       '//*:toma4/*:enderToma/*:UF'  ''                ''.

    ENDCASE.

    get_value_from_xml( EXPORTING io_xslt_processor = go_xslt_processor
                                  iv_expression     = '//*:infCTeNorm/*:infCarga/*:infQ'
                        IMPORTING eo_nodes          = DATA(lo_nodes) ).

    DATA(lv_length) = lo_nodes->get_length( ).

    DO lv_length TIMES.

      DATA(lo_node)      = lo_nodes->get_item( sy-index - 1 )->get_children( ).
      DATA(lo_iterator)  = lo_node->create_iterator( ).
      DATA(lo_next_node) = lo_iterator->get_next( ).

      CHECK lo_next_node->get_name( ) = 'cUnid'.

      CASE lo_next_node->get_value( ).

        WHEN '01'. " cUnid = 01-KG
          lo_iterator->get_next( ). " Pula a tag tpMed
          lo_next_node = lo_iterator->get_next( ).

          DATA(lv_qcarga_aux) = lo_next_node->get_value( ).

          FIND '.' IN lv_qcarga_aux.
          IF sy-subrc <> 0.
            lv_qcarga_aux = |{ lv_qcarga_aux }.00|.
          ENDIF.

          lv_qcarga            = lv_qcarga_aux.
          gs_gko_header-qcarga = gs_gko_header-qcarga + lv_qcarga.

        WHEN '02'. " cUnid = 02-TON
          lo_iterator->get_next( ). " Pula a tag tpMed
          lo_next_node = lo_iterator->get_next( ).

          lv_qcarga_aux = lo_next_node->get_value( ).

          FIND '.' IN lv_qcarga_aux.
          IF sy-subrc <> 0.
            lv_qcarga_aux = |{ lv_qcarga_aux }.00|.
          ENDIF.

          lv_qcarga            = lv_qcarga_aux.
          gs_gko_header-qcarga = gs_gko_header-qcarga + ( lv_qcarga * 1000 ).

      ENDCASE.

    ENDDO.

    CASE gs_gko_header-tpcte.

      WHEN gc_tpcte-complemento_de_valores.

        get_value_from_xml( EXPORTING io_xslt_processor = go_xslt_processor
                                      iv_expression     = '//*:infCteComp/*:chCTe'
                            IMPORTING eo_nodes          = lo_nodes ).

        lv_length = lo_nodes->get_length( ).

        DO lv_length TIMES.

          DATA(lr_node_it) = lo_nodes->get_item( sy-index - 1 ).
          lo_iterator = lr_node_it->create_iterator( ).

          lo_next_node = lo_iterator->get_next( ).

          APPEND lo_next_node->get_value( ) TO lt_acckey_orig.

        ENDDO.

        IF lt_acckey_orig IS NOT INITIAL.

          SELECT mandt,
                 acckey,
                 acckey_ref,
                 acckey_orig,
                 docnum,
                 prod_acabado,
                 regio,
                 nfyear,
                 nfmonth,
                 stcd1,
                 model,
                 serie,
                 nfnum9,
                 docnum9,
                 cdv
            FROM zttm_gkot003
             FOR ALL ENTRIES IN @lt_acckey_orig
           WHERE acckey = @lt_acckey_orig-table_line
            INTO TABLE @DATA(lt_zgkot003).

          IF sy-subrc IS INITIAL.
            SORT lt_zgkot003 BY acckey.
          ENDIF.

          LOOP AT lt_acckey_orig ASSIGNING FIELD-SYMBOL(<fs_s_acckey_orig>).

            READ TABLE lt_zgkot003 TRANSPORTING NO FIELDS
                                                 WITH KEY acckey = <fs_s_acckey_orig>
                                                 BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              LOOP AT lt_zgkot003 ASSIGNING FIELD-SYMBOL(<fs_s_zgkot003>) FROM sy-tabix.
                IF <fs_s_zgkot003>-acckey NE <fs_s_acckey_orig>.
                  EXIT.
                ENDIF.

                APPEND CORRESPONDING #( <fs_s_zgkot003> ) TO gt_gko_references ASSIGNING FIELD-SYMBOL(<fs_s_gko_ref>).

                <fs_s_gko_ref>-acckey      = gv_acckey.
                <fs_s_gko_ref>-acckey_orig = <fs_s_acckey_orig>.

              ENDLOOP.
            ENDIF.

            IF sy-subrc IS NOT INITIAL.

              APPEND VALUE #( acckey      = gv_acckey
                              acckey_orig = <fs_s_acckey_orig> ) TO gt_gko_references.

            ENDIF.

          ENDLOOP.
        ENDIF.

      WHEN gc_tpcte-substituto.

        get_value_from_xml(
          EXPORTING
            io_xslt_processor = go_xslt_processor
            iv_expression     = '//*:infCTeNorm/*:infDoc/*:infNFe/*:chave'
          IMPORTING
            eo_nodes         = lo_nodes ).

        lv_length = lo_nodes->get_length( ).

        DO lv_length TIMES.

          APPEND INITIAL LINE TO gt_gko_references ASSIGNING <fs_s_gko_ref>.

          lr_node_it = lo_nodes->get_item( sy-index - 1 ).
          lo_iterator = lr_node_it->create_iterator( ).

          lo_next_node = lo_iterator->get_next( ).

          <fs_s_gko_ref>-acckey      = gv_acckey.
          <fs_s_gko_ref>-acckey_ref  = lo_next_node->get_value( ).

          DATA(ls_acckey) = CONV j_1b_nfe_access_key( <fs_s_gko_ref>-acckey_ref ).
          MOVE-CORRESPONDING ls_acckey TO <fs_s_gko_ref>.

        ENDDO.

        IF gt_gko_references IS NOT INITIAL.

          " Obtêm a chave de origem
          SELECT acckey,
                 acckey_ref
            FROM zttm_gkot003
            INTO TABLE @DATA(lt_references_sub)
             FOR ALL ENTRIES IN @gt_gko_references
           WHERE acckey     <> @gv_acckey
             AND acckey_ref =  @gt_gko_references-acckey_ref.

          LOOP AT gt_gko_references ASSIGNING <fs_s_gko_ref>.

            READ TABLE lt_references_sub ASSIGNING FIELD-SYMBOL(<fs_s_ref_sub>) WITH KEY acckey_ref = <fs_s_gko_ref>-acckey_ref.
            IF sy-subrc IS INITIAL.

              <fs_s_gko_ref>-acckey_orig = <fs_s_ref_sub>-acckey.

            ENDIF.

          ENDLOOP.
        ENDIF.

      WHEN OTHERS.

        get_value_from_xml(
          EXPORTING
            io_xslt_processor = go_xslt_processor
            iv_expression     = '//*:infCTeNorm/*:infDoc/*:infNFe/*:chave'
          IMPORTING
            eo_nodes         = lo_nodes ).

        lv_length = lo_nodes->get_length( ).

        DO lv_length TIMES.

          APPEND INITIAL LINE TO gt_gko_references ASSIGNING <fs_s_gko_ref>.

          lr_node_it = lo_nodes->get_item( sy-index - 1 ).
          lo_iterator = lr_node_it->create_iterator( ).

          lo_next_node = lo_iterator->get_next( ).

          <fs_s_gko_ref>-acckey     = gv_acckey.
          <fs_s_gko_ref>-acckey_ref = lo_next_node->get_value( ).

          ls_acckey = CONV j_1b_nfe_access_key( <fs_s_gko_ref>-acckey_ref ).
          MOVE-CORRESPONDING ls_acckey TO <fs_s_gko_ref>.

        ENDDO.

    ENDCASE.

    GET TIME.

    gs_gko_header-tpdoc  = gc_tpdoc-cte.
    gs_gko_header-crenam = sy-uname.
    gs_gko_header-credat = sy-datum.
    gs_gko_header-cretim = sy-uzeit.

    " Preenche dados complementares

    gs_gko_compl-acckey       = gs_gko_header-acckey.
    gs_gko_compl-emit_nome    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:xNome' ).
    gs_gko_compl-emit_lgr     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:enderEmit/*:xLgr' ).
    gs_gko_compl-emit_nro     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:enderEmit/*:nro' ).
    gs_gko_compl-emit_bairro  = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:enderEmit/*:xBairro').
    gs_gko_compl-emit_mun     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:enderEmit/*:xMun' ).
    gs_gko_compl-emit_cep     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:enderEmit/*:CEP' ).
    gs_gko_compl-emit_cpl     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:emit/*:enderEmit/*:xCpl' ).

    gs_gko_compl-rem_nome     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:xNome').
    gs_gko_compl-rem_lgr      = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:enderReme/*:xLgr'  ).
    gs_gko_compl-rem_nro      = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:enderReme/*:nro' ).
    gs_gko_compl-rem_bairro   = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:enderReme/*:xBairro' ).
    gs_gko_compl-rem_mun      = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:enderReme/*:xMun' ).
    gs_gko_compl-rem_cep      = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:enderReme/*:CEP' ).
    gs_gko_compl-rem_cpl      = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:rem/*:enderReme/*:xCpl' ).

    gs_gko_compl-dest_nome    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:xNome' ).
    gs_gko_compl-dest_lgr     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:enderDest/*:xLgr' ).
    gs_gko_compl-dest_nro     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:enderDest/*:nro' ).
    gs_gko_compl-dest_bairro  = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:enderDest/*:xBairro' ).
    gs_gko_compl-dest_mun     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:enderDest/*:xMun' ).
    gs_gko_compl-dest_cep     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:enderDest/*:CEP'  ).
    gs_gko_compl-dest_cpl     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:dest/*:enderDest/*:xCpl' ).

    gs_gko_compl-exped_nome   = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:xNome' ).
    gs_gko_compl-exped_lgr    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:enderExped/*:xLgr' ).
    gs_gko_compl-exped_nro    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:enderExped/*:nro' ).
    gs_gko_compl-exped_bairro = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:enderExped/*:xBairro' ).
    gs_gko_compl-exped_mun    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:enderExped/*:xMun' ).
    gs_gko_compl-exped_cep    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:enderExped/*:CEP' ).
    gs_gko_compl-exped_cpl    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:exped/*:enderExped/*:xCpl' ).

    gs_gko_compl-receb_nome   = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:xNome' ).
    gs_gko_compl-receb_lgr    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:enderReceb/*:xLgr' ).
    gs_gko_compl-receb_nro    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:enderReceb/*:nro' ).
    gs_gko_compl-receb_bairro = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:enderReceb/*:xBairro' ).
    gs_gko_compl-receb_mun    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:enderReceb/*:xMun' ).
    gs_gko_compl-receb_cep    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:enderReceb/*:CEP' ).
    gs_gko_compl-receb_cpl    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:receb/*:enderReceb/*:xCpl' ).

    CASE lv_tomador.

      WHEN '0'. "Remetente
        gs_gko_compl-tom_nome    = gs_gko_compl-rem_nome.
        gs_gko_compl-tom_lgr     = gs_gko_compl-rem_lgr.
        gs_gko_compl-tom_nro     = gs_gko_compl-rem_nro.
        gs_gko_compl-tom_bairro  = gs_gko_compl-rem_bairro.
        gs_gko_compl-tom_mun     = gs_gko_compl-rem_mun.
        gs_gko_compl-tom_cep     = gs_gko_compl-rem_cep.
        gs_gko_compl-tom_cpl     = gs_gko_compl-rem_cpl.

      WHEN '1'. "Expedidor
        gs_gko_compl-tom_nome    = gs_gko_compl-exped_nome.
        gs_gko_compl-tom_lgr     = gs_gko_compl-exped_lgr.
        gs_gko_compl-tom_nro     = gs_gko_compl-exped_nro.
        gs_gko_compl-tom_bairro  = gs_gko_compl-exped_bairro.
        gs_gko_compl-tom_mun     = gs_gko_compl-exped_mun.
        gs_gko_compl-tom_cep     = gs_gko_compl-exped_cep.
        gs_gko_compl-tom_cpl     = gs_gko_compl-exped_cpl.

      WHEN '2'. "Recebedor
        gs_gko_compl-tom_nome    = gs_gko_compl-receb_nome.
        gs_gko_compl-tom_lgr     = gs_gko_compl-receb_lgr.
        gs_gko_compl-tom_nro     = gs_gko_compl-receb_nro.
        gs_gko_compl-tom_bairro  = gs_gko_compl-receb_bairro.
        gs_gko_compl-tom_mun     = gs_gko_compl-receb_mun.
        gs_gko_compl-tom_cep     = gs_gko_compl-receb_cep.
        gs_gko_compl-tom_cpl     = gs_gko_compl-receb_cpl.

      WHEN '3'. "Destinatário
        gs_gko_compl-tom_nome    = gs_gko_compl-dest_nome.
        gs_gko_compl-tom_lgr     = gs_gko_compl-dest_lgr.
        gs_gko_compl-tom_nro     = gs_gko_compl-dest_nro.
        gs_gko_compl-tom_bairro  = gs_gko_compl-dest_bairro.
        gs_gko_compl-tom_mun     = gs_gko_compl-dest_mun.
        gs_gko_compl-tom_cep     = gs_gko_compl-dest_cep.
        gs_gko_compl-tom_cpl     = gs_gko_compl-dest_cpl.

      WHEN '4'. "Outros
        gs_gko_compl-tom_nome    = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:xNome' ).
        gs_gko_compl-tom_lgr     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:enderToma/*:xLgr' ).
        gs_gko_compl-tom_nro     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:enderToma/*:nro' ).
        gs_gko_compl-tom_bairro  = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:enderToma/*:xBairro' ).
        gs_gko_compl-tom_mun     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:enderToma/*:xMun' ).
        gs_gko_compl-tom_cep     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:enderToma/*:CEP' ).
        gs_gko_compl-tom_cpl     = get_value_from_xml( io_xslt_processor = go_xslt_processor iv_expression = '//*:toma4/*:enderToma/*:xCpl' ).

    ENDCASE.

  ENDMETHOD.


  METHOD check_dff.

    FREE: gv_wait_async,
          gv_check,
          gt_sfir_id,
          gt_return.

* ---------------------------------------------------------------------------
* Recupera o DFF atual
* ---------------------------------------------------------------------------
    SELECT SINGLE acckey, sfir_id
        FROM zi_tm_cockpit001
        WHERE acckey = @gs_gko_header-acckey
        INTO @DATA(ls_001).

    IF sy-subrc NE 0.
      CLEAR ls_001.
    ENDIF.

    " Valida se existe DFF
    IF ls_001-sfir_id IS INITIAL.
      rv_check = abap_true.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica e recupera o DFF criado
* ---------------------------------------------------------------------------
    CALL FUNCTION 'ZFMTM_GKO_CHECK_DFF'
      STARTING NEW TASK 'GKO_CHECK_DFF'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_torid  = gs_gko_header-tor_id
        iv_acckey = gs_gko_header-acckey.

    WAIT UNTIL gv_wait_async = abap_true.
    DATA(lt_return)  = gt_return.
    DATA(lt_sfir_id) = gt_sfir_id.
    rv_check = gv_check.

    CHECK rv_check EQ abap_false.

    IF NOT line_exists( lt_return[ type = 'E' ] ).

      IF line_exists( lt_sfir_id[ table_line = ls_001-sfir_id ] ).
        me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-frete_faturado ).
      ELSE.
        " Documento DFF &1 encontrado não consta no fluxo de documentos.
        me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_fat_frete
                                  it_bapi_ret = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '133' message_v1 = ls_001-sfir_id ) ) ).
      ENDIF.

    ELSE.

      DELETE ADJACENT DUPLICATES FROM gt_return COMPARING id number message_v1 message_v2 message_v3 message_v4.

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_fat_frete
                                it_bapi_ret = gt_return ).

    ENDIF.

  ENDMETHOD.


  METHOD determina_configuracao_p013.

    FREE: es_header,
          ev_tom_branch,
          ev_rem_branch,
          ev_dest_branch,
          es_p013.

    IF iv_acckey IS NOT INITIAL.

      SELECT SINGLE *
          FROM zttm_gkot001
          WHERE acckey = @iv_acckey
            AND tor_id = @iv_tor_id
          INTO @es_header.

      IF sy-subrc NE 0.
        CLEAR es_header.
      ENDIF.
    ENDIF.

    IF is_header IS NOT INITIAL.
      es_header = is_header.
    ENDIF.

    CHECK es_header IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Recupera dados do Tomador, Remetente e Destinatário
* ---------------------------------------------------------------------------
    SELECT werks, kunnr, j_1bbranch
      INTO TABLE @DATA(lt_tom_branch)
      FROM t001w
      WHERE kunnr = @es_header-tom_cod.

    SELECT werks, kunnr, j_1bbranch
      INTO TABLE @DATA(lt_rem_branch)
      FROM t001w
      WHERE kunnr = @es_header-rem_cod.

    SELECT werks, kunnr, j_1bbranch
      INTO TABLE @DATA(lt_dest_branch)
      FROM t001w
      WHERE kunnr = @es_header-dest_cod.

    IF lt_tom_branch IS NOT INITIAL.
      ev_tom_branch = lt_tom_branch[ 1 ]-j_1bbranch. "werks.
    ENDIF.

    IF lt_rem_branch IS NOT INITIAL.
      ev_rem_branch = lt_rem_branch[ 1 ]-j_1bbranch. "werks.
    ENDIF.

    IF lt_dest_branch IS NOT INITIAL.
      ev_dest_branch = lt_dest_branch[ 1 ]-j_1bbranch. "werks.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera a configuração ( testa diferentes combinações )
* ---------------------------------------------------------------------------
    SELECT *
      INTO TABLE @DATA(lt_p013)
      FROM zttm_pcockpit013
      WHERE ( cenario   = @es_header-cenario OR cenario = '00' )
        AND uforig      = @es_header-rem_uf
        AND ufdest      = @es_header-dest_uf
        AND rem_branch  = @ev_rem_branch
        AND tom_branch  = @ev_tom_branch.

    IF sy-subrc EQ 0.
      SORT lt_p013 BY cenario uforig ufdest rem_branch tom_branch.
    ENDIF.

    READ TABLE lt_p013 INTO es_p013 WITH KEY cenario     = es_header-cenario
                                             uforig      = es_header-rem_uf
                                             ufdest      = es_header-dest_uf
                                             rem_branch  = ev_rem_branch
                                             tom_branch  = ev_tom_branch
                                             dest_branch = ev_dest_branch
                                             loc_ret     = es_header-ret_loc
                                             loc_ent     = es_header-ent_loc.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

    READ TABLE lt_p013 INTO es_p013 WITH KEY cenario     = es_header-cenario
                                             uforig      = es_header-rem_uf
                                             ufdest      = es_header-dest_uf
                                             rem_branch  = ev_rem_branch
                                             tom_branch  = ev_tom_branch
                                             dest_branch = ev_dest_branch
                                             loc_ret     = es_header-ret_loc.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

    READ TABLE lt_p013 INTO es_p013 WITH KEY cenario     = es_header-cenario
                                             uforig      = es_header-rem_uf
                                             ufdest      = es_header-dest_uf
                                             rem_branch  = ev_rem_branch
                                             tom_branch  = ev_tom_branch
                                             dest_branch = ev_dest_branch
                                             loc_ent     = es_header-ent_loc.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

    READ TABLE lt_p013 INTO es_p013 WITH KEY cenario     = '00'
                                             uforig      = es_header-rem_uf
                                             ufdest      = es_header-dest_uf
                                             rem_branch  = ev_rem_branch
                                             tom_branch  = ev_tom_branch
                                             dest_branch = ev_dest_branch
                                             loc_ret     = es_header-ret_loc
                                             loc_ent     = es_header-ent_loc.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

    READ TABLE lt_p013 INTO es_p013 WITH KEY cenario     = '00'
                                             uforig      = es_header-rem_uf
                                             ufdest      = es_header-dest_uf
                                             rem_branch  = ev_rem_branch
                                             tom_branch  = ev_tom_branch.
    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera Parâmetro GKO local
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_zgko_local IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_zgko_local-modulo
                                                 chave1 = gc_param_zgko_local-chave1
                                                 chave2 = gc_param_zgko_local-chave2
                                               chave3 = gc_param_zgko_local-chave3 ).

      me->get_t_parameter( EXPORTING is_param = ls_parametro
                           IMPORTING et_value = me->gs_parameter-r_zgko_local[] ).

    ENDIF.

    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD get_t_parameter.

    FREE et_value.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                         iv_chave1 = is_param-chave1
                                         iv_chave2 = is_param-chave2
                                         iv_chave3 = is_param-chave3
                               IMPORTING et_range  = et_value ).
      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.


  METHOD check_status_sefaz_direct.

    DATA: lt_events_prot TYPE zctgtm_gko_014.


    status_check( EXPORTING iv_cteid       = iv_acckey
                  IMPORTING es_infprot     = DATA(ls_infprot)
                            et_events_prot = lt_events_prot
                            ev_subrc       = DATA(lv_subrc) ).

    IF lv_subrc IS NOT INITIAL.

      CASE lv_subrc.
        WHEN 1.
          DATA(lv_desc_cod_sysubrc) = 'VERSION_NOT_MAINTAINED'.
        WHEN 2.
          lv_desc_cod_sysubrc = 'ERROR_PROXY_CALL'.
        WHEN 3.
          lv_desc_cod_sysubrc = 'TRANSFORMATION_ERROR'.
        WHEN 4.
          lv_desc_cod_sysubrc = 'ERROR_READING_CTE'.
        WHEN OTHERS.
          lv_desc_cod_sysubrc = 'ERROR_ON_CALL_RFC'.
      ENDCASE.

      " Erro ao confirmar o evento de rejeição na SEFAZ
      set_status( iv_status   = gc_codstatus-erro_ao_confirmar_evt_rejeicao
                  iv_codigo   = CONV #( sy-subrc )
                  iv_desc_cod = CONV #( lv_desc_cod_sysubrc ) ).

      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
*         textid   = CONV #( sy-subrc )
          gv_msgv1 = CONV #( lv_desc_cod_sysubrc ).

    ELSE.

      " Verifica se o evento de desacordo foi registrado
      LOOP AT lt_events_prot ASSIGNING FIELD-SYMBOL(<fs_s_event_prot>)
                       WHERE tpevento = '610110'    " Desacordo de Entrega de Serviço
AND ( cstat  = '134'       " Evento registrado e vinculado ao CT-e com alerta para situação do documento.
OR cstat  = '135'       " Evento registrado e vinculado a CT-e
OR cstat  = '136'    ). " Evento registrado, mas não vinculado a CT-e
        EXIT.
      ENDLOOP.

      IF sy-subrc IS INITIAL.

        " Evento de rejeição realizado e confirmado pela SEFAZ
        set_status( iv_status   = gc_codstatus-evt_rejeicao_confirmado_sefaz
                    iv_codigo   = <fs_s_event_prot>-cstat
                    iv_desc_cod = CONV #( <fs_s_event_prot>-xmotivo ) ).

        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
*           textid   = CONV #( <fs_s_event_prot>-cstat )
            gv_msgv1 = CONV #( <fs_s_event_prot>-xmotivo ).

      ELSE.

        READ TABLE lt_events_prot ASSIGNING <fs_s_event_prot> WITH KEY tpevento = '610110'.
        IF sy-subrc IS INITIAL.

          DATA(lv_cstat) = <fs_s_event_prot>-cstat.
          DATA(lv_xmotivo) = <fs_s_event_prot>-xmotivo.

        ELSEIF ls_infprot-c_stat <> '100'.

          lv_cstat   = ls_infprot-c_stat.
          lv_xmotivo = ls_infprot-x_motivo.

        ENDIF.

        " Erro ao confirmar o evento de rejeição na SEFAZ
        set_status( iv_status   = gc_codstatus-erro_ao_confirmar_evt_rejeicao
                    iv_codigo   = lv_cstat
                    iv_desc_cod = CONV #( lv_xmotivo ) ).

        RAISE EXCEPTION TYPE zcxtm_gko_process
          EXPORTING
*           textid   = CONV #( lv_cstat )
            gv_msgv1 = CONV #( lv_xmotivo ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_miro.

    " Tipo Pedido = NB e status 300 (criado) não faz a MIRO (somente NB com status 301 aprovado)
    " e pedidos ZGKO faz a MIRO tanto para status 300 quanto 301

    " ------------------------------------------------
    " Chama programa para criação da MIRO
    " ------------------------------------------------
    TRY.
        DATA(lt_seltab) = VALUE ty_rsparams( ( selname = 'S_ACCKEY'
                                               kind    = 'S'
                                               sign    = 'I'
                                               option  = 'EQ'
                                               low     = gs_gko_header-acckey ) ).

        me->persist( ).
        me->free( ).

        SUBMIT zmmr_gko_processa
            WITH SELECTION-TABLE lt_seltab
            AND RETURN.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD create_extra_charge_and_step.

* ---------------------------------------------------------------------------
* Libera o bloqueio atual
* ---------------------------------------------------------------------------
    TRY.
        me->persist( ).
        me->dequeue_acckey( ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Chama processo de criação de custo e faturamento de frete
* ---------------------------------------------------------------------------
    FREE: gv_wait_async, gt_return.

    CALL FUNCTION 'ZFMTM_EXTRA_CHARGE_AND_STEP'
      STARTING NEW TASK 'EXTRA_CHARGE_AND_STEP'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_gko_header = gs_gko_header.

    WAIT UNTIL gv_wait_async = abap_true.
    DATA(lt_return) = gt_return.

* ---------------------------------------------------------------------------
* Recupera o bloqueio
* ---------------------------------------------------------------------------
    TRY.
        me->enqueue_acckey( gv_locked_in_tab ).
        gv_min_data_load = abap_false.
        me->load_data_from_acckey( ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD determine_charge.

*    IF is_gko_header-tpdoc EQ gc_tpdoc-cte AND is_gko_header-tpcte EQ gc_tpcte-complemento_de_valores.
*      rv_evento = 'CTE_COMPLEMENTA'.
*      RETURN.
*    ENDIF.
*
*    IF ( is_gko_header-tpevento EQ 'NORMAL' OR  is_gko_header-tpevento EQ 'ENTREGA' )
*    OR ( is_gko_header-tpcte NE gc_tpcte-complemento_de_valores AND is_gko_header-tpcte NE gc_tpcte-substituto ).
*      rv_evento = 'COCKPIT'.
*      RETURN.
*    ENDIF.

    IF is_gko_header-tpevento EQ 'NORMAL' AND is_gko_header-tpcte EQ gc_tpcte-normal.
      rv_evento = 'COCKPIT'.
      RETURN.
    ENDIF.

    SELECT SINGLE tp_custo_tm
      FROM zttm_pcockpit014
      INTO rv_evento
      WHERE evento_extra EQ is_gko_header-tpevento.

    IF sy-subrc NE 0.
      CLEAR rv_evento.
    ENDIF.

    "Se houver algum caractere no campo evento e não for encontrado na tabela de eventos extras, considera o tipo de custo VAZIO.
    IF rv_evento IS INITIAL.
      rv_evento = 'VAZIO'.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD extra_charge_and_step.

* ---------------------------------------------------------------------------
* Processo para criação do custo extra
* ---------------------------------------------------------------------------
    IF gs_gko_header-codstatus EQ gc_codstatus-calculo_custo_efetuado.
      me->extra_charge_v2( ).
    ENDIF.

* ---------------------------------------------------------------------------
* Processo para faturamento da ordem de frete
* ---------------------------------------------------------------------------
    IF gs_gko_header-codstatus EQ gc_codstatus-calculo_custo_efetuado.
      me->faturar_etapa_v2( ).
    ENDIF.

  ENDMETHOD.


  METHOD release_charge_step.

    " Tabelas
    DATA: lt_tor_root        TYPE /scmtms/t_tor_root_k,
          lt_stage           TYPE /scmtms/t_tor_stage,
          lt_tor_root_keys   TYPE /bobf/t_frw_key,
          lt_sfir_item       TYPE /scmtms/t_sfir_item_k,
          lt_sfir_root       TYPE /scmtms/t_sfir_root_k,
          lt_post_sfir       TYPE /bobf/t_frw_key,
          lt_sfir_keys       TYPE /bobf/t_frw_key,
          lt_sfir_keys_final TYPE /bobf/t_frw_key,
          lt_tor_for_charges TYPE /scmtms/t_tor_q_chargedata,
          lr_params          TYPE REF TO /scmtms/s_sfir_input_params,
          lr_param_sfir      TYPE REF TO /scmtms/s_sfir_a_post_docs,
          lt_return          TYPE bapiret2_tab,
          lt_bal_message     TYPE /bofu/t_bal_message_k,
          lt_dd07v           TYPE TABLE OF dd07v,
          lt_mod             TYPE /bobf/t_frw_modification,
          lt_changed         TYPE /bobf/t_frw_name,
          lt_loc_id_key      TYPE STANDARD TABLE OF zi_tm_vh_location_id,
          lv_zz1_cond        TYPE Char2.

    " Estruturas
    DATA: ls_ctx      TYPE /scmtms/cl_tcc_do_helper=>ts_ctx.

    " Variáveis
    DATA: lv_tor_key      TYPE /bobf/conf_key,
          lv_cons_invoice TYPE /scmtms/cons_invoice.

    " Instancias
    DATA(lr_txm)             = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    DATA(lo_sfir_sett_index) = /scmtms/cl_sfir_sett_ind_help=>get_instance( ).
    DATA(lo_srvmgr_tor)      = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_srvmgr_sfir)     = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key ).

    FREE: et_return.

    " Buscar TOR Key
    lv_tor_key = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = is_gko_header-tor_id ).

    " Busca TOR Data
    CALL METHOD /scmtms/cl_tor_helper_common=>get_tor_data
      EXPORTING
        it_root_key = VALUE #( ( key = lv_tor_key ) )
      IMPORTING
        et_root     = lt_tor_root.

    CHECK lt_tor_root[] IS NOT INITIAL.

* Condição de expedição - determina se é OF Cross/'Mãe'

    lv_zz1_cond = lt_tor_root[ 1 ]-zz1_cond_exped.

* Determinar direção do transporte - inbound ou outbound

    CALL METHOD /scmtms/cl_tor_helper_stop=>get_stops_for_root
      EXPORTING
        it_root_keys     = VALUE #( ( key = lv_tor_key ) )
      IMPORTING
        et_stop          = DATA(lt_stops)
        et_outbound_stop = DATA(lt_out_stops)
        et_inbound_stop  = DATA(lt_inb_stops).

    LOOP AT lt_out_stops TRANSPORTING NO FIELDS WHERE wh_next_rel = 'L' AND stop_seq_pos = 'F'.
      DATA(lv_outbound) = abap_true.
    ENDLOOP.

    LOOP AT lt_inb_stops TRANSPORTING NO FIELDS WHERE wh_next_rel = 'U' AND stop_seq_pos = 'L'.
      DATA(lv_inbound) = abap_true.
    ENDLOOP.


    TRY.
        lo_srvmgr_tor->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-qdb_for_charges " Query
            it_filter_key           = VALUE #( ( key = lv_tor_key ) )                 " Key Table
            iv_fill_data            = abap_true                                       " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_tor_for_charges ).
      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    " Busca Stage
    /scmtms/cl_tor_helper_stage=>get_stage(
      EXPORTING
        it_root_key            =   VALUE #( ( key = lv_tor_key ) )
      IMPORTING
        et_stage               =   lt_stage ).

    " Prepara Settlement
    CALL METHOD lo_sfir_sett_index->/scmtms/if_sfir_sett_ind_help~prepare_settlement_index
      EXPORTING
        iv_inv_creation_method = lv_cons_invoice                                  " Invoice Creation Method
        it_tor_key             = VALUE #( ( key = lv_tor_key ) )                  " Key
        it_tor_q_data          = lt_tor_for_charges.                              " Key Table

    " Busca Settlement
    CALL METHOD lo_sfir_sett_index->/scmtms/if_sfir_sett_ind_help~execute_packaging
      EXPORTING
        iv_package_size     = '100'                                               " package size
        iv_soft_split       = '0'                                                 " adjust package dynamically
      IMPORTING
        et_tor_root_keys    = lt_tor_root_keys                                    " NodeID
        et_settlement_index = DATA(lt_settlement_index).                          " Settlement Index structure for FSD creation

    ls_ctx-host_bo_key        = /scmtms/if_tor_c=>sc_bo_key.
    ls_ctx-host_root_node_key = /scmtms/if_tor_c=>sc_node-root.
    ls_ctx-host_node_key      = /scmtms/if_tor_c=>sc_node-transportcharges.

    /scmtms/cl_tcc_do_helper=>retrive_do_nodes( EXPORTING is_ctx            = ls_ctx
                                                          it_root_key       = VALUE #( ( key = lv_tor_key ) )
                                                IMPORTING et_charge_item    = DATA(lt_items)
                                                          et_do_root        = DATA(lt_root)
                                                          et_charge_element = DATA(lt_elements) ).

    " Recupera a Unidade Gerencial
    IF is_gko_header-dest_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-dest_cod ) ).
    ENDIF.
    IF is_gko_header-receb_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-receb_cod ) ).
    ENDIF.
    IF is_gko_header-rem_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-rem_cod ) ).
    ENDIF.
    IF is_gko_header-exped_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-exped_cod ) ).
    ENDIF.

    IF lt_loc_id_key[] IS NOT INITIAL.

      SELECT locationid, partner
          FROM zi_tm_vh_location_id
          FOR ALL ENTRIES IN @lt_loc_id_key
          WHERE partner = @lt_loc_id_key-partner
          INTO TABLE @DATA(lt_loc_id).

      IF sy-subrc EQ 0.
        SORT lt_loc_id BY partner.
      ENDIF.
    ENDIF.

    LOOP AT lt_stage ASSIGNING FIELD-SYMBOL(<fs_stage>).

      " Valida Destinatário /Recebedor da Mercadoria
      IF ( <fs_stage>-dest_stop-log_locid     EQ is_gko_header-dest_cod
         AND lv_outbound EQ abap_true )

        OR ( <fs_stage>-dest_stop-log_locid   EQ is_gko_header-receb_cod
        AND lv_outbound EQ abap_true )
        " Valida Remetente/ Expedidor
        OR ( <fs_stage>-source_stop-log_locid EQ is_gko_header-rem_cod
        AND lv_inbound EQ abap_true )

        OR ( <fs_stage>-source_stop-log_locid EQ is_gko_header-exped_cod
        AND lv_inbound EQ abap_true )

        " Valida se é OF Cross- Se sim, pega a key da primeira etapa.
        OR lv_zz1_cond EQ '04'.

        " Valida se cenário é igual a 04(Venda Cliente (CD - Cliente))
*        OR is_gko_header-cenario EQ gc_cenario-venda_cliente.

        IF line_exists( lt_items[ host_key = <fs_stage>-stage_key ] ).
          IF lt_items[ host_key = <fs_stage>-stage_key ]-amount IS INITIAL.
            DELETE lt_settlement_index WHERE host_key = <fs_stage>-stage_key.
            CONTINUE.
          ENDIF.
        ENDIF.

        IF line_exists( lt_settlement_index[ host_key = <fs_stage>-stage_key ] ).
          DELETE lt_settlement_index WHERE host_key <> <fs_stage>-stage_key.
          DATA(lv_stage_key) = <fs_stage>-stage_key.
          EXIT.
        ENDIF.

      ELSE.
        DELETE lt_settlement_index WHERE host_key = <fs_stage>-stage_key.
      ENDIF.
    ENDLOOP.

*  CHECK lt_settlement_index[] IS NOT INITIAL.

    CREATE DATA lr_params.
    lr_params->sfir_settlement_index = lt_settlement_index.
    lr_params->inv_category = /scmtms/if_sfir_c=>sc_category-sfir.
    lr_params->inv_dt = sy-datum.

    " -----------------------------------------------------------------------
    " 1. Verifica se existe uma DFF criada em aberto
    " -----------------------------------------------------------------------
    FREE: lo_srvmgr_tor.
    lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    lo_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key             = /scmtms/if_tor_c=>sc_node-root
        it_key                  = VALUE #( ( key = lv_tor_key ) )
        iv_association          = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root
        iv_fill_data            = abap_true
        iv_edit_mode            = /bobf/if_conf_c=>sc_edit_exclusive                 " Lock     " INSERT - JWSILVA - 31.03.2023
      IMPORTING
        et_data                 = lt_sfir_root ).

    DELETE lt_sfir_root WHERE lifecycle <> '01'  " Em processamento
                          AND lifecycle <> '02'  " Disponível para provisões
                          AND lifecycle <> '03'  " Lançado iniciado
                          AND lifecycle <> '04'. " Lançado

    " Caso exista uma chave de acesso criada, não criar DFF novo
    IF line_exists( lt_sfir_root[ zzacckey  = is_gko_header-acckey lifecycle = '04' ] ).

      RETURN.

    ELSEIF  line_exists( lt_sfir_root[ zzacckey  = is_gko_header-acckey ] ).

      DELETE lt_sfir_root WHERE zzacckey IS INITIAL.
      lt_sfir_keys = CORRESPONDING #( lt_sfir_root MAPPING key = root_key ).
      CHECK lt_sfir_keys[] IS NOT INITIAL.

    ELSE.


      " -----------------------------------------------------------------------
      " 2. Caso não exista DFF, criaremos um novo
      " -----------------------------------------------------------------------
      TRY.

          " Cria SFIR
          lo_srvmgr_tor->do_action(
            EXPORTING
              iv_act_key           = /scmtms/if_tor_c=>sc_action-root-create_sfir
              it_key               = VALUE #( ( key = lv_tor_key ) )
              is_parameters        = lr_params
            IMPORTING
              eo_change            = DATA(lo_change)
              eo_message           = DATA(lo_msg) ).

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
          me->get_message( EXPORTING io_message = lo_msg
                           CHANGING  ct_return  = et_return ).

          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          RETURN.
      ENDTRY.

      " -----------------------------------------------------------------------
      " 2.1. Recupera o DFF novo criado
      " -----------------------------------------------------------------------
      TRY.

          DO 30 TIMES.
            lo_srvmgr_tor->retrieve_by_association(
                EXPORTING
                  iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
                  it_key                  = VALUE #( ( key = lv_tor_key ) )                    " Key Table
                  iv_association          = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root " Association
                  iv_fill_data            = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                IMPORTING
                  et_data                 = lt_sfir_root ).

* BEGIN OF INSERT - JWSILVA - 24.03.2023
            DELETE lt_sfir_root WHERE zzacckey IS NOT INITIAL. " Somente considerar o registro novo
* END OF INSERT - JWSILVA - 24.03.2023
            DELETE lt_sfir_root WHERE lifecycle <> '02'  " Ready for Accurals
                                  AND lifecycle <> '01'. " In Process

            IF lt_sfir_root[] IS NOT INITIAL.
              EXIT.
            ELSE.
              WAIT UP TO 2 SECONDS.
            ENDIF.
          ENDDO.

        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          RETURN.
      ENDTRY.

      lt_sfir_keys = CORRESPONDING #( lt_sfir_root MAPPING key = root_key ).
      CHECK lt_sfir_keys[] IS NOT INITIAL.

      " -----------------------------------------------------------------------
      " 2.2. Atualiza DFF novo com a chave de acesso
      " -----------------------------------------------------------------------
      LOOP AT lt_sfir_root ASSIGNING FIELD-SYMBOL(<fs_sfir_acckey>).
        <fs_sfir_acckey>-zzacckey = is_gko_header-acckey.
      ENDLOOP.

      CLEAR: lt_changed[].
      APPEND: 'ZZACCKEY' TO lt_changed.

      /scmtms/cl_mod_helper=>mod_update_multi(  EXPORTING it_data           = lt_sfir_root
                                                          iv_bo_key         = /scmtms/if_suppfreightinvreq_c=>sc_bo_key
                                                          iv_node           = /scmtms/if_suppfreightinvreq_c=>sc_node-root
                                                          it_changed_fields = lt_changed
                                                 CHANGING ct_mod            = lt_mod ).

      TRY.

          lo_srvmgr_sfir->modify( EXPORTING it_modification = lt_mod                 " Changes
                                  IMPORTING eo_message      = lo_msg ).              " Interface of Message Object

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
          me->get_message( EXPORTING io_message = lo_msg
                           CHANGING  ct_return  = et_return ).

          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

          " Desbloqueia chave de acesso do cockpit de frete
          TRY.
              me->persist( ).
              me->dequeue_acckey( ).
            CATCH cx_root.
          ENDTRY.

          " -----------------------------------------------------------------------
          " Persiste as alterações
          " -----------------------------------------------------------------------
          lr_txm->save( IMPORTING ev_rejected = DATA(lv_rejected)                    " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                                  eo_message  = lo_msg ).                            " Interface of Message Object

          " Bloqueia chave de acesso do cockpit de frete
          TRY.
              me->enqueue_acckey( gv_locked_in_tab ).
            CATCH cx_root.
          ENDTRY.

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
          me->get_message( EXPORTING io_message = lo_msg
                           CHANGING  ct_return  = et_return ).

          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

          DO 3 TIMES.
            WAIT UP TO 2 SECONDS.
          ENDDO.

        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          RETURN.
      ENDTRY.

    ENDIF.

    " -----------------------------------------------------------------------
    " 3. Continua com o processamento da DFF antiga (1.) ou nova (2.)
    " -----------------------------------------------------------------------
    TRY.

        CALL METHOD lo_srvmgr_sfir->do_action
          EXPORTING
            iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-calc_transport_charges
            it_key        = lt_sfir_keys
          IMPORTING
            eo_message    = lo_msg
            et_failed_key = DATA(lt_failed_key).

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
        me->get_message( EXPORTING io_message = lo_msg
                         CHANGING  ct_return  = et_return ).

        IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
          RETURN.
        ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

        DO 3 TIMES.
          WAIT UP TO 2 SECONDS.
        ENDDO.

        "Call to Static method of SFIR BO
        CALL METHOD lo_srvmgr_sfir->do_action
          EXPORTING
            iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-set_transferred_for_accruals
            it_key        = lt_sfir_keys
          IMPORTING
            eo_message    = lo_msg
            et_failed_key = lt_failed_key.

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
        me->get_message( EXPORTING io_message = lo_msg
                         CHANGING  ct_return  = et_return ).

        IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
          RETURN.
        ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

        lr_txm->save( IMPORTING ev_rejected = lv_rejected                " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                                eo_message  = lo_msg                  ). " Interface of Message Object

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
        me->get_message( EXPORTING io_message = lo_msg
                         CHANGING  ct_return  = et_return ).

        IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
          RETURN.
        ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

        DO 3 TIMES.
          WAIT UP TO 2 SECONDS.
        ENDDO.

* Verifica se a DFF teve algum problema na criação, se houve, ao tentar reprocessar pelo cockpit, o programa irá tentar novamente criar a ABD, do contrário, a ABD será criada
*   automaticamente seguindo o fluxo e chamada standard.
        IF line_exists( lt_sfir_root[ confirmation = '13' ] ).
          DATA(lv_check_create_po) = abap_true.
        ELSE.
          lv_check_create_po = abap_false.
        ENDIF.

        DATA(lo_post_sfir) = /scmtms/cl_post_sfir_for_accru=>get_instance( ).
        lo_post_sfir->/scmtms/if_post_sfir_for_accru~post_sfir_for_accurals(
          EXPORTING
            it_sfir_keys   = lt_sfir_keys                                       " Key Table
            iv_save        = abap_true
            iv_create_po   = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
            iv_create_ab   = lv_check_create_po
            IMPORTING
            eo_message     = DATA(lo_msg_sfir)                                  " Interface of Message Object
            et_return      = DATA(lt_return_sfir) ).                            " Table with BAPI Return Information

        INSERT LINES OF lt_return_sfir INTO TABLE et_return.

* BEGIN OF CHANGE - JWSILVA - 06.04.2023
        me->get_message( EXPORTING io_message = lo_msg_sfir
                         CHANGING  ct_return  = et_return ).

        IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
          RETURN.
        ENDIF.
* END OF CHANGE - JWSILVA - 06.04.2023

        DO 3 TIMES.
          WAIT UP TO 2 SECONDS.
        ENDDO.

        CLEAR: lt_sfir_root[].
        lo_srvmgr_sfir->retrieve(
          EXPORTING
            iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root                                   " Node
            it_key                  = lt_sfir_keys                                   " Key Table
          IMPORTING
            et_data                 = lt_sfir_root ).

        IF NOT line_exists( lt_sfir_root[ confirmation = '03' ] ) .

          CALL FUNCTION 'DD_DOMVALUES_GET'
            EXPORTING
              domname        = '/SCMTMS/SFIR_CONFIRM_STATUS'
              text           = abap_true
              langu          = sy-langu
            TABLES
              dd07v_tab      = lt_dd07v
            EXCEPTIONS
              wrong_textflag = 1
              OTHERS         = 2.

          IF sy-subrc = 0.
            DATA(ls_sfir_root) = lt_sfir_root[ 1 ].
            IF line_exists( lt_dd07v[ domvalue_l = ls_sfir_root-confirmation ] ).
              APPEND INITIAL LINE TO et_return ASSIGNING FIELD-SYMBOL(<fs_return>).
              <fs_return>-type       = if_xo_const_message=>error.
              <fs_return>-id         = '00'.
              <fs_return>-number     = '208'.
              <fs_return>-message_v1 = lt_dd07v[ domvalue_l = ls_sfir_root-confirmation ]-ddtext.
*            RETURN.
            ENDIF.
          ENDIF.

          lo_srvmgr_sfir->retrieve_by_association(
            EXPORTING
                iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root                                   " Node
                it_key                  = lt_sfir_keys                                   " Key Table
                iv_association          = /scmtms/if_suppfreightinvreq_c=>sc_association-root-latest_app_log_messages                                   " Association
                iv_fill_data            = abap_true                         " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
            IMPORTING
                et_data                 = lt_bal_message ).

          LOOP AT lt_bal_message ASSIGNING FIELD-SYMBOL(<fs_bal_message>).
            APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
            <fs_return>-type       = <fs_bal_message>-msgty.
            <fs_return>-id         = <fs_bal_message>-msgid.
            <fs_return>-number     = <fs_bal_message>-msgno.
            <fs_return>-message_v1 = <fs_bal_message>-msgv1.
            <fs_return>-message_v2 = <fs_bal_message>-msgv2.
            <fs_return>-message_v3 = <fs_bal_message>-msgv3.
            <fs_return>-message_v4 = <fs_bal_message>-msgv4.
          ENDLOOP.
        ENDIF.

*      WAIT UP TO 20 SECONDS.
*
*      lo_post_sfir->/scmtms/if_post_sfir_for_accru~post_sfir_for_accurals(
*        EXPORTING
*          it_sfir_keys   = lt_sfir_keys                                       " Key Table
*          iv_save        = abap_true
*          iv_create_ab   = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
**          iv_create_ses  = abap_true
*        IMPORTING
*          eo_message     = lo_msg_sfir                                        " Interface of Message Object
*          et_return      = lt_return_sfir ).                                  " Table with BAPI Return Information

*      set_status( iv_status   = gc_codstatus-frete_faturado ).

*      CALL METHOD lo_srvmgr_sfir->do_action
*        EXPORTING
*          iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-set_confirmed_from_erp
*          it_key        = lt_sfir_keys
*        IMPORTING
*          eo_message    = lo_msg
*          et_failed_key = lt_failed_key.
*
*      lr_txm->save( IMPORTING ev_rejected = lv_rejected                " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*                              eo_message  = lo_msg                  ). " Interface of Message Object

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    lr_txm->cleanup( ).

  ENDMETHOD.


  METHOD faturar_etapa_v2.

** ---------------------------------------------------------------------------
** Verifica se foi feito o cálculo de custo
** ---------------------------------------------------------------------------
** Determinado na classe ZCLTM_TCC_RULES->/scmtms/if_tcc_rules~charge_calc_through_formula
** ---------------------------------------------------------------------------
*    DATA(lv_success) = me->faturar_etapa_valid_calc_custo( iv_torid = gs_gko_header-tor_id ).
*    CHECK lv_success EQ abap_true.

*    TRY.
*        me->persist( ).
*        me->dequeue_acckey( ).
*      CATCH cx_root.
*    ENDTRY.

* ---------------------------------------------------------------------------
* Inicia processo de documento de faturamente de frete (DFF)
* ---------------------------------------------------------------------------
    DATA(lv_dest_cod) = gs_gko_header-dest_cod.
    DATA(lv_rem_cod) = gs_gko_header-rem_cod.

* ---------------------------------------------------------------------------
* Recupera o último contador
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_gko_logs) = gt_gko_logs.
        SORT lt_gko_logs BY counter DESCENDING.
        DATA(lv_counter) = lt_gko_logs[ 1 ]-counter.
      CATCH cx_root.
        CLEAR lv_counter.
    ENDTRY.


    me->release_charge_step( EXPORTING is_gko_header = gs_gko_header
                             IMPORTING et_return     = DATA(lt_return) ).

    " Remove linha de log 'Lançamento FRS iniciado' do tipo erro
    DELETE lt_return WHERE type       = 'E'
                       AND id         = '00'
                       AND number     = '208'
                       AND message_v1 = 'Lançamento FRS iniciado'.

    TRY.
*        me->enqueue_acckey( gv_locked_in_tab ).
        gv_min_data_load = abap_false.
        me->load_data_from_acckey( ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Separa as mensagens de logs que foram salvos durante etapa de fatura
* ---------------------------------------------------------------------------
    DATA(lt_gko_logs_new) = gt_gko_logs.
    DELETE lt_gko_logs_new WHERE counter <= lv_counter.
    DELETE gt_gko_logs WHERE counter > lv_counter.

    " Caso a mensagem for um erro, atualizar com erro as próximas linhas
    LOOP AT lt_gko_logs_new INTO DATA(ls_gko_logs). "#EC CI_LOOP_INTO_WA
      CHECK ls_gko_logs-codstatus+0(1) = 'E'.
      EXIT.
    ENDLOOP.

    IF ls_gko_logs-codstatus+0(1) = 'E'.
      LOOP AT lt_return REFERENCE INTO DATA(ls_return).
        ls_return->type = 'E'.
      ENDLOOP.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica mensagens de retorno
* ---------------------------------------------------------------------------
    IF line_exists( lt_return[ id = '/SCMTMS/MSG' number = '252' ] )
    OR line_exists( lt_return[ id = '/SCMTMS/MSG' number = '253' ] ).

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-bloqueio_usuario_faturam_frete
                                it_bapi_ret = lt_return ).

    ELSEIF NOT line_exists( lt_return[ type = 'E' ] ).

      me->set_status( EXPORTING iv_status = COND #( WHEN gs_gko_header-codstatus = zcltm_gko_process=>gc_codstatus-frete_faturado
                                                    THEN zcltm_gko_process=>gc_codstatus-frete_faturado
                                                    ELSE zcltm_gko_process=>gc_codstatus-aguardando_faturamento_frete ) ).

    ELSE.

      DELETE ADJACENT DUPLICATES FROM lt_return COMPARING id number message_v1 message_v2 message_v3 message_v4.

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_fat_frete
                                it_bapi_ret = lt_return ).

    ENDIF.

* ---------------------------------------------------------------------------
* Salva as mensages da funcão no final da lista
* ---------------------------------------------------------------------------
    TRY.
        lt_gko_logs = gt_gko_logs.
        SORT lt_gko_logs BY counter DESCENDING.
        lv_counter = lt_gko_logs[ 1 ]-counter.
      CATCH cx_root.
        CLEAR lv_counter.
    ENDTRY.

    LOOP AT lt_gko_logs_new REFERENCE INTO DATA(ls_gko_logs_new).
      ls_gko_logs_new->codstatus = gs_gko_header-codstatus.
      ls_gko_logs_new->counter   = lv_counter = lv_counter + 1.
      ls_gko_logs_new->credat    = sy-datum.
      ls_gko_logs_new->cretim    = sy-uzeit.
      ls_gko_logs_new->crenam    = sy-uname.
    ENDLOOP.

    INSERT LINES OF lt_gko_logs_new INTO TABLE gt_gko_logs.

  ENDMETHOD.


  METHOD extra_charge_v2.

    DATA(lv_evento) = me->determine_charge( is_gko_header = gs_gko_header ).

    DATA(lt_return) = NEW zcltm_eventos_extras( )->executar( EXPORTING iv_cod_evento = lv_evento
                                                                       is_gko_header = gs_gko_header
                                                                       iv_commit     = abap_false ).

    IF line_exists( lt_return[ id = '/SCMTMS/MSG' number = '252' ] )
    OR line_exists( lt_return[ id = '/SCMTMS/MSG' number = '253' ] ).

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-bloqueio_usuario_criacao_custo
                                it_bapi_ret = lt_return ).

    ELSEIF line_exists( lt_return[ type = 'E' ] ).

      me->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_calc_cust_extra
                                it_bapi_ret = lt_return ).

    ELSEIF line_exists( lt_return[ type = 'W' ] ).

      me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-calculo_custo_efetuado
                                it_bapi_ret = lt_return ).

    ELSE.

      me->set_status( EXPORTING iv_status = zcltm_gko_process=>gc_codstatus-calculo_custo_efetuado ).

    ENDIF.

  ENDMETHOD.


  METHOD get_partner.

    FREE: ev_partner.

* ---------------------------------------------------------------------------
* Recupera parceiro utilizando CNPJ
* ---------------------------------------------------------------------------
    IF iv_cnpj IS NOT INITIAL.

      SELECT Parceiro, Nome, cnpj, cpf, InscricaoEstadual, InscricaoMunicipal
        FROM zi_ca_vh_partner
        WHERE cnpj EQ @iv_cnpj
        INTO TABLE @DATA(lt_parceiro).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera parceiro utilizando CPF
* ---------------------------------------------------------------------------
    IF iv_cpf IS NOT INITIAL.

      SELECT Parceiro, Nome, cnpj, cpf, InscricaoEstadual, InscricaoMunicipal
        FROM zi_ca_vh_partner
        WHERE cpf EQ @iv_cpf
        APPENDING TABLE @lt_parceiro.

    ENDIF.

    IF sy-subrc EQ 0.
      SORT lt_parceiro BY InscricaoEstadual.
    ENDIF.

* ---------------------------------------------------------------------------
* Devolver parceiro comparando a inscrição estadual
* ---------------------------------------------------------------------------
    IF iv_ie IS NOT INITIAL.

      READ TABLE lt_parceiro REFERENCE INTO DATA(ls_parceiro) WITH KEY InscricaoEstadual = iv_ie BINARY SEARCH.

      IF sy-subrc EQ 0.
        ev_partner = ls_parceiro->Parceiro.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Devolver primeiro parceiro encontrado
* ---------------------------------------------------------------------------
    READ TABLE lt_parceiro REFERENCE INTO ls_parceiro INDEX 1.

    IF sy-subrc EQ 0.
      ev_partner = ls_parceiro->Parceiro.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_message.

    DATA: lt_return TYPE bapiret2_t.

    CHECK io_message IS NOT INITIAL.

    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = io_message
                                                           CHANGING  ct_bapiret2 = lt_return ).

*    LOOP AT lt_return REFERENCE INTO DATA(ls_return).
*
*      IF  ls_return->type   = 'W'
*      AND ls_return->id     = '/SCMTMS/SFIR'
*      AND ls_return->number = '028'.
*        " Forçar erro para mensagem: Montante líquido deve ser maior que 0
*        ls_return->type = 'E'.
*      ENDIF.
*
*    ENDLOOP.

    INSERT LINES OF lt_return INTO TABLE ct_return.

  ENDMETHOD.


  METHOD check_doc_memo_miro.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.

    load_gko_references( ).

    DATA(lt_gko_orig_acckey) = gt_gko_references.
    SORT lt_gko_orig_acckey BY acckey_orig.
    DELETE ADJACENT DUPLICATES FROM lt_gko_orig_acckey COMPARING acckey_orig.

    CHECK lt_gko_orig_acckey IS NOT INITIAL.

    " Verifica se a MIRO do Documento de origem, foi confirmada
    SELECT acckey
      FROM zttm_gkot001
     INNER JOIN rbkp
             ON ( rbkp~belnr = zttm_gkot001~re_belnr AND
                  rbkp~gjahr = zttm_gkot001~re_gjahr )
      INTO TABLE @DATA(lt_gko_orig_acckey_posted)
       FOR ALL ENTRIES IN @lt_gko_orig_acckey
     WHERE zttm_gkot001~acckey = @lt_gko_orig_acckey-acckey_orig
       AND rbkp~rbstat         = @gc_invoice_status-registrado.

    IF sy-subrc IS INITIAL.
      SORT lt_gko_orig_acckey_posted BY acckey.
    ENDIF.

    IF lines( lt_gko_orig_acckey ) <> lines( lt_gko_orig_acckey_posted ).

      LOOP AT lt_gko_orig_acckey ASSIGNING FIELD-SYMBOL(<fs_s_acckey_orig>).

        READ TABLE lt_gko_orig_acckey_posted TRANSPORTING NO FIELDS
                                                           WITH KEY acckey = <fs_s_acckey_orig>-acckey_orig
                                                           BINARY SEARCH.
        CHECK sy-subrc IS NOT INITIAL.

        me->add_to_log( it_bapi_ret = VALUE #( ( type       = 'E'
                                                 id         = zcxtm_gko_process=>orig_acckey_not_posted-msgid
                                                 number     = zcxtm_gko_process=>orig_acckey_not_posted-msgno
                                                 message_v1 = <fs_s_acckey_orig>-acckey_orig ) ) ).

        " A chave de origem & não possui MIRO Confirmada.
        APPEND NEW zcxtm_gko_process( textid    = zcxtm_gko_process=>orig_acckey_not_posted
                                      gv_msgv1  = CONV #( <fs_s_acckey_orig>-acckey_orig ) )
                                    TO lt_errors.

      ENDLOOP.

      RAISE EXCEPTION TYPE zcxtm_gko_process
        EXPORTING
          gt_errors = lt_errors.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
