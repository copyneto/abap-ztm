CLASS zcltm_receb_manual_c_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcltm_receb_manual_c_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream
        REDEFINITION .

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .

  PROTECTED SECTION.

    METHODS downloadset_get_entity
        REDEFINITION .

  PRIVATE SECTION.

ENDCLASS.



CLASS zcltm_receb_manual_c_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_T.

    DATA(lo_manual) = NEW zcltm_receb_manual_cte_nfe( ).

* ----------------------------------------------------------------------
* Recupera chave
* ----------------------------------------------------------------------
    DATA(lt_headers)  = io_tech_request_context->get_request_headers( ).

    TRY.
        DATA(lv_guid_raw) = VALUE #( lt_headers[ name = 'guid' ]-value OPTIONAL ). "#EC CI_STDSEQ
        DATA(lv_guid)     = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_guid_raw ).
      CATCH cx_root.
        " Chave não informada para criação do anexo.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '125' ) ).
    ENDTRY.

    TRY.
        DATA(lv_doctype) = VALUE ze_doctype_cte_nfe( lt_headers[ name = 'doctype' ]-value OPTIONAL ). "#EC CI_STDSEQ
      CATCH cx_root.
        " Tipo de documento não informado para criação do anexo.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '126' ) ).
    ENDTRY.

* ----------------------------------------------------------------------
* Adiciona arquivo no DMS
* ----------------------------------------------------------------------
    IF lt_return[] IS INITIAL.
      lo_manual->add_attachment_to_dms( EXPORTING iv_filename = iv_slug
                                                  iv_file     = is_media_resource-value
                                        IMPORTING es_dms      = DATA(ls_dms)
                                                  et_return   = lt_return ).
    ENDIF.

* ----------------------------------------------------------------------
* Envia arquivo ao GRC
* ----------------------------------------------------------------------
    IF lt_return[] IS INITIAL.
      lo_manual->send_to_grc( EXPORTING iv_file    = is_media_resource-value
                                        iv_doctype = lv_doctype
                              IMPORTING et_return  = lt_return ).
    ENDIF.

* ----------------------------------------------------------------------
* Salva registro de log
* ----------------------------------------------------------------------
    lo_manual->save_log( EXPORTING iv_guid     = lv_guid
                                   iv_doctype  = lv_doctype
                                   iv_filename = iv_slug
                                   is_dms      = ls_dms
                                   it_return   = lt_return ).

    copy_data_to_ref( EXPORTING is_data = ls_dms CHANGING cr_data = er_entity ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages          = lt_return
                                          iv_add_to_response_header = abap_true ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource.

    TRY.
        DATA(lv_guid_raw) = VALUE #( it_key_tab[ name = gc_fields-guid ]-value ). "#EC CI_STDSEQ
        DATA(lv_guid)     = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_guid_raw ).
      CATCH cx_root.
    ENDTRY.

    DATA(lo_manual) = NEW zcltm_receb_manual_cte_nfe( ).

    lo_manual->get_attachment_from_dms( EXPORTING iv_guid     = lv_guid
                                        IMPORTING ev_filename = DATA(lv_filename)
                                                  ev_file     = DATA(lv_file)
                                                  ev_mimetype = DATA(lv_mimetype)
                                                  et_return   = DATA(lt_return) ).

* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
    ls_header-name  = |Content-Disposition| ##NO_TEXT.
    ls_header-value = |outline; filename="{ lv_filename }";|.

    set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do PDF
* ----------------------------------------------------------------------
    ls_stream-mime_type = lv_mimetype.
    ls_stream-value     = lv_file.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD downloadset_get_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_t.

    TRY.
        DATA(lv_guid_raw) = VALUE #( it_key_tab[ name = gc_fields-guid ]-value ). "#EC CI_STDSEQ
        DATA(lv_guid)     = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_guid_raw ).
      CATCH cx_root.
        " Chave não informada para criação do anexo.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '125' ) ).
    ENDTRY.

    DATA(lo_manual) = NEW zcltm_receb_manual_cte_nfe( ).

    IF lt_return IS INITIAL.
      lo_manual->get_attachment_from_dms( EXPORTING iv_guid     = lv_guid
                                          IMPORTING ev_filename = DATA(lv_filename)
                                                    ev_file     = DATA(lv_file)
                                                    ev_mimetype = DATA(lv_mimetype)
                                                    et_return   = lt_return ).
    ENDIF.

    er_entity-guid      = lv_guid.
    er_entity-filename  = lv_filename.
    er_entity-value     = lv_file.
    er_entity-mimetype  = lv_mimetype.

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
