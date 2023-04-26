FUNCTION zfmtm_extra_charge_and_step.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GKO_HEADER) TYPE  ZTTM_GKOT001
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

* ----------------------------------------------------------------------
* Exporta a linha do cockpit para uma variável global
* ----------------------------------------------------------------------
  gs_gko_header = is_gko_header.

* ----------------------------------------------------------------------
* Executa processo de criação de custo e faturamento de frete
* ----------------------------------------------------------------------

  TRY.
      DATA(lo_gko_process) = NEW zcltm_gko_process( iv_acckey        = is_gko_header-acckey
                                                    iv_tpprocess     = zcltm_gko_process=>gc_tpprocess-automatico
                                                    iv_locked_in_tab = abap_true
                                                    iv_min_data_load = abap_false ).
      lo_gko_process->extra_charge_and_step( ).
      lo_gko_process->persist( ).
      lo_gko_process->free( ).
    CATCH zcxtm_gko_process INTO DATA(lo_cx_gko_process).
  ENDTRY.

ENDFUNCTION.
