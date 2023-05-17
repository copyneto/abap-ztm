CLASS zcltm_integrar_medida_cubagem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_selected_table,
        db_key      TYPE /scmtms/d_torrot-db_key,
        tor_id      TYPE /scmtms/d_torrot-tor_id,
        base_btd_id TYPE /scmtms/d_torrot-base_btd_id,
        tor_cat     TYPE /scmtms/d_torrot-tor_cat,
      END   OF ty_selected_table .

    DATA:
      gt_tor TYPE STANDARD TABLE OF ty_selected_table .
    CONSTANTS gc_tor_catg_fu TYPE /scmtms/tor_category VALUE 'FU' ##NO_TEXT.
    CONSTANTS gc_class_msg TYPE symsgid VALUE 'ZTM_INTEG_CUBAGEM' ##NO_TEXT.
    CONSTANTS gc_001 TYPE symsgno VALUE '001'.
    CONSTANTS gc_002 TYPE symsgno VALUE '002'.

    METHODS execute
      IMPORTING
        !it_lista TYPE z195dt_embalagem
      RAISING
        zcxtm_erro_interface .

  PROTECTED SECTION.
  PRIVATE SECTION.



    METHODS insert_table
      IMPORTING
        !it_lista TYPE z195dt_embalagem
      RAISING
        zcxtm_erro_interface .
    METHODS select_data
      IMPORTING
        !it_lista TYPE z195dt_embalagem
      RAISING
        zcxtm_erro_interface .
ENDCLASS.



CLASS zcltm_integrar_medida_cubagem IMPLEMENTATION.


  METHOD execute.

    select_data(
      EXPORTING
        it_lista = it_lista ).
*      IMPORTING
*        et_table = DATA(lt_selected_data) ).

    insert_table(
      EXPORTING
        it_lista         = it_lista ).
*        it_selected_data = lt_selected_data ).

  ENDMETHOD.


  METHOD insert_table.

    DATA:
*      ls_zttm_cubagem TYPE zttm_cubagem,
      lt_zttm_cubagem TYPE STANDARD TABLE OF zttm_cubagem,
      lv_btd_id       TYPE /scmtms/base_btd_id.
*
*    CONSTANTS:
*      BEGIN OF lc_exception,
*        id TYPE symsgid VALUE 'ZTM_INTEG_CUBAGEM',
*        n2 TYPE symsgno VALUE '002',
*      END OF lc_exception.

*    FIELD-SYMBOLS:
*      <fs_lista>         LIKE LINE OF it_lista-lista,
*      <fs_selected_data> LIKE LINE OF it_selected_data.

    LOOP AT it_lista-lista ASSIGNING FIELD-SYMBOL(<fs_lista>).

*      CLEAR:
*        ls_zttm_cubagem.

*      READ TABLE it_selected_data WITH KEY base_btd_id = <fs_lista>-im_remessa BINARY SEARCH
*        ASSIGNING <fs_selected_data>.


*      SHIFT <fs_lista>-im_remessa LEFT DELETING LEADING '0'.

      lv_btd_id = <fs_lista>-im_remessa.
      CONDENSE lv_btd_id NO-GAPS.

      UNPACK lv_btd_id TO lv_btd_id.

      READ TABLE gt_tor
      WITH KEY base_btd_id = lv_btd_id
      ASSIGNING FIELD-SYMBOL(<fs_tor>) BINARY SEARCH.

      IF sy-subrc = 0.

*        ls_zttm_cubagem-mandt         = <fs_selected_data>-tor_id.
        APPEND INITIAL LINE TO lt_zttm_cubagem ASSIGNING FIELD-SYMBOL(<fs_cubagem>).


        <fs_cubagem>-unidade_frete = <fs_tor>-tor_id.
        <fs_cubagem>-remessa       = <fs_lista>-im_remessa.
        <fs_cubagem>-peso_total    = <fs_lista>-im_peso.
        <fs_cubagem>-volume        = <fs_lista>-im_cubagem.
        <fs_cubagem>-data          = sy-datum.
        <fs_cubagem>-hora          = sy-uzeit.

*        APPEND ls_zttm_cubagem TO lt_zttm_cubagem.

      ENDIF.

    ENDLOOP.

    IF lt_zttm_cubagem IS NOT INITIAL.
      MODIFY zttm_cubagem FROM TABLE lt_zttm_cubagem.
      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
      ELSE.
        ROLLBACK WORK.
        RAISE EXCEPTION TYPE zcxtm_erro_interface
          EXPORTING
            iv_textid = VALUE #( msgid = gc_class_msg
                                 msgno = gc_002 ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD select_data.

    DATA: lv_r_btd_id TYPE RANGE OF /scmtms/base_btd_id,
          lv_btd_id   TYPE /scmtms/base_btd_id.

    LOOP AT it_lista-lista ASSIGNING FIELD-SYMBOL(<fs_lista>).

      lv_btd_id = <fs_lista>-im_remessa.
      CONDENSE lv_btd_id NO-GAPS.
      UNPACK lv_btd_id TO lv_btd_id.

      APPEND INITIAL LINE TO lv_r_btd_id ASSIGNING FIELD-SYMBOL(<fs_btd>).
      <fs_btd>-sign = 'I'.
      <fs_btd>-option = 'EQ'.
      <fs_btd>-low = lv_btd_id.
    ENDLOOP.
    CLEAR gt_tor.

    IF lv_r_btd_id IS NOT INITIAL.
      SELECT
        db_key,
        tor_id,
        base_btd_id,
        tor_cat
      FROM /scmtms/d_torrot
      WHERE
        base_btd_id IN @lv_r_btd_id
        AND tor_cat EQ @gc_tor_catg_fu
      INTO TABLE @gt_tor.

      IF sy-subrc EQ 0.
        SORT gt_tor BY base_btd_id.
      ELSE.
        RAISE EXCEPTION TYPE zcxtm_erro_interface
          EXPORTING
            iv_textid = VALUE scx_t100key( msgid = gc_class_msg
                                           msgno = gc_001
                                           attr1 = gc_tor_catg_fu ).
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
