CLASS zcltm_unalloc_ce DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_common_badi .
    INTERFACES /scmtms/if_tcd_unalloc_ce .
    INTERFACES if_badi_interface .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_unalloc_ce IMPLEMENTATION.


  METHOD /scmtms/if_common_badi~set_badi_work_mode.

    cv_work_mode = /scmtms/if_common_badi=>gc_mode_customer_logic_only.

  ENDMETHOD.


  METHOD /scmtms/if_tcd_unalloc_ce~unallocate_charge_element.

    DATA: lt_fsd_data TYPE /scmtms/t_sfir_root_k,
          lt_key      TYPE /bobf/t_frw_key.

* ---------------------------------------------------------------------------
* Recupera dados do Documento de Faturamento de Frete (DFF)
* ---------------------------------------------------------------------------
    DATA(lo_sfir_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_suppfreightinvreq_c=>sc_bo_key ).

    TRY.
        lo_sfir_srv_mgr->retrieve(
          EXPORTING
            iv_node_key             = /scmtms/if_suppfreightinvreq_c=>sc_node-root
            it_key                  = CORRESPONDING #( it_chrg_elements MAPPING key = root_key  )
          IMPORTING
            eo_message              = DATA(lo_message)
            eo_change               = DATA(lo_change)
            et_data                 = lt_fsd_data
            et_failed_key           = DATA(lt_failed) ).

        DATA(ls_fsd_data) = lt_fsd_data[ 1 ].
      CATCH cx_root.
        RETURN.
    ENDTRY.

    IF ls_fsd_data-zzacckey IS INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida se a chave de acesso é DIFERENTE da DFF sendo processada. Caso seja,
* iremos remover esse elemento de distribuição de custos
* ---------------------------------------------------------------------------
    LOOP AT it_chrg_elements REFERENCE INTO DATA(ls_charg_elements).
      CHECK ls_charg_elements->zzacckey IS NOT INITIAL.
      CHECK ls_charg_elements->zzacckey NE ls_fsd_data-zzacckey.
      APPEND ls_charg_elements->* TO et_unalloc_chrg_elements.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.
