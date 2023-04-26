class ZCXTM_MOTORISTA_TOR definition
  public
  inheriting from /BOBF/CM_FRW
  final
  create public .

public section.

  constants:
    begin of ZCXTM_MOTORISTA_TOR,
      msgid type symsgid value 'ZTM_DRIVER_OF',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value 'GV_MSGV4',
    end of ZCXTM_MOTORISTA_TOR .
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
      !SEVERITY type TY_MESSAGE_SEVERITY optional
      !SYMPTOM type TY_MESSAGE_SYMPTOM optional
      !LIFETIME type TY_MESSAGE_LIFETIME default CO_LIFETIME_TRANSITION
      !MS_ORIGIN_LOCATION type /BOBF/S_FRW_LOCATION optional
      !MT_ENVIRONMENT_LOCATION type /BOBF/T_FRW_LOCATION optional
      !MV_ACT_KEY type /BOBF/ACT_KEY optional
      !MV_ASSOC_KEY type /BOBF/OBM_ASSOC_KEY optional
      !MV_BOPF_LOCATION type /BOBF/CONF_KEY optional
      !MV_DET_KEY type /BOBF/DET_KEY optional
      !MV_QUERY_KEY type /BOBF/OBM_QUERY_KEY optional
      !MV_VAL_KEY type /BOBF/VAL_KEY optional
      !GV_MSGV1 type MSGV1 optional
      !GV_MSGV2 type MSGV2 optional
      !GV_MSGV3 type MSGV3 optional
      !GV_MSGV4 type MSGV4 optional .
protected section.
private section.
ENDCLASS.



CLASS ZCXTM_MOTORISTA_TOR IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
SEVERITY = SEVERITY
SYMPTOM = SYMPTOM
LIFETIME = LIFETIME
MS_ORIGIN_LOCATION = MS_ORIGIN_LOCATION
MT_ENVIRONMENT_LOCATION = MT_ENVIRONMENT_LOCATION
MV_ACT_KEY = MV_ACT_KEY
MV_ASSOC_KEY = MV_ASSOC_KEY
MV_BOPF_LOCATION = MV_BOPF_LOCATION
MV_DET_KEY = MV_DET_KEY
MV_QUERY_KEY = MV_QUERY_KEY
MV_VAL_KEY = MV_VAL_KEY
.
me->GV_MSGV1 = GV_MSGV1 .
me->GV_MSGV2 = GV_MSGV2 .
me->GV_MSGV3 = GV_MSGV3 .
me->GV_MSGV4 = GV_MSGV4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCXTM_MOTORISTA_TOR .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
