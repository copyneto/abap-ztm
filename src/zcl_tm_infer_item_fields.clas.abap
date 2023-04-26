CLASS zcl_tm_infer_item_fields DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_wzre_infer_item_fields_badi .

    DATA gc_param_kostl TYPE ztca_param_par-chave1 VALUE 'KOSTL_BUKRS_FRETE' ##NO_TEXT.
    DATA gc_param_modulo TYPE ztca_param_par-modulo VALUE 'TM' ##NO_TEXT.
protected section.
private section.
ENDCLASS.



CLASS ZCL_TM_INFER_ITEM_FIELDS IMPLEMENTATION.


  METHOD if_wzre_infer_item_fields_badi~infer_fields.
    DATA: lr_param TYPE RANGE OF kostl.
    DATA(lo_config) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_config->m_get_range(
          EXPORTING
            iv_modulo = gc_param_modulo
            iv_chave1 = gc_param_kostl
          IMPORTING
            et_range  = lr_param ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

    CHECK lr_param IS NOT INITIAL.
    READ TABLE lr_param INTO DATA(ls_param) WITH KEY low = cs_header_fields-bukrs.
    cs_item_fields-kostl = ls_param-high.

    IF is_input_item-division IS INITIAL.
      SELECT SINGLE gsber
        INTO cs_item_fields-gsber
        FROM t134g
        WHERE werks EQ cs_item_fields-werks.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
