CLASS lcl_Complemento DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Complemento RESULT result.

ENDCLASS.

CLASS lcl_Complemento IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        FIELDS ( Guid Agrupador BR_MDFeNumber Manual )
        WITH VALUE #( FOR ls_key IN keys ( %tky-Guid = ls_key-%tky-Id ) )
*        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf)
        FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_mdf IN lt_mdf

                    ( %tky              = ls_mdf-%tky
                      %update           = COND #( WHEN ls_mdf-StatusCode NE '100'
                                                  THEN if_abap_behv=>fc-o-enabled
                                                  ELSE if_abap_behv=>fc-o-disabled )
                                          ) ).
  ENDMETHOD.

ENDCLASS.
