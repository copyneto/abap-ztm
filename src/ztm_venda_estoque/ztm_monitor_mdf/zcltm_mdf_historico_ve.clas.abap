CLASS zcltm_mdf_historico_ve DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_mdf_historico_ve IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT CONV string( 'MSGID' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'MSGNO' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'MSGV1' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'MSGV2' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'MSGV3' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'MSGV4' ) INTO TABLE et_Requested_orig_elements[].

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_historico TYPE STANDARD TABLE OF zi_tm_mdf_historico.

    lt_historico = CORRESPONDING #( it_original_data ).

* --------------------------------------------------------------------
* Recupera informações
* --------------------------------------------------------------------
    LOOP AT lt_historico REFERENCE INTO DATA(ls_historico).

      IF ls_historico->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_historico->msgid
                lang      = sy-langu
                no        = ls_historico->msgno
                v1        = ls_historico->msgv1
                v2        = ls_historico->msgv2
                v3        = ls_historico->msgv3
                v4        = ls_historico->msgv4
              IMPORTING
                msg       = ls_historico->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_historico->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

* --------------------------------------------------------------------
* Transfere dados convertidos
* --------------------------------------------------------------------
    ct_calculated_data = CORRESPONDING #( lt_historico ).

  ENDMETHOD.

ENDCLASS.
