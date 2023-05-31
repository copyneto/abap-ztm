class ZCXTM_SAGA_CONF_SEP_CARREG definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of ZCXTM_SAGA_CONF_SEP_CARREG,
      msgid type symsgid value 'ZTM_SAGA_CONF_SEPCAR',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value 'GV_MSGV3',
      attr4 type scx_attrname value 'GV_MSGV4',
    end of ZCXTM_SAGA_CONF_SEP_CARREG .
  constants:
    begin of COD_SITUACAO_NAO_PREVISTA,
      msgid type symsgid value 'ZTM_SAGA_CONF_SEPCAR',
      msgno type symsgno value '001',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of COD_SITUACAO_NAO_PREVISTA .
  constants:
    begin of TOR_ID_INVALIDO,
      msgid type symsgid value 'ZTM_SAGA_CONF_SEPCAR',
      msgno type symsgno value '002',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value 'GV_MSGV2',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of TOR_ID_INVALIDO .

  constants:
    begin of tsp_invalido,
      msgid type symsgid value 'ZTM_SAGA_CONF_SEPCAR',
      msgno type symsgno value '003',
      attr1 type scx_attrname value 'GV_MSGV1',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of tsp_invalido.


  data GV_MSGV1 type MSGV1 .
  data GV_MSGV2 type MSGV2 .
  data GV_MSGV3 type MSGV3 .
  data GV_MSGV4 type MSGV4 .
  data GT_BAPIRET2 type BAPIRET2_TAB .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !GV_MSGV1 type MSGV1 optional
      !GV_MSGV2 type MSGV2 optional
      !GV_MSGV3 type MSGV3 optional
      !GV_MSGV4 type MSGV4 optional
      !GT_BAPIRET2 type BAPIRET2_TAB optional .
  methods GET_BAPIRETRETURN
    returning
      value(RT_BAPIRET2) type BAPIRET2_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCXTM_SAGA_CONF_SEP_CARREG IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->GV_MSGV1 = GV_MSGV1 .
me->GV_MSGV2 = GV_MSGV2 .
me->GV_MSGV3 = GV_MSGV3 .
me->GV_MSGV4 = GV_MSGV4 .
me->GT_BAPIRET2 = GT_BAPIRET2 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCXTM_SAGA_CONF_SEP_CARREG .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.


  METHOD get_bapiretreturn.
    IF if_t100_message~t100key-msgid IS NOT INITIAL OR gv_msgv1 IS NOT INITIAL.
      APPEND INITIAL LINE TO rt_bapiret2 ASSIGNING FIELD-SYMBOL(<fs_s_bapiret2>).

      <fs_s_bapiret2>-id         = if_t100_message~t100key-msgid.
      <fs_s_bapiret2>-number     = if_t100_message~t100key-msgno.
      <fs_s_bapiret2>-type       = 'E'.
      <fs_s_bapiret2>-message_v1 = gv_msgv1.
      <fs_s_bapiret2>-message_v2 = gv_msgv2.
      <fs_s_bapiret2>-message_v3 = gv_msgv3.
      <fs_s_bapiret2>-message_v4 = gv_msgv4.

      MESSAGE ID  <fs_s_bapiret2>-id
           TYPE   <fs_s_bapiret2>-type
           NUMBER <fs_s_bapiret2>-number
           WITH   <fs_s_bapiret2>-message_v1
                  <fs_s_bapiret2>-message_v2
                  <fs_s_bapiret2>-message_v3
                  <fs_s_bapiret2>-message_v4
           INTO   <fs_s_bapiret2>-message.

    ENDIF.

    LOOP AT gt_bapiret2 ASSIGNING FIELD-SYMBOL(<fs_bapiret2>).
      APPEND INITIAL LINE TO rt_bapiret2 ASSIGNING <fs_s_bapiret2>.

      MOVE-CORRESPONDING <fs_bapiret2> TO <fs_s_bapiret2>.

      MESSAGE ID  <fs_s_bapiret2>-id
           TYPE   <fs_s_bapiret2>-type
           NUMBER <fs_s_bapiret2>-number
           WITH   <fs_s_bapiret2>-message_v1
                  <fs_s_bapiret2>-message_v2
                  <fs_s_bapiret2>-message_v3
                  <fs_s_bapiret2>-message_v4
           INTO   <fs_s_bapiret2>-message.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
