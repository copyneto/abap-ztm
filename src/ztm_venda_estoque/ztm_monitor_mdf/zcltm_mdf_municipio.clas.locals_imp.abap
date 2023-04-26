CLASS lcl_municipio DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Municipio RESULT result.

ENDCLASS.

CLASS lcl_municipio IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        FIELDS ( Guid Agrupador BR_MDFeNumber Manual )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf)
        FAILED failed.

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].
      CATCH cx_root.
    ENDTRY.

*    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf by \_Municipio
*        FIELDS ( Guid AccessKey OrdemFrete BR_NotaFiscal FreightOrder NfExtrn )
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_municipio)
*        FAILED failed.

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Municipio
        FIELDS ( Guid AccessKey OrdemFrete BR_NotaFiscal FreightOrder NfExtrn )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_municipio)
        FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT lt_municipio INTO DATA(ls_municipio). "#EC CI_LOOP_INTO_WA

      result = VALUE #( BASE result
                      ( %tky                         = ls_municipio-%tky

                        %update                      = COND #( WHEN ls_mdf-StatusCode IS INITIAL
                                                               THEN if_abap_behv=>fc-o-enabled
                                                               ELSE if_abap_behv=>fc-o-disabled )

                        %delete                      = COND #( WHEN ls_mdf-StatusCode IS INITIAL
                                                               THEN if_abap_behv=>fc-o-enabled
                                                               ELSE if_abap_behv=>fc-o-disabled )

                        %field-BR_NFTotalAmount      = COND #( WHEN ls_municipio-NfExtrn IS NOT INITIAL
                                                               THEN if_abap_behv=>fc-f-mandatory
                                                               ELSE if_abap_behv=>fc-f-read_only )

                        %field-SalesDocumentCurrency = if_abap_behv=>fc-f-read_only

                        %field-HeaderGrossWeight     = COND #( WHEN ls_municipio-NfExtrn IS NOT INITIAL
                                                               THEN if_abap_behv=>fc-f-mandatory
                                                               ELSE if_abap_behv=>fc-f-read_only )

                        %field-HeaderNetWeight       = if_abap_behv=>fc-f-read_only

                        %field-HeaderWeightUnit      = if_abap_behv=>fc-f-read_only

                        ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
