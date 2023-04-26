class ZCLTM_UPLOAD_FILE_GKO definition
  public
  final
  create public .

public section.

  constants GC_EXTENSAOFILE type CHAR3 value 'xml' ##NO_TEXT.
  constants GC_TPDOC_CTE type ZE_GKO_TPDOC value 'CTE' ##NO_TEXT.
  constants GC_TPDOC_NFS type ZE_GKO_TPDOC value 'NFS' ##NO_TEXT.
  constants GC_SIGN_I type CHAR1 value 'I' ##NO_TEXT.
  constants GC_OPTION_EQ type CHAR2 value 'EQ' ##NO_TEXT.
  constants GC_LOG_NMOBJ type BALOBJ_D value 'ZTM' ##NO_TEXT.
  constants GC_LOG_NMSUBOBJ type BALSUBOBJ value 'ZGKO' ##NO_TEXT.

  methods PROCESS
    importing
      !IV_PATH type EPS2FILNAM .
  PROTECTED SECTION.
private section.

  data:
    gt_gko TYPE STANDARD TABLE OF zttm_gkot001 .
  data GT_LOG type BAPIRET2_TAB .

  methods PROCESS_NF
    importing
      !IT_XML_INFO type ZCTGTM_XML_INFO
      !IV_NAMEFILE type EPS2FILNAM .
  methods PROCESS_NF_GKO
    importing
      !IT_XML_INFO type ZCTGTM_XML_INFO
      !IV_NAMEFILE type EPS2FILNAM .
  methods SAVE_DATA .
  methods SAVE_LOG .
  methods GET_VALUE_TAG_XML
    importing
      !IT_XML type ZCTGTM_XML_INFO
      !IV_TAG type CHAR255
    returning
      value(RV_VALUE) type CHAR255 .
ENDCLASS.



CLASS ZCLTM_UPLOAD_FILE_GKO IMPLEMENTATION.


  METHOD get_value_tag_xml.

    READ TABLE it_xml
      WITH KEY cname = iv_tag
      BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_xml>).

    IF sy-subrc = 0.
      rv_value = <fs_xml>-cvalue.
    ENDIF.

  ENDMETHOD.


  METHOD process.

    TYPES: BEGIN OF ty_xml,
             raw(262143) TYPE c,
           END    OF ty_xml.
    DATA: lt_arquivos    TYPE STANDARD TABLE OF eps2fili,
          lo_file        TYPE REF TO zcltm_load_file_xml,
          lv_namefile    TYPE eps2filnam,
          lv_validofile  TYPE abap_bool,
          lv_tamnmfile   TYPE i,
          lv_tamextensao TYPE i,
          lv_tamaux      TYPE i,
          lv_ok          TYPE abap_bool,
          lt_xml_tab     TYPE zctgtm_line_file,
          lt_xml_texto   TYPE STANDARD TABLE OF ty_xml,
          lv_str         TYPE string,
          lv_xmldata     TYPE xstring,
          lt_xml_info    TYPE STANDARD TABLE OF smum_xmltb,
          lt_return      TYPE STANDARD TABLE OF bapiret2,
          lv_path        TYPE eps2filnam.

    CONSTANTS : lc_nfe TYPE c LENGTH 3 VALUE 'NFe',
                lc_gko TYPE c LENGTH 8 VALUE 'ZGKO_NFS'.


    TRY.
        lv_path = iv_path.
        lv_path = '/interfaces/S4D/GKO/'.

        CALL FUNCTION 'EPS2_GET_DIRECTORY_LISTING'
          EXPORTING
            iv_dir_name            = lv_path
          TABLES
            dir_list               = lt_arquivos
          EXCEPTIONS
            invalid_eps_subdir     = 1
            sapgparam_failed       = 2
            build_directory_failed = 3
            no_authorization       = 4
            read_directory_failed  = 5
            too_many_read_errors   = 6
            empty_directory_list   = 7
            OTHERS                 = 8.

        IF sy-subrc EQ 0 AND  lt_arquivos IS NOT INITIAL.

          lv_tamextensao = strlen( gc_extensaofile ).
          lo_file = NEW zcltm_load_file_xml( ).

          LOOP AT lt_arquivos ASSIGNING FIELD-SYMBOL(<fs_arquivos>).
            lv_namefile = <fs_arquivos>-name.
            CONDENSE lv_namefile NO-GAPS.

            lv_validofile = abap_true.
            lv_tamnmfile = strlen( lv_namefile ).

            IF lv_tamnmfile <= lv_tamextensao.
              lv_validofile = abap_false.
            ELSE.
              lv_tamaux = lv_tamnmfile - 3.

              IF ( lv_namefile+lv_tamaux(lv_tamextensao) NE gc_extensaofile ).
                lv_validofile = abap_false.
              ENDIF.

            ENDIF.

            IF lv_validofile EQ abap_true.

              IF lo_file->open(
                                EXPORTING
                                  iv_path        = CONV string( lv_path )
                                  iv_namefile    = CONV string( lv_namefile )
                                  iv_binary_mode = abap_false
                              ) EQ abap_true.

                CLEAR: lt_xml_tab,
                       lv_ok,
                       lt_xml_texto,
                       lt_xml_tab,
                       lt_xml_texto,
                       lv_str,
                       lv_xmldata,
                       lt_xml_info,
                       lt_return,
                       lt_xml_info.

                lo_file->read_to_table(
                                         IMPORTING
                                           ev_ok    = lv_ok
                                           ev_tfile = lt_xml_tab
                                       ).

                IF lv_ok = abap_true.

                  IF lt_xml_tab IS NOT INITIAL.
                    LOOP AT lt_xml_tab ASSIGNING FIELD-SYMBOL(<fs_xmltab>).
                      APPEND INITIAL LINE TO lt_xml_texto ASSIGNING FIELD-SYMBOL(<fs_xmltxt>).
                      <fs_xmltxt> = <fs_xmltab>-line.
                    ENDLOOP.

                    CLEAR lv_str.
                    "Concatenar as linhas do XML em uma string.
                    CONCATENATE LINES OF lt_xml_texto INTO lv_str .

                    "Converter a String em uma XString.
                    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
                      EXPORTING
                        text   = lv_str
                      IMPORTING
                        buffer = lv_xmldata
                      EXCEPTIONS
                        failed = 1
                        OTHERS = 2.
                    IF sy-subrc = 0.
                      "Converter a XString e salvar as TAGS do XML na tabela t_xml_info.
                      CALL FUNCTION 'SMUM_XML_PARSE' ##FM_SUBRC_OK
                        EXPORTING
                          xml_input = lv_xmldata
                        TABLES
                          xml_table = lt_xml_info
                          return    = lt_return
                        EXCEPTIONS
                          OTHERS    = 1.



                      IF sy-subrc = 0.
                        DATA(lt_aux) = lt_xml_info.

                        SORT lt_aux BY cname.

                        READ TABLE lt_aux
                        WITH KEY cname = lc_nfe
                        BINARY SEARCH TRANSPORTING NO FIELDS.
                        IF sy-subrc = 0.
                          "processamento os arquivos de NFs

                          process_nf(
                                       EXPORTING
                                         it_xml_info =  lt_xml_info
                                         iv_namefile =  lv_namefile
                                     ).
                        ELSE.
                          READ TABLE lt_aux
                          WITH KEY cname = lc_gko
                          BINARY SEARCH TRANSPORTING NO FIELDS.
                          IF sy-subrc = 0.
                            "processando os arquivos do gko
                            process_nf_gko(
                                                EXPORTING
                                                  it_xml_info =  lt_xml_info
                                                  iv_namefile =  lv_namefile
                                          ).

                          ENDIF.
                        ENDIF.
                      ELSEIF sy-subrc NE 0.
                        "Erro na conversão de xstring para as Tags xml. Arquivo &GV_MSGV1&
                        APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                    textid      = zcxtm_upload_file_gko=>erro_conversao_xstring_tags
                                                    gv_msgv1    = CONV msgv1( lv_namefile )
                                                 )->get_bapiretreturn( )
                                     TO gt_log.

                        IF lt_return IS NOT INITIAL.
                          APPEND LINES OF lt_return TO gt_log.
                        ENDIF.
                      ENDIF.

                    ELSE.
                      "erro na conversao do arquivo para xstring
                      APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                    textid      = zcxtm_upload_file_gko=>erro_convesrao_string_xstring
                                                    gv_msgv1    = CONV msgv1( lv_namefile )
                                                 )->get_bapiretreturn( )
                                     TO gt_log.
                    ENDIF.

                  ELSE.
                    "mover ou deletar arquivo
*                    lo_file->force_delete_al11(
*                      EXPORTING
*                        iv_namefile = CONV string( lv_namefile )
*                        iv_path     = CONV string( lv_path )
*                    ).

                  ENDIF.

                ELSE.
                  APPEND LINES OF lo_file->get_erro( ) TO gt_log.
                ENDIF.

              ELSE.
                APPEND LINES OF lo_file->get_erro( ) TO gt_log.
              ENDIF.

            ENDIF.

          ENDLOOP.
          save_data( ).

        ENDIF.

      CATCH cx_root INTO DATA(LO_cx_root).


    ENDTRY.
    save_log( ).

  ENDMETHOD.


  METHOD process_nf.

    DATA: ls_acckey  TYPE j_1b_nfe_access_key,
          lt_acckey  TYPE STANDARD TABLE OF j_1b_nfe_access_key,
          lr_acckey  TYPE RANGE OF j_1b_nfe_access_key_dtel44,
          ls_gko     TYPE zttm_gkot001,
          lv_ano     TYPE c LENGTH 4,
          lv_mes     TYPE c LENGTH 2,
          lv_dia     TYPE c LENGTH 2,
          lv_docdata TYPE c LENGTH 10,
          lv_liss    TYPE abap_bool,
          lv_licms   TYPE abap_bool,
          lv_lemit   TYPE abap_bool,
          lv_ldest   TYPE abap_bool.

    DATA(lt_aux_xml) = it_xml_info.

    CONSTANTS: lc_tagkey       TYPE char255 VALUE 'chNFe',
               lc_VTPREST      TYPE char255 VALUE 'vPag',
               lc_prefno       TYPE char255 VALUE 'nNF',
               lc_cfop         TYPE char255 VALUE 'CFOP',

               lc_icmsvb       TYPE char255 VALUE 'vBC',
               lc_icmsvlr      TYPE char255 VALUE 'vICMS',

               lc_issvb        TYPE char255 VALUE 'vBC',
               lc_issvlr       TYPE char255 VALUE 'vISS',

               lc_cnpj         TYPE char255 VALUE 'CNPJ',
               lc_ie           TYPE char255 VALUE 'IE',
               lc_uf           TYPE char255 VALUE 'UF',

               lc_docdat       TYPE char255 VALUE 'dhEmi',
               lc_status_integ TYPE ze_gko_codstatus VALUE '100',
               lc_sep_data     TYPE c VALUE '-'.

    SORT lt_aux_xml BY cname.

    READ TABLE lt_aux_xml
    WITH KEY cname = lc_tagkey
    BINARY SEARCH TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.

      LOOP AT lt_aux_xml FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_aux>).
        IF <fs_aux>-cname NE lc_tagkey.
          EXIT.
        ENDIF.

        APPEND INITIAL LINE TO lt_acckey ASSIGNING FIELD-SYMBOL(<fs_s_acckey>).
        <fs_s_acckey> = <fs_aux>-cvalue.

        APPEND INITIAL LINE TO lr_acckey ASSIGNING FIELD-SYMBOL(<fs_r_acckey>).
        <fs_r_acckey>-sign   = gc_sign_i.
        <fs_r_acckey>-option = gc_option_eq.
        <fs_r_acckey>-low    =  <fs_aux>-cvalue.
      ENDLOOP.

      IF lt_acckey IS NOT INITIAL.

        SELECT
          docnum,
          direct,
          regio,
          nfyear,
          nfmonth,
          stcd1,
          model,
          serie,
          nfnum9,
          docnum9,
          cdv,
          bukrs,
          branch
        FROM j_1bnfe_active FOR ALL ENTRIES IN @lt_acckey
        WHERE regio       = @lt_acckey-regio
              AND nfyear  = @lt_acckey-nfyear
              AND nfmonth = @lt_acckey-nfmonth
              AND stcd1   = @lt_acckey-stcd1
              AND model   = @lt_acckey-model
              AND serie   = @lt_acckey-serie
              AND nfnum9  = @lt_acckey-nfnum9
              AND docnum9 = @lt_acckey-docnum9
              AND cdv     = @lt_acckey-cdv
*              AND direct  IN ('1','2') "Entrada e Saida
              AND cancel  EQ @abap_false
        INTO TABLE @DATA(lt_active).

        IF sy-subrc = 0.
          SORT  lt_acckey BY regio nfyear nfmonth stcd1 model serie nfnum9 docnum9 cdv.
        ENDIF.

      ENDIF.

      IF lr_acckey IS NOT INITIAL.
        SELECT
          acckey
        FROM zttm_gkot001
        WHERE acckey IN @lr_acckey
        INTO TABLE @DATA(lt_auxgko).
        IF sy-subrc = 0.
          SORT lt_auxgko BY acckey.
        ENDIF.
      ENDIF.

      ls_gko-codstatus = lc_status_integ.
      ls_gko-tpdoc     = gc_tpdoc_nfs.
      ls_gko-credat    = sy-datum.
      ls_gko-cretim    = sy-uzeit.

      lv_docdata = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_docdat
                                       ).

      SPLIT lv_docdata AT lc_sep_data INTO lv_ano lv_mes lv_dia.

      IF lv_ano IS NOT INITIAL AND  lv_mes IS NOT INITIAL AND lv_dia IS NOT INITIAL.
        ls_gko-dtemi = lv_ano && lv_mes && lv_dia.
      ENDIF.

      ls_gko-prefno = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_prefno
                                       ).

      "valores
      ls_gko-vtprest = get_value_tag_xml(
                                            it_xml = lt_aux_xml
                                            iv_tag = lc_vtprest
                                          ).

      ls_gko-cfop = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_cfop
                                       ).


      LOOP AT it_xml_info ASSIGNING FIELD-SYMBOL(<fs_xml>).

        IF <fs_xml>-cname = 'infAdic'.
          EXIT.
        ENDIF.

        IF <fs_xml>-cname = 'emit'.
          lv_lemit = abap_true.

          lv_licms = abap_false.
          lv_liss  = abap_false.
          lv_ldest = abap_false.
        ENDIF.

        IF <fs_xml>-cname = 'dest'.

          lv_ldest = abap_false.

          lv_lemit = abap_false.
          lv_licms = abap_false.
          lv_liss  = abap_false.

        ENDIF.


        IF <fs_xml>-cname = 'ICMSTot'.
          lv_licms = abap_true.

          lv_liss  = abap_false.
          lv_lemit = abap_false.
          lv_ldest = abap_false.

        ENDIF.

        IF <fs_xml>-cname = 'ISSQNtot'.
          lv_liss  = abap_true.

          lv_licms = abap_false.
          lv_lemit = abap_false.
          lv_ldest = abap_false.
        ENDIF.

        IF lv_licms = abap_true AND <fs_xml>-cname = lc_icmsvb AND ls_gko-vbcicms IS NOT INITIAL.
          ls_gko-vbcicms = <fs_xml>-cvalue.
        ENDIF.

        IF lv_licms = abap_true AND <fs_xml>-cname = lc_icmsvlr AND ls_gko-vicms IS NOT INITIAL.
          ls_gko-vicms = <fs_xml>-cvalue.
        ENDIF.


        IF lv_liss = abap_true AND <fs_xml>-cname = lc_issvb AND ls_gko-vbciss IS NOT INITIAL.
          ls_gko-vbciss = <fs_xml>-cvalue.
        ENDIF.

        IF lv_liss = abap_true AND <fs_xml>-cname = lc_issvlr AND ls_gko-viss IS NOT INITIAL.
          ls_gko-viss = <fs_xml>-cvalue.
        ENDIF.


        IF lv_lemit = abap_true AND <fs_xml>-cname = lc_cnpj AND ls_gko-emit_cnpj_cpf IS NOT INITIAL.
          ls_gko-emit_cnpj_cpf = <fs_xml>-cvalue.
        ENDIF.

        IF lv_lemit = abap_true AND <fs_xml>-cname = lc_ie AND ls_gko-emit_ie IS NOT INITIAL.
          ls_gko-emit_ie = <fs_xml>-cvalue.
        ENDIF.

        IF lv_lemit = abap_true AND <fs_xml>-cname = lc_uf AND ls_gko-emit_uf IS NOT INITIAL.
          ls_gko-emit_uf = <fs_xml>-cvalue.
        ENDIF.


        IF lv_ldest = abap_true AND <fs_xml>-cname = lc_cnpj AND ls_gko-dest_cnpj  IS NOT INITIAL.
          ls_gko-dest_cnpj = <fs_xml>-cvalue.

          IF strlen( ls_gko-dest_cnpj ) <= 11.
            ls_gko-dest_cpf = ls_gko-dest_cnpj.
            CLEAR ls_gko-dest_cnpj.
          ENDIF.

        ENDIF.

        IF lv_ldest = abap_true AND <fs_xml>-cname = lc_ie AND ls_gko-dest_ie IS NOT INITIAL.
          ls_gko-dest_ie = <fs_xml>-cvalue.
        ENDIF.

        IF lv_ldest = abap_true AND <fs_xml>-cname = lc_uf AND ls_gko-dest_uf IS NOT INITIAL.
          ls_gko-dest_uf = <fs_xml>-cvalue.
        ENDIF.

      ENDLOOP.

      LOOP AT lr_acckey ASSIGNING <fs_r_acckey>.

        READ TABLE lt_auxgko
        WITH KEY acckey = <fs_r_acckey>-low
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          ls_acckey = <fs_r_acckey>-low.

          READ TABLE lt_active
          WITH KEY regio       = ls_acckey-regio
                   nfyear      = ls_acckey-nfyear
                   nfmonth     = ls_acckey-nfmonth
                   stcd1       = ls_acckey-stcd1
                   model       = ls_acckey-model
                   serie       = ls_acckey-serie
                   nfnum9      = ls_acckey-nfnum9
                   docnum9     = ls_acckey-docnum9
                   cdv         = ls_acckey-cdv
          BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_acckey>).

          IF sy-subrc = 0.
            ls_gko-acckey = ls_acckey.
            ls_gko-bukrs  = <fs_acckey>-bukrs.
            ls_gko-branch = <fs_acckey>-branch.
            ls_gko-direct = <fs_acckey>-direct.
            ls_gko-model  = <fs_acckey>-model.
            ls_gko-nfnum9 = <fs_acckey>-nfnum9.
            ls_gko-series = <fs_acckey>-serie.

            APPEND INITIAL LINE TO gt_gko ASSIGNING FIELD-SYMBOL(<fs_gko>).
            <fs_gko> = ls_gko.

          ELSE.
            "chave xxx do arquivo xxxx nao localizado dentro sap
            APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                  textid      = zcxtm_upload_file_gko=>chave_nao_localizada
                                                  gv_msgv1    = CONV msgv1( <fs_r_acckey>-low )
                                                  gv_msgv2    = CONV msgv2( iv_namefile )
                                               )->get_bapiretreturn( )
                                   TO gt_log.
          ENDIF.

        ELSE.
          "chave acceky do file ja existe na tabela ZTTM_GKOT001
          APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                   textid      = zcxtm_upload_file_gko=>chave_duplicada
                                                   gv_msgv1    = CONV msgv1( <fs_r_acckey>-low )
                                                   gv_msgv2    = CONV msgv2( iv_namefile )
                                                )->get_bapiretreturn( )
                                    TO gt_log.
        ENDIF.

      ENDLOOP.

    ELSE.
      APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                    textid      = zcxtm_upload_file_gko=>tag_nao_localizada
                                                    gv_msgv1    = CONV msgv1( lc_tagkey )
                                                    gv_msgv2    = CONV msgv2( iv_namefile )
                                                 )->get_bapiretreturn( )
                                     TO gt_log.

    ENDIF.

  ENDMETHOD.


  METHOD process_nf_gko.

    DATA: ls_acckey  TYPE j_1b_nfe_access_key,
          lt_acckey  TYPE STANDARD TABLE OF j_1b_nfe_access_key,
          lr_acckey  TYPE RANGE OF j_1b_nfe_access_key_dtel44,
          ls_gko     TYPE zttm_gkot001,
          lv_ano     TYPE c LENGTH 4,
          lv_mes     TYPE c LENGTH 2,
          lv_dia     TYPE c LENGTH 2,
          lv_docdata TYPE c LENGTH 10.

    DATA(lt_aux_xml) = it_xml_info.

    CONSTANTS: lc_tagkey        TYPE char255 VALUE 'ZGKO_ACCKEY_REF',
               lc_VTPREST       TYPE char255 VALUE 'ZGKO_VTPREST',
               lc_prefno        TYPE char255 VALUE 'ZGKO_NFS',
               lc_vrec          TYPE char255 VALUE 'ZGKO_VREC',
               lc_vbciss        TYPE char255 VALUE 'ZGKO_VBCISS',
               lc_piss          TYPE char255 VALUE 'ZGKO_PISS',
               lc_viss          TYPE char255 VALUE 'ZGKO_VISS',

               lc_EMIT_CNPJ_CPF TYPE char255 VALUE 'ZGKO_EMIT_CNPJ_CPF',
               lc_EMIT_IE       TYPE char255 VALUE 'ZGKO_EMIT_IE',
               lc_EMIT_COD      TYPE char255 VALUE 'ZGKO_EMIT_COD',
               lc_EMIT_UF       TYPE char255 VALUE 'ZGKO_EMIT_UF',

               lc_TOM_CNPJ_CPF  TYPE char255 VALUE 'ZGKO_TOM_CNPJ_CPF',
               lc_TOM_IE        TYPE char255 VALUE 'ZGKO_TOM_IE',
               lc_TOM_COD       TYPE char255 VALUE 'ZGKO_TOM_COD',
               lc_TOM_UF        TYPE char255 VALUE 'ZGKO_TOM_UF',

               lc_REM_CNPJ_CPF  TYPE char255 VALUE 'ZGKO_REM_CNPJ_CPF',
               lc_REM_IE        TYPE char255 VALUE 'ZGKO_REM_IE',
               lc_REM_COD       TYPE char255 VALUE 'ZGKO_REM_COD',
               lc_REM_UF        TYPE char255 VALUE 'ZGKO_REM_UF',

               lc_DEST_CNPJ_CPF TYPE char255 VALUE 'ZGKO_DEST_CNPJ_CPF',
               lc_DEST_IE       TYPE char255 VALUE 'ZGKO_DEST_IE',
               lc_DEST_COD      TYPE char255 VALUE 'ZGKO_DEST_COD',
               lc_DEST_UF       TYPE char255 VALUE 'ZGKO_DEST_UF',
               lc_docdat        TYPE char255 VALUE 'DOCDAT',
               lc_status_integ  TYPE ze_gko_codstatus VALUE '100',
               lc_sep_data      TYPE c VALUE '-'.

    SORT lt_aux_xml BY cname.

    READ TABLE lt_aux_xml
    WITH KEY cname = lc_tagkey
    BINARY SEARCH TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.

      LOOP AT lt_aux_xml FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_aux>).
        IF <fs_aux>-cname NE lc_tagkey.
          EXIT.
        ENDIF.

        APPEND INITIAL LINE TO lt_acckey ASSIGNING FIELD-SYMBOL(<fs_s_acckey>).
        <fs_s_acckey> = <fs_aux>-cvalue.

        APPEND INITIAL LINE TO lr_acckey ASSIGNING FIELD-SYMBOL(<fs_r_acckey>).
        <fs_r_acckey>-sign   = gc_sign_i.
        <fs_r_acckey>-option = gc_option_eq.
        <fs_r_acckey>-low    =  <fs_aux>-cvalue.
      ENDLOOP.

      IF lt_acckey IS NOT INITIAL.

        SELECT
          docnum,
          direct,
          regio,
          nfyear,
          nfmonth,
          stcd1,
          model,
          serie,
          nfnum9,
          docnum9,
          cdv,
          bukrs,
          branch
        FROM j_1bnfe_active FOR ALL ENTRIES IN @lt_acckey
        WHERE regio       = @lt_acckey-regio
              AND nfyear  = @lt_acckey-nfyear
              AND nfmonth = @lt_acckey-nfmonth
              AND stcd1   = @lt_acckey-stcd1
              AND model   = @lt_acckey-model
              AND serie   = @lt_acckey-serie
              AND nfnum9  = @lt_acckey-nfnum9
              AND docnum9 = @lt_acckey-docnum9
              AND cdv     = @lt_acckey-cdv
*              AND direct  IN ('1','2') "Entrada e Saida
              AND cancel  EQ @abap_false
        INTO TABLE @DATA(lt_active).

        IF sy-subrc = 0.
          SORT  lt_acckey BY regio nfyear nfmonth stcd1 model serie nfnum9 docnum9 cdv.
        ENDIF.

      ENDIF.

      IF lr_acckey IS NOT INITIAL.
        SELECT
          acckey
        FROM zttm_gkot001
        WHERE acckey IN @lr_acckey
        INTO TABLE @DATA(lt_auxgko).
        IF sy-subrc = 0.
          SORT lt_auxgko BY acckey.
        ENDIF.
      ENDIF.

      ls_gko-codstatus = lc_status_integ.
      ls_gko-tpdoc     = gc_tpdoc_nfs.
      ls_gko-credat    = sy-datum.
      ls_gko-cretim    = sy-uzeit.

      lv_docdata = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_docdat
                                       ).

      SPLIT lv_docdata AT lc_sep_data INTO lv_ano lv_mes lv_dia.

      IF lv_ano IS NOT INITIAL AND  lv_mes IS NOT INITIAL AND lv_dia IS NOT INITIAL.
        ls_gko-dtemi = lv_ano && lv_mes && lv_dia.
      ENDIF.

      ls_gko-prefno = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_prefno
                                       ).

      "valores
      ls_gko-vtprest = get_value_tag_xml(
                                            it_xml = lt_aux_xml
                                            iv_tag = lc_vtprest
                                          ).

      ls_gko-vrec = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_vrec
                                       ).

      "imposto
      ls_gko-vbciss = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_vbciss
                                       ).

      ls_gko-piss = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_piss
                                       ).

      ls_gko-viss = get_value_tag_xml(
                                         it_xml = lt_aux_xml
                                         iv_tag = lc_viss
                                       ).

      "Emitente
      ls_gko-emit_cnpj_cpf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_emit_cnpj_cpf
                                               ).

      ls_gko-emit_ie = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_emit_ie
                                               ).

      ls_gko-emit_cod = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_emit_cod
                                               ).

      ls_gko-emit_uf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_emit_uf
                                               ).

      "Tomador
      ls_gko-tom_cnpj_cpf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_tom_cnpj_cpf
                                               ).

      ls_gko-tom_ie = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_tom_ie
                                               ).

      ls_gko-tom_cod = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_tom_cod
                                               ).

      ls_gko-tom_uf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_tom_uf
                                               ).

      "Remetente
      ls_gko-rem_cnpj_cpf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_rem_cnpj_cpf
                                               ).

      ls_gko-rem_ie = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_rem_ie
                                               ).

      ls_gko-rem_cod = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_rem_cod
                                               ).

      ls_gko-rem_uf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_rem_uf
                                               ).

      "destinatario

      ls_gko-dest_cnpj = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_dest_cnpj_cpf
                                               ).
      IF strlen( ls_gko-dest_cnpj ) <= 11.
        ls_gko-dest_cpf = ls_gko-dest_cnpj.
        CLEAR ls_gko-dest_cnpj.
      ENDIF.

      ls_gko-dest_ie = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_dest_ie
                                               ).

      ls_gko-dest_cod = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_dest_cod
                                               ).

      ls_gko-dest_uf = get_value_tag_xml(
                                                 it_xml = lt_aux_xml
                                                 iv_tag = lc_dest_uf
                                               ).




      LOOP AT lr_acckey ASSIGNING <fs_r_acckey>.

        READ TABLE lt_auxgko
        WITH KEY acckey = <fs_r_acckey>-low
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          ls_acckey = <fs_r_acckey>-low.

          READ TABLE lt_active
          WITH KEY regio       = ls_acckey-regio
                   nfyear      = ls_acckey-nfyear
                   nfmonth     = ls_acckey-nfmonth
                   stcd1       = ls_acckey-stcd1
                   model       = ls_acckey-model
                   serie       = ls_acckey-serie
                   nfnum9      = ls_acckey-nfnum9
                   docnum9     = ls_acckey-docnum9
                   cdv         = ls_acckey-cdv
          BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_acckey>).

          IF sy-subrc = 0.
            ls_gko-acckey = ls_acckey.
            ls_gko-bukrs  = <fs_acckey>-bukrs.
            ls_gko-branch = <fs_acckey>-branch.
            ls_gko-direct = <fs_acckey>-direct.
            ls_gko-model  = <fs_acckey>-model.
            ls_gko-nfnum9 = <fs_acckey>-nfnum9.
            ls_gko-series = <fs_acckey>-serie.

            APPEND INITIAL LINE TO gt_gko ASSIGNING FIELD-SYMBOL(<fs_gko>).
            <fs_gko> = ls_gko.

          ELSE.
            "chave xxx do arquivo xxxx nao localizado dentro sap
            APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                  textid      = zcxtm_upload_file_gko=>chave_nao_localizada
                                                  gv_msgv1    = CONV msgv1( <fs_r_acckey>-low )
                                                  gv_msgv2    = CONV msgv2( iv_namefile )
                                               )->get_bapiretreturn( )
                                   TO gt_log.
          ENDIF.

        ELSE.
          "chave acceky do file ja existe na tabela ZTTM_GKOT001
          APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                   textid      = zcxtm_upload_file_gko=>chave_duplicada
                                                   gv_msgv1    = CONV msgv1( <fs_r_acckey>-low )
                                                   gv_msgv2    = CONV msgv2( iv_namefile )
                                                )->get_bapiretreturn( )
                                    TO gt_log.
        ENDIF.

      ENDLOOP.

    ELSE.
      APPEND LINES OF NEW zcxtm_upload_file_gko(
                                                    textid      = zcxtm_upload_file_gko=>tag_nao_localizada
                                                    gv_msgv1    = CONV msgv1( lc_tagkey )
                                                    gv_msgv2    = CONV msgv2( iv_namefile )
                                                 )->get_bapiretreturn( )
                                     TO gt_log.

    ENDIF.

  ENDMETHOD.


  METHOD save_data.

    IF gt_gko IS NOT INITIAL.

      MODIFY zttm_gkot001 FROM TABLE gt_gko.

      IF sy-subrc = 0.
        COMMIT WORK AND WAIT.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD save_log.
    DATA: ls_log        TYPE bal_s_log,
          lv_log_handle TYPE balloghndl,
          ls_msg        TYPE bal_s_msg.

    IF gt_log IS NOT INITIAL.

      ls_log-object    = gc_log_nmobj.
      ls_log-subobject = gc_log_nmsubobj.

      ls_log-aluser = sy-uname.
      ls_log-alprog = sy-repid.


      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = ls_log
        IMPORTING
          e_log_handle            = lv_log_handle
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.

      IF sy-subrc = 0.
        LOOP AT gt_log ASSIGNING FIELD-SYMBOL(<fs_log>).

          ls_msg-msgty = <fs_log>-type.
          ls_msg-msgid = <fs_log>-id.
          ls_msg-msgno = <fs_log>-number.
          ls_msg-msgv1 = <fs_log>-message_v1.
          ls_msg-msgv2 = <fs_log>-message_v2.
          ls_msg-msgv3 = <fs_log>-message_v3.
          ls_msg-msgv4 = <fs_log>-message_v4.

          CALL FUNCTION 'BAL_LOG_MSG_ADD'
            EXPORTING
              i_log_handle     = lv_log_handle
              i_s_msg          = ls_msg.
*            EXCEPTIONS
*              log_not_found    = 1
*              msg_inconsistent = 2
*              log_is_full      = 3
*              OTHERS           = 4.
*
*          IF sy-subrc = 0.
*          ENDIF.

        ENDLOOP.

        CALL FUNCTION 'BAL_LOG_CREATE'
          EXPORTING
            i_s_log                 = ls_log
          IMPORTING
            e_log_handle            = lv_log_handle.
*          EXCEPTIONS
*            log_header_inconsistent = 1
*            OTHERS                  = 2.
*        IF sy-subrc = 0.
*
*        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
