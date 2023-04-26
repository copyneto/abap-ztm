CLASS zcxtm_gko DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .

    TYPES:
      ty_t_errors TYPE TABLE OF REF TO zcxtm_gko WITH DEFAULT KEY .

    CONSTANTS:
      BEGIN OF gc_zcxtm_gko,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_zcxtm_gko .
    CONSTANTS:
      BEGIN OF gc_data_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '034',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_data_not_found .
    CONSTANTS:
      BEGIN OF gc_no_valid_line_selected,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '037',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_no_valid_line_selected .
    CONSTANTS:
      BEGIN OF gc_error_create_file,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '071',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'GV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'GV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'GV_MSGV4',
      END OF gc_error_create_file .
    CONSTANTS:
      BEGIN OF gc_file_does_not_exists,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '068',
        attr1 TYPE scx_attrname VALUE 'GV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_file_does_not_exists .
    CONSTANTS:
      BEGIN OF gc_not_able_to_attach_file,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '069',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_not_able_to_attach_file .
    CONSTANTS:
      BEGIN OF gc_fill_all_mandatory_fields,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '067',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_fill_all_mandatory_fields .
    CONSTANTS:
      BEGIN OF gc_select_only_one_line,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '065',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF gc_select_only_one_line .

    DATA gv_msgv1 TYPE msgv1 .
    DATA gv_msgv2 TYPE msgv2 .
    DATA gv_msgv3 TYPE msgv3 .
    DATA gv_msgv4 TYPE msgv4 .
    DATA gt_errors TYPE ty_t_errors .
    DATA gt_bapi_return TYPE bapiret2_t .

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
    METHODS display .
    METHODS get_bapi_return
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxtm_gko IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    me->gv_msgv1 = gv_msgv1 .
    me->gv_msgv2 = gv_msgv2 .
    me->gv_msgv3 = gv_msgv3 .
    me->gv_msgv4 = gv_msgv4 .
    me->gt_errors = gt_errors .
    me->gt_bapi_return = gt_bapi_return .
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = gc_zcxtm_gko .
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.


  METHOD display.

    DATA(lt_return) = get_bapi_return( ).

    IF lines( lt_return ) = 1.

      ASSIGN lt_return[ 1 ] TO FIELD-SYMBOL(<fs_s_return>).

      MESSAGE ID     <fs_s_return>-id
              TYPE   'S'
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

      IF sy-subrc IS NOT INITIAL.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
                                                               sy-msgv2
                                                               sy-msgv3
                                                               sy-msgv4.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_bapi_return.

    IF if_t100_message~t100key <> if_t100_message~default_textid.

      APPEND INITIAL LINE TO rt_return ASSIGNING FIELD-SYMBOL(<fs_s_return>).

      <fs_s_return>-type       = 'E'.
      <fs_s_return>-id         = if_t100_message~t100key-msgid.
      <fs_s_return>-number     = if_t100_message~t100key-msgno.
      <fs_s_return>-message_v1 = if_t100_message~t100key-attr1.
      <fs_s_return>-message_v2 = if_t100_message~t100key-attr2.
      <fs_s_return>-message_v3 = if_t100_message~t100key-attr3.
      <fs_s_return>-message_v4 = if_t100_message~t100key-attr4.

      IF gv_msgv1 IS NOT INITIAL
      OR gv_msgv2 IS NOT INITIAL
      OR gv_msgv3 IS NOT INITIAL
      OR gv_msgv4 IS NOT INITIAL.
        <fs_s_return>-message_v1 = gv_msgv1.
        <fs_s_return>-message_v2 = gv_msgv2.
        <fs_s_return>-message_v3 = gv_msgv3.
        <fs_s_return>-message_v4 = gv_msgv4.
      ENDIF.

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
