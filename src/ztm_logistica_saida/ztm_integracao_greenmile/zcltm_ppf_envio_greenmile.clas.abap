"!<p><h2>Envio de Dados da Ordem de Frete via PPF</h2></p>
"!<p>Esta classe trata a mensagem (action) definida nas configurações de TM para enviar a ordem de frete ao sistema GreenMile
"!através de interface PI</p>
"!<p><strong>Autor: </strong>Marcos Roberto de Souza</p>
"!<p><strong>Data: </strong>10 de fev de 2022</p>
class ZCLTM_PPF_ENVIO_GREENMILE definition
  public
  inheriting from /SCMTMS/CL_PPF_SERV_TOR_B2B
  final
  create public .

public section.

  interfaces IF_EX_EXEC_METHODCALL_PPF .

  constants GC_ENVIAR_GREENMILE type STRING value 'ZTM_B2B_TO_GREENMILE' ##NO_TEXT.
ENDCLASS.



CLASS ZCLTM_PPF_ENVIO_GREENMILE IMPLEMENTATION.


  METHOD if_ex_exec_methodcall_ppf~execute.

    DATA: lo_interface TYPE REF TO ziftm_envio_tor_greenmile,
          lo_container TYPE REF TO /bofu/cl_ppf_container.

    IF ip_action = gc_enviar_greenmile.

      lo_container ?= io_appl_object.

      "Instanciar classe para envio da ordem de frete ao GreenMile
      lo_interface ?= NEW zcltm_process_greenmile( ).

      lo_interface->enviar_tor( EXPORTING iv_tor_key  = lo_container->get_bo_root_key( )
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

    ELSE. "Não é a action a ser tratada por esta classe
      rp_status = '0'. "amarelo = não processada (0)
    ENDIF.

  ENDMETHOD.
ENDCLASS.
