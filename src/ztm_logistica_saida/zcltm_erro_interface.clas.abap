"!<p>Classe de exceção para a interface com o sistema MES</p>
"!<p><strong>Autor:</strong> Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong> 6 de ago de 2021</p>
class ZCLTM_ERRO_INTERFACE definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

*    ! @parameter is_textid |Erro apontado pela exceção
*    ! @parameter is_previous |Erro anterior (utilizado para a propagação de erros)
  methods CONSTRUCTOR
    importing
      !textid like IF_T100_MESSAGE=>T100KEY optional
      !previous like PREVIOUS optional .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLTM_ERRO_INTERFACE IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
