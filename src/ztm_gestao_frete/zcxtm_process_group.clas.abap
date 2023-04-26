CLASS zcxtm_process_group DEFINITION
  PUBLIC
  INHERITING FROM zcxtm_gestao_frete
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF GC_no_document_informed,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '043',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF GC_no_document_informed .
    CONSTANTS:
      BEGIN OF GC_po_header_params_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '051',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF GC_po_header_params_not_found .
    CONSTANTS:
      BEGIN OF GC_scenario_not_config_for_grp,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '063',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF GC_scenario_not_config_for_grp .
    CONSTANTS:
      BEGIN OF GC_scenario_not_allow_grp_proc,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '064',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF GC_scenario_not_allow_grp_proc .


    METHODS constructor
      IMPORTING
        !iv_textid      LIKE if_t100_message=>t100key OPTIONAL
        !iv_previous    LIKE previous OPTIONAL
        !iv_msgv1       TYPE any OPTIONAL
        !iv_msgv2       TYPE any OPTIONAL
        !iv_msgv3       TYPE any OPTIONAL
        !iv_msgv4       TYPE any OPTIONAL
        !it_errors      TYPE ty_t_errors OPTIONAL
        !it_bapi_return TYPE bapiret2_t OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxtm_process_group IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        iv_textid      = iv_textid
        iv_previous    = iv_previous
        iv_msgv1       = iv_msgv1
        iv_msgv2       = iv_msgv2
        iv_msgv3       = iv_msgv3
        iv_msgv4       = iv_msgv4
        it_errors      = it_errors
        it_bapi_return = it_bapi_return.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
