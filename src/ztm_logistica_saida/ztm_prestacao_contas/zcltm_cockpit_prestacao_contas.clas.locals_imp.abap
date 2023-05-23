CLASS lcl_Cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Cockpit.

    METHODS read FOR READ
      IMPORTING keys FOR READ Cockpit RESULT result.

    METHODS rba_Execucao FOR READ
      IMPORTING keys_rba FOR READ Cockpit\_Execucao FULL result_requested RESULT result LINK association_links.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Cockpit RESULT result.

    METHODS definiremprocessamento FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~definiremprocessamento.

    METHODS definirconcluido FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~definirconcluido.

    METHODS novostatusevento FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~novostatusevento.

ENDCLASS.

CLASS lcl_Cockpit IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados do cockpit
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
        FROM zi_tm_cockpit_prestacao_contas
        FOR ALL ENTRIES IN @keys
        WHERE FreightOrderUUID = @keys-FreightOrderUUID
          AND FreightUnitUUID  = @keys-FreightUnitUUID
        INTO CORRESPONDING FIELDS OF TABLE @result. "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Retorna resultados (sem duplicata)
* ---------------------------------------------------------------------------
    SORT result BY FreightOrderUUID FreightUnitUUID.
    DELETE ADJACENT DUPLICATES FROM result COMPARING FreightOrderUUID FreightUnitUUID.

  ENDMETHOD.

  METHOD rba_Execucao.
    RETURN.
  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_cockpit_prestacao_contas IN LOCAL MODE ENTITY Cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_cockpit IN lt_cockpit

                    ( %tky                              = ls_cockpit-%tky

                      %action-definirEmProcessamento    = COND #( WHEN ls_cockpit-TranspOrdLifeCycleStatus NE zcltm_cockpit_prestacao=>gc_lc_status-em_processamento
                                                                   AND ls_cockpit-TranspOrdLifeCycleStatus NE zcltm_cockpit_prestacao=>gc_lc_status-concluido
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )

                      %action-definirConcluido          = COND #( WHEN ls_cockpit-TranspOrdLifeCycleStatus NE zcltm_cockpit_prestacao=>gc_lc_status-concluido
                                                                   AND ls_cockpit-StatusSinistro IS INITIAL
                                                                   AND ( ls_cockpit-StatusEntregue    IS NOT INITIAL OR
                                                                         ls_cockpit-StatusDevolvido   IS NOT INITIAL OR
                                                                         ls_cockpit-StatusSinistro    IS NOT INITIAL OR
                                                                         ls_cockpit-StatusColetado    IS NOT INITIAL OR
                                                                         ls_cockpit-StatusNaoColetado IS NOT INITIAL )
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )

                      %action-novoStatusEvento          = COND #( WHEN ls_cockpit-TranspOrdLifeCycleStatus NE zcltm_cockpit_prestacao=>gc_lc_status-concluido
                                                                  THEN if_abap_behv=>fc-o-enabled
                                                                  ELSE if_abap_behv=>fc-o-disabled )
                    ) ).

  ENDMETHOD.


  METHOD definirEmProcessamento.

    DATA: lt_return_all TYPE bapiret2_t.

    DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

    LOOP AT keys INTO DATA(ls_keys). "#EC CI_LOOP_INTO_WA

      lo_cockpit->call_change_order_status( EXPORTING iv_freightorderuuid = ls_keys-FreightOrderUUID
                                                      iv_status           = zcltm_cockpit_prestacao=>gc_lc_status-em_processamento
                                            IMPORTING et_return           = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD definirConcluido.

    DATA: lt_return_all TYPE bapiret2_t.

    DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

    LOOP AT keys INTO DATA(ls_keys). "#EC CI_LOOP_INTO_WA

      lo_cockpit->call_change_order_status( EXPORTING iv_freightorderuuid = ls_keys-FreightOrderUUID
                                                      iv_status           = zcltm_cockpit_prestacao=>gc_lc_status-concluido
                                            IMPORTING et_return           = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD novoStatusEvento.

    DATA: lt_return_all TYPE bapiret2_t.

    DATA(lo_cockpit) = NEW zcltm_cockpit_prestacao( ).

    LOOP AT keys INTO DATA(ls_keys). "#EC CI_LOOP_INTO_WA

      lo_cockpit->call_insert_unit_event_status( EXPORTING iv_freightorderuuid   = ls_keys-FreightOrderUUID
                                                           iv_freightunituuid    = ls_keys-FreightUnitUUID
                                                           iv_transpordeventcode = ls_keys-%param-transpordeventcode
                                                 IMPORTING et_return             = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_cockpit->build_reported( EXPORTING it_return   = lt_return_all
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZI_TM_COCKPIT_PRESTACAO_CO DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_ZI_TM_COCKPIT_PRESTACAO_CO IMPLEMENTATION.

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
