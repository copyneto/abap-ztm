class ZCLTM_BADI_TCD_DISTR_RULE definition
  public
  final
  create public .

public section.

  interfaces /SCMTMS/IF_TCD_DISTR_RULE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_BADI_TCD_DISTR_RULE IMPLEMENTATION.


METHOD /SCMTMS/IF_TCD_DISTR_RULE~DETERMINE_QUANTITY.

  FIELD-SYMBOLS:
                 <ls_ch_el_rule>          TYPE /scmtms/if_tcd_preproc=>ty_ch_el_rule,
                 <ls_charge_elements>     TYPE /scmtms/s_tcc_trchrg_element_k,
                 <ls_tcd_comm_root>       TYPE /scmtms/s_tcd_comm_root,
                 <ls_tcd_comm_item>       TYPE /scmtms/s_tcd_comm_item,
                 <ls_item_qty_rule_link>  TYPE /scmtms/if_tcd_preproc=>ty_item_qty_rule_link,
                 <ls_item_qty>            TYPE /scmtms/s_tcd_distr_rule_qty,
                 <ls_tcd_root>            TYPE /scmtms/s_tcd_root_k,
                 <ls_tcd_comm_item_qua>   TYPE /scmtms/s_tcd_distr_rule_qty.

  LOOP AT it_tcd_root ASSIGNING <ls_tcd_root>.
    CASE <ls_tcd_root>-distr_cat.
*  Extract only the External Cost Dist instance.
      WHEN /scmtms/if_tcd_constants=>gc_distr_cat-external_charges.

*  For Root level charge elements perform distribution by weight irrespective of the profile settings.
        LOOP AT it_charge_elements ASSIGNING <ls_charge_elements>.
          APPEND INITIAL LINE TO et_ch_el_rule ASSIGNING <ls_ch_el_rule>.
          IF <ls_charge_elements>-clcresbas036 = /scmtms/if_tc_const=>cs_res_base-header.
            <ls_ch_el_rule>-key = <ls_charge_elements>-key.
            <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-gross_weight.
          ELSE.
            <ls_ch_el_rule>-key = <ls_charge_elements>-key.
            <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-pieces.
          ENDIF.
        ENDLOOP.

*  For all the items pass the pieces information. And for rest of the charge elements consider the distribution rule as pieces.
        LOOP AT it_tcd_comm_root ASSIGNING <ls_tcd_comm_root>.
          LOOP AT <ls_tcd_comm_root>-item ASSIGNING <ls_tcd_comm_item> WHERE parent_key = <ls_tcd_comm_root>-key.
            APPEND INITIAL LINE TO et_item_qty_rule_link ASSIGNING <ls_item_qty_rule_link>.
            <ls_item_qty_rule_link>-key = <ls_tcd_comm_item>-key.
            APPEND INITIAL LINE TO <ls_item_qty_rule_link>-quantity ASSIGNING <ls_item_qty>.
            <ls_item_qty>-qty = <ls_tcd_comm_item>-qua_pcs_val.
            <ls_item_qty>-qty_uni = <ls_tcd_comm_item>-qua_pcs_uni.
            <ls_item_qty>-distr_rule = /scmtms/if_tcd_constants=>gc_distr_rule-pieces.
            <ls_item_qty_rule_link>-root_key = <ls_tcd_comm_item>-root_key.
            <ls_item_qty_rule_link>-ref_key = <ls_tcd_comm_root>-ref_key.
          ENDLOOP.
        ENDLOOP.

*  Extract only the Internal Cost Dist instance.
      WHEN /scmtms/if_tcd_constants=>gc_distr_cat-internal_charges.

*  For charge elements with resolution base resource, PERFORM distribution BY distance-weight irrespective OF the profile settings.
*  For Charge Elements with other Resolution Bases, use the Gross Weight distribution rule.

        LOOP AT it_charge_elements ASSIGNING <ls_charge_elements>.
          APPEND INITIAL LINE TO et_ch_el_rule ASSIGNING <ls_ch_el_rule>.
          IF <ls_charge_elements>-clcresbas036 = /scmtms/if_tc_const=>cs_res_base-resource.
            <ls_ch_el_rule>-key = <ls_charge_elements>-key.
            <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-dist_weight.
          ELSE.
            <ls_ch_el_rule>-key = <ls_charge_elements>-key.
            <ls_ch_el_rule>-distrib_rule = /scmtms/if_tcd_constants=>gc_distr_rule-gross_weight.
          ENDIF.
        ENDLOOP.

*  For all the items pass the Distance-Weight information. And for rest of the charge elements consider the distribution rule as Gross Weight.
        LOOP AT it_tcd_comm_root ASSIGNING <ls_tcd_comm_root>.
          LOOP AT <ls_tcd_comm_root>-item ASSIGNING <ls_tcd_comm_item> WHERE parent_key = <ls_tcd_comm_root>-key.
            APPEND INITIAL LINE TO et_item_qty_rule_link ASSIGNING <ls_item_qty_rule_link>.
            <ls_item_qty_rule_link>-key = <ls_tcd_comm_item>-key.
            APPEND INITIAL LINE TO <ls_item_qty_rule_link>-quantity ASSIGNING <ls_item_qty>.
            READ TABLE <ls_tcd_comm_item>-quantity ASSIGNING <ls_tcd_comm_item_qua> WITH KEY distr_rule = /scmtms/if_tcd_constants=>gc_distr_rule-dist_weight.
            IF sy-subrc EQ 0.
              <ls_item_qty>-qty = <ls_tcd_comm_item_qua>-qty.
              <ls_item_qty>-qty_uni = <ls_tcd_comm_item_qua>-qty_uni.
            ENDIF.
            <ls_item_qty>-distr_rule = /scmtms/if_tcd_constants=>gc_distr_rule-dist_weight.
            <ls_item_qty_rule_link>-root_key = <ls_tcd_comm_item>-root_key.
            <ls_item_qty_rule_link>-ref_key = <ls_tcd_comm_root>-ref_key.
          ENDLOOP.
        ENDLOOP.

    ENDCASE.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.
