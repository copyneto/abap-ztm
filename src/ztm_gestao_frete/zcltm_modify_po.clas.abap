class ZCLTM_MODIFY_PO definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces /SCMTMS/IF_SFIR_POSTING .

  types TY_BP_DEST type BU_PARTNER .
  types TY_BP_ORIG type BU_PARTNER .
  types:
    BEGIN OF ty_parameter,
        nftype_cte_fob TYPE RANGE OF j_1bnfdoc-nftype,
      END OF ty_parameter .

  constants GC_FRETES_DIVERSOS type ZE_GKO_CENARIO value '06' ##NO_TEXT.
  constants GC_COMPRAS type ZE_GKO_CENARIO value '07' ##NO_TEXT.
  constants GC_NFTYPE_SERVICO type J_1BNFDOC-NFTYPE value 'ZK' ##NO_TEXT.
  constants GC_PEDIDO_TM type EKKO-BSART value 'ZTM' ##NO_TEXT.
  data GV_BP_REM type BU_PARTNER .
  data GV_BP_DEST type BU_PARTNER .
  data GS_LOC_ORIGEM type /BOFU/S_ADDR_POSTAL_ADDRESSK .
  data GS_LOC_DEST type /BOFU/S_ADDR_POSTAL_ADDRESSK .
  data GV_MESSAGE type CHAR200 .

  methods BUSCA_FU_ASSIGN
    importing
      !IT_TOR_FO type /SCMTMS/T_TOR_ROOT_K
    returning
      value(RT_TOR_ASSIGN) type /SCMTMS/T_TOR_ROOT_K .
  methods DETERMINA_IVA_COMPRAS
    importing
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_PO_ITEMS type BAPIMEPOITEM_TP
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
    exporting
      !EV_IVA type MWSKZ
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP .
  methods DETERMINA_IVA_CTE
    importing
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
    exporting
      !EV_IVA type MWSKZ
    changing
      !CT_PO_ITEMS type BAPIMEPOITEM_TP optional
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP optional
      !CT_PO_SERVICES type BAPIESLLC_TP .
  methods DETERMINA_IVA_CTE_FOB
    importing
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
    exporting
      !EV_IVA type MWSKZ
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP .
  methods DETERMINA_IVA_CTE_SERVICES_01
    importing
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
      !IT_CHARGE_ELEMENT type /SCMTMS/T_TCC_TRCHRG_ELEMENT_K optional
    exporting
      !EV_IVA type MWSKZ
      !EV_SERV_DEF type CHAR1
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP .
  methods DETERMINA_IVA_CTE_SERVICES_03
    importing
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
      !IT_CHARGE_ELEMENT type /SCMTMS/T_TCC_TRCHRG_ELEMENT_K optional
      !IV_ZZACCKEY type J_1B_NFE_ACCESS_KEY_DTEL44 optional
    exporting
      !EV_IVA type MWSKZ
      !EV_SERV_DEF type CHAR1
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP .
  methods DETERMINA_IVA_CTE_CIF
    importing
      !IT_PO_ITEMS type BAPIMEPOITEM_TP
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
    exporting
      !EV_IVA type MWSKZ
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP .
  methods DETERMINA_IVA_DIVERSOS
    importing
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IV_BTD_ID type /SCMTMS/BASE_BTD_ID
      !IS_PO_HEADER type BAPIMEPOHEADER
    exporting
      !EV_IVA type MWSKZ
    changing
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP
      !CT_PO_SERVICES type BAPIESLLC_TP .
  methods DETERMINA_IVA_NFSE
    importing
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
    exporting
      !EV_IVA type MWSKZ
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP .
  methods DETERMINA_CONTA_CONTAB
    importing
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IS_SFIR_ITEM_DATA type /SCMTMS/S_SFIR_ITEM_K
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
      !IS_LOC_ORIGEM type /BOFU/S_ADDR_POSTAL_ADDRESSK optional
      !IS_LOC_DEST type /BOFU/S_ADDR_POSTAL_ADDRESSK optional
    returning
      value(RV_CONTA_CONTAB) type SAKNR .
  methods BUSCA_REFERENCIA
    importing
      !IS_TOR_FO type /SCMTMS/S_TOR_ROOT_K
    returning
      value(RT_TOR_DOCREF) type /SCMTMS/T_TOR_DOCREF_K .
  methods DETERMINA_PROD_ACABADO
    importing
      !IT_TOR_ITEM type /SCMTMS/T_TOR_ITEM_TR_K
    returning
      value(RT_PROD_ACABADO) type FLAG .
  methods DETERMINA_LOC_ORIGEM_DEST
    importing
      !IT_SFIR_ITEM_DATA type /SCMTMS/T_SFIR_ITEM_K
      !IT_STAGE_LOC_DATA type /SCMTMS/CL_SFIR_HELPER_ROOT=>TTY_STAGE_DATA
      !IT_POSTAL_ADDR type /BOFU/T_ADDR_POSTAL_ADDRESSK
      !IT_TOR_STOP type /SCMTMS/T_TOR_STOP_K
    exporting
      !ES_LOC_ORIGEM type /BOFU/S_ADDR_POSTAL_ADDRESSK
      !ES_LOC_DEST type /BOFU/S_ADDR_POSTAL_ADDRESSK .
  methods GET_ITEMS_POST
    importing
      !IT_REFERENCES type ZCLTM_GKO_PROCESS=>TY_T_ZGKOT003
      !IS_HEADER type ZTTM_GKOT001
      !IV_ACCKEY type ZTTM_GKOT001-ACCKEY
    returning
      value(RT_ITEMS_POST) type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST .
  methods DETERMINA_PARCEIRO_PEDIDO
    importing
      !IS_TOR_ROOT type /SCMTMS/S_TOR_ROOT_K
    changing
      !CT_PO_PARTNER type BAPIEKKOP_TP .
  methods DETERMINA_NCM_SERVICO
    importing
      !IT_PO_SERVICES type BAPIESLLC_TP
    changing
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP .
  methods GET_ITEMS_POST_WO_PA
    importing
      !IT_NF_SAIDA type ZCLTM_GKO_PROCESS=>TY_T_J_1BNFLIN
      !IS_HEADER type ZTTM_GKOT001
    changing
      !CT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST .
  methods GET_ITEMS_POST_OTHERS
    importing
      !IT_NF_SAIDA type ZCLTM_GKO_PROCESS=>TY_T_J_1BNFLIN
      !IS_HEADER type ZTTM_GKOT001
    changing
      !CT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST .
  methods GET_ITEMS_POST_TRANSFERENCIA
    importing
      !IT_NF_SAIDA type ZCLTM_GKO_PROCESS=>TY_T_J_1BNFLIN
      !IS_HEADER type ZTTM_GKOT001
    changing
      !CT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST .
  methods GET_ITEMS_POST_VENDA_COLIGADA
    importing
      !IT_NF_SAIDA type ZCLTM_GKO_PROCESS=>TY_T_J_1BNFLIN
      !IS_HEADER type ZTTM_GKOT001
    changing
      !CT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST .
  methods GET_IVA_DETAILED
    importing
      !IT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST
      !IS_HEADER type ZTTM_GKOT001
      !IV_SAKNR type ZTTM_PCOCKPIT013-SAKNR
    returning
      value(RT_IVA) type ZCLTM_GKO_PROCESS=>TY_T_PO_IVA_DETAILED .
  methods GET_IVA_UNIFIED
    importing
      !IT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST
      !IS_HEADER type ZTTM_GKOT001
      !IV_SAKNR type ZTTM_PCOCKPIT013-SAKNR
    returning
      value(RV_IVA) type MWSKZ .
  methods GET_IVA_FROM_INFO_RECORD
    importing
      !IT_ITEMS_POST type ZCLTM_GKO_PROCESS=>TY_T_ITEMS_POST
      !IS_HEADER type ZTTM_GKOT001
      !IV_SAKNR type ZTTM_PCOCKPIT013-SAKNR
    returning
      value(RV_IVA) type MWSKZ .
  methods TRATA_CARACTER_ESPECIAL
    importing
      !IV_TEXT type ANY
    returning
      value(RV_TEXT) type STRING .
  methods SET_LOG
    importing
      !IT_RETURN type BAPIRET2_T
      !IV_ACCKEY type J_1B_NFE_ACCESS_KEY_DTEL44 .
  methods ADD_LC_OBSERVACAO_NF_MIRO
    importing
      !IT_NFITEMS type J_1BNFLIN_TAB
      !IS_NFHEADER type J_1BNFDOC
    changing
      !CV_OBSERVACAO type J_1BNFDOC-OBSERVAT .
  methods DETERMINA_SERVICE
    importing
      !IT_CHARGE_ELEMENT type /SCMTMS/T_TCC_TRCHRG_ELEMENT_K optional
    exporting
      !EV_SERV_DEF type CHAR1
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP .
  methods ATUALIZA_PO_SERVICES
    importing
      !IT_TOR_ROOT_DATA type /SCMTMS/T_TOR_ROOT_K
      !IS_SFIR_ROOT type /SCMTMS/S_SFIR_ROOT_K
      !IT_CHARGE_ELEMENT type /SCMTMS/T_TCC_TRCHRG_ELEMENT_K
      !IV_IVA type MWSKZ
      !IV_SERV_DEF type CHAR1 optional
    changing
      !CT_PO_SERVICES type BAPIESLLC_TP
      !CT_PO_ITEMS type BAPIMEPOITEM_TP
      !CT_PO_ITEMSX type BAPIMEPOITEMX_TP .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA gs_parameter TYPE ty_parameter .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING
        !es_parameter TYPE ty_parameter
        !et_return    TYPE bapiret2_t .
    "! Recupera parâmetro na tabela de parâmetros
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING
        !is_param TYPE ztca_param_val
      EXPORTING
        !et_value TYPE any .
ENDCLASS.



CLASS ZCLTM_MODIFY_PO IMPLEMENTATION.


  METHOD /scmtms/if_sfir_posting~modify_po_creation.

    DATA: lo_post_sfir      TYPE REF TO /scmtms/cl_post_sfir_for_accru,
          lt_sfir_item_data TYPE /scmtms/t_sfir_item_k,
          lt_tor_root_data  TYPE /scmtms/t_tor_root_k,
          lt_tor_item_data  TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,
          lt_charge_element TYPE /scmtms/t_tcc_trchrg_element_k,
          lv_transport_mode TYPE /scmtms/trmodcat.

    lo_post_sfir = /scmtms/cl_post_sfir_for_accru=>get_instance( ).
    CALL METHOD lo_post_sfir->get_data
      IMPORTING
        et_sfir_root_data = DATA(lt_sfir_root_data)
        et_sfir_item_data = lt_sfir_item_data
        et_charge_element = lt_charge_element
        et_tor_root_data  = lt_tor_root_data
        et_tor_stop       = DATA(lt_tor_stop)
        et_location_data  = DATA(lt_location_data)
        et_tor_item_data  = DATA(lt_tor_item)
        et_postal_addr    = DATA(lt_postal_addr)
        et_stage_loc_data = DATA(lt_stage_loc_data).

    IF lt_tor_item[] IS INITIAL.
      TRY.
          /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
            EXPORTING
              iv_node_key    = /scmtms/if_tor_c=>sc_node-root                        " Node
              it_key         = CORRESPONDING #( lt_tor_root_data MAPPING key = key ) " Key Table
              iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr         " Association
              iv_fill_data   = abap_true                                             " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
            IMPORTING
              et_data        = lt_tor_item ).
        CATCH /bobf/cx_frw_contrct_violation.                                        " Caller violates a BOPF contract
          RETURN.
      ENDTRY.
    ENDIF.

    lt_tor_item_data = lt_tor_item.
    SORT lt_tor_item_data BY root_key.

    READ TABLE lt_sfir_item_data ASSIGNING FIELD-SYMBOL(<ls_sfir_item>) WITH KEY parent_key COMPONENTS parent_key = iv_sfir_key.
    IF sy-subrc = 0.
      READ TABLE lt_tor_root_data ASSIGNING FIELD-SYMBOL(<ls_tor_root>) WITH TABLE KEY key = <ls_sfir_item>-tor_root_key.
      IF sy-subrc = 0.
        lv_transport_mode = <ls_tor_root>-trmodcat.
      ENDIF.
    ENDIF.

    READ TABLE lt_sfir_root_data ASSIGNING FIELD-SYMBOL(<fs_sfir_root>) WITH KEY key COMPONENTS key = iv_sfir_key.
    CHECK sy-subrc IS INITIAL.

    READ TABLE lt_sfir_item_data ASSIGNING FIELD-SYMBOL(<fs_sfir_item>) WITH KEY parent_key COMPONENTS parent_key = iv_sfir_key.
    CHECK sy-subrc IS INITIAL.

    READ TABLE lt_tor_root_data  ASSIGNING FIELD-SYMBOL(<fs_tor_root>)  WITH TABLE KEY key = <fs_sfir_item>-tor_root_key.
    CHECK sy-subrc IS INITIAL.

    READ TABLE lt_tor_item_data  ASSIGNING FIELD-SYMBOL(<fs_tor_item>)  WITH KEY root_key = <fs_tor_root>-key BINARY SEARCH.
    CHECK sy-subrc IS INITIAL.

    DATA(lt_tor_assign) = busca_fu_assign( lt_tor_root_data ).

    lv_transport_mode = <fs_tor_root>-trmodcat.

    IF lt_tor_assign IS NOT INITIAL.
      DATA(lv_btd_id) = lt_tor_assign[ 1 ]-base_btd_id.
    ENDIF.

    <ls_tor_root>-tor_id = |{ <ls_tor_root>-tor_id ALPHA = OUT }|.

    " Determina Local de Expedição Origem/Destino
    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = lt_sfir_item_data   " Main Area: SFIR Item
        it_stage_loc_data = lt_stage_loc_data   " Stages
        it_postal_addr    = lt_postal_addr      " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
        it_tor_stop       = lt_tor_stop
      IMPORTING
        es_loc_origem     = gs_loc_origem " Node structure for postal address data - internal
        es_loc_dest       = gs_loc_dest )." Node structure for postal address data - internal

    " Determina os parceiros de Origem e Destino
    IF line_exists( lt_location_data[ location_uuid = gs_loc_origem-root_key ] ).
      gv_bp_rem = lt_location_data[ location_uuid = gs_loc_origem-root_key ]-business_partner_id.
    ENDIF.

    IF line_exists( lt_location_data[ location_uuid = gs_loc_dest-root_key ] ).
      gv_bp_dest = lt_location_data[ location_uuid = gs_loc_dest-root_key ]-business_partner_id.
    ENDIF.

    " Determinar parceiro do pedido
    me->determina_parceiro_pedido(
      EXPORTING
        is_tor_root = <fs_tor_root>
      CHANGING
        ct_po_partner = ct_po_partner
    ).

    " Determinar NCM
    me->determina_ncm_servico(
      EXPORTING
        it_po_services = ct_po_services
      CHANGING
        ct_po_items    = ct_po_items
        ct_po_itemsx   = ct_po_itemsx
    ).

* BEGIN OF CHANGE - JWSILVA - 03.04.2023
    " Utilizar IVA caso este tenha sido informado no Documento de Faturamente de Frete (DFF)
    DATA(lv_iva) = <fs_sfir_root>-zzmwskz.

    " Determina o IVA
    IF lv_iva IS INITIAL.
      determina_iva_nfse(       EXPORTING is_sfir_root      = <fs_sfir_root>
                                          it_sfir_item_data = lt_sfir_item_data " Main Area: SFIR Item
                                          it_stage_loc_data = lt_stage_loc_data " Stage
                                          it_postal_addr    = lt_postal_addr    " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
                                          it_tor_stop       = lt_tor_stop
                                          is_tor_root       = <fs_tor_root>     " Transportation Order Root Node Structure
                                IMPORTING ev_iva            = lv_iva
                                CHANGING  ct_po_services    = ct_po_services    " Tipo de tabela para BAPIESLLC
                                          ct_po_items       = ct_po_items       " Transportation Order Root Node Structure
                                          ct_po_itemsx      = ct_po_itemsx   ). " Tipo de tabela para BAPIMEPOITEMX
    ENDIF.
* END OF CHANGE - JWSILVA - 03.04.2023

    IF lv_iva IS INITIAL.
      determina_iva_compras(  EXPORTING is_sfir_root      = <fs_sfir_root>
                                        is_po_header      = cs_po_header      " Tipo de tabela para BAPIMEPOITEM
                                        it_po_items       = ct_po_items       " Transportation Order Root Node Structure
                                        it_tor_item       = lt_tor_item       " Transportation Order Item
                                        is_tor_root       = <fs_tor_root>     " Documento de transação comercial básico
                                        iv_btd_id         = lv_btd_id         " Pedido dds.cabeçalho
                              IMPORTING ev_iva            = lv_iva
                               CHANGING ct_po_services    = ct_po_services ). " Tipo de tabela para BAPIESLLC
    ENDIF.

    IF lv_iva IS INITIAL.
      determina_iva_cte(      EXPORTING is_po_header      = cs_po_header      " Tipo de tabela para BAPIMEPOITEM
                                        it_tor_item       = lt_tor_item       " Transportation Order Item
                                        it_tor_stop       = lt_tor_stop
                                        is_sfir_root      = <fs_sfir_root>
                                        it_sfir_item_data = lt_sfir_item_data " Main Area: SFIR Item
                                        it_stage_loc_data = lt_stage_loc_data " Stage
                                        it_postal_addr    = lt_postal_addr    " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
                                        is_tor_root       = <fs_tor_root>     " Documento de transação comercial básico
                                        iv_btd_id         = lv_btd_id         " Tipo de tabela para BAPIESLLC
                              IMPORTING ev_iva            = lv_iva
                               CHANGING ct_po_items       = ct_po_items       " Transportation Order Root Node Structure
                                        ct_po_itemsx      = ct_po_itemsx      " Tipo de tabela para BAPIMEPOITEMX
                                        ct_po_services    = ct_po_services ). " Pedido dds.cabeçalho
    ENDIF.

    IF lv_iva IS INITIAL.
      determina_iva_diversos( EXPORTING is_po_header      = cs_po_header      " Tipo de tabela para BAPIMEPOITEM
                                        it_tor_item       = lt_tor_item       " Transportation Order Item
                                        is_sfir_root      = <fs_sfir_root>
                                        is_tor_root       = <fs_tor_root>     " Documento de transação comercial básico
                                        iv_btd_id         = lv_btd_id         " Pedido dds.cabeçalho
                              IMPORTING ev_iva            = lv_iva
                               CHANGING ct_po_items       = ct_po_items       " Transportation Order Root Node Structure
                                        ct_po_itemsx      = ct_po_itemsx      " Tipo de tabela para BAPIMEPOITEMX
                                        ct_po_services    = ct_po_services ). " Tipo de tabela para BAPIESLLC
    ENDIF.

    IF lv_iva IS INITIAL.

      determina_iva_cte_services_01(
        EXPORTING
          is_tor_root       = <fs_tor_root>    " Root Node
          it_tor_item       = lt_tor_item       " Transportation Order Item
          it_tor_stop       = lt_tor_stop
          is_sfir_root      = <fs_sfir_root>
          it_sfir_item_data = lt_sfir_item_data " Main Area: SFIR Item
          it_stage_loc_data = lt_stage_loc_data " Stages
          it_postal_addr    = lt_postal_addr    " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
          iv_btd_id         = lv_btd_id         " Documento de transação comercial básico
          is_po_header      = cs_po_header      " Pedido dds.cabeçalho
          it_charge_element = lt_charge_element
        IMPORTING
          ev_iva            = lv_iva
          ev_serv_def       = DATA(lv_serv_def)
        CHANGING
          ct_po_items       = ct_po_items       " Tipo de tabela para BAPIMEPOITEM
          ct_po_itemsx      = ct_po_itemsx      " Tipo de tabela para BAPIMEPOITEMX
          ct_po_services    = ct_po_services ). " Tipo de tabela para BAPIESLLC


    ENDIF.

    IF lv_iva IS INITIAL.

      determina_iva_cte_services_03(
        EXPORTING
          is_tor_root       = <fs_tor_root>    " Root Node
          it_tor_item       = lt_tor_item       " Transportation Order Item
          it_tor_stop       = lt_tor_stop
          is_sfir_root      = <fs_sfir_root>
          it_sfir_item_data = lt_sfir_item_data " Main Area: SFIR Item
          it_stage_loc_data = lt_stage_loc_data " Stages
          it_postal_addr    = lt_postal_addr    " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
          iv_btd_id         = lv_btd_id         " Documento de transação comercial básico
          is_po_header      = cs_po_header      " Pedido dds.cabeçalho
          it_charge_element = lt_charge_element
        IMPORTING
          ev_iva            = lv_iva
          ev_serv_def       = lv_serv_def
        CHANGING
          ct_po_items       = ct_po_items       " Tipo de tabela para BAPIMEPOITEM
          ct_po_itemsx      = ct_po_itemsx      " Tipo de tabela para BAPIMEPOITEMX
          ct_po_services    = ct_po_services ). " Tipo de tabela para BAPIESLLC


    ENDIF.

* BEGIN OF INSERT - JWSILVA - 12.04.2023
    me->atualiza_po_services( EXPORTING it_tor_root_data  = lt_tor_root_data
                                        is_sfir_root      = <fs_sfir_root>
                                        it_charge_element = lt_charge_element
                                        iv_iva            = lv_iva
                                        iv_serv_def       = lv_serv_def
                              CHANGING  ct_po_services    = ct_po_services
                                        ct_po_items       = ct_po_items
                                        ct_po_itemsx      = ct_po_itemsx   ).
* END OF INSERT - JWSILVA - 12.04.2023

    IF lv_iva IS INITIAL.
      CLEAR: gv_message.

      DATA(lv_tor_id) = CONV /scmtms/tor_id( |{ <fs_tor_root>-tor_id ALPHA = IN }| ).

      " Com a Ordem de Frete, recuperamos o incoterms da remessa de Saída
      SELECT SINGLE fluxo~of_tor_id,
                    fluxo~vbeln_vl,
                    likp~inco1
          FROM zi_tm_vh_frete_docs_nf_saida AS fluxo
          LEFT OUTER JOIN likp
              ON likp~vbeln = fluxo~vbeln_vl
          WHERE fluxo~of_tor_id EQ @lv_tor_id
            AND fluxo~vbeln_vl  IS NOT INITIAL
          INTO @DATA(ls_fluxo).

      IF sy-subrc NE 0.

        " Com a Ordem de Frete, recuperamos o incoterms da remessa de Entrada
        SELECT SINGLE fluxo~of_tor_id,
                      fluxo~vbeln_vl,
                      likp~inco1
            FROM zi_tm_vh_frete_docs_nf_entrada AS fluxo
            LEFT OUTER JOIN likp
                ON likp~vbeln = fluxo~vbeln_vl
            WHERE fluxo~of_tor_id EQ @lv_tor_id
              AND fluxo~vbeln_vl  IS NOT INITIAL
            INTO @ls_fluxo.

      ENDIF.


      " Determina Produto Acabado
      DATA(lv_prod_acabado) = determina_prod_acabado( it_tor_item = lt_tor_item ).

      IF lv_prod_acabado IS INITIAL.
        DATA(lv_prod) = CONV char20( 'NF Sem Produto Acabado' ).
      ELSE.
        lv_prod = 'Produto Acabado'.
      ENDIF.

      " Selecionar o CFOP das notas transportadas
      SELECT SINGLE cenario
        INTO @DATA(lv_cenario)
        FROM zttm_gkot001
        WHERE tor_id = @lv_tor_id
          AND acckey = @<fs_sfir_root>-zzacckey.

      CONCATENATE 'Cenário' lv_cenario           '/'
                  'Orig.'   gs_loc_origem-region '/'
                  'Dest.'   gs_loc_dest-region   '/'
                  'Inco.'   ls_fluxo-inco1       '/'
                  lv_prod
                  INTO gv_message SEPARATED BY space.

      " Falha na determinação de IVA: &1&2&3&4.
      DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                            id         = 'ZTM_GKO'
                                            number     = '138'
                                            message_v1 = gv_message+0(50)
                                            message_v2 = gv_message+50(50)
                                            message_v3 = gv_message+100(50)
                                            message_v4 = gv_message+150(50) ) ).

      set_log( EXPORTING it_return = lt_return                  " Tabela de retorno
                         iv_acckey = <fs_sfir_root>-zzacckey ). " Chave de acesso de 44 dígitos

    ENDIF.

  ENDMETHOD.


  METHOD busca_fu_assign.

    DATA:
      lt_tor_root_key TYPE /bobf/t_frw_key.

    CHECK it_tor_fo IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_tor_fo ASSIGNING FIELD-SYMBOL(<fs_tor_fu>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor_fu>-key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.


    lo_tor_mgr->retrieve_by_association(
      EXPORTING
          it_key         = lt_tor_root_key
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
          iv_fill_data   = abap_true
      IMPORTING
           et_data     = rt_tor_assign ).


  ENDMETHOD.


  METHOD determina_iva_compras.

    DATA:
      lt_tor_item_data TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,

      lv_chave         TYPE char44,
      lv_cenario       TYPE char2,
      lv_rateio        TYPE ze_tm_tprateio,
      lv_vstel         TYPE vstel,
      lv_tor_id        TYPE /scmtms/tor_id,
      lv_guid_header   TYPE /xnfe/guid_16,

      lv_icms_xml      TYPE ze_tm_icms_xml.

    DATA:
      lt_refkey  TYPE zctgtm_cargo_refkey,
      lt_gkot003 TYPE zttm_gkot003,
      lt_assign  TYPE /xnfe/nfeassign_t.

    lv_tor_id = |{ is_tor_root-tor_id ALPHA = IN }|.

    SELECT SINGLE acckey,
                  cenario,
                  picms,
                  vicms
      INTO (@lv_chave, @lv_cenario, @DATA(lv_picms), @DATA(lv_vicms))
      FROM zttm_gkot001
      WHERE tor_id = @lv_tor_id
        AND acckey = @is_sfir_root-zzacckey.

    CHECK lv_cenario = gc_compras.

    SELECT acckey_ref
      FROM zttm_gkot003
      WHERE acckey    = @lv_chave
      INTO TABLE @DATA(lt_acckey_ref).

    CHECK lt_acckey_ref IS NOT INITIAL.

    SELECT guid_header
      FROM /xnfe/innfehd
      FOR ALL ENTRIES IN @lt_acckey_ref
      WHERE nfeid = @lt_acckey_ref-acckey_ref
      INTO TABLE @DATA(lt_innfehd).           "#EC CI_ALL_FIELDS_NEEDED

    CHECK lt_innfehd IS NOT INITIAL.

    READ TABLE lt_innfehd ASSIGNING FIELD-SYMBOL(<fs_innfehd>) INDEX 1.
    lv_guid_header = <fs_innfehd>-guid_header.

    CALL FUNCTION '/XNFE/B2BNFE_READ'
      EXPORTING
        iv_guid_header     = lv_guid_header
      IMPORTING
        et_assign          = lt_assign
      EXCEPTIONS
        nfe_does_not_exist = 1
        nfe_locked         = 2
        technical_error    = 3
        OTHERS             = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
    ENDIF.

    IF lt_assign IS NOT INITIAL.

      IF lv_picms IS NOT INITIAL AND
         lv_vicms IS NOT INITIAL.
        lv_icms_xml = abap_true.
      ELSE.
        lv_icms_xml = abap_false.
      ENDIF.

      IF lt_assign[] IS NOT INITIAL.

        DATA(ls_assign) = lt_assign[ 1 ].

        IF lv_icms_xml EQ abap_true.
          lv_icms_xml = 'S'.
        ELSE.
          lv_icms_xml = 'N'.
        ENDIF.

        SELECT iva_frete
          INTO @DATA(ls_zttm_pcockpit019)
          FROM zttm_pcockpit019
          UP TO 1 ROWS
          WHERE cenario   = @lv_cenario
            AND icms_xml  = @lv_icms_xml
            AND iva_nf    = @ls_assign-mwskz.
        ENDSELECT.

        CHECK sy-subrc IS INITIAL.
      ENDIF.

      LOOP AT it_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).

        READ TABLE ct_po_services ASSIGNING FIELD-SYMBOL(<fs_ct_po_services>) WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.
        <fs_ct_po_services>-tax_code = ls_zttm_pcockpit019.
        ev_iva                       = ls_zttm_pcockpit019.
      ENDLOOP.
    ENDIF.

    IF ev_iva IS NOT INITIAL.
      CLEAR: gv_message.
      CONCATENATE 'ZTTM_PCOCKPIT019'
                  lv_cenario
                  lv_icms_xml
                  ls_assign-mwskz
                  INTO gv_message SEPARATED BY space.

      " IVA determinado por: &1&2&3&4.
      DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                            id         = 'ZTM_GKO'
                                            number     = '137'
                                            message_v1 = ev_iva
                                            message_v2 = gv_message+0(50)
                                            message_v3 = gv_message+50(50)
                                            message_v4 = gv_message+100(50) ) ).

      set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                         iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

    ENDIF.

  ENDMETHOD.


  METHOD determina_iva_cte.

    TYPES:
      BEGIN OF ty_cfop_nf,
        docnum TYPE j_1bdocnum,
        itmnum TYPE j_1bitmnum,
        cfop   TYPE j_1bcfop,
      END OF ty_cfop_nf.

    DATA:
      lt_cfop_nf    TYPE TABLE OF ty_cfop_nf.

    DATA:
      lt_mat_transf TYPE TABLE OF /scmtms/s_tor_item_tr_k,
      lt_mat_venda  TYPE TABLE OF /scmtms/s_tor_item_tr_k.

    DATA:
      lt_refkey  TYPE zctgtm_cargo_refkey.

    DATA:
      lt_tor_item_data  TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k.

    DATA:
      ls_cfop_params TYPE j_1bao,
      lv_cfop_nf     TYPE j_1bcfop.

    DATA:
      lv_cenario TYPE ze_tm_cenario,
      lv_rateio  TYPE ze_tm_tprateio,
      lv_vstel   TYPE vstel,
      lv_tor_id  TYPE /scmtms/s_tor_root_k-tor_id.

    lv_tor_id = |{ is_tor_root-tor_id ALPHA = IN }|.

    " Com a Ordem de Frete, recuperamos o incoterms da remessa de Saída
    SELECT SINGLE fluxo~of_tor_id,
                  fluxo~vbeln_vl,
                  likp~inco1
        FROM zi_tm_vh_frete_docs_nf_saida AS fluxo
        LEFT OUTER JOIN likp
            ON likp~vbeln = fluxo~vbeln_vl
        WHERE fluxo~of_tor_id EQ @lv_tor_id
          AND fluxo~vbeln_vl  IS NOT INITIAL
        INTO @DATA(ls_fluxo).

    IF sy-subrc NE 0.

      " Com a Ordem de Frete, recuperamos o incoterms da remessa de Entrada
      SELECT SINGLE fluxo~of_tor_id,
                    fluxo~vbeln_vl,
                    likp~inco1
          FROM zi_tm_vh_frete_docs_nf_entrada AS fluxo
          LEFT OUTER JOIN likp
              ON likp~vbeln = fluxo~vbeln_vl
          WHERE fluxo~of_tor_id EQ @lv_tor_id
            AND fluxo~vbeln_vl  IS NOT INITIAL
          INTO @ls_fluxo.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

    CHECK it_tor_item IS NOT INITIAL.
    DATA(lt_tor_item) = it_tor_item.

    CASE ls_fluxo-inco1.
      WHEN 'CIF'.

        determina_iva_cte_cif(
          EXPORTING
            it_po_items       = ct_po_items       " Tipo de tabela para BAPIMEPOITEM
            is_tor_root       = is_tor_root       " Root Node
            it_tor_item       = lt_tor_item       " Transportation Order Item
            it_tor_stop       = it_tor_stop
            is_sfir_root      = is_sfir_root
            it_sfir_item_data = it_sfir_item_data " Main Area: SFIR Item
            it_stage_loc_data = it_stage_loc_data " Stages
            it_postal_addr    = it_postal_addr    " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
            iv_btd_id         = iv_btd_id         " Documento de transação comercial básico
            is_po_header      = is_po_header      " Pedido dds.cabeçalho
          IMPORTING
            ev_iva            = ev_iva
          CHANGING
            ct_po_services    = ct_po_services ). " Tipo de tabela para BAPIESLLC

      WHEN 'FOB'.

        determina_iva_cte_fob(
          EXPORTING
            is_tor_root       = is_tor_root       " Root Node
            it_tor_item       = lt_tor_item       " Transportation Order Item
            it_tor_stop       = it_tor_stop
            is_sfir_root      = is_sfir_root
            it_sfir_item_data = it_sfir_item_data " Main Area: SFIR Item
            it_stage_loc_data = it_stage_loc_data " Stages
            it_postal_addr    = it_postal_addr    " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
            iv_btd_id         = iv_btd_id         " Documento de transação comercial básico
            is_po_header      = is_po_header      " Pedido dds.cabeçalho
          IMPORTING
            ev_iva            = ev_iva
          CHANGING
            ct_po_items       = ct_po_items       " Tipo de tabela para BAPIMEPOITEM
            ct_po_itemsx      = ct_po_itemsx      " Tipo de tabela para BAPIMEPOITEMX
            ct_po_services    = ct_po_services ). " Tipo de tabela para BAPIESLLC

    ENDCASE.

  ENDMETHOD.


  METHOD determina_iva_diversos.

    DATA:
      lt_tor_item_data TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,
      ls_acckey        TYPE j_1b_nfe_access_key,
      lv_cenario       TYPE char2,
      lv_rateio        TYPE ze_tm_tprateio,
      lv_vstel         TYPE vstel,
      lv_tor_id        TYPE /scmtms/tor_id,
      lr_acckey        TYPE RANGE OF ztm_infos_fluig-chave_nfe,
      lr_vbeln         TYPE RANGE OF lips-vbeln,
      lr_vbeln_s       TYPE RANGE OF lips-vbeln,
      lr_vbeln_e       TYPE RANGE OF lips-vbeln.

* ---------------------------------------------------------------------------
* Recupera a remessa de entrada/saída
* ---------------------------------------------------------------------------
    DATA(lt_docref)  = busca_referencia( is_tor_root ).

    LOOP AT lt_docref REFERENCE INTO DATA(ls_docref).

      " Verifica se existe remessa de saída
      IF ls_docref->btd_tco EQ '73' AND ls_docref->btd_id IS NOT INITIAL.

        lr_vbeln    = VALUE #( BASE lr_vbeln ( sign   = 'I'
                                               option = 'EQ'
                                               low    = |{ ls_docref->btd_id+25(10) ALPHA = IN }| ) ).

        lr_vbeln_s  = VALUE #( BASE lr_vbeln_s ( sign   = 'I'
                                                 option = 'EQ'
                                                 low    = |{ ls_docref->btd_id+25(10) ALPHA = IN }| ) ).

      ENDIF.

      " Verifica se existe remessa de entrada
      IF ls_docref->btd_tco EQ '58' AND ls_docref->btd_id IS NOT INITIAL.

        lr_vbeln    = VALUE #( BASE lr_vbeln ( sign   = 'I'
                                               option = 'EQ'
                                               low    = |{ ls_docref->btd_id+25(10) ALPHA = IN }| ) ).

        lr_vbeln_e  = VALUE #( BASE lr_vbeln_e ( sign   = 'I'
                                                 option = 'EQ'
                                                 low    = |{ ls_docref->btd_id+25(10) ALPHA = IN }| ) ).
      ENDIF.

    ENDLOOP.

    IF lr_vbeln IS INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica se existe ICMS no XML
* ---------------------------------------------------------------------------
    lv_tor_id = |{ is_tor_root-tor_id ALPHA = IN }|.

    SELECT SINGLE tor_id, cenario, picms
        INTO @DATA(ls_001)
        FROM zttm_gkot001
        WHERE tor_id = @lv_tor_id
          AND acckey = @is_sfir_root-zzacckey.

*    IF sy-subrc EQ 0.
    DATA(lv_icms_xml) = COND ze_tm_icms_xml( WHEN ls_001-picms IS NOT INITIAL
                                             THEN 'S'
                                             ELSE 'N' ).
*    ENDIF.

* ---------------------------------------------------------------------------
* Verificamos se a Remessa ou Chave de acesso é FLUIG
* ---------------------------------------------------------------------------

    " Verifica se a Remessa é FLUIG
    IF lr_vbeln IS NOT INITIAL.

      SELECT DISTINCT remessa,
                      pedido_fluig,
                      ordem_frete,
                      chave_nfe
           FROM ztm_infos_fluig
           INTO TABLE @DATA(lt_fluig)
           WHERE remessa IN @lr_vbeln.

      IF sy-subrc NE 0.
        FREE lt_fluig.
      ENDIF.
    ENDIF.

    " Verifica se a Remessa é de Entrada
    IF lr_vbeln_e IS NOT INITIAL.

      SELECT DISTINCT vbeln_vl, docnum, acckey, mwskz
          FROM zi_tm_vh_frete_docs_nf_entrada
          WHERE vbeln_vl IN @lr_vbeln_e
            AND docnum IS NOT INITIAL
          INTO TABLE @DATA(lt_entrada).

      IF sy-subrc EQ 0.
        lr_acckey = VALUE #( BASE lr_acckey FOR ls_e IN lt_entrada WHERE ( acckey IS NOT INITIAL )
                           ( sign   = 'I'
                             option = 'EQ'
                             low    = ls_e-acckey ) ).
      ENDIF.
    ENDIF.

    " Verifica se a Remessa é de Saída
    IF lr_vbeln_s IS NOT INITIAL.

      SELECT DISTINCT vbeln_vl, docnum, acckey, mwskz
          FROM zi_tm_vh_frete_docs_nf_saida
          WHERE vbeln_vl IN @lr_vbeln_s
            AND docnum IS NOT INITIAL
          INTO TABLE @DATA(lt_saida).

      IF sy-subrc EQ 0.
        lr_acckey = VALUE #( BASE lr_acckey FOR ls_s IN lt_saida WHERE ( acckey IS NOT INITIAL )
                           ( sign   = 'I'
                             option = 'EQ'
                             low    = ls_s-acckey ) ).
      ENDIF.
    ENDIF.


    " Verifica se a chave de acesso é FLUIG
    IF lt_fluig IS INITIAL AND lr_acckey IS NOT INITIAL.

      SELECT DISTINCT remessa,
                      pedido_fluig,
                      ordem_frete,
                      chave_nfe
           FROM ztm_infos_fluig
           INTO TABLE @lt_fluig
           WHERE chave_nfe IN @lr_acckey.

      IF sy-subrc NE 0.
        FREE lt_fluig.
      ENDIF.
    ENDIF.

    lv_cenario = COND #( WHEN lt_fluig IS NOT INITIAL
                         THEN gc_fretes_diversos
                         ELSE ls_001-cenario ).

* ---------------------------------------------------------------------------
* Verifica o código do IVA
* ---------------------------------------------------------------------------
    SORT lt_entrada BY vbeln_vl ASCENDING docnum DESCENDING.
    SORT lt_saida   BY vbeln_vl ASCENDING docnum DESCENDING.

    TRY.
        DATA(lv_iva_sel) = COND #( WHEN lt_entrada IS NOT INITIAL
                                   THEN lt_entrada[ 1 ]-mwskz
                                   WHEN lt_saida IS NOT INITIAL
                                   THEN lt_saida[ 1 ]-mwskz ).
      CATCH cx_root.
    ENDTRY.

    SELECT SINGLE iva_frete
      INTO @DATA(lv_iva_019)
      FROM zttm_pcockpit019
      WHERE cenario   = @lv_cenario
        AND icms_xml  = @lv_icms_xml
        AND iva_nf    = @lv_iva_sel.

    IF sy-subrc NE 0.
      CLEAR lv_iva_019.
    ENDIF.

    ev_iva = lv_iva_019.

    IF ev_iva IS NOT INITIAL.
      CLEAR: gv_message.
      CONCATENATE 'ZTTM_PCOCKPIT019'
                  lv_cenario
                  lv_icms_xml
                  lv_iva_sel
                  INTO gv_message SEPARATED BY space.

      " IVA determinado por: &1&2&3&4.
      DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                            id         = 'ZTM_GKO'
                                            number     = '137'
                                            message_v1 = ev_iva
                                            message_v2 = gv_message+0(50)
                                            message_v3 = gv_message+50(50)
                                            message_v4 = gv_message+100(50) ) ).

      set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                         iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos
    ELSE.

      SELECT SINGLE FROM zttm_gkot003 AS gkot003
        INNER JOIN j_1bnfdoc      AS doc   ON doc~docnum = gkot003~docnum
        INNER JOIN j_1bnflin      AS lin   ON lin~docnum = gkot003~docnum
        INNER JOIN mara           AS mara  ON mara~matnr = lin~matnr
*        LEFT OUTER JOIN j_1bnfstx AS stx   ON stx~docnum = gkot003~docnum
        FIELDS doc~docnum,
               doc~manual,
               lin~matnr,
               mara~mtart
*               stx~base,
*               stx~taxval,
*               stx~taxgrp
        WHERE gkot003~acckey EQ @is_sfir_root-zzacckey
*          AND stx~taxgrp     EQ 'ICMS'
        INTO @DATA(ls_gkot003).

      IF sy-subrc IS INITIAL.
*        CLEAR: lv_icms_xml.
*
*        lv_icms_xml = COND ze_tm_icms_xml( WHEN ls_gkot003-base   IS NOT INITIAL AND
*                                                ls_gkot003-taxval IS NOT INITIAL
*                                           THEN 'S'
*                                           ELSE 'N' ).

        SELECT SINGLE iva
          FROM zttm_pcockpit017
          INTO ev_iva
          WHERE mtart     EQ ls_gkot003-mtart
            AND operacao  EQ lv_cenario
            AND manual    EQ ls_gkot003-manual
            AND icms_xml  EQ lv_icms_xml.

        IF ev_iva IS NOT INITIAL.
          CLEAR: gv_message.
          CONCATENATE 'ZTTM_PCOCKPIT017'
                      lv_cenario
                      lv_icms_xml
                      ls_gkot003-mtart
                      ls_gkot003-manual
                      INTO gv_message SEPARATED BY space.

          " IVA determinado por: &1&2&3&4.
          lt_return = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                          id         = 'ZTM_GKO'
                                          number     = '137'
                                          message_v1 = ev_iva
                                          message_v2 = gv_message+0(50)
                                          message_v3 = gv_message+50(50)
                                          message_v4 = gv_message+100(50) ) ).

          set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                             iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD determina_iva_nfse.

    DATA: lr_rem_uf TYPE RANGE OF ze_tm_rem_uf.

    " Doc Principal
    TRY.
        DATA(ls_sfir_item_data) = it_sfir_item_data[ 1 ].
      CATCH cx_root.
        RETURN.
    ENDTRY.

    " Determina Local de Expedição Origem/Destino
    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = it_sfir_item_data   " Main Area: SFIR Item
        it_stage_loc_data = it_stage_loc_data   " Stages
        it_postal_addr    = it_postal_addr      " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
        it_tor_stop       = it_tor_stop
      IMPORTING
        es_loc_origem     = DATA(ls_loc_origem) " Node structure for postal address data - internal
        es_loc_dest       = DATA(ls_loc_dest) )." Node structure for postal address data - internal

    IF ls_loc_origem-city_name IS NOT INITIAL.
      ls_loc_origem-city_name = trata_caracter_especial( iv_text = ls_loc_origem-city_name ).
    ENDIF.

    IF ls_loc_dest-city_name IS NOT INITIAL.
      ls_loc_dest-city_name = trata_caracter_especial( iv_text = ls_loc_dest-city_name ).
    ENDIF.

    " Domicílio Fiscal de Origem igual ao de Destino
    CHECK ls_loc_origem-city_name EQ ls_loc_dest-city_name.

    IF ct_po_items IS NOT INITIAL.

      DATA(lv_conta_contab) = determina_conta_contab( is_sfir_root      = is_sfir_root
                                                      is_sfir_item_data = ls_sfir_item_data
                                                      is_tor_root       = is_tor_root
                                                      is_loc_origem     = ls_loc_origem
                                                      is_loc_dest       = ls_loc_dest ).

      APPEND INITIAL LINE TO lr_rem_uf ASSIGNING FIELD-SYMBOL(<fs_rem_uf>).
      <fs_rem_uf>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
      <fs_rem_uf>-option = /bobf/if_conf_c=>sc_sign_equal.

      APPEND INITIAL LINE TO lr_rem_uf ASSIGNING <fs_rem_uf>.
      <fs_rem_uf>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
      <fs_rem_uf>-option = /bobf/if_conf_c=>sc_sign_equal.
      <fs_rem_uf>-low    = ls_loc_origem-region.

      SELECT * INTO TABLE @DATA(lt_zttm_pcockpit010)
        FROM zttm_pcockpit010
        WHERE saknr  = @lv_conta_contab
          AND rem_uf IN @lr_rem_uf.

      CHECK sy-subrc IS INITIAL.

      IF line_exists( lt_zttm_pcockpit010[ rem_uf = ls_loc_origem-region ] ).
        DELETE lt_zttm_pcockpit010 WHERE rem_uf <> ls_loc_origem-region.
      ENDIF.
    ENDIF.

    LOOP AT ct_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).

      READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_ct_po_itemsx>) WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.

      TRY.
          <fs_ct_po_items>-tax_code  = lt_zttm_pcockpit010[ 1 ]-mwskz.
          <fs_ct_po_itemsx>-tax_code = abap_true.
          ev_iva                     = lt_zttm_pcockpit010[ 1 ]-mwskz.
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.

    IF ev_iva IS NOT INITIAL.
      CLEAR: gv_message.
      CONCATENATE 'ZTTM_PCOCKPIT010'
                  lv_conta_contab
                  ls_loc_origem-region
                  INTO gv_message SEPARATED BY space.

      " IVA determinado por: &1&2&3&4.
      DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                            id         = 'ZTM_GKO'
                                            number     = '137'
                                            message_v1 = ev_iva
                                            message_v2 = gv_message+0(50)
                                            message_v3 = gv_message+50(50)
                                            message_v4 = gv_message+100(50) ) ).

      set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                         iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

    ENDIF.

  ENDMETHOD.


  METHOD busca_referencia.
    TRY.
        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
            it_key                  = VALUE #( ( key = is_tor_fo-key ) )                 " Key Table
            iv_association          = /scmtms/if_tor_c=>sc_association-root-docreference " Association
            iv_fill_data            = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = rt_tor_docref ).
      CATCH /bobf/cx_frw_contrct_violation.                                              " Caller violates a BOPF contract
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD determina_conta_contab.

    DATA: lt_remessa     TYPE tcm_t_vbrp,
          lt_refkey      TYPE zctgtm_cargo_refkey,
          lt_taxnum_tom  TYPE TABLE OF bptaxnumxl,
          lt_taxnum_rem  TYPE TABLE OF bptaxnumxl,
          lt_taxnum_dest TYPE TABLE OF bptaxnumxl.

    DATA: lr_locno_guid TYPE RANGE OF /scmb/mdl_locid.

    DATA: lv_tor_id   TYPE /scmtms/tor_id,
          lv_rem_cod  TYPE ze_gko_rem_cod,
          lv_dest_cod TYPE ze_gko_dest_cod.

    APPEND INITIAL LINE TO lr_locno_guid ASSIGNING FIELD-SYMBOL(<fs_locno>).
    <fs_locno>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_locno>-option = /bobf/if_conf_c=>sc_sign_equal.
    <fs_locno>-low    = is_loc_origem-root_key.

    APPEND INITIAL LINE TO lr_locno_guid ASSIGNING <fs_locno>.
    <fs_locno>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_locno>-option = /bobf/if_conf_c=>sc_sign_equal.
    <fs_locno>-low    = is_loc_dest-root_key.

    SELECT loc~loc_uuid,
           partner~partner
      INTO TABLE @DATA(lt_partner)
      FROM       /sapapo/loc AS loc
      INNER JOIN but000      AS partner ON partner~partner_guid = loc~partner_guid
      WHERE loc~loc_uuid IN @lr_locno_guid.

    CHECK sy-subrc IS INITIAL.

    IF line_exists( lt_partner[ loc_uuid = is_loc_origem-root_key ] ).
      lv_rem_cod =  lt_partner[ loc_uuid = is_loc_origem-root_key ]-partner.
    ENDIF.

    IF line_exists( lt_partner[ loc_uuid = is_loc_dest-root_key ] ).
      lv_dest_cod = lt_partner[ loc_uuid = is_loc_dest-root_key ]-partner.
    ENDIF.

    CLEAR: lv_tor_id.
    lv_tor_id = |{ is_tor_root-tor_id ALPHA = IN }|.

*    SELECT SINGLE *
*      INTO @DATA(ls_001)
*      FROM zttm_gkot001
*      WHERE acckey = @is_sfir_root-zzacckey
*        AND tor_id = @lv_tor_id.
**            emit_cod    = @is_tor_root-tspid AND
**            rem_cod     = @lv_rem_cod        AND
**            dest_cod    = @lv_dest_cod       .

    zcltm_gko_process=>determina_configuracao_p013( EXPORTING iv_acckey      = is_sfir_root-zzacckey
                                                              iv_tor_id      = lv_tor_id
                                                    IMPORTING es_header      = DATA(ls_001)
                                                              es_p013        = DATA(ls_p013) ).

    CHECK sy-subrc IS INITIAL.

    CASE ls_001-cenario .
      WHEN '06'. "fretes diversos

        DATA(lt_fo_dcref)  = busca_referencia( is_tor_root ).

        LOOP AT lt_fo_dcref ASSIGNING FIELD-SYMBOL(<fs_fo_docref>) WHERE btd_tco = '73'.
          DATA(lv_remessa) = |{ <fs_fo_docref>-btd_id ALPHA = OUT }|.
          APPEND lv_remessa TO lt_remessa.
        ENDLOOP.

        CHECK lt_remessa[] IS NOT INITIAL.

        SELECT
          vbeln
          INTO TABLE @DATA(lt_faturas)
          FROM vbfa
          FOR ALL ENTRIES IN @lt_remessa
          WHERE vbelv   = @lt_remessa-table_line
            AND vbtyp_n = 'M'.

        CHECK sy-subrc IS INITIAL.

        SORT lt_faturas BY vbeln.
        DELETE ADJACENT DUPLICATES FROM lt_faturas COMPARING vbeln.

        LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<fs_fat>).
          APPEND <fs_fat>-vbeln TO lt_refkey.
        ENDLOOP.

        SELECT *
           FROM j_1bnflin
          INTO TABLE @DATA(lt_lin)
          FOR ALL ENTRIES IN @lt_refkey
          WHERE refkey = @lt_refkey-table_line.

        IF sy-subrc IS INITIAL.
          DATA(lv_docnum) = lt_lin[ 1 ]-docnum.
        ENDIF.

        SELECT SINGLE * INTO @DATA(ls_active)
          FROM j_1bnfe_active
          WHERE docnum = @lv_docnum.          "#EC CI_ALL_FIELDS_NEEDED

        DATA(lv_acckey) = ls_active-regio && ls_active-nfyear && ls_active-nfmonth && ls_active-stcd1 && ls_active-model && ls_active-serie && ls_active-nfnum9 && ls_active-docnum9 && ls_active-cdv.

        SELECT * INTO TABLE @DATA(lt_fluig)
          FROM ztm_infos_fluig
          WHERE chave_nfe = @lv_acckey.

        IF sy-subrc IS INITIAL.
          rv_conta_contab = lt_fluig[ 1 ]-conta_contabil.
        ENDIF.

      WHEN OTHERS. "demais cenários

**        LOOP AT lt_zttm_gkot001 ASSIGNING FIELD-SYMBOL(<fs_zttm_gkot001>).
**
**          APPEND <fs_zttm_gkot001>-dest_cnpj    TO lt_taxnum_dest.
**          APPEND <fs_zttm_gkot001>-tom_cnpj_cpf TO lt_taxnum_tom.
**          APPEND <fs_zttm_gkot001>-rem_cnpj_cpf TO lt_taxnum_rem.
**
**        ENDLOOP.
**
**        SELECT * INTO TABLE @DATA(lt_tom)
**          FROM dfkkbptaxnum
**          FOR ALL ENTRIES IN @lt_taxnum_tom
**          WHERE taxnumxl = @lt_taxnum_tom-table_line.
**
**        SELECT * INTO TABLE @DATA(lt_rem)
**          FROM dfkkbptaxnum
**          FOR ALL ENTRIES IN @lt_taxnum_rem
**          WHERE taxnumxl = @lt_taxnum_rem-table_line.
**
**        SELECT * INTO TABLE @DATA(lt_dest)
**          FROM dfkkbptaxnum
**          FOR ALL ENTRIES IN @lt_taxnum_dest
**          WHERE taxnumxl = @lt_taxnum_dest-table_line.
*
*        SELECT werks, kunnr, j_1bbranch
*          INTO TABLE @DATA(lt_tom_branch)
*          FROM t001w
*          WHERE kunnr = @ls_001-tom_cod.
*
*        SELECT werks, kunnr, j_1bbranch
*          INTO TABLE @DATA(lt_rem_branch)
*          FROM t001w
*          WHERE kunnr = @ls_001-rem_cod.
*
*        SELECT werks, kunnr, j_1bbranch
*          INTO TABLE @DATA(lt_dest_branch)
*          FROM t001w
*          WHERE kunnr = @ls_001-dest_cod.
*
*        IF lt_tom_branch IS NOT INITIAL.
*          DATA(lv_tom_branch) = lt_tom_branch[ 1 ]-j_1bbranch. "werks.
*        ENDIF.
*
*        IF lt_rem_branch IS NOT INITIAL.
*          DATA(lv_rem_branch) = lt_rem_branch[ 1 ]-j_1bbranch. "werks.
*        ENDIF.
*
*        IF lt_dest_branch IS NOT INITIAL.
*          DATA(lv_dest_branch) = lt_dest_branch[ 1 ]-j_1bbranch. "werks.
*        ENDIF.
*
*        SELECT * INTO TABLE @DATA(lt_zttm_pcockpit013)
*          FROM zttm_pcockpit013
*          WHERE uforig      = @lt_zttm_gkot001-rem_uf
*            AND ufdest      = @lt_zttm_gkot001-dest_uf
*            AND rem_branch  = @lv_rem_branch
*            AND tom_branch  = @lv_tom_branch
*            AND dest_branch = @lv_dest_branch
*            AND loc_ret     = @lt_zttm_gkot001-ret_loc
*            AND loc_ent     = @lt_zttm_gkot001-ent_loc. "#EC CI_ALL_FIELDS_NEEDED
*
*        IF sy-subrc IS NOT INITIAL.
*          SELECT * INTO TABLE @lt_zttm_pcockpit013
*            FROM zttm_pcockpit013
*            FOR ALL ENTRIES IN @lt_zttm_gkot001
*            WHERE uforig      = @lt_zttm_gkot001-rem_uf
*              AND ufdest      = @lt_zttm_gkot001-dest_uf
*              AND rem_branch  = @lv_rem_branch
*              AND tom_branch  = @lv_tom_branch.
*        ENDIF.
*
*        IF sy-subrc IS INITIAL.
*          rv_conta_contab = lt_zttm_pcockpit013[ 1 ]-saknr.
*        ENDIF.
        IF ls_p013-saknr IS NOT INITIAL.
          rv_conta_contab = ls_p013-saknr.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD determina_iva_cte_cif.

    DATA: lv_remessa  TYPE vbeln,
          lv_vstel    TYPE vstel,
          ls_tor_root TYPE /scmtms/s_tor_root_k.

    CLEAR: ls_tor_root.

    ls_tor_root = is_tor_root.

    " Determina Local de Expedição Origem/Destino
    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = it_sfir_item_data   " Main Area: SFIR Item
        it_stage_loc_data = it_stage_loc_data   " Stages
        it_postal_addr    = it_postal_addr      " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
        it_tor_stop       = it_tor_stop
      IMPORTING
        es_loc_origem     = DATA(ls_loc_origem) " Node structure for postal address data - internal
        es_loc_dest       = DATA(ls_loc_dest) )." Node structure for postal address data - internal

    " Verifica Retorno
    CHECK ls_loc_origem IS NOT INITIAL AND
          ls_loc_dest   IS NOT INITIAL.

    lv_remessa = iv_btd_id+25(10).
    SELECT SINGLE
           vbeln,
           vstel
      FROM likp
      INTO @DATA(ls_likp)
      WHERE vbeln EQ @lv_remessa.

    CHECK sy-subrc IS INITIAL.

    SELECT vbeln,
           vgbel,
           vgpos
      FROM lips
      INTO TABLE @DATA(lt_lips)
      WHERE vbeln EQ @lv_remessa.

    " Seleção do IVA na Tabela ZTTM_PCOCKPIT005
    SELECT SINGLE *
      FROM zttm_pcockpit005
      INTO @DATA(ls_pcockpit005)
     WHERE regio_from EQ @ls_loc_origem-region
       AND regio_to   EQ @ls_loc_dest-region
       AND incoterm   EQ 'CIF'
       AND burks      EQ @is_po_header-comp_code
       AND vstel      EQ @ls_likp-vstel.

    IF sy-subrc IS INITIAL.

      LOOP AT it_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).

        READ TABLE ct_po_services ASSIGNING FIELD-SYMBOL(<fs_ct_po_services>) WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.
        <fs_ct_po_services>-tax_code = ls_pcockpit005-mwskz.
        ev_iva                       = ls_pcockpit005-mwskz.
      ENDLOOP.

      IF ev_iva IS NOT INITIAL.
        CLEAR: gv_message.
        CONCATENATE 'ZTTM_PCOCKPIT005'
                    ls_loc_origem-region
                    ls_loc_dest-region
                    'CIF'
                    is_po_header-comp_code
                    ls_likp-vstel
                    INTO gv_message SEPARATED BY space.

        " IVA determinado por: &1&2&3&4.
        DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                              id         = 'ZTM_GKO'
                                              number     = '137'
                                              message_v1 = ev_iva
                                              message_v2 = gv_message+0(50)
                                              message_v3 = gv_message+50(50)
                                              message_v4 = gv_message+100(50) ) ).

        set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                           iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

      ENDIF.
      RETURN.
    ENDIF.

    ls_tor_root-tor_id = |{ ls_tor_root-tor_id ALPHA = IN }|.

    SELECT SINGLE cenario,
                  picms,
                  vicms
      INTO @DATA(ls_gkot001)
      FROM zttm_gkot001
      WHERE tor_id = @ls_tor_root-tor_id
        AND acckey = @is_sfir_root-zzacckey.

    IF sy-subrc IS INITIAL.

* BEGIN OF INSERT - JWSILVA - 15.05.2023
      " Determina Produto Acabado
      DATA(lv_prod_acabado) = determina_prod_acabado( it_tor_item = it_tor_item ).
* END OF INSERT - JWSILVA - 15.05.2023

      SELECT SINGLE *
        FROM zttm_pcockpit011
        INTO @DATA(ls_pcockpit011)
        WHERE cenario  EQ @ls_gkot001-cenario
          AND incoterm EQ 'CIF'
          AND rateio   EQ 'R02'.

      IF sy-subrc IS INITIAL.

* BEGIN OF INSERT - JWSILVA - 15.05.2023
        IF lv_prod_acabado IS INITIAL.              " Se não tiver produto acabado

          DATA(lv_iva) = ls_pcockpit011-gmwskz.
* END OF INSERT - JWSILVA - 15.05.2023
        ELSEIF ls_gkot001-picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
               ls_gkot001-vicms IS NOT INITIAL.

          lv_iva = ls_pcockpit011-dmwskz.

        ELSEIF ls_gkot001-picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
               ls_gkot001-vicms IS INITIAL.

          lv_iva = ls_pcockpit011-pmwskz.

        ENDIF.
      ENDIF.
      LOOP AT it_po_items ASSIGNING <fs_ct_po_items>.

        READ TABLE ct_po_services ASSIGNING <fs_ct_po_services> WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.
        <fs_ct_po_services>-tax_code = lv_iva.
        ev_iva                       = lv_iva.
      ENDLOOP.

      IF ev_iva IS NOT INITIAL.
        CLEAR: gv_message.
        CONCATENATE 'ZTTM_PCOCKPIT011'
                    ls_gkot001-cenario
                    'CIF'
                    INTO gv_message SEPARATED BY space.

        " IVA determinado por: &1&2&3&4.
        lt_return = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                        id         = 'ZTM_GKO'
                                        number     = '137'
                                        message_v1 = ev_iva
                                        message_v2 = gv_message+0(50)
                                        message_v3 = gv_message+50(50)
                                        message_v4 = gv_message+100(50) ) ).

        set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                           iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

      ENDIF.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD determina_iva_cte_fob.

    TYPES:
      BEGIN OF ty_cfop_nf,
        docnum TYPE j_1bdocnum,
        itmnum TYPE j_1bitmnum,
        cfop   TYPE j_1bcfop,
      END OF ty_cfop_nf.

    DATA:
      lt_cfop_nf    TYPE TABLE OF ty_cfop_nf.

    DATA:
      lt_refkey TYPE zctgtm_cargo_refkey,
      ls_refkey TYPE j_1brefkey.

    DATA: lv_remessa TYPE vbeln,
          lv_vstel   TYPE vstel.

    DATA:
      lv_bp_rem      TYPE partner,
      lv_bp_dest     TYPE partner,
      ls_cfop_params TYPE j_1bao,
      lv_cfop_nf     TYPE j_1bcfop.

    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = it_sfir_item_data    " Main Area: SFIR Item
        it_stage_loc_data = it_stage_loc_data    " Stages
        it_postal_addr    = it_postal_addr       " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
        it_tor_stop       = it_tor_stop
      IMPORTING
        es_loc_origem     = DATA(ls_loc_origem)  " Node structure for postal address data - internal
        es_loc_dest       = DATA(ls_loc_dest) ). " Node structure for postal address data - internal

    CHECK ls_loc_origem IS NOT INITIAL AND
          ls_loc_dest   IS NOT INITIAL.

    lv_remessa = iv_btd_id+25(10).
    SELECT SINGLE vbeln,
                  vstel,
                  kunnr
      FROM likp
      INTO @DATA(ls_likp)
     WHERE vbeln EQ @lv_remessa.

* BEGIN OF INSERT - JWSILVA - 16.03.2023
    ls_likp-kunnr = COND #( WHEN ls_likp-kunnr IS NOT INITIAL
                            THEN ls_likp-kunnr
                            ELSE is_tor_root-consigneeid ).
* END OF INSERT - JWSILVA - 16.03.2023

    CHECK sy-subrc IS INITIAL.

    SELECT vbeln,
           vgbel,
           vgpos,
           j_1bcfop,
           j_1btxsdc
      FROM lips
      INTO TABLE @DATA(lt_lips)
      WHERE vbeln EQ @lv_remessa.

    " Seleção do IVA na Tabela ZTTM_PCOCKPIT005
    SELECT SINGLE *
      FROM zttm_pcockpit005
      INTO @DATA(ls_pcockpit005)
     WHERE regio_from EQ @ls_loc_origem-region
       AND regio_to   EQ @ls_loc_dest-region
       AND incoterm   EQ 'FOB'
       AND burks      EQ @is_po_header-comp_code
       AND vstel      EQ @ls_likp-vstel.

    IF sy-subrc IS INITIAL.
      LOOP AT ct_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).

        READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_ct_po_itemsx>) WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.

        <fs_ct_po_items>-tax_code  = ls_pcockpit005-mwskz.
        <fs_ct_po_itemsx>-tax_code = abap_true.
        ev_iva                     = ls_pcockpit005-mwskz.
      ENDLOOP.

      IF ev_iva IS NOT INITIAL.
        CLEAR: gv_message.
        CONCATENATE 'ZTTM_PCOCKPIT005'
                    ls_loc_origem-region
                    ls_loc_dest-region
                    'FOB'
                    is_po_header-comp_code
                    ls_likp-vstel
                    INTO gv_message SEPARATED BY space.

        " IVA determinado por: &1&2&3&4.
        DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                              id         = 'ZTM_GKO'
                                              number     = '137'
                                              message_v1 = ev_iva
                                              message_v2 = gv_message+0(50)
                                              message_v3 = gv_message+50(50)
                                              message_v4 = gv_message+100(50) ) ).

        set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                           iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

      ENDIF.
      RETURN.
    ENDIF.

    DATA(lv_tor_id) =   |{ is_tor_root-tor_id  ALPHA = IN }|.

    " Selecionar o CFOP das notas transportadas
    SELECT SINGLE cenario,
                  picms,
                  vicms,
                  cfop
      INTO (@DATA(lv_cenario),
            @DATA(lv_picms),
            @DATA(lv_vicms),
            @DATA(lv_cfop))
      FROM zttm_gkot001
      WHERE tor_id = @lv_tor_id
        AND acckey = @is_sfir_root-zzacckey.
**        AND dest_cod = @ls_loc_dest-region.
*        AND dest_cod  = @gv_bp_dest
*        AND rem_cod   = @gv_bp_rem.

    DATA(lt_fo_dcref)  = busca_referencia( is_tor_root ).
    DELETE lt_fo_dcref WHERE btd_tco NE '73' AND btd_tco NE '58'.

    IF lt_fo_dcref[] IS NOT INITIAL.

      SELECT vbeln,
             posnr,
             j_1bcfop
        FROM vbap
        INTO TABLE @DATA(lt_vbap)
        FOR ALL ENTRIES IN @lt_lips
        WHERE vbeln EQ @lt_lips-vgbel
          AND posnr EQ @lt_lips-vgpos.

      IF sy-subrc IS INITIAL.

        SELECT cfop
          INTO TABLE @DATA(lt_cfop_param)
          FROM zttm_pcockpit006
          FOR ALL ENTRIES IN @lt_vbap
          WHERE cfop = @lt_vbap-j_1bcfop.

        LOOP AT lt_cfop_param ASSIGNING FIELD-SYMBOL(<fs_cfop_param>).
          CASE <fs_cfop_param>-cfop.
            WHEN space.
              LOOP AT ct_po_items ASSIGNING <fs_ct_po_items>.

*        READ TABLE ct_po_services ASSIGNING FIELD-SYMBOL(<fs_ct_po_services>) WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
                READ TABLE ct_po_itemsx ASSIGNING <fs_ct_po_itemsx> WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
                CHECK sy-subrc IS INITIAL.

                <fs_ct_po_items>-tax_code  = 'C0'.
                <fs_ct_po_itemsx>-tax_code = abap_true.
                ev_iva                     = 'C0'.
              ENDLOOP.
              RETURN.
            WHEN OTHERS.

              " Determina Produto Acabado
              DATA(lv_prod_acabado) = determina_prod_acabado( it_tor_item = it_tor_item ).

              SELECT SINGLE *
                FROM zttm_pcockpit011
                INTO @DATA(ls_pcockpit011)
                WHERE cenario  EQ @lv_cenario
                  AND incoterm EQ 'FOB'
                  AND rateio   EQ 'R02'.             "#EC CI_SEL_NESTED

              IF sy-subrc IS INITIAL.
                IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado

                  DATA(lv_iva) = ls_pcockpit011-gmwskz.

                ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
                   lv_vicms IS NOT INITIAL.

                  lv_iva = ls_pcockpit011-dmwskz.

                ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
                       lv_vicms IS INITIAL.

                  lv_iva = ls_pcockpit011-pmwskz.

                ENDIF.
              ENDIF.

              IF lv_iva IS NOT INITIAL.
                LOOP AT ct_po_items ASSIGNING <fs_ct_po_items>.

*                  READ TABLE ct_po_services ASSIGNING FIELD-SYMBOL(<fs_ct_po_services>) WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
                  READ TABLE ct_po_itemsx ASSIGNING <fs_ct_po_itemsx> WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
                  CHECK sy-subrc IS INITIAL.

                  <fs_ct_po_items>-tax_code  = lv_iva.
                  <fs_ct_po_itemsx>-tax_code = abap_true.
                  ev_iva                     = lv_iva.
                ENDLOOP.

                IF ev_iva IS NOT INITIAL.
                  CLEAR: gv_message.
                  CONCATENATE 'ZTTM_PCOCKPIT011'
                              lv_cenario
                              'FOB'
                              INTO gv_message SEPARATED BY space.

                  " IVA determinado por: &1&2&3&4.
                  lt_return = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                                  id         = 'ZTM_GKO'
                                                  number     = '137'
                                                  message_v1 = ev_iva
                                                  message_v2 = gv_message+0(50)
                                                  message_v3 = gv_message+50(50)
                                                  message_v4 = gv_message+100(50) ) ).

                  set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                                     iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

                ENDIF.
                RETURN.
              ENDIF.
          ENDCASE.

        ENDLOOP.
      ENDIF.
    ENDIF.

    " Seleção de IVA em tabela de exceção
    DATA(lt_mat) = it_tor_item.
    DELETE lt_mat WHERE item_cat <> /scmtms/if_tor_const=>sc_tor_item_category-product.

    IF lt_mat IS NOT INITIAL.

      SELECT
        matnr,
*        mtart
        matkl
        INTO TABLE @DATA(lt_tp_mat)
        FROM mara
        FOR ALL ENTRIES IN @lt_mat
        WHERE matnr = @lt_mat-product_id.               "#EC CI_SEL_DEL

      SORT lt_tp_mat BY matkl.
      DELETE ADJACENT DUPLICATES FROM lt_tp_mat COMPARING matkl.

      IF lt_tp_mat[] IS NOT INITIAL.

        SELECT SINGLE werks,
                      kunnr
          FROM t001w
          INTO @DATA(ls_t001w)
          WHERE kunnr EQ @ls_likp-kunnr.

        IF sy-subrc IS INITIAL.

          SELECT
            vstel,
            mtart,
            mwskz
            INTO TABLE @DATA(lt_zttm_pcockpit018)
            FROM zttm_pcockpit018
            FOR ALL ENTRIES IN @lt_tp_mat
            WHERE vstel  = @ls_t001w-werks
              AND mtart  = @lt_tp_mat-matkl.

          IF sy-subrc IS INITIAL.

            DATA(ls_zttm_pcockpit018) = lt_zttm_pcockpit018[ 1 ].
            LOOP AT ct_po_items ASSIGNING <fs_ct_po_items>.

*            READ TABLE ct_po_services ASSIGNING <fs_ct_po_services> WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
              READ TABLE ct_po_itemsx ASSIGNING <fs_ct_po_itemsx> WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
              CHECK sy-subrc IS INITIAL.

*            <fs_ct_po_services>-tax_code = ls_zttm_pcockpit018-mwskz.
              <fs_ct_po_items>-tax_code  = ls_zttm_pcockpit018-mwskz.
              <fs_ct_po_itemsx>-tax_code = abap_true.
              ev_iva                     = ls_zttm_pcockpit018-mwskz.
            ENDLOOP.

            IF ev_iva IS NOT INITIAL.
              CLEAR: gv_message.

              DATA(lv_matkl) = lt_tp_mat[ 1 ]-matkl.

              CONCATENATE 'ZTTM_PCOCKPIT018'
                          ls_t001w-werks
                          lv_matkl
                          INTO gv_message SEPARATED BY space.

              " IVA determinado por: &1&2&3&4.
              lt_return = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                              id         = 'ZTM_GKO'
                                              number     = '137'
                                              message_v1 = ev_iva
                                              message_v2 = gv_message+0(50)
                                              message_v3 = gv_message+50(50)
                                              message_v4 = gv_message+100(50) ) ).

              set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                                 iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

            ENDIF.
            RETURN.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    " seleção na tabela de IVA detalhado (ZTTM_PCOCKPIT003) considerando CFOP/ Cenário / IVA de (NF) de entrada no destino / IVA para (frete).
    lt_mat = it_tor_item.
    DELETE lt_mat WHERE item_cat <> 'PRD'.

    IF lt_mat[] IS NOT INITIAL.

      SELECT
        ebeln,
        ebelp,
        mwskz
      INTO TABLE @DATA(lt_ekpo)
      FROM ekpo
      FOR ALL ENTRIES IN @lt_mat
      WHERE ebeln = @lt_mat-orig_btd_id+25(10).

      IF sy-subrc IS INITIAL.

        IF lt_lips[] IS NOT INITIAL.
          DATA(lv_iva_sd)  = lt_lips[ 1 ]-j_1btxsdc.
          DATA(lv_cfop_sd) = lt_lips[ 1 ]-j_1bcfop.
        ENDIF.

        SELECT * INTO TABLE @DATA(lt_j_1bt007)
          FROM j_1bt007
          FOR ALL ENTRIES IN @lt_ekpo
          WHERE in_mwskz = @lt_ekpo-mwskz
            AND sd_mwskz = @lv_iva_sd.


        SORT lt_j_1bt007 BY in_mwskz
                            sd_mwskz.

      ENDIF.

      SELECT * INTO TABLE @DATA(lt_faturas)
        FROM vbfa
        WHERE vbelv   = @iv_btd_id+25(10)
          AND vbtyp_n = 'R'.

      IF sy-subrc IS INITIAL.

        LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<fs_fat>).
          ls_refkey = |{ <fs_fat>-vbeln && sy-datum(4) }|.
          APPEND ls_refkey TO lt_refkey.
        ENDLOOP.

        SELECT *
           FROM j_1bnflin
          INTO TABLE @DATA(lt_lin)
          FOR ALL ENTRIES IN @lt_refkey
          WHERE refkey = @lt_refkey-table_line.

        IF sy-subrc IS INITIAL.

          DATA(lv_docnum) = lt_lin[ 1 ]-docnum.

          SELECT SINGLE *
             FROM j_1bnfdoc
            INTO @DATA(ls_doc)
            WHERE docnum = @lv_docnum.

        ENDIF.

      ENDIF.

      LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).

        ls_cfop_params-direct   = ls_doc-direct.
        ls_cfop_params-itmtyp   = <fs_lin>-itmtyp.
        ls_cfop_params-matuse   = <fs_lin>-matuse.
        ls_cfop_params-indus2   = lv_vstel.
        ls_cfop_params-cfop     = lv_cfop_sd.

        CALL FUNCTION 'J_1B_NF_CFOP_1_DETERMINATION'
          EXPORTING
            cfop_parameters = ls_cfop_params
            i_land1         = ls_doc-land1
            i_region        = ls_doc-regio
            i_date          = ls_doc-docdat
          IMPORTING
            cfop            = lv_cfop_nf
          EXCEPTIONS
            cfop_not_found  = 1
            OTHERS          = 2.
        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
        ENDIF.

        DATA(ls_cfop_nf) = VALUE ty_cfop_nf( docnum = ls_doc-docnum
                                             itmnum = <fs_lin>-itmnum
                                             cfop   = lv_cfop ).

        APPEND ls_cfop_nf TO lt_cfop_nf.
      ENDLOOP.

      lt_mat = it_tor_item.
      DELETE lt_mat WHERE orig_btd_tco <> '114'.

      IF lt_mat IS NOT INITIAL.

        SELECT SINGLE * INTO @DATA(ls_active)
          FROM j_1bnfe_active
          WHERE docnum = @lv_docnum.          "#EC CI_ALL_FIELDS_NEEDED

        DATA(lv_acckey) = ls_active-regio && ls_active-nfyear && ls_active-nfmonth && ls_active-stcd1 && ls_active-model && ls_active-serie && ls_active-nfnum9 && ls_active-docnum9 && ls_active-cdv.


        SELECT SINGLE * INTO @DATA(ls_innfehd)
          FROM /xnfe/innfehd
          WHERE nfeid = @lv_acckey.           "#EC CI_ALL_FIELDS_NEEDED

        DATA:
          lt_assign  TYPE /xnfe/nfeassign_t.

        CALL FUNCTION '/XNFE/B2BNFE_READ'
          EXPORTING
            iv_guid_header     = ls_innfehd-guid_header
          IMPORTING
            et_assign          = lt_assign
          EXCEPTIONS
            nfe_does_not_exist = 1
            nfe_locked         = 2
            technical_error    = 3
            OTHERS             = 4.

        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_message.
        ENDIF.

        SORT lt_assign BY guid_header.
        IF lt_assign[] IS NOT INITIAL.
          DATA(ls_assign) = lt_assign[ 1 ].
        ENDIF.

        SELECT SINGLE *
          INTO @DATA(ls_zttm_pcockpit003)
          FROM zttm_pcockpit003
          WHERE cenario = @lv_cenario
            AND cfop    = @lv_cfop_sd
            AND dmwskz  = @ls_assign-mwskz.   "#EC CI_ALL_FIELDS_NEEDED

        IF ls_zttm_pcockpit003 IS NOT INITIAL.
          LOOP AT ct_po_items ASSIGNING <fs_ct_po_items>.

*            READ TABLE ct_po_services ASSIGNING FIELD-SYMBOL(<fs_ct_po_services>) WITH KEY pckg_no = <fs_ct_po_items>-pckg_no BINARY SEARCH.
            READ TABLE ct_po_itemsx ASSIGNING <fs_ct_po_itemsx> WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
            CHECK sy-subrc IS INITIAL.

            <fs_ct_po_items>-tax_code  = ls_zttm_pcockpit003-pmwskz.
            <fs_ct_po_itemsx>-tax_code = abap_true.
            ev_iva                     = ls_zttm_pcockpit003-pmwskz.
          ENDLOOP.

          IF ev_iva IS NOT INITIAL.
            CLEAR: gv_message.
            CONCATENATE 'ZTTM_PCOCKPIT003'
                        lv_cenario
                        lv_cfop_sd
                        ls_assign-mwskz
                        INTO gv_message SEPARATED BY space.

            " IVA determinado por: &1&2&3&4.
            lt_return = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                            id         = 'ZTM_GKO'
                                            number     = '137'
                                            message_v1 = ev_iva
                                            message_v2 = gv_message+0(50)
                                            message_v3 = gv_message+50(50)
                                            message_v4 = gv_message+100(50) ) ).

            set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                               iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

          ENDIF.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Caso nenhuma das determinações anteriores funcione, fazer uma última determinação
* somente para os cenários de Entrada
* ---------------------------------------------------------------------------
    " Somente continuar quando o documento for 58 (Recebimento) ou 73 (Entrega)
    CHECK ev_iva IS INITIAL AND lt_fo_dcref IS NOT INITIAL.

    " Determina Produto Acabado
    lv_prod_acabado = determina_prod_acabado( it_tor_item = it_tor_item ).

    SELECT SINGLE *
      FROM zttm_pcockpit011
      INTO @ls_pcockpit011
      WHERE cenario  EQ @lv_cenario
        AND incoterm EQ 'FOB'
        AND rateio   EQ 'R02'.                       "#EC CI_SEL_NESTED

    IF sy-subrc IS INITIAL.
      IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado

        lv_iva = ls_pcockpit011-gmwskz.

      ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
         lv_vicms IS NOT INITIAL.

        lv_iva = ls_pcockpit011-dmwskz.

      ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
             lv_vicms IS INITIAL.

        lv_iva = ls_pcockpit011-pmwskz.

      ENDIF.
    ENDIF.

    IF lv_iva IS NOT INITIAL.
      LOOP AT ct_po_items ASSIGNING <fs_ct_po_items>.

        READ TABLE ct_po_itemsx ASSIGNING <fs_ct_po_itemsx> WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
        CHECK sy-subrc IS INITIAL.

        <fs_ct_po_items>-tax_code  = lv_iva.
        <fs_ct_po_itemsx>-tax_code = abap_true.
        ev_iva                     = lv_iva.
      ENDLOOP.

      IF ev_iva IS NOT INITIAL.
        CLEAR: gv_message.
        CONCATENATE 'ZTTM_PCOCKPIT011'
                    lv_cenario
                    'FOB'
                    INTO gv_message SEPARATED BY space.

        " IVA determinado por: &1&2&3&4.
        lt_return = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
                                        id         = 'ZTM_GKO'
                                        number     = '137'
                                        message_v1 = ev_iva
                                        message_v2 = gv_message+0(50)
                                        message_v3 = gv_message+50(50)
                                        message_v4 = gv_message+100(50) ) ).

        set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
                           iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos

      ENDIF.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD determina_loc_origem_dest.

    " Doc Principal
    IF line_exists( it_sfir_item_data[ 1 ] ).
      DATA(ls_sfir_item_data) = it_sfir_item_data[ 1 ].
    ENDIF.
    CHECK ls_sfir_item_data IS NOT INITIAL.

    " Busca Stage
    IF line_exists( it_stage_loc_data[ key = ls_sfir_item_data-tor_stage_key ] ).
      DATA(ls_stage_loc_data) = it_stage_loc_data[ key = ls_sfir_item_data-tor_stage_key ].
    ENDIF.
    CHECK ls_stage_loc_data IS NOT INITIAL.

* BEGIN OF INSERT - JWSILVA - 28.03.2023
    " Recupera a primeira unidade gerencial de origem e seta para todas as etapas
    TRY.
        ls_stage_loc_data-src_loc_id   = it_tor_stop[ stop_seq_pos = 'F' ]-log_locid.
        ls_stage_loc_data-src_loc_uuid = it_tor_stop[ stop_seq_pos = 'F' ]-log_loc_uuid.
      CATCH cx_root.
    ENDTRY.
* END OF INSERT - JWSILVA - 28.03.2023

    " Loc Origem
    IF line_exists( it_postal_addr[ root_key = ls_stage_loc_data-src_loc_uuid ] ).
      DATA(ls_loc_origem) = it_postal_addr[ root_key = ls_stage_loc_data-src_loc_uuid ].
    ENDIF.
    CHECK ls_loc_origem IS NOT INITIAL.

    " Loc Destino
    IF line_exists( it_postal_addr[ root_key = ls_stage_loc_data-des_loc_uuid ] ).
      DATA(ls_loc_dest) = it_postal_addr[ root_key = ls_stage_loc_data-des_loc_uuid ].
    ENDIF.
    CHECK ls_loc_dest IS NOT INITIAL.

    es_loc_origem = ls_loc_origem.
    es_loc_dest   = ls_loc_dest.

  ENDMETHOD.


  METHOD determina_prod_acabado.

    DATA(lt_mat) = it_tor_item.

    DELETE lt_mat WHERE item_cat <> 'PRD'.

    IF lt_mat IS NOT INITIAL.

      SELECT
        matnr,
        mtart
        INTO TABLE @DATA(lt_tp_mat)
        FROM mara
        FOR ALL ENTRIES IN @lt_mat
        WHERE matnr = @lt_mat-product_id.               "#EC CI_SEL_DEL

      SORT lt_tp_mat BY mtart.
      DELETE ADJACENT DUPLICATES FROM lt_tp_mat COMPARING mtart.

      IF lt_tp_mat IS NOT INITIAL.

        SELECT
          categoria,
          tipo_mat
          INTO TABLE @DATA(lt_zttm_pcockpit009)
          FROM zttm_pcockpit009
          FOR ALL ENTRIES IN @lt_tp_mat
          WHERE tipo_mat  = @lt_tp_mat-mtart.

        IF sy-subrc IS INITIAL.

          rt_prod_acabado = abap_true.

          LOOP AT lt_tp_mat INTO DATA(ls_tp_mat).

            IF NOT line_exists( lt_zttm_pcockpit009[ tipo_mat = ls_tp_mat-mtart ] ).

              rt_prod_acabado = abap_false.
              EXIT.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_items_post.

    DATA: lt_references     TYPE zcltm_gko_process=>ty_t_zgkot003,
          lt_nf_saida       TYPE zcltm_gko_process=>ty_t_j_1bnflin,
          lt_nf_saida_w_pa  TYPE zcltm_gko_process=>ty_t_j_1bnflin,
          lt_nf_saida_wo_pa TYPE zcltm_gko_process=>ty_t_j_1bnflin,
          lt_errors         TYPE zcxtm_gko=>ty_t_errors,
          lt_po_data_col    TYPE zcltm_gko_process=>ty_t_po_data_col.

    IF it_references IS INITIAL.

      SELECT *
        FROM zttm_gkot003
        INTO TABLE lt_references
       WHERE acckey = iv_acckey.

    ELSE.

      lt_references[] = it_references[].

    ENDIF.

    SORT lt_references BY docnum.

    DELETE ADJACENT DUPLICATES FROM lt_references COMPARING docnum.

    IF lt_references[] IS NOT INITIAL.

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
         FOR ALL ENTRIES IN lt_references
       WHERE docnum = lt_references-docnum.

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
    get_items_post_wo_pa( EXPORTING it_nf_saida   = lt_nf_saida_wo_pa
                                    is_header     = is_header
                           CHANGING ct_items_post = rt_items_post ).

    CASE is_header-cenario.

      WHEN '01'. " transferencia.
        " Obtêm os itens para o cenário Transferência - Registros com Produto Acabado
        get_items_post_transferencia( EXPORTING it_nf_saida   = lt_nf_saida_w_pa
                                                is_header     = is_header
                                       CHANGING ct_items_post = rt_items_post ).

      WHEN '03'. " venda_coligada.
        " Obtêm os itens para o cenário Venda Coligada - Registros com Produto Acabado
        get_items_post_venda_coligada( EXPORTING it_nf_saida   = lt_nf_saida_w_pa
                                                 is_header     = is_header
                                        CHANGING ct_items_post = rt_items_post ).

      WHEN OTHERS.
        " Para os demais casos com Produto Acabado, replica os itens da NF de saída
        get_items_post_others( EXPORTING it_nf_saida   = lt_nf_saida_w_pa
                                         is_header     = is_header
                                CHANGING ct_items_post = rt_items_post ).

    ENDCASE.

    DATA(lv_amount_doc) = COND ze_gko_vtprest( WHEN is_header-tpdoc = zcltm_gko_process=>gc_tpdoc-nfs
                                                    THEN is_header-vrec
                                                    ELSE is_header-vtprest ).

    DATA(lv_item_amount_tot) = REDUCE ze_gko_vtprest( INIT lr_result = CONV ze_gko_vtprest( '0' )
                                                       FOR <fs_red_item_post> IN rt_items_post
                                                       NEXT lr_result = lr_result + <fs_red_item_post>-item_amount + <fs_red_item_post>-tax_amount ).

    LOOP AT lt_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_saida>).

      ASSIGN rt_items_post[ docnum_out = <fs_s_nf_saida>-docnum
                            itmnum_out = <fs_s_nf_saida>-itmnum ] TO FIELD-SYMBOL(<fs_s_item_post>).

      IF sy-subrc IS NOT INITIAL.

        " Não foi realizada a entrada da nota &.
        ASSIGN it_references[ docnum = <fs_s_nf_saida>-docnum ] TO FIELD-SYMBOL(<fs_s_reference>).

      ELSE.

        <fs_s_item_post>-item_amount_r = lv_amount_doc * ( <fs_s_item_post>-item_amount / lv_item_amount_tot ).

      ENDIF.
    ENDLOOP.

    " Remove os itens com quantidade igual a zero (devolução)
    DELETE rt_items_post WHERE quantity IS INITIAL.

  ENDMETHOD.


  METHOD get_items_post_others.

*    CHECK iv_nf_saida IS NOT INITIAL.

*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ is_header-tom_ie }| ).

    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      =    @is_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      =    @is_header-cenario.

    " Obtêm os CFOPs com Crédito de ICMS
    SELECT *
      FROM zttm_pcockpit006
      INTO TABLE @DATA(lt_zgkop015).

    LOOP AT it_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin_saida>) .

      APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).

      <fs_s_item_post>-docnum   = <fs_s_nf_lin_saida>-docnum.
      <fs_s_item_post>-itmnum   = <fs_s_nf_lin_saida>-itmnum.
      <fs_s_item_post>-matnr    = <fs_s_nf_lin_saida>-matnr.
      <fs_s_item_post>-cfop     = <fs_s_nf_lin_saida>-cfop.
      <fs_s_item_post>-tax_code = <fs_s_nf_lin_saida>-mwskz.

      " nfnet = bruto
      IF is_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_lin_saida>-cfop ] ) ).
*                                             OR   lv_count_zgkop005 IS NOT INITIAL                                ).
        <fs_s_item_post>-item_amount = <fs_s_nf_lin_saida>-nfnet * ( ( 100 - is_header-picms ) / 100 ).
        <fs_s_item_post>-tax_amount  = <fs_s_nf_lin_saida>-nfnet - <fs_s_item_post>-item_amount.
      ELSE.
        <fs_s_item_post>-item_amount = <fs_s_nf_lin_saida>-nfnet .
      ENDIF.

      <fs_s_item_post>-quantity     = <fs_s_nf_lin_saida>-menge.
      <fs_s_item_post>-unit         = <fs_s_nf_lin_saida>-meins.
      <fs_s_item_post>-ebeln        = <fs_s_nf_lin_saida>-ebeln.
      <fs_s_item_post>-ebelp        = <fs_s_nf_lin_saida>-ebelp.
      <fs_s_item_post>-ref_doc      = <fs_s_nf_lin_saida>-mblnr.
      <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin_saida>-zeile.
      <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin_saida>-mjahr.

      <fs_s_item_post>-docnum_out   = <fs_s_item_post>-docnum.
      <fs_s_item_post>-itmnum_out   = <fs_s_item_post>-itmnum.
      <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin_saida>-mtart_pa.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_items_post_transferencia.

    CHECK it_nf_saida IS NOT INITIAL.

*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).

    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      = @IS_HEADER-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      = @IS_HEADER-cenario.

    " Obtêm os CFOPs com Crédito de ICMS
    SELECT *
      FROM zttm_pcockpit006
      INTO TABLE @DATA(lt_zgkop015).

    DATA(lt_nf_saida) = it_nf_saida.
    SORT lt_nf_saida BY xped ASCENDING nitemped ASCENDING.

    " Obtêm a nota fiscal de entrada para os registros com pedido
    DATA(lt_j_1bnflin_w_po) = lt_nf_saida.
    DELETE lt_j_1bnflin_w_po WHERE ebeln IS INITIAL.

    IF lt_j_1bnflin_w_po IS NOT INITIAL.

      SORT lt_j_1bnflin_w_po BY ebeln.
      DELETE ADJACENT DUPLICATES FROM lt_j_1bnflin_w_po COMPARING ebeln.

      SELECT ebeln,
             ebelp,
             gjahr,
             belnr,
             buzei
        FROM ekbe AS ekbe_orig
        INTO TABLE @DATA(lt_ekbe_transf)
         FOR ALL ENTRIES IN @lt_j_1bnflin_w_po
       WHERE ekbe_orig~ebeln = @lt_j_1bnflin_w_po-ebeln
         AND ekbe_orig~zekkn = '00'
         AND ekbe_orig~vgabe = '1'    " Entrada de mercadorias
         AND NOT EXISTS ( SELECT ebeln
                            FROM ekbe
                           WHERE ebeln =  ekbe_orig~ebeln
                             AND ebelp =  ekbe_orig~ebelp
                             AND zekkn =  ekbe_orig~zekkn
                             AND vgabe =  ekbe_orig~vgabe
                             AND gjahr <> ekbe_orig~gjahr
                             AND belnr <> ekbe_orig~belnr
                             AND buzei <> ekbe_orig~buzei
                             AND lfgja =  ekbe_orig~gjahr
                             AND lfbnr =  ekbe_orig~belnr
                             AND lfpos =  ekbe_orig~buzei ).

      IF sy-subrc IS INITIAL.

        " Preenche o pedido na tabela interna de acordo com a ordem dos itens
        LOOP AT lt_nf_saida ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin>)
                                          GROUP BY <fs_s_nf_lin>-ebeln.

          CHECK <fs_s_nf_lin>-ebeln IS NOT INITIAL.

          DATA(lt_ekbe_transf_aux) = lt_ekbe_transf.
          DELETE lt_ekbe_transf_aux WHERE ebeln <> <fs_s_nf_lin>-ebeln.
          SORT lt_ekbe_transf_aux BY ebelp ASCENDING.

          DATA(lv_item_counter) = 0.

          LOOP AT GROUP <fs_s_nf_lin> ASSIGNING FIELD-SYMBOL(<fs_s_nf_lin_mbr>).

            lv_item_counter = lv_item_counter + 1.

            ASSIGN lt_ekbe_transf_aux[ lv_item_counter ] TO FIELD-SYMBOL(<fs_s_ekbe_transf_aux>).
            IF sy-subrc IS INITIAL.
              <fs_s_nf_lin_mbr>-ebeln     = <fs_s_ekbe_transf_aux>-ebeln.
              <fs_s_nf_lin_mbr>-ebelp     = <fs_s_ekbe_transf_aux>-ebelp.
              <fs_s_nf_lin_mbr>-refkey_po = |{ <fs_s_ekbe_transf_aux>-belnr }{ <fs_s_ekbe_transf_aux>-gjahr }|.
              <fs_s_nf_lin_mbr>-refitm_po = <fs_s_ekbe_transf_aux>-buzei.
            ENDIF.

          ENDLOOP.
        ENDLOOP.

        lt_j_1bnflin_w_po = lt_nf_saida.
        DELETE lt_j_1bnflin_w_po WHERE refkey_po IS INITIAL.
        IF lt_j_1bnflin_w_po IS NOT INITIAL.

          SELECT out_mwskz,
                 in_mwskz
            FROM j_1bt007
            INTO TABLE @DATA(lt_j1bt007)
             FOR ALL ENTRIES IN @lt_j_1bnflin_w_po
           WHERE out_mwskz = @lt_j_1bnflin_w_po-mwskz.

          " Obtêm a NF de entrada de acordo com o pedido
          SELECT docnum,
                 itmnum,
                 refkey,
                 refitm,
                 cfop,
                 mwskz,
                 netwr,
                 nfnet,
                 menge,
                 meins
            FROM j_1bnflin
            INTO TABLE @DATA(lt_nf_entrada)
             FOR ALL ENTRIES IN @lt_j_1bnflin_w_po
           WHERE refkey = @lt_j_1bnflin_w_po-refkey_po
             AND refitm = @lt_j_1bnflin_w_po-refitm_po.

          IF sy-subrc IS INITIAL.

            LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS NOT INITIAL.

              ASSIGN lt_nf_entrada[ refkey = <fs_s_nf_lin>-refkey_po
                                    refitm = <fs_s_nf_lin>-refitm_po ] TO FIELD-SYMBOL(<fs_s_nf_lin_entrada>).
              CHECK sy-subrc IS INITIAL.

              ASSIGN lt_j1bt007[ out_mwskz = <fs_s_nf_lin>-mwskz ] TO FIELD-SYMBOL(<fs_s_j1bt007>).
              IF sy-subrc IS INITIAL.
                DATA(lv_iva) = <fs_s_j1bt007>-in_mwskz.
              ENDIF.

              APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).

              <fs_s_item_post>-docnum   = <fs_s_nf_lin>-docnum.
              <fs_s_item_post>-itmnum   = <fs_s_nf_lin>-itmnum.
              <fs_s_item_post>-matnr    = <fs_s_nf_lin>-matnr.
              <fs_s_item_post>-cfop     = <fs_s_nf_lin_entrada>-cfop.
              <fs_s_item_post>-tax_code = lv_iva.

              " nfnet = bruto
              IF is_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_lin_entrada>-cfop ] ) ).
*                                                    OR    lv_count_zgkop005 IS NOT INITIAL                                ).
                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet * ( ( 100 - is_header-picms ) / 100 ).
                <fs_s_item_post>-tax_amount  = <fs_s_nf_lin_entrada>-nfnet - <fs_s_item_post>-item_amount.
              ELSE.
                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet .
              ENDIF.

              <fs_s_item_post>-quantity     = <fs_s_nf_lin_entrada>-menge.
              <fs_s_item_post>-unit         = <fs_s_nf_lin_entrada>-meins.
              <fs_s_item_post>-ebeln        = <fs_s_nf_lin>-ebeln.
              <fs_s_item_post>-ebelp        = <fs_s_nf_lin>-ebelp.
              <fs_s_item_post>-ref_doc      = <fs_s_nf_lin>-mblnr.
              <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin>-zeile.
              <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin>-mjahr.

              <fs_s_item_post>-docnum_out   = <fs_s_nf_lin>-docnum.
              <fs_s_item_post>-itmnum_out   = <fs_s_nf_lin>-itmnum.
              <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin>-mtart_pa.

            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    " Obtêm a nota fiscal de entrada para os registros sem pedido
    DATA(lt_j_1bnflin_wo_po) = lt_nf_saida.
    DELETE lt_j_1bnflin_wo_po WHERE ebeln IS NOT INITIAL.

    IF lt_j_1bnflin_wo_po IS NOT INITIAL.

      " Obtêm a MIGO de entrada
      SELECT mblnr,
             mjahr,
             zeile,
             mwskz
        FROM mseg
        INTO TABLE @DATA(lt_mseg_transf_entrada)
         FOR ALL ENTRIES IN @lt_j_1bnflin_wo_po
       WHERE mblnr = @lt_j_1bnflin_wo_po-mblnr
         AND mjahr = @lt_j_1bnflin_wo_po-mjahr
         AND zeile = @lt_j_1bnflin_wo_po-zeile
         AND xauto = @space.

      IF sy-subrc IS INITIAL.

        LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS INITIAL.
          ASSIGN lt_mseg_transf_entrada[ mblnr = <fs_s_nf_lin>-mblnr
                                         mjahr = <fs_s_nf_lin>-mjahr
                                         zeile = <fs_s_nf_lin>-zeile ] TO FIELD-SYMBOL(<fs_s_mseg_transf_ent>).
          CHECK sy-subrc IS INITIAL.
          <fs_s_nf_lin>-refkey_mb = |{ <fs_s_nf_lin>-mblnr }{ <fs_s_nf_lin>-mjahr }|.
          <fs_s_nf_lin>-refitm_mb = <fs_s_nf_lin>-zeile.
        ENDLOOP.

        lt_j_1bnflin_wo_po = lt_nf_saida.
        DELETE lt_j_1bnflin_wo_po WHERE ebeln     IS NOT INITIAL
                                     OR refkey_mb IS INITIAL.
        IF lt_j_1bnflin_wo_po IS NOT INITIAL.

          " Obtêm a NF de entrada de acordo com a MIGO
          SELECT docnum,
                 itmnum,
                 refkey,
                 refitm,
                 cfop,
                 mwskz,
                 netwr,
                 nfnet,
                 menge,
                 meins
            FROM j_1bnflin
            APPENDING TABLE @lt_nf_entrada
             FOR ALL ENTRIES IN @lt_j_1bnflin_wo_po
           WHERE docnum <> @lt_j_1bnflin_wo_po-docnum
             AND refkey =  @lt_j_1bnflin_wo_po-refkey_mb
             AND refitm =  @lt_j_1bnflin_wo_po-refitm_mb.

          IF sy-subrc IS INITIAL.

            LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS INITIAL.

              ASSIGN lt_nf_entrada[ refkey = <fs_s_nf_lin>-refkey_mb
                                    refitm = <fs_s_nf_lin>-refitm_mb ] TO <fs_s_nf_lin_entrada>.
              CHECK sy-subrc IS INITIAL.

              APPEND INITIAL LINE TO ct_items_post ASSIGNING <fs_s_item_post>.

              <fs_s_item_post>-docnum   = <fs_s_nf_lin>-docnum.
              <fs_s_item_post>-itmnum   = <fs_s_nf_lin>-itmnum.
              <fs_s_item_post>-matnr    = <fs_s_nf_lin>-matnr.
              <fs_s_item_post>-cfop     = <fs_s_nf_lin_entrada>-cfop.
              <fs_s_item_post>-tax_code = <fs_s_nf_lin_entrada>-mwskz.

              " nfnet = bruto
              IF is_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_lin_entrada>-cfop ] ) ).
*                                                    OR    lv_count_zgkop005 IS NOT INITIAL                                ).
                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet * ( ( 100 - is_header-picms ) / 100 ).
                <fs_s_item_post>-tax_amount  = <fs_s_nf_lin_entrada>-nfnet - <fs_s_item_post>-item_amount.
              ELSE.
                <fs_s_item_post>-item_amount = <fs_s_nf_lin_entrada>-nfnet .
              ENDIF.

              <fs_s_item_post>-quantity     = <fs_s_nf_lin_entrada>-menge.
              <fs_s_item_post>-unit         = <fs_s_nf_lin_entrada>-meins.
              <fs_s_item_post>-ebeln        = <fs_s_nf_lin>-ebeln.
              <fs_s_item_post>-ebelp        = <fs_s_nf_lin>-ebelp.
              <fs_s_item_post>-ref_doc      = <fs_s_nf_lin>-mblnr.
              <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin>-zeile.
              <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin>-mjahr.

              <fs_s_item_post>-docnum_out   = <fs_s_nf_lin>-docnum.
              <fs_s_item_post>-itmnum_out   = <fs_s_nf_lin>-itmnum.
              <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin>-mtart_pa.

            ENDLOOP.

          ELSE.

            DATA(lt_j_1bnflin_wo_po_aux) = lt_j_1bnflin_wo_po.
            SORT lt_j_1bnflin_wo_po_aux BY docnum.
            DELETE ADJACENT DUPLICATES FROM lt_j_1bnflin_wo_po_aux COMPARING docnum.

            " Caso não encontre na seleção anterior, obtêm a NF de entrada de acordo com o número, serie e CNPJ da NF de saída
            SELECT nfdoc_saida~docnum   AS docnum_saida,
                   nflin_entrada~docnum AS docnum_entrada,
                   nflin_entrada~itmnum AS itmnum_entrada,
                   nflin_entrada~cfop,
                   nflin_entrada~mwskz,
                   nflin_entrada~netwr,
                   nflin_entrada~nfnet,
                   nflin_entrada~menge,
                   nflin_entrada~meins
              FROM j_1bnfdoc AS nfdoc_saida
             INNER JOIN j_1bnfdoc AS nfdoc_entrada
                     ON ( nfdoc_entrada~direct   = '1'
                    AND nfdoc_entrada~series     = nfdoc_saida~series
                    AND nfdoc_entrada~nfenum     = nfdoc_saida~nfenum
                    AND nfdoc_entrada~cnpj_bupla = nfdoc_saida~cgc    )
             INNER JOIN j_1bnflin AS nflin_entrada
                     ON ( nflin_entrada~docnum = nfdoc_entrada~docnum )
              INTO TABLE @DATA(lt_nf_entrada_wo_po)
               FOR ALL ENTRIES IN @lt_j_1bnflin_wo_po_aux
             WHERE nfdoc_saida~docnum = @lt_j_1bnflin_wo_po_aux-docnum
               AND nfdoc_saida~cancel = @abap_false.

            IF sy-subrc IS INITIAL.

              LOOP AT lt_nf_saida ASSIGNING <fs_s_nf_lin> WHERE ebeln IS INITIAL
                                                       GROUP BY <fs_s_nf_lin>-docnum. "#EC CI_SORTLOOP

                DATA(lt_nf_entrada_wo_po_aux) = lt_nf_entrada_wo_po.
                DELETE lt_nf_entrada_wo_po_aux WHERE docnum_saida <> <fs_s_nf_lin>-docnum.
                SORT lt_nf_entrada_wo_po_aux BY itmnum_entrada.

                lv_item_counter = 0.

                LOOP AT GROUP <fs_s_nf_lin> ASSIGNING <fs_s_nf_lin_mbr>.

                  lv_item_counter = lv_item_counter + 1.

                  ASSIGN lt_nf_entrada_wo_po_aux[ lv_item_counter ] TO FIELD-SYMBOL(<fs_s_nf_entrada_wo_po>).
                  IF sy-subrc IS INITIAL.

                    APPEND INITIAL LINE TO ct_items_post ASSIGNING <fs_s_item_post>.

                    <fs_s_item_post>-docnum   = <fs_s_nf_lin_mbr>-docnum.
                    <fs_s_item_post>-itmnum   = <fs_s_nf_lin_mbr>-itmnum.
                    <fs_s_item_post>-matnr    = <fs_s_nf_lin_mbr>-matnr.
                    <fs_s_item_post>-cfop     = <fs_s_nf_entrada_wo_po>-cfop.
                    <fs_s_item_post>-tax_code = <fs_s_nf_entrada_wo_po>-mwskz.

                    " nfnet = bruto
                    IF is_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_entrada_wo_po>-cfop ] ) ).
*                                                          OR    lv_count_zgkop005 IS NOT INITIAL                                ).
                      <fs_s_item_post>-item_amount = <fs_s_nf_entrada_wo_po>-nfnet * ( ( 100 - is_header-picms ) / 100 ).
                      <fs_s_item_post>-tax_amount  = <fs_s_nf_entrada_wo_po>-nfnet - <fs_s_item_post>-item_amount.
                    ELSE.
                      <fs_s_item_post>-item_amount = <fs_s_nf_entrada_wo_po>-nfnet .
                    ENDIF.

                    <fs_s_item_post>-quantity     = <fs_s_nf_entrada_wo_po>-menge.
                    <fs_s_item_post>-unit         = <fs_s_nf_entrada_wo_po>-meins.
                    <fs_s_item_post>-ebeln        = <fs_s_nf_lin_mbr>-ebeln.
                    <fs_s_item_post>-ebelp        = <fs_s_nf_lin_mbr>-ebelp.
                    <fs_s_item_post>-ref_doc      = <fs_s_nf_lin_mbr>-mblnr.
                    <fs_s_item_post>-ref_doc_it   = <fs_s_nf_lin_mbr>-zeile.
                    <fs_s_item_post>-ref_doc_year = <fs_s_nf_lin_mbr>-mjahr.

                    <fs_s_item_post>-docnum_out   = <fs_s_nf_lin_mbr>-docnum.
                    <fs_s_item_post>-itmnum_out   = <fs_s_nf_lin_mbr>-itmnum.
                    <fs_s_item_post>-mtart_pa     = <fs_s_nf_lin_mbr>-mtart_pa.

                  ENDIF.

                ENDLOOP.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_items_post_venda_coligada.

    TYPES: BEGIN OF ty_s_ekbe_key_aux,
             ebeln      TYPE ekbe-ebeln,
             ebelp      TYPE ekbe-ebelp,
             gjahr      TYPE ekbe-gjahr,
             belnr      TYPE ekbe-belnr,
             buzei      TYPE ekbe-buzei,
             belnr_conv TYPE rseg-belnr,
             gjahr_conv TYPE rseg-gjahr,
             buzei_conv TYPE rseg-buzei,
             refkey     TYPE j_1bnflin-refkey,
             refitm     TYPE j_1bnflin-refitm,
           END OF ty_s_ekbe_key_aux,

           ty_t_ekbe_key_aux TYPE TABLE OF ty_s_ekbe_key_aux WITH DEFAULT KEY.

    CHECK it_nf_saida IS NOT INITIAL.

*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ is_header-tom_ie }| ).

    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      =    @is_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      =    @is_header-cenario.

    " Obtêm os CFOPs com Crédito de ICMS
    SELECT *
      FROM zttm_pcockpit006
      INTO TABLE @DATA(lt_zgkop015).

    DATA(lt_nf_saida) = it_nf_saida.

    DATA(lt_nf_saida_aux) = lt_nf_saida.
    SORT lt_nf_saida_aux BY ebeln.
    DELETE ADJACENT DUPLICATES FROM lt_nf_saida_aux COMPARING ebeln.

    " Obtêm o histórico do pedido
    SELECT ekbe~ebeln,
           ekbe~ebelp,
           ekbe~gjahr,
           ekbe~belnr,
           ekbe~buzei,
           ekbe~menge,
           ekbe~wrbtr,
           ekbe~shkzg,
           ekbe~cpudt,
           ekbe~cputm,
           ekpo~mwskz,
           rbkp~xrech
      FROM ekbe
     INNER JOIN ekpo
             ON ( ekpo~ebeln = ekbe~ebeln AND ekpo~ebelp = ekbe~ebelp )
     INNER JOIN rbkp
             ON ( rbkp~belnr = ekbe~belnr AND rbkp~gjahr = ekbe~gjahr )
      INTO TABLE @DATA(lt_ekbe)
       FOR ALL ENTRIES IN @lt_nf_saida_aux
     WHERE ekbe~ebeln = @lt_nf_saida_aux-ebeln
       AND ekbe~zekkn = '00'
       AND ekbe~vgabe = '2'  "Entrada de fatura
       AND ekbe~bewtp = 'Q'
       AND ekpo~loekz = @space.

    DATA(lt_ekbe_aux) = lt_ekbe.
    DELETE lt_ekbe_aux WHERE xrech IS INITIAL.
    SORT lt_ekbe_aux BY ebeln ASCENDING  ebelp ASCENDING
                        belnr DESCENDING gjahr DESCENDING buzei ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_ekbe_aux COMPARING ebeln ebelp.

    DATA(lt_ekbe_key_aux) = VALUE ty_t_ekbe_key_aux( FOR <ekbe_aux> IN lt_ekbe_aux
                                                       LET belnr_conv = CONV rseg-belnr( <ekbe_aux>-belnr )
                                                           gjahr_conv = CONV rseg-gjahr( <ekbe_aux>-gjahr )
                                                           buzei_conv = CONV rseg-buzei( <ekbe_aux>-buzei ) IN
                                                       ( ebeln      = <ekbe_aux>-ebeln
                                                         ebelp      = <ekbe_aux>-ebelp
                                                         gjahr      = <ekbe_aux>-gjahr
                                                         belnr      = <ekbe_aux>-belnr
                                                         buzei      = <ekbe_aux>-buzei
                                                         belnr_conv = belnr_conv
                                                         gjahr_conv = gjahr_conv
                                                         buzei_conv = buzei_conv
                                                         refkey     = |{ belnr_conv }{ gjahr_conv }|
                                                         refitm     = buzei_conv                     ) ).

    IF lt_ekbe_key_aux IS NOT INITIAL.

      " Obtêm os dados dos itens da fatura mais recente
      SELECT belnr,
             gjahr,
             buzei,
             lfbnr,
             lfpos,
             lfgja,
             bprme
        FROM rseg
        INTO TABLE @DATA(lt_rseg)
         FOR ALL ENTRIES IN @lt_ekbe_key_aux
       WHERE belnr = @lt_ekbe_key_aux-belnr_conv
         AND gjahr = @lt_ekbe_key_aux-gjahr_conv
         AND buzei = @lt_ekbe_key_aux-buzei_conv.

      " Obtêm a NF de entrada de acordo com a fatura mais recente
      SELECT docnum,
             itmnum,
             refkey,
             refitm,
             cfop,
             mwskz,
             netwr,
             nfnet,
             menge,
             meins
        FROM j_1bnflin
        INTO TABLE @DATA(lt_nf_entrada)
         FOR ALL ENTRIES IN @lt_ekbe_key_aux
       WHERE refkey = @lt_ekbe_key_aux-refkey
         AND refitm = @lt_ekbe_key_aux-refitm.

      SORT lt_nf_entrada BY refkey refitm.

      LOOP AT lt_nf_entrada ASSIGNING FIELD-SYMBOL(<fs_s_nf_entrada>).

        DATA(lv_item_counter) = sy-tabix.

        READ TABLE lt_ekbe_key_aux ASSIGNING FIELD-SYMBOL(<fs_s_ekbe_key_aux>) WITH KEY refkey = <fs_s_nf_entrada>-refkey
                                                                                        refitm = <fs_s_nf_entrada>-refitm.
        CHECK sy-subrc IS INITIAL.

        READ TABLE lt_rseg ASSIGNING FIELD-SYMBOL(<fs_s_rseg>) WITH KEY belnr = <fs_s_ekbe_key_aux>-belnr_conv
                                                                        gjahr = <fs_s_ekbe_key_aux>-gjahr_conv
                                                                        buzei = <fs_s_ekbe_key_aux>-buzei_conv.
        CHECK sy-subrc IS INITIAL.

        DATA(lv_menge_miro) = CONV ekpo-menge( '0.00' ).

        " Obtêm a quantidade a ser lançada
        LOOP AT lt_ekbe ASSIGNING FIELD-SYMBOL(<fs_s_ekbe>) WHERE ebeln = <fs_s_ekbe_key_aux>-ebeln
                                                              AND ebelp = <fs_s_ekbe_key_aux>-ebelp.

          CASE <fs_s_ekbe>-shkzg.
            WHEN 'S'.
              lv_menge_miro = lv_menge_miro + abs( <fs_s_ekbe>-menge ).
            WHEN 'H'.
              lv_menge_miro = lv_menge_miro - abs( <fs_s_ekbe>-menge ).
            WHEN OTHERS.
              lv_menge_miro = lv_menge_miro + abs( <fs_s_ekbe>-menge ).
          ENDCASE.

          " Obtêm o registro com os dados da fatura mais recente
          IF <fs_s_ekbe>-gjahr = <fs_s_ekbe_key_aux>-gjahr AND
             <fs_s_ekbe>-belnr = <fs_s_ekbe_key_aux>-belnr AND
             <fs_s_ekbe>-buzei = <fs_s_ekbe_key_aux>-buzei.
            DATA(ls_ekbe_miro) = <fs_s_ekbe>.
          ENDIF.

        ENDLOOP.

        APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).

        <fs_s_item_post>-docnum   = <fs_s_nf_entrada>-docnum.
        <fs_s_item_post>-itmnum   = <fs_s_nf_entrada>-itmnum.
        <fs_s_item_post>-cfop     = <fs_s_nf_entrada>-cfop.
        <fs_s_item_post>-tax_code = ls_ekbe_miro-mwskz.
        <fs_s_item_post>-quantity = lv_menge_miro.
        <fs_s_item_post>-unit     = <fs_s_nf_entrada>-meins.

        IF <fs_s_item_post>-quantity > 0.

          " nfnet = bruto
          IF is_header-vicms IS NOT INITIAL AND ( line_exists( lt_zgkop015[ cfop = <fs_s_nf_entrada>-cfop ] ) ).
*                                                OR    lv_count_zgkop005 IS NOT INITIAL                                ).
            <fs_s_item_post>-item_amount = <fs_s_nf_entrada>-nfnet * ( ( 100 - is_header-picms ) / 100 ).
            <fs_s_item_post>-tax_amount  = <fs_s_nf_entrada>-nfnet - <fs_s_item_post>-item_amount.
          ELSE.
            <fs_s_item_post>-item_amount = <fs_s_nf_entrada>-nfnet .
          ENDIF.

        ENDIF.

        <fs_s_item_post>-ebeln        = <fs_s_ekbe_key_aux>-ebeln.
        <fs_s_item_post>-ebelp        = <fs_s_ekbe_key_aux>-ebelp.
        <fs_s_item_post>-ref_doc      = <fs_s_rseg>-lfbnr.
        <fs_s_item_post>-ref_doc_it   = <fs_s_rseg>-lfpos.
        <fs_s_item_post>-ref_doc_year = <fs_s_rseg>-lfgja.
        <fs_s_item_post>-po_pr_uom    = <fs_s_rseg>-bprme.

        READ TABLE lt_nf_saida INDEX lv_item_counter ASSIGNING FIELD-SYMBOL(<fs_s_nf_saida>).
        IF sy-subrc IS NOT INITIAL AND ( lv_item_counter - 1 ) > 0.
          READ TABLE lt_nf_saida INDEX ( lv_item_counter - 1 ) ASSIGNING <fs_s_nf_saida>.
        ENDIF.

        IF sy-subrc IS INITIAL.

          <fs_s_item_post>-matnr        = <fs_s_nf_saida>-matnr.
          <fs_s_item_post>-docnum_out   = <fs_s_nf_saida>-docnum.
          <fs_s_item_post>-itmnum_out   = <fs_s_nf_saida>-itmnum.
          <fs_s_item_post>-mtart_pa     = <fs_s_nf_saida>-mtart_pa.

        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_items_post_wo_pa.

    CHECK it_nf_saida IS NOT INITIAL.

*    DATA(lv_tom_ie) = CONV j_1bstains( |%{ gs_gko_header-tom_ie }| ).

    " Verifica se para o cenário, o IVA é determinado pela empresa e filial do tomador
*    SELECT COUNT(*)
*      FROM j_1bbranch
*     INNER JOIN zgkop005
*             ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*            AND zgkop005~branch = j_1bbranch~branch )
*      INTO @DATA(lv_count_zgkop005)
*     WHERE j_1bbranch~stcd1      =    @gs_gko_header-tom_cnpj_cpf
*       AND j_1bbranch~state_insc LIKE @lv_tom_ie
*       AND zgkop005~cenario      =    @gs_gko_header-cenario.

    " Obtêm os CFOPs com Crédito de ICMS
    SELECT *
      FROM zttm_pcockpit006
      INTO TABLE @DATA(lt_zgkop015).

    DATA(lt_nf_saida_wo_pa) = it_nf_saida.

    DATA(lt_nf_saida_aux) = lt_nf_saida_wo_pa.
    SORT lt_nf_saida_aux BY docnum.
    DELETE ADJACENT DUPLICATES FROM lt_nf_saida_aux COMPARING docnum.

    " Verifica se foi realizada a entrada da NF de acordo com o número, serie e CNPJ da NF de saída
    SELECT nfdoc_saida~docnum   AS docnum_saida,
           nflin_entrada~docnum AS docnum_entrada,
           nflin_entrada~itmnum AS itmnum_entrada,
           nflin_entrada~cfop,
           nflin_entrada~mwskz,
           nflin_entrada~netwr,
           nflin_entrada~nfnet,
           nflin_entrada~menge,
           nflin_entrada~meins
      FROM j_1bnfdoc AS nfdoc_saida
     INNER JOIN j_1bnfdoc AS nfdoc_entrada
             ON ( nfdoc_entrada~direct     = '1'
            AND nfdoc_entrada~series     = nfdoc_saida~series
            AND nfdoc_entrada~nfenum     = nfdoc_saida~nfenum
            AND nfdoc_entrada~cnpj_bupla = nfdoc_saida~cgc    )
     INNER JOIN j_1bnflin AS nflin_entrada
             ON ( nflin_entrada~docnum = nfdoc_entrada~docnum )
      INTO TABLE @DATA(lt_nf_entrada)
       FOR ALL ENTRIES IN @lt_nf_saida_aux
     WHERE nfdoc_saida~docnum = @lt_nf_saida_aux-docnum
       AND nfdoc_saida~cancel = @abap_false.

    LOOP AT lt_nf_saida_wo_pa ASSIGNING FIELD-SYMBOL(<fs_s_nf_saida>).

      " Verifica se foi realizada a entrada da NF
      CHECK line_exists( lt_nf_entrada[ docnum_saida = <fs_s_nf_saida>-docnum ] ) OR
            ( is_header-cenario <> '01'                                           AND
              is_header-cenario <> '03' ).

      APPEND INITIAL LINE TO ct_items_post ASSIGNING FIELD-SYMBOL(<fs_s_item_post>).

      <fs_s_item_post>-docnum   = <fs_s_nf_saida>-docnum.
      <fs_s_item_post>-itmnum   = <fs_s_nf_saida>-itmnum.
      <fs_s_item_post>-matnr    = <fs_s_nf_saida>-matnr.
      <fs_s_item_post>-cfop     = <fs_s_nf_saida>-cfop.
      <fs_s_item_post>-tax_code = <fs_s_nf_saida>-mwskz.

      " nfnet = bruto
      IF is_header-vicms IS NOT INITIAL AND  line_exists( lt_zgkop015[ cfop = <fs_s_nf_saida>-cfop ] ).
*                                            OR    lv_count_zgkop005 IS NOT INITIAL ).
        <fs_s_item_post>-item_amount = <fs_s_nf_saida>-nfnet * ( ( 100 - is_header-picms ) / 100 ).
        <fs_s_item_post>-tax_amount  = <fs_s_nf_saida>-nfnet - <fs_s_item_post>-item_amount.
      ELSE.
        <fs_s_item_post>-item_amount = <fs_s_nf_saida>-nfnet .
      ENDIF.

      <fs_s_item_post>-quantity     = <fs_s_nf_saida>-menge.
      <fs_s_item_post>-unit         = <fs_s_nf_saida>-meins.
      <fs_s_item_post>-ebeln        = <fs_s_nf_saida>-ebeln.
      <fs_s_item_post>-ebelp        = <fs_s_nf_saida>-ebelp.
      <fs_s_item_post>-ref_doc      = <fs_s_nf_saida>-mblnr.
      <fs_s_item_post>-ref_doc_it   = <fs_s_nf_saida>-zeile.
      <fs_s_item_post>-ref_doc_year = <fs_s_nf_saida>-mjahr.

      <fs_s_item_post>-docnum_out   = <fs_s_item_post>-docnum.
      <fs_s_item_post>-itmnum_out   = <fs_s_item_post>-itmnum.
      <fs_s_item_post>-mtart_pa     = <fs_s_nf_saida>-mtart_pa.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_iva_detailed.

    DATA: ls_zgkop016 TYPE zttm_pcockpit005.

    IF is_header-tpdoc <> 'NFS'.
      SELECT SINGLE *
        FROM zttm_pcockpit005
        INTO @ls_zgkop016
       WHERE regio_from = @is_header-emit_uf
         AND regio_to   = @is_header-dest_uf
         AND burks      = @is_header-bukrs
         AND vstel      = @is_header-branch.
    ENDIF.

    rt_iva = CORRESPONDING #( it_items_post MAPPING mwskz = tax_code ).
    IF ls_zgkop016 IS INITIAL.

      " Obtêm as configurações do IVA de acordo com o cenário e rateio
      SELECT SINGLE *
        FROM zttm_pcockpit011
        INTO @DATA(ls_zgkop009)
        WHERE cenario = @is_header-cenario
          AND rateio  = 'R01'.

      " Casos onde não há ICMS destacado no documento,
      IF is_header-vicms IS INITIAL
     AND is_header-tpdoc <> 'NFS'.

        LOOP AT rt_iva ASSIGNING FIELD-SYMBOL(<fs_s_iva>).

          ASSIGN it_items_post[ docnum = <fs_s_iva>-docnum
                                itmnum = <fs_s_iva>-itmnum ] TO FIELD-SYMBOL(<fs_s_item_post>).
          CHECK sy-subrc IS INITIAL.

          FREE: <fs_s_iva>-mwskz.

          IF <fs_s_item_post>-mtart_pa IS INITIAL.
            <fs_s_iva>-mwskz = ls_zgkop009-gmwskz.
          ELSE.
            <fs_s_iva>-mwskz = ls_zgkop009-pmwskz.
          ENDIF.
        ENDLOOP.

      ELSE.

        " Para Notas Fiscais de serviço, o IVA é determinado de forma Unificada
        IF is_header-tpdoc = 'NFS'.

*          DATA(lv_iva) = get_iva_unified( iv_saknr = iv_saknr ).
          DATA(lv_iva) = get_iva_unified( iv_saknr      = iv_saknr
                                          is_header     = is_header
                                          it_items_post = it_items_post ).

          LOOP AT rt_iva ASSIGNING <fs_s_iva>.

            <fs_s_iva>-mwskz = lv_iva.

          ENDLOOP.

        ELSE.

          " Determinação do IVA
          CASE is_header-cenario.

              " Transferência e venda coligada, realizam a busca do De x Para de IVA
            WHEN '01'
              OR '03'.

              SELECT *
                FROM zttm_pcockpit003
                INTO TABLE @DATA(lt_zgkop004)
                 FOR ALL ENTRIES IN @rt_iva
               WHERE dmwskz = @rt_iva-mwskz.

              " Demais casos, realiza a busca do IVA de acordo com o cenário e tipo de rateio
            WHEN OTHERS.

              SELECT SINGLE *
                FROM zttm_pcockpit011
                INTO @DATA(ls_zgko009)
               WHERE cenario =  @is_header-cenario
                 AND rateio  =  'R01'
                 AND dmwskz  <> @space
                 AND pmwskz  <> @space.

              lv_iva = COND #( WHEN is_header-vicms IS NOT INITIAL
                                    THEN ls_zgko009-dmwskz
                                    ELSE ls_zgko009-pmwskz ).

          ENDCASE.

          DATA(lv_tom_ie) = CONV j_1bstains( |%{ is_header-tom_ie }| ).

          " Obtêm o IVA por Empresa/Filial e Cenário
          SELECT SINGLE *
            FROM zttm_pcockpit005
            INTO @DATA(ls_pcockpit005)
           WHERE regio_from EQ @is_header-emit_uf
             AND regio_to   EQ @is_header-rem_uf
             AND incoterm   EQ 'FOB'
             AND burks      EQ @is_header-bukrs
             AND vstel      EQ @is_header-vstel.

          LOOP AT rt_iva ASSIGNING <fs_s_iva>.

            ASSIGN it_items_post[ docnum = <fs_s_iva>-docnum
                                  itmnum = <fs_s_iva>-itmnum ] TO <fs_s_item_post>.
            CHECK sy-subrc IS INITIAL.

            TRY.
                IF <fs_s_item_post>-mtart_pa IS INITIAL.

                  <fs_s_iva>-mwskz = ls_zgkop009-gmwskz.

                ELSEIF ls_pcockpit005-mwskz IS NOT INITIAL.

                  <fs_s_iva>-mwskz = ls_pcockpit005-mwskz.

                ELSE.
                  ASSIGN lt_zgkop004[ cfop   = <fs_s_item_post>-cfop(4)
                                      dmwskz = <fs_s_iva>-mwskz         ] TO FIELD-SYMBOL(<fs_s_zgkop004>).
                  IF sy-subrc IS INITIAL.

                    <fs_s_iva>-mwskz = <fs_s_zgkop004>-pmwskz.

                  ELSE.

                    ASSIGN lt_zgkop004[ dmwskz = <fs_s_iva>-mwskz ] TO <fs_s_zgkop004>.
                    IF sy-subrc IS INITIAL.

                      <fs_s_iva>-mwskz = <fs_s_zgkop004>-pmwskz.

                    ELSE.

                      IF lv_iva IS NOT INITIAL.

                        <fs_s_iva>-mwskz = lv_iva.

                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.

              CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
            ENDTRY.

          ENDLOOP.
        ENDIF.
      ENDIF.

    ELSE.
      LOOP AT rt_iva ASSIGNING FIELD-SYMBOL(<fs_s_iva_aux>).
        <fs_s_iva_aux>-mwskz = ls_zgkop016-mwskz.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD get_iva_from_info_record.


  ENDMETHOD.


  METHOD get_iva_unified.

    IF is_header-tpdoc <> 'NFS'.
      SELECT SINGLE mwskz
        FROM zttm_pcockpit005
        INTO @rv_iva
       WHERE regio_from = @is_header-emit_uf
         AND regio_to   = @is_header-dest_uf
         AND burks      = @is_header-bukrs
         AND vstel      = @is_header-branch.
    ENDIF.

    IF rv_iva IS INITIAL.

      IF is_header-vicms IS INITIAL
     AND is_header-tpdoc <> 'NFS'.

        SELECT SINGLE pmwskz
          FROM zttm_pcockpit011
          INTO @rv_iva
         WHERE cenario =  @is_header-cenario
           AND rateio  =  'R02'
           AND pmwskz  <> @space.

*        IF sy-subrc IS NOT INITIAL.
*
*          " Não foi possível determinar o IVA para a Nota Fiscal &.
*          RAISE EXCEPTION TYPE zcxtm_gko_process
*            EXPORTING
*              textid   = zcxtm_gko_process=>for_nfs_iva_not_found
*              gv_msgv1 = |{ IS_HEADER-cenario } { 'R02' }|.
*
*        ENDIF.

      ELSE.

        IF is_header-tpdoc <> 'NFS'.

*          DATA(lv_tom_ie) = CONV j_1bstains( |%{ IS_HEADER-tom_ie }| ).
*
*          " Obtêm o IVA por Empresa/Filial e Cenário
*          SELECT SINGLE zgkop005~mwskz
*            FROM j_1bbranch
*           INNER JOIN zgkop005
*                   ON ( zgkop005~bukrs  = j_1bbranch~bukrs
*                  AND zgkop005~branch = j_1bbranch~branch )
*            INTO @re_iva
*           WHERE j_1bbranch~stcd1      =    @IS_HEADER-tom_cnpj_cpf
*             AND j_1bbranch~state_insc LIKE @lv_tom_ie
*             AND zgkop005~cenario      =    @IS_HEADER-cenario.
*
*          CHECK rv_iva IS INITIAL.

        ENDIF.

        " Para todos os casos, realiza a busca no registro INFO
        rv_iva = get_iva_from_info_record( it_items_post = it_items_post
                                           is_header     = is_header
                                           iv_saknr      = iv_saknr ).


        CHECK rv_iva IS INITIAL.

        IF is_header-tpdoc = 'NFS'.

          SELECT SINGLE mwskz
            FROM zttm_pcockpit010
            INTO rv_iva
           WHERE saknr  = iv_saknr
             AND rem_uf = is_header-rem_uf
             AND mwskz  <> space.

          IF sy-subrc IS NOT INITIAL.

            SELECT SINGLE mwskz
              FROM zttm_pcockpit010
              INTO rv_iva
             WHERE saknr  =  iv_saknr
               AND rem_uf =  space
               AND mwskz  <> space.

          ENDIF.

*          IF sy-subrc IS NOT INITIAL.
*
*            " Não foi possível determinar o IVA para a Nota Fiscal &.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                textid   = zcxtm_gko_process=>for_nfs_iva_not_found
*                gv_msgv1 = |{ iv_saknr } { is_header-rem_uf }|.
*
*          ENDIF.

        ELSE.

          SELECT SINGLE *
            FROM zttm_pcockpit011
            INTO @DATA(ls_zgkop009)
           WHERE cenario =  @is_header-cenario
             AND rateio  =  'R02'
             AND dmwskz  <> @space
             AND pmwskz  <> @space.

*          IF sy-subrc IS NOT INITIAL.
*
*            " Para o tipo de rateio &, não foi possível determinar o IVA.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                textid   = zcxtm_gko_process=>for_rateio_iva_not_found
*                gv_msgv1 = CONV #( is_header-rateio ).
*
*          ENDIF.

          IF is_header-vicms IS NOT INITIAL.
            rv_iva = ls_zgkop009-dmwskz.
          ELSE.
            rv_iva = ls_zgkop009-pmwskz.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD trata_caracter_especial.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = iv_text
      IMPORTING
        outtext = rv_text.

    IF rv_text IS INITIAL.
      rv_text = iv_text.
    ENDIF.

  ENDMETHOD.


  METHOD add_lc_observacao_nf_miro.
    CHECK is_nfheader-nftype = gc_nftype_servico.

    DATA(lt_nf_items) = it_nfitems.

    DELETE lt_nf_items WHERE reftyp NE 'LI'.
    DELETE lt_nf_items WHERE xped IS INITIAL.

    CHECK lt_nf_items IS NOT INITIAL.
    DATA(lr_pedido) = VALUE rsis_t_range( FOR ls_nfitem IN lt_nf_items ( sign = 'I' option = 'EQ' low = ls_nfitem-xped ) ).

    SELECT br_ncm
      FROM i_purchaseorderitem
     WHERE \_purchaseorder-purchaseordertype = @gc_pedido_tm
       AND purchaseorder IN @lr_pedido
      INTO TABLE @DATA(lt_ncm_po).

    SORT lt_ncm_po BY br_ncm.
    DELETE ADJACENT DUPLICATES FROM lt_ncm_po COMPARING br_ncm.

    LOOP AT lt_ncm_po INTO DATA(ls_ncm_po).        "#EC CI_LOOP_INTO_WA
      IF cv_observacao IS INITIAL.
        cv_observacao = ls_ncm_po-br_ncm.
      ELSE.
        cv_observacao = |{ cv_observacao },{ ls_ncm_po-br_ncm }|.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_log.

    TRY.
        IF it_return IS NOT INITIAL.
          DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey    = iv_acckey
                                                        iv_tpprocess = zcltm_gko_process=>gc_tpprocess-automatico ).
          IF line_exists( it_return[ type = if_xo_const_message=>error ] ).
            lr_gko_process->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_fat_frete
                                                  it_bapi_ret = it_return ).
          ELSE.
            lr_gko_process->add_to_log( EXPORTING it_bapi_ret = it_return ).
          ENDIF.
          lr_gko_process->persist( ).
          lr_gko_process->free( ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD determina_parceiro_pedido.
    SELECT SINGLE regio
      FROM lfa1
      INTO @DATA(lv_regio_transportadora)
     WHERE lifnr = @is_tor_root-tspid.

    CHECK sy-subrc IS INITIAL.

    SELECT SINGLE regio
      FROM lfa1
      INTO @DATA(lv_regio_emissor)
     WHERE lifnr = @is_tor_root-shipperid.

    CHECK sy-subrc IS INITIAL.

    IF lv_regio_emissor <> lv_regio_transportadora.
      TRY.
          ct_po_partner[ partnerdesc = 'FM' ]-buspartno = is_tor_root-shipperid.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDIF.


  ENDMETHOD.


  METHOD determina_ncm_servico.
    CHECK it_po_services IS NOT INITIAL.

    SELECT asnum, taxtariffcode
      FROM asmd
      INTO TABLE @DATA(lt_ncm_servico)
   FOR ALL ENTRIES IN @it_po_services
     WHERE asnum = @it_po_services-service.

    CHECK sy-subrc IS INITIAL.

    LOOP AT ct_po_items ASSIGNING FIELD-SYMBOL(<fs_item>).
      DATA(lv_item) = CONV extrow( |{ <fs_item>-po_item ALPHA = IN }| ).

      READ TABLE it_po_services ASSIGNING FIELD-SYMBOL(<fs_service>) WITH KEY ext_line = lv_item.

      IF sy-subrc IS INITIAL.
        <fs_item>-bras_nbm = lt_ncm_servico[ asnum = <fs_service>-service ]-taxtariffcode.
        ct_po_itemsx[ po_item = <fs_item>-po_item ]-bras_nbm = abap_true.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD determina_service.

    DATA: lv_count TYPE numc1.

    CHECK it_charge_element[] IS NOT INITIAL.

    SELECT trcharg_catcd,
           trcharg_subcatcd,
           trcharg_typecd,
           service
      FROM tcm_d_tc_srv_map
       FOR ALL ENTRIES IN @it_charge_element
     WHERE trcharg_catcd    = @it_charge_element-chrgcatcd021_i
       AND trcharg_subcatcd = @it_charge_element-tcclass037
       AND trcharg_typecd   = @it_charge_element-tcet084
      INTO TABLE @DATA(lt_map_services).

    IF sy-subrc IS INITIAL.
      SORT lt_map_services BY trcharg_catcd
                              trcharg_subcatcd
                              trcharg_typecd.
    ENDIF.

    SORT ct_po_services BY ext_line.

    CLEAR lv_count.

    LOOP AT ct_po_services ASSIGNING FIELD-SYMBOL(<ls_ct_po_services>).

      IF <ls_ct_po_services>-subpckg_no IS INITIAL.
        IF <ls_ct_po_services>-gr_price IS INITIAL.
          DELETE TABLE ct_po_services FROM <ls_ct_po_services>.
          CONTINUE.
        ENDIF.

        IF <ls_ct_po_services>-ext_serv EQ 'FRETE_SAIDA'
        OR <ls_ct_po_services>-ext_serv EQ 'FRETE_ENTRADA'
        OR <ls_ct_po_services>-ext_serv EQ 'FRETE_TRANSFER'.
          <ls_ct_po_services>-external_item_id = 'NORMAL'.

          <ls_ct_po_services>-service = <ls_ct_po_services>-service(17) && lv_count.
          ADD 1 TO lv_count.

        ELSE.

          <ls_ct_po_services>-external_item_id = <ls_ct_po_services>-ext_serv.

          IF line_exists( it_charge_element[ tcet084 = 'FRETE_SAIDA' ] ).

            DATA(ls_charge_element) = it_charge_element[ tcet084 = 'FRETE_SAIDA' ].

          ELSEIF line_exists( it_charge_element[ tcet084 = 'FRETE_ENTRADA' ] ).

            ls_charge_element = it_charge_element[ tcet084 = 'FRETE_ENTRADA' ].

          ELSEIF line_exists( it_charge_element[ tcet084 = 'FRETE_TRANSFER' ] ).

            ls_charge_element = it_charge_element[ tcet084 = 'FRETE_TRANSFER' ].

          ENDIF.

          IF ls_charge_element IS NOT INITIAL.

            READ TABLE lt_map_services ASSIGNING FIELD-SYMBOL(<fs_map_services>)
                                                     WITH KEY trcharg_catcd    = ls_charge_element-chrgcatcd021_i
                                                              trcharg_subcatcd = ls_charge_element-tcclass037
                                                              trcharg_typecd   = ls_charge_element-tcet084
                                                              BINARY SEARCH.
            IF sy-subrc IS INITIAL.
              <ls_ct_po_services>-service = <fs_map_services>-service(17) && lv_count.
              ADD 1 TO lv_count.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

    ev_serv_def = abap_true.

  ENDMETHOD.


  METHOD determina_iva_cte_services_03.

    TYPES:
      BEGIN OF ty_cfop_nf,
        docnum  TYPE j_1bdocnum,
        itmnum  TYPE j_1bitmnum,
        cfop    TYPE j_1bcfop,
        vlritem TYPE netwr,
        mwskz   TYPE mwskz,
      END OF ty_cfop_nf,

      BEGIN OF ty_cfop_matkl_nf,
        docnum  TYPE j_1bdocnum,
        itmnum  TYPE j_1bitmnum,
        cfop    TYPE j_1bcfop,
        matkl   TYPE matkl,
        vlritem TYPE netwr,
        mwskz   TYPE mwskz,
      END OF ty_cfop_matkl_nf,

      BEGIN OF ty_cfop_iva_vlr,
        cfop       TYPE j_1bcfop,
        mwskz_lips TYPE mwskz,
        mwskz_btax TYPE mwskz,
        mwskz_tb03 TYPE mwskz,
        valor      TYPE netwr,
      END OF ty_cfop_iva_vlr,

      BEGIN OF ty_para_iva_vlr,
        mwskz_para TYPE mwskz,
        valor      TYPE netwr,
      END OF ty_para_iva_vlr.

    DATA:
      lt_cfop_nf       TYPE TABLE OF ty_cfop_nf,
      lt_cfop_matkl_nf TYPE TABLE OF ty_cfop_matkl_nf,

      lt_cfop_iva_vlr  TYPE TABLE OF ty_cfop_iva_vlr,
      ls_cfop_iva_vlr  LIKE LINE OF lt_cfop_iva_vlr,

      lt_para_iva_vlr  TYPE TABLE OF ty_para_iva_vlr,
      ls_para_iva_vlr  LIKE LINE OF lt_para_iva_vlr.

    DATA(lo_stvarv) = NEW zcacl_stvarv( ).

    DATA:
      lt_refkey TYPE zctgtm_cargo_refkey,
      ls_refkey TYPE j_1brefkey.

    DATA: lv_remessa TYPE vbeln,
          lv_vstel   TYPE vstel.

    DATA:
      lv_bp_rem      TYPE partner,
      lv_bp_dest     TYPE partner,
      ls_cfop_params TYPE j_1bao,
      lv_cfop_nf     TYPE j_1bcfop,
      lv_totnf       TYPE netwr,
      lv_fator       TYPE bapigrprice,
      lv_nitemped    TYPE j_1bnflin-nitemped.

    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = it_sfir_item_data    " Main Area: SFIR Item
        it_stage_loc_data = it_stage_loc_data    " Stages
        it_postal_addr    = it_postal_addr       " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
        it_tor_stop       = it_tor_stop
      IMPORTING
        es_loc_origem     = DATA(ls_loc_origem)  " Node structure for postal address data - internal
        es_loc_dest       = DATA(ls_loc_dest) ). " Node structure for postal address data - internal

    CHECK ls_loc_origem IS NOT INITIAL AND
          ls_loc_dest   IS NOT INITIAL.

*    lv_remessa = iv_btd_id+25(10).
*    SELECT SINGLE vbeln,
*                  vstel,
*                  kunnr
*      FROM likp
*      INTO @DATA(ls_likp)
*     WHERE vbeln EQ @lv_remessa.

* BEGIN OF INSERT - JWSILVA - 16.03.2023
*    ls_likp-kunnr = COND #( WHEN ls_likp-kunnr IS NOT INITIAL
*                            THEN ls_likp-kunnr
*                            ELSE is_tor_root-consigneeid ).
* END OF INSERT - JWSILVA - 16.03.2023

*    CHECK sy-subrc IS INITIAL.

*    SELECT vbeln,
*           vgbel,
*           vgpos,
*           j_1bcfop,
*           j_1btxsdc
*      FROM lips
*      INTO TABLE @DATA(lt_lips)
*      WHERE vbeln EQ @lv_remessa.

    " Seleção do IVA na Tabela ZTTM_PCOCKPIT005
    DATA(lv_tor_id) =   |{ is_tor_root-tor_id  ALPHA = IN }|.

    " Selecionar o CFOP das notas transportadas
    SELECT SINGLE cenario,
                  picms,
                  vicms,
                  cfop
      INTO (@DATA(lv_cenario),
            @DATA(lv_picms),
            @DATA(lv_vicms),
            @DATA(lv_cfop))
      FROM zttm_gkot001
      WHERE tor_id = @lv_tor_id
        AND acckey = @is_sfir_root-zzacckey.

    CHECK lv_cenario = '03'.


    " Determina Produto Acabado
    DATA(lv_prod_acabado) = determina_prod_acabado( it_tor_item = it_tor_item ).


    " seleção na tabela de IVA detalhado (ZTTM_PCOCKPIT003) considerando CFOP/ Cenário / IVA de (NF) de entrada no destino / IVA para (frete).
    DATA(lt_mat) = it_tor_item.
*    DELETE lt_mat WHERE base_btd_id <> iv_btd_id.
    DELETE lt_mat WHERE item_cat <> 'PRD'.

    SELECT *
      FROM zttm_pcockpit011
      INTO TABLE @DATA(lt_pcockpit011)
      WHERE cenario  EQ @lv_cenario
        AND incoterm EQ 'FOB'
        AND rateio   EQ 'R01'.                       "#EC CI_SEL_NESTED

*    IF lt_mat[] IS NOT INITIAL.

    SELECT
      acckey,
      acckey_ref
      INTO TABLE @DATA(lt_gkot003)
      FROM zttm_gkot003
      WHERE acckey = @is_sfir_root-zzacckey.

    IF sy-subrc IS INITIAL.

      SELECT
        accesskey,
        purchaseorder
        INTO TABLE @DATA(lt_po_ref)
        FROM zi_tm_vh_frete_identify_fo
        FOR ALL ENTRIES IN @lt_gkot003
        WHERE accesskey = @lt_gkot003-acckey_ref
          AND deliverydocumenttype = 'EL'.

    ENDIF.

    IF lt_po_ref IS NOT INITIAL.

      SELECT
        ebeln,
        ebelp,
        mwskz
      INTO TABLE @DATA(lt_ekpo)
      FROM ekpo
      FOR ALL ENTRIES IN @lt_po_ref
      WHERE ebeln = @lt_po_ref-purchaseorder.

      IF sy-subrc IS INITIAL.
        DATA(lv_po) = lt_ekpo[ 1 ]-ebeln.
      ENDIF.

    ENDIF.

    lv_remessa = iv_btd_id+25(10).

    SELECT SINGLE vbeln,
                  vstel,
                  kunnr
      FROM likp
      INTO @DATA(ls_likp)
     WHERE vbeln EQ @lv_remessa.

    SELECT vbeln,
           posnr,
           matnr,
           vgbel,
           vgpos,
           matkl,
           j_1bcfop,
           j_1btxsdc,
           uecha
      FROM lips
      INTO TABLE @DATA(lt_lips)
      WHERE vbeln EQ @lv_remessa.

    SORT lt_lips BY vbeln
                    posnr.

    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>) WHERE uecha IS NOT INITIAL.
      READ TABLE lt_lips TRANSPORTING NO FIELDS WITH KEY vbeln = <fs_lips>-vbeln
                                                         posnr = <fs_lips>-uecha BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        DELETE lt_lips INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

*    ENDIF.

    SELECT * INTO TABLE @DATA(lt_vbkd)
      FROM vbkd
      WHERE bstkd = @lv_po.

    IF lt_vbkd IS NOT INITIAL.

      DATA(lv_ov) = lt_vbkd[ 1 ]-vbeln.

      SELECT * INTO TABLE @DATA(lt_faturas)
        FROM vbfa
        WHERE vbelv   = @lv_ov
          AND vbtyp_n = 'M'.

      IF lt_faturas IS NOT INITIAL.

        ls_refkey = lt_faturas[ 1 ]-vbeln.
        APPEND ls_refkey TO lt_refkey.

        SELECT *
           FROM j_1bnflin
          INTO TABLE @DATA(lt_lin_1)
          FOR ALL ENTRIES IN @lt_refkey
          WHERE refkey = @lt_refkey-table_line.

        IF sy-subrc IS INITIAL.

          DATA(lv_docnum) = lt_lin_1[ 1 ]-docnum.
*
          SELECT SINGLE *
             FROM j_1bnfdoc
            INTO @DATA(ls_doc)
            WHERE docnum = @lv_docnum.

          IF sy-subrc IS INITIAL.

* BEGIN OF INSERT - JWSILVA - 23.05.2023
            me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter) ).

            IF ls_parameter-nftype_cte_fob IS NOT INITIAL.
* END OF INSERT - JWSILVA - 23.05.2023

              SELECT SINGLE
                j_1bbranch
                INTO @DATA(lv_locneg)
                FROM t001w
                WHERE kunnr = @ls_doc-parid.

              SELECT SINGLE *
                FROM j_1bnfdoc
                INTO @ls_doc
* BEGIN OF CHANGE - JWSILVA - 23.05.2023
*                WHERE nftype = 'YA'
                WHERE nftype IN @ls_parameter-nftype_cte_fob
* BEGIN OF CHANGE - JWSILVA - 23.05.2023
                  AND nfenum = @ls_doc-nfenum
                  AND branch = @lv_locneg.

              IF sy-subrc IS INITIAL.

                SELECT *
                  FROM j_1bnflin
                  INTO TABLE @DATA(lt_lin_2)
                 WHERE docnum = @ls_doc-docnum.

              ENDIF.
* BEGIN OF INSERT - JWSILVA - 23.05.2023
            ENDIF.
* END OF INSERT - JWSILVA - 23.05.2023
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    IF  lt_ekpo IS NOT INITIAL.

      SELECT *
        INTO TABLE @DATA(lt_pcockpit003)
        FROM zttm_pcockpit003
        FOR ALL ENTRIES IN @lt_ekpo
        WHERE dmwskz  = @lt_ekpo-mwskz.               "#EC CI_ALL_FIELD

    ENDIF.

    SELECT *
      FROM zttm_pcockpit005
      INTO TABLE @DATA(lt_pcockpit005)
     WHERE regio_from EQ @ls_loc_origem-region
       AND regio_to   EQ @ls_loc_dest-region
       AND incoterm   EQ 'FOB'
       AND burks      EQ @is_po_header-comp_code
       AND vstel      EQ @ls_likp-vstel.


    LOOP AT lt_lin_2 ASSIGNING FIELD-SYMBOL(<fs_lin>).

      DATA(ls_cfop_nf) = VALUE ty_cfop_nf( docnum  = lv_docnum
*                                             itmnum  = <fs_lin>-itmnum
                                           vlritem = <fs_lin>-nfnett
                                           cfop    = <fs_lin>-cfop ).


      lv_totnf = lv_totnf + <fs_lin>-nfnett.

      COLLECT ls_cfop_nf INTO lt_cfop_nf.

      DATA(ls_cfop_matkl_nf) = VALUE ty_cfop_matkl_nf( docnum  = lv_docnum
*                                                        itmnum  = <fs_lin>-itmnum
                                                       vlritem = <fs_lin>-nfnett
                                                       cfop    = <fs_lin>-cfop
                                                       matkl   = <fs_lin>-matkl ).

      COLLECT ls_cfop_matkl_nf INTO lt_cfop_matkl_nf.

    ENDLOOP.

    DATA(lt_mat_nf) = lt_lin_2[].

    IF lt_mat IS NOT INITIAL.

      SELECT
        matnr,
        matkl
        INTO TABLE @DATA(lt_tp_mat)
        FROM mara
        FOR ALL ENTRIES IN @lt_mat_nf
        WHERE matnr = @lt_mat_nf-matnr.                 "#EC CI_SEL_DEL

      SORT lt_tp_mat BY matkl.
      DELETE ADJACENT DUPLICATES FROM lt_tp_mat COMPARING matkl.

      IF lt_tp_mat[] IS NOT INITIAL.

        SELECT SINGLE werks,
                      kunnr
          FROM t001w
          INTO @DATA(ls_t001w)
          WHERE kunnr EQ @ls_likp-kunnr.

        IF sy-subrc IS INITIAL.

          SELECT
            vstel,
            mtart,
            mwskz
            INTO TABLE @DATA(lt_pcockpit018)
            FROM zttm_pcockpit018
            FOR ALL ENTRIES IN @lt_tp_mat
            WHERE vstel  = @ls_t001w-werks
              AND mtart  = @lt_tp_mat-matkl.

        ENDIF.
      ENDIF.
    ENDIF.

    SELECT cfop
      INTO TABLE @DATA(lt_cfop_param)
      FROM zttm_pcockpit006
      FOR ALL ENTRIES IN @lt_cfop_nf
      WHERE cfop = @lt_cfop_nf-cfop.

*    loop at lt_lips into data(ls_lips).

*        READ TABLE lt_pcockpit003 INTO DATA(ls_pcockpit003) WITH KEY dmwskz = ls_j_1bt007-in_mwskz.
*
*        IF sy-subrc IS INITIAL.

    LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<ls_ekpo>).

      READ TABLE lt_pcockpit003 INTO DATA(ls_pcockpit003) WITH KEY dmwskz = <ls_ekpo>-mwskz.

      IF sy-subrc IS INITIAL.

        LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<ls_faturas>) WHERE posnv = <ls_ekpo>-ebelp." WITH KEY vbelv = ls_lips-vbeln
          "          posnv = ls_lips-posnr.

*          IF sy-subrc IS INITIAL.
*          LOOP AT lt_lin INTO DATA(ls_lin) WHERE cfop = ls_lips-j_1bcfop.
          READ TABLE lt_lin_1 INTO DATA(ls_lin_1) WITH KEY refkey = <ls_faturas>-vbeln
                                                           refitm = <ls_faturas>-posnn.

          READ TABLE lt_lin_2 INTO DATA(ls_lin) WITH KEY itmnum = ls_lin_1-itmnum.

          IF sy-subrc IS INITIAL.
            ls_cfop_iva_vlr-mwskz_tb03 = ls_pcockpit003-dmwskz.
            ls_cfop_iva_vlr-mwskz_lips = <ls_ekpo>-mwskz.
            ls_cfop_iva_vlr-valor      = ls_lin-nfnett.
*            ls_cfop_iva_vlr-cfop       = ls_lin-cfop.
            COLLECT ls_cfop_iva_vlr INTO lt_cfop_iva_vlr.

            ls_para_iva_vlr-mwskz_para = ls_pcockpit003-pmwskz.
            ls_para_iva_vlr-valor      = ls_lin-nfnett.
            COLLECT ls_para_iva_vlr INTO lt_para_iva_vlr.

*            ENDLOOP.
          ENDIF.

*          ENDIF.
*        ENDIF.
        ENDLOOP.
      ENDIF.

    ENDLOOP.


    DATA(lt_serv_aux) = ct_po_services.

    DELETE lt_serv_aux WHERE ext_line IS INITIAL.

    LOOP AT lt_cfop_nf ASSIGNING FIELD-SYMBOL(<fs_cfop_nf>).

      READ TABLE lt_cfop_param INTO DATA(ls_cfop_param) WITH KEY cfop = <fs_cfop_nf>-cfop.

      IF sy-subrc IS NOT INITIAL.
        <fs_cfop_nf>-mwskz = '0I'.
      ENDIF.

    ENDLOOP.

    DATA(lv_gr_price) = lt_serv_aux[ 1 ]-gr_price.

    DATA(lt_cfop_nf_aux) = lt_cfop_nf.

    DELETE lt_cfop_nf_aux WHERE mwskz IS INITIAL.

    LOOP AT lt_cfop_nf_aux ASSIGNING FIELD-SYMBOL(<ls_cfop_nf>).

      CHECK <ls_cfop_nf>-mwskz IS NOT INITIAL.

      DATA(lv_tabix_srv) = sy-tabix.

      READ TABLE lt_cfop_param INTO ls_cfop_param WITH KEY cfop = <ls_cfop_nf>-cfop.

      IF sy-subrc IS NOT INITIAL.
        DATA(lv_iva) = '0I'.
      ELSE.

        READ TABLE lt_pcockpit011 INTO DATA(ls_pcockpit011) INDEX 1.

        IF sy-subrc IS INITIAL                   AND
           ( ls_pcockpit011-dmwskz IS NOT INITIAL  OR
             ls_pcockpit011-gmwskz IS NOT INITIAL  OR
             ls_pcockpit011-pmwskz IS NOT INITIAL  ).

          IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado

            lv_iva = ls_pcockpit011-gmwskz.

          ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
                 lv_vicms IS NOT INITIAL.

            lv_iva = ls_pcockpit011-dmwskz.

          ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
                 lv_vicms IS INITIAL.

            lv_iva = ls_pcockpit011-pmwskz.

          ENDIF.

        ELSE.

          READ TABLE lt_pcockpit005 INTO DATA(ls_pcockpit005) INDEX 1.

          IF sy-subrc IS INITIAL                   AND
             ls_pcockpit005-mwskz IS NOT INITIAL.
            lv_iva = ls_pcockpit005-mwskz.
          ELSE.

          ENDIF.

        ENDIF.

      ENDIF.

      READ TABLE lt_serv_aux ASSIGNING FIELD-SYMBOL(<fs_po_services>) INDEX lv_tabix_srv.

      IF sy-subrc IS INITIAL.

        DATA(lv_gr_price_itm) = <fs_po_services>-gr_price.

*        IF lv_iva IS INITIAL.
        IF <ls_cfop_nf>-mwskz IS INITIAL.

*          READ TABLE ct_po_items INTO DATA(ls_po_items) INDEX 1. "WITH KEY
*          READ TABLE lt_tp_mat INTO DATA(ls_tp_mat) WITH KEY matnr = ls_po_items-material.
*          READ TABLE lt_pcockpit018 INTO DATA(ls_pcockpit018) WITH KEY mtart = ls_tp_mat-matkl.
*
*          IF sy-subrc IS INITIAL                   AND
*             ls_pcockpit018-mwskz IS NOT INITIAL.
*            lv_iva = ls_pcockpit018-mwskz.
*          ELSE.
*            READ TABLE lt_pcockpit003 INTO DATA(ls_pcockpit003) WITH KEY cfop = <ls_cfop_nf>-cfop.
*            IF sy-subrc IS INITIAL.
*              DATA(lv_iva) = ls_pcockpit003-dmwskz.
*            ENDIF.
*          ENDIF.

        ELSE.
          lv_iva = <ls_cfop_nf>-mwskz.
        ENDIF.

        IF lv_iva IS NOT INITIAL.
          <fs_po_services>-tax_code = lv_iva.
          ev_iva = lv_iva.

          DATA(ls_po_services) = <fs_po_services>.

          lv_fator = ( <ls_cfop_nf>-vlritem / lv_totnf ).
          <fs_po_services>-gr_price = lv_gr_price_itm * lv_fator.

          MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
           WHERE pckg_no  = <fs_po_services>-pckg_no   AND
                 line_no  = <fs_po_services>-line_no   AND
                 ext_line = <fs_po_services>-ext_line.

        ENDIF.


      ELSE.

        ls_po_services-line_no  = ls_po_services-line_no  + 1.
        ls_po_services-ext_line = ls_po_services-ext_line + 10.

*        IF lv_iva IS INITIAL.
        IF <ls_cfop_nf>-mwskz IS INITIAL.

*          READ TABLE ct_po_items INTO ls_po_items INDEX 1. "WITH KEY
*          READ TABLE lt_tp_mat INTO ls_tp_mat WITH KEY matnr = ls_po_items-material.
*          READ TABLE lt_pcockpit018 INTO ls_pcockpit018 WITH KEY mtart = ls_tp_mat-matkl.

*          IF sy-subrc IS INITIAL                   AND
*             ls_pcockpit018-mwskz IS NOT INITIAL.
*            lv_iva = ls_pcockpit018-mwskz.
*          ELSE.
*            READ TABLE lt_zttm_pcockpit003 INTO ls_zttm_pcockpit003 WITH KEY cfop = <ls_cfop_nf>-cfop.
*            IF sy-subrc IS INITIAL.
*              lv_iva = ls_zttm_pcockpit003-dmwskz.
*            ENDIF.
*          ENDIF.

        ELSE.
          lv_iva = <ls_cfop_nf>-mwskz.
        ENDIF.

*      ENDIF.
        IF lv_iva IS NOT INITIAL.

          ls_po_services-tax_code = lv_iva.
          ev_iva = lv_iva.

          lv_fator = ( <ls_cfop_nf>-vlritem / lv_totnf ).
          ls_po_services-gr_price = lv_gr_price_itm * lv_fator.

          APPEND ls_po_services TO ct_po_services.
        ENDIF.

      ENDIF.

    ENDLOOP.

    lt_cfop_nf_aux = lt_cfop_nf.
    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF  lt_cfop_nf_aux IS NOT INITIAL.

      READ TABLE lt_pcockpit011 INTO ls_pcockpit011 INDEX 1.

      IF sy-subrc IS INITIAL                   AND
         ( ls_pcockpit011-dmwskz IS NOT INITIAL  OR
           ls_pcockpit011-gmwskz IS NOT INITIAL  OR
           ls_pcockpit011-pmwskz IS NOT INITIAL  ).

        IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado

          ev_iva = lv_iva = ls_pcockpit011-gmwskz.

        ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
               lv_vicms IS NOT INITIAL.

          ev_iva = lv_iva = ls_pcockpit011-dmwskz.

        ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
               lv_vicms IS INITIAL.

          ev_iva = lv_iva = ls_pcockpit011-pmwskz.

        ENDIF.

      ENDIF.
    ENDIF.

    DATA: lv_vlritem   TYPE wrbtr.

    IF lv_iva IS NOT INITIAL.

      lt_serv_aux = ct_po_services.
      DELETE lt_serv_aux WHERE ext_line IS INITIAL.
      DELETE lt_serv_aux WHERE tax_code IS NOT INITIAL.

      LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.

        lv_tabix_srv = sy-tabix.

        READ TABLE lt_serv_aux ASSIGNING <fs_po_services> INDEX lv_tabix_srv.

        IF sy-subrc IS INITIAL.

*      LOOP AT ct_po_services ASSIGNING <fs_po_services> WHERE subpckg_no IS INITIAL AND tax_code IS INITIAL.
*        <fs_po_services>-tax_code = lv_iva.
*      ENDLOOP.
*      IF sy-subrc IS NOT INITIAL.

          <ls_cfop_nf>-mwskz = lv_iva.

          ls_po_services = <fs_po_services>.

          lv_fator = ( <ls_cfop_nf>-vlritem / lv_totnf ).
          <fs_po_services>-gr_price = <fs_po_services>-gr_price * lv_fator.
          <fs_po_services>-tax_code = lv_iva.

          MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
           WHERE pckg_no  = <fs_po_services>-pckg_no   AND
                 line_no  = <fs_po_services>-line_no   AND
                 ext_line = <fs_po_services>-ext_line.

        ELSE.

          DATA(lt_serv_aux2) = ct_po_services.

          SORT lt_serv_aux2 BY line_no DESCENDING.

          READ TABLE lt_serv_aux2 INTO ls_po_services INDEX 1.

          IF sy-subrc IS INITIAL.
            ls_po_services-line_no  = ls_po_services-line_no  + 1.
            ls_po_services-ext_line = ls_po_services-ext_line + 10.
            ls_po_services-tax_code = lv_iva.
            ev_iva = lv_iva.
          ENDIF.

          CLEAR lv_vlritem.

          lv_vlritem = <ls_cfop_nf>-vlritem + lv_vlritem.
          <ls_cfop_nf>-mwskz = lv_iva.

          lv_fator = ( lv_vlritem / lv_totnf ).
          ls_po_services-gr_price = lv_gr_price * lv_fator.

          APPEND ls_po_services TO ct_po_services.

        ENDIF.

      ENDLOOP.

    ENDIF.

*    lt_cfop_nf_aux = lt_cfop_nf.
    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      lt_serv_aux = ct_po_services.

      DELETE lt_serv_aux WHERE ext_line IS INITIAL OR tax_code IS NOT INITIAL.

      IF lv_iva IS INITIAL.

        READ TABLE lt_pcockpit005 INTO ls_pcockpit005 INDEX 1.

        IF sy-subrc IS INITIAL                   AND
           ls_pcockpit005-mwskz IS NOT INITIAL.
          lv_iva = ls_pcockpit005-mwskz.
        ELSE.

        ENDIF.

      ELSE.

        LOOP AT ct_po_services ASSIGNING <fs_po_services> WHERE subpckg_no IS INITIAL AND tax_code IS INITIAL.
          <fs_po_services>-tax_code = lv_iva.
        ENDLOOP.
        IF sy-subrc IS NOT INITIAL.

          SORT ct_po_services BY line_no DESCENDING.

          READ TABLE ct_po_services INTO ls_po_services INDEX 1.
          IF sy-subrc IS INITIAL.

            ls_po_services-line_no  = ls_po_services-line_no  + 1.
            ls_po_services-ext_line = ls_po_services-ext_line + 10.
            ls_po_services-tax_code = lv_iva.
            ev_iva = lv_iva.
          ENDIF.

          CLEAR lv_vlritem.
          LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.
            lv_vlritem = ls_cfop_nf-vlritem + lv_vlritem.
            <ls_cfop_nf>-mwskz = lv_iva.
          ENDLOOP.

          lv_fator = ( lv_vlritem / lv_totnf ).
          ls_po_services-gr_price = lv_gr_price * lv_fator.

          APPEND ls_po_services TO ct_po_services.

        ENDIF.
      ENDIF.
    ENDIF.

*    lt_cfop_nf_aux = lt_cfop_nf.
    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      lt_serv_aux = ct_po_services.

      DELETE lt_serv_aux WHERE ext_line IS INITIAL OR tax_code IS NOT INITIAL.

      LOOP AT lt_cfop_matkl_nf ASSIGNING FIELD-SYMBOL(<ls_cfop_matkl_nf>).

        READ TABLE lt_cfop_nf_aux ASSIGNING <ls_cfop_nf> WITH KEY cfop = <ls_cfop_matkl_nf>-cfop.

        CHECK sy-subrc IS INITIAL.

        lv_tabix_srv = sy-tabix.

        READ TABLE lt_serv_aux ASSIGNING <fs_po_services> INDEX lv_tabix_srv.

        IF sy-subrc IS INITIAL.

          READ TABLE lt_pcockpit018 INTO DATA(ls_pcockpit018) WITH KEY mtart = <ls_cfop_matkl_nf>-matkl.

          IF sy-subrc IS INITIAL                   AND
             ls_pcockpit018-mwskz IS NOT INITIAL.
            lv_iva = ls_pcockpit018-mwskz.
          ENDIF.

          IF lv_iva IS NOT INITIAL.
            <fs_po_services>-tax_code = lv_iva.
            ev_iva = lv_iva.

            <ls_cfop_nf>-mwskz = lv_iva.

*          READ TABLE lt_cfop_nf_aux ASSIGNING <ls_cfop_nf> WITH KEY cfop = <ls_cfop_matkl_nf>-cfop.
*          IF sy-subrc IS INITIAL.
            lv_fator = ( <ls_cfop_matkl_nf>-vlritem / lv_totnf ).
*          ENDIF.

            ls_po_services-gr_price = lv_gr_price * lv_fator.

            ls_po_services = <fs_po_services>.

            MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
             WHERE pckg_no  = <fs_po_services>-pckg_no   AND
                   line_no  = <fs_po_services>-line_no   AND
                   ext_line = <fs_po_services>-ext_line.

          ENDIF.

        ELSE.

          ls_po_services-line_no  = ls_po_services-line_no  + 1.
          ls_po_services-ext_line = ls_po_services-ext_line + 10.


          READ TABLE lt_pcockpit018 INTO ls_pcockpit018 WITH KEY mtart = <ls_cfop_matkl_nf>-matkl.

          IF sy-subrc IS INITIAL                   AND
             ls_pcockpit018-mwskz IS NOT INITIAL.
            lv_iva = ls_pcockpit018-mwskz.
          ENDIF.

          IF lv_iva IS NOT INITIAL.
            ls_po_services-tax_code = lv_iva.
            ev_iva = lv_iva.

            <ls_cfop_nf>-mwskz = lv_iva.

            lv_fator = ( <ls_cfop_matkl_nf>-vlritem / lv_totnf ).
            ls_po_services-gr_price = lv_gr_price * lv_fator.

            APPEND ls_po_services TO ct_po_services.
          ENDIF.

        ENDIF.

      ENDLOOP.
    ENDIF.

    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      SORT lt_lin_2 BY nitemped.
      SORT lt_ekpo BY mwskz.
      SORT lt_cfop_param BY cfop.

      SORT lt_pcockpit003 BY pmwskz.
      DELETE ADJACENT DUPLICATES FROM lt_pcockpit003 COMPARING pmwskz.

      LOOP AT lt_pcockpit003 ASSIGNING FIELD-SYMBOL(<ls_pcockpit003>).

        READ TABLE lt_ekpo ASSIGNING <ls_ekpo> WITH KEY mwskz = <ls_pcockpit003>-dmwskz BINARY SEARCH.
        IF sy-subrc IS INITIAL.

*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*            EXPORTING
*              input  = <ls_ekpo>-ebelp
*            IMPORTING
*              output = lv_nitemped.
*
*          READ TABLE lt_lin_2 INTO ls_lin WITH KEY nitemped = lv_nitemped BINARY SEARCH.
*          IF sy-subrc IS INITIAL.
*            READ TABLE lt_cfop_param TRANSPORTING NO FIELDS WITH KEY cfop = ls_lin-cfop BINARY SEARCH.
*            CHECK sy-subrc IS INITIAL.
*          ELSE.
*            CONTINUE.
*          ENDIF.
        ENDIF.

        IF <ls_pcockpit003>-pmwskz IS NOT INITIAL.

          READ TABLE ct_po_services ASSIGNING <fs_po_services> WITH KEY subpckg_no = 0
                                                                        tax_code   = space.

          IF sy-subrc IS INITIAL.

            <fs_po_services>-tax_code = <ls_pcockpit003>-pmwskz.

*            READ TABLE lt_cfop_iva_vlr INTO ls_cfop_iva_vlr WITH KEY mwskz_tb03 = <ls_pcockpit003>-dmwskz.
            READ TABLE lt_para_iva_vlr INTO ls_para_iva_vlr WITH KEY mwskz_para = <ls_pcockpit003>-pmwskz.

            IF sy-subrc IS INITIAL.
*              lv_fator = ( ls_cfop_iva_vlr-valor / lv_totnf ).
              lv_fator = ( ls_para_iva_vlr-valor / lv_totnf ).
              <fs_po_services>-gr_price = lv_gr_price * lv_fator.
            ENDIF.

*          ENDLOOP.

*          IF sy-subrc IS NOT INITIAL.
          ELSE.
            SORT ct_po_services BY line_no DESCENDING.

            READ TABLE ct_po_services INTO ls_po_services INDEX 1.
            IF sy-subrc IS INITIAL.

              ls_po_services-line_no  = ls_po_services-line_no  + 1.
              ls_po_services-ext_line = ls_po_services-ext_line + 10.
              ls_po_services-tax_code = <ls_pcockpit003>-pmwskz.
              ev_iva = <ls_pcockpit003>-pmwskz.

*            CLEAR lv_vlritem.
*            LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.
*              lv_vlritem = <ls_cfop_nf>-vlritem + lv_vlritem.
*              <ls_cfop_nf>-mwskz = <ls_pcockpit003>-pmwskz.
*            ENDLOOP.

*              READ TABLE lt_cfop_iva_vlr INTO ls_cfop_iva_vlr WITH KEY mwskz_tb03 = <ls_pcockpit003>-dmwskz.
              READ TABLE lt_para_iva_vlr INTO ls_para_iva_vlr WITH KEY mwskz_para = <ls_pcockpit003>-pmwskz.

              IF sy-subrc IS INITIAL.
*                lv_fator = ( ls_cfop_iva_vlr-valor / lv_totnf ).
                lv_fator = ( ls_para_iva_vlr-valor / lv_totnf ).
                ls_po_services-gr_price = lv_gr_price * lv_fator.
              ENDIF.

*            lv_fator = ( lv_vlritem / lv_totnf ).
*            ls_po_services-gr_price = lv_gr_price * lv_fator.

            ENDIF.

            APPEND ls_po_services TO ct_po_services.

*            lv_fator = ( ls_lin-nfnett / lv_totnf ).
*            lv_vlritem = lv_gr_price * lv_fator.
*
*            SORT ct_po_services BY tax_code.
*
*            READ TABLE ct_po_services ASSIGNING FIELD-SYMBOL(<fs_po_services_aux>)
*                                                    WITH KEY tax_code = <ls_pcockpit003>-pmwskz
*                                                    BINARY SEARCH.
*            IF sy-subrc IS INITIAL.
*
*              <fs_po_services_aux>-gr_price = <fs_po_services_aux>-gr_price + lv_vlritem.
*
*            ELSE.
*
*              SORT ct_po_services BY tax_code DESCENDING.
*
*              READ TABLE ct_po_services INTO ls_po_services INDEX 1.
*              IF sy-subrc IS INITIAL.
*
*                ls_po_services-line_no  = ls_po_services-line_no  + 1.
*                ls_po_services-ext_line = ls_po_services-ext_line + 10.
*                ls_po_services-tax_code = <ls_pcockpit003>-pmwskz.
*                ev_iva = <ls_pcockpit003>-pmwskz.
*
*              CLEAR lv_vlritem.
*                LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.
*              lv_vlritem = <ls_cfop_nf>-vlritem + lv_vlritem.
*                  <ls_cfop_nf>-mwskz = <ls_pcockpit003>-pmwskz.
*                ENDLOOP.
*
*              lv_fator = ( lv_vlritem / lv_totnf ).
*              ls_po_services-gr_price = lv_gr_price * lv_fator.
*                ls_po_services-gr_price = lv_vlritem.
*
*                APPEND ls_po_services TO ct_po_services.
*
*              ENDIF.
*            ENDIF.
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDIF.

    DATA(lt_po_serv_aux) = ct_po_services[].

    DELETE lt_po_serv_aux WHERE tax_code IS INITIAL.
    SORT lt_po_serv_aux BY tax_code.
    DELETE ADJACENT DUPLICATES FROM lt_po_serv_aux COMPARING tax_code.

    IF lines( lt_po_serv_aux[] ) = 1.

      READ TABLE ct_po_items ASSIGNING FIELD-SYMBOL(<fs_po_items>) INDEX 1.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_po_serv_aux ASSIGNING FIELD-SYMBOL(<fs_po_serv_aux>) INDEX 1.
        IF sy-subrc IS INITIAL.

          <fs_po_items>-tax_code = <fs_po_serv_aux>-tax_code.

          READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_po_items_x>) INDEX 1.
          IF sy-subrc IS INITIAL.

            <fs_po_items_x>-tax_code = abap_true.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    determina_service( EXPORTING it_charge_element = it_charge_element
                       IMPORTING ev_serv_def       = ev_serv_def
                        CHANGING ct_po_services    = ct_po_services ).


    DATA:
      lv_srv_based_iv.

    lo_stvarv->get_value( EXPORTING name  = 'ZTM_DET_IVA_ENT_FAT_SERV'
                          IMPORTING value = lv_srv_based_iv ).

    LOOP AT ct_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).

      READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_ct_po_itemsx>) WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
      CHECK sy-subrc IS INITIAL.

      <fs_ct_po_items>-srv_based_iv  = lv_srv_based_iv.
      <fs_ct_po_itemsx>-srv_based_iv = lv_srv_based_iv.

    ENDLOOP.

  ENDMETHOD.


  METHOD determina_iva_cte_services_01.

    TYPES:
      BEGIN OF ty_cfop_nf,
        docnum  TYPE j_1bdocnum,
        itmnum  TYPE j_1bitmnum,
        cfop    TYPE j_1bcfop,
        vlritem TYPE netwr,
        mwskz   TYPE mwskz,
      END OF ty_cfop_nf,

      BEGIN OF ty_cfop_matkl_nf,
        docnum  TYPE j_1bdocnum,
        itmnum  TYPE j_1bitmnum,
        cfop    TYPE j_1bcfop,
        matkl   TYPE matkl,
        vlritem TYPE netwr,
        mwskz   TYPE mwskz,
      END OF ty_cfop_matkl_nf,

      BEGIN OF ty_para_iva_vlr,
        mwskz_para TYPE mwskz,
        valor      TYPE netwr,
      END OF ty_para_iva_vlr,

      BEGIN OF ty_cfop_iva_vlr,
        cfop       TYPE j_1bcfop,
        mwskz_lips TYPE mwskz,
        mwskz_btax TYPE mwskz,
        mwskz_tb03 TYPE mwskz,
        valor      TYPE netwr,
      END OF ty_cfop_iva_vlr.

    DATA:
      lt_cfop_nf       TYPE TABLE OF ty_cfop_nf,
      lt_cfop_matkl_nf TYPE TABLE OF ty_cfop_matkl_nf,

      lt_cfop_iva_vlr  TYPE TABLE OF ty_cfop_iva_vlr,
      ls_cfop_iva_vlr  LIKE LINE OF lt_cfop_iva_vlr,

      lt_para_iva_vlr  TYPE TABLE OF ty_para_iva_vlr,
      ls_para_iva_vlr  LIKE LINE OF lt_para_iva_vlr.


    DATA:
      lt_depara_cfop TYPE RANGE OF j_1bcfop,
      lr_cfop        TYPE RANGE OF j_1bcfop,
      ls_cfop_range  LIKE LINE OF lr_cfop.

    DATA:
      lt_refkey TYPE zctgtm_cargo_refkey,
      ls_refkey TYPE j_1brefkey.

*    DATA: lv_remessa TYPE vbeln,
*          lv_vstel   TYPE vstel.

    DATA: lv_vstel   TYPE vstel.

    DATA:
      lv_bp_rem      TYPE partner,
      lv_bp_dest     TYPE partner,
      ls_cfop_params TYPE j_1bao,
      lv_totnf       TYPE netwr,
      lv_fator       TYPE bapigrprice.

    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = it_sfir_item_data    " Main Area: SFIR Item
        it_stage_loc_data = it_stage_loc_data    " Stages
        it_postal_addr    = it_postal_addr       " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
        it_tor_stop       = it_tor_stop
      IMPORTING
        es_loc_origem     = DATA(ls_loc_origem)  " Node structure for postal address data - internal
        es_loc_dest       = DATA(ls_loc_dest) ). " Node structure for postal address data - internal

    CHECK ls_loc_origem IS NOT INITIAL AND
          ls_loc_dest   IS NOT INITIAL.

*    lv_remessa = iv_btd_id+25(10).
*    SELECT SINGLE vbeln,
*                  vstel,
*                  kunnr
*      FROM likp
*      INTO @DATA(ls_likp)
*     WHERE vbeln EQ @lv_remessa.

* BEGIN OF INSERT - JWSILVA - 16.03.2023
*    ls_likp-kunnr = COND #( WHEN ls_likp-kunnr IS NOT INITIAL
*                            THEN ls_likp-kunnr
*                            ELSE is_tor_root-consigneeid ).
* END OF INSERT - JWSILVA - 16.03.2023

*    CHECK sy-subrc IS INITIAL.

*    SELECT vbeln,
*           vgbel,
*           vgpos,
*           j_1bcfop,
*           j_1btxsdc
*      FROM lips
*      INTO TABLE @DATA(lt_lips)
*      WHERE vbeln EQ @lv_remessa.

    " Seleção do IVA na Tabela ZTTM_PCOCKPIT005
    DATA(lv_tor_id) =   |{ is_tor_root-tor_id  ALPHA = IN }|.

    " Selecionar o CFOP das notas transportadas
    SELECT SINGLE cenario,
                  picms,
                  vicms,
                  cfop
      INTO (@DATA(lv_cenario),
            @DATA(lv_picms),
            @DATA(lv_vicms),
            @DATA(lv_cfop))
      FROM zttm_gkot001
      WHERE tor_id = @lv_tor_id
        AND acckey = @is_sfir_root-zzacckey.

    CHECK lv_cenario = '01'.


    " Determina Produto Acabado
    DATA(lv_prod_acabado) = determina_prod_acabado( it_tor_item = it_tor_item ).


    " seleção na tabela de IVA detalhado (ZTTM_PCOCKPIT003) considerando CFOP/ Cenário / IVA de (NF) de entrada no destino / IVA para (frete).
    DATA(lt_mat) = it_tor_item.
*    DELETE lt_mat WHERE base_btd_id <> iv_btd_id.
    DELETE lt_mat WHERE item_cat <> 'PRD'.
*
*    IF lt_mat[] IS NOT INITIAL.
*
**      SELECT
**        ebeln,
**        ebelp,
**        matnr,
**        mwskz
**      INTO TABLE @DATA(lt_ekpo)
**      FROM ekpo
**      FOR ALL ENTRIES IN @lt_mat
**      WHERE ebeln = @lt_mat-orig_btd_id+25(10).
*
*
*      SELECT * INTO TABLE @DATA(lt_faturas)
*        FROM vbfa
*        WHERE vbelv   = @iv_btd_id+25(10)
*          AND vbtyp_n = 'R'.
*
*      IF sy-subrc IS INITIAL.
*
*        LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<fs_fat>).
*          ls_refkey = |{ <fs_fat>-vbeln && sy-datum(4) }|.
*          APPEND ls_refkey TO lt_refkey.
*        ENDLOOP.
*
*        SELECT *
*           FROM j_1bnflin
*          INTO TABLE @DATA(lt_lin)
*          FOR ALL ENTRIES IN @lt_refkey
*          WHERE refkey = @lt_refkey-table_line.
*
*        IF sy-subrc IS INITIAL.
*
*          DATA(lv_docnum) = lt_lin[ 1 ]-docnum.
*
*          SELECT SINGLE *
*             FROM j_1bnfdoc
*            INTO @DATA(ls_doc)
*            WHERE docnum = @lv_docnum.
*
*        ENDIF.
*
*      ENDIF.
*    ENDIF.

*    LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).
*
*      DATA(ls_cfop_nf) = VALUE ty_cfop_nf( docnum  = ls_doc-docnum
**                                             itmnum  = <fs_lin>-itmnum
*                                           vlritem = <fs_lin>-nfnett
*                                           cfop    = <fs_lin>-cfop ).
*
*
*      lv_totnf = lv_totnf + <fs_lin>-nfnett.
*
*      COLLECT ls_cfop_nf INTO lt_cfop_nf.
*
*      DATA(ls_cfop_matkl_nf) = VALUE ty_cfop_matkl_nf( docnum  = ls_doc-docnum
**                                                        itmnum  = <fs_lin>-itmnum
*                                                       vlritem = <fs_lin>-nfnett
*                                                       cfop    = <fs_lin>-cfop
*                                                       matkl   = <fs_lin>-matkl ).
*
*
*      lv_totnf = lv_totnf + <fs_lin>-nfnett.
*
*      COLLECT ls_cfop_matkl_nf INTO lt_cfop_matkl_nf.
*
*
*    ENDLOOP.

*    SELECT cfop
*      INTO TABLE @DATA(lt_cfop_param)
*      FROM zttm_pcockpit006
*      FOR ALL ENTRIES IN @lt_cfop_nf
*      WHERE cfop = @lt_cfop_nf-cfop.

    SELECT *
      FROM zttm_pcockpit011
      INTO TABLE @DATA(lt_pcockpit011)
      WHERE cenario  EQ @lv_cenario
        AND incoterm EQ 'FOB'
        AND rateio   EQ 'R01'.                       "#EC CI_SEL_NESTED

    " Seleção de IVA em tabela de exceção
*      lt_mat = it_tor_item.
*      DELETE lt_mat WHERE item_cat <> /scmtms/if_tor_const=>sc_tor_item_category-product.


*        SORT lt_j_1bt007 BY in_mwskz
*                            sd_mwskz.
*      IF lt_cfop_nf IS NOT INITIAL.
*
*        SELECT *
*          INTO TABLE @DATA(lt_zttm_pcockpit003)
*          FROM zttm_pcockpit003
*          FOR ALL ENTRIES IN @lt_cfop_nf
*          WHERE cenario = @lv_cenario
*            AND cfop    = @lt_cfop_nf-cfop.   "#EC CI_ALL_FIELDS_NEEDED
*
*      ENDIF.


*    lt_mat = it_tor_item.
*    DELETE lt_mat WHERE item_cat <> 'PRD'.

*    IF lt_mat[] IS NOT INITIAL.

    SELECT
      acckey,
      acckey_ref
      INTO TABLE @DATA(lt_gkot003)
      FROM zttm_gkot003
      WHERE acckey = @is_sfir_root-zzacckey.

    IF sy-subrc IS INITIAL.

      SELECT
        accesskey,
        purchaseorder
        INTO TABLE @DATA(lt_po_ref)
        FROM zi_tm_vh_frete_identify_fo
        FOR ALL ENTRIES IN @lt_gkot003
        WHERE accesskey = @lt_gkot003-acckey_ref
          AND deliverydocumenttype = 'EL'.

    ENDIF.

    IF lt_po_ref IS NOT INITIAL.

      SELECT
        ebeln,
        ebelp,
        mwskz
      INTO TABLE @DATA(lt_ekpo)
      FROM ekpo
      FOR ALL ENTRIES IN @lt_po_ref
      WHERE ebeln = @lt_po_ref-purchaseorder.

      IF sy-subrc IS INITIAL.

        DATA(lv_po) = lt_ekpo[ 1 ]-ebeln.

*        IF lt_lips[] IS NOT INITIAL.
*          DATA(lv_iva_sd)  = lt_lips[ 1 ]-j_1btxsdc.
*          DATA(lv_cfop_sd) = lt_lips[ 1 ]-j_1bcfop.
*        ENDIF.

      ENDIF.

*      SELECT * INTO TABLE @DATA(lt_ekbe)
*        FROM ekbe
*        WHERE ebeln = @lv_po
*          AND gjahr =  @space
*          AND bewtp = 'L'.

      SELECT * INTO TABLE @DATA(lt_ekbe)
        FROM ekbe
      FOR ALL ENTRIES IN @lt_ekpo
        WHERE ebeln = @lt_ekpo-ebeln
          AND gjahr =  @space
          AND bewtp = 'L'.

      IF sy-subrc IS INITIAL.

*        lv_remessa = lt_ekbe[ 1 ]-belnr.

*        SELECT SINGLE vbeln,
*                      vstel,
*                      kunnr
*          FROM likp
*          INTO @DATA(ls_likp)
*         WHERE vbeln EQ @lv_remessa.

        SELECT
          vbeln,
          vstel,
          kunnr
          FROM likp
          INTO TABLE @DATA(lt_likp)
        FOR ALL ENTRIES IN @lt_ekbe
         WHERE vbeln EQ @lt_ekbe-belnr.

*        SELECT DISTINCT
*          vbeln,
*          posnr,
*          matnr,
*          vgbel,
*          vgpos,
*          matkl,
*          j_1bcfop,
*          j_1btxsdc,
*          uecha
*          FROM lips
*          INTO TABLE @DATA(lt_lips)
*          WHERE vbeln EQ @lv_remessa.

        SELECT DISTINCT
          vbeln,
          posnr,
          matnr,
          vgbel,
          vgpos,
          matkl,
          j_1bcfop,
          j_1btxsdc,
          uecha
          FROM lips
          INTO TABLE @DATA(lt_lips)
          FOR ALL ENTRIES IN @lt_likp
          WHERE vbeln EQ @lt_likp-vbeln.

        SORT lt_lips BY vbeln
                        posnr.

        LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>) WHERE uecha IS NOT INITIAL.
          READ TABLE lt_lips TRANSPORTING NO FIELDS WITH KEY vbeln = <fs_lips>-vbeln
                                                             posnr = <fs_lips>-uecha BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            DELETE lt_lips INDEX sy-tabix.
          ENDIF.
        ENDLOOP.

      ENDIF.

      IF lt_lips IS NOT INITIAL.

        SELECT *
          INTO TABLE @DATA(lt_j_1bt007)
          FROM j_1bt007
           FOR ALL ENTRIES IN @lt_lips
*      WHERE in_mwskz = @lt_ekpo-mwskz
*        AND sd_mwskz = @lt_lips-j_1btxsdc.
         WHERE kalsm     = 'TAXBRA'
           AND ( out_mwskz LIKE 'T%' OR
                 out_mwskz LIKE 'A%' )
           AND sd_mwskz  = @lt_lips-j_1btxsdc.

      ENDIF.

*      LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).
*
*        DATA(ls_cfop_nf) = VALUE ty_cfop_nf( cfop    = <fs_lips>-j_1bcfop ).
*
*
**      lv_totnf = lv_totnf + <fs_lin>-nfnett.
*
*        COLLECT ls_cfop_nf INTO lt_cfop_nf.
*
*        DATA(ls_cfop_matkl_nf) = VALUE ty_cfop_matkl_nf( cfop    = <fs_lips>-j_1bcfop
*                                                         matkl   = <fs_lips>-matkl ).
*
*
**      lv_totnf = lv_totnf + <fs_lin>-nfnett.
*
*        COLLECT ls_cfop_matkl_nf INTO lt_cfop_matkl_nf.
*
*
*      ENDLOOP.
*
*      LOOP AT lt_cfop_nf ASSIGNING FIELD-SYMBOL(<fs_cfop_nf>).
*
*        CASE <fs_cfop_nf>-cfop.
*          WHEN '615101'.
*            <fs_cfop_nf>-cfop = '2152AA'.
*          WHEN '515101'.
*            <fs_cfop_nf>-cfop = '1152AA'.
*          WHEN OTHERS.
*        ENDCASE.
*
*      ENDLOOP.
*
*      LOOP AT lt_cfop_matkl_nf ASSIGNING FIELD-SYMBOL(<fs_cfop_matkl_nf>).
*
*        CASE <fs_cfop_matkl_nf>-cfop.
*          WHEN '615101'.
*            <fs_cfop_matkl_nf>-cfop = '2152AA'.
*          WHEN '515101'.
*            <fs_cfop_matkl_nf>-cfop = '1152AA'.
*          WHEN OTHERS.
*        ENDCASE.
*
*      ENDLOOP.

*      SELECT SINGLE * INTO @DATA(ls_active)
*        FROM j_1bnfe_active
*        WHERE docnum = @lv_docnum.            "#EC CI_ALL_FIELDS_NEEDED
*
*      DATA(lv_acckey) = ls_active-regio && ls_active-nfyear && ls_active-nfmonth && ls_active-stcd1 && ls_active-model && ls_active-serie && ls_active-nfnum9 && ls_active-docnum9 && ls_active-cdv.
*
*
*      SELECT SINGLE * INTO @DATA(ls_innfehd)
*        FROM /xnfe/innfehd
*        WHERE nfeid = @lv_acckey.             "#EC CI_ALL_FIELDS_NEEDED
*
*      DATA:
*        lt_assign  TYPE /xnfe/nfeassign_t.
*
*      CALL FUNCTION '/XNFE/B2BNFE_READ'
*        EXPORTING
*          iv_guid_header     = ls_innfehd-guid_header
*        IMPORTING
*          et_assign          = lt_assign
*        EXCEPTIONS
*          nfe_does_not_exist = 1
*          nfe_locked         = 2
*          technical_error    = 3
*          OTHERS             = 4.
*
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
*      ENDIF.
*
*      SORT lt_assign BY guid_header.
*      IF lt_assign[] IS NOT INITIAL.
*        DATA(ls_assign) = lt_assign[ 1 ].
*      ENDIF.
*
*      SORT lt_lips.
*      DELETE ADJACENT DUPLICATES FROM lt_lips.
*
*      LOOP AT lt_lips INTO DATA(<ls_lips>).
*
*        READ TABLE lt_assign INTO ls_assign INDEX sy-tabix.
*
*        SELECT SINGLE *
*          INTO @DATA(ls_pcockpit003)
*          FROM zttm_pcockpit003
*          WHERE cenario = @lv_cenario
*            AND cfop    = @<ls_lips>-j_1bcfop
*            AND dmwskz  = @ls_assign-mwskz.           "#EC CI_ALL_FIELD
*
*        IF sy-subrc IS INITIAL.
*          APPEND ls_pcockpit003 TO lt_pcockpit003.
*        ENDIF.
*
*      ENDLOOP.

    ENDIF.

    IF lt_j_1bt007 IS NOT INITIAL.

      SORT lt_j_1bt007 BY in_mwskz sd_mwskz.
      DELETE ADJACENT DUPLICATES FROM lt_j_1bt007 COMPARING in_mwskz sd_mwskz.

      SELECT *
        INTO TABLE @DATA(lt_pcockpit003)
        FROM zttm_pcockpit003
        FOR ALL ENTRIES IN @lt_j_1bt007
        WHERE dmwskz  = @lt_j_1bt007-in_mwskz.        "#EC CI_ALL_FIELD

    ENDIF.


*    LOOP AT lt_pcockpit003 INTO DATA(ls_pcockpit003).
*
*
*      READ TABLE lt_j_1bt007 INTO DATA(ls_j_1bt007) WITH KEY
*
*
*
*    ENDLOOP.

    SELECT *
      FROM zttm_pcockpit005
      INTO TABLE @DATA(lt_pcockpit005)
      FOR ALL ENTRIES IN @lt_likp
     WHERE regio_from EQ @ls_loc_origem-region
       AND regio_to   EQ @ls_loc_dest-region
       AND incoterm   EQ 'FOB'
       AND burks      EQ @is_po_header-comp_code
       AND vstel      EQ @lt_likp-vstel.


*    SELECT * INTO TABLE @DATA(lt_faturas)
*      FROM vbfa
*      WHERE vbelv   = @lv_remessa
*        AND vbtyp_n = 'R'.

    SELECT * INTO TABLE @DATA(lt_faturas)
      FROM vbfa
      FOR ALL ENTRIES IN @lt_likp
      WHERE vbelv   = @lt_likp-vbeln
        AND vbtyp_n = 'R'.

    DELETE lt_faturas WHERE rfwrt IS INITIAL.

    IF lt_faturas IS NOT INITIAL.

      LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<fs_fat>).
        ls_refkey = |{ <fs_fat>-vbeln && <fs_fat>-mjahr }|.
        APPEND ls_refkey TO lt_refkey.
      ENDLOOP.

      SELECT *
         FROM j_1bnflin
        INTO TABLE @DATA(lt_lin)
        FOR ALL ENTRIES IN @lt_refkey
        WHERE refkey = @lt_refkey-table_line.

      IF sy-subrc IS INITIAL.

*        DATA(lv_docnum) = lt_lin[ 1 ]-docnum.
*
*        SELECT SINGLE *
*           FROM j_1bnfdoc
*          INTO @DATA(ls_doc)
*          WHERE docnum = @lv_docnum.
*
      ENDIF.

    ENDIF.

    DATA(lo_stvarv) = NEW zcacl_stvarv( ).

    lo_stvarv->get_range( EXPORTING name = 'ZTM_DET_IVA_CFOP'
                          IMPORTING range = lt_depara_cfop ).


    LOOP AT lt_depara_cfop ASSIGNING FIELD-SYMBOL(<ls_depara_cfop>).

      ls_cfop_range-option  = 'EQ'.
      ls_cfop_range-sign    = 'I'.
      ls_cfop_range-low     =  <ls_depara_cfop>-low.
      APPEND ls_cfop_range TO lr_cfop.

    ENDLOOP.


    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<ls_lips>).

      LOOP AT lt_j_1bt007 ASSIGNING FIELD-SYMBOL(<ls_j_1bt007>) WHERE sd_mwskz = <ls_lips>-j_1btxsdc.

        READ TABLE lt_pcockpit003 INTO DATA(ls_pcockpit003) WITH KEY dmwskz = <ls_j_1bt007>-in_mwskz.

        IF sy-subrc IS INITIAL.

          READ TABLE lt_faturas INTO DATA(ls_faturas) WITH KEY vbelv = <ls_lips>-vbeln
                                                               posnv = <ls_lips>-posnr.

          IF sy-subrc IS INITIAL.
*          LOOP AT lt_lin INTO DATA(ls_lin) WHERE cfop = <ls_lips>-j_1bcfop.

            READ TABLE lt_lin INTO DATA(ls_lin) WITH KEY refkey = ls_faturas-vbeln && ls_faturas-mjahr
                                                         refitm = ls_faturas-posnn.

            IF sy-subrc IS INITIAL.
              ls_cfop_iva_vlr-mwskz_tb03 = ls_pcockpit003-dmwskz.
              ls_cfop_iva_vlr-mwskz_lips = <ls_lips>-j_1btxsdc.
              ls_cfop_iva_vlr-mwskz_btax = <ls_j_1bt007>-in_mwskz.
              ls_cfop_iva_vlr-valor      = ls_lin-nfnett.
*            ls_cfop_iva_vlr-cfop       = ls_lin-cfop.
              COLLECT ls_cfop_iva_vlr INTO lt_cfop_iva_vlr.

*            ENDLOOP.

              ls_para_iva_vlr-mwskz_para = ls_pcockpit003-pmwskz.
              ls_para_iva_vlr-valor      = ls_lin-nfnett.
              COLLECT ls_para_iva_vlr INTO lt_para_iva_vlr.

            ENDIF.

          ENDIF.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

    LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).

      DATA(lv_cfop_nf) = <fs_lin>-cfop.

      READ TABLE lt_depara_cfop ASSIGNING <ls_depara_cfop> WITH KEY low = <fs_lin>-cfop.
      IF sy-subrc IS INITIAL.
        lv_cfop_nf = <ls_depara_cfop>-high.
      ENDIF.

      DATA(ls_cfop_nf) = VALUE ty_cfop_nf( "docnum  = <fs_lin>-docnum
*                                             itmnum  = <fs_lin>-itmnum
                                           vlritem = <fs_lin>-nfnett
                                           cfop    = lv_cfop_nf ).



      lv_totnf = lv_totnf + <fs_lin>-nfnett.

      COLLECT ls_cfop_nf INTO lt_cfop_nf.

      DATA(ls_cfop_matkl_nf) = VALUE ty_cfop_matkl_nf( "docnum  = lv_docnum
*                                                        itmnum  = <fs_lin>-itmnum
                                                       vlritem = <fs_lin>-nfnett
                                                       cfop    = lv_cfop_nf
                                                       matkl   = <fs_lin>-matkl ).


      COLLECT ls_cfop_matkl_nf INTO lt_cfop_matkl_nf.

    ENDLOOP.

*    LOOP AT lt_cfop_nf ASSIGNING FIELD-SYMBOL(<fs_cfop_nf>).
*
*      CASE <fs_cfop_nf>-cfop.
*        WHEN '6151AA'.
*          <fs_cfop_nf>-cfop = '2152AA'.
*        WHEN '5151AA'.
*          <fs_cfop_nf>-cfop = '1152AA'.
*        WHEN OTHERS.
*      ENDCASE.
*
*    ENDLOOP.
*
*    LOOP AT lt_cfop_matkl_nf ASSIGNING FIELD-SYMBOL(<fs_cfop_matkl_nf>).
*
*      CASE <fs_cfop_matkl_nf>-cfop.
*        WHEN '6151AA'.
*          <fs_cfop_matkl_nf>-cfop = '2152AA'.
*        WHEN '5151AA'.
*          <fs_cfop_matkl_nf>-cfop = '1152AA'.
*        WHEN OTHERS.
*      ENDCASE.
*
*    ENDLOOP.


    DATA(lt_mat_nf) = lt_lin[].

    IF lt_mat IS NOT INITIAL.

      SELECT
        matnr,
        matkl
        INTO TABLE @DATA(lt_tp_mat)
        FROM mara
        FOR ALL ENTRIES IN @lt_mat_nf
        WHERE matnr = @lt_mat_nf-matnr.                 "#EC CI_SEL_DEL

      SORT lt_tp_mat BY matkl.
      DELETE ADJACENT DUPLICATES FROM lt_tp_mat COMPARING matkl.

      IF lt_tp_mat[] IS NOT INITIAL.

        SELECT
          werks,
          kunnr
          FROM t001w
          INTO TABLE @DATA(lt_t001w)
          FOR ALL ENTRIES IN @lt_likp
          WHERE kunnr EQ @lt_likp-kunnr.

        IF sy-subrc IS INITIAL.

          DATA(ls_t001w) = lt_t001w[ 1 ].

          SELECT
            vstel,
            mtart,
            mwskz
            INTO TABLE @DATA(lt_pcockpit018)
            FROM zttm_pcockpit018
            FOR ALL ENTRIES IN @lt_tp_mat
            WHERE vstel  = @ls_t001w-werks
              AND mtart  = @lt_tp_mat-matkl.

        ENDIF.
      ENDIF.
    ENDIF.

    SELECT cfop
      INTO TABLE @DATA(lt_cfop_param)
      FROM zttm_pcockpit006
      FOR ALL ENTRIES IN @lt_cfop_nf
      WHERE cfop = @lt_cfop_nf-cfop.


    DATA(lt_serv_aux) = ct_po_services.

    DELETE lt_serv_aux WHERE ext_line IS INITIAL.

    LOOP AT lt_cfop_nf ASSIGNING FIELD-SYMBOL(<fs_cfop_nf>).

      READ TABLE lt_cfop_param INTO DATA(ls_cfop_param) WITH KEY cfop = <fs_cfop_nf>-cfop.

      IF sy-subrc IS NOT INITIAL.
        <fs_cfop_nf>-mwskz = '0I'.
      ENDIF.

    ENDLOOP.

    DATA(lv_gr_price) = lt_serv_aux[ 1 ]-gr_price.

    DATA(lt_cfop_nf_aux) = lt_cfop_nf.

    DELETE lt_cfop_nf_aux WHERE mwskz IS INITIAL.

    LOOP AT lt_cfop_nf_aux ASSIGNING FIELD-SYMBOL(<ls_cfop_nf>).

      CHECK <ls_cfop_nf>-mwskz IS NOT INITIAL.

      DATA(lv_tabix_srv) = sy-tabix.

      READ TABLE lt_cfop_param INTO ls_cfop_param WITH KEY cfop = <ls_cfop_nf>-cfop.

      IF sy-subrc IS NOT INITIAL.
        DATA(lv_iva) = '0I'.
      ELSE.

        READ TABLE lt_pcockpit011 INTO DATA(ls_pcockpit011) INDEX 1.

        IF sy-subrc IS INITIAL                   AND
           ( ls_pcockpit011-dmwskz IS NOT INITIAL  OR
             ls_pcockpit011-gmwskz IS NOT INITIAL  OR
             ls_pcockpit011-pmwskz IS NOT INITIAL  ).

          IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado

            ev_iva = lv_iva = ls_pcockpit011-gmwskz.

          ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
                 lv_vicms IS NOT INITIAL.

            ev_iva = lv_iva = ls_pcockpit011-dmwskz.

          ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
                 lv_vicms IS INITIAL.

            ev_iva = lv_iva = ls_pcockpit011-pmwskz.

          ENDIF.

        ELSE.

          READ TABLE lt_pcockpit005 INTO DATA(ls_pcockpit005) INDEX 1.

          IF sy-subrc IS INITIAL                   AND
             ls_pcockpit005-mwskz IS NOT INITIAL.
            lv_iva = ls_pcockpit005-mwskz.
          ELSE.

          ENDIF.

        ENDIF.

      ENDIF.

      READ TABLE lt_serv_aux ASSIGNING FIELD-SYMBOL(<fs_po_services>) INDEX lv_tabix_srv.

      IF sy-subrc IS INITIAL.

        DATA(lv_gr_price_itm) = <fs_po_services>-gr_price.

*        IF lv_iva IS INITIAL.
        IF ls_cfop_nf-mwskz IS INITIAL.

*          READ TABLE ct_po_items INTO DATA(ls_po_items) INDEX 1. "WITH KEY
*          READ TABLE lt_tp_mat INTO DATA(ls_tp_mat) WITH KEY matnr = ls_po_items-material.
*          READ TABLE lt_pcockpit018 INTO DATA(ls_pcockpit018) WITH KEY mtart = ls_tp_mat-matkl.
*
*          IF sy-subrc IS INITIAL                   AND
*             ls_pcockpit018-mwskz IS NOT INITIAL.
*            lv_iva = ls_pcockpit018-mwskz.
*          ELSE.
*            READ TABLE lt_pcockpit003 INTO DATA(ls_pcockpit003) WITH KEY cfop = ls_cfop_nf-cfop.
*            IF sy-subrc IS INITIAL.
*              DATA(lv_iva) = ls_pcockpit003-dmwskz.
*            ENDIF.
*          ENDIF.

        ELSE.
          lv_iva = ls_cfop_nf-mwskz.
        ENDIF.

        IF lv_iva IS NOT INITIAL.
          <fs_po_services>-tax_code = lv_iva.
          ev_iva = lv_iva.

          DATA(ls_po_services) = <fs_po_services>.

          lv_fator = ( ls_cfop_nf-vlritem / lv_totnf ).
          <fs_po_services>-gr_price = lv_gr_price_itm * lv_fator.

          MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
           WHERE pckg_no  = <fs_po_services>-pckg_no   AND
                 line_no  = <fs_po_services>-line_no   AND
                 ext_line = <fs_po_services>-ext_line.

        ENDIF.


      ELSE.

        ls_po_services-line_no  = ls_po_services-line_no  + 1.
        ls_po_services-ext_line = ls_po_services-ext_line + 10.

*        IF lv_iva IS INITIAL.
        IF ls_cfop_nf-mwskz IS INITIAL.

*          READ TABLE ct_po_items INTO ls_po_items INDEX 1. "WITH KEY
*          READ TABLE lt_tp_mat INTO ls_tp_mat WITH KEY matnr = ls_po_items-material.
*          READ TABLE lt_pcockpit018 INTO ls_pcockpit018 WITH KEY mtart = ls_tp_mat-matkl.

*          IF sy-subrc IS INITIAL                   AND
*             ls_pcockpit018-mwskz IS NOT INITIAL.
*            lv_iva = ls_pcockpit018-mwskz.
*          ELSE.
*            READ TABLE lt_zttm_pcockpit003 INTO ls_zttm_pcockpit003 WITH KEY cfop = ls_cfop_nf-cfop.
*            IF sy-subrc IS INITIAL.
*              lv_iva = ls_zttm_pcockpit003-dmwskz.
*            ENDIF.
*          ENDIF.

        ELSE.
          lv_iva = ls_cfop_nf-mwskz.
        ENDIF.

*      ENDIF.
        IF lv_iva IS NOT INITIAL.

          ls_po_services-tax_code = lv_iva.
          ev_iva = lv_iva.

          lv_fator = ( ls_cfop_nf-vlritem / lv_totnf ).
          ls_po_services-gr_price = lv_gr_price_itm * lv_fator.

          APPEND ls_po_services TO ct_po_services.
        ENDIF.

      ENDIF.

    ENDLOOP.

    lt_cfop_nf_aux = lt_cfop_nf.
    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      READ TABLE lt_pcockpit011 INTO ls_pcockpit011 INDEX 1.

      IF sy-subrc IS INITIAL                   AND
         ( ls_pcockpit011-dmwskz IS NOT INITIAL  OR
           ls_pcockpit011-gmwskz IS NOT INITIAL  OR
           ls_pcockpit011-pmwskz IS NOT INITIAL  ).

        IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado

          lv_iva = ls_pcockpit011-gmwskz.

        ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
               lv_vicms IS NOT INITIAL.

          lv_iva = ls_pcockpit011-dmwskz.

        ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
               lv_vicms IS INITIAL.

          ev_iva = lv_iva = ls_pcockpit011-pmwskz.

        ENDIF.

      ENDIF.

    ENDIF.

    DATA: lv_vlritem   TYPE wrbtr.

    IF lv_iva IS NOT INITIAL.

      lt_serv_aux = ct_po_services.
      DELETE lt_serv_aux WHERE ext_line IS INITIAL.
      DELETE lt_serv_aux WHERE tax_code IS NOT INITIAL.

      LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.

        lv_tabix_srv = sy-tabix.

        READ TABLE lt_serv_aux ASSIGNING <fs_po_services> INDEX lv_tabix_srv.

        IF sy-subrc IS INITIAL.

*      LOOP AT ct_po_services ASSIGNING <fs_po_services> WHERE subpckg_no IS INITIAL AND tax_code IS INITIAL.
*        <fs_po_services>-tax_code = lv_iva.
*      ENDLOOP.
*      IF sy-subrc IS NOT INITIAL.

          <ls_cfop_nf>-mwskz = lv_iva.

          ls_po_services = <fs_po_services>.

          lv_fator = ( <ls_cfop_nf>-vlritem / lv_totnf ).
          <fs_po_services>-gr_price = <fs_po_services>-gr_price * lv_fator.
          <fs_po_services>-tax_code = lv_iva.

          MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
           WHERE pckg_no  = <fs_po_services>-pckg_no   AND
                 line_no  = <fs_po_services>-line_no   AND
                 ext_line = <fs_po_services>-ext_line.


        ELSE.

          DATA(lt_serv_aux2) = ct_po_services.

          SORT lt_serv_aux2 BY line_no DESCENDING.

          READ TABLE lt_serv_aux2 INTO ls_po_services INDEX 1.

          IF sy-subrc IS INITIAL.
            ls_po_services-line_no  = ls_po_services-line_no  + 1.
            ls_po_services-ext_line = ls_po_services-ext_line + 10.
            ls_po_services-tax_code = lv_iva.
            ev_iva = lv_iva.
          ENDIF.

          CLEAR lv_vlritem.

          lv_vlritem = <ls_cfop_nf>-vlritem + lv_vlritem.
          <ls_cfop_nf>-mwskz = lv_iva.

          lv_fator = ( lv_vlritem / lv_totnf ).
          ls_po_services-gr_price = lv_gr_price * lv_fator.

          APPEND ls_po_services TO ct_po_services.

        ENDIF.

      ENDLOOP.

    ENDIF.


*    lt_cfop_nf_aux = lt_cfop_nf.
    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      lt_serv_aux = ct_po_services.

      DELETE lt_serv_aux WHERE ext_line IS INITIAL OR tax_code IS NOT INITIAL.

      IF lv_iva IS INITIAL.

        READ TABLE lt_pcockpit005 INTO ls_pcockpit005 INDEX 1.

        IF sy-subrc IS INITIAL                   AND
           ls_pcockpit005-mwskz IS NOT INITIAL.
          lv_iva = ls_pcockpit005-mwskz.
        ELSE.

        ENDIF.

      ELSE.

        LOOP AT ct_po_services ASSIGNING <fs_po_services> WHERE subpckg_no IS INITIAL AND tax_code IS INITIAL.
          <fs_po_services>-tax_code = lv_iva.
        ENDLOOP.
        IF sy-subrc IS NOT INITIAL.

          SORT ct_po_services BY line_no DESCENDING.

          READ TABLE ct_po_services INTO ls_po_services INDEX 1.
          IF sy-subrc IS INITIAL.

            ls_po_services-line_no  = ls_po_services-line_no  + 1.
            ls_po_services-ext_line = ls_po_services-ext_line + 10.
            ls_po_services-tax_code = lv_iva.
            ev_iva = lv_iva.
          ENDIF.

          CLEAR lv_vlritem.
          LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.
            lv_vlritem = <ls_cfop_nf>-vlritem + lv_vlritem.
            <ls_cfop_nf>-mwskz = lv_iva.
          ENDLOOP.

          lv_fator = ( lv_vlritem / lv_totnf ).
          ls_po_services-gr_price = lv_gr_price * lv_fator.

          APPEND ls_po_services TO ct_po_services.

        ENDIF.
      ENDIF.
    ENDIF.

*    lt_cfop_nf_aux = lt_cfop_nf.
    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      lt_serv_aux = ct_po_services.

      DELETE lt_serv_aux WHERE ext_line IS INITIAL OR tax_code IS NOT INITIAL.


      LOOP AT lt_cfop_matkl_nf ASSIGNING FIELD-SYMBOL(<ls_cfop_matkl_nf>).

        READ TABLE lt_cfop_nf_aux ASSIGNING <ls_cfop_nf> WITH KEY cfop = <ls_cfop_matkl_nf>-cfop.

        CHECK sy-subrc IS INITIAL.

        lv_tabix_srv = sy-tabix.

        READ TABLE lt_serv_aux ASSIGNING <fs_po_services> INDEX lv_tabix_srv.

        IF sy-subrc IS INITIAL.

          READ TABLE lt_pcockpit018 INTO DATA(ls_pcockpit018) WITH KEY mtart = <ls_cfop_matkl_nf>-matkl.

          IF sy-subrc IS INITIAL                   AND
             ls_pcockpit018-mwskz IS NOT INITIAL.
            lv_iva = ls_pcockpit018-mwskz.
          ENDIF.

          IF lv_iva IS NOT INITIAL.
            <fs_po_services>-tax_code = lv_iva.
            ev_iva = lv_iva.

            <ls_cfop_nf>-mwskz = lv_iva.

*          READ TABLE lt_cfop_nf_aux ASSIGNING <ls_cfop_nf> WITH KEY cfop = <ls_cfop_matkl_nf>-cfop.
*          IF sy-subrc IS INITIAL.
            lv_fator = ( <ls_cfop_matkl_nf>-vlritem / lv_totnf ).
*          ENDIF.

            ls_po_services-gr_price = lv_gr_price * lv_fator.

            ls_po_services = <fs_po_services>.

            MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
             WHERE pckg_no  = <fs_po_services>-pckg_no   AND
                   line_no  = <fs_po_services>-line_no   AND
                   ext_line = <fs_po_services>-ext_line.

          ENDIF.

        ELSE.

          ls_po_services-line_no  = ls_po_services-line_no  + 1.
          ls_po_services-ext_line = ls_po_services-ext_line + 10.


          READ TABLE lt_pcockpit018 INTO ls_pcockpit018 WITH KEY mtart = <ls_cfop_matkl_nf>-matkl.

          IF sy-subrc IS INITIAL                   AND
             ls_pcockpit018-mwskz IS NOT INITIAL.
            lv_iva = ls_pcockpit018-mwskz.
          ENDIF.

          IF lv_iva IS NOT INITIAL.
            ls_po_services-tax_code = lv_iva.
            ev_iva = lv_iva.

            <ls_cfop_nf>-mwskz = lv_iva.

            lv_fator = ( <ls_cfop_matkl_nf>-vlritem / lv_totnf ).
            ls_po_services-gr_price = lv_gr_price * lv_fator.

            APPEND ls_po_services TO ct_po_services.

          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
    IF lt_cfop_nf_aux IS NOT INITIAL.

      SORT lt_pcockpit003 BY pmwskz.
      DELETE ADJACENT DUPLICATES FROM lt_pcockpit003 COMPARING pmwskz.

      SORT lt_lin BY cfop.

      LOOP AT lt_pcockpit003 ASSIGNING FIELD-SYMBOL(<ls_pcockpit003>).

        IF <ls_pcockpit003>-pmwskz IS NOT INITIAL.

*          LOOP AT ct_po_services ASSIGNING <fs_po_services> WHERE subpckg_no IS INITIAL AND tax_code IS INITIAL.

          READ TABLE ct_po_services ASSIGNING <fs_po_services> WITH KEY subpckg_no = 0
                                                                        tax_code   = space.

          IF sy-subrc IS INITIAL.

            <fs_po_services>-tax_code = <ls_pcockpit003>-pmwskz.

*          READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin_aux>)
*                                          WITH KEY cfop = '6151AA'
*                                          BINARY SEARCH.
*          IF sy-subrc IS NOT INITIAL.
*            READ TABLE lt_lin ASSIGNING <fs_lin_aux>
*                               WITH KEY cfop = '5151AA'
*                               BINARY SEARCH.
*          ENDIF.

*          LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin_aux>) WHERE cfop IN lr_cfop.
*            EXIT.
*          ENDLOOP.

*            READ TABLE lt_cfop_iva_vlr INTO ls_cfop_iva_vlr WITH KEY mwskz_tb03 = <ls_pcockpit003>-dmwskz.
            READ TABLE lt_para_iva_vlr INTO ls_para_iva_vlr WITH KEY mwskz_para = <ls_pcockpit003>-pmwskz.

            IF sy-subrc IS INITIAL.

*              lv_fator = ( ls_cfop_iva_vlr-valor / lv_totnf ).
              lv_fator = ( ls_para_iva_vlr-valor / lv_totnf ).
              <fs_po_services>-gr_price = lv_gr_price * lv_fator.

              DATA(lv_proc) = abap_true.

            ENDIF.
*          ENDLOOP.

*        IF sy-subrc IS NOT INITIAL
*       AND lv_proc IS INITIAL.

          ELSE.  "IF sy-subrc IS NOT INITIAL.

            SORT ct_po_services BY line_no DESCENDING.

            READ TABLE ct_po_services INTO ls_po_services INDEX 1.
            IF sy-subrc IS INITIAL.

              ls_po_services-line_no  = ls_po_services-line_no  + 1.
              ls_po_services-ext_line = ls_po_services-ext_line + 10.
              ls_po_services-tax_code = <ls_pcockpit003>-pmwskz.
              ev_iva = <ls_pcockpit003>-pmwskz.

*            CLEAR lv_vlritem.
*            LOOP AT lt_cfop_nf_aux ASSIGNING <ls_cfop_nf>.
*              lv_vlritem = <ls_cfop_nf>-vlritem + lv_vlritem.
*              <ls_cfop_nf>-mwskz = <ls_pcockpit003>-pmwskz.
*            ENDLOOP.

*              READ TABLE lt_cfop_iva_vlr INTO ls_cfop_iva_vlr WITH KEY mwskz_tb03 = <ls_pcockpit003>-dmwskz.
              READ TABLE lt_para_iva_vlr INTO ls_para_iva_vlr WITH KEY mwskz_para = <ls_pcockpit003>-pmwskz.

              IF sy-subrc IS INITIAL.
*                lv_fator = ( ls_cfop_iva_vlr-valor / lv_totnf ).
                lv_fator = ( ls_para_iva_vlr-valor / lv_totnf ).
                ls_po_services-gr_price = lv_gr_price * lv_fator.
              ENDIF.

*            lv_fator = ( lv_vlritem / lv_totnf ).
*            ls_po_services-gr_price = lv_gr_price * lv_fator.

            ENDIF.

            APPEND ls_po_services TO ct_po_services.

          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    DATA(lt_po_serv_aux) = ct_po_services[].

    DELETE lt_po_serv_aux WHERE tax_code IS INITIAL.
    SORT lt_po_serv_aux BY tax_code.
    DELETE ADJACENT DUPLICATES FROM lt_po_serv_aux COMPARING tax_code.

    IF lines( lt_po_serv_aux[] ) = 1.

      READ TABLE ct_po_items ASSIGNING FIELD-SYMBOL(<fs_po_items>) INDEX 1.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_po_serv_aux ASSIGNING FIELD-SYMBOL(<fs_po_serv_aux>) INDEX 1.
        IF sy-subrc IS INITIAL.

          <fs_po_items>-tax_code = <fs_po_serv_aux>-tax_code.

          READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_po_items_x>) INDEX 1.
          IF sy-subrc IS INITIAL.

            <fs_po_items_x>-tax_code = abap_true.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    determina_service( EXPORTING it_charge_element = it_charge_element
                       IMPORTING ev_serv_def       = ev_serv_def
                        CHANGING ct_po_services    = ct_po_services ).


    DATA:
      lv_srv_based_iv.

    lo_stvarv->get_value( EXPORTING name  = 'ZTM_DET_IVA_ENT_FAT_SERV'
                          IMPORTING value = lv_srv_based_iv ).

    LOOP AT ct_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).

      READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_ct_po_itemsx>) WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
      CHECK sy-subrc IS INITIAL.

      <fs_ct_po_items>-srv_based_iv  = lv_srv_based_iv.
      <fs_ct_po_itemsx>-srv_based_iv = lv_srv_based_iv.

    ENDLOOP.


*      lt_serv_aux = ct_po_services.
*
*      DELETE lt_serv_aux WHERE ext_line IS INITIAL OR tax_code IS NOT INITIAL.


*      lt_cfop_nf_aux = lt_cfop_nf.
*
*      DELETE lt_cfop_nf_aux WHERE mwskz IS NOT INITIAL.
*
*      CHECK lt_cfop_nf_aux IS NOT INITIAL.
*
*      LOOP AT lt_cfop_nf_aux INTO ls_cfop_nf.
*
*        CHECK ls_cfop_nf-mwskz IS INITIAL.
*
*        lv_tabix_srv = sy-tabix.
*
*
*        READ TABLE lt_serv_aux ASSIGNING <fs_po_services> INDEX lv_tabix_srv.
*
*        IF sy-subrc IS INITIAL.
*
*          lv_gr_price = <fs_po_services>-gr_price.
*
*          READ TABLE lt_zttm_pcockpit003 INTO ls_zttm_pcockpit003 WITH KEY cfop = ls_cfop_nf-cfop.
*          IF sy-subrc IS INITIAL.
*            lv_iva = ls_zttm_pcockpit003-dmwskz.
*          ENDIF.
*
*          IF lv_iva IS NOT INITIAL.
*            <fs_po_services>-tax_code = lv_iva.
*            ev_iva = lv_iva.
*          ENDIF.
*
*          ls_po_services = <fs_po_services>.
*
*          lv_fator = ( ls_cfop_nf-vlritem / lv_totnf ).
*          <fs_po_services>-gr_price = lv_gr_price * lv_fator.
*
*          MODIFY ct_po_services FROM <fs_po_services> TRANSPORTING tax_code gr_price
*           WHERE pckg_no  = <fs_po_services>-pckg_no   AND
*                 line_no  = <fs_po_services>-line_no   AND
*                 ext_line = <fs_po_services>-ext_line.
*
*
*        ELSE.
*
*          ls_po_services-line_no  = ls_po_services-line_no  + 1.
*          ls_po_services-ext_line = ls_po_services-ext_line + 10.
*
*          READ TABLE lt_zttm_pcockpit003 INTO ls_zttm_pcockpit003 WITH KEY cfop = ls_cfop_nf-cfop.
*          IF sy-subrc IS INITIAL.
*            lv_iva = ls_zttm_pcockpit003-dmwskz.
*          ENDIF.
*
*          IF lv_iva IS NOT INITIAL.
*            ls_po_services-tax_code = lv_iva.
*            ev_iva = ls_zttm_pcockpit003-dmwskz.
*          ENDIF.
*
*          lv_fator = ( ls_cfop_nf-vlritem / lv_totnf ).
*          ls_po_services-gr_price = lv_gr_price * lv_fator.
*
*          APPEND ls_po_services TO ct_po_services.
*
*        ENDIF.
*
*      ENDLOOP.


** ---------------------------------------------------------------------------
** Caso nenhuma das determinações anteriores funcione, fazer uma última determinação
** somente para os cenários de Entrada
** ---------------------------------------------------------------------------
*    " Somente continuar quando o documento for 58 (Recebimento) ou 73 (Entrega)
*    CHECK ev_iva IS INITIAL AND lt_fo_dcref IS NOT INITIAL.
*
*    " Determina Produto Acabado
*    DATA(lv_prod_acabado) = determina_prod_acabado( it_tor_item = it_tor_item ).
*
*    SELECT SINGLE *
*      FROM zttm_pcockpit011
*      INTO @DATA(ls_pcockpit011)
*      WHERE cenario  EQ @lv_cenario
*        AND incoterm EQ 'FOB'
*        AND rateio   EQ 'R01'.                       "#EC CI_SEL_NESTED
*
*    IF sy-subrc IS INITIAL.
*      IF lv_prod_acabado IS INITIAL.      " Se não tiver produto acabado
*
*        DATA(lv_iva) = ls_pcockpit011-gmwskz.
*
*      ELSEIF lv_picms IS NOT INITIAL AND  " Se tiver ICMS no XML do CT-e
*         lv_vicms IS NOT INITIAL.
*
*        lv_iva = ls_pcockpit011-dmwskz.
*
*      ELSEIF lv_picms IS INITIAL AND      " Se não tiver ICMS no XML do CT-e
*             lv_vicms IS INITIAL.
*
*        lv_iva = ls_pcockpit011-pmwskz.
*
*      ENDIF.
*    ENDIF.
*
*    IF lv_iva IS NOT INITIAL.
*      LOOP AT ct_po_items ASSIGNING FIELD-SYMBOL(<fs_ct_po_items>).
*
*        READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<fs_ct_po_itemsx>) WITH KEY po_item = <fs_ct_po_items>-po_item BINARY SEARCH.
*        CHECK sy-subrc IS INITIAL.
*
*        <fs_ct_po_items>-tax_code  = lv_iva.
*        <fs_ct_po_itemsx>-tax_code = abap_true.
*        ev_iva                     = lv_iva.
*      ENDLOOP.
*
*      IF ev_iva IS NOT INITIAL.
*        CLEAR: gv_message.
*        CONCATENATE 'ZTTM_PCOCKPIT011'
*                    lv_cenario
*                    'FOB'
*                    INTO gv_message SEPARATED BY space.
*
*        " IVA determinado por: &1&2&3&4.
*        DATA(lt_return) = VALUE bapiret2_t( ( type       = if_xo_const_message=>info
*                                        id         = 'ZTM_GKO'
*                                        number     = '137'
*                                        message_v1 = ev_iva
*                                        message_v2 = gv_message+0(50)
*                                        message_v3 = gv_message+50(50)
*                                        message_v4 = gv_message+100(50) ) ).
*
*        set_log( EXPORTING it_return = lt_return                 " Tabela de retorno
*                           iv_acckey = is_sfir_root-zzacckey ).  " Chave de acesso de 44 dígitos
*
*      ENDIF.
*      RETURN.
*    ENDIF.

  ENDMETHOD.


  METHOD atualiza_po_services.

* BEGIN OF INSERT - JWSILVA - 11.04.2023
* ---------------------------------------------------------------------------
* Recupera a linha do custo extra/normal
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_charge_element) = it_charge_element[ zzacckey = is_sfir_root-zzacckey ].
      CATCH cx_root.
        CLEAR ls_charge_element.
    ENDTRY.

* ---------------------------------------------------------------------------
* Determina valor total do serviço
* ---------------------------------------------------------------------------
    " Em caso de mais de uma linha de serviço, é um cenário de rateio.
    " Neste cenário não devemos recalcular os custos
    DATA(lt_po_services) = ct_po_services.
    DELETE lt_po_services WHERE extrefkey NE ls_charge_element-key.

    IF lines( lt_po_services ) <= 1.
      DATA(lv_price) = REDUCE bapigrprice( INIT lv_value TYPE bapigrprice
                                           FOR ls_services IN ct_po_services WHERE ( subpckg_no IS INITIAL )
                                           NEXT lv_value = lv_value + ls_services-gr_price ).
    ENDIF.
* END OF INSERT - JWSILVA - 11.04.2023

*   Atualização de config de IVA MM
    FIELD-SYMBOLS <ls_ct_po_services> LIKE LINE OF ct_po_services.
    READ TABLE ct_po_items  ASSIGNING FIELD-SYMBOL(<ls_ct_po_items>)  WITH KEY po_item = '00010'.
    READ TABLE ct_po_itemsx ASSIGNING FIELD-SYMBOL(<ls_ct_po_itemsx>) WITH KEY po_item = '00010'.

    LOOP AT ct_po_services ASSIGNING <ls_ct_po_services>.

      CHECK <ls_ct_po_services>-subpckg_no IS INITIAL.

* BEGIN OF INSERT - JWSILVA - 11.04.2023
      " Remove a linha que não correponde à chave de acesso sendo processada
      IF <ls_ct_po_services>-extrefkey NE ls_charge_element-key.
        DELETE TABLE ct_po_services FROM <ls_ct_po_services>.
        CONTINUE.
      ENDIF.

      " Insere o valor total nessa linha de custo
      IF lv_price IS NOT INITIAL.
        <ls_ct_po_services>-gr_price = lv_price.
      ENDIF.

      " Campo de custo deixa de ser apenas "Informativo"
      <ls_ct_po_services>-inform   = abap_false.
* END OF INSERT - JWSILVA - 11.04.2023

* BEGIN OF DELETE - JWSILVA - 11.04.2023
*        IF <ls_ct_po_services>-gr_price IS INITIAL.
*          DELETE TABLE ct_po_services FROM <ls_ct_po_services>.
*          CONTINUE.
*        ENDIF.
* END OF DELETE - JWSILVA - 11.04.2023

      IF <ls_ct_po_services>-ext_serv EQ 'FRETE_SAIDA'
      OR <ls_ct_po_services>-ext_serv EQ 'FRETE_ENTRADA'
      OR <ls_ct_po_services>-ext_serv EQ 'FRETE_TRANSFER'.
        <ls_ct_po_services>-external_item_id = 'NORMAL'.
      ELSE.

        <ls_ct_po_services>-external_item_id = <ls_ct_po_services>-ext_serv.
* BEGIN OF INSERT - RPORTES - 26.05.2023 - 8000007922, COMPRAS - MESTRE D SERVIÇO PEDIDO

        " Caso o cenário não seja de rateio, devemos determinar o código de mestre de serviço.
        IF lines( lt_po_services ) <= 1.
          IF     line_exists(   it_charge_element[ tcet084 = 'FRETE_SAIDA' ] )   .

            ls_charge_element = it_charge_element[ tcet084 = 'FRETE_SAIDA' ]     .

          ELSEIF line_exists(   it_charge_element[ tcet084 = 'FRETE_ENTRADA' ] ) .

            ls_charge_element = it_charge_element[ tcet084 = 'FRETE_ENTRADA' ]   .

          ELSEIF line_exists(   it_charge_element[ tcet084 = 'FRETE_TRANSFER' ] ).

            ls_charge_element = it_charge_element[ tcet084 = 'FRETE_TRANSFER' ]  .

          ENDIF.
        ENDIF.
* END OF INSERT - RPORTES - 26.05.2023 - 8000007922, COMPRAS - MESTRE D SERVIÇO PEDIDO

* BEGIN OF DELETE - JWSILVA - 11.04.2023
*        IF     line_exists( lt_charge_element[ tcet084 = 'FRETE_SAIDA' ] ).
*
*          DATA(ls_charge_element) = lt_charge_element[ tcet084 = 'FRETE_SAIDA' ].
*
*        ELSEIF line_exists( lt_charge_element[ tcet084 = 'FRETE_ENTRADA' ] ).
*
*          ls_charge_element = lt_charge_element[ tcet084 = 'FRETE_ENTRADA' ].
*
*        ELSEIF line_exists( lt_charge_element[ tcet084 = 'FRETE_TRANSFER' ] ).
*
*          ls_charge_element = lt_charge_element[ tcet084 = 'FRETE_TRANSFER' ].
*
*        ENDIF.
* END OF DELETE - JWSILVA - 11.04.2023

        IF ls_charge_element IS NOT INITIAL AND iv_serv_def IS INITIAL.

          SELECT SINGLE service
            INTO <ls_ct_po_services>-service
            FROM tcm_d_tc_srv_map
           WHERE trcharg_catcd    = ls_charge_element-chrgcatcd021_i
             AND trcharg_subcatcd = ls_charge_element-tcclass037
             AND trcharg_typecd   = ls_charge_element-tcet084. "#EC CI_SEL_NESTED

        ENDIF.

      ENDIF.

      IF <ls_ct_po_services>-tax_code IS INITIAL.
        <ls_ct_po_services>-tax_code        = iv_iva.
        <ls_ct_po_itemsx>-tax_code          = abap_true.
        <ls_ct_po_items>-tax_code           = <ls_ct_po_services>-tax_code.
      ENDIF.
* BEGIN OF INSERT - JWSILVA - 03.04.2023
      IF is_sfir_root-zzhkont IS NOT INITIAL.
        " Atualiza conta razão
        <ls_ct_po_items>-gl_account         = is_sfir_root-zzhkont.
        <ls_ct_po_itemsx>-gl_account        = abap_true.
      ENDIF.
      IF is_sfir_root-zzkostl IS NOT INITIAL.
        " Atualiza centro de custo
        <ls_ct_po_items>-costcenter         = is_sfir_root-zzkostl.
        <ls_ct_po_itemsx>-costcenter        = abap_true.
      ENDIF.
* END OF INSERT - JWSILVA - 03.04.2023
      IF line_exists( it_tor_root_data[ KEY tor_type tor_type = '1030' ] ).
        <ls_ct_po_services>-taxjurcode = <ls_ct_po_items>-taxjurcode = gs_loc_dest-taxjurisdiction.
        <ls_ct_po_itemsx>-taxjurcode = abap_true.
      ELSE.
        <ls_ct_po_services>-taxjurcode = <ls_ct_po_items>-taxjurcode.
        IF <ls_ct_po_services>-taxjurcode IS INITIAL.
          <ls_ct_po_services>-taxjurcode = <ls_ct_po_items>-taxjurcode = gs_loc_dest-taxjurisdiction.
          <ls_ct_po_itemsx>-taxjurcode = abap_true.
        ENDIF.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

    CONSTANTS:
      BEGIN OF gc_param_nftype_cte_fob,
        modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
        chave1 TYPE ztca_param_val-chave1 VALUE 'COCKPIT_FRETE' ##NO_TEXT,
        chave2 TYPE ztca_param_val-chave2 VALUE 'MODIFY_PO' ##NO_TEXT,
        chave3 TYPE ztca_param_val-chave3 VALUE 'NFTYPFOB' ##NO_TEXT,
      END OF gc_param_nftype_cte_fob.

* ---------------------------------------------------------------------------
* Recupera Parâmetro GKO local
* ---------------------------------------------------------------------------
    IF me->gs_parameter-nftype_cte_fob IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_nftype_cte_fob-modulo
                                                 chave1 = gc_param_nftype_cte_fob-chave1
                                                 chave2 = gc_param_nftype_cte_fob-chave2
                                                 chave3 = gc_param_nftype_cte_fob-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-nftype_cte_fob[] ).

    ENDIF.

    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD get_parameter.

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
ENDCLASS.
