FUNCTION zfmtm_refresh_status_sefaz.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GKOT006) TYPE  ZTTM_GKOT006
*"----------------------------------------------------------------------
  DATA: ls_006 TYPE zttm_gkot006.

  ls_006 = is_gkot006.

  SELECT SINGLE acckey, codstatus, sitdoc
    FROM zttm_gkot001
    INTO @DATA(ls_001)
    WHERE acckey =  @is_gkot006-acckey.

  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  SELECT COUNT(*)
    FROM zttm_gkot006
    INTO @DATA(lv_count)
    WHERE acckey =  @is_gkot006-acckey.

  IF sy-subrc NE 0.
    CLEAR lv_count.
  ENDIF.

  ls_001-codstatus = is_gkot006-codstatus.
  ls_001-sitdoc    = COND #( WHEN is_gkot006-codstatus EQ '100'
                             THEN '1' " Autorizado
                             WHEN is_gkot006-codstatus NE '100' AND ls_001-sitdoc NE '1'
                             THEN ls_001-sitdoc
                             ELSE space ).

  ls_006-counter   = lv_count + 1.

  MODIFY zttm_gkot006 FROM ls_006.

  UPDATE zttm_gkot001 SET codstatus = ls_001-codstatus
                          sitdoc    = ls_001-sitdoc
                      WHERE acckey EQ ls_001-acckey.

  COMMIT WORK.

ENDFUNCTION.
