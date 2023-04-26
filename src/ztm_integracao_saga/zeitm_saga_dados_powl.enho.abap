CLASS lcl_zeitm_saga_dados_powl DEFINITION DEFERRED.
CLASS /scmtms/cl_ui_pow_fd_tor_fo DEFINITION LOCAL FRIENDS lcl_zeitm_saga_dados_powl.
CLASS lcl_zeitm_saga_dados_powl DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA obj TYPE REF TO lcl_zeitm_saga_dados_powl.   "#EC NEEDED
    DATA core_object TYPE REF TO /scmtms/cl_ui_pow_fd_tor_fo . "#EC NEEDED
 INTERFACES  IPO_ZEITM_SAGA_DADOS_POWL.
    METHODS:
      constructor IMPORTING core_object
                              TYPE REF TO /scmtms/cl_ui_pow_fd_tor_fo OPTIONAL.
ENDCLASS.
CLASS lcl_zeitm_saga_dados_powl IMPLEMENTATION.
  METHOD constructor.
    me->core_object = core_object.
  ENDMETHOD.

  METHOD ipo_zeitm_saga_dados_powl~get_field_catalog.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods GET_FIELD_CATALOG
*"  importing
*"    !I_USERNAME type XUSER
*"    !I_APPLID type POWL_APPLID_TY
*"    !I_TYPE type POWL_TYPE_TY
*"    !I_LANGU type LANGU optional
*"    !I_SELCRIT_VALUES type RSPARAMS_TT
*"  changing
*"    !E_FIELDCAT_CHANGED type POWL_XFLAG_TY
*"    !E_VISIBLE_COLS_COUNT type I
*"    !E_VISIBLE_ROWS_COUNT type I
*"    !C_FIELDCAT type POWL_FIELDCAT_TTY
*"    !E_DEFAULT_TECHNICAL_COL type POWL_XFLAG_TY .
*"------------------------------------------------------------------------*

    READ TABLE c_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>) WITH TABLE KEY colid = 'ZZNR_SAGA'.
    IF sy-subrc EQ 0.
      <fs_fieldcat>-colpos         = 2.
      <fs_fieldcat>-technical_col  = abap_false.
      <fs_fieldcat>-enabled        = abap_true.
      <fs_fieldcat>-header_by_ddic = abap_true.
      <fs_fieldcat>-col_visible    = abap_true.
    ENDIF.

  ENDMETHOD.
METHOD IPO_ZEITM_SAGA_DADOS_POWL~GET_SEL_CRITERIA_FO.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods GET_SEL_CRITERIA_FO
*"  importing
*"    !I_TYPE type POWL_TYPE_TY
*"  changing
*"    !C_SELCRIT_DEFS type POWL_SELCRIT_TTY
*"    !C_DEFAULT_VALUES type RSPARAMS_TT .
*"------------------------------------------------------------------------*

    DATA: ls_selcrit_defs     LIKE LINE OF c_selcrit_defs,
          ls_default_values   LIKE LINE OF c_default_values,
          ls_selcrit_ddfields LIKE LINE OF me->core_object->mt_selcrit_ddfields,
          ls_pow_selcrit_mapp LIKE LINE OF me->core_object->mt_pow_selcrit_mapp.



    LOOP AT me->core_object->mt_selcrit_ddfields INTO ls_selcrit_ddfields.
      " Prepare out put structure
      CLEAR ls_selcrit_defs.
      CLEAR ls_default_values.
      ls_selcrit_defs-param_type = 'I'.
      ls_selcrit_defs-kind = 'S'.
      ls_selcrit_defs-allow_admin_change = abap_true.
      ls_selcrit_defs-ref_table = me->core_object->ms_pow_profile-pow_selcrit_structure_name.
      ls_selcrit_defs-ref_field = ls_selcrit_ddfields-fieldname.
      ls_selcrit_defs-crittext = ls_selcrit_ddfields-scrtext_m.
      ls_selcrit_defs-tooltip  = ls_selcrit_ddfields-scrtext_l.
      ls_selcrit_defs-datatype = ls_selcrit_ddfields-rollname.
      ls_selcrit_defs-allow_admin_change = abap_true.
      ls_selcrit_defs-param_type = /scmtms/if_ui_pow_const=>co_param_type-input_field.

      CASE ls_selcrit_ddfields-fieldname.

****************************************************
* General Data
****************************************************
        WHEN 'ZZNR_SAGA'.
          ls_selcrit_defs-selname = 'P0911'.
          ls_selcrit_defs-header = cl_wd_utilities=>get_otr_text_by_alias( '/SCMTMS/UI_CMN/GENERAL_DATA' ).
          ls_selcrit_defs-quicksearch_crit = abap_true.
*        ls_selcrit_defs-crittext = cl_wd_utilities=>get_otr_text_by_alias( '/SCMTMS/UI_CMN/BO_NAME_FRIGHTORDER ').

        WHEN OTHERS.
          CONTINUE.

      ENDCASE.

      ls_pow_selcrit_mapp-selname   = ls_selcrit_defs-selname.
      ls_pow_selcrit_mapp-fieldname = ls_selcrit_ddfields-fieldname.
      APPEND ls_pow_selcrit_mapp TO me->core_object->mt_pow_selcrit_mapp.
      APPEND ls_selcrit_defs TO c_selcrit_defs.
      IF ls_default_values IS NOT INITIAL.
        INSERT ls_default_values INTO TABLE c_default_values.
      ENDIF.

      " Fill mapping tables
      READ TABLE c_selcrit_defs
        WITH KEY selname = ls_selcrit_defs-selname
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        ls_pow_selcrit_mapp-selname   = ls_selcrit_defs-selname.
        ls_pow_selcrit_mapp-fieldname = ls_selcrit_ddfields-fieldname.
        APPEND ls_selcrit_defs TO c_selcrit_defs.
      ENDIF.

      READ TABLE me->core_object->mt_pow_selcrit_mapp
        WITH TABLE KEY selname COMPONENTS selname = ls_selcrit_defs-selname
        TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        ls_pow_selcrit_mapp-selname   = ls_selcrit_defs-selname.
        ls_pow_selcrit_mapp-fieldname = ls_selcrit_ddfields-fieldname.
        APPEND ls_pow_selcrit_mapp TO me->core_object->mt_pow_selcrit_mapp.
      ENDIF.

    ENDLOOP.

ENDMETHOD.
ENDCLASS.
