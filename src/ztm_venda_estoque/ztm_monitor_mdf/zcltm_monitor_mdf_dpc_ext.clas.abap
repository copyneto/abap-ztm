CLASS zcltm_monitor_mdf_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcltm_monitor_mdf_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      "Tipo para buscar ID
      BEGIN OF ty_guid,
        guid TYPE sysuuid_x16,
      END OF ty_guid,

      ty_t_guid TYPE STANDARD TABLE OF ty_guid.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION.

  PROTECTED SECTION.

    METHODS cockpitmdfset_get_entityset
        REDEFINITION.
    METHODS desagruparmdfset_get_entityset
        REDEFINITION.
    METHODS monitoradicion01_get_entity
        REDEFINITION.
    METHODS monitoradicionar_get_entity
        REDEFINITION.
    METHODS usarofcriarmdfes_get_entity
        REDEFINITION.
    METHODS usarofcriarmdf01_get_entity
        REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_monitor_mdf_dpc_ext IMPLEMENTATION.


  METHOD monitoradicionar_get_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    TRY.
        DATA(lv_id)      = it_key_tab[ name = gc_field-id ]-value. "#EC CI_STDSEQ
        DATA(lv_accesskey) = it_key_tab[ name = gc_field-accesskey ]-value. "#EC CI_STDSEQ
        DATA(lv_carga)   = it_key_tab[ name = gc_field-carga ]-value. "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Salva lista de Notas Fiscais
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->save_mcd_list( EXPORTING iv_id        = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_id )
                                        iv_accesskey = lv_accesskey
                              IMPORTING et_return    = DATA(lt_return) ).

    TRY.
        DATA(ls_return) = lt_return[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Preenche informações de retorno
* ---------------------------------------------------------------------------
    er_entity-id            = lv_id.
    er_entity-accesskey    = lv_accesskey.
    er_entity-message       = ls_return-message.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return
                                          iv_add_to_response_header = abap_true ).

      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.


  ENDMETHOD.


  METHOD monitoradicion01_get_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    TRY.
        DATA(lv_id)      = it_key_tab[ name = gc_field-id ]-value. "#EC CI_STDSEQ
        DATA(lv_ordens)  = it_key_tab[ name = gc_field-ordemfrete ]-value. "#EC CI_STDSEQ
        DATA(lv_carga)   = it_key_tab[ name = gc_field-carga ]-value. "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Salva lista de Notas Fiscais
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->save_mcd_list( EXPORTING iv_id      = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_id )
                                        iv_ordens  = lv_ordens
                              IMPORTING et_return  = DATA(lt_return) ).

    TRY.
        DATA(ls_return) = lt_return[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Preenche informações de retorno
* ---------------------------------------------------------------------------
    er_entity-id            = lv_id.
    er_entity-ordemfrete    = lv_ordens.
    er_entity-message       = ls_return-message.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return
                                          iv_add_to_response_header = abap_true ).

      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.
  ENDMETHOD.


  METHOD cockpitmdfset_get_entityset.
    DATA: lt_dados     TYPE TABLE OF zstm_mdfe_relatorio,
          lt_return    TYPE bapiret2_t,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    DATA(lt_return_check) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_b
                                                              iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-modificar ).


    IF lt_return_check IS NOT INITIAL.                   "#EC CI_STDSEQ

      DATA(lo_message_check) = mo_context->get_message_container( ).
      lo_message_check = mo_context->get_message_container( ).
      lo_message_check->add_messages_from_bapi( it_bapi_messages = lt_return_check
                                                iv_add_to_response_header = abap_true ).

      CREATE OBJECT lo_exception EXPORTING message_container = lo_message_check.
      RAISE EXCEPTION lo_exception.
    ENDIF.

    "Cria instancia
    DATA(lo_cockpit) = zcltm_monitor_mdf=>get_instance( ).

    DATA(lt_result) = lo_cockpit->build( iv_agrupar = abap_true ).

    SELECT * FROM @lt_result AS result
    WHERE (iv_filter_string)
    INTO TABLE @lt_result.

    " Verifica se existe linhas com MDF criada
    SELECT * FROM @lt_result AS result
    WHERE statuscode IS NOT INITIAL
    INTO TABLE @DATA(lt_result_error).

    IF sy-subrc NE 0.
      FREE lt_result_error.
    ENDIF.

    LOOP AT lt_result_error REFERENCE INTO DATA(ls_result).
      IF ls_result->br_notafiscal IS NOT INITIAL.
        " NF &1 já agrupada na MDF-e. Favor desmarcar.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '110' message_v1 = ls_result->br_notafiscal ) ).
      ENDIF.
      IF ls_result->ordemfrete IS NOT INITIAL.
        " OF &1 já agrupada na MDF-e. Favor desmarcar.
        lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '111' message_v1 = ls_result->ordemfrete ) ).
      ENDIF.
    ENDLOOP.

    IF lt_return IS INITIAL.
      " Remove as linhas com MDF-e criadas
      SELECT * FROM @lt_result AS result
      WHERE statuscode IS INITIAL
      INTO TABLE @lt_result.

      "Preencher tabelas Z
      MOVE-CORRESPONDING lt_result TO lt_dados.

      DATA(lo_monitor) = NEW zcltm_monitor_mdf( ).
      lt_return = lo_monitor->agrupar( lt_dados ).

      "Cria instancia
      DATA(lo_message) = mo_context->get_message_container( ).
    ENDIF.

* ----------------------------------------------------------------------
* Retorna mensagem de sucesso
* ----------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'E' ] ).       "#EC CI_STDSEQ
      " MDF-e criada com sucesso.
      MESSAGE s003(ztm_monitor_mdf) INTO DATA(lv_msg).

      lo_message->add_message_text_only(
        EXPORTING
          iv_msg_type               = CONV #( if_abap_behv_message=>severity-success )
          iv_msg_text               = CONV bapi_msg( lv_msg )
          iv_add_to_response_header = abap_true ).
    ELSE.
* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
        EXPORTING
          message_container = lo_cockpit->add_message_to_container( io_context = mo_context it_return = lt_return ).
    ENDIF.
  ENDMETHOD.

  METHOD desagruparmdfset_get_entityset.
    DATA  lt_dados      TYPE TABLE OF zstm_mdfe_relatorio.
    DATA lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    "Cria instancia
    DATA(lo_cockpit) = zcltm_monitor_mdf=>get_instance( ).

    DATA(lt_result) = lo_cockpit->build( iv_agrupar = abap_true ).

    SELECT * FROM @lt_result AS result
    WHERE (iv_filter_string)
    INTO TABLE @lt_result.

    "Preencher tabelas Z
    MOVE-CORRESPONDING lt_result TO lt_dados.

    DATA(lo_monitor) = NEW zcltm_monitor_mdf( ).
    DATA(lt_return) = lo_monitor->desagrupar( lt_dados ).

    "Cria instancia
    DATA(lo_message) = mo_context->get_message_container( ).

* ----------------------------------------------------------------------
* Retorna mensagem de sucesso
* ----------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'E' ] ).       "#EC CI_STDSEQ
      " MDF-e desagrupada com sucesso.
      MESSAGE s071(ztm_monitor_mdf) INTO DATA(lv_msg).

      lo_message->add_message_text_only(
        EXPORTING
          iv_msg_type               = CONV #( if_abap_behv_message=>severity-success )
          iv_msg_text               = CONV bapi_msg( lv_msg )
          iv_add_to_response_header = abap_true ).
    ELSE.
* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
        EXPORTING
          message_container = lo_cockpit->add_message_to_container( io_context = mo_context it_return = lt_return ).
    ENDIF.
  ENDMETHOD.


  METHOD usarofcriarmdfes_get_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_a
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-criar ).


    IF lt_return IS NOT INITIAL.                         "#EC CI_STDSEQ

      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return
                                          iv_add_to_response_header = abap_true ).

      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

    TRY.
        DATA(lv_ordem)  = VALUE /scmtms/tor_id( it_key_tab[ name = gc_field-ordemfrete ]-value ). "#EC CI_STDSEQ
        lv_ordem        = |{ lv_ordem ALPHA = IN }|.
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Salva lista de Notas Fiscais
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->use_fo_create_mdf( EXPORTING it_freight_order = VALUE #( ( lv_ordem ) )
                                  IMPORTING et_return        = lt_return ).

* ---------------------------------------------------------------------------
* Preenche informações de retorno
* ---------------------------------------------------------------------------
    TRY.
        er_entity-ordemfrete    = lv_ordem.
        er_entity-message       = lt_return[ 1 ]-message.
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
*    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
    IF lt_return IS NOT INITIAL.                         "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return
                                          iv_add_to_response_header = abap_true ).

      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.


    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,

          lt_key       TYPE string_table,
          lt_id        TYPE ty_t_guid,
          lt_return    TYPE bapiret2_t,

          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource,

          lv_file      TYPE xstring.

    DATA(lt_return_print) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_b
                                                              iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-imprimir ).

    IF lt_return_print IS NOT INITIAL.                   "#EC CI_STDSEQ

      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return_print
                                          iv_add_to_response_header = abap_true ).

      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

    CASE iv_entity_name.
* ----------------------------------------------------------------------
* Entidade responsável pelo envio do binário do arquivo
* ----------------------------------------------------------------------
      WHEN gc_entity-download.

        TRY.
            DATA(lv_key) = VALUE #( it_key_tab[ name = gc_fields-id ]-value ). "#EC CI_STDSEQ
          CATCH cx_root.
        ENDTRY.

*       Separa os IDs selecionados
        SPLIT lv_key AT ';' INTO TABLE lt_key.
        lt_id = VALUE #( FOR lv_keys IN lt_key ( guid = lv_keys ) ).

        "Cria instancia
        DATA(lo_pdf) = zcltm_monitor_mdf=>get_instance( ).

        lo_pdf->print_pdf( EXPORTING it_id = lt_id
                           IMPORTING ev_pdf_file = lv_file
                                     et_return   = lt_return ).

* ----------------------------------------------------------------------
* Atualizar Metadata ao arquivo
* ----------------------------------------------------------------------
        TRY.
            " Cria Objeto PDF
            DATA(lo_fp) = cl_fp=>get_reference( ).
            DATA(lo_pdfobj) = lo_fp->create_pdf_object( connection = 'ADS' ).
            lo_pdfobj->set_document( pdfdata = lv_file ).

            " Atualiza título do arquivo PDF
            DATA(ls_meta) = VALUE sfpmetadata( title = 'MDFe' ).
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
        ls_header-name  = |Content-Disposition| ##NO_TEXT.
        ls_header-value = |inline; filename="{ gc_filename }";|.

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


  METHOD usarofcriarmdf01_get_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

* ---------------------------------------------------------------------------
* Salva lista de Notas Fiscais
* ---------------------------------------------------------------------------
    SELECT freightorder
      FROM zi_tm_vh_mdf_of_nf_criar
      WHERE freightorder IS NOT INITIAL
      INTO TABLE @DATA(lt_of).

    IF sy-subrc NE 0.
      APPEND 'N/A' TO lt_of.
    ENDIF.

    SORT lt_of BY table_line DESCENDING.

* ---------------------------------------------------------------------------
* Preenche informações de retorno
* ---------------------------------------------------------------------------
    er_entity-ordemfrete        = space.
    er_entity-ordemfretelista   = concat_lines_of( table = lt_of sep = ';' ).

  ENDMETHOD.
ENDCLASS.
