"!<p><h2>Execução de 'determination' no objeto /SCMTMS/TOR para criar parceiro 'Motorista' no sub nó 'PARTY'</h2></p>
"!<p><strong>Autor:</strong>Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong>4 de nov de 2021</p>
CLASS zcltm_motorista_tor DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      /bobf/if_frw_determination~execute REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLTM_MOTORISTA_TOR IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_root        TYPE /scmtms/t_tor_root_k,
          lt_party       TYPE /scmtms/t_tor_party_k,
          lt_aux         TYPE STANDARD TABLE OF /scmtms/s_tor_party_k,
          ls_party       TYPE /scmtms/s_tor_party_k,
          lt_fieldchange TYPE /bobf/t_frw_name.



    CLEAR: eo_message,
           et_failed_key.

    " Mensagens de validação causam dump durante execução do job de saída de mercadorias p/ entregas
    CHECK sy-batch IS INITIAL.

    "Ler a Ordem de Frete
    io_read->retrieve( EXPORTING iv_node = /scmtms/if_tor_c=>sc_node-root
                                 it_key  = it_key
                       IMPORTING et_data = lt_root ).

    "Seleção dos parceiros
    io_read->retrieve_by_association( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
                                                it_key         = it_key
                                                iv_association = /scmtms/if_tor_c=>sc_association-root-party
                                                iv_fill_data   = abap_true
                                      IMPORTING et_data        = lt_party ).

    DATA(ls_root) = lt_root[ 1 ].

    IF ls_root-zz_motorista IS NOT INITIAL. "Caso haja motorista no nó root
      TRY.
          "Verificar se o motorista já faz parte dos parceiros
*          DATA(ls_party) = lt_party[ party_id = ls_root-zz_motorista ].

          SELECT
            SINGLE partner
          FROM but0id
          WHERE
            partner = @ls_root-zz_motorista
            AND type = 'ZCNH'
            AND valid_date_from <= @sy-datum
            AND valid_date_to  >= @sy-datum
          INTO @DATA(lv_partner).

          IF sy-subrc = 0.

* Valida se o CNH está próximo de vencer
            SELECT
             SINGLE valid_date_to
           FROM but0id
           WHERE
             partner = @ls_root-zz_motorista
             AND type = 'ZCNH'
           INTO @DATA(lv_data).

            IF sy-subrc IS INITIAL.

              DATA(lv_data_aux) = lv_data.
              DATA(lv_data_dia) = sy-datum.

              CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                EXPORTING
                  date      = lv_data
                  days      = 30
                  months    = 00
                  signum    = '-'
                  years     = 00
                IMPORTING
                  calc_date = lv_data_aux.

              DATA(lr_data_range) = VALUE rsdsselopt_t( sign  = 'I'  option = 'BT'
                                                       ( low  = lv_data_aux  high = lv_data )  ).

              IF lv_data_dia IN lr_data_range.

                eo_message = /bobf/cl_frw_factory=>get_message( ).

                DATA(ls_message) = VALUE symsg( msgid = 'ZTM_MOTORISTA' msgno = '001' msgty = 'W' msgv1 = lv_data  ).
                eo_message->add_message( EXPORTING is_msg  = ls_message "Aviso: CNH próxima do vencimento. Data vencimento =
                                                   iv_node = is_ctx-node_key
                                                   iv_key  = ls_root-root_key  ).

              ENDIF.
            ENDIF.

            lt_aux = lt_party.
            SORT lt_aux BY party_rco.
            READ TABLE lt_aux
            WITH KEY party_rco  = 'YM'
            BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_aux>).
            IF sy-subrc = 0.
              ls_party = <fs_aux>.
              ls_party-party_id  = ls_root-zz_motorista.
              lt_fieldchange = VALUE #( ( /scmtms/if_tor_c=>sc_node_attribute-party-party_id )
                                        ( /scmtms/if_tor_c=>sc_node_attribute-party-party_uuid )
                                      ).

            ELSE.
              "Se não encontrar o parceiro (motorista), criar
              ls_party-key            = /bobf/cl_frw_factory=>get_new_key( ).
              ls_party-root_key       = it_key[ 1 ]-key.
              ls_party-parent_key     = it_key[ 1 ]-key.
              ls_party-party_rco      = 'YM'.
              ls_party-set_by_service = 'MA'.
              ls_party-party_id       = ls_root-zz_motorista.

            ENDIF.

            SELECT SINGLE partner_guid FROM but000
            INTO @ls_party-party_uuid
            WHERE partner = @ls_root-zz_motorista.
            IF lt_fieldchange IS INITIAL.
              io_modify->create( EXPORTING iv_node            = /scmtms/if_tor_c=>sc_node-party
                                           iv_key             = ls_party-key
                                           is_data            = REF #( ls_party )
                                           iv_assoc_key       = /scmtms/if_tor_c=>sc_association-root-party
                                           iv_source_node_key = /scmtms/if_tor_c=>sc_node-root
                                           iv_source_key      = it_key[ 1 ]-key
                                 IMPORTING ev_key             = DATA(lv_key_created) ).
            ELSE.
              io_modify->update(
                                   EXPORTING
                                     iv_node           = /scmtms/if_tor_c=>sc_node-party                " Node
                                     iv_key            = ls_party-key
*                                   iv_root_key       = ls_root-root_key
                                     is_data           =  REF #( ls_party )
                                     it_changed_fields = lt_fieldchange " List of Names (e.g. Fieldnames)
                                 ).
            ENDIF.

          ELSE.
            "motorista com CNH vencida
            eo_message = /bobf/cl_frw_factory=>get_message( ).


            ls_message = VALUE symsg( msgid = 'ZTM_MOTORISTA' msgno = '000' msgty = 'E' ).
            eo_message->add_message( EXPORTING is_msg  = ls_message "ERRO: CNH vencida
                                               iv_node = is_ctx-node_key
                                               iv_key  = ls_root-root_key  ).

*            INSERT VALUE #( key = ls_root-root_key ) INTO TABLE et_failed_key.
            RETURN.

*            DATA(lo_erro) = NEW zcxtm_motorista_tor(
*                                                        symptom  = /bobf/if_frw_message_symptoms=>co_bo_inconsistency
*                                                        lifetime = /bobf/if_frw_c=>sc_lifetime_set_by_bopf
*                                                        previous = NEW zcxtm_msg_motorista(
*                                                                                            textid = zcxtm_msg_motorista=>zvalid_doc_invalida
*                                                                                            gv_msgv1 = 'CNH'
*                                                                                           )
*                                                        ms_origin_location  = VALUE #(
*                                                                                          bo_key = is_ctx-bo_key
*                                                                                       node_key = is_ctx-node_key
*                                                                                       key = ls_root-root_key
*                                                                                     )
*                                                      ).
*            eo_message->add_cm( EXPORTING
*                                   io_message = lo_erro ).
*      eo_message->add_message(
*        EXPORTING
*          is_msg       = VALUE #( msgty = sy-msgty
*                                  msgid = sy-msgid
*                                  msgno = sy-msgno
*                                  msgv1 = sy-msgv1
*                         )
*          iv_node      = is_ctx-node_key
*          iv_key       = ls_root-root_key
*      ).
*
*    CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
*      EXPORTING
*        iv_key      = ls_root-root_key
*        iv_node_key = /scmtms/if_tor_c=>sc_node-root
*      CHANGING
*        co_message  = eo_message.

          ENDIF.

        CATCH cx_sy_itab_line_not_found INTO DATA(lo_cx_erro).
*          INSERT VALUE #( key = ls_root-root_key ) INTO TABLE et_failed_key.

*          eo_message->add_cm(
*            NEW zcxtm_motorista_tor(
*                                    symptom       = /bobf/if_frw_message_symptoms=>co_bo_inconsistency
*                                    lifetime = /bobf/if_frw_c=>sc_lifetime_set_by_bopf
*                                    previous                = lo_cx_erro
*                                    ms_origin_location      = VALUE #( bo_key = is_ctx-bo_key
*                                                                        node_key = is_ctx-node_key
*                                                                        key = ls_root-root_key
*                                                                     )
*                                  )
*          ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
