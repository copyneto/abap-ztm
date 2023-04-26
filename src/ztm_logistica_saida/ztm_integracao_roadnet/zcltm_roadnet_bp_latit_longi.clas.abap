CLASS zcltm_roadnet_bp_latit_longi DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS:
      update_bp_ident_latit_longi
        IMPORTING
          it_sessions      TYPE zcltm_dt_consulta_sessao__tab1
        RETURNING
          VALUE(rt_return) TYPE bapiret2_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      delete_and_create_bp_lat_long
        IMPORTING
          it_shiptoparty_from_delivery TYPE ty_tt_bp_shiptoparty,

      determine_delivery_latit_long
        IMPORTING
          it_sessions      TYPE zcltm_dt_consulta_sessao__tab1
        RETURNING
          VALUE(rt_return) TYPE ty_tt_delivery_latit_longi,

      get_shiptoparty_from_delivery
        IMPORTING
          it_deliveries_latit_longi TYPE ty_tt_delivery_latit_longi
        RETURNING
          VALUE(rt_return)          TYPE ty_tt_bp_shiptoparty,

      get_bp_identification_lat_long
        IMPORTING
          it_bp_shiptoparties TYPE ty_tt_bp_shiptoparty
        RETURNING
          VALUE(rt_return)    TYPE ty_tt_bp_identification,

      determine_update_lat_long
        IMPORTING
          is_bp_shiptoparty         TYPE ty_bp_shiptoparty
          is_bp_identification_lati TYPE ty_bp_identification
          is_bp_identification_long TYPE ty_bp_identification,

      delete_exist_bp_identification
        IMPORTING
          is_bp_identification TYPE ty_bp_identification,

      create_identif_latit_long
        IMPORTING
          is_bp_identification TYPE ty_bp_identification,

      read_bp_identific_lat_long
        IMPORTING
          iv_bpidentificationtype TYPE i_bupaidentification-bpidentificationtype
          iv_businesspartner      TYPE i_bupaidentification-businesspartner
        RETURNING
          VALUE(rs_return)        TYPE ty_bp_identification.

    DATA:
      gt_bp_identification_lat_long  TYPE ty_tt_bp_identification,
      gt_msg_upd_bp_ident_lati_longi TYPE bapiret2_tab,
      gv_bp_indentification_updated  TYPE abap_bool.

    CONSTANTS:
      gc_longitude TYPE bu_id_type VALUE 'ZLONGI',
      gc_latitude  TYPE bu_id_type VALUE 'ZLATIT'.
ENDCLASS.



CLASS zcltm_roadnet_bp_latit_longi IMPLEMENTATION.
  METHOD update_bp_ident_latit_longi.
    DATA(lt_deliveries_latit_longi) = determine_delivery_latit_long( it_sessions ).
    DATA(lt_shiptoparty_from_delivery) = get_shiptoparty_from_delivery( lt_deliveries_latit_longi ).
    gt_bp_identification_lat_long = get_bp_identification_lat_long( lt_shiptoparty_from_delivery ).
    delete_and_create_bp_lat_long( lt_shiptoparty_from_delivery ).

    rt_return = gt_msg_upd_bp_ident_lati_longi.
  ENDMETHOD.


  METHOD delete_and_create_bp_lat_long.
    LOOP AT it_shiptoparty_from_delivery ASSIGNING FIELD-SYMBOL(<fs_delivery_shiptoparty>).
      DATA(ls_bp_identification_latitude) = read_bp_identific_lat_long(
        iv_businesspartner = <fs_delivery_shiptoparty>-shiptoparty
        iv_bpidentificationtype = gc_latitude
      ).
      DATA(ls_bp_identification_longitude) = read_bp_identific_lat_long(
        iv_businesspartner = <fs_delivery_shiptoparty>-shiptoparty
        iv_bpidentificationtype = gc_longitude
      ).
      determine_update_lat_long(
        is_bp_shiptoparty         = <fs_delivery_shiptoparty>
        is_bp_identification_lati = ls_bp_identification_latitude
        is_bp_identification_long = ls_bp_identification_longitude
      ).
    ENDLOOP.

    IF gv_bp_indentification_updated = abap_true.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    ENDIF.
  ENDMETHOD.


  METHOD determine_update_lat_long.
    IF is_bp_shiptoparty-latitude IS NOT INITIAL AND
       is_bp_identification_lati-bpidentificationnumber <> is_bp_shiptoparty-latitude.

      IF is_bp_identification_lati-businesspartner IS NOT INITIAL.
        delete_exist_bp_identification( is_bp_identification_lati ).
      ENDIF.
      create_identif_latit_long( VALUE #(
        businesspartner = is_bp_shiptoparty-shiptoparty
        bpidentificationtype = gc_latitude
        bpidentificationnumber = is_bp_shiptoparty-latitude
      ) ).
    ENDIF.

    IF is_bp_shiptoparty-longitude IS NOT INITIAL AND
       is_bp_identification_long-bpidentificationnumber <> is_bp_shiptoparty-longitude.
      IF is_bp_identification_long-businesspartner IS NOT INITIAL.
        delete_exist_bp_identification( is_bp_identification_long ).
      ENDIF.
      create_identif_latit_long( VALUE #(
        businesspartner = is_bp_shiptoparty-shiptoparty
        bpidentificationtype = gc_longitude
        bpidentificationnumber = is_bp_shiptoparty-longitude
      ) ).
    ENDIF.
  ENDMETHOD.


  METHOD create_identif_latit_long.
    DATA:
      ls_identification   TYPE bapibus1006_identification,
      lt_return_ident_add TYPE bapiret2_tab.

    CALL FUNCTION 'BAPI_IDENTIFICATION_ADD'
      EXPORTING
        businesspartner        = is_bp_identification-businesspartner
        identificationcategory = is_bp_identification-bpidentificationtype
        identificationnumber   = is_bp_identification-bpidentificationnumber
        identification         = ls_identification
      TABLES
        return                 = lt_return_ident_add.

    APPEND LINES OF lt_return_ident_add TO gt_msg_upd_bp_ident_lati_longi.

    gv_bp_indentification_updated = COND #(
      WHEN gv_bp_indentification_updated = abap_true
      THEN gv_bp_indentification_updated
      ELSE COND #( WHEN lt_return_ident_add IS INITIAL THEN abap_true )
    ).
  ENDMETHOD.


  METHOD delete_exist_bp_identification.
    DATA lt_return_ident_remove TYPE bapiret2_tab.

    CALL FUNCTION 'BAPI_IDENTIFICATION_REMOVE'
      EXPORTING
        businesspartner        = is_bp_identification-businesspartner
        identificationcategory = is_bp_identification-bpidentificationtype
        identificationnumber   = is_bp_identification-bpidentificationnumber
      TABLES
        return                 = lt_return_ident_remove.

    APPEND LINES OF lt_return_ident_remove TO gt_msg_upd_bp_ident_lati_longi.
  ENDMETHOD.


  METHOD read_bp_identific_lat_long.
    rs_return = VALUE #( gt_bp_identification_lat_long[
      businesspartner = iv_businesspartner
      bpidentificationtype = iv_bpidentificationtype ] OPTIONAL
    ).
  ENDMETHOD.


  METHOD determine_delivery_latit_long.
    rt_return = VALUE #(
      FOR <fs_roadnet_session> IN it_sessions
      FOR <fs_roadnet_route>   IN <fs_roadnet_session>-session_identity-routes
      FOR <fs_roadnet_stop>    IN <fs_roadnet_route>-stops
      FOR <fs_roadnet_order>   IN <fs_roadnet_stop>-orders
        ( delivery  = |{ <fs_roadnet_order>-order_number ALPHA = IN }|
          latitude  = <fs_roadnet_stop>-latitude
          longitude = <fs_roadnet_stop>-longitude )
    ).
  ENDMETHOD.


  METHOD get_shiptoparty_from_delivery.
    CHECK it_deliveries_latit_longi IS NOT INITIAL.

    SELECT DISTINCT ( _deliverydocument~shiptoparty ),
                      _deliveries_latit_longi~latitude,
                      _deliveries_latit_longi~longitude
    FROM i_deliverydocument AS _deliverydocument
    JOIN @it_deliveries_latit_longi AS _deliveries_latit_longi
    ON _deliveries_latit_longi~delivery = _deliverydocument~deliverydocument
    INTO TABLE @rt_return.
  ENDMETHOD.


  METHOD get_bp_identification_lat_long.
    CHECK it_bp_shiptoparties IS NOT INITIAL.

    SELECT _bupaidentification~businesspartner,
           _bupaidentification~bpidentificationtype,
           _bupaidentification~bpidentificationnumber
    FROM @it_bp_shiptoparties AS _bp_shiptoparties
    INNER JOIN i_bupaidentification AS _bupaidentification
    ON _bupaidentification~businesspartner = _bp_shiptoparties~shiptoparty
    AND ( _bupaidentification~bpidentificationtype = 'ZLATIT' OR
          _bupaidentification~bpidentificationtype = 'ZLONGI' )
    INTO TABLE @rt_return.
  ENDMETHOD.
ENDCLASS.
