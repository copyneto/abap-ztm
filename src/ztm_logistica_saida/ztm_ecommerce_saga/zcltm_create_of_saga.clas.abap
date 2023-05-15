CLASS zcltm_create_of_saga DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_option_eq TYPE char2 VALUE 'EQ' ##NO_TEXT.
    CONSTANTS gc_option_ne TYPE char2 VALUE 'NE' ##NO_TEXT.
    CONSTANTS gc_sign_i TYPE char1 VALUE 'I' ##NO_TEXT.
    CONSTANTS gc_torcat_to TYPE /scmtms/tor_category VALUE 'TO' ##NO_TEXT.
    CONSTANTS gc_torcat_fu TYPE /scmtms/tor_category VALUE 'FU' ##NO_TEXT.
    CONSTANTS gc_event_coletado TYPE /scmtms/tor_event VALUE 'COLETADO_TRANSPORTAD' ##NO_TEXT.
    CONSTANTS gc_tortype_ecommerce TYPE /scmtms/tor_type VALUE '1030' ##NO_TEXT.
    CONSTANTS gc_itmtype_truc TYPE /scmtms/tor_item_type VALUE 'TRUC' ##NO_TEXT.
    CONSTANTS gc_itmtype_trl TYPE /scmtms/tor_item_type VALUE 'TRL' ##NO_TEXT.
    CONSTANTS gc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR' ##NO_TEXT.
    CONSTANTS gc_itemcat_pvr TYPE /scmtms/item_category VALUE 'PVR' ##NO_TEXT.

    METHODS process_interface
      IMPORTING
        !is_input TYPE zmt_frete_ordem
      RAISING
        zcxtm_create_of_saga .
    METHODS get_message
      RETURNING
        VALUE(rt_bapiret2) TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA go_srv_tor TYPE REF TO /bobf/if_tra_service_manager .
    DATA gs_input TYPE zmt_frete_ordem .
    DATA go_tra_mgr TYPE REF TO /bobf/if_tra_transaction_mgr .
    DATA gt_messages TYPE bapiret2_tab .
    DATA gt_mod TYPE /bobf/t_frw_modification .
    DATA gt_stop_first_last TYPE /scmtms/t_tor_stop_k .
    DATA gv_tures_tco TYPE /scmtms/equip_type .

    METHODS create_fo
      IMPORTING
        !is_root       TYPE /scmtms/s_tor_root_k
        !iv_actua_data TYPE /scmtms/actual_date
        !iv_vbeln      TYPE likp-vbeln.

    METHODS associate_uf
      IMPORTING
        !is_fu TYPE /scmtms/s_tor_root_k
        !is_fo TYPE /scmtms/s_tor_root_k .

    METHODS get_data_stop
      IMPORTING
        !iv_key TYPE /bobf/conf_key .

    METHODS create_vehicle .

    METHODS atualiza_status_of
      IMPORTING
        !iv_tor_key TYPE /bobf/conf_key .

ENDCLASS.



CLASS ZCLTM_CREATE_OF_SAGA IMPLEMENTATION.


  METHOD associate_uf.
    DATA: lo_change_action     TYPE REF TO /bobf/if_tra_change,
          lo_message_action    TYPE REF TO /bobf/if_frw_message,
          lt_failed_key        TYPE /bobf/t_frw_key,
          lt_failed_action_key TYPE /bobf/t_frw_key,
          lt_key               TYPE /bobf/t_frw_key,
          lt_keys_fu           TYPE /bobf/t_frw_key,
          ls_parameters        TYPE /scmtms/s_tor_a_add_elements,
          ls_parameters_pln    TYPE /scmtms/s_tor_a_add_fu_pln,
          lt_param             TYPE REF TO data,
          lt_fu_stop_succ      TYPE /scmtms/t_tor_stop_succ_k,
          lt_return            TYPE bapiret2_tab,
          lt_stop_first        TYPE /scmtms/t_tor_stop_k,
          lt_doc_reference     TYPE /scmtms/t_tor_docref_k,
          lt_mod               TYPE /bobf/t_frw_modification,
          ls_fu_key            TYPE /bobf/conf_key.

    DATA(lv_with_key) = abap_true.

    DATA: lr_param_key TYPE /bobf/s_frw_key.

    CLEAR lt_key.
    APPEND VALUE #( key = is_fo-key ) TO lt_key.

*    LOOP AT it_tor_fu INTO DATA(ls_tor_fu).

*      IF lv_with_key IS NOT INITIAL.
    lr_param_key-key = is_fu-key.
    APPEND lr_param_key TO ls_parameters-target_item_keys.
*      ELSE.
*
*        SHIFT ls_tor_fu-tor_id RIGHT DELETING TRAILING space.
*        SHIFT ls_tor_fu-tor_id LEFT  DELETING LEADING  space.
*        SHIFT ls_tor_fu-tor_id LEFT  DELETING LEADING  '0'.

    CONCATENATE ls_parameters-string
                is_fu-tor_id
           INTO ls_parameters-string SEPARATED BY space.

*      ENDIF.

*      AT LAST.

    GET REFERENCE OF ls_parameters INTO lt_param.

    go_srv_tor->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-add_fu_by_fuid
                                     it_key                = lt_key
                                     is_parameters         = lt_param
                           IMPORTING eo_change             = lo_change_action
                                     eo_message            = lo_message_action
                                     et_failed_action_key  = lt_failed_action_key
                                     et_failed_key         = lt_failed_key ).


    IF lo_message_action IS BOUND .
      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
                                                             CHANGING  ct_bapiret2 = lt_return[] ).
      APPEND LINES OF lt_return TO gt_messages.
    ELSE.

    ENDIF.

    CLEAR: ls_parameters,
           lo_message_action,
           lt_param.

*      ENDAT.

*    ENDLOOP.

*    go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                      IMPORTING ev_rejected         = DATA(lv_rejected)
*                                eo_change           = DATA(lo_change)
*                                eo_message          = DATA(lo_message_save)
*                                et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).

*    IF NOT lo_message_action IS INITIAL.
*      CLEAR lt_return.
*      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
*                                                             CHANGING  ct_bapiret2 = lt_return[] ).
*
*      APPEND LINES OF lt_return TO gt_messages.
*    ENDIF.

*    IF NOT lo_message_save IS INITIAL.
*      CLEAR lt_return.
*      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
*                                                             CHANGING  ct_bapiret2 = lt_return[] ).
*
*      APPEND LINES OF lt_return TO gt_messages.
*    ENDIF.

* Corrigir data de partida da OF baseado na remessa
    ls_fu_key = is_fo-key.

    go_srv_tor->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = ls_fu_key ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-stop_first
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_stop_first ).

    IF lt_stop_first IS NOT INITIAL.
      LOOP AT lt_stop_first ASSIGNING FIELD-SYMBOL(<fs_stop_first>).
        CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP <fs_stop_first>-plan_trans_time TIME ZONE sy-zonlo.
      ENDLOOP.

      INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_update
                      node = /scmtms/if_tor_c=>sc_node-stop
                      key  = <fs_stop_first>-key
                      data = REF #( <fs_stop_first> ) ) INTO TABLE lt_mod.

      CALL METHOD go_srv_tor->modify
        EXPORTING
          it_modification = lt_mod
        IMPORTING
          eo_message      = DATA(lo_message).

*      go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                        IMPORTING ev_rejected         = lv_rejected
*                                  eo_change           = lo_change
*                                  eo_message          = lo_message_save
*                                  et_rejecting_bo_key = ls_rejecting_bo_key ).
*
*      IF NOT lo_message_save IS INITIAL.
*        CLEAR lt_return.
*        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
*                                                               CHANGING  ct_bapiret2 = lt_return[] ).
*
*        APPEND LINES OF lt_return TO gt_messages.
*      ENDIF.



*      go_srv_tor->retrieve_by_association(
*        EXPORTING
*          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
*          it_key         = VALUE #( ( key = ls_fu_key ) )
*          iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
*          iv_fill_data   = abap_true
*        IMPORTING
*          et_data        = lt_doc_reference ).
*
*      IF line_exists( lt_doc_reference[ btd_tco = '73' ] ).
*        DATA(lv_vbeln) = VALUE #( lt_doc_reference[ btd_tco = '73' ]-btd_id ).
*
*        SHIFT lv_vbeln LEFT DELETING LEADING '0'.
*        lv_vbeln = '00' && lv_vbeln.
*
*        SELECT SINGLE wadat, wauhr
*          FROM likp
*          INTO @DATA(ls_likp)
*        WHERE vbeln = @lv_vbeln.
*
*        IF sy-subrc IS INITIAL.
*          LOOP AT lt_stop_first ASSIGNING FIELD-SYMBOL(<fs_stop_first>).
*            CONVERT DATE ls_likp-wadat TIME ls_likp-wauhr INTO TIME STAMP <fs_stop_first>-plan_trans_time TIME ZONE sy-zonlo.
*          ENDLOOP.
*        ENDIF.
*
*        INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_update
*                        node = /scmtms/if_tor_c=>sc_node-stop
*                        key  = <fs_stop_first>-key
*                        data = REF #( <fs_stop_first> ) ) INTO TABLE lt_mod.
*
*        CALL METHOD go_srv_tor->modify
*          EXPORTING
*            it_modification = lt_mod
*          IMPORTING
*            eo_message      = DATA(lo_message).
*
*        go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                          IMPORTING ev_rejected         = lv_rejected
*                                    eo_change           = lo_change
*                                    eo_message          = lo_message_save
*                                    et_rejecting_bo_key = ls_rejecting_bo_key ).
*
*        IF NOT lo_message_save IS INITIAL.
*          CLEAR lt_return.
*          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
*                                                                 CHANGING  ct_bapiret2 = lt_return[] ).
*
*          APPEND LINES OF lt_return TO gt_messages.
*        ENDIF.
*      ENDIF.
    ENDIF.

    go_tra_mgr->save(
      EXPORTING
        iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
      IMPORTING
        ev_rejected         = DATA(lv_rejected)
        eo_change           = DATA(lo_change)
        eo_message          = DATA(lo_message_save)
        et_rejecting_bo_key = DATA(ls_rejecting_bo_key)
    ).
    IF NOT lo_message_save IS INITIAL.
      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
        EXPORTING
          io_message  = lo_message_save
        CHANGING
          ct_bapiret2 = lt_return[]
      ).
      APPEND LINES OF lt_return TO gt_messages.
    ENDIF.

  ENDMETHOD.


  METHOD atualiza_status_of.

    DATA:
      lt_key     TYPE /bobf/t_frw_key,
      lr_param   TYPE REF TO /scmtms/s_tor_a_set_exm_status,
      LT_message TYPE bapiret2_tab.

    CREATE DATA lr_param.

    lr_param->ui_action_source = 'P'. "ou 'F'
    lr_param->force            = abap_true.

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_tor_key CHANGING ct_key = lt_key ).


    go_srv_tor->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-set_exm_status_in_execution
                                     it_key                = lt_key
                                     is_parameters         = lr_param
                           IMPORTING eo_change             = DATA(lo_change_action)
                                     eo_message            = DATA(lo_message_action)
                                     et_failed_action_key  = DATA(lt_failed_action_key)
                                     et_failed_key         = DATA(lt_failed_key) ).


    IF NOT lo_message_action IS INITIAL.

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
                                                             CHANGING  ct_bapiret2 = LT_message ).

    ENDIF.

    IF LT_message IS NOT INITIAL.
      APPEND LINES OF lt_message TO gt_messages.
    ENDIF.

  ENDMETHOD.


  METHOD create_fo.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.

    DATA:
      lo_message    TYPE REF TO /bobf/if_frw_message,
      lt_return     TYPE bapiret2_tab,
      lt_result     TYPE /bobf/t_frw_keyindex,
      lt_loc_item   TYPE /scmtms/t_loc_alt_id,
      lt_mod_root   TYPE /bobf/t_frw_modification,
      lt_mod        TYPE /bobf/t_frw_modification,
      lt_mod_evento TYPE /bobf/t_frw_modification,
      lt_mod_driver TYPE /bobf/t_frw_modification,
      lo_tra_tor    TYPE REF TO /bobf/if_tra_transaction_mgr,
      lt_root       TYPE /scmtms/t_tor_root_k,
      lt_changed    TYPE /bobf/t_frw_name,
      lv_sourceid   TYPE /scmtms/location_id,
      lv_destiid    TYPE /scmtms/location_id,
      ls_stopfirst  TYPE /scmtms/s_tor_stop_k,
      lt_tor_item   TYPE /scmtms/t_tor_item_tr_k,
      lv_nitem      TYPE p LENGTH 10,
      ls_item       TYPE /scmtms/s_tor_item_tr_k,
      ls_mod        TYPE /bobf/s_frw_modification,
      ls_mod_bupa   TYPE /bobf/s_frw_modification,
      lt_auxitm     TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,
      lv_appendvehi TYPE abap_bool,
      lt_bupa       TYPE /bofu/t_bupa_root_k,
      lt_bupa_uf    TYPE /bofu/t_bupa_root_k.

    FIELD-SYMBOLS: <fs_exec> TYPE /scmtms/s_tor_exec_k.

    CONSTANTS: lc_stop_first TYPE /scmtms/stop_category VALUE 'O',
               lc_stop_last  TYPE /scmtms/stop_category VALUE 'I',
               gc_modulo     TYPE ze_param_modulo       VALUE 'TM',
               gc_chave1     TYPE ze_param_chave        VALUE 'INTEGRACAO_SAGA',
               gc_tipo_exp   TYPE ze_param_chave        VALUE 'TIPO_EXP',
               gc_cond_exp   TYPE ze_param_chave        VALUE 'COND_EXPED'.

    lo_tra_tor    = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    "Criar ordem de frete
    /scmtms/cl_tor_factory=>create_tor_tour(
                                             EXPORTING
                                                iv_do_modify            = abap_true
                                                iv_tor_type             = gc_tortype_ecommerce
                                                iv_create_initial_stage = abap_true
                                                iv_creation_type        = /scmtms/if_tor_const=>sc_creation_type-manual
                                             IMPORTING
                                                es_tor_root             = DATA(ls_tor_root)
                                                et_tor_item             = DATA(lt_item)
                                                et_tor_stop             = DATA(lt_stop)
                                             CHANGING
                                                co_message              = lo_message ).

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      APPEND LINES OF lt_return TO gt_messages.
    ELSE.

      LOOP AT gt_stop_first_last ASSIGNING FIELD-SYMBOL(<fs_stp>).
        IF <fs_stp>-stop_cat = lc_stop_first.
          lv_sourceid = <fs_stp>-log_locid .
          ls_stopfirst = <fs_stp>.
        ENDIF.

        IF <fs_stp>-stop_cat = lc_stop_last.
          lv_destiid = <fs_stp>-log_locid .
        ENDIF.
      ENDLOOP.

      "Converter origem e destino
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
        EXPORTING
          iv_node_key   = /scmtms/if_location_c=>sc_node-root
          iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
          it_key        = VALUE /scmtms/t_loc_alt_id( ( lv_sourceid ) ( lv_destiid ) )
        IMPORTING
          et_result     = lt_result ).

      "Definir os pontos de origem e destino
      LOOP AT lt_stop ASSIGNING FIELD-SYMBOL(<fs_stop>).
        IF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.
          <fs_stop>-log_locid    = lv_sourceid.
          <fs_stop>-log_loc_uuid = lt_result[ 1 ]-key.
          CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

        ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.
          <fs_stop>-log_locid    = lv_destiid.
          <fs_stop>-log_loc_uuid = lt_result[ 2 ]-key.
          CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

        ELSE.
          CONTINUE.
        ENDIF.

        "Preparar as atualizações das paradas
        INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_update
                        node = /scmtms/if_tor_c=>sc_node-stop
                        key  = <fs_stop>-key
                        data = REF #( <fs_stop> )
                       ) INTO TABLE lt_mod.
      ENDLOOP.

      "Gravar Ordem de Frete
      CALL METHOD go_srv_tor->modify
        EXPORTING
          it_modification = lt_mod
        IMPORTING
          eo_message      = lo_message.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).
      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.

      ls_tor_root-tor_type          = gc_tortype_ecommerce.
      ls_tor_root-tspid             = gs_input-mt_frete_ordem-party_id.
      ls_tor_root-zznr_saga    = gs_input-mt_frete_ordem-zcarga.


      TRY.
          NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = gc_modulo
                                                                  iv_chave1 = gc_chave1
                                                                  iv_chave2 = gc_cond_exp
                                                        IMPORTING ev_param  = ls_tor_root-zz1_cond_exped ).

        CATCH zcxca_tabela_parametros.
      ENDTRY.

      TRY.
          NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = gc_modulo
                                                                  iv_chave1 = gc_chave1
                                                                  iv_chave2 = gc_tipo_exp
                                                        IMPORTING ev_param  = ls_tor_root-zz1_tipo_exped ).

        CATCH zcxca_tabela_parametros.
      ENDTRY.

      IF ls_tor_root-tor_type IS NOT INITIAL.
        APPEND 'TOR_TYPE'       TO lt_changed.
      ENDIF.
      IF ls_tor_root-tspid IS NOT INITIAL.
        APPEND 'TSPID'          TO lt_changed.
      ENDIF.
      IF ls_tor_root-zz1_cond_exped IS NOT INITIAL.
        APPEND 'ZZ1_COND_EXPED' TO lt_changed.
      ENDIF.
      IF ls_tor_root-zz1_tipo_exped IS NOT INITIAL.
        APPEND 'ZZ1_TIPO_EXPED' TO lt_changed.
      ENDIF.
      IF ls_tor_root-zznr_saga IS NOT INITIAL.
        APPEND 'ZZNR_SAGA'      TO lt_changed.
      ENDIF.

      " Atualiza campos da Ordem de Frete
      TRY.
          zcltm_manage_of=>change_of( EXPORTING iv_interface = zcltm_manage_of=>gc_interface-saga
                                                is_root_fu   = is_root
                                                iv_vbeln     = iv_vbeln
                                      CHANGING  cs_root      = ls_tor_root
                                                ct_changed   = lt_changed ).
        CATCH cx_root.
      ENDTRY.

      "Atualização do TOR
      INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                     node           = /scmtms/if_tor_c=>sc_node-root
                     key            = ls_tor_root-key
                     changed_fields = lt_changed
                     data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.
*
      CALL METHOD go_srv_tor->modify
        EXPORTING
          it_modification = lt_mod_root
        IMPORTING
          eo_message      = lo_message.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).
      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.

      IF gv_tures_tco IS NOT INITIAL.

        SELECT SINGLE equi_type FROM /scmb/equi_code
        WHERE
          equi_code = @gv_tures_tco
        INTO @DATA(lv_tures_cat).

        lv_nitem = lv_nitem + 10.

        READ TABLE lt_item WITH KEY  item_cat  = gc_itemcat_avr ASSIGNING FIELD-SYMBOL(<fs_aux>). "#EC CI_SORTSEQ

        IF sy-subrc EQ 0.
          lv_appendvehi       =  abap_false.
          MOVE-CORRESPONDING <fs_aux> TO ls_item.
          ls_item-item_type   = gc_itmtype_truc.
        ELSE.
          ls_item-item_id     = lv_nitem.
          ls_item-parent_key  = ls_tor_root-key.
          ls_item-root_key    = ls_tor_root-key.
          ls_item-item_type   = gc_itmtype_truc.
          ls_item-item_cat    = gc_itemcat_avr. "recurso de veículo
          lv_appendvehi =  abap_true.
        ENDIF.

        ls_item-platenumber = gs_input-mt_frete_ordem-platenumber.
        ls_item-tures_tco   = gv_tures_tco.
        ls_item-tures_cat   = lv_tures_cat.
        ls_item-mtr         = '0004'.
        INSERT ls_item INTO TABLE lt_tor_item.

        IF lv_appendvehi = abap_true. "lt_tor_item_C IS NOT INITIAL.

          /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data     = lt_tor_item
                                                    iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                                    iv_source_node = /scmtms/if_tor_c=>sc_node-root
                                                    iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                           CHANGING ct_mod         = lt_mod_driver ).
        ELSE.
          /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_tor_item
                                                         iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                         iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                                CHANGING ct_mod         = lt_mod_driver ).

        ENDIF.
        "Gravar Veiculo
        IF lt_mod_driver IS NOT INITIAL.
          CALL METHOD go_srv_tor->modify
            EXPORTING
              it_modification = lt_mod_driver
            IMPORTING
              eo_message      = lo_message.

          lo_message->get_messages( EXPORTING iv_severity =  /bobf/cm_frw=>co_severity_error
                                    IMPORTING et_message  = DATA(lt_messages) ).

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).
          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO gt_messages.
          ENDIF.
        ENDIF.

*        ENDIF.
      ENDIF.

    ENDIF.

    "criando os envetos
    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
    ls_mod-source_key   = ls_tor_root-key.
    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
    ASSIGN ls_mod-data->* TO <fs_exec>.

    <fs_exec>-key          = ls_mod-key.
    <fs_exec>-event_code   = gc_event_coletado.
    <fs_exec>-torstopuuid  = ls_stopfirst-key.
    <fs_exec>-ext_loc_id   = ls_stopfirst-log_locid.
    <fs_exec>-ext_loc_uuid = ls_stopfirst-log_loc_uuid.
    <fs_exec>-actual_date  = iv_actua_data.
    APPEND ls_mod TO lt_mod_evento.

    "Gravar Evento
    CALL METHOD go_srv_tor->modify
      EXPORTING
        it_modification = lt_mod_evento
      IMPORTING
        eo_message      = lo_message.

    IF lo_message IS BOUND.
*      lo_message->get_messages( EXPORTING iv_severity =  /bobf/cm_frw=>co_severity_error
*                                IMPORTING et_message  = DATA(lt_messages1) ).
*
      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).
      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.
    ENDIF.

**    IF sy-uname = 'FSSILVA'.
*** Buscar Unidade gerencial de destino da UF
**      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
**        EXPORTING
**          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
**          it_key         = VALUE #( ( key = is_root-key ) )
**          iv_association = /scmtms/if_tor_c=>sc_association-root-bupa_consignee_root
**          iv_fill_data   = abap_true
**        IMPORTING
**          et_data        = lt_bupa_uf ).
**
*** Inserir Unidade gerencial de destino - OF
**      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
**        EXPORTING
**          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
**          it_key         = VALUE #( ( key = ls_tor_root-key ) )
**          iv_association = /scmtms/if_tor_c=>sc_association-root-bupa_consignee_root
**          iv_fill_data   = abap_true
**        IMPORTING
**          et_data        = lt_bupa ).
**
**      IF lt_bupa IS INITIAL.
**        IF lt_bupa_uf IS NOT INITIAL.
***          READ TABLE lt_bupa_uf INTO DATA(ls_bupa_uf) INDEX 1.
***
***          ls_bupa_uf-key      = /bobf/cl_frw_factory=>get_new_key( ).
***          ls_bupa_uf-root_key = ls_tor_root-key.
***
***          "Preparar as atualizações das paradas
***          INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_create
***                          node        = /scmtms/if_tor_c=>sc_node-bupa_root
***                          key         = ls_tor_root-key
***                          data        = REF #( <fs_stop_new> ) ) INTO TABLE lt_mod.
**
**          READ TABLE lt_bupa_uf ASSIGNING FIELD-SYMBOL(<fs_bupa>) INDEX 1.
**
**          <fs_bupa>-key      = /bobf/cl_frw_factory=>get_new_key( ).
**          <fs_bupa>-root_key = ls_tor_root-key.
**
**          CLEAR lt_mod.
**
**          /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data        = lt_bupa_uf
**                                                             iv_node        = /scmtms/if_tor_c=>sc_node-bupa_root
**                                                             iv_source_node = /scmtms/if_tor_c=>sc_node-root
**                                                             iv_association = /scmtms/if_tor_c=>sc_association-root-bupa_consignee_root
**                                                    CHANGING ct_mod         = lt_mod ).
**
***          CLEAR : ls_bupa_uf-key,
***                  ls_bupa_uf-parent_key.
***
***          ls_bupa_uf-key      = /bobf/cl_frw_factory=>get_new_key( ).
***          ls_bupa_uf-root_key = ls_tor_root-key.
***
***          CLEAR lt_mod.
***
***          INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_create
***                          node        = /scmtms/if_tor_c=>sc_node-root
***                          association = /scmtms/if_tor_c=>sc_association-root-bupa_consignee_root
***                          key         = ls_tor_root-key
***                          data        = REF #( ls_bupa_uf ) ) INTO TABLE lt_mod.
**
**          CALL METHOD go_srv_bupa->modify
**            EXPORTING
**              it_modification = lt_mod
**            IMPORTING
**              eo_message      = lo_message.
**
**          CLEAR lt_return.
**          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
**                                                                 CHANGING  ct_bapiret2 = lt_return[] ).
**          IF lt_return IS NOT INITIAL.
**            APPEND LINES OF lt_return TO gt_messages.
**          ENDIF.
**
**        ENDIF.
**      ENDIF.
**    ENDIF.

    IF lines( lt_return ) > 0.
      lo_tra_tor->cleanup( ).
    ELSE.
      DO 5 TIMES.

        lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                          IMPORTING ev_rejected         = DATA(lv_rejected)
                                    eo_change           = DATA(lo_change)
                                    eo_message          = lo_message
                                    et_rejecting_bo_key = DATA(lt_rej_bo_key) ).
        IF line_exists( lt_return[ id = '/SCMTMS/TOR' number = '000' ] ).
          EXIT.
        ELSE.
          WAIT UP TO 10 SECONDS.
        ENDIF.
      ENDDO.


      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      " Quando encontrado a mensagem que a OF foi criada, mudar o restante das mensagens 'E' como 'W'
      IF line_exists( lt_return[ id = '/SCMTMS/TOR' number = '000' ] ). "#EC CI_STDSEQ
        LOOP AT lt_return REFERENCE INTO DATA(ls_r_return).
          CHECK ls_r_return->type = 'E'.
          ls_r_return->type = 'W'.
        ENDLOOP.
      ENDIF.

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root
          it_key                  = VALUE #( ( key = ls_tor_root-key ) )
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_root ).

      IF NOT line_exists( lt_return[ type = if_xo_const_message=>error ] ). "#EC CI_STDSEQ

        associate_uf(
          EXPORTING
            is_fu = is_root
            is_fo = ls_tor_root
        ).
        atualiza_status_of( iv_tor_key = ls_tor_root-key  ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_vehicle.




  ENDMETHOD.


  METHOD get_data_stop.

    DATA: lt_key    TYPE /bobf/t_frw_key.

    FREE: gt_stop_first_last.

    IF go_srv_tor IS NOT INITIAL.
      CLEAR: gt_stop_first_last.

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_key CHANGING ct_key = lt_key ).

      go_srv_tor->retrieve_by_association(
                                           EXPORTING
                                             iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                             it_key                  = lt_key
                                             iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first_and_last
                                             iv_fill_data            = abap_true
                                           IMPORTING
                                             et_data                 = gt_stop_first_last
                                          ).
    ENDIF.
  ENDMETHOD.


  METHOD get_message.

    rt_bapiret2 = gt_messages.
  ENDMETHOD.


  METHOD process_interface.

    DATA: lt_parameters   TYPE /bobf/t_frw_query_selparam,
          lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_tor_root_key TYPE /bobf/t_frw_key,
          lv_remessa      TYPE vbeln,
          lv_btdid        TYPE /scmtms/base_btd_id,
          lv_key1         TYPE ze_param_chave,
          lv_key2         TYPE ze_param_chave,
          lt_key          TYPE /bobf/t_frw_key.

    CONSTANTS: lc_modulo TYPE ze_param_modulo VALUE 'TM',
               lc_key1   TYPE ze_param_chave VALUE 'TIPODEVEICULOSAGA'.

    go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    go_tra_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    "Jefferson: Atualizar seleção para App tabela de parâemtros

*    SELECT * FROM zttm_tpvei_saga
*    WHERE tures_tco_saga = @is_input-mt_frete_ordem-tures_tco
*    INTO TABLE @gt_conftpvei.
*    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).
*    TRY.
*        lo_tabela_parametros->m_get_single(
*          EXPORTING
*            iv_modulo = lc_modulo
*            iv_chave1 = lc_key1
*            iv_chave2 = CONV ze_param_chave( is_input-mt_frete_ordem-tures_tco )
*          IMPORTING
*            ev_param  = gv_tures_tco
*        ).
*      CATCH zcxca_tabela_parametros.
*
*    ENDTRY.

*    IF gv_tures_tco IS NOT INITIAL.
    IF is_input-mt_frete_ordem-tures_tco IS NOT INITIAL.
*      SORT gt_confTpVei BY tures_tco_saga.
      gv_tures_tco = is_input-mt_frete_ordem-tures_tco.
      gs_input     = is_input.

      LOOP AT is_input-mt_frete_ordem-remessas ASSIGNING FIELD-SYMBOL(<fs_remessa>).

        IF <fs_remessa>-base_btd_id IS NOT INITIAL.
          CLEAR : lt_parameters,
                  lt_tor,
                  lt_tor_root_key.

          lv_btdid = <fs_remessa>-base_btd_id.
          SHIFT lv_btdid LEFT DELETING LEADING '0'.
          CONDENSE lv_btdid NO-GAPS.
          lv_remessa = lv_btdid.
          UNPACK lv_remessa TO lv_remessa.

          APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
          <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-base_btd_id.
          <fs_parameters>-sign   = gc_sign_i.
          <fs_parameters>-option = gc_option_eq.
          <fs_parameters>-low    = lv_remessa.

          APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameters>.
          <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-lifecycle.
          <fs_parameters>-sign   = gc_sign_i.
          <fs_parameters>-option = gc_option_ne.
          <fs_parameters>-low    = '10'.


          go_srv_tor->query(
           EXPORTING
             iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
             it_selection_parameters = lt_parameters
             iv_fill_data            = abap_true
           IMPORTING
             et_key                  = lt_tor_root_key
             et_data                 = lt_tor
          ).


          IF lt_tor IS NOT INITIAL.
            IF lt_tor[ 1 ]-plan_status_root = '03'.
             DATA(ls_message) = VALUE BAPIRET2(
               type       = 'E'
               id         = 'ZTM_CREATE_OF_SAGA'
               number     = '003'
               message_v1 = lt_tor[ 1 ]-tor_id
             ).
             MESSAGE ID  ls_message-id
                  TYPE   ls_message-type
                  NUMBER ls_message-number
                  WITH   ls_message-message_v1
                         ls_message-message_v2
                         ls_message-message_v3
                         ls_message-message_v4
                  INTO   ls_message-message.
              APPEND ls_message TO gt_messages.
              CONTINUE.
            ENDIF.

            get_data_stop( iv_key =  lt_tor[ 1 ]-root_key ).
            create_fo(
                      EXPORTING
                        is_root       = lt_tor[ 1 ]
                        iv_actua_data = CONV /scmtms/actual_date( <fs_remessa>-actual_date )
                        iv_vbeln      = lv_remessa
                  ).
          ELSE.
            APPEND LINES OF NEW zcxtm_create_of_saga(
                                                   textid      = zcxtm_create_of_saga=>uf_nao_localizada
                                                   gv_msgv1    = CONV msgv1( <fs_remessa>-base_btd_id )
                                                )->get_bapiretreturn( )
                                    TO gt_messages.
          ENDIF.

        ELSE.
          APPEND LINES OF NEW zcxtm_create_of_saga(
                                                   textid      = zcxtm_create_of_saga=>uf_nao_localizada
                                                   gv_msgv1    = CONV msgv1( <fs_remessa>-base_btd_id )
                                                )->get_bapiretreturn( )
                                    TO gt_messages.

        ENDIF.

      ENDLOOP.
    ELSE.
      APPEND LINES OF NEW zcxtm_create_of_saga(
                                                  textid      = zcxtm_create_of_saga=>tpveiculo_nao_localizado
                                                  gv_msgv1    = CONV msgv1( is_input-mt_frete_ordem-tures_tco )
                                               )->get_bapiretreturn( )
                                   TO gt_messages.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
