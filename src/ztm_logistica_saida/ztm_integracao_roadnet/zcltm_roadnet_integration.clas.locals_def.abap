TYPES:
  BEGIN OF ty_stop_seq_deliveries,
    transporddocreferenceid TYPE /scmtms/base_btd_id,
  END OF ty_stop_seq_deliveries,

  ty_tt_stop_seq_deliveries TYPE SORTED TABLE OF ty_stop_seq_deliveries WITH NON-UNIQUE KEY transporddocreferenceid,


  BEGIN OF ty_internal_routes_id,
    internal_route_id TYPE /scmtms/btd_id,
    equipment_type_id TYPE /scmb/de_equi_code,
  END OF ty_internal_routes_id,

  ty_tt_internal_routes_id TYPE SORTED TABLE OF ty_internal_routes_id
                             WITH NON-UNIQUE KEY internal_route_id
                             WITH NON-UNIQUE SORTED KEY sec_key COMPONENTS equipment_type_id ,

  BEGIN OF ty_roadnet_freight_orders,
    btd_id TYPE /scmtms/d_tordrf-btd_id,
    tor_id TYPE /scmtms/d_torrot-tor_id,
  END OF ty_roadnet_freight_orders,

  ty_tt_roadnet_freight_orders TYPE SORTED TABLE OF ty_roadnet_freight_orders WITH NON-UNIQUE KEY btd_id,

  BEGIN OF ty_equipament_type,
    equi_code TYPE /scmb/equi_code-equi_code,
    equi_type TYPE /scmb/equi_code-equi_type,
  END OF ty_equipament_type,
  ty_tt_equipament_type TYPE SORTED TABLE OF ty_equipament_type WITH NON-UNIQUE KEY equi_code.
