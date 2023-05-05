CLASS zcltm_gestao_frete_a_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcltm_gestao_frete_a_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream
        REDEFINITION .

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .

  PROTECTED SECTION.
    METHODS getfilelistset_get_entityset
        REDEFINITION .

    METHODS downloadfileset_get_entity
        REDEFINITION .

    METHODS groupingcreatese_get_entityset
        REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_gestao_frete_a_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: lo_message    TYPE REF TO /iwbep/if_message_container,
          lo_exception  TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_acckey     TYPE STANDARD TABLE OF zttm_gkot001-acckey,
          lt_return_all TYPE bapiret2_t,
          ls_cockpit    TYPE zi_tm_cockpit001,
          lv_acckey_all TYPE string,
          lv_filename   TYPE sdok_filnm,
          lv_extension  TYPE char20,
          lv_mime_type  TYPE w3conttype,
          lv_atc_type   TYPE /bobf/attachment_type,
          lv_name       TYPE sdok_filnm,
          lv_year       TYPE gjahr,
          lv_month      TYPE monat,
          lv_day        TYPE monat.

    DATA(lo_file)        = NEW zcltm_atc_folder_fo( ).
    DATA(lo_agrupamento) = NEW zcltm_agrupar_fatura( ).

    CASE iv_source_name.

      WHEN 'uploadFile'.

* ----------------------------------------------------------------------
* Recupera dados informados durante carga
* ----------------------------------------------------------------------
        SPLIT iv_slug AT ';' INTO lv_acckey_all lv_filename lv_atc_type.
        SPLIT lv_acckey_all AT ',' INTO TABLE lt_acckey.

* ----------------------------------------------------------------------
* Recupera Mime Type
* ----------------------------------------------------------------------
        SPLIT lv_filename AT '.' INTO DATA(lv_dummy) lv_extension.

        CALL FUNCTION 'SDOK_MIMETYPE_GET'
          EXPORTING
            extension = lv_extension
          IMPORTING
            mimetype  = lv_mime_type.

        LOOP AT lt_acckey INTO DATA(lv_acckey).

* ----------------------------------------------------------------------
* Recupera dados do cockpit
* ----------------------------------------------------------------------
          DATA(lt_return) = lo_file->get_data( EXPORTING iv_acckey  = lv_acckey
                                               IMPORTING es_cockpit = ls_cockpit ).

          INSERT LINES OF lt_return INTO TABLE lt_return_all.

* ----------------------------------------------------------------------
* Realiza carga do arquivo
* ----------------------------------------------------------------------
          IF lt_return IS INITIAL.

            lt_return = lo_file->add_file( EXPORTING iv_torid     = ls_cockpit-tor_id
                                                     iv_filename  = lv_filename
                                                     iv_atc_type  = lv_atc_type
                                                     iv_mime_type = lv_mime_type
                                                     iv_name      = CONV #( lv_acckey )
                                                     iv_data      = is_media_resource-value
                                                     iv_acckey    = lv_acckey ).

            lo_file->format_message( CHANGING ct_return = lt_return ).

            LOOP AT lt_return REFERENCE INTO DATA(ls_return).
              ls_return->message = |{ lv_acckey }: { ls_return->message }|.
            ENDLOOP.

            INSERT LINES OF lt_return INTO TABLE lt_return_all.
          ENDIF.

        ENDLOOP.

      WHEN 'grouping'.

        DATA(lt_header) =  io_tech_request_context->get_request_headers( ).

* ----------------------------------------------------------------------
* Recupera filtro de seleção
* ----------------------------------------------------------------------
        TRY.
            lv_acckey_all     = VALUE #( lt_header[ name = 'acckey' ]-value ). "#EC CI_STDSEQ
            CONDENSE lv_acckey_all NO-GAPS.
            SPLIT lv_acckey_all AT ',' INTO TABLE lt_acckey.
            DATA(lv_numdoc)         = VALUE #( lt_header[ name = 'numdoc' ]-value ). "#EC CI_STDSEQ
            DATA(lv_numfatura)      = VALUE #( lt_header[ name = 'numfatura' ]-value ). "#EC CI_STDSEQ
            DATA(lv_datavenc)       = VALUE #( lt_header[ name = 'datavenc' ]-value ). "#EC CI_STDSEQ

            SPLIT lv_datavenc AT '-' INTO lv_year lv_month lv_day.
            lv_datavenc = |{ lv_year ALPHA = IN }{ lv_month ALPHA = IN }{ lv_day ALPHA = IN }|.

            REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_datavenc WITH ''.
            DATA(lv_valorfrete)     = VALUE #( lt_header[ name = 'valorfrete' ]-value ). "#EC CI_STDSEQ
            DATA(lv_valordesconto)  = VALUE #( lt_header[ name = 'valordesconto' ]-value ). "#EC CI_STDSEQ
            DATA(lv_valorpagar)     = VALUE #( lt_header[ name = 'valorpagar' ]-value ). "#EC CI_STDSEQ

          CATCH cx_root.
            " Erro ao extrair os campos do pop-up.
            lt_return_all = VALUE #( BASE lt_return_all ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '135' ) ).
        ENDTRY.

        TRY.
            DATA(lv_vlr_total) = CONV wrbtr( lv_valorfrete ).
          CATCH cx_root.
        ENDTRY.

        TRY.
            DATA(lv_vlr_desconto) = CONV wrbtr( lv_valordesconto ).
          CATCH cx_root.
        ENDTRY.

        TRY.
            DATA(lv_fatura_trasnpo) = CONV xblnr( lv_numfatura ).
          CATCH cx_root.
        ENDTRY.

        TRY.
            DATA(lv_data_vencimento) = CONV dzfbdt( lv_datavenc ).
          CATCH cx_root.
        ENDTRY.

* ---------------------------------------------------------------------------
* Realiza agrupamento das faturas
* ---------------------------------------------------------------------------
        lo_agrupamento->agrupar_fatura( EXPORTING iv_stcd1           = ''
                                                  iv_vlr_total       = lv_vlr_total
                                                  iv_vlr_desconto    = lv_vlr_desconto
                                                  iv_fatura_trasnpo  = lv_fatura_trasnpo
                                                  iv_data_vencimento = lv_data_vencimento
                                                  it_acckey          = VALUE #( FOR ls_acckey IN lt_acckey ( acckey = ls_acckey ) )
                                        IMPORTING et_mensagens       = lt_return_all ).

        IF NOT line_exists( lt_return_all[ type = 'E' ] ).
          FREE lt_return_all.
        ENDIF.

* ----------------------------------------------------------------------
* Anexa arquivos quando informado
* ----------------------------------------------------------------------
        IF lt_return_all IS INITIAL AND is_media_resource IS NOT INITIAL.

          SPLIT iv_slug AT '.' INTO lv_name lv_dummy.

          lv_mime_type  = is_media_resource-mime_type.
          lv_name       = lv_dummy.
          lv_atc_type   = 'APAGR'.

          LOOP AT lt_acckey INTO lv_acckey.

            lt_return = lo_file->get_data( EXPORTING iv_acckey  = lv_acckey
                                           IMPORTING es_cockpit = ls_cockpit ).

            INSERT LINES OF lt_return INTO TABLE lt_return_all.

* ----------------------------------------------------------------------
* Realiza carga do arquivo
* ----------------------------------------------------------------------
            IF lt_return IS INITIAL.


              lt_return = lo_file->add_file( EXPORTING iv_torid     = ls_cockpit-tor_id
                                                       iv_filename  = lv_filename
                                                       iv_atc_type  = lv_atc_type
                                                       iv_mime_type = lv_mime_type
                                                       iv_name      = lv_name
                                                       iv_data      = is_media_resource-value
                                                       iv_acckey    = lv_acckey ).

              INSERT LINES OF lt_return INTO TABLE lt_return_all.

            ENDIF.

          ENDLOOP.

        ENDIF.

        TRY.
            ls_cockpit-acckey = lt_acckey[ 1 ].
          CATCH cx_root.
        ENDTRY.

    ENDCASE.

    copy_data_to_ref( EXPORTING is_data = ls_cockpit
                      CHANGING  cr_data = er_entity ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return_all[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return_all ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_t,
          ls_cockpit   TYPE zi_tm_cockpit001,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource.

    DATA(lo_file) = NEW zcltm_atc_folder_fo( ).

* ----------------------------------------------------------------------
* Recupera filtro de seleção
* ----------------------------------------------------------------------
    TRY.
        DATA(lv_acckey)      = VALUE j_1b_nfe_access_key_dtel44( it_key_tab[ name = 'acckey' ]-value ). "#EC CI_STDSEQ
        DATA(lv_filekey)     = VALUE /bobf/conf_key( it_key_tab[ name = 'filekey' ]-value ). "#EC CI_STDSEQ
      CATCH cx_root.
        " Chave não informada para a busca da lista.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '119' ) ).
    ENDTRY.

    TRY.
        DATA(lv_attach_type) = VALUE ze_gko_attach_type( it_key_tab[ name = 'filekey' ]-value ). "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Recupera dados do cockpit
* ----------------------------------------------------------------------
    IF lt_return IS INITIAL.
      lt_return = lo_file->get_data( EXPORTING iv_acckey  = lv_acckey
                                     IMPORTING es_cockpit = ls_cockpit ).
    ENDIF.

    DATA(ls_file) = lo_file->get_file( iv_torid    = ls_cockpit-tor_id
                                       iv_file_key = lv_filekey
                                       iv_acckey   = lv_acckey ).

*    DATA(ls_file) = lo_file->get_file_002( iv_acckey      = lv_acckey
*                                           iv_attach_type = lv_attach_type ).

* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
    ls_header-name  = |Content-Disposition| ##NO_TEXT.
    ls_header-value = |outline; filename="{ ls_file-file_name }";|.

    set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do PDF
* ----------------------------------------------------------------------
    ls_stream-mime_type = ls_file-mime_code.
    ls_stream-value     = ls_file-content.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

    IF ls_file IS INITIAL.
      " Arquivo não encontrado.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '124' ) ).
    ENDIF.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD getfilelistset_get_entityset.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_t,
          ls_cockpit   TYPE zi_tm_cockpit001,
          lv_acckey    TYPE zttm_gkot001-acckey.

    DATA(lo_file) = NEW zcltm_atc_folder_fo( ).

* ----------------------------------------------------------------------
* Recupera filtro de seleção
* ----------------------------------------------------------------------
    DATA(lt_filter) =  io_tech_request_context->get_filter( )->get_filter_select_options( ).

    TRY.
        lv_acckey = lt_filter[ property = 'ACCKEY' ]-select_options[ 1 ]-low.
      CATCH cx_root.
        " Chave não informada para a busca da lista.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '119' ) ).
    ENDTRY.

* ----------------------------------------------------------------------
* Recupera dados do cockpit
* ----------------------------------------------------------------------
    IF lt_return IS INITIAL.
      lt_return = lo_file->get_data( EXPORTING iv_acckey  = lv_acckey
                                     IMPORTING es_cockpit = ls_cockpit ).
    ENDIF.

    lo_file->get_doc_list( EXPORTING iv_torid        = ls_cockpit-tor_id
                                     iv_acckey       = lv_acckey
                           IMPORTING et_atf_doc_list = DATA(lt_list) ).

    et_entityset[] = VALUE #( FOR ls_list IN lt_list ( acckey  = lv_acckey
                                                       filekey = ls_list-filekey
                                                       name    = ls_list-name
                                                       atctype = ls_list-atctype ) ).

*     lo_file->get_doc_list_002( EXPORTING iv_acckey       = lv_acckey
*                                IMPORTING et_atf_doc_list = et_entityset[]  ).

    IF et_entityset[] IS INITIAL.
      " Ordem de frete sem lista de anexos.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '120' ) ).
    ENDIF.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD downloadfileset_get_entity.

    DATA: lo_message     TYPE REF TO /iwbep/if_message_container,
          lo_exception   TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return      TYPE bapiret2_t,
          ls_cockpit     TYPE zi_tm_cockpit001,
          lv_acckey      TYPE zttm_gkot001-acckey,
          lv_filekey     TYPE /bobf/conf_key,
          lv_attach_type TYPE ze_gko_attach_type.

    DATA(lo_file) = NEW zcltm_atc_folder_fo( ).

    TRY.
        lv_acckey  = it_key_tab[ name = 'acckey' ]-value.
        lv_filekey = it_key_tab[ name = 'filekey' ]-value.
      CATCH cx_root.
        " Chave não informada para a busca da lista.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '119' ) ).
    ENDTRY.

    TRY.
        lv_attach_type = it_key_tab[ name = 'filekey' ]-value.
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Recupera dados do cockpit
* ----------------------------------------------------------------------
    IF lt_return IS INITIAL.
      lt_return = lo_file->get_data( EXPORTING iv_acckey  = lv_acckey
                                     IMPORTING es_cockpit = ls_cockpit ).
    ENDIF.

    DATA(ls_file) = lo_file->get_file( iv_torid    = ls_cockpit-tor_id
                                       iv_file_key = lv_filekey
                                       iv_acckey   = lv_acckey ).

*    DATA(ls_file) = lo_file->get_file_002( iv_acckey      = lv_acckey
*                                           iv_attach_type = lv_attach_type ).

    IF ls_file IS NOT INITIAL.

      er_entity-acckey    = lv_acckey.
      er_entity-filekey   = lv_filekey.
      er_entity-filename  = ls_file-file_name.
      er_entity-mimetype  = ls_file-mime_code.

*      cl_bcs_convert=>raw_to_xstring

      er_entity-value     = ls_file-content.

    ELSE.
      " Arquivo não encontrado.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '124' ) ).
    ENDIF.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD groupingcreatese_get_entityset.


    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_t,
          ls_cockpit   TYPE zi_tm_cockpit001,
          lt_acckey    TYPE STANDARD TABLE OF zttm_gkot001-acckey,
          lv_year      TYPE gjahr,
          lv_month     TYPE monat,
          lv_day       TYPE monat.

    DATA(lo_file) = NEW zcltm_atc_folder_fo( ).

* ----------------------------------------------------------------------
* Recupera filtro de seleção
* ----------------------------------------------------------------------
    DATA(lt_filter) =  io_tech_request_context->get_filter( )->get_filter_select_options( ).

    TRY.
        lt_acckey     = VALUE #( FOR ls_filter IN lt_filter[ property = 'ACCKEY' ]-select_options ( CONV #( ls_filter-low ) ) ). "#EC CI_STDSEQ
        DATA(lv_numdoc)         = VALUE #( lt_filter[ property = 'NUMDOCS' ]-select_options[ 1 ]-low  ). "#EC CI_STDSEQ
        DATA(lv_numfatura)      = VALUE #( lt_filter[ property = 'NUMFATURA' ]-select_options[ 1 ]-low  ). "#EC CI_STDSEQ
        DATA(lv_datavenc)       = VALUE #( lt_filter[ property = 'DATAVENC' ]-select_options[ 1 ]-low ). "#EC CI_STDSEQ

        SPLIT lv_datavenc AT '-' INTO lv_day lv_month lv_year.
        lv_datavenc = |{ lv_year ALPHA = IN }{ lv_month ALPHA = IN }{ lv_day ALPHA = IN }|.

        REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_datavenc WITH ''.
        DATA(lv_valorfrete)     = VALUE #( lt_filter[ property = 'VALORFRETE' ]-select_options[ 1 ]-low  ). "#EC CI_STDSEQ
        DATA(lv_valordesconto)  = VALUE #( lt_filter[ property = 'VALORDESCONTO' ]-select_options[ 1 ]-low  ). "#EC CI_STDSEQ
        DATA(lv_valorpagar)     = VALUE #( lt_filter[ property = 'VALORPAGAR' ]-select_options[ 1 ]-low  ). "#EC CI_STDSEQ

      CATCH cx_root.
        " Erro ao extrair os campos do pop-up.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '135' ) ).
    ENDTRY.

    TRY.
        DATA(lv_vlr_total) = CONV wrbtr( lv_valorfrete ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA(lv_vlr_desconto) = CONV wrbtr( lv_valordesconto ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA(lv_fatura_trasnpo) = CONV xblnr( lv_numfatura ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA(lv_data_vencimento) = CONV dzfbdt( lv_datavenc ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza agrupamento das faturas
* ---------------------------------------------------------------------------
    IF lt_return IS INITIAL.
      DATA(lo_agrupamento) = NEW zcltm_agrupar_fatura( ).

      lo_agrupamento->agrupar_fatura( EXPORTING iv_stcd1           = ''
                                                iv_vlr_total       = lv_vlr_total
                                                iv_vlr_desconto    = lv_vlr_desconto
                                                iv_fatura_trasnpo  = lv_fatura_trasnpo
                                                iv_data_vencimento = lv_data_vencimento
                                                it_acckey          = VALUE #( FOR ls_acckey IN lt_acckey ( acckey = ls_acckey ) )
                                      IMPORTING et_mensagens       = lt_return ).

      IF NOT line_exists( lt_return[ type = 'E' ] ).
        FREE lt_return.
      ENDIF.
    ENDIF.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
