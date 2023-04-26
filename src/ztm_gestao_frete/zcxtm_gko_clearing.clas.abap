CLASS zcxtm_gko_clearing DEFINITION
  PUBLIC
  INHERITING FROM zcxtm_gko
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_start_clearing_docmnt_error,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_start_clearing_docmnt_error .
    CONSTANTS:
      BEGIN OF gc_clearing_documents_fail,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_clearing_documents_fail .

    METHODS constructor
      IMPORTING
        !textid         LIKE if_t100_message=>t100key OPTIONAL
        !previous       LIKE previous OPTIONAL
        !gv_msgv1       TYPE msgv1 OPTIONAL
        !gv_msgv2       TYPE msgv2 OPTIONAL
        !gv_msgv3       TYPE msgv3 OPTIONAL
        !gv_msgv4       TYPE msgv4 OPTIONAL
        !gt_errors      TYPE ty_t_errors OPTIONAL
        !gt_bapi_return TYPE bapiret2_t OPTIONAL .
protected section.
private section.
ENDCLASS.



CLASS ZCXTM_GKO_CLEARING IMPLEMENTATION.


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
