CLASS lcl_mdf DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS motorista FOR MODIFY
      IMPORTING keys FOR ACTION mdf~motorista.

    METHODS get_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR mdf RESULT result.

    METHODS verificar FOR MODIFY
      IMPORTING keys FOR ACTION mdf~verificar.

    METHODS enviar FOR MODIFY
      IMPORTING keys FOR ACTION mdf~enviar.

    METHODS cancelar FOR MODIFY
      IMPORTING keys FOR ACTION mdf~cancelar.

    METHODS encerrar FOR MODIFY
      IMPORTING keys FOR ACTION mdf~encerrar.

    METHODS determinarnotafiscal FOR DETERMINE ON SAVE
      IMPORTING keys FOR mdf~determinarnotafiscal.

    METHODS criarassociacoes FOR DETERMINE ON SAVE
      IMPORTING keys FOR mdf~criarassociacoes.

    METHODS criarrefmdfe FOR MODIFY
      IMPORTING keys FOR ACTION mdf~criarrefmdfe.

    METHODS criarmdfeusarof FOR MODIFY
      IMPORTING keys FOR ACTION mdf~criarmdfeusarof.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR mdf RESULT result.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR mdf~authoritycreate.

    METHODS precheck FOR PRECHECK
      IMPORTING keys FOR CREATE mdf.

ENDCLASS.

CLASS lcl_mdf IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
      FIELDS ( guid agrupador br_mdfenumber manual statuscode )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_mdf)
      FAILED failed.

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf BY \_complemento
        FIELDS ( id dhemi )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_complemento)
        FAILED failed.

    SORT lt_complemento BY id.

    " Autorização
    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_b
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-modificar ).
    IF lt_return IS NOT INITIAL.
      DATA(lv_aut) = abap_true.
      CLEAR: lt_return[].
    ENDIF.

    lt_return = zcltm_monitor_mdf_aut=>check_aut(       iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_c
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-eliminar ).
    IF lt_return IS NOT INITIAL.
      DATA(lv_aut_delete) = abap_true.
      CLEAR: lt_return[].
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT lt_mdf INTO DATA(ls_mdf).

      READ TABLE lt_complemento INTO DATA(ls_complemento) WITH KEY id = ls_mdf-guid BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_complemento.
      ENDIF.

      GET TIME STAMP FIELD DATA(lv_timestamp).
      DATA(lv_timestamp_diff) = lv_timestamp - ls_complemento-dhemi.

      result = VALUE #( BASE result

                      ( %tky                      = ls_mdf-%tky

                        %update                   = COND #( WHEN ls_mdf-statuscode NE '100'     " Autorizado
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        "%delete                   = if_abap_behv=>fc-o-enabled
                        %delete                   = COND #( WHEN lv_aut_delete IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled     " Autorizado
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        "%action-verificar         = if_abap_behv=>fc-o-enabled
                        %action-verificar         = COND #( WHEN lv_aut IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled     " Autorizado
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %action-enviar            = COND #( WHEN ls_mdf-statuscode NE '100'     " Autorizado
                                                             AND ls_mdf-statuscode NE '101'     " Cancelado
                                                             AND lv_aut            IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %action-cancelar          = COND #( WHEN ls_mdf-statuscode IS NOT INITIAL
                                                             AND ls_mdf-statuscode NE '132'     " Encerrado
                                                             AND lv_timestamp_diff < 1000000    " 24hrs
                                                             AND lv_aut            IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %action-encerrar          = COND #( WHEN ls_mdf-statuscode EQ '100'
                                                             AND lv_aut            IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %action-criarrefmdfe      = COND #( WHEN ls_mdf-statuscode EQ '101'
                                                              OR ls_mdf-statuscode EQ '132'
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %action-criarmdfeusarof   = if_abap_behv=>fc-o-enabled

                        %action-motorista         = COND #( WHEN ls_mdf-statuscode NE '132'     " Encerrado
                                                             AND lv_aut            IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )

                        %assoc-_municipio         = if_abap_behv=>fc-o-disabled

                        %assoc-_placa             = COND #( WHEN ls_mdf-statuscode NE '100'
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled ) ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD determinarnotafiscal.

    DATA: lt_return TYPE bapiret2_t.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf).

* ---------------------------------------------------------------------------
* Para registro criado manualmente, gerar um número de Nota Fiscal Temporária
* ---------------------------------------------------------------------------
    LOOP AT lt_mdf INTO DATA(ls_mdf).              "#EC CI_LOOP_INTO_WA

      IF ls_mdf-agrupador IS NOT INITIAL.
        DATA(lv_docnum)   = ls_mdf-agrupador.
        DATA(lv_manual)   = abap_false.
      ELSE.
        lv_docnum       = zcltm_mdf_events=>doc_mdfe_create( IMPORTING et_return = lt_return ).
        lv_manual       = abap_true.
      ENDIF.

      DATA(lv_modfrete) = COND #( WHEN ls_mdf-modfrete IS NOT INITIAL
                                  THEN ls_mdf-modfrete
                                  ELSE  '3' ).

      IF lt_return IS NOT INITIAL.
        lo_events->build_reported( EXPORTING it_return   = lt_return
                                   IMPORTING es_reported = DATA(lt_reported) ).

        reported = CORRESPONDING #( DEEP lt_reported ).
        RETURN.
      ENDIF.

* ---------------------------------------------------------------------------
* Update field
* ---------------------------------------------------------------------------
      MODIFY ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
           UPDATE FIELDS ( agrupador manual modfrete )
           WITH VALUE #( ( %tky          = ls_mdf-%tky
                           guid          = ls_mdf-guid
                           agrupador     = lv_docnum
                           manual        = lv_manual
                           modfrete      = lv_modfrete ) )
           REPORTED lt_reported
           FAILED DATA(lt_failed).

      reported = CORRESPONDING #( DEEP lt_reported ).

    ENDLOOP.

  ENDMETHOD.




  METHOD criarassociacoes.

    DATA: lt_return_all TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf).

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Cria associação automática - Complemento
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->determine_complemento( EXPORTING is_mdf     = CORRESPONDING #( ls_mdf )
                                      IMPORTING es_mdf_ide = DATA(ls_mdf_ide)
                                                et_return  = DATA(lt_return) ).

    INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

    lo_events->save_complemento( EXPORTING is_mdf_ide = ls_mdf_ide
                                 IMPORTING et_return  = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return_all
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD motorista.

    DATA: lt_return_all TYPE bapiret2_t.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf).

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
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

      lo_events->validate_motorista( EXPORTING is_motorista = ls_motorista
                                     IMPORTING et_return    = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

      IF ls_mdf-br_mdfenumber IS NOT INITIAL.
        lt_return[] = zcltm_mdf_events=>mdf_driver_change_background( EXPORTING iv_id         = ls_mdf-guid
                                                                                is_parameters = ls_keys-%param ).
      ENDIF.

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

      lo_events->add_motorista( EXPORTING is_motorista = ls_motorista
                                IMPORTING et_return    = lt_return ).

*      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return_all
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

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
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

      " Todas as validações realizadas com sucesso.
      lt_return_all[] = VALUE #( BASE lt_return_all ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '064' ) ).

    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return_all
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD enviar.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t,
          lv_statuscode TYPE /xnfe/statuscode.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Chama BAPI para envio da XML
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      lo_events->validate_all( EXPORTING iv_id     = ls_keys-%tky-guid
                                         iv_send   = abap_true
                               IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      IF lt_return IS INITIAL.
        DATA(lv_resend) = abap_false.
      ELSE.
        lv_resend = abap_true.
      ENDIF.

      lt_return[] = zcltm_mdf_events=>mdf_send_background( EXPORTING iv_id         = ls_keys-%tky-guid
                                                                     iv_resend     = lv_resend
                                                           IMPORTING ev_statuscode = lv_statuscode ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].

      lo_events->get_history( EXPORTING iv_id     = ls_keys-%tky-guid
                              IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return_all
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

*      IF line_exists( lt_return[ id = '/XNFE/APPMDFE' number = '429' ] ).
*        INSERT LINES OF lt_return[] INTO TABLE lt_return_all[].
*        CONTINUE.
*      ENDIF.

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
    lo_events->build_reported( EXPORTING it_return   = lt_return_all
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
    lo_events->build_reported( EXPORTING it_return   = lt_return_all
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD criarrefmdfe.

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
                                           IMPORTING et_return = DATA(lt_return) ).

    lo_events->format_message( EXPORTING iv_change_error_type   = abap_true
                                         iv_change_warning_type = abap_true
                               CHANGING  ct_return              = lt_return[] ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).


  ENDMETHOD.

  METHOD criarmdfeusarof.
    RETURN.
  ENDMETHOD.

  METHOD get_authorizations.
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE
        ENTITY mdf
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zcltm_auth_ztmbukrs=>bukrs_update( <fs_data>-companycode ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zcltm_auth_ztmbukrs=>bukrs_delete( <fs_data>-companycode ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky                    = <fs_data>-%tky
                      %update                 = lv_update
                      %delete                 = lv_delete
                      %assoc-_municipio       = lv_update
                      %assoc-_placa           = lv_update
                    )
             TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE
        ENTITY mdf
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zcltm_auth_ztmbukrs=>bukrs_create( <fs_data>-companycode ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-mdf.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-mdf.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-companycode = if_abap_behv=>mk-on )
          TO reported-mdf.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD precheck.

    " Autorização
    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_b
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-modificar ).

    IF lt_return IS INITIAL.
      RETURN.
    ENDIF.

    " Adiciona restrição às chaves selecionadas
    LOOP AT keys INTO DATA(ls_keys).

      APPEND VALUE #( %tky = ls_keys-%key ) TO failed-mdf.

      LOOP AT lt_return INTO DATA(ls_return).

        APPEND VALUE #( %tky        = ls_keys-%key

                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = ls_return-id
                                                              msgno = ls_return-number
                                                              attr1 = ls_return-message_v1
                                                              attr2 = ls_return-message_v2
                                                              attr3 = ls_return-message_v3
                                                              attr4 = ls_return-message_v4 ) ) )
          to reported-mdf.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
