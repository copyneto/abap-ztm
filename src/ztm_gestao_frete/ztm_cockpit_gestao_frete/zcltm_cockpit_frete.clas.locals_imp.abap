CLASS lcl_cockpitheader DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS agrupamento FOR MODIFY
      IMPORTING keys FOR ACTION _cockpitheader~agrupamento.
    METHODS estorno FOR MODIFY
      IMPORTING keys FOR ACTION _cockpitheader~estorno.
    METHODS reprocessar FOR MODIFY
      IMPORTING keys FOR ACTION _cockpitheader~reprocessar.
    METHODS evento_cte FOR MODIFY
      IMPORTING keys FOR ACTION _cockpitheader~evento_cte.
    METHODS consultar_status FOR MODIFY
      IMPORTING keys FOR ACTION _cockpitheader~consultar_status.
ENDCLASS.

CLASS lcl_cockpitheader IMPLEMENTATION.

  METHOD agrupamento.
    READ ENTITIES OF zi_tm_cockpit001 IN LOCAL MODE
      ENTITY _cockpitheader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    CHECK lt_header_data IS NOT INITIAL.


    NEW zcltm_agrupar_fatura( )->agrupar_fatura(
      EXPORTING
        iv_stcd1           = ''
        iv_vlr_total       = ''
        iv_vlr_desconto    = ''
        iv_fatura_trasnpo  = ''
        iv_data_vencimento = '00000000'
        it_acckey    = VALUE #( FOR ls_header_data IN lt_header_data ( acckey = ls_header_data-acckey ) )
      IMPORTING
        et_mensagens = DATA(lt_mensagens)
    ).

    DATA(lv_acckey) = lt_header_data[ 1 ]-acckey.

    APPEND VALUE #( %tky-acckey = lv_acckey ) TO failed-_cockpitheader.
    reported-_cockpitheader = VALUE #( BASE reported-_cockpitheader
      FOR ls_mensagens IN lt_mensagens (
        %tky       = VALUE #( acckey = lv_acckey )
        %msg       =  new_message(
          id       = ls_mensagens-id
          number   = ls_mensagens-number
          severity = CONV #( ls_mensagens-type )
          v1       = ls_mensagens-message_v1
          v2       = ls_mensagens-message_v2
          v3       = ls_mensagens-message_v3
          v4       = ls_mensagens-message_v4
    ) ) ).
  ENDMETHOD.

  METHOD estorno.

    READ ENTITIES OF zi_tm_cockpit001 IN LOCAL MODE
      ENTITY _cockpitheader
      FIELDS ( acckey codstatus belnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    CHECK lt_header_data IS NOT INITIAL.

    DATA: lt_errors      TYPE zcxtm_gko=>ty_t_errors,
          lt_docs        TYPE zcltm_gko_process_group=>ty_t_docs,
          lt_acckey      TYPE zctgsd_acckey,
          lt_bapi_return TYPE bapiret2_t,
          lt_mensagens   TYPE bapiret2_t.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
      IF <fs_key>-%param-estornoagrupamento = abap_true.
        LOOP AT lt_header_data ASSIGNING FIELD-SYMBOL(<fs_s_agrup>)
                                    GROUP BY <fs_s_agrup>-belnr.
          TRY.
              FREE: lt_errors, lt_docs.
              LOOP AT GROUP <fs_s_agrup> ASSIGNING FIELD-SYMBOL(<fs_s_agrup_mbr>).
                TRY.
                    zcltm_gko_process=>check_status_from_action(
                      iv_action = zcltm_gko_process=>gc_acao-estorno
                      iv_status = <fs_s_agrup_mbr>-codstatus
                    ).

                    APPEND NEW zcltm_gko_process(
                      iv_acckey    = <fs_s_agrup_mbr>-acckey
                      iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ) TO lt_docs.

                    APPEND <fs_s_agrup_mbr>-acckey TO lt_acckey.

                  CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
                    APPEND lr_cx_gko_process TO lt_errors.
                ENDTRY.
              ENDLOOP.

              IF lt_errors IS NOT INITIAL.
                RAISE EXCEPTION TYPE zcxtm_gko
                  EXPORTING
                    gt_errors = lt_errors.
              ENDIF.

              zcltm_gko_process_group=>reversal_invoice_grouping( lt_docs ).

              IF <fs_key>-%param-estornomiro = abap_true.

                LOOP AT lt_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).

                  DATA(lv_tabix) = sy-tabix.
                  TRY.
                      DATA(lv_rev_miro) = <fs_s_doc>->reversal_invoice( ).

                      IF <fs_key>-%param-estornopedido = abap_true AND lv_rev_miro = abap_true.
                        <fs_s_doc>->reversal_purchase_order_ex( ).
                      ENDIF.

                    CATCH zcxtm_gko INTO DATA(lr_cx_gko).

                      <fs_s_doc>->persist( ).
                      <fs_s_doc>->free( ).

                      APPEND lr_cx_gko TO lt_errors.

                      DELETE lt_docs INDEX lv_tabix.
                      CONTINUE.
                  ENDTRY.

                ENDLOOP.

                IF lt_errors IS NOT INITIAL.
                  RAISE EXCEPTION TYPE zcxtm_gko
                    EXPORTING
                      gt_errors = lt_errors.
                ENDIF.

              ENDIF.

              LOOP AT lt_docs ASSIGNING <fs_s_doc>.
                TRY.
                    <fs_s_doc>->persist( ).
                    <fs_s_doc>->free( ).
                  CATCH zcxtm_gko INTO lr_cx_gko.
                    <fs_s_doc>->free( ).
                ENDTRY.

              ENDLOOP.

            CATCH zcxtm_gko INTO lr_cx_gko.
            CATCH zcxtm_process_group  INTO DATA(lr_cx_process_group).
              APPEND LINES OF lr_cx_gko->get_bapi_return( ) TO lt_bapi_return.
              APPEND LINES OF lr_cx_process_group->get_bapi_return( ) TO lt_bapi_return.
              LOOP AT lt_docs ASSIGNING <fs_s_doc>.
                <fs_s_doc>->free( ).
              ENDLOOP.
          ENDTRY.

        ENDLOOP.
      ENDIF.

      IF <fs_key>-%param-estornomiro EQ abap_true.
        TRY.
            DATA(lr_gko_process) = NEW zcltm_gko_process(
              iv_acckey    = <fs_key>-acckey
              iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ).

            lv_rev_miro = lr_gko_process->reversal_invoice( ).
            lr_gko_process->persist( ).

            IF <fs_key>-%param-estornopedido = abap_true AND lv_rev_miro = abap_true.
              lr_gko_process->reversal_purchase_order_ex( IMPORTING et_return  = lt_bapi_return ).
              APPEND LINES OF lt_bapi_return TO lt_mensagens.
            ENDIF.

            lr_gko_process->persist( ).
            lr_gko_process->free( ).
          CATCH zcxtm_gko_process INTO lr_cx_gko_process.
            APPEND LINES OF lr_cx_gko_process->get_bapi_return( ) TO lt_mensagens.
            IF lr_gko_process IS BOUND.
              lr_gko_process->free( ).
            ENDIF.
        ENDTRY.
      ENDIF.

      IF <fs_key>-%param-estornopedido EQ abap_true
      AND <fs_key>-%param-estornomiro NE abap_true.

        TRY.
            lr_gko_process = NEW zcltm_gko_process(
              iv_acckey    = <fs_key>-acckey
              iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ).
            lr_gko_process->reversal_purchase_order_ex( IMPORTING et_return  = lt_bapi_return ).
            APPEND LINES OF lt_bapi_return TO lt_mensagens.
            lr_gko_process->persist( ).
            lr_gko_process->free( ).
          CATCH zcxtm_gko_process INTO lr_cx_gko_process.
            APPEND LINES OF lr_cx_gko_process->get_bapi_return( ) TO lt_mensagens.
            IF lr_gko_process IS BOUND.
              lr_gko_process->free( ).
            ENDIF.
        ENDTRY.
      ENDIF.

      APPEND VALUE #( %tky-acckey = <fs_key>-acckey ) TO failed-_cockpitheader.
      reported-_cockpitheader = VALUE #( BASE reported-_cockpitheader
        FOR ls_mensagens IN lt_mensagens (
          %tky       = VALUE #( acckey = <fs_key>-acckey )
          %msg       =  new_message(
            id       = ls_mensagens-id
            number   = ls_mensagens-number
            severity = CONV #( ls_mensagens-type )
            v1       = ls_mensagens-message_v1
            v2       = ls_mensagens-message_v2
            v3       = ls_mensagens-message_v3
            v4       = ls_mensagens-message_v4
      ) ) ).
    ENDLOOP.

    RETURN.
  ENDMETHOD.

  METHOD reprocessar.
    READ ENTITIES OF zi_tm_cockpit001 IN LOCAL MODE
      ENTITY _cockpitheader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    CHECK lt_header_data IS NOT INITIAL.

    LOOP AT lt_header_data ASSIGNING FIELD-SYMBOL(<fs_header_data>).
      TRY.
          DATA(lr_gko_process) = NEW zcltm_gko_process(
            iv_acckey          = <fs_header_data>-acckey
            iv_tpprocess       = zcltm_gko_process=>gc_tpprocess-manual
            iv_min_data_load   = abap_false ).
          lr_gko_process->reprocess( ).
          lr_gko_process->persist( ).
          lr_gko_process->free( ).
          DATA(lt_mensagens) = VALUE bapiret2_t( (
            id         = 'ZTM_GESTAO_FRETE'
            number     = '040'
            type       = 'S'
          ) ).
        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
          IF lr_gko_process IS BOUND.
            lr_gko_process->free( ).
          ENDIF.
          lt_mensagens = lr_cx_gko_process->get_bapi_return( ).
      ENDTRY.

*      APPEND VALUE #( %tky-acckey = <fs_header_data>-acckey ) TO failed-_cockpitheader.
      reported-_cockpitheader = VALUE #( BASE reported-_cockpitheader
        FOR ls_mensagens IN lt_mensagens (
          %tky       = VALUE #( acckey = <fs_header_data>-acckey )
          %msg       =  new_message(
            id       = ls_mensagens-id
            number   = ls_mensagens-number
            severity = CONV #( ls_mensagens-type )
            v1       = ls_mensagens-message_v1
            v2       = ls_mensagens-message_v2
            v3       = ls_mensagens-message_v3
            v4       = ls_mensagens-message_v4
      ) ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD evento_cte.
    READ ENTITIES OF zi_tm_cockpit001 IN LOCAL MODE
      ENTITY _cockpitheader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    CHECK lt_header_data IS NOT INITIAL.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
      TRY.
          DATA(lr_gko_process) = NEW zcltm_gko_process(
            iv_acckey    = <fs_key>-acckey
            iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ).
          lr_gko_process->reject( <fs_key>-%param-motivorejeicao ).
          lr_gko_process->persist( ).
          lr_gko_process->free( ).
          DATA(lt_mensagens) = VALUE bapiret2_t( (
            id         = 'ZTM_GESTAO_FRETE'
            number     = '040'
            type       = 'S'
          ) ).
        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
          IF lr_gko_process IS BOUND.
            lr_gko_process->free( ).
          ENDIF.
          lt_mensagens = lr_cx_gko_process->get_bapi_return( ).
      ENDTRY.

      APPEND VALUE #( %tky-acckey = <fs_key>-acckey ) TO failed-_cockpitheader.
      reported-_cockpitheader = VALUE #( BASE reported-_cockpitheader
        FOR ls_mensagens IN lt_mensagens (
          %tky       = VALUE #( acckey = <fs_key>-acckey )
          %msg       =  new_message(
            id       = ls_mensagens-id
            number   = ls_mensagens-number
            severity = CONV #( ls_mensagens-type )
            v1       = ls_mensagens-message_v1
            v2       = ls_mensagens-message_v2
            v3       = ls_mensagens-message_v3
            v4       = ls_mensagens-message_v4
      ) ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD consultar_status.
    READ ENTITIES OF zi_tm_cockpit001 IN LOCAL MODE
      ENTITY _cockpitheader
      FIELDS ( acckey )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header_data)
      FAILED failed.

    CHECK lt_header_data IS NOT INITIAL.

    LOOP AT lt_header_data ASSIGNING FIELD-SYMBOL(<fs_header_data>).
      NEW zcltm_check_doc_sefaz( )->check_sefaz(
        EXPORTING
          iv_acckey    = <fs_header_data>-acckey
        IMPORTING
          et_mensagens = DATA(lt_mensagens)
      ).
      APPEND VALUE #( %tky-acckey = <fs_header_data>-acckey ) TO failed-_cockpitheader.

      reported-_cockpitheader = VALUE #( BASE reported-_cockpitheader
        FOR ls_mensagens IN lt_mensagens (
          %tky       = VALUE #( acckey = <fs_header_data>-acckey )
          %msg       =  new_message(
            id       = ls_mensagens-id
            number   = ls_mensagens-number
            severity = CONV #( ls_mensagens-type )
            v1       = ls_mensagens-message_v1
            v2       = ls_mensagens-message_v2
            v3       = ls_mensagens-message_v3
            v4       = ls_mensagens-message_v4
      ) ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
