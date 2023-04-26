CLASS lcl_TipoTransporte DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTTM_MDF_TPTRANS'.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR TipoTransporte~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR TipoTransporte RESULT result.

ENDCLASS.

CLASS lcl_TipoTransporte IMPLEMENTATION.

  METHOD authorityCreate.
    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_tm_mdf_tipo_transporte IN LOCAL MODE
        ENTITY TipoTransporte
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zcltm_auth_ztmmtable=>create( gc_table ) = abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-tipotransporte.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-tipotransporte.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-categoria = if_abap_behv=>mk-on )
          TO reported-tipotransporte.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_authorizations.
    READ ENTITIES OF zi_tm_mdf_tipo_transporte IN LOCAL MODE
        ENTITY TipoTransporte
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

ENDCLASS.
