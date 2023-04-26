CLASS lcl_zeitm_nome_motorista DEFINITION DEFERRED.
CLASS /scmtms/cl_ui_viewexit_tor DEFINITION LOCAL FRIENDS lcl_zeitm_nome_motorista.
CLASS lcl_zeitm_nome_motorista DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA obj TYPE REF TO lcl_zeitm_nome_motorista.    "#EC NEEDED
    DATA core_object TYPE REF TO /scmtms/cl_ui_viewexit_tor . "#EC NEEDED
 INTERFACES  IPO_ZEITM_NOME_MOTORISTA.
    METHODS:
      constructor IMPORTING core_object
                              TYPE REF TO /scmtms/cl_ui_viewexit_tor OPTIONAL.
ENDCLASS.


CLASS lcl_zeitm_nome_motorista IMPLEMENTATION.
  METHOD constructor.
    me->core_object = core_object.
  ENDMETHOD.

  METHOD ipo_zeitm_nome_motorista~get_gendata_text.
*"------------------------------------------------------------------------*
*" Declaration of POST-method, do not insert any comments here please!
*"
*"methods GET_GENDATA_TEXT
*"  changing
*"    !CS_DATA type DATA
*"    !CV_DATA_CHANGED type BOOLE_D .
*"------------------------------------------------------------------------*

    ASSIGN COMPONENT 'ZZ_MOTORISTA' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_cod_driver>).
    IF <fs_cod_driver> IS ASSIGNED.
      ASSIGN COMPONENT 'NOMEMOTORISTA' OF  STRUCTURE cs_data TO FIELD-SYMBOL(<fs_driver_name>).
      IF <fs_driver_name> IS ASSIGNED.
        IF <fs_cod_driver> IS INITIAL.
          CLEAR <fs_driver_name>.

        ELSE.
          SELECT SINGLE nomemotorista
            FROM zi_tm_motorista_sh
            WHERE codigomotorista = @<fs_cod_driver>
            INTO @<fs_driver_name>.
        ENDIF.
      ENDIF.
    ENDIF.


    ASSIGN COMPONENT 'ZZ1_COND_EXPED' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_cod_expe>).
    IF <fs_cod_expe> IS ASSIGNED.
      ASSIGN COMPONENT 'DESC_COND_EXPED' OF  STRUCTURE cs_data TO FIELD-SYMBOL(<fs_cod_expe_name>).
      IF <fs_cod_expe_name> IS ASSIGNED.
        IF <fs_cod_expe> IS INITIAL.
          CLEAR <fs_cod_expe_name>.

        ELSE.
          SELECT SINGLE descricao
            FROM zttm_cond_exped
            WHERE cond_exped = @<fs_cod_expe>
            INTO @<fs_cod_expe_name>.
        ENDIF.
      ENDIF.
    ENDIF.


    ASSIGN COMPONENT 'ZZ1_TIPO_EXPED' OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_tipo_expe>).
    IF <fs_tipo_expe> IS ASSIGNED.
      ASSIGN COMPONENT 'DESC_TIPO_EXPED' OF  STRUCTURE cs_data TO FIELD-SYMBOL(<fs_tipo_expe_name>).
      IF <fs_tipo_expe_name> IS ASSIGNED.
        IF <fs_tipo_expe> IS INITIAL.
          CLEAR <fs_tipo_expe_name>.

        ELSE.
          SELECT SINGLE descricao
            FROM zttm_tipo_exped
            WHERE tipo_exped = @<fs_tipo_expe>
            INTO @<fs_tipo_expe_name>.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
