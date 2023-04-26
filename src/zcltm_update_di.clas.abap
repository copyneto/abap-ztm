CLASS zcltm_update_di DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_common_badi .
    INTERFACES /scmtms/if_tcd_update_di .
    INTERFACES if_badi_interface .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_update_di IMPLEMENTATION.


  METHOD /scmtms/if_common_badi~set_badi_work_mode.
    RETURN.
  ENDMETHOD.


  METHOD /scmtms/if_tcd_update_di~unassign_di.

    CHECK it_distr_item IS NOT INITIAL.

    DATA(lo_sfir_serv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key ).
    DATA: lt_sfir_items TYPE /scmtms/t_sfir_item_k.
    lo_sfir_serv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root
        it_key                  = VALUE #( ( key = is_distr_root-host_key ) )
        iv_association          = /scmtms/if_suppfreightinvreq_c=>sc_association-root-item
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_sfir_items
    ).
    CHECK lt_sfir_items IS NOT INITIAL.
    SELECT _distr_item~key, _distr_item~ref_root_key, _torrite~des_stop_key, _torrite~src_stop_key, _torrite~base_btd_tco
    FROM /scmtms/d_torite AS _torrite
    INNER JOIN @it_distr_item AS _distr_item
    ON _torrite~db_key = _distr_item~ref_key
    INTO TABLE @DATA(lt_dest_stop_keys).

    LOOP AT lt_dest_stop_keys ASSIGNING FIELD-SYMBOL(<fs_dest_stop_keys>).
      READ TABLE it_tcd_comm_root ASSIGNING FIELD-SYMBOL(<fs_tcd_comm_root>) WITH KEY key COMPONENTS key = <fs_dest_stop_keys>-ref_root_key.
      IF sy-subrc = 0.
        LOOP AT lt_sfir_items ASSIGNING FIELD-SYMBOL(<fs_lt_sfir_items>). "#EC CI_NESTED.
          LOOP AT <fs_tcd_comm_root>-stage ASSIGNING FIELD-SYMBOL(<fs_stage>) "#EC CI_NESTED
          WHERE key = <fs_lt_sfir_items>-tor_stage_key . "#EC CI_STDSEQ
            IF <fs_dest_stop_keys>-base_btd_tco = '58' AND
               <fs_stage>-start_stop_key <> <fs_dest_stop_keys>-src_stop_key.
              APPEND VALUE #(
                key = <fs_dest_stop_keys>-key
              ) TO ct_invalid_di_key.
            ELSE.
              IF <fs_stage>-end_stop_key <> <fs_dest_stop_keys>-des_stop_key.
                APPEND VALUE #(
                  key = <fs_dest_stop_keys>-key
                ) TO ct_invalid_di_key.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
