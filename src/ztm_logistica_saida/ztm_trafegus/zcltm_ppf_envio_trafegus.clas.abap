class ZCLTM_PPF_ENVIO_TRAFEGUS definition
  public
  final
  create public .

public section.

  interfaces IF_EX_EXEC_METHODCALL_PPF .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_PPF_ENVIO_TRAFEGUS IMPLEMENTATION.


  METHOD if_ex_exec_methodcall_ppf~execute.

    DATA: lo_trafegus  TYPE REF TO zcltm_send_of_trafegus,
          lo_container TYPE REF TO /bofu/cl_ppf_container,
          ls_msg       TYPE bal_s_msg,
          lv_ok        TYPE abap_bool.

    CONSTANTS : LC_ENVIAR_Trafegus TYPE string VALUE 'ZTM_B2B_TRAFEGUS'.

    IF ip_action = LC_ENVIAR_Trafegus.

      lo_container ?= io_appl_object.

      lo_trafegus = NEW zcltm_send_of_trafegus( ).
      lo_trafegus->process(
        EXPORTING
          iv_key    = lo_container->get_bo_root_key( )
          iv_memory = abap_true
      ).

      IF lo_trafegus->send_data( ) EQ abap_true.

        rp_status = '1'. "verde = processada corretamente (1)

      ELSE.

        DATA(lt_return) = lo_trafegus->get_erro( ).

        LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

          CLEAR: ls_msg.

          ls_msg-msgty = <fs_return>-type.
          ls_msg-msgid = <fs_return>-id.
          ls_msg-msgno = <fs_return>-number.

          ls_msg-msgv1 = <fs_return>-message_v1.
          ls_msg-msgv2 = <fs_return>-message_v2.
          ls_msg-msgv3 = <fs_return>-message_v3.
          ls_msg-msgv4 = <fs_return>-message_v4.

          CALL FUNCTION 'BAL_LOG_MSG_ADD'
            EXPORTING
              i_log_handle     = ip_application_log
              i_s_msg          = ls_msg
            EXCEPTIONS
              log_not_found    = 1
              msg_inconsistent = 2
              log_is_full      = 3
              OTHERS           = 4.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

        ENDLOOP.

        SORT lt_return BY type.

        lv_ok = abap_true.

        READ TABLE lt_return
        WITH KEY type = 'E'
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc = 0.
          lv_ok = abap_false.
        ELSE.

          READ TABLE lt_return
          WITH KEY type = 'A'
          BINARY SEARCH TRANSPORTING NO FIELDS.

          IF sy-subrc = 0.
            lv_ok = abap_false.
          ENDIF.

        ENDIF.


*        IF line_exists( lt_return[ type = 'E' ] ) OR
*           line_exists( lt_return[ type = 'A' ] ).
        IF lv_ok = abap_true.
          "Se ocorrer erros no envio, setar retorno para erro
          rp_status = '2'. "vermelho = Ocorreram erros durante o processamento (2)
        ELSE.
          rp_status = '1'. "verde = processada corretamente (1)
        ENDIF.

      ENDIF.


    ELSE.
      rp_status = '0'. "amarelo = não processada (0)
    ENDIF.



  ENDMETHOD.
ENDCLASS.
