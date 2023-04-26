CLASS lcl_ValePedagio DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ValePedagio RESULT result.

    METHODS validarvalepedagio FOR VALIDATE ON SAVE
      IMPORTING keys FOR valepedagio~validarvalepedagio.

    METHODS determinarinfovalepedagio FOR DETERMINE ON MODIFY
      IMPORTING keys FOR valepedagio~determinarinfovalepedagio.


ENDCLASS.

CLASS lcl_ValePedagio IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        FIELDS ( Guid Agrupador BR_MDFeNumber Manual StatusCode )
        WITH VALUE #( FOR ls_keys IN keys ( Guid = ls_keys-Id ) )
        RESULT DATA(lt_mdf)
        FAILED failed.

    DATA(ls_mdf) = lt_mdf[ 1 ].

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys

                    ( %tky              = ls_keys-%tky

                      %update           = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  ELSE if_abap_behv=>fc-o-disabled )

                      %delete           = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  ELSE if_abap_behv=>fc-o-disabled )
                      ) ).

  ENDMETHOD.


  METHOD validarValePedagio.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY ValePedagio
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_vale).

    TRY.
        DATA(ls_vale) = lt_vale[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Valida campos informados
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->validate_vale_pedagio( EXPORTING is_vale  = CORRESPONDING #( ls_vale )
                                      IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD determinarInfoValePedagio.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY ValePedagio
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_vale).

    TRY.
        DATA(ls_vale) = lt_vale[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Valida campos informados
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->determine_vale_pedagio( IMPORTING et_return = DATA(lt_return)
                                       CHANGING  cs_vale   = ls_vale-%data ).

* ---------------------------------------------------------------------------
* Atualiza campos
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY ValePedagio
         UPDATE SET FIELDS
         WITH VALUE #( ( %key-Id        = ls_vale-Id
                         %key-Placa     = ls_vale-Placa
                         %key-NCompra   = ls_vale-NCompra
                         CnpjForn       = ls_vale-%data-CnpjForn
                         CnpjPg         = ls_vale-%data-CnpjPg
                         CpfPg          = ls_vale-%data-CpfPg
                         ValorValePed   = ls_vale-%data-ValorValePed ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

    reported = CORRESPONDING #( DEEP lt_reported ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = lt_reported ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

ENDCLASS.
