class ZCL_SI_RECEBER_EVENTO_ROTA_GM definition
  public
  create public .

public section.

  interfaces ZII_SI_RECEBER_EVENTO_ROTA_GM .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SI_RECEBER_EVENTO_ROTA_GM IMPLEMENTATION.


  METHOD zii_si_receber_evento_rota_gm~si_receber_evento_rota_gm_in.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg    TYPE ty_msg.


    TRY.
        NEW zcltm_proc_event_in_greenmile( )->process_interface( is_input = input ).

      CATCH zcxtm_proc_event_in_greenmile INTO DATA(lo_cx_erro).
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCX_FMT_ROTA_GM'
            bapireturn_tab       = lo_cx_erro->get_bapiretreturn( ).

      CATCH cx_root INTO DATA(lo_cx_root).
        ls_msg = lo_cx_root->get_text( ).

        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCX_FMT_ROTA_GM'
            bapireturn_tab       = NEW zcxtm_proc_event_in_greenmile(
                                                              textid      = zcxtm_proc_event_in_greenmile=>zcxtm_proc_event_in_greenmile
                                                              gv_msgv1    = ls_msg-msgv1
                                                              gv_msgv2    = ls_msg-msgv2
                                                              gv_msgv3    = ls_msg-msgv3
                                                              gv_msgv4    = ls_msg-msgv4
                                                            )->get_bapiretreturn( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
