FUNCTION zfmtm_wf_agrup_fat_agent_det.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      AC_CONTAINER STRUCTURE  SWCONT
*"      ACTOR_TAB STRUCTURE  SWHACTOR
*"  EXCEPTIONS
*"      NOBODY_FOUND
*"----------------------------------------------------------------------
  DATA: lt_oject TYPE SWFBORRTAB,
        lv_object TYPE swc_object,
        lv_objkey TYPE swotobjid-objkey.

  swc_get_element ac_container 'ZAGRPFAT' lv_object.

  IF sy-subrc NE 0.
    CLEAR lv_object.
  ENDIF.

  swc_get_object_key lv_object lv_objkey.

  IF sy-subrc NE 0.
    CLEAR lv_objkey.
  ENDIF.

  TRY.
      DATA(lo_agrupar) = zcltm_agrupar_fatura=>get_instance( ).

      lo_agrupar->busca_aprovadores( EXPORTING iv_objkey    = lv_objkey
                                               it_container = ac_container[]
                                     CHANGING  ct_actor_tab = actor_tab[] ).

    CATCH cx_root.
      RAISE nobody_found.
  ENDTRY.

ENDFUNCTION.
