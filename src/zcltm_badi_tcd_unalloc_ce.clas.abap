class ZCLTM_BADI_TCD_UNALLOC_CE definition
  public
  final
  create public .

public section.

  interfaces /SCMTMS/IF_COMMON_BADI .
  interfaces /SCMTMS/IF_TCD_UNALLOC_CE .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_BADI_TCD_UNALLOC_CE IMPLEMENTATION.


method /SCMTMS/IF_COMMON_BADI~SET_BADI_WORK_MODE.
  cv_work_mode = /scmtms/if_common_badi=>gc_mode_customer_logic_only.
endmethod.


method /SCMTMS/IF_TCD_UNALLOC_CE~UNALLOCATE_CHARGE_ELEMENT.
  FIELD-SYMBOLS:
                 <ls_chrg_elements> TYPE /scmtms/s_tcc_trchrg_element_k.

  LOOP AT it_chrg_elements ASSIGNING <ls_chrg_elements> WHERE clcresbas036 = 'CONTAINER'.
    APPEND <ls_chrg_elements> TO et_unalloc_chrg_elements.
  ENDLOOP.
endmethod.
ENDCLASS.
