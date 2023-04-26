"!<p><h2>Seleção de dados de ordens de frete utilizada na CDS <em>ZI_TM_ORDENS_FRETE</em></h2></p>
"!<p><strong>Autor:</strong>Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong>21 de out de 2021</p>
CLASS zcltm_query_ordens_frete DEFINITION
  PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider,
      if_amdp_marker_hdb,
      if_oo_adt_classrun.

    TYPES:
      "Tipo de retorno de dados à custom entity
      ty_ordens_frete TYPE STANDARD TABLE OF zi_tm_ordens_frete.

    METHODS:
      "! Ler as informações das ordens de frete utilizando o BOPF
      "! @parameter ct_ordens |Lista com as ordens de frete
      get_data CHANGING ct_ordens TYPE ty_ordens_frete.
  PRIVATE SECTION.

    TYPES:
      "Cálculo do nº de notas válidas na ordem de frete
      BEGIN OF ty_numnotas,
        parent_key TYPE /bobf/conf_key,
        notas      TYPE i,
      END OF ty_numnotas,
      "Tipo tabela para o tipo <em>TY_NUMNOTAS</em>
      ty_numnotas_t TYPE SORTED TABLE OF ty_numnotas WITH UNIQUE KEY parent_key,

      "Dados da região de origem e destino da ordem de frete
      BEGIN OF ty_regiao,
        partner      TYPE /bofu/cv_bp_addressinformation-partner,
        addrnumber   TYPE /bofu/cv_bp_addressinformation-addrnumber,
        partner_guid TYPE /bofu/cv_bp_addressinformation-partner_guid,
        region       TYPE adrc-region,
      END OF ty_regiao,
      "Tipo tabela para <em>TY_REGIAO</em>
      ty_regiao_t TYPE SORTED TABLE OF ty_regiao WITH NON-UNIQUE KEY partner_guid,

      "Dados do nome do motorista que consta na ordem de frete
      BEGIN OF ty_nome,
        partner      TYPE /bofu/cv_bp_addressinformation-partner,
        addrnumber   TYPE /bofu/cv_bp_addressinformation-addrnumber,
        partner_guid TYPE /bofu/cv_bp_addressinformation-partner_guid,
        name1        TYPE adrc-name1,
      END OF ty_nome,
      "Tipo tabela do tipo <em>TY_NOME</em>
      ty_nome_t TYPE SORTED TABLE OF ty_nome WITH NON-UNIQUE KEY partner_guid.

    METHODS:
      "! Contagem de notas fiscais válidas para as remessas
      "! @parameter it_remessas |Lista com as remessas a serem processadas
      "! @parameter et_numnotas |Tabela com o nº de notas válidas por remessa
      amdp_contar_notas IMPORTING VALUE(it_remessas) TYPE /scmtms/t_tor_docref_k
                        EXPORTING VALUE(et_numnotas) TYPE ty_numnotas_t.
ENDCLASS.



CLASS zcltm_query_ordens_frete IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    TYPES ty_ordens TYPE STANDARD TABLE OF zi_tm_ordens_frete WITH EMPTY KEY.

    DATA: lt_dados TYPE STANDARD TABLE OF zi_tm_ordens_frete WITH EMPTY KEY.


    get_data( CHANGING ct_ordens = lt_dados ).

    "Filtrar dados conforme requisito de entrada
    DATA(lo_filter) = io_request->get_filter( ).
    TRY.
        DATA(lv_filtro) = lo_filter->get_as_sql_string( ).

        IF lv_filtro IS NOT INITIAL.
          SELECT * FROM @lt_dados AS dados
              WHERE (lv_filtro)
              INTO TABLE @lt_dados.
        ENDIF.

      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    "Realizar ordenação de acordo com parâmetros de entrada
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).
    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_dados BY (lt_sort).
    ENDIF.

    "Fazer paginação
    DATA(lo_paging)   = io_request->get_paging( ).
    DATA(lv_offset)   = lo_paging->get_offset( ).
    DATA(lv_num_recs) = lo_paging->get_page_size( ).

    TRY.
        DATA(lt_dados_finais) = VALUE ty_ordens( FOR lv_count = 1 WHILE lv_count <= lv_num_recs ( CORRESPONDING #( lt_dados[ lv_count + lv_offset ] ) ) ).
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    "
    "Preparar estrutura de 'response'
    TRY.
        io_response->set_data( it_data = lt_dados_finais ).
        io_response->set_total_number_of_records( iv_total_number_of_records = lines( lt_dados ) ).
      CATCH cx_rap_query_response_set_twic.
    ENDTRY.
  ENDMETHOD.


  METHOD get_data.

    DATA: lt_root      TYPE /scmtms/t_tor_root_k,
          lt_placas    TYPE /scmtms/t_tor_item_tr_k,
          lt_remessas  TYPE /scmtms/t_tor_docref_k,
          lt_drivers   TYPE /scmtms/t_tor_party_k,
          lt_uforigem  TYPE ty_regiao_t,
          lt_ufdestino TYPE ty_regiao_t,
          lt_names     TYPE ty_nome_t.


    "Service Manager
    DATA(lo_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    "Parâmetros do nó ROOT
    DATA(lt_selpar) = VALUE /bobf/t_frw_query_selparam( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-manifested
                                                          sign = 'I' option = 'EQ' low = '' )
                                                        ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-execution
                                                          sign = 'I' option = 'EQ' low = '03' ) ).
    "Execução da query
    lo_srv_mgr->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                                 it_selection_parameters = lt_selpar
                                 iv_fill_data            = abap_true
                       IMPORTING et_data                 = lt_root ).

    "Definição das chaves do ROOT
    DATA(lt_keys) = VALUE /bobf/t_frw_key( FOR ls_root IN lt_root ( key = ls_root-key ) ).

    "Seleção das placas
    DATA(lt_filter) = VALUE /scmtms/s_tor_c_cat_specific( categories = VALUE /scmtms/t_item_cat( ( 'AVR' ) ) ).
    lo_srv_mgr->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   it_key         = lt_keys
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr_cat_specific
                                                   is_parameters  = REF #( lt_filter )
                                                   iv_fill_data   = abap_true
                                         IMPORTING et_data        = lt_placas ).

    "Obter remessas
    lo_srv_mgr->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   it_key         = lt_keys
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
                                                   iv_fill_data   = abap_true
                                         IMPORTING et_data        = lt_remessas ).
    DELETE lt_remessas WHERE btd_tco <> '73'.

    "Contagem de notas válidas
    amdp_contar_notas( EXPORTING it_remessas = lt_remessas
                       IMPORTING et_numnotas = DATA(lt_numnotas) ).

    "UF de Origem
    lo_srv_mgr->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   it_key         = lt_keys
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-bupa_ship_root
                                         IMPORTING et_key_link = DATA(lt_bupa_keys) ).
    lt_keys = VALUE /bobf/t_frw_key( FOR ls_keys IN lt_bupa_keys ( key = ls_keys-target_key ) ).

    IF lines( lt_keys ) > 0.
      SELECT a~partner, a~addrnumber, a~partner_guid, b~region
          FROM /bofu/cv_bp_addressinformation AS a
          LEFT JOIN adrc AS b ON b~addrnumber = a~addrnumber
          FOR ALL ENTRIES IN @lt_keys
          WHERE a~partner_guid = @lt_keys-key
          INTO TABLE @lt_uforigem.
    ENDIF.

    "Seleção dos motoristas
    DATA(lt_filter_drivers) = VALUE /scmtms/s_tor_c_bupa_rc( party_rco = 'ZM' ).
    lo_srv_mgr->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   it_key         = lt_keys
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-party_with_rc
                                                   is_parameters  = REF #( lt_filter_drivers )
                                                   iv_fill_data   = abap_true
                                         IMPORTING et_data        = lt_drivers ).
    IF lines( lt_drivers ) > 0.
      SELECT a~partner, a~addrnumber, a~partner_guid, b~name1
          FROM /bofu/cv_bp_addressinformation AS a
          LEFT JOIN adrc AS b ON b~addrnumber = a~addrnumber
          FOR ALL ENTRIES IN @lt_drivers
          WHERE a~partner_guid = @lt_drivers-party_uuid
          INTO TABLE @lt_names.
    ENDIF.

    "UF de destino
    lo_srv_mgr->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                   it_key         = lt_keys
                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-stop_last
                                         IMPORTING et_key_link = DATA(lt_stop_keys) ).
    lt_keys = VALUE /bobf/t_frw_key( FOR ls_keys IN lt_stop_keys ( key = ls_keys-target_key ) ).

    IF lines( lt_keys ) > 0.
      SELECT a~partner, a~addrnumber, a~partner_guid, b~region
          FROM /bofu/cv_bp_addressinformation AS a
          LEFT JOIN adrc AS b ON b~addrnumber = a~addrnumber
          FOR ALL ENTRIES IN @lt_keys
          WHERE a~partner_guid = @lt_keys-key
          INTO TABLE @lt_ufdestino.
    ENDIF.

    "
    "Relacionar todos os dados lidos acima na estrutura final.
    LOOP AT lt_root ASSIGNING FIELD-SYMBOL(<fs_root>).
      APPEND INITIAL LINE TO ct_ordens ASSIGNING FIELD-SYMBOL(<fs_ordem>).

      <fs_ordem>-ordemfrete     = <fs_root>-tor_id.
      <fs_ordem>-localexpedicao = <fs_root>-shipperid.

      TRY.
          <fs_ordem>-placa = lt_placas[ KEY parent_key COMPONENTS parent_key = <fs_root>-key ]-platenumber.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      TRY.
          <fs_ordem>-QtdNotas = lt_numnotas[ parent_key = <fs_root>-key ]-notas.
        CATCH cx_sy_itab_line_not_found.
          <fs_ordem>-QtdNotas = 0.
      ENDTRY.

      TRY.
          DATA(ls_bupa_key) = lt_bupa_keys[ source_key = <fs_root>-key ].
          <fs_ordem>-ufinicio = <fs_ordem>-regiao = lt_uforigem[ partner_guid = ls_bupa_key-target_key ]-region.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      TRY.
          DATA(ls_driver) = lt_drivers[ KEY parent_key COMPONENTS parent_key = <fs_root>-key ].
          <fs_ordem>-bpmotorista   = ls_driver-party_id.
          <fs_ordem>-nomemotorista = lt_names[ partner_guid = ls_driver-party_uuid ]-name1.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      TRY.
          DATA(ls_stop_key) = lt_stop_keys[ source_key = <fs_root>-key ].
          <fs_ordem>-uffim = lt_ufdestino[ partner_guid = ls_stop_key-target_key ]-region.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.


  METHOD amdp_contar_notas BY DATABASE PROCEDURE FOR HDB
                           LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING vbfa.

    lt_faturas = select a.parent_key, count(b.vbelv) as numregs
                    from :it_remessas as a
                    inner join vbfa as b on b.vbelv = right(a.btd_id, 10)
                    where b.mandt   = session_context('CLIENT') and
                          b.vbtyp_n = 'M'                       and
                          b.vbtyp_v = 'J'
                    group by a.parent_key;

    lt_estornos = select a.parent_key, count(b.vbelv) as numregs
                    from :it_remessas as a
                    inner join vbfa as b on b.vbelv = right(a.btd_id, 10)
                    where b.mandt   = session_context('CLIENT') and
                          b.vbtyp_n = 'N'                       and
                          b.vbtyp_v = 'J'
                    group by a.parent_key;

    et_numnotas = select a.parent_key, a.numregs - b.numregs as notas
                      from :lt_faturas as a
                      left join :lt_estornos as b on b.parent_key = a.parent_key;
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA lt_ordens TYPE ty_ordens_frete.

    get_data( CHANGING ct_ordens = lt_ordens ).
  ENDMETHOD.
ENDCLASS.
