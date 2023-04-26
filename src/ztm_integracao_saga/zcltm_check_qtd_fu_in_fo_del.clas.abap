class ZCLTM_CHECK_QTD_FU_IN_FO_DEL definition
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



CLASS ZCLTM_CHECK_QTD_FU_IN_FO_DEL IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA: lt_tor_root TYPE /scmtms/t_tor_root_k,
          lt_tor_item TYPE /scmtms/t_tor_item_tr_k.

    io_read->retrieve(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-item_tr " Node Name
        it_key                  = it_key " Key Table
      IMPORTING
        et_data                 = lt_tor_item ).

    io_read->retrieve_by_association(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-item_tr " Node Name
        it_key                  = it_key             " Key Table
        iv_association          = /scmtms/if_tor_c=>sc_association-item_tr-to_root " Name of Association
        iv_fill_data            = abap_true       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
      IMPORTING
        et_data                 = lt_tor_root ).              " Data Return Structure

    IF line_exists( lt_tor_root[ zz_code = '100' ] ). "#EC CI_SORTSEQ

      et_failed_key[] = it_key[].
      MESSAGE e000(su) WITH TEXT-001 "'FO com MDF-e Aprovado,'
                            TEXT-002 "'exclusão de FU não permitida'
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
ENDCLASS.
