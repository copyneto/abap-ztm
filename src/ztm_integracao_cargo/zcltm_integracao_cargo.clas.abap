CLASS zcltm_integracao_cargo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS atualiza_integracao
      IMPORTING
        VALUE(it_tor_fu) TYPE /scmtms/t_tor_root_k
        !iv_commit       TYPE char1 OPTIONAL
        !it_tor_docref   TYPE /scmtms/t_tor_docref_k
        !it_tor_fo       TYPE /scmtms/t_tor_root_k .
    CLASS-METHODS busca_pdf
      IMPORTING
        !it_spoolsid TYPE tsfspoolid
      CHANGING
        !ct_pdf      TYPE tsfotf .
    CLASS-METHODS download_danfe
      IMPORTING
        !it_pdf        TYPE tsfotf OPTIONAL
        !it_tor_fo     TYPE /scmtms/t_tor_root_k
        !it_tor_docref TYPE /scmtms/t_tor_docref_k
        !iv_docnum     TYPE j_1bdocnum
        !it_spoolsid   TYPE tsfspoolid .
    CLASS-METHODS busca_fu
      IMPORTING
        !iv_remessa      TYPE vbeln_vl
      RETURNING
        VALUE(rt_tor_fu) TYPE /scmtms/t_tor_root_k .
    CLASS-METHODS busca_remessa
      IMPORTING
        VALUE(iv_docnum)  TYPE j_1bdocnum
      RETURNING
        VALUE(rv_remessa) TYPE vbeln_vl .
    CLASS-METHODS execute
      IMPORTING
        !iv_docnum   TYPE j_1bdocnum
        !it_pdf      TYPE tsfotf
        !iv_commit   TYPE char1 OPTIONAL
        !it_spoolsid TYPE tsfspoolid OPTIONAL .
    CLASS-METHODS busca_fo
      IMPORTING
        VALUE(it_tor_fu) TYPE /scmtms/t_tor_root_k
      RETURNING
        VALUE(rt_tor_fo) TYPE /scmtms/t_tor_root_k .
    CLASS-METHODS busca_fu_assign
      IMPORTING
        VALUE(it_tor_fo)     TYPE /scmtms/t_tor_root_k
      RETURNING
        VALUE(rt_tor_assign) TYPE /scmtms/t_tor_root_k .
    CLASS-METHODS busca_referencia
      IMPORTING
        !it_tor_fo           TYPE /scmtms/t_tor_root_k
      RETURNING
        VALUE(rt_tor_docref) TYPE /scmtms/t_tor_docref_k .
    CLASS-METHODS cria_subpasta
      IMPORTING
        !iv_subpasta     TYPE string
      RETURNING
        VALUE(rv_result) TYPE xfeld .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_integracao_cargo IMPLEMENTATION.


  METHOD atualiza_integracao.

    DATA:
      lo_srv_tor          TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor          TYPE REF TO /bobf/if_tra_transaction_mgr,

      lt_tor_root_data    TYPE /scmtms/t_tor_root_k,
      lt_tor_root_key     TYPE /bobf/t_frw_key,
      lt_tor_refe_key     TYPE /bobf/t_frw_key,
      lt_tor_refe_data    TYPE /scmtms/t_tor_docref_k,
      lt_return           TYPE bapiret2_tab,
      lt_zttm_cargo_impre TYPE TABLE OF zttm_cargo_impre,

      ls_output           TYPE zcltm_mt_emissao_cte.

    DATA: lt_rem  TYPE tcm_t_vbrp.

    DATA: lt_refkey  TYPE zctgtm_cargo_refkey.

    DATA(lt_tor_fu) = it_tor_fu.

    DELETE lt_tor_fu WHERE dlv_goods_mvmnt <> 'C'.      "#EC CI_SORTSEQ

    CHECK lt_tor_fu IS NOT INITIAL.

    LOOP AT lt_tor_fu ASSIGNING FIELD-SYMBOL(<fs_tor_fu>).
      DATA(lv_remessa) = <fs_tor_fu>-base_btd_id+25(10).
      APPEND lv_remessa TO lt_rem.
    ENDLOOP.

    SELECT
      vbeln
      INTO TABLE @DATA(lt_num_pedido)
      FROM vbfa
      FOR ALL ENTRIES IN @lt_rem
      WHERE vbelv   = @lt_rem-table_line
        AND vbtyp_n = 'M'.

    CHECK sy-subrc IS INITIAL.

    SORT lt_rem.
    DELETE ADJACENT DUPLICATES FROM lt_rem.

    DATA(lt_faturas) = lt_num_pedido.
    SORT lt_faturas BY vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_faturas COMPARING vbeln.

    DESCRIBE TABLE lt_rem     LINES DATA(lv_qtd_rem).
    DESCRIBE TABLE lt_faturas LINES DATA(lv_qtd_fat).

    CHECK lv_qtd_rem = lv_qtd_fat.

    LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<fs_fat>).
      APPEND <fs_fat>-vbeln TO lt_refkey.
    ENDLOOP.

    SELECT
      a~docnum,
      itmnum,
      refkey,
      refitm
      FROM j_1bnflin AS a
      INNER JOIN vbrk AS b
      ON b~vbeln = a~refkey
      INNER JOIN j_1bnfdoc AS c
      ON c~docnum = a~docnum
      INNER JOIN j_1bnfe_active AS d
      ON d~docnum = a~docnum
      INTO TABLE @DATA(lt_nflinhas)
      FOR ALL ENTRIES IN @lt_refkey
      WHERE refkey = @lt_refkey-table_line
        AND fksto  = @space
        AND d~printd = @abap_true.

    " Se não encontrou, busca por documento de material
    IF sy-subrc IS NOT INITIAL.

      FREE lt_refkey.

      SELECT
        vbeln,
        mjahr
      INTO TABLE @DATA(lt_docmaterial)
      FROM vbfa
      FOR ALL ENTRIES IN @lt_rem
      WHERE vbelv   = @lt_rem-table_line
        AND vbtyp_n = 'R'.

      IF sy-subrc IS INITIAL.

        lt_refkey = VALUE #( FOR ls_docmat IN lt_docmaterial
                                ( |{ ls_docmat-vbeln }{ ls_docmat-mjahr }| )
         ).

        IF lt_refkey IS NOT INITIAL.

          SELECT
            a~docnum,
            itmnum,
            refkey,
            refitm
            FROM j_1bnflin AS a
            INNER JOIN j_1bnfdoc AS b
            ON b~docnum = a~docnum
            INNER JOIN j_1bnfe_active AS c
            ON c~docnum = a~docnum
            INTO TABLE @lt_nflinhas
            FOR ALL ENTRIES IN @lt_refkey
            WHERE refkey = @lt_refkey-table_line
              AND c~printd = @abap_true.

        ENDIF.

      ENDIF.

    ENDIF.

    DATA(lt_lin) = lt_nflinhas.
    SORT lt_lin BY docnum.
    DELETE ADJACENT DUPLICATES FROM lt_lin COMPARING docnum.

    DESCRIBE TABLE lt_lin LINES DATA(lv_qtd_nfs).

    CHECK lv_qtd_nfs = lv_qtd_fat.

    LOOP AT it_tor_docref ASSIGNING FIELD-SYMBOL(<fs_tor_docref>).

      DATA(ls_zttm_cargo_impre) = VALUE zttm_cargo_impre( btd_id   = <fs_tor_docref>-btd_id
                                                          tor_id   = it_tor_fo[ key = <fs_tor_docref>-root_key ]-tor_id
                                                          impresso = abap_true ).

      APPEND ls_zttm_cargo_impre TO lt_zttm_cargo_impre.

      TRY.

          DATA(lo_cargo) = NEW zcltm_co_si_envia_emissao_cte( ).

          ls_output-mt_emissao_cte-tor_id = |{ ls_zttm_cargo_impre-tor_id ALPHA = OUT }|.
          ls_output-mt_emissao_cte-btd_id = |{ ls_zttm_cargo_impre-btd_id ALPHA = OUT }|.

          lo_cargo->si_envia_emissao_cte_out( ls_output ).
        CATCH cx_ai_system_fault.
      ENDTRY.

    ENDLOOP.

    MODIFY zttm_cargo_impre FROM TABLE lt_zttm_cargo_impre.

    IF iv_commit IS NOT INITIAL.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD busca_fo.

    DATA:
      lt_return       TYPE bapiret2_t,
      lt_tor_root_key TYPE /bobf/t_frw_key,
      lt_tor_capa     TYPE /scmtms/t_tor_root_k,
      lt_key_link     TYPE /bobf/t_frw_key_link.

    CHECK it_tor_fu IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_tor_fu ASSIGNING FIELD-SYMBOL(<fs_tor_fu>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor_fu>-key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.


    lo_tor_mgr->retrieve_by_association(
      EXPORTING
        it_key         = lt_tor_root_key
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-capa_tor
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_tor_capa
        et_key_link    = lt_key_link ).

    CLEAR lt_tor_root_key.
    LOOP AT lt_tor_capa ASSIGNING FIELD-SYMBOL(<fs_tor_capa>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor_capa>-root_key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.

    lo_tor_mgr->retrieve(
      EXPORTING
        it_key       = lt_tor_root_key
        iv_node_key  = /scmtms/if_tor_c=>sc_node-root
        iv_fill_data = abap_true
      IMPORTING
        et_data      = rt_tor_fo ).

  ENDMETHOD.


  METHOD busca_fu.

    DATA:
      lo_srv_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor       TYPE REF TO /bobf/if_tra_transaction_mgr,

      lt_tor_root_data TYPE /scmtms/t_tor_root_k,
      lt_tor_root_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_data TYPE /scmtms/t_tor_docref_k,
      lt_return        TYPE bapiret2_tab.


    DATA:
      lt_parameters TYPE /bobf/t_frw_query_selparam,
      ls_parameter  TYPE /bobf/s_frw_query_selparam.


    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.

    CHECK iv_remessa IS NOT INITIAL.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    CLEAR ls_parameter.
    ls_parameter-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-docreference-btd_id.

    ls_parameter-sign   = lc_sign_i.
    ls_parameter-option = lc_option_eq.
    ls_parameter-low    = iv_remessa.
    APPEND ls_parameter TO lt_parameters.


* Busca referencias (FU) a partir da remessa
    IF lt_parameters IS NOT INITIAL.

      lo_srv_tor->query(
        EXPORTING
          iv_query_key            = /scmtms/if_tor_c=>sc_query-docreference-docreference_elements
          it_selection_parameters = lt_parameters
          iv_fill_data            = abap_true
        IMPORTING
          et_key                  = lt_tor_refe_key
          et_data                 = lt_tor_refe_data ).

    ENDIF.

    LOOP AT lt_tor_refe_data ASSIGNING FIELD-SYMBOL(<fs_refe_data>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_refe_data>-root_key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.

*   Busca dados das FUs
    lo_srv_tor->retrieve(
      EXPORTING
        it_key      = lt_tor_root_key
        iv_node_key = /scmtms/if_tor_c=>sc_node-root
      IMPORTING
        et_data     = lt_tor_root_data
    ).


*   Considerar somente FU
    DELETE lt_tor_root_data WHERE tor_cat <> 'FU'.      "#EC CI_SORTSEQ
    "Não é possível utilizar usando chave pois a condição é "diferente"

    CHECK lt_tor_root_data IS NOT INITIAL.

    rt_tor_fu = lt_tor_root_data.


  ENDMETHOD.


  METHOD busca_fu_assign.

    DATA:
      lt_return       TYPE bapiret2_t,
      lt_tor_root_key TYPE /bobf/t_frw_key.

    CHECK it_tor_fo IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_tor_fo ASSIGNING FIELD-SYMBOL(<fs_tor_fu>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor_fu>-key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.


    lo_tor_mgr->retrieve_by_association(
      EXPORTING
        it_key         = lt_tor_root_key
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = rt_tor_assign ).


  ENDMETHOD.


  METHOD busca_referencia.

    CONSTANTS:
      lc_doctype_3ca TYPE /scmtms/s_tor_docref_k-btd_tco VALUE '3CA'.

    DATA:
      lt_return       TYPE bapiret2_t,
      lt_tor_root_key TYPE /bobf/t_frw_key.

    CHECK it_tor_fo IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_tor_fo ASSIGNING FIELD-SYMBOL(<fs_tor_fu>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_tor_fu>-key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.

    lo_tor_mgr->retrieve_by_association(
      EXPORTING
        it_key         = lt_tor_root_key
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = rt_tor_docref ).


*    DELETE rt_tor_docref WHERE btd_tco <> '3CA'.

    LOOP AT rt_tor_docref ASSIGNING FIELD-SYMBOL(<fs_tor_docref>).
      IF <fs_tor_docref>-btd_tco <> lc_doctype_3ca.
        DELETE rt_tor_docref INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD busca_remessa.

    DATA: lr_nftype    TYPE RANGE OF j_1bnftype.

    SELECT SINGLE
      docnum,
      nftype,
      doctyp,
      direct,
      docdat,
      pstdat,
      series,
      nfenum,
      parid,
      cancel
      FROM j_1bnfdoc
      INTO @DATA(ls_doc)
      WHERE docnum = @iv_docnum.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = 'TM'
            iv_chave1 = 'TIPO_NF_3CARGO'
          IMPORTING
            et_range  = lr_nftype
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    CHECK ls_doc-nftype IN lr_nftype.

    SELECT
      docnum,
      itmnum,
      refkey,
      refitm
      FROM j_1bnflin
      INTO TABLE @DATA(lt_lin)
      WHERE docnum = @ls_doc-docnum.

    CHECK sy-subrc IS INITIAL.

    DATA(lv_fatura) = CONV vbeln_vf( lt_lin[ 1 ]-refkey ).


    SELECT SINGLE
      vbelv
      INTO @rv_remessa
      FROM vbfa
      WHERE vbeln   = @lv_fatura
        AND vbtyp_v = 'J'.                              "#EC CI_NOFIELD

  ENDMETHOD.


  METHOD download_danfe.

    DATA:
      lt_file          TYPE TABLE OF tline,
      lt_docs          TYPE TABLE OF docs,
      lt_bindata       TYPE solix_tab,
      lv_path          TYPE rlgrap-filename,
      lv_file          TYPE rlgrap-filename,

      lv_max_len       TYPE i  VALUE 255,
      lv_all_lines_len TYPE i,
      lv_diff_len      TYPE i,
      lv_filesize      TYPE i,
      lv_buffer        TYPE string,
      lv_buffer_x      TYPE xstring.

    CHECK it_tor_fo     IS NOT INITIAL.
    CHECK it_tor_docref IS NOT INITIAL.

    DATA(lv_fo) = CONV char10( it_tor_fo[ 1 ]-tor_id+10(10) ).
    DATA(lv_ref)     = it_tor_docref[ 1 ]-btd_id.

    CHECK it_spoolsid IS NOT INITIAL.

    DATA(lv_spoolid) = it_spoolsid[ 1 ].

*** Gerar PDF
    CALL FUNCTION 'CONVERT_OTFSPOOLJOB_2_PDF'
      EXPORTING
        src_spoolid              = lv_spoolid
        no_dialog                = 'X'
        pdf_destination          = 'X'
        no_background            = 'X'
      IMPORTING
        pdf_bytecount            = lv_filesize
        bin_file                 = lv_buffer_x
      EXCEPTIONS
        err_no_otf_spooljob      = 1
        err_no_spooljob          = 2
        err_no_permission        = 3
        err_conv_not_possible    = 4
        err_bad_dstdevice        = 5
        user_cancelled           = 6
        err_spoolerror           = 7
        err_temseerror           = 8
        err_btcjob_open_failed   = 9
        err_btcjob_submit_failed = 10
        err_btcjob_close_failed  = 11
        OTHERS                   = 12.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo = 'TM'
                                          iv_chave1 = 'DIRETORIO3CARGO'
                                IMPORTING ev_param  = lv_path ).

      CATCH zcxca_tabela_parametros.
        lv_path = '/interfaces/S4D'.
    ENDTRY.

    DATA(lv_subfolder) = lv_path && '/' && lv_ref.

    cria_subpasta( iv_subpasta = lv_subfolder ).

    lv_path = lv_subfolder && '/' && lv_ref && '_' && iv_docnum && '.pdf'.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_buffer_x
*       APPEND_TO_TABLE       = ' '
      IMPORTING
        output_length = lv_filesize
      TABLES
        binary_tab    = lt_bindata.

    DESCRIBE TABLE lt_bindata LINES DATA(lv_lines).

    OPEN DATASET lv_path FOR OUTPUT IN BINARY MODE.
    CHECK sy-subrc IS INITIAL.

    DATA(lv_len) = lv_max_len.


*   If no I_FILE_SIZE then I_LINES has to be 0.
    IF lv_filesize = 0.
      lv_lines = 0.
    ENDIF.

    LOOP AT lt_bindata ASSIGNING FIELD-SYMBOL(<fs_bindata>).
*     last line is shorter perhaps
      IF sy-tabix = lv_lines.
        lv_all_lines_len = lv_max_len * ( lv_lines - 1 ).
        lv_diff_len = lv_filesize - lv_all_lines_len.
        lv_len = lv_diff_len.
      ENDIF.
      TRANSFER <fs_bindata> TO lv_path LENGTH lv_len.

    ENDLOOP.
    CLOSE DATASET lv_path.

  ENDMETHOD.


  METHOD execute.

    DATA(lt_pdf) = it_pdf.
    DATA(lv_remessa)    = busca_remessa( iv_docnum ).
    DATA(lt_tor_fu)     = busca_fu( lv_remessa ).
    DATA(lt_tor_fo)     = busca_fo( lt_tor_fu ).
    DATA(lt_tor_assign) = busca_fu_assign( lt_tor_fo ).
    DATA(lt_tor_docref) = busca_referencia( lt_tor_fo ).
    download_danfe( it_spoolsid = it_spoolsid it_pdf = lt_pdf it_tor_fo = lt_tor_fo it_tor_docref = lt_tor_docref iv_docnum = iv_docnum ).
    atualiza_integracao( it_tor_fo = lt_tor_fo it_tor_fu = lt_tor_assign it_tor_docref = lt_tor_docref iv_commit = iv_commit ).

  ENDMETHOD.


  METHOD busca_pdf.

    DATA:
      ls_printoptions   TYPE itcpo.

    CHECK ct_pdf IS INITIAL.

    CHECK it_spoolsid IS NOT INITIAL.

    DATA(lv_spoolid) = it_spoolsid[ 1 ].


*    CALL FUNCTION 'PRINT_OTF'
*      EXPORTING
*        printoptions = ls_printoptions
*      IMPORTING
*        otf_printer  = lv_dest
*        spoolid      = lv_spoolid
*      TABLES
*        otf          = lt_otf.
*

  ENDMETHOD.


  METHOD cria_subpasta.

    CONSTANTS:
      lc_create_subfolder TYPE sxpgcolist-name VALUE 'ZMAKEDIR'.

    DATA:
      lt_file_list TYPE STANDARD TABLE OF salfldir.

    DATA:
      lv_param   TYPE sxpgcolist-parameters,
      lv_srvname TYPE char20.

    FREE lt_file_list.
    lv_srvname = space.

    CALL FUNCTION 'RZL_READ_DIR'
      EXPORTING
        name           = iv_subpasta
        srvname        = lv_SRVNAME
      TABLES
        file_tbl       = lt_FILE_LIST
      EXCEPTIONS
        not_found      = 1
        argument_error = 2
        send_error     = 3.

    IF sy-subrc EQ 0.

      "Subpasta já existe
      rv_result = abap_true.
      RETURN.

    ENDIF.

    lv_param = iv_subpasta.

    CALL FUNCTION 'SXPG_COMMAND_EXECUTE'
      EXPORTING
        commandname                   = lc_create_subfolder
        additional_parameters         = lv_param
      EXCEPTIONS
        no_permission                 = 1
        command_not_found             = 2
        parameters_too_long           = 3
        security_risk                 = 4
        wrong_check_call_interface    = 5
        program_start_error           = 6
        program_termination_error     = 7
        x_error                       = 8
        parameter_expected            = 9
        too_many_parameters           = 10
        illegal_command               = 11
        wrong_asynchronous_parameters = 12
        cant_enq_tbtco_entry          = 13
        jobcount_generation_error     = 14
        OTHERS                        = 15.

    IF sy-subrc EQ 0.
      rv_result = abap_true.
    ELSE.
      rv_result = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
