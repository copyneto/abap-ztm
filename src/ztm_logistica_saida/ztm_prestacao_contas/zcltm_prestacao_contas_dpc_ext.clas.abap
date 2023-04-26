CLASS zcltm_prestacao_contas_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcltm_prestacao_contas_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .

  PROTECTED SECTION.

    METHODS checkauthorityse_get_entity
        REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_prestacao_contas_dpc_ext IMPLEMENTATION.


  METHOD checkauthorityse_get_entity.


    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

* ---------------------------------------------------------------------------
* Recupera as chaves
* ---------------------------------------------------------------------------
    TRY.
        DATA(lv_freightorderuuid) = it_key_tab[ name = gc_fields-freight_order ]-value. "#EC CI_STDSEQ
        DATA(lv_freightunituuid)  = it_key_tab[ name = gc_fields-freight_unit ]-value. "#EC CI_STDSEQ
      CATCH cx_root INTO DATA(lo_root).
    ENDTRY.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

    lo_cockpit->check_permission( EXPORTING iv_actvt  = zcltm_cockpit_prestacao=>gc_permission-processar
                                  IMPORTING ev_ok     = DATA(lv_ok)
                                            et_return = DATA(lt_return) ).

    er_entity-freightorderuuid = lv_freightorderuuid.
    er_entity-freightunituuid  = lv_freightunituuid.
    er_entity-message          = lv_ok.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource.

    CASE iv_entity_name.
* ----------------------------------------------------------------------
* Entidade responsável pelo envio do binário do arquivo
* ----------------------------------------------------------------------
      WHEN gc_entity-download.

        TRY.
            DATA(lv_freightorder) = VALUE /bobf/conf_key( it_key_tab[ name = gc_fields-freight_order ]-value ). "#EC CI_STDSEQ
            DATA(lv_freightunit)  = VALUE /bobf/conf_key( it_key_tab[ name = gc_fields-freight_unit ]-value ). "#EC CI_STDSEQ
            DATA(lv_printname)    = VALUE ppfdtt( it_key_tab[ name = gc_fields-print_name ]-value ). "#EC CI_STDSEQ
            TRANSLATE lv_printname USING './'.

          CATCH cx_root.
        ENDTRY.

    DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

    lo_cockpit->get_print( EXPORTING iv_freightorderuuid = lv_freightorder
                                     iv_freightunituuid  = lv_freightunit
                                     iv_printname        = lv_printname

                           IMPORTING ev_filename         = DATA(lv_filename)
                                     ev_file             = DATA(lv_file)
                                     et_return           = DATA(lt_return) ).

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
        ls_header-name  = |Content-Disposition| ##NO_TEXT.
        ls_header-value = |inline; filename="{ lv_filename }";|.

        set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do PDF
* ----------------------------------------------------------------------
        ls_stream-mime_type = 'application/pdf'.
        ls_stream-value     = lv_file.

        copy_data_to_ref( EXPORTING is_data = ls_stream
                          CHANGING  cr_data = er_stream ).

      WHEN OTHERS.
    ENDCASE.

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
