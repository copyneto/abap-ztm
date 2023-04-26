CLASS zcltm_proc_event_in_greenmile DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_notesevent,
        texto TYPE string,
      END OF ty_notesevent .
    TYPES:
      ty_texto TYPE TABLE OF ty_notesevent WITH DEFAULT KEY .

    CONSTANTS gc_option_eq TYPE char2 VALUE 'EQ' ##NO_TEXT.
    CONSTANTS gc_sign_i TYPE char1 VALUE 'I' ##NO_TEXT.
    CONSTANTS gc_torcat_to TYPE /scmtms/tor_category VALUE 'TO' ##NO_TEXT.
    CONSTANTS gc_torcat_fu TYPE /scmtms/tor_category VALUE 'FU' ##NO_TEXT.
    CONSTANTS:
      BEGIN OF gc_events,
        actual_departure      TYPE /scmtms/tor_event VALUE 'ACTUAL_DEPARTURE',
        actual_departure_stop TYPE /scmtms/tor_event VALUE 'ACTUAL_DEPARTURE_STP',
        actual_arrival        TYPE /scmtms/tor_event VALUE 'ACTUAL_ARRIVAL',
        actual_arrival_stop   TYPE /scmtms/tor_event VALUE 'ACTUAL_ARRIVAL_STOP',
        actual_complete       TYPE /scmtms/tor_event VALUE 'ACTUAL_COMPLETE',
        actual_service        TYPE /scmtms/tor_event VALUE 'ACTUAL_SERVICE',
        actual_start          TYPE /scmtms/tor_event VALUE 'ACTUAL_START',
        entrega_parcial       TYPE /scmtms/tor_event VALUE 'ENTREGA_PARCIAL',
        entrega_total         TYPE /scmtms/tor_event VALUE 'ENTREGA_TOTAL',
        entrega_pendente      TYPE /scmtms/tor_event VALUE 'ENTREGA_PENDENTE',
        devolvido             TYPE /scmtms/tor_event VALUE 'DEVOLVIDO',
        coleta                TYPE /scmtms/tor_event VALUE 'COLETADO',
        voltar_depois         TYPE /scmtms/tor_event VALUE 'VOLTAR_DEPOIS',
        hassignature          TYPE /scmtms/tor_event VALUE 'HASSIGNATURE',
        tzone                 TYPE /scmtms/tor_event VALUE 'BRAZIL',
      END OF gc_events,

      BEGIN OF gc_delivery_status,
        delivered           TYPE /scmtms/tor_event VALUE 'DELIVERED',
        pending             TYPE /scmtms/tor_event VALUE 'PENDING',
        partially_delivered TYPE /scmtms/tor_event VALUE 'PARTIALLY_DELIVERED',
      END OF gc_delivery_status,

      BEGIN OF lc_param,
        modulo TYPE zi_ca_param_mod-modulo VALUE 'TM',
        chave1 TYPE zi_ca_param_par-chave1 VALUE 'GREENMILE',
        chave2 TYPE zi_ca_param_par-chave2 VALUE 'DEBUG_EVENTOS',
      END OF lc_param.

    METHODS process_interface
      IMPORTING
        !is_input TYPE zdt_rota_gm1
      RAISING
        zcxtm_proc_event_in_greenmile .
  PROTECTED SECTION.
private section.

  data GO_SRV_TOR type ref to /BOBF/IF_TRA_SERVICE_MANAGER .
  data GS_INPUT type ZDT_ROTA_GM1 .
  data GO_TRA_MGR type ref to /BOBF/IF_TRA_TRANSACTION_MGR .
  data GT_MESSAGES type BAPIRET2_TAB .
  data GT_MOD type /BOBF/T_FRW_MODIFICATION .
  data GT_MOD_CHANGE type /BOBF/T_FRW_MODIFICATION .
  data:
    gt_key_stop_analyze TYPE STANDARD TABLE OF /bobf/s_frw_key .

  methods EVENT_ORDEM_FRETE
    raising
      ZCXTM_PROC_EVENT_IN_GREENMILE .
  methods EVENT_LOCATION
    importing
      !IS_TOR type /SCMTMS/S_TOR_ROOT_K
      !IS_OF_INPUT type ZDT_ROTA_GM_ORDEM_DE_FRETE
      !IT_KEY_FU type /BOBF/T_FRW_KEY .
  methods FILL_TEXT_COLLECTION
    importing
      !IV_LOCID type /SCMTMS/LOCATION_ID
      !IT_TOR_KEY type /BOBF/T_FRW_KEY
      !IV_KEY_EVENT type /BOBF/CONF_KEY
      !IV_ROOT_KEY type /BOBF/CONF_KEY
      !IT_TEXTO type TY_TEXTO .
  methods SAVE
    returning
      value(RV_ERRO) type ABAP_BOOL .
  methods ANALYZER_EVENT_STOPS
    importing
      !IS_TOR type /SCMTMS/S_TOR_ROOT_K .
  methods EXEC_ACTION
    importing
      !IT_KEY type /BOBF/T_FRW_KEY .
ENDCLASS.



CLASS ZCLTM_PROC_EVENT_IN_GREENMILE IMPLEMENTATION.


  METHOD event_location.

    DATA: lt_stop                 TYPE /scmtms/t_tor_stop_k,
          lt_req_stop             TYPE /scmtms/t_tor_stop_k,
          ls_mod                  TYPE /bobf/s_frw_modification,
          lt_stopaux              TYPE STANDARD TABLE OF /scmtms/s_tor_stop_k,
          lt_key                  TYPE /bobf/t_frw_key,
          lt_filtro               TYPE /bobf/t_frw_key,
          lt_fu                   TYPE /scmtms/t_tor_root_k,
          lt_exec                 TYPE /scmtms/t_tor_exec_k,
          lt_execaux              TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
          lv_enttotal             TYPE abap_bool,
          lv_entparc              TYPE abap_bool,
          lv_find                 TYPE abap_bool,
          lt_texto                TYPE ty_texto,
          lv_tor_id               TYPE /scmtms/tor_id,
          lt_execauxtor           TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
          lv_levent_arrival       TYPE abap_bool,
          lv_levent_service       TYPE abap_bool,
          lv_levent_departure     TYPE abap_bool,
          lv_levent_voltar_depois TYPE abap_bool,
          lv_text_reason          TYPE /scmtms/tor_event_reason.

    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k,
                   <fs_tor_upd> TYPE /scmtms/s_tor_root_k.

    CONSTANTS: lc_nextrel_l TYPE /scmtms/stop_wh_next VALUE 'L',
               lc_nextrel_u TYPE /scmtms/stop_wh_next VALUE 'U'.

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_tor-key CHANGING ct_key = lt_key ).


    go_srv_tor->retrieve_by_association(
       EXPORTING
         iv_node_key             = /scmtms/if_tor_c=>sc_node-root
         it_key                  = lt_key
         iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
         iv_fill_data            = abap_true
       IMPORTING
         et_data                 = lt_exec
     ).
    lt_execauxtor = lt_exec.
    SORT lt_execauxtor BY event_code.

    CLEAR : lt_exec.

    go_srv_tor->retrieve_by_association(
                                         EXPORTING
                                           iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                           it_key                  = lt_key
                                           iv_association          = /scmtms/if_tor_c=>sc_association-root-stop
                                           iv_fill_data            = abap_true
                                         IMPORTING
                                           et_data                 = lt_stop
                                       ).
    lt_stopaux = lt_stop.
    SORT lt_stopaux BY log_locid.

*    lv_levent_arrival    = abap_false.
*    lv_levent_service    = abap_false.
*    lv_levent_departure  = abap_false.

*    LOOP AT is_of_input-location1 ASSIGNING FIELD-SYMBOL(<fs_loc>) WHERE redelivered = 'false'.
    LOOP AT is_of_input-location1 ASSIGNING FIELD-SYMBOL(<fs_loc>).

      lv_levent_arrival        = abap_false.
      lv_levent_service        = abap_false.
      lv_levent_departure      = abap_false.
      lv_levent_voltar_depois  = abap_false.

      SORT lt_texto BY texto.
      DELETE ADJACENT DUPLICATES FROM lt_texto COMPARING texto.

      READ TABLE lt_stopaux
      WITH KEY log_locid = <fs_loc>-log_locid
*      ASSIGNING FIELD-SYMBOL(<fs_stop>)
      TRANSPORTING NO FIELDS.

      IF sy-subrc = 0.

        LOOP AT lt_stopaux FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_stop>).

          IF <fs_stop>-log_locid NE <fs_loc>-log_locid.
            EXIT.
          ENDIF.


*          IF <fs_stop>-wh_next_rel EQ lc_nextrel_l
*             OR <fs_stop>-wh_next_rel EQ lc_nextrel_u.

          CLEAR lt_key.
          /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_stop>-key CHANGING ct_key = lt_key ).

          go_srv_tor->retrieve_by_association(
                                            EXPORTING
                                              iv_node_key             = /scmtms/if_tor_c=>sc_node-stop
                                              it_key                  = lt_key
                                              iv_association          = /scmtms/if_tor_c=>sc_association-stop-assigned_req_stops
                                              iv_fill_data            = abap_true
                                            IMPORTING
                                              et_data                 = lt_req_stop
                                          ).

          CLEAR : lt_key,
                  lt_fu.

          LOOP AT lt_req_stop ASSIGNING FIELD-SYMBOL(<fs_req_stop>).
            /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_req_stop>-parent_key CHANGING ct_key = lt_key ).
          ENDLOOP.

          IF lt_key IS INITIAL.
            CONTINUE.
          ENDIF.

          go_srv_tor->query(
                              EXPORTING
                                iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                                it_filter_key           = lt_key
                                iv_fill_data            = abap_true
                              IMPORTING
                                et_data                 =  lt_fu
                            ).

          LOOP AT lt_fu ASSIGNING FIELD-SYMBOL(<fs_fu>). "Loop das UF

            CLEAR : lt_key,
                    lt_exec,
                    lt_execaux,
                    lt_texto,
                    lv_text_reason.

            lv_tor_id = <fs_fu>-tor_id.

            SHIFT lv_tor_id LEFT DELETING LEADING '0'.

            LOOP AT <fs_loc>-unidade_de_frete ASSIGNING FIELD-SYMBOL(<fs_txtuf>).
*
              IF <fs_txtuf>-tor_id = lv_tor_id.

                IF <fs_txtuf>-lineitems IS NOT INITIAL.
                  READ TABLE <fs_txtuf>-lineitems
                  INDEX 1 ASSIGNING FIELD-SYMBOL(<fs_lineitens>).

                  IF sy-subrc = 0.

                    LOOP AT <fs_lineitens>-deliveryreasoncode ASSIGNING FIELD-SYMBOL(<fs_delivery>).
                      IF <fs_delivery>-deliveryreasoncode_description IS NOT INITIAL.

                        IF lv_text_reason IS INITIAL.
                          lv_text_reason = <fs_delivery>-deliveryreasoncode_description.
                        ELSE.
                          lv_text_reason = |{ lv_text_reason }/{ <fs_delivery>-deliveryreasoncode_description }|.
                        ENDIF.

*                        APPEND INITIAL LINE TO lt_texto ASSIGNING FIELD-SYMBOL(<fs_texto>).
*                        <fs_texto>-texto = <fs_delivery>-deliveryreasoncode_description.
                      ENDIF.
                    ENDLOOP.


                    LOOP AT <fs_lineitens>-shortreasoncode ASSIGNING FIELD-SYMBOL(<fs_short>).
                      IF <fs_short>-shortreasoncode_description IS NOT INITIAL.

                        lv_text_reason = |{ lv_text_reason }{ <fs_short>-shortreasoncode_description }|.

*                        APPEND INITIAL LINE TO lt_texto ASSIGNING <fs_texto>.
*                        <fs_texto>-texto = <fs_short>-shortreasoncode_description.
                      ENDIF.
                    ENDLOOP.

                    LOOP AT <fs_lineitens>-demagereasoncode ASSIGNING FIELD-SYMBOL(<fs_dema>).

                      IF <fs_dema>-demagereasoncode_description IS NOT INITIAL.

                        lv_text_reason = |{ lv_text_reason }{ <fs_dema>-demagereasoncode_description }|.

*                        APPEND INITIAL LINE TO lt_texto ASSIGNING <fs_texto>.
*                        <fs_texto>-texto = <fs_dema>-demagereasoncode_description.
                      ENDIF.
                    ENDLOOP.


                    LOOP AT <fs_lineitens>-overreasoncode ASSIGNING FIELD-SYMBOL(<fs_over>).
                      IF <fs_over>-overreasoncode_description IS NOT INITIAL.

                        lv_text_reason = |{ lv_text_reason }{ <fs_over>-overreasoncode_description }|.

*                        APPEND INITIAL LINE TO lt_texto ASSIGNING <fs_texto>.
*                        <fs_texto>-texto = <fs_over>-overreasoncode_description.
                      ENDIF.
                    ENDLOOP.

                    LOOP AT <fs_lineitens>-pickupreasoncode ASSIGNING FIELD-SYMBOL(<fs_pick>).

                      IF <fs_pick>-pickup_reasoncode_description IS NOT INITIAL.

                        lv_text_reason = |{ lv_text_reason }{ <fs_pick>-pickup_reasoncode_description }|.

*                        APPEND INITIAL LINE TO lt_texto ASSIGNING <fs_texto>.
*                        <fs_texto>-texto = <fs_pick>-pickup_reasoncode_description.
                      ENDIF.
                    ENDLOOP.

                  ENDIF.
                ENDIF.
              ENDIF.

            ENDLOOP.

            IF is_of_input-bp_chapa = 'true'.

              CLEAR ls_mod.

              ls_mod-node         = /scmtms/if_tor_c=>sc_node-root.
              ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_update.
              ls_mod-key          = <fs_fu>-key.

              CREATE DATA ls_mod-data TYPE /scmtms/s_tor_root_k.
              ASSIGN ls_mod-data->* TO <fs_fu>.
              <fs_fu>-zzchapa = abap_true.
              APPEND 'ZZCHAPA' TO ls_mod-changed_fields.
              APPEND ls_mod TO gt_mod_change.

            ENDIF.

            LOOP AT <fs_loc>-undeliverablecode ASSIGNING FIELD-SYMBOL(<fs_undeliverablecode>).
              IF <fs_undeliverablecode>-undeliverablecode_description IS NOT INITIAL.
                lv_text_reason = |{ lv_text_reason }{ <fs_undeliverablecode>-undeliverablecode_description }|.
              ENDIF.
            ENDLOOP.

            /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_fu>-key CHANGING ct_key = lt_key ).

            go_srv_tor->retrieve_by_association(
                                                   EXPORTING
                                                     iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                     it_key                  = lt_key
                                                     iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
                                                     iv_fill_data            = abap_true
                                                   IMPORTING
                                                     et_data                 = lt_exec
                                                 ).
            lt_execaux = lt_exec.
            SORT lt_execaux BY event_code.

            IF <fs_loc>-event_arrival IS NOT INITIAL.

              READ TABLE lt_execaux
              WITH KEY event_code = gc_events-actual_arrival_stop
                       actual_date = <fs_loc>-event_arrival
              TRANSPORTING NO FIELDS.

              IF sy-subrc NE 0.

                CLEAR ls_mod.

                ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                ls_mod-source_key   = <fs_fu>-key.
                ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                ASSIGN ls_mod-data->* TO <fs_exec>.
                <fs_exec>-key = ls_mod-key.

                <fs_exec>-event_code  = gc_events-actual_arrival_stop.
                <fs_exec>-actual_date = <fs_loc>-event_arrival.
                <fs_exec>-event_reason_code = <fs_loc>-event_arrivaldataquality.
                <fs_exec>-ext_loc_id  = <fs_loc>-log_locid.

                <fs_exec>-actual_tzone = gc_events-tzone.
                APPEND ls_mod TO gt_mod.

*                IF lt_texto IS NOT INITIAL.
*                  fill_text_collection(
*                                        EXPORTING
*                                          iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
*                                          it_tor_key   = lt_key
*                                          iv_key_event =  ls_mod-key
*                                          iv_root_key  = is_tor-key
*                                          it_texto     = lt_texto
*                                      ).
*                ENDIF.

                "inserindo evento no TOR
                IF lv_levent_arrival EQ abap_false.

                  lv_levent_arrival = abap_true.

                  READ TABLE lt_execauxtor
                  WITH KEY event_code  = gc_events-actual_arrival_stop
                           ext_loc_id  = <fs_loc>-log_locid
                           actual_date = <fs_loc>-event_arrival
                  TRANSPORTING NO FIELDS.

                  IF sy-subrc NE 0.
                    CLEAR ls_mod.

                    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                    ls_mod-source_key   = is_tor-key.
                    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                    ASSIGN ls_mod-data->* TO <fs_exec>.
                    <fs_exec>-key = ls_mod-key.

                    <fs_exec>-event_code        = gc_events-actual_arrival_stop.
                    <fs_exec>-actual_date       = <fs_loc>-event_arrival.
                    <fs_exec>-event_reason_code = <fs_loc>-event_arrivaldataquality.
                    <fs_exec>-ext_loc_id        = <fs_loc>-log_locid.

                    <fs_exec>-actual_tzone = gc_events-tzone.
                    APPEND ls_mod TO gt_mod.

*                    IF lt_texto IS NOT INITIAL.
*                      fill_text_collection(
*                                            EXPORTING
*                                              iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
*                                              it_tor_key   = lt_key
*                                              iv_key_event = ls_mod-key
*                                              iv_root_key  = is_tor-key
*                                              it_texto     = lt_texto
*                                          ).
*                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDIF.

            IF <fs_loc>-event_service IS NOT INITIAL.

              READ TABLE lt_execaux
              WITH KEY event_code  = gc_events-actual_service
                       actual_date = <fs_loc>-event_service
              TRANSPORTING NO FIELDS.

              IF sy-subrc NE 0.

                CLEAR ls_mod.

                ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                ls_mod-source_key   = <fs_fu>-key.
                ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                ASSIGN ls_mod-data->* TO <fs_exec>.
                <fs_exec>-key = ls_mod-key.

*                 <fs_exec>-event_reason = <fs_loc>-
                <fs_exec>-event_code  = gc_events-actual_service.
                <fs_exec>-actual_date = <fs_loc>-event_service.
                <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
                <fs_exec>-ext_loc_id  = <fs_loc>-log_locid.
                <fs_exec>-actual_tzone = gc_events-tzone.
                APPEND ls_mod TO gt_mod.

*                IF lt_texto IS NOT INITIAL.
*                  fill_text_collection(
*                                        EXPORTING
*                                          iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
*                                          it_tor_key   = lt_key
*                                          iv_key_event =  ls_mod-key
*                                          iv_root_key  = is_tor-key
*                                          it_texto     = lt_texto
*                                      ).
*                ENDIF.


                "inserindo evento no TOR
                IF lv_levent_service EQ abap_false.

                  lv_levent_service = abap_true.

                  READ TABLE lt_execauxtor
                  WITH KEY event_code  = gc_events-actual_service
                           ext_loc_id  = <fs_loc>-log_locid
                           actual_date = <fs_loc>-event_service
                  TRANSPORTING NO FIELDS.

                  IF sy-subrc NE 0.

                    CLEAR ls_mod.

                    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                    ls_mod-source_key   = is_tor-key.
                    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                    ASSIGN ls_mod-data->* TO <fs_exec>.

                    <fs_exec>-key               = ls_mod-key.
                    <fs_exec>-event_code        = gc_events-actual_service.
                    <fs_exec>-actual_date       = <fs_loc>-event_service.
                    <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
                    <fs_exec>-ext_loc_id        = <fs_loc>-log_locid.
                    <fs_exec>-actual_tzone      = gc_events-tzone.
                    APPEND ls_mod TO gt_mod.

*                    IF lt_texto IS NOT INITIAL.
*                      fill_text_collection(
*                                            EXPORTING
*                                              iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
*                                              it_tor_key   = lt_key
*                                              iv_key_event = ls_mod-key
*                                              iv_root_key  = is_tor-key
*                                              it_texto     = lt_texto
*                                          ).
*                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDIF.

*            IF <fs_loc>-event_departure IS NOT INITIAL.
*
*              READ TABLE lt_execaux
*              WITH KEY event_code  = gc_events-actual_departure_stop
*                       actual_date = <fs_loc>-event_departure
*              BINARY SEARCH TRANSPORTING NO FIELDS.
*
*              IF sy-subrc NE 0.
*
*                CLEAR ls_mod.
*
*                ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*                ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*                ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*                ls_mod-source_key   = <fs_fu>-key.
*                ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*                ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*                ASSIGN ls_mod-data->* TO <fs_exec>.
*                <fs_exec>-key = ls_mod-key.
*                <fs_exec>-event_code   = gc_events-actual_departure_stop.
*                <fs_exec>-actual_date  = <fs_loc>-event_departure.
*                <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
*                <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
*                <fs_exec>-actual_tzone = gc_events-tzone.
*                APPEND ls_mod TO gt_mod.
*
**                IF lt_texto IS NOT INITIAL.
**                  fill_text_collection(
**                                        EXPORTING
**                                          iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
**                                          it_tor_key   = lt_key
**                                          iv_key_event =  ls_mod-key
**                                          iv_root_key  = is_tor-key
**                                          it_texto     = lt_texto
**                                      ).
**                ENDIF.
*
*                "inserindo evento no TOR
*                IF lv_levent_departure EQ abap_false.
*                  lv_levent_departure = abap_true.
*
*                  READ TABLE lt_execauxtor
*                  WITH KEY event_code  = gc_events-actual_departure_stop
*                           ext_loc_id  = <fs_loc>-log_locid
*                           actual_date = <fs_loc>-event_departure
*                  BINARY SEARCH TRANSPORTING NO FIELDS.
*
*                  IF sy-subrc NE 0.
*
*                    CLEAR ls_mod.
*
*                    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*                    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*                    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*                    ls_mod-source_key   = is_tor-key.
*                    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*                    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*                    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*                    ASSIGN ls_mod-data->* TO <fs_exec>.
*                    <fs_exec>-key = ls_mod-key.
*                    <fs_exec>-event_code   = gc_events-actual_departure_stop.
*                    <fs_exec>-actual_date  = <fs_loc>-event_departure.
*                    <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
*                    <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
*                    <fs_exec>-actual_tzone = gc_events-tzone.
*                    APPEND ls_mod TO gt_mod.
*
**                    IF lt_texto IS NOT INITIAL.
**                      fill_text_collection(
**                                            EXPORTING
**                                              iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
**                                              it_tor_key   = lt_key
**                                              iv_key_event =  ls_mod-key
**                                              iv_root_key  = is_tor-key
**                                              it_texto     = lt_texto
**                                          ).
**                    ENDIF.
*
*                  ENDIF.
*
*
*                ENDIF.
*
*
*
**                ENDIF.
*
**              IF <fs_loc>-hasassignature EQ abap_true.
**                CLEAR ls_mod.
**
**                ls_mod-node         = /scmtms/if_tor_c=>sc_node-root.
**                ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_update.
**                ls_mod-key          = <fs_fu>-key.
**
**                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_root_k.
**                ASSIGN ls_mod-data->* TO <fs_tor_upd>.
***                <fs_tor_upd>- = abap_true.
***                 APPEND /scmtms/if_tor_c=>sc_node_attribute-root-h to ls_mod-changed_fields.
**                APPEND ls_mod TO gt_mod_change.
**
**              ENDIF.
*                IF <fs_fu>-tor_type NE 'F013'.
*                  "Evento 1
*                  CLEAR ls_mod.
*
*                  ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*                  ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*                  ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*                  ls_mod-source_key   = <fs_fu>-key.
*                  ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*                  ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*                  CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*                  ASSIGN ls_mod-data->* TO <fs_exec>.
*                  <fs_exec>-key = ls_mod-key.
*
**                 <fs_exec>-event_reason = <fs_loc>-
**                <fs_exec>-actual_date  = <fs_loc>-event_arrival.
*                  <fs_exec>-actual_date  = <fs_loc>-event_departure.
*                  <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
*                  <fs_exec>-actual_tzone = gc_events-tzone.
*                  <fs_exec>-event_reason = lv_text_reason.
*
*                  IF <fs_loc>-deliverystatus EQ gc_delivery_status-delivered.
*                    <fs_exec>-event_code = gc_events-entrega_total.
*                    lv_enttotal = abap_true.
*                  ENDIF.
*
*                  IF <fs_loc>-deliverystatus EQ gc_delivery_status-partially_delivered.
*                    <fs_exec>-event_code = gc_events-entrega_parcial.
*                    lv_entparc = abap_true.
*                  ENDIF.
*
*                  IF <fs_loc>-deliverystatus EQ gc_delivery_status-pending AND
*                     <fs_loc>-returned       EQ 'true'."abap_true.
*                    <fs_exec>-event_code = gc_events-devolvido.
*                  ELSEIF <fs_loc>-deliverystatus EQ gc_delivery_status-pending AND
*                         <fs_loc>-returned       EQ 'false'                    AND
*                         <fs_loc>-redelivered    EQ 'false'."abap_false.
*                    <fs_exec>-event_code = gc_events-entrega_pendente.
*                  ENDIF.
*
*                  IF <fs_exec>-event_code IS NOT INITIAL.
*                    APPEND ls_mod TO gt_mod.
*
*                    IF <fs_loc>-hasassignature EQ 'true'                    AND
*                     ( <fs_exec>-event_code    EQ gc_events-entrega_total   OR
*                       <fs_exec>-event_code    EQ gc_events-entrega_parcial ).
*
*                      READ TABLE lt_execaux
*                      WITH KEY event_code  = gc_events-hassignature
*                               actual_date = <fs_loc>-event_departure
*                      BINARY SEARCH TRANSPORTING NO FIELDS.
*
*                      IF sy-subrc NE 0.
*
*                        CLEAR ls_mod.
*
*                        ls_mod-node                 = /scmtms/if_tor_c=>sc_node-executioninformation.
*                        ls_mod-change_mode          = /bobf/if_frw_c=>sc_modify_create.
*                        ls_mod-association          = /scmtms/if_tor_c=>sc_association-root-exec.
*                        ls_mod-source_key           = <fs_fu>-key.
*                        ls_mod-source_node          = /scmtms/if_tor_c=>sc_node-root.
*                        ls_mod-key                  = /bobf/cl_frw_factory=>get_new_key( ).
*
*                        CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*                        ASSIGN ls_mod-data->* TO <fs_exec>.
*                        <fs_exec>-key               = ls_mod-key.
*                        <fs_exec>-event_code        = gc_events-hassignature.
*                        <fs_exec>-actual_date       = <fs_loc>-event_departure.
*                        <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
*                        <fs_exec>-ext_loc_id        = <fs_loc>-log_locid.
*                        <fs_exec>-actual_tzone      = gc_events-tzone.
*                        APPEND ls_mod TO gt_mod.
*
*                      ENDIF.
*                    ENDIF.
*                  ENDIF.
*                ENDIF.
*
**                IF lt_texto IS NOT INITIAL.
**                  fill_text_collection( EXPORTING iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
**                                                  it_tor_key   = lt_key
**                                                  iv_key_event = ls_mod-key
**                                                  iv_root_key  = is_tor-key
**                                                  it_texto     = lt_texto ).
**                ENDIF.
*
**                " Evento 'Voltar Depois'
**                IF <fs_loc>-redelivered EQ 'true'.
**
**                  READ TABLE lt_execaux
**                  WITH KEY event_code  = gc_events-voltar_depois
**                           actual_date = <fs_loc>-event_service
**                  BINARY SEARCH TRANSPORTING NO FIELDS.
**
**                  IF sy-subrc NE 0.
**
**                    CLEAR ls_mod.
**
**                    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
**                    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
**                    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
**                    ls_mod-source_key   = <fs_fu>-key.
**                    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
**                    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
**
**                    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
**                    ASSIGN ls_mod-data->* TO <fs_exec>.
**                    <fs_exec>-key = ls_mod-key.
**                    <fs_exec>-actual_date  = <fs_loc>-event_departure.
**                    <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
**                    <fs_exec>-actual_tzone = gc_events-tzone.
**                    <fs_exec>-event_code   = gc_events-voltar_depois.
**                    APPEND ls_mod TO gt_mod.
**
**                  ENDIF.
**                ENDIF.
*
**                "Evento 2
**                READ TABLE lt_execaux
**                WITH KEY event_code = lc_ev_saidaCli
**                BINARY SEARCH TRANSPORTING NO FIELDS.
**
**                IF sy-subrc NE 0.
**
**                  CLEAR ls_mod.
**
**                  ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
**                  ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
**                  ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
**                  ls_mod-source_key   = <fs_fu>-key.
**                  ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
**                  ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
**
**                  CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
**                  ASSIGN ls_mod-data->* TO <fs_exec>.
**                  <fs_exec>-key = ls_mod-key.
**
***                  <fs_exec>-actual_date  = <fs_loc>-event_arrival.
**                  <fs_exec>-actual_date  = <fs_loc>-event_departure.
**                  <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
**                  <fs_exec>-actual_tzone = lc_tzone.
**                  <fs_exec>-event_code = lc_ev_saidaCli.
**                  APPEND ls_mod TO gt_mod.
*                APPEND INITIAL LINE TO gt_key_stop_analyze ASSIGNING FIELD-SYMBOL(<fs_stop_analye>).
*                <fs_stop_analye>-key = <fs_stop>-key.
**                ENDIF.
*
*              ENDIF.
*            ENDIF."fim do IF <fs_loc>-event_departure IS NOT INITIAL.

            " Evento 'Voltar Depois'
            IF <fs_loc>-redelivered EQ 'true' AND
               <fs_loc>-event_departure IS NOT INITIAL.

              READ TABLE lt_execaux
              WITH KEY event_code  = gc_events-voltar_depois
                       actual_date = <fs_loc>-event_departure
              TRANSPORTING NO FIELDS.

              IF sy-subrc NE 0.

                CLEAR ls_mod.

                ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                ls_mod-source_key   = <fs_fu>-key.
                ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                ASSIGN ls_mod-data->* TO <fs_exec>.
                <fs_exec>-key = ls_mod-key.
                <fs_exec>-actual_date  = <fs_loc>-event_departure.
                <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
                <fs_exec>-actual_tzone = gc_events-tzone.
                <fs_exec>-event_code   = gc_events-voltar_depois.
                <fs_exec>-event_reason = lv_text_reason.
                APPEND ls_mod TO gt_mod.

*                IF lt_texto IS NOT INITIAL.
*                  fill_text_collection( EXPORTING iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
*                                                  it_tor_key   = lt_key
*                                                  iv_key_event = ls_mod-key
*                                                  iv_root_key  = is_tor-key
*                                                  it_texto     = lt_texto ).
*                ENDIF.

                "inserindo evento no TOR
                IF lv_levent_voltar_depois EQ abap_false.

                  lv_levent_voltar_depois = abap_true.

                  READ TABLE lt_execauxtor
                  WITH KEY event_code  = gc_events-voltar_depois
                           ext_loc_id  = <fs_loc>-log_locid
                           actual_date = <fs_loc>-event_departure
                  TRANSPORTING NO FIELDS.

                  IF sy-subrc NE 0.
                    CLEAR ls_mod.

                    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                    ls_mod-source_key   = is_tor-key.
                    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                    ASSIGN ls_mod-data->* TO <fs_exec>.
                    <fs_exec>-key = ls_mod-key.

                    <fs_exec>-event_code        = gc_events-voltar_depois.
                    <fs_exec>-actual_date       = <fs_loc>-event_departure.
                    <fs_exec>-event_reason_code = <fs_loc>-event_departuredataquality.
                    <fs_exec>-ext_loc_id        = <fs_loc>-log_locid.

                    <fs_exec>-actual_tzone = gc_events-tzone.
                    APPEND ls_mod TO gt_mod.

*                    IF lt_texto IS NOT INITIAL.
*                      fill_text_collection(
*                                            EXPORTING
*                                              iv_locid     = CONV /scmtms/location_id( <fs_loc>-log_locid )
*                                              it_tor_key   = lt_key
*                                              iv_key_event = ls_mod-key
*                                              iv_root_key  = is_tor-key
*                                              it_texto     = lt_texto
*                                          ).
*                    ENDIF.

                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.

            IF <fs_fu>-tor_type EQ 'F013' AND " Coleta
               <fs_loc>-event_service IS NOT INITIAL.

              READ TABLE lt_execaux
              WITH KEY event_code  = gc_events-coleta
                       actual_date = <fs_loc>-event_service
              TRANSPORTING NO FIELDS.

              IF sy-subrc NE 0.

                CLEAR ls_mod.

                ls_mod-node                 = /scmtms/if_tor_c=>sc_node-executioninformation.
                ls_mod-change_mode          = /bobf/if_frw_c=>sc_modify_create.
                ls_mod-association          = /scmtms/if_tor_c=>sc_association-root-exec.
                ls_mod-source_key           = <fs_fu>-key.
                ls_mod-source_node          = /scmtms/if_tor_c=>sc_node-root.
                ls_mod-key                  = /bobf/cl_frw_factory=>get_new_key( ).

                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                ASSIGN ls_mod-data->* TO <fs_exec>.
                <fs_exec>-key               = ls_mod-key.
                <fs_exec>-event_code        = gc_events-coleta.
                <fs_exec>-actual_date       = <fs_loc>-event_service.
                <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
                <fs_exec>-ext_loc_id        = <fs_loc>-log_locid.
                <fs_exec>-actual_tzone      = gc_events-tzone.
                APPEND ls_mod TO gt_mod.

              ENDIF.
            ENDIF. " Fim Coleta

            IF <fs_loc>-event_departure IS NOT INITIAL.

              READ TABLE lt_execaux
              WITH KEY event_code  = gc_events-actual_departure_stop
                       actual_date = <fs_loc>-event_departure TRANSPORTING NO FIELDS.

              IF sy-subrc NE 0.

                CLEAR ls_mod.

                ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                ls_mod-source_key   = <fs_fu>-key.
                ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                ASSIGN ls_mod-data->* TO <fs_exec>.
                <fs_exec>-key = ls_mod-key.
                <fs_exec>-event_code   = gc_events-actual_departure_stop.
                <fs_exec>-actual_date  = <fs_loc>-event_departure.
                <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
                <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
                <fs_exec>-actual_tzone = gc_events-tzone.
                APPEND ls_mod TO gt_mod.

                "inserindo evento no TOR
                IF lv_levent_departure EQ abap_false.
                  lv_levent_departure = abap_true.

                  READ TABLE lt_execauxtor
                  WITH KEY event_code  = gc_events-actual_departure_stop
                           ext_loc_id  = <fs_loc>-log_locid
                           actual_date = <fs_loc>-event_departure
                  TRANSPORTING NO FIELDS.

                  IF sy-subrc NE 0.

                    CLEAR ls_mod.

                    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                    ls_mod-source_key   = is_tor-key.
                    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                    ASSIGN ls_mod-data->* TO <fs_exec>.
                    <fs_exec>-key = ls_mod-key.
                    <fs_exec>-event_code   = gc_events-actual_departure_stop.
                    <fs_exec>-actual_date  = <fs_loc>-event_departure.
                    <fs_exec>-event_reason_code = <fs_loc>-event_servicedataquality.
                    <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
                    <fs_exec>-actual_tzone = gc_events-tzone.
                    APPEND ls_mod TO gt_mod.

                  ENDIF.

                ENDIF.
              ENDIF.
              IF <fs_fu>-tor_type NE 'F013'.
                "Evento 1
                CLEAR ls_mod.

                  ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
                  ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
                  ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
                  ls_mod-source_key   = <fs_fu>-key.
                  ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
                  ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

                  CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                  ASSIGN ls_mod-data->* TO <fs_exec>.
                  <fs_exec>-key = ls_mod-key.

                  <fs_exec>-actual_date  = <fs_loc>-event_departure.
                  <fs_exec>-ext_loc_id   = <fs_loc>-log_locid.
                  <fs_exec>-actual_tzone = gc_events-tzone.
                  <fs_exec>-event_reason = lv_text_reason.

                  IF <fs_loc>-deliverystatus EQ gc_delivery_status-delivered.
                    <fs_exec>-event_code = gc_events-entrega_total.
                    lv_enttotal = abap_true.
                  ENDIF.

                  IF <fs_loc>-deliverystatus EQ gc_delivery_status-partially_delivered.
                    <fs_exec>-event_code = gc_events-entrega_parcial.
                    lv_entparc = abap_true.
                  ENDIF.

                  IF <fs_loc>-deliverystatus EQ gc_delivery_status-pending AND
                     <fs_loc>-returned       EQ 'true'."abap_true.
                    <fs_exec>-event_code = gc_events-devolvido.
                  ELSEIF <fs_loc>-deliverystatus EQ gc_delivery_status-pending AND
                         <fs_loc>-returned       EQ 'false'                    AND
                         <fs_loc>-redelivered    EQ 'false'."abap_false.
                    <fs_exec>-event_code = gc_events-entrega_pendente.
                  ENDIF.

                READ TABLE lt_execaux
                WITH KEY event_code  = <fs_exec>-event_code
                         actual_date = <fs_loc>-event_departure
                TRANSPORTING NO FIELDS.
                IF sy-subrc NE 0.
                  IF <fs_exec>-event_code IS NOT INITIAL.
                    APPEND ls_mod TO gt_mod.
                  ENDIF.
                ENDIF.

                IF <fs_exec>-event_code IS NOT INITIAL.
                  IF lv_text_reason          IS INITIAL                   AND
                     <fs_loc>-hasassignature EQ 'true'                    AND
                   ( <fs_exec>-event_code    EQ gc_events-entrega_total   OR
                     <fs_exec>-event_code    EQ gc_events-entrega_parcial ).

                    READ TABLE lt_execaux
                    WITH KEY event_code  = gc_events-hassignature
                             actual_date = <fs_loc>-event_departure
                    TRANSPORTING NO FIELDS.

                    IF sy-subrc NE 0.

                      CLEAR ls_mod.

                      ls_mod-node                 = /scmtms/if_tor_c=>sc_node-executioninformation.
                      ls_mod-change_mode          = /bobf/if_frw_c=>sc_modify_create.
                      ls_mod-association          = /scmtms/if_tor_c=>sc_association-root-exec.
                      ls_mod-source_key           = <fs_fu>-key.
                      ls_mod-source_node          = /scmtms/if_tor_c=>sc_node-root.
                      ls_mod-key                  = /bobf/cl_frw_factory=>get_new_key( ).

                      CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
                      ASSIGN ls_mod-data->* TO <fs_exec>.
                      <fs_exec>-key               = ls_mod-key.
                      <fs_exec>-event_code        = gc_events-hassignature.
                      <fs_exec>-actual_date       = <fs_loc>-event_departure.
                      <fs_exec>-event_reason_code = <fs_loc>-event_departuredataquality.
                      <fs_exec>-event_reason      = lv_text_reason.
                      <fs_exec>-ext_loc_id        = <fs_loc>-log_locid.
                      <fs_exec>-actual_tzone      = gc_events-tzone.
                      APPEND ls_mod TO gt_mod.

                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF."fim do Event_departure

          ENDLOOP."LOOP DA FU
*        endloop.
*          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

*    IF lv_entparc EQ abap_false AND lv_enttotal EQ abap_false.
*      CLEAR : lt_key,
*              lt_fu.
*      LOOP AT lt_stop ASSIGNING <fs_stop>.
*        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_stop>-parent_key CHANGING ct_key = lt_key ).
*      ENDLOOP.
*
*      go_srv_tor->query(
*                             EXPORTING
*                               iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
*                               it_filter_key           = lt_filtro
*                               iv_fill_data            = abap_true
*                             IMPORTING
*                               et_data                 =  lt_fu
*                           ).
*
*      lv_find = abap_false.
*      LOOP AT lt_tor ASSIGNING <fs_tor>.
*        CLEAR: lt_key,
*               lt_exec.
*        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor>-key CHANGING ct_key = lt_key ).
*
*        go_srv_tor->retrieve_by_association(
*          EXPORTING
*            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
*            it_key                  = lt_key
*            iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
*            iv_fill_data            = abap_true
*          IMPORTING
*            et_data                 = lt_exec
*        ).
*
*        LOOP AT lt_exec ASSIGNING <fs_exec>.
*          IF <fs_exec>-event_code = lc_ev_ent_total.
*            lv_enttotal = abap_true.
*            lv_find = abap_true.
*          ENDIF.
*
*          IF <fs_exec>-event_code = lc_ev_parcent.
*            lv_enttotal = abap_true.
*            lv_find = abap_true.
*          ENDIF.
*
*          IF lv_find = abap_true.
*            EXIT.
*          ENDIF.
*
*        ENDLOOP.
*
*        IF lv_find = abap_true.
*          EXIT.
*        ENDIF.
*
*      ENDLOOP.
*
*    ENDIF.
*
*    IF lv_entparc = abap_true.
*      CLEAR ls_mod.
*
*      ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*      ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*      ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*      ls_mod-source_key   = is_tor-key.
*      ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*      ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*      CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*      ASSIGN ls_mod-data->* TO <fs_exec>.
*      <fs_exec>-key = ls_mod-key.
*      <fs_exec>-event_code  = lc_ev_parcEnt.
*
*      APPEND ls_mod TO gt_mod.
*
*    ELSEIF lv_enttotal = abap_true.
*
*      CLEAR ls_mod.
*
*      ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*      ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*      ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*      ls_mod-source_key   = is_tor-key.
*      ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*      ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*      CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*      ASSIGN ls_mod-data->* TO <fs_exec>.
*      <fs_exec>-key = ls_mod-key.
*      <fs_exec>-event_code  = lc_ev_tot_entreg.
*
*      APPEND ls_mod TO gt_mod.
*
*    ENDIF.


  ENDMETHOD.


  METHOD event_ordem_frete.
    DATA: lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_fu           TYPE /scmtms/t_tor_root_k,
          lt_tor_root_key TYPE /bobf/t_frw_key,
          lt_FU_key       TYPE /bobf/t_frw_key,
          lt_tor_exec_key TYPE /bobf/t_frw_key,
          lt_parameters   TYPE /bobf/t_frw_query_selparam,
          ls_parameters   TYPE /bobf/s_frw_query_selparam,
          lt_exec         TYPE /scmtms/t_tor_exec_k,
          lt_stop         TYPE /scmtms/t_tor_stop_k,
          lt_stop_last    TYPE /scmtms/t_tor_stop_k,
*          gt_mod               TYPE /bobf/t_frw_modification,
*          gt_mod_change        TYPE /bobf/t_frw_modification,
          ls_mod          TYPE /bobf/s_frw_modification,
          lt_execaux      TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
          lt_return       TYPE bapiret2_tab,
          lv_tor_id       TYPE char10.

    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k,
                   <fs_tor_upd> TYPE /scmtms/s_tor_root_k.

    LOOP AT gs_input-dt_rota_gm-ordem_de_frete ASSIGNING FIELD-SYMBOL(<fs_input>).

      ls_parameters-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
      ls_parameters-sign   = gc_sign_i.
      ls_parameters-option = gc_option_eq.
      ls_parameters-low    = <fs_input>-tor_id.
      APPEND ls_parameters TO lt_parameters.
      CLEAR ls_parameters.
    ENDLOOP.

    IF lt_parameters IS NOT INITIAL.

      ls_parameters-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_cat.
      ls_parameters-sign   = gc_sign_i.
      ls_parameters-option = gc_option_eq.
      ls_parameters-low    = gc_torcat_to.
      APPEND ls_parameters TO lt_parameters.
      CLEAR ls_parameters.

      go_srv_tor->query(
                          EXPORTING
                            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                            it_selection_parameters = lt_parameters
                            iv_fill_data            = abap_true
                          IMPORTING
                            et_key                  = lt_tor_root_key
                            et_data                 = lt_tor
                       ).

    ENDIF.
    LOOP AT lt_tor ASSIGNING FIELD-SYMBOL(<fs_tor>).

      CLEAR: lt_tor_root_key,
             lt_exec,
             lt_stop,
             lt_execaux,
             gt_key_stop_analyze.

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor>-key CHANGING ct_key = lt_tor_root_key ).

      go_srv_tor->retrieve_by_association(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root
          it_key                  = lt_tor_root_key
          iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_exec
      ).
      lt_execaux = lt_exec.
      SORT lt_execaux BY event_code.

      go_srv_tor->retrieve_by_association(
                                         EXPORTING
                                           iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                           it_key                  = lt_tor_root_key
                                           iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first
                                           iv_fill_data            = abap_true
                                         IMPORTING
                                           et_data                 = lt_stop
                                       ).

      go_srv_tor->retrieve_by_association(
                                          EXPORTING
                                            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                            it_key                  = lt_tor_root_key
                                            iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_last
                                            iv_fill_data            = abap_true
                                          IMPORTING
                                            et_data                 = lt_stop_last
                                        ).

      "Remover zeros a esquerda
      lv_tor_id = |{ <fs_tor>-tor_id ALPHA = OUT }|.

      READ TABLE gs_input-dt_rota_gm-ordem_de_frete
      WITH KEY tor_id = lv_tor_id
      ASSIGNING <fs_input>.

      IF sy-subrc = 0.

        IF <fs_input>-event_start IS NOT INITIAL.
          READ TABLE lt_execaux
          WITH KEY event_code = gc_events-actual_start
                   actual_date = <fs_input>-event_start
          BINARY SEARCH TRANSPORTING NO FIELDS.

          IF sy-subrc NE 0.

            CLEAR ls_mod.

            ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
            ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
            ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
            ls_mod-source_key   = <fs_tor>-key.
            ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
            ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

            CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
            ASSIGN ls_mod-data->* TO <fs_exec>.
            <fs_exec>-key = ls_mod-key.

            APPEND INITIAL LINE TO lt_tor_exec_key ASSIGNING FIELD-SYMBOL(<fs_key_exec>).
            <fs_key_exec>-key = <fs_exec>-key.

            <fs_exec>-event_code = gc_events-actual_start.
            <fs_exec>-actual_date = <fs_input>-event_start.

            IF lt_stop IS NOT INITIAL.
              <fs_exec>-torstopuuid  = lt_stop[ 1 ]-key.
              <fs_exec>-ext_loc_id   = lt_stop[ 1 ]-log_locid.
              <fs_exec>-ext_loc_uuid = lt_stop[ 1 ]-log_loc_uuid.
            ENDIF.

            APPEND ls_mod TO gt_mod.

          ENDIF.

        ENDIF.

        IF <fs_input>-event_departure IS NOT INITIAL.

          READ TABLE lt_execaux
          WITH KEY event_code  = gc_events-actual_departure
                   actual_date = <fs_input>-event_departure
          BINARY SEARCH TRANSPORTING NO FIELDS.

          IF sy-subrc NE 0.

            CLEAR ls_mod.

            ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
            ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
            ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
            ls_mod-source_key   = <fs_tor>-key.
            ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
            ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

            CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
            ASSIGN ls_mod-data->* TO <fs_exec>.
            <fs_exec>-key = ls_mod-key.

            APPEND INITIAL LINE TO lt_tor_exec_key ASSIGNING <fs_key_exec>.
            <fs_key_exec>-key = <fs_exec>-key.

            <fs_exec>-event_code = gc_events-actual_departure.
            <fs_exec>-actual_date = <fs_input>-event_departure.

            IF lt_stop IS NOT INITIAL.
              <fs_exec>-torstopuuid  = lt_stop[ 1 ]-key.
              <fs_exec>-ext_loc_id   = lt_stop[ 1 ]-log_locid.
              <fs_exec>-ext_loc_uuid = lt_stop[ 1 ]-log_loc_uuid.
            ENDIF.

            APPEND ls_mod TO gt_mod.

          ENDIF.

        ENDIF.

        IF <fs_input>-event_arrival IS NOT INITIAL.

          READ TABLE lt_execaux
          WITH KEY event_code  = gc_events-actual_arrival
                   actual_date = <fs_input>-event_arrival
          BINARY SEARCH TRANSPORTING NO FIELDS.

          IF sy-subrc NE 0.

            CLEAR ls_mod.

            ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
            ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
            ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
            ls_mod-source_key   = <fs_tor>-key.
            ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
            ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

            CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
            ASSIGN ls_mod-data->* TO <fs_exec>.
            <fs_exec>-key = ls_mod-key.

            APPEND INITIAL LINE TO lt_tor_exec_key ASSIGNING <fs_key_exec>.
            <fs_key_exec>-key = <fs_exec>-key.

            <fs_exec>-event_code = gc_events-actual_arrival.
            <fs_exec>-actual_date = <fs_input>-event_arrival.

            IF lt_stop_last IS NOT INITIAL.
              <fs_exec>-torstopuuid  = lt_stop_last[ 1 ]-key.
              <fs_exec>-ext_loc_id   = lt_stop_last[ 1 ]-log_locid.
              <fs_exec>-ext_loc_uuid = lt_stop_last[ 1 ]-log_loc_uuid.
            ENDIF.

            APPEND ls_mod TO gt_mod.

          ENDIF.

        ENDIF.

        IF <fs_input>-event_complete IS NOT INITIAL.

          READ TABLE lt_execaux
          WITH KEY event_code  = gc_events-actual_complete
                   actual_date = <fs_input>-event_complete
          BINARY SEARCH TRANSPORTING NO FIELDS.

          IF sy-subrc NE 0.

            CLEAR ls_mod.

            ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
            ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
            ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
            ls_mod-source_key   = <fs_tor>-key.
            ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
            ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

            CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
            ASSIGN ls_mod-data->* TO <fs_exec>.
            <fs_exec>-key = ls_mod-key.

            APPEND INITIAL LINE TO lt_tor_exec_key ASSIGNING <fs_key_exec>.
            <fs_key_exec>-key = <fs_exec>-key.

            <fs_exec>-event_code = gc_events-actual_complete.
            <fs_exec>-actual_date = <fs_input>-event_complete.

            IF lt_stop_last IS NOT INITIAL.
              <fs_exec>-torstopuuid  = lt_stop_last[ 1 ]-key.
              <fs_exec>-ext_loc_id   = lt_stop_last[ 1 ]-log_locid.
              <fs_exec>-ext_loc_uuid = lt_stop_last[ 1 ]-log_loc_uuid.
            ENDIF.

            APPEND ls_mod TO gt_mod.

          ENDIF.

        ENDIF.

*        IF <fs_input>-bp_chapa = abap_true.
*
*          CLEAR ls_mod.
*
*          ls_mod-node         = /scmtms/if_tor_c=>sc_node-root.
*          ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_update.
*          ls_mod-key          = <fs_tor>-key.
*
*          CREATE DATA ls_mod-data TYPE /scmtms/s_tor_root_k.
*          ASSIGN ls_mod-data->* TO <fs_tor_upd>.
*          <fs_tor_upd>-zzchapa = abap_true.
*          APPEND 'ZZCHAPA' TO ls_mod-changed_fields.
*          APPEND ls_mod TO gt_mod_change.
*
*        ENDIF.

        IF <fs_input>-location1 IS NOT INITIAL.

          CLEAR: lt_FU_key,
                 lt_fu.
          event_location(
                            EXPORTING
                              is_tor      =  <fs_tor>
                              is_of_input = <fs_input>
                              it_key_fu   = lt_fu_key
                          ).
        ENDIF.

      ENDIF.

*      IF me->save( ) EQ abap_false. "salvando as informacoes
      IF me->save( ) EQ abap_true. "salvando as informacoes
        exec_action( it_key = lt_tor_exec_key  ).
      ENDIF.
      me->analyzer_event_stops( <fs_tor> ).

    ENDLOOP."fim do loop das OF

  ENDMETHOD.


  METHOD process_interface.
    DATA: lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_tor_root_key TYPE /bobf/t_frw_key,
          lt_parameters   TYPE /bobf/t_frw_query_selparam,
          lv_torid        TYPE /scmtms/tor_id.

    DATA(lo_param)      = NEW zclca_tabela_parametros( ).
    DATA(lv_automatico) = VALUE abap_bool(  ).

    TRY.
        " Parametro para ligar/desligar Interface
        lo_param->m_get_single( EXPORTING iv_modulo = lc_param-modulo
                                          iv_chave1 = lc_param-chave1
                                          iv_chave2 = lc_param-chave2
                                IMPORTING ev_param  = lv_automatico ).

        CHECK lv_automatico IS INITIAL.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

    gs_input = is_input.
    go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    go_tra_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

*    LOOP AT gs_input-dt_rota_gm-ordem_de_frete ASSIGNING FIELD-SYMBOL(<fs_input>).
*      lv_torid = <fs_input>-tor_id.
*      CONDENSE lv_torid NO-GAPS.
*      SHIFT lv_torid LEFT DELETING LEADING '0'.
*      UNPACK lv_torid TO lv_torid.
*      <fs_input>-tor_id = lv_torid.
*    ENDLOOP.
*    SORT gs_input-dt_rota_gm-ordem_de_frete BY tor_id.

    event_ordem_frete( ).

    IF gt_messages IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcxtm_proc_event_in_greenmile
        EXPORTING
          gt_bapiret2 = gt_messages.


    ENDIF.

  ENDMETHOD.


  METHOD analyzer_event_stops.
    DATA: lt_stop       TYPE /scmtms/t_tor_stop_k,
          lt_key        TYPE /bobf/t_frw_key,
          lt_req_stop   TYPE /scmtms/t_tor_stop_k,
          lt_fu         TYPE /scmtms/t_tor_root_k,
          lt_exec       TYPE /scmtms/t_tor_exec_k,
          lv_qtdtotal   TYPE i,
          lv_qtdtotstop TYPE i,
          lv_qtdsaidcli TYPE i,
          lv_qtdevtot   TYPE i,
          lv_qtdevparc  TYPE i,
          ls_mod        TYPE /bobf/s_frw_modification,
          lt_exec2      TYPE /scmtms/t_tor_exec_k,
          lt_execaux    TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
          lt_execaux_fu TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
          lv_check      TYPE abap_bool.

    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k.


    CONSTANTS: lc_ev_ent_total  TYPE c LENGTH 30 VALUE 'ENTREGA_TOTAL',
               lc_ev_parcent    TYPE c LENGTH 30 VALUE 'PARCIALMENTEENTREGUE',
               lc_ev_tot_entreg TYPE c LENGTH 30 VALUE 'TOTALMENTE_ENTREGUE',
               lc_ev_saidacli   TYPE /scmtms/tor_event    VALUE 'SAIDA_CLIENTE',
               lc_ev_entfim     TYPE /scmtms/tor_event    VALUE 'ENTREGA_FINALIZADA',
               lc_ev_entparc    TYPE /scmtms/tor_event    VALUE 'ENTREGA_PARCIAL'.

    CHECK is_tor-key IS NOT INITIAL.
*    SORT gt_key_stop_analyze BY key.
*
*    lv_check = abap_false.

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_tor-key CHANGING ct_key = lt_key ).

    go_srv_tor->retrieve_by_association(
                                                     EXPORTING
                                                       iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                       it_key                  = lt_key
                                                       iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
                                                       iv_fill_data            = abap_true
                                                     IMPORTING
                                                       et_data                 = lt_exec2
                                                   ).

    lt_execaux = lt_exec2.
    SORT lt_execaux BY event_code.

    go_srv_tor->retrieve_by_association(
                                         EXPORTING
                                           iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                           it_key                  = lt_key
                                           iv_association          = /scmtms/if_tor_c=>sc_association-root-stop
                                           iv_fill_data            = abap_true
                                         IMPORTING
                                           et_data                 = lt_stop
                                       ).

    LOOP AT lt_stop ASSIGNING FIELD-SYMBOL(<fs_stop>) WHERE stop_seq_pos EQ 'I'.
*      lv_qtdtotstop = 0.
*      lv_qtdsaidcli = 0.
*      lv_check = abap_false.
*
*      READ TABLE gt_key_stop_analyze
*      WITH KEY key = <fs_stop>-key
*      BINARY SEARCH TRANSPORTING NO FIELDS.
*      IF sy-subrc = 0.
*        lv_check = abap_true.
*      ENDIF.

      CLEAR lt_key.
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_stop>-key CHANGING ct_key = lt_key ).

      go_srv_tor->retrieve_by_association(
                                        EXPORTING
                                          iv_node_key             = /scmtms/if_tor_c=>sc_node-stop
                                          it_key                  = lt_key
                                          iv_association          = /scmtms/if_tor_c=>sc_association-stop-assigned_req_stops
                                          iv_fill_data            = abap_true
                                        IMPORTING
                                          et_data                 = lt_req_stop
                                      ).
      CLEAR : lt_key,
              lt_fu.

      LOOP AT lt_req_stop ASSIGNING FIELD-SYMBOL(<fs_req_stop>).
        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_req_stop>-parent_key CHANGING ct_key = lt_key ).
      ENDLOOP.

      CHECK lt_key IS NOT INITIAL.

      go_srv_tor->query(
                          EXPORTING
                            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                            it_filter_key           = lt_key
                            iv_fill_data            = abap_true
                          IMPORTING
                            et_data                 =  lt_fu
                        ).

*      LOOP AT lt_fu ASSIGNING FIELD-SYMBOL(<fs_fu>).

      CLEAR : lt_key,
              lt_exec,
              lt_execaux_fu.

*        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_fu>-key CHANGING ct_key = lt_key ).

      lt_key = VALUE #( FOR <fs_fu> IN lt_fu
                      ( key = <fs_fu>-key ) ).

      go_srv_tor->retrieve_by_association(
                                             EXPORTING
                                               iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                               it_key                  = lt_key
                                               iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
                                               iv_fill_data            = abap_true
                                             IMPORTING
                                               et_data                 = lt_exec
                                           ).

*        LOOP AT lt_exec ASSIGNING FIELD-SYMBOL(<fs_exec_fu>).
*          lv_qtdtotal = lv_qtdtotal + 1.
*
*          IF <fs_exec_fu>-event_code = lc_ev_ent_total OR
*             <fs_exec_fu>-event_code = gc_events-coleta.
*            lv_qtdevtot = lv_qtdevtot + 1.
*          ENDIF.
*
**          IF <fs_exec_fu>-event_code = lc_ev_parcent.
*          IF <fs_exec_fu>-event_code = gc_events-entrega_parcial.
*            lv_qtdevparc = lv_qtdevparc + 1.
*          ENDIF.
*          IF lv_check = abap_true.
*            lv_qtdtotstop = lv_qtdtotstop + 1.
**            IF <fs_exec_fu>-event_code =  lc_ev_saidacli.
*            IF <fs_exec_fu>-event_code =  gc_events-actual_departure_stop.
*              lv_qtdsaidcli = lv_qtdsaidcli + 1.
*            ENDIF.
*          ENDIF.
*
*        ENDLOOP.
*      ENDLOOP.

*      IF lv_check = abap_true.

      lt_execaux_fu[] = lt_exec[].

      CLEAR ls_mod.

      ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
      ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
      ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
      ls_mod-source_key   = is_tor-key. "<fs_stop>-key.
      ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
      ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

      CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
      ASSIGN ls_mod-data->* TO <fs_exec>.
      <fs_exec>-key = ls_mod-key.
      <fs_exec>-torstopuuid  = <fs_stop>-key.
      <fs_exec>-ext_loc_id   = <fs_stop>-log_locid.
      <fs_exec>-ext_loc_uuid = <fs_stop>-log_loc_uuid.

      IF line_exists( lt_execaux_fu[ event_code = gc_events-actual_departure_stop ] ).
        SORT lt_execaux_fu BY event_code actual_date DESCENDING.
        <fs_exec>-actual_date = lt_execaux_fu[ event_code = gc_events-actual_departure_stop ]-actual_date.
        DELETE lt_exec WHERE event_code EQ gc_events-actual_arrival_stop   OR
                     event_code EQ gc_events-actual_service        OR
                     event_code EQ gc_events-actual_departure_stop OR
                     event_code EQ gc_events-voltar_depois         OR
                     event_code EQ gc_events-hassignature          .

        IF lt_exec[] IS INITIAL.
          CONTINUE.
        ENDIF.

        IF line_exists( lt_exec[ event_code = gc_events-entrega_parcial ] ).
          <fs_exec>-event_code  = gc_events-entrega_parcial.
        ELSEIF line_exists( lt_exec[ event_code = gc_events-devolvido ] ).
          DELETE lt_exec WHERE event_code EQ gc_events-devolvido.
          IF lt_exec[] IS INITIAL.
            <fs_exec>-event_code  = gc_events-devolvido.
          ELSE.
            <fs_exec>-event_code  = gc_events-entrega_parcial.
          ENDIF.
        ELSE.
          <fs_exec>-event_code = gc_events-entrega_total.
        ENDIF.
      ENDIF.



      READ TABLE lt_execaux
        WITH KEY event_code  = <fs_exec>-event_code
                 ext_loc_id  = <fs_exec>-ext_loc_id
                 actual_date = <fs_exec>-actual_date
        TRANSPORTING NO FIELDS.

      IF sy-subrc IS INITIAL.
        CONTINUE.
      ENDIF.

      IF ls_mod IS NOT INITIAL AND <fs_exec>-event_code IS NOT INITIAL..
        APPEND ls_mod TO gt_mod.
      ENDIF.

    ENDLOOP.
*        IF lv_qtdtotstop = lv_qtdsaidcli AND lv_qtdtotstop > 0.
*
*          READ TABLE lt_execaux
*          WITH KEY event_code = lc_ev_entfim
*          BINARY SEARCH TRANSPORTING NO FIELDS.
*
*          IF sy-subrc NE 0.
*            <fs_exec>-event_code  = lc_ev_entfim.
*          ELSE.
*            CLEAR ls_mod.
*          ENDIF.
*        ELSE.
*          READ TABLE lt_execaux
*         WITH KEY event_code = lc_ev_entparc
*         BINARY SEARCH TRANSPORTING NO FIELDS.
*
*          IF sy-subrc NE 0.
*            <fs_exec>-event_code  = lc_ev_entparc.
*          ELSE.
*            CLEAR ls_mod.
*          ENDIF.
*        ENDIF.

*      IF ls_mod IS NOT INITIAL.
*        APPEND ls_mod TO gt_mod.
*      ENDIF.

*      ENDIF.

*    ENDLOOP.

*    IF lv_qtdevparc > 0 AND lv_qtdevparc EQ lv_qtdtotal.
*
*      READ TABLE lt_execaux
*      WITH KEY event_code = lc_ev_parcent
*      BINARY SEARCH TRANSPORTING NO FIELDS.
*
*      IF sy-subrc NE 0.
*        ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*        ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*        ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*        ls_mod-source_key   = is_tor-key.
*        ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*        ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*        CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*        ASSIGN ls_mod-data->* TO <fs_exec>.
*        <fs_exec>-key = ls_mod-key.
*        <fs_exec>-event_code  = lc_ev_parcent.
*
*        APPEND ls_mod TO gt_mod.
*      ENDIF.
*
*    ELSEIF lv_qtdevtot > 0 AND lv_qtdevtot EQ lv_qtdtotal.
*
*      READ TABLE lt_execaux
*    WITH KEY event_code = lc_ev_tot_entreg
*    BINARY SEARCH TRANSPORTING NO FIELDS.
*
*      IF sy-subrc NE 0.
*
*        ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*        ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*        ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*        ls_mod-source_key   = is_tor-key.
*        ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*        ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*        CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*        ASSIGN ls_mod-data->* TO <fs_exec>.
*        <fs_exec>-key = ls_mod-key.
*        <fs_exec>-event_code  = lc_ev_tot_entreg.
*
*        APPEND ls_mod TO gt_mod.
*      ENDIF.
*    ENDIF.

    save( ).

  ENDMETHOD.


  METHOD exec_action.

    DATA: lo_change            TYPE REF TO /bobf/if_tra_change,
          lo_message           TYPE REF TO /bobf/if_frw_message,
          lt_return            TYPE bapiret2_tab,
          lv_rejected          TYPE boole_d,
          lo_message_save      TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key  TYPE /bobf/t_frw_key2,
          lo_change_action     TYPE REF TO /bobf/if_tra_change,
          lo_message_action    TYPE REF TO /bobf/if_frw_message,
          lt_failed_key        TYPE /bobf/t_frw_key,
          lt_failed_action_key TYPE /bobf/t_frw_key.

    go_srv_tor->do_action(
                                   EXPORTING
                                     iv_act_key              =  /scmtms/if_tor_c=>sc_action-executioninformation-revoke_event
                                     it_key                  =  it_key "lt_tor_exec_key
                                   IMPORTING
                                     eo_change               = lo_change_action
                                     eo_message              = lo_message_action
                                     et_failed_key           = lt_failed_action_key
                                     et_failed_action_key    = lt_failed_key
                                 ).

    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                           EXPORTING
                                                            iv_action_messages = space
                                                            io_message  = lo_message_action
                                                           CHANGING
                                                            ct_bapiret2 = lt_return
                                                          ).

    IF lt_return IS NOT INITIAL.
      APPEND LINES OF lt_return TO gt_messages.
    ENDIF.

  ENDMETHOD.


  METHOD fill_text_collection.

    DATA: ls_execnote      TYPE /bobf/s_txc_root_k,
          ls_text          TYPE /bobf/s_txc_txt_k,
          lt_text          TYPE /bobf/t_txc_txt_k,
          ls_text_CONT     TYPE /bobf/s_txc_con_k,
          lv_key_note      TYPE /bobf/conf_key,
          lv_key_text_cont TYPE /bobf/conf_key,
          lv_key_text      TYPE /bobf/conf_key,
          lo_bo_conf       TYPE REF TO /bobf/if_frw_configuration,
          ls_mod           TYPE /bobf/s_frw_modification.

    FIELD-SYMBOLS: <fs_text>    TYPE /bobf/s_txc_txt_k,
                   <fs_txtcont> TYPE /bobf/s_txc_con_k.

*-- Configuration Reference
*--Export the Business Object Key of the Node

    lo_bo_conf  = /bobf/cl_frw_factory=>get_configuration( iv_bo_key  = /scmtms/if_tor_c=>sc_bo_key ).

    lv_key_note = /bobf/cl_frw_factory=>get_new_key( ).

    "Adicionando no EXECUTIONNOTES
*    lt_execnote = VALUE #( ( text_schema_id = 'TOREM' ) ).

    ls_execnote-text_schema_id = 'TOREM'.
    ls_execnote-key            = lv_key_note.
    ls_execnote-parent_key     = iv_key_event.
    ls_execnote-root_key       = iv_root_key.
    /scmtms/cl_mod_helper=>mod_create_single(
                                                  EXPORTING
                                                    is_data        = ls_execnote
                                                    iv_key         = lv_key_note
                                                    iv_parent_key  = iv_key_event
                                                    iv_root_key    = iv_root_key
                                                    iv_node        = /scmtms/if_tor_c=>sc_node-executionnotes
                                                    iv_source_node = /scmtms/if_tor_c=>sc_node-executioninformation
                                                    iv_association = /scmtms/if_tor_c=>sc_association-executioninformation-executionnotes
                                                  CHANGING
                                                    ct_mod         =  gt_mod
                                                ).
*-- Node Key of TEXT node
    DATA(lv_txt_key) = lo_bo_conf->get_content_key_mapping(
                                                            iv_content_cat      = /bobf/if_conf_c=>sc_content_nod
                                                            iv_do_content_key   = /bobf/if_txc_c=>sc_node-text
                                                            iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-executionnotes ).


    DATA(lv_cont_key) = lo_bo_conf->get_content_key_mapping(
                                                            iv_content_cat      = /bobf/if_conf_c=>sc_content_nod
                                                            iv_do_content_key   = /bobf/if_txc_c=>sc_node-text_content
                                                            iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-executionnotes ).

*-- Association Key of ROOT->TEXT
    DATA(lv_txt_assoc) = lo_bo_conf->get_content_key_mapping(
                                                               iv_content_cat      = /bobf/if_conf_c=>sc_content_ass
                                                               iv_do_content_key   = /bobf/if_txc_c=>sc_association-root-text
                                                               iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-executionnotes ).


*-- Association Key of TEXT->TEXT_CONTENT
    DATA(lv_cont_assoc) = lo_bo_conf->get_content_key_mapping(
                                                               iv_content_cat      = /bobf/if_conf_c=>sc_content_ass
                                                               iv_do_content_key   = /bobf/if_txc_c=>sc_association-text-text_content
                                                               iv_do_root_node_key = /scmtms/if_tor_c=>sc_node-executionnotes
                                                              ).

    lv_key_text = /bobf/cl_frw_factory=>get_new_key( ).

*-- Details of Dependent Object TEXT Node

    ls_mod-key          = lv_key_text. "ls_text-key.
    ls_mod-source_key   = lv_key_note.
    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-executionnotes. "/cpd/if_pfp_bo_plan_hdr_c=>sc_node-plan_header_long_text.
    ls_mod-root_key     = iv_root_key.
    ls_mod-node         = lv_txt_key.	" text Node Key
    ls_mod-association  = lv_txt_assoc.	" root -> text Node Association
    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*    ls_mod-data         = lt_text.
    CREATE DATA ls_mod-data TYPE /bobf/s_txc_txt_k.
*    ls_mod-data = ls_text.
    ASSIGN ls_mod-data->* TO <fs_text>.
    IF sy-subrc = 0.
      <fs_text>-key           = lv_key_text. "/bobf/cl_frw_factory=>get_new_key( ).
      <fs_text>-root_key      = iv_root_key.
      <fs_text>-parent_key    = lv_key_note.
      <fs_text>-user_id_ch    = sy-uname.
      <fs_text>-language_code = 'PT'.
      <fs_text>-text_type     = 'TOREM'.
      <fs_text>-datetime_ch   = sy-datum.
      <fs_text>-datetime_cr   = sy-datum.
    ENDIF.

    APPEND ls_mod TO gt_mod.
    LOOP AT it_texto ASSIGNING FIELD-SYMBOL(<fs_texto>).
      CLEAR :ls_text_cont,
            ls_mod.
      lv_key_text_cont = /bobf/cl_frw_factory=>get_new_key( ).

      ls_mod-key          = lv_key_text_cont.
      ls_mod-root_key     = iv_root_key.
      ls_mod-source_key   = lv_key_text.

      ls_mod-node         = lv_cont_key. "/bobf/if_txc_c=>sc_node-text_content. "lv_cont_key.  " TEXT_CONTENT Node Key
      ls_mod-source_node  = lv_txt_key.
      ls_mod-association  = lv_cont_assoc.  " text –> text_content Association
      ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.


      CREATE DATA ls_mod-data TYPE /bobf/s_txc_con_k.
      ASSIGN ls_mod-data->* TO <fs_txtcont>.

      <fs_txtcont>-key         = lv_key_text_cont.
      <fs_txtcont>-parent_key  = lv_key_text.
      <fs_txtcont>-root_key    = iv_root_key.
      <fs_txtcont>-text        = <fs_texto>-texto.
      APPEND ls_mod TO gt_mod.
    ENDLOOP.


  ENDMETHOD.


  METHOD save.

    DATA: lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          lt_return           TYPE bapiret2_tab,
          lv_rejected         TYPE boole_d,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

    IF gt_mod_change IS NOT INITIAL.
      go_srv_tor->modify( EXPORTING it_modification = gt_mod_change
                          IMPORTING eo_change  = lo_change
                                    eo_message = lo_message ).

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                               EXPORTING
                                                                iv_action_messages = space
                                                                io_message  = lo_message
                                                               CHANGING
                                                                ct_bapiret2 = lt_return
                                                              ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.
      CLEAR lt_return.
      CLEAR gt_mod_change.
    ENDIF.

    IF gt_mod IS NOT INITIAL.


      go_srv_tor->modify( EXPORTING it_modification = gt_mod
                          IMPORTING eo_change  = lo_change
                                    eo_message = lo_message ).

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                               EXPORTING
*                                                                iv_action_messages = space
                                                                io_message  = lo_message
                                                               CHANGING
                                                                ct_bapiret2 = lt_return
                                                              ).
      IF lt_return IS INITIAL.

        go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                          IMPORTING ev_rejected            = lv_rejected
                                    eo_change              = lo_change
                                    eo_message             = lo_message_save
                                    et_rejecting_bo_key    = ls_rejecting_bo_key ).

        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                               EXPORTING
*                                                                iv_action_messages = space
                                                                io_message  = lo_message_save
                                                               CHANGING
                                                                ct_bapiret2 = lt_return
                                                              ).
        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO gt_messages.
        ENDIF.
        SORT lt_return BY type.
        READ TABLE lt_return
        WITH KEY type = 'E'
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
*          go_srv_tor->do_action(
*                                   EXPORTING
*                                     iv_act_key              =  /scmtms/if_tor_c=>sc_action-executioninformation-revoke_event
*                                     it_key                  =   lt_tor_exec_key
*                                   IMPORTING
*                                     eo_change               = lo_change_action
*                                     eo_message              = lo_message_action
*                                     et_failed_key           = lt_failed_action_key
*                                     et_failed_action_key    = lt_failed_key
*                                 ).
*
*          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
*                                                                 EXPORTING
*                                                                  iv_action_messages = space
*                                                                  io_message  = lo_message_action
*                                                                 CHANGING
*                                                                  ct_bapiret2 = lt_return
*                                                                ).

*          IF lt_return IS NOT INITIAL.
*            APPEND LINES OF lt_return TO gt_messages.
*          ENDIF.
        ELSE.
          rv_erro = abap_true.
        ENDIF.

*        ELSE.
*          APPEND LINES OF lt_return TO gt_messages.
*        ENDIF.
      ELSE.
        rv_erro = abap_true.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.
      CLEAR gt_mod.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
