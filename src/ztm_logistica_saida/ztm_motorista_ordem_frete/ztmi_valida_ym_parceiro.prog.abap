*&---------------------------------------------------------------------*
*& Include          ZTMI_VALIDA_YM_PARCEIRO
*&---------------------------------------------------------------------*

IF line_exists( lt_selopt_roles[ low = 'BUP003' ] ).

  SELECT partner, name1_text
    FROM but000
    INTO TABLE @DATA(lt_but000)
    WHERE bpkind = '0011'.

  IF sy-subrc IS INITIAL.
    LOOP AT ct_result INTO DATA(ls_result).
      READ TABLE lt_but000 INTO DATA(ls_but000) WITH KEY partner = ls_result-partner.
      IF sy-subrc IS INITIAL.
        DELETE lt_but000 WHERE partner = ls_but000-partner .
      ELSE.
        DELETE ct_result WHERE partner = ls_result-partner .
      ENDIF.
    ENDLOOP.
    CLEAR ls_result.
    LOOP AT lt_but000 ASSIGNING FIELD-SYMBOL(<fs_but000>).
      ls_result-partner = <fs_but000>-partner.
      ls_result-description = <fs_but000>-name1_text.

      APPEND ls_result TO ct_result.
      CLEAR  ls_result.
    ENDLOOP.
  ENDIF.
ENDIF.
