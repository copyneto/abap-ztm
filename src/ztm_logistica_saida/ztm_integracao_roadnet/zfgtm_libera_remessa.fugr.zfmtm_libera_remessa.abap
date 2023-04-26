FUNCTION zfmtm_libera_remessa .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_REMESSA) TYPE  VBELN_VL_T
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: ls_header_data    TYPE bapiobdlvhdrchg,
        ls_header_control TYPE bapiobdlvhdrctrlchg.

  CONSTANTS: lc_lvblock_44 TYPE lifsk VALUE '44',
             lc_lvblock_45 TYPE lifsk VALUE '45'.

DATA(lt_remessas_exec) = it_remessa.

  IF sy-uname = 'CGARCIA'  OR sy-uname = 'MSPEREIRA'.
    IF it_remessa IS NOT INITIAL.
    RETURN. "##STMNT_EXIT
    ENDIF.
    DATA(lt_remessas_exec_enhan) = it_remessa.

    DO 20 TIMES.
      IF lt_remessas_exec_enhan IS INITIAL.
        EXIT.
      ELSE.
        SELECT deliverydocument FROM i_deliverydocument "#EC CI_SEL_NESTED
          INTO TABLE @DATA(lt_documents_complete_enhan)
          FOR ALL ENTRIES IN @lt_remessas_exec_enhan
          WHERE deliverydocument = @lt_remessas_exec_enhan-table_line
            AND ( transportationplanningstatus = 'C' OR transportationplanningstatus = 'B' )
            AND ( deliveryblockreason = '44' OR deliveryblockreason = '45' ).
        IF sy-subrc = 0.
          LOOP AT lt_documents_complete_enhan ASSIGNING FIELD-SYMBOL(<fs_documents_complete_enhan>). "#EC CI_NESTED
            DELETE FROM DATABASE indx(zt) CLIENT sy-mandt ID <fs_documents_complete_enhan>-deliverydocument. "#EC CI_IMUD_NESTED
            DELETE lt_remessas_exec_enhan WHERE table_line = <fs_documents_complete_enhan>-deliverydocument. "#EC CI_STDSEQ
          ENDLOOP.
        ENDIF.
      ENDIF.
    WAIT UP TO 1 SECONDS.
    ENDDO.
    lt_remessas_exec = lt_remessas_exec_enhan.
    IF lt_remessas_exec IS INITIAL.
      RETURN.
    ENDIF.
  ENDIF.

  SELECT vbeln,
         lprio
    FROM likp
    INTO TABLE @DATA(lt_lprio)
    FOR ALL ENTRIES IN @lt_remessas_exec
*    FOR ALL ENTRIES IN @it_remessa
*   WHERE vbeln EQ @it_remessa-table_line.       "#EC CI_FAE_NO_LINES_OK
   WHERE vbeln EQ @lt_remessas_exec-table_line.       "#EC CI_FAE_NO_LINES_OK

"  DATA(lt_remessas_exec) = it_remessa.
  SORT lt_remessas_exec.

  DO 40 TIMES.
    IF lt_remessas_exec IS INITIAL.
      EXIT.
    ELSE.
      SELECT deliverydocument FROM i_deliverydocument "#EC CI_SEL_NESTED
        INTO TABLE @DATA(lt_documents_complete)
        FOR ALL ENTRIES IN @lt_remessas_exec
        WHERE deliverydocument = @lt_remessas_exec-table_line
          AND transportationplanningstatus = 'C'.

*    LOOP AT gt_rembp ASSIGNING FIELD-SYMBOL(<fs_rembp>).
*  LOOP AT it_remessa ASSIGNING FIELD-SYMBOL(<fs_rembp>).
      LOOP AT lt_documents_complete ASSIGNING FIELD-SYMBOL(<fs_documents_complete>). "#EC CI_NESTED
        IF line_exists(    lt_lprio[ vbeln = <fs_documents_complete>-deliverydocument ] ). "#EC CI_STDSEQ
          DATA(ls_lprio) = lt_lprio[ vbeln = <fs_documents_complete>-deliverydocument ]. "#EC CI_STDSEQ
        ELSE.
          CONTINUE.
        ENDIF.

        ls_header_control-dlv_block_flg    = abap_true.
        ls_header_control-deliv_numb       = <fs_documents_complete>-deliverydocument.

        ls_header_data-deliv_numb          = <fs_documents_complete>-deliverydocument.
        ls_header_data-dlv_block           = SWITCH #( ls_lprio-lprio
                                                       WHEN '04' THEN lc_lvblock_45
                                                       WHEN '06' THEN lc_lvblock_45
                                                       ELSE           lc_lvblock_44  ).
        CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
          EXPORTING
            header_data    = ls_header_data
            header_control = ls_header_control
            delivery       = <fs_documents_complete>-deliverydocument
          TABLES
            return         = et_return.

        IF line_exists( et_return[ type = if_xo_const_message=>error ] ). "#EC CI_STDSEQ

          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        ELSE.
          DELETE lt_remessas_exec WHERE table_line = <fs_documents_complete>-deliverydocument. "#EC CI_STDSEQ

          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.

        ENDIF.

        CLEAR: ls_header_data,
               ls_header_control,
               ls_lprio.

      ENDLOOP.
      CLEAR lt_documents_complete.
    ENDIF.
    WAIT UP TO 1 SECONDS.
  ENDDO.


  IF lt_remessas_exec IS NOT INITIAL.
    TYPES: BEGIN OF ty_base,
             base_btd_id TYPE /scmtms/d_torrot-base_btd_id,
           END OF ty_base.
    DATA lt_base TYPE STANDARD TABLE OF ty_base.
    CLEAR lt_base.
    LOOP AT lt_remessas_exec ASSIGNING FIELD-SYMBOL(<fs_remessa>).
      APPEND VALUE #(
        base_btd_id = |{ <fs_remessa> ALPHA = IN }|
      ) TO lt_base.
    ENDLOOP.

    SELECT base_btd_id FROM /scmtms/d_torrot            "#EC CI_NOFIELD
      INTO TABLE @DATA(lt_base_ok)
    FOR ALL ENTRIES IN @lt_base
      WHERE base_btd_id = @lt_base-base_btd_id
        AND tor_cat = 'FU'
        AND ( plan_status_root = '02' OR plan_status_root = '03' ).


    LOOP AT lt_base_ok ASSIGNING FIELD-SYMBOL(<fs_base>). "#EC CI_NESTED
      CLEAR: ls_header_data,
             ls_header_control,
             ls_lprio.

      DATA(lv_remessa) = CONV vbeln( |{ <fs_base>-base_btd_id ALPHA = OUT }| ).
      lv_remessa = |{ lv_remessa ALPHA = IN }|.
      IF line_exists(    lt_lprio[ vbeln = lv_remessa ] ). "#EC CI_STDSEQ
        ls_lprio = lt_lprio[ vbeln = lv_remessa ].       "#EC CI_STDSEQ
      ELSE.
        CONTINUE.
      ENDIF.

      ls_header_control-dlv_block_flg    = abap_true.
      ls_header_control-deliv_numb       = lv_remessa.

      ls_header_data-deliv_numb          = lv_remessa.
      ls_header_data-dlv_block           = SWITCH #( ls_lprio-lprio
                                                     WHEN '04' THEN lc_lvblock_45
                                                     WHEN '06' THEN lc_lvblock_45
                                                     ELSE           lc_lvblock_44  ).
      CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
        EXPORTING
          header_data    = ls_header_data
          header_control = ls_header_control
          delivery       = lv_remessa
        TABLES
          return         = et_return.

      IF line_exists( et_return[ type = if_xo_const_message=>error ] ). "#EC CI_STDSEQ
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
