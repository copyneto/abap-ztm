"!<p><h2>Envio de dados via proxy para o sistema Roadnet</h2></p>
"!<p><strong>Autor: </strong>Guido Olivan</p>
"!<p><strong>Data: </strong>11/02/2022</p>
"!<p><strong>Alterado: </strong>Eliabe Lima</p>
"!<p><strong>Data: </strong>04/07/2022</p>
CLASS zcltm_process_roadnet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ziftm_integracao_roadnet .

    TYPES:
      BEGIN OF ty_etapas,
        seq         TYPE i,
        locid       TYPE /sapapo/locno,
        acc_start   TYPE /scmtms/stop_acc_start,
        acc_end     TYPE /scmtms/stop_acc_end,
        distance_km TYPE /scmtms/decimal_value,
      END OF ty_etapas .
    TYPES:
      ty_t_etapas TYPE STANDARD TABLE OF ty_etapas .
    TYPES ty_road_session TYPE zttm_road_sessio .
    TYPES:
      ty_t_road_session TYPE STANDARD TABLE OF ty_road_session .
    TYPES ty_road_item TYPE zttm_road_item .
    TYPES:
      ty_t_road_item    TYPE STANDARD TABLE OF ty_road_item .

    TYPES: BEGIN OF ty_parameter,
             r_entrega      TYPE RANGE OF zttm_road_item-description,
             r_crossdocking TYPE RANGE OF zttm_road_item-description,
             r_redespacho   TYPE RANGE OF zttm_road_item-description,
           END OF ty_parameter.

    CONSTANTS:
      gc_centro TYPE c LENGTH 6 VALUE 'CENTRO' ##NO_TEXT.
    CONSTANTS:
      gc_sessao TYPE c LENGTH 10 VALUE 'SESSION_ID' ##NO_TEXT.
    CONSTANTS:
      gc_data   TYPE c LENGTH 4 VALUE 'DATA' ##NO_TEXT.
    "!Tabela com os dados no nó raiz das ordens de frete
    DATA gt_tor_fo TYPE /scmtms/t_tor_root_k .
    DATA:
      gt_stops TYPE STANDARD TABLE OF zcltm_dt_consulta_sessao_resp .
    CONSTANTS gc_itmtype_truc TYPE /scmtms/tor_item_type VALUE 'TRUC' ##NO_TEXT.
    CONSTANTS gc_itmtype_trl TYPE /scmtms/tor_item_type VALUE 'TRL' ##NO_TEXT.
    CONSTANTS gc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR' ##NO_TEXT.
    CONSTANTS gc_itemcat_pvr TYPE /scmtms/item_category VALUE 'PVR' ##NO_TEXT.
    DATA gt_mod_stop TYPE /bobf/t_frw_modification .
    DATA: gs_parameter  TYPE ty_parameter.

    "! Atualizar o status da ordem de frete
    "! @parameter iv_tor_key | chava da ordem
    "! @parameter io_tor_mgr | objeto de gerenciamento da ordem
    "! @parameter rt_messages | Mensagens do processamento
    CLASS-METHODS atualiza_status_fo
      IMPORTING
        !iv_tor_key        TYPE /bobf/conf_key
        !io_tor_mgr        TYPE REF TO /bobf/if_tra_service_manager
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Buscar unidade de frete
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter rt_tor_fu | Tabela com as unidades de frete correspondente
    METHODS busca_fu
      IMPORTING
        !is_dados        TYPE ztms_input_rodnet
      RETURNING
        VALUE(rt_tor_fu) TYPE /scmtms/t_tor_root_k .
    "! Efetuar a gravação do log de processamento
    "! @parameter is_dados | Dados de entrda do Roadnet
    "! @parameter it_tor_fu | Tabela com as ordens
    "! @parameter it_messages | Mensagens a serem logadas
    METHODS grava_log
      IMPORTING
        !is_dados    TYPE ztms_input_rodnet
        !it_tor_fu   TYPE /scmtms/t_tor_root_k
        !it_messages TYPE bapiret2_t .
    "! Associar unidade de frete à ordem
    "! @parameter it_tor_fu | tabela com as unidades de frete
    "! @parameter io_tor_mgr | objeto de gerenciamento da ordem
    "! @parameter io_txn_mgr | objeto de gerenciamento da transação
    "! @parameter is_tor_root | Nó root da ordem de frete
    "! @parameter rt_return | Mensagens do processamento
    CLASS-METHODS associa_unidade_frete
      IMPORTING
        !it_tor_fu       TYPE /scmtms/t_tor_root_k
        !io_tor_mgr      TYPE REF TO /bobf/if_tra_service_manager
        !io_txn_mgr      TYPE REF TO /bobf/if_tra_transaction_mgr
        !is_tor_root     TYPE /scmtms/s_tor_root_k
        iv_data          TYPE sydatum OPTIONAL
        iv_centro        TYPE werks_d OPTIONAL
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Buscar tipo do business partner
    "! @parameter iv_partner | Cod. do parceiro
    "! @parameter rv_kind | tipo do parceiro
    CLASS-METHODS busca_tipo_bp
      IMPORTING
        !iv_partner    TYPE bu_partner
      RETURNING
        VALUE(rv_kind) TYPE bu_bpkind .
    "! converter o BP na sua chave (UUID)
    "! @parameter iv_partner | Cod. parceiro
    "! @parameter rv_key | chave do parceiro
    CLASS-METHODS convert_bp_to_key
      IMPORTING
        !iv_partner   TYPE bu_partner
      RETURNING
        VALUE(rv_key) TYPE bu_partner_guid .
    "! Converter o local para sua chave (UUID)
    "! @parameter iv_locno | Cod. do local
    "! @parameter rv_loc_uuid | chave do local
    CLASS-METHODS convert_loc_to_key
      IMPORTING
        !iv_locno          TYPE /sapapo/locno
      RETURNING
        VALUE(rv_loc_uuid) TYPE /scmb/mdl_locid .
    "! Ajustar as paradas de transbordo
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter it_tor_fu | Tabela com as unidades de frete
    "! @parameter rt_messages | Mensagens do processamento
    METHODS ajusta_etapa_transbordo
      IMPORTING
        !is_dados          TYPE ztms_input_rodnet
        !it_tor_fu         TYPE /scmtms/t_tor_root_k
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Atualizar as Referências
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter rt_messages | Mensagens do processamento
    METHODS atualiza_referencia
      IMPORTING
        !iv_tor_id         TYPE /scmtms/tor_id
        !is_dados          TYPE ztms_input_rodnet
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Liberar remessa
    "! @parameter is_dados |Dados da interface Roadnet
    "! @parameter rt_messages |Mensagens do processamento
    METHODS libera_remessa
      IMPORTING
        !is_dados          TYPE ztms_input_rodnet
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Processar ordem de frete
    "! @parameter iv_transbordo | Possui transbordo?
    "! @parameter is_dados |Dados da interface Roadnet
    "! @parameter rt_messages |Mensagens do processamento
    METHODS processamento_frete
      IMPORTING
        !iv_transbordo     TYPE char1 OPTIONAL
        !is_dados          TYPE ztms_input_rodnet
        !is_session        TYPE zcltm_dt_consulta_sessao_resp1
        !is_routes         TYPE zcltm_dt_consulta_sessao_res14
      EXPORTING
        !ev_tor_id         TYPE /scmtms/d_torrot-tor_id
      CHANGING
        ct_road_session    TYPE zctgtm_road_session
        ct_road_item       TYPE zctgtm_road_item
        ct_road_log        TYPE zctgtm_road_log
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Criar ordem de frete
    "! @parameter iv_transbordo | Possui transbordo?
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter rt_messages | Mensagens do processamento
    METHODS cria_ordem_frete
      IMPORTING
        !iv_transbordo     TYPE char1 OPTIONAL
        !is_dados          TYPE ztms_input_rodnet
        !is_session        TYPE zcltm_dt_consulta_sessao_resp1
        !is_routes         TYPE zcltm_dt_consulta_sessao_res14
      CHANGING
        ct_road_session    TYPE zctgtm_road_session
        ct_road_item       TYPE zctgtm_road_item
        ct_road_log        TYPE zctgtm_road_log
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Criar ordem de frete superior
    "! @parameter iv_transbordo | Possui transbordo?
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter it_tor_fu | Tabela com as unidades de frete
    "! @parameter rt_messages | Mensagens do processamento
    METHODS cria_ordem_frete_mae
      IMPORTING
        !iv_transbordo     TYPE char1 OPTIONAL
        !is_dados          TYPE ztms_input_rodnet
        !it_tor_fu         TYPE /scmtms/t_tor_root_k
        !is_session        TYPE zcltm_dt_consulta_sessao_resp1
        !is_routes         TYPE zcltm_dt_consulta_sessao_res14
      CHANGING
        ct_road_session    TYPE zctgtm_road_session
        ct_road_item       TYPE zctgtm_road_item
        ct_road_log        TYPE zctgtm_road_log
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Criar ordem de frete sem redespacho
    "! @parameter iv_transbordo | Possui transbordo?
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter it_tor_fu | Tabela com as unidades de frete
    "! @parameter rt_messages | Mensagens do processamento
    METHODS cria_ordem_frete_s_redesp
      IMPORTING
        !iv_transbordo     TYPE char1 OPTIONAL
        !is_dados          TYPE ztms_input_rodnet
        !it_tor_fu         TYPE /scmtms/t_tor_root_k
        !is_session        TYPE zcltm_dt_consulta_sessao_resp1
        !is_routes         TYPE zcltm_dt_consulta_sessao_res14
      EXPORTING
        !ev_tor_id         TYPE /scmtms/d_torrot-tor_id
      CHANGING
        ct_road_session    TYPE zctgtm_road_session
        ct_road_item       TYPE zctgtm_road_item
        ct_road_log        TYPE zctgtm_road_log
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Criar ordem de frete
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter iv_order_type | Tipo de ordem
    "! @parameter es_root | Dados do root criado
    "! @parameter et_item | Dados dos ítens da ordem criada
    "! @parameter et_stop | Paradas da ordem
    "! @parameter rt_messages | Mensagens do processamento
    METHODS gera_fo
      IMPORTING
        !is_dados          TYPE ztms_input_rodnet
        !iv_order_type     TYPE /scmtms/tor_type OPTIONAL
        !is_session        TYPE zcltm_dt_consulta_sessao_resp1
        !is_routes         TYPE zcltm_dt_consulta_sessao_res14
      EXPORTING
        !es_root           TYPE /scmtms/s_tor_root_k
        !et_item           TYPE /scmtms/t_tor_item_tr_k
        !et_stop           TYPE /scmtms/t_tor_stop_k
      CHANGING
        ct_road_session    TYPE zctgtm_road_session
        ct_road_item       TYPE zctgtm_road_item
        ct_road_log        TYPE zctgtm_road_log
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    "! Verificar o depósito do transbordo
    "! @parameter is_dados | Dados da interface Roadnet
    "! @parameter rv_true | Retorna se o depósito está configurado como transbordo
    METHODS verifica_deposito_transbordo
      IMPORTING
        !is_dados      TYPE ztms_input_rodnet
      RETURNING
        VALUE(rv_true) TYPE char1 .
    METHODS split_etapa
      IMPORTING
        !is_root_tor        TYPE /scmtms/s_tor_root_k
        !iv_locid           TYPE /sapapo/locno OPTIONAL
        VALUE(iv_arrival)   TYPE /scmtms/stop_plan_date OPTIONAL
        VALUE(iv_departure) TYPE /scmtms/stop_plan_date OPTIONAL
        VALUE(iv_maxetapa)  TYPE int4 OPTIONAL
        !iv_distancia_km    TYPE /scmtms/decimal_value OPTIONAL
        !it_etapas          TYPE ty_t_etapas OPTIONAL
      RETURNING
        VALUE(rt_messages)  TYPE bapiret2_t .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .

    METHODS build_roadnet_description
      IMPORTING
        !iv_description       TYPE zttm_road_item-description
      EXPORTING
        !ev_description       TYPE zttm_road_item-description
      RETURNING
        VALUE(rv_description) TYPE zttm_road_item-description.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_rembp,
        vbeln         TYPE vbeln_vl,
        torkey        TYPE /bobf/conf_key,
        torid         TYPE /scmtms/tor_id,
        latitude      TYPE bu_id_number,
        longitude     TYPE bu_id_number,
        seq           TYPE n LENGTH 4,
        arrival       TYPE /scmtms/stop_plan_date,
        tempo_servico TYPE int8,
        distance_km   TYPE  /scmtms/decimal_value,
      END OF ty_rembp .
    TYPES:
      BEGIN OF ty_routes,
        routes TYPE char20,
        torid  TYPE /scmtms/tor_id,
      END OF ty_routes .
    TYPES:
      ty_t_routes TYPE TABLE OF ty_routes .

    DATA gv_km_total TYPE /scmtms/decimal_value .
    DATA:
      gt_rembp       TYPE STANDARD TABLE OF ty_rembp .
    DATA:
      gt_rembp_total TYPE STANDARD TABLE OF ty_rembp .

    DATA:
      gv_data   TYPE sydatum,
      gv_centro TYPE werks_d.

    CLASS-DATA gv_wait_async TYPE abap_bool .
    CLASS-DATA gt_return TYPE bapiret2_t .

    METHODS create_event
      IMPORTING
        !is_tor            TYPE /scmtms/s_tor_root_k
        !is_dados          TYPE ztms_input_rodnet
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    METHODS upd_bp .
    METHODS process_session
      IMPORTING
        !iv_cross          TYPE abap_bool
        !is_session        TYPE zcltm_dt_consulta_sessao_resp1
      CHANGING
        ct_road_session    TYPE zctgtm_road_session
        ct_road_item       TYPE zctgtm_road_item
        ct_road_log        TYPE zctgtm_road_log
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    METHODS build_roadnet_session
      IMPORTING
        !it_session      TYPE zcltm_dt_consulta_sessao__tab1
      EXPORTING
        !et_road_session TYPE zctgtm_road_session
        !et_road_item    TYPE zctgtm_road_item
        !et_road_log     TYPE zctgtm_road_log .
    METHODS update_roadnet_session
      IMPORTING
        !is_session      TYPE zcltm_dt_consulta_sessao_resp1
        !is_routes       TYPE zcltm_dt_consulta_sessao_res14 OPTIONAL
        !iv_tor_id       TYPE /scmtms/d_torrot-tor_id OPTIONAL
        !it_return       TYPE bapiret2_t OPTIONAL
      EXPORTING
        !et_road_log_new TYPE zctgtm_road_log
      CHANGING
        !ct_road_session TYPE zctgtm_road_session
        !ct_road_item    TYPE zctgtm_road_item
        !ct_road_log     TYPE zctgtm_road_log .
    METHODS save_roadnet_session
      IMPORTING
        !it_road_session TYPE zctgtm_road_session
        !it_road_item    TYPE zctgtm_road_item
        !it_road_log     TYPE zctgtm_road_log
      EXPORTING
        !et_return       TYPE bapiret2_t .
    METHODS validate_roadnet_session
      IMPORTING
        !is_session      TYPE zcltm_dt_consulta_sessao_resp1
        !it_road_session TYPE zctgtm_road_session
        !it_road_item    TYPE zctgtm_road_item
        !it_road_log     TYPE zctgtm_road_log
      EXPORTING
        !et_return       TYPE bapiret2_t.
    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t .
    METHODS ajusta_fu_stop
      IMPORTING
        !is_dados TYPE ztms_input_rodnet
      CHANGING
        !ct_stop  TYPE /scmtms/t_tor_stop_k .
    METHODS ajusta_km
      IMPORTING
        !is_root_tor       TYPE /scmtms/s_tor_root_k
        !it_etapas         TYPE ty_t_etapas
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    METHODS check_routes
      IMPORTING
        !it_routes             TYPE zcltm_dt_consulta_sessao__tab2
      EXPORTING
        !et_return             TYPE bapiret2_t
        !et_routes             TYPE ty_t_routes
      RETURNING
        VALUE(rt_check_routes) TYPE char1 .
    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING
        !is_param TYPE ztca_param_val
      EXPORTING
        !et_value TYPE any .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING
        !es_parameter TYPE ty_parameter
        !et_return    TYPE bapiret2_t .
ENDCLASS.



CLASS zcltm_process_roadnet IMPLEMENTATION.


  METHOD ajusta_etapa_transbordo.

    DATA:
      lt_mod           TYPE /bobf/t_frw_modification,
      lo_srv_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor       TYPE REF TO /bobf/if_tra_transaction_mgr,
      lt_root          TYPE /scmtms/t_tor_root_k,

      lt_tor_root_data TYPE /scmtms/t_tor_root_k,
      lt_tor_root_key  TYPE /bobf/t_frw_key,
      lt_tor_stop_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_data TYPE /scmtms/t_tor_docref_k,
      lt_return        TYPE bapiret2_tab,
*      lv_remessafu     TYPE /scmtms/base_btd_id.
      lv_ok            TYPE c,
      lv_remessafu     TYPE char10.

    DATA:
      lt_stop TYPE /scmtms/t_tor_stop_k,
      lr_stop TYPE REF TO /scmtms/s_tor_stop_k.

    DATA:
      lt_stop_succ TYPE /scmtms/t_tor_stop_succ_k,
      lr_stop_succ TYPE REF TO /scmtms/s_tor_stop_succ_k.

    DATA:
      lo_change_action     TYPE REF TO /bobf/if_tra_change,
      lo_message_action    TYPE REF TO /bobf/if_frw_message,
      lt_failed_key        TYPE /bobf/t_frw_key,
      lt_failed_action_key TYPE /bobf/t_frw_key,
      ls_param             TYPE REF TO data,
      ls_param_split_succ  TYPE /scmtms/s_tor_act_succ_addstag,

      lt_parameters        TYPE /bobf/t_frw_query_selparam,
      ls_parameter         TYPE /bobf/s_frw_query_selparam,
      lv_arrival           TYPE /scmtms/datetime.

    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.


    lo_tra_tor = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    lt_tor_root_data = it_tor_fu.

    CLEAR lt_tor_root_key.

    LOOP AT lt_tor_root_data INTO DATA(ls_root_data).
      CLEAR : lt_tor_root_key,
              lt_stop,
              lt_stop_succ,
              lt_tor_stop_key.

      lv_remessafu = |{ ls_root_data-base_btd_id ALPHA = OUT }|.
      lv_remessafu = |{ lv_remessafu ALPHA = IN }|.

*      lv_remessafu = ls_root_data-base_btd_id. "numero da remessa da FU.
*      SHIFT lv_remessafu LEFT DELETING LEADING '0'.
      CLEAR: lv_arrival,
             lv_ok.
      "procuarndo o stop na interface pela a remessa para pegar o campo Arrival correspondente a FU
      LOOP AT gt_stops ASSIGNING FIELD-SYMBOL(<fs_gstop>).
        LOOP AT <fs_gstop>-orders ASSIGNING FIELD-SYMBOL(<fs_orders>).
*          IF <fs_gstop>-orders-order_number = lv_remessafu.
          IF <fs_orders>-order_number = lv_remessafu.
            lv_arrival = <fs_gstop>-arrival.
            lv_ok = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.
        IF lv_ok = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = ls_root_data-key CHANGING ct_key = lt_tor_root_key ).


*   Busca informações de etapas/paradas
      lo_srv_tor->retrieve_by_association(
                                           EXPORTING
                                               it_key         = lt_tor_root_key
                                               iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                               iv_association = /scmtms/if_tor_c=>sc_association-root-stop
                                               iv_fill_data   = abap_true
                                           IMPORTING
                                                et_data = lt_stop ).

      me->ajusta_fu_stop(                  EXPORTING is_dados = is_dados
                                            CHANGING ct_stop  = lt_stop ).

      lo_srv_tor->retrieve_by_association(
                                           EXPORTING
                                               it_key         = lt_tor_root_key
                                               iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                               iv_association = /scmtms/if_tor_c=>sc_association-root-stop_succ
                                               iv_fill_data   = abap_true
                                           IMPORTING
                                                et_data = lt_stop_succ ).

*      CHECK lines( lt_stop_succ ) = 1.
      IF lines( lt_stop_succ ) = 1.

        DATA(lv_loc_uuid) = convert_loc_to_key( is_dados-dest_locid ).

        APPEND VALUE #( key = lt_stop_succ[ 1 ]-key ) TO lt_tor_stop_key.

        ls_param_split_succ-new_loc_key         = lv_loc_uuid.
        IF lv_arrival IS NOT INITIAL.
          ls_param_split_succ-arrival_timestamp   = lv_arrival. " is_dados-req_end.
          ls_param_split_succ-departure_timestamp = lv_arrival. "is_dados-req_start.
        ENDIF.

        GET REFERENCE OF ls_param_split_succ INTO ls_param.

*   Ação para inserir nova etapa
        lo_srv_tor->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-stop_successor-split_stage
                                         it_key                = lt_tor_stop_key
                                         is_parameters         = ls_param
                               IMPORTING eo_change             = lo_change_action
                                         eo_message            = lo_message_action
                                         et_failed_action_key  = lt_failed_action_key
                                         et_failed_key         = lt_failed_key ).


*--------------------------------------------------------------------*
* 18/02 -     carlos
*--------------------------------------------------------------------*
        lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                          IMPORTING ev_rejected         = DATA(lv_rejected)
                                    eo_change           = DATA(lo_change)
                                    eo_message          = DATA(lo_message_save)
                                    et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).

*   Converte mensagens de execução
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                               EXPORTING
                                                                iv_action_messages = space
                                                                io_message  = lo_message_save
                                                               CHANGING
                                                                ct_bapiret2 = lt_return ).
        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO rt_messages.
        ENDIF.
*--------------------------------------------------------------------*
        CLEAR lt_stop_succ.
        lo_srv_tor->retrieve_by_association(
                                            EXPORTING
                                                it_key         = lt_tor_root_key
                                                iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                iv_association = /scmtms/if_tor_c=>sc_association-root-stop_successor_all
                                                iv_fill_data   = abap_true
                                                iv_before_image = abap_false
                                            IMPORTING
                                                 et_data = lt_stop_succ ).
      ENDIF.
    ENDLOOP.
*--------------------------------------------------------------------*
* 18/02 -     carlos
*--------------------------------------------------------------------*
*    lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                  IMPORTING ev_rejected         = DATA(lv_rejected)
*                            eo_change           = DATA(lo_change)
*                            eo_message          = DATA(lo_message_save)
*                            et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).
**   Converte mensagens de execução
*    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
*     EXPORTING
*      iv_action_messages = space
*      io_message  = lo_message_save
*     CHANGING
*      ct_bapiret2 = lt_return ).
*    IF lt_return IS NOT INITIAL.
*      APPEND LINES OF lt_return TO rt_messages.
*    ENDIF.
*--------------------------------------------------------------------*
  ENDMETHOD.


  METHOD verifica_deposito_transbordo.

    IF is_dados-ori_loctype = 'DPT' AND is_dados-dest_loctype = 'DPT'.

      SELECT loctype FROM /sapapo/loc INTO TABLE @DATA(lt_loctype)
        WHERE locno = @is_dados-ori_locid OR locno = @is_dados-dest_locid.

      IF sy-subrc = 0.

*    CHECK is_dados-ori_loctype = 'DPT' AND is_dados-dest_loctype = 'DPT'.
        LOOP AT lt_loctype ASSIGNING FIELD-SYMBOL(<fs_loctype>).
          CASE <fs_loctype>-loctype." lv_loctype.
            WHEN '1170'.
              rv_true = abap_true.
            WHEN '1005'.
              rv_true = abap_false.
              EXIT.
          ENDCASE.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD ziftm_integracao_roadnet~executar.

    gv_centro = iv_centro.
    gv_data   = iv_data.



    DATA: ls_output TYPE zcltm_mt_consulta_sessao,
          ls_input  TYPE zcltm_mt_consulta_sessao_resp,
          lv_tor_id TYPE /scmtms/d_torrot-tor_id.

    FREE: et_road_session, et_road_item, et_road_log, et_messages.

    ls_output-mt_consulta_sessao-criteria-region_identity = iv_centro.
    ls_output-mt_consulta_sessao-criteria-date_start      = iv_data.

    IF iv_data_ate IS NOT INITIAL.
      ls_output-mt_consulta_sessao-criteria-date_end      = iv_data_ate.
    ELSE.
      ls_output-mt_consulta_sessao-criteria-date_end      = iv_data.
    ENDIF.

    ls_output-mt_consulta_sessao-options-retrieve_built      = 'false'.
    ls_output-mt_consulta_sessao-options-retrieve_active     = 'false'.
    ls_output-mt_consulta_sessao-options-retrieve_equipment  = 'false'.
    ls_output-mt_consulta_sessao-options-retrieve_published  = 'true'.
    ls_output-mt_consulta_sessao-options-level               = 'rdlStop'.

* ---------------------------------------------------------------------------
* Chamada da interface via proxy
* ---------------------------------------------------------------------------
    TRY.

        DATA(lo_roadnet) = NEW zcltm_co_si_consulta_sessao_ou( ).

        lo_roadnet->si_consulta_sessao_out( EXPORTING output = ls_output
                                            IMPORTING input  = ls_input ).

        IF ls_input-mt_consulta_sessao_resp-sessions IS INITIAL.
          " Nenhuma rota encontrada para continuar com o processamento.
          et_messages = VALUE #( BASE et_messages ( type        = 'E'
                                                    id          = 'ZTM_ROADNET_SESSION'
                                                    number      = COND #( WHEN iv_sessao IS NOT INITIAL THEN '003' ELSE '009' )
                                                    message_v1  = iv_sessao ) ).
          RETURN.
        ENDIF.

        SORT ls_input-mt_consulta_sessao_resp-sessions BY description.

* ---------------------------------------------------------------------------
* Monta registros para Aplicativo Parâmetros Roadnet
* ---------------------------------------------------------------------------
        me->build_roadnet_session( EXPORTING it_session      = ls_input-mt_consulta_sessao_resp-sessions[]
                                   IMPORTING et_road_session = et_road_session
                                             et_road_item    = et_road_item
                                             et_road_log     = et_road_log ).


* ---------------------------------------------------------------------------
* Executa processo - Entrega
* ---------------------------------------------------------------------------
        READ TABLE ls_input-mt_consulta_sessao_resp-sessions WITH KEY description = 'ENTREGA'
                                                             BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.

          LOOP AT ls_input-mt_consulta_sessao_resp-sessions FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_session>).

            IF <fs_session>-description NE 'ENTREGA'.
              EXIT.
            ENDIF.

            IF iv_testrun EQ abap_true.
              EXIT.
            ENDIF.

            DATA(lt_auxreturn) = process_session( EXPORTING is_session      = <fs_session>
                                                            iv_cross        = abap_false
                                                   CHANGING ct_road_session = et_road_session   " INSERT - JWSILVA - 21.02.2023
                                                            ct_road_item    = et_road_item
                                                            ct_road_log     = et_road_log ).    " INSERT - JWSILVA - 21.02.2023

            IF lt_auxreturn IS NOT INITIAL.
              APPEND LINES OF lt_auxreturn TO et_messages.
            ENDIF.

            me->update_roadnet_session( EXPORTING is_session      = <fs_session>
                                                  it_return       = lt_auxreturn
                                        CHANGING  ct_road_session = et_road_session
                                                  ct_road_item    = et_road_item
                                                  ct_road_log     = et_road_log ).

          ENDLOOP. " Fim do loop da sessions.

        ENDIF.

* ---------------------------------------------------------------------------
* Executa processo - Cross Docking
* ---------------------------------------------------------------------------
        READ TABLE ls_input-mt_consulta_sessao_resp-sessions WITH KEY description = 'CROSSDOCKING'
                                                             BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.

          LOOP AT ls_input-mt_consulta_sessao_resp-sessions FROM sy-tabix ASSIGNING <fs_session>.

            IF <fs_session>-description NE 'CROSSDOCKING'.
              EXIT.
            ENDIF.

            IF iv_testrun EQ abap_true.
              EXIT.
            ENDIF.

            lt_auxreturn = process_session( EXPORTING is_session      = <fs_session>
                                                      iv_cross        = abap_true
                                             CHANGING ct_road_session = et_road_session     " INSERT - JWSILVA - 21.02.2023
                                                      ct_road_item    = et_road_item
                                                      ct_road_log     = et_road_log ).      " INSERT - JWSILVA - 21.02.2023

            IF lt_auxreturn IS NOT INITIAL.
              APPEND LINES OF lt_auxreturn TO et_messages.
            ENDIF.

            me->update_roadnet_session( EXPORTING is_session      = <fs_session>
                                                  it_return       = lt_auxreturn
                                        CHANGING  ct_road_session = et_road_session
                                                  ct_road_item    = et_road_item
                                                  ct_road_log     = et_road_log ).

          ENDLOOP."fim do loop da sessions.

        ENDIF.

      CATCH cx_ai_system_fault.

    ENDTRY.

* ---------------------------------------------------------------------------
* Salva registros para Aplicativo Parâmetros Roadnet
* ---------------------------------------------------------------------------
    me->save_roadnet_session( EXPORTING it_road_session = et_road_session
                                        it_road_item    = et_road_item
                                        it_road_log     = et_road_log
                              IMPORTING et_return       = DATA(lt_return) ).

    SORT et_messages BY id number message_v1 message_v2 message_v3 message_v4.
    DELETE ADJACENT DUPLICATES FROM et_messages COMPARING id number message_v1 message_v2 message_v3 message_v4.

  ENDMETHOD.


  METHOD gera_fo.

    DATA:
      lo_message TYPE REF TO /bobf/if_frw_message,
      lt_return  TYPE bapiret2_tab.

    "Criar ordem de frete
    /scmtms/cl_tor_factory=>create_tor_tour(
      EXPORTING
         iv_do_modify            = abap_true
         iv_tor_type             = is_dados-tor_type
         iv_create_initial_stage = abap_true
         iv_creation_type        = /scmtms/if_tor_const=>sc_creation_type-manual
      IMPORTING
         es_tor_root             = DATA(ls_tor_root)
         et_tor_item             = DATA(lt_tor_item)
         et_tor_stop             = DATA(lt_tor_stop)
      CHANGING
         co_message              = lo_message ).

    es_root = ls_tor_root.
    et_item = lt_tor_item.
    et_stop = lt_tor_stop.

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).
      APPEND LINES OF lt_return TO rt_messages.
    ENDIF.

  ENDMETHOD.


  METHOD cria_ordem_frete.

    DATA: lt_tor_item_aux     TYPE TABLE OF /scmtms/s_tor_item_tr_k,
          lt_tor_root         TYPE /scmtms/t_tor_root_k,
          lt_tor_stop_aux     TYPE TABLE OF /scmtms/s_tor_stop_k,
          lt_tor_stop_succ    TYPE /scmtms/t_tor_stop_succ_k,
          lt_tor_party        TYPE /scmtms/t_tor_party_k,
          lt_stop_succ        TYPE /scmtms/t_tor_stop_succ_k,
          lr_stop_succ        TYPE REF TO /scmtms/s_tor_stop_succ_k,
          lt_tor_root_key     TYPE /bobf/t_frw_key,
          lt_tor_stop_key     TYPE /bobf/t_frw_key,
          lt_fu_stop          TYPE /scmtms/t_tor_stop_k,
          lt_fu_stop_i        TYPE /scmtms/t_tor_stop_k,
          lt_key_fu           TYPE /bobf/t_frw_key,
          lt_mod              TYPE /bobf/t_frw_modification,
          ls_param            TYPE REF TO data,
          ls_param_split_succ TYPE /scmtms/s_tor_act_succ_addstag,
          lo_message_header   TYPE REF TO /bobf/if_frw_message,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          lt_mod_root         TYPE /bobf/t_frw_modification,
          lt_changed          TYPE /bobf/t_frw_name,
          lt_result           TYPE /bobf/t_frw_keyindex,

          ls_tor_root         TYPE /scmtms/s_tor_root_k,
          lt_tor_stop         TYPE /scmtms/t_tor_stop_k,
          lt_tor_item         TYPE /scmtms/t_tor_item_tr_k.
    .

    DATA: lv_rejected         TYPE boole_d,
          lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

    DATA: lt_return  TYPE bapiret2_tab,
          lt_message TYPE /bobf/t_frw_message_k.

    CONSTANTS : lc_tortype TYPE /scmtms/tor_type VALUE '1010'.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_txn_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    "Criar ordem de frete

    lt_return = gera_fo( EXPORTING is_dados        = is_dados
                                   is_session      = is_session        " INSERT - JWSILVA - 21.02.2023
                                   is_routes       = is_routes         " INSERT - JWSILVA - 21.02.2023
                         IMPORTING es_root         = ls_tor_root
                                   et_item         = lt_tor_item
                                   et_stop         = lt_tor_stop
                         CHANGING  ct_road_session = ct_road_session   " INSERT - JWSILVA - 21.02.2023
                                   ct_road_item    = ct_road_item      " INSERT - JWSILVA - 21.02.2023
                                   ct_road_log     = ct_road_log ).    " INSERT - JWSILVA - 21.02.2023

    lt_tor_item_aux = lt_tor_item.

    READ TABLE lt_tor_item ASSIGNING FIELD-SYMBOL(<fs_item_tr>) INDEX 1.

    IF sy-subrc IS INITIAL.
      <fs_item_tr>-tures_tco       = is_dados-tures_tco.
      <fs_item_tr>-tures_cat       = is_dados-tures_cat.

      <fs_item_tr>-item_type       = gc_itmtype_truc.
      <fs_item_tr>-item_cat        = gc_itemcat_avr.
      <fs_item_tr>-platenumber     = is_dados-platenumber.

    ENDIF.

    ls_tor_root-tor_cat       = 'TO'.
    ls_tor_root-labeltxt      = is_dados-labeltxt.
    ls_tor_root-tspid         = is_dados-tsp_id.
    ls_tor_root-tsp           = convert_bp_to_key( is_dados-tsp_id ).
    ls_tor_root-tor_type      = lc_tortype.

    APPEND:  'TOR_CAT'   TO lt_changed,
             'TOR_TYPE'  TO lt_changed,
             'TSPID'     TO lt_changed,
             'LABELTXT'  TO lt_changed,
             'TSP'       TO lt_changed.

    DATA(lv_bpkind)       = busca_tipo_bp( is_dados-zz_motorista ).
    DATA(lv_partner_guid) = convert_bp_to_key( is_dados-zz_motorista ).

    CASE lv_bpkind.

      WHEN '0011'.
        APPEND:   'ZZ_MOTORISTA'   TO lt_changed.
        ls_tor_root-zz_motorista = is_dados-zz_motorista.

        APPEND INITIAL LINE TO lt_tor_party ASSIGNING FIELD-SYMBOL(<fs_tor_party>).

        <fs_tor_party>-parent_key     = ls_tor_root-key.
        <fs_tor_party>-root_key       = ls_tor_root-key.

        <fs_tor_party>-party_rco      = 'YM'.
        <fs_tor_party>-party_id       = is_dados-zz_motorista.
        <fs_tor_party>-party_uuid     = lv_partner_guid.

        SELECT SINGLE partner2 INTO ls_tor_root-tspid
          FROM but050
          WHERE partner1 = is_dados-zz_motorista.


      WHEN '0020'.

        ls_tor_root-tspid         = is_dados-tsp_id.

    ENDCASE.

    " Atualiza campos da Ordem de Frete
    TRY.
        zcltm_manage_of=>change_of( EXPORTING iv_interface = zcltm_manage_of=>gc_interface-roadnet
                                    CHANGING  cs_root      = ls_tor_root
                                              ct_changed   = lt_changed ).
      CATCH cx_root.
    ENDTRY.

    INSERT ls_tor_root INTO TABLE lt_tor_root.


    DATA:
      lr_locno_range   TYPE /sctm/tt_locno_r,
      ls_locno_range   LIKE LINE OF lr_locno_range,
      lt_locations_aux TYPE /scmtms/cl_loc_helper=>ty_t_loc,
      lt_locations     TYPE TABLE OF /scmtms/cl_loc_helper=>ty_s_loc WITH KEY locno.


*    lr_locno_range = VALUE /sctm/tt_locno_r( ( sign = 'I' option = 'EQ' low = 'SP_2003' )
*                                             ( sign = 'I' option = 'EQ' low = '1000000044' )
*                                            ).

    lr_locno_range = VALUE /sctm/tt_locno_r( ( sign = 'I' option = 'EQ' low = is_dados-ori_locid )
                                              ( sign = 'I' option = 'EQ' low = is_dados-dest_locid )
                                             ).

    CALL METHOD /scmtms/cl_loc_helper=>get_locations_by_locno
      EXPORTING
        it_locno_range = lr_locno_range
      IMPORTING
        et_locations   = lt_locations_aux.

    lt_locations = lt_locations_aux.

    "Converter origem e destino
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_location_c=>sc_node-root
        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
        it_key        = VALUE /scmtms/t_loc_alt_id( ( is_dados-ori_locid ) ( is_dados-dest_locid ) )
      IMPORTING
        et_result     = lt_result ).

    "Definir os pontos de origem e destino
    LOOP AT lt_tor_stop ASSIGNING FIELD-SYMBOL(<fs_stop>).

      IF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.

        <fs_stop>-log_locid    = is_dados-ori_locid.        "'SP_2003'.

        <fs_stop>-log_loc_uuid = lt_result[ 1 ]-key.
*        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
        CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

*
*        READ TABLE lt_locations WITH KEY locno = is_dados-ori_locid
*        BINARY SEARCH INTO DATA(ls_location).
*
*        IF sy-subrc = 0.
*          <fs_stop>-log_loc_uuid = ls_location-locuuid.
*          CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*        ENDIF.

      ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.

        <fs_stop>-log_locid    = is_dados-dest_locid. "'1000000044'.

        <fs_stop>-log_loc_uuid = lt_result[ 2 ]-key.
*        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
        CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

*
*        READ TABLE lt_locations
*        WITH KEY locno = is_dados-dest_locid
*        BINARY SEARCH INTO ls_location .
*
*        IF sy-subrc = 0.
*          <fs_stop>-log_loc_uuid = ls_location-locuuid.
*          CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*        ENDIF.

      ELSE.
        CONTINUE.
      ENDIF.

    ENDLOOP.

*    APPEND INITIAL LINE TO lt_tor_stop_aux ASSIGNING FIELD-SYMBOL(<fs_tor_stop>).
*
*    <fs_tor_stop>-parent_key     = <fs_stop>-parent_key.
*    <fs_tor_stop>-root_key       = <fs_stop>-root_key.
*    CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.


    "Atualização do TOR
    INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                   node           = /scmtms/if_tor_c=>sc_node-root
                   key            = ls_tor_root-key
                   changed_fields = lt_changed
                   data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.

*    /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
*                                                       it_data        = lt_tor_root
*                                              CHANGING ct_mod         = lt_mod ).
*
*    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
*                                                       it_data        = lt_tor_root
*                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                              CHANGING ct_mod         = lt_mod ).

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_tor_item
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                              CHANGING ct_mod         = lt_mod ).

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_tor_stop
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-stop
                                              CHANGING ct_mod         = lt_mod ).

*    /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data        = lt_tor_stop_aux
*                                                       iv_node        = /scmtms/if_tor_c=>sc_node-stop
*                                                       iv_source_node = /scmtms/if_tor_c=>sc_node-root
*                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-stop
*                                              CHANGING ct_mod         = lt_mod ).
*
*    /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data        = lt_tor_party
*                                                       iv_node        = /scmtms/if_tor_c=>sc_node-party
*                                                       iv_source_node = /scmtms/if_tor_c=>sc_node-root
*                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-party
*                                              CHANGING ct_mod         = lt_mod ).

    CALL METHOD lo_tor_mgr->modify
      EXPORTING
        it_modification = lt_mod_root
      IMPORTING
        eo_change       = lo_change
        eo_message      = lo_message.

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
      CLEAR lo_message.
    ENDIF.

    lo_tor_mgr->modify( EXPORTING it_modification = lt_mod
                        IMPORTING eo_change = lo_change
                                  eo_message = lo_message ).

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
    ENDIF.

    lo_txn_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected           = lv_rejected
                                eo_change             = lo_change
                                eo_message            = lo_message_save
                                et_rejecting_bo_key   = ls_rejecting_bo_key ).


    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.

    ENDIF.

    IF NOT lo_message_save IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.

    ENDIF.

    IF lv_rejected IS INITIAL.

      SELECT SINGLE tor_id
          INTO @DATA(lv_torid)
          FROM /scmtms/d_torrot
          WHERE db_key = @ls_tor_root-key.

      APPEND VALUE /scmtms/s_tor_root_k( tor_id = lv_torid ) TO gt_tor_fo.

      IF sy-subrc = 0.
      ENDIF.
    ELSE.

    ENDIF.

    lt_return = atualiza_status_fo( io_tor_mgr = lo_tor_mgr iv_tor_key = ls_tor_root-key ).
    APPEND LINES OF lt_return TO rt_messages.

  ENDMETHOD.


  METHOD cria_ordem_frete_mae.

    DATA: lt_tor_item_aux     TYPE TABLE OF /scmtms/s_tor_item_tr_k,
          lt_tor_root         TYPE /scmtms/t_tor_root_k,
          lt_tor_stop_aux     TYPE TABLE OF /scmtms/s_tor_stop_k,
          lt_tor_stop_succ    TYPE /scmtms/t_tor_stop_succ_k,
          lt_tor_party        TYPE /scmtms/t_tor_party_k,
          lt_stop_succ        TYPE /scmtms/t_tor_stop_succ_k,
          lr_stop_succ        TYPE REF TO /scmtms/s_tor_stop_succ_k,
          lt_tor_root_key     TYPE /bobf/t_frw_key,
          lt_tor_stop_key     TYPE /bobf/t_frw_key,
          lt_tor_fu           TYPE /scmtms/t_tor_root_k,
          lt_fu_stop          TYPE /scmtms/t_tor_stop_k,
          lt_fu_stop_i        TYPE /scmtms/t_tor_stop_k,
          lt_key_fu           TYPE /bobf/t_frw_key,
          lt_mod              TYPE /bobf/t_frw_modification,
          ls_param            TYPE REF TO data,
          ls_param_split_succ TYPE /scmtms/s_tor_act_succ_addstag,
          lo_message_header   TYPE REF TO /bobf/if_frw_message,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          lt_mod_root         TYPE /bobf/t_frw_modification,
          lt_changed          TYPE /bobf/t_frw_name,
          lt_result           TYPE /bobf/t_frw_keyindex,

          ls_tor_root         TYPE /scmtms/s_tor_root_k,
          lt_tor_stop         TYPE /scmtms/t_tor_stop_k,
          lt_tor_item         TYPE /scmtms/t_tor_item_tr_k.

    DATA: lv_rejected         TYPE boole_d,
          lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

    DATA: lt_return  TYPE bapiret2_tab,
          lt_message TYPE /bobf/t_frw_message_k.

    CONSTANTS : lc_tortype TYPE /scmtms/tor_type VALUE '1020'.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_txn_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    "Criar ordem de frete
    lt_return = gera_fo( EXPORTING is_dados         = is_dados
                                   is_session       = is_session        " INSERT - JWSILVA - 21.02.2023
                                   is_routes        = is_routes         " INSERT - JWSILVA - 21.02.2023
                         IMPORTING es_root          = ls_tor_root
                                   et_item          = lt_tor_item
                                   et_stop          = lt_tor_stop
                         CHANGING  ct_road_session  = ct_road_session   " INSERT - JWSILVA - 21.02.2023
                                   ct_road_item     = ct_road_item      " INSERT - JWSILVA - 21.02.2023
                                   ct_road_log      = ct_road_log ).    " INSERT - JWSILVA - 21.02.2023

    lt_tor_item_aux = lt_tor_item.

    READ TABLE lt_tor_item ASSIGNING FIELD-SYMBOL(<fs_item_tr>) INDEX 1.

    IF sy-subrc IS INITIAL.

      <fs_item_tr>-tures_tco       = is_dados-tures_tco.
      <fs_item_tr>-tures_cat       = is_dados-tures_cat.
      <fs_item_tr>-item_type       = gc_itmtype_truc.
      <fs_item_tr>-item_cat        = gc_itemcat_avr.
      <fs_item_tr>-platenumber     = is_dados-platenumber.

    ENDIF.

    ls_tor_root-tor_cat       = 'TO'.
    ls_tor_root-labeltxt      = is_dados-labeltxt.
    ls_tor_root-tspid         = is_dados-tsp_id.
    ls_tor_root-tsp           = convert_bp_to_key( is_dados-tsp_id ).
    ls_tor_root-tor_type      = lc_tortype.

    APPEND:  'TOR_CAT'   TO lt_changed,
             'TOR_TYPE'  TO lt_changed,
             'TSPID'     TO lt_changed,
             'LABELTXT'  TO lt_changed,
             'TSP'       TO lt_changed.

    DATA(lv_bpkind)       = busca_tipo_bp( is_dados-zz_motorista ).
    DATA(lv_partner_guid) = convert_bp_to_key( is_dados-zz_motorista ).

    CASE lv_bpkind.

      WHEN '0011'.
        APPEND:   'ZZ_MOTORISTA'   TO lt_changed.
        ls_tor_root-zz_motorista = is_dados-zz_motorista.

        APPEND INITIAL LINE TO lt_tor_party ASSIGNING FIELD-SYMBOL(<fs_tor_party>).

        <fs_tor_party>-parent_key     = ls_tor_root-key.
        <fs_tor_party>-root_key       = ls_tor_root-key.

        <fs_tor_party>-party_rco      = 'YM'.
        <fs_tor_party>-party_id       = is_dados-zz_motorista.
        <fs_tor_party>-party_uuid     = lv_partner_guid.

        SELECT SINGLE partner2 INTO ls_tor_root-tspid
          FROM but050
          WHERE partner1 = is_dados-zz_motorista.


      WHEN '0020'.

*        ls_tor_root-tspid         = is_dados-tsp_id.
        ls_tor_root-tspid         = is_dados-zz_motorista.
        ls_tor_root-tsp           = lv_partner_guid.

    ENDCASE.

    " Atualiza campos da Ordem de Frete
    TRY.
        zcltm_manage_of=>change_of( EXPORTING iv_interface = zcltm_manage_of=>gc_interface-roadnet
                                    CHANGING  cs_root      = ls_tor_root
                                              ct_changed   = lt_changed ).
      CATCH cx_root.
    ENDTRY.

    INSERT ls_tor_root INTO TABLE lt_tor_root.

    DATA:
      lr_locno_range   TYPE /sctm/tt_locno_r,
      ls_locno_range   LIKE LINE OF lr_locno_range,
      lt_locations_aux TYPE /scmtms/cl_loc_helper=>ty_t_loc,
      lt_locations     TYPE TABLE OF /scmtms/cl_loc_helper=>ty_s_loc WITH KEY locno.


    lr_locno_range = VALUE /sctm/tt_locno_r( ( sign = 'I' option = 'EQ' low = is_dados-ori_locid )
                                             ( sign = 'I' option = 'EQ' low = is_dados-dest_locid )
                                            ).

    CALL METHOD /scmtms/cl_loc_helper=>get_locations_by_locno
      EXPORTING
        it_locno_range = lr_locno_range
      IMPORTING
        et_locations   = lt_locations_aux.

    lt_locations = lt_locations_aux.

    SORT lt_locations BY locno.

    "Converter origem e destino
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_location_c=>sc_node-root
        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
        it_key        = VALUE /scmtms/t_loc_alt_id( ( is_dados-ori_locid ) ( is_dados-dest_locid ) )
      IMPORTING
        et_result     = lt_result ).

    "Definir os pontos de origem e destino
    LOOP AT lt_tor_stop ASSIGNING FIELD-SYMBOL(<fs_stop>).

      IF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.

        <fs_stop>-log_locid    = is_dados-ori_locid.        "'SP_2003'.

        <fs_stop>-log_loc_uuid = lt_result[ 1 ]-key.
*        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
        CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

*        READ TABLE lt_locations WITH KEY locno = is_dados-ori_locid
*        BINARY SEARCH INTO DATA(ls_location).
*
*        IF sy-subrc = 0.
*          <fs_stop>-log_loc_uuid = ls_location-locuuid.
*          CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*        ENDIF.

      ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.

        <fs_stop>-log_locid    = is_dados-dest_locid. "'1000000044'.
        <fs_stop>-log_loc_uuid = lt_result[ 2 ]-key.
*        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
        CONVERT DATE sy-datum TIME sy-uzeit INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*
*        READ TABLE lt_locations
*        WITH KEY locno = is_dados-dest_locid
*        BINARY SEARCH INTO ls_location .
*
*        IF sy-subrc = 0.
*          <fs_stop>-log_loc_uuid = ls_location-locuuid.
*          CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*        ENDIF.

      ELSE.
        CONTINUE.
      ENDIF.

*      IF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.
*        <fs_stop>-log_locid    = 'SP_2003'.
*        READ TABLE lt_locations INTO DATA(ls_location) WITH KEY locno = 'SP_2003' BINARY SEARCH.
*        <fs_stop>-log_loc_uuid = ls_location-locuuid.
*        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*
*      ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.
*        <fs_stop>-log_locid    = '1000000044'.
*        READ TABLE lt_locations INTO ls_location WITH KEY locno = '1000000044' BINARY SEARCH.
*        <fs_stop>-log_loc_uuid = ls_location-locuuid.
*        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.
*
*      ELSE.
*        CONTINUE.
*      ENDIF.

    ENDLOOP.


*    APPEND INITIAL LINE TO lt_tor_stop_aux ASSIGNING FIELD-SYMBOL(<fs_tor_stop>).
*
*    <fs_tor_stop>-parent_key     = <fs_stop>-parent_key.
*    <fs_tor_stop>-root_key       = <fs_stop>-root_key.
*
*    CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.


    "Atualização do TOR
    INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                   node           = /scmtms/if_tor_c=>sc_node-root
                   key            = ls_tor_root-key
                   changed_fields = lt_changed
                   data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.


*    /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
*                                                       it_data        = lt_tor_root
*                                              CHANGING ct_mod         = lt_mod ).
*
*    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
*                                                       it_data        = lt_tor_root
*                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                              CHANGING ct_mod         = lt_mod ).

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_tor_item
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                              CHANGING ct_mod         = lt_mod ).

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_tor_stop
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-stop
                                              CHANGING ct_mod         = lt_mod ).

*    /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data        = lt_tor_stop_aux
*                                                       iv_node        = /scmtms/if_tor_c=>sc_node-stop
*                                                       iv_source_node = /scmtms/if_tor_c=>sc_node-root
*                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-stop
*                                              CHANGING ct_mod         = lt_mod ).
*
*    /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING it_data        = lt_tor_party
*                                                       iv_node        = /scmtms/if_tor_c=>sc_node-party
*                                                       iv_source_node = /scmtms/if_tor_c=>sc_node-root
*                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-party
*                                              CHANGING ct_mod         = lt_mod ).

    CALL METHOD lo_tor_mgr->modify
      EXPORTING
        it_modification = lt_mod_root
      IMPORTING
        eo_change       = lo_change
        eo_message      = lo_message.

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
      CLEAR lo_message.
    ENDIF.

    lo_tor_mgr->modify( EXPORTING it_modification = lt_mod
                        IMPORTING eo_change = lo_change
                                  eo_message = lo_message ).

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
      CLEAR lo_message.
    ENDIF.

    lo_txn_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected           = lv_rejected
                                eo_change             = lo_change
                                eo_message            = lo_message_save
                                et_rejecting_bo_key   = ls_rejecting_bo_key ).



    lt_return = associa_unidade_frete( is_tor_root = ls_tor_root
                                       it_tor_fu   = it_tor_fu   "lt_tor_fu
                                       io_tor_mgr  = lo_tor_mgr
                                       io_txn_mgr  = lo_txn_mgr
                                       iv_data     = gv_data
                                       iv_centro   = gv_centro ).

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      APPEND LINES OF lt_return TO rt_messages.
    ENDIF.

    IF NOT lo_message_save IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      APPEND LINES OF lt_return TO rt_messages.
    ENDIF.

    IF lv_rejected IS INITIAL.

      SELECT SINGLE tor_id
          INTO @DATA(lv_torid)
          FROM /scmtms/d_torrot
          WHERE db_key = @ls_tor_root-key.

      APPEND VALUE /scmtms/s_tor_root_k( tor_id = lv_torid ) TO gt_tor_fo.

      IF sy-subrc = 0.
      ENDIF.
    ELSE.
    ENDIF.

    lt_return = atualiza_status_fo( io_tor_mgr = lo_tor_mgr iv_tor_key = ls_tor_root-key ).
    APPEND LINES OF lt_return TO rt_messages.

  ENDMETHOD.


  METHOD processamento_frete.

    FREE: ev_tor_id.

    DATA(lt_tor_fu) = busca_fu( is_dados ).

    IF verifica_deposito_transbordo( is_dados = is_dados ) = abap_true.
      DATA(lt_messages) = ajusta_etapa_transbordo( is_dados  = is_dados it_tor_fu = lt_tor_fu ). " Ajusta etapas FU
      APPEND LINES OF lt_messages TO rt_messages.
    ENDIF.

    "Criar FO
    lt_messages = cria_ordem_frete_s_redesp( EXPORTING is_dados      = is_dados
                                                       it_tor_fu     = lt_tor_fu
                                                       iv_transbordo = iv_transbordo
                                                       is_session    = is_session           " INSERT - JWSILVA - 21.02.2023
                                                       is_routes     = is_routes            " INSERT - JWSILVA - 21.02.2023
                                             IMPORTING ev_tor_id     = ev_tor_id
                                             CHANGING  ct_road_session  = ct_road_session   " INSERT - JWSILVA - 21.02.2023
                                                       ct_road_item     = ct_road_item      " INSERT - JWSILVA - 21.02.2023
                                                       ct_road_log      = ct_road_log ).    " INSERT - JWSILVA - 21.02.2023

    APPEND LINES OF lt_messages TO rt_messages.


*    CASE verifica_deposito_transbordo( is_dados = is_dados ).
*      WHEN abap_true.
*
*        "Ajusta etapas FU
*        DATA(lt_messages) = ajusta_etapa_transbordo( is_dados  = is_dados it_tor_fu = lt_tor_fu ).
*        APPEND LINES OF lt_messages TO rt_messages.
*
*        lt_messages = cria_ordem_frete_s_redesp( EXPORTING is_dados      = is_dados
*                                                           it_tor_fu     = lt_tor_fu
*                                                           iv_transbordo = iv_transbordo
*                                                 IMPORTING ev_tor_id     = ev_tor_id ).
*
*      WHEN abap_false.
*
*        "Criar FO sem redespacho
*        lt_messages = cria_ordem_frete_s_redesp( EXPORTING is_dados      = is_dados
*                                                           it_tor_fu     = lt_tor_fu
*                                                           iv_transbordo = iv_transbordo
*                                                 IMPORTING ev_tor_id     = ev_tor_id ).
*
*        APPEND LINES OF lt_messages TO rt_messages.
*
*    ENDCASE.

  ENDMETHOD.


  METHOD associa_unidade_frete.

    DATA: lo_change_action     TYPE REF TO /bobf/if_tra_change,
          lo_message_action    TYPE REF TO /bobf/if_frw_message,
          lt_failed_key        TYPE /bobf/t_frw_key,
          lt_failed_action_key TYPE /bobf/t_frw_key,
          lt_key               TYPE /bobf/t_frw_key,
          lt_keys_fu           TYPE /bobf/t_frw_key,
          ls_parameters        TYPE /scmtms/s_tor_a_add_elements,
          ls_parameters_pln    TYPE /scmtms/s_tor_a_add_fu_pln,
          lt_param             TYPE REF TO data,
          lt_fu_stop_succ      TYPE /scmtms/t_tor_stop_succ_k,
          lt_return            TYPE bapiret2_tab.

    DATA(lv_with_key) = abap_true.
    DATA: lr_param_key TYPE /bobf/s_frw_key.

    CLEAR lt_key.
    APPEND VALUE #( key = is_tor_root-key ) TO lt_key.

    DATA: lv_remessa TYPE likp-vbeln,
          ls_indx    TYPE indx.
    LOOP AT it_tor_fu INTO DATA(ls_tor_fu).
*      IF sy-uname = 'CGARCIA' OR sy-uname = 'MSPEREIRA'.
      lv_remessa = |{ ls_tor_fu-base_btd_id ALPHA = OUT }|.
      IF lv_remessa IS NOT INITIAL.
        lv_remessa = |{ lv_remessa ALPHA = IN }|.
        EXPORT remessa = lv_remessa TO DATABASE indx(zt) FROM ls_indx CLIENT sy-mandt ID lv_remessa.
      ENDIF.
*      ENDIF.

      CLEAR : lr_param_key.
      lr_param_key-key = ls_tor_fu-key.
      APPEND lr_param_key TO ls_parameters-target_item_keys.

      CONCATENATE ls_parameters-string
                 ls_tor_fu-tor_id
            INTO ls_parameters-string SEPARATED BY space.

      GET REFERENCE OF ls_parameters INTO lt_param.

*      IF lv_with_key IS NOT INITIAL.
*        lr_param_key-key = ls_tor_fu-key.
*        APPEND lr_param_key TO ls_parameters-target_item_keys.
*      ELSE.
*
*        SHIFT ls_tor_fu-tor_id RIGHT DELETING TRAILING space.
*        SHIFT ls_tor_fu-tor_id LEFT  DELETING LEADING  space.
*        SHIFT ls_tor_fu-tor_id LEFT  DELETING LEADING  '0'.
*
*        CONCATENATE ls_parameters-string
*                    ls_tor_fu-tor_id
*               INTO ls_parameters-string SEPARATED BY space.
*
*      ENDIF.

*      AT LAST.
*
      io_tor_mgr->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-add_fu_by_fuid
                                       it_key                = lt_key
                                       is_parameters         = lt_param
                             IMPORTING eo_change             = lo_change_action
                                       eo_message            = lo_message_action
                                       et_failed_action_key  = lt_failed_action_key
                                       et_failed_key         = lt_failed_key ).


      IF lo_message_action IS BOUND .
        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
                                                               CHANGING  ct_bapiret2 = lt_return[] ).
        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO rt_return.
        ENDIF.
      ELSE.

      ENDIF.

      CLEAR: ls_parameters,
             lo_message_action,
             lt_param.
*
*      ENDAT.

    ENDLOOP.
*    IF lt_param IS NOT INITIAL.
*      io_tor_mgr->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-add_fu_by_fuid
*                                          it_key                = lt_key
*                                          is_parameters         = lt_param
*                                IMPORTING eo_change             = lo_change_action
*                                          eo_message            = lo_message_action
*                                          et_failed_action_key  = lt_failed_action_key
*                                          et_failed_key         = lt_failed_key ).
*
*
*      IF lo_message_action IS BOUND .
*        CLEAR lt_return.
*        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
*                                                               CHANGING  ct_bapiret2 = lt_return[] ).
*        IF lt_return IS NOT INITIAL.
*          APPEND LINES OF lt_return TO rt_return.
*        ENDIF.
*      ELSE.
*
*      ENDIF.
*    ENDIF.
*
*    CLEAR: ls_parameters,
*           lo_message_action,
*           lt_param.

    io_txn_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected         = DATA(lv_rejected)
                                eo_change           = DATA(lo_change)
                                eo_message          = DATA(lo_message_save)
                                et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).

    CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
      EXPORTING
        werks          = iv_centro
        dtsession      = iv_data
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc = 0.
      DATA(lv_enqueue) = abap_true.
    ENDIF.

    IF NOT lo_message_action IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_return.
      ENDIF.
    ENDIF.



    IF NOT lo_message_save IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_return.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD convert_bp_to_key.


    SELECT SINGLE
      partner_guid
      INTO rv_key
      FROM but000
      WHERE partner = iv_partner.

  ENDMETHOD.


  METHOD busca_tipo_bp.

    SELECT SINGLE
      bpkind
      INTO rv_kind
      FROM but000
      WHERE partner = iv_partner.

  ENDMETHOD.


  METHOD convert_loc_to_key.

    SELECT SINGLE loc_uuid FROM /sapapo/loc INTO rv_loc_uuid
      WHERE locno = iv_locno.

  ENDMETHOD.


  METHOD busca_fu.

    DATA:
      lo_srv_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor       TYPE REF TO /bobf/if_tra_transaction_mgr,

      lt_tor_root_data TYPE /scmtms/t_tor_root_k,
      lt_tor_root_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_data TYPE /scmtms/t_tor_docref_k,
      lt_return        TYPE bapiret2_tab,
      lv_seq           TYPE n LENGTH 4,
      lv_vbeln         TYPE vbeln_vl,
      lv_btd_id        TYPE /scmtms/base_btd_id.

    DATA:
      lt_parameters TYPE /bobf/t_frw_query_selparam,
      ls_parameter  TYPE /bobf/s_frw_query_selparam.

    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    lv_seq = 1.

    CLEAR: gt_rembp[],
           lt_parameters[].

    LOOP AT gt_stops ASSIGNING FIELD-SYMBOL(<fs_gstop>).
      LOOP AT <fs_gstop>-orders ASSIGNING FIELD-SYMBOL(<fs_orders>).

        APPEND INITIAL LINE TO gt_rembp ASSIGNING FIELD-SYMBOL(<fs_remessa>).
        <fs_remessa>-vbeln            = <fs_orders>-order_number.
        UNPACK <fs_remessa>-vbeln TO <fs_remessa>-vbeln.
        <fs_orders>-order_number       = <fs_remessa>-vbeln.
        <fs_remessa>-latitude          = <fs_gstop>-latitude.
        <fs_remessa>-longitude         = <fs_gstop>-longitude.
        <fs_remessa>-seq               = lv_seq.
        <fs_remessa>-arrival           = <fs_gstop>-arrival.
        <fs_remessa>-tempo_servico     = <fs_gstop>-service_time.
        <fs_remessa>-distance_km       = <fs_gstop>-distance.
        ADD 1 TO lv_seq.

        APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
        <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-base_btd_id.
        <fs_parameters>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_parameters>-option         = /bobf/if_conf_c=>sc_sign_equal.
        <fs_parameters>-low            = <fs_orders>-order_number. "is_dados-remessa.
      ENDLOOP.
    ENDLOOP.

    APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-attribute_name     = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_cat.
    <fs_parameters>-sign               = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_parameters>-option             = /bobf/if_conf_c=>sc_sign_equal.
    <fs_parameters>-low                = /scmtms/if_tor_const=>sc_tor_category-freight_unit.

* Busca referencias (FU) a partir da remessa
    IF lt_parameters IS NOT INITIAL.

*     Busca dados das FUs
      lo_srv_tor->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements " Query
                                   it_selection_parameters = lt_parameters                                 " Query Selection Parameters
                                   iv_fill_data            = abap_true                                     " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                         IMPORTING et_data                 = lt_tor_root_data ).

*      lo_srv_tor->query(
*                        EXPORTING
*                          iv_query_key            = /scmtms/if_tor_c=>sc_query-docreference-docreference_elements
*                          it_selection_parameters = lt_parameters
*                          iv_fill_data            = abap_true
*                        IMPORTING
*                          et_key                  = lt_tor_refe_key
*                          et_data                 = lt_tor_refe_data ).
    ENDIF.

*    LOOP AT lt_tor_refe_data ASSIGNING FIELD-SYMBOL(<fs_refe_data>).
*      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_refe_data>-root_key CHANGING ct_key = lt_tor_root_key ).
*    ENDLOOP.

*   Busca dados das FUs
*    lo_srv_tor->retrieve(
*                           EXPORTING
*                               it_key        = lt_tor_root_key
*                               iv_node_key   = /scmtms/if_tor_c=>sc_node-root
*                           IMPORTING
*                               et_data       = lt_tor_root_data
*                           ).

*   Considerar somente FU
    DELETE lt_tor_root_data WHERE archiving_time IS NOT INITIAL. "#EC CI_SORTSEQ

*    DELETE lt_tor_root_data WHERE tor_cat        <> /scmtms/if_tor_const=>sc_tor_category-freight_unit OR
*                                  archiving_time IS NOT INITIAL. "#EC CI_SORTSEQ
    "Não é possível utilizar usando chave pois a condição é "diferente"

    CHECK lt_tor_root_data IS NOT INITIAL.

    SORT gt_rembp BY vbeln.

    LOOP AT lt_tor_root_data ASSIGNING FIELD-SYMBOL(<fs_root>).

      lv_btd_id = <fs_root>-base_btd_id.
      SHIFT lv_btd_id LEFT DELETING LEADING '0'.

      lv_vbeln = lv_btd_id.
      UNPACK lv_vbeln TO lv_vbeln.
      READ TABLE gt_rembp
      WITH KEY vbeln = lv_vbeln
      BINARY SEARCH ASSIGNING <fs_remessa>.
      IF sy-subrc = 0.
        <fs_remessa>-torid  = <fs_root>-tor_id.
        <fs_remessa>-torkey = <fs_root>-key.
      ENDIF.

    ENDLOOP.
    rt_tor_fu = lt_tor_root_data.
    gt_rembp_total = CORRESPONDING #( BASE ( gt_rembp_total ) gt_rembp ).
  ENDMETHOD.


  METHOD cria_ordem_frete_s_redesp.

    TYPES: BEGIN OF ty_etapas,
             seq         TYPE i,
             locid       TYPE /sapapo/locno,
             acc_start   TYPE /scmtms/stop_acc_start,
             acc_end     TYPE /scmtms/stop_acc_end,
             distance_km TYPE /scmtms/decimal_value,
           END OF ty_etapas.

    DATA: BEGIN OF ls_time,
            hora TYPE c LENGTH 2,
            mm   TYPE c LENGTH 2,
            seg  TYPE c LENGTH 2,
          END OF ls_time.

    DATA: lt_tor_item_aux     TYPE TABLE OF /scmtms/s_tor_item_tr_k,
          lt_tor_root         TYPE /scmtms/t_tor_root_k,
          lt_tor_stop_new     TYPE TABLE OF /scmtms/s_tor_stop_k,
          lt_tor_stop_succ    TYPE /scmtms/t_tor_stop_succ_k,
          lt_tor_party        TYPE /scmtms/t_tor_party_k,
          lt_stop_succ        TYPE /scmtms/t_tor_stop_succ_k,
          lr_stop_succ        TYPE REF TO /scmtms/s_tor_stop_succ_k,
          lt_tor_root_key     TYPE /bobf/t_frw_key,
          lt_tor_stop_key     TYPE /bobf/t_frw_key,
          lt_tor_fu           TYPE /scmtms/t_tor_root_k,
          lt_fu_stop          TYPE /scmtms/t_tor_stop_k,
          lt_fu_stop_i        TYPE /scmtms/t_tor_stop_k,
          lt_key_fu           TYPE /bobf/t_frw_key,
          lt_mod              TYPE /bobf/t_frw_modification,
          ls_tor_doc_ref      TYPE /scmtms/s_tor_docref_k,
          ls_param            TYPE REF TO data,
          ls_param_split_succ TYPE /scmtms/s_tor_act_succ_addstag,
          lo_message_header   TYPE REF TO /bobf/if_frw_message,
          lo_message_save     TYPE REF TO /bobf/if_frw_message,
          lt_mod_root         TYPE /bobf/t_frw_modification,

          ls_tor_root         TYPE /scmtms/s_tor_root_k,
          lt_tor_stop         TYPE /scmtms/t_tor_stop_k,
          lt_tor_item         TYPE /scmtms/t_tor_item_tr_k,
          lt_result           TYPE /bobf/t_frw_keyindex,
          ls_root_fu          TYPE /scmtms/s_tor_root_k,
          lv_locid            TYPE /sapapo/locno,
          lt_etapas           TYPE STANDARD TABLE OF ty_etapas,
          lv_seqetapas        TYPE i.

    DATA: lv_rejected         TYPE boole_d,
          lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2.

    DATA: lt_return         TYPE bapiret2_tab,
          lt_message        TYPE /bobf/t_frw_message_k,
          lt_changed        TYPE /bobf/t_frw_name,
          lt_key            TYPE /bobf/t_frw_key,
          lt_stop_uf        TYPE /scmtms/t_tor_stop_k,
          lt_stop_uf_aux    TYPE /scmtms/t_tor_stop_k,
          lt_stop_succ_uf   TYPE /scmtms/t_tor_stop_succ_k,
          lv_seqstop        TYPE /scmtms/stop_id,
          lv_start          TYPE /scmtms/stop_acc_start,
          lv_starttime      TYPE sy-uzeit,
          lv_addtime        TYPE sy-uzeit,
          lv_startdt        TYPE sy-datum,
          lv_aux            TYPE c LENGTH 15,
          lv_newdt          TYPE sy-datum,
          lv_newtime        TYPE sy-uzeit,
          lv_timeserv       TYPE int8,
          lv_hh             TYPE i,
          lv_mm             TYPE i,
          lv_ss             TYPE i,
          lv_seg            TYPE p DECIMALS 2,
          lv_tempo          TYPE p DECIMALS 2,
          lv_ex_time_string TYPE char12.

    CONSTANTS : lc_tortype         TYPE /scmtms/tor_type      VALUE '1010',
                lc_btd_tco_roadnet TYPE /scmtms/btd_type_code VALUE 'ROADN'.

    FREE: ev_tor_id.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_txn_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    " Busca Nº cliente do centro e Organização de vendas para faturamento interno
    SELECT SINGLE werks,
                  kunnr,
                  vkorg
      FROM t001w
      INTO @DATA(ls_t001w)
      WHERE werks EQ @is_dados-region_id.

    "Criar ordem de frete
    lt_return = gera_fo( EXPORTING is_dados         = is_dados
                                   is_session       = is_session        " INSERT - JWSILVA - 21.02.2023
                                   is_routes        = is_routes         " INSERT - JWSILVA - 21.02.2023
                         IMPORTING es_root          = ls_tor_root
                                   et_item          = lt_tor_item
                                   et_stop          = lt_tor_stop
                         CHANGING  ct_road_session  = ct_road_session   " INSERT - JWSILVA - 21.02.2023
                                   ct_road_item     = ct_road_item      " INSERT - JWSILVA - 21.02.2023
                                   ct_road_log      = ct_road_log ).    " INSERT - JWSILVA - 21.02.2023

    lt_tor_item_aux = lt_tor_item.

    READ TABLE lt_tor_item ASSIGNING FIELD-SYMBOL(<fs_item_tr>) INDEX 1.

    IF sy-subrc IS INITIAL.

      <fs_item_tr>-tures_tco       = is_dados-tures_tco.
      <fs_item_tr>-tures_cat       = is_dados-tures_cat.
      <fs_item_tr>-item_type       = gc_itmtype_truc.
      <fs_item_tr>-item_cat        = gc_itemcat_avr.
      <fs_item_tr>-platenumber     = is_dados-platenumber.
    ENDIF.

    ls_tor_root-tor_cat            = 'TO'.
    ls_tor_root-labeltxt           = is_dados-labeltxt.
    ls_tor_root-tspid              = is_dados-tsp_id.
    ls_tor_root-tsp                = convert_bp_to_key( is_dados-tsp_id ).
    ls_tor_root-tor_type           = lc_tortype.
    ls_tor_root-zz1_cond_exped     = is_dados-zz1_cond_exped.
    ls_tor_root-zz1_tipo_exped     = is_dados-zz1_tipo_exped.

    SELECT SINGLE objid,
                  logqs_id
      FROM /scmb/hrp5561
      INTO @DATA(ls_hrp5561)
*      WHERE logqs_id EQ @ls_t001w-vkorg.
      WHERE external_id EQ @ls_t001w-vkorg.

    IF sy-subrc IS INITIAL.
      ls_tor_root-purch_company_code   = ls_t001w-vkorg.
      ls_tor_root-purch_company_org_id = ls_hrp5561-objid.
    ENDIF.

    APPEND:   'TOR_CAT'              TO lt_changed,
              'TOR_TYPE'             TO lt_changed,
              'TSPID'                TO lt_changed,
              'LABELTXT'             TO lt_changed,
              'ZZ1_TIPO_EXPED'       TO lt_changed,
              'ZZ1_COND_EXPED'       TO lt_changed,
              'PURCH_COMPANY_CODE'   TO lt_changed,
              'PURCH_COMPANY_ORG_ID' TO lt_changed,
              'TSP'                  TO lt_changed.

    DATA(lv_bpkind)       = busca_tipo_bp( is_dados-zz_motorista ).
    DATA(lv_partner_guid) = convert_bp_to_key( is_dados-zz_motorista ).

    CASE lv_bpkind.

      WHEN '0011'.

        DATA(lv_partner_guid_kunnr) = convert_bp_to_key( ls_t001w-kunnr ).

        APPEND:   'ZZ_MOTORISTA'   TO lt_changed.
        ls_tor_root-zz_motorista      = is_dados-zz_motorista.
        ls_tor_root-tspid             = ls_t001w-kunnr.
        ls_tor_root-tsp               = lv_partner_guid_kunnr.

        APPEND INITIAL LINE TO lt_tor_party ASSIGNING FIELD-SYMBOL(<fs_tor_party>).

        <fs_tor_party>-parent_key     = ls_tor_root-key.
        <fs_tor_party>-root_key       = ls_tor_root-key.

        <fs_tor_party>-party_rco      = 'YM'.
        <fs_tor_party>-party_id       = is_dados-zz_motorista.
        <fs_tor_party>-party_uuid     = lv_partner_guid.

*        SELECT SINGLE partner2 INTO ls_tor_root-tspid
*          FROM but050
*          WHERE partner1 = is_dados-zz_motorista.

      WHEN '0020'.

        ls_tor_root-tspid         = is_dados-zz_motorista.
        ls_tor_root-tsp           = lv_partner_guid.

    ENDCASE.

    " Atualiza campos da Ordem de Frete
    TRY.
        zcltm_manage_of=>change_of( EXPORTING iv_interface = zcltm_manage_of=>gc_interface-roadnet
                                    CHANGING  cs_root      = ls_tor_root
                                              ct_changed   = lt_changed ).
      CATCH cx_root.
    ENDTRY.

    DATA:
      lr_locno_range   TYPE /sctm/tt_locno_r,
      ls_locno_range   LIKE LINE OF lr_locno_range,
      lt_locations_aux TYPE /scmtms/cl_loc_helper=>ty_t_loc,
      lt_locations     TYPE TABLE OF /scmtms/cl_loc_helper=>ty_s_loc WITH KEY locno.

    lr_locno_range = VALUE /sctm/tt_locno_r( ( sign = 'I' option = 'EQ' low = is_dados-ori_locid )
                                             ( sign = 'I' option = 'EQ' low = is_dados-dest_locid )
                                            ).

    CALL METHOD /scmtms/cl_loc_helper=>get_locations_by_locno
      EXPORTING
        it_locno_range = lr_locno_range
      IMPORTING
        et_locations   = lt_locations_aux.

    lt_locations = lt_locations_aux.

    SORT gt_rembp BY seq.
    lv_seqstop = 20.
    lv_seqetapas = 1.

    LOOP AT gt_rembp ASSIGNING FIELD-SYMBOL(<fs_remessa>).
      CLEAR: lt_key,
             lt_stop_uf,
             lv_start.

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_remessa>-torkey CHANGING ct_key = lt_key ).

      lo_tor_mgr->retrieve_by_association( EXPORTING iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                     it_key                  = lt_key
                                                     iv_association          = /scmtms/if_tor_c=>sc_association-root-stop
                                                     iv_fill_data            = abap_true
                                           IMPORTING et_data                 = lt_stop_uf ).

      IF iv_transbordo EQ abap_true.

        CLEAR: lt_stop_succ_uf[],
               lt_stop_uf_aux[].

        TRY.
            lo_tor_mgr->retrieve_by_association( EXPORTING iv_node_key       = /scmtms/if_tor_c=>sc_node-root                   " Node
                                                           it_key            = lt_key                                           " Key Table
                                                           iv_association    = /scmtms/if_tor_c=>sc_association-root-stop_succ  " Association
                                                           iv_fill_data      = abap_true                                        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                                                 IMPORTING et_data           = lt_stop_succ_uf ).
          CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        ENDTRY.

        DELETE lt_stop_succ_uf WHERE plan_status <> /scmtms/if_tor_const=>sc_succ_planning_status-not_planned.
        IF lt_stop_succ_uf[] IS NOT INITIAL.

          DATA(ls_stop_succ_uf) = lt_stop_succ_uf[ 1 ].

          IF line_exists( lt_stop_uf[ key = ls_stop_succ_uf-parent_key ] ).
            DATA(ls_stop_uf) = lt_stop_uf[ key = ls_stop_succ_uf-parent_key ].
*            APPEND ls_stop_uf TO lt_stop_uf_aux.
            INSERT ls_stop_uf INTO TABLE lt_stop_uf_aux.
          ENDIF.

          IF line_exists( lt_stop_uf[ key = ls_stop_succ_uf-succ_stop_key ] ).
            ls_stop_uf = lt_stop_uf[ key = ls_stop_succ_uf-succ_stop_key ].
*            APPEND ls_stop_uf TO lt_stop_uf_aux.
            INSERT ls_stop_uf INTO TABLE lt_stop_uf_aux.
          ENDIF.

          IF lt_stop_uf_aux[] IS NOT INITIAL.
            CLEAR: lt_stop_uf[].
            lt_stop_uf[] = lt_stop_uf_aux[].
          ENDIF.
        ENDIF.
      ENDIF.

      CLEAR lv_locid.
      LOOP AT lt_stop_uf ASSIGNING FIELD-SYMBOL(<fs_stop_uf>).

        IF <fs_stop_uf>-stop_cat EQ 'O'  AND lv_locid IS INITIAL.
          lv_locid = <fs_stop_uf>-log_locid.
          lv_start = <fs_stop_uf>-acc_start.
        ENDIF.

        IF <fs_stop_uf>-stop_cat NE 'O' AND <fs_stop_uf>-log_locid NE is_dados-ori_locid.
          ls_root_fu-key = <fs_stop_uf>-root_key.
          APPEND INITIAL LINE TO lt_etapas ASSIGNING FIELD-SYMBOL(<fs_etapas>).
          <fs_etapas>-seq       = lv_seqetapas.
          <fs_etapas>-locid     = <fs_stop_uf>-log_locid.
          IF <fs_remessa>-arrival IS NOT INITIAL.
            lv_aux = <fs_remessa>-arrival.
            lv_startdt = lv_aux(8).
            lv_starttime = lv_aux+8(6).
            CONVERT DATE lv_startdt TIME lv_starttime INTO TIME STAMP <fs_etapas>-acc_start TIME ZONE 'UTC'.
          ENDIF.

          IF <fs_etapas>-acc_start IS NOT INITIAL.
            lv_aux = <fs_remessa>-arrival. "<fs_etapas>-acc_start.
            lv_startdt = lv_aux(8).
            lv_starttime = lv_aux+8(6).

            TRY.
                DATA(lv_seconds) = CONV int4( <fs_remessa>-tempo_servico ).

                CALL FUNCTION '/SAPAPO/PFM_CONVERT_TIME'
                  EXPORTING
                    im_seconds     = lv_seconds
                  IMPORTING
                    ex_time_string = lv_ex_time_string.

                REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_ex_time_string WITH space.
                CONDENSE lv_ex_time_string NO-GAPS.
                lv_addtime = |{ lv_ex_time_string ALPHA = IN }|.

              CATCH cx_root.
                CLEAR lv_addtime.
            ENDTRY.

            CALL FUNCTION 'C14B_ADD_TIME'
              EXPORTING
                i_starttime = lv_starttime
                i_startdate = lv_startdt
                i_addtime   = lv_addtime
              IMPORTING
                e_endtime   = lv_newtime
                e_enddate   = lv_newdt.
            CONVERT DATE lv_newdt TIME lv_newtime INTO TIME STAMP <fs_etapas>-acc_end TIME ZONE 'UTC'.
          ENDIF.
          <fs_etapas>-distance_km = <fs_remessa>-distance_km.
          lv_seqetapas = lv_seqetapas + 1.
          EXIT.
        ENDIF.

      ENDLOOP.

      IF iv_transbordo EQ abap_true.
        EXIT.
      ENDIF.

    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_etapas COMPARING locid acc_end acc_start.
    SORT lt_etapas BY seq.

    "Converter origem e destino
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
                      EXPORTING
                        iv_node_key   = /scmtms/if_location_c=>sc_node-root
                        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
                        it_key        = VALUE /scmtms/t_loc_alt_id( ( is_dados-ori_locid ) ( is_dados-dest_locid ) )
                      IMPORTING
                        et_result     = lt_result ).

    DATA(lv_len) = lines( lt_result ).
    "Definir os pontos de origem e destino
    LOOP AT lt_tor_stop ASSIGNING FIELD-SYMBOL(<fs_stop>).

      IF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.
        <fs_stop>-stop_id = '10'.
        <fs_stop>-log_locid    = is_dados-ori_locid.        "'SP_2003'.
        IF lv_len >= 1.
          <fs_stop>-log_loc_uuid = lt_result[ 1 ]-key.
        ENDIF.

        IF is_dados-planed_outbound IS NOT INITIAL.
          lv_aux = is_dados-planed_outbound.
          lv_startdt   = lv_aux(8).
          lv_starttime = lv_aux+8(6).
          CONVERT DATE lv_startdt TIME lv_starttime INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'UTC'.

        ENDIF.

        <fs_stop>-req_start = <fs_stop>-plan_trans_time. "is_dados-planed_outbound.
        <fs_stop>-req_end   = <fs_stop>-plan_trans_time. "is_dados-planed_outbound.

      ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.
        <fs_stop>-log_locid    = is_dados-dest_locid. "'1000000044'.
        IF lv_len >= 2.
          <fs_stop>-log_loc_uuid = lt_result[ 2 ]-key.
        ENDIF.

        IF is_dados-planed_inbound IS NOT INITIAL.
          lv_aux       = is_dados-planed_inbound.
          lv_startdt   = lv_aux(8).
          lv_starttime = lv_aux+8(6).
          CONVERT DATE lv_startdt TIME lv_starttime INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'UTC'.
        ENDIF.

        <fs_stop>-req_start       = <fs_stop>-plan_trans_time. "is_dados-planed_inbound.
        <fs_stop>-req_end         =  <fs_stop>-plan_trans_time. "is_dados-planed_inbound.

        <fs_stop>-stop_id = '20'."lv_seqstop.
      ELSE.
        CONTINUE.
      ENDIF.

    ENDLOOP.

    CLEAR: ls_tor_doc_ref.
    ls_tor_doc_ref-key        = lo_tor_mgr->get_new_key( ).
    ls_tor_doc_ref-parent_key = ls_tor_root-key.
    ls_tor_doc_ref-root_key   = ls_tor_root-key.
    ls_tor_doc_ref-btd_tco    = lc_btd_tco_roadnet.
    ls_tor_doc_ref-btd_id     = is_dados-internal_route_id.
    ls_tor_doc_ref-btd_date   = sy-datum.

    "Atualização do TOR
    INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                    node           = /scmtms/if_tor_c=>sc_node-root
                    key            = ls_tor_root-key
                    changed_fields = lt_changed
                    data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.

    /scmtms/cl_mod_helper=>mod_update_multi(  EXPORTING it_data        = lt_tor_item
                                                        iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                        iv_node        = /scmtms/if_tor_c=>sc_node-item_tr
                                               CHANGING ct_mod         = lt_mod ).

    /scmtms/cl_mod_helper=>mod_update_multi(  EXPORTING it_data        = lt_tor_stop
                                                        iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                        iv_node        = /scmtms/if_tor_c=>sc_node-stop
                                               CHANGING ct_mod         = lt_mod ).

    /scmtms/cl_mod_helper=>mod_create_single( EXPORTING is_data        = ls_tor_doc_ref
                                                        iv_key         = ls_tor_doc_ref-key
                                                        iv_parent_key  = ls_tor_doc_ref-parent_key
                                                        iv_root_key    = ls_tor_doc_ref-root_key
                                                        iv_node        = /scmtms/if_tor_c=>sc_node-docreference
                                                        iv_source_node = /scmtms/if_tor_c=>sc_node-root
                                                        iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
                                               CHANGING ct_mod         = lt_mod ).

    lo_tor_mgr->modify( EXPORTING it_modification = lt_mod_root               " Changes
                        IMPORTING eo_change       = lo_change                 " Interface of Change Object
                                  eo_message      = lo_message ).             " Interface of Message Object

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
      CLEAR lo_message.
    ENDIF.

    lo_tor_mgr->modify( EXPORTING it_modification = lt_mod
                        IMPORTING eo_change       = lo_change
                                  eo_message      = lo_message ).

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
    ENDIF.

    lo_txn_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected            = lv_rejected
                                eo_change              = lo_change
                                eo_message             = lo_message_save
                                et_rejecting_bo_key    = ls_rejecting_bo_key ).


    CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
      EXPORTING
        werks          = gv_centro
        dtsession      = gv_data
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc = 0.
      DATA(lv_enqueue) = abap_true.
    ENDIF.

    IF NOT lo_message IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
    ENDIF.

    IF NOT lo_message_save IS INITIAL.

      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
    ENDIF.

    "fazendo o Split da OF de frete de acordo com os Stops da UF
    SORT lt_etapas BY seq DESCENDING.
    DATA(lt_aux) =  split_etapa( is_root_tor     = ls_tor_root
                                 it_etapas       = lt_etapas ).

    IF lt_aux IS NOT INITIAL.
      APPEND LINES OF lt_aux TO rt_messages.
    ENDIF.

    IF iv_transbordo IS INITIAL.
      DATA(lt_return_stop_succ) = me->ajusta_km( EXPORTING is_root_tor = ls_tor_root  " Root Node
                                                           it_etapas   = lt_etapas ). " Etapas
    ENDIF.

    IF lt_return_stop_succ IS NOT INITIAL.
      APPEND LINES OF lt_return_stop_succ TO rt_messages.
    ENDIF.

    CHECK ls_tor_root IS NOT INITIAL.
    "associando as UF a OF
    lt_return = associa_unidade_frete( is_tor_root = ls_tor_root
                                       it_tor_fu   = it_tor_fu "lt_tor_fu
                                       io_tor_mgr  = lo_tor_mgr
                                       io_txn_mgr  = lo_txn_mgr
                                       iv_centro = gv_centro
                                       iv_data = gv_data ).

    IF lt_return IS NOT INITIAL.
      APPEND LINES OF lt_return TO rt_messages.
      CLEAR: lt_return[].
    ENDIF.

    lt_return = create_event( is_tor   = ls_tor_root
                              is_dados = is_dados ).
    APPEND LINES OF lt_return TO rt_messages.
    CLEAR: lt_return[].

    IF ls_tor_root-tor_id IS NOT INITIAL.

      ev_tor_id = ls_tor_root-tor_id.

    ELSE.
      TRY.

          CLEAR: lt_tor_root[].
          /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve( EXPORTING iv_node_key             = /scmtms/if_tor_c=>sc_node-root       " Node
                                                                                                                 it_key                  = VALUE #( ( key = ls_tor_root-key ) ) " Key Table
                                                                                                       IMPORTING et_data                 = lt_tor_root ).

          IF lt_tor_root IS NOT INITIAL.
            ev_tor_id = lt_tor_root[ 1 ]-tor_id.
          ENDIF.
        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          RETURN.
      ENDTRY.
    ENDIF.


* BEGIN OF INSERT - JWSILVA - 21.02.2023
    IF ev_tor_id IS NOT INITIAL.
      " Iniciando criação da Ordem de Frete &1 para rota &2.
      me->update_roadnet_session( EXPORTING is_session      = is_session
                                            is_routes       = is_routes
                                            iv_tor_id       = ev_tor_id
                                            it_return       = VALUE #( ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '018'
                                                                         message_v1 = |{ ev_tor_id ALPHA = OUT }|
                                                                         message_v2 = |{ is_routes-internal_route_id ALPHA = OUT }| ) )
                                  CHANGING  ct_road_session = ct_road_session
                                            ct_road_item    = ct_road_item
                                            ct_road_log     = ct_road_log ).
    ENDIF.
* END OF INSERT - JWSILVA - 21.02.2023

  ENDMETHOD.


  METHOD grava_log.

    DATA:
      ls_ztmt001   TYPE zttm_log_roadnet.

    MOVE-CORRESPONDING is_dados TO ls_ztmt001 .

    LOOP AT it_messages INTO DATA(ls_message).

      IF ls_message-type = 'E'.
        ls_ztmt001-status_int = abap_true.
      ENDIF.

      CONCATENATE ls_ztmt001-erro
                  ls_message-message
             INTO ls_ztmt001-erro SEPARATED BY '/'.

    ENDLOOP.

    GET TIME FIELD DATA(lv_uzeit).


    ls_ztmt001-data    = sy-datum.
    ls_ztmt001-hora    = lv_uzeit.
    ls_ztmt001-usuario = sy-uname.

    MODIFY zttm_log_roadnet FROM ls_ztmt001.

  ENDMETHOD.


  METHOD libera_remessa.

    DATA: lt_remessa        TYPE vbeln_vl_t.

    FREE: gv_wait_async,
          gt_return.

    DELETE ADJACENT DUPLICATES FROM gt_rembp_total COMPARING vbeln.
    CHECK gt_rembp_total[] IS NOT INITIAL.
    SORT gt_rembp_total BY vbeln.

    lt_remessa = VALUE #( FOR <fs_remessa> IN gt_rembp_total
                        ( <fs_remessa>-vbeln ) ).

    CHECK lt_remessa IS NOT INITIAL.

    CALL FUNCTION 'ZFMTM_LIBERA_REMESSA'
      STARTING NEW TASK 'LIBERA_REMESSA'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        it_remessa = lt_remessa.

    WAIT UNTIL gv_wait_async = abap_true.
    rt_messages  = gt_return.

  ENDMETHOD.


  METHOD atualiza_status_fo.


    DATA:
      lt_key   TYPE /bobf/t_frw_key,
*      ls_param TYPE /scmtms/s_tor_a_set_exm_status,
      lr_param TYPE REF TO /scmtms/s_tor_a_set_exm_status.

    CREATE DATA lr_param.

    lr_param->ui_action_source = 'P'. "ou 'F'
    lr_param->force            = abap_true.

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_tor_key CHANGING ct_key = lt_key ).


    io_tor_mgr->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-root-set_exm_status_ready_for_exec
                                     it_key                = lt_key
                                     is_parameters         = lr_param
                           IMPORTING eo_change             = DATA(lo_change_action)
                                     eo_message            = DATA(lo_message_action)
                                     et_failed_action_key  = DATA(lt_failed_action_key)
                                     et_failed_key         = DATA(lt_failed_key) ).


    IF NOT lo_message_action IS INITIAL.

      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_action
                                                             CHANGING  ct_bapiret2 = rt_messages ).

    ENDIF.


*
*    io_modify->do_action(
*      EXPORTING
*        it_key          = lt_key
*        iv_act_key      = /scmtms/if_tor_c=>sc_action-root-set_exm_status_ready_for_exec
*        is_parameters   = lr_param ).
*

*      io_ut_helper->do_action(
*        EXPORTING
*          iv_action    = /scmtms/if_tor_c=>sc_action-item_tr-set_cargo_receipt_in_transit
*          it_items_all = lt_items_all
*          it_item_key  = lt_item_pu
*          ir_parameters = lr_param_set_cargo
*        IMPORTING
*          et_changed_item = ct_items ).

  ENDMETHOD.


  METHOD atualiza_referencia.

    DATA:
      lt_parameters  TYPE /bobf/t_frw_query_selparam,
      lt_tor_root    TYPE /scmtms/t_tor_root_k,
      lt_mod         TYPE /bobf/t_frw_modification,
      lt_tor_doc_ref TYPE /scmtms/t_tor_docref_k,
      lt_return      TYPE bapiret2_tab,
      ls_tor_doc_ref TYPE /scmtms/s_tor_docref_k,
      lo_srv_tor     TYPE REF TO /bobf/if_tra_service_manager,
      ls_parameter   TYPE /bobf/s_frw_query_selparam.

    CONSTANTS: lc_of_filha TYPE /scmtms/btd_type_code VALUE 'OFFIL',
               lc_of_mae   TYPE /scmtms/btd_type_code VALUE 'OFMAE'.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    CLEAR ls_parameter.
    lt_parameters = VALUE #( FOR <fs_param> IN gt_rembp
                           ( sign           = /bobf/if_conf_c=>sc_sign_option_including
                             option         = /bobf/if_conf_c=>sc_sign_equal
                             attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-trq_base_btd_id
                             low            = <fs_param>-vbeln ) ).

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_param_tco>).
    <fs_param_tco>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_cat.
    <fs_param_tco>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_param_tco>-option         = /bobf/if_conf_c=>sc_sign_equal.
    <fs_param_tco>-low            = /scmtms/if_tor_const=>sc_tor_category-active.

    TRY.

        lo_srv_tor->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes " Query
            it_selection_parameters = lt_parameters                                       " Query Selection Parameters
            iv_fill_data            = abap_true                                           " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_tor_root ).

        LOOP AT lt_tor_root ASSIGNING FIELD-SYMBOL(<fs_of>).

          IF <fs_of>-tor_id EQ iv_tor_id.
            CONTINUE.
          ENDIF.

          ls_tor_doc_ref-key          = lo_srv_tor->get_new_key( ).
          ls_tor_doc_ref-parent_key   = <fs_of>-key.
          ls_tor_doc_ref-root_key     = <fs_of>-key.
          ls_tor_doc_ref-btd_tco      = lc_of_mae.
          ls_tor_doc_ref-btd_id       = iv_tor_id.
          ls_tor_doc_ref-btd_date     = sy-datum.
          APPEND ls_tor_doc_ref TO lt_tor_doc_ref.

          IF line_exists( lt_tor_root[ tor_id = iv_tor_id ] ).
            ls_tor_doc_ref-key        = lo_srv_tor->get_new_key( ).
            ls_tor_doc_ref-parent_key = lt_tor_root[ tor_id = iv_tor_id ]-key.
            ls_tor_doc_ref-root_key   = lt_tor_root[ tor_id = iv_tor_id ]-key.
            ls_tor_doc_ref-btd_tco    = lc_of_filha.
            ls_tor_doc_ref-btd_id     = <fs_of>-tor_id.
            ls_tor_doc_ref-btd_date   = sy-datum.
            APPEND ls_tor_doc_ref TO lt_tor_doc_ref.
          ENDIF.

        ENDLOOP.

        CHECK lt_tor_doc_ref[] IS NOT INITIAL.

        CLEAR: lt_mod[].
        /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-docreference              " Node
                                                           it_data        = lt_tor_doc_ref
                                                           iv_association = /scmtms/if_tor_c=>sc_association-root-docreference  " Association
                                                           iv_source_node = /scmtms/if_tor_c=>sc_node-root                      " Node
                                                  CHANGING ct_mod         = lt_mod ).                                           " Changes

        lo_srv_tor->modify( EXPORTING it_modification = lt_mod                                                                  " Changes
                            IMPORTING eo_message      = DATA(lo_message) ).                                                     " Interface of Message Object

        IF NOT lo_message IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO rt_messages.
          ENDIF.
        ENDIF.

        CHECK lt_return[] IS INITIAL.

        /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message = lo_message ).


        CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
          EXPORTING
            werks          = gv_centro
            dtsession      = gv_data
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc = 0.
          DATA(lv_enqueue) = abap_true.
        ENDIF.

        IF NOT lo_message IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO rt_messages.
          ENDIF.
        ENDIF.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

    ENDTRY.

  ENDMETHOD.


  METHOD create_event.

    DATA: lt_stop_fist    TYPE /scmtms/t_tor_stop_k,
          lt_docreference TYPE /scmtms/t_tor_docref_k,
          lt_mod          TYPE /bobf/t_frw_modification,
          lt_return       TYPE bapiret2_t.

    DATA: ls_mod  TYPE /bobf/s_frw_modification,
          ls_exec TYPE /scmtms/s_tor_exec_k.

    DATA: lv_evento TYPE /scmtms/tor_event.

    CONSTANTS: lc_evento         TYPE /scmtms/tor_event VALUE 'LIBERADO P/CARREGAR',
               lc_evento_fat_car TYPE /scmtms/tor_event VALUE 'FATURAR/CARREGAR'.

    TRY.

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root                                                                                   " Node
            it_key                  = VALUE #( ( key = is_tor-key ) )                                                                                  " Key Table
            iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first                                                                 " Association
            iv_fill_data            = abap_true                                                                                                        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_stop_fist  ).

        IF gt_rembp[ 1 ]-vbeln IS NOT INITIAL.
          DATA(lv_remessa) = gt_rembp[ 1 ]-vbeln.
          SELECT SINGLE lprio
            FROM likp
            INTO @DATA(lv_lprio)
           WHERE vbeln EQ @lv_remessa.

          CLEAR: lv_evento.
          IF lv_lprio EQ '04' OR
             lv_lprio EQ '06'.
            lv_evento = lc_evento_fat_car.
          ELSE.
            lv_evento = lc_evento.
          ENDIF.
        ENDIF.

      CATCH /bobf/cx_frw_contrct_violation.                                                                                                            " Caller violates a BOPF contract

    ENDTRY.

    CHECK lt_stop_fist[] IS NOT INITIAL.

    IF line_exists( lt_stop_fist[ log_locid = is_dados-ori_locid ]  ).

      ls_exec-key           = /bobf/cl_frw_factory=>get_new_key( ).
      ls_exec-parent_key    = is_tor-key.
      ls_exec-root_key      = is_tor-key.
      ls_exec-event_code    = lv_evento.
      ls_exec-torstopuuid   = lt_stop_fist[ log_locid = is_dados-ori_locid ]-key.
      ls_exec-ext_loc_id    = lt_stop_fist[ log_locid = is_dados-ori_locid ]-log_locid.
      ls_exec-ext_loc_uuid  = lt_stop_fist[ log_locid = is_dados-ori_locid ]-log_loc_uuid.

      /scmtms/cl_mod_helper=>mod_create_single(
        EXPORTING
          is_data        = ls_exec
          iv_key         = ls_exec-key                                                                                                                 " NodeID
          iv_parent_key  = ls_exec-parent_key                                                                                                          " NodeID
          iv_root_key    = ls_exec-root_key                                                                                                            " NodeID
          iv_node        = /scmtms/if_tor_c=>sc_node-executioninformation                                                                              " Node
          iv_source_node = /scmtms/if_tor_c=>sc_node-root                                                                                              " Node
          iv_association = /scmtms/if_tor_c=>sc_association-root-exec                                                                                  " Association
        CHANGING
          ct_mod         = lt_mod ).                                                                                                                   " Changes

      IF lt_mod[] IS NOT INITIAL.
        TRY.

            /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify( EXPORTING it_modification = lt_mod              " Changes
                                                                                                       IMPORTING eo_message      = DATA(lo_message) ). " Interface of Message Object

            IF NOT lo_message IS INITIAL.

              CLEAR lt_return.
              /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                     CHANGING  ct_bapiret2 = lt_return[] ).

              IF lt_return IS NOT INITIAL.
                APPEND LINES OF lt_return TO rt_messages.
                EXIT.
              ENDIF.

              CLEAR lo_message.

              /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message = lo_message ).
              CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
                EXPORTING
                  werks          = gv_centro
                  dtsession      = gv_data
                EXCEPTIONS
                  foreign_lock   = 1
                  system_failure = 2
                  OTHERS         = 3.
              IF sy-subrc = 0.
                DATA(lv_enqueue) = abap_true.
              ENDIF.
              IF NOT lo_message IS INITIAL.

                CLEAR lt_return.
                /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                       CHANGING  ct_bapiret2 = lt_return[] ).

                IF lt_return IS NOT INITIAL.
                  APPEND LINES OF lt_return TO rt_messages.
                ENDIF.
              ENDIF.
            ENDIF.
          CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

        ENDTRY.
      ENDIF.
    ENDIF.


*    FIELD-SYMBOLS: <fs_exec>    TYPE /scmtms/s_tor_exec_k.
*
*    ls_mod-node         = /scmtms/if_tor_c=>sc_node-executioninformation.
*    ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
*    ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-exec.
*    ls_mod-source_key   = is_tor-key.
*    ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
*    ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).
*
*    CREATE DATA ls_mod-data TYPE /scmtms/s_tor_exec_k.
*    ASSIGN ls_mod-data->* TO <fs_exec>.
*
*    <fs_exec>-key          = ls_mod-key.
*    <fs_exec>-event_code   = iv_evento.
*    <fs_exec>-torstopuuid  = is_stop-key.
*    <fs_exec>-ext_loc_id   = is_stop-log_locid.
*    <fs_exec>-ext_loc_uuid = is_stop-log_loc_uuid.
*
*    APPEND ls_mod TO rt_mod.
  ENDMETHOD.


  METHOD split_etapa.
    DATA:
      lt_mod          TYPE /bobf/t_frw_modification,
      lo_srv_tor      TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor      TYPE REF TO /bobf/if_tra_transaction_mgr,
      lt_tor_root_key TYPE /bobf/t_frw_key,
      lt_tor_stop_key TYPE /bobf/t_frw_key,
      lt_key          TYPE /bobf/t_frw_key,
      lt_return       TYPE bapiret2_tab,
      lt_stop         TYPE /scmtms/t_tor_stop_k,
      lt_stop_start   TYPE /scmtms/t_tor_stop_k,
      lt_stop_next    TYPE /scmtms/t_tor_stop_k,
      lt_stop_succ    TYPE /scmtms/t_tor_stop_succ_k,
      lv_ok           TYPE abap_bool,
      lo_message      TYPE REF TO /bobf/if_frw_message,
      lv_key          TYPE /bobf/conf_key.
*    lo_message    TYPE REF TO /bobf/if_frw_message

    DATA:
      lo_change_action     TYPE REF TO /bobf/if_tra_change,
      lo_message_action    TYPE REF TO /bobf/if_frw_message,
      lt_failed_key        TYPE /bobf/t_frw_key,
      lt_failed_action_key TYPE /bobf/t_frw_key,
      ls_param             TYPE REF TO data,
      ls_param_split_succ  TYPE /scmtms/s_tor_act_succ_addstag,
      lt_parameters        TYPE /bobf/t_frw_query_selparam,
      ls_parameter         TYPE /bobf/s_frw_query_selparam,
      lv_arrival           TYPE /scmtms/datetime,
      lt_changed           TYPE /bobf/t_frw_name,
      lt_succ              TYPE /scmtms/t_tor_stop_succ_k,
      lt_upd_succ          TYPE /scmtms/t_tor_stop_succ_k.

    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.

    lo_tra_tor = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_root_tor-key CHANGING ct_key = lt_tor_root_key ).

*   Busca informações de etapas/paradas
    lo_srv_tor->retrieve_by_association(
                                         EXPORTING
                                             it_key         = lt_tor_root_key
                                             iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                             iv_association = /scmtms/if_tor_c=>sc_association-root-stop
                                             iv_fill_data   = abap_true
                                         IMPORTING
                                              et_data = lt_stop ).
    lo_srv_tor->retrieve_by_association(
                                         EXPORTING
                                             it_key         = lt_tor_root_key
                                             iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                             iv_association = /scmtms/if_tor_c=>sc_association-root-stop_succ
                                             iv_fill_data   = abap_true
                                         IMPORTING
                                              et_data = lt_stop_succ ).

    LOOP AT it_etapas ASSIGNING FIELD-SYMBOL(<fs_etapas>).

      FREE:  ls_param.
      CLEAR: ls_param_split_succ,
             lt_tor_stop_key[].

      DATA(lv_loc_uuid) = convert_loc_to_key( <fs_etapas>-locid ).
      IF line_exists( lt_stop_succ[ 1 ] ).
        APPEND VALUE #( key = lt_stop_succ[ 1 ]-key ) TO lt_tor_stop_key.
      ENDIF.

      ls_param_split_succ-new_loc_key         = lv_loc_uuid.

      IF <fs_etapas>-acc_start IS NOT INITIAL.
        ls_param_split_succ-arrival_timestamp   = <fs_etapas>-acc_start.
      ENDIF.

      IF <fs_etapas>-acc_end IS NOT INITIAL.
        ls_param_split_succ-departure_timestamp = <fs_etapas>-acc_end.
      ENDIF.

      GET REFERENCE OF ls_param_split_succ INTO ls_param.

*   Ação para inserir nova etapa
      lo_srv_tor->do_action( EXPORTING iv_act_key = /scmtms/if_tor_c=>sc_action-stop_successor-split_stage
                                       it_key                = lt_tor_stop_key
                                       is_parameters         = ls_param
                             IMPORTING eo_change             = lo_change_action
                                       eo_message            = lo_message_action
                                       et_failed_action_key  = lt_failed_action_key
                                       et_failed_key         = lt_failed_key ).

      lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                        IMPORTING ev_rejected         = DATA(lv_rejected)
                                  eo_change           = DATA(lo_change)
                                  eo_message          = DATA(lo_message_save)
                                  et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).



*   Converte mensagens de execução
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING iv_action_messages = space
                                                                       io_message         = lo_message_save
                                                             CHANGING  ct_bapiret2        = lt_return ).

      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.
      lo_tra_tor->cleanup( ).
      CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
        EXPORTING
          werks          = gv_centro
          dtsession      = gv_data
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc = 0.
        DATA(lv_enqueue) = abap_true.
      ENDIF.
    ENDLOOP.

    CLEAR lt_stop_succ.
    WAIT UP TO 1 SECONDS.

    lo_srv_tor->retrieve_by_association( EXPORTING it_key         = lt_tor_root_key
                                                   iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-stop_successor_all
                                                   iv_fill_data   = abap_true
                                         IMPORTING et_data        = lt_stop_succ ).

    CLEAR : lt_stop, lt_key.
    LOOP AT lt_stop_succ ASSIGNING FIELD-SYMBOL(<fs_sucess>).
      IF <fs_sucess>-successor_id IS INITIAL.
        APPEND INITIAL LINE TO lt_key ASSIGNING FIELD-SYMBOL(<fs_key>).
        <fs_key>-key = <fs_sucess>-key.
      ENDIF.
    ENDLOOP.

    IF lt_key[] IS NOT INITIAL. "lt_stop_succ IS NOT INITIAL.

      APPEND:   'PLAN_TRANS_TIME'   TO lt_changed.
      lo_srv_tor->retrieve_by_association( EXPORTING it_key                 = lt_key
                                                     iv_node_key            = /scmtms/if_tor_c=>sc_node-stop_successor
                                                     iv_association         = /scmtms/if_tor_c=>sc_association-stop_successor-start_stop
                                                     iv_fill_data           = abap_true
                                           IMPORTING et_data                = lt_stop_start ).

      CLEAR lt_return.
      lo_srv_tor->retrieve_by_association( EXPORTING it_key                 = lt_key
                                                     iv_node_key            = /scmtms/if_tor_c=>sc_node-stop_successor
                                                     iv_association         = /scmtms/if_tor_c=>sc_association-stop_successor-next_stop
                                                     iv_fill_data           = abap_true
                                           IMPORTING et_data                = lt_stop_next ).

      LOOP AT it_etapas ASSIGNING <fs_etapas>.

        IF lt_stop_start IS NOT INITIAL.
*          LOOP AT lt_stop_start ASSIGNING FIELD-SYMBOL(<fs_stop>) WHERE log_locid = <fs_etapas>-locid. "#EC CI_SORTSEQ
*            <fs_stop>-plan_trans_time = <fs_etapas>-acc_start.
*          ENDLOOP.

          IF line_exists( lt_stop_start[ log_locid = <fs_etapas>-locid ] ).

            DATA(ls_stop_start)           = lt_stop_start[ log_locid = <fs_etapas>-locid ].
            ls_stop_start-plan_trans_time = <fs_etapas>-acc_start.

            /scmtms/cl_mod_helper=>mod_update_single( EXPORTING is_data            = ls_stop_start
                                                                iv_node            = /scmtms/if_tor_c=>sc_node-stop " Node
                                                                it_changed_fields  = lt_changed                     " List of Names (e.g. Fieldnames)
                                                                iv_bo_key          = /scmtms/if_tor_c=>sc_bo_key    " Business Object
                                                       CHANGING ct_mod             = gt_mod_stop ).                 " Changes

          ENDIF.

*          /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_stop_start
*                                                             iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                             iv_node        = /scmtms/if_tor_c=>sc_node-stop
*                                                    CHANGING ct_mod         = gt_mod_stop ).
        ENDIF.

        IF lt_stop_next IS NOT INITIAL.
*          LOOP AT lt_stop_next ASSIGNING <fs_stop> WHERE log_locid = <fs_etapas>-locid. "#EC CI_SORTSEQ
*            <fs_stop>-plan_trans_time = <fs_etapas>-acc_end.
*          ENDLOOP.

          IF line_exists( lt_stop_next[ log_locid = <fs_etapas>-locid ] ).

            DATA(ls_stop_next)           = lt_stop_next[ log_locid = <fs_etapas>-locid ].
            ls_stop_next-plan_trans_time = <fs_etapas>-acc_end.

            /scmtms/cl_mod_helper=>mod_update_single( EXPORTING is_data            = ls_stop_next
                                                                iv_node            = /scmtms/if_tor_c=>sc_node-stop " Node
                                                                it_changed_fields  = lt_changed                     " List of Names (e.g. Fieldnames)
                                                                iv_bo_key          = /scmtms/if_tor_c=>sc_bo_key    " Business Object
                                                       CHANGING ct_mod             = gt_mod_stop ).                 " Changes

          ENDIF.

*          /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_stop_next
*                                                             iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                             iv_node        = /scmtms/if_tor_c=>sc_node-stop
*                                                    CHANGING ct_mod         = gt_mod_stop ).

        ENDIF.
      ENDLOOP.
    ENDIF.

    IF lt_mod IS NOT INITIAL.
      CALL METHOD lo_srv_tor->modify
        EXPORTING
          it_modification = lt_mod
        IMPORTING
          eo_change       = lo_change
          eo_message      = lo_message.


*   Converte mensagens de execução
      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                             EXPORTING
                                                              iv_action_messages = space
                                                              io_message  = lo_message
                                                             CHANGING
                                                              ct_bapiret2 = lt_return ).
      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.

      CLEAR : lo_message,
              lv_rejected,
              lo_change,
              lo_message,
              ls_rejecting_bo_key.

      lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                     IMPORTING ev_rejected         = lv_rejected
                               eo_change           = lo_change
                               eo_message          = lo_message
                               et_rejecting_bo_key = ls_rejecting_bo_key ).

      CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
        EXPORTING
          werks          = gv_centro
          dtsession      = gv_data
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc = 0.
        lv_enqueue = abap_true.
      ENDIF.
      IF NOT lo_message IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO rt_messages.
        ENDIF.
      ENDIF.

      IF NOT lo_message_save IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO rt_messages.
        ENDIF.
      ENDIF.

    ENDIF.

    IF gt_mod_stop IS NOT INITIAL.

      lo_srv_tor->modify( EXPORTING it_modification = gt_mod_stop           " Changes
                          IMPORTING eo_change       = lo_change             " Interface of Change Object
                                    eo_message      = lo_message ).         " Interface of Message Object

*   Converte mensagens de execução
      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2(
                                                             EXPORTING
                                                              iv_action_messages = space
                                                              io_message  = lo_message
                                                             CHANGING
                                                              ct_bapiret2 = lt_return ).
      IF lt_return IS NOT INITIAL.
        APPEND LINES OF lt_return TO rt_messages.
      ENDIF.

      CLEAR : lo_message,
              lv_rejected,
              lo_change,
              lo_message,
              ls_rejecting_bo_key.

      lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                     IMPORTING ev_rejected         = lv_rejected
                               eo_change           = lo_change
                               eo_message          = lo_message
                               et_rejecting_bo_key = ls_rejecting_bo_key ).

      CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
        EXPORTING
          werks          = gv_centro
          dtsession      = gv_data
        EXCEPTIONS
          foreign_lock   = 1
          system_failure = 2
          OTHERS         = 3.
      IF sy-subrc = 0.
        lv_enqueue = abap_true.
      ENDIF.

      IF NOT lo_message IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO rt_messages.
        ENDIF.
      ENDIF.

      IF NOT lo_message_save IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        IF lt_return IS NOT INITIAL.
          APPEND LINES OF lt_return TO rt_messages.
        ENDIF.
      ENDIF.

    ENDIF.

*    ENDIF.
  ENDMETHOD.


  METHOD upd_bp.

    DATA: lt_butid     TYPE STANDARD TABLE OF but0id,
          lt_butid_del TYPE STANDARD TABLE OF but0id.

    CONSTANTS: lc_long TYPE bu_id_type VALUE 'ZLONGI',
               lc_lati TYPE bu_id_type VALUE 'ZLATIT'.

*    IF gt_rembp IS NOT INITIAL.
    IF gt_rembp_total IS NOT INITIAL.
*      SORT gt_rembp BY vbeln.
      SORT gt_rembp_total BY vbeln.

      SELECT
        vbeln,
        kunnr
      FROM likp
*      FOR ALL ENTRIES IN @gt_rembp
      FOR ALL ENTRIES IN @gt_rembp_total
      WHERE
*        vbeln = @gt_rembp-vbeln
        vbeln = @gt_rembp_total-vbeln
      INTO TABLE @DATA(lt_likp).
      IF sy-subrc = 0.

        SELECT * FROM but0id
        FOR ALL ENTRIES IN @lt_likp
        WHERE
          partner = @lt_likp-kunnr
          AND type IN ('ZLATIT','ZLONGI')
        INTO TABLE @DATA(lt_bp).
        IF sy-subrc = 0.
          SORT lt_bp BY partner type.
        ENDIF.

        LOOP AT lt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>).
*          READ TABLE gt_rembp
          READ TABLE gt_rembp_total
          WITH KEY vbeln = <fs_likp>-vbeln
          BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_remessa>).
          IF sy-subrc = 0.

            " Longitude
            READ TABLE lt_bp
            WITH KEY partner = <fs_likp>-kunnr
                     type    = lc_long
            BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_bp>).
            IF sy-subrc = 0.
              IF <fs_bp>-idnumber NE <fs_remessa>-longitude AND <fs_remessa>-longitude IS NOT INITIAL.
                APPEND INITIAL LINE TO lt_butid_del ASSIGNING FIELD-SYMBOL(<fs_butid_del>).
                <fs_butid_del> = <fs_bp>.
                APPEND INITIAL LINE TO lt_butid ASSIGNING FIELD-SYMBOL(<fs_butid>).
                <fs_butid> = <fs_bp>.
                <fs_butid>-idnumber = <fs_remessa>-longitude.
              ENDIF.
            ELSEIF <fs_remessa>-longitude IS NOT INITIAL.
              APPEND INITIAL LINE TO lt_butid ASSIGNING <fs_butid>.
              <fs_butid>-partner = <fs_likp>-kunnr.
              <fs_butid>-type    = lc_long.
              <fs_butid>-idnumber = <fs_remessa>-longitude.
            ENDIF.

            " Latitude
            READ TABLE lt_bp
            WITH KEY partner = <fs_likp>-kunnr
                     type    = lc_lati
            BINARY SEARCH ASSIGNING <fs_bp>.
            IF sy-subrc = 0.
              IF <fs_bp>-idnumber NE <fs_remessa>-latitude AND <fs_remessa>-latitude IS NOT INITIAL.
                APPEND INITIAL LINE TO lt_butid_del ASSIGNING <fs_butid_del>.
                <fs_butid_del> = <fs_bp>.
                APPEND INITIAL LINE TO lt_butid ASSIGNING <fs_butid>.
                <fs_butid> = <fs_bp>.
                <fs_butid>-idnumber = <fs_remessa>-latitude.
              ENDIF.
            ELSEIF <fs_remessa>-latitude IS NOT INITIAL.
              APPEND INITIAL LINE TO lt_butid ASSIGNING <fs_butid>.
              <fs_butid>-partner = <fs_likp>-kunnr.
              <fs_butid>-type    = lc_lati.
              <fs_butid>-idnumber = <fs_remessa>-latitude.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      IF lt_butid IS NOT INITIAL.

        DELETE but0id FROM TABLE lt_butid_del.
        MODIFY but0id FROM TABLE lt_butid.

        IF sy-subrc = 0.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD process_session.

    DATA: lt_stops            TYPE zcltm_dt_consulta_sessao_r_tab,
          lt_msg_check_routes TYPE bapiret2_t,
          ls_dados            TYPE ztms_input_rodnet, "preencher com dados da interface
          lt_routes_return    TYPE ty_t_routes,
          lv_timestamp        TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    DATA: lt_tor_root TYPE /scmtms/t_tor_root_k,
          lv_tor_id   TYPE /scmtms/d_torrot-tor_id.

    CLEAR: lt_msg_check_routes[],
           gt_rembp_total[].

    DATA(lv_check_routes) = check_routes( EXPORTING it_routes = is_session-session_identity-routes    " Proxy Table Type (generated)
                                          IMPORTING et_return = lt_msg_check_routes                   " Tabela de retorno
                                                    et_routes = lt_routes_return ).                   " Root Node

    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.

    LOOP AT is_session-session_identity-routes ASSIGNING FIELD-SYMBOL(<fs_routes>).
      IF line_exists( lt_routes_return[ routes = <fs_routes>-internal_route_id ] ).
        TRY.
            rt_messages = VALUE #( BASE rt_messages ( type       = if_xo_const_message=>error
                                                      id         = 'ZTM_ROADNET_SESSION'
                                                      number     = '016'
                                                      message_v1 = <fs_routes>-internal_route_id
                                                      message_v2 = lt_routes_return[ routes = <fs_routes>-internal_route_id ]-torid ) ).               " CHANGE - JWSILVA - 21.02.2023
          CATCH cx_root.
        ENDTRY.
        CONTINUE.
      ENDIF.


* BEGIN OF INSERT - JWSILVA - 21.02.2023
      " Iniciando processamento da rota &1.
      me->update_roadnet_session( EXPORTING is_session      = is_session
                                            it_return       = VALUE #( ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '024' message_v1 = |{ <fs_routes>-internal_route_id ALPHA = OUT }| ) )
                                  CHANGING  ct_road_session = ct_road_session
                                            ct_road_item    = ct_road_item
                                            ct_road_log     = ct_road_log ).
* end of insert - jwsilva - 21.02.2023

      lt_stops = <fs_routes>-stops.
      CLEAR: ls_dados,
             gv_km_total.

      ls_dados-internal_session_id = is_session-session_identity-internal_session_id.
      ls_dados-region_id           = is_session-session_identity-region_id.

      ls_dados-labeltxt            = <fs_routes>-description.
      ls_dados-tures_cat           = <fs_routes>-route_equipment-equipment_id.
      ls_dados-route_id            = <fs_routes>-route_id .
      ls_dados-internal_route_id   = <fs_routes>-internal_route_id.
      ls_dados-description         = <fs_routes>-description.
      ls_dados-zz1_tipo_exped      = |{ <fs_routes>-load_priority ALPHA = IN }|.
      ls_dados-ori_locid           = <fs_routes>-origin-location_id.
      ls_dados-ori_loctype         = <fs_routes>-origin-location_type.

      IF <fs_routes>-drivers[] IS NOT INITIAL.
        LOOP AT <fs_routes>-drivers ASSIGNING FIELD-SYMBOL(<fs_drivers>).
          IF sy-tabix EQ 1.
            ls_dados-zz_motorista   = <fs_drivers>-employee_id.
          ELSEIF sy-tabix EQ 2.
            ls_dados-zz1_cond_exped = CONV char2( |{ <fs_drivers>-employee_id ALPHA = IN }| ).
          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.

      ls_dados-tures_tco        = <fs_routes>-route_equipment-equipment_type_id. "ls_routes-route_equipment-equipment_id.
      ls_dados-platenumber      = <fs_routes>-route_equipment-equipment_id.
      ls_dados-planed_outbound  = <fs_routes>-start_time.
      ls_dados-planed_inbound   = <fs_routes>-arrive_time.

      SELECT SINGLE equi_type FROM /scmb/equi_code
      WHERE
        equi_code = @ls_dados-tures_tco
      INTO @ls_dados-tures_cat.

      ls_dados-dest_locid        = <fs_routes>-destination-location_id.
      ls_dados-dest_loctype      = <fs_routes>-destination-location_type.
      gv_km_total                = <fs_routes>-distance.

      CLEAR gt_stops.
      gt_stops = <fs_routes>-stops.

      DATA(lt_return) = processamento_frete( EXPORTING iv_transbordo    = iv_cross
                                                       is_dados         = ls_dados
                                                       is_session       = is_session        " INSERT - JWSILVA - 21.02.2023
                                                       is_routes        = <fs_routes>       " INSERT - JWSILVA - 21.02.2023
                                             IMPORTING ev_tor_id        = lv_tor_id
                                             CHANGING  ct_road_session  = ct_road_session   " INSERT - JWSILVA - 21.02.2023
                                                       ct_road_item     = ct_road_item      " INSERT - JWSILVA - 21.02.2023
                                                       ct_road_log      = ct_road_log ).    " INSERT - JWSILVA - 21.02.2023

      rt_messages = VALUE #( BASE rt_messages FOR ls_return IN lt_return ( ls_return ) ).

*      me->upd_bp( ).
*
*      DATA(lt_messages) = libera_remessa( is_dados = ls_dados ).
*      rt_messages = CORRESPONDING #( BASE ( rt_messages ) lt_messages ).

* BEGIN OF INSERT - JWSILVA - 21.02.2023
*      READ TABLE ct_road_item ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY werks      = is_session-session_identity-region_id
*                                                                         dtsession  = lv_dtsession
*                                                                         session_id = is_session-session_identity-internal_session_id
*                                                                         route_id   = <fs_routes>-internal_route_id.
*      IF sy-subrc IS INITIAL.
*        <fs_item>-freight_order         = lv_tor_id.
*        <fs_item>-last_changed_by       = sy-uname.
*        <fs_item>-last_changed_at       = lv_timestamp.
*        <fs_item>-local_last_changed_at = lv_timestamp.
*      ENDIF.
* END OF INSERT - JWSILVA - 21.02.2023

      IF iv_cross EQ abap_true.
        DATA(lt_msg_ref) = atualiza_referencia( EXPORTING iv_tor_id   = lv_tor_id        " Documento
                                                          is_dados    = ls_dados      ). " Remessa
        rt_messages = CORRESPONDING #( BASE ( rt_messages ) lt_msg_ref ).
      ENDIF.

* BEGIN OF INSERT - JWSILVA - 21.02.2023
      " Finalizado processamento da rota &1.
      me->update_roadnet_session( EXPORTING is_session      = is_session
                                            it_return       = VALUE #( ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '025' message_v1 = |{ <fs_routes>-internal_route_id ALPHA = OUT }| ) )
                                  CHANGING  ct_road_session = ct_road_session
                                            ct_road_item    = ct_road_item
                                            ct_road_log     = ct_road_log ).
* END OF INSERT - JWSILVA - 21.02.2023

    ENDLOOP."fim do loop de routes

    me->upd_bp( ).

* BEGIN OF INSERT - JWSILVA - 21.02.2023
    " Iniciando a alteração do bloqueio das remessas.
    me->update_roadnet_session( EXPORTING is_session      = is_session
                                          it_return       = VALUE #( ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '023' ) )
                                CHANGING  ct_road_session = ct_road_session
                                          ct_road_item    = ct_road_item
                                          ct_road_log     = ct_road_log ).
* END OF INSERT - JWSILVA - 21.02.2023

* ---------------------------------------------------------------------------
* Processo de liberação de remessas
* ---------------------------------------------------------------------------
*    DATA(lt_messages) = libera_remessa( is_dados = ls_dados ).
*    rt_messages = CORRESPONDING #( BASE ( rt_messages ) lt_messages ).


* BEGIN OF INSERT - JWSILVA - 21.02.2023
* ---------------------------------------------------------------------------
* Valida se todas as remessas foram adicionadas na Ordem de Frete
* ---------------------------------------------------------------------------
    me->validate_roadnet_session( EXPORTING is_session      = is_session
                                            it_road_session = ct_road_session
                                            it_road_item    = ct_road_item
                                            it_road_log     = ct_road_log
                                  IMPORTING et_return       = lt_return ).

* ---------------------------------------------------------------------------
* Atualiza logs
* ---------------------------------------------------------------------------
    me->update_roadnet_session( EXPORTING is_session      = is_session
                                          it_return       = lt_return
                                CHANGING  ct_road_session = ct_road_session
                                          ct_road_item    = ct_road_item
                                          ct_road_log     = ct_road_log ).

    " Processamento da Sessão &1 finalizada.
    rt_messages = VALUE #( BASE rt_messages ( type = 'S' id = 'ZTM_ROADNET_SESSION' number = '019' message_v1 = |{ is_session-session_identity-internal_session_id ALPHA = OUT }| ) ).
* END OF INSERT - JWSILVA - 21.02.2023

  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD build_roadnet_session.

    DATA:  lv_timestamp TYPE timestampl.

    FREE: et_road_session, et_road_item, et_road_log.

    GET TIME STAMP FIELD lv_timestamp.

* ---------------------------------------------------------------------------
* Cria registros para aplicativo de parâmetros Roadnet - Cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT it_session INTO DATA(ls_session).

      REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN ls_session-session_date WITH space.
      CONDENSE ls_session-session_date NO-GAPS.

      et_road_session[] = VALUE #( BASE et_road_session (
                                   werks                 = ls_session-session_identity-region_id
                                   dtsession             = ls_session-session_date
                                   id_session_roadnet    = ls_session-session_identity-internal_session_id
                                   total_route_id        = 0
                                   created_by            = sy-uname
                                   created_at            = lv_timestamp
                                   local_last_changed_at = lv_timestamp ) ).
    ENDLOOP.

    SORT et_road_session BY werks dtsession.
    DELETE ADJACENT DUPLICATES FROM et_road_session COMPARING werks dtsession.

* ---------------------------------------------------------------------------
* Cria registros para aplicativo de parâmetros Roadnet - Rotas
* ---------------------------------------------------------------------------
    LOOP AT it_session INTO ls_session.

      REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN ls_session-session_date WITH space.
      CONDENSE ls_session-session_date NO-GAPS.

      READ TABLE et_road_session REFERENCE INTO DATA(ls_road_session) BINARY SEARCH
                                 WITH KEY werks     = ls_session-session_identity-region_id
                                          dtsession = ls_session-session_date.
      IF sy-subrc EQ 0.
        ls_road_session->total_route_id = ls_road_session->total_route_id + lines( ls_session-session_identity-routes[] ).
      ENDIF.

      me->check_routes( EXPORTING it_routes       = ls_session-session_identity-routes  " Proxy Table Type (generated)
                        IMPORTING et_return       = DATA(lt_msg_check_routes)           " Tabela de retorno
                                  et_routes       = DATA(lt_routes_return) ).           " Root Node

      LOOP AT ls_session-session_identity-routes INTO DATA(ls_route).
        IF line_exists( lt_routes_return[ routes = ls_route-internal_route_id ] ).
          DATA(lv_tor_id) = |{ lt_routes_return[ routes = ls_route-internal_route_id ]-torid ALPHA = OUT }|.
        ELSE.
          CLEAR lv_tor_id.
        ENDIF.

        DATA(lt_deliveries) = VALUE string_table( FOR ls_stop IN ls_route-stops
                                                  FOR ls_orders IN ls_stop-orders
                                                ( ls_orders-order_number ) ).
* BEGIN OF INSERT - JWSILVA - 16.03.2023
        " Atualiza campo descrição
        ls_session-description = me->build_roadnet_description( EXPORTING iv_description = CONV #( ls_session-description ) ).
* END OF INSERT - JWSILVA - 16.03.2023

        et_road_item[]    = VALUE #( BASE et_road_item
                                   ( werks                 = ls_session-session_identity-region_id
                                     dtsession             = ls_session-session_date
                                     session_id            = ls_session-session_identity-internal_session_id
                                     route_id              = ls_route-internal_route_id
                                     deliveries            = lines( lt_deliveries )
                                     description           = ls_session-description
                                     freight_order         = lv_tor_id
                                     created_by            = sy-uname
                                     created_at            = lv_timestamp
                                     local_last_changed_at = lv_timestamp ) ).
      ENDLOOP.
    ENDLOOP.


    SORT et_road_item BY werks dtsession session_id route_id.
    DELETE ADJACENT DUPLICATES FROM et_road_item COMPARING werks dtsession session_id route_id.

* ---------------------------------------------------------------------------
* Recupera registros antigos
* ---------------------------------------------------------------------------
    IF et_road_item IS NOT INITIAL.

      SELECT *
          FROM zttm_road_item
          INTO TABLE @DATA(lt_road_item_old)
          FOR ALL ENTRIES IN @et_road_item
          WHERE werks       = @et_road_item-werks
            AND dtsession   = @et_road_item-dtsession
            AND session_id  = @et_road_item-session_id.

      IF sy-subrc EQ 0.
        SORT lt_road_item_old BY werks dtsession session_id.
      ENDIF.
    ENDIF.
*
    IF et_road_session IS NOT INITIAL.

      SELECT *
          FROM zttm_road_log
          INTO TABLE @et_road_log
          FOR ALL ENTRIES IN @et_road_session
          WHERE werks       = @et_road_session-werks
            AND dtsession   = @et_road_session-dtsession.

      IF sy-subrc EQ 0.
        SORT et_road_log BY werks dtsession session_id line.
      ENDIF.
    ENDIF.
*
* ---------------------------------------------------------------------------
* Atualiza registros com a ordem de frete criado anteriormente
* ---------------------------------------------------------------------------
    LOOP AT et_road_item REFERENCE INTO DATA(ls_road_item).

      READ TABLE lt_road_item_old REFERENCE INTO DATA(ls_road_item_old) WITH KEY werks       = ls_road_item->werks
                                                                                 dtsession   = ls_road_item->dtsession
                                                                                 session_id  = ls_road_item->session_id
                                                                                 route_id    = ls_road_item->route_id
                                                                                 BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_road_item->created_by            = ls_road_item_old->created_by.
        ls_road_item->created_at            = ls_road_item_old->created_at.
        ls_road_item->local_last_changed_at = ls_road_item_old->local_last_changed_at.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_roadnet_description.

    FREE: ev_description, rv_description.

    " Recupera valores para  tabela de parâmetros
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

    " atualiza descrição da sessão do tipo entrega
    IF iv_description IN ls_parameter-r_entrega AND ls_parameter-r_entrega IS NOT INITIAL.
      rv_description = ev_description = gc_param_entrega-chave2.
      RETURN.
    ENDIF.

    " atualiza descrição da sessão do tipo crossdocking
    IF iv_description IN ls_parameter-r_crossdocking AND ls_parameter-r_crossdocking IS NOT INITIAL.
      rv_description = ev_description = gc_param_crossdocking-chave2+0(5).
      RETURN.
    ENDIF.

    " atualiza descrição da sessão do tipo redespacho
    IF iv_description IN ls_parameter-r_redespacho AND ls_parameter-r_redespacho IS NOT INITIAL.
      rv_description = ev_description = gc_param_redespacho-chave2.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD update_roadnet_session.

    FREE: et_road_log_new.

    DATA: lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    DATA(lv_session_date) = is_session-session_date.
    REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_session_date WITH space.
    CONDENSE lv_session_date NO-GAPS.


* BEGIN OF INSERT - JWSILVA - 21.02.2023
* ---------------------------------------------------------------------------
* Atualiza campo de Ordem de Frete
* ---------------------------------------------------------------------------
    IF iv_tor_id IS NOT INITIAL AND is_routes IS NOT INITIAL.

      DATA(lv_dtsession) = CONV char10( is_session-session_date ).
      REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
      CONDENSE lv_dtsession NO-GAPS.

      READ TABLE ct_road_item ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY werks      = is_session-session_identity-region_id
                                                                         dtsession  = lv_dtsession
                                                                         session_id = is_session-session_identity-internal_session_id
                                                                         route_id   = is_routes-internal_route_id.
      IF sy-subrc IS INITIAL.
        <fs_item>-freight_order         = iv_tor_id.
        <fs_item>-last_changed_by       = sy-uname.
        <fs_item>-last_changed_at       = lv_timestamp.
        <fs_item>-local_last_changed_at = lv_timestamp.
      ENDIF.
    ENDIF.
* END OF DELETE - JWSILVA - 21.02.2023

* ---------------------------------------------------------------------------
* Prepara chave
* ---------------------------------------------------------------------------
    DATA(ls_key) = VALUE zttm_road_item( werks      = is_session-session_identity-region_id
                                         dtsession  = lv_session_date
                                         session_id = is_session-session_identity-internal_session_id ).

* ---------------------------------------------------------------------------
* Atualiza Log
* ---------------------------------------------------------------------------
    DATA(lt_return) = it_return.
    me->format_return( CHANGING ct_return = lt_return ).

    TRY.
        DATA(lt_road_log) = ct_road_log.
        SORT lt_road_log BY line DESCENDING.
        DATA(lv_line) = lt_road_log[ 1 ]-line.
      CATCH cx_root.
        CLEAR lv_line.
    ENDTRY.

    LOOP AT lt_return INTO DATA(ls_return).
      lv_line = lv_line + 1.
      et_road_log_new[] = VALUE #( BASE et_road_log_new (
                                   werks                 = ls_key-werks
                                   dtsession             = ls_key-dtsession
                                   session_id            = ls_key-session_id
                                   line                  = lv_line
                                   route_id              = is_routes-internal_route_id      " INSERT - JWSILVA - 14.03.2023
                                   msgty                 = ls_return-type
                                   msgid                 = ls_return-id
                                   msgno                 = ls_return-number
                                   msgv1                 = ls_return-message_v1
                                   msgv2                 = ls_return-message_v2
                                   msgv3                 = ls_return-message_v3
                                   msgv4                 = ls_return-message_v4
                                   message               = ls_return-message
                                   created_by            = sy-uname
                                   created_at            = lv_timestamp
                                   local_last_changed_at = lv_timestamp ) ).
    ENDLOOP.

    INSERT LINES OF et_road_log_new INTO TABLE ct_road_log.
*    DELETE ADJACENT DUPLICATES FROM ct_road_log COMPARING msgid
*                                                          msgno
*                                                          msgv1
*                                                          msgv2
*                                                          msgv3
*                                                          msgv4.

* BEGIN OF INSERT - JWSILVA - 21.02.2023
* ---------------------------------------------------------------------------
* Salva Log em tempo de execução
* ---------------------------------------------------------------------------
    me->save_roadnet_session( EXPORTING it_road_session = ct_road_session
                                        it_road_item    = ct_road_item
                                        it_road_log     = et_road_log_new       " Somente gravar os logs novos
                              IMPORTING et_return       = DATA(lt_return_save) ).
* END OF INSERT - JWSILVA - 21.02.2023

  ENDMETHOD.


  METHOD save_roadnet_session.

* ---------------------------------------------------------------------------
* Salva dados de sessão Roadnet
* ---------------------------------------------------------------------------
    IF it_road_session IS NOT INITIAL.

      MODIFY zttm_road_sessio FROM TABLE it_road_session.

      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.

    IF it_road_session IS NOT INITIAL.

      SELECT *
          FROM zttm_road_item
          INTO TABLE @DATA(lt_road_item_old)
          FOR ALL ENTRIES IN @it_road_session
          WHERE werks     = @it_road_session-werks
            AND dtsession = @it_road_session-dtsession. "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE lt_road_item_old.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de rota Roadnet
* ---------------------------------------------------------------------------
    IF it_road_item IS NOT INITIAL.

      MODIFY zttm_road_item FROM TABLE it_road_item.

      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Remove dados de rota Roadnet que não existem mais
* ---------------------------------------------------------------------------
    LOOP AT lt_road_item_old REFERENCE INTO DATA(ls_road_item_old).

      DATA(lv_index) = sy-tabix.

      IF line_exists( it_road_item[ werks      = ls_road_item_old->werks
                                    dtsession  = ls_road_item_old->dtsession
                                    session_id = ls_road_item_old->session_id
                                    route_id   = ls_road_item_old->route_id ] ).

        DELETE lt_road_item_old INDEX lv_index.

      ENDIF.

    ENDLOOP.

    IF lt_road_item_old IS NOT INITIAL.

      DELETE zttm_road_item FROM TABLE lt_road_item_old.

      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de log Roadnet
* ---------------------------------------------------------------------------
    IF it_road_log IS NOT INITIAL.

      MODIFY zttm_road_log FROM TABLE it_road_log.

      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_roadnet_session.

    DATA: lt_vbeln  TYPE STANDARD TABLE OF likp-vbeln.

    FREE: et_return.

    DATA(lv_dtsession) = CONV char10( is_session-session_date ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_dtsession WITH space.
    CONDENSE lv_dtsession NO-GAPS.

* ---------------------------------------------------------------------------
* Separa e recupera todas as remessas
* ---------------------------------------------------------------------------
    lt_vbeln = VALUE #( FOR ls_route IN is_session-session_identity-routes
                        FOR ls_stop  IN ls_route-stops
                        FOR ls_order IN ls_stop-orders
                      ( |{ ls_order-order_number ALPHA = IN }| ) ).
    SORT lt_vbeln BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_vbeln COMPARING table_line.

    IF lt_vbeln IS NOT INITIAL.

      SELECT DISTINCT freightorder, deliverydocument
          FROM zi_tm_gestao_frota_docs_of
          FOR ALL ENTRIES IN @lt_vbeln
          WHERE deliverydocument EQ @lt_vbeln-table_line
          INTO TABLE @DATA(lt_docs).

      IF sy-subrc EQ 0.
        SORT lt_docs BY deliverydocument freightorder.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida os documentos criados
* ---------------------------------------------------------------------------
    LOOP AT is_session-session_identity-routes REFERENCE INTO DATA(ls_routes).

      READ TABLE it_road_item INTO DATA(ls_road_item) WITH KEY werks      = is_session-session_identity-region_id
                                                               dtsession  = lv_dtsession
                                                               session_id = is_session-session_identity-internal_session_id
                                                               route_id   = ls_routes->internal_route_id.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

* ---------------------------------------------------------------------------
* Valida Ordem de Frete
* ---------------------------------------------------------------------------
      IF ls_road_item-freight_order IS INITIAL.
        " Falha ao criar Ordem de Frete para Sessão &1 Rota &1.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '020'
                                              message_v1 = |{ ls_road_item-session_id ALPHA = OUT }|
                                              message_v2 = |{ ls_road_item-route_id ALPHA = OUT }| ) ).
        CONTINUE.
      ENDIF.

      LOOP AT ls_routes->stops REFERENCE INTO DATA(ls_stops).

        LOOP AT ls_stops->orders REFERENCE INTO DATA(ls_orders).

* ---------------------------------------------------------------------------
* Valida Remessa
* ---------------------------------------------------------------------------
          DATA(lv_vbeln) = CONV vbeln_vl( |{ ls_orders->order_number ALPHA = IN }| ).

          READ TABLE lt_docs TRANSPORTING NO FIELDS BINARY SEARCH WITH KEY deliverydocument = lv_vbeln
                                                                           freightorder     = |{ ls_road_item-freight_order ALPHA = IN }|.

          IF sy-subrc NE 0.

            READ TABLE lt_docs INTO DATA(ls_docs) BINARY SEARCH WITH KEY deliverydocument = lv_vbeln.

            IF sy-subrc EQ 0.
              " Remessa &1 não atribuída à OF &2. Atualmente Atribuída na OF &3.
              et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '022'
                                                    message_v1 = |{ lv_vbeln ALPHA = OUT }|
                                                    message_v2 = |{ ls_road_item-freight_order ALPHA = OUT }|
                                                    message_v3 = |{ ls_docs-freightorder ALPHA = OUT }| ) ).
            ELSE.
              " Remessa &1 não atribuída à Ordem de Frete &2.
              et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '021'
                                                    message_v1 = |{ lv_vbeln ALPHA = OUT }|
                                                    message_v2 = |{ ls_road_item-freight_order ALPHA = OUT }| ) ).
            ENDIF.
          ENDIF.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Formata mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

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


  METHOD ajusta_fu_stop.

    DATA: lt_uf_stop TYPE /scmtms/t_tor_stop_k,
          lt_mod_uf  TYPE /bobf/t_frw_modification.

    DATA: lo_message TYPE REF TO /bobf/if_frw_message.

    CHECK ct_stop IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
    DATA(lo_txn_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).


    lt_uf_stop[] = ct_stop[].

    LOOP AT lt_uf_stop ASSIGNING FIELD-SYMBOL(<fs_stop>).
      IF     <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.

*        <fs_stop>-acc_end         = is_dados-planed_outbound.
        <fs_stop>-acc_start       = is_dados-planed_outbound.
        <fs_stop>-req_end         = is_dados-planed_outbound.
        <fs_stop>-req_start       = is_dados-planed_outbound.

      ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.

*        <fs_stop>-acc_start       = is_dados-planed_inbound.
        <fs_stop>-acc_end         = is_dados-planed_inbound.
        <fs_stop>-req_end         = is_dados-planed_inbound.
        <fs_stop>-req_start       = is_dados-planed_inbound.

      ENDIF.
    ENDLOOP.

    ct_stop[] = lt_uf_stop[].

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_uf_stop
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       iv_node        = /scmtms/if_tor_c=>sc_node-stop
                                              CHANGING ct_mod         = lt_mod_uf ).

    IF lt_mod_uf[] IS NOT INITIAL.

      lo_tor_mgr->modify( it_modification = lt_mod_uf ).
      lo_txn_mgr->save( IMPORTING eo_message = lo_message ).

    ENDIF.

  ENDMETHOD.


  METHOD ajusta_km.

    DATA: lt_stop          TYPE /scmtms/t_tor_stop_k,
          lt_stop_succ     TYPE /scmtms/t_tor_stop_succ_k,
          lt_stop_succ_udt TYPE /scmtms/t_tor_stop_succ_k,
          lt_tor_root_key  TYPE /bobf/t_frw_key,
          lt_mod           TYPE /bobf/t_frw_modification,
          lt_return        TYPE bapiret2_tab,
          lv_km            TYPE /scmtms/decimal_value.

    DATA(lo_tra_tor) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_root_tor-key
                                                 CHANGING ct_key = lt_tor_root_key ).

*   Busca informações de etapas/paradas
    lo_tor_mgr->retrieve_by_association( EXPORTING  it_key         = lt_tor_root_key
                                                    iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                    iv_association = /scmtms/if_tor_c=>sc_association-root-stop
                                                    iv_fill_data   = abap_true
                                         IMPORTING  et_data = lt_stop ).

    lo_tor_mgr->retrieve_by_association( EXPORTING  it_key         = lt_tor_root_key
                                                    iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                    iv_association = /scmtms/if_tor_c=>sc_association-root-stop_succ
                                                    iv_fill_data   = abap_true
                                         IMPORTING  et_data = lt_stop_succ ).
    CLEAR: lv_km.

    lv_km = REDUCE #( INIT lv_x = '0.000000'
                      FOR <fs_km> IN it_etapas
                      NEXT lv_x = lv_x + <fs_km>-distance_km ).

    LOOP AT lt_stop_succ ASSIGNING FIELD-SYMBOL(<fs_stop_succ>).

      IF line_exists( lt_stop[ key = <fs_stop_succ>-succ_stop_key ] ).

        DATA(ls_stop) = lt_stop[ key = <fs_stop_succ>-succ_stop_key ].

        IF line_exists( it_etapas[ locid = ls_stop-log_locid ] ).

          <fs_stop_succ>-distance_km = it_etapas[ locid = ls_stop-log_locid ]-distance_km.
          APPEND <fs_stop_succ> TO lt_stop_succ_udt.

        ELSE.

          <fs_stop_succ>-distance_km = gv_km_total - lv_km.
          APPEND <fs_stop_succ> TO lt_stop_succ_udt.

        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_stop_succ_udt[] IS NOT INITIAL.

      /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING it_data        = lt_stop_succ_udt
                                                         iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                         iv_node        = /scmtms/if_tor_c=>sc_node-stop_successor
                                                CHANGING ct_mod         = lt_mod ).

      TRY.
          lo_tor_mgr->modify( EXPORTING it_modification = lt_mod                 " Changes
                              IMPORTING eo_message      = DATA(lo_message) ).    " Interface of Message Object

          " Converte mensagens de execução
          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING iv_action_messages = space
                                                                           io_message         = lo_message
                                                                  CHANGING ct_bapiret2        = lt_return ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO rt_messages.
          ENDIF.

          lo_tra_tor->save( IMPORTING eo_message = lo_message ).

          CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
            EXPORTING
              werks          = gv_centro
              dtsession      = gv_data
            EXCEPTIONS
              foreign_lock   = 1
              system_failure = 2
              OTHERS         = 3.
          IF sy-subrc = 0.
            DATA(lv_enqueue) = abap_true.
          ENDIF.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING iv_action_messages = space
                                                                           io_message         = lo_message
                                                                  CHANGING ct_bapiret2        = lt_return ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO rt_messages.
          ENDIF.
        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD check_routes.

    DATA: lt_tor_doc_ref TYPE /scmtms/t_tor_docref_k,
          lt_tor_root    TYPE /scmtms/t_tor_root_k,
          lt_tor_root_s  TYPE STANDARD TABLE OF /scmtms/s_tor_root_k,
          lt_parameters  TYPE /bobf/t_frw_query_selparam.

    CONSTANTS: lc_btd_tco_roadnet TYPE /scmtms/btd_type_code VALUE 'ROADN'.

    CLEAR: lt_parameters[],
           lt_tor_doc_ref[],
           rt_check_routes.

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_param>).
    <fs_param>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-docreference-docreference_elements-btd_tco.
    <fs_param>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_param>-option         = /bobf/if_conf_c=>sc_sign_equal.
    <fs_param>-low            = lc_btd_tco_roadnet.

    LOOP AT it_routes ASSIGNING FIELD-SYMBOL(<fs_routes>).
      APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_param>.
      <fs_param>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-docreference-docreference_elements-btd_id.
      <fs_param>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
      <fs_param>-option         = /bobf/if_conf_c=>sc_sign_equal.
      <fs_param>-low            = <fs_routes>-internal_route_id.
    ENDLOOP.

    TRY.
        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-docreference-docreference_elements                 " Query
            it_selection_parameters = lt_parameters                 " Query Selection Parameters
            iv_fill_data            = abap_true       " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_tor_doc_ref ).

        IF lt_tor_doc_ref[] IS NOT INITIAL.

          /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root                             " Node
              it_key                  = CORRESPONDING #( lt_tor_doc_ref MAPPING key = parent_key ) " Key Table
            IMPORTING
              et_data                 = lt_tor_root ).

          DELETE lt_tor_root WHERE lifecycle = '10'.

          IF lt_tor_root[] IS NOT INITIAL.
            LOOP AT it_routes ASSIGNING <fs_routes>.
              IF line_exists( lt_tor_doc_ref[ btd_id = <fs_routes>-internal_route_id ] ).
*                DATA(ls_doc_ref) = lt_tor_doc_ref[ btd_id = <fs_routes>-internal_route_id ].       " DELETE - JWSILVA - 21.02.2023

                LOOP AT lt_tor_doc_ref INTO DATA(ls_doc_ref) WHERE btd_id = <fs_routes>-internal_route_id. "#EC CI_SORTSEQ

                  IF line_exists( lt_tor_root[ key = ls_doc_ref-root_key ] ).
                    APPEND INITIAL LINE TO et_routes ASSIGNING FIELD-SYMBOL(<fs_routes_return>).
                    <fs_routes_return>-routes = <fs_routes>-internal_route_id.
                    <fs_routes_return>-torid  = |{ lt_tor_root[ key = ls_doc_ref-root_key ]-tor_id ALPHA = OUT }|.
                  ENDIF.
                ENDLOOP.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

    ENDTRY.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.
      WHEN 'LIBERA_REMESSA'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_LIBERA_REMESSA'
          IMPORTING et_return = gt_return.

        gv_wait_async = abap_true.
    ENDCASE.

  ENDMETHOD.

  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera Parâmetro para ENTREGA
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_entrega IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_entrega-modulo
                                                 chave1 = gc_param_entrega-chave1
                                                 chave2 = gc_param_entrega-chave2
                                                 chave3 = gc_param_entrega-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_entrega[] ).

    ENDIF.

    IF me->gs_parameter-r_entrega IS INITIAL.
      " Descrições para "Entrega" não cadastrado na tabela de parâmetros.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '030'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro para CROSSDOCKING
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_crossdocking IS INITIAL.

      ls_parametro       = VALUE ztca_param_val( modulo = gc_param_crossdocking-modulo
                                                 chave1 = gc_param_crossdocking-chave1
                                                 chave2 = gc_param_crossdocking-chave2
                                                 chave3 = gc_param_crossdocking-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_crossdocking[] ).

    ENDIF.

    IF me->gs_parameter-r_crossdocking IS INITIAL.
      " Descrições para "Crossdocking" não cadastrado na tabela de parâmetros.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '031'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro para REDESPACHO
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_redespacho IS INITIAL.

      ls_parametro       = VALUE ztca_param_val( modulo = gc_param_redespacho-modulo
                                                 chave1 = gc_param_redespacho-chave1
                                                 chave2 = gc_param_redespacho-chave2
                                                 chave3 = gc_param_redespacho-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_redespacho[] ).

    ENDIF.

    IF me->gs_parameter-r_redespacho IS INITIAL.
      " Descrições para "Redespacho" não cadastrado na tabela de parâmetros.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_ROADNET_SESSION' number = '032'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD get_parameter.

    FREE et_value.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                         iv_chave1 = is_param-chave1
                                         iv_chave2 = is_param-chave2
                                         iv_chave3 = is_param-chave3
                               IMPORTING et_range  = et_value ).
      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
