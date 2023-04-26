CLASS lcl_CrossDocking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ _CrossDocking RESULT result.

    METHODS rba_Roadnet FOR READ
      IMPORTING keys_rba FOR READ _CrossDocking\_Roadnet FULL result_requested RESULT result LINK association_links.

    METHODS importar FOR MODIFY
      IMPORTING keys FOR ACTION _CrossDocking~importar_cros.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _CrossDocking RESULT result.

ENDCLASS.

CLASS lcl_CrossDocking IMPLEMENTATION.

  METHOD read.

    IF keys[] IS NOT INITIAL.

      SELECT *
          FROM zttm_road_item
          FOR ALL ENTRIES IN @keys
          WHERE werks      = @keys-%key-centro
            AND dtsession  = @keys-%key-session_data
            and session_id = @keys-%key-session_id
            and route_id   = @keys-%key-route_id
          INTO TABLE @DATA(lt_item).

      IF sy-subrc NE 0.
        FREE lt_item.
      ENDIF.
    ENDIF.

    result[] = VALUE #( FOR ls_session IN lt_item (
                        %tky-centro           = ls_session-werks
                        %tky-session_data     = ls_session-dtsession
                        %tky-session_id       = ls_session-session_id
                        %tky-route_id         = ls_session-route_id

                        %key-centro           = ls_session-werks
                        %key-session_data     = ls_session-dtsession
                        %key-session_id       = ls_session-session_id
                        %key-route_id         = ls_session-route_id

                        centro                = ls_session-werks
                        session_data          = ls_session-dtsession
                        session_id            = ls_session-session_id
                        route_id              = ls_session-route_id
                        description           = ls_session-description
                        freightorder          = ls_session-freight_order
                        created_by            = ls_session-created_by
                        created_at            = ls_session-created_at
                        last_changed_by       = ls_session-last_changed_by
                        last_changed_at       = ls_session-last_changed_at
                        local_last_changed_at = ls_session-local_last_changed_at ) ).

    SORT result BY centro session_data session_id route_id.

  ENDMETHOD.

  METHOD rba_Roadnet.
    RETURN.
  ENDMETHOD.

  METHOD importar.

* ---------------------------------------------------------------------------
* Recupera as chaves
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_param)  = VALUE zi_tm_param_roadnet( centro       = keys[ 1 ]-centro
                                                     session_data = keys[ 1 ]-session_data
                                                     session_id   = keys[ 1 ]-session_id ).

        DATA(lt_routes) = VALUE zctgtm_route_id( FOR ls_keys IN keys ( ls_keys-route_id ) ).
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza processo de importação
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_param_roadnet_events( ).

    lo_events->importar( EXPORTING is_param  = ls_param
                                   it_routes = lt_routes
                         IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------

    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported-_crossdocking = CORRESPONDING #( DEEP lt_reported-param  ).

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zc_tm_param_roadnet_new IN LOCAL MODE ENTITY _CrossDocking
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( BASE result FOR ls_item IN lt_item

                    ( %tky                  = ls_item-%tky

                      %action-importar_cros = COND #( WHEN ls_item-FreightOrder IS INITIAL
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )
    ) ).

  ENDMETHOD.

ENDCLASS.
