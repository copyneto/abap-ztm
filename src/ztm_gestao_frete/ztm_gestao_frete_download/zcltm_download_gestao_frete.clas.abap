"!<p>Classe Processa Downloads Gestão Frete</p>
"!<p><strong>Autor:</strong>Marcos Rubik</p>
"!<p><strong>Data:</strong> 27 de Abril de 2022</p>
CLASS zcltm_download_gestao_frete DEFINITION
  PUBLIC
  CREATE PUBLIC .
  PUBLIC SECTION.
    "! Download
    "! @parameter is_acckey             | Chave NFE
    "! @parameter iv_doctype            | Tipo de documento
    "! @parameter ev_filename           | Nome Arquivo Retorno
    "! @parameter ev_file               | Arquivo binário
    "! @parameter ev_mime_type          | Tipo Arquivo
    "! @parameter et_return             | Mensagens de retorno
    METHODS download
      IMPORTING
        !is_acckey    TYPE j_1b_nfe_access_key
        !iv_doctype   TYPE string
      EXPORTING
        !ev_filename  TYPE string
        !ev_file      TYPE xstring
        !ev_mime_type TYPE string
        !et_return    TYPE bapiret2_t.
    "! Pega filtros de entrada
    "! @parameter iv_filter_string          | String de Filtro
    "! @parameter et_filter_select_options  | Tabela de retorno
    METHODS set_filter_str
      IMPORTING
        iv_filter_string         TYPE string
      EXPORTING
        et_filter_select_options TYPE /iwbep/t_mgw_select_option.

  PROTECTED SECTION.
  PRIVATE SECTION.
    "! Download PDF NFE
    "! @parameter is_acckey             | Chave NFE
    "! @parameter iv_doctype            | Tipo de documento
    "! @parameter ev_filename           | Nome Arquivo Retorno
    "! @parameter ev_file               | Arquivo binário
    "! @parameter ev_mime_type          | Tipo Arquivo
    "! @parameter et_return             | Mensagens de retorno
    METHODS download_pdf_nfe
      IMPORTING
        !is_acckey    TYPE j_1b_nfe_access_key
        !iv_doctype   TYPE string
      EXPORTING
        !ev_filename  TYPE string
        !ev_file      TYPE xstring
        !ev_mime_type TYPE string
        !et_return    TYPE bapiret2_t.
    "! Download XML NFE
    "! @parameter is_acckey             | Chave NFE
    "! @parameter iv_doctype            | Tipo de documento
    "! @parameter ev_filename           | Nome Arquivo Retorno
    "! @parameter ev_file               | Arquivo binário
    "! @parameter ev_mime_type          | Tipo Arquivo
    "! @parameter et_return             | Mensagens de retorno
    METHODS download_xml_nfe
      IMPORTING
        !is_acckey    TYPE j_1b_nfe_access_key
        !iv_doctype   TYPE string
      EXPORTING
        !ev_filename  TYPE string
        !ev_file      TYPE xstring
        !ev_mime_type TYPE string
        !et_return    TYPE bapiret2_t.
    "! Download PDF CT-e
    "! @parameter is_acckey             | Chave NFE
    "! @parameter iv_doctype            | Tipo de documento
    "! @parameter ev_filename           | Nome Arquivo Retorno
    "! @parameter ev_file               | Arquivo binário
    "! @parameter ev_mime_type          | Tipo Arquivo
    "! @parameter et_return             | Mensagens de retorno
    METHODS download_pdf_cte
      IMPORTING
        !is_acckey    TYPE j_1b_nfe_access_key
        !iv_doctype   TYPE string
      EXPORTING
        !ev_filename  TYPE string
        !ev_file      TYPE xstring
        !ev_mime_type TYPE string
        !et_return    TYPE bapiret2_t.
    "! Download XML CT-e
    "! @parameter is_acckey             | Chave NFE
    "! @parameter iv_doctype            | Tipo de documento
    "! @parameter ev_filename           | Nome Arquivo Retorno
    "! @parameter ev_file               | Arquivo binário
    "! @parameter ev_mime_type          | Tipo Arquivo
    "! @parameter et_return             | Mensagens de retorno
    METHODS download_xml_cte
      IMPORTING
        !is_acckey    TYPE j_1b_nfe_access_key
        !iv_doctype   TYPE string
      EXPORTING
        !ev_filename  TYPE string
        !ev_file      TYPE xstring
        !ev_mime_type TYPE string
        !et_return    TYPE bapiret2_t.

ENDCLASS.

CLASS zcltm_download_gestao_frete IMPLEMENTATION.
  METHOD download.

    CASE iv_doctype.
      WHEN '1'.
        me->download_pdf_nfe(
          EXPORTING
            is_acckey    = is_acckey
            iv_doctype   = iv_doctype
          IMPORTING
            ev_filename  = ev_filename
            ev_file      = ev_file
            ev_mime_type = ev_mime_type
        ).
      WHEN '2'.
        me->download_pdf_cte(
          EXPORTING
            is_acckey    = is_acckey
            iv_doctype   = iv_doctype
          IMPORTING
            ev_filename  = ev_filename
            ev_file      = ev_file
            ev_mime_type = ev_mime_type
        ).
      WHEN '4'.
        me->download_xml_nfe(
          EXPORTING
            is_acckey    = is_acckey
            iv_doctype   = iv_doctype
          IMPORTING
            ev_filename  = ev_filename
            ev_file      = ev_file
            ev_mime_type = ev_mime_type
        ).
      WHEN '5'.
        me->download_xml_cte(
          EXPORTING
            is_acckey    = is_acckey
            iv_doctype   = iv_doctype
          IMPORTING
            ev_filename  = ev_filename
            ev_file      = ev_file
            ev_mime_type = ev_mime_type
        ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

  METHOD download_pdf_nfe.

    DATA: lv_nfeid  TYPE /xnfe/innfehd-nfeid,
          lv_acckey TYPE j_1b_nfe_access_key_dtel44.

*    IF sy-uname = 'CGARCIA'.
*
*      SELECT SINGLE docnum
*        FROM  j_1bnfe_active
*        INTO @DATA(lv_docnum)
*            WHERE    regio    = @is_acckey-regio
*            AND      nfyear   = @is_acckey-nfyear
*            AND      nfmonth  = @is_acckey-nfmonth
*            AND      stcd1    = @is_acckey-stcd1
*            AND      model    = @is_acckey-model
*            AND      serie    = @is_acckey-serie
*            AND      nfnum9   = @is_acckey-nfnum9.
*
*      " Recupera PDF da nota fiscal
*      DATA(lo_impressao) = NEW zclsd_nf_mass_download( ).
*      lo_impressao->gera_pdf( EXPORTING iv_docnum   = lv_docnum
*                                        iv_doctype  = iv_doctype
*                              IMPORTING ev_filename = lv_filename
*                                        ev_file     = DATA(lv_file)
*                                        et_return   = et_return ).
*
*    ELSE.

    lv_acckey = is_acckey.

    DATA(lo_pdf) = NEW zcltm_gestao_frete_relat( ).

    lo_pdf->print_nf( EXPORTING iv_acckey = lv_acckey
                      IMPORTING ev_pdf    = DATA(lv_file)
                                et_return = et_return ).
*    ENDIF.

    ev_filename = |{ lv_acckey }_PDFNFE_{ sy-datum }{ sy-uzeit }.pdf|.
    ev_file      = lv_file.
    ev_mime_type = 'application/pdf'.

  ENDMETHOD.

  METHOD download_xml_nfe.

    DATA: lv_filename TYPE string,
          lv_nfeid    TYPE /xnfe/innfehd-nfeid.

*    SELECT SINGLE docnum
*      FROM  j_1bnfe_active
*      INTO @DATA(lv_docnum)
*          WHERE    regio    = @is_acckey-regio
*          AND      nfyear   = @is_acckey-nfyear
*          AND      nfmonth  = @is_acckey-nfmonth
*          AND      stcd1    = @is_acckey-stcd1
*          AND      model    = @is_acckey-model
*          AND      serie    = @is_acckey-serie
*          AND      nfnum9   = @is_acckey-nfnum9.
*
*    lv_nfeid = is_acckey.
*    SELECT SINGLE guid_header
*      FROM /xnfe/innfehd
*      INTO @DATA(lv_guid_header)
*     WHERE nfeid = @lv_nfeid.
*    IF sy-subrc = 0.
*      SELECT SINGLE xmlstring
*        FROM /xnfe/inxml
*        INTO @DATA(lv_xmlstring)
*       WHERE guid_header = @lv_guid_header.
*      IF sy-subrc <> 0.
*        CLEAR: lv_xmlstring.
*      ENDIF.
*    ENDIF.

    DATA(lv_acckey) = CONV j_1b_nfe_access_key_dtel44( is_acckey ).

    SELECT SINGLE
           001~acckey,
           001~bukrs,
           001~branch,
           001~tpdoc,
           003~acckey_ref
      FROM zttm_gkot001 AS 001
      INNER JOIN zttm_gkot003 AS 003
        ON 003~acckey = 001~acckey
      INTO @DATA(ls_nfe)
      WHERE 001~acckey = @lv_acckey.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    TRY.
        DATA(lv_xml_ref) = zcltm_gko_process=>get_xml_from_ref_nf( iv_bukrs     = ls_nfe-bukrs
                                                                   iv_branch    = ls_nfe-branch
                                                                   iv_acckey    = ls_nfe-acckey
                                                                   iv_direction = 'INBD'
                                                                   iv_doctype   = CONV #( ls_nfe-tpdoc ) ).
      CATCH cx_root.
    ENDTRY.

    IF lv_xml_ref IS INITIAL.
      TRY.
          lv_xml_ref        = zcltm_gko_process=>get_xml_from_ref_nf( iv_bukrs     = ls_nfe-bukrs
                                                                      iv_branch    = ls_nfe-branch
                                                                      iv_acckey    = ls_nfe-acckey
                                                                      iv_direction = 'OUTB'
                                                                      iv_doctype   = CONV #( ls_nfe-tpdoc ) ).
        CATCH cx_root.
      ENDTRY.
    ENDIF.

    lv_filename = |{ lv_acckey }_XMLNFE_{ sy-datum }{ sy-uzeit }.xml|.

    ev_filename  = lv_filename.
    ev_file      = lv_xml_ref.
    ev_mime_type = 'application/xml'.

  ENDMETHOD.

  METHOD download_pdf_cte.
    DATA  lv_acckey    TYPE /xnfe/inctehd-cteid.

    lv_acckey = is_acckey.

    TRY.
        DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey = lv_acckey ).
        lr_gko_process->print( IMPORTING ev_pdf = ev_file ).
        lr_gko_process->free( ).

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
        IF lr_gko_process IS BOUND.
          lr_gko_process->free( ).
        ENDIF.
        et_return = lr_cx_gko_process->get_bapi_return( ).
    ENDTRY.

    CHECK et_return IS INITIAL.

    ev_filename = |{ lv_acckey }_PDFCTE_{ sy-datum }{ sy-uzeit }.pdf|.
    ev_mime_type = 'application/pdf'.

  ENDMETHOD.

  METHOD download_xml_cte.

    DATA: lv_filename TYPE string,
          lv_cteid    TYPE /xnfe/inctehd-cteid.

*    SELECT SINGLE docnum
*      FROM  j_1bnfe_active
*      INTO @DATA(lv_docnum)
*          WHERE    regio    = @is_acckey-regio
*          AND      nfyear   = @is_acckey-nfyear
*          AND      nfmonth  = @is_acckey-nfmonth
*          AND      stcd1    = @is_acckey-stcd1
*          AND      model    = @is_acckey-model
*          AND      serie    = @is_acckey-serie
*          AND      nfnum9   = @is_acckey-nfnum9.
*
*    lv_cteid = is_acckey.
*    SELECT SINGLE guid
*      FROM /xnfe/inctehd
*      INTO @DATA(lv_guid)
*     WHERE cteid = @lv_cteid.
*    IF sy-subrc = 0.
*      SELECT SINGLE xmlstring
*        FROM /xnfe/inctexml
*        INTO @DATA(lv_xmlstring)
*       WHERE guid = @lv_guid.
*      IF sy-subrc <> 0.
*        CLEAR: lv_xmlstring.
*      ENDIF.
*    ENDIF.
*
*    lv_filename = |{ lv_docnum }_XMLCTE_{ sy-datum }{ sy-uzeit }.xml|.
*
*    ev_filename  = lv_filename.
*    ev_file      = lv_xmlstring.
*    ev_mime_type = 'application/xml'.

*
*    SELECT single acckey, attach_content
*        FROM zttm_gkot002
*        INTO @DATA(ls_attach)
*        WHERE acckey      = @lv_acckey
*          and attach_type = '1'. " XML

    DATA(lv_acckey) = CONV j_1b_nfe_access_key_dtel44( is_acckey ).

    SELECT SINGLE
           001~acckey,
           001~bukrs,
           001~branch,
           003~acckey_ref
      FROM zttm_gkot001 AS 001
      INNER JOIN zttm_gkot003 AS 003
        ON 003~acckey = 001~acckey
      INTO @DATA(ls_cte)
      WHERE 001~acckey = @lv_acckey.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    TRY.
        DATA(lv_xml_ref) = zcltm_gko_process=>get_xml_from_ref_nf( iv_bukrs     = ls_cte-bukrs
                                                                   iv_branch    = ls_cte-branch
                                                                   iv_acckey    = ls_cte-acckey
                                                                   iv_direction = 'INBD'
                                                                   iv_doctype   = 'CTE' ).
      CATCH cx_root.
    ENDTRY.

    ev_filename  = |{ lv_acckey }_XMLCTE_{ sy-datum }{ sy-uzeit }.xml|.
    ev_file      = lv_xml_ref.
    ev_mime_type = 'text/xml'.

  ENDMETHOD.

  METHOD set_filter_str.
    DATA:
      lt_filter_string          TYPE TABLE OF string,
      lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
      lv_input                  TYPE string,
      lv_name                   TYPE string,
      lv_doctype                TYPE string,
      lv_value                  TYPE string,
      lv_value2                 TYPE string,
      lv_sign                   TYPE string,
      lv_sign2                  TYPE string,

      lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
      ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
      lt_select_options         TYPE /iwbep/t_cod_select_options,
      ls_select_options         TYPE /iwbep/s_cod_select_option,
      lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
      ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.

    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

*******************************************************************************
    IF iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *--- get rid of )( & ' and make AND's uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF `'` IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' and ' IN lv_input WITH ' AND '.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' OR '.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      SPLIT lv_input AT 'AND' INTO TABLE lt_filter_string.

* *--- build a table of key value pairs based on filter string
      LOOP AT lt_filter_string ASSIGNING FIELD-SYMBOL(<fs_filter_string>).
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.

        CONDENSE <fs_filter_string>.
*       Split at space, then split into 3 parts
        SPLIT <fs_filter_string> AT ' ' INTO lv_name lv_sign lv_value  .
        TRANSLATE lv_sign TO UPPER CASE.
        ls_select_options-sign = 'I'.
        ls_select_options-option = lv_sign.
        ls_select_options-low = lv_value.
        APPEND ls_select_options TO lt_select_options. CLEAR:ls_select_options.
        ls_filter_select_options-property = lv_name.
        ls_filter_select_options-select_options = lt_select_options.

        APPEND ls_filter_select_options TO lt_filter_select_options.
        CLEAR: ls_filter_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

    et_filter_select_options = lt_filter_select_options.
  ENDMETHOD.

ENDCLASS.
