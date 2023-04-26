"!<p><h2>Integração GKO - DANFE XML</h2></p>
"!<p><strong>Autor:</strong>Bruno Costa</p>
"!<p><strong>Data:</strong>12 de fev de 2022</p>
CLASS zcltm_integracao_gko DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Inicializa a classe
    METHODS constructor .
    "! Execução da rotina principal da integração
    METHODS execute
      IMPORTING
        !iv_active TYPE j_1bnfe_active OPTIONAL .
  PRIVATE SECTION.

    DATA lo_parametros TYPE REF TO zclca_tabela_parametros .
    DATA lo_nfse TYPE REF TO if_j_1bnfse .
    DATA lo_download_cloud TYPE REF TO cl_nfe_cloud_download .
    DATA lo_xml_document TYPE REF TO cl_xml_document .
    DATA lo_download TYPE REF TO cl_j_1bnfe_xml_download .

    CONSTANTS lc_form_cte TYPE j_1bform VALUE 'NF57' ##NO_TEXT.
    CONSTANTS lc_model_nfe TYPE j_1b_nfe_doctype VALUE 'NFE' ##NO_TEXT.
    CONSTANTS lc_model_cte TYPE j_1b_nfe_doctype VALUE 'CTE' ##NO_TEXT.
    CONSTANTS lc_direct_in TYPE j_1b_nfe_direction VALUE 'INBD' ##NO_TEXT.
    CONSTANTS lc_direct_out TYPE j_1b_nfe_direction VALUE 'OUTB' ##NO_TEXT.

    "! Método para ler a tabela de parametros
    "! @parameter rv_folder  | Carrega a pasta para transferir o XML
    METHODS get_parameters
      RETURNING
        VALUE(rv_folder) TYPE ze_param_low .
ENDCLASS.



CLASS zcltm_integracao_gko IMPLEMENTATION.


  METHOD constructor.

    Lo_parametros  = NEW #( ).

  ENDMETHOD.


  METHOD execute.

    DATA: lv_access_key TYPE j_1b_nfe_access_key_dtel44,
          lv_file_name  TYPE string,
          lv_rfcdest    TYPE rfcdest,
          lv_xnfeactive TYPE j_1bxnfeactive,
          lv_doctype    TYPE j_1b_nfe_doctype,
          lv_direction  TYPE j_1b_nfe_direction,
          lv_cloud_uuid TYPE nfe_document_uuid.

    DATA: ls_active TYPE j_1bnfe_active,
          ls_acckey TYPE j_1b_nfe_access_key.

    MOVE-CORRESPONDING iv_active TO ls_active.

    IF ls_active-form IS INITIAL.

      SELECT SINGLE *
        FROM j_1bnfe_active
        INTO ls_active
       WHERE docnum EQ ls_active-docnum.

    ELSE.

      CHECK ls_active-form EQ Lc_form_cte.

    ENDIF.

    DATA(lv_folder) = get_parameters( ).

    lv_cloud_uuid = ls_active-cloud_guid.

    MOVE-CORRESPONDING ls_active TO ls_acckey.

    lv_access_key = ls_acckey.

    CALL FUNCTION 'J_1B_NFE_CHECK_RFC_DESTINATION'
      EXPORTING
        i_bukrs      = ls_active-bukrs
        i_branch     = ls_active-branch
        i_model      = ls_active-model
      IMPORTING
        e_rfcdest    = lv_rfcdest
        e_xnfeactive = lv_xnfeactive
      EXCEPTIONS
        rfc_error    = 1
        OTHERS       = 2.

    IF sy-subrc IS INITIAL AND lv_xnfeactive = 'X'.

    ELSE.
      RETURN.
    ENDIF.

    Lo_nfse = cl_j_1bnfse=>get_instance( ).

    IF Lo_nfse->is_service_notafiscal( iv_document_number = ls_active-docnum ) = abap_true.
      lv_rfcdest = if_j_1bnfse=>mc_nfse_downloadxml_key.
      lv_access_key = ls_active-rps.
      IF iv_active-conting = abap_true.
        RETURN.
      ENDIF.
    ENDIF.

    IF lv_rfcdest IS NOT INITIAL.

      CREATE OBJECT Lo_download
        EXPORTING
          iv_xml_key = lv_access_key
          iv_rfc     = lv_rfcdest.

      CASE ls_active-model.
        WHEN 55.
          lv_doctype = LC_model_nfe.
        WHEN 57.
          lv_doctype = LC_model_cte.
      ENDCASE.

      CASE ls_active-direct.

        WHEN '1'.

          SELECT SINGLE entrad
            FROM j_1bnfdoc
            INTO @DATA(lv_docentrad)
            WHERE docnum = @ls_active-docnum.

          IF lv_docentrad = abap_true.
            lv_direction = Lc_direct_out.
          ELSE.
            lv_direction = Lc_direct_in.
          ENDIF.
        WHEN '2'.
          lv_direction = Lc_direct_out.
      ENDCASE.

      CALL METHOD Lo_download->load_xml_content
        EXPORTING
          iv_docnum       = ls_active-docnum
          iv_event_type   = '' "iv_active-ext_event
          iv_event_seqnum = '00' "iv_active-seqnum
          iv_direction    = lv_direction
          iv_doctype      = lv_doctype.

      DATA(lv_xml_content) = Lo_download->get_xml_content( ).

      IF NOT lv_xml_content IS INITIAL.

        lv_folder = '/usr/sap/tmp/'. "TEST

        CONCATENATE lv_folder lv_access_key '.xml' INTO lv_file_name.

        OPEN DATASET lv_file_name FOR OUTPUT IN BINARY MODE.
        IF sy-subrc EQ 0.
          TRANSFER lv_xml_content TO lv_file_name.
          CLOSE DATASET lv_file_name.
        ENDIF.

      ENDIF.

      FREE Lo_download.

    ENDIF.

  ENDMETHOD.


  METHOD get_parameters.

    TRY.
        Lo_parametros->m_get_single(
          EXPORTING
            iv_modulo = 'TM'
            iv_chave1 = 'INTEGRACAO_GKO'
            iv_chave2 = 'PASTA'
          IMPORTING
            ev_param  = rv_folder ).
      CATCH zcxca_tabela_parametros.
        RETURN.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
