CLASS zcxtm_gestao_frete DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    TYPES:
      ty_t_errors TYPE TABLE OF REF TO zcxtm_gestao_frete WITH DEFAULT KEY .


    CONSTANTS:
      BEGIN OF gc_data_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '034',
      END OF gc_data_not_found .
    CONSTANTS:
      BEGIN OF gc_no_valid_line_selected,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '037',
      END OF gc_no_valid_line_selected .
    CONSTANTS:
      BEGIN OF gc_select_only_one_line,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '065',
      END OF gc_select_only_one_line .
    CONSTANTS:
      BEGIN OF gc_fill_all_mandatory_fields,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '067',
      END OF gc_fill_all_mandatory_fields .
    CONSTANTS:
      BEGIN OF gc_file_does_not_exists,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '068',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
      END OF gc_file_does_not_exists .
    CONSTANTS:
      BEGIN OF gc_not_able_to_attach_file,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '069',
      END OF gc_not_able_to_attach_file .
    CONSTANTS:
      BEGIN OF gc_error_create_file,
        msgid TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
        msgno TYPE symsgno VALUE '071',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
      END OF gc_error_create_file .
    DATA gv_msgv1 TYPE msgv1 .
    DATA gv_msgv2 TYPE msgv2 .
    DATA gv_msgv3 TYPE msgv3 .
    DATA gv_msgv4 TYPE msgv4 .
    DATA gt_errors TYPE ty_t_errors .
    DATA gt_bapi_return TYPE bapiret2_t .

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
    METHODS display .
    METHODS get_bapi_return
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCXTM_GESTAO_FRETE IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = iv_previous.
    CLEAR me->textid.
    IF iv_textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = iv_textid.
    ENDIF.

    me->gv_msgv1 = iv_msgv1.
    me->gv_msgv2 = iv_msgv2.
    me->gv_msgv3 = iv_msgv3.
    me->gv_msgv4 = iv_msgv4.
    me->gt_errors = it_errors.
    me->gt_bapi_return = it_bapi_return.

  ENDMETHOD.


  METHOD display.


    DATA(lt_return) = get_bapi_return( ).

    IF lines( lt_return ) = 1.

      ASSIGN lt_return[ 1 ] TO FIELD-SYMBOL(<fs_s_return>).

      MESSAGE ID     <fs_s_return>-id
              TYPE   if_xo_const_message=>success
              NUMBER <fs_s_return>-number
              WITH   <fs_s_return>-message_v1
                     <fs_s_return>-message_v2
                     <fs_s_return>-message_v3
                     <fs_s_return>-message_v4
              DISPLAY LIKE <fs_s_return>-type.

    ELSE.

      CALL FUNCTION 'FB_MESSAGES_DISPLAY_POPUP'
        EXPORTING
          it_return       = lt_return
        EXCEPTIONS
          no_messages     = 1
          popup_cancelled = 2
          OTHERS          = 3.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_bapi_return.

    IF if_t100_message~t100key <> if_t100_message~default_textid.

      APPEND INITIAL LINE TO rt_return ASSIGNING FIELD-SYMBOL(<fs_s_return>).

      <fs_s_return>-type       = if_xo_const_message=>error.
      <fs_s_return>-id         = if_t100_message~t100key-msgid.
      <fs_s_return>-number     = if_t100_message~t100key-msgno.
      <fs_s_return>-message_v1 = me->gv_msgv1.
      <fs_s_return>-message_v2 = me->gv_msgv2.
      <fs_s_return>-message_v3 = me->gv_msgv3.
      <fs_s_return>-message_v4 = me->gv_msgv4.

      MESSAGE ID     <fs_s_return>-id
              TYPE   <fs_s_return>-type
              NUMBER <fs_s_return>-number
              WITH   <fs_s_return>-message_v1
                     <fs_s_return>-message_v2
                     <fs_s_return>-message_v3
                     <fs_s_return>-message_v4
              INTO   <fs_s_return>-message.

    ENDIF.

    APPEND LINES OF gt_bapi_return TO rt_return.

    LOOP AT gt_errors ASSIGNING FIELD-SYMBOL(<fs_s_exception>).

      APPEND LINES OF <fs_s_exception>->get_bapi_return( ) TO rt_return.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
