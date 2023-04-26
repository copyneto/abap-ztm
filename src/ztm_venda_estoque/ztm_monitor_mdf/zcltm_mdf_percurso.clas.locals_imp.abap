CLASS lcl_Percurso DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Percurso RESULT result.


    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Percurso~authorityCreate.


    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTTM_MDF_PERC'.

ENDCLASS.

CLASS lcl_Percurso IMPLEMENTATION.

  METHOD get_authorizations.

    READ ENTITIES OF zi_tm_mdf_percurso IN LOCAL MODE
        ENTITY Percurso
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

  METHOD authoritycreate.
    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_tm_mdf_percurso IN LOCAL MODE
        ENTITY Percurso
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zcltm_auth_ztmmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-percurso.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-percurso.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-percurso.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
