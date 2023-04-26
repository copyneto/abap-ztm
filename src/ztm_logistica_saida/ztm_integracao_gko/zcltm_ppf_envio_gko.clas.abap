"!<p><h2>Envio de Dados da Ordem de Frete via PPF</h2></p>
"!<p>Esta classe trata a mensagem (action) definida nas configurações de TM para enviar a ordem de frete ao sistema GKO
"!através de geração de arquivo</p>
"!<p><strong>Autor: </strong>Marcos Roberto de Souza</p>
"!<p><strong>Data: </strong>03 de mar de 2022</p>
CLASS zcltm_ppf_envio_gko DEFINITION
  PUBLIC
  INHERITING FROM /scmtms/cl_ppf_serv_tor_b2b
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_exec_methodcall_ppf.
ENDCLASS.



CLASS zcltm_ppf_envio_gko IMPLEMENTATION.

  METHOD if_ex_exec_methodcall_ppf~execute.

    DATA lo_container TYPE REF TO /bofu/cl_ppf_container.

    lo_container ?= io_appl_object.

    "Instanciar classe para envio da ordem de frete ao GKO
    DATA(lo_gko) = NEW zcltm_interface_fo_gko( ).

    lo_gko->gerar_arquivo_gko( EXPORTING iv_tor_key  = lo_container->get_bo_root_key( )
                               IMPORTING et_messages = DATA(lt_messages) ).

    IF lines( lt_messages ) > 0.
      "Logar as mensagens de retorno
      LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_msg>).
        CALL FUNCTION 'BAL_LOG_MSG_ADD'
          EXPORTING
            i_log_handle     = ip_application_log
            i_s_msg          = CORRESPONDING bal_s_msg( <fs_msg> )
          EXCEPTIONS
            log_not_found    = 1
            msg_inconsistent = 2
            log_is_full      = 3
            OTHERS           = 4.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF line_exists( lt_messages[ msgty = 'E' ] ) OR
       line_exists( lt_messages[ msgty = 'A' ] ).
      "Se ocorrer erros no envio, setar retorno para erro
      rp_status = '2'. "vermelho = Ocorreram erros durante o processamento (2)

    ELSE. "Sucesso no envio
      rp_status = '1'. "verde = processada corretamente (1)
    ENDIF.
  ENDMETHOD.
ENDCLASS.
