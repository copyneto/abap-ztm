FUNCTION zfmtm_param_roadnet_apagar_log.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_ROAD_LOG) TYPE  ZCTGTM_ROAD_LOG
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lt_road_log) = it_road_log.

  LOOP AT lt_road_log REFERENCE INTO DATA(ls_road_log).
    ls_road_log->obsolete = abap_true.
  ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza tabela de logs
* ---------------------------------------------------------------------------
  IF lt_road_log IS NOT INITIAL.
    MODIFY zttm_road_log FROM TABLE lt_road_log.

    IF sy-subrc EQ 0.
      " Operação realizada com sucesso.
      et_return = VALUE #( ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '027' ) ).
      COMMIT WORK.
    ELSE.
      " Falha ao limpar o histórico.
      et_return = VALUE #( ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '028' ) ).
      ROLLBACK WORK.
    ENDIF.
  ENDIF.

ENDFUNCTION.
