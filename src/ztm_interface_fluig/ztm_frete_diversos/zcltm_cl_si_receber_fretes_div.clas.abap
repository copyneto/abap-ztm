CLASS zcltm_cl_si_receber_fretes_div DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zcltm_ii_si_receber_fretes_div .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLTM_CL_SI_RECEBER_FRETES_DIV IMPLEMENTATION.


  METHOD zcltm_ii_si_receber_fretes_div~si_receber_fretes_diversos_in.
*** **** INSERT IMPLEMENTATION HERE **** ***
    TRY.

        NEW zcltm_frete_diversos( is_input = input ).

      CATCH zcxtm_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zcltm_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zcltm_cx_fmt_fretes_diversos
          EXPORTING
            standard = ls_erro.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
