FUNCTION zfmtm_gko_check_dff.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_TORID) TYPE  /SCMTMS/TOR_ID
*"     VALUE(IV_ACCKEY) TYPE  J_1B_NFE_ACCESS_KEY_DTEL44
*"  EXPORTING
*"     VALUE(EV_CHECK) TYPE  ABAP_BOOLEAN
*"     VALUE(ET_SFIR_ID) TYPE  /SCMTMS/T_SFIR_ID
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  " Tabelas
  DATA: lt_sfir_root   TYPE /scmtms/t_sfir_root_k,
        lt_return      TYPE bapiret2_tab,
        lt_dd07v       TYPE TABLE OF dd07v,
        lt_bal_message TYPE /bofu/t_bal_message_k,
        lr_params      TYPE REF TO /scmtms/s_sfir_a_post_docs.

  " Variáveis
  DATA: lv_tor_key      TYPE /bobf/conf_key.

  TRY.

      CLEAR: ev_check, et_sfir_id, et_return.

      " Buscar TOR Key
      lv_tor_key = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = iv_torid ).

      " Buscar SFIR
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root                                     " Node
          it_key                  = VALUE #( ( key = lv_tor_key ) )                                    " Key Table
          iv_association          = /scmtms/if_tor_c=>sc_association-root-bo_sfir_root                 " Association
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_sfir_root ).

      DELETE lt_sfir_root WHERE lifecycle NE '03'.      " Lançamento iniciado
      DELETE lt_sfir_root WHERE zzacckey NE iv_acckey.  " Chave de acesso

      IF lt_sfir_root IS INITIAL.
        ev_check   = abap_true.
        RETURN.
      ENDIF.

      et_sfir_id = VALUE #( FOR ls_sfir IN lt_sfir_root ( ls_sfir-sfir_id ) ).

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->do_action(
        EXPORTING
          iv_act_key              = /scmtms/if_suppfreightinvreq_c=>sc_action-root-reprocess_sfir_int_stat       " Action
          it_key                  = CORRESPONDING #( lt_sfir_root MAPPING key = key )                            " Key Table
        IMPORTING
          eo_message              = DATA(lo_msg) ).

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->do_action(
        EXPORTING
          iv_act_key              = /scmtms/if_suppfreightinvreq_c=>sc_action-root-set_ses_abd_posting_initiated " Action
          it_key                  = CORRESPONDING #( lt_sfir_root MAPPING key = key )                            " Key Table
        IMPORTING
          eo_message              = lo_msg ).

      CREATE DATA lr_params.
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->do_action(
        EXPORTING
          iv_act_key              = /scmtms/if_suppfreightinvreq_c=>sc_action-root-post_follow_on_docs " Action
          it_key                  = CORRESPONDING #( lt_sfir_root MAPPING key = key )                  " Key Table
          is_parameters           = lr_params                                                          " Action
        IMPORTING
          eo_message              = lo_msg ).                                                          " Interface of Message Object

      IF NOT lo_msg IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
          CHECK NOT line_exists( lt_return[ type = if_xo_const_message=>error ] ).
        ENDIF.
        CLEAR lo_msg.
      ENDIF.

      /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message =  lo_msg ).

      IF NOT lo_msg IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_msg
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO et_return.
          CHECK NOT line_exists( lt_return[ type = if_xo_const_message=>error ] ).
        ENDIF.
        CLEAR lo_msg.
      ENDIF.

      WAIT UP TO 6 SECONDS.

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->retrieve(
        EXPORTING
          iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root                                   " Node
          it_key                  = CORRESPONDING #( lt_sfir_root MAPPING key = key )                              " Key Table
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

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_suppfreightinvreq_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root                                   " Node
            it_key                  = CORRESPONDING #( lt_sfir_root MAPPING key = key )                              " Key Table
            iv_association          = /scmtms/if_suppfreightinvreq_c=>sc_association-root-latest_app_log_messages    " Association
            iv_fill_data            = abap_true
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

    CATCH /bobf/cx_frw_contrct_violation.                                              " Caller violates a BOPF contract
      RETURN.
  ENDTRY.

ENDFUNCTION.
