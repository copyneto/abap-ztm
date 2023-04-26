CLASS zcltm_det_contr_fields_badi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_wzre_det_contr_fields_badi .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_det_contr_fields_badi IMPLEMENTATION.


  METHOD if_wzre_det_contr_fields_badi~determine_ab_control_fields.

    CONSTANTS:
      BEGIN OF lc_param,
        modulo TYPE ztca_param_par-modulo VALUE 'TM',
        chave1 TYPE ztca_param_par-chave1 VALUE 'STO_FREIGHT_EXPENSE',
      END OF lc_param,

      BEGIN OF lc_param_bsart,
        modulo TYPE ztca_param_par-modulo VALUE 'TM',
        chave1 TYPE ztca_param_par-chave1 VALUE 'STO_FREIGHT_EXPENSE',
        chave2 TYPE ztca_param_par-chave2 VALUE 'BSART',
      END OF lc_param_bsart.

    DATA: lr_bsart    TYPE RANGE OF ekko-bsart,
          lv_custdesp TYPE flag.


    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        " Recupera tipo do pedido
        lo_param->m_get_range( EXPORTING iv_modulo = lc_param_bsart-modulo
                                         iv_chave1 = lc_param_bsart-chave1
                                         iv_chave2 = lc_param_bsart-chave2
                               IMPORTING et_range  = lr_bsart ).

        " Parâmetro de liga / desliga
        lo_param->m_get_single( EXPORTING iv_modulo = lc_param-modulo
                                          iv_chave1 = lc_param-chave1
                                IMPORTING ev_param  = lv_custdesp ).
      CATCH cx_root.
    ENDTRY.

    IF lv_custdesp IS INITIAL.
      RETURN.
    ENDIF.

    IF lr_bsart[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT COUNT(*)
      FROM ekko
      WHERE ebeln EQ @is_posting_item-ab_item-wbelnv
        AND bsart IN @lr_bsart.   " 'UB'

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    ct_ab_control_fields = VALUE #( ( use_case      = '31'
                                      ext_post_type = 'EXSP'
                                      kappl         = if_wzre_posting_const=>kappl-purchase
                                      ab_doc_cat    = if_wzre_posting_const=>agency_doc_category-invoice ) ).

  ENDMETHOD.

ENDCLASS.
