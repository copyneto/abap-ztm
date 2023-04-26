class ZCXTM_MSG_MOTORISTA definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of ZCXTM_MSG_MOTORISTA,
      msgid type symsgid value 'ZTM_DRIVER_OF',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value 'GV_MSGV4',
    end of ZCXTM_MSG_MOTORISTA .
  constants:
    begin of ZVALID_DOC_INVALIDA,
      msgid type symsgid value 'ZTM_DRIVER_OF',
      msgno type symsgno value '001',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of ZVALID_DOC_INVALIDA .
  data GV_MSGV1 type MSGV1 .
  data GV_MSGV2 type MSGV2 .
  data GV_MSGV3 type MSGV3 .
  data GV_MSGV4 type MSGV4 .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !GV_MSGV1 type MSGV1 optional
      !GV_MSGV2 type MSGV2 optional
      !GV_MSGV3 type MSGV3 optional
      !GV_MSGV4 type MSGV4 optional .
protected section.
private section.
ENDCLASS.



CLASS ZCXTM_MSG_MOTORISTA IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->GV_MSGV1 = GV_MSGV1 .
me->GV_MSGV2 = GV_MSGV2 .
me->GV_MSGV3 = GV_MSGV3 .
me->GV_MSGV4 = GV_MSGV4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCXTM_MSG_MOTORISTA .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
