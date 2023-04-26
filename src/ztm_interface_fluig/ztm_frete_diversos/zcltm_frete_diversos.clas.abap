CLASS zcltm_frete_diversos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          is_input TYPE zcltm_mt_fretes_diversos.
  PROTECTED SECTION.
private section.

  data GS_INPUT type ZCLTM_MT_FRETES_DIVERSOS .
  data GO_TRA_MGR type ref to /BOBF/IF_TRA_TRANSACTION_MGR .
  data GO_SRV_TOR type ref to /BOBF/IF_TRA_SERVICE_MANAGER .
  data GO_SRV_BP type ref to /BOBF/IF_TRA_SERVICE_MANAGER .
  data GO_SRV_TRNSP type ref to /BOBF/IF_TRA_SERVICE_MANAGER .
  data GT_MESSAGES type BAPIRET2_TAB .
  data GT_MOD_TOR type /BOBF/T_FRW_MODIFICATION .
  data GT_MOD_ITEM_TR type /BOBF/T_FRW_MODIFICATION .
  data GT_MOD_TCC type /BOBF/T_FRW_MODIFICATION .
  data GT_MOD_TSP type /BOBF/T_FRW_MODIFICATION .

  methods PROCESS_DATA .
  methods MODIFY_TRANSPORTCHARGES
    importing
      !IT_TCC_KEYS type /BOBF/T_FRW_KEY
      !IS_DADOS type ZCLTM_DT_FRETES_DIVERSOS_DADOS .
  methods CREATE_TRANSPORTCHARGES
    importing
      !IV_ROOT_KEY type /BOBF/CONF_KEY
      !IS_DADOS type ZCLTM_DT_FRETES_DIVERSOS_DADOS .
  methods SAVE .
  methods CREATE_DELIVERY
    importing
      !IV_DOCNUM type J_1BDOCNUM
    returning
      value(RV_REMESSA) type VBELN .
ENDCLASS.



CLASS ZCLTM_FRETE_DIVERSOS IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
  ENDMETHOD.


  METHOD process_data.

    DATA: lt_root          TYPE /scmtms/t_tor_root_k,
          lt_root_delivery TYPE /scmtms/t_tor_root_k,
          lt_item_tr       TYPE /scmtms/t_tor_item_tr_k,
          lt_root_key      TYPE /bobf/t_frw_key,
          lt_tsp_root      TYPE /bofu/t_bupa_root_k,
          lt_item_tr_root  TYPE /scmtms/t_tor_item_tr_k,

          lt_tra_root      TYPE /scmtms/t_tcc_root_k,

          ls_mod_tsp       TYPE /bobf/s_frw_modification,
          ls_mod_tor       TYPE /bobf/s_frw_modification,
          ls_mod_item_tr   TYPE /bobf/s_frw_modification,

          lt_changed       TYPE /bobf/t_frw_name,
          lo_change        TYPE REF TO /bobf/if_tra_change,
          lo_message       TYPE REF TO /bobf/if_frw_message,
          ls_tor_root      TYPE /scmtms/s_tor_root_k.

    DATA: ls_infos_fluig   TYPE ztm_infos_fluig,
          lt_infos_fluig   TYPE TABLE OF ztm_infos_fluig,
          lv_numero_nfe(9) TYPE c,
          lv_remessa       TYPE vbeln,
          lt_docflow       TYPE tdt_docflow.

    READ TABLE gs_input-mt_fretes_diversos-dados ASSIGNING FIELD-SYMBOL(<fs_dados>) INDEX 1.

*    IF <fs_dados>-status = 'Confirmação de coleta e valores'.
    IF <fs_dados>-pedido_fluig IS NOT INITIAL.

      DATA(lv_regio)    = <fs_dados>-chave_nfe(2).
      DATA(lv_nfyear)   = <fs_dados>-chave_nfe+2(2).
      DATA(lv_month)    = <fs_dados>-chave_nfe+4(2).
      DATA(lv_stcd1)    = <fs_dados>-chave_nfe+6(14).
      DATA(lv_model)    = <fs_dados>-chave_nfe+20(2).
      DATA(lv_serie)    = <fs_dados>-chave_nfe+22(3).
      DATA(lv_nfnum9)   = <fs_dados>-chave_nfe+25(9).
      DATA(lv_docnum9)  = <fs_dados>-chave_nfe+34(9).
      DATA(lv_cdv)      = <fs_dados>-chave_nfe+43(1).
*    lv_numero_nfe = '000000013'.

      SELECT SINGLE
          docnum,
          code,
          regio,
          nfyear,
          nfmonth,
          stcd1,
          model,
          serie,
          nfnum9,
          docnum9,
          cdv,
          direct
        INTO @DATA(ls_active)
        FROM j_1bnfe_active
        WHERE regio   = @lv_regio
        AND   nfyear  = @lv_nfyear
        AND   nfmonth = @lv_month
        AND   stcd1    = @lv_stcd1
        AND   model    = @lv_model
        AND   serie    = @lv_serie
        AND   nfnum9   = @lv_nfnum9
        AND   docnum9  = @lv_docnum9
        AND   cdv      = @lv_cdv.

      IF sy-subrc = 0.
        SELECT SINGLE manual
          FROM j_1bnfdoc
          INTO @DATA(lv_manual)
        WHERE docnum = @ls_active-docnum.

        IF sy-subrc IS INITIAL.
          IF lv_manual = abap_false.
            CASE ls_active-direct. " Direção do movimento de mercadorias
              WHEN '1'. " Entrada

                SELECT SINGLE br_notafiscal,
                              deliverydocument
                  FROM zi_tm_vh_frete_identify_fo
                  INTO @DATA(ls_frete_identify_fo)
                  WHERE br_notafiscal EQ @ls_active-docnum.

                IF sy-subrc IS INITIAL.
                  lv_remessa = ls_frete_identify_fo-deliverydocument.
                ENDIF.

              WHEN '2'. " Saída

                SELECT SINGLE br_notafiscal, predecessorreferencedocument
                   INTO @DATA(ls_nfdocumentflow_c)
                   FROM i_br_nfdocumentflow_c
                WHERE br_notafiscal = @ls_active-docnum.

                IF sy-subrc IS INITIAL.
                  lv_remessa = ls_nfdocumentflow_c-predecessorreferencedocument.
                ENDIF.

            ENDCASE.

          ENDIF.
        ENDIF.

        IF lv_remessa IS INITIAL.
*        IF ls_nfdocumentflow_c-predecessorreferencedocument IS NOT INITIAL.
*        IF ls_nfdocumentflow_c-deliverydocument IS NOT INITIAL.
*          lv_remessa = ls_nfdocumentflow_c-predecessorreferencedocument.
*          lv_remessa = ls_nfdocumentflow_c-deliverydocument.
*        ELSE.
          lv_remessa = create_delivery( iv_docnum = ls_active-docnum ).
        ENDIF.

        CHECK lv_remessa IS NOT INITIAL.

* Verifica se o documento encontrado é uma remessa
        SELECT COUNT(*)
          FROM likp
          WHERE vbeln = @lv_remessa.

        IF sy-subrc IS NOT INITIAL.
* Verifica se o numero do campo predecessorreferencedocument é o numero de documento de material, caso seja, busca a remessa a partir dele
          SELECT SINGLE *
            FROM mkpf
            INTO @DATA(ls_mkpf)
          WHERE mblnr = @lv_remessa.

          IF sy-subrc IS INITIAL.
            lv_remessa = ls_mkpf-xblnr.
          ENDIF.
        ENDIF.

*** Inicio - WMDO - 15-11-2022 - Modificação da logica para seleção de documentos subsequentes a remessa
        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes
            it_selection_parameters = VALUE #( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-trq_base_btd_id
                                                 sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                 option         = /bobf/if_conf_c=>sc_sign_equal
                                                 low            = lv_remessa ) )
            iv_fill_data            = abap_true
          IMPORTING
            et_key                  = lt_root_key
            et_data                 = lt_root_delivery ).

        IF lt_root_delivery IS NOT INITIAL.
* Unidade de frete
          READ TABLE lt_root_delivery INTO DATA(ls_root_delivery) WITH KEY tor_cat COMPONENTS tor_cat = 'FU'.

          IF sy-subrc IS INITIAL.
            SHIFT ls_root_delivery-tor_id LEFT DELETING LEADING '0'.
            DATA(lv_unidade_frete) = ls_root_delivery-tor_id.
          ENDIF.

* Ordem de frete
          READ TABLE lt_root_delivery INTO ls_root_delivery WITH KEY tor_cat COMPONENTS tor_cat = 'TO'.

          IF sy-subrc IS INITIAL.
            SHIFT ls_root_delivery-tor_id LEFT DELETING LEADING '0'.
            DATA(lv_ordem_frete) = ls_root_delivery-tor_id.
          ENDIF.

          /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
              EXPORTING
                  it_key         = lt_root_key
                  iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                  iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                  iv_fill_data   = abap_true
              IMPORTING
                  et_data        = lt_item_tr ).

          IF lt_item_tr IS NOT INITIAL.
            READ TABLE lt_item_tr INTO DATA(ls_item_tr) WITH KEY item_cat = 'PRD'.

            IF sy-subrc IS INITIAL.
* Pedido de compra
              IF ls_item_tr-orig_btd_tco = '001'.
                SHIFT ls_item_tr-orig_btd_id LEFT DELETING LEADING '0'.
                DATA(lv_pedido_compra) = ls_item_tr-orig_btd_id.
* Ordem de venda
              ELSEIF ls_item_tr-orig_btd_tco = '114'.
                SHIFT ls_item_tr-orig_btd_id LEFT DELETING LEADING '0'.
                DATA(lv_ordem_venda) = ls_item_tr-orig_btd_id.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        IF lv_unidade_frete IS INITIAL.
          CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
            EXPORTING
              iv_docnum  = lv_remessa
            IMPORTING
              et_docflow = lt_docflow.

          SORT lt_docflow BY vbtyp_n.
          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_v>) WITH KEY vbtyp_n = 'C' BINARY SEARCH.
          IF sy-subrc = 0.
            lv_ordem_venda = <fs_docflow_v>-docnum.
          ENDIF.

          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_c>) WITH KEY vbtyp_n = 'V' BINARY SEARCH.
          IF sy-subrc = 0.
            lv_pedido_compra = <fs_docflow_v>-docnum.
          ENDIF.

          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_o>) WITH KEY vbtyp_n = 'TMFO' BINARY SEARCH.
          IF sy-subrc = 0.
            lv_ordem_frete = <fs_docflow_o>-docnum.
          ENDIF.

          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_u>) WITH KEY vbtyp_n = 'TMFU' BINARY SEARCH.
          IF sy-subrc = 0.
            lv_unidade_frete = <fs_docflow_u>-docnum.
          ENDIF.
        ENDIF.

**          CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
**            EXPORTING
**              iv_docnum  = lv_remessa
**            IMPORTING
**              et_docflow = lt_docflow.
**
**          SORT lt_docflow BY vbtyp_n.
**          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_v>) WITH KEY vbtyp_n = 'C' BINARY SEARCH.
**          IF sy-subrc = 0.
**            DATA(lv_ordem_venda) = <fs_docflow_v>-docnum.
**          ENDIF.
**
**          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_c>) WITH KEY vbtyp_n = 'V' BINARY SEARCH.
**          IF sy-subrc = 0.
**            DATA(lv_pedido_compra) = <fs_docflow_v>-docnum.
**          ENDIF.
**
**          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_o>) WITH KEY vbtyp_n = 'TMFO' BINARY SEARCH.
**          IF sy-subrc = 0.
**            DATA(lv_ordem_frete) = <fs_docflow_o>-docnum.
**          ENDIF.
**
**          READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_u>) WITH KEY vbtyp_n = 'TMFU' BINARY SEARCH.
**          IF sy-subrc = 0.
**            DATA(lv_unidade_frete) = <fs_docflow_u>-docnum.
**          ENDIF.
*** Fim - WMDO - 15-11-2022 - Modificação da logica para seleção de documentos subsequentes a remessa

        APPEND VALUE #(
            mandt           = sy-mandt
            pedido_mm       = lv_pedido_compra
            ordem_sd        = lv_ordem_venda
            remessa         = lv_remessa
            unid_frete      = lv_unidade_frete
            ordem_frete     = lv_ordem_frete
            transportadora  = <fs_dados>-transportadora
            modal           = <fs_dados>-modal
            vlr_frete       = <fs_dados>-vlr_frete
            custo_adicional = <fs_dados>-custo_adicional
            centro_custo    = <fs_dados>-centro_custo
            conta_contabil  = <fs_dados>-conta_contabil
            chave_nfe       = <fs_dados>-chave_nfe
            data_pedido     = <fs_dados>-data_pedido
            pedido_fluig    = <fs_dados>-pedido_fluig
            tipo_frete      = <fs_dados>-tipo_frete
            tipo_operacao   = <fs_dados>-tipo_operacao
        ) TO lt_infos_fluig.

        MODIFY ztm_infos_fluig FROM TABLE lt_infos_fluig.
        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
        ENDIF.

        go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
        go_srv_bp  = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_bp_c=>sc_bo_key ).
        go_tra_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

*        DATA: lv_orde_frete(20) TYPE c.
*
*        IF lv_orde_frete IS NOT INITIAL.
*          lv_orde_frete = '0000000000' && lv_ordem_frete.
*      lv_orde_frete = '00000000006100000201'.
        IF lv_ordem_frete IS NOT INITIAL.
          lv_ordem_frete = |{ lv_ordem_frete ALPHA = IN }|.

          SELECT FROM i_freightordervh
            FIELDS transportationorderuuid
*            WHERE freightorder = @lv_orde_frete
            WHERE freightorder = @lv_ordem_frete
            INTO @DATA(lv_root_key)
            UP TO 1 ROWS.
          ENDSELECT.

          SELECT FROM i_businesspartner
            FIELDS businesspartneruuid
            WHERE businesspartner = @<fs_dados>-transportadora
            INTO @DATA(lv_businesspartneruuid)
            UP TO 1 ROWS.
          ENDSELECT.

          go_srv_tor->retrieve(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
              it_key                  = VALUE #( ( key = lv_root_key ) )
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_root ).

          READ TABLE lt_root ASSIGNING FIELD-SYMBOL(<fs_root>) INDEX 1.
          DATA(lt_keys) = VALUE /bobf/t_frw_key( FOR ls_root IN lt_root ( key = ls_root-key ) ).

          IF <fs_dados>-transportadora IS NOT INITIAL.

            go_srv_tor->retrieve_by_association(
                EXPORTING
                    it_key         = lt_keys
                    iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                    iv_association = /scmtms/if_tor_c=>sc_association-root-bo_tsp_root
                    iv_fill_data   = abap_true
                IMPORTING
                    et_data        = lt_tsp_root ).

            IF sy-subrc = 0.

              IF lt_tsp_root IS NOT INITIAL.

                FIELD-SYMBOLS:  <fs_tsp_upd> TYPE /scmtms/s_tor_root_k.

                READ TABLE lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>) INDEX 1.

                ls_mod_tsp-node         = /scmtms/if_tor_c=>sc_node-root.
                ls_mod_tsp-change_mode  = /bobf/if_frw_c=>sc_modify_update.
                ls_mod_tsp-key          = <fs_root>-key.

                CREATE DATA ls_mod_tsp-data TYPE /scmtms/s_tor_root_k.
                ASSIGN ls_mod_tsp-data->* TO <fs_tsp_upd>.
                <fs_tsp_upd>-tspid          = <fs_dados>-transportadora.
                <fs_tsp_upd>-tsp            = lv_businesspartneruuid.
                <fs_tsp_upd>-subcontracting = /scmtms/if_tor_status_c=>sc_root-subcontracting-v_carrier_assigned.

                APPEND /scmtms/if_tor_c=>sc_node_attribute-root-tspid           TO ls_mod_tsp-changed_fields.
                APPEND /scmtms/if_tor_c=>sc_node_attribute-root-tsp             TO ls_mod_tsp-changed_fields.
                APPEND /scmtms/if_tor_c=>sc_node_attribute-root-subcontracting  TO ls_mod_tsp-changed_fields.
                APPEND ls_mod_tsp TO gt_mod_tsp.

              ELSE.

                ls_mod_tsp-node         = /scmtms/if_tor_c=>sc_node-root.
                ls_mod_tsp-change_mode  = /bobf/if_frw_c=>sc_modify_update.
                ls_mod_tsp-key          = <fs_root>-key.

                CREATE DATA ls_mod_tsp-data TYPE /scmtms/s_tor_root_k.
                ASSIGN ls_mod_tsp-data->* TO <fs_tsp_upd>.
                <fs_tsp_upd>-tspid          = <fs_dados>-transportadora.
                <fs_tsp_upd>-tsp            = lv_businesspartneruuid.
                <fs_tsp_upd>-subcontracting = /scmtms/if_tor_status_c=>sc_root-subcontracting-v_carrier_assigned.

                APPEND /scmtms/if_tor_c=>sc_node_attribute-root-tspid           TO ls_mod_tsp-changed_fields.
                APPEND /scmtms/if_tor_c=>sc_node_attribute-root-tsp             TO ls_mod_tsp-changed_fields.
                APPEND /scmtms/if_tor_c=>sc_node_attribute-root-subcontracting  TO ls_mod_tsp-changed_fields.
                APPEND ls_mod_tsp TO gt_mod_tsp.

              ENDIF.
            ENDIF.

            IF gt_mod_tsp IS NOT INITIAL.
              me->save( ).
            ENDIF.
          ENDIF.

          " Centro de Custo
          IF <fs_dados>-centro_custo IS NOT INITIAL.
*          "Modal - /SCMTMS/TOR>ROOT> TRMODCOD
            FIELD-SYMBOLS:  <fs_tor_upd> TYPE /scmtms/s_tor_root_k.

            ls_mod_tor-node         = /scmtms/if_tor_c=>sc_node-root.
            ls_mod_tor-change_mode  = /bobf/if_frw_c=>sc_modify_update.
            ls_mod_tor-key          = <fs_root>-key.

            CREATE DATA ls_mod_tor-data TYPE /scmtms/s_tor_root_k.
            ASSIGN ls_mod_tor-data->* TO <fs_tor_upd>.
*          <fs_tor_upd>-trmodcod = <fs_dados>-modal.
            <fs_tor_upd>-eikto    = <fs_dados>-centro_custo.
            APPEND /scmtms/if_tor_c=>sc_node_attribute-root-trmodcod TO ls_mod_tor-changed_fields.
            APPEND /scmtms/if_tor_c=>sc_node_attribute-root-eikto TO ls_mod_tor-changed_fields.
            APPEND ls_mod_tor TO gt_mod_tor.

            "Call Service Manager
            go_srv_tor->modify(
               EXPORTING
                 it_modification = gt_mod_tor
               IMPORTING
                 eo_message      = DATA(lo_messages_tor)
                 eo_change       = DATA(lo_changes_tor) ).

            DATA: lo_trans TYPE REF TO /bobf/if_tra_transaction_mgr.
            CALL METHOD /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager
              RECEIVING
                eo_transaction_manager = lo_trans.

            DATA: lv_rejected         TYPE boole_d,
                  lo_message_save     TYPE REF TO /bobf/if_frw_message,
                  ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

            lo_trans->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                              IMPORTING ev_rejected            = lv_rejected
                                        eo_change              = lo_changes_tor
                                        eo_message             = lo_messages_tor
                                        et_rejecting_bo_key    = ls_rejecting_bo_key ).

          ENDIF.

          IF <fs_dados>-modal IS NOT INITIAL.

            "ITEM_TR ->MOT
            go_srv_tor->retrieve_by_association(
              EXPORTING
              it_key         = lt_keys
              iv_node_key    = /scmtms/if_tor_c=>sc_node-root
              iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
              iv_fill_data   = abap_true
              IMPORTING
              et_data        = lt_item_tr_root ).

            IF lt_item_tr_root IS NOT INITIAL.

              LOOP AT lt_item_tr_root ASSIGNING FIELD-SYMBOL(<fs_item_tr_root>).

                IF <fs_item_tr_root>-item_type = 'TRUC'.

                  FIELD-SYMBOLS:  <fs_items_tr_upd> TYPE /scmtms/s_tor_item_tr_k.

                  ls_mod_item_tr-key          = <fs_item_tr_root>-key.
                  ls_mod_item_tr-node         = /scmtms/if_tor_c=>sc_node-item_tr.
                  ls_mod_item_tr-source_node  = <fs_item_tr_root>-parent_key.
                  ls_mod_item_tr-source_node  = /scmtms/if_tor_c=>sc_node-root.
                  ls_mod_item_tr-change_mode  = /bobf/if_frw_c=>sc_modify_update.
                  ls_mod_item_tr-association  = /scmtms/if_tor_c=>sc_association-root-item_tr.

                  CREATE DATA ls_mod_item_tr-data TYPE /scmtms/s_tor_item_tr_k.
                  ASSIGN ls_mod_item_tr-data->* TO <fs_items_tr_upd>.
                  <fs_items_tr_upd>-key = ls_mod_item_tr-key.
                  <fs_items_tr_upd>-mot = <fs_dados>-modal.
                  APPEND /scmtms/if_tor_c=>sc_node_attribute-item_tr-mot TO ls_mod_item_tr-changed_fields.
                  APPEND ls_mod_item_tr TO gt_mod_item_tr.

                ENDIF.

              ENDLOOP.

              "Call Service Manager
              go_srv_tor->modify(
                 EXPORTING
                   it_modification = gt_mod_item_tr
                 IMPORTING
                   eo_message      = DATA(lo_messages_item_tr)
                   eo_change       = DATA(lo_changes_item_tr) ).

              DATA: lo_trans_item_tr TYPE REF TO /bobf/if_tra_transaction_mgr.
              CALL METHOD /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager
                RECEIVING
                  eo_transaction_manager = lo_trans_item_tr.

              DATA: lv_rejected_item_tr   TYPE boole_d,
                    lo_message_save_i     TYPE REF TO /bobf/if_frw_message,
                    ls_rejecting_bo_key_i TYPE /bobf/t_frw_key2.

              lo_trans_item_tr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                                IMPORTING ev_rejected            = lv_rejected_item_tr
                                          eo_change              = lo_changes_item_tr
                                          eo_message             = lo_messages_item_tr
                                          et_rejecting_bo_key    = ls_rejecting_bo_key_i ).

            ENDIF.
          ENDIF.
        ENDIF.
*          "Atualização - /SCMTMS/TOR > ITEMCHARGEELEMENT
*          go_srv_tor->retrieve_by_association(
*              EXPORTING
*                  it_key         = lt_keys
*                  iv_node_key    = /scmtms/if_tor_c=>sc_node-root
*                  iv_association = /scmtms/if_tor_c=>sc_association-root-transportcharges
*                  iv_fill_data   = abap_true
*              IMPORTING
*                  et_data        = lt_tra_root
*                  et_target_key  =  DATA(lt_tcc_keys) ).
*
*
*          IF lt_tra_root IS NOT INITIAL.
*
*            me->modify_transportcharges( it_tcc_keys = lt_tcc_keys is_dados = <fs_dados> ).
*
*          ELSE.
*
*            me->create_transportcharges( iv_root_key = lv_root_key is_dados = <fs_dados> ).
*
*          ENDIF.

*        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD create_transportcharges.

**  Aqui sera Criado um registro no Dependent Node TRANSPORTCHARGES, criando também CHARGEITEM->ITEMCHARGEELEMENT

    DATA: ls_ctx      TYPE /scmtms/cl_tcc_do_helper=>ts_ctx,
          lt_root     TYPE /scmtms/t_tcc_root_k,
          lt_mod      TYPE /bobf/t_frw_modification,
          ls_param    TYPE /scmtms/s_tcc_copy_do_param,
          lv_root_key TYPE /bobf/conf_key.

    ls_ctx-host_bo_key        = /scmtms/if_tor_c=>sc_bo_key.
    ls_ctx-host_root_node_key = /scmtms/if_tor_c=>sc_node-root.
    ls_ctx-host_node_key      = /scmtms/if_tor_c=>sc_node-transportcharges.

    lv_root_key = iv_root_key.
    /scmtms/cl_tcc_do_helper=>retrive_do_nodes(
      EXPORTING
        is_ctx                   = ls_ctx
        it_root_key              = VALUE /bobf/t_frw_key( ( key = lv_root_key ) )
      IMPORTING
        et_charge_item           = DATA(lt_items)
        et_do_root               = lt_root
        et_charge_element        = DATA(lt_elements) ).

    TRY.
        DATA(lo_trm_tor) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
        DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
        DATA(lo_conf)    = /bobf/cl_frw_factory=>get_configuration( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
      CATCH /bobf/cx_frw.
    ENDTRY.

    "fetch the runtime Dependent Node key and Association Key for relation between TOR and TRANSPORTCHARGES
    /scmtms/cl_tcc_calc_utility=>get_bo_do_assoc( EXPORTING
                                                    iv_bo_key        = /scmtms/if_tor_c=>sc_bo_key      "business Object (TOR)
                                                    iv_node_key      = /scmtms/if_tor_c=>sc_node-root   "Node (root do TOR)
                                                    iv_do_key        = /scmtms/if_tcc_trnsp_chrg_c=>sc_bo_key "root do TransportCharges
                                                  IMPORTING
                                                    ev_root_node_key = DATA(lv_do_key)                  "nodeId (Transportcharges)
                                                    ev_assoc_key     = DATA(lv_bo_do_assoc_key) ).      "Node (Associação TOR->Transportcharges)


    "fetch Node Keys and Association Keys for Charge Items and Charge Elements.
    DATA(lv_root_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
                                        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                        iv_host_do_node_key = lv_do_key
                                        iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
                                        iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-root ). "This is runtime node key for Charges Root

    DATA(lv_it_chrg_it_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
                                        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                        iv_host_do_node_key = lv_do_key
                                        iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
                                        iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-chargeitem ). "This is runtime node key for Charges Items

    DATA(lv_it_chrg_el_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
                                        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                        iv_host_do_node_key = lv_do_key
                                        iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
                                        iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-itemchargeelement ). "This is runtime node key for Charges Elements

    DATA(lv_ass_root_chargeitem) = /scmtms/cl_common_helper=>get_do_entity_key(
                                        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                        iv_host_do_node_key = lv_do_key
                                        iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
                                        iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-root-chargeitem ). "This is runtime association key for Charges root to Charge Items

    DATA(lv_ass_chargitem_chargelement) = /scmtms/cl_common_helper=>get_do_entity_key(
                                        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                        iv_host_do_node_key = lv_do_key
                                        iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
                                        iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-chargeitem-itemchargeelement ).


    APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<fs_transp>).

    GET TIME STAMP FIELD DATA(lv_timestamp).
    DATA: lo_ref_t TYPE REF TO /scmtms/s_tcc_root_k.
    CREATE DATA lo_ref_t.
    lo_ref_t->key               = /bobf/cl_frw_factory=>get_new_key( ).
    lo_ref_t->parent_key        = lv_root_key.
    lo_ref_t->root_key          = lv_root_key.
    lo_ref_t->created_by        = sy-uzeit.
    lo_ref_t->created_on        = lv_timestamp.
    lo_ref_t->changed_by        = sy-uzeit.
    lo_ref_t->changed_on        = lv_timestamp.
    lo_ref_t->doc_currency      = 'BRL'.
    lo_ref_t->lcl_currency      = 'BRL'.
    lo_ref_t->rounding_currency = 'BRL'.

    <fs_transp>-key          = lo_ref_t->key.
    <fs_transp>-source_key   = lo_ref_t->parent_key.                    "Parent Key
    <fs_transp>-source_node  = /scmtms/if_tor_c=>sc_node-root.       " Charge Item Key
    <fs_transp>-root_key     = lo_ref_t->root_key.                      " Key for Charge DO
    <fs_transp>-node         = /scmtms/if_tor_c=>sc_node-transportcharges.
    <fs_transp>-association  = /scmtms/if_tor_c=>sc_association-root-transportcharges.
    <fs_transp>-change_mode  = /bobf/if_frw_c=>sc_modify_create.
    <fs_transp>-data         = lo_ref_t.

    APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<fs_item>).
    DATA: lo_ref TYPE REF TO /scmtms/s_tcc_chrgitem_k.
    CREATE DATA lo_ref.

    lo_ref->key = /bobf/cl_frw_factory=>get_new_key( ).

    <fs_item>-change_mode  = /bobf/if_frw_c=>sc_modify_create.
    <fs_item>-source_key   = lo_ref_t->key.                           "Instância do nó pai onde vai ocorrer a mudança
    <fs_item>-source_node  = lv_root_node_key.                     "Nó pai da operação
    <fs_item>-root_key     = lo_ref_t->key.                           "Root key do TransportCharges (Nó delegado superior)
    <fs_item>-key          = lo_ref->key.                             "Instância do Node a ser apagada
    <fs_item>-node         = lv_it_chrg_it_node_key.               "Node a ser apagado
    <fs_item>-association  = lv_ass_root_chargeitem.               "Associação Nó pai -> nó a atualizar
    <fs_item>-data         = lo_ref.

**  APPEND Valor do Frete
    IF is_dados-vlr_frete IS NOT INITIAL.

      DATA: lo_ref_elem_f TYPE REF TO /scmtms/s_tcc_trchrg_element_k.
      CREATE DATA lo_ref_elem_f.
      lo_ref_elem_f->key = /bobf/cl_frw_factory=>get_new_key( ).
      lo_ref_elem_f->parent_key = lo_ref->key.
      lo_ref_elem_f->tcet084 = 'FRETE_FLUIG'.
      lo_ref_elem_f->amount = ( is_dados-vlr_frete / 10000 ).
      lo_ref_elem_f->rate_amount = ( is_dados-vlr_frete / 10000 ).
      lo_ref_elem_f->tccs_amount = ( is_dados-vlr_frete / 10000 ).
      lo_ref_elem_f->rate_amount_curr = 'BRL'.
      lo_ref_elem_f->tccs_curr = 'BRL'.

      APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<fs_itemelement_f>).
      <fs_itemelement_f>-change_mode  = /bobf/if_frw_c=>sc_modify_create.
      <fs_itemelement_f>-source_key   = lo_ref_elem_f->parent_key.               "Instância do nó pai onde vai ocorrer a mudança
      <fs_itemelement_f>-source_node  = lv_it_chrg_it_node_key.               "Nó pai da operação
      <fs_itemelement_f>-root_key     = lo_ref_t->key.                           "Root key do TransportCharges (Nó delegado superior)
      <fs_itemelement_f>-key          = lo_ref_elem_f->key.                      "Instância do Node a ser criado
      <fs_itemelement_f>-node         = lv_it_chrg_el_node_key.               "Node a ser apagado
      <fs_itemelement_f>-association  = lv_ass_chargitem_chargelement.        "Associação Nó pai -> nó a atualizar
      <fs_itemelement_f>-data         = lo_ref_elem_f.

    ENDIF.

**  APPEND Custo Adicional
    IF is_dados-custo_adicional IS NOT INITIAL.

      DATA: lo_ref_elem_c TYPE REF TO /scmtms/s_tcc_trchrg_element_k.
      CREATE DATA lo_ref_elem_c.
      lo_ref_elem_c->key = /bobf/cl_frw_factory=>get_new_key( ).
      lo_ref_elem_c->parent_key = lo_ref->key.
      lo_ref_elem_c->tcet084 = 'FRETE_FLUIG_ADC'.
      lo_ref_elem_c->amount = ( is_dados-custo_adicional / 10000 ).
      lo_ref_elem_c->tccs_amount = ( is_dados-custo_adicional / 10000 ).
      lo_ref_elem_c->rate_amount = ( is_dados-custo_adicional / 10000 ).
      lo_ref_elem_c->rate_amount_curr = 'BRL'.
      lo_ref_elem_c->tccs_curr = 'BRL'.

      APPEND INITIAL LINE TO lt_mod ASSIGNING FIELD-SYMBOL(<fs_itemelement_c>).
      <fs_itemelement_c>-change_mode  = /bobf/if_frw_c=>sc_modify_create.
      <fs_itemelement_c>-source_key   = lo_ref_elem_c->parent_key.               "Instância do nó pai onde vai ocorrer a mudança
      <fs_itemelement_c>-source_node  = lv_it_chrg_it_node_key.               "Nó pai da operação
      <fs_itemelement_c>-root_key     = lo_ref_t->key.                     "Root key do TransportCharges (Nó delegado superior)
      <fs_itemelement_c>-key          = lo_ref_elem_c->key.                      "Instância do Node a ser criado
      <fs_itemelement_c>-node         = lv_it_chrg_el_node_key.               "Node a ser apagado
      <fs_itemelement_c>-association  = lv_ass_chargitem_chargelement.        "Associação Nó pai -> nó a atualizar
      <fs_itemelement_c>-data         = lo_ref_elem_c.

    ENDIF.

    TRY.
        lo_srv_tor->modify(
          EXPORTING
            it_modification = lt_mod
          IMPORTING
            eo_change       = DATA(lo_change)
            eo_message      = DATA(lo_message) ).
      CATCH /bobf/cx_frw_contrct_violation.
    ENDTRY.

    IF lo_message IS BOUND.
      lo_message->get_messages( IMPORTING et_message = DATA(lt_messages) ).
      LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_msg>).
        DATA(lv_msg) = <fs_msg>-message->get_longtext( ).
      ENDLOOP.
    ENDIF.

    lo_trm_tor->save( ).

  ENDMETHOD.


  METHOD modify_transportcharges.

    DATA: ls_mod_tcc  TYPE /bobf/s_frw_modification.

    /scmtms/cl_tcc_calc_utility=>get_bo_do_assoc(
    EXPORTING
      iv_bo_key        = /scmtms/if_tor_c=>sc_bo_key  " Business Object
      iv_node_key      = /scmtms/if_tor_c=>sc_node-root   " Node
      iv_do_key        = /scmtms/if_tcc_trnsp_chrg_c=>sc_bo_key
*          iv_calc_ctx      = iv_calc_ctx    " Calculation Context
    IMPORTING
      ev_root_node_key = DATA(lv_do_key)    " NodeID
      ev_assoc_key     = DATA(lv_bo_do_assoc_key)    " Node
      ).

    DATA(lv_root_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
              iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
              iv_host_do_node_key = lv_do_key
               iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
              iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-root
                 ).

    DATA(lv_it_chrg_it_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
              iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
              iv_host_do_node_key = lv_do_key
              iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
              iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-chargeitem
                 ).

    DATA(lv_it_chrg_el_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
              iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
              iv_host_do_node_key = lv_do_key
              iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
              iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-itemchargeelement
                 ).

    DATA(lv_chrg_chargit_assoc_key) = /scmtms/cl_common_helper=>get_do_entity_key(
              iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
              iv_host_do_node_key = lv_do_key
              iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
              iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-root-chargeitem
                 ).

    DATA(lv_chrgit_itchrgel_assoc_key) = /scmtms/cl_common_helper=>get_do_entity_key(
              iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
              iv_host_do_node_key = lv_do_key
              iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
              iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-chargeitem-itemchargeelement
                 ).

    DATA: lt_chitem TYPE /scmtms/t_tcc_chrgitem_k,
          lt_chrel  TYPE /scmtms/t_tcc_trchrg_element_k,
          ls_chrel  TYPE /scmtms/s_tcc_trchrg_element_k.

    go_srv_tor->retrieve_by_association(
      EXPORTING
        iv_node_key             = lv_do_key                   "/scmtms/if_tor_c=>sc_node-transportcharges    " Node
        it_key                  = it_tcc_keys                 " Key Table
        iv_association          = lv_chrg_chargit_assoc_key   " Association
      IMPORTING
        et_target_key           =  DATA(lt_chitemkeys)        " Key Table
    ).

    go_srv_tor->retrieve_by_association(
      EXPORTING
        iv_node_key             = lv_it_chrg_it_node_key       "Node
        it_key                  = lt_chitemkeys                " Key Table
        iv_association          = lv_chrgit_itchrgel_assoc_key " Association
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_chrel
        et_target_key           =  DATA(lt_chelm)    " Key Table
    ).

    GET REFERENCE OF ls_chrel INTO DATA(lr_chrel).

    READ TABLE it_tcc_keys INTO DATA(ls_tcc_keys) INDEX 1.

    IF lt_chelm IS NOT INITIAL.

      LOOP AT lt_chelm ASSIGNING FIELD-SYMBOL(<fs_chelm>).

        ls_mod_tcc-key          = <fs_chelm>-key.
*       ls_mod_tcc-key          = /bobf/cl_frw_factory=>get_new_key( ).
        ls_mod_tcc-source_key   = ls_chrel-parent_key.
        ls_mod_tcc-source_node  = lv_it_chrg_it_node_key. " Charge Item Key
        ls_mod_tcc-root_key     = ls_chrel-root_key.      "ls_tcc_keys-key. " Key for Charge DO
*       ls_mod_tcc-node         = /scmtms/if_tor_c=>sc_node-root.
        ls_mod_tcc-node         = lv_it_chrg_el_node_key.
        ls_mod_tcc-association  = lv_chrgit_itchrgel_assoc_key.
        ls_mod_tcc-change_mode  = /bobf/if_frw_c=>sc_modify_update.

        FIELD-SYMBOLS: <fs_tcc_upd> TYPE /scmtms/s_tcc_trchrg_element_k.
        CREATE DATA ls_mod_tcc-data TYPE /scmtms/s_tcc_trchrg_element_k.
        ASSIGN ls_mod_tcc-data->* TO <fs_tcc_upd>.

        <fs_tcc_upd>-key              = ls_mod_tcc-key.
        <fs_tcc_upd>-tcet084          = TEXT-001.
        <fs_tcc_upd>-rate_amount      = is_dados-vlr_frete.
*        <fs_tcc_upd>-rate_amount_curr = is_dados-unidade_frete.

        APPEND /scmtms/if_tcc_trnsp_chrg_c=>sc_node_attribute-itemchargeelement-tcet084 TO ls_mod_tcc-changed_fields.
        APPEND /scmtms/if_tcc_trnsp_chrg_c=>sc_node_attribute-itemchargeelement-rate_amount TO ls_mod_tcc-changed_fields.
        APPEND /scmtms/if_tcc_trnsp_chrg_c=>sc_node_attribute-itemchargeelement-rate_amount_curr TO ls_mod_tcc-changed_fields.
        APPEND ls_mod_tcc TO gt_mod_tcc.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD save.
    DATA: lo_change_action    TYPE REF TO /bobf/if_tra_change,
          lo_message_action   TYPE REF TO /bobf/if_frw_message,
          lt_failed_key       TYPE /bobf/t_frw_key,
          lt_return           TYPE bapiret2_tab,
          lv_rejected         TYPE boole_d,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

    IF gt_mod_tsp IS NOT INITIAL.

      go_srv_tor->modify( EXPORTING it_modification = gt_mod_tsp
                         IMPORTING eo_change        = lo_change
                                   eo_message       = lo_message ).

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                              EXPORTING
                                                               iv_action_messages = space
                                                               io_message         = lo_message
                                                              CHANGING
                                                               ct_bapiret2 = lt_return
                                                             ).

*
*      lo_message->get_messages(
**                 EXPORTING
**                   iv_severity             =
**                   iv_consistency_messages = abap_true
**                   iv_action_messages      = abap_true
*        IMPORTING
*          et_message              = DATA(lt_message)
*
*
*      ).

*      data(lv_msg_txt) = lt_message[ 1 ]-message->get_text( ).

      IF lt_return IS INITIAL.

        go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                          IMPORTING ev_rejected            = lv_rejected
                                    eo_change              = lo_change
                                    eo_message             = lo_message_save
                                    et_rejecting_bo_key    = ls_rejecting_bo_key ).




        lo_message_save->get_messages(
*                     EXPORTING
*                       iv_severity             =
*                       iv_consistency_messages = abap_true
*                       iv_action_messages      = abap_true
        IMPORTING
        et_message              = DATA(lt_message)


    ).

*        DATA(lv_msg_txt1) = lt_message[ 1 ]-message->get_text( ).
*        DATA(lv_msg_txt2) = lt_message[ 2 ]-message->get_text( ).
*        DATA(lv_msg_txt3) = lt_message[ 3 ]-message->get_text( ).
*        DATA(lv_msg_txt4) = lt_message[ 4 ]-message->get_text( ).

        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                               EXPORTING
                                                                iv_action_messages = space
                                                                io_message         = lo_message
                                                               CHANGING
                                                                ct_bapiret2 = lt_return
                                                              ).
        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO gt_messages.
        ENDIF.

      ELSE.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD create_delivery.

    DATA: lt_dates     TYPE TABLE OF bapidlvdeadln,
          lt_items     TYPE TABLE OF bapidlvnorefitem,
          ls_items     LIKE LINE OF lt_items,
          lt_return    TYPE TABLE OF bapiret2,
          lv_delivery  TYPE vbeln,
          lv_timestamp TYPE timestamp,
          lv_matnr     TYPE matnr.

    SELECT SINGLE doc~docnum,
                  doc~manual,
                  doc~branch,
                  doc~parid,
                  doc~vstel,
                  lin~matnr,
                  lin~menge,
                  lin~meins,
                  lin~werks,
                  t001w~vkorg
      FROM j_1bnfdoc AS doc
      INNER JOIN j_1bnflin AS lin   ON lin~docnum       = doc~docnum
      INNER JOIN t001w     AS t001w ON t001w~j_1bbranch = doc~branch
      INTO @DATA(ls_doc)
      WHERE doc~docnum EQ @iv_docnum.                  "#EC CI_BUFFJOIN

    IF sy-subrc      IS INITIAL." AND
*       ls_doc-manual EQ abap_true.

      IF ls_doc-vstel IS INITIAL.
        ls_doc-vstel = ls_doc-werks.
      ENDIF.

      CLEAR: lv_delivery.

      GET TIME STAMP FIELD lv_timestamp.

      "delivery date
      INSERT VALUE #( timetype      = 'WSHDRLFDAT'
                      timestamp_utc = lv_timestamp
                      timezone      = sy-zonlo
                    ) INTO TABLE lt_dates.

      "Goods issue date
      INSERT VALUE #( timetype      = 'WSHDRWADAT'
                      timestamp_utc = lv_timestamp
                      timezone      = sy-zonlo
                    ) INTO TABLE lt_dates.

      DATA(lo_param) = NEW zclca_tabela_parametros( ).

      TRY.
          lo_param->m_get_single(
            EXPORTING
              iv_modulo = 'TM'
              iv_chave1 = 'MATNR'
            IMPORTING
              ev_param  = lv_matnr ).
        CATCH zcxca_tabela_parametros.

      ENDTRY.

*      ls_items-material   = ls_doc-matnr.
      ls_items-material   = |{ lv_matnr ALPHA = IN }|.
      ls_items-dlv_qty    = ls_doc-menge.
      ls_items-sales_unit = ls_doc-meins.
      ls_items-plant      = ls_doc-werks.
      ls_items-item_categ = 'LDN'.
      APPEND ls_items TO lt_items.

      CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATENOREF'
        EXPORTING
          ship_point = ls_doc-vstel
          dlv_type   = 'LD'
          salesorg   = ls_doc-vkorg
          distr_chan = '10'
          division   = '99'
          ship_to    = ls_doc-parid
        IMPORTING
          delivery   = lv_delivery
        TABLES
          dates      = lt_dates
          dlv_items  = lt_items
          return     = lt_return.

      IF lv_delivery IS NOT INITIAL.

        rv_remessa = lv_delivery.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

*        WAIT UP TO 3 SECONDS.
*
*        SELECT SINGLE *
*          FROM likp
*          INTO @DATA(ls_likp)
*        WHERE vbeln = @lv_delivery.
*
*        IF sy-subrc IS INITIAL.
*          ls_likp-vsbed = '00'.
**          ls_likp-tm_ctrl_key = '0053'.
*
*          MODIFY likp FROM ls_likp.
*
*          COMMIT WORK.
*        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
