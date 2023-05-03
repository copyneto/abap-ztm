*&---------------------------------------------------------------------*
*& Report ZTMR_VERIFICA_STATUS_SEFAZ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztmr_verifica_status_sefaz.

DATA: gt_mdf    TYPE TABLE OF zttm_mdf,
      gt_return TYPE bapiret2_t.

DATA: gs_mdf TYPE zttm_mdf.

SELECTION-SCREEN BEGIN OF BLOCK b1.

  SELECT-OPTIONS: s_id      FOR gs_mdf-id,
                  s_docnum  FOR gs_mdf-docnum,
                  s_fenum   FOR gs_mdf-mdfenum,
                  s_series  FOR gs_mdf-series .

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  FREE: gt_mdf, gt_return.

  PERFORM f_seleciona_dados_mdf CHANGING gt_return.

  PERFORM f_processa_dados_mdf CHANGING gt_return.

  PERFORM f_exibe_log USING gt_return.

*&---------------------------------------------------------------------*
*& Form f_seleciona_dados_mdf
*&---------------------------------------------------------------------*

FORM f_seleciona_dados_mdf CHANGING ct_return TYPE bapiret2_t.

  SELECT id, histcount, stepstatus
    FROM zttm_mdf_hist
    INTO TABLE @DATA(lt_mdf)
    WHERE id      IN @s_id.

  IF sy-subrc NE 0.
    " Nenhuma MDF-e encontrada.
    ct_return = VALUE #( BASE ct_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '096' ) ).
    RETURN.
  ENDIF.

  SORT lt_mdf BY id ASCENDING histcount DESCENDING.
  DELETE ADJACENT DUPLICATES FROM lt_mdf COMPARING id.
  DELETE lt_mdf WHERE stepstatus = '01' OR stepstatus = '02'.

  IF lt_mdf IS NOT INITIAL.

    SELECT *
      FROM zttm_mdf
      INTO TABLE gt_mdf
      FOR ALL ENTRIES IN lt_mdf
      WHERE id      EQ lt_mdf-id
        AND docnum  IN s_docnum
        AND mdfenum IN s_fenum
        AND series  IN s_series.

    IF sy-subrc NE 0.
      " Nenhuma MDF-e encontrada.
      ct_return = VALUE #( BASE ct_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '096' ) ).
      RETURN.
    ENDIF.
  ELSE.
    " Nenhuma MDF-e necessita ser atualizada. Nada a fazer.
    ct_return = VALUE #( BASE ct_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '098' ) ).
    RETURN.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_processa_dados_mdf
*&---------------------------------------------------------------------*

FORM f_processa_dados_mdf CHANGING ct_return TYPE bapiret2_t.

  CHECK NOT line_exists( ct_return[ type = 'E' ] ).

  DATA(lo_events) = NEW zcltm_mdf_events_manual( ).

  LOOP AT gt_mdf ASSIGNING FIELD-SYMBOL(<fs_mdf>).

    " Atualizando status do Agrupador &1, MDF-e &2:
    ct_return[] = VALUE #( BASE ct_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '097' message_v1 = <fs_mdf>-docnum message_v2 = <fs_mdf>-mdfenum ) ).

    lo_events->get_history_background( EXPORTING is_mdf    = <fs_mdf>
                                       IMPORTING es_mdfehd = DATA(ls_mdfehd)
                                                 et_return = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE ct_return[].

* BEGIN OF INSERT - JWSILVA - 02.05.2023
    lo_events->update_freight_order( EXPORTING is_mdf    = <fs_mdf>
                                               is_mdfehd = ls_mdfehd
                                     IMPORTING et_return = lt_return ).

    INSERT LINES OF lt_return INTO TABLE ct_return.
* END OF INSERT - JWSILVA - 02.05.2023

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_exibe_log
*&---------------------------------------------------------------------*

FORM f_exibe_log USING ut_return TYPE bapiret2_t.


  CHECK ut_return[] IS NOT INITIAL.

* ----------------------------------------------------------------------
* Filter information
* ----------------------------------------------------------------------
  DATA(lt_message) = VALUE esp1_message_tab_type(
                     FOR ls_return IN ut_return ( msgid  = ls_return-id
                                                  msgty  = ls_return-type
                                                  msgno  = ls_return-number
                                                  msgv1  = ls_return-message_v1
                                                  msgv2  = ls_return-message_v2
                                                  msgv3  = ls_return-message_v3
                                                  msgv4  = ls_return-message_v4
                                                  lineno = sy-tabix ) ).

* ----------------------------------------------------------------------
* Show multiple messages as pop-up
* ----------------------------------------------------------------------
  IF lines( lt_message[] ) GT 1.

    CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
      TABLES
        i_message_tab = lt_message[].

* ----------------------------------------------------------------------
* Show single message
* ----------------------------------------------------------------------
  ELSE.

    TRY.
        DATA(ls_message) = lt_message[ 1 ].

        MESSAGE ID ls_message-msgid
              TYPE 'S'
            NUMBER ls_message-msgno
           DISPLAY
              LIKE ls_message-msgty
              WITH ls_message-msgv1
                   ls_message-msgv2
                   ls_message-msgv3
                   ls_message-msgv4.

      CATCH cx_root.
    ENDTRY.

  ENDIF.

ENDFORM.
