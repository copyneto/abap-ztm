CLASS zcltm_roadnet_freight_order DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      create_freight_order
        IMPORTING
          is_dados         TYPE zcltm_roadnet_integration=>ty_input_roadnet
          it_stops         TYPE zcltm_dt_consulta_sessao_r_tab
          it_fu_root       TYPE zcltm_roadnet_integration=>ty_tt_fu_root
        RETURNING
          VALUE(rt_return) TYPE bapiret2_tab.
    DATA:
      go_tor_serv_mgr TYPE REF TO /bobf/if_tra_service_manager.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      create_basic_freight_order
        RETURNING
          VALUE(rs_return) TYPE ty_complete_fo,

      determine_fo_modifications
        IMPORTING
          is_fo_data       TYPE ty_complete_fo
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_modification,

      assign_execution_messages
        IMPORTING
          io_message TYPE REF TO /bobf/if_frw_message,

      update_fo_root_modification
        IMPORTING
          is_fo_root       TYPE /scmtms/s_tor_root_k
        RETURNING
          VALUE(rs_return) TYPE /bobf/s_frw_modification,

      create_fo_doc_ref_modification
        IMPORTING
          is_fo_root       TYPE /scmtms/s_tor_root_k
        RETURNING
          VALUE(rs_return) TYPE /bobf/s_frw_modification,

      create_fo_exec_info_modificat
        IMPORTING
          is_fo_root       TYPE /scmtms/s_tor_root_k
        RETURNING
          VALUE(rs_return) TYPE /bobf/s_frw_modification,

      update_fo_items_modifications
        IMPORTING
          it_fo_items      TYPE /scmtms/t_tor_item_tr_k
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_modification ,

      update_fo_stops_modifications
        IMPORTING
          it_fo_stops      TYPE /scmtms/t_tor_stop_k
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_modification ,

      create_intermediate_stop_modif
        IMPORTING
          it_fo_complete   TYPE ty_complete_fo
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_modification ,

      determine_fo_header_data
        IMPORTING
          is_fo_root       TYPE /scmtms/s_tor_root_k
        RETURNING
          VALUE(rs_return) TYPE /scmtms/s_tor_root_k,

      determine_fo_doc_ref_data
        IMPORTING
          is_fo_root       TYPE /scmtms/s_tor_root_k
        RETURNING
          VALUE(rs_return) TYPE /scmtms/s_tor_docref_k,

      determine_fo_exec_info_data
        IMPORTING
          is_fo_root       TYPE /scmtms/s_tor_root_k
        RETURNING
          VALUE(rs_return) TYPE /scmtms/s_tor_exec_k,

      determine_fo_items_data
        IMPORTING
          it_fo_items      TYPE /scmtms/t_tor_item_tr_k
        RETURNING
          VALUE(rt_return) TYPE /scmtms/t_tor_item_tr_k,

      determine_fo_stops_data
        IMPORTING
          it_fo_stops      TYPE /scmtms/t_tor_stop_k
        RETURNING
          VALUE(rt_return) TYPE /scmtms/t_tor_stop_k,

      get_fo_root_changed_fields
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_name,

      get_fo_items_changed_fields
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_name,

      get_fo_stops_changed_fields
        RETURNING
          VALUE(rt_return) TYPE /bobf/t_frw_name,

      get_db_bp_data
        IMPORTING
          iv_bp            TYPE bu_partner
        RETURNING
          VALUE(rs_return) TYPE ty_db_bp_data,

      get_db_plant_data
        IMPORTING
          iv_plant         TYPE werks_d
        RETURNING
          VALUE(rs_return) TYPE ty_db_plant_data,

      get_db_infotyp5561_by_ext_id
        IMPORTING
          iv_external_id   TYPE /scmb/org_ext_id
        RETURNING
          VALUE(rs_return) TYPE hrobjid,

      get_db_orgunit_by_pur_compcode
        IMPORTING
          iv_short         TYPE short_d
        RETURNING
          VALUE(rs_return) TYPE hrobjid,

      get_db_fu_loc_by_delivy_loadin
        IMPORTING
          it_stops_seq_deliveries TYPE ty_tt_stop_seq_deliveries
        RETURNING
          VALUE(rt_return)        TYPE ty_tt_stop_seq_deliveries,

      get_db_fu_loc_by_delivy_unload
        IMPORTING
          it_stops_seq_deliveries TYPE ty_tt_stop_seq_deliveries
        RETURNING
          VALUE(rt_return)        TYPE ty_tt_stop_seq_deliveries,

      location_convert_to_altern_key
        RETURNING
          VALUE(rt_result) TYPE /bobf/t_frw_keyindex,

      convert_planed_date
        IMPORTING
          iv_planed_date   TYPE /scmtms/stop_plan_date
        RETURNING
          VALUE(rv_return) TYPE /scmtms/stop_plan_date,

      convert_string_utc_timestamp
        IMPORTING
          iv_date_string   TYPE string
        RETURNING
          VALUE(rv_return) TYPE /scmtms/stop_plan_date,

      calculate_acc_end_timestamp
        IMPORTING
          iv_service_time  TYPE string
          iv_arrival       TYPE string
        RETURNING
          VALUE(rs_return) TYPE /scmtms/stop_acc_end ,

      modify_fo_modifications
        IMPORTING
          it_fo_modifications TYPE /bobf/t_frw_modification,

      add_fu_by_fuid_into_fo
        IMPORTING
          it_fo_modifications TYPE /bobf/t_frw_modification,

      get_dc_distance_locfrom_locto
        IMPORTING
          iv_loc_from      TYPE /sapapo/loc-locid
          iv_loc_to        TYPE /sapapo/loc-locid
        RETURNING
          VALUE(rv_return) TYPE /sapapo/trm-dist,

      determine_docreference_cross
        IMPORTING
          iv_tor_id        TYPE /scmtms/tor_id
        RETURNING
          VALUE(rt_return) TYPE /scmtms/t_tor_docref_k,

      save_fo_modifications,
      update_docreference_cross.

    DATA:
      gt_execution_messages TYPE bapiret2_tab,
      gs_roadnet_data       TYPE zcltm_roadnet_integration=>ty_input_roadnet,
      gt_fo_stops           TYPE zcltm_dt_consulta_sessao_r_tab,
      gt_fo_stop_first      TYPE /scmtms/t_tor_stop_k,
      gt_fu_root            TYPE zcltm_roadnet_integration=>ty_tt_fu_root.
    CONSTANTS:
      gc_tortype         TYPE /scmtms/tor_type      VALUE '1010',
      gc_of_filha        TYPE /scmtms/btd_type_code VALUE 'OFFIL',
      gc_of_mae          TYPE /scmtms/btd_type_code VALUE 'OFMAE',
      gc_fo_cat          TYPE /scmtms/tor_category  VALUE 'TO',
      gc_itmtype_truc    TYPE /scmtms/tor_item_type VALUE 'TRUC',
      gc_itemcat_avr     TYPE /scmtms/item_category VALUE 'AVR',
      gc_btd_tco_roadnet TYPE /scmtms/btd_type_code VALUE 'ROADN',
      gc_evento_lib_car  TYPE /scmtms/tor_event     VALUE 'LIBERADO P/CARREGAR',
      gc_evento_fat_car  TYPE /scmtms/tor_event     VALUE 'FATURAR/CARREGAR'.

ENDCLASS.



CLASS zcltm_roadnet_freight_order IMPLEMENTATION.

  METHOD create_freight_order.
    go_tor_serv_mgr = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    gs_roadnet_data = is_dados.
    gt_fo_stops     = CORRESPONDING #( DEEP it_stops ).
    gt_fu_root      = it_fu_root.

    DATA(ls_fo_data) = create_basic_freight_order( ).
    DATA(lt_fo_modifications) = determine_fo_modifications( ls_fo_data ). "#EC CI_CONV_OK

    modify_fo_modifications( lt_fo_modifications ).
    add_fu_by_fuid_into_fo( lt_fo_modifications ).
    save_fo_modifications( ).
    update_docreference_cross( ).
    rt_return = gt_execution_messages.
  ENDMETHOD.


  METHOD determine_fo_modifications.
    APPEND update_fo_root_modification( is_fo_data-fo_root ) TO rt_return.
    APPEND LINES OF update_fo_items_modifications( is_fo_data-fo_item ) TO rt_return. "#EC CI_CONV_OK
    APPEND LINES OF update_fo_stops_modifications( is_fo_data-fo_stop ) TO rt_return. "#EC CI_CONV_OK
    APPEND LINES OF create_intermediate_stop_modif( is_fo_data ) TO rt_return. "#EC CI_CONV_OK
    APPEND create_fo_doc_ref_modification( is_fo_data-fo_root ) TO rt_return.
    APPEND create_fo_exec_info_modificat( is_fo_data-fo_root ) TO rt_return.
  ENDMETHOD.


  METHOD modify_fo_modifications.
    go_tor_serv_mgr->modify(
      EXPORTING
        it_modification = it_fo_modifications
      IMPORTING
        eo_change       = DATA(lo_change)
        eo_message      = DATA(lo_fo_complete_message)
    ).
    assign_execution_messages( lo_fo_complete_message ).
  ENDMETHOD.


  METHOD add_fu_by_fuid_into_fo.
    CHECK NOT line_exists( gt_execution_messages[ type = 'E' ] ). "#EC CI_STDSEQ

    DATA: lr_param_key  TYPE /bobf/s_frw_key,
          ls_parameters TYPE /scmtms/s_tor_a_add_elements,
          lt_param      TYPE REF TO data,
          lv_remessa    TYPE likp-vbeln,
          ls_indx       TYPE indx.

    DATA(lv_fu_total) = lines( gt_fu_root ).
    DATA(lv_multi_group_40) = 40.
    LOOP AT gt_fu_root ASSIGNING FIELD-SYMBOL(<fs_fus>).
      DATA(lv_current_fu_index) = sy-tabix.

      lv_remessa = |{ <fs_fus>-base_btd_id ALPHA = OUT }|.
      IF lv_remessa IS NOT INITIAL.
        lv_remessa = |{ lv_remessa ALPHA = IN }|.
        EXPORT remessa = lv_remessa TO DATABASE indx(zt) FROM ls_indx CLIENT sy-mandt ID lv_remessa.
      ENDIF.

      CLEAR : lr_param_key.
      lr_param_key-key = <fs_fus>-db_key.
      APPEND lr_param_key TO ls_parameters-target_item_keys.

      ls_parameters-string = COND #(
        WHEN lv_current_fu_index = 1
        THEN CONV char10( |{ <fs_fus>-tor_id ALPHA = OUT }| )
        ELSE |{ ls_parameters-string } { CONV char10( |{ <fs_fus>-tor_id ALPHA = OUT }| ) }|
      ).

      GET REFERENCE OF ls_parameters INTO lt_param.
      IF lv_current_fu_index <> lv_fu_total AND lv_current_fu_index <> lv_multi_group_40.
        CONTINUE.
      ENDIF.
      lv_multi_group_40 = lv_multi_group_40 + 40.

      go_tor_serv_mgr->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-add_fu_by_fuid
                                       it_key                = VALUE #( ( key = it_fo_modifications[ 1 ]-key ) )
                                       is_parameters         = lt_param
                             IMPORTING eo_change             = DATA(lo_change_action)
                                       eo_message            = DATA(lo_message_action)
                                       et_failed_action_key  = DATA(lt_failed_action_key)
                                       et_failed_key         = DATA(lt_failed_key)
      ).
      assign_execution_messages( lo_message_action ).
      CLEAR: ls_parameters,
             lo_message_action,
             lt_param.
    ENDLOOP.

  ENDMETHOD.

  METHOD save_fo_modifications.
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
    assign_execution_messages( lo_message_save ).
    lo_txn_mgr->cleanup( 2 ).
  ENDMETHOD.

  METHOD create_intermediate_stop_modif.
    DATA(lt_roadnet_fo_stops) = COND zcltm_dt_consulta_sessao_r_tab( "#EC CI_CONV_OK
      WHEN gs_roadnet_data-session_description = 'CROSS'
      THEN VALUE #( ( gt_fo_stops[ 1 ] ) )
      ELSE gt_fo_stops
    ).
    DATA(lt_stop_seq_deliveries) = VALUE ty_tt_stop_seq_deliveries(
      FOR <fs_roadnet_stops> IN lt_roadnet_fo_stops
        ( stop_sequence_number = <fs_roadnet_stops>-sequence_number
          transporddocreferenceid = '000000000000000000000000000' && |{ VALUE #( <fs_roadnet_stops>-orders[ 1 ]-order_number OPTIONAL ) ALPHA = IN }| )
    ).
    DATA(lt_loc_id_from_uf_stops) = COND #(
      WHEN gs_roadnet_data-session_description = 'CROSS'
      THEN get_db_fu_loc_by_delivy_loadin( lt_stop_seq_deliveries )
      ELSE get_db_fu_loc_by_delivy_unload( lt_stop_seq_deliveries )
    ).

    DATA lt_fo_stops TYPE /scmtms/t_tor_stop_k .
    DATA lt_fo_stop_succ TYPE /scmtms/t_tor_stop_succ_k.
    DATA lv_next_stop  TYPE /bobf/conf_key.

    DATA(lv_route_distance_balance) = gs_roadnet_data-route_distance_km.
    DATA(lv_total_fo_stops) = lines( lt_roadnet_fo_stops ).
    LOOP AT lt_roadnet_fo_stops ASSIGNING FIELD-SYMBOL(<fs_stop>).

      DATA(lv_acc_start) = COND #(
        WHEN gs_roadnet_data-session_description = 'CROSS'
        THEN gs_roadnet_data-planed_outbound
        ELSE convert_string_utc_timestamp( <fs_stop>-arrival )
      ).
      DATA(lv_acc_end) = COND #(
        WHEN gs_roadnet_data-session_description = 'CROSS'
        THEN gs_roadnet_data-planed_outbound
        ELSE calculate_acc_end_timestamp(
          iv_service_time = <fs_stop>-service_time
          iv_arrival      = <fs_stop>-arrival
        )
      ).
      DATA(ls_locationid_from_uf) = VALUE #( lt_loc_id_from_uf_stops[ stop_sequence_number = <fs_stop>-sequence_number ] OPTIONAL ). "#EC CI_SORTSEQ

      DATA(ls_stop_out) = VALUE /scmtms/s_tor_stop_k(
        key             = /bobf/cl_frw_factory=>get_new_key( )
        parent_key      = it_fo_complete-fo_root-key
        root_key        = it_fo_complete-fo_root-key
        stop_cat        = 'O'
        stop_id         = '0000000040'
        stop_seq_pos    = 'I' "Fixo?
        log_loc_uuid    = ls_locationid_from_uf-locationuuid
        log_locid       = ls_locationid_from_uf-locationid
        req_start       = lv_acc_end
        req_end         = lv_acc_end
        plan_trans_time = lv_acc_end
        sel_time        = lv_acc_end
        sched_ref_data_status = 'X' "Fixo?
      ).

      DATA(ls_stop_inb) = VALUE /scmtms/s_tor_stop_k(
        key             = COND #(
          WHEN ls_locationid_from_uf-stop_sequence_number = 1
          THEN /bobf/cl_frw_factory=>get_new_key( )
          ELSE lv_next_stop
        )
        parent_key      = it_fo_complete-fo_root-key
        root_key        = it_fo_complete-fo_root-key
        stop_cat        = 'I'
        stop_id         = '0000000030'
        stop_seq_pos    = 'I' "Fixo?
        log_loc_uuid    = ls_locationid_from_uf-locationuuid
        log_locid       = ls_locationid_from_uf-locationid
        req_start       = lv_acc_start
        req_end         = lv_acc_start
        plan_trans_time = lv_acc_start
        sel_time        = lv_acc_start
        aggr_assgn_start_l = lv_acc_start
        aggr_assgn_end_l = lv_acc_start
        sched_ref_data_status = 'X' "Fixo?
      ).
      IF ls_locationid_from_uf-stop_sequence_number = 1.
        DATA(lv_stop_key_first_stop) = ls_stop_inb-key.
        DATA(lv_distance_km_stop_succ_first) = CONV /scmtms/decimal_value( <fs_stop>-distance ).
      ENDIF.
      APPEND ls_stop_out TO lt_fo_stops.
      INSERT ls_stop_inb INTO TABLE lt_fo_stops.

      lv_route_distance_balance = lv_route_distance_balance - CONV /scmtms/decimal_value( <fs_stop>-distance ).

      DATA(lv_next_stop_distance) = COND #(
        WHEN ls_locationid_from_uf-stop_sequence_number < lv_total_fo_stops
        THEN lt_roadnet_fo_stops[ ls_locationid_from_uf-stop_sequence_number + 1 ]-distance
        ELSE COND #( WHEN lv_route_distance_balance < 0 THEN 0 ELSE lv_route_distance_balance )
      ).
      lv_next_stop_distance = COND #(
        WHEN gs_roadnet_data-session_description = 'CROSS'
        THEN get_dc_distance_locfrom_locto(
          iv_loc_from = CONV #( ls_stop_out-log_locid )
          iv_loc_to   = CONV #( gs_roadnet_data-dest_locid )
        )
        ELSE lv_next_stop_distance
      ).


      APPEND VALUE #(
        key             = /bobf/cl_frw_factory=>get_new_key( )
        root_key        = it_fo_complete-fo_root-key
        parent_key      = ls_stop_inb-key
        succ_stop_key   = ls_stop_out-key
        distance_km     = lv_next_stop_distance
        order_rel_type  = '02'  "fixo?
        stop_succ_cat   = 'I'   "fixo?
      ) TO lt_fo_stop_succ.

      lv_next_stop = /bobf/cl_frw_factory=>get_new_key( ).
      APPEND VALUE #(
        key             = /bobf/cl_frw_factory=>get_new_key( )
        root_key        = ls_stop_out-key
        parent_key = ls_stop_out-key
        succ_stop_key   = COND #( WHEN lv_total_fo_stops = ls_locationid_from_uf-stop_sequence_number
          THEN VALUE #( it_fo_complete-fo_stop[  stop_cat = 'I' ]-key OPTIONAL ) "#EC CI_SORTSEQ "stop_id = '0000000010'
          ELSE lv_next_stop
        )
        successor_id    = ( ls_locationid_from_uf-stop_sequence_number * 10 ) + 10
        distance_km     = lv_next_stop_distance
        order_rel_type  = '02'  "fixo?
        stop_succ_cat   = 'L'   "fixo?
      ) TO lt_fo_stop_succ.

    ENDLOOP.

    DATA(lt_stop_succ_first) = it_fo_complete-fo_stop_succ.

    READ TABLE lt_stop_succ_first ASSIGNING FIELD-SYMBOL(<fs_stop_succ_first>) INDEX 1.
    IF sy-subrc = 0.
      <fs_stop_succ_first>-succ_stop_key = lv_stop_key_first_stop.
      <fs_stop_succ_first>-distance_km = COND #(
        WHEN gs_roadnet_data-session_description = 'CROSS'
        THEN get_dc_distance_locfrom_locto(
          iv_loc_from = CONV #( gs_roadnet_data-ori_locid )
          iv_loc_to   = CONV #( ls_stop_inb-log_locid )
        )
        ELSE lv_distance_km_stop_succ_first
      ).
    ENDIF.
    /scmtms/cl_mod_helper=>mod_update_multi(
      EXPORTING
        it_data        = lt_stop_succ_first
        iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
        iv_node        = /scmtms/if_tor_c=>sc_node-stop_successor
        it_changed_fields  = VALUE #( ( |SUCC_STOP_KEY| ) ( |DISTANCE_KM| ) )
        iv_autofill_fields = ' '
      CHANGING
        ct_mod         = rt_return
    ).

    /scmtms/cl_mod_helper=>mod_create_multi(
      EXPORTING
        it_data        = lt_fo_stops
        iv_node        = /scmtms/if_tor_c=>sc_node-stop
        iv_source_node = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-stop
      CHANGING
        ct_mod         = rt_return
    ).

    /scmtms/cl_mod_helper=>mod_create_multi(
      EXPORTING
        it_data        = lt_fo_stop_succ
        iv_node        = /scmtms/if_tor_c=>sc_node-stop_successor
        iv_source_node = /scmtms/if_tor_c=>sc_node-stop
        iv_association = /scmtms/if_tor_c=>sc_association-stop-stop_successor
        iv_do_sorting  = abap_true
      CHANGING
        ct_mod         = rt_return ).
  ENDMETHOD.


  METHOD create_basic_freight_order.
    DATA: lo_fo_tour_message TYPE REF TO /bobf/if_frw_message.

    /scmtms/cl_tor_factory=>create_tor_tour(
      EXPORTING
        iv_do_modify            = abap_true
        iv_tor_type             = gc_tortype
        iv_create_initial_stage = abap_true
        iv_creation_type        = /scmtms/if_tor_const=>sc_creation_type-manual
      IMPORTING
        es_tor_root             = rs_return-fo_root
        et_tor_item             = rs_return-fo_item
        et_tor_stop             = rs_return-fo_stop
        et_tor_stop_succ        = rs_return-fo_stop_succ
      CHANGING
        co_message              = lo_fo_tour_message
    ).
    assign_execution_messages( lo_fo_tour_message ).
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


  METHOD update_fo_root_modification.
    DATA(ls_fo_header_data) = determine_fo_header_data( is_fo_root ).

    /scmtms/cl_mod_helper=>mod_update_single(
      EXPORTING
        iv_bo_key          = /scmtms/if_tor_c=>sc_bo_key
        iv_node            = /scmtms/if_tor_c=>sc_node-root
        is_data            = ls_fo_header_data
        iv_key             = ls_fo_header_data-key
        it_changed_fields  = get_fo_root_changed_fields( )
        iv_autofill_fields = ' '
      IMPORTING
        es_mod             = rs_return
    ).
  ENDMETHOD.


  METHOD create_fo_doc_ref_modification.
    DATA(ls_doc_ref_data) = determine_fo_doc_ref_data( is_fo_root ).
    /scmtms/cl_mod_helper=>mod_create_single(
      EXPORTING
        is_data        = ls_doc_ref_data
        iv_key         = ls_doc_ref_data-key
        iv_parent_key  = ls_doc_ref_data-parent_key
        iv_root_key    = ls_doc_ref_data-root_key
        iv_node        = /scmtms/if_tor_c=>sc_node-docreference
        iv_source_node = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
      IMPORTING
        es_mod         = rs_return
    ).
  ENDMETHOD.


  METHOD create_fo_exec_info_modificat.
    DATA(ls_exec_info_data) = determine_fo_exec_info_data( is_fo_root ).
    /scmtms/cl_mod_helper=>mod_create_single(
      EXPORTING
        is_data        = ls_exec_info_data
        iv_key         = ls_exec_info_data-key                                                                                                                 " NodeID
        iv_parent_key  = ls_exec_info_data-parent_key                                                                                                          " NodeID
        iv_root_key    = ls_exec_info_data-root_key                                                                                                            " NodeID
        iv_node        = /scmtms/if_tor_c=>sc_node-executioninformation                                                                              " Node
        iv_source_node = /scmtms/if_tor_c=>sc_node-root                                                                                              " Node
        iv_association = /scmtms/if_tor_c=>sc_association-root-exec                                                                                  " Association
      IMPORTING
        es_mod = rs_return
    ).
  ENDMETHOD.


  METHOD update_fo_items_modifications.
    /scmtms/cl_mod_helper=>mod_update_multi(
      EXPORTING
        it_data   = determine_fo_items_data( it_fo_items )
        iv_bo_key = /scmtms/if_tor_c=>sc_bo_key
        iv_node   = /scmtms/if_tor_c=>sc_node-item_tr
        it_changed_fields  = get_fo_items_changed_fields( )
        iv_autofill_fields = ' '
      CHANGING
        ct_mod    = rt_return
    ).
  ENDMETHOD.


  METHOD update_fo_stops_modifications.
    gt_fo_stop_first = determine_fo_stops_data( it_fo_stops ).

    /scmtms/cl_mod_helper=>mod_update_multi(
      EXPORTING
        it_data        = gt_fo_stop_first
        iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
        iv_node        = /scmtms/if_tor_c=>sc_node-stop
        it_changed_fields  = get_fo_stops_changed_fields( )
        iv_autofill_fields = ' '
      CHANGING
        ct_mod         = rt_return
    ).
  ENDMETHOD.


  METHOD determine_fo_doc_ref_data.
    rs_return = VALUE #(
      key        = /bobf/cl_frw_factory=>get_new_key( )
      parent_key = is_fo_root-key
      root_key   = is_fo_root-key
      btd_tco    = gc_btd_tco_roadnet
      btd_id     = gs_roadnet_data-internal_route_id
      btd_date   = sy-datum
    ).
  ENDMETHOD.


  METHOD determine_fo_exec_info_data.

    SELECT key, log_locid, log_loc_uuid
    FROM @gt_fo_stop_first AS _fo_stop_first
    WHERE _fo_stop_first~stop_cat = @/scmtms/if_tor_const=>sc_tor_stop_cat-outbound
    INTO @DATA(ls_stop_first_outbound)
    UP TO 1 ROWS.
    ENDSELECT.

    DATA(lv_first_deliv_first_stop) = VALUE #( gt_fo_stops[ 1 ]-orders[ 1 ]-order_number OPTIONAL ).
    DATA(lv_first_deliv_first_stop_conv) = CONV vbeln_vl( |{ lv_first_deliv_first_stop ALPHA = IN }| ).
    IF lv_first_deliv_first_stop_conv IS NOT INITIAL.
      SELECT SINGLE lprio FROM likp
      INTO @DATA(lv_delivery_lprio)
      WHERE vbeln EQ @lv_first_deliv_first_stop_conv.
      IF sy-subrc = 0.
        DATA(lv_fo_event) = COND /scmtms/tor_event(
          WHEN lv_delivery_lprio = '04' OR lv_delivery_lprio = '06'
          THEN gc_evento_fat_car
          ELSE gc_evento_lib_car
        ).
      ENDIF.
    ENDIF.

    rs_return = VALUE #(
      key           = /bobf/cl_frw_factory=>get_new_key( )
      parent_key    = is_fo_root-key
      root_key      = is_fo_root-key
      event_code    = lv_fo_event
      torstopuuid   = ls_stop_first_outbound-key
      ext_loc_id    = ls_stop_first_outbound-log_locid
      ext_loc_uuid  = ls_stop_first_outbound-log_loc_uuid
    ).
  ENDMETHOD.


  METHOD determine_fo_stops_data.
    rt_return = it_fo_stops.
    DATA(lt_origin_destination_loc_keys) = location_convert_to_altern_key( ).

    DATA(lv_planed_outbound_converted) = convert_planed_date( gs_roadnet_data-planed_outbound ).
    MODIFY rt_return FROM VALUE #(
      stop_id         = '10'
      log_locid       = gs_roadnet_data-ori_locid
      log_loc_uuid    = VALUE #( lt_origin_destination_loc_keys[ 1 ]-key OPTIONAL )
      req_start       = lv_planed_outbound_converted
      req_end         = lv_planed_outbound_converted
      plan_trans_time = lv_planed_outbound_converted
    )
    TRANSPORTING stop_id log_locid log_loc_uuid req_start req_end plan_trans_time
    WHERE stop_cat = /scmtms/if_tor_const=>sc_tor_stop_cat-outbound. "#EC CI_SORTSEQ

    DATA(lv_planed_inbound_converted) = COND #(
      WHEN gs_roadnet_data-session_description = 'CROSS'
      THEN convert_planed_date( gs_roadnet_data-planed_outbound )
      ELSE convert_planed_date( gs_roadnet_data-planed_inbound )
    ).
    MODIFY rt_return FROM VALUE #(
      stop_id         = '20'
      log_locid       = gs_roadnet_data-dest_locid
      log_loc_uuid    = VALUE #( lt_origin_destination_loc_keys[ 2 ]-key OPTIONAL )
      req_start       = lv_planed_inbound_converted
      req_end         = lv_planed_inbound_converted
      plan_trans_time = lv_planed_inbound_converted
    )
    TRANSPORTING stop_id log_locid log_loc_uuid req_start req_end plan_trans_time
    WHERE stop_cat = /scmtms/if_tor_const=>sc_tor_stop_cat-inbound. "#EC CI_SORTSEQ
  ENDMETHOD.


  METHOD determine_fo_header_data.
    rs_return = is_fo_root.
    rs_return-tor_cat         = gc_fo_cat.
    rs_return-tor_type        = gc_tortype.
    rs_return-labeltxt        = gs_roadnet_data-labeltxt.
    rs_return-zz1_cond_exped  = gs_roadnet_data-zz1_cond_exped.
    rs_return-zz1_tipo_exped  = gs_roadnet_data-zz1_tipo_exped.

    DATA(ls_db_plant_data) = get_db_plant_data( CONV #( gs_roadnet_data-region_id ) ).
    rs_return-purch_company_code   = ls_db_plant_data-vkorg.
    rs_return-purch_company_org_id = get_db_infotyp5561_by_ext_id( CONV #( ls_db_plant_data-vkorg ) ).
    rs_return-purch_company_org_id = COND #(
      WHEN rs_return-purch_company_org_id IS INITIAL OR
           rs_return-purch_company_org_id = 00000000
      THEN get_db_orgunit_by_pur_compcode( CONV #( rs_return-purch_company_code ) )
      ELSE rs_return-purch_company_org_id
    ).

    DATA(ls_db_bp_data) = get_db_bp_data( gs_roadnet_data-zz_motorista ).

    CASE ls_db_bp_data-kind.
      WHEN '0011'.
        rs_return-zz_motorista = gs_roadnet_data-zz_motorista.
        rs_return-tspid        = ls_db_plant_data-kunnr.
        rs_return-tsp          = get_db_bp_data( ls_db_plant_data-kunnr )-guid.
      WHEN '0020'.
        rs_return-tspid        = gs_roadnet_data-zz_motorista.
        rs_return-tsp          = ls_db_bp_data-guid.
      WHEN OTHERS.
        rs_return-tspid        = gs_roadnet_data-tsp_id.
        rs_return-tsp          = get_db_bp_data( gs_roadnet_data-tsp_id )-guid.
    ENDCASE.
    rs_return-subcontracting = COND #(
      WHEN rs_return-tspid IS NOT INITIAL
      THEN /scmtms/if_tor_status_c=>sc_root-subcontracting-v_carrier_assigned
    ).
  ENDMETHOD.


  METHOD get_fo_root_changed_fields.
    rt_return = VALUE #(
      ( |TOR_CAT| )
      ( |TOR_TYPE| )
      ( |TSP| )
      ( |TSPID| )
      ( |LABELTXT| )
      ( |ZZ_MOTORISTA| )
      ( |SUBCONTRACTING| )
      ( |ZZ1_TIPO_EXPED| )
      ( |ZZ1_COND_EXPED| )
      ( |PURCH_COMPANY_CODE| )
      ( |PURCH_COMPANY_ORG_ID| )
    ).
  ENDMETHOD.


  METHOD get_fo_items_changed_fields.
    rt_return = VALUE #(
      ( |ITEM_TYPE| )
      ( |ITEM_CAT| )
      ( |TURES_TCO| )
      ( |TURES_CAT| )
      ( |PLATENUMBER| )
    ).
  ENDMETHOD.


  METHOD get_fo_stops_changed_fields.
    rt_return = VALUE #(
      ( |STOP_ID| )
      ( |LOG_LOCID| )
      ( |LOG_LOC_UUID| )
      ( |REQ_START| )
      ( |REQ_END| )
      ( |PLAN_TRANS_TIME| )
    ).
  ENDMETHOD.


  METHOD determine_fo_items_data.
    rt_return = it_fo_items.
    MODIFY rt_return FROM VALUE #(
      item_type       = gc_itmtype_truc
      item_cat        = gc_itemcat_avr
      tures_tco       = gs_roadnet_data-tures_tco
      tures_cat       = gs_roadnet_data-tures_cat
      platenumber     = gs_roadnet_data-platenumber
    )
    INDEX 1
    TRANSPORTING tures_tco tures_cat item_type item_cat platenumber.
  ENDMETHOD.


  METHOD get_db_bp_data.
    SELECT SINGLE partner_guid, bpkind
      INTO @rs_return
      FROM but000
      WHERE partner = @iv_bp.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD get_db_plant_data.
    SELECT werks, kunnr, vkorg UP TO 1 ROWS
      FROM t001w
      INTO @rs_return
      WHERE werks = @iv_plant.
    ENDSELECT.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD get_db_infotyp5561_by_ext_id.
    SELECT objid UP TO 1 ROWS
      FROM /scmb/hrp5561
      INTO @rs_return
      WHERE external_id = @iv_external_id.
    ENDSELECT.
  ENDMETHOD.


  METHOD get_db_orgunit_by_pur_compcode.
    SELECT internal_id UP TO 1 ROWS
      FROM /scmb/dv_orgunit
      INTO @rs_return
      WHERE short = @iv_short.
    ENDSELECT.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD location_convert_to_altern_key.
    DATA(lo_serv_mgr_location) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key ).
    lo_serv_mgr_location->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_location_c=>sc_node-root
        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
        it_key        = VALUE /scmtms/t_loc_alt_id( ( gs_roadnet_data-ori_locid ) ( gs_roadnet_data-dest_locid ) )
      IMPORTING
        et_result     = rt_result
    ).
  ENDMETHOD.


  METHOD convert_planed_date.
    CHECK iv_planed_date IS NOT INITIAL.

    DATA(lv_planed_outbound) = CONV char14( iv_planed_date ).
    CONVERT DATE lv_planed_outbound(8)
            TIME lv_planed_outbound+8(6)
    INTO TIME STAMP rv_return TIME ZONE 'UTC'.
  ENDMETHOD.


  METHOD convert_string_utc_timestamp.
    CHECK iv_date_string IS NOT INITIAL.

    DATA(lv_planed_outbound) = CONV char14( iv_date_string ).
    CONVERT DATE lv_planed_outbound(8)
            TIME lv_planed_outbound+8(6)
    INTO TIME STAMP rv_return TIME ZONE 'UTC'.
  ENDMETHOD.


  METHOD get_db_fu_loc_by_delivy_unload.
    SELECT _stops_seq_deliveries~transporddocreferenceid,
           _stops_seq_deliveries~stop_sequence_number,
           _stops~log_loc_uuid,
           _stops~log_locid,
           _torroot~db_key,
           _torroot~tor_id
    FROM /scmtms/d_torrot AS _torroot
    INNER JOIN /scmtms/d_torstp AS _stops
    ON  _torroot~db_key = _stops~parent_key
    AND _stops~stop_cat = 'I'
    AND _stops~wh_next_rel = 'U'
    INNER JOIN @it_stops_seq_deliveries AS _stops_seq_deliveries
    ON _torroot~base_btd_id = _stops_seq_deliveries~transporddocreferenceid
    WHERE _torroot~tor_cat = 'FU'
    AND _torroot~lifecycle = '02'
    INTO TABLE @rt_return.
  ENDMETHOD.


  METHOD get_db_fu_loc_by_delivy_loadin.
    SELECT _stops_seq_deliveries~transporddocreferenceid,
           _stops_seq_deliveries~stop_sequence_number,
           _stops~log_loc_uuid,
           _stops~log_locid,
           _torroot~db_key,
           _torroot~tor_id
    FROM /scmtms/d_torrot AS _torroot
    INNER JOIN /scmtms/d_torstp AS _stops
    ON  _torroot~db_key = _stops~parent_key
    AND _stops~stop_cat = 'I'
    AND _stops~wh_next_rel <> 'U'
    INNER JOIN @it_stops_seq_deliveries AS _stops_seq_deliveries
    ON _torroot~base_btd_id = _stops_seq_deliveries~transporddocreferenceid
    WHERE _torroot~tor_cat = 'FU'
    AND _torroot~lifecycle = '02'
    INTO TABLE @rt_return.
  ENDMETHOD.


  METHOD calculate_acc_end_timestamp.
    DATA:
      lv_ex_time_string TYPE char12,
      lv_newdt          TYPE sy-datum,
      lv_newtime        TYPE sy-uzeit.

    CHECK iv_arrival IS NOT INITIAL.
    TRY.
        CALL FUNCTION '/SAPAPO/PFM_CONVERT_TIME'
          EXPORTING
            im_seconds     = CONV int4( iv_service_time )
          IMPORTING
            ex_time_string = lv_ex_time_string.

        REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_ex_time_string WITH space.
        CONDENSE lv_ex_time_string NO-GAPS.
        DATA(lv_addtime) = CONV sy-uzeit( |{ lv_ex_time_string ALPHA = IN }| ).

      CATCH cx_root.
        CLEAR lv_addtime.
    ENDTRY.
    DATA(lv_arrival_char14) = CONV char14( iv_arrival ).
    DATA(lv_starttime) = CONV sy-uzeit( lv_arrival_char14+8(6) ).
    DATA(lv_startdt) = CONV sy-datum( lv_arrival_char14(8) ).

    CALL FUNCTION 'C14B_ADD_TIME'
      EXPORTING
        i_starttime = lv_starttime
        i_startdate = lv_startdt
        i_addtime   = lv_addtime
      IMPORTING
        e_endtime   = lv_newtime
        e_enddate   = lv_newdt.

    CONVERT DATE lv_newdt TIME lv_newtime
    INTO TIME STAMP rs_return TIME ZONE 'UTC'.
  ENDMETHOD.

  METHOD get_dc_distance_locfrom_locto.
    SELECT locid UP TO 1 ROWS FROM /sapapo/loc
    INTO @DATA(lv_locid_from)
    WHERE locno = @iv_loc_from.
    ENDSELECT.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    SELECT locid UP TO 1 ROWS FROM /sapapo/loc
    INTO @DATA(lv_locid_to)
    WHERE locno = @iv_loc_to.
    ENDSELECT.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    SELECT dist UP TO 1 ROWS FROM /sapapo/trm           "#EC CI_NOFIELD
    INTO @rv_return
    WHERE locfr = @lv_locid_from
      AND locto = @lv_locid_to
      AND trname = '000'.
    ENDSELECT.

  ENDMETHOD.


  METHOD update_docreference_cross.
    CHECK gs_roadnet_data-session_description = 'CROSS'.
    DATA(ls_execution_messages) = VALUE #( gt_execution_messages[ type = 'S' id = '/SCMTMS/TOR' number = '000'  ]  OPTIONAL ). "#EC CI_STDSEQ
    IF ls_execution_messages-message_v2 IS NOT INITIAL.
      DATA lt_doc_ref_modif TYPE /bobf/t_frw_modification.

      DATA(lt_tor_doc_ref) = determine_docreference_cross( CONV #( ls_execution_messages-message_v2 ) ).
      IF lt_tor_doc_ref IS NOT INITIAL.
        /scmtms/cl_mod_helper=>mod_create_multi(
          EXPORTING
            iv_node        = /scmtms/if_tor_c=>sc_node-docreference
            it_data        = lt_tor_doc_ref
            iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
            iv_source_node = /scmtms/if_tor_c=>sc_node-root
          CHANGING
            ct_mod         = lt_doc_ref_modif
        ).
*        modify_fo_modifications( lt_doc_ref_modif ).
*        save_fo_modifications( ).
        try.
        go_tor_serv_mgr->modify(
          EXPORTING
            it_modification = lt_doc_ref_modif
          IMPORTING
            eo_change       = DATA(lo_change)
            eo_message      = DATA(lo_fo_complete_message)
        ).
        CATCH /bobf/cx_frw_contrct_violation.
        ENDTRY.
        IF lo_fo_complete_message IS NOT INITIAL.
          DATA lt_messages_bapiret TYPE bapiret2_tab.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
            EXPORTING
              io_message  = lo_fo_complete_message
            CHANGING
              ct_bapiret2 = lt_messages_bapiret
          ).
          APPEND LINES OF lt_messages_bapiret TO gt_execution_messages.
        ENDIF.

        CHECK NOT line_exists( lt_messages_bapiret[ type = 'E' ] ). "#EC CI_STDSEQ
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
        assign_execution_messages( lo_message_save ).
        lo_txn_mgr->cleanup( 2 ).

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD determine_docreference_cross.
    DATA(lv_tor_id) = iv_tor_id.
    lv_tor_id = |{ lv_tor_id ALPHA = IN }|.
    DATA(lt_parameters) = VALUE /bobf/t_frw_query_selparam(
      FOR <fs_fu_root> IN gt_fu_root
      LET lv_delivery = CONV vbeln_vl( |{ <fs_fu_root>-base_btd_id ALPHA = IN }| ) IN
      ( sign           = /bobf/if_conf_c=>sc_sign_option_including
        option         = /bobf/if_conf_c=>sc_sign_equal
        attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-trq_base_btd_id
        low            = lv_delivery )
      ).
    APPEND VALUE #(
      attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_cat
      sign           = /bobf/if_conf_c=>sc_sign_option_including
      option         = /bobf/if_conf_c=>sc_sign_equal
      low            = /scmtms/if_tor_const=>sc_tor_category-active
    ) TO lt_parameters.
    DATA lt_tor_root    TYPE /scmtms/t_tor_root_k.
    go_tor_serv_mgr->query(
      EXPORTING
        iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes
        it_selection_parameters = lt_parameters
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_tor_root
    ).
    SELECT SINGLE db_key FROM /scmtms/d_torrot WHERE tor_id = @lv_tor_id
    INTO @DATA(lv_key).

    LOOP AT lt_tor_root ASSIGNING FIELD-SYMBOL(<fs_of>).
      IF <fs_of>-tor_id EQ lv_tor_id.
        CONTINUE.
      ENDIF.
      APPEND VALUE #(
        key          = /bobf/cl_frw_factory=>get_new_key( )
        parent_key   = <fs_of>-key
        root_key     = <fs_of>-key
        btd_tco      = gc_of_mae
        btd_id       = lv_tor_id
        btd_date     = sy-datum
      ) TO rt_return.

      APPEND VALUE #(
        key          = /bobf/cl_frw_factory=>get_new_key( )
        parent_key   = lv_key
        root_key     = lv_key
        btd_tco      = gc_of_filha
        btd_id       = <fs_of>-tor_id
        btd_date     = sy-datum
      ) TO rt_return.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
