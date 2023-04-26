class ZCL_SI_RECEBER_ORDEM_FRETE_IN definition
  public
  create public .

public section.

  interfaces ZII_SI_RECEBER_ORDEM_FRETE_IN .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SI_RECEBER_ORDEM_FRETE_IN IMPLEMENTATION.


  METHOD zii_si_receber_ordem_frete_in~si_receber_ordem_frete_in.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg  TYPE ty_msg,
          lt_erro TYPE STANDARD TABLE OF bapiret2.

    TRY.
        DATA(lo_of) =  NEW zcltm_create_of_saga( ).

        lo_of->process_interface( input ).
        DATA(lt_aux) = lo_of->get_message( ).
        SORT lt_aux BY type.
        READ TABLE lt_aux
        WITH KEY type = 'E'
        BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          LOOP AT lt_aux ASSIGNING FIELD-SYMBOL(<fs_aux>).
            IF <fs_aux>-type = 'E'.
              APPEND INITIAL LINE TO lt_erro ASSIGNING FIELD-SYMBOL(<fs_erro>).
              <fs_erro> = <fs_aux>.
            ENDIF.
          ENDLOOP.
        ENDIF.

      CATCH zcxtm_create_of_saga INTO DATA(lo_cx_erro).
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCX_FMT_FRETE_ORDEM'
            bapireturn_tab       = lo_cx_erro->get_bapiretreturn( ).

      CATCH cx_root INTO DATA(lo_cx_root).
        ls_msg = lo_cx_root->get_text( ).

        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCX_FMT_FRETE_ORDEM'
            bapireturn_tab       = NEW zcxtm_create_of_saga(
                                                              textid      = zcxtm_create_of_saga=>zcxtm_create_of_saga
                                                              gv_msgv1    = ls_msg-msgv1
                                                              gv_msgv2    = ls_msg-msgv2
                                                              gv_msgv3    = ls_msg-msgv3
                                                              gv_msgv4    = ls_msg-msgv4
                                                            )->get_bapiretreturn( ).
    ENDTRY.

    IF lt_erro IS NOT INITIAL.
      CALL METHOD cl_proxy_fault=>raise
        EXPORTING
          exception_class_name = 'ZCX_FMT_FRETE_ORDEM'
          bapireturn_tab       = lt_erro.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
