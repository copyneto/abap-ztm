CLASS zcltm_status_operacao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          is_input TYPE zcltm_mt_intelispost_status.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gs_input    TYPE zcltm_mt_intelispost_status,
          gt_mod      TYPE /bobf/t_frw_modification,
          go_srv_tor  TYPE REF TO /bobf/if_tra_service_manager,
          go_tra_mgr  TYPE REF TO /bobf/if_tra_transaction_mgr,
          gt_messages TYPE bapiret2_tab.

    METHODS:
      process_data,
      save.

ENDCLASS.

CLASS zcltm_status_operacao IMPLEMENTATION.
  METHOD constructor.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
  ENDMETHOD.

  METHOD process_data.

    DATA: lt_docflow      TYPE tdt_docflow,
          lt_root         TYPE /scmtms/t_tor_root_k,
          lt_assigned_fus TYPE /scmtms/t_tor_root_k,
          ls_mod          TYPE /bobf/s_frw_modification.

    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k.

    DATA(lv_numero_nfe) = gs_input-mt_intelispost_status-nvoice_key+25(9).

    SELECT SINGLE FROM j_1bnfe_active
        FIELDS docnum,
               nfnum9
        WHERE nfnum9 = @lv_numero_nfe
        INTO @DATA(ls_1bnfe_active).
    IF sy-subrc = 0.

      SELECT SINGLE FROM i_br_nfdocumentflow_c
          FIELDS br_notafiscal,
                 predecessorreferencedocument
          WHERE br_notafiscal = @ls_1bnfe_active-docnum
          INTO @DATA(ls_nfdocumentflow_c).
      IF sy-subrc = 0.

        DATA(lv_remessa) = ls_nfdocumentflow_c-predecessorreferencedocument.

        CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
          EXPORTING
            iv_docnum  = lv_remessa
          IMPORTING
            et_docflow = lt_docflow.

        SORT lt_docflow BY vbtyp_n.
        READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_o>) WITH KEY vbtyp_n = 'TMFO' BINARY SEARCH.
        IF sy-subrc = 0.
          DATA(lv_ordem_frete) = <fs_docflow_o>-docnum.
        ENDIF.

        READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow_u>) WITH KEY vbtyp_n = 'TMFU' BINARY SEARCH.
        IF sy-subrc = 0.
          DATA(lv_unidade_frete) = <fs_docflow_u>-docnum.
        ENDIF.

        go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
        go_tra_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

        DATA(lv_orde_frete) = '0000000000' && lv_ordem_frete.
        SELECT FROM i_freightordervh
            FIELDS transportationorderuuid
            WHERE freightorder = @lv_orde_frete
            INTO @DATA(lv_transportationorderuuid)
            UP TO 1 ROWS.
        ENDSELECT.

        go_srv_tor->retrieve(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
              it_key                  = VALUE #( ( key = lv_transportationorderuuid ) )
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_root ).

        DATA(lt_keys) = VALUE /bobf/t_frw_key( FOR ls_root IN lt_root ( key = ls_root-key ) ).

        go_srv_tor->retrieve_by_association(
          EXPORTING
            it_key         = lt_keys
            iv_node_key    = /scmtms/if_tor_c=>sc_node-root
            iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
            iv_fill_data   = abap_true
          IMPORTING
            et_data        = lt_assigned_fus ).

        DATA(lt_assigned_fus_key) = VALUE /bobf/t_frw_key( FOR ls_assigned_fus IN lt_assigned_fus ( key = ls_assigned_fus-key ) ).

        DATA: lt_exec TYPE /scmtms/t_tor_exec_k.
        go_srv_tor->retrieve_by_association(
          EXPORTING
              it_key         = lt_assigned_fus_key
              iv_node_key    = /scmtms/if_tor_c=>sc_node-root
              iv_association = /scmtms/if_tor_c=>sc_association-root-exec
              iv_fill_data   = abap_true
          IMPORTING
              et_data        = lt_exec ).

        IF lt_assigned_fus IS NOT INITIAL.

          LOOP AT lt_assigned_fus_key ASSIGNING FIELD-SYMBOL(<fs_assigned_fus_key>).

            ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
            ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
            ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
            ls_mod-source_key   = <fs_assigned_fus_key>-key.
            ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
            ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*          ls_mod-root_key     = lt_root[ 1 ]-key.

            CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
            ASSIGN ls_mod-data->* TO <fs_exec>.

            <fs_exec>-key          = ls_mod-key.
            <fs_exec>-event_code   = gs_input-mt_intelispost_status-event_code.
            <fs_exec>-ext_loc_id   = lt_assigned_fus[ 1 ]-consigneeid.
            <fs_exec>-ext_loc_uuid = lt_assigned_fus[ 1 ]-consignee_key.

*          ls_mod-data = REF #( lt_exec_t ).
            APPEND ls_mod TO gt_mod.

          ENDLOOP.

          IF gt_mod IS NOT INITIAL.

            me->save( ).

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD save.
    DATA: lo_change_action    TYPE REF TO /bobf/if_tra_change,
          lo_message_action   TYPE REF TO /bobf/if_frw_message,
          lt_failed_key       TYPE /bobf/t_frw_key,
          lt_return           TYPE bapiret2_tab,
          lv_rejected         TYPE boole_d,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

    IF gt_mod IS NOT INITIAL.

      go_srv_tor->modify(
        EXPORTING it_modification = gt_mod
        IMPORTING eo_change        = lo_change
                  eo_message       = lo_message ).

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
        EXPORTING
           iv_action_messages = space
           io_message         = lo_message
        CHANGING
           ct_bapiret2 = lt_return
      ).

      IF lt_return IS INITIAL.

        TRY.
            go_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
              IMPORTING ev_rejected            = lv_rejected
                                                  eo_change              = lo_change
                                                  eo_message             = lo_message_save
                                                  et_rejecting_bo_key    = ls_rejecting_bo_key ).
          CATCH cx_sy_ref_is_initial INTO DATA(lo_cx).


        ENDTRY.



        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
            EXPORTING
                iv_action_messages = space
                io_message         = lo_message
            CHANGING
                ct_bapiret2 = lt_return
        ).
        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO gt_messages.
        ENDIF.

      ELSE.
        APPEND LINES OF lt_return TO gt_messages.
      ENDIF.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
