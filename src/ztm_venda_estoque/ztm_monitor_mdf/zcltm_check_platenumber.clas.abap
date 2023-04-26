class ZCLTM_CHECK_PLATENUMBER definition
  public
  inheriting from /BOBF/CL_LIB_V_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_VALIDATION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_CHECK_PLATENUMBER IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    RETURN.

    DATA: lt_tor_root     TYPE /scmtms/t_tor_root_k,
          lt_tor_item_new TYPE /scmtms/t_tor_item_tr_k,
          lt_tor_item_old TYPE /scmtms/t_tor_item_tr_k,
          lt_msg          TYPE /scmtms/t_symsg,
          lt_message      TYPE bapirettab.

    CHECK is_ctx-val_time = 'CHECK_BEFORE_SAVE' OR
          is_ctx-val_time = 'CHECK'             OR
          is_ctx-val_time = 'AFTER_MODIFY'.

    io_read->retrieve(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-item_tr " Node Name
        it_key                  = it_key " Key Table
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_tor_item_new ).

    io_read->retrieve(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-item_tr " Node Name
        it_key                  = it_key " Key Table
        iv_before_image         = abap_true
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_tor_item_old ).


    DATA(lv_check_platenumber) = abap_false.

    LOOP AT lt_tor_item_new INTO DATA(ls_item_new).
      IF line_exists( lt_tor_item_old[ key = ls_item_new-key ] ).

        DATA(ls_item_old) = lt_tor_item_old[ key = ls_item_new-key ].

        IF ls_item_new-platenumber NE ls_item_old-platenumber.
          lv_check_platenumber = abap_true.
        ENDIF.
      ELSE.
        lv_check_platenumber = abap_true.
      ENDIF.
    ENDLOOP.

    CHECK lv_check_platenumber = abap_true.

    io_read->retrieve_by_association(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-item_tr                " Node Name
        it_key                  = it_key                                           " Key Table
        iv_association          = /scmtms/if_tor_c=>sc_association-item_tr-to_root " Name of Association
        iv_fill_data            = abap_true                                        " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
      IMPORTING
        et_data                 = lt_tor_root ).                                   " Data Return Structure

    IF line_exists( lt_tor_root[ zz_code = '100' ] ).   "#EC CI_SORTSEQ

      et_failed_key[] = it_key[].
      MESSAGE e000(su) WITH TEXT-001 "'FO com MDF-e Aprovado,'
                            TEXT-002 "'troca de placa não permitida.'
                            INTO DATA(lv_text).

      CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
        EXPORTING
          iv_key       = et_failed_key[ 1 ]-key
          iv_node_key  = /scmtms/if_tor_c=>sc_node-item_tr
          iv_probclass = /scmtms/cl_applog_helper=>sc_al_probclass_very_important
          iv_attribute = /scmtms/if_tor_c=>sc_node_attribute-item_tr-platenumber
        CHANGING
          co_message   = eo_message.

*      lt_message = VALUE #( ( type       = if_xo_const_message=>error
*                              id         = 'SU'
*                              number     = '000'
*                              message_v1 = TEXT-001
*                              message_v2 = TEXT-002 ) ).
*
*      /scmtms/cl_common_helper=>msg_convert_bapiret2_2_bopf(
*        EXPORTING
*          iv_node_key   = is_ctx-node_key                                       " Node Key
*          it_key        = it_key                                                " Key Table
*          it_return     = lt_message                                            " Table with BAPI Return Information
*        CHANGING
*          co_message    = eo_message                                            " Interface of Message Object
*          ct_failed_key = et_failed_key ).                                      " Failed Key Table

      "Code value '&1' contains invalid characters
*              MESSAGE e121(/scmtms/msg) WITH <forkey_val> INTO lv_msg.
*              /scmtms/cl_common_helper=>msg_helper_add_symsg(
*                EXPORTING
*                  iv_key               = <fs_key>
*                  iv_node_key          = is_ctx-node_key
*                  iv_attribute         = <fs_code_value_key>-attribute_name
*                CHANGING
*                  co_message           = co_message ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
