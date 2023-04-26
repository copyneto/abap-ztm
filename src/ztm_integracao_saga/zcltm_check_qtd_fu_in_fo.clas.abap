class ZCLTM_CHECK_QTD_FU_IN_FO definition
  public
  inheriting from /BOBF/CL_LIB_V_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_VALIDATION~EXECUTE
    redefinition .
protected section.
private section.

  methods CHECK_FO_TYPE_1030
    importing
      !IS_CTX type /BOBF/S_FRW_CTX_VAL
      !IT_KEY type /BOBF/T_FRW_KEY
      !IO_READ type ref to /BOBF/IF_FRW_READ
    exporting
      !EO_MESSAGE type ref to /BOBF/IF_FRW_MESSAGE
      !ET_FAILED_KEY type /BOBF/T_FRW_KEY .
  methods CHECK_FO_STATUS_100
    importing
      !IS_CTX type /BOBF/S_FRW_CTX_VAL
      !IT_TOR_DATA type /SCMTMS/T_TOR_ROOT_K
      !IT_KEY type /BOBF/T_FRW_KEY
      !IO_READ type ref to /BOBF/IF_FRW_READ
    exporting
      !EO_MESSAGE type ref to /BOBF/IF_FRW_MESSAGE
      !ET_FAILED_KEY type /BOBF/T_FRW_KEY .
ENDCLASS.



CLASS ZCLTM_CHECK_QTD_FU_IN_FO IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA: lt_tor_root   TYPE /scmtms/t_tor_root_k.

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key
        it_key                  = it_key
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_tor_root    ).

    IF line_exists( lt_tor_root[ tor_cat = /scmtms/if_tor_const=>sc_tor_category-active ]  ).       "#EC CI_SORTSEQ
      DATA(ls_tor_root) = lt_tor_root[ tor_cat = /scmtms/if_tor_const=>sc_tor_category-active ].    "#EC CI_SORTSEQ

      IF lt_tor_root[ tor_cat = /scmtms/if_tor_const=>sc_tor_category-active ]-tor_type EQ '1030'.  "#EC CI_SORTSEQ

        me->check_fo_type_1030(
          EXPORTING
            is_ctx        = is_ctx           " Context Information for Validations
            it_key        = it_key           " Key Table
            io_read       = io_read          " Interface to Read Data
          IMPORTING
            eo_message    = eo_message       " Interface of Message Object
            et_failed_key = et_failed_key ). " Key Table

        CHECK et_failed_key[] IS INITIAL.
      ENDIF.

      me->check_fo_status_100(
        EXPORTING
          is_ctx        = is_ctx           " Context Information for Validations
          it_tor_data   = lt_tor_root      " TOR Root
          it_key        = it_key           " Key Table
          io_read       = io_read          " Interface to Read Data
        IMPORTING
          eo_message    = eo_message       " Interface of Message Object
          et_failed_key = et_failed_key ). " Key Table

    ENDIF.

  ENDMETHOD.


  METHOD check_fo_status_100.

    IF line_exists( it_tor_data[ zz_code = '100' ] ). "#EC CI_SORTSEQ

      et_failed_key[] = it_key[].
      MESSAGE e000(su) WITH TEXT-003 "'FO com MDF-e Aprovado,'
                            TEXT-004 "'inserção de FU não permitida'
                            INTO DATA(lv_text).

      CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
        EXPORTING
          iv_key       = et_failed_key[ 1 ]-key
          iv_node_key  = /scmtms/if_tor_c=>sc_node-root
          iv_probclass = /scmtms/cl_applog_helper=>sc_al_probclass_very_important
        CHANGING
          co_message   = eo_message.

    ENDIF.

  ENDMETHOD.


  METHOD check_fo_type_1030.

    DATA: lt_fu_assign TYPE /scmtms/t_tor_root_k.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    TRY.
        lo_tor_mgr->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
            it_key                  = it_key                                             " Key Table
            iv_association          = /scmtms/if_tor_c=>sc_association-root-assigned_fus " Association
            iv_fill_data            = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_fu_assign ).
      CATCH /bobf/cx_frw_contrct_violation.                                              " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    DATA(lt_fu) = VALUE /scmtms/t_tor_root_k( FOR <fs_fu> IN lt_fu_assign WHERE
                                            ( tor_cat = /scmtms/if_tor_const=>sc_tor_category-freight_unit )
                                            ( CORRESPONDING #( <fs_fu> ) ) ). "#EC CI_SORTSEQ

    IF lines( lt_fu ) >= 1.

      et_failed_key[] = it_key[].
      MESSAGE e000(su) WITH TEXT-001 "'Não permitido mais de uma FU'
                            TEXT-002 "'em FO tipo'
                            '1030' INTO DATA(lv_text).

      CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
        EXPORTING
          iv_key       = et_failed_key[ 1 ]-key
          iv_node_key  = /scmtms/if_tor_c=>sc_node-root
          iv_probclass = /scmtms/cl_applog_helper=>sc_al_probclass_very_important
        CHANGING
          co_message   = eo_message.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
