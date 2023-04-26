FUNCTION zfmtm_gko_faturar_etapa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GKO_HEADER) TYPE  ZTTM_GKOT001
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  " Tabelas
  DATA: lt_tor_root        TYPE /scmtms/t_tor_root_k,
        lt_stage           TYPE /scmtms/t_tor_stage,
        lt_tor_root_keys   TYPE /bobf/t_frw_key,
        lt_sfir_item       TYPE /scmtms/t_sfir_item_k,
        lt_sfir_root       TYPE /scmtms/t_sfir_root_k,
        lt_post_sfir       TYPE /bobf/t_frw_key,
        lt_sfir_keys       TYPE /bobf/t_frw_key,
        lt_sfir_keys_final TYPE /bobf/t_frw_key,
        lt_tor_for_charges TYPE /scmtms/t_tor_q_chargedata,
        lr_params          TYPE REF TO /scmtms/s_sfir_input_params,
        lr_param_sfir      TYPE REF TO /scmtms/s_sfir_a_post_docs,
        lt_return          TYPE bapiret2_tab,
        lt_bal_message     TYPE /bofu/t_bal_message_k,
        lt_dd07v           TYPE TABLE OF dd07v,
        lt_mod             TYPE /bobf/t_frw_modification,
        lt_changed         TYPE /bobf/t_frw_name,
        lt_loc_id_key      TYPE STANDARD TABLE OF zi_tm_vh_location_id,
        lv_zz1_cond        TYPE Char2.

  " Estruturas
  DATA: ls_ctx      TYPE /scmtms/cl_tcc_do_helper=>ts_ctx.

  " Variáveis
  DATA: lv_tor_key      TYPE /bobf/conf_key,
        lv_cons_invoice TYPE /scmtms/cons_invoice.

  " Instancias
  DATA(lr_txm)             = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
  DATA(lo_sfir_sett_index) = /scmtms/cl_sfir_sett_ind_help=>get_instance( ).
  DATA(lo_srvmgr_tor)      = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).
  DATA(lo_srvmgr_sfir)     = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key ).

  " Buscar TOR Key
  lv_tor_key = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = is_gko_header-tor_id ).

  " Busca TOR Data
  CALL METHOD /scmtms/cl_tor_helper_common=>get_tor_data
    EXPORTING
      it_root_key = VALUE #( ( key = lv_tor_key ) )
    IMPORTING
      et_root     = lt_tor_root.

  CHECK lt_tor_root[] IS NOT INITIAL.

* Condição de expedição - determina se é OF Cross/'Mãe'

  lv_zz1_cond = lt_tor_root[ 1 ]-zz1_cond_exped.

* Determinar direção do transporte - inbound ou outbound

  CALL METHOD /scmtms/cl_tor_helper_stop=>get_stops_for_root
    EXPORTING
      it_root_keys     = VALUE #( ( key = lv_tor_key ) )
    IMPORTING
      et_stop          = DATA(lt_stops)
      et_outbound_stop = DATA(lt_out_stops)
      et_inbound_stop  = DATA(lt_inb_stops).

  LOOP AT lt_out_stops TRANSPORTING NO FIELDS WHERE wh_next_rel = 'L' AND stop_seq_pos = 'F'.
    DATA(lv_outbound) = abap_true.
  ENDLOOP.

  LOOP AT lt_inb_stops TRANSPORTING NO FIELDS WHERE wh_next_rel = 'U' AND stop_seq_pos = 'L'.
    DATA(lv_inbound) = abap_true.
  ENDLOOP.


  TRY.
      lo_srvmgr_tor->query(
        EXPORTING
          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-qdb_for_charges " Query
          it_filter_key           = VALUE #( ( key = lv_tor_key ) )                 " Key Table
          iv_fill_data            = abap_true                                       " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
        IMPORTING
          et_data                 = lt_tor_for_charges ).
    CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
      RETURN.
  ENDTRY.

  " Busca Stage
  /scmtms/cl_tor_helper_stage=>get_stage(
    EXPORTING
      it_root_key            =   VALUE #( ( key = lv_tor_key ) )
    IMPORTING
      et_stage               =   lt_stage ).

  " Prepara Settlement
  CALL METHOD lo_sfir_sett_index->/scmtms/if_sfir_sett_ind_help~prepare_settlement_index
    EXPORTING
      iv_inv_creation_method = lv_cons_invoice                                  " Invoice Creation Method
      it_tor_key             = VALUE #( ( key = lv_tor_key ) )                  " Key
      it_tor_q_data          = lt_tor_for_charges.                              " Key Table

  " Busca Settlement
  CALL METHOD lo_sfir_sett_index->/scmtms/if_sfir_sett_ind_help~execute_packaging
    EXPORTING
      iv_package_size     = '100'                                               " package size
      iv_soft_split       = '0'                                                 " adjust package dynamically
    IMPORTING
      et_tor_root_keys    = lt_tor_root_keys                                    " NodeID
      et_settlement_index = DATA(lt_settlement_index).                          " Settlement Index structure for FSD creation

  ls_ctx-host_bo_key        = /scmtms/if_tor_c=>sc_bo_key.
  ls_ctx-host_root_node_key = /scmtms/if_tor_c=>sc_node-root.
  ls_ctx-host_node_key      = /scmtms/if_tor_c=>sc_node-transportcharges.

  /scmtms/cl_tcc_do_helper=>retrive_do_nodes( EXPORTING is_ctx            = ls_ctx
                                                        it_root_key       = VALUE #( ( key = lv_tor_key ) )
                                              IMPORTING et_charge_item    = DATA(lt_items)
                                                        et_do_root        = DATA(lt_root)
                                                        et_charge_element = DATA(lt_elements) ).

  " Recupera a Unidade Gerencial
  IF is_gko_header-dest_cod IS NOT INITIAL.
    lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-dest_cod ) ).
  ENDIF.
  IF is_gko_header-receb_cod IS NOT INITIAL.
    lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-receb_cod ) ).
  ENDIF.
  IF is_gko_header-rem_cod IS NOT INITIAL.
    lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-rem_cod ) ).
  ENDIF.
  IF is_gko_header-exped_cod IS NOT INITIAL.
    lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-exped_cod ) ).
  ENDIF.

  IF lt_loc_id_key[] IS NOT INITIAL.

    SELECT locationid, partner
        FROM zi_tm_vh_location_id
        FOR ALL ENTRIES IN @lt_loc_id_key
        WHERE partner = @lt_loc_id_key-partner
        INTO TABLE @DATA(lt_loc_id).

    IF sy-subrc EQ 0.
      SORT lt_loc_id BY partner.
    ENDIF.
  ENDIF.





  LOOP AT lt_stage ASSIGNING FIELD-SYMBOL(<fs_stage>).

    " Valida Destinatário /Recebedor da Mercadoria
    IF ( <fs_stage>-dest_stop-log_locid     EQ is_gko_header-dest_cod
       AND lv_outbound EQ abap_true )

      OR ( <fs_stage>-dest_stop-log_locid   EQ is_gko_header-receb_cod
      AND lv_outbound EQ abap_true )
      " Valida Remetente/ Expedidor
      OR ( <fs_stage>-source_stop-log_locid EQ is_gko_header-rem_cod
      AND lv_inbound EQ abap_true )

      OR ( <fs_stage>-source_stop-log_locid EQ is_gko_header-exped_cod
      AND lv_inbound EQ abap_true )
      " Valida se é OF Cross- Se sim, pega a key da primeira etapa.
      OR lv_zz1_cond EQ '04'.

      IF line_exists( lt_items[ host_key = <fs_stage>-stage_key ] ).
        IF lt_items[ host_key = <fs_stage>-stage_key ]-amount IS INITIAL.
          DELETE lt_settlement_index WHERE host_key = <fs_stage>-stage_key.
          CONTINUE.
        ENDIF.
      ENDIF.

      IF line_exists( lt_settlement_index[ host_key = <fs_stage>-stage_key ] ).
        DELETE lt_settlement_index WHERE host_key <> <fs_stage>-stage_key.
        DATA(lv_stage_key) = <fs_stage>-stage_key.
        EXIT.
      ENDIF.

    ELSE.
      DELETE lt_settlement_index WHERE host_key = <fs_stage>-stage_key.
    ENDIF.
  ENDLOOP.

*  CHECK lt_settlement_index[] IS NOT INITIAL.

  CREATE DATA lr_params.
  lr_params->sfir_settlement_index = lt_settlement_index.
  lr_params->inv_category = /scmtms/if_sfir_c=>sc_category-sfir.
  lr_params->inv_dt = sy-datum.

  " -----------------------------------------------------------------------
  " 1. Verifica se existe uma DFF criada em aberto
  " -----------------------------------------------------------------------
  FREE: lo_srvmgr_tor.
  lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

  lo_srvmgr_tor->retrieve_by_association(
    EXPORTING
      iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
      it_key                  = VALUE #( ( key = lv_tor_key ) )                    " Key Table
      iv_association          = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root " Association
      iv_fill_data            = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
    IMPORTING
      et_data                 = lt_sfir_root ).

  DELETE lt_sfir_root WHERE lifecycle <> '01'  " Em processamento
                        AND lifecycle <> '02'  " Disponível para provisões
                        AND lifecycle <> '03'  " Lançado iniciado
                        AND lifecycle <> '04'. " Lançado

  " Caso exista uma chave de acesso criada, não criar DFF novo
  IF line_exists( lt_sfir_root[ zzacckey  = is_gko_header-acckey lifecycle = '04' ] ).

    RETURN.

  ELSEIF  line_exists( lt_sfir_root[ zzacckey  = is_gko_header-acckey ] ).

    DELETE lt_sfir_root WHERE zzacckey IS INITIAL.
    lt_sfir_keys = CORRESPONDING #( lt_sfir_root MAPPING key = root_key ).
    CHECK lt_sfir_keys[] IS NOT INITIAL.

  ELSE.

    " -----------------------------------------------------------------------
    " 2. Caso não exista DFF, criaremos um novo
    " -----------------------------------------------------------------------
    TRY.
        " Cria SFIR
        lo_srvmgr_tor->do_action(
          EXPORTING
            iv_act_key           = /scmtms/if_tor_c=>sc_action-root-create_sfir
            it_key               = VALUE #( ( key = lv_tor_key ) )
            is_parameters        = lr_params
          IMPORTING
            eo_change            = DATA(lo_change)
            eo_message           = DATA(lo_msg) ).

        IF NOT lo_msg IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO et_return.
            IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
              RETURN.
            ENDIF.
          ENDIF.
          CLEAR lo_msg.
        ENDIF.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.
    DO 3 TIMES.
      WAIT UP TO 2 SECONDS.
    ENDDO.
    " Save
    lr_txm->save( IMPORTING ev_rejected = DATA(lv_rejected)                              " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                            eo_message  = lo_msg                  ).                     " Interface of Message Object

    IF NOT lo_msg IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO et_return.
        IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
          RETURN.
        ENDIF.
      ENDIF.
      CLEAR lo_msg.
    ENDIF.

    DO 3 TIMES.
      WAIT UP TO 2 SECONDS.
    ENDDO.
    lr_txm->cleanup( iv_cleanup_mode = 2 ).

    " -----------------------------------------------------------------------
    " 2.1. Recupera o DFF novo criado
    " -----------------------------------------------------------------------
    TRY.

        FREE: lo_srvmgr_tor.
        lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

        DO 30 TIMES.
          lo_srvmgr_tor->retrieve_by_association(
              EXPORTING
                iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
                it_key                  = VALUE #( ( key = lv_tor_key ) )                    " Key Table
                iv_association          = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root " Association
                iv_fill_data            = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
              IMPORTING
                et_data                 = lt_sfir_root ).

* BEGIN OF INSERT - JWSILVA - 24.03.2023
          DELETE lt_sfir_root WHERE zzacckey IS NOT INITIAL. " Somente considerar o registro novo
* END OF INSERT - JWSILVA - 24.03.2023
          DELETE lt_sfir_root WHERE lifecycle <> '02'  " Ready for Accurals
                                AND lifecycle <> '01'. " In Process

          IF lt_sfir_root[] IS NOT INITIAL.
            EXIT.
          ELSE.
            WAIT UP TO 2 SECONDS.
          ENDIF.
        ENDDO.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    lt_sfir_keys = CORRESPONDING #( lt_sfir_root MAPPING key = root_key ).
    CHECK lt_sfir_keys[] IS NOT INITIAL.

    " -----------------------------------------------------------------------
    " 2.2. Atualiza DFF novo com a chave de acesso
    " -----------------------------------------------------------------------
    LOOP AT lt_sfir_root ASSIGNING FIELD-SYMBOL(<fs_sfir_acckey>).
      <fs_sfir_acckey>-zzacckey = is_gko_header-acckey.
    ENDLOOP.

    CLEAR: lt_changed[].
    APPEND: 'ZZACCKEY' TO lt_changed.

    /scmtms/cl_mod_helper=>mod_update_multi(  EXPORTING it_data           = lt_sfir_root
                                                        iv_bo_key         = /scmtms/if_suppfreightinvreq_c=>sc_bo_key
                                                        iv_node           = /scmtms/if_suppfreightinvreq_c=>sc_node-root
                                                        it_changed_fields = lt_changed
                                               CHANGING ct_mod            = lt_mod ).

    TRY.

        lo_srvmgr_sfir->modify( EXPORTING it_modification = lt_mod                 " Changes
                                IMPORTING eo_message      = lo_msg ).              " Interface of Message Object

        IF NOT lo_msg IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO et_return.
            IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
              RETURN.
            ENDIF.
          ENDIF.
          CLEAR lo_msg.
        ENDIF.

        " Save
        lr_txm->save( IMPORTING ev_rejected = lv_rejected                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                                eo_message  = lo_msg ).                            " Interface of Message Object

        IF NOT lo_msg IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO et_return.
            IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
              RETURN.
            ENDIF.
          ENDIF.
          CLEAR lo_msg.
        ENDIF.

        DO 3 TIMES.
          WAIT UP TO 2 SECONDS.
        ENDDO.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

  ENDIF.

  " -----------------------------------------------------------------------
  " 3. Continua com o processamento da DFF antiga (1.) ou nova (2.)
  " -----------------------------------------------------------------------
  TRY.

      CALL METHOD lo_srvmgr_sfir->do_action
        EXPORTING
          iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-calc_transport_charges
          it_key        = lt_sfir_keys
        IMPORTING
          eo_message    = lo_msg
          et_failed_key = DATA(lt_failed_key).

      IF NOT lo_msg IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
        ENDIF.
        CLEAR lo_msg.
      ENDIF.

      DO 3 TIMES.
        WAIT UP TO 2 SECONDS.
      ENDDO.

      "Call to Static method of SFIR BO
      CALL METHOD lo_srvmgr_sfir->do_action
        EXPORTING
          iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-set_transferred_for_accruals
          it_key        = lt_sfir_keys
        IMPORTING
          eo_message    = lo_msg
          et_failed_key = lt_failed_key.

      IF NOT lo_msg IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
        ENDIF.
        CLEAR lo_msg.
      ENDIF.

      lr_txm->save( IMPORTING ev_rejected = lv_rejected                " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                              eo_message  = lo_msg                  ). " Interface of Message Object

      IF NOT lo_msg IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
        ENDIF.
        CLEAR lo_msg.
      ENDIF.

      DO 3 TIMES.
        WAIT UP TO 2 SECONDS.
      ENDDO.

* Verifica se a DFF teve algum problema na criação, se houve, ao tentar reprocessar pelo cockpit, o programa irá tentar novamente criar a ABD, do contrário, a ABD será criada
*   automaticamente seguindo o fluxo e chamada standard.
      IF line_exists( lt_sfir_root[ confirmation = '13' ] ).
        DATA(lv_check_create_po) = abap_true.
      ELSE.
        lv_check_create_po = abap_false.
      ENDIF.

      DATA(lo_post_sfir) = /scmtms/cl_post_sfir_for_accru=>get_instance( ).
      lo_post_sfir->/scmtms/if_post_sfir_for_accru~post_sfir_for_accurals(
        EXPORTING
          it_sfir_keys   = lt_sfir_keys                                       " Key Table
          iv_save        = abap_true
          iv_create_po   = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          iv_create_ab   = lv_check_create_po
        IMPORTING
          eo_message     = DATA(lo_msg_sfir)                                  " Interface of Message Object
          et_return      = DATA(lt_return_sfir) ).                            " Table with BAPI Return Information

      INSERT LINES OF lt_return_sfir INTO TABLE et_return.

      IF NOT lo_msg_sfir IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg_sfir
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
          IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
            RETURN.
          ENDIF.
        ENDIF.
        CLEAR lo_msg.
      ENDIF.

      DO 3 TIMES.
        WAIT UP TO 2 SECONDS.
      ENDDO.

      CLEAR: lt_sfir_root[].
      lo_srvmgr_sfir->retrieve(
        EXPORTING
          iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root                                   " Node
          it_key                  = lt_sfir_keys                                   " Key Table
        IMPORTING
          et_data                 = lt_sfir_root ).

      IF NOT line_exists( lt_sfir_root[ confirmation = '03' ] ) .

        CALL FUNCTION 'DD_DOMVALUES_GET'
          EXPORTING
            domname        = '/SCMTMS/SFIR_CONFIRM_STATUS'
            text           = abap_true
            langu          = sy-langu
          TABLES
            dd07v_tab      = lt_dd07v
          EXCEPTIONS
            wrong_textflag = 1
            OTHERS         = 2.

        IF sy-subrc = 0.
          DATA(ls_sfir_root) = lt_sfir_root[ 1 ].
          IF line_exists( lt_dd07v[ domvalue_l = ls_sfir_root-confirmation ] ).
            APPEND INITIAL LINE TO et_return ASSIGNING FIELD-SYMBOL(<fs_return>).
            <fs_return>-type       = if_xo_const_message=>error.
            <fs_return>-id         = '00'.
            <fs_return>-number     = '208'.
            <fs_return>-message_v1 = lt_dd07v[ domvalue_l = ls_sfir_root-confirmation ]-ddtext.
*            RETURN.
          ENDIF.
        ENDIF.

        lo_srvmgr_sfir->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root                                   " Node
            it_key                  = lt_sfir_keys                                   " Key Table
            iv_association          = /scmtms/if_suppfreightinvreq_c=>sc_association-root-latest_app_log_messages                                   " Association
            iv_fill_data            = abap_true                         " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_bal_message ).

        LOOP AT lt_bal_message ASSIGNING FIELD-SYMBOL(<fs_bal_message>).
          APPEND INITIAL LINE TO et_return ASSIGNING <fs_return>.
          <fs_return>-type       = <fs_bal_message>-msgty.
          <fs_return>-id         = <fs_bal_message>-msgid.
          <fs_return>-number     = <fs_bal_message>-msgno.
          <fs_return>-message_v1 = <fs_bal_message>-msgv1.
          <fs_return>-message_v2 = <fs_bal_message>-msgv2.
          <fs_return>-message_v3 = <fs_bal_message>-msgv3.
          <fs_return>-message_v4 = <fs_bal_message>-msgv4.
        ENDLOOP.
      ENDIF.

*      WAIT UP TO 20 SECONDS.
*
*      lo_post_sfir->/scmtms/if_post_sfir_for_accru~post_sfir_for_accurals(
*        EXPORTING
*          it_sfir_keys   = lt_sfir_keys                                       " Key Table
*          iv_save        = abap_true
*          iv_create_ab   = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
**          iv_create_ses  = abap_true
*        IMPORTING
*          eo_message     = lo_msg_sfir                                        " Interface of Message Object
*          et_return      = lt_return_sfir ).                                  " Table with BAPI Return Information

*      set_status( iv_status   = gc_codstatus-frete_faturado ).

*      CALL METHOD lo_srvmgr_sfir->do_action
*        EXPORTING
*          iv_act_key    = /scmtms/if_suppfreightinvreq_c=>sc_action-root-set_confirmed_from_erp
*          it_key        = lt_sfir_keys
*        IMPORTING
*          eo_message    = lo_msg
*          et_failed_key = lt_failed_key.
*
*      lr_txm->save( IMPORTING ev_rejected = lv_rejected                " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*                              eo_message  = lo_msg                  ). " Interface of Message Object

    CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
      RETURN.
  ENDTRY.

  lr_txm->cleanup( ).

ENDFUNCTION.
