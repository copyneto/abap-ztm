CLASS lcl_municipio DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR municipio RESULT result.

    METHODS refresh FOR DETERMINE ON MODIFY
      IMPORTING keys FOR municipio~refresh.

    METHODS refreshsave FOR DETERMINE ON SAVE
      IMPORTING keys FOR municipio~refreshsave.

ENDCLASS.

CLASS lcl_municipio IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        FIELDS ( guid agrupador br_mdfenumber manual )
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

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY municipio
        FIELDS ( guid accesskey ordemfrete br_notafiscal freightorder nfextrn )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_municipio)
        FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT lt_municipio INTO DATA(ls_municipio).  "#EC CI_LOOP_INTO_WA

      result = VALUE #( BASE result
                      ( %tky                         = ls_municipio-%tky

                        %update                      = COND #( WHEN ls_mdf-statuscode IS INITIAL
                                                               THEN if_abap_behv=>fc-o-enabled
                                                               ELSE if_abap_behv=>fc-o-disabled )

                        %delete                      = COND #( WHEN ls_mdf-statuscode IS INITIAL
                                                               THEN if_abap_behv=>fc-o-enabled
                                                               ELSE if_abap_behv=>fc-o-disabled )

                        %field-br_nftotalamount      = COND #( WHEN ls_municipio-nfextrn IS NOT INITIAL
                                                               THEN if_abap_behv=>fc-f-mandatory
                                                               ELSE if_abap_behv=>fc-f-read_only )

                        %field-salesdocumentcurrency = if_abap_behv=>fc-f-read_only

                        %field-headergrossweight     = COND #( WHEN ls_municipio-nfextrn IS NOT INITIAL
                                                               THEN if_abap_behv=>fc-f-mandatory
                                                               ELSE if_abap_behv=>fc-f-read_only )

                        %field-headernetweight       = if_abap_behv=>fc-f-read_only

                        %field-headerweightunit      = if_abap_behv=>fc-f-read_only

                        ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD refresh.
    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t,
          lv_statuscode TYPE /xnfe/statuscode,
          lv_nftot      TYPE zi_tm_mdf_municipio-br_nftotalamount.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf).

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Municipio
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_municipio).

* ---------------------------------------------------------------------------
* Chama BAPI para envio da XML
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      LOOP AT lt_municipio INTO DATA(ls_municipio).
        ADD ls_municipio-BR_NFTotalAmount TO lv_nftot.
      ENDLOOP.

      LOOP AT lt_mdf ASSIGNING FIELD-SYMBOL(<fs_mdf>).
        MODIFY ENTITIES OF zi_tm_mdf
        IN LOCAL MODE ENTITY mdf
        UPDATE FIELDS ( vlrcarga ) WITH VALUE #( (
                                    %tky          = <fs_mdf>-%tky
                                    guid          = <fs_mdf>-guid
                                    vlrcarga      = lv_nftot ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

        reported = CORRESPONDING #( DEEP lt_reported ).

        lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = lt_reported ).

        reported = CORRESPONDING #( DEEP lt_reported ).
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

  METHOD refreshsave.
    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t,
          lv_statuscode TYPE /xnfe/statuscode,
          lv_nftot      TYPE zi_tm_mdf_municipio-br_nftotalamount.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY mdf
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf).

    READ ENTITIES OF zi_tm_mdf IN LOCAL MODE ENTITY Municipio
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_municipio).

* ---------------------------------------------------------------------------
* Chama BAPI para envio da XML
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      LOOP AT lt_municipio INTO DATA(ls_municipio).
        ADD ls_municipio-BR_NFTotalAmount TO lv_nftot.
      ENDLOOP.

      LOOP AT lt_mdf ASSIGNING FIELD-SYMBOL(<fs_mdf>).
        MODIFY ENTITIES OF zi_tm_mdf
        IN LOCAL MODE ENTITY mdf
        UPDATE FIELDS ( vlrcarga ) WITH VALUE #( (
                                    %tky          = <fs_mdf>-%tky
                                    guid          = <fs_mdf>-guid
                                    vlrcarga      = lv_nftot ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

        reported = CORRESPONDING #( DEEP lt_reported ).

        lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = lt_reported ).

        reported = CORRESPONDING #( DEEP lt_reported ).
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
