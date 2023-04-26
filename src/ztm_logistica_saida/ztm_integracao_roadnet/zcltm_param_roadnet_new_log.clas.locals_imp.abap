CLASS lcl_Log DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ _Log RESULT result.

    METHODS rba_Roadnet FOR READ
      IMPORTING keys_rba FOR READ _Log\_Roadnet FULL result_requested RESULT result LINK association_links.

    METHODS apagar_log FOR MODIFY
      IMPORTING keys FOR ACTION _Log~apagar_log.

ENDCLASS.

CLASS lcl_Log IMPLEMENTATION.

  METHOD read.

    IF keys[] IS NOT INITIAL.

      SELECT *
          FROM zttm_road_log
          FOR ALL ENTRIES IN @keys
          WHERE werks      = @keys-%key-centro
            AND dtsession  = @keys-%key-session_data
            AND session_id = @keys-%key-session_id
            AND line       = @keys-%key-line
          INTO TABLE @DATA(lt_log).

      IF sy-subrc NE 0.
        FREE lt_log.
      ENDIF.
    ENDIF.

    result[] = VALUE #( FOR ls_log IN lt_log (
                        %tky-centro           = ls_log-werks
                        %tky-session_data     = ls_log-dtsession
                        %tky-session_id       = ls_log-session_id
                        %tky-line             = ls_log-line

                        %key-centro           = ls_log-werks
                        %key-session_data     = ls_log-dtsession
                        %key-session_id       = ls_log-session_id
                        %key-line             = ls_log-line

                        centro                = ls_log-werks
                        session_data          = ls_log-dtsession
                        session_id            = ls_log-session_id
                        line                  = ls_log-line
                        route_id              = ls_log-route_id
                        msgty                 = ls_log-msgty
                        msgid                 = ls_log-msgid
                        msgno                 = ls_log-msgno
                        msgv1                 = ls_log-msgv1
                        msgv2                 = ls_log-msgv2
                        msgv3                 = ls_log-msgv3
                        msgv4                 = ls_log-msgv4
                        message               = ls_log-message
                        created_by            = ls_log-created_by
                        created_at            = ls_log-created_at
                        last_changed_by       = ls_log-last_changed_by
                        last_changed_at       = ls_log-last_changed_at
                        local_last_changed_at = ls_log-local_last_changed_at ) ).

    SORT result BY centro session_data session_id line.
  ENDMETHOD.

  METHOD rba_Roadnet.
    RETURN.
  ENDMETHOD.

  METHOD apagar_log.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_param_roadnet_new IN LOCAL MODE ENTITY _Log
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_log)
      FAILED failed.

      DATA(lt_road_log) = VALUE zctgtm_road_log( for ls_log IN lt_log (
                                                  werks                     = ls_log-centro
                                                  dtsession                 = ls_log-session_data
                                                  session_id                = ls_log-session_id
                                                  line                      = ls_log-line
                                                  route_id                  = ls_log-route_id
                                                  msgty                     = ls_log-msgty
                                                  msgid                     = ls_log-msgid
                                                  msgno                     = ls_log-msgno
                                                  msgv1                     = ls_log-msgv1
                                                  msgv2                     = ls_log-msgv2
                                                  msgv3                     = ls_log-msgv3
                                                  msgv4                     = ls_log-msgv4
                                                  message                   = ls_log-message
                                                  created_by                = ls_log-created_by
                                                  created_at                = ls_log-created_at
                                                  last_changed_by           = ls_log-last_changed_by
                                                  last_changed_at           = ls_log-last_changed_at
                                                  local_last_changed_at     = ls_log-local_last_changed_at ) ).

* ---------------------------------------------------------------------------
* Realiza processo de importação
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_param_roadnet_events( ).

    lo_events->apagar_log( EXPORTING it_road_log = lt_road_log
                           IMPORTING et_return   = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------

    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported-_log = CORRESPONDING #( DEEP lt_reported-param ).

  ENDMETHOD.

ENDCLASS.
