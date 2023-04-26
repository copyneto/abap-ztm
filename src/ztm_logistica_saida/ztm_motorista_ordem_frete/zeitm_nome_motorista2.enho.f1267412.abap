"Name: \TY:/SCMTMS/CL_UI_VIEWEXIT_TOR\ME:ITEM_DRV_ADAPT_DATA\SE:END\EI
ENHANCEMENT 0 ZEITM_NOME_MOTORISTA2.
  DATA(lv_motorista) = lt_d_root[ 1 ]-zz_motorista.

  ASSIGN COMPONENT 'RES_ADHOC'  OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_flag>).
  ASSIGN COMPONENT 'ITEM_DESCR' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_driver>).
  IF <fs_flag> IS ASSIGNED AND <fs_driver> IS ASSIGNED.
    SELECT SINGLE nomemotorista
      FROM zi_tm_motorista_sh
      WHERE codigomotorista = @lv_motorista
      INTO @<fs_driver>.
    <fs_flag> = abap_true.
  ENDIF.
ENDENHANCEMENT.
