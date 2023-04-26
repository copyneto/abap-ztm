FUNCTION zfmtm_gko_faturar_etapa_2.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_TORID) TYPE  /SCMTMS/TOR_ID
*"     VALUE(IV_DEST_COD) TYPE  ZE_GKO_DEST_COD
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
*          lr_txm           TYPE REF TO /bobf/if_tra_transaction_mgr,
        lt_sfir_keys_final TYPE /bobf/t_frw_key,
        lt_tor_for_charges TYPE /scmtms/t_tor_q_chargedata,
        lr_params          TYPE REF TO /scmtms/s_sfir_input_params,
        lr_param_sfir      TYPE REF TO /scmtms/s_sfir_a_post_docs,
        lt_itab_list       TYPE TABLE OF abaplist,
        lt_seltab          TYPE TABLE OF rsparams.

  DATA: BEGIN OF lt_vlist OCCURS 0,
          filler1(01) TYPE c,
          field1(06)  TYPE c,
          filler(08)  TYPE c,
          field2(10)  TYPE c,
          filler3(01) TYPE c,
          field3(10)  TYPE c,
          filler4(01) TYPE c,
          field4(3)   TYPE c,
          filler5(02) TYPE c,
          field5(15)  TYPE c,
          filler6(02) TYPE c,
          field6(30)  TYPE c,
          filler7(43) TYPE c,
          field7(10)  TYPE c,
        END OF lt_vlist.

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
  lv_tor_key = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = iv_torid ).

  " Busca TOR Data
  CALL METHOD /scmtms/cl_tor_helper_common=>get_tor_data
    EXPORTING
      it_root_key = VALUE #( ( key = lv_tor_key ) )
    IMPORTING
      et_root     = lt_tor_root.

  CHECK lt_tor_root[] IS NOT INITIAL.

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

  LOOP AT lt_stage ASSIGNING FIELD-SYMBOL(<fs_stage>).
    IF <fs_stage>-dest_stop-log_locid EQ iv_dest_cod.
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

  CHECK lt_settlement_index[] IS NOT INITIAL.

  CREATE DATA lr_params.
  lr_params->sfir_settlement_index = lt_settlement_index.
  lr_params->inv_category = /scmtms/if_sfir_c=>sc_category-sfir.
  lr_params->inv_dt = sy-datum.
  DO 3 TIMES.
    WAIT UP TO 2 SECONDS.
  ENDDO.
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

    CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
      RETURN.
  ENDTRY.
  DO 3 TIMES.
    WAIT UP TO 2 SECONDS.
  ENDDO.
  " Save
  lr_txm->save( IMPORTING ev_rejected = DATA(lv_rejected)                              " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                          eo_message  = lo_msg                  ).                     " Interface of Message Object
  DO 3 TIMES.
    WAIT UP TO 2 SECONDS.
  ENDDO.
  lr_txm->cleanup( iv_cleanup_mode = 2 ).

  TRY.

      FREE: lo_srvmgr_tor.
      lo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

      DO 30 TIMES.
        lo_srvmgr_tor->retrieve_by_association(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
              it_key                  = VALUE #( ( key = lv_tor_key ) )                    " Key Table
              iv_association          = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root " Association
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_sfir_root ).

        DELETE lt_sfir_root WHERE lifecycle <> '02' "Ready for Accurals
                              AND lifecycle <> '01'. "In Process

        IF lt_sfir_root[] IS NOT INITIAL.
          EXIT.
        ELSE.
          WAIT UP TO 2 SECONDS.
        ENDIF.
      ENDDO.

      IF lt_sfir_root[] IS NOT INITIAL.

        LOOP AT lt_sfir_root ASSIGNING FIELD-SYMBOL(<fs_sfir_root>).
          APPEND INITIAL LINE TO lt_seltab ASSIGNING FIELD-SYMBOL(<fs_param>).
          <fs_param>-selname = 'SO_SF_ID'.
          <fs_param>-sign    = /bobf/if_conf_c=>sc_sign_option_including.
          <fs_param>-option  = /bobf/if_conf_c=>sc_sign_equal.
          <fs_param>-low     = <fs_sfir_root>-sfir_id.
        ENDLOOP.

        SUBMIT /scmtms/sfir_transfer_batch WITH SELECTION-TABLE lt_seltab
          VIA SELECTION-SCREEN EXPORTING LIST TO MEMORY AND RETURN .

        CALL FUNCTION 'LIST_FROM_MEMORY'
          TABLES
            listobject = lt_itab_list
          EXCEPTIONS
            not_found  = 1
            OTHERS     = 2.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.

        CALL FUNCTION 'LIST_TO_ASCI'
          TABLES
            listasci           = lt_vlist
            listobject         = lt_itab_list
          EXCEPTIONS
            empty_list         = 1
            list_index_invalid = 2
            OTHERS             = 3.

        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
      ENDIF.

    CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
      RETURN.
  ENDTRY.

ENDFUNCTION.
