***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Confirmãção de pagamento faturas agrupadas             *
*** AUTOR : GUIDO OLIVAN                                              *
*** FUNCIONAL: Jefferson Alcantara – META                             *
*** DATA : 10.05.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA  | AUTOR | DESCRIÇÃO                                         *
***-------------------------------------------------------------------*
***       |       |                                                   *
***********************************************************************
REPORT ztmr_confirma_pagamento.

TABLES:
  zttm_gkot001.


DATA: gt_zttm_gkot001 TYPE zctgtm_gkot001.


SELECT-OPTIONS:
  s_bukrs    FOR zttm_gkot001-bukrs,
  s_tpdoc    FOR zttm_gkot001-tpdoc,
  s_cena     FOR zttm_gkot001-cenario,
  s_dtemi    FOR zttm_gkot001-dtemi,
  s_belnr    FOR zttm_gkot001-belnr,
  s_gjahr    FOR zttm_gkot001-gjahr.


START-OF-SELECTION.

  SELECT * INTO TABLE @gt_zttm_gkot001
    FROM zttm_gkot001
    WHERE tpdoc    IN @s_tpdoc
      AND bukrs    IN @s_bukrs
      AND cenario  IN @s_cena
      AND dtemi    IN @s_dtemi
      AND belnr    IN @s_belnr
      AND gjahr    IN @s_gjahr
      AND codstatus = '500'. "Agrupado


  DATA(lo_confirma_pagto) = NEW zcltm_confirma_pagamento( ).

  DATA(lt_docs_pagos) = lo_confirma_pagto->execute( it_zttm_gkot001 = gt_zttm_gkot001
                                                    iv_atualiza     = abap_true ).





  PERFORM f_display_alv CHANGING lt_docs_pagos.

END-OF-SELECTION.


FORM f_display_alv CHANGING ct_outtab TYPE zctgtm_gkot001.

* Tabelas internas locais
  DATA:
    lt_fcat             TYPE lvc_t_fcat.

* Workareas
  DATA:
    ls_layout           TYPE lvc_s_layo.

* Monta o catalogo de campos
  PERFORM f_build_fieldcat CHANGING lt_fcat
                                  ct_outtab.

* Configura layout
  ls_layout-cwidth_opt  = abap_true.
  ls_layout-sel_mode    = 'A'.
*  ls_layout-box_fname   = 'MARK'.


* Mostra ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
*     i_callback_pf_status_set = 'SET_STATUS'
*     i_callback_user_command  = 'USER_COMMAND'
      is_layout_lvc      = ls_layout
      it_fieldcat_lvc    = lt_fcat
      i_save             = 'A'
*     is_variant         = gs_variant
    TABLES
      t_outtab           = ct_outtab[]
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid
          TYPE 'S'
        NUMBER sy-msgno
          WITH sy-msgv1
               sy-msgv2
               sy-msgv3
               sy-msgv4
         DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

FORM f_build_fieldcat CHANGING ct_fcat   TYPE lvc_t_fcat
                               ct_outtab TYPE zctgtm_gkot001.

* Objetos locais
  DATA:
    lo_salv_table        TYPE REF TO cl_salv_table,
    lo_salv_columns      TYPE REF TO cl_salv_columns_table,
    lo_salv_aggregations TYPE REF TO cl_salv_aggregations,
    lo_cx_root           TYPE REF TO cx_root.


  IF ct_outtab IS INITIAL.
    DATA(lv_edit)  = abap_true.
  ENDIF.


* Variáveis
  DATA:
    lv_text                 TYPE string.

* Field-symbols
  FIELD-SYMBOLS:
    <lf_outtab> TYPE ANY TABLE,
    <fl_fcat>   TYPE lvc_s_fcat.

  ASSIGN ct_outtab[] TO <lf_outtab>.

  TRY .
*     Gerando ALV OM
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lo_salv_table
        CHANGING
          t_table      = <lf_outtab>.

*     Buscar as informações das colunas da ALV
      lo_salv_columns      = lo_salv_table->get_columns( ).
      lo_salv_aggregations = lo_salv_table->get_aggregations( ).
      ct_fcat              = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                                                 r_columns             = lo_salv_columns
                                                 r_aggregations        = lo_salv_aggregations ).

    CATCH cx_root INTO lo_cx_root.                       "#EC CATCH_ALL
      lv_text = lo_cx_root->get_text( ).
      MESSAGE lv_text TYPE 'S' DISPLAY LIKE 'E'.
      STOP.
  ENDTRY.

* Tratamento para campos específicos
  LOOP AT ct_fcat ASSIGNING <fl_fcat>.
    CASE <fl_fcat>-fieldname.
      WHEN 'MANDT'.
        <fl_fcat>-no_out = abap_true.
      WHEN 'MARK'.
        <fl_fcat>-no_out = abap_true.
*      WHEN 'NR_PALS'.
*        <fl_fcat>-outputlen = 6.
*        <fl_fcat>-scrtext_l = 'Qtde pal previsto'.
*        <fl_fcat>-scrtext_m = 'Qtde pal prev'.
*        <fl_fcat>-scrtext_s = 'QtPlPrev'.
*        <fl_fcat>-reptext   = 'Qtde pal previsto'.
      WHEN OTHERS.
*        <fl_fcat>-no_out = abap_true.

    ENDCASE.

  ENDLOOP.

ENDFORM.
