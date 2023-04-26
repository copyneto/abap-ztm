CLASS zcltm_conv_cfop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS conv_cfop
      IMPORTING
        iv_cfop        TYPE logbr_cfopcode
      RETURNING
        VALUE(rv_cfop) TYPE logbr_cfopcode.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_conv_cfop IMPLEMENTATION.

  METHOD conv_cfop.

    CALL FUNCTION 'CONVERSION_EXIT_CFOBR_INPUT'
      EXPORTING
        input  = iv_cfop
      IMPORTING
        output = rv_cfop.

  ENDMETHOD.

ENDCLASS.
