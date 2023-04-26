class ZCLTM_MONITOR_MDF_AUT definition
  public
  final
  create public .

public section.

  constants:
    BEGIN OF gc_actvt,
                 criar     TYPE char02 VALUE '01',
                 modificar TYPE char02 VALUE '02',
                 imprimir  TYPE char02 VALUE '04',
                 eliminar  TYPE char02 VALUE '06',
               END OF gc_actvt .
  constants:
    BEGIN OF gc_obj,
                 grupo_a TYPE xuobject VALUE 'ZTMMDFE_A',
                 grupo_b TYPE xuobject VALUE 'ZTMMDFE_B',
                 grupo_c TYPE xuobject VALUE 'ZTMMDFE_C',
               END OF gc_obj .

  class-methods CHECK_AUT
    importing
      !IV_OBJ type XUOBJECT
      !IV_ACTVT type CHAR2
    returning
      value(RT_RETURN) type BAPIRET2_TAB .
  class-methods FORMAT_MESSAGE
    importing
      !IV_CHANGE_ERROR_TYPE type FLAG optional
      !IV_CHANGE_WARNING_TYPE type FLAG optional
    changing
      !CT_RETURN type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_MONITOR_MDF_AUT IMPLEMENTATION.


  METHOD check_aut.

    AUTHORITY-CHECK OBJECT iv_obj
      ID 'ACTVT' FIELD iv_actvt.    "Alteração

    IF sy-subrc IS NOT INITIAL.
      rt_return[] = VALUE #( BASE rt_return ( type = if_xo_const_message=>error id = 'ZTM_MONITOR_MDF' number = '119' ) ).
      format_message( CHANGING ct_return = rt_return ).
    ENDIF.

  ENDMETHOD.


  METHOD format_message.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E' AND iv_change_error_type IS NOT INITIAL
                                THEN 'I'
                                WHEN ls_return->type EQ 'W' AND iv_change_warning_type IS NOT INITIAL
                                THEN 'I'
                                ELSE ls_return->type ).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
