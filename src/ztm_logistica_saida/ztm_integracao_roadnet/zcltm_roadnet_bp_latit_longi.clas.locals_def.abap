    TYPES:
      BEGIN OF ty_delivery_latit_longi,
        delivery  TYPE likp-vbeln,
        latitude  TYPE bu_id_number,
        longitude TYPE bu_id_number,
      END OF ty_delivery_latit_longi,

      ty_tt_delivery_latit_longi TYPE SORTED TABLE OF ty_delivery_latit_longi WITH NON-UNIQUE KEY delivery.

    TYPES:
      BEGIN OF ty_bp_shiptoparty,
        shiptoparty TYPE i_deliverydocument-shiptoparty,
        latitude    TYPE i_bupaidentification-bpidentificationnumber,
        longitude   TYPE i_bupaidentification-bpidentificationnumber,
      END OF ty_bp_shiptoparty,
      ty_tt_bp_shiptoparty TYPE SORTED TABLE OF ty_bp_shiptoparty WITH UNIQUE KEY shiptoparty.

    TYPES:
      BEGIN OF ty_bp_identification,
        businesspartner        TYPE i_bupaidentification-businesspartner,
        bpidentificationtype   TYPE i_bupaidentification-bpidentificationtype,
        bpidentificationnumber TYPE i_bupaidentification-bpidentificationnumber,
      END OF ty_bp_identification,
      ty_tt_bp_identification TYPE SORTED TABLE OF ty_bp_identification WITH NON-UNIQUE KEY businesspartner bpidentificationtype.
