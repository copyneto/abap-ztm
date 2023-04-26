class ZCXTM_GKO_PROCESS_GROUP definition
  public
  inheriting from ZCXTM_GKO
  create public .

public section.

    CONSTANTS:
      BEGIN OF gc_no_document_informed,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '043',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_no_document_informed .
    CONSTANTS:
      BEGIN OF gc_po_header_params_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '051',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_po_header_params_not_found .
    CONSTANTS:
      BEGIN OF gc_scenario_not_config_group,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '063',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_scenario_not_config_group .
    CONSTANTS:
      BEGIN OF gc_scenario_not_allow_gro_proc,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '064',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_scenario_not_allow_gro_proc .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !GV_MSGV1 type MSGV1 optional
      !GV_MSGV2 type MSGV2 optional
      !GV_MSGV3 type MSGV3 optional
      !GV_MSGV4 type MSGV4 optional
      !GT_ERRORS type TY_T_ERRORS optional
      !GT_BAPI_RETURN type BAPIRET2_T optional .
protected section.
private section.
ENDCLASS.



CLASS ZCXTM_GKO_PROCESS_GROUP IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
GV_MSGV1 = GV_MSGV1
GV_MSGV2 = GV_MSGV2
GV_MSGV3 = GV_MSGV3
GV_MSGV4 = GV_MSGV4
GT_ERRORS = GT_ERRORS
GT_BAPI_RETURN = GT_BAPI_RETURN
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
