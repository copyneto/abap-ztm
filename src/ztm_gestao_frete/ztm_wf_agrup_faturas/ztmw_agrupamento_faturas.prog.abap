*****           Implementation of object type ZAGRPFAT             *****
INCLUDE <object>.
begin_data object. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
  " begin of private,
  "   to declare private attributes remove comments and
  "   insert private attributes here ...
  " end of private,
  BEGIN OF key,
    reference    LIKE zttm_gkot009-xblnr,
    cnpj         LIKE zttm_gkot009-stcd1,
    documentdate LIKE zttm_gkot009-bldat,
  END OF key,
  _zttm_gkot009 LIKE zttm_gkot009.
end_data object. " Do not change.. DATA is generated

TABLES zttm_gkot009.
*
get_table_property zttm_gkot009.
DATA subrc LIKE sy-subrc.
* Fill TABLES ZTTM_GKOT009 to enable Object Manager Access to Table
* Properties
PERFORM select_table_zttm_gkot009 USING subrc.
IF subrc NE 0.
  exit_object_not_found.
ENDIF.
end_property.
*
* Use Form also for other(virtual) Properties to fill TABLES
* ZTTM_GKOT009
FORM select_table_zttm_gkot009 USING subrc LIKE sy-subrc.
* Select single * from ZTTM_GKOT009, if OBJECT-_ZTTM_GKOT009 is initial
  IF object-_zttm_gkot009-mandt IS INITIAL
  AND object-_zttm_gkot009-xblnr IS INITIAL
  AND object-_zttm_gkot009-stcd1 IS INITIAL
  AND object-_zttm_gkot009-bldat IS INITIAL.
    SELECT SINGLE * FROM zttm_gkot009 CLIENT SPECIFIED
        WHERE mandt = sy-mandt
        AND xblnr = object-key-reference
        AND stcd1 = object-key-cnpj
        AND bldat = object-key-documentdate.
    subrc = sy-subrc.
    IF subrc NE 0. EXIT. ENDIF.
    object-_zttm_gkot009 = zttm_gkot009.
  ELSE.
    subrc = 0.
    zttm_gkot009 = object-_zttm_gkot009.
  ENDIF.
ENDFORM.

begin_method alterastatus changing container.

TYPES: BEGIN OF ty_gkot011_format,
         budat         TYPE zttm_gkot001-budat,
         prefno        TYPE zttm_gkot001-prefno,
         nfnum9        TYPE zttm_gkot001-nfnum9,
         series        TYPE zttm_gkot001-series,
         emit_cnpj_cpf TYPE zttm_gkot001-emit_cnpj_cpf,
       END OF ty_gkot011_format.

DATA: lv_status         TYPE zttm_gkot001-codstatus,
      lt_gkot011_format TYPE TABLE OF ty_gkot011_format,
      lt_001_key        TYPE STANDARD TABLE OF zttm_gkot001.

swc_get_element container 'Status' lv_status.

*SELECT FROM zttm_gkot010
*  FIELDS xblnr, stcd1, bldat, seqcte, acckey
*  WHERE xblnr EQ @object-key-reference
*    AND stcd1 EQ @object-key-cnpj
*    AND bldat EQ @object-key-documentdate
*  INTO TABLE @DATA(lt_gkot010).
*
*SELECT FROM zttm_gkot011
*  FIELDS xblnr, stcd1, bldat, seqnfs, docdat, prefno, nfnum, nfenum, series, stcd1_transp
*  WHERE xblnr EQ @object-key-reference
*    AND stcd1 EQ @object-key-cnpj
*    AND bldat EQ @object-key-documentdate
*  INTO TABLE @DATA(lt_gkot011).
*
*IF lt_gkot010 IS NOT INITIAL.
*  SELECT * FROM zttm_gkot001
*    FOR ALL ENTRIES IN @lt_gkot010
*    WHERE acckey EQ @lt_gkot010-acckey
*    INTO TABLE @DATA(lt_gkot001).
*ENDIF.
*
*LOOP AT lt_gkot011 ASSIGNING FIELD-SYMBOL(<fs_gkot011>).
*  APPEND VALUE #(
*    budat         = <fs_gkot011>-docdat
*    prefno        = CONV #( <fs_gkot011>-prefno )
*    nfnum9        = CONV #( COND #( WHEN <fs_gkot011>-nfenum IS NOT INITIAL
*                                    THEN <fs_gkot011>-nfenum
*                                    WHEN <fs_gkot011>-nfnum IS NOT INITIAL
*                                    THEN <fs_gkot011>-nfnum
*                                    ELSE <fs_gkot011>-nfenum ) )
*    series        = CONV #( <fs_gkot011>-series )
*    emit_cnpj_cpf = CONV #( <fs_gkot011>-stcd1_transp )
*  ) TO lt_gkot011_format.
*ENDLOOP.
*
*IF lt_gkot011_format IS NOT INITIAL.
*  SELECT * FROM zttm_gkot001
*    FOR ALL ENTRIES IN @lt_gkot011_format
*    WHERE budat         EQ @lt_gkot011_format-budat
*      AND prefno        EQ @lt_gkot011_format-prefno
*      AND nfnum9        EQ @lt_gkot011_format-nfnum9
*      AND series        EQ @lt_gkot011_format-series
*      AND emit_cnpj_cpf EQ @lt_gkot011_format-emit_cnpj_cpf
*    APPENDING TABLE @lt_gkot001.
*ENDIF.

lt_001_key = VALUE #( ( num_fatura    = object-key-reference
                        emit_cnpj_cpf = object-key-cnpj ) ).

IF lt_001_key IS NOT INITIAL.
  SELECT * FROM zttm_gkot001
    FOR ALL ENTRIES IN @lt_001_key
    WHERE num_fatura    EQ @lt_001_key-num_fatura
      AND emit_cnpj_cpf EQ @lt_001_key-emit_cnpj_cpf
    INTO TABLE @DATA(lt_gkot001).
ENDIF.

LOOP AT lt_gkot001 ASSIGNING FIELD-SYMBOL(<fs_gkot001>).
  <fs_gkot001>-codstatus = lv_status.
ENDLOOP.

" Atualiza status
LOOP AT lt_gkot001 ASSIGNING <fs_gkot001>.
  TRY.
      DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey = <fs_gkot001>-acckey ).
      lr_gko_process->set_status( iv_status = <fs_gkot001>-codstatus ).
      lr_gko_process->persist( ).
      lr_gko_process->free( ).
    CATCH cx_root.
  ENDTRY.
ENDLOOP.

IF lv_status = zclfi_gko_incoming_invoice=>gc_codstatus-aguardando_reagrupamento.

  DATA(lo_agrupar) = zcltm_agrupar_fatura=>get_instance( ).

  " Agrupamento de faturas
  lo_agrupar->efetivar_agrupamento( EXPORTING it_xblnr       = VALUE #( ( object-key-reference ) )
                                    IMPORTING et_return      = DATA(lt_return)
                                              et_bapi_return = DATA(lt_bapi_return) ).
ENDIF.

end_method.


begin_method dadosadicionais changing container.

DATA: lv_niveltotal TYPE twb_rmp-node_level.

TRY.
    DATA(lo_agrupar) = zcltm_agrupar_fatura=>get_instance( ).

    lo_agrupar->busca_nivel_desconto( EXPORTING iv_xblnr = object-key-reference
                                                iv_stcd1 = object-key-cnpj
                                                iv_bldat = object-key-documentdate
                                      IMPORTING ev_nivel = lv_niveltotal ).
  CATCH cx_root.
ENDTRY.

swc_set_element container 'NivelTotal' lv_niveltotal.

end_method.
