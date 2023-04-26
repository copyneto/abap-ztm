CLASS zcltm_imp_def_doc_tm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_fsd_type .
    INTERFACES if_badi_interface .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLTM_IMP_DEF_DOC_TM IMPLEMENTATION.


  METHOD /scmtms/if_fsd_type~get_fsd_type.

    DATA ls_key TYPE /scmtms/s_tor_root_k.
    DATA ls_root TYPE /scmtms/s_tor_root.

    DATA lt_key TYPE /scmtms/t_tor_id.
*    DATA lt_key TYPE /scmtms/t_tor_root_k.
    DATA lt_stop TYPE /scmtms/t_tor_stop_k.
    DATA lt_loc TYPE /scmtms/t_bo_loc_root_k.
    DATA lt_loc_busca TYPE /scmtms/t_bo_loc_root_k.
    DATA lt_item_tr TYPE /scmtms/t_tor_item_tr_k.
    DATA lt_key_ret TYPE /bobf/t_frw_key.
    DATA lt_key_root TYPE /bobf/t_frw_key.
    DATA lt_root_data TYPE /scmtms/t_tor_root_k.

    DATA lo_message TYPE REF TO /bobf/if_frw_message.

    CONSTANTS gc_resp_frete TYPE ze_param_chave VALUE 'RESPONSAVEL_FRETE'.
    CONSTANTS gc_outbound TYPE ze_param_chave VALUE 'OUTBOUND'.
    CONSTANTS gc_fsd_type TYPE ze_param_chave VALUE 'FSD_TYPE'.
    CONSTANTS gc_tm TYPE ze_param_modulo VALUE 'TM'.
    CONSTANTS gc_1003 TYPE char4 VALUE '1003'.
    CONSTANTS gc_i TYPE char1 VALUE 'I'.
    CONSTANTS gc_f TYPE char1 VALUE 'F'.
    CONSTANTS gc_l TYPE char1 VALUE 'L'.
    CONSTANTS gc_eq TYPE char2 VALUE 'EQ'.
    CONSTANTS gc_trqtr TYPE char5 VALUE 'TRQTR'.

    DATA lr_seq_pos TYPE RANGE OF /scmtms/stop_seq_pos.
    DATA lr_loc_code TYPE RANGE OF /scmtms/location_type_code.
    DATA lr_icoterm TYPE RANGE OF /scmtms/inc_class_code.
    DATA lr_fsd_type TYPE RANGE OF /scmtms/sfir_type.

    "Jefferson
    DATA lv_fsd_type TYPE /scmtms/sfir_type.

    FIELD-SYMBOLS: <gfs_stop> LIKE LINE OF lt_stop.

    DATA lv_selecao2 TYPE boolean.
    DATA lv_locid TYPE /scmtms/location_id.


    DATA(lo_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
          /scmtms/if_tor_c=>sc_bo_key ).

    IF is_fo_root-tor_id IS NOT INITIAL.

      APPEND INITIAL LINE TO lt_key ASSIGNING FIELD-SYMBOL(<fs_key2>).
      <fs_key2> = is_fo_root-tor_id.

      TRY.

          lo_srv_mgr->convert_altern_key(
            EXPORTING
              iv_invalidate_cache  = abap_true
              iv_node_key          =  /scmtms/if_tor_c=>sc_node-root
              iv_altkey_key        = /scmtms/if_tor_c=>sc_alternative_key-root-tor_id
              it_key               = lt_key
            IMPORTING
              et_key               = lt_key_root
          ).


          "@@ Acessar Root
          lo_srv_mgr->retrieve(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
              it_key                  = lt_key_root
            IMPORTING
              et_data                 = lt_root_data
          ).


          "@@ Acessar STOP
          lo_srv_mgr->retrieve_by_association(
            EXPORTING
            iv_node_key    = /scmtms/if_tor_c=>sc_node-root
            it_key         = lt_key_root
            iv_association = /scmtms/if_tor_c=>sc_association-root-stop
            iv_fill_data   = abap_true
            iv_edit_mode   = /bobf/if_conf_c=>sc_edit_read_only
            IMPORTING
            et_data        = lt_stop
            eo_message     = lo_message ).

          "@@ Parada inicial e Final
          lr_seq_pos = VALUE #( sign = gc_i
                                 option = gc_eq
                                ( low = gc_f )
                                ( low = gc_l ) ).
          DELETE lt_stop WHERE stop_seq_pos NOT IN lr_seq_pos.

          lr_loc_code = VALUE #( ( sign = gc_i
                                 option = gc_eq
                                 low = gc_1003 ) ) .

          CLEAR lt_key_ret.

          LOOP AT lt_stop ASSIGNING <gfs_stop>.

            CLEAR: lt_key_ret,
                   lt_loc_busca.

            APPEND INITIAL LINE TO lt_key_ret ASSIGNING FIELD-SYMBOL(<fs_key>).
            <fs_key>-key = <gfs_stop>-key.

            "@@ Acessar Location por STOP
            lo_srv_mgr->retrieve_by_association(
              EXPORTING
              iv_node_key    = /scmtms/if_tor_c=>sc_node-stop
              it_key         = lt_key_ret
              iv_association = /scmtms/if_tor_c=>sc_association-stop-bo_loc_log
              iv_fill_data   = abap_true
              iv_edit_mode   = /bobf/if_conf_c=>sc_edit_read_only
              IMPORTING
              et_data        = lt_loc_busca
              eo_message     = lo_message ).

            APPEND LINES OF lt_loc_busca TO lt_loc.

          ENDLOOP.

          "@@ Parametros
*          DATA(lo_param) = NEW zclca_tabela_parametros( ).

*          DELETE lt_loc WHERE location_type_code NOT IN lr_loc_code.

          "@@ Verifica se as plantas são da 3Coracoes
          IF lines( lt_loc ) > 0 .

            READ TABLE lt_stop WITH KEY stop_seq_pos = gc_f ASSIGNING <gfs_stop>.
            IF sy-subrc = 0.

              lo_srv_mgr->retrieve_by_association(
              EXPORTING
              iv_node_key    = /scmtms/if_tor_c=>sc_node-root
              it_key         = lt_key_root
              iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
              iv_fill_data   = abap_true
              iv_edit_mode   = /bobf/if_conf_c=>sc_edit_read_only
              IMPORTING
              et_data        = lt_item_tr
              eo_message     = lo_message ).


              LOOP AT lt_item_tr ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE src_stop_key = <gfs_stop>-key
                                                                        AND orig_ref_bo = gc_trqtr
                                                                        AND item_cat = 'PRD'.


*                DATA(lv_pedido) = CONV ebeln( |{ <fs_item>-buyorig_btd_id ALPHA = OUT }| ).
*
*                SELECT SINGLE werks INTO @DATA(lv_centro)
*                  FROM ekpo
*                   WHERE ebeln = @lv_pedido.
*
*                IF sy-subrc IS NOT INITIAL.
*                  lv_centro = <fs_item>-erp_plant_id.
*                ENDIF.

                " Incio teste Jefferson.
                SELECT SINGLE sfir_type INTO @lv_fsd_type
                   FROM /scmtms/c_sfir_t
*                    WHERE plant  = @lv_centro AND sfir_category = '10'.
                    WHERE plant  = @<fs_item>-erp_plant_id AND sfir_category = '10'.
                " Fim teste Jefferson

                IF sy-subrc = 0
                  AND lv_fsd_type IS NOT INITIAL.

                  cs_sfirdtype-fsd_type = lv_fsd_type.
                  RETURN.

                ENDIF.

              ENDLOOP.

            ENDIF.

          ELSE.

            READ TABLE lt_stop INDEX 1 ASSIGNING <gfs_stop>.
            IF sy-subrc = 0.
              lv_locid = <gfs_stop>-log_locid.
            ENDIF.

          ENDIF.

        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
