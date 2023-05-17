"!<p>Classe de exceção para a interface com o sistema MES</p>
"!<p><strong>Autor:</strong> Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong> 6 de ago de 2021</p>
CLASS zcxtm_erro_interface DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

*    ! @parameter is_textid |Erro apontado pela exceção
*    ! @parameter is_previous |Erro anterior (utilizado para a propagação de erros)
    METHODS constructor
      IMPORTING
        !iv_textid   LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous LIKE previous OPTIONAL .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxtm_erro_interface IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
*    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
