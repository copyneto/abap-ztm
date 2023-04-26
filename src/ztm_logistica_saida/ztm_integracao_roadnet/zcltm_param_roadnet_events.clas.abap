CLASS zcltm_param_roadnet_events DEFINITION INHERITING FROM cl_abap_behv
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_cds,
        param TYPE string VALUE 'PARAM',              " Parâmetros Roadnet
      END OF gc_cds.

    TYPES:
      ty_reported TYPE RESPONSE FOR REPORTED EARLY zi_tm_param_roadnet.


    "! Realiza processo de importação
    "! @parameter is_param | Parâmetros ROADNET
    "! @parameter et_return | Mensagens de retorno
    METHODS importar
      IMPORTING is_param  TYPE zi_tm_param_roadnet
                it_routes TYPE zctgtm_route_id OPTIONAL
      EXPORTING et_return TYPE bapiret2_t.

    "! Realiza processo de limpeza do histórico
    "! @parameter it_road_log | Parâmetros ROADNET
    "! @parameter et_return | Mensagens de retorno
    METHODS apagar_log
      IMPORTING it_road_log TYPE zctgtm_road_log
      EXPORTING et_return   TYPE bapiret2_t.

    "! Realiza processo de importação
    "! @parameter iv_centro | Centro
    "! @parameter iv_data | Data
    "! @parameter iv_data_ate | Data até
    "! @parameter iv_sessao | Sessão
    "! @parameter et_return | Mensagens de retorno
    METHODS custom_entity_importar
      IMPORTING iv_centro   TYPE werks_d
                iv_data     TYPE sydatum
                iv_data_ate TYPE sydatum OPTIONAL
                iv_sessao   TYPE zttm_road_sessio-id_session_roadnet
      EXPORTING et_return   TYPE bapiret2_t.

    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING it_return   TYPE bapiret2_t
      EXPORTING es_reported TYPE ty_reported.

    "! Ler as mensagens geradas pelo processamento
    "! @parameter p_task |Noma da task executada
    CLASS-METHODS setup_messages
      IMPORTING p_task TYPE clike.

    "! Formata as mensages de retorno
    "! @parameter iv_change_error_type | Muda o Tipo de mensagem 'E' para 'I'.
    "! @parameter iv_change_warning_type | Muda o Tipo de mensagem 'W' para 'I'.
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      IMPORTING iv_change_error_type   TYPE flag OPTIONAL
                iv_change_warning_type TYPE flag OPTIONAL
      CHANGING  ct_return              TYPE bapiret2_t .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
      "!Armazenamento das mensagens de processamento
      gt_return     TYPE STANDARD TABLE OF bapiret2,

      "!Flag para sincronizar o processamento da função de criação de ordens de produção
      gv_wait_async TYPE abap_bool.

ENDCLASS.



CLASS zcltm_param_roadnet_events IMPLEMENTATION.


  METHOD importar.

    FREE: et_return, gt_return, gv_wait_async.

*    CALL FUNCTION 'ZFMTM_PARAM_ROADNET_IMPORTAR'
*      STARTING NEW TASK 'PARAM_ROADNET_IMPORTAR'
*      CALLING setup_messages ON END OF TASK
*      EXPORTING
*        iv_centro = is_param-centro
*        iv_data   = is_param-session_data
*        iv_sessao = is_param-session_id.
*
*    WAIT UNTIL gv_wait_async = abap_true.
*    et_return = gt_return.

    CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
      EXPORTING
        werks          = is_param-centro
        dtsession      = is_param-session_data
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc = 0.
      CALL FUNCTION 'DEQUEUE_EZ_TM_ROADNET'
        EXPORTING
          werks     = is_param-centro
          dtsession = is_param-session_data.


      CALL FUNCTION 'ZFMTM_PARAM_ROADNET_IMPORTAR'
        STARTING NEW TASK 'PARAM_ROADNET_IMPORTAR'
        EXPORTING
          iv_centro = is_param-centro
          iv_data   = is_param-session_data
          iv_sessao = is_param-session_id
          it_routes = it_routes.

      et_return =  VALUE #(
        ( type = 'I'
          id = 'ZTM_ROADNET_SESSION'
          number = '017'
      ) ).

    ELSE.
      et_return =  VALUE #(
        ( type       = sy-msgty
          id         = sy-msgid
          number     = sy-msgno
          message_v1 = sy-msgv1
          message_v2 = sy-msgv2
          message_v3 = sy-msgv3
          message_v4 = sy-msgv4
      ) ).
    ENDIF.

    me->format_return( EXPORTING iv_change_warning_type = abap_true
                                 iv_change_error_type   = abap_true
                       CHANGING  ct_return              = et_return ).


  ENDMETHOD.


  METHOD apagar_log.

    FREE: et_return, gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_PARAM_ROADNET_APAGAR_LOG'
      STARTING NEW TASK 'PARAM_ROADNET_APAGAR_LOG'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        it_road_log = it_road_log.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

    me->format_return( EXPORTING iv_change_warning_type = abap_true
                                 iv_change_error_type   = abap_true
                       CHANGING  ct_return              = et_return ).

  ENDMETHOD.


  METHOD custom_entity_importar.

    FREE: et_return, gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_PARAM_ROADNET_IMPORTAR'
      STARTING NEW TASK 'PARAM_ROADNET_IMPORTAR'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_centro   = iv_centro
        iv_data     = iv_data
        iv_data_ate = iv_data_ate
        iv_sessao   = iv_sessao.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

    me->format_return( EXPORTING iv_change_warning_type = abap_true
                                 iv_change_error_type   = abap_true
                       CHANGING  ct_return              = et_return ).

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'PARAM_ROADNET_IMPORTAR'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_PARAM_ROADNET_IMPORTAR'
            IMPORTING
                et_messages = gt_return.

      WHEN 'PARAM_ROADNET_APAGAR_LOG'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_PARAM_ROADNET_APAGAR_LOG'
            IMPORTING
                et_return = gt_return.
    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD build_reported.

    DATA: lo_dataref            TYPE REF TO data.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-param.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-param.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-param.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = new_message( id       = ls_return-id
                                     number   = ls_return-number
                                     v1       = ls_return-message_v1
                                     v2       = ls_return-message_v2
                                     v3       = ls_return-message_v3
                                     v4       = ls_return-message_v4
                                     severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-param.
          es_reported-param[]         = VALUE #( BASE es_reported-param[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-param[]         = VALUE #( BASE es_reported-param[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E' AND iv_change_error_type IS NOT INITIAL
                                THEN 'I'
                                WHEN ls_return->type EQ 'W' AND iv_change_warning_type IS NOT INITIAL
                                THEN 'I'
                                ELSE ls_return->type ).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
