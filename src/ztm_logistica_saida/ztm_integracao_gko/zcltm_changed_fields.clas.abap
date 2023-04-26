CLASS zcltm_changed_fields DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_common_badi .
    INTERFACES if_badi_interface .
    INTERFACES /scmtms/if_tor_cc_changes_det .

  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_changed_fields IMPLEMENTATION.

  METHOD /scmtms/if_tor_cc_changes_det~det_custom_changes.

    DATA: lt_execucao       TYPE /scmtms/t_tor_exec_k,
          lr_fields         TYPE RANGE OF string,
          lv_relevant_field TYPE abap_bool.

    DATA(lt_keys) = VALUE /bobf/t_frw_key( FOR <fs_key> IN it_tor_root USING KEY tor_cat WHERE ( tor_cat = 'TO' ) ( key = <fs_key>-key ) ).

    "Verificar se o evento "partiu" está definido.
    io_read->retrieve_by_association(
      EXPORTING
        iv_node                 = /scmtms/if_tor_c=>sc_node-root
        it_key                  = lt_keys
        iv_association          = /scmtms/if_tor_c=>sc_association-root-exec_valid
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_execucao ).
    CHECK line_exists( lt_execucao[ KEY event event_code = 'DEPARTURE' ] ).

    "Verificar a relevância das alterações para envio ao GKO
    io_read->compare(
      EXPORTING
        iv_node_key        = /scmtms/if_tor_c=>sc_node-root
        it_key             = lt_keys
        iv_fill_attributes = abap_true
        iv_scope           = /bobf/if_frw_c=>sc_scope_substructure
      IMPORTING
        eo_change          = DATA(lo_changes) ).
    CHECK lo_changes IS BOUND.

    lo_changes->get_changes(
      IMPORTING
        et_change       = DATA(lt_changes) ).

    "Definir campos sensíveis ao envio para GKO
    lr_fields = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZZ1_COND_EXPED' )
                         ( sign = 'I' option = 'EQ' low = 'ZZ1_TIPO_EXPED' ) ).

    LOOP AT lt_changes ASSIGNING FIELD-SYMBOL(<fs_change>).
      LOOP AT <fs_change>-attributes ASSIGNING FIELD-SYMBOL(<fs_attr>)
                                     WHERE table_line IN lr_fields.
        lv_relevant_field = abap_true.
        EXIT.
      ENDLOOP.
    ENDLOOP.

    "Em caso de relevância, ativar flag para tratamento pelo controlador de alterações
    IF lv_relevant_field = abap_true.
      ASSIGN ct_modification[ change_mode = 'U' ] TO FIELD-SYMBOL(<fs_mod>).
      IF <fs_mod> IS ASSIGNED.
        ASSIGN <fs_mod>-data->* TO FIELD-SYMBOL(<fs_data>).
        IF <fs_data> IS ASSIGNED.
          ASSIGN COMPONENT 'ZZRELEVANTE_GKO' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_relevante>).
          IF <fs_relevante> IS ASSIGNED.
            <fs_relevante> = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD /scmtms/if_tor_cc_changes_det~det_date_and_loc_changes.
    RETURN.
  ENDMETHOD.


  METHOD /scmtms/if_tor_cc_changes_det~det_quantity_changes.
    RETURN.
  ENDMETHOD.


  METHOD /scmtms/if_common_badi~set_badi_work_mode.

    ASSIGN ct_work_mode[ intf_method_name = 'DET_CUSTOM_CHANGES' ] TO FIELD-SYMBOL(<fs_work_mode>).
    IF <fs_work_mode> IS ASSIGNED.
      <fs_work_mode>-badi_work_mode = 'M'. "Modificar resultados da lógica padrão com lógica do cliente
    ENDIF.
  ENDMETHOD.
ENDCLASS.
