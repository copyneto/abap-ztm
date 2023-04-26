CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES:
      ty_t_freight_order TYPE STANDARD TABLE OF /scmtms/tor_id WITH DEFAULT KEY,
      ty_t_nota_fiscal   TYPE STANDARD TABLE OF j_1bnfdoc-docnum WITH DEFAULT KEY.

    METHODS read FOR READ
      IMPORTING keys FOR READ cockpit RESULT result.

    METHODS enviarmdf FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~enviarmdf.
    METHODS verificar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~verificar.
    METHODS cancelar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~cancelar.
    METHODS encerrar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~encerrar.
    METHODS motorista FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~motorista.
    METHODS criarrefmdfe FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~criarrefmdfe.

    METHODS get_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.

ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD read.
    "Cria instancia
    DATA(lo_cockpit) = zcltm_monitor_mdf=>get_instance( ).
    result = CORRESPONDING #( lo_cockpit->build( iv_agrupar = abap_true ) ).
  ENDMETHOD.

  METHOD enviarmdf.

    DATA: lv_statuscode TYPE /xnfe/statuscode.

    DATA(lo_events) = NEW zcltm_mdf_events_manual( ).
* ---------------------------------------------------------------------------
* Recupera ID/OF
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    IF ls_keys-guid IS NOT INITIAL.

      lo_events->validate_all( EXPORTING iv_id     = ls_keys-guid
                                         iv_send   = abap_true
                               IMPORTING et_return = DATA(lt_return_all) ).

      IF NOT line_exists( lt_return_all[ type = 'E' ] ). "#EC CI_STDSEQ

        lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                                IMPORTING et_return = lt_return_all ).

        IF lt_return_all IS INITIAL.
          DATA(lv_resend) = abap_false.
        ELSE.
          lv_resend = abap_true.
        ENDIF.

        lt_return_all = zcltm_mdf_events=>mdf_send_background( EXPORTING iv_id         = ls_keys-guid
                                                                         iv_resend     = lv_resend
                                                               IMPORTING ev_statuscode = lv_statuscode ).

        IF NOT line_exists( lt_return_all[ type = 'E' ] ). "#EC CI_STDSEQ

          lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                                  IMPORTING et_return = DATA(lt_return) ).

          INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
        ENDIF.

      ENDIF.

    ELSE.

      " Filtra Ordens de Frete
      DATA(lt_dados_of) = keys.
      DATA(lt_of) = VALUE ty_t_freight_order( FOR ls_dados_of IN lt_dados_of WHERE ( guid IS INITIAL AND ordemfrete IS NOT INITIAL ) ( ls_dados_of-ordemfrete ) ).

      " Filtra Notas Fiscais
      lt_dados_of = keys.
      DATA(lt_nf) = VALUE ty_t_nota_fiscal( FOR ls_dados_of IN lt_dados_of WHERE ( guid IS INITIAL AND br_notafiscal IS NOT INITIAL ) ( ls_dados_of-br_notafiscal ) ).

      " Agrupa e cria MDF-e
      lo_events->use_fo_create_mdf( EXPORTING it_freight_order = lt_of
                                              it_nota_fiscal   = lt_nf
                                              iv_save          = abap_true
                                              iv_send          = abap_true
                                    IMPORTING et_return        = lt_return_all  ).

    ENDIF.

    lo_events->format_message( EXPORTING iv_change_error_type   = abap_true
                                         iv_change_warning_type = abap_true
                               CHANGING  ct_return              = lt_return_all[] ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    reported-cockpit = VALUE #( FOR ls_mensagem IN lt_return_all
                              ( %tky = keys[ sy-index ]-%tky

                                %msg = new_message(
                                                     id       = ls_mensagem-id
                                                     number   = ls_mensagem-number
                                                     severity = CONV #( ls_mensagem-type )
                                                     v1       = ls_mensagem-message_v1
                                                     v2       = ls_mensagem-message_v2
                                                     v3       = ls_mensagem-message_v3
                                                     v4       = ls_mensagem-message_v4  ) ) ).
  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    IF keys IS NOT INITIAL.

      SELECT mdf~guid,
             mdf~statuscode,
             complemento~dhemi
          FROM zi_tm_mdf AS mdf
          LEFT OUTER JOIN zi_tm_mdf_complemento AS complemento
            ON mdf~guid = complemento~id
          FOR ALL ENTRIES IN @keys
          WHERE guid = @keys-guid
          INTO TABLE @DATA(lt_mdf).

      IF sy-subrc EQ 0.
        SORT lt_mdf BY guid.
      ENDIF.
    ENDIF.

    LOOP AT keys REFERENCE INTO DATA(ls_keys).

      READ TABLE lt_mdf INTO DATA(ls_mdf) WITH KEY guid = ls_keys->guid BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_mdf.
      ENDIF.

      GET TIME STAMP FIELD DATA(lv_timestamp).
      DATA(lv_timestamp_diff) = lv_timestamp - ls_mdf-dhemi.

** ---------------------------------------------------------------------------
** Atualiza permissões de cada linha
** ---------------------------------------------------------------------------
      result = VALUE #( BASE result (   %tky  = ls_keys->%tky

                                        %action-verificar         = COND #( WHEN ls_mdf-guid IS NOT INITIAL
                                                                            THEN if_abap_behv=>fc-o-enabled
                                                                            ELSE if_abap_behv=>fc-o-disabled )

                                        %action-enviarmdf         = COND #( WHEN ls_mdf-statuscode NE '100'     " Autorizado
                                                                             AND ls_mdf-statuscode NE '101'     " Cancelado
                                                                            THEN if_abap_behv=>fc-o-enabled
                                                                            ELSE if_abap_behv=>fc-o-disabled )

                                        %action-cancelar          = COND #( WHEN ls_mdf-statuscode IS NOT INITIAL
                                                                             AND ls_mdf-statuscode NE '132'     " Encerrado
                                                                             AND lv_timestamp_diff < 1000000    " 24hrs
                                                                            THEN if_abap_behv=>fc-o-enabled
                                                                            ELSE if_abap_behv=>fc-o-disabled )

                                        %action-encerrar          = COND #( WHEN ls_mdf-statuscode EQ '100'
                                                                            THEN if_abap_behv=>fc-o-enabled
                                                                            ELSE if_abap_behv=>fc-o-disabled )

                                        %action-criarrefmdfe      = COND #( WHEN ls_mdf-statuscode EQ '101'
                                                                              OR ls_mdf-statuscode EQ '132'
                                                                            THEN if_abap_behv=>fc-o-enabled
                                                                            ELSE if_abap_behv=>fc-o-disabled )

                                        %action-motorista         = COND #( WHEN ls_mdf-guid IS NOT INITIAL
                                                                             AND ls_mdf-statuscode NE '132'     " Encerrado
                                                                            THEN if_abap_behv=>fc-o-enabled
                                                                            ELSE if_abap_behv=>fc-o-disabled )
                                        ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD verificar.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t,
          lv_statuscode TYPE /xnfe/statuscode.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Chama BAPI para envio da XML
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      " Verifica se alguma informação da ordem de frete foi atualizada
      lo_events->update_mdf_using_fo( EXPORTING iv_id     = ls_keys-%tky-guid
                                      IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK lt_return IS INITIAL.

      lo_events->validate_all( EXPORTING iv_id     = ls_keys-%tky-guid
                               IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E' ] ).  "#EC CI_STDSEQ

      " Todas as validações realizadas com sucesso.
      lt_return_all[] = VALUE #( BASE lt_return_all ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '064' ) ).

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    NEW zcltm_mdf_events( )->build_reported( EXPORTING it_return   = lt_return_all
                                             IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD cancelar.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t,
          lv_statuscode TYPE /xnfe/statuscode.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Chama BAPI para envio da XML
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      lt_return[] = zcltm_mdf_events=>mdf_cancel( EXPORTING iv_id         = ls_keys-%tky-guid
                                                  IMPORTING ev_statuscode = lv_statuscode ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].


    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    NEW zcltm_mdf_events( )->build_reported( EXPORTING it_return   = lt_return_all
                                             IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD encerrar.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t,
          lv_statuscode TYPE /xnfe/statuscode.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Chama BAPI para envio da XML
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      IF line_exists( lt_return[ id = '/XNFE/APPMDFE' number = '429' ] ).
        INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
        CONTINUE.
      ENDIF.

      lt_return[] = zcltm_mdf_events=>mdf_close( EXPORTING iv_id         = ls_keys-%tky-guid
                                                 IMPORTING ev_statuscode = lv_statuscode ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    NEW zcltm_mdf_events( )->build_reported( EXPORTING it_return   = lt_return_all
                                             IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD motorista.

    DATA: lt_return_all TYPE bapiret2_t.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    IF keys IS NOT INITIAL.

      SELECT guid,
             statuscode,
             br_mdfenumber
          FROM zi_tm_mdf
          FOR ALL ENTRIES IN @keys
          WHERE guid = @keys-guid
          INTO TABLE @DATA(lt_mdf).

      IF sy-subrc EQ 0.
        SORT lt_mdf BY guid.
      ENDIF.
    ENDIF.

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Chama BAPI e processa novo motorista informado
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      lo_events->determine_motorista( EXPORTING iv_id        = ls_keys-guid
                                                iv_motorista = ls_keys-%param-motorista
                                      IMPORTING es_motorista = DATA(ls_motorista)
                                                et_return    = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E' ] ).  "#EC CI_STDSEQ

      lo_events->validate_motorista( EXPORTING is_motorista = ls_motorista
                                     IMPORTING et_return    = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E' ] ).  "#EC CI_STDSEQ

      IF ls_mdf-br_mdfenumber IS NOT INITIAL.
        lt_return[] = zcltm_mdf_events=>mdf_driver_change_background( EXPORTING iv_id         = ls_mdf-guid
                                                                                is_parameters = ls_keys-%param ).
      ENDIF.

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E' ] ).  "#EC CI_STDSEQ

      lo_events->add_motorista( EXPORTING is_motorista = ls_motorista
                                IMPORTING et_return    = lt_return ).

      CHECK NOT line_exists( lt_return[ type = 'E' ] ).  "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    NEW zcltm_mdf_events( )->build_reported( EXPORTING it_return   = lt_return_all
                                             IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD criarrefmdfe.

    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_a
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-criar ).

    IF lt_return IS INITIAL.                             "#EC CI_STDSEQ
* ---------------------------------------------------------------------------
* Recupera ID
* ---------------------------------------------------------------------------
      TRY.
          DATA(ls_keys) = keys[ 1 ].
        CATCH cx_root.
      ENDTRY.
* ---------------------------------------------------------------------------
* Cria novo MDFe a partir da linha selecionada
* ---------------------------------------------------------------------------
      DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

      lo_events->use_exist_mdfe_to_new_mdfe( EXPORTING iv_id     = ls_keys-guid
                                             IMPORTING et_return = lt_return ).

      lo_events->format_message( EXPORTING iv_change_error_type   = abap_true
                                           iv_change_warning_type = abap_true
                                 CHANGING  ct_return              = lt_return[] ).

    ENDIF.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    NEW zcltm_mdf_events( )->build_reported( EXPORTING it_return   = lt_return
                                             IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).


  ENDMETHOD.

ENDCLASS.

CLASS lcl_zc_tm_mdf_cockpit DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zc_tm_mdf_cockpit IMPLEMENTATION.

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
