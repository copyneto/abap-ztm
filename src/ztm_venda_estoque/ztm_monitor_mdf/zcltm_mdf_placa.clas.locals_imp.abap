CLASS lcl_Placa DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Placa RESULT result.

    METHODS validarplaca FOR VALIDATE ON SAVE
      IMPORTING keys FOR placa~validarplaca.

    METHODS validarproprietario FOR VALIDATE ON SAVE
      IMPORTING keys FOR placa~validarproprietario.

    METHODS determinarinfoplaca FOR DETERMINE ON MODIFY
      IMPORTING keys FOR placa~determinarinfoplaca.

ENDCLASS.

CLASS lcl_Placa IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        FIELDS ( Guid Agrupador BR_MDFeNumber Manual StatusCode )
        WITH VALUE #( FOR ls_keys IN keys ( Guid = ls_keys-Id ) )
        RESULT DATA(lt_mdf)
        FAILED failed.

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Placa
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_placa)
        FAILED failed.

    TRY.
        DATA(ls_placa) = lt_placa[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys

                    ( %tky                  = ls_keys-%tky

                      %update               = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )

                      %delete               = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled )

                      %assoc-_Condutor      = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                     THEN if_abap_behv=>fc-o-enabled
                                                     ELSE if_abap_behv=>fc-o-disabled )

                      %assoc-_ValePedagio   = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE if_abap_behv=>fc-o-disabled )
                      ) ).

  ENDMETHOD.



  METHOD validarPlaca.

*    BREAK-POINT.

* ---------------------------------------------------------------------------
* Recupera informações da CDS atual
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf BY \_Placa
         ALL FIELDS
         WITH VALUE #( FOR ls_keys IN keys ( Guid = ls_keys-Id ) )
         RESULT DATA(lt_placa)
         FAILED DATA(lt_failed).

* ---------------------------------------------------------------------------
* Valida campos informados
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->validate_placa( EXPORTING it_placa  = CORRESPONDING #( lt_placa )
                               IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD validarProprietario.

* ---------------------------------------------------------------------------
* Recupera informações da CDS atual
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Placa
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_placa)
        FAILED DATA(lt_failed).

    TRY.
        DATA(ls_placa) = lt_placa[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Valida campos informados
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->validate_proprietario( EXPORTING is_placa  = CORRESPONDING #( ls_placa )
                                      IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD determinarInfoPlaca.

* ---------------------------------------------------------------------------
* Recupera informações da CDS atual
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Placa
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_placa).

    TRY.
        DATA(ls_placa) = lt_placa[ 1 ].
      CATCH cx_root.
    ENDTRY.
* ---------------------------------------------------------------------------
* Determina automaticamente algumas informações
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->determine_placa( IMPORTING et_return = DATA(lt_return)
                                CHANGING  cs_placa  = ls_placa-%data ).

* ---------------------------------------------------------------------------
* Atualiza campos
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Placa
         UPDATE FIELDS ( Renavam
                         Tara
                         CapKg
                         CapM3
                         TpRod
                         TpCar
                         Uf
                         Reboque

                         cpf
                         cnpj
                         rntrc
                         Nome
                         ie
                         UfProp
                         TpProp )

         WITH VALUE #( ( %key-Id        = ls_placa-Id
                         %key-Placa     = ls_placa-Placa

                         Renavam        = ls_placa-%data-Renavam
                         Tara           = ls_placa-%data-Tara
                         CapKg          = ls_placa-%data-CapKg
                         CapM3          = ls_placa-%data-CapM3
                         TpRod          = ls_placa-%data-TpRod
                         TpCar          = ls_placa-%data-TpCar
                         Uf             = ls_placa-%data-Uf
                         Reboque        = ls_placa-%data-Reboque

                         cpf            = ls_placa-%data-cpf
                         cnpj           = ls_placa-%data-cnpj
                         rntrc          = ls_placa-%data-rntrc
                         Nome           = ls_placa-%data-Nome
                         ie             = ls_placa-%data-ie
                         UfProp         = ls_placa-%data-UfProp
                         TpProp         = ls_placa-%data-TpProp ) )
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
