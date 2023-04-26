class ZCL_SI_GRAVAR_EMBALAGEM_IN definition
  public
  create public .

public section.

  interfaces ZII_SI_GRAVAR_EMBALAGEM_IN .
protected section.
private section.
ENDCLASS.



CLASS ZCL_SI_GRAVAR_EMBALAGEM_IN IMPLEMENTATION.


  METHOD zii_si_gravar_embalagem_in~si_gravar_embalagem_in.

    DATA(lo_cubagem) = NEW zcltm_integrar_medida_cubagem( ).

    TRY.

        lo_cubagem->execute(
          EXPORTING
            it_lista   = input-mt_embalagem ).

      CATCH zcxtm_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE z195exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE z195cx_fmt_embalagem
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
