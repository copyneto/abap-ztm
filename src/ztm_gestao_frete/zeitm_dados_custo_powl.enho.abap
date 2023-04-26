CLASS LCL_ZEITM_DADOS_CUSTO_POWL DEFINITION DEFERRED.
CLASS /SCMTMS/CL_UI_POW_FD_SFIR DEFINITION LOCAL FRIENDS LCL_ZEITM_DADOS_CUSTO_POWL.
CLASS LCL_ZEITM_DADOS_CUSTO_POWL DEFINITION.
PUBLIC SECTION.
CLASS-DATA OBJ TYPE REF TO LCL_ZEITM_DADOS_CUSTO_POWL. "#EC NEEDED
DATA CORE_OBJECT TYPE REF TO /SCMTMS/CL_UI_POW_FD_SFIR . "#EC NEEDED
 INTERFACES  IPO_ZEITM_DADOS_CUSTO_POWL.
  METHODS:
   CONSTRUCTOR IMPORTING CORE_OBJECT
     TYPE REF TO /SCMTMS/CL_UI_POW_FD_SFIR OPTIONAL.
ENDCLASS.
CLASS LCL_ZEITM_DADOS_CUSTO_POWL IMPLEMENTATION.
METHOD CONSTRUCTOR.
  ME->CORE_OBJECT = CORE_OBJECT.
ENDMETHOD.

METHOD IPO_ZEITM_DADOS_CUSTO_POWL~GET_FIELD_CATALOG.
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

  READ TABLE c_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>) WITH TABLE KEY colid = 'ZZACCKEY'.
  IF sy-subrc EQ 0.
    <fs_fieldcat>-technical_col  = abap_false.
    <fs_fieldcat>-enabled        = abap_true.
    <fs_fieldcat>-header_by_ddic = abap_true.
    <fs_fieldcat>-col_visible    = abap_true.
  ENDIF.

ENDMETHOD.
ENDCLASS.
