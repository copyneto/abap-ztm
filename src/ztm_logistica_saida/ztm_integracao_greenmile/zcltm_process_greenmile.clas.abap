"!<p><h2>Envio de dados via proxy para o sistema Greenmile</h2></p>
"!<p><strong>Autor: </strong>Guido Olivan</p>
"!<p><strong>Data: </strong>11/02/2022</p>
CLASS zcltm_process_greenmile DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES ziftm_envio_tor_greenmile .

    CONSTANTS:
      gc_centro TYPE c LENGTH 6 VALUE 'CENTRO' ##NO_TEXT.
    CONSTANTS:
      gc_sessao TYPE c LENGTH 10 VALUE 'SESSION_ID' ##NO_TEXT.
    CONSTANTS:
      gc_data   TYPE c LENGTH 4 VALUE 'DATA' ##NO_TEXT.
    CONSTANTS:
      BEGIN OF gc_estrutura,
        principal   TYPE tabname VALUE 'PRINCIPAL',
        stops       TYPE tabname VALUE 'STOPS',
        location    TYPE tabname VALUE 'LOCATION',
        orders      TYPE tabname VALUE 'ORDERS',
        line_items  TYPE tabname VALUE 'LINE_ITEMS',
        equipamento TYPE tabname VALUE 'EQUIPAMENTO',
        motorista   TYPE tabname VALUE 'MOTORISTA',
        transporte  TYPE tabname VALUE 'TRANSPORTE',
        destination TYPE tabname VALUE 'DESTINATION',
        origin      TYPE tabname VALUE 'ORIGIN',
      END OF gc_estrutura .

    "!Tabela com os dados no nó raiz das ordens de frete
    DATA gt_tor_fo TYPE /scmtms/t_tor_root_k .

    "! Procurar por ordem de frete
    "! @parameter is_dados | Dados do filtro
    "! @parameter iv_tor_key | Chave da ordem de frete
    "! @parameter rt_tor_fo | Dados do nó raíz
    CLASS-METHODS busca_fo
      IMPORTING
        !is_dados        TYPE ztms_input_rodnet OPTIONAL
        !iv_tor_key      TYPE /bobf/conf_key
      RETURNING
        VALUE(rt_tor_fo) TYPE /scmtms/t_tor_root_k .
    CLASS-METHODS valida_campos
      IMPORTING
        !is_output  TYPE zcltm_mt_ordem_de_frete
      EXPORTING
        !et_return  TYPE bapiret2_t
        !et_message TYPE /scmtms/t_symsg .
    "! Buscar unidade de frete
    "! @parameter iv_remessa | Número da remessa
    "! @parameter rt_tor_fu | Tabela com as unidades de frete correspondente
    CLASS-METHODS busca_fu
      IMPORTING
        !iv_remessa      TYPE /scmtms/base_btd_id
      RETURNING
        VALUE(rt_tor_fu) TYPE /scmtms/t_tor_root_k .
    CLASS-METHODS busca_dados_envio
      IMPORTING
        !it_tor_fo       TYPE /scmtms/t_tor_root_k
      EXPORTING
        !et_return       TYPE bapiret2_t
      RETURNING
        VALUE(rt_output) TYPE zcltm_mt_ordem_de_frete .
    CLASS-METHODS valida_estrutura_greenmile
      IMPORTING
        !is_data      TYPE any
        !iv_estrutura TYPE tabname OPTIONAL
      CHANGING
        !ct_return    TYPE bapiret2_t .
    CLASS-METHODS valida_tabela_greenmile
      IMPORTING
        !it_data   TYPE ANY TABLE
      CHANGING
        !ct_return TYPE bapiret2_t .
    CLASS-METHODS exibe_msg_validacao
      IMPORTING
        !it_return_valida TYPE bapiret2_t .
    CLASS-METHODS busca_campos_validacao
      IMPORTING
        !iv_estrutura    TYPE tabname
      RETURNING
        VALUE(rt_return) TYPE /smb/tr_field .
ENDCLASS.



CLASS ZCLTM_PROCESS_GREENMILE IMPLEMENTATION.


  METHOD busca_fu.



    DATA:
      lo_srv_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor       TYPE REF TO /bobf/if_tra_transaction_mgr,

      lt_tor_root_data TYPE /scmtms/t_tor_root_k,
      lt_tor_root_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_data TYPE /scmtms/t_tor_docref_k,
      lt_return        TYPE bapiret2_tab.


    DATA:
      lt_parameters TYPE /bobf/t_frw_query_selparam,
      ls_parameter  TYPE /bobf/s_frw_query_selparam.


    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.


    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    CLEAR ls_parameter.
    ls_parameter-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-docreference-btd_id.

    CHECK iv_remessa IS NOT INITIAL.

    ls_parameter-sign   = lc_sign_i.
    ls_parameter-option = lc_option_eq.
    ls_parameter-low    = iv_remessa.
    APPEND ls_parameter TO lt_parameters.


* Busca referencias (FU) a partir da remessa
    IF lt_parameters IS NOT INITIAL.

      lo_srv_tor->query(
        EXPORTING
          iv_query_key            = /scmtms/if_tor_c=>sc_query-docreference-docreference_elements
          it_selection_parameters = lt_parameters
          iv_fill_data            = abap_true
        IMPORTING
          et_key                  = lt_tor_refe_key
          et_data                 = lt_tor_refe_data ).

    ENDIF.

    LOOP AT lt_tor_refe_data ASSIGNING FIELD-SYMBOL(<fs_refe_data>).
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_refe_data>-root_key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.


*   Busca dados das FUs
    lo_srv_tor->retrieve(
    EXPORTING
        it_key        = lt_tor_root_key
        iv_node_key   = /scmtms/if_tor_c=>sc_node-root
    IMPORTING
        et_data       = lt_tor_root_data
    ).


*   Considerar somente FU
    DELETE lt_tor_root_data WHERE tor_cat <> 'FU'.      "#EC CI_SORTSEQ
    "Não é possível utilizar usando chave pois a condição é "diferente"

    CHECK lt_tor_root_data IS NOT INITIAL.

    rt_tor_fu = lt_tor_root_data.

  ENDMETHOD.


  METHOD ziftm_envio_tor_greenmile~enviar_tor.

    DATA:
      ls_output   TYPE zcltm_mt_ordem_de_frete.

    TRY.
        CLEAR: ev_exec.

        DATA(lo_envia_fo) = NEW zcltm_co_si_enviar_ordem_de_fr( ).

        DATA(lt_tor_fo) = me->busca_fo( iv_tor_key = iv_tor_key ).

        IF lt_tor_fo IS INITIAL.
          ev_exec = abap_true.
          RETURN.
        ENDIF.

        ls_output = busca_dados_envio( lt_tor_fo ).

**------------------ Inicio - VARAUJO - 09.02.2023 ----------------------
** ----------------------------------------------------------------------
** Validação de campos
** ----------------------------------------------------------------------
        valida_campos( EXPORTING is_output  = ls_output
                       IMPORTING et_message = et_messages ).
**-------------------- Fim - VARAUJO - 09.02.2023 -----------------------

        IF et_messages IS INITIAL.
          lo_envia_fo->si_enviar_ordem_de_frete_out( ls_output ).
        ENDIF.

      CATCH cx_ai_system_fault.
      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.


  METHOD busca_fo.

    DATA:
      lo_srv_tor       TYPE REF TO /bobf/if_tra_service_manager,
      lo_tra_tor       TYPE REF TO /bobf/if_tra_transaction_mgr,

      lt_tor_root_data TYPE /scmtms/t_tor_root_k,
      lt_tor_root_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_key  TYPE /bobf/t_frw_key,
      lt_tor_refe_data TYPE /scmtms/t_tor_docref_k,
      lt_return        TYPE bapiret2_tab.


    DATA:
      lt_parameters TYPE /bobf/t_frw_query_selparam,
      ls_parameter  TYPE /bobf/s_frw_query_selparam.

*    DATA:
*      lv_zcondexp   TYPE /scmtms/s_tor_root_k-zz1_cond_exped.

    DATA:
      lr_zcondexp  TYPE RANGE OF /scmtms/s_tor_root_k-zz1_cond_exped.

    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
*        lo_param->m_get_single( EXPORTING iv_modulo = 'TM'
*                                          iv_chave1 = 'COND_EXPED_GREENMILE'
**                                          iv_chave2 = lv_chave2
*                                IMPORTING ev_param  = lv_zcondexp ).

        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
                                         iv_chave1 = 'COND_EXPED_GREENMILE'
                               IMPORTING et_range  = lr_zcondexp ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

*    CLEAR ls_parameter.
*    ls_parameter-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-execution.
*
*    ls_parameter-sign   = lc_sign_i.
*    ls_parameter-option = lc_option_eq.
*    ls_parameter-low    = '07'.
*    APPEND ls_parameter TO lt_parameters.
*
*    CLEAR ls_parameter.
*    ls_parameter-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-blk_exec.
*
*    ls_parameter-sign   = lc_sign_i.
*    ls_parameter-option = lc_option_eq.
*    ls_parameter-low    = space.
*    APPEND ls_parameter TO lt_parameters.
*
*
*
** Busca referencias (FU) a partir da remessa
*    IF lt_parameters IS NOT INITIAL.
*
*      lo_srv_tor->query(
*        EXPORTING
*          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
*          it_selection_parameters = lt_parameters
*          iv_fill_data            = abap_true
*        IMPORTING
*          et_key                  = lt_tor_root_key
*          et_data                 = lt_tor_root_data ).
*
*    ENDIF.

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_tor_key CHANGING ct_key = lt_tor_root_key ).

*   Busca dados das FO
    lo_srv_tor->retrieve( EXPORTING it_key        = lt_tor_root_key
                                    iv_node_key   = /scmtms/if_tor_c=>sc_node-root
                          IMPORTING et_data       = lt_tor_root_data ).

*   Considerar somente FU
    DELETE lt_tor_root_data WHERE tor_cat <> 'TO'.                   "#EC CI_SORTSEQ
    "Não é possível utilizar usando chave pois a condição é "diferente"

    CHECK lt_tor_root_data IS NOT INITIAL.

    " Excluir FOs que tenham o campos ZZ1_COND_EXPED fora do range
    DELETE lt_tor_root_data WHERE zz1_cond_exped NOT IN lr_zcondexp. "#EC CI_SORTSEQ
    CHECK lt_tor_root_data IS NOT INITIAL.

    rt_tor_fo = lt_tor_root_data.

  ENDMETHOD.


  METHOD busca_dados_envio.

    TYPES:
      BEGIN OF ty_orders,
        loc_id TYPE string,
        orders TYPE zcltm_dt_ordem_de_frete_orders,
      END OF ty_orders,

      BEGIN OF ty_geo,
        businesspartner        TYPE i_bupaidentificationtp-businesspartner,
        bpidentificationtype   TYPE i_bupaidentificationtp-bpidentificationtype,
        bpidentificationnumber TYPE i_bupaidentificationtp-bpidentificationnumber,
      END OF ty_geo,

      BEGIN OF ty_loclog_id,
        seq       TYPE num,
        loclog_id TYPE /scmtms/location_id,
        loctype   TYPE /sapapo/c_loctype,
        partner   TYPE bu_partner,
      END OF ty_loclog_id.

    DATA:
      lt_tor_root_key   TYPE /bobf/t_frw_key,
      lt_stops_key      TYPE /bobf/t_frw_key,
      lt_link_fo        TYPE /bobf/t_frw_key_link,
      lt_link_stop_fu   TYPE /bobf/t_frw_key_link,
      lt_assigned_fus   TYPE /scmtms/t_tor_root_k,
      ls_assigned_fus   TYPE /scmtms/s_tor_root_k,
      ls_tor_root       TYPE /scmtms/s_tor_root_k,
      lt_item_tr        TYPE /scmtms/t_tor_item_tr_k,
      ls_item_tr        TYPE /scmtms/s_tor_item_tr_k,
      ls_tor_stop       TYPE /scmtms/s_tor_stop_k,
      lt_tor_stop       TYPE /scmtms/t_tor_stop_k,
      lt_tor_stop_aux   TYPE TABLE OF /scmtms/s_tor_stop_k,
      ls_stop_prev      TYPE /scmtms/s_tor_stop_k,
      lt_stop_prev      TYPE /scmtms/t_tor_stop_k,
      ls_stop_next      TYPE /scmtms/s_tor_stop_k,
      lt_stop_next      TYPE /scmtms/t_tor_stop_k,
      lt_link_prev_stop TYPE /bobf/t_frw_key_link,
      ls_link_prev_stop TYPE /bobf/s_frw_key_link,
      lt_link_next_stop TYPE /bobf/t_frw_key_link,
      ls_link_next_stop TYPE /bobf/s_frw_key_link,
      lt_stop_loc_log   TYPE /scmtms/t_bo_loc_root_k,
      lt_tor_bupa_root  TYPE /bofu/t_bupa_root_k,
      lt_tor_stop_succ  TYPE /scmtms/t_tor_stop_succ_k,
      lt_bupa_shp_root  TYPE /bofu/t_bupa_root_k,
      lt_bo_common      TYPE /bofu/t_bupa_common_k,
      lt_return         TYPE bapiret2_tab,
      lt_tor_party      TYPE /scmtms/t_tor_party_k,
      lt_tor_summary    TYPE /scmtms/t_tor_root_transient_k,
      lt_remessas       TYPE  vbeln_vl_t,
      lt_faturas        TYPE TABLE OF /xeit/wgte_nfe_data,
      lt_consigneeid    TYPE rpm_tt_bupa,
      lt_log_locid      TYPE TABLE OF ty_loclog_id,
      ls_lat            TYPE ty_geo,
      ls_long           TYPE ty_geo,
      ls_stops          TYPE zcltm_dt_ordem_de_frete_stops,
      lt_stops          TYPE TABLE OF zcltm_dt_ordem_de_frete_stops,
      ls_orders         TYPE zcltm_dt_ordem_de_frete_orders,
      lt_orders         TYPE TABLE OF ty_orders,
      ls_orders_aux     TYPE ty_orders,
      lt_equipamento    TYPE zcltm_dt_ordem_de_frete_eq_tab,
      lt_return_valida  TYPE bapiret2_t,
      ls_equipamento    TYPE zcltm_dt_ordem_de_frete_equipa,
      lt_location       TYPE zcltm_dt_ordem_de_frete_lo_tab,
      ls_location       TYPE zcltm_dt_ordem_de_frete_locati,
      ls_motorista      TYPE zcltm_dt_ordem_de_frete_motori,
      ls_transporte     TYPE zcltm_dt_ordem_de_frete_transp,
      ls_items          TYPE zcltm_dt_ordem_de_frete_line_i,
      lt_equnr          TYPE equnr_tab,
      ls_equnr          LIKE LINE OF lt_equnr,
      lt_produto        TYPE matnr_tty,
      lv_remessa        TYPE likp-vbeln,
      lv_consigneeid    TYPE bu_partner,
      ls_log_locid      TYPE ty_loclog_id,
      lt_locno_range    TYPE RANGE OF /sapapo/locno,
      ls_locno_range    LIKE LINE OF lt_locno_range,
      lv_amt_gdsv_val   TYPE /scmtms/amt_goodsvalue_val,
      lv_select_clause  TYPE string,
      lv_matnr          TYPE matnr.

    CONSTANTS: lc_coligadas TYPE bu_bpkind VALUE '0002'.

    CHECK it_tor_fo IS NOT INITIAL.
    CLEAR ls_tor_root.

    DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_tor_fo INTO ls_tor_root.
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = ls_tor_root-key CHANGING ct_key = lt_tor_root_key ).
    ENDLOOP.

    CALL METHOD /scmtms/cl_tor_helper_read=>get_tor_data
      EXPORTING
        it_root_key  = lt_tor_root_key
      IMPORTING
        et_stop      = lt_tor_stop
        et_stop_succ = lt_tor_stop_succ
        et_party     = lt_tor_party
        et_all_items = lt_item_tr.

    lo_srv_tor->retrieve_by_association(
          EXPORTING
              it_key         = lt_tor_root_key
              iv_node_key    = /scmtms/if_tor_c=>sc_node-root
              iv_association = /scmtms/if_tor_c=>sc_association-root-stop
              iv_fill_data   = abap_true
          IMPORTING
              et_data       = lt_tor_stop
              et_target_key = lt_stops_key ).

    lo_srv_tor->retrieve_by_association(
          EXPORTING
              it_key         = lt_stops_key
              iv_node_key    = /scmtms/if_tor_c=>sc_node-stop
              iv_association = /scmtms/if_tor_c=>sc_association-stop-stop_nextstop
              iv_fill_data   = abap_true
          IMPORTING
              et_data       = lt_stop_next
              et_key_link   = lt_link_next_stop ).

    lo_srv_tor->retrieve_by_association(
          EXPORTING
              it_key         = lt_stops_key
              iv_node_key    = /scmtms/if_tor_c=>sc_node-stop
              iv_association = /scmtms/if_tor_c=>sc_association-stop-stop_prevstop
              iv_fill_data   = abap_true
          IMPORTING
              et_data       = lt_stop_prev
              et_key_link   = lt_link_prev_stop ).

    lo_srv_tor->retrieve_by_association(
          EXPORTING
              it_key         = lt_tor_root_key
              iv_node_key    = /scmtms/if_tor_c=>sc_node-stop
              iv_association = /scmtms/if_tor_c=>sc_association-stop-bo_loc_log
              iv_fill_data   = abap_true
          IMPORTING
               et_data       = lt_stop_loc_log ).

    lo_srv_tor->retrieve_by_association(
    EXPORTING
        it_key         = lt_tor_root_key
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-summary
        iv_fill_data   = abap_true
    IMPORTING
         et_data     = lt_tor_summary ).

    lo_srv_tor->retrieve_by_association(
      EXPORTING
        it_key         = lt_tor_root_key
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
        iv_fill_data   = abap_true
      IMPORTING
          et_data     = lt_assigned_fus ).

    lo_srv_tor->retrieve_by_association(
  EXPORTING
    it_key         = lt_tor_root_key
    iv_node_key    = /scmtms/if_tor_c=>sc_node-root
    iv_association = /scmtms/if_tor_c=>sc_association-root-bupa_ship_root
    iv_fill_data   = abap_true
  IMPORTING
      et_data     = lt_bupa_shp_root ).

*-> Adicionar tabelas de Remessas e BPs
    LOOP AT lt_assigned_fus INTO ls_assigned_fus.
      lv_remessa = ls_assigned_fus-base_btd_id+25.
      APPEND lv_remessa TO lt_remessas.
      lv_consigneeid = ls_assigned_fus-consigneeid.
      APPEND lv_consigneeid TO lt_consigneeid.
    ENDLOOP.

*-> Ler dados das remessas e notas fiscais
    IF lt_remessas IS NOT INITIAL.

      SELECT
        vbeln,
        lfart
        INTO TABLE @DATA(lt_likp)
        FROM likp
        FOR ALL ENTRIES IN @lt_remessas
        WHERE vbeln = @lt_remessas-table_line.
      IF lt_likp IS NOT INITIAL.

        SELECT vbeln,
               posnr,
               werks
          INTO TABLE @DATA(lt_lips)
          FROM lips
          FOR ALL ENTRIES IN @lt_remessas
          WHERE vbeln = @lt_remessas-table_line.

        SELECT
          vbelv,
          vbtyp_v,
          a~vbeln,
          vbtyp_n,
          b~vbeln AS vbeln_vf,
          zlsch
          INTO TABLE @DATA(lt_vbfa)
          FROM vbfa AS a
          INNER JOIN vbrk AS b
          ON b~vbeln = a~vbeln
          FOR ALL ENTRIES IN @lt_remessas
          WHERE vbelv   = @lt_remessas-table_line
            AND vbtyp_v = 'J'
            AND vbtyp_n = 'M'
            AND fksto = @space.

        IF sy-subrc IS INITIAL.
          LOOP AT lt_vbfa ASSIGNING FIELD-SYMBOL(<fs_vbrk>).

            DATA(ls_faturas) = VALUE /xeit/wgte_nfe_data( refkey = <fs_vbrk>-vbeln_vf ).
            APPEND ls_faturas TO lt_faturas.

          ENDLOOP.
          IF lt_faturas IS NOT INITIAL.

            SELECT
              a~docnum,
              itmnum,
              matnr,
              reftyp,
              refkey,
              refitm,
              b~nfenum,
              b~series,
              b~nftot
              INTO TABLE @DATA(lt_lin)
              FROM j_1bnflin AS a
              INNER JOIN j_1bnfdoc AS b
              ON b~docnum = a~docnum
              FOR ALL ENTRIES IN @lt_faturas
              WHERE refkey = @lt_faturas-refkey.

            IF sy-subrc = 0.
              SORT lt_lin BY docnum.
              SELECT *
                FROM j_1bnfstx
                INTO TABLE @DATA(lt_stx)
                FOR ALL ENTRIES IN @lt_lin
                WHERE docnum = @lt_lin-docnum. "#EC CI_ALL_FIELDS_NEEDED
            ENDIF.

            IF lt_vbfa IS NOT INITIAL.

              SELECT
                zlsch,
                text1
                INTO TABLE @DATA(lt_t042z)
                FROM t042z
                FOR ALL ENTRIES IN @lt_vbfa
                WHERE zlsch = @lt_vbfa-zlsch
                  AND land1 = 'BR'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*    IF lt_consigneeid IS NOT INITIAL.
*      SELECT
*        FROM i_businesspartneraddress
*        FIELDS businesspartner, streetname, fullname, housenumber, cityname, region, postalcode, country, district
*        FOR ALL ENTRIES IN @lt_consigneeid
*        WHERE businesspartner = @lt_consigneeid-table_line
*        INTO TABLE @DATA(lt_partneraddr).
*
*      SELECT
*        FROM i_customer
*        FIELDS customer, taxnumber1, taxnumber2
*        FOR ALL ENTRIES IN @lt_consigneeid
*        WHERE customer = @lt_consigneeid-table_line
*        INTO TABLE @DATA(lt_partnercust).
*    ENDIF.

*-> Adicionar tabelas de equipamento e produtos
    LOOP AT lt_item_tr INTO ls_item_tr.
      IF ls_item_tr-item_cat EQ 'AVR' OR ls_item_tr-item_cat EQ 'PVR'.
        APPEND ls_item_tr-platenumber TO lt_equnr.
      ELSEIF ls_item_tr-item_cat EQ 'PRD'.
        APPEND ls_item_tr-product_id TO lt_produto.
      ENDIF.
    ENDLOOP.
    CLEAR ls_item_tr.

*-> Ler dados do material
    IF lt_produto IS NOT INITIAL.
      SELECT matnr, brand_id INTO TABLE @DATA(lt_mara)
        FROM mara
        FOR ALL ENTRIES IN @lt_produto
        WHERE matnr = @lt_produto-table_line.
    ENDIF.

*-> Ler dados do equipamento
    IF lt_equnr IS NOT INITIAL.
      SELECT * INTO TABLE @DATA(lt_equipment)
        FROM i_equipment
        FOR ALL ENTRIES IN @lt_equnr
        WHERE equipment = @lt_equnr-table_line. "#EC CI_ALL_FIELDS_NEEDED
    ENDIF.

*-> Preparar tabela de location
    lt_tor_stop_aux = lt_tor_stop[].
    SORT lt_tor_stop_aux BY plan_trans_time ASCENDING.

    DATA(lt_log_locid_sel) = VALUE /sapapo/locno_tab( FOR <fs_locid_sel> IN lt_tor_stop_aux
                                                    ( <fs_locid_sel>-log_locid ) ).

    SELECT loctype,
           locno,
           partner_guid
      FROM /sapapo/loc
      INTO TABLE @DATA(lt_loc)
      FOR ALL ENTRIES IN @lt_log_locid_sel
      WHERE locno EQ @lt_log_locid_sel-table_line.

    IF sy-subrc = 0.

      SELECT partner,
             partner_guid
        FROM but000
        INTO TABLE @DATA(lt_but000)
        FOR ALL ENTRIES IN @lt_loc
        WHERE partner_guid EQ @lt_loc-partner_guid. "#EC CI_NO_TRANSFORM "#EC CI_FAE_LINES_ENSURED

      LOOP AT lt_tor_stop_aux INTO ls_tor_stop.
        CLEAR ls_log_locid-loclog_id.

        ls_log_locid-loclog_id = ls_tor_stop-log_locid.
        ls_log_locid-seq       = ls_log_locid-seq + 1.

        IF line_exists( lt_loc[ locno = ls_log_locid-loclog_id ] ).
          ls_log_locid-loctype = lt_loc[ locno = ls_log_locid-loclog_id ]-loctype.

          IF line_exists( lt_but000[ partner_guid = lt_loc[ locno = ls_log_locid-loclog_id ]-partner_guid ] ).
            ls_log_locid-partner = lt_but000[ partner_guid = lt_loc[ locno = ls_log_locid-loclog_id ]-partner_guid ]-partner.
          ENDIF.
        ENDIF.

        APPEND ls_log_locid TO lt_log_locid.
      ENDLOOP.
    ENDIF.

*    LOOP AT lt_tor_stop_aux INTO ls_tor_stop.
*      CLEAR ls_log_locid-loclog_id.
*
*      ls_log_locid-loclog_id = ls_tor_stop-log_locid.
*      ls_log_locid-seq       = ls_log_locid-seq + 1.
*
*      IF line_exists( lt_loc[ locno = ls_log_locid-loclog_id ] ).
*        ls_log_locid-loctype = lt_loc[ locno = ls_log_locid-loclog_id ]-loctype.
*      ENDIF.
*
*      APPEND ls_log_locid TO lt_log_locid.
*    ENDLOOP.

    SORT lt_log_locid BY loclog_id.
    DELETE ADJACENT DUPLICATES FROM lt_log_locid COMPARING loclog_id.

    IF ( ls_tor_root-zz1_cond_exped EQ '04' OR
          ls_tor_root-zz1_cond_exped EQ '17' ).
*      DELETE lt_log_locid WHERE table_line CS 'SP_'.
      DELETE lt_log_locid WHERE loctype = '1003'.
    ELSE.
*      DELETE lt_log_locid WHERE table_line CS 'SP_'
*                             OR table_line CS 'TP_'.
      DELETE lt_log_locid WHERE loctype = '1003'
                             OR loctype = '1170'.
    ENDIF.

*    DATA(lt_log_locid_sel) = VALUE /sapapo/locno_tab( FOR <fs_locid_sel> IN lt_log_locid
*                                                    ( <fs_locid_sel>-loclog_id ) ).
*
*    SELECT locno,
*           partner_guid
*      FROM /sapapo/loc
*      INTO TABLE @DATA(lt_loc)
*      FOR ALL ENTRIES IN @lt_log_locid_sel
*      WHERE locno EQ @lt_log_locid_sel-table_line.

*    IF sy-subrc = 0.
*    IF lt_loc IS NOT INITIAL.
*
*      SELECT partner,
*             partner_guid
*        FROM but000
*        INTO TABLE @DATA(lt_but000)
*        FOR ALL ENTRIES IN @lt_loc
*        WHERE partner_guid EQ @lt_loc-partner_guid. "#EC CI_NO_TRANSFORM "#EC CI_FAE_LINES_ENSURED
*
*      LOOP AT lt_log_locid ASSIGNING FIELD-SYMBOL(<fs_locid>).
*        IF line_exists( lt_loc[ locno = <fs_locid>-loclog_id ] ).
*          IF line_exists( lt_but000[ partner_guid = lt_loc[ locno = <fs_locid>-loclog_id ]-partner_guid ] ).
*            <fs_locid>-partner = lt_but000[ partner_guid = lt_loc[ locno = <fs_locid>-loclog_id ]-partner_guid ]-partner.
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.

    IF lt_log_locid IS NOT INITIAL.
      SELECT
        FROM i_businesspartneraddress
        FIELDS businesspartner, streetname, fullname, housenumber, cityname, region, postalcode, country, district
        FOR ALL ENTRIES IN @lt_log_locid
        WHERE businesspartner = @lt_log_locid-partner
        INTO TABLE @DATA(lt_partneraddr).

*      SELECT
*        FROM i_customer
*        FIELDS customer, taxnumber1, taxnumber2
*        FOR ALL ENTRIES IN @lt_log_locid
*        WHERE customer = @lt_log_locid-partner
*        INTO TABLE @DATA(lt_partnercust).

      SELECT
        FROM dfkkbptaxnum
        FIELDS partner, taxtype, taxnum
        FOR ALL ENTRIES IN @lt_log_locid
        WHERE partner = @lt_log_locid-partner
        INTO TABLE @DATA(lt_partnercust).
    ENDIF.

*-> Busca dados de geolocalização da Location
    SELECT businesspartner,
       bpidentificationtype,
       bpidentificationnumber
    FROM i_bupaidentificationtp
  INTO TABLE @DATA(lt_geo_coord)
     FOR ALL ENTRIES IN @lt_log_locid
   WHERE businesspartner = @lt_log_locid-partner
*   WHERE businesspartner = @lt_log_locid-loclog_id
     AND ( bpidentificationtype = 'ZLATIT'
     OR bpidentificationtype = 'ZLONGI' ). "#EC CI_NO_TRANSFORM "#EC CI_FAE_LINES_ENSURED

*-> Busca dado de Geolocalização da Origem e Destino
    SELECT businesspartner,
       bpidentificationtype,
       bpidentificationnumber
    FROM i_bupaidentificationtp
  INTO TABLE @DATA(lt_geo_coord_origin)
     FOR ALL ENTRIES IN @lt_bupa_shp_root
   WHERE businesspartner = @lt_bupa_shp_root-partner
     AND ( bpidentificationtype = 'ZLATIT'
     OR bpidentificationtype = 'ZLONGI' ).    "#EC CI_FAE_LINES_ENSURED

*-> TOR_ID
    rt_output-mt_ordem_de_frete-tor_id                = ls_tor_root-tor_id.
    SHIFT rt_output-mt_ordem_de_frete-tor_id LEFT DELETING LEADING '0'.
*-> Checa se é transporte 3 corações.
    IF ls_tor_root-tspid IS NOT INITIAL.
      SELECT SINGLE bpkind
        FROM but000
        INTO @DATA(lv_bpkind)
        WHERE partner = @ls_tor_root-tspid.
    ENDIF.


*-> DATA
    rt_output-mt_ordem_de_frete-data                  = lt_tor_summary[ 1 ]-first_stop_aggr_assgn_start_l.
*-> FIRST_LOG_LOCID
    rt_output-mt_ordem_de_frete-first_log_locid       = lt_tor_stop[ stop_seq_pos = 'F' ]-log_locid.
*-> LAST_LOG_LOCID
    rt_output-mt_ordem_de_frete-last_log_locid        = lt_tor_stop[ stop_seq_pos = 'L' ]-log_locid.
*-> LASTSTOPISDESTINATION
    rt_output-mt_ordem_de_frete-laststopisdestination = abap_true.
*-> CITY
    ls_locno_range-sign   = 'I'.
    ls_locno_range-option = 'EQ'.
    ls_locno_range-low    = rt_output-mt_ordem_de_frete-first_log_locid.

    APPEND ls_locno_range TO lt_locno_range.

    CALL METHOD /scmtms/cl_loc_helper=>get_locations_by_locno
      EXPORTING
        it_locno_range = lt_locno_range
      IMPORTING
        et_locations   = DATA(lt_et_locations).
    READ TABLE lt_et_locations INTO DATA(ls_et_locations) INDEX 1.

    IF sy-subrc EQ 0.
      rt_output-mt_ordem_de_frete-city = ls_et_locations-city.
    ENDIF.

*    DATA(lv_len) = strlen( rt_output-mt_ordem_de_frete-first_log_locid ) - 4.
*    IF lv_len > 0 .
*      rt_output-mt_ordem_de_frete-centro = rt_output-mt_ordem_de_frete-first_log_locid+lv_len(4).
*    ELSE.
*      rt_output-mt_ordem_de_frete-centro    = ls_tor_root-purch_company_code.
*    ENDIF.
    IF lt_lips IS NOT INITIAL.
      rt_output-mt_ordem_de_frete-centro    = lt_lips[ 1 ]-werks.
    ENDIF.

*-> FIRST_STOP_AGGR_ASSGN_START_L
    rt_output-mt_ordem_de_frete-first_stop_aggr_assgn_start_l = lt_tor_stop[ stop_seq_pos = 'F' ]-plan_trans_time.
*-> FIRST_STOP_AGGR_ASSGN_END_L
    rt_output-mt_ordem_de_frete-first_stop_aggr_assgn_end_l   = lt_tor_stop[ stop_seq_pos = 'F' ]-plan_trans_time.
*-> LAST_STOP_AGGR_ASSGN_START_L
    rt_output-mt_ordem_de_frete-last_stop_aggr_assgn_start_l  = lt_tor_stop[ stop_seq_pos = 'L' ]-plan_trans_time.
*-> LAST_STOP_AGGR_ASSGN_END_L
    rt_output-mt_ordem_de_frete-last_stop_aggr_assgn_end_l    = lt_tor_stop[ stop_seq_pos = 'L' ]-plan_trans_time.
*-> TOT_DISTANCE_KM
    rt_output-mt_ordem_de_frete-tot_distance_km               = lt_tor_summary[ 1 ]-tot_distance_km * 1000.
*-> TOT_DURATION
    rt_output-mt_ordem_de_frete-tot_duration                  = lt_tor_summary[ 1 ]-tot_duration.
*-> LABELTXT - Descrição da ROTA
    rt_output-mt_ordem_de_frete-labeltxt                      = ls_tor_root-labeltxt.




*-> Dados do motorista
    IF lv_bpkind EQ lc_coligadas.
      ls_motorista-party_id   = lt_tor_party[ party_rco = 'YM' ]-party_id.
      ls_motorista-login     = lt_tor_party[ party_rco = 'YM' ]-party_id.
      ls_motorista-password  = lt_tor_party[ party_rco = 'YM' ]-party_id+4(6).

      SELECT SINGLE lifnr, name1, name2
              FROM lfa1
              INTO @DATA(ls_lfa1)
              WHERE lifnr = @ls_motorista-party_id.

      IF sy-subrc = 0.
        ls_motorista-drivername = ls_lfa1-name1.
      ENDIF.

      APPEND ls_motorista TO rt_output-mt_ordem_de_frete-motorista .
      CLEAR ls_motorista.
    ELSE.
      ls_motorista-party_id   = ls_tor_root-tspid.
      ls_motorista-login     = ls_tor_root-tspid.
      ls_motorista-password  = ls_tor_root-tspid+4(6).
      SELECT SINGLE fullname
        INTO @ls_motorista-drivername
        FROM i_businesspartneraddress
        WHERE businesspartner = @ls_tor_root-tspid.
      APPEND ls_motorista TO rt_output-mt_ordem_de_frete-motorista .
      CLEAR ls_motorista.
    ENDIF.

*-> Dados de Destino
    CLEAR: ls_lat, ls_long.
    rt_output-mt_ordem_de_frete-destination-key             = rt_output-mt_ordem_de_frete-first_log_locid.
    READ TABLE lt_geo_coord_origin INTO ls_lat WITH KEY bpidentificationtype = 'ZLATIT'.
    IF sy-subrc IS INITIAL.
      rt_output-mt_ordem_de_frete-destination-latitude_value  = ls_lat-bpidentificationnumber.
    ELSE.
      rt_output-mt_ordem_de_frete-destination-latitude_value  = '0.0'.
    ENDIF.

    READ TABLE lt_geo_coord_origin INTO ls_long WITH KEY bpidentificationtype = 'ZLONGI'.
    IF sy-subrc IS INITIAL.
      rt_output-mt_ordem_de_frete-destination-longitude_value = ls_long-bpidentificationnumber.
    ELSE.
      rt_output-mt_ordem_de_frete-destination-longitude_value = '0.0'.
    ENDIF.

*-> Dados de Origem
    rt_output-mt_ordem_de_frete-origin-key             = rt_output-mt_ordem_de_frete-last_log_locid.
    READ TABLE lt_geo_coord_origin INTO ls_lat WITH KEY bpidentificationtype = 'ZLATIT'.
    IF sy-subrc IS INITIAL.
      rt_output-mt_ordem_de_frete-origin-latitude_value  = ls_lat-bpidentificationnumber.
    ELSE.
      rt_output-mt_ordem_de_frete-origin-latitude_value  = '0.0'.
    ENDIF.

    READ TABLE lt_geo_coord_origin INTO ls_long WITH KEY bpidentificationtype = 'ZLONGI'.
    IF sy-subrc IS INITIAL.
      rt_output-mt_ordem_de_frete-origin-longitude_value = ls_long-bpidentificationnumber.
    ELSE.
      rt_output-mt_ordem_de_frete-origin-longitude_value = '0.0'.
    ENDIF.

    DATA(lt_equnr_sel) = VALUE equnr_tab( FOR <fs_equnr> IN lt_item_tr
                                  WHERE ( item_cat EQ /scmtms/if_tor_const=>sc_tor_item_category-av_item OR
                                          item_cat EQ /scmtms/if_tor_const=>sc_tor_item_category-pv_item )
                                        ( CONV equnr( <fs_equnr>-platenumber ) ) ).

    IF lt_equnr_sel IS NOT INITIAL.

      SELECT equnr,
             swerk
        FROM itob
        INTO TABLE @DATA(lt_itob)
        FOR ALL ENTRIES IN @lt_equnr_sel
        WHERE equnr EQ @lt_equnr_sel-table_line.

    ENDIF.

*-> EQUIPAMENTO
    LOOP AT lt_item_tr INTO ls_item_tr WHERE ( item_cat EQ 'AVR' OR item_cat EQ 'PVR' ).
      ls_equipamento-equipment = ls_item_tr-platenumber.

      SELECT SINGLE eqktx
        INTO @DATA(lv_equip_descript)
        FROM eqkt  WHERE  equnr EQ @ls_equipamento-equipment
        AND spras EQ 'P'.

      IF sy-subrc IS INITIAL.
        ls_equipamento-equipment_name = lv_equip_descript.
*          ELSE
*             ls_equipamento-equipment_name = 'Equipamento sem descrição'.
      ENDIF.

      IF line_exists( lt_itob[ equnr = ls_equipamento-equipment ] ).
        ls_equipamento-werk = lt_itob[ equnr = ls_equipamento-equipment ]-swerk.
      ENDIF.

*      IF lt_lips IS NOT INITIAL.
*        ls_equipamento-werk = lt_lips[ 1 ]-werks.
*      ENDIF.
*      ls_equipamento-werk           = ls_tor_root-purch_company_code.
      TRY.
          ls_equipamento-vehicletype    = lt_equipment[ equipment = ls_equipamento-equipment ]-technicalobjecttype.
        CATCH cx_root.
      ENDTRY.

      ls_equipamento-gro_wei_valcap = ls_item_tr-gro_wei_valcap.
      ls_equipamento-heightcam      = ls_item_tr-heightcam.
      ls_equipamento-gro_vol_valcap = ls_item_tr-gro_vol_valcap.
      ls_equipamento-gro_wei_val    = ls_item_tr-gro_wei_val.
      ls_equipamento-vehicletype    = ls_item_tr-tures_tco.

      APPEND ls_equipamento TO rt_output-mt_ordem_de_frete-equipamento.
      ls_transporte-platenumber = ls_item_tr-platenumber.
*-> TRANSPORTE
      APPEND ls_transporte TO rt_output-mt_ordem_de_frete-transporte.
      CLEAR: ls_transporte, ls_equipamento.
    ENDLOOP.

*-> ZCHAPA
    rt_output-mt_ordem_de_frete-zchapa    = ls_tor_root-zzchapa.

*-> STOPS
    SORT lt_log_locid BY seq ASCENDING.
    LOOP AT lt_log_locid INTO ls_log_locid.
      ls_stops-log_locid = ls_log_locid-loclog_id.
      READ TABLE lt_tor_stop INTO ls_tor_stop WITH KEY log_locid = ls_log_locid-loclog_id
                                                       stop_cat = 'I'.


*      READ TABLE lt_link_next_stop INTO ls_link_next_stop WITH KEY source_key = ls_tor_stop-key.
*      READ TABLE lt_stop_next INTO ls_stop_next WITH KEY key = ls_link_next_stop-target_key.
      READ TABLE lt_stop_next INTO ls_stop_next WITH KEY key = ls_tor_stop-key.
*      READ TABLE lt_link_next_stop INTO ls_link_next_stop WITH KEY source_key = ls_link_next_stop-target_key.
      ls_stops-appointment_start = ls_tor_stop-plan_trans_time.

      IF ls_stop_next-plan_trans_time IS NOT INITIAL.
        ls_stops-finalize_end      = ls_stop_next-plan_trans_time.
      ENDIF.

      CLEAR: ls_lat, ls_long.
      READ TABLE lt_geo_coord INTO ls_lat WITH KEY bpidentificationtype = 'ZLATIT'
*                                                         businesspartner = ls_log_locid-loclog_id.
                                                         businesspartner = ls_log_locid-partner.
      IF sy-subrc IS INITIAL.
        ls_stops-latitude_value  = ls_lat-bpidentificationnumber.
      ELSE.
        ls_stops-latitude_value  = '0.0'.
      ENDIF.

      READ TABLE lt_geo_coord INTO ls_long WITH KEY bpidentificationtype = 'ZLONGI'
*                                                         businesspartner = ls_log_locid-loclog_id.
                                                         businesspartner = ls_log_locid-partner.
      IF sy-subrc IS INITIAL.
        ls_stops-longitude_value = ls_long-bpidentificationnumber.
      ELSE.
        ls_stops-longitude_value = '0.0'.
      ENDIF.

*-> STOPS-LOCATION
      ls_location-log_locid          = ls_log_locid-loclog_id.
*      READ TABLE lt_partneraddr INTO DATA(ls_partneraddr) WITH KEY businesspartner = CONV bu_partner( ls_location-log_locid ).
      READ TABLE lt_partneraddr INTO DATA(ls_partneraddr) WITH KEY businesspartner = ls_log_locid-partner.
      IF ls_location-log_locid <> CONV bu_partner( ls_et_locations-locno ).
        ls_location-street_name     = ls_partneraddr-streetname .
        ls_location-house_number    = ls_partneraddr-housenumber.
        IF ls_partneraddr-fullname IS NOT INITIAL.
          ls_location-description     = ls_partneraddr-fullname.
        ELSE.
          SELECT SINGLE name_first, name_last
            FROM but000
            INTO @DATA(ls_but000)
*            WHERE partner = @ls_location-log_locid.
            WHERE partner = @ls_log_locid-partner.

          CONCATENATE ls_but000-name_first ls_but000-name_last INTO ls_location-description SEPARATED BY space.
        ENDIF.
        ls_location-city_name       = ls_partneraddr-cityname.
        ls_location-region          = ls_partneraddr-region.
        ls_location-postal_code     = ls_partneraddr-postalcode.
        ls_location-district        = ls_partneraddr-district.
        ls_location-country         = ls_partneraddr-country.
*        READ TABLE lt_partnercust INTO DATA(ls_partnercust) WITH KEY customer = CONV bu_partner( ls_location-log_locid ).
*        READ TABLE lt_partnercust INTO DATA(ls_partnercust) WITH KEY customer = ls_log_locid-partner.
*        ls_location-tax_number1     = ls_partnercust-taxnumber1.
*        IF ls_location-tax_number1 IS INITIAL.
*          ls_location-tax_number1 = ls_partnercust-taxnumber2.
*        ENDIF.

        READ TABLE lt_partnercust INTO DATA(ls_partnercust) WITH KEY partner = ls_log_locid-partner
                                                                     taxtype = 'BR1'.

        IF sy-subrc IS INITIAL AND
           ls_partnercust-taxnum IS NOT INITIAL.

          ls_location-tax_number1     = ls_partnercust-taxnum.
        ELSE.
          READ TABLE lt_partnercust INTO ls_partnercust WITH KEY partner = ls_log_locid-partner
                                                                 taxtype = 'BR2'.

          IF sy-subrc IS INITIAL AND
            ls_partnercust-taxnum IS NOT INITIAL.

            ls_location-tax_number1     = ls_partnercust-taxnum.
          ELSE.
            READ TABLE lt_partnercust INTO ls_partnercust WITH KEY partner = ls_log_locid-partner
                                                                   taxtype = 'BR3'.

            IF sy-subrc IS INITIAL AND
              ls_partnercust-taxnum IS NOT INITIAL.

              ls_location-tax_number1     = ls_partnercust-taxnum.
            ENDIF.
          ENDIF.
        ENDIF.

        IF ls_lat-bpidentificationnumber IS INITIAL.
          ls_location-latitude_value = '0.0'.
        ELSE.
          ls_location-latitude_value  = ls_lat-bpidentificationnumber.
        ENDIF.
        IF ls_long-bpidentificationnumber IS INITIAL.
          ls_location-longitude_value = '0.0'.
        ELSE.
          ls_location-longitude_value = ls_long-bpidentificationnumber.
        ENDIF.
      ELSE.
        ls_location-street_name     = ls_et_locations-street.
        ls_location-house_number    = ls_et_locations-house_number.
        ls_location-city_name       = ls_et_locations-city.
        ls_location-region          = ls_et_locations-region.
        ls_location-postal_code     = ls_et_locations-code.
        ls_location-district        = ls_partneraddr-district. "Ajustar
        ls_location-country         = ls_et_locations-country.
        ls_location-tax_number1     = space. "Ajustar
      ENDIF.

      READ TABLE lt_tor_stop_succ INTO DATA(ls_stop_succ) WITH TABLE KEY succ_stop_key COMPONENTS succ_stop_key = ls_tor_stop-key. "##PRIMKEY[SUCC_STOP_KEY]

      ls_location-tot_distance_km = ls_stop_succ-distance_km * 1000.
      ls_location-tot_duration = ls_stop_succ-duration_net.
      APPEND ls_location TO ls_stops-location.

*-> STOPS-ORDERS
*      LOOP AT lt_assigned_fus INTO ls_assigned_fus WHERE consigneeid EQ ls_log_locid-loclog_id.
*      LOOP AT lt_assigned_fus INTO ls_assigned_fus WHERE consigneeid EQ ls_log_locid-partner.

      IF ( ls_tor_root-zz1_cond_exped EQ '04'
         OR ls_tor_root-zz1_cond_exped EQ '17' ).
        CLEAR: lv_select_clause.
      ELSE.
        lv_select_clause =  'consigneeid = ls_log_locid-partner'.
      ENDIF.

      LOOP AT lt_assigned_fus INTO ls_assigned_fus WHERE (lv_select_clause).
        "Ler os dados
*-> STOPS-ORDERS-NFNUM
        TRY.
            DATA(lv_lfart) = lt_likp[ vbeln = ls_assigned_fus-base_btd_id+25(10) ]-lfart.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        IF ls_assigned_fus-tor_type EQ 'F013'.
*        CASE lv_lfart.
*          WHEN 'ZPDV'.
          ls_orders-nfnum = ls_assigned_fus-base_btd_id+25(10).
          ls_orders-text1 = 'N/A'.
          ls_orders-zlsch = 'Z'.
          ls_orders-amt_gdsv_val = '0.01'.

*          WHEN OTHERS.
        ELSE.
          TRY.
              DATA(lv_fatura)        = lt_vbfa[ vbelv = ls_assigned_fus-base_btd_id+25(10) ]-vbeln.
              DATA(lv_docnum)        = lt_lin[ refkey = lv_fatura ]-docnum.
              DATA(lv_nfenum)        = lt_lin[ docnum = lv_docnum ]-nfenum.
              DATA(lv_series)        = lt_lin[ docnum = lv_docnum ]-series.

              IF lv_series IS NOT INITIAL.
                CONCATENATE lv_nfenum '-' lv_series INTO ls_orders-nfnum.
              ELSE.
                ls_orders-nfnum = lv_nfenum.
              ENDIF.

*-> STOPS-ORDERS-AMT_GDSV_VAL
              ls_orders-amt_gdsv_val = lt_lin[ docnum = lv_docnum ]-nftot * 10000.
*-> STOPS-ORDERS-ZLSCH
              ls_orders-zlsch        = lt_vbfa[ vbeln_vf = lv_fatura ]-zlsch.
* I - MAS - 32Z-193I02
              SELECT SINGLE br_nfeaccesskey FROM c_br_verifynotafiscal"cbrverifynf
                INTO @ls_orders-br_nfeaccesskey
               WHERE br_notafiscal EQ @lv_docnum.
* F - MAS - 32Z-193I02
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.
        ENDIF.

*        ls_orders-zlsch        = lt_vbfa[ vbeln_vf = lv_fatura ]-zlsch.

*-> STOPS-ORDERS-GRO_WEI_VAL
        ls_orders-gro_wei_val  = ls_assigned_fus-gro_wei_val.
*-> STOPS-ORDERS-GRO_VOL_VAL
        ls_orders-gro_vol_val  = ls_assigned_fus-gro_vol_val.
        TRY .
*-> STOPS-ORDERS-TEXT1
            IF ls_orders-text1 IS INITIAL.
              ls_orders-text1        = lt_t042z[ zlsch = ls_orders-zlsch ]-text1.
            ENDIF.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

        IF ls_orders-zlsch IS INITIAL.
          ls_orders-zlsch = abap_true.
        ENDIF.

        IF ls_orders-text1 IS INITIAL.
          ls_orders-text1 = abap_true.
        ENDIF.

        SHIFT ls_assigned_fus-tor_id  LEFT DELETING LEADING '0'.
        ls_orders-instrucoes   = ls_assigned_fus-tor_id.
*        ENDCASE.

*-> STOPS-ORDERS-INSTRUCOES
        ls_orders-instrucoes = ls_assigned_fus-tor_id.
        SHIFT ls_orders-instrucoes  LEFT DELETING LEADING '0'.

*-> STOPS-ORDERS-LINE_ITEMS
        LOOP AT lt_item_tr INTO ls_item_tr WHERE base_btd_id EQ ls_assigned_fus-base_btd_id
                                             AND main_cargo_item EQ abap_true.

*-> STOPS-ORDERS-LINE_ITEMS-POSNR
          ls_items-posnr         = ls_item_tr-item_id.
*-> STOPS-ORDERS-LINE_ITEMS-PRODUCT_ID
          ls_items-product_id    = ls_item_tr-product_id.
          SHIFT ls_items-product_id LEFT DELETING LEADING '0'.
*-> STOPS-ORDERS-LINE_ITEMS-GRO_WEI_VAL
          ls_items-gro_wei_val   = ls_item_tr-gro_wei_val.
*-> STOPS-ORDERS-LINE_ITEMS-GRO_VOL_VAL
          ls_items-gro_vol_val   = ls_item_tr-gro_vol_val.
*-> STOPS-ORDERS-LINE_ITEMS-AMT_GDSV_VAL
          DATA(lv_product_id)    = CONV char18( ls_item_tr-product_id ).
          lv_product_id = |{ lv_product_id ALPHA = IN }|.
          READ TABLE lt_lin INTO DATA(ls_lin_aux) WITH KEY docnum = lv_docnum
                                                           matnr = lv_product_id.
          lv_amt_gdsv_val = CONV /scmtms/amt_goodsvalue_val( ls_item_tr-amt_gdsv_val ).
          ls_items-amt_gdsv_val  = lv_amt_gdsv_val * 10000.
          LOOP AT lt_stx INTO DATA(ls_stx) WHERE docnum = lv_docnum AND itmnum = ls_lin_aux-itmnum. "#EC CI_STDSEQ
            ls_items-amt_gdsv_val = ls_items-amt_gdsv_val + ls_stx-taxval.
          ENDLOOP.

          IF ls_assigned_fus-tor_type = 'F013' AND ls_items-amt_gdsv_val IS INITIAL.
            ls_items-amt_gdsv_val = '0.01'.
          ENDIF.

*-> STOPS-ORDERS-LINE_ITEMS-BRAND_ID
          IF line_exists( lt_mara[ matnr = |{ lv_product_id ALPHA = IN }| ] ).
            ls_items-brand_id    = lt_mara[ matnr = lv_product_id  ]-brand_id.
          ENDIF.
*-> STOPS-ORDERS-LINE_ITEMS-MAKTX
          ls_items-maktx         = ls_item_tr-item_descr.
*-> STOPS-ORDERS-LINE_ITEMS-QUA_PCS_UNI
          ls_items-qua_pcs_uni   = ls_item_tr-qua_pcs_uni.
*-> STOPS-ORDERS-LINE_ITEMS-QUA_PCS2_UNI
          ls_items-qua_pcs2_uni  = ls_item_tr-qua_pcs2_uni.
          APPEND ls_items TO ls_orders-line_items.
          CLEAR ls_items.
        ENDLOOP.
        APPEND ls_orders TO ls_stops-orders.
        CLEAR ls_orders.
      ENDLOOP.

      IF ls_stops-orders IS NOT INITIAL.
        APPEND ls_stops TO rt_output-mt_ordem_de_frete-stops.
      ENDIF.

      CLEAR ls_stops.
    ENDLOOP.

  ENDMETHOD.


  METHOD valida_estrutura_greenmile.

    DATA: lo_describe TYPE REF TO cl_abap_structdescr.

* ----------------------------------------------------------------------
* Recupera campos da estrutura
* ----------------------------------------------------------------------
    lo_describe ?= cl_abap_structdescr=>describe_by_data( is_data ).
    DATA(lt_dfies) = cl_salv_data_descr=>read_structdescr( lo_describe ).

* ----------------------------------------------------------------------
* Recupera campos obrigatórios da estrutura
* ----------------------------------------------------------------------
    DATA(lr_fields) = busca_campos_validacao( iv_estrutura = iv_estrutura ).
    IF lr_fields IS INITIAL.
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Valida os tipos do campos e realiza a verificação
* ----------------------------------------------------------------------
*    LOOP AT lt_dfies REFERENCE INTO DATA(ls_dfies).      "#EC CI_NESTED
    LOOP AT lt_dfies REFERENCE INTO DATA(ls_dfies) WHERE fieldname IN lr_fields. "#EC CI_NESTED

      CHECK ls_dfies->inttype = 'D'
         OR ls_dfies->inttype = 'T'
         OR ls_dfies->inttype = 'P'
         OR ls_dfies->inttype = 'N'
         OR ls_dfies->inttype = 'h'
         OR ls_dfies->inttype = 'g'.

      " Recupera campo da tabela
      ASSIGN COMPONENT sy-tabix OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_v_data_field>).
      CHECK sy-subrc EQ 0.

      " Verifica se o campo está preenchido.
      IF <fs_v_data_field> IS INITIAL.
        " Campo '&1'está vazio.
        ct_return[] = VALUE #( BASE ct_return ( type       = 'E'
                                                id         = 'ZTM_EVENT_OUT_GREENM'
                                                number     = '001'
                                                message_v1 = ls_dfies->tabname
                                                message_v2 = ls_dfies->fieldname ) ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD valida_tabela_greenmile.

* ----------------------------------------------------------------------
* Valida os tipos do campos e realiza a verificação
* ----------------------------------------------------------------------
    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_s_data>).

      valida_estrutura_greenmile(
        EXPORTING
          is_data   = <fs_s_data>
        CHANGING
          ct_return = ct_return ).

    ENDLOOP.

  ENDMETHOD.


  METHOD valida_campos.

    FREE: et_return, et_message.

* ----------------------------------------------------------------------
* Valida a estrutura principal
* ----------------------------------------------------------------------
    CALL METHOD valida_estrutura_greenmile
      EXPORTING
        is_data      = is_output-mt_ordem_de_frete
        iv_estrutura = gc_estrutura-principal
      CHANGING
        ct_return    = et_return.

* ----------------------------------------------------------------------
* Valida a tabela de paradas
* ----------------------------------------------------------------------
    LOOP AT is_output-mt_ordem_de_frete-stops REFERENCE INTO DATA(ls_stops).

      CALL METHOD valida_estrutura_greenmile
        EXPORTING
          is_data      = ls_stops->*
          iv_estrutura = gc_estrutura-stops
        CHANGING
          ct_return    = et_return.

      LOOP AT ls_stops->location REFERENCE INTO DATA(ls_location).

        CALL METHOD valida_estrutura_greenmile
          EXPORTING
            is_data      = ls_location->*
            iv_estrutura = gc_estrutura-location
          CHANGING
            ct_return    = et_return.

      ENDLOOP.

      LOOP AT ls_stops->orders REFERENCE INTO DATA(ls_orders).

        CALL METHOD valida_estrutura_greenmile
          EXPORTING
            is_data      = ls_orders->*
            iv_estrutura = gc_estrutura-orders
          CHANGING
            ct_return    = et_return.

        LOOP AT ls_orders->line_items REFERENCE INTO DATA(ls_line_items).

          CALL METHOD valida_estrutura_greenmile
            EXPORTING
              is_data      = ls_line_items->*
              iv_estrutura = gc_estrutura-line_items
            CHANGING
              ct_return    = et_return.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

    LOOP AT is_output-mt_ordem_de_frete-equipamento REFERENCE INTO DATA(ls_equipamento).

      CALL METHOD valida_estrutura_greenmile
        EXPORTING
          is_data      = ls_equipamento->*
          iv_estrutura = gc_estrutura-equipamento
        CHANGING
          ct_return    = et_return.

    ENDLOOP.

    LOOP AT is_output-mt_ordem_de_frete-motorista REFERENCE INTO DATA(ls_motorista).

      CALL METHOD valida_estrutura_greenmile
        EXPORTING
          is_data      = ls_motorista->*
          iv_estrutura = gc_estrutura-motorista
        CHANGING
          ct_return    = et_return.

    ENDLOOP.

    LOOP AT is_output-mt_ordem_de_frete-transporte REFERENCE INTO DATA(ls_transporte).

      CALL METHOD valida_estrutura_greenmile
        EXPORTING
          is_data      = ls_transporte->*
          iv_estrutura = gc_estrutura-transporte
        CHANGING
          ct_return    = et_return.

    ENDLOOP.

*    CALL METHOD valida_estrutura_greenmile
*      EXPORTING
*        is_data      = is_output-mt_ordem_de_frete-destination
*        iv_estrutura = gc_estrutura-destination
*      CHANGING
*        ct_return    = et_return.

*    CALL METHOD valida_estrutura_greenmile
*      EXPORTING
*        is_data      = is_output-mt_ordem_de_frete-origin
*        iv_estrutura = gc_estrutura-origin
*      CHANGING
*        ct_return    = et_return.


    et_message = VALUE #( FOR ls_return IN et_return ( msgty = ls_return-type
                                                       msgid = ls_return-id
                                                       msgno = ls_return-number
                                                       msgv1 = ls_return-message_v1
                                                       msgv2 = ls_return-message_v2
                                                       msgv3 = ls_return-message_v3
                                                       msgv4 = ls_return-message_v4  ) ).

  ENDMETHOD.


  METHOD exibe_msg_validacao.
    LOOP AT it_return_valida ASSIGNING FIELD-SYMBOL(<fs_return_valida>).
      CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
        EXPORTING
          i_msgid  = <fs_return_valida>-id
          i_msgty  = <fs_return_valida>-type
          i_msgno  = <fs_return_valida>-number
          i_msgv1  = <fs_return_valida>-message_v1
*         i_msgv2  =
*         i_msgv3  =
*         i_msgv4  =
          i_lineno = <fs_return_valida>-row
*      TABLES
*         i_message_tab =
        .
    ENDLOOP.
    RETURN.
  ENDMETHOD.


  METHOD busca_campos_validacao.

    CASE iv_estrutura.
      WHEN gc_estrutura-principal.

        APPEND INITIAL LINE TO rt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'TOR_ID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'DATA'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'CENTRO'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'FIRST_LOG_LOCID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LAST_LOG_LOCID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LASTSTOPISDESTINATION'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'FIRST_STOP_AGGR_ASSGN_START_L'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'FIRST_STOP_AGGR_ASSGN_END_L'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LAST_STOP_AGGR_ASSGN_START_L'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LAST_STOP_AGGR_ASSGN_END_L'.

*        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
*        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
*        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
*        <fs_return>-low    = 'ZCHAPA'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'STOPS'.

      WHEN gc_estrutura-stops.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LOG_LOCID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LOCATION'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'APPOINTMENT_START'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'FINALIZE_END'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'ORDERS'.

      WHEN gc_estrutura-location.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LOG_LOCID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LATITUDE_VALUE'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LONGITUDE_VALUE'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'STREET_NAME'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'HOUSE_NUMBER'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'CITY_NAME'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'REGION'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'POSTAL_CODE'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'DISTRICT'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'COUNTRY'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'TAX_NUMBER1'.

      WHEN gc_estrutura-orders.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'NFNUM'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'BR_NFEACCESSKEY'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'LINE_ITEMS'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'GRO_WEI_VAL'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'GRO_VOL_VAL'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'AMT_GDSV_VAL'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'ZLSCH'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'TEXT1'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'INSTRUCOES'.

      WHEN gc_estrutura-line_items.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'PRODUCT_ID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'GRO_WEI_VAL'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'GRO_VOL_VAL'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'AMT_GDSV_VAL'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'MAKTX'.

*        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
*        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
*        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
*        <fs_return>-low    = 'QUA_PCS2_UNI'.

      WHEN gc_estrutura-equipamento.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'EQUIPMENT'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'EQUIPMENT_NAME'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'WERK'.

      WHEN gc_estrutura-motorista.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'PARTY_ID'.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'DRIVERNAME'.

      WHEN gc_estrutura-transporte.

        APPEND INITIAL LINE TO rt_return ASSIGNING <fs_return>.
        <fs_return>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
        <fs_return>-option = /bobf/if_conf_c=>sc_sign_equal.
        <fs_return>-low    = 'PLATENUMBER'.

      WHEN OTHERS.

        CLEAR: rt_return.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
