class ZCLTM_VALIDATION_QTDE_FU definition
  public
  inheriting from /SCMTMS/CL_TOR_V_NODE_SUPER
  create public .

public section.

  methods /BOBF/IF_FRW_VALIDATION~EXECUTE
    redefinition .
*    TYPES:
*      BEGIN OF ts_msg_property,
*        source_node    TYPE /bobf/obm_node_key,
*        source_key     TYPE /bobf/conf_key,
*        content_cat    TYPE /bobf/obm_content_cat,
*        content_key    TYPE /bobf/conf_key,
*        attribute_name TYPE string,
*        property_name  TYPE /bobf/obm_property_name,
*        value          TYPE boole_d,
*        msg            TYPE symsg,
*      END OF ts_msg_property .
*    TYPES:
*      BEGIN OF ts_msg_mapping,
*        source_node TYPE /bobf/obm_node_key,
*        source_key  TYPE /bobf/conf_key,
*        msgno       TYPE symsgno,
*        msgv1       TYPE  symsgv,
*      END OF ts_msg_mapping .
*    TYPES:
*      tt_msg_property TYPE HASHED TABLE OF ts_msg_property
*                      WITH UNIQUE KEY source_node
*                                      source_key
*                                      content_cat
*                                      content_key
*                                      attribute_name
*                                      property_name .
*    TYPES:
*      tt_msg_mapping TYPE HASHED TABLE OF ts_msg_mapping
*                      WITH UNIQUE KEY source_node
*                                      source_key
*                                      msgno .
*
*    TYPES:
*      BEGIN OF ts_requested_properties,
*        node_update_enable  TYPE abap_bool,
*        node_delete_enable  TYPE abap_bool,
*        subtr_create_enable TYPE abap_bool,
*        subtr_update_enable TYPE abap_bool,
*        subtr_delete_enable TYPE abap_bool,
*        attr_enabled        TYPE abap_bool,
*        attr_mandatory      TYPE abap_bool,
*        attr_readonly       TYPE abap_bool,
*        action_enabled      TYPE abap_bool,
*        assoc_create_enable TYPE abap_bool,
*        assoc_enabled       TYPE abap_bool,
*      END OF ts_requested_properties .
*
*    TYPES:
*      BEGIN OF ts_changed_properties,
*        node_changed   TYPE abap_bool,
*        attr_changed   TYPE abap_bool,
*        assoc_changed  TYPE abap_bool,
*        action_changed TYPE abap_bool,
*      END OF ts_changed_properties .
*    TYPES:
*      tt_action_whitelist TYPE HASHED TABLE OF /bobf/act_key WITH UNIQUE KEY table_line .
*    TYPES:
*      tt_act_key TYPE STANDARD TABLE OF /bobf/act_key WITH DEFAULT KEY .
*    TYPES:
*      BEGIN OF ty_node_attr_action,
*        node_key   TYPE /bobf/obm_node_key,
*        attributes TYPE /bobf/t_frw_name,
*        actions    TYPE tt_act_key,
*      END OF ty_node_attr_action .
*    TYPES:
*      tt_node_attr_action  TYPE HASHED TABLE OF ty_node_attr_action WITH UNIQUE KEY node_key .
*
*    TYPES:
*      ty_requested_attribute TYPE c LENGTH 30 .
*    TYPES:
*      tt_requested_attributes TYPE HASHED TABLE OF ty_requested_attribute WITH UNIQUE KEY table_line .
protected section.
private section.

  class-data GV_CHECKS_DONE type BOOLEAN .
ENDCLASS.



CLASS ZCLTM_VALIDATION_QTDE_FU IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA: ls_ctx        TYPE /scmtms/cl_tcc_do_helper=>ts_ctx,
          lt_mod        TYPE /bobf/t_frw_modification,
          lt_tor_root   TYPE /scmtms/t_tor_root_k,
          lt_tor_assign TYPE /scmtms/t_tor_root_k,
          lt_tor_key    TYPE /bobf/t_frw_key,
          lt_failed_key TYPE /bobf/t_frw_key,
          lo_message    TYPE REF TO /bobf/if_frw_message.

    CLEAR et_failed_key.

    CHECK sy-batch IS INITIAL.

    CHECK is_ctx-val_time = 'CHECK_BEFORE_SAVE' OR
          is_ctx-val_time = 'CHECK'             OR
          is_ctx-val_time = 'AFTER_MODIFY'.

    CHECK gv_checks_done = abap_false.

    ls_ctx-host_bo_key = /scmtms/if_tor_c=>sc_bo_key.
    ls_ctx-host_node_key = /scmtms/if_tor_c=>sc_node-root.
    ls_ctx-host_root_node_key = /scmtms/if_tor_c=>sc_node-root.

    CHECK it_key IS NOT INITIAL.

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_tor_root    ).


    DATA(lt_fo) = lt_tor_root.
    DELETE lt_fo WHERE tor_cat <> 'TO'.

    CHECK lt_fo IS NOT INITIAL.

    DATA(ls_fo) = lt_fo[ 1 ].

    CHECK ls_fo-tor_type = '1030'.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_txn_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    INSERT VALUE #( key = ls_fo-key ) INTO TABLE lt_tor_key.

    lo_tor_mgr->retrieve_by_association(
      EXPORTING
        it_key         = lt_tor_key
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_tor_assign
        et_key_link    = DATA(lt_link) ).

    DATA(lt_fus) = lt_tor_root.
    DELETE lt_fus WHERE tor_cat <> 'FU'.

*
    DESCRIBE TABLE lt_tor_assign LINES DATA(lv_lines).

    CHECK lv_lines > 1.

*    DATA:
*      ls_parameters TYPE /scmtms/s_tor_a_root_remassgn,
*      ls_link       TYPE /bobf/s_frw_key_link,
*      lt_param      TYPE REF TO data.
*
*
**    ls_parameters-remove_links_to_tor   = abap_true.
*    ls_parameters-remove_links_from_tor = abap_true.
*
*    LOOP AT lt_fus INTO DATA(ls_key).
*
*      ls_link = lt_link[ target_key = ls_key-key ].
*      APPEND ls_link TO ls_parameters-kl_req_capa_root.
*
*    ENDLOOP.
*
*
*    GET REFERENCE OF ls_parameters INTO lt_param.

*    lo_tor_mgr->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-remove_tor_assignments
*                                     it_key                = lt_tor_key
*                                     is_parameters         = lt_param
*                           IMPORTING eo_change             = DATA(lo_change_action)
*                                     eo_message            = DATA(lo_message_action)
*                                     et_failed_action_key  = DATA(lt_failed_action_key)
*                                     et_failed_key         = lt_failed_key ).
*
*
*
*    lo_txn_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                      IMPORTING ev_rejected         = DATA(lv_rejected)
*                                eo_change           = DATA(lo_change)
*                                eo_message          = DATA(lo_message_save)
*                                et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).



*    /scmtms/cl_mod_helper=>mod_delete_single(
*      EXPORTING
*        iv_node            = is_ctx-node_key
*        iv_key             = lt_fus[ 1 ]-key
*      IMPORTING
*        es_mod             = DATA(ls_mod) ).
*
*    INSERT ls_mod INTO TABLE lt_mod.

*    IF lt_mod IS NOT INITIAL.
*      CALL METHOD lo_tor_mgr->modify( lt_mod ).
*    ENDIF.

*    MESSAGE e000(su) WITH 'Não permitido mais de uma FU' INTO DATA(lv_text).
*    _set_action_enabled_msg is_ctx-act_key abap_false.

**    LOOP AT lt_tor_root INTO DATA(ls_tor_root).
*    LOOP AT lt_tor_root INTO DATA(ls_tor_root).
*
*      INSERT VALUE #( key = ls_tor_root-key ) INTO TABLE et_failed_key.
*      MESSAGE e000(su) WITH 'Não permitido mais de uma FU' INTO DATA(lv_text).
*
**      eo_message->add_message(
**        EXPORTING
**          is_msg       = VALUE #( msgty = sy-msgty
**                                  msgid = sy-msgid
**                                  msgno = sy-msgno
**                                  msgv1 = sy-msgv1
**                         )
**          iv_node      = is_ctx-node_key
**          iv_key       = ls_tor_root-key
**      ).
*
*    CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
*      EXPORTING
*        iv_key      = ls_tor_root-key
*        iv_node_key = /scmtms/if_tor_c=>sc_node-root
*      CHANGING
*        co_message  = eo_message.
*
*    ENDLOOP.
    INSERT VALUE #( key = ls_fo-key ) INTO TABLE et_failed_key.
    MESSAGE e000(su) WITH TEXT-001  "'Não permitido mais de uma FU'
                          TEXT-002 "'em FO tipo'
                          ls_fo-tor_type INTO DATA(lv_text).

    CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
      EXPORTING
        iv_key       = ls_fo-key
        iv_node_key  = /scmtms/if_tor_c=>sc_node-root
        iv_probclass = /scmtms/cl_applog_helper=>sc_al_probclass_very_important
      CHANGING
        co_message   = eo_message.


*    DATA ls_error_location TYPE /bobf/s_frw_location.
**    DATA lo_message_add TYPE REF TO /bobf/cm_frw. "/bobf/cm_sepm_soq_messages.
*
*    DATA: lo_message_add TYPE REF TO /bobf/cm_epm_sq_messages,
*          ls_messageid   TYPE scx_t100key.
*
*    ls_error_location-bo_key   = /scmtms/if_tor_c=>sc_bo_key.
*    ls_error_location-node_key = /scmtms/if_tor_c=>sc_node-root.
*    ls_error_location-key      = ls_fo-key.
**    INSERT zif_d_sales_quote_c=>sc_node_attribute-item-discount
**    INTO TABLE ls_error_location-attributes.
*    " 2.) Create message
*
**     DATA(lo_message_add) = NEW /bobf/cm_frw(         textid             = /bobf/cm_sepm_soq_messages=>gc_invalid_discount_rate
**        severity           = /bobf/cm_sepm_soq_messages=>co_severity_error
**        symptom            = /bobf/if_frw_message_symptoms=>co_bo_inconsistency
**        ms_origin_location = ls_error_location ).
*
*
*    ls_messageid-msgid = 'SU'.
*    ls_messageid-msgno = 000.
*    ls_messageid-attr1 = TEXT-001.
*    ls_messageid-attr2 = TEXT-002.
*    ls_messageid-attr3 = ls_fo-tor_type.
*
*
*    CREATE OBJECT lo_message_add
*      EXPORTING
*        textid             = ls_messageid
*        severity           = /bobf/cm_epm_sq_messages=>co_severity_error
*        symptom            = /bobf/if_frw_message_symptoms=>co_bo_inconsistency
*        ms_origin_location = ls_error_location.
*    " 3.) Add message to message object
*
*    IF eo_message IS NOT BOUND.
*      eo_message = /bobf/cl_frw_factory=>get_message( ).
*    ENDIF.
*    eo_message->add_cm( lo_message_add ).

    after_validation( ).

*        CALL METHOD /scmtms/cl_msg_helper=>msg_helper_add_symsg
*          EXPORTING
*            iv_bopf_location_key = /scmtms/if_tor_c=>sc_validation-root-val_bo_consistency
*            iv_key               = is_d_exec-key
*            iv_node_key          = /scmtms/if_tor_c=>sc_node-executioninformation
*            iv_attribute         = /scmtms/if_tor_c=>sc_node_attribute-executioninformation-exec_role_cat
*            iv_probclass         = /scmtms/cl_applog_helper=>sc_al_probclass_important
*          CHANGING
*            co_message           = co_message.
*        cv_k_failed = is_d_exec-root_key.


*    gv_checks_done = abap_true. " set to true so that when post_accrual action is called from confirm_accrual action this validation is not repeated.


  ENDMETHOD.
ENDCLASS.
