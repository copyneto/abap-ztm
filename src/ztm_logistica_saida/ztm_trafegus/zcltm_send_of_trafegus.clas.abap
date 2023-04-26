CLASS zcltm_send_of_trafegus DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_btd_tco_73 TYPE /scmtms/btd_type_code VALUE '73' ##NO_TEXT.
    CONSTANTS gc_itmtype_truc TYPE /scmtms/tor_item_type VALUE 'TRUC' ##NO_TEXT.
    CONSTANTS gc_itmtype_trl TYPE /scmtms/tor_item_type VALUE 'TRL' ##NO_TEXT.
    CONSTANTS gc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR' ##NO_TEXT.
    CONSTANTS gc_itemcat_pvr TYPE /scmtms/item_category VALUE 'PVR' ##NO_TEXT.
    CONSTANTS gc_sign_i TYPE char1 VALUE 'I' ##NO_TEXT.
    CONSTANTS gc_option_eq TYPE char2 VALUE 'EQ' ##NO_TEXT.

    METHODS process
      IMPORTING
        !iv_key          TYPE /bobf/conf_key
        VALUE(iv_memory) TYPE abap_bool DEFAULT 'X' .
    METHODS get_data_interface
      RETURNING
        VALUE(rs_data) TYPE zmt_ordem_frete .
    METHODS send_data
      RETURNING
        VALUE(rv_ok) TYPE abap_bool .
    METHODS get_erro
      RETURNING
        VALUE(rt_return) TYPE bapiret2_tab .
  PROTECTED SECTION.


private section.

  types:
    BEGIN OF ty_vehicle,
        platenumber TYPE /scmtms/resplatenr,
      END OF ty_vehicle .

  data GS_DATA_INTERFACE type ZMT_ORDEM_FRETE .
  data GS_DATA_INTERFACE_RESP type ZMT_ORDEM_FRETE_RESP .
  data GT_RETURN type BAPIRET2_TAB .
  data GO_SRV_TOR type ref to /BOBF/IF_TRA_SERVICE_MANAGER .
  data GV_KEY type /BOBF/CONF_KEY .
  data:
    gt_tor_root TYPE STANDARD TABLE OF /scmtms/s_tor_root_k .
  data:
    gt_docreferente TYPE STANDARD TABLE OF /scmtms/s_tor_docref_k .
  data:
    gt_nf TYPE STANDARD TABLE OF j_1bnfdoc .
  data GT_STOP_FIRST_LAST type /SCMTMS/T_TOR_STOP_K .
  data:
    gt_vehicle TYPE STANDARD TABLE OF ty_vehicle .        "/scmtms/s_tor_item_tr_k.
  constants GC_NF_AUTORIZADA type J_1BNFEDOCSTATUS value '1' ##NO_TEXT.

  methods GET_DATA_ROOT
    importing
      value(IV_MEMORY) type ABAP_BOOL default 'X' .
  methods GET_DATA_DOCREFERENTE
    importing
      !IV_KEY type /BOBF/CONF_KEY .
*      RETURNING
*        VALUE(rt_doc) TYPE /scmtms/t_tor_docref_k .
  methods BUILD_DATA .
  methods CHECK_NF_OF_OK
    returning
      value(RV_OK) type ABAP_BOOL .
  methods GET_DATA_STOP
    importing
      !IV_KEY type /BOBF/CONF_KEY .
  methods GET_LOCATION
    importing
      !IV_KEY type /BOBF/CONF_KEY
      !IV_LOCID type /SCMTMS/LOCATION_ID
    exporting
      !EV_TAXJURCODE type AD_TXJCD
    returning
      value(RS_ENDERECO) type /SCMTMS/S_BO_LOC_ADDR_DETAILSK .
  methods GET_VEHICLE
    importing
      !IV_KEY type /BOBF/CONF_KEY .
  methods GET_NF_OF .
  methods EXECUTE_VEHICLE
    raising
      CX_AI_SYSTEM_FAULT .
  methods EXECUTE_TRANSP
    raising
      CX_AI_SYSTEM_FAULT .
  methods EXECUTE_DRIVER
    raising
      CX_AI_SYSTEM_FAULT .
  methods PREPARE_LOG
    importing
      !IS_LOG type ZMT_ORDEM_FRETE_RESP
      !IV_TOR_ID type /SCMTMS/TOR_ID .
ENDCLASS.



CLASS ZCLTM_SEND_OF_TRAFEGUS IMPLEMENTATION.


  METHOD build_data.

    DATA: lv_driver    TYPE bu_partner,
          lv_transp    TYPE bu_partner,
          ls_location  TYPE /scmtms/s_bo_loc_addr_detailsk,
          lv_vlrtotnfs TYPE j_1bnftot,
          lv_seq       TYPE i,
          lv_taxjur    TYPE ad_txjcd.

    CONSTANTS : lc_cnpj       TYPE bptaxtype VALUE 'BR1',
                lc_cpf        TYPE bptaxtype VALUE 'BR2',
                lc_stop_first TYPE /scmtms/stop_category VALUE 'O',
                lc_stop_last  TYPE /scmtms/stop_category VALUE 'I'.
    IF gt_tor_root IS NOT INITIAL.

      gs_data_interface-mt_ordem_frete-tor_id = gt_tor_root[ 1 ]-tor_id.
      SHIFT gs_data_interface-mt_ordem_frete-tor_id LEFT DELETING LEADING '0'.

      lv_driver = gt_tor_root[ 1 ]-zz_motorista.
      lv_transp = gt_tor_root[ 1 ]-tspid.

      SELECT
        partner,
        taxtype,
        taxnum
      FROM dfkkbptaxnum
      WHERE
        ( partner EQ @lv_driver OR partner EQ @lv_transp )
        AND ( taxtype EQ @lc_cpf OR taxtype EQ @lc_cnpj )
      INTO TABLE @DATA(lt_taxnum).

      IF sy-subrc = 0.
        SORT lt_taxnum BY partner taxtype.
      ENDIF.

      "setando a transportadora
      READ TABLE lt_taxnum
      WITH KEY partner = lv_transp
               taxtype = lc_cnpj
      ASSIGNING FIELD-SYMBOL(<fs_taxnum>) BINARY SEARCH.
      IF sy-subrc = 0.
        gs_data_interface-mt_ordem_frete-taxnumber = <fs_taxnum>-taxnum.
      ENDIF.

      "setando o motorista
      READ TABLE lt_taxnum
      WITH KEY partner = lv_driver
               taxtype = lc_cpf
      ASSIGNING <fs_taxnum> BINARY SEARCH.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO gs_data_interface-mt_ordem_frete-motoristas ASSIGNING FIELD-SYMBOL(<fs_driver>).
        <fs_driver>-taxnum = <fs_taxnum>-taxnum.
      ENDIF.

      "setando os veiculos
      LOOP AT gt_vehicle ASSIGNING FIELD-SYMBOL(<fs_vehicle>).
        APPEND INITIAL LINE TO gs_data_interface-mt_ordem_frete-veiculos ASSIGNING FIELD-SYMBOL(<fs_veiculo>).
        <fs_veiculo>-platenumber = <fs_vehicle>-platenumber.
      ENDLOOP.

      LOOP AT gt_stop_first_last ASSIGNING FIELD-SYMBOL(<fs_stop>).
        CLEAR ls_location.

        "setando a origem
        IF <fs_stop>-stop_cat = lc_stop_first.
          CLEAR lv_taxjur.
          ls_location = get_location( EXPORTING iv_key = <fs_stop>-root_key  iv_locid = <fs_stop>-log_locid
                                      IMPORTING ev_taxjurcode  =  lv_taxjur
                                     ).

          gs_data_interface-mt_ordem_frete-origem-city_name          = |{ <fs_stop>-log_locid }| & | | & |{ ls_location-name1 }|.
          gs_data_interface-mt_ordem_frete-origem-street_name        = ls_location-street_name.
          gs_data_interface-mt_ordem_frete-origem-house_id           = ls_location-house_id.
          gs_data_interface-mt_ordem_frete-origem-street_postal_code = ls_location-street_postal_code.
          gs_data_interface-mt_ordem_frete-origem-adrnummer          = ls_location-house_id.

          gs_data_interface-mt_ordem_frete-origem-name2              = ls_location-name2.
          gs_data_interface-mt_ordem_frete-origem-region             = ls_location-region.
          gs_data_interface-mt_ordem_frete-origem-country_code       = ls_location-country_code.

          IF strlen( lv_taxjur ) >= 10.
            gs_data_interface-mt_ordem_frete-origem-taxjurcode = lv_taxjur+3(7).
          ENDIF.

          gs_data_interface-mt_ordem_frete-destino-city_name          = |{ <fs_stop>-log_locid }| & | | & |{ ls_location-name1 }|.
          gs_data_interface-mt_ordem_frete-destino-street_name        = ls_location-street_name.
          gs_data_interface-mt_ordem_frete-destino-house_id           = ls_location-house_id.
          gs_data_interface-mt_ordem_frete-destino-street_postal_code = ls_location-street_postal_code.
          gs_data_interface-mt_ordem_frete-destino-adrnummer          = ls_location-house_id.

          gs_data_interface-mt_ordem_frete-destino-name2              = ls_location-name2.
          gs_data_interface-mt_ordem_frete-destino-region             = ls_location-region.
          gs_data_interface-mt_ordem_frete-destino-country_code       = ls_location-country_code.

          IF strlen( lv_taxjur ) >= 10.
            gs_data_interface-mt_ordem_frete-origem-taxjurcode  = lv_taxjur+3(7).
          ENDIF.
        ENDIF.

*        "Setando o destino
*        IF <fs_stop>-stop_cat = lc_stop_last.
*          CLEAR lv_taxjur.
*          ls_location = get_location( EXPORTING iv_key = <fs_stop>-root_key iv_locid = <fs_stop>-log_locid
*                                      IMPORTING ev_taxjurcode  =  lv_taxjur
*                                     ).
*          gs_data_interface-mt_ordem_frete-destino-city_name   = ls_location-city_name.
*          gs_data_interface-mt_ordem_frete-destino-street_name     = ls_location-street_name.
*          gs_data_interface-mt_ordem_frete-destino-house_id = ls_location-house_id.
*          gs_data_interface-mt_ordem_frete-destino-street_postal_code  = ls_location-street_postal_code.
*          gs_data_interface-mt_ordem_frete-destino-adrnummer             = ls_location-house_id.
*
*          gs_data_interface-mt_ordem_frete-destino-name2 = ls_location-name2.
*          gs_data_interface-mt_ordem_frete-destino-region  = ls_location-region.
*          gs_data_interface-mt_ordem_frete-destino-country_code = ls_location-country_code.
*          IF strlen( lv_taxjur ) >= 10.
*            gs_data_interface-mt_ordem_frete-origem-taxjurcode = lv_taxjur+3(7).
*          ENDIF.
*        ENDIF.

      ENDLOOP.

      IF gt_nf IS NOT INITIAL.
        SELECT
          a~partner,
          b~date_from,
          b~taxjurcode
        FROM but020 AS a INNER JOIN adrc AS b
        ON  b~addrnumber = a~addrnumber
        FOR ALL ENTRIES IN @gt_nf
        WHERE
          a~partner = @gt_nf-parid
        INTO TABLE @DATA(lt_adrc).

        IF sy-subrc = 0.
          SORT lt_adrc BY partner ASCENDING date_from DESCENDING.
        ENDIF.
      ENDIF.

      lv_seq = 1.
      LOOP AT gt_nf ASSIGNING FIELD-SYMBOL(<fs_nf>).
        lv_vlrtotnfs = lv_vlrtotnfs + <fs_nf>-nftot.

        APPEND INITIAL LINE TO gs_data_interface-mt_ordem_frete-locais ASSIGNING FIELD-SYMBOL(<fs_locais>).
        <fs_locais>-name1      = <fs_nf>-name1.
        <fs_locais>-parid      = <fs_nf>-parid.
        <fs_locais>-street     = <fs_nf>-street.
        <fs_locais>-house_num1 = <fs_nf>-house_num1.
        <fs_locais>-house_num2 = <fs_nf>-house_num2.
        <fs_locais>-pstlz      = <fs_nf>-pstlz.

        REPLACE ALL OCCURRENCES OF '-' IN <fs_locais>-pstlz WITH space.
        CONDENSE <fs_locais>-pstlz NO-GAPS.

        <fs_locais>-ort02 = <fs_nf>-ort02.
        READ TABLE lt_adrc
        WITH KEY partner = <fs_nf>-parid
        BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_adrc>).
        IF sy-subrc = 0.
          IF strlen( <fs_adrc>-taxjurcode ) >= 10.
            <fs_locais>-txjcd = <fs_adrc>-taxjurcode+3(7).
          ENDIF.
        ENDIF.
        <fs_locais>-regio = <fs_nf>-regio.
        <fs_locais>-land1 = <fs_nf>-land1.

        APPEND INITIAL LINE TO <fs_locais>-conhecimentos ASSIGNING FIELD-SYMBOL(<fs_know>).
        <fs_know>-sequencial = lv_seq.
        lv_seq = lv_seq + 1.
        <fs_know>-nftot = <fs_nf>-nftot.

        IF <fs_nf>-cgc IS NOT INITIAL.
          <fs_know>-cgc = <fs_nf>-cgc.
        ELSE.
          <fs_know>-cgc = <fs_nf>-cpf.
        ENDIF.

        APPEND INITIAL LINE TO <fs_know>-notas_fiscais ASSIGNING FIELD-SYMBOL(<fs_notas>).
        <fs_notas>-nfenum = <fs_nf>-nfenum.
        <fs_notas>-nftot  = <fs_nf>-nftot.
        CONCATENATE <fs_nf>-docdat <fs_nf>-cretim INTO <fs_notas>-dtfaturamento.
      ENDLOOP.
      gs_data_interface-mt_ordem_frete-amt_gdsv_val = lv_vlrtotnfs.
    ENDIF.

  ENDMETHOD.


  METHOD check_nf_of_ok.
    rv_ok = abap_true.
    LOOP AT gt_nf ASSIGNING FIELD-SYMBOL(<fs_nf>).
      IF <fs_nf>-docstat NE gc_nf_autorizada AND <fs_nf>-cancel = abap_true.
        rv_ok = abap_false.
        APPEND LINES OF NEW zcxtm_send_of_trafegus(
                                                textid      = zcxtm_send_of_trafegus=>existe_nf_nao_autorizada
                                              )->get_bapiretreturn( )
                       TO gt_return.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_data_docreferente.
    DATA: lt_key    TYPE /bobf/t_frw_key,
          lt_docref TYPE /scmtms/t_tor_docref_k,
          lt_aux    TYPE STANDARD TABLE OF /scmtms/s_tor_docref_k.

    IF go_srv_tor IS NOT INITIAL.
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_key CHANGING ct_key = lt_key ).

      go_srv_tor->retrieve_by_association(
                                           EXPORTING
                                             iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                             it_key                  = lt_key
                                             iv_association          = /scmtms/if_tor_c=>sc_association-root-docreference
                                             iv_fill_data            = abap_true
                                           IMPORTING
                                             et_data                 = lt_docref
                                          ).

      lt_aux = lt_docref.
      SORT lt_aux BY btd_tco.

      READ TABLE lt_aux
      WITH KEY btd_tco = gc_btd_tco_73
      TRANSPORTING NO FIELDS BINARY SEARCH.
      IF sy-subrc = 0.

        LOOP AT lt_aux FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_aux>).
          IF <fs_aux>-btd_tco NE gc_btd_tco_73.
            EXIT.
          ENDIF.
          APPEND INITIAL LINE TO gt_docreferente ASSIGNING FIELD-SYMBOL(<fs_doc_ref>).
          <fs_doc_ref> = <fs_aux>.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_data_interface.
    rs_data = gs_data_interface.
  ENDMETHOD.


  METHOD get_data_root.

    DATA: lt_tor_root_key TYPE /bobf/t_frw_key,
          lt_filtro       TYPE /bobf/t_frw_key,
          lt_root         TYPE /scmtms/t_tor_root_k.



    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = gv_key CHANGING ct_key = lt_tor_root_key ).

    IF iv_memory EQ abap_true.

      go_srv_tor->retrieve(
                             EXPORTING
                                 it_key        = lt_tor_root_key
                                 iv_node_key   = /scmtms/if_tor_c=>sc_node-root
                             IMPORTING
                                 et_data       = lt_root
                             ).

    ELSE.

      APPEND INITIAL LINE TO lt_filtro ASSIGNING FIELD-SYMBOL(<fs_filtro>).
      <fs_filtro>-key = gv_key.

      go_srv_tor->query(
        EXPORTING
          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
          it_filter_key           = lt_filtro
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_root
      ).
    ENDIF.
    "lt_root já é ordenado pela chave
    gt_tor_root = lt_root.
  ENDMETHOD.


  METHOD get_data_stop.
    DATA: lt_key    TYPE /bobf/t_frw_key.

    IF go_srv_tor IS NOT INITIAL.

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_key CHANGING ct_key = lt_key ).

      go_srv_tor->retrieve_by_association(
                                           EXPORTING
                                             iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                             it_key                  = lt_key
                                             iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first_and_last
                                             iv_fill_data            = abap_true
                                           IMPORTING
                                             et_data                 = gt_stop_first_last
                                          ).
    ENDIF.


  ENDMETHOD.


  METHOD get_erro.
    rt_return = gt_return.
  ENDMETHOD.


  METHOD get_location.

    DATA: lt_endereco   TYPE /scmtms/t_bo_loc_addr_detailsk,
          lt_key        TYPE /bobf/t_frw_key,
          lt_rootloc    TYPE /scmtms/t_bo_loc_root_k,
          lt_parameters TYPE /bobf/t_frw_query_selparam.

    IF go_srv_tor IS NOT INITIAL.

      DATA(lo_srv_loc) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key ).

      APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
      <fs_parameters>-attribute_name = /scmtms/if_location_c=>sc_query_attribute-root-query_by_identifier-location_id. "root-root_elements-tor_id.
      <fs_parameters>-sign   = gc_sign_i.
      <fs_parameters>-option = gc_option_eq.
      <fs_parameters>-low    = iv_locid.

      lo_srv_loc->query(
                       EXPORTING
                         iv_query_key            = /scmtms/if_location_c=>sc_query-root-query_by_identifier
                         it_selection_parameters = lt_parameters
                         iv_fill_data            = abap_true
                       IMPORTING
                         et_key                  = lt_key
                         et_data                 = lt_rootloc
                    ).


      IF lt_rootloc IS NOT INITIAL.

        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = lt_rootloc[ 1 ]-root_key CHANGING ct_key = lt_key ).

        lo_srv_loc->retrieve_by_association(
                                               EXPORTING
                                                 iv_node_key             = /scmtms/if_location_c=>sc_node-root
                                                 it_key                  = lt_key
                                                 iv_association          = /scmtms/if_location_c=>sc_association-root-selected_address_details
                                                 iv_fill_data            = abap_true
                                               IMPORTING
                                                 et_data                 = lt_endereco
                                              ).
        IF lt_endereco IS NOT INITIAL.
          rs_endereco = lt_endereco[ 1 ].

          DATA(lv_adrcnumber) = lt_rootloc[ 1 ]-adrnummer.

          SELECT
                 addrnumber,
                 date_from,
                 nation,
                 taxjurcode
          FROM adrc
          WHERE addrnumber = @lv_adrcnumber
*          ORDER BY date_from DESCENDING , nation DESCENDING

          INTO TABLE @DATA(lt_end).
*          UP TO 1 ROWS.

          IF sy-subrc = 0.
            SORT lt_end BY date_from DESCENDING nation DESCENDING.
            ev_taxjurcode = lt_end[ 1 ]-taxjurcode.
          ENDIF.

        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_nf_of.
    DATA: lv_vbeln   TYPE vbeln,
          lt_docflow TYPE tdt_docflow,
          lr_vf      TYPE RANGE OF vbeln_vf,
          lv_aux     TYPE /scmtms/btd_id.

    CONSTANTS: lc_fatura TYPE vbtypl VALUE 'M'.

    IF gt_docreferente IS NOT INITIAL.

      LOOP AT gt_docreferente ASSIGNING FIELD-SYMBOL(<fs_docref>).
        CLEAR lt_docflow.

        lv_aux = <fs_docref>-btd_id.
        SHIFT lv_aux LEFT DELETING LEADING '0'.
        lv_vbeln = lv_aux.
        UNPACK lv_vbeln TO lv_vbeln.
        CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
          EXPORTING
            iv_docnum  = lv_vbeln
          IMPORTING
            et_docflow = lt_docflow.

        SORT lt_docflow BY vbtyp_n.

        READ TABLE lt_docflow
        WITH KEY vbtyp_n = lc_fatura
        ASSIGNING FIELD-SYMBOL(<fs_docflow>) BINARY SEARCH.

        IF sy-subrc = 0.
          APPEND INITIAL LINE TO lr_vf ASSIGNING FIELD-SYMBOL(<fs_r_vbrk>).
          <fs_r_vbrk>-sign   = gc_sign_i.
          <fs_r_vbrk>-option = gc_option_eq.
          <fs_r_vbrk>-low    = <fs_docflow>-vbeln.
        ENDIF.

      ENDLOOP.

      IF lr_vf IS NOT INITIAL.

        SELECT
          c~docnum,
          c~inco2,
          c~street,
          c~house_num2,
          c~pstlz,
          c~house_num1,
          c~ort02,
          c~txjcd,
          c~regio,
          c~land1,
          c~cgc,
          c~cpf,
          c~nftot,
          c~nfenum,
          c~docdat,
          c~cretim,
          c~parid,
          c~name1
        FROM vbrk AS a INNER JOIN j_1bnflin AS b
        ON
          b~refkey = a~vbeln
        INNER JOIN j_1bnfdoc AS c
        ON
          c~docnum = b~docnum
        WHERE
          a~fksto = @abap_false
          AND a~vbeln IN @lr_vf
        INTO TABLE @DATA(lt_sql).

        gt_nf = CORRESPONDING #( lt_sql ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_vehicle.

    DATA: lt_itemtr TYPE /scmtms/t_tor_item_tr_k,
          lt_key    TYPE /bobf/t_frw_key.
    IF go_srv_tor IS NOT INITIAL.

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_key CHANGING ct_key = lt_key ).

      go_srv_tor->retrieve_by_association(
           EXPORTING
             iv_node_key             = /scmtms/if_tor_c=>sc_node-root
             it_key                  = lt_key
             iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
             iv_fill_data            = abap_true
           IMPORTING
             et_data                 = lt_itemtr
         ).

      LOOP AT lt_itemtr ASSIGNING FIELD-SYMBOL(<fs_itemtr>).
        IF <fs_itemtr>-item_cat EQ gc_itemcat_avr "CAVALO
          OR <fs_itemtr>-item_cat EQ gc_itemcat_pvr. "CARRETA - Recurso passivo
          APPEND INITIAL LINE TO gt_vehicle ASSIGNING FIELD-SYMBOL(<fs_vehicle>).
          <fs_vehicle>-platenumber = <fs_itemtr>-platenumber.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD process.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg    TYPE ty_msg.

    TRY.
        go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
        gv_key = iv_key.

        get_data_root( iv_memory ).
        IF gt_tor_root IS NOT INITIAL.

          get_data_docreferente( iv_key = gt_tor_root[ 1 ]-root_key ).

          get_nf_of( ).

          IF check_nf_of_ok( ) EQ abap_true.
            get_vehicle( iv_key   =  gt_tor_root[ 1 ]-root_key ).
            get_data_stop( iv_key = gt_tor_root[ 1 ]-root_key ).
            build_data( ).
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(lo_cx_root).
        ls_msg = lo_cx_root->get_text( ).

        APPEND LINES OF NEW zcxtm_send_of_trafegus(
                                                 textid      = zcxtm_send_of_trafegus=>zcxtm_send_of_trafegus
                                                 gv_msgv1    = ls_msg-msgv1
                                                 gv_msgv2    = ls_msg-msgv2
                                                 gv_msgv3    = ls_msg-msgv3
                                                 gv_msgv4    = ls_msg-msgv4
                                               )->get_bapiretreturn( )
                        TO gt_return.
    ENDTRY.



  ENDMETHOD.


  METHOD send_data.

    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg    TYPE ty_msg.

    TRY.
        IF gs_data_interface IS NOT INITIAL.
          execute_vehicle( ).
          execute_transp( ).
          execute_driver( ).
*          NEW zco_si_enviar_ordem_frete_out( )->si_enviar_ordem_frete_out( output = gs_data_interface  ).
          NEW zco_si_enviar_ordem_frete_out( )->si_enviar_ordem_frete_out( EXPORTING output = gs_data_interface
                                                                           IMPORTING input  = gs_data_interface_resp ).

          prepare_log( EXPORTING is_log    = gs_data_interface_resp
                                 iv_tor_id = CONV /scmtms/tor_id( gs_data_interface-mt_ordem_frete-tor_id ) ).

          rv_ok = abap_true.
        ENDIF.
      CATCH cx_ai_system_fault INTO DATA(lo_erro). " Erro de comunicação .
        rv_ok = abap_false.
        ls_msg = lo_erro->get_text( ).

        APPEND LINES OF NEW zcxtm_send_of_trafegus(
                                                 textid      = zcxtm_send_of_trafegus=>zcxtm_send_of_trafegus
                                                 gv_msgv1    = ls_msg-msgv1
                                                 gv_msgv2    = ls_msg-msgv2
                                                 gv_msgv3    = ls_msg-msgv3
                                                 gv_msgv4    = ls_msg-msgv4
                                               )->get_bapiretreturn( )
                        TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD execute_vehicle.

    DATA: ls_veiculos TYPE zstm_dt_equipamentos_veiculo_v,
          ls_output   TYPE zstm_mt_equipamentos_veiculo,
          lr_veiculo  TYPE RANGE OF equi-eqart.

    CHECK gt_vehicle IS NOT INITIAL.
    SORT gt_vehicle BY platenumber.

    SELECT equip~equnr, equip~eqart , equip_text~eqktx
      FROM equi AS equip
      INNER JOIN eqkt AS equip_text ON equip~equnr = equip_text~equnr
      AND equip_text~spras = @sy-langu
      INTO TABLE @DATA(lt_veiculo)
      FOR ALL ENTRIES IN @gt_vehicle
      WHERE equip~equnr EQ @gt_vehicle-platenumber(18).

    LOOP AT lt_veiculo ASSIGNING FIELD-SYMBOL(<fs_veiculo>).

      TRY.
          DATA(lo_param) = NEW zclca_tabela_parametros( ).

          lo_param->m_get_range(
            EXPORTING
              iv_modulo = 'TM'
              iv_chave1 = 'TRAFEGUS'
              iv_chave2 = 'TIPOVEICULO'
            IMPORTING
              et_range  = lr_veiculo
          ).
        CATCH zcxca_tabela_parametros.
      ENDTRY.

      ls_veiculos-platenumber = <fs_veiculo>-equnr.
      READ TABLE lr_veiculo WITH KEY low = <fs_veiculo>-eqart INTO DATA(ls_tipo_veiculo). "#EC CI_STDSEQ
      ls_veiculos-tures_tco = ls_tipo_veiculo-high.
      APPEND ls_veiculos TO ls_output-mt_equipamentos_veiculo-vehicle.
      NEW zcltm_co_si_enviar_equipamento( )->si_enviar_equipamentos_veiculo( output = ls_output ).
    ENDLOOP.

  ENDMETHOD.


  METHOD execute_transp.
    DATA(lv_businesspartner_transp) = CONV bu_partner( gt_tor_root[ 1 ]-tspid ).
    SELECT SINGLE
      businesspartner,
      bptaxnumber,
      businesspartnername
      FROM zi_tm_get_transp
      INTO @DATA(ls_transportador)
      WHERE businesspartner = @lv_businesspartner_transp.

    IF ls_transportador-businesspartnername IS NOT INITIAL.

      NEW zclbp_co_si_enviar_business_pa( )->si_enviar_business_partner_out( output = VALUE #(
        mt_business_partner-businesspartnername           = ls_transportador-businesspartnername
        mt_business_partner-partnerexternal-results       = VALUE #( ( partnerexternal = TEXT-001 && sy-sysid+2(1) ) )
        mt_business_partner-to_businesspartnertax-results = VALUE #( ( bptaxnumber = ls_transportador-bptaxnumber ) )
        mt_business_partner-to_businesspartnerrole-results = VALUE #( ( businesspartnerrole = 'CRM010' ) )
      ) ).

    ENDIF.

  ENDMETHOD.


  METHOD execute_driver.
    DATA(lv_businesspartner_driver) = CONV bu_partner( gt_tor_root[ 1 ]-zz_motorista ).
    SELECT SINGLE
      businesspartner,
      bptaxnumber,
      businesspartnername
      FROM zi_tm_get_motorista1
      INTO @DATA(ls_transportador)
      WHERE businesspartner = @lv_businesspartner_driver.

    IF ls_transportador-businesspartnername IS NOT INITIAL.

      NEW zclbp_co_si_enviar_business_pa( )->si_enviar_business_partner_out( output = VALUE #(
        mt_business_partner-firstname                     = ls_transportador-businesspartnername
        mt_business_partner-partnerexternal-results       = VALUE #( ( partnerexternal = TEXT-002 && sy-sysid+2(1) ) )
        mt_business_partner-to_businesspartnertax-results = VALUE #( ( bptaxnumber = ls_transportador-bptaxnumber ) )
        mt_business_partner-businesspartnertype = '0011'
      ) ).

    ENDIF.

  ENDMETHOD.


  METHOD prepare_log.

    DATA: lt_log      TYPE TABLE OF zttm_trafegus_l,
          ls_log      TYPE zttm_trafegus_l,
          lv_cont_itf TYPE ze_trafegus_contador_itf,
          lv_cont_msg TYPE ze_trafegus_contador_msg.

    SELECT tor_id,
           contador_itf
      FROM zttm_trafegus_l
      INTO TABLE @DATA(lt_trafegus)
      WHERE tor_id EQ @iv_tor_id.

    IF sy-subrc IS INITIAL.
      SORT lt_trafegus DESCENDING BY contador_itf.
      lv_cont_itf = lt_trafegus[ 1 ]-contador_itf.
    ENDIF.

    CLEAR: lv_cont_msg.
    ADD 10 TO lv_cont_itf.

    IF is_log-mt_ordem_frete_resp-error[] IS NOT INITIAL.

*      LOOP AT is_log-mt_ordem_frete_resp-error INTO DATA(ls_error).
      LOOP AT is_log-mt_ordem_frete_resp-error ASSIGNING FIELD-SYMBOL(<fs_error>).

        APPEND INITIAL LINE TO lt_log ASSIGNING FIELD-SYMBOL(<fs_log>).
        MOVE-CORRESPONDING <fs_error> TO <fs_log>.

        ADD 1 TO lv_cont_msg.

        <fs_log>-contador_msg  = lv_cont_msg.
        <fs_log>-client        = sy-mandt.
        <fs_log>-tor_id        = |{ iv_tor_id ALPHA = IN }|.
        <fs_log>-contador_itf  = lv_cont_itf.
        <fs_log>-tipo_mensagem = if_xo_const_message=>error.
        <fs_log>-created_by    = sy-uname.

        CONVERT DATE sy-datum
                TIME sy-uzeit
                INTO TIME STAMP <fs_log>-created_at
                TIME ZONE sy-zonlo.

      ENDLOOP.
    ENDIF.

    IF is_log-mt_ordem_frete_resp-success[] IS NOT INITIAL.

*      LOOP AT is_log-mt_ordem_frete_resp-success INTO DATA(ls_success).
      LOOP AT is_log-mt_ordem_frete_resp-success ASSIGNING FIELD-SYMBOL(<fs_success>).

        APPEND INITIAL LINE TO lt_log ASSIGNING <fs_log>.
        MOVE-CORRESPONDING <fs_success> TO <fs_log>.

        ADD 1 TO lv_cont_msg.

        <fs_log>-contador_msg  = lv_cont_msg.
        <fs_log>-client        = sy-mandt.
        <fs_log>-tor_id        = |{ iv_tor_id ALPHA = IN }|.
        <fs_log>-contador_itf  = lv_cont_itf.
        <fs_log>-tipo_mensagem = if_xo_const_message=>success.
        <fs_log>-mensagem      = <fs_success>-status.
        <fs_log>-created_by    = sy-uname.

        CONVERT DATE sy-datum
                TIME sy-uzeit
                INTO TIME STAMP <fs_log>-created_at
                TIME ZONE sy-zonlo.

      ENDLOOP.
    ENDIF.

    IF is_log-mt_ordem_frete_resp-sucesso[] IS NOT INITIAL.

*      LOOP AT is_log-mt_ordem_frete_resp-sucesso INTO DATA(ls_successo).
      LOOP AT is_log-mt_ordem_frete_resp-sucesso ASSIGNING FIELD-SYMBOL(<fs_successo>).

        APPEND INITIAL LINE TO lt_log ASSIGNING <fs_log>.
        MOVE-CORRESPONDING <fs_successo> TO <fs_log>.

        ADD 1 TO lv_cont_msg.

        <fs_log>-contador_msg  = lv_cont_msg.
        <fs_log>-client        = sy-mandt.
        <fs_log>-tor_id        = |{ iv_tor_id ALPHA = IN }|.
        <fs_log>-contador_itf  = lv_cont_itf.
        <fs_log>-tipo_mensagem = if_xo_const_message=>success.
        <fs_log>-mensagem      = <fs_successo>-status.
        <fs_log>-created_by    = sy-uname.

        CONVERT DATE sy-datum
                TIME sy-uzeit
                INTO TIME STAMP <fs_log>-created_at
                TIME ZONE sy-zonlo.

      ENDLOOP.
    ENDIF.

    IF lt_log[] IS NOT INITIAL.

      MODIFY zttm_trafegus_l FROM TABLE lt_log.

*      IF sy-subrc IS INITIAL.
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*          EXPORTING
*            wait = abap_true.
*      ELSE.
*        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
