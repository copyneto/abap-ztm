class ZCL_TM_TCD_DIST_RULE_HIE definition
  public
  final
  create public .

public section.

  interfaces /SCMTMS/IF_TCD_DISTR_RULE_HIE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_TM_TCD_DIST_RULE_HIE IMPLEMENTATION.


METHOD /SCMTMS/IF_TCD_DISTR_RULE_HIE~DETERMINE_QUANTITY.
*  This example demonstrates following scenario.
*  FO has trailers, the costs should be distributed to the trailers based on distribution rule pieces.
*  For items inside the trailers, now these trailer costs should be distributed at distribution rule gross weight.

  FIELD-SYMBOLS:
                 <ls_chrg_element_itm_link> TYPE /scmtms/if_tcd_preproc=>ty_ch_el_item_link,
                 <ls_tor_item_key>          TYPE /bobf/s_frw_key,
                 <ls_tcd_comm_item>         TYPE /scmtms/s_tcd_comm_item,
                 <ls_ch_el_rule>            TYPE /scmtms/if_tcd_preproc=>ty_ch_el_rule,
                 <ls_item_qty_rule_link>    TYPE /scmtms/if_tcd_preproc=>ty_item_qty_rule_link,
                 <ls_item_qty>              TYPE /scmtms/s_tcd_distr_rule_qty,
                 <ls_tcd_root>              TYPE /scmtms/s_tcd_root_k.

  READ TABLE it_tcd_root ASSIGNING <ls_tcd_root> INDEX 1.
  IF sy-subrc EQ 0.
    CASE <ls_tcd_root>-distr_cat.
      WHEN /scmtms/if_tcd_constants=>gc_distr_cat-external_charges.

        LOOP AT it_hie_level_item_key ASSIGNING <ls_tor_item_key>.
          READ TABLE is_tcd_comm_root-item ASSIGNING <ls_tcd_comm_item> WITH KEY key COMPONENTS KEY = <ls_tor_item_key>-key item_cat = /scmtms/if_tor_const=>sc_itemcat_prd.
          IF sy-subrc EQ 0.
            LOOP AT it_chrg_element_itm_link ASSIGNING <ls_chrg_element_itm_link>.
              READ TABLE <ls_chrg_element_itm_link>-item WITH KEY key_sort COMPONENTS key = <ls_tor_item_key>-key TRANSPORTING NO FIELDS.
              IF sy-subrc = 0.
                READ TABLE et_ch_el_rule WITH KEY key = <ls_chrg_element_itm_link>-charge_element_key TRANSPORTING NO FIELDS.
                IF sy-subrc NE 0.
                  APPEND INITIAL LINE TO et_ch_el_rule ASSIGNING <ls_ch_el_rule>.
                  <ls_ch_el_rule>-key = <ls_chrg_element_itm_link>-charge_element_key.
                  <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-pieces.
                ENDIF.
              ENDIF.
            ENDLOOP.
            APPEND INITIAL LINE TO et_item_qty_rule_link ASSIGNING <ls_item_qty_rule_link>.
            <ls_item_qty_rule_link>-key = <ls_tor_item_key>-key.
            APPEND INITIAL LINE TO <ls_item_qty_rule_link>-quantity ASSIGNING <ls_item_qty>.
            <ls_item_qty>-distr_rule = /scmtms/if_tcd_constants=>gc_distr_rule-pieces.
            <ls_item_qty>-qty = <ls_tcd_comm_item>-qua_pcs_val.
            <ls_item_qty>-qty_uni = <ls_tcd_comm_item>-qua_pcs_uni.
            <ls_item_qty_rule_link>-ref_key = is_tcd_comm_root-ref_key.
            <ls_item_qty_rule_link>-root_key = <ls_tcd_comm_item>-root_key.
          ENDIF.
        ENDLOOP.

      WHEN /scmtms/if_tcd_constants=>gc_distr_cat-internal_charges.

        LOOP AT it_hie_level_item_key ASSIGNING <ls_tor_item_key>.
          READ TABLE is_tcd_comm_root-item ASSIGNING <ls_tcd_comm_item> WITH KEY  key COMPONENTS KEY = <ls_tor_item_key>-key item_cat = /scmtms/if_tor_const=>sc_itemcat_res_gen.
          IF sy-subrc EQ 0.
            LOOP AT it_chrg_element_itm_link ASSIGNING <ls_chrg_element_itm_link>.
              READ TABLE <ls_chrg_element_itm_link>-item WITH KEY key_sort COMPONENTS key = <ls_tor_item_key>-key TRANSPORTING NO FIELDS.
              IF sy-subrc = 0.
                READ TABLE et_ch_el_rule WITH KEY key = <ls_chrg_element_itm_link>-charge_element_key TRANSPORTING NO FIELDS.
                IF sy-subrc NE 0.
                  APPEND INITIAL LINE TO et_ch_el_rule ASSIGNING <ls_ch_el_rule>.
                  <ls_ch_el_rule>-key = <ls_chrg_element_itm_link>-charge_element_key.
                  <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-pieces.
                ENDIF.
              ENDIF.
            ENDLOOP.
            APPEND INITIAL LINE TO et_item_qty_rule_link ASSIGNING <ls_item_qty_rule_link>.
            <ls_item_qty_rule_link>-key = <ls_tor_item_key>-key.
            APPEND INITIAL LINE TO <ls_item_qty_rule_link>-quantity ASSIGNING <ls_item_qty>.
            <ls_item_qty>-distr_rule = /scmtms/if_tcd_constants=>gc_distr_rule-pieces.
            <ls_item_qty>-qty = <ls_tcd_comm_item>-qua_pcs_val.
            <ls_item_qty>-qty_uni = <ls_tcd_comm_item>-qua_pcs_uni.
            <ls_item_qty_rule_link>-ref_key = is_tcd_comm_root-ref_key.
            <ls_item_qty_rule_link>-root_key = <ls_tcd_comm_item>-root_key.
          ENDIF.
        ENDLOOP.

    ENDCASE.
  ENDIF.

ENDMETHOD.
ENDCLASS.
