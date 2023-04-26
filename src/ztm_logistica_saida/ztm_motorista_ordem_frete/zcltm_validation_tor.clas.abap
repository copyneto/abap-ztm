class ZCLTM_VALIDATION_TOR definition
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



CLASS ZCLTM_VALIDATION_TOR IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.
*    DATA: lt_root        TYPE /scmtms/t_tor_root_k.
**          lo_cm      TYPE REF TO   cm_bopf_training.
*
*    IF is_ctx-val_time = 'CHECK_BEFORE_SAVE' OR is_ctx-val_time = 'AFTER_MODIFY'.
*
*      io_read->retrieve( EXPORTING iv_node = /scmtms/if_tor_c=>sc_node-root
*                                 it_key  = it_key
*                       IMPORTING et_data = lt_root ).
*      IF lt_root IS NOT INITIAL.
*        DATA(ls_root) = lt_root[ 1 ].
*        DATA(lo_erro) = NEW zcxtm_motorista_tor(
*                                                         textid   = zcxtm_motorista_tor=>zvalid_doc_invalida
*                                                         severity = /bobf/cm_frw=>co_severity_error
*                                                         symptom  = /bobf/if_frw_message_symptoms=>co_bo_inconsistency
*                                                         lifetime = /bobf/if_frw_c=>sc_lifetime_set_by_bopf
**                                                         previous = NEW zcxtm_msg_motorista(
**                                                                                             textid = zcxtm_msg_motorista=>zvalid_doc_invalida
**                                                                                             gv_msgv1 = 'CNH'
**                                                                                            )
*                                                         ms_origin_location  = VALUE #( bo_key = is_ctx-bo_key
*                                                                                        node_key = is_ctx-node_key
*                                                                                        key = ls_root-root_key
*                                                                                      )
*                                                        ).
*
**        eo_message->add_cm(
**                           EXPORTING
**                             io_message =  lo_erro ).
*      ENDIF.
*
*    ENDIF.

    DATA: lt_msg     TYPE /scmtms/t_symsg,
          lt_message TYPE bapirettab.

    IF is_ctx-val_time = 'CHECK_AND_DETERMINE'.

      "Instanciar classe para envio da ordem de frete ao GKO
      DATA(lo_gko) = NEW zcltm_interface_fo_gko( ).
      DATA(lv_ok) = lo_gko->check_all_ok( EXPORTING iv_tor_key  = it_key[ 1 ]-key " NodeID
                                          IMPORTING et_messages = lt_msg ).       " System Messages

      IF lv_ok EQ abap_false.

        lt_message = VALUE #( FOR <fs_msg> IN lt_msg
                            ( type       = <fs_msg>-msgty
                              id         = <fs_msg>-msgid
                              number     = <fs_msg>-msgno
                              message_v1 = <fs_msg>-msgv1
                              message_v2 = <fs_msg>-msgv2
                              message_v3 = <fs_msg>-msgv3
                              message_v4 = <fs_msg>-msgv4 ) ).

        /scmtms/cl_common_helper=>msg_convert_bapiret2_2_bopf(
          EXPORTING
            iv_node_key   = is_ctx-node_key                                       " Node Key
            it_key        = it_key                                                " Key Table
            it_return     = lt_message                                            " Table with BAPI Return Information
          CHANGING
            co_message    = eo_message                                            " Interface of Message Object
            ct_failed_key = et_failed_key ).                                      " Failed Key Table

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
