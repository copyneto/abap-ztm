***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: TM - User exit liberação ABD                           *
*** AUTOR    : Luís Gustavo Schepp - META                             *
*** FUNCIONAL: Jefferson Gomes de Alcantara- META                     *
*** DATA     : 30.03.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 30.03.2022 | Luís Gustavo Schepp   | Desenvolvimento inicial      *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZXLFXU06
*&---------------------------------------------------------------------*
  CONSTANTS: BEGIN OF lc_param,
               modulo TYPE ztca_param_par-modulo VALUE 'TM',
               chave1 TYPE ztca_param_par-chave1 VALUE 'ABD_COPA',
               chave2 TYPE ztca_param_par-chave2 VALUE 'TIPO_PEDIDO',
               busidm TYPE buzid VALUE 'M',
             END OF lc_param.

  DATA lt_tp_ped TYPE wrf_pbas_bsart_rtty.


  IF NOT i_komlfp-wbelnv IS INITIAL.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                         iv_chave1 = lc_param-chave1
                                         iv_chave2 = lc_param-chave2
                               IMPORTING et_range  = lt_tp_ped ).

        SELECT COUNT( * )
          FROM ekko
          WHERE ebeln EQ @i_komlfp-wbelnv
            AND bsart IN @lt_tp_ped.
        IF sy-subrc EQ 0.
          e_accit-buzid = lc_param-busidm.
        ENDIF.
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDIF.
