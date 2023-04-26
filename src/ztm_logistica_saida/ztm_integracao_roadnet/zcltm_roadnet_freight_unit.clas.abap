CLASS zcltm_roadnet_freight_unit DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS:
      fu_split_stage
        IMPORTING
          is_dados         TYPE zcltm_roadnet_integration=>ty_input_roadnet
          it_stops         TYPE zcltm_dt_consulta_sessao_r_tab
          it_fu_root       TYPE zcltm_roadnet_integration=>ty_tt_fu_root
        RETURNING
          VALUE(rt_return) TYPE bapiret2_tab.

    DATA:
      go_srv_tor TYPE REF TO /bobf/if_tra_service_manager.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      convert_loc_to_key
        IMPORTING
          iv_locid         TYPE /sapapo/locno
        RETURNING
          VALUE(rv_return) TYPE /scmb/mdl_locid,

      update_fu_stops
        IMPORTING
          it_fu_root_keys    TYPE /bobf/t_frw_key
          iv_planed_outbound TYPE /scmtms/stop_plan_date
          iv_planed_inbound  TYPE /scmtms/stop_plan_date,

      split_stage_fu
        IMPORTING
          it_fu_root_keys  TYPE /bobf/t_frw_key
          it_roadnet_stops TYPE zcltm_dt_consulta_sessao_r_tab
          it_fu_root       TYPE zcltm_roadnet_integration=>ty_tt_fu_root
          iv_dest_locid    TYPE /sapapo/locno,

      determine_fu_stop_changed_flds
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_name,

      assign_execution_messages
        IMPORTING
          io_message TYPE REF TO /bobf/if_frw_message,

      is_transhipment_storage
        IMPORTING
          is_dados         TYPE zcltm_roadnet_integration=>ty_input_roadnet
        RETURNING
          VALUE(rv_return) TYPE abap_bool,

      save_fu_modifications.
    DATA:
      gt_execution_messages TYPE bapiret2_tab.
ENDCLASS.



CLASS zcltm_roadnet_freight_unit IMPLEMENTATION.
  METHOD fu_split_stage.
    CHECK is_transhipment_storage( is_dados ).

    go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lt_fu_root_keys) = CORRESPONDING /bobf/t_frw_key( it_fu_root MAPPING key = db_key ).

    update_fu_stops(
      it_fu_root_keys    = lt_fu_root_keys
      iv_planed_outbound = is_dados-planed_outbound
      iv_planed_inbound  = is_dados-planed_inbound
    ).
    split_stage_fu(
      it_fu_root_keys  = lt_fu_root_keys
      it_roadnet_stops = it_stops
      it_fu_root       = it_fu_root
      iv_dest_locid    = is_dados-dest_locid
    ).
    save_fu_modifications( ).

    rt_return = gt_execution_messages.
  ENDMETHOD.

  METHOD split_stage_fu.
    DATA(lv_loc_uuid) = convert_loc_to_key( iv_dest_locid ).

    go_srv_tor->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = it_fu_root_keys
        iv_association = /scmtms/if_tor_c=>sc_association-root-stop_succ
      IMPORTING
        et_key_link    = DATA(lt_stop_succ_keys_link)
    ).
    data lt_stop_succ_keys_link_2 type /bobf/t_frw_key_link.
    LOOP AT lt_stop_succ_keys_link ASSIGNING FIELD-SYMBOL(<fs_stop_succ_keys_link>).
    DATA(lv_tabix) = sy-tabix.
      DATA(lt_line) = FILTER /bobf/t_frw_key_link( lt_stop_succ_keys_link WHERE source_key = <fs_stop_succ_keys_link>-source_key  ).
      IF lines( lt_line ) = 1.
        APPEND <fs_stop_succ_keys_link> TO lt_stop_succ_keys_link_2.
      ENDIF.
    ENDLOOP.

    DATA ls_param_action_split TYPE REF TO data.
    LOOP AT it_roadnet_stops ASSIGNING FIELD-SYMBOL(<fs_stops>).

      DATA(lt_fu_stop_succ_first) = VALUE /bobf/t_frw_key(
        FOR <fs_order> IN <fs_stops>-orders
        LET lv_root_key = VALUE #(  it_fu_root[ KEY sec_base_btd_id COMPONENTS
              base_btd_id = CONV #( |{ <fs_order>-order_number ALPHA = IN }| ) ]-db_key OPTIONAL )
            lv_target_key = VALUE #( lt_stop_succ_keys_link_2[ source_key = lv_root_key ]-target_key OPTIONAL )  IN
        ( key = lv_target_key )
      ).

      DELETE lt_fu_stop_succ_first WHERE key is INITIAL.
      IF lt_fu_stop_succ_first IS NOT INITIAL.
        DATA(ls_param_split_succ) = VALUE /scmtms/s_tor_act_succ_addstag(
          new_loc_key         = lv_loc_uuid
          arrival_timestamp   = <fs_stops>-arrival
          departure_timestamp = <fs_stops>-arrival
        ).
        GET REFERENCE OF ls_param_split_succ INTO ls_param_action_split.
        go_srv_tor->do_action(
          EXPORTING
            iv_act_key            = /scmtms/if_tor_c=>sc_action-stop_successor-split_stage
            it_key                = lt_fu_stop_succ_first
            is_parameters         = ls_param_action_split
          IMPORTING
            eo_change             = DATA(lo_change_action)
            eo_message            = DATA(lo_message_action)
            et_failed_action_key  = DATA(lt_failed_action_key)
            et_failed_key         = DATA(lt_failed_key)
        ).
        assign_execution_messages( lo_message_action ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update_fu_stops.
    DATA:
      lt_fu_stops       TYPE /scmtms/t_tor_stop_k,
      lt_fu_stops_modif TYPE /bobf/t_frw_modification.

    go_srv_tor->retrieve_by_association(
      EXPORTING
        it_key         = it_fu_root_keys
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-stop
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_fu_stops
    ).
    IF lt_fu_stops IS NOT INITIAL.
      MODIFY lt_fu_stops FROM VALUE #(
        acc_start = iv_planed_outbound
        req_end   = iv_planed_outbound
        req_start = iv_planed_outbound
      ) TRANSPORTING acc_start req_end req_start
      WHERE stop_cat = /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.

      MODIFY lt_fu_stops FROM VALUE #(
        acc_end   = iv_planed_inbound
        req_end   = iv_planed_inbound
        req_start = iv_planed_inbound
      ) TRANSPORTING acc_end req_end req_start
      WHERE stop_cat = /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.

      /scmtms/cl_mod_helper=>mod_update_multi(
        EXPORTING
          it_data            = lt_fu_stops
          iv_node            = /scmtms/if_tor_c=>sc_node-stop
          iv_bo_key          = /scmtms/if_tor_c=>sc_bo_key
          it_changed_fields  = determine_fu_stop_changed_flds( )
          iv_autofill_fields = abap_false
        CHANGING
          ct_mod             = lt_fu_stops_modif
      ).
      go_srv_tor->modify(
        EXPORTING
          it_modification = lt_fu_stops_modif
        IMPORTING
          eo_message = DATA(lo_modify_fu_stops)
      ).
      assign_execution_messages( lo_modify_fu_stops ).
    ENDIF.
  ENDMETHOD.

  METHOD determine_fu_stop_changed_flds.
    rt_return = VALUE #(
      ( |ACC_START| )
      ( |ACC_END| )
      ( |REQ_START| )
      ( |REQ_START| )
    ).
  ENDMETHOD.

  METHOD convert_loc_to_key.
    SELECT loc_uuid UP TO 1 ROWS
      FROM /sapapo/loc
      INTO @rv_return
      WHERE locno = @iv_locid.
    ENDSELECT.
  ENDMETHOD.

  METHOD assign_execution_messages.
    DATA lt_messages_bapiret TYPE bapiret2_tab.

    CHECK io_message IS NOT INITIAL.
    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
      EXPORTING
        io_message  = io_message
      CHANGING
        ct_bapiret2 = lt_messages_bapiret
    ).
    APPEND LINES OF lt_messages_bapiret TO gt_execution_messages.
  ENDMETHOD.

  METHOD save_fu_modifications.
    CHECK NOT line_exists( gt_execution_messages[ type = 'E' ] ). "#EC CI_STDSEQ
    DATA(lo_txn_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    lo_txn_mgr->save(
      EXPORTING
        iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
      IMPORTING
        ev_rejected            = DATA(lv_rejected)
        eo_change              = DATA(lo_change_save)
        eo_message             = DATA(lo_message_save)
        et_rejecting_bo_key    = DATA(ls_rejecting_bo_key)
    ).
    wait up to 10 seconds.
    assign_execution_messages( lo_message_save ).
    lo_txn_mgr->cleanup( 2 ).
  ENDMETHOD.

  METHOD is_transhipment_storage.
    IF is_dados-ori_loctype = 'DPT' AND is_dados-dest_loctype = 'DPT'.
      SELECT loctype FROM /sapapo/loc INTO TABLE @DATA(lt_loctype)
       WHERE locno = @is_dados-ori_locid
          OR locno = @is_dados-dest_locid.
      IF sy-subrc = 0.
        LOOP AT lt_loctype ASSIGNING FIELD-SYMBOL(<fs_loctype>).
          CASE <fs_loctype>-loctype." lv_loctype.
            WHEN '1170'.
              rv_return = abap_true.
            WHEN '1005'.
              rv_return = abap_false.
              EXIT.
          ENDCASE.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
