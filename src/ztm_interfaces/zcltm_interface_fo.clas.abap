CLASS zcltm_interface_fo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_codstatus,
        no_exec      TYPE ze_int_status VALUE '00',   " Interface não executada
        exec_sucesso TYPE ze_int_status VALUE '01',   " Interface executada com sucesso
        exec_erro    TYPE ze_int_status VALUE '02',   " Interface executada com erro
        fat_sucesso  TYPE ze_int_status VALUE '03',   " Faturado com sucesso
        fat_erro     TYPE ze_int_status VALUE '04',   " Erro no faturamento
        no_fat       TYPE ze_int_status VALUE '05',   " Aguardando faturamento
        fat_estorno  TYPE ze_int_status VALUE '06',   " Fatura Estornada
      END OF gc_codstatus .
    CONSTANTS:
      BEGIN OF gc_icons,
        green    TYPE icon_d VALUE icon_led_green,    " LED verde; avançar; OK
        red      TYPE icon_d VALUE icon_led_red,      " LED vermelho; parar; incorreto
        yellow   TYPE icon_d VALUE icon_led_yellow,   " LED amarelo; atenção
        inactive TYPE icon_d VALUE icon_led_inactive, " LED inativo; indefinido
      END OF gc_icons .
    CONSTANTS:
      BEGIN OF gc_interface,
        gko       TYPE balsubobj VALUE 'ZGKO',        " Interface GKO
        greenmile TYPE balsubobj VALUE 'ZGM',         " Interface Greenmile
        trafegus  TYPE balsubobj VALUE 'ZTRAF',       " Interface Trafegus
      END OF gc_interface .

    METHODS execute
      IMPORTING
        !iv_execution_type TYPE string OPTIONAL .
    CLASS-METHODS get_status_desc
      IMPORTING
        !is_status_cod        TYPE ze_int_status
      RETURNING
        VALUE(rv_status_desc) TYPE char50 .
    METHODS set_status_invoicing
      IMPORTING
        !is_header TYPE j_1bnfdoc OPTIONAL .
    METHODS get_query_parameters
      CHANGING
        !ct_parameters TYPE /bobf/t_frw_query_selparam .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: gc_gko       TYPE string VALUE 'GKO',
               gc_greenmile TYPE string VALUE 'GEENMILE',
               gc_trafegus  TYPE string VALUE 'TRAFEGUS'.

    TYPES:
      BEGIN OF ty_tsp_id,
        tsp_id TYPE  /scmtms/s_tor_root_k-tspid,
      END OF ty_tsp_id,
      ty_tt_tspid TYPE SORTED TABLE OF ty_tsp_id WITH NON-UNIQUE KEY tsp_id,

      BEGIN OF ty_tsp_coligada,
        partner TYPE but000-partner,
      END OF ty_tsp_coligada,
      ty_tt_tsp_coligada TYPE SORTED TABLE OF ty_tsp_coligada WITH NON-UNIQUE KEY partner.

    METHODS:
      get_db_tsp_coligada
        IMPORTING
          it_tor_root      TYPE /scmtms/t_tor_root_k
        RETURNING
          VALUE(rt_return) TYPE ty_tt_tsp_coligada.

    METHODS call_gko
      EXPORTING
        !et_messages TYPE bapiret2_t
      CHANGING
        !cs_tor_root TYPE /scmtms/s_tor_root_k .
    METHODS call_gm
      EXPORTING
        !et_messages TYPE bapiret2_t
      CHANGING
        !cs_tor_root TYPE /scmtms/s_tor_root_k .
    METHODS call_traf
      EXPORTING
        !et_messages TYPE bapiret2_t
      CHANGING
        !cs_tor_root TYPE /scmtms/s_tor_root_k .
    METHODS save_log
      IMPORTING
        !it_messages   TYPE bapiret2_t
        !iv_subobject  TYPE balsubobj OPTIONAL
        !iv_externalid TYPE balnrext OPTIONAL .
    METHODS check_fus
      IMPORTING
        !is_tor_root    TYPE /scmtms/s_tor_root_k
      RETURNING
        VALUE(rv_check) TYPE abap_boolean .
ENDCLASS.



CLASS ZCLTM_INTERFACE_FO IMPLEMENTATION.


  METHOD call_gko.

    "Instanciar classe para envio da ordem de frete ao GKO
    DATA(lo_gko) = NEW zcltm_interface_fo_gko( ).

    lo_gko->gerar_arquivo_gko( EXPORTING iv_tor_key  = cs_tor_root-key
                               IMPORTING et_messages = DATA(lt_return) ).

    IF line_exists( lt_return[ msgty = if_xo_const_message=>error ] ) OR  "Se ocorrer erros no envio, setar retorno para erro
       line_exists( lt_return[ msgty = if_xo_const_message=>abort ] ). "#EC CI_STDSEQ

      cs_tor_root-zzint_gko_status = gc_codstatus-exec_erro.
      cs_tor_root-zzint_gko_desc   = get_status_desc( is_status_cod = gc_codstatus-exec_erro ).
      cs_tor_root-zzint_gko_icon   = gc_icons-red.
      cs_tor_root-zzint_gko_data   = sy-datum.
      cs_tor_root-zzint_gko_hora   = sy-uzeit.

    ELSE.                                                                 "Sucesso no envio

      cs_tor_root-zzint_gko_status = gc_codstatus-exec_sucesso.
      cs_tor_root-zzint_gko_desc   = get_status_desc( is_status_cod = gc_codstatus-exec_sucesso ).
      cs_tor_root-zzint_gko_icon   = gc_icons-green.
      cs_tor_root-zzint_gko_data   = sy-datum.
      cs_tor_root-zzint_gko_hora   = sy-uzeit.

    ENDIF.

    IF lt_return IS NOT INITIAL.
      et_messages = VALUE #( FOR <fs_return> IN lt_return
                           ( type       = <fs_return>-msgty
                             id         = <fs_return>-msgid
                             number     = <fs_return>-msgno
                             message_v1 = <fs_return>-msgv1
                             message_v2 = <fs_return>-msgv2
                             message_v3 = <fs_return>-msgv3
                             message_v4 = <fs_return>-msgv4 ) ).
    ENDIF.

  ENDMETHOD.


  METHOD call_gm.

    DATA: lo_interface TYPE REF TO ziftm_envio_tor_greenmile.

    lo_interface ?= NEW zcltm_process_greenmile( ).
    lo_interface->enviar_tor( EXPORTING iv_tor_key  = cs_tor_root-key
                              IMPORTING ev_exec     = DATA(lv_exec)
                                        et_messages = DATA(lt_return) ).

    CHECK lv_exec IS INITIAL.

    IF line_exists( lt_return[ msgty = if_xo_const_message=>error ] ) OR  "Se ocorrer erros no envio, setar retorno para erro
       line_exists( lt_return[ msgty = if_xo_const_message=>abort ] ). "#EC CI_STDSEQ

      cs_tor_root-zzint_gm_status = gc_codstatus-exec_erro.
      cs_tor_root-zzint_gm_desc   = get_status_desc( is_status_cod = gc_codstatus-exec_erro ).
      cs_tor_root-zzint_gm_icon   = gc_icons-red.
      cs_tor_root-zzint_gm_data   = sy-datum.
      cs_tor_root-zzint_gm_hora   = sy-uzeit.

    ELSE.                                                                   "Sucesso no envio

      cs_tor_root-zzint_gm_status = gc_codstatus-exec_sucesso.
      cs_tor_root-zzint_gm_desc   = get_status_desc( is_status_cod = gc_codstatus-exec_sucesso ).
      cs_tor_root-zzint_gm_icon   = gc_icons-green.
      cs_tor_root-zzint_gm_data   = sy-datum.
      cs_tor_root-zzint_gm_hora   = sy-uzeit.

    ENDIF.

    IF lt_return IS NOT INITIAL.
      et_messages = VALUE #( FOR <fs_return> IN lt_return
                           ( type       = <fs_return>-msgty
                             id         = <fs_return>-msgid
                             number     = <fs_return>-msgno
                             message_v1 = <fs_return>-msgv1
                             message_v2 = <fs_return>-msgv2
                             message_v3 = <fs_return>-msgv3
                             message_v4 = <fs_return>-msgv4 ) ).
    ENDIF.

  ENDMETHOD.


  METHOD call_traf.

    DATA(lo_trafegus) = NEW zcltm_send_of_trafegus( ).
    lo_trafegus->process( EXPORTING iv_key    = cs_tor_root-key
                                    iv_memory = abap_true ).

    IF lo_trafegus->send_data( ) EQ abap_true.

      "Sucesso no envio
      cs_tor_root-zzint_traf_status = gc_codstatus-exec_sucesso.
      cs_tor_root-zzint_traf_desc   = get_status_desc( is_status_cod = gc_codstatus-exec_sucesso ).
*      cs_tor_root-zzint_traf_icon   = get_icon( is_icon_name = gc_icons-green ).
      cs_tor_root-zzint_traf_icon   = gc_icons-green.
      cs_tor_root-zzint_traf_data   = sy-datum.
      cs_tor_root-zzint_traf_hora   = sy-uzeit.

    ELSE.

      DATA(lt_return) = lo_trafegus->get_erro( ).
      IF lt_return IS NOT INITIAL.
        et_messages = lt_return.
      ENDIF.

      " Se ocorrer erros no envio, setar retorno para erro
      cs_tor_root-zzint_traf_status = gc_codstatus-exec_erro.
      cs_tor_root-zzint_traf_desc   = get_status_desc( is_status_cod = gc_codstatus-exec_erro ).
*      cs_tor_root-zzint_traf_icon   = get_icon( is_icon_name = gc_icons-red ).
      cs_tor_root-zzint_traf_icon   = gc_icons-red.
      cs_tor_root-zzint_traf_data   = sy-datum.
      cs_tor_root-zzint_traf_hora   = sy-uzeit.

    ENDIF.

  ENDMETHOD.


  METHOD check_fus.

    " Ranges
    DATA: lr_fu_type  TYPE RANGE OF /scmtms/tor_type.

    " Tabelas
    DATA: lt_fu_root    TYPE /scmtms/t_tor_root_k.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).
        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
                                         iv_chave1 = 'TOR_TYPE_FU'
                               IMPORTING et_range  = lr_fu_type ).
      CATCH zcxca_tabela_parametros.
        FREE lr_fu_type.
    ENDTRY.

    TRY.
        CLEAR: lt_fu_root.
        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root                                                                      " Node
            it_key                  = VALUE #( ( key = is_tor_root-key ) )                                                                " Key Table
            iv_association          = /scmtms/if_tor_c=>sc_association-root-assigned_fus                                                  " Association
            iv_fill_data            = abap_true
          IMPORTING
            et_data                 = lt_fu_root ).

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    IF lr_fu_type IS NOT INITIAL.
      DELETE lt_fu_root WHERE tor_type IN lr_fu_type.   "#EC CI_SORTSEQ
    ENDIF.

    CLEAR rv_check.

    IF lt_fu_root IS INITIAL.
      rv_check = abap_true.
      RETURN.
    ENDIF.

    LOOP AT lt_fu_root ASSIGNING FIELD-SYMBOL(<fs_fu>).
      IF <fs_fu>-zzint_fat_status NE gc_codstatus-fat_sucesso.
        rv_check = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD execute.

    " Tabelas
    DATA: lt_tor_root   TYPE /scmtms/t_tor_root_k,
          lt_mod        TYPE /bobf/t_frw_modification,
          lt_parameters TYPE /bobf/t_frw_query_selparam,
          lt_return     TYPE bapiret2_t.

    " Estruturas
    DATA: ls_tor_root_old TYPE /scmtms/s_tor_root_k,
          ls_mod          TYPE /bobf/s_frw_modification.

    " variaveis
    DATA: lv_key  TYPE  /bobf/conf_key.

    CLEAR: lt_parameters[].
    get_query_parameters( CHANGING ct_parameters = lt_parameters ).                                                                 " Query Selection Parameters

    TRY.

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes                                           " Query
            it_selection_parameters = lt_parameters                                                                                 " Query Selection Parameters
            iv_fill_data            = abap_true
          IMPORTING
            et_data                 = lt_tor_root ).

      CATCH /bobf/cx_frw_contrct_violation.                                                                                         " Caller violates a BOPF contract.
        RETURN.
    ENDTRY.

    " Remover FOs com status de execução com sucesso.
    DELETE lt_tor_root WHERE zzint_gko_status  = gc_codstatus-exec_sucesso
                         AND zzint_gm_status   = gc_codstatus-exec_sucesso
                         AND zzint_traf_status = gc_codstatus-exec_sucesso. "#EC CI_SORTSEQ

    CHECK lt_tor_root IS NOT INITIAL.

    DATA(lt_tsp_coligada) = get_db_tsp_coligada( lt_tor_root ).

    CLEAR: lt_mod.

    LOOP AT lt_tor_root INTO DATA(ls_tor_root).

      " Verifica se todas as FUs foram faturadas
      IF check_fus( is_tor_root = ls_tor_root ) EQ abap_true.
        CONTINUE.
      ENDIF.

      ls_tor_root_old = ls_tor_root.

      " Interface GKO
      IF iv_execution_type = me->gc_gko OR iv_execution_type IS INITIAL.
        IF ls_tor_root-zzint_gko_status NE gc_codstatus-exec_sucesso.

          call_gko( IMPORTING et_messages = DATA(lt_message)                                                                            " System Messages
                    CHANGING  cs_tor_root = ls_tor_root ).                                                                              " Root Node

          IF lt_message IS NOT INITIAL.
            save_log( it_messages   = lt_message                                                                                        " System Messages
                      iv_subobject  = gc_interface-gko                                                                                  " Log de aplicação: subobjeto
                      iv_externalid = CONV balnrext( |{ ls_tor_root-tor_id ALPHA = OUT }| ) ).                                          " Log de aplicação: identificação externa

          ENDIF.
          CLEAR: lt_message.
        ENDIF.
      ENDIF.

      " Interface Greenmile
      IF iv_execution_type = me->gc_greenmile OR iv_execution_type IS INITIAL.
        IF ls_tor_root-zzint_gm_status NE gc_codstatus-exec_sucesso.

          call_gm( IMPORTING et_messages = lt_message                                                                                   " System Messages
                   CHANGING  cs_tor_root = ls_tor_root ).                                                                               " Root Node

          IF lt_message IS NOT INITIAL.
            save_log( it_messages   = lt_message                                                                                        " System Messages
                      iv_subobject  = gc_interface-greenmile                                                                            " Log de aplicação: subobjeto
                      iv_externalid = CONV balnrext( |{ ls_tor_root-tor_id ALPHA = OUT }| ) ).                                          " Log de aplicação: identificação externa
          ENDIF.
          CLEAR: lt_message.
        ENDIF.
      ENDIF.

      " Interface Trafegus
      IF iv_execution_type = me->gc_trafegus OR iv_execution_type IS INITIAL.
        IF ls_tor_root-zzint_traf_status NE gc_codstatus-exec_sucesso.
          IF line_exists( lt_tsp_coligada[ partner = ls_tor_root-tspid ] ).
            call_traf( IMPORTING et_messages = lt_message                                                                                 " System Messages
                       CHANGING  cs_tor_root = ls_tor_root ).                                                                             " Root Node

            IF lt_message IS NOT INITIAL.
              save_log( it_messages   = lt_message                                                                                        " System Messages
                        iv_subobject  = gc_interface-trafegus                                                                             " Log de aplicação: subobjeto
                        iv_externalid = CONV balnrext( |{ ls_tor_root-tor_id ALPHA = OUT }| ) ).                                          " Log de aplicação: identificação externa
            ENDIF.
            CLEAR: lt_message.
          ENDIF.
        ENDIF.
      ENDIF.

      /scmtms/cl_mod_helper=>mod_update_chg_fields(
        EXPORTING
          iv_node     = /scmtms/if_tor_c=>sc_node-root                                                                                " Node
          is_data     = ls_tor_root                                                                                                   " New Data
          is_data_old = ls_tor_root_old                                                                                               " Old Data
          iv_bo_key   = /scmtms/if_tor_c=>sc_bo_key                                                                                   " Business Object
        IMPORTING
          es_mod      = ls_mod ).                                                                                                     " Change

      IF ls_mod IS NOT INITIAL.
        APPEND ls_mod TO lt_mod.
      ENDIF.

      CLEAR: ls_tor_root_old,
             ls_mod.
    ENDLOOP.

    IF lt_mod IS NOT INITIAL.
      TRY.

          /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify( EXPORTING it_modification = lt_mod " Changes
                                                                                                     IMPORTING eo_message      = DATA(lo_message_mod) ).

          /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message = DATA(lo_message_save) ).

*          IF NOT lo_message_save IS INITIAL.
*
*            CLEAR lt_message.
*            /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
*                                                                   CHANGING  ct_bapiret2 = lt_message[] ).
*
*            IF lt_message IS NOT INITIAL.
*              lt_return = CORRESPONDING #( BASE ( lt_return ) lt_message ).
*            ENDIF.
*
*            CLEAR: lt_message,
*                   lo_message_save.
*
*          ENDIF.
*
*          save_log( it_messages = lt_return ).
*          CLEAR: lt_return[].

        CATCH /bobf/cx_frw_contrct_violation.                                                                                         " Caller violates a BOPF contract
          RETURN.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD get_query_parameters.

    " Ranges
    DATA: lr_tor_type TYPE RANGE OF /scmtms/tor_type.

    " Variaveis
    DATA: lv_data_inicio    TYPE begda,
          lv_data_fim       TYPE begda,
          lv_data_ts_inicio TYPE /bofu/tstmp_creation_time,
          lv_data_ts_fim    TYPE /bofu/tstmp_creation_time.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
                                         iv_chave1 = 'TOR_TYPE'
                               IMPORTING et_range  = lr_tor_type ).
      CATCH zcxca_tabela_parametros.
        FREE lr_tor_type.
    ENDTRY.

    ct_parameters = VALUE #( FOR <fs_tor_type> IN lr_tor_type
                           ( attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-tor_type
                             sign           = /bobf/if_conf_c=>sc_sign_option_including
                             option         = /bobf/if_conf_c=>sc_sign_equal
                             low            = <fs_tor_type>-low ) ).

    APPEND INITIAL LINE TO ct_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
    <fs_parameters>-attribute_name  = /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat.
    <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_equal.
    <fs_parameters>-low             = /scmtms/if_tor_const=>sc_tor_category-active.

    APPEND INITIAL LINE TO ct_parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-attribute_name  = /scmtms/if_tor_c=>sc_node_attribute-root-tspid.
    <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_not_equal.
    <fs_parameters>-low             = abap_false.

    APPEND INITIAL LINE TO ct_parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-attribute_name  = 'ZZ1_COND_EXPED'.
    <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_not_equal.
    <fs_parameters>-low             = abap_false.

    APPEND INITIAL LINE TO ct_parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-attribute_name  = 'ZZ1_TIPO_EXPED'.
    <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_not_equal.
    <fs_parameters>-low             = abap_false.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum
        days      = '05'
        months    = '00'
        signum    = '-'
        years     = '00'
      IMPORTING
        calc_date = lv_data_inicio.

    lv_data_fim = sy-datum.

    CONVERT DATE lv_data_inicio
            TIME sy-uzeit
            INTO TIME STAMP lv_data_ts_inicio TIME ZONE sy-zonlo.

    CONVERT DATE lv_data_fim
            TIME sy-uzeit
            INTO TIME STAMP lv_data_ts_fim TIME ZONE sy-zonlo.

    APPEND INITIAL LINE TO ct_parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-attribute_name  = /scmtms/if_tor_c=>sc_node_attribute-root-created_on.
    <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_between.
    <fs_parameters>-low             = lv_data_ts_inicio.
    <fs_parameters>-high            = lv_data_ts_fim.

  ENDMETHOD.


  METHOD get_status_desc.

    DATA: lt_dd07v       TYPE TABLE OF dd07v.

    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = 'ZD_INT_STATUS'
        text           = abap_true
        langu          = sy-langu
      TABLES
        dd07v_tab      = lt_dd07v
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2.

    IF sy-subrc = 0.
      IF line_exists( lt_dd07v[ domvalue_l = is_status_cod ] ). "#EC CI_STDSEQ
        rv_status_desc = lt_dd07v[ domvalue_l = is_status_cod ]-ddtext. "#EC CI_STDSEQ
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD save_log.

    IF it_messages IS NOT INITIAL.

      DATA(lo_log) = NEW zclca_save_log( iv_object = 'ZTM' ).
      lo_log->create_log( iv_subobject = iv_subobject iv_externalid = iv_externalid ).
      lo_log->add_msgs( it_msg = it_messages ).
      lo_log->save( ).
      COMMIT WORK AND WAIT.

    ENDIF.

  ENDMETHOD.


  METHOD set_status_invoicing.

    " Types
    TYPES : BEGIN OF ty_vbfa,
              vbeln TYPE vbeln,
            END OF ty_vbfa.

    " Tabelas
    DATA: lt_fu_root    TYPE /scmtms/t_tor_root_k,
          lt_tor_root   TYPE /scmtms/t_tor_root_k,
          lt_mod        TYPE /bobf/t_frw_modification,
          lt_parameters TYPE /bobf/t_frw_query_selparam,
          lt_return     TYPE bapiret2_t,
          lt_vbeln      TYPE TABLE OF ty_vbfa.

    " Estrutura
    DATA: ls_mod         TYPE /bobf/s_frw_modification,
          ls_fu_root     TYPE /scmtms/s_tor_root_k,
          ls_fu_root_old TYPE /scmtms/s_tor_root_k,
          ls_vbeln       TYPE ty_vbfa.

    " Constantes
    CONSTANTS: lc_delivery_type TYPE /scmtms/base_btd_tco VALUE '73'.

    " Variaveis
    DATA : lv_delivery TYPE vbeln.

    CHECK is_header IS NOT INITIAL.

    CHECK is_header-code = '100'
       OR is_header-code = '101'
       OR is_header-code = '102'.

    SELECT br_nfsourcedocumentnumber
      FROM i_br_nfitem
      INTO TABLE @DATA(lt_nfitem)
    WHERE br_notafiscal = @is_header-docnum.

    IF sy-subrc IS INITIAL.
      LOOP AT lt_nfitem INTO DATA(ls_nfitem). "#EC CI_LOOP_INTO_WA
        MOVE ls_nfitem-br_nfsourcedocumentnumber TO ls_vbeln-vbeln.

        APPEND ls_vbeln TO lt_vbeln.
      ENDLOOP.

      SELECT *                                                   "#EC CI_SEL_DEL
        FROM i_br_salehistory
        INTO TABLE @DATA(lt_salehistory)
        FOR ALL ENTRIES IN @lt_vbeln
      WHERE subsequentdocument        = @lt_vbeln-vbeln
        AND precedingdocumentcategory = 'J'.

      IF sy-subrc IS INITIAL.
        DELETE ADJACENT DUPLICATES FROM lt_salehistory.

        lv_delivery = lt_salehistory[ 1 ]-precedingdocument.
      ENDIF.
    ENDIF.

*    SELECT SINGLE br_notafiscal,
*                  deliverydocument
*      FROM zi_tm_vh_frete_identify_fo
*      INTO @DATA(ls_nf)
*      WHERE br_notafiscal EQ @is_header-docnum.

*    CHECK sy-subrc = 0 AND ls_nf-deliverydocument IS NOT INITIAL.

    CHECK lv_delivery IS NOT INITIAL.

    TRY.

        CLEAR: lt_parameters[].

        APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
        <fs_parameters>-attribute_name  = /scmtms/if_tor_c=>sc_node_attribute-root-base_btd_id.
        <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_equal.
*        <fs_parameters>-low             = ls_nf-deliverydocument.
        <fs_parameters>-low             = lv_delivery.

        APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameters>.
        <fs_parameters>-attribute_name  = /scmtms/if_tor_c=>sc_node_attribute-root-base_btd_tco.
        <fs_parameters>-sign            = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_parameters>-option          = /bobf/if_conf_c=>sc_sign_equal.
        <fs_parameters>-low             = lc_delivery_type.

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements                 " Query
            it_selection_parameters = lt_parameters                 " Query Selection Parameters
            iv_fill_data            = abap_true       " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_fu_root ).

        CHECK lt_fu_root IS NOT INITIAL.
        ls_fu_root     = lt_fu_root[ 1 ].
        ls_fu_root_old = ls_fu_root.

        CASE is_header-code.
          WHEN '100'. "Aprovado"

            ls_fu_root-zzint_fat_status = gc_codstatus-fat_sucesso.
            ls_fu_root-zzint_fat_desc   = get_status_desc( is_status_cod = gc_codstatus-fat_sucesso ).
            ls_fu_root-zzint_fat_icon   = gc_icons-green.
            ls_fu_root-zzint_fat_data   = sy-datum.
            ls_fu_root-zzint_fat_hora   = sy-uzeit.

          WHEN '101'. "Rejeitado"

            ls_fu_root-zzint_fat_status = gc_codstatus-fat_erro.
            ls_fu_root-zzint_fat_desc   = get_status_desc( is_status_cod = gc_codstatus-fat_erro ).
            ls_fu_root-zzint_fat_icon   = gc_icons-red.
            ls_fu_root-zzint_fat_data   = sy-datum.
            ls_fu_root-zzint_fat_hora   = sy-uzeit.

          WHEN '102'. " Estornada

            ls_fu_root-zzint_fat_status = gc_codstatus-fat_estorno.
            ls_fu_root-zzint_fat_desc   = get_status_desc( is_status_cod = gc_codstatus-fat_estorno ).
            ls_fu_root-zzint_fat_icon   = gc_icons-yellow.
            ls_fu_root-zzint_fat_data   = sy-datum.
            ls_fu_root-zzint_fat_hora   = sy-uzeit.

        ENDCASE.

        /scmtms/cl_mod_helper=>mod_update_chg_fields(
          EXPORTING
            iv_node     = /scmtms/if_tor_c=>sc_node-root                                                                                " Node
            is_data     = ls_fu_root                                                                                                    " New Data
            is_data_old = ls_fu_root_old                                                                                                " Old Data
            iv_bo_key   = /scmtms/if_tor_c=>sc_bo_key                                                                                   " Business Object
          IMPORTING
            es_mod      = ls_mod ).                                                                                                     " Change

        IF ls_mod IS NOT INITIAL.
          APPEND ls_mod TO lt_mod.
        ENDIF.

        IF ls_fu_root-zzint_fat_status NE gc_codstatus-fat_sucesso.

          /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root                                                                  " Node
              it_key                  = CORRESPONDING #( lt_fu_root MAPPING key = key )                                                 " Key Table
              iv_association          = /scmtms/if_tor_c=>sc_association-root-capa_tor                                   " Association
              iv_fill_data            = abap_true                         " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
            IMPORTING
              et_data                 = lt_tor_root ).

          IF lt_tor_root IS NOT INITIAL.
            DATA(ls_tor_root)     = lt_tor_root[ 1 ].
            DATA(ls_tor_root_old) = lt_tor_root[ 1 ].

            " GKO
            ls_tor_root-zzint_gko_status  = gc_codstatus-no_exec.
            ls_tor_root-zzint_gko_desc    = get_status_desc( is_status_cod = gc_codstatus-no_exec ).
            ls_tor_root-zzint_gko_icon    = gc_icons-inactive.
            ls_tor_root-zzint_gko_data    = sy-datum.
            ls_tor_root-zzint_gko_hora    = sy-uzeit.

            " Greenmile
            ls_tor_root-zzint_gm_status   = gc_codstatus-no_exec.
            ls_tor_root-zzint_gm_desc     = get_status_desc( is_status_cod = gc_codstatus-no_exec ).
            ls_tor_root-zzint_gm_icon     = gc_icons-inactive.
            ls_tor_root-zzint_gm_data     = sy-datum.
            ls_tor_root-zzint_gm_hora     = sy-uzeit.

            " Trafegus
            ls_tor_root-zzint_traf_status = gc_codstatus-no_exec.
            ls_tor_root-zzint_traf_desc   = get_status_desc( is_status_cod = gc_codstatus-no_exec ).
            ls_tor_root-zzint_traf_icon   = gc_icons-inactive.
            ls_tor_root-zzint_traf_data   = sy-datum.
            ls_tor_root-zzint_traf_hora   = sy-uzeit.

            /scmtms/cl_mod_helper=>mod_update_chg_fields(
              EXPORTING
                iv_node     = /scmtms/if_tor_c=>sc_node-root                                                                                " Node
                is_data     = ls_tor_root                                                                                                   " New Data
                is_data_old = ls_tor_root_old                                                                                               " Old Data
                iv_bo_key   = /scmtms/if_tor_c=>sc_bo_key                                                                                   " Business Object
              IMPORTING
                es_mod      = ls_mod ).                                                                                                     " Change

            IF ls_mod IS NOT INITIAL.
              APPEND ls_mod TO lt_mod.
            ENDIF.

          ENDIF.
        ENDIF.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    CHECK lt_mod IS NOT INITIAL.

    TRY.

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify( EXPORTING it_modification = lt_mod " Changes
                                                                                                   IMPORTING eo_message      = DATA(lo_message_mod) ).

        /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message = DATA(lo_message_save) ).

      CATCH /bobf/cx_frw_contrct_violation.
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD get_db_tsp_coligada.
    DATA(lt_tspi_id) = CORRESPONDING ty_tt_tspid( it_tor_root MAPPING tsp_id = tspid ).
    SELECT _businesspartner~businesspartner
    FROM i_businesspartner AS _businesspartner
    JOIN @lt_tspi_id AS _tspi_id
    ON _businesspartner~businesspartner = _tspi_id~tsp_id
    AND _businesspartner~businesspartnertype = '0002'
    INTO TABLE @rt_return.
  ENDMETHOD.
ENDCLASS.
