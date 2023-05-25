"!<p><h2>Envio de dados via proxy para o sistema Roadnet</h2></p>
"!<p><strong>Autor: </strong>Eliabe Lima</p>
"!<p><strong>Data: </strong>07/02/2022</p>
CLASS zcltm_raoadnet_session DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS processa
      IMPORTING
        !it_remessa      TYPE vbeln_vl_t
      RETURNING
        VALUE(rt_return) TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_remessa,
        vbeln    TYPE vbeln_vl,
        werks    TYPE werks_d,
*        base_btd_id TYPE /scmtms/base_btd_id,
        btd_id   TYPE /scmtms/btd_id,
        tor_id   TYPE /scmtms/tor_id,
        vbeln_ok TYPE flag,
      END OF ty_remessa ,

      BEGIN OF ty_parameter,
        lifsk_er TYPE likp-lifsk,           " Enviar para roteirização
      END OF ty_parameter .

    CONSTANTS:
      BEGIN OF gc_param_lifsk_er,
        modulo TYPE ztca_param_val-modulo VALUE 'SD',
        chave1 TYPE ztca_param_val-chave1 VALUE 'ADM_FATURAMENTO',
        chave2 TYPE ztca_param_val-chave2 VALUE 'BLOQ_REMESSA',
        chave3 TYPE ztca_param_val-chave3 VALUE 'EM_ROTA',
      END OF gc_param_lifsk_er.

    DATA gs_parameter TYPE ty_parameter .

    DATA:
      gt_dados TYPE STANDARD TABLE OF ty_remessa .
    DATA:
      gt_session TYPE STANDARD TABLE OF zttm_road_sessio .
    DATA gt_remessa TYPE vbeln_vl_t .
    DATA gt_return TYPE bapiret2_tab .
    DATA:
      gt_rodremessa TYPE STANDARD TABLE OF zttm_road_remess .
    CONSTANTS gc_calendfab TYPE wfcid VALUE 'Z0' ##NO_TEXT.
    CONSTANTS gc_torcat_fu TYPE /scmtms/tor_category VALUE 'FU' ##NO_TEXT.
    CONSTANTS gc_btd_tco TYPE /scmtms/btd_type_code VALUE 'RODSE' ##NO_TEXT.
    CONSTANTS gc_btd_issuer TYPE /scmtms/btd_issuingparty_name VALUE 'ROADNET' ##NO_TEXT.
    DATA gt_mod TYPE /bobf/t_frw_modification .

*  constants GC_VBTY type VBTYPL value 'TMFU' ##NO_TEXT.
    METHODS criar_sessao
      RAISING
        zcxtm_roadnet_session
        cx_ai_system_fault .
    METHODS enviar_remessa
      RAISING
        zcxtm_roadnet_session
        cx_ai_system_fault
        cx_sadl_exit .
    METHODS carrega_dados
      RAISING
        zcxtm_roadnet_session .
    METHODS workingday
      IMPORTING
        !iv_day        TYPE dlydy
        !iv_data       TYPE dats
      RETURNING
        VALUE(rv_data) TYPE dats .
    METHODS criar_docreference .
    METHODS save_remessa .
    METHODS get_session_roadnet
      IMPORTING
        !iv_data          TYPE sydatum
        !iv_centro        TYPE werks_d
      RETURNING
        VALUE(rs_session) TYPE zttm_road_sessio .
    METHODS save_data_of .
    METHODS liberar_remessa
      IMPORTING
        !iv_remessa        TYPE vbeln_vl
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
    METHODS get_parameter
      IMPORTING is_param TYPE ztca_param_val
      EXPORTING ev_value TYPE any.
ENDCLASS.



CLASS ZCLTM_RAOADNET_SESSION IMPLEMENTATION.


  METHOD carrega_dados.

    DATA: lv_r_vbeln TYPE RANGE OF vbeln_vl.
*          lt_docflow TYPE tdt_docflow.

    CONSTANTS:
      lc_sign_i    TYPE char1              VALUE 'I',
      lc_option_eq TYPE char2              VALUE 'EQ'.

    SELECT
      DISTINCT
      vbeln
    FROM zttm_road_remess
    WHERE
      dtenvio = @sy-datum
    INTO TABLE @DATA(lt_remessa).

    IF sy-subrc = 0.
      SORT lt_remessa BY vbeln.
    ENDIF.

    LOOP AT gt_remessa ASSIGNING FIELD-SYMBOL(<fs_remessa>).

      READ TABLE lt_remessa
      WITH KEY vbeln = <fs_remessa>
      BINARY SEARCH TRANSPORTING NO FIELDS.

      IF sy-subrc NE 0.
        APPEND INITIAL LINE TO lv_r_vbeln ASSIGNING FIELD-SYMBOL(<fs_vbeln>).
        <fs_vbeln>-sign = lc_sign_i.
        <fs_vbeln>-option = lc_option_eq.
        <fs_vbeln>-low = <fs_remessa>.
      ENDIF.

    ENDLOOP.

    IF lv_r_vbeln IS NOT INITIAL.
      SELECT
        DISTINCT
        vbeln,
        werks
      FROM lips
      WHERE
        vbeln IN @lv_r_vbeln
      INTO TABLE @gt_dados."@gt_dados.

      IF sy-subrc = 0.

*        SORT gt_dados BY vbeln.
*
*        LOOP AT gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
*          CLEAR lt_docflow.
*
*          CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
*            EXPORTING
*              iv_docnum  = <fs_dados>-vbeln
*            IMPORTING
*              et_docflow = lt_docflow.
*
*          IF lt_docflow IS NOT INITIAL.
*            SORT lt_docflow BY vbtyp_n.
*            READ TABLE lt_docflow
*            WITH KEY vbtyp_n = gc_vbty
*            ASSIGNING FIELD-SYMBOL(<fs_flow>) BINARY SEARCH.
*
*            IF sy-subrc = 0.
*              <fs_dados>-base_btd_id = <fs_flow>-docnum.
*            ENDIF.
*          ENDIF.
*
*        ENDLOOP.
*
*        LOOP AT lv_r_vbeln ASSIGNING <fs_vbeln>.
*          READ TABLE gt_dados
*          WITH KEY vbeln = <fs_vbeln>-low
*          BINARY SEARCH TRANSPORTING NO FIELDS.
*
*          IF sy-subrc NE 0.
*
*          ENDIF.
*
*        ENDLOOP.

        SORT gt_dados BY werks.

      ENDIF.
    ELSE.
      "Erro ao criar ordem de manutenção
      RAISE EXCEPTION TYPE zcxtm_roadnet_session
        EXPORTING
          textid = zcxtm_roadnet_session=>sem_remessa.
    ENDIF.

  ENDMETHOD.


  METHOD criar_docreference.
    DATA: lo_srv_tor      TYPE REF TO /bobf/if_tra_service_manager,
          lt_parameters   TYPE /bobf/t_frw_query_selparam,
          lt_docreferenc  TYPE /scmtms/t_tor_docref_k,
          lt_tor          TYPE /scmtms/t_tor_root_k,
          lt_tor_root_key TYPE /bobf/t_frw_key,
*          lt_mod              TYPE /bobf/t_frw_modification,
          ls_mod          TYPE /bobf/s_frw_modification,
          lv_vbeln        TYPE vbeln_vl,
          lv_basebtdid    TYPE /scmtms/base_btd_id.

    FIELD-SYMBOLS: <fs_docref> TYPE /scmtms/s_tor_docref_k.

    CONSTANTS: lc_sign_i    TYPE char1   VALUE 'I',
               lc_option_eq TYPE char2   VALUE 'EQ'.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
      <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-base_btd_id.
      <fs_parameters>-sign           = lc_sign_i.
      <fs_parameters>-option         = lc_option_eq.
      <fs_parameters>-low            = <fs_dados>-vbeln.
    ENDLOOP.

    IF lt_parameters IS NOT INITIAL.

      APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameters>.
      <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_node_attribute-root-tor_cat.
      <fs_parameters>-sign   = lc_sign_i.
      <fs_parameters>-option = lc_option_eq.
      <fs_parameters>-low    = gc_torcat_fu.

      lo_srv_tor->query(
                         EXPORTING
                           iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements "docreference-docreference_elements
                           it_selection_parameters = lt_parameters
                           iv_fill_data            = abap_true
                         IMPORTING
                           et_key                  = lt_tor_root_key
                           et_data                 = lt_tor
                       ).

      DATA(lt_dados) = gt_dados.
      CLEAR gt_dados.

      SORT lt_dados BY vbeln.
      SORT gt_session BY werks.

      LOOP AT lt_tor ASSIGNING FIELD-SYMBOL(<fs_tor>).

        CLEAR ls_mod.

        ls_mod-node         = /scmtms/if_tor_c=>sc_node-docreference.
        ls_mod-change_mode  = /bobf/if_frw_c=>sc_modify_create.
        ls_mod-association  = /scmtms/if_tor_c=>sc_association-root-docreference.
        ls_mod-source_key   = <fs_tor>-key.
        ls_mod-source_node  = /scmtms/if_tor_c=>sc_node-root.
        ls_mod-key          = /bobf/cl_frw_factory=>get_new_key( ).

        CREATE DATA ls_mod-data TYPE /scmtms/s_tor_docref_k.

        ASSIGN ls_mod-data->* TO <fs_docref>.
        <fs_docref>-btd_tco = gc_btd_tco.
        <fs_docref>-key = ls_mod-key.
        <fs_docref>-btd_date = sy-datum.
        <fs_docref>-btd_issuer = gc_btd_issuer.

        lv_basebtdid = <fs_tor>-base_btd_id.
        SHIFT lv_basebtdid LEFT DELETING LEADING '0'.
        lv_vbeln = lv_basebtdid.
        UNPACK lv_vbeln TO lv_vbeln.

        READ TABLE lt_dados
        WITH KEY vbeln = lv_vbeln
        BINARY SEARCH ASSIGNING <fs_dados>.

        IF sy-subrc = 0.
          <fs_docref>-btd_id = <fs_dados>-werks && '_' && sy-datum.

          READ TABLE gt_session
          WITH KEY werks = <fs_dados>-werks
          ASSIGNING FIELD-SYMBOL(<fs_session>) BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_docref>-btd_id = <fs_docref>-btd_id && '_' && <fs_session>-id_session_roadnet.
          ENDIF.
          <fs_dados>-tor_id = <fs_tor>-tor_id.
          <fs_dados>-btd_id = <fs_docref>-btd_id.

          <fs_dados>-vbeln_ok = abap_true.

          APPEND INITIAL LINE TO gt_dados ASSIGNING FIELD-SYMBOL(<fs_gdados>).
          <fs_gdados> = <fs_dados> .

          APPEND ls_mod TO gt_mod.
*        ELSE.
*          APPEND INITIAL LINE TO gt_dados ASSIGNING <Fs_gdados>.
*          <fs_gdados> = <fs_dados> .
        ENDIF.

      ENDLOOP.

      SORT lt_dados BY vbeln_ok.
      READ TABLE lt_dados
      WITH KEY vbeln_ok = abap_false TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        LOOP AT lt_dados FROM sy-tabix ASSIGNING <fs_dados>.

          IF <fs_dados>-vbeln_ok NE abap_false.
            EXIT.
          ENDIF.

          APPEND LINES OF NEW zcxtm_roadnet_session(
            textid      = zcxtm_roadnet_session=>gc_remssa_nao_enviada
            gv_msgv1    = CONV msgv1( <fs_dados>-vbeln )
          )->get_bapiretreturn( ) TO gt_return.


        ENDLOOP.
      ENDIF.


    ENDIF.

  ENDMETHOD.


  METHOD criar_sessao.

    DATA: lv_dtsession   TYPE sy-datum,
          ls_input       TYPE zcltm_mt_sessao_resp,
          ls_output      TYPE zcltm_mt_sessao,
          ls_tmpsession  TYPE zttm_road_sessio,
          lt_updsesseion TYPE STANDARD TABLE OF zttm_road_sessio,
          lv_upd         TYPE abap_bool,
          lv_create      TYPE abap_bool.


    DATA(lt_dados) = gt_dados.
    SORT lt_dados BY werks.

    DELETE ADJACENT DUPLICATES FROM lt_dados COMPARING werks.

    IF lt_dados IS NOT INITIAL.

      lv_dtsession = sy-datum.
      "adicionando 1 dia sobre a data de execucao
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lv_dtsession
          days      = '1'
          months    = '0'
          signum    = '+'
          years     = '0'
        IMPORTING
          calc_date = lv_dtsession.

      lv_dtsession =    workingday(
                                    EXPORTING
                                      iv_day  = '1'
                                      iv_data = lv_dtsession
                                  ).
*      SELECT *
*      FROM zttm_road_sessio
*      WHERE dtsession = @lv_dtsession
*      INTO TABLE @DATA(lt_session).
*
*      IF sy-subrc EQ 0.
*        SORT lt_session BY werks.
*      ENDIF.

      LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

        CLEAR : ls_tmpsession,
                ls_input,
                ls_output.

        lv_create = abap_false.

        ls_tmpsession = get_session_roadnet(
                                              iv_data   = lv_dtsession
                                              iv_centro = <fs_dados>-werks
                                            ).

*        READ TABLE lt_session ASSIGNING FIELD-SYMBOL(<fs_ses>)
*        WITH KEY werks = <fs_dados>-werks
*        BINARY SEARCH.

*        IF sy-subrc NE 0.

        APPEND INITIAL LINE TO gt_session ASSIGNING FIELD-SYMBOL(<fs_session>).
        <fs_session>-werks     = <fs_dados>-werks.
        <fs_session>-dtsession = lv_dtsession.

        ls_output-mt_sessao-centro       = <fs_dados>-werks.
        ls_output-mt_sessao-session_date = lv_dtsession.

        IF ls_tmpsession IS INITIAL.
          NEW zcltm_co_si_criar_sessao( )->si_criar_sessao(
                                                              EXPORTING
                                                                output = ls_output
                                                              IMPORTING
                                                                input  = ls_input
                                                            ).
          <fs_session>-id_session_roadnet = ls_input-mt_sessao_resp-session_identity-zinternal_session.
          GET TIME STAMP FIELD <fs_session>-created_at.
          lv_create = abap_true.
        ELSE.
          "sessao foi criada direto no Raodnet
          <fs_session>-id_session_roadnet = ls_tmpsession-id_session_roadnet.
        ENDIF.

        IF lv_create EQ abap_true.
          APPEND INITIAL LINE TO lt_updsesseion ASSIGNING FIELD-SYMBOL(<fs_upd>).
          MOVE-CORRESPONDING <fs_session> TO <fs_upd>.
        ENDIF.
*        ELSE."IF gt_session IS INITIAL.
*          lv_upd  = abap_false.
*
*          IF ls_tmpSession IS INITIAL.
*            ls_output-mt_sessao-centro       = <fs_ses>-werks.
*            ls_output-mt_sessao-session_date = <fs_ses>-dtsession.
*
*            NEW zcltm_co_si_criar_sessao( )->si_criar_sessao(
*                                                                EXPORTING
*                                                                  output = ls_output
*                                                                IMPORTING
*                                                                  input  = ls_input
*                                                              ).
*            <fs_ses>-id_session_roadnet = ls_input-mt_sessao_resp-session_identity-zinternal_session.
*            lv_upd = abap_true.
*          ELSEIF <fs_ses>-id_session_roadnet NE ls_tmpSession-id_session_roadnet .
*            <fs_ses>-id_session_roadnet = ls_tmpSession-id_session_roadnet.
*            lv_upd = abap_true.
*          ENDIF.
*
*          APPEND INITIAL LINE TO gt_session ASSIGNING FIELD-SYMBOL(<fs_session2>).
*          MOVE-CORRESPONDING <fs_ses> TO <fs_session2>.
*
*          "sessao ja exite no SAP , mas o id está divergente. Causa, o usuário deletou a sessao criada pelo o sap e gerou outra manualmente
**          IF ls_tmpSession IS NOT INITIAL
**              AND ls_tmpSession-id_session_roadnet NE <fs_session2>-id_session_roadnet.
*
*          IF lv_upd = abap_true.
**            <fs_session2>-id_session_roadnet = ls_tmpSession-id_session_roadnet.
*            GET TIME STAMP FIELD <fs_session2>-last_changed_at.
*            <fs_session2>-local_last_changed_at   = <fs_session2>-last_changed_at.
*
*            APPEND INITIAL LINE TO lt_updSesseion ASSIGNING <fs_upd>.
*            MOVE-CORRESPONDING <fs_session2> TO <fs_upd>.
*          ENDIF.
*
*        ENDIF.

      ENDLOOP.

      IF lt_updsesseion IS NOT INITIAL ."AND lt_session IS INITIAL.

        MODIFY zttm_road_sessio FROM TABLE lt_updsesseion.

        IF sy-subrc = 0.
          COMMIT WORK.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD enviar_remessa.

    TYPES: BEGIN OF ty_itens,
             material                     TYPE matnr,
             item_gross_weight            TYPE brgew_15,
             item_volume                  TYPE p LENGTH 15 DECIMALS 6,
             actual_delivery_amount       TYPE p LENGTH 16 DECIMALS 5,
             deliverydocumentitemcategory TYPE pstyv_vl,
           END OF ty_itens.

    DATA: ls_output     TYPE zcltm_mt_remessa,
          ls_itens      TYPE ty_itens,
          lv_menge      TYPE bstmg,
          lv_material   TYPE matnr,
          lv_undmed     TYPE voleh,
          lv_volconvert TYPE p LENGTH 15 DECIMALS 6,
          lv_vbeln      TYPE vbeln_vl.

    CONSTANTS: lc_vol_m3   TYPE msehi VALUE 'M3',
               lc_peso_kg  TYPE msehi VALUE 'KG',
               lc_peso_cd3 TYPE msehi VALUE 'CD3',
               lc_peso_lt  TYPE msehi VALUE 'LT',
               lc_typsmsg  TYPE bapi_mtype VALUE 'S',
               lc_msgid    TYPE symsgid VALUE 'ZTM_ROADNET_SESSION',
               lc_numeber  TYPE symsgno VALUE '004'.

    IF gt_dados IS NOT  INITIAL.
      SELECT
        DISTINCT
        a~deliverydocument,
        a~headergrossweight,
        a~headerweightunit,
        a~headervolume,
        a~headervolumeunit,
        a~shippingpoint,
        a~shiptoparty,
        a~deliverydate,
        a~documentdate,
        a~deliverydocumenttype,
        a~deliverydocumentcondition,
        b~material,
        b~originaldeliveryquantity,
        b~itemgrossweight,
        b~itemweightunit,
        b~itemvolume,
        b~itemvolumeunit,
        c~actualdeliveryamount,
        e~creationdate,
*        f~meins,
        d~referencesddocument,
        b~deliverydocumentitemcategory
      FROM i_deliverydocument AS a
      INNER JOIN i_outbounddeliveryitem AS b
      ON
        b~outbounddelivery = a~deliverydocument
      INNER JOIN i_deliverydocumentitemamount AS c
      ON
          c~deliverydocument     = b~outbounddelivery
      AND c~deliverydocumentitem = b~outbounddeliveryitem
      INNER JOIN i_deliverydocumentitem AS d
      ON
          d~deliverydocument     = b~outbounddelivery
      AND d~deliverydocumentitem = b~outbounddeliveryitem
      INNER JOIN i_salesdocument AS e
      ON
        d~referencesddocument = e~salesdocument
      INNER JOIN mara AS f
      ON
        f~matnr = b~material
      FOR ALL ENTRIES IN @gt_dados
      WHERE
        a~deliverydocument = @gt_dados-vbeln
        AND d~actualdeliveryquantity NE 0
       " AND d~Batch NE @space    **** Cenário de brinde não tem lote.
*      and DeliveryBlockReason = '' "Funcional ainda falta configurar e passar a coniguracao
      INTO TABLE @DATA(lt_delivery).

      IF sy-subrc = 0.
        SORT lt_delivery BY deliverydocument.
      ENDIF.

    ENDIF.

* BEGIN OF INSERT - JWSILVA - 12.05.2023
* ---------------------------------------------------------------------------
* Tratativa para integração do cliente UNOP
* ---------------------------------------------------------------------------
    IF gt_dados[] IS NOT INITIAL.

      SELECT vbeln, posnr, parvw, kunnr
        FROM vbpa
        INTO TABLE @DATA(lt_partners)
        FOR ALL ENTRIES IN @gt_dados
        WHERE vbeln EQ @gt_dados-vbeln
          AND parvw EQ 'Z2'. " Cliente UNOP

      IF sy-subrc EQ 0.
        SORT lt_partners BY vbeln.
      ENDIF.
    ENDIF.

    LOOP AT lt_delivery REFERENCE INTO DATA(ls_delivery).

      READ TABLE lt_partners REFERENCE INTO DATA(ls_partner) WITH KEY vbeln = ls_delivery->DeliveryDocument BINARY SEARCH.

      IF sy-subrc EQ 0.
        ls_delivery->ShipToParty = ls_partner->kunnr.
      ENDIF.
    ENDLOOP.
* END OF INSERT - JWSILVA - 12.05.2023

    " Monta tabela de chaves Remessa X Material
    DATA(lt_delivery_key) = lt_delivery.
    SORT lt_delivery_key BY deliverydocument material.
    DELETE ADJACENT DUPLICATES FROM lt_delivery_key COMPARING deliverydocument material.

    SORT gt_session BY werks.
    SORT gt_dados   BY werks.

    DATA(lt_dados) = gt_dados.

    SORT lt_dados BY werks.
    DELETE ADJACENT DUPLICATES FROM lt_dados COMPARING vbeln werks.

    DATA(lt_dadosrem) = gt_dados.

    SORT lt_dadosrem BY vbeln werks.
    DELETE ADJACENT DUPLICATES FROM lt_dadosrem COMPARING vbeln werks.
    SORT lt_dadosrem BY werks.

    " ---------------------------
    " Busca de valor de paletização
    " ---------------------------

    DATA lt_original_data           TYPE STANDARD TABLE OF zi_sd_ckpt_agen_app WITH DEFAULT KEY.
    DATA lt_calculated_data         TYPE STANDARD TABLE OF zi_sd_ckpt_agen_app WITH DEFAULT KEY.
    DATA lt_requested_calc_elements TYPE if_sadl_exit_calc_element_read=>tt_elements.

    CONSTANTS: lc_item                 TYPE I_SalesOrderItem-SalesOrderItem VALUE '000010',
               lc_add_palletfracionado TYPE num                             VALUE 1.

    DATA(lo_agend_pallet) = NEW zclsd_ckpt_agend_pallet(  ).

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados_1>).

      READ TABLE lt_delivery ASSIGNING FIELD-SYMBOL(<fs_delivery_1>) WITH KEY DeliveryDocument = <fs_dados_1>-vbeln BINARY SEARCH.

      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).
*      <fs_original_data>-ChaveOrdemRemessa = |{ <fs_delivery_1>-ReferenceSDDocument }| & |{ lc_item }| & |{ <fs_dados_1>-vbeln }|.
        <fs_original_data>-ChaveDinamica     = <fs_dados_1>-vbeln.
*      <fs_original_data>-SalesOrderItem    = lc_item.
        <fs_original_data>-SalesOrder        = <fs_delivery_1>-ReferenceSDDocument.
        <fs_original_data>-Remessa           = <fs_dados_1>-vbeln.
        <fs_original_data>-SoldToParty       = <fs_delivery_1>-ShipToParty.
        <fs_original_data>-Material          = <fs_delivery_1>-Material.
      ENDIF.

    ENDLOOP.

    IF lt_original_data IS NOT INITIAL.
      SELECT SalesOrder, Remessa, DataAgendada, Senha
      FROM zi_sd_hist_agendamento
      FOR ALL ENTRIES IN @lt_original_data
      WHERE SalesOrder = @lt_original_data-SalesOrder
*** Flávia Leite -  8000006305, COCK AGENDAMENTO
       AND Remessa    = @lt_original_data-Remessa
       AND agend_valid = @abap_true
*** Flávia Leite - 8000006305, COCK AGENDAMENTO
      INTO TABLE @DATA(lt_agendamento).

*** Flávia Leite - 8000007431, AGENDAMENTO NA ORDEM
    IF lt_agendamento IS INITIAL.
      SELECT SalesOrder, Remessa, DataAgendada, Senha
      FROM zi_sd_hist_agendamento
      FOR ALL ENTRIES IN @lt_original_data
      WHERE SalesOrder = @lt_original_data-SalesOrder
       AND agend_valid = @abap_true
      INTO TABLE @lt_agendamento.
    ENDIF.
*** Flávia Leite - 8000007431, AGENDAMENTO NA ORDEM
   ENDIF.

    TRY.
        CALL METHOD lo_agend_pallet->if_sadl_exit_calc_element_read~calculate
          EXPORTING
            it_original_data           = lt_original_data
            it_requested_calc_elements = lt_requested_calc_elements
          CHANGING
            ct_calculated_data         = lt_calculated_data.
      CATCH cx_sadl_exit.
    ENDTRY.

    " ---------------------------
    " Fim busca de valor de paletização
    " ---------------------------

    IF sy-subrc IS INITIAL.
      SORT lt_calculated_data BY ChaveDinamica SalesOrder.
      SORT lt_agendamento     BY DataAgendada.
    ENDIF.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_auxdados>).

      CLEAR ls_output.

      READ TABLE gt_session ASSIGNING FIELD-SYMBOL(<fs_session>) WITH KEY werks = <fs_auxdados>-werks
                                                                 BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      READ TABLE lt_dadosrem
      WITH KEY werks = <fs_auxdados>-werks
      BINARY SEARCH TRANSPORTING NO FIELDS.

      IF sy-subrc = 0.

        LOOP AT lt_dadosrem FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_dados>).

          IF <fs_dados>-werks NE <fs_auxdados>-werks.
            EXIT.
          ENDIF.

          READ TABLE lt_delivery ASSIGNING FIELD-SYMBOL(<fs_delivery>)
          WITH KEY deliverydocument = <fs_dados>-vbeln
          BINARY SEARCH.

          IF sy-subrc NE 0.
            CONTINUE.
          ENDIF.

          " ---------------------------
          " Lê tabela calculada para campo Zpaletizacao
          " ---------------------------

          READ TABLE lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated_data>)
              WITH KEY ChaveDinamica = <fs_dados>-vbeln
                       SalesOrder    = <fs_delivery>-ReferenceSDDocument BINARY SEARCH.

          IF sy-subrc EQ 0.
            READ TABLE lt_agendamento ASSIGNING FIELD-SYMBOL(<fs_agendamento>)
                WITH KEY SalesOrder = <fs_calculated_data>-SalesOrder
                         Remessa    = <fs_calculated_data>-Remessa BINARY SEARCH.
*** Flávia Leite - 8000007431, AGENDAMENTO NA ORDEM
           IF <fs_agendamento> IS NOT ASSIGNED.
            READ TABLE lt_agendamento ASSIGNING <fs_agendamento>
                WITH KEY SalesOrder = <fs_calculated_data>-SalesOrder
                         Remessa    = space BINARY SEARCH.
           ENDIF.
*** Flávia Leite - 8000007431, AGENDAMENTO NA ORDEM
          ENDIF.


          DATA(lv_index) = sy-tabix.

          " ---------------------------
          " Preenche dados de cabeçalho
          " ---------------------------

          ls_output-mt_remessa-shipping_point                 = <fs_delivery>-shippingpoint.

          " ----------------------
          " Preenche dados de item
          " ----------------------

          IF <fs_delivery>-headerweightunit NE lc_peso_kg.
            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = <fs_delivery>-material
                i_in_me              = <fs_delivery>-headerweightunit
                i_out_me             = lc_peso_kg
                i_menge              = CONV bstmg( <fs_delivery>-headergrossweight )
              IMPORTING
                e_menge              = lv_menge
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.
            IF sy-subrc = 0.
              <fs_delivery>-headergrossweight = lv_menge.
            ENDIF.
          ENDIF.

          IF <fs_delivery>-headervolumeunit NE lc_vol_m3.
            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = <fs_delivery>-material
                i_in_me              = <fs_delivery>-headervolumeunit
                i_out_me             = lc_vol_m3
                i_menge              = CONV bstmg( <fs_delivery>-headervolume )
              IMPORTING
                e_menge              = lv_menge
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.

            IF sy-subrc = 0.
              <fs_delivery>-headervolume = lv_menge.
            ENDIF.
          ENDIF.

          APPEND INITIAL LINE TO ls_output-mt_remessa-remessas ASSIGNING FIELD-SYMBOL(<fs_remessa>).

          <fs_remessa>-delivery_document              = <fs_delivery>-deliverydocument.
          <fs_remessa>-session_id                     = <fs_session>-id_session_roadnet.
          <fs_remessa>-centro                         = <fs_dados>-werks.
          <fs_remessa>-header_gross_weight            = <fs_delivery>-headergrossweight.
          <fs_remessa>-header_volume                  = <fs_delivery>-headervolume.
          <fs_remessa>-urgencia                       = <fs_delivery>-creationdate.
          <fs_remessa>-ship_to_party                  = <fs_delivery>-shiptoparty.
          <fs_remessa>-delivery_date                  = <fs_delivery>-deliverydate.
          <fs_remessa>-document_date                  = <fs_delivery>-documentdate.
          IF <fs_calculated_data>-PalletFracionado IS NOT INITIAL.
            <fs_remessa>-zpaletizacao                 = <fs_calculated_data>-PalletTotal + lc_add_palletfracionado.
          ELSE.
            <fs_remessa>-zpaletizacao                 = <fs_calculated_data>-PalletTotal.
          ENDIF.

          IF <fs_agendamento>-DataAgendada IS ASSIGNED.
            <fs_remessa>-zdata_agenqda = <fs_agendamento>-DataAgendada.
          ENDIF.

          IF <fs_agendamento>-Senha IS ASSIGNED.
            <fs_remessa>-zsenha_agenda = <fs_agendamento>-Senha.
          ENDIF.

          IF <fs_delivery>-documentdate IS NOT INITIAL.
            <fs_remessa>-idade_documento   = sy-datum - <fs_delivery>-documentdate.
          ENDIF.

          <fs_remessa>-deliverydocument_type          = <fs_delivery>-deliverydocumenttype.
          IF <fs_delivery>-creationdate IS NOT INITIAL.
            <fs_remessa>-urgencia = sy-datum - <fs_delivery>-creationdate.
          ENDIF.

          LOOP AT lt_delivery_key ASSIGNING FIELD-SYMBOL(<fs_delivery_key>) WHERE deliverydocument = <fs_dados>-vbeln. "#EC CI_STDSEQ

            CLEAR ls_itens.

            LOOP AT lt_delivery ASSIGNING <fs_delivery> WHERE deliverydocument EQ <fs_delivery_key>-deliverydocument
                                                          AND material         EQ <fs_delivery_key>-material. "#EC CI_STDSEQ

              IF <fs_delivery>-itemweightunit NE lc_peso_kg.
                CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
                  EXPORTING
                    i_matnr              = <fs_delivery>-material
                    i_in_me              = <fs_delivery>-itemweightunit
                    i_out_me             = lc_peso_kg
                    i_menge              = CONV bstmg( <fs_delivery>-itemgrossweight )
                  IMPORTING
                    e_menge              = lv_menge
                  EXCEPTIONS
                    error_in_application = 1
                    error                = 2
                    OTHERS               = 3.

                IF sy-subrc = 0.
                  <fs_delivery>-itemgrossweight = lv_menge.
                ENDIF.
              ENDIF.

              CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
                EXPORTING
                  input          = <fs_delivery>-itemvolumeunit
                  language       = sy-langu
                IMPORTING
                  output         = lv_undmed
                EXCEPTIONS
                  unit_not_found = 1
                  OTHERS         = 2.
              IF sy-subrc <> 0.
                lv_undmed = <fs_delivery>-itemvolumeunit.
              ENDIF.

              IF lv_undmed NE lc_vol_m3.
                CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
                  EXPORTING
                    i_matnr              = <fs_delivery>-material
                    i_in_me              = lv_undmed
                    i_out_me             = lc_vol_m3
                    i_menge              = CONV bstmg( <fs_delivery>-itemvolume )
                  IMPORTING
                    e_menge              = lv_menge
                  EXCEPTIONS
                    error_in_application = 1
                    error                = 2
                    OTHERS               = 3.

                IF sy-subrc = 0.
                  lv_volconvert = lv_menge.
                ELSEIF ( lv_undmed = lc_peso_cd3 OR lv_undmed = lc_peso_lt ) AND <fs_delivery>-itemvolume NE 0 .
                  lv_volconvert  = <fs_delivery>-itemvolume / 1000.
                ENDIF.
              ENDIF.

              lv_material = <fs_delivery>-material.
              SHIFT lv_material LEFT DELETING LEADING '0'.

              ls_itens-material                     = lv_material.
              ls_itens-item_gross_weight            = ls_itens-item_gross_weight + <fs_delivery>-itemgrossweight.
              ls_itens-item_volume                  = ls_itens-item_volume + lv_volconvert.
              ls_itens-actual_delivery_amount       = ls_itens-actual_delivery_amount + <fs_delivery>-actualdeliveryamount.
              ls_itens-deliverydocumentitemcategory = <fs_delivery>-deliverydocumentitemcategory.

            ENDLOOP. "loop da remessa

            <fs_remessa>-itens = VALUE #( BASE <fs_remessa>-itens (
                                          material                                                = ls_itens-material
                                          original_delivery_quantity-item_gross_weight            = ls_itens-item_gross_weight
                                          original_delivery_quantity-item_volume                  = ls_itens-item_volume
                                          original_delivery_quantity-actual_delivery_amount       = ls_itens-actual_delivery_amount
                                          original_delivery_quantity-deliverydocumentitemcategory = ls_itens-deliverydocumentitemcategory ) ).

          ENDLOOP.

        ENDLOOP.

      ENDIF.

      " ----------------------------
      " Processo de envio ao ROADNET
      " ----------------------------

      TRY.
          IF ls_output IS NOT INITIAL.
            NEW zcltm_co_si_enviar_remessa( )->si_enviar_remessa( output = ls_output ).
            COMMIT WORK AND WAIT.

            LOOP AT ls_output-mt_remessa-remessas INTO DATA(ls_remessas).

              lv_vbeln = ls_remessas-delivery_document.
              lv_vbeln = |{ lv_vbeln ALPHA = IN }|.

              APPEND INITIAL LINE TO gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
              <fs_return>-id         = lc_msgid.
              <fs_return>-type       = lc_typsmsg.
              <fs_return>-number     = lc_numeber.
              <fs_return>-message_v1 = lv_vbeln.
              <fs_return>-message_v2 = <fs_session>-id_session_roadnet.

              MESSAGE ID <fs_return>-id
                 TYPE    <fs_return>-type
                 NUMBER  <fs_return>-number
                 WITH    <fs_return>-message_v1
                         <fs_return>-message_v2
                         <fs_return>-message_v3
                         <fs_return>-message_v4
                 INTO    <fs_return>-message.

              " Liberando as remessas
              DATA(lt_return) = liberar_remessa( iv_remessa = lv_vbeln ).

              IF lt_return IS NOT INITIAL.
                APPEND LINES OF lt_return TO gt_return.
              ENDIF.

            ENDLOOP.

          ENDIF.

        CATCH cx_root.
      ENDTRY.

    ENDLOOP."loop por centro

  ENDMETHOD.


  METHOD processa.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.

    DATA: ls_msg    TYPE ty_msg,
          lt_return TYPE bapiret2_tab.

    CONSTANTS: lc_typemsg TYPE bapi_mtype VALUE 'E',
               lc_msgid   TYPE symsgid VALUE 'ZTM_ROADNET_SESSION',
               lc_numeber TYPE symsgno VALUE '003'.
    TRY.
        gt_remessa = it_remessa.

        carrega_dados( ).

        criar_docreference( ).

        criar_sessao( ).

        enviar_remessa( ).

*        save_data_of( ).

*        criar_docreference( ).

      CATCH zcxtm_roadnet_session INTO DATA(lo_cx_erro).
        lt_return = lo_cx_erro->get_bapiretreturn( ).
      CATCH cx_root INTO DATA(lo_erro).

        ls_msg = lo_erro->get_text( ).

        APPEND INITIAL LINE TO lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        <fs_return>-id         = lc_msgid.
        <fs_return>-type       = lc_typemsg.
        <fs_return>-message_v1 = ls_msg-msgv1.
        <fs_return>-message_v2 = ls_msg-msgv2.
        <fs_return>-message_v3 = ls_msg-msgv3.
        <fs_return>-message_v4 = ls_msg-msgv4.

        MESSAGE ID <fs_return>-id
           TYPE    <fs_return>-type
           NUMBER  <fs_return>-number
           WITH    <fs_return>-message_v1
                   <fs_return>-message_v2
                   <fs_return>-message_v3
                   <fs_return>-message_v4
           INTO    <fs_return>-message.

    ENDTRY.

    IF gt_return IS NOT INITIAL.
      LOOP AT gt_return ASSIGNING FIELD-SYMBOL(<fs_return2>).
        APPEND INITIAL LINE TO lt_return ASSIGNING <fs_return>.
        <fs_return> = <fs_return2>.
        MESSAGE ID <fs_return>-id
           TYPE    <fs_return>-type
           NUMBER  <fs_return>-number
           WITH    <fs_return>-message_v1
                   <fs_return>-message_v2
                   <fs_return>-message_v3
                   <fs_return>-message_v4
           INTO    <fs_return>-message.
      ENDLOOP.
    ENDIF.
    save_remessa( ).

    rt_return = lt_return.

  ENDMETHOD.


  METHOD workingday.

    DATA: lv_ok      TYPE abap_bool,
          lv_dayweek TYPE cind.
    rv_data = iv_data.
    WHILE lv_ok = abap_false.

      CALL FUNCTION 'DATE_CHECK_WORKINGDAY'
        EXPORTING
          date                       = rv_data
          factory_calendar_id        = gc_calendfab
          message_type               = 'S'
        EXCEPTIONS
          date_after_range           = 1
          date_before_range          = 2
          date_invalid               = 3
          date_no_workingday         = 4
          factory_calendar_not_found = 5
          message_type_invalid       = 6
          OTHERS                     = 7.

      IF sy-subrc <> 0.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = rv_data
            days      = '1'
            months    = '0'
            signum    = '+'
            years     = '0'
          IMPORTING
            calc_date = rv_data.
      ELSE.
        CALL FUNCTION 'DATE_COMPUTE_DAY'
          EXPORTING
            date = rv_data
          IMPORTING
            day  = lv_dayweek.

***     diferente de sabado e domingo
        IF lv_dayweek NE '6' AND lv_dayweek NE '7' .
          lv_ok = abap_true.
        ENDIF.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.


  METHOD save_remessa.
    IF gt_rodremessa IS NOT INITIAL.
      MODIFY zttm_road_remess FROM TABLE gt_rodremessa.
      COMMIT WORK AND WAIT .
    ENDIF.
  ENDMETHOD.


  METHOD get_session_roadnet.
    DATA: ls_output TYPE zcltm_mt_consulta_sessao,
          ls_input  TYPE zcltm_mt_consulta_sessao_resp.


    ls_output-mt_consulta_sessao-criteria-region_identity = iv_centro.
    ls_output-mt_consulta_sessao-criteria-date_start      = iv_data.
    ls_output-mt_consulta_sessao-criteria-date_end        = iv_data.

    ls_output-mt_consulta_sessao-criteria-scenario           = 'DELIVERY'.
    ls_output-mt_consulta_sessao-criteria-description        = 'ENTREGA'.

    ls_output-mt_consulta_sessao-options-retrieve_built      = 'false'.
    ls_output-mt_consulta_sessao-options-retrieve_active     = 'false'.
    ls_output-mt_consulta_sessao-options-retrieve_equipment  = 'false'.
    ls_output-mt_consulta_sessao-options-retrieve_published  = 'true'.
    ls_output-mt_consulta_sessao-options-level               = 'rdlSession'.


    TRY.
        NEW zcltm_co_si_consulta_sessao_ou( )->si_consulta_sessao_out( EXPORTING output = ls_output
                                                                       IMPORTING input  = ls_input ).
      CATCH cx_root INTO DATA(lo_root).
    ENDTRY.

    IF ls_input-mt_consulta_sessao_resp-sessions IS NOT INITIAL.

      LOOP AT ls_input-mt_consulta_sessao_resp-sessions ASSIGNING FIELD-SYMBOL(<fs_session>).
        IF <fs_session>-session_identity-region_id = iv_centro.
          rs_session-werks = <fs_session>-session_identity-region_id.
          rs_session-dtsession = iv_data.
          rs_session-id_session_roadnet = <fs_session>-session_identity-internal_session_id.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD save_data_of.
    DATA: lo_change           TYPE REF TO /bobf/if_tra_change,
          lo_message          TYPE REF TO /bobf/if_frw_message,
          ls_rejecting_bo_key TYPE /bobf/t_frw_key2,
          lt_return           TYPE bapiret2_tab,
          lt_message          TYPE /bobf/t_frw_message_k,
          lv_rejected         TYPE boole_d,
          lo_message_save     TYPE REF TO /bobf/if_frw_message.

    IF gt_mod IS NOT INITIAL.
      DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

      lo_srv_tor->modify( EXPORTING it_modification = gt_mod
                            IMPORTING eo_change     = lo_change
                                      eo_message    = lo_message ).

      DATA(lo_tra_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

      lo_tra_mgr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                        IMPORTING ev_rejected           = lv_rejected
                                  eo_change             = lo_change
                                  eo_message            = lo_message_save
                                  et_rejecting_bo_key   = ls_rejecting_bo_key ).

      IF NOT lo_message IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        APPEND LINES OF lt_return TO gt_return.
      ENDIF.

      IF NOT lo_message_save IS INITIAL.

        CLEAR lt_return.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                               CHANGING  ct_bapiret2 = lt_return[] ).

        APPEND LINES OF lt_return TO gt_return.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD liberar_remessa.

    DATA:
      ls_header_data    TYPE bapiobdlvhdrchg,
      ls_header_control TYPE bapiobdlvhdrctrlchg.

    CONSTANTS: lc_lvblock_64 TYPE lifsk VALUE '64'.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de bloqueio 'Enviar para Liberação'. (RICEFW BD9-154F11)
* ---------------------------------------------------------------------------
    IF me->gs_parameter-lifsk_er IS INITIAL.

      DATA(ls_parameter) = VALUE ztca_param_val( modulo = gc_param_lifsk_er-modulo
                                                 chave1 = gc_param_lifsk_er-chave1
                                                 chave2 = gc_param_lifsk_er-chave2
                                                 chave3 = gc_param_lifsk_er-chave3 ).

      me->get_parameter( EXPORTING is_param  = ls_parameter
                         IMPORTING ev_value  = me->gs_parameter-lifsk_er ).

    ENDIF.

    ls_header_data-deliv_numb       = iv_remessa.
*    ls_header_data-dlv_block        = lc_lvblock_64.
    ls_header_data-dlv_block        = me->gs_parameter-lifsk_er.
    ls_header_control-deliv_numb    = iv_remessa.
    ls_header_control-dlv_block_flg = abap_true.

    TRY.
        CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
          EXPORTING
            header_data    = ls_header_data
            header_control = ls_header_control
            delivery       = iv_remessa
          TABLES
            return         = rt_messages.
        IF NOT line_exists( rt_messages[ type = 'E' ] ).
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
        ENDIF.

      CATCH cx_root INTO DATA(lo_cx_root).
        DATA(lv_msg) = lo_cx_root->get_text( ).

    ENDTRY.

  ENDMETHOD.


  METHOD get_parameter.
    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        " Recupera valor único
        IF ev_value IS SUPPLIED.
          lo_param->m_get_single( EXPORTING iv_modulo = is_param-modulo
                                            iv_chave1 = is_param-chave1
                                            iv_chave2 = is_param-chave2
                                            iv_chave3 = is_param-chave3
                                  IMPORTING ev_param  = ev_value ).
        ENDIF.
      CATCH zcxca_tabela_parametros.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
