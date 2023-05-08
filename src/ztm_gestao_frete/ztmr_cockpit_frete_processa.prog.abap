*&---------------------------------------------------------------------*
*& Report ZTMR_COCKPIT_FRETE_PROCESSA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztmr_cockpit_frete_processa MESSAGE-ID ztm_gko.


* Variáveis
*-----------------------------------------------------------------------
DATA: gv_eventid                 TYPE tbtcm-eventid,
      gv_eventparm               TYPE tbtcm-eventparm,
      gv_external_program_active TYPE tbtcm-xpgactive,
      gv_jobcount                TYPE tbtcm-jobcount,
      gv_jobname                 TYPE tbtcm-jobname,
      gv_stepcount               TYPE tbtcm-stepcount.

* Estruturas e Tabelas internas
*-----------------------------------------------------------------------
DATA: ls_001    TYPE zttm_gkot001,
      lt_docs   TYPE zcltm_gko_process_group=>ty_t_docs,
      lt_errors TYPE zcxtm_gko=>ty_t_errors.
* BEGIN OF DELETE - JWSILVA - 31.03.2023
*      lt_008    TYPE TABLE OF zttm_gkot008.
* END OF DELETE - JWSILVA - 31.03.2023

DATA: gv_data_regra TYPE sy-datum.

DATA: gv_delta_time  TYPE  mcwmit-be_ae,
      gv_delta_unit  TYPE  mcwmit-lzeit,
      gv_delta_time2 TYPE  mcwmit-be_ae,
      gv_delta_unit2 TYPE  mcwmit-lzeit.

* Parâmetros de seleção
*-----------------------------------------------------------------------
SELECT-OPTIONS: s_bukrs  FOR ls_001-bukrs,
                s_branch FOR ls_001-branch,
                s_codsta FOR ls_001-codstatus,
                s_docger FOR ls_001-docger,
                s_cenar  FOR ls_001-cenario,
                s_acckey FOR ls_001-acckey,
                s_tcnpjc FOR ls_001-tom_cnpj_cpf,
                s_tom_ie FOR ls_001-tom_ie,
                s_tor_id FOR ls_001-tor_id.

START-OF-SELECTION.

  IF sy-batch IS INITIAL.
    "Só é possível a execução em background.
    MESSAGE s080 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Obtêm os dados do Job
  CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
    IMPORTING
      eventid                 = gv_eventid
      eventparm               = gv_eventparm
      external_program_active = gv_external_program_active
      jobcount                = gv_jobcount
      jobname                 = gv_jobname
      stepcount               = gv_stepcount
    EXCEPTIONS
      no_runtime_info         = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    RETURN.
  ENDIF.

  "Recupera o nome do programa sendo executado no job
  SELECT SINGLE
         tbtco~jobname,
         tbtco~jobcount,
         tbtcp~stepcount,
         tbtcp~progname
    FROM tbtco
    INNER JOIN tbtcp
      ON  tbtcp~jobname  = tbtco~jobname
      AND tbtcp~jobcount = tbtco~jobcount
    INTO @DATA(ls_job)
    WHERE tbtco~jobname   = @gv_jobname
      AND tbtco~jobcount  = @gv_jobcount
      AND tbtcp~stepcount = @gv_stepcount.

  IF sy-subrc NE 0.
    CLEAR ls_job.
  ENDIF.

  "Verifica se possui outro Job em execução
  SELECT COUNT(*)
    FROM tbtco
    INNER JOIN tbtcp
      ON  tbtcp~jobname  = tbtco~jobname
      AND tbtcp~jobcount = tbtco~jobcount
    WHERE tbtco~jobcount <> gv_jobcount
      AND tbtco~status   = 'R'
      AND tbtcp~progname = ls_job-progname.
  IF sy-subrc IS INITIAL.

    "Já existe um Job em execução.
    MESSAGE s081 DISPLAY LIKE 'E'.
    RETURN.

  ENDIF.

  DATA: gv_curto TYPE timestamp.
  GET TIME STAMP FIELD gv_curto.

  CONVERT TIME STAMP gv_curto TIME ZONE 'BRAZIL'
    INTO DATE DATA(gv_data)
         TIME DATA(gv_hora).

*  SELECT * FROM zgko_bloqueio
*    INTO TABLE @DATA(lt_zgko_bloqueio).
*
**Essa regra é para o cenário em que o bloqueio deva existir em um período de meses distintos.
*  IF sy-datum+6(2) < 5.
*    gv_data_regra = sy-datum - 6.
*  ELSE.
*    gv_data_regra = sy-datum.
*  ENDIF.
*
*  READ TABLE lt_zgko_bloqueio INTO DATA(wa_zgko_bloqueio) WITH KEY mes = gv_data_regra+4(2).
*  IF sy-subrc EQ 0 AND lv_data BETWEEN wa_zgko_bloqueio-data_ini AND wa_zgko_bloqueio-data_fim.
*
*    PERFORM verifica_bloqueio USING wa_zgko_bloqueio lv_data lv_hora.
*
*  ENDIF.

  SELECT acckey
       , codstatus
       , dtemi
       , hremi
       , bukrs_doc
       , belnr
       , gjahr
       , docger
    FROM zttm_gkot001
    INTO TABLE @DATA(lt_zttm_gkot001)
    WHERE acckey       IN @s_acckey
      AND codstatus    IN @s_codsta
      AND codstatus    NE @zcltm_gko_process=>gc_codstatus-aguardando_reagrupamento     " INSERT - JWSILVA - 31.03.2023
      AND codstatus    NE @zcltm_gko_process=>gc_codstatus-aguardando_aprovacao_wf      " INSERT - JWSILVA - 31.03.2023
      AND codstatus    NE @zcltm_gko_process=>gc_codstatus-aguardando_estorno_dff       " INSERT - JWSILVA - 31.03.2023
      AND bukrs        IN @s_bukrs
      AND branch       IN @s_branch
      AND docger       IN @s_docger
      AND cenario      IN @s_cenar
      AND tom_cnpj_cpf IN @s_tcnpjc
      AND tom_ie       IN @s_tom_ie
      AND tor_id       IN @s_tor_id.

  IF lt_zttm_gkot001 IS INITIAL.
    WRITE: / |-- Nenhum registro foi encontrado|.
    RETURN.
  ENDIF.

  SORT lt_zttm_gkot001 BY dtemi ASCENDING
                      hremi ASCENDING.

  WRITE: / |-- { lines( lt_zttm_gkot001 ) NUMBER = USER } registro(s) encontrado(s)|.

  LOOP AT lt_zttm_gkot001 ASSIGNING FIELD-SYMBOL(<fs_001>) WHERE codstatus <> zcltm_gko_process=>gc_codstatus-aguardando_estorno_agrupamento.

    GET TIME STAMP FIELD gv_curto.

    CONVERT TIME STAMP gv_curto TIME ZONE 'BRAZIL'
      INTO DATE gv_data
           TIME gv_hora.

*    READ TABLE lt_zgko_bloqueio INTO wa_zgko_bloqueio WITH KEY mes = gv_data_regra+4(2).
*    IF sy-subrc EQ 0 AND lv_data BETWEEN wa_zgko_bloqueio-data_ini AND wa_zgko_bloqueio-data_fim.
*
*      PERFORM verifica_bloqueio USING wa_zgko_bloqueio lv_data lv_hora.
*
*    ENDIF.

    WRITE: / |-- { gv_hora TIME = ISO } Ini chave: { <fs_001>-acckey }|.

* BEGIN OF DELETE - JWSILVA - 31.03.2023
*    DATA(ls_008) = VALUE zttm_gkot008( acckey = <fs_001>-acckey
*                                                credat = sy-datum
*                                                cretim = sy-uzeit
*                                                crenam = sy-uname    ).
*    INSERT zttm_gkot008 FROM ls_008.
*    IF sy-subrc IS NOT INITIAL.
*
*      COMMIT WORK.
*
*      WRITE: / |--- A chave de acesso já está sendo processada|.
*
*    ELSE.
*
*      COMMIT WORK AND WAIT.
* END OF DELETE - JWSILVA - 31.03.2023

    TRY.

*** Reprocessa erro de bloqueio
        DATA(go_gko_process) = NEW zcltm_gko_process( iv_acckey        = <fs_001>-acckey
                                                      iv_tpprocess     = zcltm_gko_process=>gc_tpprocess-automatico
                                                      iv_locked_in_tab = abap_true
                                                      iv_min_data_load = abap_false                              ).

* BEGIN OF DELETE - JWSILVA - 03.04.2023
*          DATA: lt_006     TYPE zcltm_gko_process=>ty_t_zgkot006,
*                wa_gkot006 TYPE zttm_gkot006.
*
*          go_gko_process->get_data( IMPORTING et_gko_logs = lt_006 ).
*          SORT lt_006 BY acckey
*                             counter DESCENDING.
*          wa_gkot006 =  lt_006[ acckey = <fs_001>-acckey ].
* END OF DELETE - JWSILVA - 03.04.2023

*          IF  ( (  <fs_001>-codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
*                OR <fs_001>-codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro_deb_post )
*                AND wa_gkot006-codigo = '024'  " Dados de avaliação p/o material ... bloqueados pelo usuário
*              )
*              OR
*              ( <fs_001>-codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_realizar_estorno_canc
*              ).
        go_gko_process->reprocess( ).
*          ELSE.
*            go_gko_process->process( ).
*          ENDIF.
        go_gko_process->persist( ).
        go_gko_process->free( ).

        COMMIT WORK AND WAIT.

        WRITE: / |--- Chave de acesso processada|.

      CATCH zcxtm_gko_process INTO DATA(lo_cx_gko_process).

        IF go_gko_process IS BOUND.
          go_gko_process->free( ).
        ENDIF.

        LOOP AT lo_cx_gko_process->get_bapi_return( ) ASSIGNING FIELD-SYMBOL(<fs_s_bapi_return>).
          WRITE: / |--- { <fs_s_bapi_return>-id } { <fs_s_bapi_return>-number } { <fs_s_bapi_return>-type } { <fs_s_bapi_return>-message }|.
        ENDLOOP.

    ENDTRY.
* BEGIN OF DELETE - JWSILVA - 31.03.2023
*
*      DELETE zttm_gkot008 FROM ls_008.
*
*      COMMIT WORK AND WAIT.
*
*    ENDIF.
* END OF DELETE - JWSILVA - 31.03.2023

    GET TIME STAMP FIELD gv_curto.

    CONVERT TIME STAMP gv_curto TIME ZONE 'BRAZIL'
      INTO DATE gv_data
           TIME gv_hora.

    WRITE: / |-- { gv_hora TIME = ISO } Fim chave: { <fs_001>-acckey }|.
    ULINE.

  ENDLOOP.

  LOOP AT lt_zttm_gkot001 ASSIGNING <fs_001> WHERE codstatus = zcltm_gko_process=>gc_codstatus-aguardando_estorno_agrupamento
                      GROUP BY ( bukrs_doc = <fs_001>-bukrs_doc
                                 belnr     = <fs_001>-belnr
                                 gjahr     = <fs_001>-gjahr     )
                      ASSIGNING FIELD-SYMBOL(<fs_zttm_gkot001_grp>).

    WRITE: / |-- Iniciando o estorno do agrupamento { <fs_001>-bukrs_doc }{ <fs_001>-belnr }{ <fs_001>-gjahr }|.

* BEGIN OF DELETE - JWSILVA - 31.03.2023
*    LOOP AT GROUP <fs_zttm_gkot001_grp> ASSIGNING FIELD-SYMBOL(<fs_zttm_gkot001_mbr>).
*
*      TRY.
*          ls_008 = VALUE zttm_gkot008( acckey = <fs_zttm_gkot001_mbr>-acckey
*                                       credat = sy-datum
*                                       cretim = sy-uzeit
*                                       crenam = sy-uname                 ).
*          INSERT zttm_gkot008 FROM ls_008.
*          IF sy-subrc IS INITIAL.
*
*            APPEND ls_008 TO lt_008.
*            COMMIT WORK AND WAIT.
*
*          ELSE.
*
*            COMMIT WORK.
*
*            "Chave de acesso & bloqueada pelo usuário &.
*            RAISE EXCEPTION TYPE zcxtm_gko_process
*              EXPORTING
*                textid   = zcxtm_gko_process=>gc_acckey_blocked
*                gv_msgv1 = CONV #( <fs_zttm_gkot001_mbr>-acckey ).
*          ENDIF.
*
*          APPEND NEW zcltm_gko_process( iv_acckey        = <fs_zttm_gkot001_mbr>-acckey
*                                        iv_tpprocess     = zcltm_gko_process=>gc_tpprocess-automatico
*                                        iv_locked_in_tab = abap_true                               ) TO lt_docs.
*        CATCH zcxtm_gko_process INTO lo_cx_gko_process.
*          APPEND lo_cx_gko_process TO lt_errors.
*      ENDTRY.
*
*    ENDLOOP.
* END OF DELETE - JWSILVA - 31.03.2023

    IF lt_errors IS INITIAL.

      "Realiza o estorno do agrupamento
      TRY.
          zcltm_gko_process_group=>reversal_invoice_grouping( lt_docs ).
        CATCH cx_root.
      ENDTRY.

      LOOP AT lt_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).

        TRY.
            <fs_s_doc>->persist( ).
          CATCH cx_root.
        ENDTRY.

        TRY.
            DATA(gv_reversal) = <fs_s_doc>->reversal_invoice( ).

            IF gv_reversal = abap_true.

              <fs_s_doc>->reversal_purchase_order( ).

            ENDIF.

            <fs_s_doc>->persist( ).
            <fs_s_doc>->free( ).

          CATCH zcxtm_gko_process INTO lo_cx_gko_process.

            <fs_s_doc>->free( ).

        ENDTRY.

      ENDLOOP.

      COMMIT WORK.

    ELSE.

      LOOP AT lt_docs ASSIGNING <fs_s_doc>.
        <fs_s_doc>->free( ).
      ENDLOOP.

      LOOP AT NEW zcxtm_gko( gt_errors = lt_errors )->get_bapi_return( ) ASSIGNING <fs_s_bapi_return>.
        WRITE: / |-- { <fs_s_bapi_return>-id } { <fs_s_bapi_return>-number } { <fs_s_bapi_return>-type } { <fs_s_bapi_return>-message }|.
      ENDLOOP.

    ENDIF.

* BEGIN OF DELETE - JWSILVA - 31.03.2023
*    IF lt_008 IS NOT INITIAL.
*      DELETE zttm_gkot008 FROM TABLE lt_008.
*      COMMIT WORK AND WAIT.
*    ENDIF.
*    FREE: lt_008.
* END OF DELETE - JWSILVA - 31.03.2023

    FREE: lt_docs, lt_errors.

    WRITE: / |-- Fim do estorno do agrupamento { <fs_001>-bukrs_doc }{ <fs_001>-belnr }{ <fs_001>-gjahr }|.

  ENDLOOP.

**&---------------------------------------------------------------------*
**&      Form  VERIFICA_BLOQUEIO
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
**      -->P_WA_ZGKO_BLOQUEIO  text
**      -->P_LV_DATA  text
**      -->P_LV_HORA  text
**----------------------------------------------------------------------*
*FORM verifica_bloqueio  USING    u_wa_zgko_bloqueio TYPE zgko_bloqueio
*                                 u_lv_data
*                                 u_lv_hora.
*
*  CALL FUNCTION 'L_MC_TIME_DIFFERENCE'
*    EXPORTING
*      date_from       = u_wa_zgko_bloqueio-data_ini
*      date_to         = u_wa_zgko_bloqueio-data_fim
*      time_from       = u_wa_zgko_bloqueio-hora_ini
*      time_to         = u_wa_zgko_bloqueio-hora_fim
*    IMPORTING
*      delta_time      = gv_delta_time
*      delta_unit      = gv_delta_unit
*    EXCEPTIONS
*      from_greater_to = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
**   Implement suitable error handling here
*  ENDIF.
*
*  CALL FUNCTION 'L_MC_TIME_DIFFERENCE'
*    EXPORTING
*      date_from       = wa_zgko_bloqueio-data_ini
*      date_to         = u_lv_data
*      time_from       = u_wa_zgko_bloqueio-hora_ini
*      time_to         = u_lv_hora
*    IMPORTING
*      delta_time      = gv_delta_time2
*      delta_unit      = gv_delta_unit2
*    EXCEPTIONS
*      from_greater_to = 1
*      OTHERS          = 2.
*  IF sy-subrc <> 0.
**   Implement suitable error handling here
*  ENDIF.
*
*  IF gv_delta_time2 > 0.
*    IF gv_delta_time2 <= gv_delta_time.
*      MESSAGE s097 DISPLAY LIKE 'E'.
*      LEAVE PROGRAM.
*    ENDIF.
*  ENDIF.
*ENDFORM.
