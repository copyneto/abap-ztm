CLASS lcl_writer DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS changemotorista FOR MODIFY
      IMPORTING keys FOR ACTION _writer~changemotorista.

    METHODS changeplaca FOR MODIFY
      IMPORTING keys FOR ACTION _writer~changeplaca.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _writer RESULT result.

    METHODS removemotoristaplaca FOR MODIFY
      IMPORTING keys FOR ACTION _writer~removemotoristaplaca.

    METHODS setdata
      IMPORTING iv_docnum    TYPE j_1bdocnum
                iv_placa     TYPE equnr OPTIONAL
                iv_motorista TYPE bu_partner OPTIONAL
      EXPORTING et_return    TYPE bapiret2_tab.

ENDCLASS.

CLASS lcl_writer IMPLEMENTATION.

  METHOD changemotorista.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

*    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE ENTITY _writer
        FIELDS ( docnum motorista placa )
        WITH VALUE #( ( %tky = ls_keys-%tky ) )
        RESULT DATA(lt_mdf).

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].

        DATA(lv_partner) = CONV bu_partner( ls_keys-%param ).

      CATCH cx_root.
*        CONTINUE.
    ENDTRY.

    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_a
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-criar ).

    IF lt_return IS NOT INITIAL.

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.
      APPEND VALUE #( %tky = ls_mdf-%tky
                      %msg = new_message( severity = CONV #( lt_return[ 1 ]-type )
                                                id = lt_return[ 1 ]-id
                                            number = lt_return[ 1 ]-number
                                                v1 = lt_return[ 1 ]-message_v1
                                                v2 = lt_return[ 1 ]-message_v2
                                                v3 = lt_return[ 1 ]-message_v3
                                                v4 = lt_return[ 1 ]-message_v4  ) ) TO reported-_writer.
      RETURN.
    ENDIF.

    SELECT SINGLE bpkind, CASE WHEN xdele = 'X' OR xblck = 'X' OR not_released = 'X' THEN 'X' ELSE ' ' END AS block
      FROM but000
     WHERE partner = @lv_partner
      INTO (@DATA(lv_kind), @DATA(lv_block)).
    IF sy-subrc NE 0.

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.

      APPEND VALUE #( %tky = ls_mdf-%tky %msg = new_message( severity = if_abap_behv_message=>severity-error
                                                                     id = gc_mg_id
                                                                 number = gc_msg_no-m_036  ) ) TO reported-_writer.

    ELSEIF lv_kind NE gc_kind.

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.

      APPEND VALUE #( %tky = ls_mdf-%tky %msg = new_message( severity = if_abap_behv_message=>severity-error
                                                                     id = gc_mg_id
                                                                 number = gc_msg_no-m_035  ) ) TO reported-_writer.

    ELSEIF lv_block EQ abap_true.

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.

      APPEND VALUE #( %tky = ls_mdf-%tky %msg = new_message( severity = if_abap_behv_message=>severity-error
                                                                     id = gc_mg_id
                                                                 number = gc_msg_no-m_034  ) ) TO reported-_writer.

    ELSE.

      me->setdata( EXPORTING iv_docnum = ls_mdf-docnum
                          iv_motorista = ls_keys-%param-motorista
                              iv_placa = ls_mdf-placa
                   IMPORTING et_return = DATA(lt_messages) ).

      IF line_exists( lt_messages[ type = if_abap_behv_message=>severity-error ] ). "#EC CI_STDSEQ

        APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.

        APPEND VALUE #( %tky = ls_mdf-%tky
                        %msg = new_message( severity = CONV #( lt_messages[ 1 ]-type )
                                                  id = lt_messages[ 1 ]-id
                                              number = lt_messages[ 1 ]-number
                                                  v1 = lt_messages[ 1 ]-message_v1
                                                  v2 = lt_messages[ 1 ]-message_v2
                                                  v3 = lt_messages[ 1 ]-message_v3
                                                  v4 = lt_messages[ 1 ]-message_v4  ) ) TO reported-_writer.

      ELSE.

        MODIFY ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE
          ENTITY _writer
            UPDATE FIELDS ( motorista )
              WITH VALUE #( ( %tky = ls_keys-%tky motorista = ls_keys-%param-motorista ) )
                REPORTED DATA(lt_reported).

      ENDIF.
    ENDIF.

*    ENDLOOP.

    READ ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE
      ENTITY _writer
        ALL FIELDS
          WITH CORRESPONDING #( keys )
            RESULT DATA(lt_result)
            FAILED failed.

*    result = VALUE #( FOR ls_result IN lt_result ( %tky   = ls_result-%tky %param = ls_result ) ).

  ENDMETHOD.

  METHOD changeplaca.

*    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE ENTITY _writer
        FIELDS ( docnum motorista placa )
        WITH VALUE #( ( %tky = ls_keys-%tky ) )
        RESULT DATA(lt_mdf).

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].
      CATCH cx_root.
*        CONTINUE.
    ENDTRY.

    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_a
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-criar ).

    IF lt_return IS NOT INITIAL.

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.
      APPEND VALUE #( %tky = ls_mdf-%tky
                      %msg = new_message( severity = CONV #( lt_return[ 1 ]-type )
                                                id = lt_return[ 1 ]-id
                                            number = lt_return[ 1 ]-number
                                                v1 = lt_return[ 1 ]-message_v1
                                                v2 = lt_return[ 1 ]-message_v2
                                                v3 = lt_return[ 1 ]-message_v3
                                                v4 = lt_return[ 1 ]-message_v4  ) ) TO reported-_writer.
      RETURN.
    ENDIF.

    "CALL FUNCTION 'ZFTM_VEIC_INFO'.

    "IF line_exists( lt_messages[ type = if_abap_behv_message=>severity-error ] ).
    IF 1 = 2.

*        APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.
*
*        APPEND VALUE #( %tky = ls_mdf-%tky %msg = new_message( severity = CONV #( lt_messages[ 1 ]-type )
*                                                                     id = lt_messages[ 1 ]-id
*                                                                 number = lt_messages[ 1 ]-number
*                                                                     v1 = lt_messages[ 1 ]-message_v1 ) ) TO reported-_writer.
    ELSE.

      me->setdata( EXPORTING iv_docnum = ls_mdf-docnum
                          iv_motorista = ls_mdf-motorista
                              iv_placa = CONV #( ls_keys-%param )
                     IMPORTING et_return = DATA(lt_messages) ).

      IF line_exists( lt_messages[ type = if_abap_behv_message=>severity-error ] ). "#EC CI_STDSEQ

        APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.

        APPEND VALUE #( %tky = ls_mdf-%tky
                        %msg = new_message( severity = CONV #( lt_messages[ 1 ]-type )
                                                  id = lt_messages[ 1 ]-id
                                              number = lt_messages[ 1 ]-number
                                                  v1 = lt_messages[ 1 ]-message_v1
                                                  v2 = lt_messages[ 1 ]-message_v2
                                                  v3 = lt_messages[ 1 ]-message_v3
                                                  v4 = lt_messages[ 1 ]-message_v4  ) ) TO reported-_writer.

      ELSE.

        MODIFY ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE
          ENTITY _writer
            UPDATE FIELDS ( placa )
              WITH VALUE #( ( %tky = ls_keys-%tky placa = ls_keys-%param-placa ) )
                REPORTED DATA(lt_reported).

      ENDIF.
    ENDIF.

*    ENDLOOP.

    READ ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE
          ENTITY _writer
            ALL FIELDS
              WITH CORRESPONDING #( keys )
                RESULT DATA(lt_result)
                FAILED failed.

*    result = VALUE #( FOR ls_result IN lt_result ( %tky   = ls_result-%tky %param = ls_result ) ).

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE ENTITY _writer
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf)
        FAILED failed.

    result = VALUE #( FOR ls_mdf IN lt_mdf
                        ( %tky = ls_mdf-%tky
                          %action-changemotorista       = if_abap_behv=>fc-o-enabled
                          %action-changeplaca           = if_abap_behv=>fc-o-enabled
                          %action-removemotoristaplaca  = if_abap_behv=>fc-o-enabled ) ).
*                          %action-removeMotoristaPlaca  = COND #( WHEN ls_mdf-Motorista IS NOT INITIAL
*                                                                    OR ls_mdf-Placa IS NOT INITIAL
*                                                                  THEN if_abap_behv=>fc-o-enabled
*                                                                  ELSE if_abap_behv=>fc-o-disabled ) ) ) .

  ENDMETHOD.

  METHOD setdata.

    DATA: ls_header    TYPE j_1bnfdoc,
          ls_historico TYPE zttm_mdfe_hist.

    DATA: lt_partner    TYPE TABLE OF j_1bnfnad,
          lt_item       TYPE TABLE OF j_1bnflin,
          lt_item_tax   TYPE TABLE OF j_1bnfstx,
          lt_header_msg TYPE TABLE OF j_1bnfftx,
          lt_refer_msg  TYPE TABLE OF j_1bnfref.

    CALL FUNCTION 'J_1B_NF_DOCUMENT_READ'
      EXPORTING
        doc_number         = iv_docnum
      IMPORTING
        doc_header         = ls_header
      TABLES
        doc_partner        = lt_partner
        doc_item           = lt_item
        doc_item_tax       = lt_item_tax
        doc_header_msg     = lt_header_msg
        doc_refer_msg      = lt_refer_msg
      EXCEPTIONS
        document_not_found = 1
        docum_lock         = 2
        partner_blocked    = 3
        OTHERS             = 4.
    IF sy-subrc NE 0.
      APPEND VALUE #( id = sy-msgid number = sy-msgno type = sy-msgty message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_return.
      RETURN.
    ENDIF.

    ls_historico-condutor   = ls_header-zzmotorista.
    ls_historico-placa      = ls_header-zzplaca.


    DATA(lv_placa) = |{ iv_placa ALPHA = OUT }|.
    REPLACE ALL OCCURRENCES OF REGEX '[^[:alnum:]]' IN lv_placa WITH ''.

    ls_header-traid         = |{ iv_placa ALPHA = OUT }|.
    ls_header-zzplaca       = |{ iv_placa ALPHA = OUT }|.
    ls_header-zzmotorista   = iv_motorista.
    ls_header-shpmrk        = iv_motorista.
    ls_header-placa         = lv_placa.

    CALL FUNCTION 'J_1B_NF_DOCUMENT_UPDATE'
      EXPORTING
        doc_number            = ls_header-docnum
        doc_header            = ls_header
      TABLES
        doc_partner           = lt_partner
        doc_item              = lt_item
        doc_item_tax          = lt_item_tax
        doc_header_msg        = lt_header_msg
        doc_refer_msg         = lt_refer_msg
      EXCEPTIONS
        document_not_found    = 1
        update_problem        = 2
        doc_number_is_initial = 3
        OTHERS                = 4.
    IF sy-subrc <> 0.
      APPEND VALUE #( id = sy-msgid number = sy-msgno type = sy-msgty message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_return.
      RETURN.
    ENDIF.

    TRY.

        ls_historico-guid   = cl_system_uuid=>create_uuid_x16_static( ).
        ls_historico-docnum = ls_header-docnum.
        ls_historico-data   = sy-datum.
        ls_historico-hora   = sy-uzeit.
        ls_historico-uname  = sy-uname.

        ls_historico-condutor_novo = ls_header-zzmotorista.
        ls_historico-placa_nova = ls_header-zzplaca.

        INSERT zttm_mdfe_hist FROM ls_historico.
        IF sy-subrc NE 0.
          APPEND VALUE #( id = sy-msgid number = sy-msgno type = sy-msgty message_v1 = sy-msgv1 message_v2 = sy-msgv2 message_v3 = sy-msgv3 message_v4 = sy-msgv4 ) TO et_return.
          RETURN.
        ENDIF.

      CATCH cx_uuid_error.
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD removemotoristaplaca.

    READ ENTITIES OF zi_tm_mdf_motorista_change IN LOCAL MODE ENTITY _writer
        FIELDS ( docnum motorista placa )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_mdf).

    TRY.
        DATA(ls_mdf) = lt_mdf[ 1 ].
      CATCH cx_root.
    ENDTRY.

    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_a
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-eliminar ).

    IF lt_return IS NOT INITIAL.

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.
      APPEND VALUE #( %tky = ls_mdf-%tky
                      %msg = new_message( severity = CONV #( lt_return[ 1 ]-type )
                                                id = lt_return[ 1 ]-id
                                            number = lt_return[ 1 ]-number
                                                v1 = lt_return[ 1 ]-message_v1
                                                v2 = lt_return[ 1 ]-message_v2
                                                v3 = lt_return[ 1 ]-message_v3
                                                v4 = lt_return[ 1 ]-message_v4  ) ) TO reported-_writer.
      RETURN.
    ENDIF.

    me->setdata( EXPORTING iv_docnum      = ls_mdf-docnum
                           iv_motorista   = space
                           iv_placa       = space
                 IMPORTING et_return      = DATA(lt_messages) ).

    IF line_exists( lt_messages[ type = if_abap_behv_message=>severity-error ] ). "#EC CI_STDSEQ

      APPEND VALUE #( %tky = ls_mdf-%tky ) TO failed-_writer.

      APPEND VALUE #( %tky = ls_mdf-%tky
                      %msg = new_message( severity = CONV #( lt_messages[ 1 ]-type )
                                                id = lt_messages[ 1 ]-id
                                            number = lt_messages[ 1 ]-number
                                                v1 = lt_messages[ 1 ]-message_v1
                                                v2 = lt_messages[ 1 ]-message_v2
                                                v3 = lt_messages[ 1 ]-message_v3
                                                v4 = lt_messages[ 1 ]-message_v4  ) ) TO reported-_writer.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
