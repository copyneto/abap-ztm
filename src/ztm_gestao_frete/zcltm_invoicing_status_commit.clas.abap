class ZCLTM_INVOICING_STATUS_COMMIT definition
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



CLASS ZCLTM_INVOICING_STATUS_COMMIT IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_return    TYPE bapiret2_t,
          lv_status    TYPE zttm_gkot001-codstatus,
          lv_reprocess TYPE flag.

* ---------------------------------------------------------------------------
* Recupera dados da Ordem de Frete
* ---------------------------------------------------------------------------
    zcltm_invoicing_status=>get_data( EXPORTING is_ctx                 = is_ctx
                                                it_key                 = it_key
                                                io_read                = io_read
                                                io_modify              = io_modify
                                      IMPORTING eo_tor_srv_mgr         = DATA(lo_tor_srv_mgr)
                                                es_cockpit             = DATA(ls_cockpit)
                                                es_tor_key             = DATA(ls_tor_key)
                                                es_fsd_data            = DATA(ls_fsd_data)
                                                et_tcc                 = DATA(lt_tcc)
                                                ev_do_key              = DATA(lv_do_key)
                                                ev_bo_do_assoc_key     = DATA(lv_bo_do_assoc_key)
                                                ev_it_chrg_it_node_key = DATA(lv_it_chrg_it_node_key)
                                                ev_it_chrg_el_node_key = DATA(lv_it_chrg_el_node_key)
                                                es_ctx                 = DATA(ls_ctx)
                                                et_charge_item         = DATA(lt_charge_item)
                                                et_do_root             = DATA(lt_do_root)
                                                et_charge_element      = DATA(lt_charge_element) ).

* ---------------------------------------------------------------------------
* Realiza processamento adicional de acordo com o status atual
* ---------------------------------------------------------------------------
    CASE ls_fsd_data-lifecycle.

        " Status 04 - Lançado
      WHEN /scmtms/if_sfir_status=>sc_root-lifecycle-v_accruals_posted.

*        lv_reprocess = abap_true.

      WHEN OTHERS.
        RETURN.

    ENDCASE.

* ---------------------------------------------------------------------------
* Atualiza Cockpit de Frete
* ---------------------------------------------------------------------------
    IF ls_cockpit-codstatus NE lv_status AND lv_status IS NOT INITIAL
    OR lv_reprocess IS NOT INITIAL.

      zcltm_invoicing_status=>update_cockpit( EXPORTING iv_acckey    = ls_cockpit-acckey    " Chave de acesso
                                                        iv_status    = ls_cockpit-codstatus " Novo status
                                                        iv_reprocess = lv_reprocess         " Ativa reprocessamento
                                              IMPORTING et_return    = lt_return ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
