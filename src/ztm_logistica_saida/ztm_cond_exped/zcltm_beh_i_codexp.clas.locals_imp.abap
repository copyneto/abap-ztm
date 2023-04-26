CLASS lhc_Condexped DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTTM_COND_EXPED'.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _Condexped RESULT result.
    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR _Condexped~authoritycreate.

ENDCLASS.

CLASS lhc_Condexped IMPLEMENTATION.

  METHOD get_authorizations.
    READ ENTITIES OF zi_cond_exped IN LOCAL MODE
        ENTITY _Condexped
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zcltm_auth_ztmmtable=>update( gc_table ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zcltm_auth_ztmmtable=>delete( gc_table ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky          = <fs_data>-%tky
                      %update       = lv_update
                      %delete       = lv_delete )
             TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD authorityCreate.
    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_cond_exped IN LOCAL MODE
        ENTITY _Condexped
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zcltm_auth_ztmmtable=>create( gc_table ) = abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-_condexped.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_condexped.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-CondExped = if_abap_behv=>mk-on )
          TO reported-_condexped.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
