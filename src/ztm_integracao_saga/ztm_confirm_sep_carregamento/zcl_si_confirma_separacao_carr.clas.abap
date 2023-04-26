class ZCL_SI_CONFIRMA_SEPARACAO_CARR definition
  public
  create public .

public section.

  interfaces ZII_SI_CONFIRMA_SEPARACAO_CARR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SI_CONFIRMA_SEPARACAO_CARR IMPLEMENTATION.


  METHOD zii_si_confirma_separacao_carr~si_confirma_separacao_carregam.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg    TYPE ty_msg.

    TRY.
        NEW zcltm_saga_conf_sep_carreg( )->process_interface( input ).

      CATCH zcxtm_saga_conf_sep_carreg INTO DATA(lo_cx_erro).
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCX_FMT_CONFIRMA_SEPARACAO_CAR'
            bapireturn_tab       = lo_cx_erro->get_bapiretreturn( ).

      CATCH cx_root INTO DATA(lo_cx_root).
        ls_msg = lo_cx_root->get_text( ).

        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCX_FMT_CONFIRMA_SEPARACAO_CAR'
            bapireturn_tab       = NEW zcxtm_saga_conf_sep_carreg(
                                                              textid      = zcxtm_saga_conf_sep_carreg=>zcxtm_saga_conf_sep_carreg
                                                              gv_msgv1    = ls_msg-msgv1
                                                              gv_msgv2    = ls_msg-msgv2
                                                              gv_msgv3    = ls_msg-msgv3
                                                              gv_msgv4    = ls_msg-msgv4
                                                            )->get_bapiretreturn( ).

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
