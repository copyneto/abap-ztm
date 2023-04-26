FUNCTION zfmtm_gko_save.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GKO_HEADER) TYPE  ZTTM_GKOT001
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lo_svs_mgr         TYPE REF TO /bobf/if_tra_service_manager,
        lo_transaction_mgr TYPE REF TO /bobf/if_tra_transaction_mgr,
        lo_message         TYPE REF TO /bobf/if_frw_message,
        lt_failed_keys     TYPE /bobf/t_frw_key,
        lt_tor             TYPE /scmtms/t_tor_root_k,
        ls_tor             TYPE /scmtms/s_tor_root_k,
        lt_parameters      TYPE /bobf/t_frw_query_selparam,
        ls_calc_base_param TYPE REF TO /scmtms/s_tcc_calc_base_param,
        lt_message         TYPE bapiret2_tab,
        lt_changed         TYPE /bobf/t_frw_name,
        lt_mod_root        TYPE /bobf/t_frw_modification,
        lt_return          TYPE bapiret2_tab,
        lt_keys            TYPE /bobf/t_frw_key,
        lt_tcc             TYPE /scmtms/t_tcc_root_k,
        lt_chrel           TYPE /scmtms/t_tcc_trchrg_element_k,
        lt_chrel_sort      TYPE /scmtms/t_tcc_trchrg_element_k,
        lt_chitem          TYPE /scmtms/t_tcc_chrgitem_k.

  CONSTANTS: lc_sign_i    TYPE char1   VALUE 'I',
             lc_option_eq TYPE char2   VALUE 'EQ'.

  lo_svs_mgr  = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
  lo_transaction_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

  IF is_gko_header-tor_id IS NOT INITIAL.

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
    <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-tor_id.
    <fs_parameters>-sign   = lc_sign_i.
    <fs_parameters>-option = lc_option_eq.
    <fs_parameters>-low    = is_gko_header-tor_id.

    lo_svs_mgr->query(
                         EXPORTING
                           iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                           it_selection_parameters = lt_parameters
                           iv_fill_data            = abap_true
                         IMPORTING
                           et_key                  = lt_keys
                           et_data                 = lt_tor
                       ).

  ENDIF.

  IF lt_tor IS NOT INITIAL.
    IF lt_tor[ 1 ]-tspid IS NOT INITIAL.
      DATA(lv_supplier) = lt_tor[ 1 ]-tspid.

      SELECT SINGLE supplier,
                    taxnumber1
        FROM i_supplier
        INTO @DATA(ls_supplier)
        WHERE supplier EQ @lv_supplier.

      IF sy-subrc IS INITIAL.
        IF is_gko_header-emit_cnpj_cpf NE ls_supplier-taxnumber1.
          APPEND INITIAL LINE TO et_return ASSIGNING FIELD-SYMBOL(<fs_return>).
          <fs_return>-type       = if_xo_const_message=>error.
          <fs_return>-id         = 'ZTM_GKO'.
          <fs_return>-number     = '119'.
          <fs_return>-message_v1 = |{ lt_tor[ 1 ]-tor_id ALPHA = OUT }|.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    CLEAR lt_keys.
    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = lt_tor[ 1 ]-key CHANGING ct_key = lt_keys ).

    IF lt_tor[ 1 ]-tsp IS INITIAL.
      APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
      <fs_return>-type       = if_xo_const_message=>error.
      <fs_return>-id         = '/SCMTMS/TOR'.
      <fs_return>-number     = '023'.
      <fs_return>-message_v1 = |{ lt_tor[ 1 ]-tor_id ALPHA = OUT }|.
      RETURN.
    ENDIF.

    lo_svs_mgr->retrieve_by_association(
       EXPORTING
         iv_node_key    = /scmtms/if_tor_c=>sc_node-root
         it_key         = lt_keys
         iv_association = /scmtms/if_tor_c=>sc_association-root-transportcharges
         iv_fill_data   = abap_true
       IMPORTING
         et_data        = lt_tcc
         et_target_key  = DATA(lt_tcc_keys) ).

    /scmtms/cl_tcc_calc_utility=>get_bo_do_assoc(
      EXPORTING
        iv_bo_key        = /scmtms/if_tor_c=>sc_bo_key
        iv_node_key      = /scmtms/if_tor_c=>sc_node-root
        iv_do_key        = /scmtms/if_tcc_trnsp_chrg_c=>sc_bo_key
      IMPORTING
        ev_root_node_key = DATA(lv_do_key)
        ev_assoc_key     = DATA(lv_bo_do_assoc_key) ).

    DATA(lv_root_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = lv_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-root ).

    DATA(lv_it_chrg_it_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = lv_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-chargeitem ).

    DATA(lv_it_chrg_el_node_key) = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = lv_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-itemchargeelement ).

    DATA(lv_chrg_chargit_assoc_key) = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = lv_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-root-chargeitem ).

    DATA(lv_chrgit_itchrgel_assoc_key) = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = lv_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-chargeitem-itemchargeelement ).

    lo_svs_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = lv_do_key
        it_key         = lt_tcc_keys
        iv_association = lv_chrg_chargit_assoc_key
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_chitem
        et_target_key  = DATA(lt_chitemkeys) ).

    IF lt_chitem[] IS INITIAL.

      CREATE DATA ls_calc_base_param.
      lo_svs_mgr->do_action( EXPORTING iv_act_key           = /scmtms/if_tor_c=>sc_action-root-calc_transportation_charges
                                       it_key               = lt_keys
                                       is_parameters        = ls_calc_base_param
                             IMPORTING et_failed_key        = lt_failed_keys
                                       eo_message           = lo_message ).

      lo_transaction_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                                IMPORTING ev_rejected         = DATA(lv_rejected)
                                          eo_change           = DATA(lo_change)
                                          eo_message          = DATA(lo_message_save)
                                          et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).

      IF NOT lo_message_save IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
        ENDIF.
        CLEAR lo_message_save.
      ENDIF.
    ENDIF.

*    ELSE.
*
*      et_return = CORRESPONDING #( lt_message ).
*
*    ENDIF.

    ls_tor = lt_tor[ 1 ].

    IF ls_tor-purch_company_code   IS INITIAL AND
       ls_tor-purch_company_org_id IS INITIAL.

      SELECT SINGLE t001w~werks,
                    t001w~vkorg,
                    hrp5561~objid
        FROM        t001w         AS t001w
        INNER JOIN  /scmb/hrp5561 AS hrp5561 ON hrp5561~logqs_id = t001w~vkorg
        INTO @DATA(ls_t001w)
        WHERE werks EQ @is_gko_header-werks.

      IF sy-subrc IS INITIAL.
        ls_tor-purch_company_code   = ls_t001w-vkorg.
        ls_tor-purch_company_org_id = ls_t001w-objid.

        APPEND: 'PURCH_COMPANY_CODE'   TO lt_changed,
                'PURCH_COMPANY_ORG_ID' TO lt_changed.

        " Atualiza campos da Ordem de Frete
        TRY.
            zcltm_manage_of=>change_of( CHANGING  cs_root      = ls_tor
                                                  ct_changed   = lt_changed ).
          CATCH cx_root.
        ENDTRY.

        "Atualização do TOR
        INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                        node           = /scmtms/if_tor_c=>sc_node-root
                        key            = ls_tor-key
                        changed_fields = lt_changed
                        data           = REF #( ls_tor ) ) INTO TABLE lt_mod_root.

        lo_svs_mgr->modify( EXPORTING it_modification = lt_mod_root         " Changes
                            IMPORTING eo_change       = lo_change           " Interface of Change Object
                                      eo_message      = lo_message ).       " Interface of Message Object

        IF NOT lo_message IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO et_return.
          ENDIF.
          CLEAR lo_message.
        ENDIF.

        lo_transaction_mgr->save( IMPORTING eo_message = lo_message ).

        IF NOT lo_message IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO et_return.
          ENDIF.
          CLEAR lo_message.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFUNCTION.
