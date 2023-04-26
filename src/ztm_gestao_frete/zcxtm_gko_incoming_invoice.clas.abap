CLASS zcxtm_gko_incoming_invoice DEFINITION
  PUBLIC
  INHERITING FROM zcxtm_gko
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_generic_error,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_generic_error .
    CONSTANTS:
      BEGIN OF gc_nfs_invoice_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_nfs_invoice_not_found .
    CONSTANTS:
      BEGIN OF gc_vendor_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_vendor_not_found .
    CONSTANTS:
      BEGIN OF gc_value_not_coincident,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_value_not_coincident .
    CONSTANTS:
      BEGIN OF gc_error_unlock_document,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_unlock_document .
    CONSTANTS:
      BEGIN OF gc_parameter_not_registered,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '041',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_parameter_not_registered .
    CONSTANTS:
      BEGIN OF gc_abort_processing,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '042',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_abort_processing .
    CONSTANTS:
      BEGIN OF gc_data_not_found_parameter,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_data_not_found_parameter .
    CONSTANTS:
      BEGIN OF gc_cte_invoice_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '072',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_cte_invoice_not_found .

    CONSTANTS:
      BEGIN OF gc_invoice_not_to_update,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '091',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_invoice_not_to_update .

    CONSTANTS:
      BEGIN OF gc_invoice_already_cleared,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '149',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_invoice_already_cleared .

    METHODS constructor
      IMPORTING
        !textid         LIKE if_t100_message=>t100key OPTIONAL
        !previous       LIKE previous OPTIONAL
        !gv_msgv1       TYPE any OPTIONAL
        !gv_msgv2       TYPE any OPTIONAL
        !gv_msgv3       TYPE any OPTIONAL
        !gv_msgv4       TYPE any OPTIONAL
        !gt_errors      TYPE ty_t_errors OPTIONAL
        !gt_bapi_return TYPE bapiret2_t OPTIONAL .
protected section.
private section.
ENDCLASS.



CLASS ZCXTM_GKO_INCOMING_INVOICE IMPLEMENTATION.


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
