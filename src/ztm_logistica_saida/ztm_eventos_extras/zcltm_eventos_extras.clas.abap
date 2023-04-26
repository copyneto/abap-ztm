CLASS zcltm_eventos_extras DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS executar
      IMPORTING
        !iv_cod_evento   TYPE /scmtms/trcharg_elmnt_typecd
        !is_gko_header   TYPE zttm_gkot001 OPTIONAL
        !iv_commit       TYPE flag DEFAULT abap_true
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t.

    METHODS custo_normal
      IMPORTING
        !iv_cod_evento   TYPE /scmtms/trcharg_elmnt_typecd DEFAULT 'COCKPIT'
        !is_gko_header   TYPE zttm_gkot001 OPTIONAL
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t.

  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS busca_associacoes
      IMPORTING is_gko_header                TYPE zttm_gkot001
      EXPORTING eo_srvmgr_tor                TYPE REF TO /bobf/if_tra_service_manager
                ev_root_node_key             TYPE /bobf/obm_node_key
                ev_it_chrg_it_node_key       TYPE /bobf/obm_node_key
                ev_it_chrg_el_node_key       TYPE /bobf/obm_node_key
                ev_chrg_chargit_assoc_key    TYPE /bobf/obm_node_key
                ev_chrgit_itchrgel_assoc_key TYPE /bobf/obm_node_key
                et_tcc_keys                  TYPE /bobf/t_frw_key
                et_tor_stop                  TYPE /scmtms/t_tor_stop_k
                et_tor_stop_succ             TYPE /scmtms/t_tor_stop_succ_k
                et_chitem                    TYPE /scmtms/t_tcc_chrgitem_k
                et_chitemkeys                TYPE /bobf/t_frw_key
                et_chrel                     TYPE /scmtms/t_tcc_trchrg_element_k
                et_chelm                     TYPE /bobf/t_frw_key
                et_return                    TYPE bapiret2_t.

    METHODS faturamento_frete
      IMPORTING
        iv_torid TYPE /scmtms/tor_fo_id.

    METHODS prepara_mensagem
      IMPORTING io_message TYPE REF TO /bobf/if_frw_message
      CHANGING  ct_return  TYPE bapiret2_t.
ENDCLASS.



CLASS zcltm_eventos_extras IMPLEMENTATION.


  METHOD executar.

    DATA: lt_changed_fields TYPE /bobf/t_frw_name,
          lt_mod            TYPE /bobf/t_frw_modification,
          ls_mod            TYPE /bobf/s_frw_modification,
          lt_chrel_sort     TYPE /scmtms/t_tcc_trchrg_element_k,
          ls_chrel          TYPE /scmtms/s_tcc_trchrg_element_k,
          lt_tcc            TYPE /scmtms/t_tcc_root_k.

* ---------------------------------------------------------------------------
* Recupera associações
* ---------------------------------------------------------------------------
    me->busca_associacoes( EXPORTING is_gko_header                = is_gko_header
                           IMPORTING eo_srvmgr_tor                = DATA(lo_srvmgr_tor)
                                     ev_root_node_key             = DATA(lv_root_node_key)
                                     ev_it_chrg_it_node_key       = DATA(lv_it_chrg_it_node_key)
                                     ev_it_chrg_el_node_key       = DATA(lv_it_chrg_el_node_key)
                                     ev_chrg_chargit_assoc_key    = DATA(lv_chrg_chargit_assoc_key)
                                     ev_chrgit_itchrgel_assoc_key = DATA(lv_chrgit_itchrgel_assoc_key)
*                                     et_tcc_keys                  = DATA(lt_tcc_keys)
                                     et_tor_stop_succ             = DATA(lt_tor_stop_succ)
                                     et_tor_stop                  = DATA(lt_tor_stop)
                                     et_chitem                    = DATA(lt_chitem)
                                     et_chitemkeys                = DATA(lt_chitemkeys)
                                     et_chrel                     = DATA(lt_chrel)
                                     et_chelm                     = DATA(lt_chelm)
                                     et_return                    = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      INSERT LINES OF lt_return INTO TABLE rt_return.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida se Custo Extra já foi criado. Se encontrado, não criar novamente.
* ---------------------------------------------------------------------------
    IF line_exists( lt_chrel[ zzacckey = is_gko_header-acckey
                              tcet084  = iv_cod_evento
                              inactive = abap_false ] ).

      " Custo extra &1 já foi adicionado.
      rt_return[] = VALUE #( ( type       = if_xo_const_message=>warning
                               id         = 'ZTM_GKO'
                               number     = '141'
                               message_v1 = iv_cod_evento ) ).
      RETURN.
    ENDIF.

    lt_chrel_sort[] = lt_chrel[].
    SORT lt_chrel_sort DESCENDING BY linenr.

    IF line_exists( lt_chrel_sort[ 1 ] ).
      DATA(ls_chrel_sort) = lt_chrel_sort[ 1 ].
    ENDIF.

    "Prepare your Data Table for Charge Elements Here.
    CLEAR ls_chrel.
    ls_chrel-key              = /bobf/cl_frw_factory=>get_new_key( ).
    ls_chrel-parent_key       = ls_chrel_sort-parent_key.
    ls_chrel-root_key         = ls_chrel_sort-root_key.
    ls_chrel-tcet084          = iv_cod_evento.
    ls_chrel-linenr           = ls_chrel_sort-linenr + 10.
    ls_chrel-my_tce_linenr    = ls_chrel_sort-linenr + 10.       " INSERT - JWSILVA - 01.02.2023
    ls_chrel-tccalcresins040  = ls_chrel_sort-tccalcresins040.
    ls_chrel-clcresbas036     = ls_chrel_sort-clcresbas036.
    ls_chrel-amount           = is_gko_header-vtprest / 10000.
    ls_chrel-rate_amount      = ls_chrel-amount.
    ls_chrel-currcode016      = 'BRL'.
    ls_chrel-rate_amount_curr = ls_chrel-currcode016.
    ls_chrel-zzacckey         = is_gko_header-acckey.

    GET REFERENCE OF ls_chrel INTO DATA(lr_chrel).

    ls_mod-key          = ls_chrel-key.
    ls_mod-source_key   = ls_chrel-parent_key.
    ls_mod-source_node  = lv_it_chrg_it_node_key.
    ls_mod-root_key     = ls_chrel-root_key.
    ls_mod-node         = lv_it_chrg_el_node_key.
    ls_mod-association  = lv_chrgit_itchrgel_assoc_key.
    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
    ls_mod-data         = lr_chrel.
    APPEND ls_mod TO lt_mod.

* ---------------------------------------------------------------------------
* Modifica os dados de custo
* ---------------------------------------------------------------------------
    lo_srvmgr_tor->modify( EXPORTING it_modification = lt_mod
                           IMPORTING eo_change       = DATA(lo_srvmgr_change)
                                     eo_message      = DATA(lo_message) ).

    me->prepara_mensagem( EXPORTING io_message = lo_message
                          CHANGING  ct_return  = rt_return ).

* ---------------------------------------------------------------------------
* Salva os dados de custo
* ---------------------------------------------------------------------------
    IF iv_commit EQ abap_true.

      DATA(lo_trans_manager) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

      lo_trans_manager->save( IMPORTING eo_change  = DATA(lo_change)
                                        eo_message = lo_message ).

      me->prepara_mensagem( EXPORTING io_message = lo_message
                            CHANGING  ct_return  = rt_return ).
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica se o custo foi criado corretamente
* ---------------------------------------------------------------------------
    lo_srvmgr_tor->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE /bobf/t_frw_key( ( key = ls_chrel-root_key ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-transportcharges
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_tcc
        et_target_key  = DATA(lt_tcc_keys) ).

    IF lt_tcc IS INITIAL.

      " Ordem de frete &1 não encontrado para validação do cálculo de custos.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_GKO' number = '131' message_v1 =  is_gko_header-tor_id ) ).

    ELSEIF line_exists( lt_tcc[ net_amount = 0 ] ).

      " Ordem de frete &1 com cálculo de custos zerado.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_GKO' number = '132' message_v1 =  is_gko_header-tor_id ) ).

    ENDIF.

  ENDMETHOD.


  METHOD faturamento_frete.

    CONSTANTS:
      lc_modulo_tm  TYPE ze_param_modulo VALUE 'TM',
      lc_chave1_job TYPE ze_param_chave  VALUE 'JOB_CALCULO_CUSTO'.

    DATA:
      lt_range_doc     TYPE RANGE OF /scmtms/tor_fo_id.

    APPEND VALUE #( sign = 'I' option = 'EQ' low = iv_torid ) TO lt_range_doc.

    SELECT modulo, chave1, low, high
      FROM ztca_param_val
      INTO TABLE @DATA(lt_param_val)
      WHERE modulo = @lc_modulo_tm
        AND chave1 = @lc_chave1_job.
    LOOP AT lt_param_val ASSIGNING FIELD-SYMBOL(<fs_param_val>).
      SUBMIT /scmtms/sfir_create_batch
*              VIA JOB lv_jobname NUMBER lv_jobcount
        WITH pv_slprf = <fs_param_val>-low "us_profile
        WITH incl_dc  = abap_true
        WITH so_torid = lt_range_doc[]
        WITH so_shipp = <fs_param_val>-high "us_expedidor
        WITH so_invdt = sy-datum
        WITH pv_tnsfr = abap_true
        WITH pv_test  = abap_false
        WITH pv_msg   = abap_true
        WITH pv_tc_m  = abap_true
        WITH pv_inv   = /scmtms/if_sfir_c=>sc_inv_creation_method-individual
        AND RETURN.
    ENDLOOP.

  ENDMETHOD.


  METHOD custo_normal.

    DATA: lt_changed_fields TYPE /bobf/t_frw_name,
          lt_mod            TYPE /bobf/t_frw_modification,
          ls_mod            TYPE /bobf/s_frw_modification.

* ---------------------------------------------------------------------------
* Recupera associações
* ---------------------------------------------------------------------------
    me->busca_associacoes( EXPORTING is_gko_header                = is_gko_header
                           IMPORTING eo_srvmgr_tor                = DATA(lo_srvmgr_tor)
                                     ev_root_node_key             = DATA(lv_root_node_key)
                                     ev_it_chrg_it_node_key       = DATA(lv_it_chrg_it_node_key)
                                     ev_it_chrg_el_node_key       = DATA(lv_it_chrg_el_node_key)
                                     ev_chrg_chargit_assoc_key    = DATA(lv_chrg_chargit_assoc_key)
                                     ev_chrgit_itchrgel_assoc_key = DATA(lv_chrgit_itchrgel_assoc_key)
                                     et_tcc_keys                  = DATA(lt_tcc_keys)
                                     et_tor_stop_succ             = DATA(lt_tor_stop_succ)
                                     et_tor_stop                  = DATA(lt_tor_stop)
                                     et_chitem                    = DATA(lt_chitem)
                                     et_chitemkeys                = DATA(lt_chitemkeys)
                                     et_chrel                     = DATA(lt_chrel)
                                     et_chelm                     = DATA(lt_chelm)
                                     et_return                    = DATA(lt_return) ).

    IF lt_return IS NOT INITIAL.
      INSERT LINES OF lt_return INTO TABLE rt_return.
      RETURN.
    ENDIF.

    IF NOT line_exists( lt_chrel[ tcet084  = iv_cod_evento ] ).
      " Custo &1 não encontrado para atualização do valor.
      rt_return[] = VALUE #( ( type       = if_xo_const_message=>error
                               id         = 'ZTM_GKO'
                               number     = '142'
                               message_v1 = iv_cod_evento ) ).
      RETURN.
    ENDIF.

    TRY.
        DATA(ls_chrel) = lt_chrel[ tcet084  = iv_cod_evento ].
      CATCH cx_root.

        " Custo &1 não encontrado para atualização do valor.
        rt_return[] = VALUE #( ( type       = if_xo_const_message=>error
                                 id         = 'ZTM_GKO'
                                 number     = '142'
                                 message_v1 = iv_cod_evento ) ).
        RETURN.
    ENDTRY.

    ls_chrel-amount   = is_gko_header-vtprest / 10000.
    ls_chrel-zzacckey = is_gko_header-acckey.

    APPEND:   'AMOUNT'   TO lt_changed_fields,
              'ZZACCKEY' TO lt_changed_fields.

    /scmtms/cl_mod_helper=>mod_update_single( EXPORTING is_data            = ls_chrel
                                                        iv_node            = lv_it_chrg_el_node_key " Node
                                                        it_changed_fields  = lt_changed_fields
                                               CHANGING ct_mod             = lt_mod ).              " Changes

    lo_srvmgr_tor->modify( EXPORTING it_modification = lt_mod
                           IMPORTING eo_change       = DATA(lo_change)
                                     eo_message      = DATA(lo_message) ).

    me->prepara_mensagem( EXPORTING io_message = lo_message
                          CHANGING  ct_return  = rt_return ).

    DATA(lo_trans_manager) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    lo_trans_manager->save( IMPORTING eo_change  = lo_change
                                      eo_message = lo_message ).

    me->prepara_mensagem( EXPORTING io_message = lo_message
                          CHANGING  ct_return  = rt_return ).

  ENDMETHOD.


  METHOD prepara_mensagem.

    DATA: lt_return TYPE bapiret2_t.

    CHECK io_message IS NOT INITIAL.

    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = io_message
                                                           CHANGING  ct_bapiret2 = lt_return ).
    INSERT LINES OF lt_return INTO TABLE ct_return.

  ENDMETHOD.


  METHOD busca_associacoes.

*- se n encontrar ordem a OF - jogar msg errro
*
*- se n encontrar a paradas (com De e Ate) - jogar msg erro
*
*- se n encontrar o calcula (transp chag) - jogar msg erro
*
*- se n encontrar o item do transp char - jogar msg erro
*
*se encontrar, adicionar elemento novo no item do trans selecionado - pelo De ate das paradas

    DATA: lt_tcc            TYPE /scmtms/t_tcc_root_k,
          lt_changed_fields TYPE /bobf/t_frw_name,
          lt_return         TYPE bapiret2_tab,
          lt_loc_id_key     TYPE STANDARD TABLE OF zi_tm_vh_location_id,
          lv_montante       TYPE char35.

    FREE: eo_srvmgr_tor,
          ev_root_node_key,
          ev_it_chrg_it_node_key,
          ev_it_chrg_el_node_key,
          ev_chrg_chargit_assoc_key,
          ev_chrgit_itchrgel_assoc_key,
          et_tcc_keys,
          et_tor_stop,
          et_tor_stop_succ,
          et_chitem,
          et_chitemkeys,
          et_chrel,
          et_chelm,
          et_return.

    eo_srvmgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    " Recupera a Unidade Gerencial
    IF is_gko_header-dest_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-dest_cod ) ).
    ENDIF.
    IF is_gko_header-receb_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-receb_cod ) ).
    ENDIF.
    IF is_gko_header-rem_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-rem_cod ) ).
    ENDIF.
    IF is_gko_header-exped_cod IS NOT INITIAL.
      lt_loc_id_key = VALUE #( BASE lt_loc_id_key ( partner = is_gko_header-exped_cod ) ).
    ENDIF.

    IF lt_loc_id_key[] IS NOT INITIAL.

      SELECT locationid, partner
          FROM zi_tm_vh_location_id
          FOR ALL ENTRIES IN @lt_loc_id_key
          WHERE partner = @lt_loc_id_key-partner
          INTO TABLE @DATA(lt_loc_id).

      IF sy-subrc EQ 0.
        SORT lt_loc_id BY partner.
      ENDIF.

    ENDIF.

    " Verifica se existe Destinatário (NF Saída)
    IF et_tor_stop_succ IS INITIAL.

      " Adiciona a Ordem de Frete e Destinatário
      DATA(lt_parameters) = VALUE /bobf/t_frw_query_selparam( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-tor_id
                                                                sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                option         = /bobf/if_conf_c=>sc_sign_equal
                                                                low            = is_gko_header-tor_id )
                                                              ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locto
                                                                sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                option         = /bobf/if_conf_c=>sc_sign_equal
                                                                low            = is_gko_header-dest_cod ) ).

      " Adiciona a Unidade Gerencial do Destinatário
      LOOP AT lt_loc_id INTO DATA(ls_loc_id) WHERE partner = is_gko_header-dest_cod.

        lt_parameters = VALUE /bobf/t_frw_query_selparam( BASE lt_parameters ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locto
                                                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                                                               low            = ls_loc_id-locationid ) ).
      ENDLOOP.

      " Adiciona o Recebedor da Mercadoria
      IF is_gko_header-receb_cod IS NOT INITIAL.
        lt_parameters = VALUE /bobf/t_frw_query_selparam( BASE lt_parameters ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locto
                                                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                                                               low            = is_gko_header-receb_cod ) ).
      ENDIF.

      " Adiciona a Unidade Gerencial do Recebedor da Mercadoria
      LOOP AT lt_loc_id INTO ls_loc_id WHERE partner = is_gko_header-receb_cod.

        lt_parameters = VALUE /bobf/t_frw_query_selparam( BASE lt_parameters ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locto
                                                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                                                               low            = ls_loc_id-locationid ) ).
      ENDLOOP.

      SORT lt_parameters BY table_line.
      DELETE ADJACENT DUPLICATES FROM lt_parameters COMPARING table_line.

      eo_srvmgr_tor->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-stop_successor-planning_attributes
                                      it_selection_parameters = lt_parameters
                                      iv_fill_data            = abap_true
                            IMPORTING et_data                 = et_tor_stop_succ ).
    ENDIF.

    " Caso não exista destinatário (NF Saída), verifica se existe Remetente (NF Entrada)
    IF et_tor_stop_succ IS INITIAL.

      " Adiciona a Ordem de Frete e Remetente
      lt_parameters = VALUE /bobf/t_frw_query_selparam( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-tor_id
                                                          sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                          option         = /bobf/if_conf_c=>sc_sign_equal
                                                          low            = is_gko_header-tor_id )
                                                        ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locfr
                                                          sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                          option         = /bobf/if_conf_c=>sc_sign_equal
                                                          low            = is_gko_header-rem_cod ) ).

      " Adiciona a Unidade Gerencial do Remetente
      LOOP AT lt_loc_id INTO ls_loc_id WHERE partner = is_gko_header-rem_cod.

        lt_parameters = VALUE /bobf/t_frw_query_selparam( BASE lt_parameters ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locfr
                                                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                                                               low            = ls_loc_id-locationid ) ).
      ENDLOOP.

      " Adiciona o Expedidor
      IF is_gko_header-exped_cod IS NOT INITIAL.
        lt_parameters = VALUE /bobf/t_frw_query_selparam( BASE lt_parameters ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locfr
                                                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                                                               low            = is_gko_header-exped_cod ) ).
      ENDIF.

      " Adiciona a Unidade Gerencial do Expedidor
      LOOP AT lt_loc_id INTO ls_loc_id WHERE partner = is_gko_header-exped_cod.

        lt_parameters = VALUE /bobf/t_frw_query_selparam( BASE lt_parameters ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-stop_successor-planning_attributes-locfr
                                                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                                                               low            = ls_loc_id-locationid ) ).
      ENDLOOP.

      SORT lt_parameters BY table_line.
      DELETE ADJACENT DUPLICATES FROM lt_parameters COMPARING table_line.

      eo_srvmgr_tor->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-stop_successor-planning_attributes
                                      it_selection_parameters = lt_parameters
                                      iv_fill_data            = abap_true
                            IMPORTING et_data                 = et_tor_stop_succ ).

    ENDIF.

    eo_srvmgr_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                      it_key         = CORRESPONDING #( et_tor_stop_succ MAPPING key = root_key )
                                                      iv_association = /scmtms/if_tor_c=>sc_association-root-transportcharges
                                                      iv_fill_data   = abap_true
                                            IMPORTING et_data        = lt_tcc
                                                      et_target_key  = DATA(lt_tcc_keys) ).

    /scmtms/cl_tcc_calc_utility=>get_bo_do_assoc( EXPORTING iv_bo_key        = /scmtms/if_tor_c=>sc_bo_key
                                                            iv_node_key      = /scmtms/if_tor_c=>sc_node-root
                                                            iv_do_key        = /scmtms/if_tcc_trnsp_chrg_c=>sc_bo_key
                                                  IMPORTING ev_root_node_key = DATA(lv_do_key)
                                                            ev_assoc_key     = DATA(lv_bo_do_assoc_key) ).

    ev_root_node_key             = /scmtms/cl_common_helper=>get_do_entity_key(
                                   iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                   iv_host_do_node_key = lv_do_key
                                   iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
                                   iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-root ).

    ev_it_chrg_it_node_key       = /scmtms/cl_common_helper=>get_do_entity_key(
                                   iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                   iv_host_do_node_key = lv_do_key
                                   iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
                                   iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-chargeitem ).

    ev_it_chrg_el_node_key       = /scmtms/cl_common_helper=>get_do_entity_key(
                                   iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                   iv_host_do_node_key = lv_do_key
                                   iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
                                   iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_node-itemchargeelement ).

    ev_chrg_chargit_assoc_key    = /scmtms/cl_common_helper=>get_do_entity_key(
                                   iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                   iv_host_do_node_key = lv_do_key
                                   iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
                                   iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-root-chargeitem ).

    ev_chrgit_itchrgel_assoc_key = /scmtms/cl_common_helper=>get_do_entity_key(
                                   iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                   iv_host_do_node_key = lv_do_key
                                   iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_ass
                                   iv_do_entity_key    = /scmtms/if_tcc_trnsp_chrg_c=>sc_association-chargeitem-itemchargeelement ).

    eo_srvmgr_tor->retrieve_by_association( EXPORTING iv_node_key    = lv_do_key
                                                      it_key         = lt_tcc_keys
                                                      iv_association = ev_chrg_chargit_assoc_key
                                                      iv_fill_data   = abap_true
                                            IMPORTING et_data        = et_chitem
                                                      et_target_key  = et_chitemkeys ).

    eo_srvmgr_tor->retrieve_by_association( EXPORTING iv_node_key    = ev_it_chrg_it_node_key
                                                      it_key         = et_chitemkeys
                                                      iv_association = ev_chrgit_itchrgel_assoc_key
                                                      iv_fill_data   = abap_true
                                            IMPORTING et_data        = et_chrel
                                                      et_target_key  = et_chelm ).

    IF line_exists( et_tor_stop_succ[ 1 ] ).
      DATA(ls_tor_stop_succ) = et_tor_stop_succ[ 1 ].
    ELSE.
      " MSG erro - Parceiro Destino não localizado
      et_return[] = VALUE #( ( type       = if_xo_const_message=>error
                               id         = 'ZTM_GKO'
                               number     = '139' ) ).
      RETURN.
    ENDIF.

    IF line_exists( et_chitem[ host_key = ls_tor_stop_succ-key ] ).
      DATA(ls_chitem) = et_chitem[ host_key = ls_tor_stop_succ-key ].
    ELSE.
      " MSG Erro - Cálculo de Custo não realizado
      et_return[] = VALUE #( ( type       = if_xo_const_message=>error
                               id         = 'ZTM_GKO'
                               number     = '140' ) ).
      RETURN.
    ENDIF.

    DELETE et_chrel WHERE parent_key <> ls_chitem-key.
    IF et_chrel[] IS INITIAL.
      " MSG Erro - Cálculo de Custo não realizado.
      et_return[] = VALUE #( ( type       = if_xo_const_message=>error
                               id         = 'ZTM_GKO'
                               number     = '140' ) ).
      RETURN.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
