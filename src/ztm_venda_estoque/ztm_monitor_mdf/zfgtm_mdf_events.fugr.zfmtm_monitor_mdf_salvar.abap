FUNCTION zfmtm_monitor_mdf_salvar.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_MDF) TYPE  ZTTM_MDF
*"     VALUE(IS_MDF_IDE) TYPE  ZTTM_MDF_IDE
*"     VALUE(IT_MDF_MCD) TYPE  ZCTGTM_MDF_MCD
*"     VALUE(IS_MDF_MOTO) TYPE  ZTTM_MDF_MOTO
*"     VALUE(IT_MDF_PLACA) TYPE  ZCTGTM_MDF_PLACA
*"     VALUE(IT_MDF_PLACA_C) TYPE  ZCTGTM_MDF_PLACA_C
*"     VALUE(IT_MDF_PLACA_V) TYPE  ZCTGTM_MDF_PLACA_V
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  FREE: et_return.

  DATA(lo_events) = NEW zcltm_mdf_events_manual( ).

  lo_events->save_background( EXPORTING is_mdf          = is_mdf
                                        is_mdf_ide      = is_mdf_ide
                                        it_mdf_mcd      = it_mdf_mcd
                                        is_mdf_moto     = is_mdf_moto
                                        it_mdf_placa    = it_mdf_placa
                                        it_mdf_placa_c  = it_mdf_placa_c
                                        it_mdf_placa_v  = it_mdf_placa_v
                              IMPORTING et_return       = et_return ).

ENDFUNCTION.
