class ZCLTM_SET_STATUS_INT definition
  public
  inheriting from /BOBF/CL_LIB_D_SUPERCL_SIMPLE
  final
  create public .

public section.

  methods /BOBF/IF_FRW_DETERMINATION~EXECUTE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_SET_STATUS_INT IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_root TYPE /scmtms/t_tor_root_k,
          lt_mod  TYPE /bobf/t_frw_modification.

    DATA: ls_mod  TYPE /bobf/s_frw_modification.


    io_read->retrieve(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-root                 " Node Name
        it_key                  = it_key                 " Key Table
      IMPORTING
        et_data                 = lt_root ).

    CHECK lt_root IS NOT INITIAL.

    DATA(ls_root)     = lt_root[ 1 ].
    DATA(ls_root_old) = ls_root.

    CASE ls_root-tor_cat.
      WHEN /scmtms/if_tor_const=>sc_tor_category-active.       " Ordem de Frete

        ls_root-zzint_gko_status  = zcltm_interface_fo=>gc_codstatus-no_exec.
        ls_root-zzint_gko_desc    = zcltm_interface_fo=>get_status_desc( is_status_cod = zcltm_interface_fo=>gc_codstatus-no_exec ).
        ls_root-zzint_gko_icon    = zcltm_interface_fo=>gc_icons-inactive.

        ls_root-zzint_gm_status   = zcltm_interface_fo=>gc_codstatus-no_exec.
        ls_root-zzint_gm_desc     = zcltm_interface_fo=>get_status_desc( is_status_cod = zcltm_interface_fo=>gc_codstatus-no_exec ).
        ls_root-zzint_gm_icon     = zcltm_interface_fo=>gc_icons-inactive.

        ls_root-zzint_traf_status = zcltm_interface_fo=>gc_codstatus-no_exec.
        ls_root-zzint_traf_desc   = zcltm_interface_fo=>get_status_desc( is_status_cod = zcltm_interface_fo=>gc_codstatus-no_exec ).
        ls_root-zzint_traf_icon   = zcltm_interface_fo=>gc_icons-inactive.

      WHEN /scmtms/if_tor_const=>sc_tor_category-freight_unit. " Unidade de Frete

        ls_root-zzint_fat_status  = zcltm_interface_fo=>gc_codstatus-no_fat.
        ls_root-zzint_fat_desc    = zcltm_interface_fo=>get_status_desc( is_status_cod = zcltm_interface_fo=>gc_codstatus-no_fat ).
        ls_root-zzint_fat_icon    = zcltm_interface_fo=>gc_icons-inactive.

    ENDCASE.

    /scmtms/cl_mod_helper=>mod_update_chg_fields(
      EXPORTING
        iv_node     = /scmtms/if_tor_c=>sc_node-root                                                                                " Node
        is_data     = ls_root                                                                                                   " New Data
        is_data_old = ls_root_old                                                                                               " Old Data
        iv_bo_key   = /scmtms/if_tor_c=>sc_bo_key                                                                                   " Business Object
      IMPORTING
        es_mod      = ls_mod ).

    IF ls_mod IS NOT INITIAL.
      APPEND ls_mod TO lt_mod.
    ENDIF.

    CHECK lt_mod IS NOT INITIAL.

    TRY.
        io_modify->do_modify( it_modification = lt_mod ).
      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
