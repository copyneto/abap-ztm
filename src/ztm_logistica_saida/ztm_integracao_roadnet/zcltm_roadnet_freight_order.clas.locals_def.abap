    TYPES:


      BEGIN OF ty_db_bp_data,
        guid TYPE bu_partner_guid,
        kind TYPE bu_bpkind,
      END OF ty_db_bp_data,

      BEGIN OF ty_db_plant_data,
        werks TYPE t001w-werks,
        kunnr TYPE t001w-kunnr,
        vkorg TYPE t001w-vkorg,
      END OF ty_db_plant_data,
      BEGIN OF ty_remessas_roadnet,
        vbeln         TYPE vbeln_vl,
        torkey        TYPE /bobf/conf_key,
        torid         TYPE /scmtms/tor_id,
        latitude      TYPE bu_id_number,
        longitude     TYPE bu_id_number,
        seq           TYPE n LENGTH 4,
        arrival       TYPE /scmtms/stop_plan_date,
        tempo_servico TYPE int8,
        distance_km   TYPE /scmtms/decimal_value,
      END OF ty_remessas_roadnet,
      ty_tt_remessas_roadnet TYPE STANDARD TABLE OF ty_remessas_roadnet WITH EMPTY KEY,

      BEGIN OF ty_complete_fo,
        fo_root TYPE /scmtms/s_tor_root_k,
        fo_item TYPE /scmtms/t_tor_item_tr_k,
        fo_stop TYPE /scmtms/t_tor_stop_k,
        fo_stop_succ type /scmtms/t_tor_stop_succ_k,
      END OF ty_complete_fo,

      BEGIN OF ty_transporddocreferenceids,
        transporddocreferenceid TYPE /scmtms/base_btd_id,
      END OF ty_transporddocreferenceids,

      ty_tt_transporddocreferenceids TYPE SORTED TABLE OF ty_transporddocreferenceids WITH NON-UNIQUE KEY transporddocreferenceid,

      BEGIN OF ty_stop_seq_deliveries,
        transporddocreferenceid TYPE /scmtms/base_btd_id,
        stop_sequence_number    TYPE i,
        locationuuid            TYPE /SCMTMS/LOCUUID,
        locationid              TYPE /SCMTMS/LOCATION_ID,
        fu_uuid                 TYPE /BOBF/CONF_KEY,
        fu_id                 TYPE /SCMTMS/TOR_ID,
      END OF ty_stop_seq_deliveries,

      ty_tt_stop_seq_deliveries TYPE SORTED TABLE OF ty_stop_seq_deliveries WITH NON-UNIQUE KEY transporddocreferenceid,


      BEGIN OF ty_transporddocrefid_rootid,
        transportationorder     TYPE i_transportationorder-transportationorder,
        transportationorderuuid TYPE i_transportationorder-transportationorderuuid,
        transporddocreferenceid TYPE i_transportationorderitem-transporddocreferenceid,
      END OF ty_transporddocrefid_rootid,

      ty_tt_transporddocrefid_rootid TYPE SORTED TABLE OF ty_transporddocrefid_rootid WITH NON-UNIQUE KEY transportationorder.
