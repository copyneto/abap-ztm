CLASS zcltm_load_file_xml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS read_to_table
      EXPORTING
        !ev_ok    TYPE abap_bool
        !ev_tfile TYPE zctgtm_line_file. "Zcline_file.
    METHODS open
      IMPORTING
        VALUE(iv_path)     TYPE string OPTIONAL
        VALUE(iv_namefile) TYPE string OPTIONAL
        VALUE(iv_fullpath) TYPE string OPTIONAL
        !iv_binary_mode    TYPE abap_bool
        !iv_output         TYPE abap_bool OPTIONAL
      RETURNING
        VALUE(rv_ok)       TYPE abap_bool .
    METHODS write
      IMPORTING
        !iv_texto    TYPE string
      RETURNING
        VALUE(rv_ok) TYPE abap_bool .
    METHODS close
      RETURNING
        VALUE(rv_ok) TYPE abap_bool .
    METHODS get_erro
      RETURNING
        VALUE(rv_erro) TYPE bapiret2_t .
    METHODS refresh
      RETURNING
        VALUE(rv_ok) TYPE abap_bool .
    METHODS move_file
      IMPORTING
        VALUE(iv_pathde) TYPE string OPTIONAL
        VALUE(iv_pathto) TYPE string
      RETURNING
        VALUE(rv_ok)     TYPE abap_bool .
    METHODS reset_file
      RETURNING
        VALUE(rv_ok) TYPE abap_bool .
    METHODS get_fullpath
      RETURNING
        VALUE(rv_path) TYPE char255 .
    METHODS delete
      IMPORTING
        VALUE(iv_path) TYPE string OPTIONAL
      RETURNING
        VALUE(rv_ok)   TYPE abap_bool .
    METHODS force_delete_al11
      IMPORTING
        !iv_namefile TYPE epsf-epsfilnam
        !iv_path     TYPE epsf-epsdirnam .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_file,
        raw(262143) TYPE c,
      END OF ty_file .

  data GT_FILE type ZCTGTM_LINE_FILE .
  data GV_NAMEFILE type STRING .
  data GV_PATH type STRING .
  data GV_FULLPATH type STRING .
  data GV_FILEACTIVE type ABAP_BOOL .
  data GT_BAPIRET2 type BAPIRET2_T .
  constants GC_FILE_NOT_OPEN type CHAR40 value 'Arquivo não está aberto' ##NO_TEXT.
  constants GC_PATH_EMPTY type CHAR40 value 'Diretório informado vazio' ##NO_TEXT.
  constants GC_OPEN_FILE type CHAR60 value 'O SISTEMA OPERACIONAL NÃO PODE ABRIR O ARQUIVO' ##NO_TEXT.

  methods ADD_ERRO
    importing
      !IT_BAPIRET2 type BAPIRET2_TAB .
ENDCLASS.



CLASS ZCLTM_LOAD_FILE_XML IMPLEMENTATION.


  METHOD add_erro.
*    FIELD-SYMBOLS : <fs_s_bapi> LIKE LINE OF gt_bapiret2.
*    IF iv_bapiret2 IS NOT INITIAL.
*      APPEND INITIAL LINE TO gt_bapiret2 ASSIGNING <fs_s_bapi>.
*      <fs_s_bapi> = iv_bapiret2.
*    ENDIF.
    APPEND LINES OF it_bapiret2 TO gt_bapiret2.
  ENDMETHOD.


  METHOD close.
    DATA: lo_cx_root TYPE REF TO cx_root.
    TRY.
        rv_ok = abap_false.
        IF me->gv_fileactive EQ abap_true.
          "Fechar o diretório após a leitura.
          CLOSE DATASET me->gv_fullpath.
          rv_ok = abap_true.
          me->gv_fileactive = abap_false.
        ELSE.
          me->add_erro( NEW zcxtm_upload_file_gko(
                                                    textid      = zcxtm_upload_file_gko=>erro_fechar_arquivo
                                                    gv_msgv1    = CONV msgv1( me->gv_namefile )
                                                 )->get_bapiretreturn( )
                       ).

        ENDIF.

      CATCH cx_root INTO lo_cx_root.
        me->add_erro( NEW zcxtm_upload_file_gko(
                                          textid      = zcxtm_upload_file_gko=>erro_fechar_arquivo
                                          gv_msgv1    = CONV msgv1( me->gv_namefile )
                                          gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                       )->get_bapiretreturn( )
             ).

    ENDTRY.

  ENDMETHOD.


  METHOD delete.
    DATA: lo_cx_root TYPE REF TO cx_root,
          lv_path    TYPE string.

*    CONSTANTS: lc_path_empty TYPE char40 VALUE 'Diretório informado vazio'.

    TRY.
        rv_ok = abap_false.

        IF iv_path IS INITIAL.
          lv_path = me->gv_fullpath.
        ELSE.
          lv_path = iv_path.
        ENDIF.

        IF lv_path IS NOT INITIAL.
          DELETE DATASET lv_path.

          IF sy-subrc = 0.
            rv_ok = abap_true.

            IF iv_path IS INITIAL.
              me->gv_fileactive = abap_false.
            ENDIF.
          ELSE.
            me->add_erro( NEW zcxtm_upload_file_gko(
                                          textid      = zcxtm_upload_file_gko=>erro_deletar_arquivo
                                          gv_msgv1    = CONV msgv1( lv_path )
                                          gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                       )->get_bapiretreturn( )
             ).
          ENDIF.

        ELSE.


          me->add_erro( NEW zcxtm_upload_file_gko(
                                         textid      = zcxtm_upload_file_gko=>erro_deletar_arquivo
                                         gv_msgv1    = ''
                                         gv_msgv2    = CONV msgv2( gc_path_empty )

                                      )->get_bapiretreturn( )
            ).

        ENDIF.

      CATCH cx_root INTO lo_cx_root.

        me->add_erro( NEW zcxtm_upload_file_gko(
                                          textid      = zcxtm_upload_file_gko=>erro_deletar_arquivo
                                          gv_msgv1    = CONV msgv1( lv_path )
                                          gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                       )->get_bapiretreturn( )
             ).
    ENDTRY.

  ENDMETHOD.


  METHOD force_delete_al11.
    DATA: lo_cx_root TYPE REF TO cx_root,
          lv_msg     TYPE c LENGTH 60.

    TRY.
        CALL FUNCTION 'EPS_DELETE_FILE'
          EXPORTING
            file_name              = iv_namefile
            dir_name               = iv_path
          EXCEPTIONS
            invalid_eps_subdir     = 1
            sapgparam_failed       = 2
            build_directory_failed = 3
            no_authorization       = 4
            build_path_failed      = 5
            delete_failed          = 6
            OTHERS                 = 7.

        IF sy-subrc <> 0.
          CASE sy-subrc.
            WHEN 1.
              lv_msg = text-001."'invalid_eps_subdir'.
            WHEN 2.
              lv_msg = text-002. "'sapgparam_failed'.
            WHEN 3.
              lv_msg = text-003. "'build_directory_failed'.
            WHEN 4.
              lv_msg = text-004. "'no_authorization'.
            WHEN 5.
              lv_msg = text-005. "'build_path_failed'.
            WHEN 6.
              lv_msg = text-006. "'delete_failed'.
            WHEN OTHERS.
              lv_msg = text-007. "'Others'.
          ENDCASE.


          me->add_erro( NEW zcxtm_upload_file_gko(
                                          textid      = zcxtm_upload_file_gko=>erro_deletar_arquivo
                                          gv_msgv1    = CONV msgv1( iv_namefile )
                                          gv_msgv2    = CONV msgv2( lv_msg )

                                       )->get_bapiretreturn( )
             ).


        ENDIF.
      CATCH cx_root INTO lo_cx_root.

        me->add_erro( NEW zcxtm_upload_file_gko(
                                           textid      = zcxtm_upload_file_gko=>erro_deletar_arquivo
                                           gv_msgv1    = CONV msgv1( iv_namefile )
                                           gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                        )->get_bapiretreturn( )
              ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_erro.
    rv_erro = gt_bapiret2.
  ENDMETHOD.


  METHOD get_fullpath.

    rv_path = me->gv_fullpath.

  ENDMETHOD.


  METHOD move_file.
    DATA: lo_cx_root TYPE REF TO cx_root,
          lv_path    TYPE string,
          lv_ok      TYPE abap_bool,
          lv_close   TYPE abap_bool,
          lt_file    TYPE zctgtm_line_file,
          lv_binary  TYPE abap_bool,
          lv_texto   TYPE string.

    TRY.
        rv_ok = abap_false.
        lv_ok = abap_true.
        lv_binary = abap_false.

        IF iv_pathde IS INITIAL.
          lv_path = me->gv_fullpath.
        ELSE.
          lv_path = iv_pathde.
        ENDIF.

        IF me->gv_fileactive = abap_false.

          lv_binary = abap_true.
          lv_ok = open(
             EXPORTING
               iv_fullpath    = lv_path
               iv_binary_mode = lv_binary
               iv_output      = abap_false
           ).
*          lv_close = lv_ok.
*          IF lv_ok = abap_true.
          me->read_to_table(
            IMPORTING
              ev_ok    = lv_ok
              ev_tfile = lt_file                  " Categoria de tabela do arquivo
          ).
*          ENDIF.

          IF lv_ok EQ abap_false.
            lv_ok = close( ).

          ENDIF.
        ELSE.
          IF me->gt_file IS INITIAL.
            me->read_to_table(
            IMPORTING
              ev_ok    = lv_ok
              ev_tfile = lt_file                  " Categoria de tabela do arquivo
          ).
          ELSE.
            lt_file = me->gt_file.
          ENDIF.
        ENDIF.

        IF lv_ok = abap_true.
          lv_ok = me->close( ). "fechando o arquivo atual.

          IF me->open( EXPORTING iv_fullpath = iv_pathto iv_binary_mode = lv_binary iv_output = abap_true ) EQ abap_true.

            LOOP AT lt_file ASSIGNING FIELD-SYMBOL(<fs_s_file>).

              lv_texto = <fs_s_file>-line .
              me->write( lv_texto ).
            ENDLOOP.
            me->close( ).
            lv_ok = me->delete( lv_path ). "deletando o arquivo da origem
            rv_ok = lv_ok.
          ENDIF.

        ENDIF.

      CATCH cx_root INTO lo_cx_root.

        me->add_erro( NEW zcxtm_upload_file_gko(
                                         textid      = zcxtm_upload_file_gko=>erro_mover_arquivo
                                         gv_msgv1    = CONV msgv1( lv_path )
                                         gv_msgv2    = CONV msgv2( iv_pathto )
                                         gv_msgv3    = CONV msgv3( lo_cx_root->get_text( ) )


                                      )->get_bapiretreturn( )
            ).

    ENDTRY.




  ENDMETHOD.


  METHOD open.
    DATA: lo_cx_root TYPE REF TO cx_root.

*    CONSTANTS: lc_open_file  TYPE char60 VALUE 'O sistema operacional não pode abrir o arquivo',
*               lc_path_empty TYPE char40 VALUE 'Caminho ou nome do arquivo em branco.'.

    TRY.
        me->gv_fileactive = abap_false.
        rv_ok = abap_false.
        CLEAR: me->gt_bapiret2.

        IF ( iv_path IS NOT INITIAL AND iv_namefile IS NOT INITIAL ).
          me->gv_fullpath = iv_path && iv_namefile.
        ELSE.
          me->gv_fullpath = iv_fullpath.
        ENDIF.

        IF me->gv_fullpath IS NOT INITIAL.
          IF iv_output = abap_false.
            "Abrir o diretório para leitura do arquivo.
            IF iv_binary_mode IS INITIAL.
              OPEN DATASET me->gv_fullpath IN TEXT MODE FOR INPUT ENCODING UTF-8.
            ELSE.
              OPEN DATASET me->gv_fullpath FOR INPUT IN BINARY MODE.
            ENDIF.
          ELSE.
            IF iv_binary_mode IS INITIAL.
              OPEN DATASET me->gv_fullpath IN TEXT MODE FOR OUTPUT ENCODING UTF-8.
            ELSE.
              OPEN DATASET me->gv_fullpath FOR OUTPUT IN BINARY MODE.
            ENDIF.
          ENDIF.

          IF sy-subrc = 0.
            rv_ok = abap_true.
            me->gv_fileactive = abap_true.
          ELSE.

            me->add_erro( NEW zcxtm_upload_file_gko(
                                        textid      = zcxtm_upload_file_gko=>erro_abrir_arquivo
                                        gv_msgv1    = CONV msgv1( me->gv_fullpath )
                                        gv_msgv2    = CONV msgv2( gc_open_file )
                                     )->get_bapiretreturn( )
                        ).

          ENDIF.
        ELSE.

          me->add_erro( NEW zcxtm_upload_file_gko(
                                                    textid      = zcxtm_upload_file_gko=>erro_abrir_arquivo
                                                    gv_msgv1    = CONV msgv1( me->gv_fullpath )
                                                    gv_msgv2    = CONV msgv2( gc_path_empty )
                                                  )->get_bapiretreturn( )
                       ).

        ENDIF.

      CATCH cx_root INTO lo_cx_root.

        me->add_erro( NEW zcxtm_upload_file_gko(
                                         textid      = zcxtm_upload_file_gko=>erro_abrir_arquivo
                                         gv_msgv1    = CONV msgv1( me->gv_fullpath )
                                         gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                      )->get_bapiretreturn( )
            ).

    ENDTRY.

  ENDMETHOD.


  METHOD read_to_table.

    DATA: lo_cx_root TYPE REF TO cx_root,
          ls_file    TYPE ty_file.

    FIELD-SYMBOLS: <fs_s_file> LIKE LINE OF gt_file.

*    CONSTANTS : lc_file_not_open TYPE char30 VALUE 'Arquivo não está aberto.'.

    TRY.
        ev_ok = abap_false.
        CLEAR: me->gt_bapiret2,
               me->gt_file.

        IF me->gv_fileactive EQ abap_true.

          DO.
            READ DATASET me->gv_fullpath INTO ls_file.

            IF sy-subrc = 0.
              APPEND INITIAL LINE TO gt_file ASSIGNING <fs_s_file>.
              <fs_s_file>-line = ls_file.
*              APPEND ls_file TO gt_file.
            ELSE.
              EXIT.
            ENDIF.
          ENDDO.
          ev_ok    = abap_true.
          ev_tfile = me->gt_file.
        ELSE.

          me->add_erro( NEW zcxtm_upload_file_gko(
                                                textid      = zcxtm_upload_file_gko=>erro_ler_arquivo
                                                gv_msgv1    = CONV msgv1( me->gv_namefile )
                                                gv_msgv2    = CONV msgv2( gc_file_not_open )

                                             )->get_bapiretreturn( )
                       ).
        ENDIF.

      CATCH cx_root INTO lo_cx_root.

        me->add_erro( NEW zcxtm_upload_file_gko(
                                                  textid      = zcxtm_upload_file_gko=>erro_ler_arquivo
                                                  gv_msgv1    = CONV msgv1( me->gv_namefile )
                                                  gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                               )->get_bapiretreturn( )
                     ).

    ENDTRY.
  ENDMETHOD.


  METHOD refresh.
    DATA: lo_cx_root TYPE REF TO cx_root.
    TRY.
        rv_ok = abap_false.
        CLEAR: me->gt_bapiret2,
               me->gt_file,
               me->gv_fullpath,
               me->gv_namefile,
               me->gv_path.

        IF me->gv_fileactive = abap_true.
          IF me->close( ) EQ abap_false."fechando o arquivo
            rv_ok = abap_false.
          ENDIF.
        ENDIF.
        rv_ok = abap_true.
      CATCH cx_root INTO lo_cx_root.
        rv_ok = abap_false.

    ENDTRY.

  ENDMETHOD.


  METHOD reset_file.
    DATA: lo_cx_root TYPE REF TO cx_root.

*    CONSTANTS: lc_file_not_open TYPE char40 VALUE text-001.

    TRY.
        rv_ok = abap_false.
        IF me->gv_fileactive = abap_true.
          SET DATASET me->gv_fullpath POSITION 0.
          rv_ok = abap_true.
        ELSE.

          me->add_erro( NEW zcxtm_upload_file_gko(
                                                 textid      = zcxtm_upload_file_gko=>erro_posicionar_ponteiro
                                                 gv_msgv1    = CONV msgv1( me->gv_fullpath )
                                                 gv_msgv2    = CONV msgv2( gc_file_not_open )

                                              )->get_bapiretreturn( )
                    ).
        ENDIF.
      CATCH cx_root INTO lo_cx_root.

        me->add_erro( NEW zcxtm_upload_file_gko(
                                                  textid      = zcxtm_upload_file_gko=>erro_posicionar_ponteiro
                                                  gv_msgv1    = CONV msgv1( me->gv_fullpath )
                                                  gv_msgv2    = CONV msgv2( lo_cx_root->get_text( ) )

                                               )->get_bapiretreturn( )
                    ).
    ENDTRY.

  ENDMETHOD.


  METHOD write.
    DATA: lo_cx_root TYPE REF TO cx_root.

*    CONSTANTS: lc_file_not_open(40) VALUE 'Arquivo não está aberto'.

    TRY.
        rv_ok = abap_false.
        IF me->gv_fileactive = abap_true.
          TRANSFER iv_texto TO me->gv_fullpath.
          rv_ok = abap_true.
        ELSE.
          me->add_erro( NEW zcxtm_upload_file_gko(
                                                  textid      = zcxtm_upload_file_gko=>erro_escrever_arquivo
                                                  gv_msgv1    = CONV msgv1( gc_file_not_open )

                                               )->get_bapiretreturn( )
                     ).

        ENDIF.

      CATCH cx_root INTO lo_cx_root.


        me->add_erro( NEW zcxtm_upload_file_gko(
                                                 textid      = zcxtm_upload_file_gko=>erro_escrever_arquivo
                                                gv_msgv1    = CONV msgv1( lo_cx_root->get_text( ) )

                                              )->get_bapiretreturn( )
                     ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
