CLASS zcltm_invoicing_status DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .

    CLASS-METHODS get_data
      IMPORTING is_ctx                 TYPE /bobf/s_frw_ctx_det
                it_key                 TYPE /bobf/t_frw_key
                io_read                TYPE REF TO /bobf/if_frw_read
                io_modify              TYPE REF TO /bobf/if_frw_modify
      EXPORTING eo_tor_srv_mgr         TYPE REF TO /bobf/if_tra_service_manager
                eo_sfir_srv_mgr        TYPE REF TO /bobf/if_tra_service_manager
                es_cockpit             TYPE zttm_gkot001
                es_tor_key             TYPE /bobf/s_frw_key
                es_fsd_data            TYPE /scmtms/s_sfir_root_k
                et_tcc                 TYPE /scmtms/t_tcc_root_k
                ev_do_key              TYPE /bobf/conf_key
                ev_bo_do_assoc_key     TYPE /bobf/conf_key
                ev_it_chrg_it_node_key TYPE /bobf/obm_node_key
                ev_it_chrg_el_node_key TYPE /bobf/obm_node_key
                es_ctx                 TYPE /scmtms/cl_tcc_do_helper=>ts_ctx
                et_charge_item         TYPE /scmtms/t_tcc_chrgitem_k
                et_do_root             TYPE /scmtms/t_tcc_root_k
                et_charge_element      TYPE /scmtms/t_tcc_trchrg_element_k.

    METHODS execute_cancel
      IMPORTING io_tor_srv_mgr         TYPE REF TO /bobf/if_tra_service_manager
                is_fsd_data            TYPE /scmtms/s_sfir_root_k
                is_cockpit             TYPE zttm_gkot001
                it_charge_element      TYPE /scmtms/t_tcc_trchrg_element_k
                iv_it_chrg_it_node_key TYPE /bobf/obm_node_key
                iv_it_chrg_el_node_key TYPE /bobf/obm_node_key
      EXPORTING eo_message             TYPE REF TO /bobf/if_frw_message
                et_failed_key          TYPE /bobf/t_frw_key
                et_return              TYPE bapiret2_t.

    CLASS-METHODS get_message
      IMPORTING io_message TYPE REF TO /bobf/if_frw_message
      EXPORTING et_return  TYPE bapiret2_t
      CHANGING  ct_return  TYPE bapiret2_t OPTIONAL.

    CLASS-METHODS update_cockpit
      IMPORTING iv_acckey    TYPE zttm_gkot001-acckey
                iv_tpprocess TYPE ze_gko_tpprocess DEFAULT zcltm_gko_process=>gc_tpprocess-automatico
                iv_status    TYPE zttm_gkot001-codstatus
                iv_reprocess TYPE flag DEFAULT abap_false
      EXPORTING et_return    TYPE bapiret2_t.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcltm_invoicing_status IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_return    TYPE bapiret2_t,
          lv_status    TYPE zttm_gkot001-codstatus,
          lv_reprocess TYPE flag.

* ---------------------------------------------------------------------------
* Recupera dados da Ordem de Frete
* ---------------------------------------------------------------------------
    me->get_data( EXPORTING is_ctx                 = is_ctx
                            it_key                 = it_key
                            io_read                = io_read
                            io_modify              = io_modify
                  IMPORTING eo_tor_srv_mgr         = DATA(lo_tor_srv_mgr)
                            es_cockpit             = DATA(ls_cockpit)
                            es_tor_key             = DATA(ls_tor_key)
                            es_fsd_data            = DATA(ls_fsd_data)
                            et_tcc                 = DATA(lt_tcc)
                            ev_do_key              = DATA(lv_do_key)
                            ev_bo_do_assoc_key     = DATA(lv_bo_do_assoc_key)
                            ev_it_chrg_it_node_key = DATA(lv_it_chrg_it_node_key)
                            ev_it_chrg_el_node_key = DATA(lv_it_chrg_el_node_key)
                            es_ctx                 = DATA(ls_ctx)
                            et_charge_item         = DATA(lt_charge_item)
                            et_do_root             = DATA(lt_do_root)
                            et_charge_element      = DATA(lt_charge_element) ).

* ---------------------------------------------------------------------------
* Realiza processamento adicional de acordo com o status atual
* ---------------------------------------------------------------------------
    CASE ls_fsd_data-lifecycle.

        " Status 04 - Lançado
      WHEN /scmtms/if_sfir_status=>sc_root-lifecycle-v_accruals_posted.

        lv_status    = zcltm_gko_process=>gc_codstatus-frete_faturado.

        " Status 05 - Cancelamento solicitado
      WHEN /scmtms/if_sfir_status=>sc_root-lifecycle-v_cancellation_requested_in_er.

        lv_status = zcltm_gko_process=>gc_codstatus-aguardando_estorno_dff.

        " Status 06 - Cancelamento
      WHEN /scmtms/if_sfir_status=>sc_root-lifecycle-v_cancelled.

        me->execute_cancel( EXPORTING io_tor_srv_mgr         = lo_tor_srv_mgr
                                      is_fsd_data            = ls_fsd_data
                                      is_cockpit             = ls_cockpit
                                      it_charge_element      = lt_charge_element
                                      iv_it_chrg_it_node_key = lv_it_chrg_it_node_key
                                      iv_it_chrg_el_node_key = lv_it_chrg_el_node_key
                            IMPORTING eo_message             = eo_message
                                      et_failed_key          = et_failed_key
                                      et_return              = lt_return ).

        IF NOT line_exists( lt_return[ type = 'E' ] ).
          lv_status = zcltm_gko_process=>gc_codstatus-dff_estornada.
        ENDIF.

      WHEN OTHERS.
        RETURN.

    ENDCASE.

* ---------------------------------------------------------------------------
* Atualiza Cockpit de Frete
* ---------------------------------------------------------------------------
    IF ls_cockpit-codstatus NE lv_status AND lv_status IS NOT INITIAL
    OR lv_reprocess IS NOT INITIAL.

      me->update_cockpit( EXPORTING iv_acckey    = ls_cockpit-acckey    " Chave de acesso
                                    iv_status    = lv_status            " Novo status
                                    iv_reprocess = lv_reprocess         " Ativa reprocessamento
                          IMPORTING et_return    = lt_return ).

    ENDIF.

  ENDMETHOD.


  METHOD get_message.

    FREE: et_return.

    CHECK io_message IS NOT INITIAL.

    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = io_message
                                                           CHANGING  ct_bapiret2 = et_return ).
    INSERT LINES OF et_return INTO TABLE ct_return.

  ENDMETHOD.


  METHOD update_cockpit.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Atualiza Cockpit de Frete
* ---------------------------------------------------------------------------
    TRY.
        DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey          = iv_acckey
                                                      iv_tpprocess       = zcltm_gko_process=>gc_tpprocess-automatico
                                                      iv_min_data_load   = abap_false ).

        lr_gko_process->set_status( EXPORTING iv_status  = iv_status ).

        IF iv_reprocess IS NOT INITIAL.
          lr_gko_process->reprocess( ).
        ENDIF.

        lr_gko_process->persist( ).
        lr_gko_process->free( ).

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
        et_return = lr_cx_gko_process->get_bapi_return( ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_data.

    DATA: lt_fsd_data TYPE /scmtms/t_sfir_root_k.

    FREE: eo_tor_srv_mgr,
          eo_sfir_srv_mgr,
          es_cockpit,
          es_tor_key,
          es_fsd_data,
          et_tcc,
          ev_do_key,
          ev_bo_do_assoc_key,
          ev_it_chrg_it_node_key,
          ev_it_chrg_el_node_key,
          es_ctx,
          et_charge_item,
          et_do_root,
          et_charge_element.

* ---------------------------------------------------------------------------
* Recupera dados do Documento de Faturamento de Frete (DFF)
* ---------------------------------------------------------------------------
    eo_sfir_srv_mgr = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = is_ctx-bo_key ).

    io_read->retrieve(
      EXPORTING
        iv_node      = is_ctx-node_key
        it_key       = it_key
        iv_fill_data = abap_true
      IMPORTING
        et_data      = lt_fsd_data ).

    TRY.
        es_fsd_data = lt_fsd_data[ 1 ].
      CATCH cx_root.
        RETURN.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera dados do cockpit de frete
* ---------------------------------------------------------------------------
    IF es_fsd_data-zzacckey IS NOT INITIAL.
      SELECT SINGLE acckey, tpevento, codstatus, tpdoc, tpcte
        FROM zttm_gkot001
        INTO CORRESPONDING FIELDS OF @es_cockpit
        WHERE acckey = @es_fsd_data-zzacckey.

      IF sy-subrc NE 0.
        CLEAR es_cockpit.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados da Ordem de Frete (OF)
* ---------------------------------------------------------------------------
    eo_sfir_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = is_ctx-node_key
        it_key         = it_key
        iv_association = /scmtms/if_suppfreightinvreq_c=>sc_association-root-tor_root
      IMPORTING
        et_target_key  = DATA(lt_tor_key)
        et_key_link    = DATA(lt_sfir_tor_kl) ).

    TRY.
        es_tor_key = lt_tor_key[ 1 ].
      CATCH cx_root.
        RETURN.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera dados de Custo Extra
* ---------------------------------------------------------------------------
    eo_tor_srv_mgr = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    eo_tor_srv_mgr->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE /bobf/t_frw_key( ( key = es_tor_key-key ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-transportcharges
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = et_tcc
        et_target_key  = DATA(lt_tcc_keys) ).

    /scmtms/cl_tcc_calc_utility=>get_bo_do_assoc(
      EXPORTING
        iv_bo_key        = /scmtms/if_tor_c=>sc_bo_key
        iv_node_key      = /scmtms/if_tor_c=>sc_node-root
        iv_do_key        = /scmtms/if_tcc_trnsp_chrg_c=>sc_bo_key
      IMPORTING
        ev_root_node_key = ev_do_key
        ev_assoc_key     = ev_bo_do_assoc_key ).

    ev_it_chrg_it_node_key = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = ev_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-chargeitem ).

    ev_it_chrg_el_node_key = /scmtms/cl_common_helper=>get_do_entity_key(
      iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
      iv_host_do_node_key = ev_do_key
      iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
      iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-itemchargeelement ).

    es_ctx = VALUE /scmtms/cl_tcc_do_helper=>ts_ctx( host_bo_key        = /scmtms/if_tor_c=>sc_bo_key
                                                     host_root_node_key = /scmtms/if_tor_c=>sc_node-root
                                                     host_node_key      = /scmtms/if_tor_c=>sc_node-transportcharges ).

    /scmtms/cl_tcc_do_helper=>retrive_do_nodes(
      EXPORTING
        is_ctx                   = es_ctx
        it_root_key              = VALUE /bobf/t_frw_key( ( key = es_tor_key-key ) )
      IMPORTING
        et_charge_item           = et_charge_item
        et_do_root               = et_do_root
        et_charge_element        = et_charge_element ).

  ENDMETHOD.


  METHOD execute_cancel.

    DATA: lt_changed TYPE /bobf/t_frw_name,
          lt_mod     TYPE /bobf/t_frw_modification.

* ---------------------------------------------------------------------------
* Prepara a remoção automática do custo extra
* ---------------------------------------------------------------------------
    IF is_cockpit IS NOT INITIAL.

      DATA(ls_cockpit) = is_cockpit.
      ls_cockpit-tpevento = zcltm_gko_process=>determine_charge( is_gko_header = is_cockpit ).

      " Para eventos criados via Cockpit de Frete
      READ TABLE it_charge_element INTO DATA(ls_elements) WITH KEY zzacckey = is_fsd_data-zzacckey
                                                                   tcet084  = ls_cockpit-tpevento
                                                                   inactive = abap_false.

    ELSE.

      " Para eventos criados manualmente na Ordem de Frete
      READ TABLE it_charge_element INTO ls_elements WITH KEY zzacckey = is_fsd_data-zzacckey
                                                             inactive = abap_false.

    ENDIF.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Inativa o Custo extra
* ---------------------------------------------------------------------------
    ls_elements-inactive      = abap_true.
    ls_elements-analyticrelev = abap_true.
    ls_elements-is_technical  = abap_true.

    APPEND:   'INACTIVE'      TO lt_changed,
              'ANALYTICRELEV' TO lt_changed,
              'IS_TECHNICAL'  TO lt_changed.

* ---------------------------------------------------------------------------
* Atualiza custo extra
* ---------------------------------------------------------------------------
    /scmtms/cl_mod_helper=>mod_update_single( EXPORTING is_data            = ls_elements
                                                        iv_node            = iv_it_chrg_el_node_key
                                                        it_changed_fields  = lt_changed
                                               CHANGING ct_mod             = lt_mod ).

    io_tor_srv_mgr->modify( EXPORTING it_modification = lt_mod
                            IMPORTING eo_message      = eo_message ).

    me->get_message( EXPORTING io_message = eo_message
                     IMPORTING et_return  = et_return ).

    IF eo_message IS NOT INITIAL.

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = eo_message
                                                             CHANGING  ct_bapiret2 = et_return ).

      IF et_return IS NOT INITIAL.
        et_failed_key = VALUE #( ( key = is_fsd_data-key ) ).

        " Falha ao eliminar automaticamente o custo extra &1.
        eo_message->add_message( EXPORTING is_msg = VALUE #( msgty  = 'W'
                                                             msgid  = 'ZTM_GKO'
                                                             msgno  = '145'
                                                             msgv1  = ls_cockpit-tpevento ) ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
