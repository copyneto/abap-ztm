CLASS zcltm_roadnet_integration DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      execute
        IMPORTING
          is_input_filter_consult_sessio TYPE zcltm_roadnet_interface=>ty_input_filter_consult_sessio
        RETURNING
          VALUE(rt_return)               TYPE bapiret2_t.
    TYPES:
      BEGIN OF ty_input_roadnet,
        internal_session_id TYPE ztms_input_rodnet-internal_session_id,
        region_id           TYPE ztms_input_rodnet-region_id,
        labeltxt            TYPE ztms_input_rodnet-labeltxt,
        route_id            TYPE ztms_input_rodnet-route_id,
        internal_route_id   TYPE ztms_input_rodnet-internal_route_id,
        session_description TYPE ztms_input_rodnet-description,
        description         TYPE ztms_input_rodnet-description,
        zz1_tipo_exped      TYPE ztms_input_rodnet-zz1_tipo_exped,
        ori_locid           TYPE ztms_input_rodnet-ori_locid,
        ori_loctype         TYPE ztms_input_rodnet-ori_loctype,
        zz_motorista        TYPE ztms_input_rodnet-zz_motorista,
        zz1_cond_exped      TYPE ztms_input_rodnet-zz1_cond_exped,
        tures_tco           TYPE ztms_input_rodnet-tures_tco,
        platenumber         TYPE ztms_input_rodnet-platenumber,
        planed_outbound     TYPE ztms_input_rodnet-planed_outbound,
        planed_inbound      TYPE ztms_input_rodnet-planed_inbound,
        dest_locid          TYPE ztms_input_rodnet-dest_locid,
        dest_loctype        TYPE ztms_input_rodnet-dest_loctype,
        tures_cat           TYPE ztms_input_rodnet-tures_cat,
        tsp_id              TYPE ztms_input_rodnet-tsp_id,
        route_distance_km   TYPE /scmtms/decimal_value,
      END OF ty_input_roadnet,
      BEGIN OF ty_fu_root,
        db_key           TYPE /scmtms/d_torrot-db_key,
        tor_id           TYPE /scmtms/d_torrot-tor_id,
        base_btd_id      TYPE /scmtms/d_torrot-base_btd_id,
        plan_status_root TYPE /scmtms/d_torrot-plan_status_root,
      END OF ty_fu_root,
      ty_tt_fu_root TYPE SORTED TABLE OF ty_fu_root
                      WITH NON-UNIQUE KEY db_key
                      WITH NON-UNIQUE SORTED KEY sec_tor_id COMPONENTS tor_id
                      WITH NON-UNIQUE SORTED KEY sec_base_btd_id COMPONENTS base_btd_id.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      get_roadnet_freight_orders
        IMPORTING
          it_routes_id     TYPE ty_tt_internal_routes_id
        RETURNING
          VALUE(rt_return) TYPE ty_tt_roadnet_freight_orders,

      get_equipament_type
        IMPORTING
          it_roadnet_route_data TYPE ty_tt_internal_routes_id
        RETURNING
          VALUE(rt_return)      TYPE ty_tt_equipament_type,

      exist_fo_with_route
        IMPORTING
          iv_internal_route_id TYPE string
          is_session           TYPE zcltm_dt_consulta_sessao_resp1
        RETURNING
          VALUE(rv_return)     TYPE abap_bool,

      initialization_session_log
        IMPORTING
          is_session TYPE zcltm_dt_consulta_sessao_resp1 ,

      initialization_route_log
        IMPORTING
          is_session  TYPE zcltm_dt_consulta_sessao_resp1
          iv_route_id TYPE string,

      processed_route_log
        IMPORTING
          is_session  TYPE zcltm_dt_consulta_sessao_resp1
          iv_route_id TYPE string
          it_messages TYPE  bapiret2_t,

      finalize_route_log
        IMPORTING
          is_session  TYPE zcltm_dt_consulta_sessao_resp1
          iv_route_id TYPE string,

      finalize_session_log
        IMPORTING
          is_session TYPE zcltm_dt_consulta_sessao_resp1 ,

      get_message_text
        IMPORTING
          is_message       TYPE bapiret2
        RETURNING
          VALUE(rv_return) TYPE string,

      save_road_log
        IMPORTING
          it_road_log TYPE zctgtm_road_log,

      update_road_item_log
        IMPORTING
          iv_fo_id        TYPE /scmtms/tor_id
          iv_plant        TYPE zttm_road_item-werks
          iv_date_session TYPE zttm_road_item-dtsession
          iv_session_id   TYPE zttm_road_item-session_id
          iv_route_id     TYPE zttm_road_item-route_id
          iv_timestamp    TYPE timestampl,

      process_tm_documents
        IMPORTING
          is_session       TYPE zcltm_dt_consulta_sessao_resp1
          is_route         TYPE zcltm_dt_consulta_sessao_res14
        RETURNING
          VALUE(rt_return) TYPE bapiret2_t,

      determine_input_roadnet
        IMPORTING
          is_session       TYPE zcltm_dt_consulta_sessao_resp1
          is_route         TYPE zcltm_dt_consulta_sessao_res14
        RETURNING
          VALUE(rs_return) TYPE ty_input_roadnet,

      determine_roadnet_route_data
        IMPORTING
          it_sessions      TYPE zcltm_dt_consulta_sessao__tab1
        RETURNING
          VALUE(rt_return) TYPE ty_tt_internal_routes_id,

      get_fu_root_from_delivery
        IMPORTING
          it_stop_seq_deliveries TYPE ty_tt_stop_seq_deliveries
        RETURNING
          VALUE(rt_return)       TYPE ty_tt_fu_root,

      filter_roadnet_sessions
        IMPORTING
          it_all_sessions  TYPE zcltm_dt_consulta_sessao__tab1
          it_routes        TYPE zctgtm_route_id
        RETURNING
          VALUE(rt_return) TYPE zcltm_dt_consulta_sessao__tab1,

      enqueue_roadnet,
      dequeue_roadnet.

    DATA:
      gt_roadnet_freight_orders TYPE ty_tt_roadnet_freight_orders,
      gt_equipament_type        TYPE ty_tt_equipament_type,
      gv_line                   TYPE bapi_line,
      gv_session_date           TYPE sydatum,
      gv_session_plant          TYPE werks_d.

ENDCLASS.


CLASS zcltm_roadnet_integration IMPLEMENTATION.
  METHOD execute.
    gv_session_date   = is_input_filter_consult_sessio-date_start.
    gv_session_plant  = is_input_filter_consult_sessio-region_identity.
    DATA(lt_all_sessions) = NEW zcltm_roadnet_interface( )->consult_sessions( is_input_filter_consult_sessio ). "#EC CI_CONV_OK
    DATA(lt_sessions) = filter_roadnet_sessions(
      it_all_sessions = CORRESPONDING #( DEEP lt_all_sessions )
      it_routes       = is_input_filter_consult_sessio-routes
    ).

    DATA(lt_roadnet_route_data) = determine_roadnet_route_data( lt_sessions ).
    gt_roadnet_freight_orders   = get_roadnet_freight_orders( lt_roadnet_route_data ).
    gt_equipament_type          = get_equipament_type( lt_roadnet_route_data ).

    LOOP AT lt_sessions ASSIGNING FIELD-SYMBOL(<fs_session>).
      initialization_session_log( <fs_session> ).
      LOOP AT <fs_session>-session_identity-routes ASSIGNING FIELD-SYMBOL(<fs_route>).
        initialization_route_log( is_session = <fs_session> iv_route_id = <fs_route>-internal_route_id ).

        IF NOT exist_fo_with_route(
          iv_internal_route_id = <fs_route>-internal_route_id
          is_session = <fs_session>
        ).
          rt_return = process_tm_documents(
            is_session = <fs_session>
            is_route   = <fs_route>
          ).
        ENDIF.
        finalize_route_log( is_session = <fs_session> iv_route_id = <fs_route>-internal_route_id ).
      ENDLOOP.
      finalize_session_log( <fs_session> ).
    ENDLOOP.

    dequeue_roadnet( ).
    NEW zcltm_roadnet_bp_latit_longi( )->update_bp_ident_latit_longi( lt_sessions ).

  ENDMETHOD.

  METHOD process_tm_documents.
    DATA(ls_input_roadnet) = determine_input_roadnet(
      is_session = is_session
      is_route   = is_route
    ).

    DATA(lt_stop_seq_deliveries) = VALUE ty_tt_stop_seq_deliveries(
      FOR <fs_roadnet_stops> IN is_route-stops
      FOR <fs_roadnet_order> IN <fs_roadnet_stops>-orders
      ( transporddocreferenceid = '000000000000000000000000000' && <fs_roadnet_order>-order_number )
    ).
    DATA(lt_fu_root) = get_fu_root_from_delivery( lt_stop_seq_deliveries ).

    IF ls_input_roadnet-session_description = 'CROSS'.
      DATA(lt_fus_plan_stat_error) = VALUE bapiret2_tab(
        FOR <fs_fu_root> IN lt_fu_root WHERE ( plan_status_root <> '02' )
        ( id         = 'ZTM_ROADNET_SESSION'
          type       = 'E'
          number     = '029'
          message_v1 = CONV vbeln_vl( |{ <fs_fu_root>-base_btd_id ALPHA = IN }| )
          message_v2 = CONV /scmtms/tor_id( |{ <fs_fu_root>-tor_id ALPHA = OUT }| ) )
      ).
      IF lt_fus_plan_stat_error IS NOT INITIAL.
        processed_route_log(
          is_session  = is_session
          iv_route_id = is_route-internal_route_id
          it_messages = lt_fus_plan_stat_error
        ).
        RETURN.
      ENDIF.
    ENDIF.

    IF ls_input_roadnet-session_description = 'REDESPACHO' .
      DATA(lt_updated_fu_messages) = NEW zcltm_roadnet_freight_unit( )->fu_split_stage(
        is_dados   = ls_input_roadnet
        it_stops   = is_route-stops
        it_fu_root = lt_fu_root
      ).
      rt_return = VALUE #( BASE rt_return ( LINES OF lt_updated_fu_messages ) ).
    ENDIF.
    DATA(lt_created_fo_messages) = NEW zcltm_roadnet_freight_order( )->create_freight_order(
      is_dados = ls_input_roadnet
      it_stops = is_route-stops
      it_fu_root = lt_fu_root
    ).
    rt_return = VALUE #( BASE rt_return ( LINES OF lt_created_fo_messages ) ).

    processed_route_log(
      is_session  = is_session
      iv_route_id = is_route-internal_route_id
      it_messages = lt_created_fo_messages
    ).
  ENDMETHOD.

  METHOD filter_roadnet_sessions.
    DATA(lo_roadnet_events) = NEW ZCLTM_PROCESS_ROADNET( ).
    rt_return = CORRESPONDING #( DEEP it_all_sessions ).
    LOOP AT rt_return ASSIGNING FIELD-SYMBOL(<fs_session>).
      DATA(lv_session_tabix) = sy-tabix.
      <fs_session>-description = lo_roadnet_events->build_roadnet_description( conv #( <fs_session>-description ) ).
      LOOP AT <fs_session>-session_identity-routes ASSIGNING FIELD-SYMBOL(<fs_route>).
        DATA(lv_route_tabix) = sy-tabix.
        IF <fs_route>-stops IS INITIAL OR NOT line_exists( it_routes[ table_line = <fs_route>-internal_route_id   ] ).
          DELETE <fs_session>-session_identity-routes INDEX lv_route_tabix.
          CONTINUE.
        ENDIF.
        LOOP AT <fs_route>-stops ASSIGNING FIELD-SYMBOL(<fs_stop>).
          IF <fs_stop>-orders IS INITIAL.
            DELETE <fs_route>-stops INDEX sy-tabix.
            CONTINUE.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
      IF <fs_session>-session_identity-routes IS INITIAL.
        DELETE rt_return INDEX lv_session_tabix.
        CONTINUE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD determine_roadnet_route_data.
    rt_return = VALUE #(
      FOR <fs_session_id> IN it_sessions
      FOR <fs_route_id> IN <fs_session_id>-session_identity-routes
      ( internal_route_id = <fs_route_id>-internal_route_id
        equipment_type_id = <fs_route_id>-route_equipment-equipment_type_id )
    ).
  ENDMETHOD.

  METHOD determine_input_roadnet.
    rs_return = VALUE #(
      internal_session_id = is_session-session_identity-internal_session_id
      region_id           = is_session-session_identity-region_id
      labeltxt            = is_route-description
*      tures_cat           = <fs_route>-route_equipment-equipment_id
      route_id            = is_route-route_id
      internal_route_id   = is_route-internal_route_id
      description         = is_route-description
      session_description = is_session-description
      zz1_tipo_exped      = |{ is_route-load_priority ALPHA = IN }|
      ori_locid           = is_route-origin-location_id
      ori_loctype         = is_route-origin-location_type
      zz_motorista        = VALUE #( is_route-drivers[ 1 ]-employee_id )
      zz1_cond_exped      = CONV char2( |{ VALUE #( is_route-drivers[ 2 ]-employee_id OPTIONAL ) ALPHA = IN }| )
      tures_tco           = is_route-route_equipment-equipment_type_id
      platenumber         = is_route-route_equipment-equipment_id
      planed_outbound     = is_route-start_time
      planed_inbound      = is_route-arrive_time
      dest_locid          = is_route-destination-location_id
      dest_loctype        = is_route-destination-location_type
      tures_cat           = VALUE #( gt_equipament_type[ equi_code = is_route-route_equipment-equipment_type_id ]-equi_type OPTIONAL )
      route_distance_km   = is_route-distance
    ).
  ENDMETHOD.

  METHOD get_roadnet_freight_orders.
    SELECT _fo_doc_req~btd_id, _fo_root~tor_id
    FROM @it_routes_id AS _routes_id
    INNER JOIN /scmtms/d_tordrf AS _fo_doc_req
    ON  _fo_doc_req~btd_id = _routes_id~internal_route_id
    AND _fo_doc_req~btd_tco = 'ROADN'
    INNER JOIN /scmtms/d_torrot AS _fo_root
    ON  _fo_doc_req~parent_key = _fo_root~db_key
    AND _fo_root~lifecycle <> '10'
    INTO TABLE @rt_return.
  ENDMETHOD.

  METHOD get_equipament_type.
    CHECK it_roadnet_route_data IS NOT INITIAL.

    DATA(lt_roadnet_route_data) = it_roadnet_route_data.
    DELETE ADJACENT DUPLICATES FROM lt_roadnet_route_data USING KEY sec_key.

    SELECT equi_code, equi_type
    FROM /scmb/equi_code AS _equi_code
    FOR ALL ENTRIES IN @lt_roadnet_route_data
    WHERE equi_code = @lt_roadnet_route_data-equipment_type_id
    INTO TABLE @rt_return.
  ENDMETHOD.

  METHOD exist_fo_with_route.
    DATA(ls_roadnet_freight_order) = VALUE #( gt_roadnet_freight_orders[ btd_id = iv_internal_route_id ] OPTIONAL ).
    IF ls_roadnet_freight_order-tor_id IS NOT INITIAL.
      rv_return = abap_true.

      DATA(ls_return) = VALUE bapiret2(
        id         = 'ZTM_ROADNET_SESSION'
        number     = '016'
        message_v1 = iv_internal_route_id
        message_v2 = ls_roadnet_freight_order-tor_id
        type = 'E'
      ).

      DATA lv_timestamp        TYPE timestampl.
      GET TIME STAMP FIELD lv_timestamp.

      DATA(lv_dtsession) = CONV char10( is_session-session_date ).
      REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
      CONDENSE lv_dtsession NO-GAPS.

      gv_line = gv_line + 1.
      DATA(lt_road_log) = VALUE zctgtm_road_log( (
        werks                 = is_session-session_identity-region_id
        dtsession             = lv_dtsession
        session_id            = is_session-session_identity-internal_session_id
        line                  = gv_line
        msgty                 = ls_return-type
        msgid                 = ls_return-id
        msgno                 = ls_return-number
        msgv1                 = ls_return-message_v1
        msgv2                 = ls_return-message_v2
        msgv3                 = ls_return-message_v3
        msgv4                 = ls_return-message_v4
        message               = get_message_text( ls_return )
        created_by            = sy-uname
        created_at            = lv_timestamp
        local_last_changed_at = lv_timestamp
      ) ).
      save_road_log( lt_road_log ).
    ENDIF.
  ENDMETHOD.

  METHOD initialization_session_log.
    DATA lv_timestamp        TYPE timestampl.
    GET TIME STAMP FIELD lv_timestamp.

    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.


    CLEAR gv_line.
    SELECT MAX( line ) FROM zttm_road_log INTO @gv_line
    WHERE werks      = @is_session-session_identity-region_id
      AND dtsession  = @lv_dtsession
      AND session_id = @is_session-session_identity-internal_session_id.

    DATA(ls_return) = VALUE bapiret2(
      id = 'ZTM_ROADNET_SESSION'
      number = '026'
      message_v1 = is_session-session_identity-internal_session_id
      type = 'S'
    ).

    gv_line = gv_line + 1.

    DATA(lt_road_log) = VALUE zctgtm_road_log( (
      werks                 = is_session-session_identity-region_id
      dtsession             = lv_dtsession
      session_id            = is_session-session_identity-internal_session_id
      line                  = gv_line
      msgty                 = ls_return-type
      msgid                 = ls_return-id
      msgno                 = ls_return-number
      msgv1                 = ls_return-message_v1
      msgv2                 = ls_return-message_v2
      msgv3                 = ls_return-message_v3
      msgv4                 = ls_return-message_v4
      message               = get_message_text( ls_return )
      created_by            = sy-uname
      created_at            = lv_timestamp
      local_last_changed_at = lv_timestamp
    ) ).
    save_road_log( lt_road_log ).
  ENDMETHOD.

  METHOD initialization_route_log.
    DATA lv_timestamp        TYPE timestampl.
    GET TIME STAMP FIELD lv_timestamp.

    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.

    DATA(ls_return) = VALUE bapiret2(
      id = 'ZTM_ROADNET_SESSION'
      number = '024'
      message_v1 = iv_route_id
      type = 'S'
    ).

    gv_line = gv_line + 1.

    DATA(lt_road_log) = VALUE zctgtm_road_log( (
      werks                 = is_session-session_identity-region_id
      dtsession             = lv_dtsession
      session_id            = is_session-session_identity-internal_session_id
      line                  = gv_line
      msgty                 = ls_return-type
      msgid                 = ls_return-id
      msgno                 = ls_return-number
      msgv1                 = ls_return-message_v1
      msgv2                 = ls_return-message_v2
      msgv3                 = ls_return-message_v3
      msgv4                 = ls_return-message_v4
      message               = get_message_text( ls_return )
      created_by            = sy-uname
      created_at            = lv_timestamp
      local_last_changed_at = lv_timestamp
    ) ).
    save_road_log( lt_road_log ).
  ENDMETHOD.

  METHOD processed_route_log.
    DATA lt_road_log TYPE zctgtm_road_log.
    DATA lv_timestamp        TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.

    LOOP AT it_messages ASSIGNING FIELD-SYMBOL(<fs_message>).
      gv_line = gv_line + 1.
      APPEND VALUE #(
        werks                 = is_session-session_identity-region_id
        dtsession             = lv_dtsession
        session_id            = is_session-session_identity-internal_session_id
        line                  = gv_line
        msgty                 = <fs_message>-type
        msgid                 = <fs_message>-id
        msgno                 = <fs_message>-number
        msgv1                 = <fs_message>-message_v1
        msgv2                 = <fs_message>-message_v2
        msgv3                 = <fs_message>-message_v3
        msgv4                 = <fs_message>-message_v4
        message               = get_message_text( <fs_message> )
        created_by            = sy-uname
        created_at            = lv_timestamp
        local_last_changed_at = lv_timestamp
      ) TO lt_road_log.
    ENDLOOP.

    DATA(ls_road_log) = VALUE #( lt_road_log[ msgty = 'S' msgid = '/SCMTMS/TOR' msgno = '000'  ]  OPTIONAL ). "#EC CI_STDSEQ
    update_road_item_log(
      iv_fo_id        = CONV #( ls_road_log-msgv2 )
      iv_plant        = CONV #( is_session-session_identity-region_id )
      iv_date_session = CONV #( lv_dtsession )
      iv_session_id   = CONV #( is_session-session_identity-internal_session_id )
      iv_route_id     = CONV #( iv_route_id )
      iv_timestamp    = lv_timestamp
    ).
    save_road_log( lt_road_log ).
  ENDMETHOD.

  METHOD finalize_route_log.
    DATA lv_timestamp        TYPE timestampl.

    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.

    GET TIME STAMP FIELD lv_timestamp.

    DATA(ls_return) = VALUE bapiret2(
      id = 'ZTM_ROADNET_SESSION'
      number = '025'
      message_v1 = iv_route_id
      type = 'S'
    ).

    gv_line = gv_line + 1.

    DATA(lt_road_log) = VALUE zctgtm_road_log( (
      werks                 = is_session-session_identity-region_id
      dtsession             = lv_dtsession
      session_id            = is_session-session_identity-internal_session_id
      line                  = gv_line
      msgty                 = ls_return-type
      msgid                 = ls_return-id
      msgno                 = ls_return-number
      msgv1                 = ls_return-message_v1
      msgv2                 = ls_return-message_v2
      msgv3                 = ls_return-message_v3
      msgv4                 = ls_return-message_v4
      message               = get_message_text( ls_return )
      created_by            = sy-uname
      created_at            = lv_timestamp
      local_last_changed_at = lv_timestamp
    ) ).
    save_road_log( lt_road_log ).
  ENDMETHOD.

  METHOD finalize_session_log.
    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.
    DATA:
      lv_timestamp        TYPE timestampl.
    GET TIME STAMP FIELD lv_timestamp.

    DATA(ls_return) = VALUE bapiret2(
      id = 'ZTM_ROADNET_SESSION'
      number = '019'
      message_v1 = is_session-session_identity-internal_session_id
      type = 'S'
    ).

    gv_line = gv_line + 1.

    DATA(lt_road_log) = VALUE zctgtm_road_log( (
      werks                 = is_session-session_identity-region_id
      dtsession             = lv_dtsession
      session_id            = is_session-session_identity-internal_session_id
      line                  = gv_line
      msgty                 = ls_return-type
      msgid                 = ls_return-id
      msgno                 = ls_return-number
      msgv1                 = ls_return-message_v1
      msgv2                 = ls_return-message_v2
      msgv3                 = ls_return-message_v3
      msgv4                 = ls_return-message_v4
      message               = get_message_text( ls_return )
      created_by            = sy-uname
      created_at            = lv_timestamp
      local_last_changed_at = lv_timestamp
    ) ).
    save_road_log( lt_road_log ).
  ENDMETHOD.

  METHOD get_message_text.
    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id        = is_message-id
        lang      = sy-langu
        no        = is_message-number
        v1        = is_message-message_v1
        v2        = is_message-message_v2
        v3        = is_message-message_v3
        v4        = is_message-message_v4
      IMPORTING
        msg       = rv_return
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc = 0.
      EXIT.
    ENDIF.
  ENDMETHOD.

  METHOD save_road_log.
    CHECK it_road_log IS NOT INITIAL.
    MODIFY zttm_road_log FROM TABLE it_road_log.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      enqueue_roadnet( ).
    ENDIF.
  ENDMETHOD.

  METHOD update_road_item_log.
    IF iv_fo_id IS NOT INITIAL.
      SELECT SINGLE * FROM zttm_road_item
        WHERE werks = @iv_plant
          AND dtsession = @iv_date_session
          AND session_id = @iv_session_id
          AND route_id = @iv_route_id
        INTO @DATA(ls_road_item).
      IF sy-subrc = 0.
        ls_road_item-freight_order   = iv_fo_id.
        ls_road_item-last_changed_by = sy-uname.
        ls_road_item-last_changed_at = iv_timestamp.
        ls_road_item-local_last_changed_at = iv_timestamp.

        MODIFY zttm_road_item FROM ls_road_item.
        IF sy-subrc EQ 0.
          EXIT.
*          COMMIT WORK AND WAIT.
*          enqueue_roadnet( ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD enqueue_roadnet.
    CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
      EXPORTING
        werks          = gv_session_plant
        dtsession      = gv_session_date
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc = 0.
      EXIT.
    ENDIF.
  ENDMETHOD.

  METHOD dequeue_roadnet.
    CALL FUNCTION 'DEQUEUE_EZ_TM_ROADNET'
      EXPORTING
        werks     = gv_session_plant
        dtsession = gv_session_date.
  ENDMETHOD.

  METHOD get_fu_root_from_delivery.
    IF it_stop_seq_deliveries IS NOT INITIAL.
      SELECT _rootfu~db_key, _rootfu~tor_id, _rootfu~base_btd_id, _rootfu~plan_status_root
      FROM @it_stop_seq_deliveries AS _stop_seq_deliveries
      INNER JOIN /scmtms/d_torrot AS _rootfu
      ON  _rootfu~base_btd_id = _stop_seq_deliveries~transporddocreferenceid
      AND _rootfu~lifecycle   = '02'
      AND _rootfu~tor_cat     = 'FU'
      INTO TABLE @rt_return.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
