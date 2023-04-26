CLASS lcl_Execucao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ Execucao RESULT result.

    METHODS rba_Cockpit FOR READ
      IMPORTING keys_rba FOR READ Execucao\_Cockpit FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lcl_Execucao IMPLEMENTATION.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD rba_Cockpit.
    RETURN.
  ENDMETHOD.

ENDCLASS.
