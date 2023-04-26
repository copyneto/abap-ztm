CLASS zcltm_tcd_dist_rule_hie_lvls DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_tcd_distr_rule .
    INTERFACES if_badi_interface .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ts_item_total,
        parent_key TYPE /scmtms/d_torite-parent_key,
        value      TYPE /scmtms/d_torite-amt_gdsv_val,
      END OF ts_item_total .
    TYPES:
      tt_item_total TYPE TABLE OF ts_item_total WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ts_item_tor_tr,
        db_key       TYPE /scmtms/d_torite-db_key,
        parent_key   TYPE /scmtms/d_torite-parent_key,
        qua_pcs_val  TYPE /scmtms/d_torite-qua_pcs_val,
        amt_gdsv_val TYPE /scmtms/d_torite-amt_gdsv_val,
      END OF ts_item_tor_tr .
    TYPES:
      tt_item_tor_tr TYPE TABLE OF ts_item_tor_tr WITH DEFAULT KEY .

    DATA mt_item_tor_tr TYPE /scmtms/t_tor_item_tr_k .
    DATA mt_item_total TYPE tt_item_total .

    METHODS retrive_tor_item_tr
      IMPORTING
        !it_tcd_comm_root TYPE /scmtms/t_tcd_comm_root .
    METHODS totalize_item_tor_tr .
    METHODS get_total_item_value
      IMPORTING
        !iv_key          TYPE /bobf/conf_key
      RETURNING
        VALUE(rv_result) TYPE /scmtms/amt_goodsvalue_val .
    METHODS get_item_value
      IMPORTING
        !iv_key          TYPE /bobf/conf_key
      RETURNING
        VALUE(rv_result) TYPE /scmtms/amt_goodsvalue_val .
    METHODS get_stops_end
      RETURNING
        VALUE(rt_result) TYPE /bobf/t_frw_key .
    METHODS get_item_tor_tr
      RETURNING
        VALUE(rt_result) TYPE /scmtms/t_tor_item_tr_k .
    METHODS get_item_tor_tr_line
      IMPORTING
        !iv_key          TYPE /bobf/conf_key
      RETURNING
        VALUE(rs_result) TYPE /scmtms/s_tor_item_tr_k .
ENDCLASS.



CLASS ZCLTM_TCD_DIST_RULE_HIE_LVLS IMPLEMENTATION.


  METHOD /scmtms/if_tcd_distr_rule~determine_quantity.
*    Retrive TOR item TR
    me->retrive_tor_item_tr( it_tcd_comm_root ).
*
    LOOP AT it_tcd_root ASSIGNING FIELD-SYMBOL(<ls_tcd_root>).

*  Extract only the External Cost Dist instance.
      IF <ls_tcd_root>-distr_cat = /scmtms/if_tcd_constants=>gc_distr_cat-external_charges.


*  For Root level charge elements perform distribution by others .
        LOOP AT it_charge_elements ASSIGNING FIELD-SYMBOL(<ls_charge_elements>).
          APPEND INITIAL LINE TO et_ch_el_rule ASSIGNING FIELD-SYMBOL(<ls_ch_el_rule>).
          <ls_ch_el_rule>-key = <ls_charge_elements>-key.
          <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-other.
        ENDLOOP.

*  For all the items pass the pieces information. And for rest of the charge elements consider the distribution rule as others.
        LOOP AT it_tcd_comm_root ASSIGNING FIELD-SYMBOL(<ls_tcd_comm_root>).
          LOOP AT <ls_tcd_comm_root>-item ASSIGNING FIELD-SYMBOL(<ls_tcd_comm_item>)
               WHERE parent_key = <ls_tcd_comm_root>-key.
            APPEND INITIAL LINE TO et_item_qty_rule_link ASSIGNING FIELD-SYMBOL(<ls_item_qty_rule_link>).
            <ls_item_qty_rule_link>-key = <ls_tcd_comm_item>-key.
            APPEND INITIAL LINE TO <ls_item_qty_rule_link>-quantity ASSIGNING FIELD-SYMBOL(<ls_item_qty>).
            <ls_item_qty>-qty     = me->get_item_tor_tr_line( <ls_tcd_comm_item>-key )-amt_gdsv_val.
            <ls_item_qty>-qty_uni = me->get_item_tor_tr_line( <ls_tcd_comm_item>-key )-amt_gdsv_cur.
            <ls_item_qty>-distr_rule = /scmtms/if_tcd_constants=>gc_distr_rule-other.
            <ls_item_qty_rule_link>-root_key = <ls_tcd_comm_item>-root_key.
            <ls_item_qty_rule_link>-ref_key = <ls_tcd_comm_root>-ref_key.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_item_tor_tr.
    rt_result = me->mt_item_tor_tr.
  ENDMETHOD.


  METHOD get_item_tor_tr_line.
    TRY.
        DATA(lt_item_tor_tr) = me->get_item_tor_tr( ).
        rs_result = lt_item_tor_tr[ key = iv_key ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD get_item_value.
    TRY.
        rv_result = me->mt_item_tor_tr[ key = iv_key ]-amt_gdsv_val. "#EC CI_STDSEQ
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD get_stops_end.
    DATA(lt_key) = CORRESPONDING /bobf/t_frw_key( me->get_item_tor_tr( ) MAPPING key = root_key ).
    SORT lt_key.
    DELETE ADJACENT DUPLICATES FROM lt_key.

    DATA(lo_srv_man) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA lt_d_stop_succ TYPE /scmtms/t_tor_stop_succ_k.
    lo_srv_man->retrieve_by_association( EXPORTING it_key         = lt_key
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-stop_succ
                                                   iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   iv_fill_data   = abap_true
                                         IMPORTING et_target_key  = DATA(lt_tcc_k)
                                                   et_data        = lt_d_stop_succ ).

    rt_result = CORRESPONDING #( lt_d_stop_succ MAPPING key = succ_stop_key ).
  ENDMETHOD.


  METHOD get_total_item_value.
    TRY.
        rv_result = me->mt_item_total[ parent_key = iv_key ]-value. "#EC CI_STDSEQ
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.


  METHOD retrive_tor_item_tr.
    IF it_tcd_comm_root IS NOT INITIAL.
      DATA(lo_srv_man) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
      lo_srv_man->retrieve_by_association( EXPORTING it_key         = VALUE #( FOR ls_tcd_comm_root IN it_tcd_comm_root ( key = ls_tcd_comm_root-key ) )
                                                     iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                     iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                     iv_fill_data   = abap_true
                                           IMPORTING et_target_key  = DATA(lt_tcc_k)
                                                     et_data        = me->mt_item_tor_tr ).
    ENDIF.
  ENDMETHOD.


  METHOD totalize_item_tor_tr.
    DATA(lt_item_tor_tr) = me->get_item_tor_tr( ).
    DO lines( lt_item_tor_tr ) TIMES.
      DATA(ls_item_tor_tr) = lt_item_tor_tr[ sy-index ].
      COLLECT VALUE ts_item_total( parent_key      = ls_item_tor_tr-item_parent_key
                                   value           = ls_item_tor_tr-amt_gdsv_val )
                                   INTO me->mt_item_total.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
