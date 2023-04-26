CLASS zcltm_download_gesta_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcltm_download_gesta_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.

    METHODS downloadcheckset_get_entityset
        REDEFINITION .
    METHODS downloadcheckset_get_entity
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_download_gesta_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key_tab   TYPE ty_t_key_tab,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource,
          lv_filename	 TYPE string,
          lv_nfeid     TYPE /xnfe/innfehd-nfeid.

    lt_key_tab = it_key_tab[].

    CASE iv_entity_name.

* ----------------------------------------------------------------------
* Entidade responsável pelo envio do binário do arquivo
* ----------------------------------------------------------------------
      WHEN gc_entity-download.

        TRY.
            DATA(ls_acckey)  = VALUE j_1b_nfe_access_key( lt_key_tab[ name = gc_name-acckey ]-value ).
            DATA(lv_doctype) = VALUE string( lt_key_tab[ name = gc_name-doctype ]-value ).
            DATA(lv_auto)    = VALUE string( lt_key_tab[ name = gc_name-auto ]-value ).
          CATCH cx_root.
        ENDTRY.

        NEW zcltm_download_gestao_frete( )->download(
          EXPORTING
            is_acckey    = ls_acckey
            iv_doctype   = lv_doctype
          IMPORTING
            ev_filename  = lv_filename
            ev_file      = DATA(lv_file)
            ev_mime_type = DATA(lv_mime_type)
            et_return    = DATA(lt_return) ).

* ----------------------------------------------------------------------
* Atualizar Metadata ao arquivo
* ----------------------------------------------------------------------
        TRY.
            " Cria Objeto PDF
            DATA(lo_fp) = cl_fp=>get_reference( ).
            DATA(lo_pdfobj) = lo_fp->create_pdf_object( connection = 'ADS' ).
            lo_pdfobj->set_document( pdfdata = lv_file ).

            " Atualiza título do arquivo PDF
            DATA(ls_meta) = VALUE sfpmetadata( title = lv_filename ).
            lo_pdfobj->set_metadata( metadata = ls_meta ).
            lo_pdfobj->execute( ).

            " Recupera conteúdo do PDF junto com o título
            lo_pdfobj->get_document( IMPORTING pdfdata = lv_file ).

          CATCH cx_root.
        ENDTRY.

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------

        ls_header-name  = |Content-Disposition|.
        ls_header-value = COND #( WHEN lv_auto IS NOT INITIAL
                                  THEN |outline; filename="{ lv_filename }";|
                                  ELSE |inline; filename="{ lv_filename }";| ).

        set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do XML
* ----------------------------------------------------------------------
        ls_stream-mime_type = lv_mime_type.
        ls_stream-value     = lv_file.

        copy_data_to_ref( EXPORTING is_data = ls_stream
                          CHANGING  cr_data = er_stream ).


      WHEN OTHERS.
    ENDCASE.

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.
  ENDMETHOD.


  METHOD downloadcheckset_get_entity.
    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key_tab   TYPE ty_t_key_tab.

    lt_key_tab = it_key_tab[].

    CASE iv_entity_name.

* ----------------------------------------------------------------------
* Entidade para verificar se arquivo de download existe
* ----------------------------------------------------------------------
      WHEN gc_entity-downloadcheck.

        TRY.
            DATA(ls_acckey)  = VALUE j_1b_nfe_access_key( lt_key_tab[ name = gc_name-acckey ]-value ).
            DATA(lv_doctype) = VALUE string( lt_key_tab[ name = gc_name-doctype ]-value ).
          CATCH cx_root.
        ENDTRY.

        NEW zcltm_download_gestao_frete( )->download(
           EXPORTING
             is_acckey    = ls_acckey
             iv_doctype   = lv_doctype
           IMPORTING
             ev_filename  = DATA(lv_filename)
             ev_file      = DATA(lv_file)
             ev_mime_type = DATA(lv_mime_type)
             et_return    = DATA(lt_return) ).

      WHEN OTHERS.
    ENDCASE.

    er_entity-acckey   = ls_acckey.
    er_entity-doctype  = lv_doctype.
    er_entity-exist    = SWITCH #( lv_file WHEN '' THEN space ELSE abap_true ).

  ENDMETHOD.


  METHOD downloadcheckset_get_entityset.
    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    CASE iv_entity_name.

      WHEN gc_entity-downloadcheck.
        DATA(lo_download) = NEW zcltm_download_gestao_frete( ).

        IF it_filter_select_options IS INITIAL.

          lo_download->set_filter_str(
                  EXPORTING
                     iv_filter_string = iv_filter_string
                  IMPORTING
                     et_filter_select_options = DATA(lt_filter_select_options)  ).
        ELSE.
          lt_filter_select_options = it_filter_select_options.
        ENDIF.



        LOOP AT lt_filter_select_options ASSIGNING FIELD-SYMBOL(<fs_filter_select_options>).
          READ TABLE  <fs_filter_select_options>-select_options ASSIGNING FIELD-SYMBOL(<fs_select_options>) INDEX 1.
          CASE <fs_filter_select_options>-property.
            WHEN 'Acckey'.
              TRY.
                  DATA(ls_acckey)  = CONV j_1b_nfe_access_key( <fs_select_options>-low ).
                CATCH cx_root.
              ENDTRY.

            WHEN 'Doctype'.
              TRY.
                  DATA(lv_doctype) = <fs_select_options>-low.
                CATCH cx_root.
              ENDTRY.

            WHEN OTHERS.
          ENDCASE.

        ENDLOOP.

        IF ls_acckey IS NOT INITIAL.

          lo_download->download(
            EXPORTING
              is_acckey    = ls_acckey
              iv_doctype   = lv_doctype
            IMPORTING
              ev_filename  = DATA(lv_filename)
              ev_file      = DATA(lv_file)
              ev_mime_type = DATA(lv_mime_type)
              et_return    = DATA(lt_return) ).


          APPEND VALUE #(  acckey   = ls_acckey
                           doctype  = lv_doctype
                           exist    = SWITCH #( lv_file WHEN '' THEN space ELSE abap_true )
                         ) TO et_entityset.
          CLEAR:lv_file.


        ENDIF.


      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
