"!<p><h2>Regra de validação da ordem de frete:</h2></p>
"!<p><h1>Se o MDF-e estiver autorizado, não pode haver alterações</h1></p>
"!<p><strong>Autor:</strong>Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong>19 de nov de 2021</p>
CLASS zcltm_mdf_tor DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_v_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_validation~execute REDEFINITION.
ENDCLASS.



CLASS zcltm_mdf_tor IMPLEMENTATION.

  METHOD /bobf/if_frw_validation~execute.

    DATA: lt_root TYPE /scmtms/t_tor_root_k.

    io_read->retrieve( EXPORTING iv_node      = /scmtms/if_tor_c=>sc_node-root
                                 it_key       = it_key
                                 iv_fill_data = abap_true
                       IMPORTING et_data      = lt_root ).

    ASSIGN lt_root[ 1 ] TO FIELD-SYMBOL(<fs_root>).
    IF <fs_root>        IS ASSIGNED    AND
       <fs_root>-zz_mdf IS NOT INITIAL AND
       <fs_root>-zz_code = '100'.

      "Não pode haver modificações se o status do MDF-e for aprovado pela Sefaz (100)
      IF eo_message IS NOT BOUND.
        eo_message = /bobf/cl_frw_factory=>get_message( ).
      ENDIF.

      DATA(ls_message) = VALUE symsg( msgid = 'ZTM_MDF' msgno = '037' msgty = 'E' ).
      eo_message->add_message( EXPORTING is_msg  = ls_message "Erro: Ordem de frete tem MDF-e autorizado
                                         iv_node = is_ctx-node_key
                                         iv_key  = <fs_root>-key ).

      et_failed_key = VALUE #( ( key = <fs_root>-key ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
