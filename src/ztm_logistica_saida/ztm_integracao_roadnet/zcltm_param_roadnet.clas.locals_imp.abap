CLASS lcl_parametros DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR param RESULT result.

    METHODS importar FOR MODIFY
      IMPORTING keys FOR ACTION param~importar.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR param RESULT result.

ENDCLASS.

CLASS lcl_parametros IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD importar.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_param_roadnet IN LOCAL MODE ENTITY param
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_param)
      FAILED failed.

    TRY.
        DATA(ls_param) = lt_param[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza processo de importação
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_param_roadnet_events( ).

    lo_events->importar( EXPORTING is_param  = CORRESPONDING #( ls_param )
                         IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_param_roadnet IN LOCAL MODE ENTITY param
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_param)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( BASE result FOR ls_param IN lt_param

                    ( %tky                = ls_param-%tky

                      %action-importar    = COND #( WHEN ls_param-session_id IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    ELSE if_abap_behv=>fc-o-disabled )
    ) ).

  ENDMETHOD.


ENDCLASS.
