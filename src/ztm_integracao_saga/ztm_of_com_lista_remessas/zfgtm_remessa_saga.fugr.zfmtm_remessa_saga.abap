FUNCTION zfmtm_remessa_saga.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      IT_REMESSA STRUCTURE  ZTSD_REM_SAGA
*"----------------------------------------------------------------------

  IF it_remessa[] IS NOT INITIAL.

    MODIFY ztsd_rem_saga FROM TABLE it_remessa.

    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.

  ENDIF.

ENDFUNCTION.
