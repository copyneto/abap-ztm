class ZCLTM_CREATE_FILE definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_directory,
        origem      TYPE eps2filnam,
        processados TYPE eps2filnam,
        destino     TYPE eps2filnam,
      END OF ty_directory .

  methods GET_DIRECTORIES
    exceptions
      ZCXTM_GKO_PROCESS .
  methods CREATE_FILE .
  methods ALV_TO_ITAB
    exporting
      !EO_ITAB type ref to DATA
      !ET_FCAT type LVC_T_FCAT .
protected section.
private section.

  data GS_DIRECTORY type TY_DIRECTORY .
  data GV_SEPARADOR type CHAR1 .

  methods CHECK_WRITE_PERMISSION
    importing
      !IV_DIRECTORY type EPS2FILNAM .
ENDCLASS.



CLASS ZCLTM_CREATE_FILE IMPLEMENTATION.


  METHOD alv_to_itab.

    DATA: lt_params TYPE rsparams_tt.
    DATA: lr_data     TYPE REF TO data,
          lr_data_dyn TYPE REF TO data.

    DATA: ls_metadata1 TYPE cl_salv_bs_runtime_info=>s_type_metadata,
          lt_fcat      TYPE lvc_t_fcat.

    FIELD-SYMBOLS: <fs_table>     TYPE STANDARD TABLE,
                   <fs_table_dyn> TYPE STANDARD TABLE.

    TRY .

        CALL FUNCTION 'RS_REFRESH_FROM_SELECTOPTIONS'
          EXPORTING
            curr_report     = sy-cprog
          TABLES
            selection_table = lt_params
          EXCEPTIONS
            not_found       = 1
            no_report       = 2
            OTHERS          = 3.

* 1.1 Configuração do ALV para usar o método GET_DATA_REF
        cl_salv_bs_runtime_info=>set( EXPORTING display  = abap_false
                                                metadata = abap_true
                                                data     = abap_true  ).

        lt_params[ selname = |P_BACKG| ] = abap_false.
        lt_params[ selname = |P_FOREG| ] = abap_true.

*        SUBMIT zgko001
*        WITH SELECTION-TABLE lt_params
*            EXPORTING LIST TO MEMORY
*            AND RETURN.



        cl_salv_bs_runtime_info=>get_data_ref( IMPORTING r_data = lr_data ).
        ASSIGN lr_data->* TO <fs_table>.

        ls_metadata1 = cl_salv_bs_runtime_info=>get_metadata( ).
        lt_fcat = ls_metadata1-t_fcat[].
        DELETE lt_fcat WHERE no_out = abap_true.

* 1.2 Configuração do ALV para uso normal do ALV : execução de teste usa exibição de ALV
        cl_salv_bs_runtime_info=>clear_all( ).

* 2.1 Transformar linhas de fcat em colunas para uma tabela interna
        CALL METHOD cl_alv_table_create=>create_dynamic_table
          EXPORTING
            it_fieldcatalog           = lt_fcat
          IMPORTING
            ep_table                  = lr_data_dyn
          EXCEPTIONS
            generate_subpool_dir_full = 1
            OTHERS                    = 2.
* 2.2 Estrutura dinamica para field symbol
        ASSIGN lr_data_dyn->* TO <fs_table_dyn>.

        MOVE-CORRESPONDING <fs_table> TO <fs_table_dyn>.

* 2.3 Referenciar para retorno type data
        eo_itab = REF #( <fs_table_dyn> ).
        et_fcat = lt_fcat.

      CATCH cx_salv_bs_sc_runtime_info.

    ENDTRY.

  ENDMETHOD.


  METHOD check_write_permission.

    DATA: lv_directory TYPE char128.

    lv_directory = iv_directory.

    CALL FUNCTION 'PFL_CHECK_DIRECTORY'
      EXPORTING
        directory_long              = lv_directory    " Name of directory
        write_check                 = 'X'             " Write authorization for directory
      EXCEPTIONS
        pfl_dir_not_exist           = 1
        pfl_permission_denied       = 2
        pfl_cant_build_dataset_name = 3
        pfl_file_not_exist          = 4
        OTHERS                      = 5.

    CASE sy-subrc.
      WHEN 1.

        "Diretório & não exite.
        WRITE: / |--- Diretório { lv_directory } não exite.|.

      WHEN 2.

        "Sem permissão de escrita para o diretório &.
        WRITE: / |--- Sem permissão de escrita para o diretório { lv_directory }.|.

      WHEN 3 OR 4 OR 5.

        "Erro ao verificar o diretório &.
        WRITE: / |--- Erro ao verificar o diretório { lv_directory }.|.

      WHEN OTHERS.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD create_file.

    TYPES: BEGIN OF ty_comp_name,
             scrtext_l TYPE scrtext_l,
           END OF ty_comp_name.

    TYPES ty_truxs_t_text_data(4096).

    DATA: lv_file_dest TYPE string.
    DATA: lt_text_tab  TYPE truxs_t_text_data.
    DATA: lv_err_text  TYPE string,
          lo_myref     TYPE REF TO cx_sy_file_open_mode.

    DATA:
      lt_compname     TYPE TABLE OF ty_comp_name,
      lv_header_texto TYPE ty_truxs_t_text_data.

    " Buscar tabela com dados por leiaute
    FIELD-SYMBOLS <lt_result_table> TYPE STANDARD TABLE.

    alv_to_itab( IMPORTING et_fcat = DATA(lt_fcat)
                           eo_itab = DATA(lr_itab) ).
    ASSIGN lr_itab->* TO <lt_result_table>.

    lv_file_dest = gs_directory-destino && gv_separador && |ZGKO002_| &&
*    p_job &&
    |.CSV| .

    "Cria o arquivo de destino
    OPEN DATASET lv_file_dest FOR OUTPUT IN TEXT MODE ENCODING UTF-8.

    IF sy-subrc IS NOT INITIAL.
      "Erro ao criar o arquivo &, &.
      WRITE: / |--- Erro ao iniciar criar Arquivo|.
    ENDIF.

    " Pegando o header da tabela
    lt_compname = VALUE #( FOR ls_fcat IN lt_fcat ( scrtext_l = ls_fcat-scrtext_l ) ).
    lv_header_texto = REDUCE #( INIT text TYPE ty_truxs_t_text_data FOR tline IN lt_compname NEXT text = text && tline-scrtext_l && ';' ).

    CALL FUNCTION 'SAP_CONVERT_TO_TEX_FORMAT'
      EXPORTING
        i_field_seperator    = ';'
      TABLES
        i_tab_sap_data       = <lt_result_table>
      CHANGING
        i_tab_converted_data = lt_text_tab
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

    "Transfere os dados para o arquivo destino
    TRY.
        TRANSFER lv_header_texto TO lv_file_dest.
        LOOP AT lt_text_tab INTO DATA(ls_text).
          TRANSFER ls_text TO lv_file_dest.
        ENDLOOP.

        WRITE: / |-- Arquivo| && | { lv_file_dest } foi gerado.|.

      CATCH cx_sy_file_open_mode INTO lo_myref.
        WRITE: / |--- { lv_err_text }|.
    ENDTRY.

    CLOSE DATASET lv_file_dest.

  ENDMETHOD.


  METHOD get_directories.

    "Obtêm o diretório de destino
*    SELECT SINGLE
*           parametro
*      FROM zgkop001
*      INTO ms_directory-destino
*      WHERE id        =  zcl_gko_process=>c_params-diretorio_destino
*        AND parametro <> space.

    IF sy-subrc IS NOT INITIAL.
      RAISE zcxtm_gko_process.
    ENDIF.

    check_write_permission( gs_directory-destino ).

    "Obtem o separador do sistema
    IF sy-opsys = 'Windows NT'.
      gv_separador = '\'.
    ELSE.
      gv_separador = '/'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
