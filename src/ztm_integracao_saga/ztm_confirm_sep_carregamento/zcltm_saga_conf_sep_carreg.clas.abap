"!<p><h2>Recebe dados do saga para criar evento dentro do TM </h2></p>
"!<p><strong>Autor: </strong>Eliabe Lima</p>
"!<p><strong>Data: </strong>07/03/2022</p>
CLASS zcltm_saga_conf_sep_carreg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_lifsk_46_separa_carrega TYPE likp-lifsk VALUE '46' ##NO_TEXT.
    CONSTANTS gc_cdsit_emexecucao TYPE char1 VALUE '1' ##NO_TEXT.
    CONSTANTS gc_torcat_to TYPE /scmtms/tor_category VALUE 'TO' ##NO_TEXT.
    CONSTANTS gc_sign_i TYPE char1 VALUE 'I' ##NO_TEXT.
    CONSTANTS gc_option_eq TYPE char2 VALUE 'EQ' ##NO_TEXT.
    CONSTANTS gc_sep_split TYPE char1 VALUE '_' ##NO_TEXT.
    CONSTANTS gc_itmtype_truc TYPE /scmtms/tor_item_type VALUE 'TRUC' ##NO_TEXT.
    CONSTANTS gc_itmtype_trl TYPE /scmtms/tor_item_type VALUE 'TRL' ##NO_TEXT.
    CONSTANTS gc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR' ##NO_TEXT.
    CONSTANTS gc_itemcat_pvr TYPE /scmtms/item_category VALUE 'PVR' ##NO_TEXT.

    METHODS process_interface
      IMPORTING
        !is_input TYPE zmt_confirma_separacao_carrega
      RAISING
        zcxtm_saga_conf_sep_carreg .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_cdsit_fechada TYPE char1 VALUE '2' ##NO_TEXT.
    DATA go_tra_mgr TYPE REF TO /bobf/if_tra_transaction_mgr .
    DATA go_srv_tor TYPE REF TO /bobf/if_tra_service_manager .
    DATA gt_mod TYPE /bobf/t_frw_modification .
    DATA gt_messages TYPE bapiret2_tab .
    DATA:
      gt_platenumber TYPE STANDARD TABLE OF /scmtms/resplatenr .

    METHODS frota_propria
      RETURNING
        VALUE(rv_frota) TYPE abap_bool .
    METHODS unlock_delivery
      IMPORTING
        !iv_delivery TYPE vbeln_vl .
    METHODS lock_delivery
      IMPORTING
        !iv_delivery TYPE vbeln_vl
        !iv_lifsk    TYPE likp-lifsk .
    METHODS create_event
      IMPORTING
        !is_tor    TYPE /scmtms/s_tor_root_k
        !iv_evento TYPE /scmtms/tor_event
        !is_stop   TYPE /scmtms/s_tor_stop_k .
    METHODS create_event_n
      IMPORTING
        !is_tor    TYPE /scmtms/s_tor_root_k
        !iv_evento TYPE /scmtms/tor_event
        !is_stop   TYPE /scmtms/s_tor_stop_k .
    METHODS save .
    METHODS clear_itmtr
      IMPORTING
        !it_itemtr TYPE /scmtms/t_tor_item_tr_k .
    METHODS upd_data_root
      IMPORTING
        !iv_key         TYPE /bobf/conf_key
        !iv_motorista   TYPE ze_motorista
        !iv_agent_frete TYPE /scmtms/pty_carrier .
    METHODS add_vehicle
      IMPORTING
        !iv_tures_tco TYPE /scmtms/equip_type
        !iv_itmstart  TYPE int1
        !iv_key       TYPE /bobf/conf_key .
    METHODS upd_vehicle
      IMPORTING
        !it_itemtr    TYPE /scmtms/t_tor_item_tr_k
        !iv_clear     TYPE flag OPTIONAL
        !iv_tures_tco TYPE /scmtms/equip_type OPTIONAL
        !iv_itmstart  TYPE int8 OPTIONAL
        !iv_key       TYPE /bobf/conf_key OPTIONAL .
ENDCLASS.



CLASS ZCLTM_SAGA_CONF_SEP_CARREG IMPLEMENTATION.


  METHOD create_event.

    DATA: ls_mod      TYPE /bobf/s_frw_modification.

    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k.

    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
    ls_mod-source_key   = is_tor-key.
    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
    ASSIGN ls_mod-data->* TO <fs_exec>.

    <fs_exec>-key          = ls_mod-key.
    <fs_exec>-event_code   = iv_evento.
    <fs_exec>-torstopuuid  = is_stop-key.
    <fs_exec>-ext_loc_id   = is_stop-log_locid.
    <fs_exec>-ext_loc_uuid = is_stop-log_loc_uuid.

    APPEND ls_mod TO gt_mod.

  ENDMETHOD.


  METHOD frota_propria.

    rv_frota = abap_false.


  ENDMETHOD.


  METHOD process_interface.

    TYPES: BEGIN OF ty_remessa,
             delivery TYPE vbeln_vl,
           END OF ty_remessa.

    DATA: lt_parameters   TYPE /bobf/t_frw_query_selparam,
          lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_torfu        TYPE /scmtms/t_tor_root_k,
          lt_key          TYPE /bobf/t_frw_key,
          lt_stop         TYPE /scmtms/t_tor_stop_k,
          lv_transp3c     TYPE abap_bool,
          lt_itmtr        TYPE /scmtms/t_tor_item_tr_k,
          lt_tor_exec     TYPE /scmtms/t_tor_exec_k,
          lv_equnr        TYPE equnr,
          lv_nitem        TYPE int8,
          lv_upd_delivery TYPE abap_bool,
          lt_remessa      TYPE STANDARD TABLE OF ty_remessa.

    CONSTANTS: lc_enveto     TYPE /scmtms/tor_event VALUE 'EM SEPARAÇÃO',
               lc_enveto_end TYPE /scmtms/tor_event VALUE 'FIM DO CARREGAMENTO',
               lc_tpremessa  TYPE /scmtms/base_btd_tco VALUE '73'.

    IF is_input-mt_confirma_separacao_carregam-evento = gc_cdsit_emexecucao
       OR is_input-mt_confirma_separacao_carregam-evento = gc_cdsit_fechada.

      IF is_input-mt_confirma_separacao_carregam-tsp IS NOT INITIAL.
        SELECT COUNT(*) FROM but000
          WHERE partner = @is_input-mt_confirma_separacao_carregam-tsp
            AND XDELE = @abap_false
            AND xblck = @abap_false.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcxtm_saga_conf_sep_carreg ##STMNT_EXIT
            EXPORTING
              textid   = zcxtm_saga_conf_sep_carreg=>tsp_invalido
              gv_msgv1 = CONV msgv1( is_input-mt_confirma_separacao_carregam-tsp ).
          RETURN.
        ENDIF.
      ENDIF.


      go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
      go_tra_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

      APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
      <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
      <fs_parameters>-sign   = gc_sign_i.
      <fs_parameters>-option = gc_option_eq.
      <fs_parameters>-low    = is_input-mt_confirma_separacao_carregam-tor_id.

      APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameters>.
      <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_cat.
      <fs_parameters>-sign   = gc_sign_i.
      <fs_parameters>-option = gc_option_eq.
      <fs_parameters>-low    = gc_torcat_to.

      go_srv_tor->query(
                       EXPORTING
                         iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                         it_selection_parameters = lt_parameters
                         iv_fill_data            = abap_true
                       IMPORTING
                         et_key                  = lt_key
                         et_data                 = lt_tor
                    ).

      lv_transp3c = abap_true.

      IF is_input-mt_confirma_separacao_carregam-platnumber IS NOT INITIAL.
        "transportadora terceirizada não vem informação de placa
        lv_transp3c = abap_false.

        "CAVALO_CARRETA_CARRETA, conforme EF
        SPLIT is_input-mt_confirma_separacao_carregam-platnumber AT gc_sep_split INTO TABLE gt_platenumber.

        IF gt_platenumber IS NOT  INITIAL.
          lv_equnr = gt_platenumber[ 1 ].
          SELECT
            SINGLE
            equipment
          FROM i_equipmentdata
          WHERE
            equipment EQ @lv_equnr
          INTO @DATA(lv_auxequnr).

          "se placa enviada tiver dentro da tabela de equipamento , considerar como transportadora própria
          IF sy-subrc = 0.
            lv_transp3c = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lt_tor IS NOT INITIAL.

        LOOP AT lt_tor ASSIGNING FIELD-SYMBOL(<fs_tor>).
          CLEAR: lt_key,
                 lt_stop,
                 lt_itmtr,
                 lt_torfu,
                 lt_tor_exec.

          /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor>-key CHANGING ct_key = lt_key ).

          go_srv_tor->retrieve_by_association(
                                                EXPORTING
                                                  iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                  it_key                  = lt_key
                                                  iv_association          = /scmtms/if_tor_c=>sc_association-root-assigned_fus
                                                  iv_fill_data            = abap_true
                                                IMPORTING
                                                  et_data                 = lt_torfu
                                              ).

          go_srv_tor->retrieve_by_association(
                                                 EXPORTING
                                                   iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                   it_key                  = lt_key
                                                   iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                   iv_fill_data            = abap_true
                                                 IMPORTING
                                                   et_data                 = lt_itmtr
                                               ).

          go_srv_tor->retrieve_by_association(
                                                 EXPORTING
                                                   iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                   it_key                  = lt_key
                                                   iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
                                                   iv_fill_data            = abap_true
                                                 IMPORTING
                                                   et_data                 = lt_tor_exec
                                               ).

          IF is_input-mt_confirma_separacao_carregam-evento = gc_cdsit_emexecucao.


            go_srv_tor->retrieve_by_association(
                                                   EXPORTING
                                                     iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                     it_key                  = lt_key
                                                     iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first
                                                     iv_fill_data            = abap_true
                                                   IMPORTING
                                                     et_data                 = lt_stop
                                                 ).
            IF lt_stop IS NOT INITIAL.
              IF NOT line_exists( lt_tor_exec[ event_code = lc_enveto ] ).
                create_event_n(
                              EXPORTING
                                is_tor    = <fs_tor>
                                iv_evento = lc_enveto
                                is_stop   = lt_stop[ 1 ]
                            ).
                save( ).
              ENDIF.
            ENDIF.
            lv_upd_delivery = abap_true.
          ELSEIF is_input-mt_confirma_separacao_carregam-evento = gc_cdsit_fechada.

            go_srv_tor->retrieve_by_association(
                                                   EXPORTING
                                                     iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                     it_key                  = lt_key
                                                     iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first
                                                     iv_fill_data            = abap_true
                                                   IMPORTING
                                                     et_data                 = lt_stop
                                                 ).
            IF lt_stop IS NOT INITIAL.
              IF NOT line_exists( lt_tor_exec[ event_code = lc_enveto_end ] ).
                create_event_n(
                              EXPORTING
                                is_tor    = <fs_tor>
                                iv_evento = lc_enveto_end
                                is_stop   = lt_stop[ 1 ]
                            ).
                save( ).
              ENDIF.
            ENDIF.


            IF lt_itmtr IS NOT INITIAL AND lv_transp3c EQ abap_false.
*              clear_itmtr( it_itemtr = lt_itmtr ).
              upd_vehicle( it_itemtr = lt_itmtr iv_clear = abap_true ).
            ELSEIF gt_platenumber IS NOT INITIAL.

              IF lt_itmtr IS INITIAL.
                lv_nitem = 10.
              ELSE.
                lv_nitem = lines( lt_itmtr ) * 10.
              ENDIF.

              upd_vehicle( it_itemtr = lt_itmtr
                           iv_clear = abap_false
                           iv_tures_tco = CONV /scmtms/equip_type( is_input-mt_confirma_separacao_carregam-tures_tco )
                           iv_itmstart = lv_nitem
                           iv_key = <fs_tor>-key
                          ).

*              add_vehicle( iv_tures_tco = CONV /scmtms/equip_type( is_input-mt_confirma_separacao_carregam-tures_tco )
*                           iv_itmstart = lv_nitem
*                           iv_key = <fs_tor>-key
*                         ).
            ENDIF.

            upd_data_root(
                            EXPORTING
                              iv_key         =  <fs_tor>-key
                              iv_motorista   = CONV ze_motorista( is_input-mt_confirma_separacao_carregam-partner )
                              iv_agent_frete = CONV /scmtms/pty_carrier( is_input-mt_confirma_separacao_carregam-tsp )
                          ).

*            unlock_delivery( iv_delivery = CONV vbeln_vl( is_input-mt_confirma_separacao_carregam-btd_btd_id ) ).
            lv_upd_delivery = abap_true.
            IF gt_messages IS NOT INITIAL.
              CLEAR: gt_mod.
              EXIT.
            ENDIF.
          ENDIF.

          IF lv_upd_delivery = abap_true.
            LOOP AT lt_torfu ASSIGNING FIELD-SYMBOL(<fs_fu>).
              IF <fs_fu>-base_btd_tco EQ lc_tpremessa.
                APPEND INITIAL LINE TO lt_remessa ASSIGNING FIELD-SYMBOL(<fs_remessa>).
                DATA(lv_btd_id) = <fs_fu>-base_btd_id.
                SHIFT lv_btd_id LEFT DELETING LEADING '0'.
                <fs_remessa>-delivery = lv_btd_id.
                UNPACK <fs_remessa>-delivery TO <fs_remessa>-delivery.
              ENDIF.
            ENDLOOP.
          ENDIF.

*          IF is_input-mt_confirma_separacao_carregam-btd_btd_id IS NOT INITIAL.
*
*            APPEND INITIAL LINE TO lt_remessa ASSIGNING FIELD-SYMBOL(<fs_remessa>).
*            DATA(lv_btd_id) = is_input-mt_confirma_separacao_carregam-btd_btd_id.
*            SHIFT lv_btd_id LEFT DELETING LEADING '0'.
*            <fs_remessa>-delivery = lv_btd_id.
*            UNPACK <fs_remessa>-delivery TO <fs_remessa>-delivery.
*
*          ENDIF.
        ENDLOOP.

        save( ).

* BEGIN OF INSERT - JWSILVA - 02.03.2023
        SORT lt_remessa BY delivery.
* END OF INSERT - JWSILVA - 02.03.2023

        IF lt_remessa IS NOT INITIAL.

* BEGIN OF DELETE - JWSILVA - 02.03.2023
*          SELECT vbeln,
*                 lifsk
*            FROM likp
*            INTO TABLE @DATA(lt_likp)
*            FOR ALL ENTRIES IN @lt_remessa
*           WHERE vbeln EQ @lt_remessa-delivery.
* END OF DELETE - JWSILVA - 02.03.2023

          LOOP AT lt_remessa ASSIGNING <fs_remessa>.

            IF is_input-mt_confirma_separacao_carregam-evento = gc_cdsit_emexecucao.

* BEGIN OF DELETE - JWSILVA - 02.03.2023
*              IF line_exists( lt_likp[ vbeln = <fs_remessa>-delivery lifsk = gc_lifsk_46_separa_carrega ] ). "#EC CI_STDSEQ
*                CONTINUE.
*              ENDIF.
* END OF DELETE - JWSILVA - 02.03.2023

              me->lock_delivery( iv_delivery = <fs_remessa>-delivery
                                 iv_lifsk    = gc_lifsk_46_separa_carrega ).
            ELSE.

* BEGIN OF DELETE - JWSILVA - 02.03.2023
*              IF line_exists( lt_likp[ vbeln = <fs_remessa>-delivery lifsk = '' ] ). "#EC CI_STDSEQ
*                CONTINUE.
*              ENDIF.
* END OF DELETE - JWSILVA - 02.03.2023

              me->unlock_delivery( iv_delivery = <fs_remessa>-delivery  ).
            ENDIF.
          ENDLOOP.
        ENDIF.

        IF gt_messages IS NOT INITIAL.
          RAISE EXCEPTION TYPE zcxtm_saga_conf_sep_carreg
            EXPORTING
              gt_bapiret2 = gt_messages.
        ENDIF.

      ELSE.
        RAISE EXCEPTION TYPE zcxtm_saga_conf_sep_carreg
          EXPORTING
            textid   = zcxtm_saga_conf_sep_carreg=>tor_id_invalido
            gv_msgv1 = CONV msgv1( is_input-mt_confirma_separacao_carregam-tor_id )
            gv_msgv2 = CONV msgv2( gc_torcat_to ).
      ENDIF.

    ELSE.
      RAISE EXCEPTION TYPE zcxtm_saga_conf_sep_carreg
        EXPORTING
          textid = zcxtm_saga_conf_sep_carreg=>cod_situacao_nao_prevista.
    ENDIF.

  ENDMETHOD.


  METHOD save.
    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.

    DATA: lo_change_action    TYPE REF TO /bobf/if_tra_change,
          lo_message_action   TYPE REF TO /bobf/if_frw_message,
          lt_failed_key       TYPE /bobf/t_frw_key,
          lt_return           TYPE bapiret2_tab,
          lv_rejected         TYPE boole_d,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2,
          ls_msg              TYPE ty_msg.

    IF gt_mod IS NOT INITIAL.

      go_srv_tor->modify( EXPORTING it_modification = gt_mod
                         IMPORTING eo_change        = lo_change
                                   eo_message       = lo_message ).

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                              EXPORTING
                                                               iv_action_messages = space
                                                               io_message         = lo_message
                                                              CHANGING
                                                               ct_bapiret2 = lt_return
                                                             ).

      lo_message->get_messages(
        IMPORTING
          et_message              = DATA(lt_message)
      ).

      LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<fs_msg>).
*        DATA(lv_msg_txt) = <fs_msg>-message->get_text( ).
        ls_msg = <fs_msg>-message->get_text( ).
        APPEND LINES OF  NEW zcxtm_saga_conf_sep_carreg(
                                                           textid      = zcxtm_saga_conf_sep_carreg=>zcxtm_saga_conf_sep_carreg
                                                           gv_msgv1    = ls_msg-msgv1
                                                           gv_msgv2    = ls_msg-msgv2
                                                           gv_msgv3    = ls_msg-msgv3
                                                           gv_msgv4    = ls_msg-msgv4
                                                         )->get_bapiretreturn( ) TO lt_return.
      ENDLOOP.

      IF lt_return IS INITIAL.

        go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                          IMPORTING ev_rejected            = lv_rejected
                                    eo_change              = lo_change
                                    eo_message             = lo_message_save
                                    et_rejecting_bo_key    = ls_rejecting_bo_key ).

        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                               EXPORTING
                                                                iv_action_messages = space
                                                                io_message         = lo_message
                                                               CHANGING
                                                                ct_bapiret2 = lt_return
                                                              ).

        lo_message->get_messages(
                                 IMPORTING
                                   et_message              = lt_message
                                 ).

        LOOP AT lt_message ASSIGNING <fs_msg>.
*          lv_msg_txt = <fs_msg>-message->get_text( ).
          ls_msg = <fs_msg>-message->get_text( ).
          APPEND LINES OF  NEW zcxtm_saga_conf_sep_carreg(
                                                             textid      = zcxtm_saga_conf_sep_carreg=>zcxtm_saga_conf_sep_carreg
                                                             gv_msgv1    = ls_msg-msgv1
                                                             gv_msgv2    = ls_msg-msgv2
                                                             gv_msgv3    = ls_msg-msgv3
                                                             gv_msgv4    = ls_msg-msgv4
                                                           )->get_bapiretreturn( ) TO lt_return.
        ENDLOOP.

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO gt_messages.
        ENDIF.

      ELSE.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.

    ENDIF.

    CLEAR gt_mod.

  ENDMETHOD.


  METHOD unlock_delivery.

    DATA: Ls_header_data    TYPE bapiobdlvhdrchg,
          ls_header_control TYPE bapiobdlvhdrctrlchg,
          lt_return         TYPE STANDARD TABLE OF bapiret2,
          lv_vbeln          TYPE vbeln_vl.

    CONSTANTS: lc_type_E TYPE bapi_mtype VALUE 'E'.
    lv_vbeln = iv_delivery.
    UNPACK lv_vbeln TO lv_vbeln.

* BEGIN OF INSERT - JWSILVA - 02.03.2023
    " Verifica se a remessa já foi atualizado com o status desejado.
    SELECT SINGLE vbeln, lifsk
      FROM likp
      INTO @DATA(ls_likp)
      WHERE vbeln EQ @iv_delivery.

    IF ls_likp-lifsk = space.
      RETURN.
    ENDIF.
* END OF INSERT - JWSILVA - 02.03.2023

    ls_header_data-deliv_numb = lv_vbeln.
    ls_header_data-dlv_block = space.

    ls_header_control-deliv_numb = lv_vbeln.
    ls_header_control-dlv_block_flg = abap_true.

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = lv_vbeln
      TABLES
        return         = lt_return.



    SORT lt_return BY type.

    READ TABLE lt_return
    WITH KEY type = lc_type_E
    BINARY SEARCH TRANSPORTING NO FIELDS.

    IF sy-subrc NE 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF lt_return TO gt_messages.
    ENDIF.

  ENDMETHOD.


  METHOD lock_delivery.

    DATA: Ls_header_data    TYPE bapiobdlvhdrchg,
          ls_header_control TYPE bapiobdlvhdrctrlchg,
          lt_return         TYPE STANDARD TABLE OF bapiret2,
          lv_vbeln          TYPE vbeln_vl.

    CONSTANTS: lc_type_E TYPE bapi_mtype VALUE 'E'.
    lv_vbeln = iv_delivery.
    UNPACK lv_vbeln TO lv_vbeln.

* BEGIN OF INSERT - JWSILVA - 02.03.2023
    " Verifica se a remessa já foi atualizado com o status desejado.
    SELECT SINGLE vbeln, lifsk
      FROM likp
      INTO @DATA(ls_likp)
      WHERE vbeln EQ @iv_delivery.

    IF ls_likp-lifsk = iv_lifsk.
      RETURN.
    ENDIF.
* END OF INSERT - JWSILVA - 02.03.2023

    ls_header_data-deliv_numb = lv_vbeln.
    ls_header_data-dlv_block  = iv_lifsk.

    ls_header_control-deliv_numb    = lv_vbeln.
    ls_header_control-dlv_block_flg = abap_true.

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = lv_vbeln
      TABLES
        return         = lt_return.

    SORT lt_return BY type.

    READ TABLE lt_return
    WITH KEY type = lc_type_E
    BINARY SEARCH TRANSPORTING NO FIELDS.

    IF sy-subrc NE 0.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF lt_return TO gt_messages.
    ENDIF.

  ENDMETHOD.


  METHOD add_vehicle.

    DATA: ls_mod      TYPE /bobf/s_frw_modification,
          lv_nitem    TYPE p LENGTH 10,
          lt_tor_item TYPE /scmtms/t_tor_item_tr_k.

*    FIELD-SYMBOLS: <fs_itmtr>    TYPE /scmtms/s_tor_item_tr_k.
*    lv_nitem = 0000000000 + iv_itmstart.
    lv_nitem = iv_itmstart.

    LOOP AT gt_platenumber ASSIGNING FIELD-SYMBOL(<fs_plate>).

*      CLEAR ls_mod.
*
*      ls_mod-node         = /scmtms/if_tor_c=>sc_node-root.
*
*      ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-item_tr.
*      ls_mod-source_key   = iv_key.
*      ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*      ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*      ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*
*      CREATE DATA ls_mod-data TYPE /scmtms/s_tor_item_tr_k.
*      ASSIGN ls_mod-data->* TO <fs_itmtr>.
*
*      <fs_itmtr>-platenumber = <fs_plate>.
*      <fs_itmtr>-item_id     = lv_nitem.
*      <fs_itmtr>-item_type   = gc_itmtype_trl.
*      <fs_itmtr>-item_cat    = gc_itemcat_pvr. "recurso passivo de veículo
*      <fs_itmtr>-tures_tco   = iv_tures_tco.
*
*      AT FIRST.
*        <fs_itmtr>-item_type = gc_itmtype_truc.
*        <fs_itmtr>-item_cat = gc_itemcat_avr. "recurso de veículo
*      ENDAT.
*
*      APPEND ls_mod TO gt_mod.

      APPEND INITIAL LINE TO lt_tor_item ASSIGNING FIELD-SYMBOL(<fs_itmtr>).

      <fs_itmtr>-parent_key = iv_key.
      <fs_itmtr>-root_key   = iv_key.
      <fs_itmtr>-platenumber = <fs_plate>.
      <fs_itmtr>-item_id     = lv_nitem.
      <fs_itmtr>-item_type   = gc_itmtype_trl.
      <fs_itmtr>-item_cat    = gc_itemcat_pvr. "recurso passivo de veículo
      <fs_itmtr>-tures_tco   = iv_tures_tco.

      AT FIRST.
        <fs_itmtr>-item_type = gc_itmtype_truc.
        <fs_itmtr>-item_cat = gc_itemcat_avr. "recurso de veículo
      ENDAT.

      lv_nitem = lv_nitem + 10.
    ENDLOOP.

    IF lt_tor_item IS NOT INITIAL.
      /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data     = lt_tor_item
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                                       iv_source_node = /scmtms/if_tor_c=>sc_node-root
                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                              CHANGING ct_mod         = gt_mod ).
    ENDIF.

  ENDMETHOD.


  METHOD clear_itmtr.

    DATA: ls_mod      TYPE /bobf/s_frw_modification.

    LOOP AT it_itemtr ASSIGNING FIELD-SYMBOL(<fs_item>).
      CLEAR ls_mod.

      IF <fs_item>-item_type = gc_itmtype_truc OR <fs_item>-item_type = gc_itmtype_trl.
*         OR <fs_item>-item_cat = gc_itemcat_avr OR <fs_item>-item_cat = gc_itemcat_pvr.


        ls_mod-node         = /scmtms/if_tor_c=>sc_node-item_tr.
*        ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-item_tr.
        ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_delete.
        ls_mod-key          = <fs_item>-key.
        APPEND ls_mod TO gt_mod.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD upd_data_root.

    DATA: ls_mod      TYPE /bobf/s_frw_modification.

    FIELD-SYMBOLS: <fs_root>    TYPE /scmtms/s_tor_root_k.

    ls_mod-node         = /scmtms/if_tor_c=>sc_node-root.
    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_update.
    ls_mod-key          = iv_key.

    APPEND /scmtms/if_tor_c=>sc_node_attribute-root-tspid TO ls_mod-changed_fields.
    APPEND /scmtms/if_tor_c=>sc_node_attribute-root-tsp   TO ls_mod-changed_fields.
    APPEND 'ZZ_MOTORISTA'                                 TO ls_mod-changed_fields.

    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_root_k.
    ASSIGN ls_mod-data->* TO <fs_root>.
    <fs_root>-zz_motorista = iv_motorista.
    <fs_root>-tspid        = iv_agent_frete.
    CALL FUNCTION 'CONVERSION_EXIT_ID001_INPUT'
      EXPORTING
        input  = iv_agent_frete
      IMPORTING
        output = <fs_root>-tsp.

    APPEND ls_mod TO gt_mod.

  ENDMETHOD.


  METHOD create_event_n.

    DATA: ls_mod      TYPE /bobf/s_frw_modification.

    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k.

    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
    ls_mod-source_key   = is_tor-key.
    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
    ASSIGN ls_mod-data->* TO <fs_exec>.

    <fs_exec>-key          = ls_mod-key.
    <fs_exec>-event_code   = iv_evento.
    <fs_exec>-ext_loc_id   = is_stop-log_locid.

    APPEND ls_mod TO gt_mod.


  ENDMETHOD.


  METHOD upd_vehicle.
    TYPES : BEGIN OF ty_itemky,
              item TYPE /scmtms/item_id,
            END OF ty_itemky.
    DATA: ls_mod        TYPE /bobf/s_frw_modification,
          lt_tor_item_C TYPE /scmtms/t_tor_item_tr_k,
          lt_tor_item_U TYPE /scmtms/t_tor_item_tr_k,
          lt_auxitm     TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,
          lv_nitem      TYPE p LENGTH 10,
          lv_lcreat     TYPE abap_bool,
          lt_itemkey    TYPE SORTED TABLE OF ty_itemky WITH UNIQUE KEY item,
          ls_itemkey    TYPE ty_itemky,
          ls_item       TYPE /scmtms/s_tor_item_tr_k.

    FIELD-SYMBOLS: <fs_itm>    TYPE /scmtms/s_tor_item_tr_k.

    IF iv_clear = abap_true.
      LOOP AT it_itemtr ASSIGNING FIELD-SYMBOL(<fs_item>).
        CLEAR ls_mod.

        IF <fs_item>-item_type = gc_itmtype_truc OR <fs_item>-item_type = gc_itmtype_trl.


*          APPEND INITIAL LINE TO lt_tor_item_u ASSIGNING FIELD-SYMBOL(<fs_item_vehicle>).
*          <fs_item_vehicle> = <fs_item>.
          ls_item = <fs_item>.

          CLEAR: ls_item-platenumber ,
*                 <fs_item_vehicle>-country,
                 ls_item-tures_tco.

          INSERT ls_item INTO TABLE lt_tor_item_u.


*        ls_mod-node         = /scmtms/if_tor_c=>sc_node-item_tr.
**        ls_mod-association  = /scmtms/if_tor_c=>sc_association-item_tr.
*        ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_update.
*        ls_mod-key          = <fs_item>-key.
*
*        APPEND /scmtms/if_tor_c=>sc_node_attribute-item_tr-platenumber  TO ls_mod-changed_fields.
*        APPEND /scmtms/if_tor_c=>sc_node_attribute-item_tr-country      TO ls_mod-changed_fields.
*        APPEND /scmtms/if_tor_c=>sc_node_attribute-item_tr-tures_tco    TO ls_mod-changed_fields.
*
*        CREATE DATA ls_mod-data TYPE /scmtms/s_tor_item_tr_k.
*        ASSIGN ls_mod-data->* TO <fs_itm>.
*        CLEAR: <fs_itm>-platenumber ,
*               <fs_itm>-country,
*               <fs_itm>-tures_tco.
*        APPEND ls_mod TO gt_mod.
        ENDIF.

      ENDLOOP.

    ELSE.
      lt_auxitm = it_itemtr.
      SORT lt_auxitm BY item_type item_cat item_id.

      LOOP AT gt_platenumber ASSIGNING FIELD-SYMBOL(<fs_plate>).

        IF sy-tabix = 1. "First
          READ TABLE lt_auxitm
          WITH KEY item_type = gc_itmtype_truc
                   item_cat  = gc_itemcat_avr
          BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_aux>).

          IF sy-subrc = 0.
*            APPEND INITIAL LINE TO lt_tor_item_u ASSIGNING <fs_item_vehicle>.
*            <fs_item_vehicle> = <fs_aux>.
*            <fs_item_vehicle>-tures_tco   = iv_tures_tco.
*            <fs_item_vehicle>-platenumber = <fs_plate>.
            ls_item = <fs_aux>.
            ls_item-tures_tco   = iv_tures_tco.
            ls_item-platenumber = <fs_plate>.
            INSERT ls_item INTO TABLE lt_tor_item_u.
          ELSE.

*            APPEND INITIAL LINE TO lt_tor_item_c ASSIGNING <fs_item_vehicle>.
*            <fs_item_vehicle>-parent_key = iv_key.
*            <fs_item_vehicle>-root_key   = iv_key.
*            <fs_item_vehicle>-platenumber = <fs_plate>.
*            <fs_item_vehicle>-item_id     = lv_nitem.
*            <fs_item_vehicle>-item_type   = gc_itmtype_truc.
*            <fs_item_vehicle>-item_cat    = gc_itemcat_avr. "recurso de veículo
*            <fs_item_vehicle>-tures_tco   = iv_tures_tco.

            CLEAR ls_item.

            ls_item-parent_key  = iv_key.
            ls_item-root_key    = iv_key.
            ls_item-platenumber = <fs_plate>.
            ls_item-item_id     = lv_nitem.
            ls_item-item_type   = gc_itmtype_truc.
            ls_item-item_cat    = gc_itemcat_avr. "recurso de veículo
            ls_item-tures_tco   = iv_tures_tco.
            INSERT ls_item INTO TABLE lt_tor_item_c.

            lv_nitem = lv_nitem + 10.

          ENDIF.

        ELSE.
          READ TABLE lt_auxitm
          WITH KEY item_type = gc_itmtype_trl
                   item_cat  = gc_itemcat_pvr
          BINARY SEARCH TRANSPORTING NO FIELDS.
          lv_lcreat = abap_false.

          IF sy-subrc = 0.

            LOOP AT lt_auxitm ASSIGNING <fs_aux>.

              IF <fs_aux>-item_type NE gc_itmtype_trl
                 OR <fs_aux>-item_cat NE gc_itemcat_pvr.
                lv_lcreat = abap_true.
                EXIT.
              ENDIF.

              READ TABLE lt_itemkey
              WITH KEY item = <fs_aux>-item_id
              BINARY SEARCH TRANSPORTING NO FIELDS.

              IF sy-subrc NE 0.
                ls_itemkey-item = <fs_aux>-item_id.
                INSERT ls_itemkey INTO TABLE lt_itemkey.

*                APPEND INITIAL LINE TO lt_tor_item_u ASSIGNING <fs_item_vehicle>.
*                <fs_item_vehicle> = <fs_aux>.
*                <fs_item_vehicle>-tures_tco   = iv_tures_tco.
*                <fs_item_vehicle>-platenumber = <fs_plate>.
                ls_item = <fs_aux>.
                ls_item-tures_tco   = iv_tures_tco.
                ls_item-platenumber = <fs_plate>.

                INSERT ls_item INTO TABLE lt_tor_item_u.

              ENDIF.

            ENDLOOP.

          ELSE.
            lv_lcreat = abap_true.
          ENDIF.

          IF lv_lcreat = abap_true.
*            APPEND INITIAL LINE TO lt_tor_item_c ASSIGNING <fs_item_vehicle>.
*            <fs_item_vehicle>-parent_key  = iv_key.
*            <fs_item_vehicle>-root_key    = iv_key.
*            <fs_item_vehicle>-platenumber = <fs_plate>.
*            <fs_item_vehicle>-item_id     = lv_nitem.
*            <fs_item_vehicle>-item_type   = gc_itmtype_trl.
*            <fs_item_vehicle>-item_cat    = gc_itemcat_pvr. "recurso passivo de veículo
*            <fs_item_vehicle>-tures_tco   = iv_tures_tco.
            CLEAR ls_item.
            ls_item-parent_key  = iv_key.
            ls_item-root_key    = iv_key.
            ls_item-platenumber = <fs_plate>.
            ls_item-item_id     = lv_nitem.
            ls_item-item_type   = gc_itmtype_trl.
            ls_item-item_cat    = gc_itemcat_pvr. "recurso passivo de veículo
            ls_item-tures_tco   = iv_tures_tco.
            INSERT ls_item INTO TABLE lt_tor_item_c.

            lv_nitem = lv_nitem + 10.
          ENDIF.

        ENDIF.

      ENDLOOP.
    ENDIF.


    IF lt_tor_item_C IS NOT INITIAL.
      /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data     = lt_tor_item_C
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                                       iv_source_node = /scmtms/if_tor_c=>sc_node-root
                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                              CHANGING ct_mod         = gt_mod ).

    ENDIF.

    IF lt_tor_item_U  IS NOT INITIAL.

      /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_tor_item_U
                                                         iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                         iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                                CHANGING ct_mod         = gt_mod ).

    ENDIF.



  ENDMETHOD.
ENDCLASS.
