CLASS zcl_tm_formula_abd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_rateio,
        base_btd_id     TYPE /scmtms/s_tor_item_tr_k-base_btd_id,
        base_btditem_id TYPE /scmtms/s_tor_item_tr_k-base_btditem_id,
        amount          TYPE /scmtms/amount,
        netpr           TYPE netpr,
      END OF ty_rateio,

      ty_t_rateio TYPE SORTED TABLE OF ty_rateio
                   WITH UNIQUE KEY base_btd_id base_btditem_id.

    CLASS-METHODS busca_valor
      IMPORTING
        !iv_tor_id       TYPE /scmtms/tor_id
        !iv_wbeln_v      TYPE wbeln_v
        !iv_posnr_v      TYPE posnr_v
        !iv_ebeln        TYPE ebeln
        !iv_ebelp        TYPE ebelp
        !iv_sfir_id      TYPE /scmtms/sfir_id
      EXPORTING
        !ev_netpr        TYPE netpr
      RETURNING
        VALUE(rv_return) TYPE netpr .

    CLASS-METHODS get_po_value
      IMPORTING
        !iv_ebeln       TYPE ebeln
        !iv_ebelp       TYPE ebelp
      EXPORTING
        VALUE(ev_netpr) TYPE netpr .

    CLASS-METHODS get_komlfp
      IMPORTING
        !iv_wbeln  TYPE komv-knumv
        !iv_posnr  TYPE komv-kposn
      EXPORTING
        !es_komlfp TYPE komlfp.

    CLASS-DATA: gt_komlfp TYPE SORTED TABLE OF komlfp           " INSERT - JWSILVA - 31.03.2023
                          WITH NON-UNIQUE KEY wbeln posnr.      " INSERT - JWSILVA - 31.03.2023

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tm_formula_abd IMPLEMENTATION.


  METHOD busca_valor.

    TYPES:
      BEGIN OF ty_ctx,
        host_bo_key        TYPE /bobf/conf_key,
        host_root_node_key TYPE /bobf/conf_key,
        host_node_key      TYPE /bobf/conf_key,
      END OF ty_ctx .

    DATA: lv_quantidade_total    TYPE /scmtms/qua_net_wei_val,
          lv_quantidade_aux      TYPE wfimg,
          lv_valor_unitario(16)  TYPE p DECIMALS 6,
          lo_srv_mgr_tor         TYPE REF TO /bobf/if_tra_service_manager,
          ls_selpar              TYPE /bobf/s_frw_query_selparam,
          lt_selpar              TYPE TABLE OF /bobf/s_frw_query_selparam,
          ls_ctx                 TYPE ty_ctx,
          lt_tor_root            TYPE /scmtms/t_tor_root_k,
          lt_item_tr             TYPE /scmtms/t_tor_item_tr_k,
          lt_charge_distribution TYPE /scmtms/t_tcd_root_k,
          lt_distribution_item   TYPE /scmtms/t_tcd_distr_item_k,
          lv_base_btd_id         TYPE /scmtms/base_btd_id,
          lv_base_btditem_id     TYPE /scmtms/base_btd_item_id,
          lv_netpr               TYPE netpr,
          lv_navnw               TYPE navnw,
          lv_ratio               TYPE decimal_value,
          lv_total_sum           TYPE netpr,
          lv_total_ext           TYPE netpr,
          lt_rateio              TYPE ty_t_rateio,   " INSERT - JWSILVA - 31.03.2023
          ls_rateio              TYPE ty_rateio.     " INSERT - JWSILVA - 31.03.2023

    lo_srv_mgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    ls_selpar-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-tor_id.
    ls_selpar-sign           = 'I'.
    ls_selpar-option         = 'EQ'.
    ls_selpar-low            = iv_tor_id. "Número da Ordem de frete
    APPEND ls_selpar TO lt_selpar.

    " /SCMTMS/TOR -> ROOT (FO)
    lo_srv_mgr_tor->query(
       EXPORTING
         iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
         it_selection_parameters = lt_selpar
         iv_fill_data            = abap_true
       IMPORTING
         et_data                 = lt_tor_root ).

    "/SCMTMS/TOR-ROOT-ITEM_TR (FO)
    lo_srv_mgr_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                       it_key         = CORRESPONDING #( lt_tor_root MAPPING key = key )
                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                       iv_fill_data   = abap_true
                                             IMPORTING et_data        = lt_item_tr ).

    "/SCMTMS/TOR-ROOT-CHARGE_DISTRIBUTION (FO)
**********************************************************************
*    gs_ctx-host_bo_key        = /scmtms/if_tor_c=>sc_bo_key.
*    gs_ctx-host_root_node_key = /scmtms/if_tor_c=>sc_node-root.
*    gs_ctx-host_node_key      = /scmtms/if_tor_c=>sc_node-charge_distribution.
*
*    /scmtms/cl_tcd_do_helper=>retrieve_tcd_do_nodes(
*    EXPORTING
*      is_ctx        = gs_ctx
*      it_root_key   = CORRESPONDING #( lt_tor_root MAPPING key = key )
*    IMPORTING
*      et_distr_root    = lt_charge_distribution
*      et_distr_item    = lt_distribution_item ).

    ls_ctx-host_bo_key        = /scmtms/if_suppfreightinvreq_c=>sc_bo_key.
    ls_ctx-host_root_node_key = /scmtms/if_suppfreightinvreq_c=>sc_node-root.
    ls_ctx-host_node_key      = /scmtms/if_suppfreightinvreq_c=>sc_node-charge_distribution.

    /scmtms/cl_sfir_helper_root=>get_key_from_sfirid( EXPORTING it_sfirid  = VALUE #( ( iv_sfir_id ) )
                                                      IMPORTING et_sfirkey = DATA(lt_sfir_k) ).

    /scmtms/cl_tcd_do_helper=>retrieve_tcd_do_nodes( EXPORTING is_ctx        = ls_ctx
                                                               it_root_key   = lt_sfir_k
                                                     IMPORTING et_distr_root = lt_charge_distribution
                                                               et_distr_item = lt_distribution_item ).
**********************************************************************

    "Só os materiais
    DELETE lt_item_tr WHERE item_type <> 'PRD'.         "#EC CI_SORTSEQ

    zcl_tm_formula_abd=>get_po_value( EXPORTING iv_ebeln = iv_ebeln     " Nº do documento de compras
                                                iv_ebelp = iv_ebelp     " Nº item do documento de compra
                                      IMPORTING ev_netpr = ev_netpr ).  " Preço líquido + Importos não dedutíveis

    READ TABLE lt_charge_distribution INTO DATA(ls_charge_distribution) INDEX 1.

    lv_base_btd_id     = |{ iv_wbeln_v ALPHA = IN }|.
    lv_base_btditem_id = |{ iv_posnr_v ALPHA = IN }|.

* BEGIN OF CHANGE - JWSILVA - 31.03.2023
* ---------------------------------------------------------------------------
* Caso exista apenas um item, não é necessário o rateio
* ---------------------------------------------------------------------------
    IF lines( lt_item_tr ) <= 1.
      rv_return = ev_netpr.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Em caso de múltiplos itens, fazer o rateio
* ---------------------------------------------------------------------------
    " Cálculo do total
    LOOP AT lt_item_tr REFERENCE INTO DATA(ls_item_tr).

      LOOP AT lt_distribution_item ASSIGNING FIELD-SYMBOL(<fs_distribution_item>) "#EC CI_NESTED
                                   WHERE ref_key = ls_item_tr->key. "#EC CI_STDSEQ

        CLEAR ls_rateio.
        ls_rateio-base_btd_id     = ls_item_tr->base_btd_id.
        ls_rateio-base_btditem_id = ls_item_tr->base_btditem_id.
        ls_rateio-amount          = <fs_distribution_item>-amount.
        ls_rateio-netpr           = 0.
        COLLECT ls_rateio INTO lt_rateio[].
      ENDLOOP.
    ENDLOOP.

    " Cálculo do rateio
    LOOP AT lt_rateio REFERENCE INTO DATA(ls_r_rateio).
      lv_ratio           = ls_r_rateio->amount / ls_charge_distribution-net_amount.
      TRY.
          ls_r_rateio->netpr = ( ev_netpr * ls_r_rateio->amount ) / ls_charge_distribution-net_amount.
        CATCH cx_root.
          ls_r_rateio->netpr = 0.
      ENDTRY.
      lv_total_sum       = lv_total_sum + ls_r_rateio->netpr.
    ENDLOOP.

    lv_total_ext = ev_netpr - lv_total_sum.

    " Transfere a diferença para o item ideal (resultado não negativo)
    LOOP AT lt_rateio REFERENCE INTO ls_r_rateio.
      CHECK ( ls_r_rateio->netpr + lv_total_ext ) >= 0.
      ls_r_rateio->netpr = ls_r_rateio->netpr + lv_total_ext.
      EXIT.
    ENDLOOP.

    " Devolve a linha correta
    READ TABLE lt_rateio REFERENCE INTO ls_r_rateio WITH TABLE KEY base_btd_id = lv_base_btd_id
                                                                   base_btditem_id = lv_base_btditem_id.
    IF sy-subrc EQ 0.
      rv_return = ls_r_rateio->netpr.
    ENDIF.
* END OF CHANGE - JWSILVA - 31.03.2023

  ENDMETHOD.


  METHOD get_po_value.

    DATA lv_navnw TYPE navnw.

    "Valor líquido do pedido e valor não dedutível.
    SELECT SINGLE netpr, navnw
      FROM ekpo
      INTO (@ev_netpr, @lv_navnw)
      WHERE ebeln = @iv_ebeln
      AND   ebelp = @iv_ebelp.

    "  Adicionar o valor dos impostos não dedutíveis ao valor líquido do pedido.
    IF lv_navnw IS NOT INITIAL.
      ev_netpr = ev_netpr + lv_navnw.
    ENDIF.

  ENDMETHOD.


  METHOD get_komlfp.

    FIELD-SYMBOLS: <fs_komlfp> TYPE komlfp.

    FREE: es_komlfp.

* ---------------------------------------------------------------------------
* Grava o Item de Faturamento caso ainda não tenha sido processada
* ---------------------------------------------------------------------------
    ASSIGN ('(SAPLWLF1)KOMLFP') TO <fs_komlfp>.

    IF <fs_komlfp> IS ASSIGNED.
      IF NOT line_exists( gt_komlfp[ wbeln = <fs_komlfp>-wbeln
                                     posnr = <fs_komlfp>-posnr ] ).
        INSERT <fs_komlfp> INTO TABLE gt_komlfp.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera o Item de Faturamento da memória
* ---------------------------------------------------------------------------
    TRY.
        es_komlfp = gt_komlfp[ wbeln = iv_wbeln
                               posnr = iv_posnr ].
      CATCH cx_root.
        CLEAR es_komlfp.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
