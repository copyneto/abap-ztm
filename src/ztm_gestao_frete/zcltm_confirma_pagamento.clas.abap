CLASS zcltm_confirma_pagamento DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS execute
      IMPORTING
        !it_zttm_gkot001     TYPE zctgtm_gkot001
        !iv_atualiza         TYPE char1 OPTIONAL
      RETURNING
        VALUE(rt_docs_pagos) TYPE zctgtm_gkot001 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_confirma_pagamento IMPLEMENTATION.


  METHOD execute.

    DATA:
      lr_hkont   TYPE RANGE OF hkont,
      lt_001_key TYPE zctgtm_gkot001.

    CHECK NOT it_zttm_gkot001[] IS INITIAL.


*    "Verificar compensação de Documento
*    READ TABLE it_ausz2 ASSIGNING FIELD-SYMBOL(<fs_ausz2>) INDEX 1.
*    CHECK sy-subrc = 0.
*
*    CHECK NOT <fs_ausz2>-augbl IS INITIAL.
*    CHECK NOT <fs_ausz2>-augdt IS INITIAL.


    SELECT * INTO TABLE @DATA(lt_bsak)
      FROM bsak_view
      FOR ALL ENTRIES IN @it_zttm_gkot001
      WHERE bukrs =  @it_zttm_gkot001-bukrs
        AND belnr =  @it_zttm_gkot001-belnr
        AND gjahr =  @it_zttm_gkot001-gjahr
        AND augbl <> @space.

    "Selecionar contas bancarias
    SELECT
        bukrs,
        hkont
      FROM t012k
      INTO TABLE @DATA(lt_t012k)
      FOR ALL ENTRIES IN @it_zttm_gkot001
      WHERE bukrs EQ @it_zttm_gkot001-bukrs.

    SORT lt_t012k BY bukrs hkont.
    DELETE ADJACENT DUPLICATES FROM lt_t012k COMPARING bukrs hkont.

    LOOP AT lt_t012k ASSIGNING FIELD-SYMBOL(<fs_t012k>).

      "BR - Entrada
      DATA(ls_ikofi_in) = VALUE ikofi(
          anwnd = '0001'
          eigr1 = 'B00D'
          eigr2 = '1'
          komo1 = '+'
          komo2 = 'BRL'
          ktopl = 'PC01'
          sakin =  <fs_t012k>-hkont
      ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_in-anwnd
          i_eigr1  = ls_ikofi_in-eigr1
          i_eigr2  = ls_ikofi_in-eigr2
          i_eigr3  = ls_ikofi_in-eigr3
          i_eigr4  = ls_ikofi_in-eigr4
          i_komo1  = ls_ikofi_in-komo1
          i_komo1b = ls_ikofi_in-komo1b
          i_komo2  = ls_ikofi_in-komo2
          i_komo2b = ls_ikofi_in-komo2b
          i_ktopl  = ls_ikofi_in-ktopl
          i_sakin  = ls_ikofi_in-sakin
          i_sakinb = ls_ikofi_in-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_in
        EXCEPTIONS
          OTHERS   = 1.
      IF  sy-subrc IS INITIAL AND ls_ikofi_in-sakn1 IS NOT INITIAL.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING FIELD-SYMBOL(<fs_r_hkont>).
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_in-sakn1.
      ENDIF.

      "BR - Saida
      DATA(ls_ikofi_out) =  VALUE ikofi(
          anwnd = '0001'
          eigr1 = 'B00C'
          eigr2 = '1'
          komo1 = '+'
          komo2 = 'BRL'
          ktopl = 'PC01'
          sakin =  <fs_t012k>-hkont
      ).

      CALL FUNCTION 'ACCOUNT_DETERMINATION'
        EXPORTING
          i_anwnd  = ls_ikofi_out-anwnd
          i_eigr1  = ls_ikofi_out-eigr1
          i_eigr2  = ls_ikofi_out-eigr2
          i_eigr3  = ls_ikofi_out-eigr3
          i_eigr4  = ls_ikofi_out-eigr4
          i_komo1  = ls_ikofi_out-komo1
          i_komo1b = ls_ikofi_out-komo1b
          i_komo2  = ls_ikofi_out-komo2
          i_komo2b = ls_ikofi_out-komo2b
          i_ktopl  = ls_ikofi_out-ktopl
          i_sakin  = ls_ikofi_out-sakin
          i_sakinb = ls_ikofi_out-sakin
        IMPORTING
          e_ikofi  = ls_ikofi_out
        EXCEPTIONS
          OTHERS   = 1.
      IF  sy-subrc IS INITIAL AND ls_ikofi_out-sakn1 IS NOT INITIAL.
        UNASSIGN <fs_r_hkont>.
        APPEND INITIAL LINE TO lr_hkont ASSIGNING <fs_r_hkont>.
        <fs_r_hkont>-option = 'EQ'.
        <fs_r_hkont>-sign   = 'I'.
        <fs_r_hkont>-low    = ls_ikofi_out-sakn1.
      ENDIF.
    ENDLOOP.

    "Verificar contas de bancos na compensação
    DATA(lt_bsak_paid) = lt_bsak.
    DELETE lt_bsak_paid WHERE hkont NOT IN lr_hkont.

    CHECK lt_bsak_paid IS NOT INITIAL.

    SELECT * INTO TABLE @DATA(lt_ztfi_retpag_segz)
      FROM ztfi_retpag_segz
      FOR ALL ENTRIES IN @lt_bsak_paid
      WHERE bukrs    = @lt_bsak_paid-bukrs
        AND lifnr    = @lt_bsak_paid-lifnr
        AND nbbln_eb = @lt_bsak_paid-augbl
        AND zautenticaban <> @space.


    SORT lt_bsak_paid BY bukrs
                         lifnr
                         augbl.

    DATA(lt_zttm_gkot001) = it_zttm_gkot001.

    SORT lt_zttm_gkot001 BY bukrs
                            belnr
                            gjahr.

    LOOP AT lt_ztfi_retpag_segz ASSIGNING FIELD-SYMBOL(<fs_ztfi_retpag_segz>).

      READ TABLE lt_bsak_paid ASSIGNING FIELD-SYMBOL(<fs_bsak_paid>) WITH KEY bukrs = <fs_ztfi_retpag_segz>-bukrs
                                                                              lifnr = <fs_ztfi_retpag_segz>-lifnr
                                                                              augbl = <fs_ztfi_retpag_segz>-nbbln_eb
                                                                              BINARY SEARCH.
      CHECK sy-subrc IS INITIAL.

* BEGIN OF DELETE - JWSILVA - 09.03.2023
*      READ TABLE lt_zttm_gkot001 ASSIGNING FIELD-SYMBOL(<fs_zttm_gkot001>) WITH KEY bukrs = <fs_bsak_paid>-bukrs
*                                                                                    belnr = <fs_bsak_paid>-belnr
*                                                                                    gjahr = <fs_bsak_paid>-gjahr BINARY SEARCH.
*      CHECK sy-subrc IS INITIAL.
* END OF DELETE - JWSILVA - 09.03.2023
* BEGIN OF INSERT - JWSILVA - 09.03.2023
      " Para cada documento do agrupamento, atualizar informação
      LOOP AT lt_zttm_gkot001 ASSIGNING FIELD-SYMBOL(<fs_zttm_gkot001>) WHERE bukrs = <fs_bsak_paid>-bukrs
                                                                          AND belnr = <fs_bsak_paid>-belnr
                                                                          AND gjahr = <fs_bsak_paid>-gjahr.
* END OF INSERT - JWSILVA - 09.03.2023

        <fs_zttm_gkot001>-pago      = abap_true.
        <fs_zttm_gkot001>-codstatus = '600'.
        <fs_zttm_gkot001>-augdt     = sy-datum.
        APPEND <fs_zttm_gkot001> TO rt_docs_pagos.

        IF iv_atualiza IS NOT INITIAL.

          " Documento pago - autenticação bancária &1.
          IF <fs_ztfi_retpag_segz>-zautenticaban IS NOT INITIAL.
            DATA(lt_return) = VALUE bapiret2_t( ( type = 'S' id =  'ZTM_GESTAO_FRETE' number = '138' message_v1 = <fs_ztfi_retpag_segz>-zautenticaban ) ).
          ELSE.
            FREE lt_return.
          ENDIF.

          " Insere log
          TRY.
              DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey = <fs_zttm_gkot001>-acckey ).
              lr_gko_process->set_status_payment( EXPORTING iv_augdt = <fs_zttm_gkot001>-augdt
                                                            iv_pago  = <fs_zttm_gkot001>-pago ).
              lr_gko_process->set_status( iv_status   = <fs_zttm_gkot001>-codstatus
                                          it_bapi_ret = lt_return ).
              lr_gko_process->persist( ).
              lr_gko_process->free( ).
            CATCH cx_root.
          ENDTRY.

          IF <fs_zttm_gkot001>-cenario = '06'. " Frete Diversos
            " Prepara registros para atualização do FLUIG
            APPEND <fs_zttm_gkot001> TO lt_001_key.
          ENDIF.
        ENDIF.
* BEGIN OF INSERT - JWSILVA - 09.03.2023
      ENDLOOP.
* END OF INSERT - JWSILVA - 09.03.2023
    ENDLOOP.

    " Recupera as remessas a serem removidas da tabela do FLUIG, referente ao cenário "Frete Diversos"
    IF lt_001_key IS NOT INITIAL.

      SELECT DISTINCT fluig~*
          FROM zi_tm_gestao_frota_docs_of AS docs
          INNER JOIN ztm_infos_fluig AS fluig
            ON docs~DeliveryDocument = fluig~remessa
          FOR ALL ENTRIES IN @lt_001_key
          WHERE docs~FreightOrder = @lt_001_key-tor_id
          INTO TABLE @DATA(lt_fluig).

      IF sy-subrc NE 0.
        FREE lt_fluig.
      ENDIF.
    ENDIF.

    " Remove as linhas FLUIG com as remessas do cenário "Frete Diversos"
    IF lt_fluig IS NOT INITIAL.
      DELETE ztm_infos_fluig FROM TABLE lt_fluig.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
