CLASS lcl_param DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK _Roadnet.

    METHODS read FOR READ
      IMPORTING keys FOR READ _Roadnet RESULT result.

    METHODS rba_Entrega FOR READ
      IMPORTING keys_rba FOR READ _Roadnet\_Entrega FULL result_requested RESULT result LINK association_links.

    METHODS rba_CrossDocking FOR READ
      IMPORTING keys_rba FOR READ _Roadnet\_CrossDocking FULL result_requested RESULT result LINK association_links.

    METHODS rba_Redespacho FOR READ
      IMPORTING keys_rba FOR READ _Roadnet\_Redespacho FULL result_requested RESULT result LINK association_links.

    METHODS rba_Log FOR READ
      IMPORTING keys_rba FOR READ _Roadnet\_Log FULL result_requested RESULT result LINK association_links.

*    METHODS importar FOR MODIFY
*      IMPORTING keys FOR ACTION _Roadnet~importar.

*    METHODS get_features FOR FEATURES
*      IMPORTING keys REQUEST requested_features FOR _Roadnet RESULT result.

ENDCLASS.

CLASS lcl_param IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

    IF keys[] IS NOT INITIAL.

      SELECT *
          FROM zttm_road_sessio
          FOR ALL ENTRIES IN @keys
          WHERE werks     = @keys-%key-centro
            AND dtsession = @keys-%key-session_data
          INTO TABLE @DATA(lt_session).

      IF sy-subrc NE 0.
        FREE lt_session.
      ENDIF.
    ENDIF.

    result[] = VALUE #( FOR ls_session IN lt_session (
                        %tky-centro       = ls_session-werks
                        %tky-session_data = ls_session-dtsession
                        %key-centro       = ls_session-werks
                        %key-session_data = ls_session-dtsession
                        centro            = ls_session-werks
                        session_data      = ls_session-dtsession
                        session_id        = ls_session-id_session_roadnet ) ).

    SORT result BY centro session_data.

  ENDMETHOD.

*  METHOD importar.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zc_tm_param_roadnet_new IN LOCAL MODE ENTITY _Roadnet
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_param)
*      FAILED failed.
*
*    TRY.
*        DATA(ls_param) = lt_param[ 1 ].
*      CATCH cx_root.
*    ENDTRY.
*
** ---------------------------------------------------------------------------
** Realiza processo de importação
** ---------------------------------------------------------------------------
*    DATA(lo_events) = NEW zcltm_param_roadnet_events( ).
*
*    lo_events->importar( EXPORTING is_param  = CORRESPONDING #( ls_param )
*                         IMPORTING et_return = DATA(lt_return) ).
*
** ---------------------------------------------------------------------------
** Retorna mensagens
** ---------------------------------------------------------------------------
*    lo_events->build_reported( EXPORTING it_return   = lt_return
*                               IMPORTING es_reported = DATA(lt_reported) ).
*
*    reported = CORRESPONDING #( DEEP lt_reported ).
*
*  ENDMETHOD.

*  METHOD get_features.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zc_tm_param_roadnet_new IN LOCAL MODE ENTITY _Roadnet
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_param)
*      FAILED failed.
*
** ---------------------------------------------------------------------------
** Atualiza permissões de cada linha
** ---------------------------------------------------------------------------
*    result = VALUE #( BASE result FOR ls_param IN lt_param
*
*                    ( %tky                = ls_param-%tky
*
*                      %action-importar    = COND #( WHEN ls_param-session_id IS NOT INITIAL
*                                                    THEN if_abap_behv=>fc-o-enabled
*                                                    ELSE if_abap_behv=>fc-o-disabled )
*    ) ).
*
*  ENDMETHOD.

  METHOD rba_Entrega.
    RETURN.
  ENDMETHOD.

  METHOD rba_CrossDocking.
    RETURN.
  ENDMETHOD.

  METHOD rba_Redespacho.
    RETURN.
  ENDMETHOD.

  METHOD rba_log.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ZC_TM_PARAM_ROADNET_NEW DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_ZC_TM_PARAM_ROADNET_NEW IMPLEMENTATION.

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
