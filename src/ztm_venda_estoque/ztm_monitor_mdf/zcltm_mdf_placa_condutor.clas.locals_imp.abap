CLASS lcl_Condutor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Condutor RESULT result.

    METHODS validarCondutor FOR VALIDATE ON SAVE
      IMPORTING keys FOR Condutor~validarCondutor.

    METHODS determinarInfoCondutor FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Condutor~determinarInfoCondutor.

ENDCLASS.

CLASS lcl_Condutor IMPLEMENTATION.

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

  METHOD validarCondutor.

* ---------------------------------------------------------------------------
* Recupera informações da CDS atual
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Condutor
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_condutor)
        FAILED DATA(lt_failed).

    TRY.
        DATA(ls_condutor) = lt_condutor[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Valida campos informados
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->validate_condutor( EXPORTING is_condutor  = CORRESPONDING #( ls_condutor )
                                  IMPORTING et_return    = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD determinarInfoCondutor.

* ---------------------------------------------------------------------------
* Recupera informações da CDS atual
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Condutor
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_condutor).

    TRY.
        DATA(ls_condutor) = lt_condutor[ 1 ].
      CATCH cx_root.
    ENDTRY.
* ---------------------------------------------------------------------------
* Determina automaticamente algumas informações
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->determine_condutor( IMPORTING et_return   = DATA(lt_return)
                                   CHANGING  cs_condutor = ls_condutor-%data ).

* ---------------------------------------------------------------------------
* Atualiza campos
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Condutor
         UPDATE SET FIELDS
         WITH VALUE #( ( %key-Id        = ls_condutor-Id
                         %key-Placa     = ls_condutor-Placa
                         %key-Condutor  = ls_condutor-Condutor
                         Cpf            = ls_condutor-%data-Cpf
                         Nome           = ls_condutor-%data-Nome ) )
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
