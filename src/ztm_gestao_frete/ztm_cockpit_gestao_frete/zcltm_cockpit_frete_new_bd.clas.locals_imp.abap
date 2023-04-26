CLASS lcl_CockpitHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ _CockpitHeader RESULT result.

    METHODS reprocessar FOR MODIFY
      IMPORTING keys FOR ACTION _CockpitHeader~reprocessar.

    METHODS estorno FOR MODIFY
      IMPORTING keys FOR ACTION _CockpitHeader~estorno.

    METHODS evento_cte FOR MODIFY
      IMPORTING keys FOR ACTION _CockpitHeader~evento_cte.

*    METHODS agrupamento FOR MODIFY
*      IMPORTING keys FOR ACTION _CockpitHeader~agrupamento.

    METHODS consultar_status FOR MODIFY
      IMPORTING keys FOR ACTION _CockpitHeader~consultar_status.

    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE _CockpitHeader.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _CockpitHeader RESULT result.

ENDCLASS.

CLASS lcl_CockpitHeader IMPLEMENTATION.

  METHOD read.

    "Cria instancia
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

    DATA(lt_range) = VALUE if_rap_query_filter=>tt_name_range_pairs( (
                     name  = 'ACCKEY'
                     range = VALUE #( FOR ls_keys IN keys ( sign = 'I' option = 'EQ' low = ls_keys-%key-acckey ) )
                     ) ).

    lo_cockpit->set_filters( it_range = lt_range ).

    DATA(lt_result) = lo_cockpit->build( ).

    result = CORRESPONDING #( DEEP lt_result ).

  ENDMETHOD.

  METHOD reprocessar.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_cockpit_new IN LOCAL MODE
      ENTITY _CockpitHeader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    IF sy-subrc NE 0.
      " Nenhum registro encontrado para a chave informada.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '130' ) ).
    ENDIF.

    LOOP AT lt_header_data ASSIGNING FIELD-SYMBOL(<fs_header_data>).

      FREE: lt_return.

      TRY.
          DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey          = <fs_header_data>-acckey
                                                        iv_tpprocess       = zcltm_gko_process=>gc_tpprocess-manual
                                                        iv_min_data_load   = abap_false ).
          lr_gko_process->reprocess( ).
          lr_gko_process->persist( ).
          lr_gko_process->free( ).

          " Processamento realizado. Verificar logs.
          lt_return = VALUE bapiret2_t( ( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '040' ) ).

        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

          IF lr_gko_process IS BOUND.
            lr_gko_process->free( ).
          ENDIF.

          lt_return = lr_cx_gko_process->get_bapi_return( ).

      ENDTRY.

      INSERT LINES OF lt_return INTO TABLE lt_return_all[].

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

    lo_cockpit->build_failed( EXPORTING it_key    = VALUE #( FOR ls_keys IN keys ( ls_keys-acckey ) )
                                        it_return = lt_return_all
                              IMPORTING es_failed = DATA(lt_failed) ).

    failed   = CORRESPONDING #( DEEP lt_failed ).

  ENDMETHOD.


  METHOD estorno.

    DATA: lt_return      TYPE bapiret2_t,
          lt_return_all  TYPE bapiret2_t,
          lt_bapi_return TYPE bapiret2_t.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors,
          lt_docs   TYPE zcltm_gko_process_group=>ty_t_docs,
          lt_acckey TYPE zctgsd_acckey.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_cockpit_new IN LOCAL MODE
      ENTITY _CockpitHeader
      FIELDS ( acckey codstatus belnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    IF sy-subrc NE 0.
      " Nenhum registro encontrado para a chave informada.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '130' ) ).
    ENDIF.

    "Cria instancia
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

* ---------------------------------------------------------------------------
* Estorno de agrupamento
* ---------------------------------------------------------------------------
      IF <fs_key>-%param-estornoagrupamento EQ abap_true.

        lo_cockpit->estorno_agrupamento_ex( EXPORTING iv_estorno_miro    = <fs_key>-%param-estornomiro
                                                      iv_estorno_pedido  = <fs_key>-%param-estornopedido
                                                      it_cockpit         = CORRESPONDING #( lt_header_data )
                                            IMPORTING et_return          = lt_return
                                                      et_bapi_return     = lt_bapi_return ).

        INSERT LINES OF lt_return INTO TABLE lt_return_all.
        INSERT LINES OF lt_bapi_return INTO TABLE lt_return_all.
      ENDIF.

* ---------------------------------------------------------------------------
* Estorno da MIRO
* ---------------------------------------------------------------------------
      IF <fs_key>-%param-estornomiro EQ abap_true.

        lo_cockpit->estorno_miro( EXPORTING iv_estorno_pedido = <fs_key>-%param-estornopedido
                                            iv_acckey         = <fs_key>-acckey
                                  IMPORTING et_return         = lt_return ).

        INSERT LINES OF lt_return INTO TABLE lt_return_all.

      ENDIF.

* ---------------------------------------------------------------------------
* Estorno do pedido
* ---------------------------------------------------------------------------
      IF <fs_key>-%param-estornopedido EQ abap_true AND <fs_key>-%param-estornomiro NE abap_true.

        lo_cockpit->estorno_pedido( EXPORTING iv_acckey = <fs_key>-acckey
                                    IMPORTING et_return = lt_return ).

        INSERT LINES OF lt_return INTO TABLE lt_return_all.

      ENDIF.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

    lo_cockpit->build_failed( EXPORTING it_key    = VALUE #( FOR ls_keys IN keys ( ls_keys-acckey ) )
                                        it_return = lt_return_all
                              IMPORTING es_failed = DATA(lt_failed) ).

    failed   = CORRESPONDING #( DEEP lt_failed ).

  ENDMETHOD.


  METHOD evento_cte.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_cockpit_new IN LOCAL MODE
      ENTITY _CockpitHeader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    IF sy-subrc NE 0.
      " Nenhum registro encontrado para a chave informada.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '130' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Realiza evento CTE
* ---------------------------------------------------------------------------
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      FREE: lt_return.

      TRY.
          DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey    = <fs_key>-acckey
                                                        iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ).

          lr_gko_process->reject( <fs_key>-%param-motivorejeicao ).
          lr_gko_process->persist( ).
          lr_gko_process->free( ).

          " Processamento realizado. Verificar logs.
          lt_return = VALUE bapiret2_t( ( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '040' ) ).

        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

          IF lr_gko_process IS BOUND.
            lr_gko_process->free( ).
          ENDIF.

          lt_return = lr_cx_gko_process->get_bapi_return( ).

      ENDTRY.

      INSERT LINES OF lt_return INTO TABLE lt_return_all.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

    lo_cockpit->build_failed( EXPORTING it_key    = VALUE #( FOR ls_keys IN keys ( ls_keys-acckey ) )
                                        it_return = lt_return_all
                              IMPORTING es_failed = DATA(lt_failed) ).

    failed   = CORRESPONDING #( DEEP lt_failed ).

  ENDMETHOD.


*  METHOD agrupamento.
*
*    DATA: lt_return     TYPE bapiret2_t.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zc_tm_cockpit_new IN LOCAL MODE
*      ENTITY _CockpitHeader
*      FIELDS ( acckey )
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_header_data)
*      FAILED failed.
*
*    IF sy-subrc NE 0.
*      " Nenhum registro encontrado para a chave informada.
*      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '130' ) ).
*    ENDIF.
*
** ---------------------------------------------------------------------------
** Realiza agrupamento das faturas
** ---------------------------------------------------------------------------
*    IF lt_return IS INITIAL.
*
*      DATA(lo_agrupamento) = NEW zcltm_agrupar_fatura( ).
*
*      lo_agrupamento->agrupar_fatura( EXPORTING iv_stcd1           = ''
*                                                iv_vlr_total       = ''
*                                                iv_vlr_desconto    = ''
*                                                iv_fatura_trasnpo  = ''
*                                                iv_data_vencimento = '00000000'
*                                                it_acckey          = VALUE #( FOR ls_header_data IN lt_header_data
*                                                                            ( acckey = ls_header_data-acckey ) )
*                                      IMPORTING et_mensagens = lt_return ).
*    ENDIF.
*
** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
*    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).
*
*    lo_cockpit->build_reported( EXPORTING it_return   = lt_return
*                                IMPORTING es_reported = DATA(lt_reported) ).
*
*    reported = CORRESPONDING #( DEEP lt_reported ).
*
*    lo_cockpit->build_failed( EXPORTING it_key    = VALUE #( FOR ls_keys IN keys ( ls_keys-acckey ) )
*                                        it_return = lt_return
*                              IMPORTING es_failed = DATA(lt_failed) ).
*
*    failed   = CORRESPONDING #( DEEP lt_failed ).
*
*  ENDMETHOD.


  METHOD consultar_status.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_cockpit_new IN LOCAL MODE
      ENTITY _CockpitHeader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    IF sy-subrc NE 0.
      " Nenhum registro encontrado para a chave informada.
      lt_return = VALUE #( BASE lt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '130' ) ).
    ENDIF.

    DATA(lo_consultar) = NEW zcltm_check_doc_sefaz( ).

    LOOP AT lt_header_data ASSIGNING FIELD-SYMBOL(<fs_header_data>).

      lo_consultar->check_sefaz( EXPORTING iv_acckey    = <fs_header_data>-acckey
                                 IMPORTING et_mensagens = lt_return ).

      INSERT LINES OF lt_return INTO TABLE lt_return_all.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

    lo_cockpit->build_failed( EXPORTING it_key    = VALUE #( FOR ls_keys IN keys ( ls_keys-acckey ) )
                                        it_return = lt_return_all
                              IMPORTING es_failed = DATA(lt_failed) ).

    failed   = CORRESPONDING #( DEEP lt_failed ).

  ENDMETHOD.

  METHOD delete.
* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    DATA(lo_cockpit) = zcltm_cockpit_frete_new=>get_instance( ).

    lo_cockpit->delete( EXPORTING it_acckey = VALUE #( FOR ls_entities IN entities ( ls_entities-acckey ) )
                        IMPORTING et_return = DATA(lt_return) ).

    lo_cockpit->build_reported( EXPORTING it_return   = lt_return
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

    lo_cockpit->build_failed( EXPORTING it_key    = VALUE #( FOR ls_entities IN entities ( ls_entities-acckey ) )
                                        it_return = lt_return
                              IMPORTING es_failed = DATA(lt_failed) ).

    failed   = CORRESPONDING #( DEEP lt_failed ).


  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_cockpit_new IN LOCAL MODE
      ENTITY _CockpitHeader
      FIELDS ( acckey codstatus doctype )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED failed.

* ---------------------------------------------------------------------------
* Recupera os status disponíveis para elimintação
* ---------------------------------------------------------------------------
    SELECT DISTINCT guid, acao, codstatus_de, codstatus_para
        FROM zttm_pcockpit016
        FOR ALL ENTRIES IN @lt_header
        WHERE acao         EQ 'X' " Eliminação
          AND codstatus_de EQ @lt_header-codstatus
        INTO TABLE @DATA(lt_016).

    IF sy-subrc EQ 0.
      SORT lt_016 BY codstatus_de.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT lt_header INTO DATA(ls_header).

      READ TABLE lt_016 INTO DATA(ls_016) WITH KEY codstatus_de = ls_header-codstatus BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_016.
      ENDIF.

      result = VALUE #( BASE result

                      ( %tky                      = ls_header-%tky

*                        %action-agrupamento       = if_abap_behv=>fc-o-disabled     " Novo botão desenvolvido via Extension (Custom Action)

                        %action-evento_cte        = COND #( WHEN ls_header-doctype = 'CTE'
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %delete                   = COND #( WHEN ls_016-codstatus_de IS NOT INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled ) ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZC_TM_COCKPIT_NEW DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_ZC_TM_COCKPIT_NEW IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
