CLASS zcltm_cl_si_processar_intelisp DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zcltm_ii_si_processar_intelisp .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_cl_si_processar_intelisp IMPLEMENTATION.


  METHOD zcltm_ii_si_processar_intelisp~si_processar_intelispost_statu.

    TRY.

        NEW zcltm_status_operacao( is_input = input ).

      CATCH zcxtm_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zcltm_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zcltm_cx_fmt_fretes_diversos
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
