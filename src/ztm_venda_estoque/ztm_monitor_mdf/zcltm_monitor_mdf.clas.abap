"!<p><h2>Classe para manipulação de dados das CDS MDF-e</h2></p>
"!<p><strong>Autor:</strong>Thiago da Graça</p>
"!<p><strong>Data:</strong>11/11/2021</p>
CLASS zcltm_monitor_mdf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_amdp_marker_hdb.

    TYPES:
      BEGIN OF ty_refkey,
        refkey TYPE j_1brefkey,
        refitm TYPE j_1brefitm,
      END OF ty_refkey,

      "Tipo para buscar ID
      BEGIN OF ty_guid,
        guid TYPE sysuuid_x16,
      END OF ty_guid,

      "Tipo chave de acesso
      BEGIN OF ty_access_key,
        access_key TYPE j_1b_nfe_access_key,
      END OF ty_access_key,

      BEGIN OF ty_param,
        br_notafiscal  TYPE if_rap_query_filter=>tt_range_option,
        ordemfrete     TYPE if_rap_query_filter=>tt_range_option,
        br_mdfenumber  TYPE if_rap_query_filter=>tt_range_option,
        localexpedicao TYPE if_rap_query_filter=>tt_range_option,
        placa          TYPE if_rap_query_filter=>tt_range_option,
        statuscode     TYPE if_rap_query_filter=>tt_range_option,
        datacriacao    TYPE if_rap_query_filter=>tt_range_option,
        tipooperacao   TYPE if_rap_query_filter=>tt_range_option,
        empresa        TYPE if_rap_query_filter=>tt_range_option,
        agrupador      TYPE if_rap_query_filter=>tt_range_option,
        stepstatus     TYPE if_rap_query_filter=>tt_range_option,
        periodovalido  TYPE if_rap_query_filter=>tt_range_option,
      END OF ty_param,

      "Tipo tabela para o tipo <em>TY_REFKEY</em>
      ty_t_refkey        TYPE TABLE OF ty_refkey WITH DEFAULT KEY,

      "Tipo de retorno de dados à custom entity
      ty_cockpit         TYPE STANDARD TABLE OF zc_tm_mdf_cockpit WITH EMPTY KEY,
*      ty_cockpit_rt TYPE STANDARD TABLE OF zc_tm_mdf_cockpit WITH EMPTY KEY,

      "Tipo de retorno de dados com a estrutura geral do relatório
      ty_t_dados         TYPE TABLE OF zstm_mdfe_relatorio WITH DEFAULT KEY,

      ty_t_freight_order TYPE STANDARD TABLE OF /scmtms/tor_id WITH DEFAULT KEY,
      ty_t_nota_fiscal   TYPE STANDARD TABLE OF j_1bnfdoc-docnum WITH DEFAULT KEY,
      ty_t_id            TYPE STANDARD TABLE OF ty_guid WITH DEFAULT KEY,
      ty_t_damdfe        TYPE STANDARD TABLE OF zstm_damdfe WITH DEFAULT KEY,
      ty_t_condutor      TYPE STANDARD TABLE OF zstm_condut WITH DEFAULT KEY,
      ty_t_nfe           TYPE STANDARD TABLE OF zstm_nfe WITH DEFAULT KEY,
      ty_t_observacao    TYPE STANDARD TABLE OF zstm_obs WITH DEFAULT KEY,
      ty_t_access_key    TYPE STANDARD TABLE OF ty_access_key,

      BEGIN OF ty_print,
        damdfe       TYPE zstm_damdfe,
        t_condutor   TYPE ty_t_condutor,
        t_nfe        TYPE ty_t_nfe,
        t_observacao TYPE ty_t_observacao,
      END OF ty_print,

      ty_t_print    TYPE STANDARD TABLE OF ty_print,

      ty_dados_of   TYPE zi_tm_nf_sem_of,

      ty_t_dados_of TYPE STANDARD TABLE OF ty_dados_of.

    DATA: gr_br_notafiscal  TYPE REF TO data,
          gr_ordemfrete     TYPE REF TO data,
          gr_br_mdfenumber  TYPE REF TO data,
          gr_localexpedicao TYPE REF TO data,
          gr_placa          TYPE REF TO data,
          gr_statuscode     TYPE REF TO data,
          gr_datacriacao    TYPE REF TO data,
          gr_tipooperacao   TYPE REF TO data,
          gr_empresa        TYPE REF TO data,
          gr_agrupador      TYPE REF TO data,
          gr_stepstatus     TYPE REF TO data,
          gr_periodovalido  TYPE REF TO data.

    CLASS-METHODS:
      "! Cria instancia
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO zcltm_monitor_mdf .

    METHODS:
      "! Preenche parametros de entrada para filtrar os selects
      set_ref_data.

    METHODS:
      "! Preenche as tabelas 'Z'
      "! @parameter it_dados |Lista dados da CDS
      agrupar
        IMPORTING
                  it_dados         TYPE ty_t_dados
        RETURNING VALUE(rt_return) TYPE bapiret2_t.
*          it_dados TYPE ty_cockpit.

    METHODS:
      "! Deleta dados das tabelas 'Z'
      "! @parameter it_dados |Lista dados da CDS
      desagrupar
        IMPORTING
                  it_dados         TYPE ty_t_dados
        RETURNING VALUE(rt_return) TYPE bapiret2_t.

    METHODS:
      "! Logica para buscar dados e apresentar relatorio
      "! @parameter rt_cockpit |Retorna tabela relatório
      "! @parameter iv_agrupar |Agrupar?
      build
        IMPORTING
                  iv_agrupar        TYPE flag OPTIONAL
        RETURNING VALUE(rt_cockpit) TYPE ty_cockpit .

    METHODS:
      print_pdf
        IMPORTING it_id           TYPE ty_t_id
                  iv_get_url      TYPE flag DEFAULT abap_false
                  iv_printer      TYPE rspopname OPTIONAL
        EXPORTING ev_url          TYPE string
                  ev_complete_url TYPE string
                  ev_pdf_file     TYPE xstring
                  et_return       TYPE bapiret2_t.

    METHODS:
      "! Adiciona mensagens
      "! @parameter io_context |Objeto com o conteudo
      "! @parameter it_return  |Tabela com as mensagens
      "! @parameter ro_message_container | Retorna objeto preecnhido
      add_message_to_container
        IMPORTING
          io_context                  TYPE REF TO /iwbep/if_mgw_context
          it_return                   TYPE bapiret2_t OPTIONAL
        RETURNING
          VALUE(ro_message_container) TYPE REF TO /iwbep/if_message_container .

    METHODS:
      "! Preenche mensagens
      "! @parameter rv_message |Retorna mensagens
      fill_message
        RETURNING
          VALUE(rv_message) TYPE bapi_msg .
  PROTECTED SECTION.
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
      ty_nome_t TYPE SORTED TABLE OF ty_nome WITH NON-UNIQUE KEY partner_guid,

      BEGIN OF ty_vbfa,
        vbeln TYPE vbeln_nach,
        posnn TYPE posnr_nach,
      END OF ty_vbfa,

      "Tipo tabela do tipo <em>TY_VBFA</em>
      ty_t_vbfa TYPE TABLE OF ty_vbfa WITH DEFAULT KEY,

      BEGIN OF ty_nf,
        docnum TYPE j_1bdocnum,
      END OF ty_nf,

      "Tipo tabela do tipo <em>TY_NF</em>
      ty_t_nf          TYPE TABLE OF ty_nf          WITH DEFAULT KEY,

      "Tipo tabela do tipo <em>ZTTM_MDF</em>
      ty_t_mdf         TYPE TABLE OF zttm_mdf       WITH DEFAULT KEY,

      "Tipo tabela do tipo <em>ZTTM_MDF_PLACA</em>
      ty_t_placa       TYPE TABLE OF zttm_mdf_placa WITH DEFAULT KEY,

      "Tipo tabela do tipo <em>ZTTM_MDF_MOTO</em>
      ty_t_motorista   TYPE TABLE OF zttm_mdf_moto  WITH DEFAULT KEY,

      "Tipo tabela do tipo <em>ZTTM_MDF_MCD</em>
      ty_t_mcd         TYPE TABLE OF zttm_mdf_mcd   WITH DEFAULT KEY,

      ty_t_nf_of       TYPE STANDARD TABLE OF zi_tm_vh_mdf_nf_of,
      ty_t_mun         TYPE STANDARD TABLE OF zi_tm_mdf_municipio_qty,
      ty_t_frete_placa TYPE STANDARD TABLE OF zi_tm_vh_ordem_frete_placa.

    CLASS-DATA go_instance TYPE REF TO zcltm_monitor_mdf .

    DATA gs_param TYPE ty_param.

    METHODS:
      "! Ler objetos de autorização para campos relevantes no relatório
      "! @parameter er_auth_bukrs |Lista de empresas com autorização para exibição
      get_authorizations
        EXPORTING
          er_auth_bukrs TYPE if_rap_query_filter=>tt_range_option.

    METHODS:
      "! Contagem de notas fiscais válidas para as remessas
      "! @parameter it_remessas |Lista com as remessas a serem processadas
      "! @parameter et_numnotas |Tabela com o nº de notas válidas por remessa
      amdp_contar_notas IMPORTING VALUE(it_remessas) TYPE /scmtms/t_tor_docref_k
                        EXPORTING VALUE(et_numnotas) TYPE ty_numnotas_t.

    METHODS:
      "! Busca as notas fiscais para cada ordem de frete
      "! @parameter it_dados |Lista com as ordens de frete
      "! @parameter rt_dados |Retorna tabela com as notas fiscais
      get_nfs
*        IMPORTING it_dados        TYPE ty_cockpit
*        RETURNING VALUE(rt_dados) TYPE ty_cockpit.
        IMPORTING it_dados        TYPE ty_t_dados
        RETURNING VALUE(rt_dados) TYPE ty_t_dados.

    METHODS:
      "! Busca as placas para cada ordem de frete
      "! @parameter it_dados |Lista com as ordens de frete
      "! @parameter et_placa |Lista de placas
      get_placa
        IMPORTING it_dados TYPE ty_t_dados
*        IMPORTING it_dados TYPE ty_cockpit
        EXPORTING et_placa TYPE /scmtms/t_tor_item_tr_k.

    METHODS:
      "! Busca as faturas
      "! @parameter it_remessas |Lista com as remessas
      "! @parameter rt_faturas  |Retorna tabela com as faturas
      get_faturas
        IMPORTING it_remessas       TYPE /scmtms/t_tor_docref_k
        RETURNING VALUE(rt_faturas) TYPE ty_t_vbfa.

    METHODS:
      "! Busca as notas fiscais
      "! @parameter it_faturas  |Lista com as faturas
      "! @parameter rt_notas    |Retorna tabela com as notas
      get_notas
        IMPORTING it_faturas      TYPE ty_t_refkey
        RETURNING VALUE(rt_notas) TYPE ty_t_nf.

    METHODS:
      "! Preenche tabela de saida para Ordens de Frete
      "! @parameter it_notas    |Lista com as notas fiscais
      "! @parameter is_dados    |Estrutura do relatorio final
      "! @parameter ct_dados    |Retorna tabela para apresentar o relatorio
      fill_table_aux
        IMPORTING it_notas TYPE ty_t_nf
                  is_dados TYPE zstm_mdfe_relatorio
*                  is_dados TYPE zc_tm_mdf_cockpit
        CHANGING  ct_dados TYPE ty_t_dados.
*        CHANGING  ct_dados TYPE ty_cockpit.

    METHODS:
      "! Preenche tabela ZTTM_MDF
      "! @parameter it_dados    |Lista com os dados do relatorio
      "! @parameter iv_tstamp   |timestamp gerado
      "! @parameter iv_guid     |Guid gerado
      fill_mdfe
        IMPORTING it_dados  TYPE ty_t_dados
*        IMPORTING it_dados  TYPE ty_cockpit
                  iv_tstamp TYPE timestampl
                  iv_guid   TYPE sysuuid_x16.

    METHODS:
      "! Preenche tabela ZTTM_MDF_PLACA
      "! @parameter it_dados    |Estrutura com os dados do relatorio
      "! @parameter iv_tstamp   |timestamp gerado
      "! @parameter iv_guid     |Guid gerado
      fill_placa
        IMPORTING it_dados  TYPE ty_t_dados
*        IMPORTING it_dados  TYPE ty_cockpit
                  iv_tstamp TYPE timestampl
                  iv_guid   TYPE sysuuid_x16.

    METHODS:
      "! Preenche tabela ZTTM_MDF_MOTO
      "! @parameter it_dados     |Estrutura com os dados do relatorio
      "! @parameter iv_tstamp    |timestamp gerado
      "! @parameter iv_guid      |Guid gerado
      fill_motorista
        IMPORTING it_dados  TYPE ty_t_dados
*        IMPORTING it_dados  TYPE ty_cockpit
                  iv_tstamp TYPE timestampl
                  iv_guid   TYPE sysuuid_x16.

    METHODS:
      "! Preenche tabela ZTTM_MDF_MCD
      "! @parameter it_dados     |Estrutura com os dados do relatorio
      "! @parameter iv_tstamp    |timestamp gerado
      "! @parameter iv_guid      |Guid gerado
      fill_mcd
        IMPORTING it_dados  TYPE ty_t_dados
*        IMPORTING it_dados  TYPE ty_cockpit
                  iv_tstamp TYPE timestampl
                  iv_guid   TYPE sysuuid_x16.


    METHODS:
      "! Ler as informações das ordens de frete utilizando o BOPF
      "! @parameter ct_cockpit |Lista com as ordens de frete
      sel1_get_data CHANGING ct_cockpit TYPE ty_cockpit.

    METHODS:
      sel1_valida_of_nf
        IMPORTING it_root        TYPE /scmtms/t_tor_root_k
                  it_nf_of       TYPE ty_t_nf_of
                  it_mun         TYPE ty_t_mun
                  it_placa       TYPE ty_t_frete_placa
        RETURNING VALUE(rt_root) TYPE /scmtms/t_tor_root_k.

    METHODS:
      "! Ler as informações dos MDF-e criados
      "! @parameter ct_cockpit |Lista com as MDF-e
      sel2_get_data CHANGING ct_cockpit TYPE ty_cockpit.

    METHODS:
      "! Ler as informações das Notas Fiscais manuais sem MDF-e
      "! @parameter ct_cockpit |Lista com as Notas Fiscais manuais sem MDF-e
      sel3_get_data CHANGING ct_cockpit TYPE ty_cockpit.

    METHODS:
      sel3_valida_of_nf
        IMPORTING it_dados TYPE ty_t_dados_of
                  it_mun   TYPE ty_t_mun
        EXPORTING et_dados TYPE ty_t_dados_of.

    METHODS:
      "! Valida as informações para agrupar MDF-e
      "! @parameter it_cockpit |Lista com MDF-e
      valida_agrupar
        IMPORTING it_cockpit       TYPE ty_t_dados
        EXPORTING ev_guid          TYPE sysuuid_x16
*        IMPORTING it_cockpit       TYPE ty_cockpit
        RETURNING VALUE(rt_return) TYPE bapiret2_t.

    METHODS:
      "! Valida se existe campos com valores iguais
      "! @parameter it_cockpit |Lista com MDF-e
      valida_campos
        IMPORTING it_cockpit       TYPE ty_t_dados
*        IMPORTING it_cockpit       TYPE ty_cockpit
                  is_cockpit       TYPE zstm_mdfe_relatorio
        RETURNING VALUE(rs_return) TYPE bapiret2.

    METHODS:
      "! Valida as informações para agrupar MDF-e
      "! @parameter it_cockpit |Lista com MDF-e
      valida_desagrupar
        IMPORTING it_cockpit       TYPE ty_t_dados
*        IMPORTING it_cockpit       TYPE ty_cockpit
        RETURNING VALUE(rt_return) TYPE bapiret2_t.

    METHODS:
      get_data_to_print
        IMPORTING it_id     TYPE ty_t_id
        EXPORTING et_print  TYPE ty_t_print
                  et_return TYPE bapiret2_t.
ENDCLASS.




CLASS zcltm_monitor_mdf IMPLEMENTATION.


  METHOD agrupar.
    DATA: lt_mdf       TYPE TABLE OF zttm_mdf,
          lt_placa     TYPE TABLE OF zttm_mdf_placa,
          lt_motorista TYPE TABLE OF zttm_mdf_moto,
          lt_mcd       TYPE TABLE OF zttm_mdf_mcd.

    DATA lv_guid TYPE sysuuid_x16.

*    DATA lv_tstamp TYPE timestampl.

    DATA(lt_return) = zcltm_monitor_mdf_aut=>check_aut( iv_obj   = zcltm_monitor_mdf_aut=>gc_obj-grupo_b
                                                        iv_actvt = zcltm_monitor_mdf_aut=>gc_actvt-modificar ).

    if lt_return Is NOT INITIAL.
       rt_return = lt_return.
       RETURN.
    endif.

    "Valida os dados das linhas selecionadas
    rt_return = valida_agrupar( EXPORTING it_cockpit = it_dados IMPORTING ev_guid = lv_guid ).

    CHECK rt_return IS INITIAL.

    " Filtra Ordens de Frete
    DATA(lt_dados_of) = it_dados.
    SORT lt_dados_of BY ordemfrete.
    DELETE ADJACENT DUPLICATES FROM lt_dados_of COMPARING ordemfrete.
    DATA(lt_of) = VALUE ty_t_freight_order( FOR ls_dados_of IN lt_dados_of WHERE ( agrupador IS INITIAL AND ordemfrete IS NOT INITIAL ) ( ls_dados_of-ordemfrete ) ).

    " Filtra Notas Fiscais
    lt_dados_of = it_dados.
    SORT lt_dados_of BY br_notafiscal.
    DELETE ADJACENT DUPLICATES FROM lt_dados_of COMPARING br_notafiscal.
    DATA(lt_nf) = VALUE ty_t_nota_fiscal( FOR ls_dados_of IN lt_dados_of WHERE ( agrupador IS INITIAL AND br_notafiscal IS NOT INITIAL ) ( ls_dados_of-br_notafiscal ) ).

    DATA(lo_events) = NEW zcltm_mdf_events_manual( ).

    " Agrupa e cria MDF-e
    lo_events->use_fo_create_mdf( EXPORTING it_freight_order = lt_of
                                            it_nota_fiscal   = lt_nf
                                            iv_save          = abap_true
                                            iv_send          = abap_true
                                  IMPORTING et_return        = rt_return ).

*    GET TIME STAMP FIELD lv_tstamp.
*
*    DATA(lt_dados_aux) = it_dados.
*
*    DATA(lt_nfs) = get_nfs( EXPORTING it_dados = lt_dados_aux ).
*
*    IF lt_nfs IS NOT INITIAL.
*      CLEAR lt_dados_aux.
*      lt_dados_aux = lt_nfs.
*    ENDIF.
*
*    IF lv_guid IS INITIAL.
*
*      TRY.
*          lv_guid = cl_system_uuid=>create_uuid_x16_static( ).
*        CATCH cx_uuid_error.
*      ENDTRY.
*
*      "Dados MDF-e e Dados complementares
*      fill_mdfe( EXPORTING it_dados = lt_dados_aux iv_guid = lv_guid iv_tstamp = lv_tstamp ).
*
*    ENDIF.
*
*    "Dados Motorista
*    fill_motorista( EXPORTING it_dados = lt_dados_aux iv_guid = lv_guid iv_tstamp = lv_tstamp ).
*
*    "Dados Placa
*    fill_placa( EXPORTING it_dados = lt_dados_aux iv_guid = lv_guid iv_tstamp = lv_tstamp ).
*
*    "Dados de Município, Carregamento e Descarregamento
*    fill_mcd( EXPORTING it_dados = lt_dados_aux iv_guid = lv_guid iv_tstamp = lv_tstamp ).

  ENDMETHOD.


  METHOD get_nfs.
    DATA: lt_root        TYPE /scmtms/t_tor_root_k,
          lt_placas      TYPE /scmtms/t_tor_item_tr_k,
          lt_remessas    TYPE /scmtms/t_tor_docref_k,
          lt_drivers     TYPE /scmtms/t_tor_party_k,

          lt_faturas_aux TYPE TABLE OF ty_refkey.

    "Service Manager
    DATA(lo_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_dados ASSIGNING FIELD-SYMBOL(<fs_dados>) WHERE br_notafiscal IS INITIAL AND ordemfrete IS NOT INITIAL. "#EC CI_STDSEQ

      "Parâmetros do nó ROOT
      DATA(lt_selpar) = VALUE /bobf/t_frw_query_selparam( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id
                                                            sign = 'I' option = 'EQ' low = <fs_dados>-ordemfrete ) ).
      "Execução da query
      lo_srv_mgr->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                                   it_selection_parameters = lt_selpar
                                   iv_fill_data            = abap_true
                         IMPORTING et_data                 = lt_root ).
*    DELETE et_root WHERE zz1_cond_exped <> 'FROTA'.

      "Definição das chaves do ROOT
      DATA(lt_keys) = VALUE /bobf/t_frw_key( FOR ls_root IN lt_root ( key = ls_root-key ) ).

      "Obter remessas
      lo_srv_mgr->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                     it_key         = lt_keys
                                                     iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
                                                     iv_fill_data   = abap_true
                                           IMPORTING et_data        = lt_remessas ).
      DELETE lt_remessas WHERE btd_tco <> '73'. "#EC CI_SORTSEQ "Não existe filtro na associação 'docreference'. É necessário excluir manualmente  os registros.

    ENDLOOP.
    DATA(lt_faturas) = get_faturas( EXPORTING it_remessas = lt_remessas ).

    lt_faturas_aux = VALUE #( FOR ls_faturas IN lt_faturas ( CONV #( ls_faturas-vbeln ) ) ( CONV #( ls_faturas-posnn ) ) ).

    DATA(lt_notas) = get_notas( EXPORTING it_faturas = lt_faturas_aux ).

    LOOP AT it_dados ASSIGNING FIELD-SYMBOL(<fs_dados_aux>).
      fill_table_aux( EXPORTING it_notas = lt_notas is_dados = <fs_dados_aux> CHANGING ct_dados = rt_dados ).
    ENDLOOP.
  ENDMETHOD.


  METHOD get_placa.

    DATA: lt_root      TYPE /scmtms/t_tor_root_k,
          lt_remessas  TYPE /scmtms/t_tor_docref_k,
          lt_drivers   TYPE /scmtms/t_tor_party_k,
          lt_uforigem  TYPE ty_regiao_t,
          lt_ufdestino TYPE ty_regiao_t,
          lt_names     TYPE ty_nome_t,
          lt_cockpit   TYPE ty_cockpit,
          lt_selpar    TYPE /bobf/t_frw_query_selparam.

    FREE: et_placa.

    "Service Manager
    DATA(lo_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT it_dados ASSIGNING FIELD-SYMBOL(<fs_dados>) WHERE br_notafiscal IS INITIAL AND ordemfrete IS NOT INITIAL. "#EC CI_STDSEQ
      "Parâmetros do nó ROOT
      lt_selpar = VALUE #( BASE lt_selpar ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id
                                                             sign = 'I' option = 'EQ' low = <fs_dados>-ordemfrete ) ).
    ENDLOOP.

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
                                         IMPORTING et_data        = et_placa ).


  ENDMETHOD.


  METHOD get_faturas.
    IF it_remessas IS NOT INITIAL.
      SELECT vbeln, posnn FROM vbfa
      INTO TABLE @rt_faturas
      FOR ALL ENTRIES IN @it_remessas
      WHERE vbelv = @it_remessas-btd_id(10) AND
      vbtyp_v = 'J' AND
      vbtyp_n = 'M'.
    ENDIF.
  ENDMETHOD.


  METHOD get_notas.
    IF it_faturas IS NOT INITIAL.
      SELECT DISTINCT docnum
      FROM j_1bnflin
      INTO TABLE @rt_notas
      FOR ALL ENTRIES IN @it_faturas
      WHERE refkey = @it_faturas-refkey
      AND   refitm = @it_faturas-refitm.
    ENDIF.
  ENDMETHOD.


  METHOD fill_table_aux.

    DATA ls_saida TYPE zstm_mdfe_relatorio.
*    DATA ls_saida TYPE zc_tm_mdf_cockpit.

    LOOP AT it_notas ASSIGNING FIELD-SYMBOL(<fs_notas>).
      MOVE-CORRESPONDING is_dados TO ls_saida.
      ls_saida-br_notafiscal = <fs_notas>-docnum.

      APPEND ls_saida TO ct_dados.
    ENDLOOP.
  ENDMETHOD.


  METHOD fill_mdfe.

    DATA: ls_mdf TYPE zi_tm_mdf.

    IF it_dados[] IS NOT INITIAL.

      SELECT bukrs, txjcd, waerk
      FROM j_1bnfdoc
      INTO TABLE @DATA(lt_doc)
      FOR ALL ENTRIES IN @it_dados
      WHERE docnum = @it_dados-br_notafiscal.

      IF sy-subrc NE 0.
        FREE lt_doc.
      ENDIF.
    ENDIF.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->determine_mdf( EXPORTING it_municipio = CORRESPONDING #( it_dados )
                              IMPORTING et_return    = DATA(lt_return)
                              CHANGING  cs_mdf       = ls_mdf ).

    ls_mdf-guid                  = iv_guid.
    ls_mdf-agrupador             = zcltm_mdf_events=>doc_mdfe_create( ).
    ls_mdf-manual                = abap_false.
    ls_mdf-br_mdfenumber         = space.           " Preenchido após envio MDF-e
    ls_mdf-br_mdfeseries         = space.           " Preenchido após envio MDF-e
    ls_mdf-accesskey             = space.           " Preenchido após envio MDF-e

    TRY .
        ls_mdf-companycode       = lt_doc[ 1 ]-bukrs. "Verificar com funcional se é para validar se são diferentes
      CATCH cx_sy_itab_line_not_found.

    ENDTRY.

    SELECT SINGLE *
        FROM t001z
        INTO @DATA(ls_t001z)
        WHERE bukrs = @ls_mdf-companycode
          AND party = 'J_1BBR'.

    IF sy-subrc EQ 0.
      ls_mdf-businessplace = ls_t001z-paval.
    ENDIF.

*        ls_mdf-modfrete =
    TRY .
        ls_mdf-ufinicio          = it_dados[ 1 ]-ufinicio. "Verificar com funcional se é para validar se são diferentes
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    TRY .
        ls_mdf-uffim             = it_dados[ 1 ]-uffim. "Verificar com funcional se é para validar se são diferentes
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    ls_mdf-datainicioviagem     = sy-datum.
    ls_mdf-horainicioviagem     = sy-uzeit.

    TRY .
        ls_mdf-domfiscalinicio  = lt_doc[ 1 ]-txjcd. "Verificar com funcional se é para validar se são diferentes
        ls_mdf-domfiscalfim     = lt_doc[ 1 ]-txjcd. "Verificar com funcional se é para validar se são diferentes
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    TRY .
        ls_mdf-localexpedicao   = it_dados[ 1 ]-localexpedicao. "Verificar com funcional se é para validar se são diferentes
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

*        ls_mdf-RNTRC =
*        ls_mdf-correcao =

    lo_events->save_mdf( EXPORTING is_mdf    = ls_mdf
                         IMPORTING et_return = lt_return ).

  ENDMETHOD.


  METHOD fill_motorista.

    " Recupera o primeiro motorista
    DATA(lv_motorista) = REDUCE bu_partner(
                         INIT lv_bpmotorista TYPE bu_partner
                         FOR ls_dados IN it_dados
                         WHERE ( bpmotorista IS NOT INITIAL )
                         NEXT lv_bpmotorista = ls_dados-bpmotorista ). "#EC CI_STDSEQ

    DATA(lo_events) = NEW zcltm_mdf_events_manual( ).

    lo_events->determine_motorista( EXPORTING iv_id        = iv_guid
                                              iv_motorista = lv_motorista
                                    IMPORTING es_motorista = DATA(ls_motorista)
                                              et_return    = DATA(lt_return) ).

    lo_events->add_motorista( EXPORTING is_motorista = ls_motorista
                              IMPORTING et_return    = lt_return ).

  ENDMETHOD.


  METHOD fill_placa.

    DATA: lt_placa TYPE STANDARD TABLE OF zi_tm_mdf_placa,
          ls_placa TYPE zi_tm_mdf_placa.

    me->get_placa( EXPORTING it_dados = it_dados
                   IMPORTING et_placa = DATA(lt_placa_ord) ).


    LOOP AT lt_placa_ord INTO DATA(ls_placa_ord).
      ls_placa-id                  = iv_guid.
      ls_placa-placa               = ls_placa_ord-platenumber.
      ls_placa-renavam             = space.
      ls_placa-tara                = ls_placa_ord-pkgun_wei_val.
      ls_placa-capkg               = ls_placa_ord-payl_wei_val_vres.
      ls_placa-capm3               = ls_placa_ord-payl_vol_val_vres.
      ls_placa-tprod               = space.
      ls_placa-tpcar               = space.
      ls_placa-uf                  = ls_placa_ord-origregion_code.
      ls_placa-reboque             = space.
      APPEND ls_placa TO lt_placa[].
    ENDLOOP.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->save_placa( EXPORTING it_placa  = lt_placa
                           IMPORTING et_return = DATA(lt_return) ).

  ENDMETHOD.


  METHOD fill_mcd.

    DATA: lt_municipio TYPE STANDARD TABLE OF zi_tm_mdf_municipio,
          ls_municipio TYPE zi_tm_mdf_municipio.

    LOOP AT it_dados INTO DATA(ls_dados).          "#EC CI_LOOP_INTO_WA
      ls_municipio-guid           = iv_guid.
      ls_municipio-br_notafiscal  = ls_dados-br_notafiscal.
      ls_municipio-freightorder   = ls_dados-ordemfrete.
      APPEND ls_municipio TO lt_municipio[].
    ENDLOOP.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    lo_events->determine_municipio( IMPORTING et_return    = DATA(lt_return)
                                    CHANGING  ct_municipio = lt_municipio ).

    lo_events->save_municipio( EXPORTING it_municipio = lt_municipio
                               IMPORTING et_return    = lt_return ).

  ENDMETHOD.


  METHOD sel1_get_data.

    DATA: lt_root        TYPE /scmtms/t_tor_root_k,
          lt_cockpit     TYPE ty_cockpit,
          ls_cockpit     TYPE LINE OF ty_cockpit,
          ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          ls_address1    TYPE addr1_val,
          lv_cgc_number  TYPE j_1bcgc,
          lt_key         TYPE /bobf/t_frw_key,
          lt_itmtr       TYPE /scmtms/t_tor_item_tr_k,
          lt_auxitem     TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k.

    CONSTANTS: lc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR'.

* ---------------------------------------------------------------------------
* Recupera todos os agentes de frete
* ---------------------------------------------------------------------------
    SELECT werks, kunnr, lifnr
        FROM t001w
        WHERE werks IS NOT INITIAL
        INTO TABLE @DATA(lt_t001w).

    IF sy-subrc NE 0.
      FREE lt_t001w.
    ENDIF.

    DATA(lt_agente) = VALUE /scmtms/t_carrier( FOR ls_t001w IN lt_t001w WHERE ( kunnr IS NOT INITIAL ) ( ls_t001w-kunnr ) ).
    lt_agente       = VALUE /scmtms/t_carrier( BASE lt_agente FOR ls_t001w IN lt_t001w WHERE ( lifnr IS NOT INITIAL ) ( ls_t001w-lifnr ) ).

* ---------------------------------------------------------------------------
* Monta lógica para chamar a BOPF da ordem de frete
* ---------------------------------------------------------------------------
    "Service Manager
    DATA(lo_srv_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    "Parâmetros do nó ROOT
    DATA(lt_selpar) = VALUE /bobf/t_frw_query_selparam( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-manifested
                                                          sign = 'I' option = 'EQ' low = '' )
                                                        ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-execution
                                                          sign = 'I' option = 'NE' low = '06' )
*                                                        ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-execution
*                                                          sign = 'I' option = 'EQ' low = '03' )
*                                                        ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-execution
*                                                          sign = 'I' option = 'EQ' low = '07' )
                                                        ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_cat
                                                          sign = 'I' option = 'EQ' low = 'TO' ) ).

    " Adiciona filtro por ordem de frete
    lt_selpar = VALUE #( BASE lt_selpar FOR ls_ordemfrete IN gs_param-ordemfrete
                       ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id
                         sign           = ls_ordemfrete-sign
                         option         = ls_ordemfrete-option
                         low            = ls_ordemfrete-low
                         high           = ls_ordemfrete-high ) ).

    " Adiciona filtro por agente de frete
    lt_selpar = VALUE #( BASE lt_selpar FOR lv_agente IN lt_agente
                       ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tspid
                         sign           = 'I'
                         option         = 'EQ'
                         low            = lv_agente ) ).

    "Execução da query
    lo_srv_mgr->query( EXPORTING iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                                 it_selection_parameters = lt_selpar
                                 iv_fill_data            = abap_true
                       IMPORTING et_data                 = lt_root ).

* ---------------------------------------------------------------------------
* Seleção dos motoristas
* ---------------------------------------------------------------------------
    IF lt_root IS NOT INITIAL.

      SELECT parentuuid, driverid, drivername
      FROM zi_tm_vh_ordem_frete_moto
      FOR ALL ENTRIES IN @lt_root
      WHERE parentuuid = @lt_root-key
      INTO TABLE @DATA(lt_motorista).

      IF sy-subrc EQ 0.
        SORT lt_motorista BY parentuuid.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Seleção dos pontos de parada da Ordem de Frete (UF Origem e Destino)
* ---------------------------------------------------------------------------
    IF lt_root IS NOT INITIAL.

      SELECT *
          FROM zi_tm_get_stop_first_and_last
          FOR ALL ENTRIES IN @lt_root
          WHERE freightorder = @lt_root-tor_id
          INTO TABLE @DATA(lt_stop).

      IF sy-subrc EQ 0.
        SORT lt_stop BY freightorder.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Seleção das placas
* ---------------------------------------------------------------------------
    IF lt_root IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_ordem_frete_placa
          FOR ALL ENTRIES IN @lt_root
          WHERE freightorder  EQ @lt_root-tor_id
            AND placacaminhao IS NOT INITIAL
          INTO TABLE @DATA(lt_placa).

      IF sy-subrc EQ 0.
        SORT lt_placa BY freightorder.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Seleção das Notas Fiscais
* ---------------------------------------------------------------------------
    IF lt_root IS NOT INITIAL.

      SELECT *
        FROM zi_tm_vh_mdf_nf_of
        FOR ALL ENTRIES IN @lt_root
        WHERE freightorder = @lt_root-tor_id
          AND br_notafiscal IS NOT INITIAL
        INTO TABLE @DATA(lt_nf_of).

      IF sy-subrc EQ 0.
        SORT lt_nf_of BY freightorder.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Seleção dos municípios de cada NF
* ---------------------------------------------------------------------------
    DATA(lt_nf_key) = lt_nf_of.
    SORT lt_nf_key BY br_notafiscal.
    DELETE ADJACENT DUPLICATES FROM lt_nf_key COMPARING br_notafiscal.

    IF lt_nf_key IS NOT INITIAL.

      SELECT *
          FROM zi_tm_mdf_municipio_qty
          FOR ALL ENTRIES IN @lt_nf_key
          WHERE br_notafiscal = @lt_nf_key-br_notafiscal
          INTO TABLE @DATA(lt_mun).

      IF sy-subrc EQ 0.
        SORT lt_mun BY br_notafiscal.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Remove as OF nas seguintes situações:
* - Se alguma OF não possui NF
* - Se alguma OF já foi criada anteriormente
* - Se alguma NF de uma OF não foi "Autorizada"
* ---------------------------------------------------------------------------
    lt_root = me->sel1_valida_of_nf( EXPORTING it_root  = lt_root
                                               it_nf_of = lt_nf_of
                                               it_mun   = lt_mun
                                               it_placa = lt_placa ).

* ---------------------------------------------------------------------------
* Relacionar todos os dados lidos acima na estrutura final.
* ---------------------------------------------------------------------------
    LOOP AT lt_root ASSIGNING FIELD-SYMBOL(<fs_root>).

      CLEAR : ls_cockpit,
              lt_itmtr,
              lt_key,
              lt_auxitem.

      ls_cockpit-ordemfrete     = |{ <fs_root>-tor_id  ALPHA = OUT }|.
      ls_cockpit-titulo         = |OF { <fs_root>-tor_id+10(10) }|.
*        ls_cockpit-localexpedicao = <fs_root>-shipperid+6(4).

      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_root>-key CHANGING ct_key = lt_key ).

      lo_srv_mgr->retrieve_by_association(
                                                 EXPORTING
                                                   iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                   it_key                  = lt_key
                                                   iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                   iv_fill_data            = abap_true
                                                 IMPORTING
                                                   et_data                 = lt_itmtr
                                               ).



      " Recupera e valida placa
      READ TABLE lt_placa REFERENCE INTO DATA(ls_placa) WITH KEY freightorder = <fs_root>-tor_id BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      IF ls_placa->placavalidaparam NE abap_true.
        CONTINUE.
      ENDIF.

      ls_cockpit-placa = ls_placa->placacaminhao.

      lt_auxitem = lt_itmtr.
      SORT lt_auxitem BY item_cat.
      READ TABLE lt_auxitem
      WITH KEY item_cat = lc_itemcat_avr
      BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_item>).

      IF sy-subrc = 0.
        ls_cockpit-placa1 = <fs_item>-ztrailer1.
        ls_cockpit-placa2 = <fs_item>-ztrailer2.
        ls_cockpit-placa3 = <fs_item>-ztrailer3.
      ENDIF.

      READ TABLE lt_nf_of TRANSPORTING NO FIELDS WITH KEY freightorder = <fs_root>-tor_id BINARY SEARCH.

      IF sy-subrc EQ 0.

        LOOP AT lt_nf_of REFERENCE INTO DATA(ls_nf) FROM sy-tabix WHERE freightorder = <fs_root>-tor_id.

          READ TABLE lt_mun REFERENCE INTO DATA(ls_mun) WITH KEY br_notafiscal = ls_nf->br_notafiscal BINARY SEARCH.

          CHECK sy-subrc EQ 0.

          " Determina e soma NF
          ls_cockpit-qtdnotas         = ls_cockpit-qtdnotas + 1.

          " Determina e soma NF Writer
          ls_cockpit-qtdwriter        = COND #( WHEN ls_mun->br_nfiscreatedmanually = abap_true
                                                THEN ls_cockpit-qtdwriter + 1
                                                ELSE ls_cockpit-qtdwriter ).

          ls_cockpit-localexpedicao   = COND #( WHEN ls_cockpit-localexpedicao IS NOT INITIAL
                                                THEN ls_cockpit-localexpedicao
                                                ELSE ls_mun->shippingpoint ).

          ls_cockpit-modelo          = COND #( WHEN ls_cockpit-modelo IS NOT INITIAL
                                               THEN ls_cockpit-modelo
                                               ELSE ls_mun->br_nfmodel ).

          ls_cockpit-regiao          = COND #( WHEN ls_cockpit-regiao IS NOT INITIAL
                                               THEN ls_cockpit-regiao
                                               ELSE ls_mun->br_nfpartnertaxjurisdiction+3(2) ).

          ls_cockpit-empresa         = COND #( WHEN ls_cockpit-empresa IS NOT INITIAL
                                               THEN ls_cockpit-empresa
                                               ELSE ls_mun->companycode ).

          IF ls_cockpit-regiao IS INITIAL AND ls_cockpit-idfiscal IS INITIAL.

            CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
              EXPORTING
                branch            = ls_mun->businessplace
                bukrs             = ls_mun->companycode
              IMPORTING
                address           = ls_address
                branch_data       = ls_branch_data
                cgc_number        = lv_cgc_number
                address1          = ls_address1
              EXCEPTIONS
                branch_not_found  = 1
                address_not_found = 2
                company_not_found = 3
                OTHERS            = 4.

            IF sy-subrc EQ 0.
              ls_cockpit-regiao    = ls_address1-taxjurcode+3(2).
              ls_cockpit-idfiscal  = lv_cgc_number.
            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

      " Recupera motorista
      READ TABLE lt_motorista REFERENCE INTO DATA(ls_motorista) WITH KEY parentuuid = <fs_root>-key BINARY SEARCH.

      IF sy-subrc EQ 0.
        ls_cockpit-motorista     = ls_motorista->driverid.
        ls_cockpit-nomemotorista = ls_motorista->drivername.
      ENDIF.

      " Recupera UF Origem e destino
      READ TABLE lt_stop REFERENCE INTO DATA(ls_stop) WITH KEY freightorder = <fs_root>-tor_id BINARY SEARCH.

      IF sy-subrc EQ 0.
        ls_cockpit-ufinicio    = ls_stop->firstregion.
        ls_cockpit-uffim       = ls_stop->lastregion.
*        CONVERT TIME STAMP ls_stop->firstplantranstime TIME ZONE space INTO DATE ls_cockpit-datacriacao.
      ENDIF.

      CONVERT TIME STAMP <fs_root>-created_on TIME ZONE space INTO DATE ls_cockpit-datacriacao.

      ls_cockpit-tipooperacao = '1'.

      APPEND ls_cockpit TO lt_cockpit[].

    ENDLOOP.

    DELETE lt_cockpit WHERE placa IS INITIAL AND motorista IS INITIAL.

    IF lt_cockpit IS NOT INITIAL.

      SELECT *
        FROM @lt_cockpit AS ordens
        WHERE br_notafiscal   IN @gs_param-br_notafiscal
        AND   ordemfrete      IN @gs_param-ordemfrete
        AND   br_mdfenumber   IN @gs_param-br_mdfenumber
        AND   localexpedicao  IN @gs_param-localexpedicao
        AND   placa           IN @gs_param-placa
        AND   statuscode      IN @gs_param-statuscode
        AND   datacriacao     IN @gs_param-datacriacao
        AND   empresa         IN @gs_param-empresa
        AND   agrupador       IN @gs_param-agrupador
        AND   stepstatus      IN @gs_param-stepstatus
        INTO TABLE @lt_cockpit.

      IF sy-subrc NE 0.
        FREE lt_cockpit.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Retorna os dados
* ---------------------------------------------------------------------------
    ct_cockpit = VALUE #( BASE ct_cockpit FOR ls_cp IN lt_cockpit ( CORRESPONDING #( ls_cp ) ) ).

  ENDMETHOD.


  METHOD sel1_valida_of_nf.

    DATA: lt_root      TYPE /scmtms/t_tor_root_k,
          lt_placa_key TYPE STANDARD TABLE OF zi_tm_mdf_criados.

    DATA(lt_mun) = it_mun.
    SORT lt_mun BY br_notafiscal.

* ---------------------------------------------------------------------------
* Recupera as placas que já foram utilizadas por outra MDF-e
* ---------------------------------------------------------------------------
    IF it_placa IS NOT INITIAL.

      lt_placa_key = VALUE #( FOR ls_plc IN it_placa ( placa = ls_plc-placacaminhao ) ).
      SORT lt_placa_key BY placa.
      DELETE ADJACENT DUPLICATES FROM lt_placa_key COMPARING placa.

      SELECT DISTINCT *
        FROM zi_tm_mdf_criados
        FOR ALL ENTRIES IN @lt_placa_key
        WHERE placa      EQ @lt_placa_key-placa
          AND statuscode EQ '100' " Autorizado o uso da NF-e
          INTO TABLE @DATA(lt_placa_c).

      IF sy-subrc EQ 0.
        SORT lt_placa_c BY placa.
      ENDIF.

    ENDIF.

* ---------------------------------------------------------------------------
* Seleção das OF com MDF-e criada
* ---------------------------------------------------------------------------
    IF it_root IS NOT INITIAL.

      SELECT DISTINCT *
          FROM zi_tm_get_agrupador
          FOR ALL ENTRIES IN @it_root
          WHERE ordemfrete = @it_root-tor_id
          INTO TABLE @DATA(lt_agrupador).

      IF sy-subrc EQ 0.
        SORT lt_agrupador BY ordemfrete ASCENDING
                             agrupador DESCENDING.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida e separa as Ordens de Frete
* ---------------------------------------------------------------------------
    LOOP AT it_root ASSIGNING FIELD-SYMBOL(<fs_root>).

      DATA(lv_autorizado) = abap_true.

      " Verifica e remove se OF já possui MDF-e criada
      " ----------------------------------------------
      READ TABLE lt_agrupador REFERENCE INTO DATA(ls_agrupador) WITH KEY ordemfrete = <fs_root>-tor_id BINARY SEARCH.

      IF sy-subrc EQ 0.
*        IF ls_agrupador->statuscode EQ '101'   " Cancelado
*        OR ls_agrupador->statuscode EQ '132'.  " Encerrado
        CONTINUE.
*        ENDIF.
      ENDIF.

      " Verifica e remove se OF possui NF
      " ---------------------------------
      READ TABLE it_nf_of TRANSPORTING NO FIELDS WITH KEY freightorder = <fs_root>-tor_id BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Verifica e remove se alguma NF de uma OF não foi "Autorizada"
      " -------------------------------------------------------------
      LOOP AT it_nf_of REFERENCE INTO DATA(ls_nf) FROM sy-tabix WHERE freightorder = <fs_root>-tor_id.

        READ TABLE lt_mun REFERENCE INTO DATA(ls_mun) WITH KEY br_notafiscal = ls_nf->br_notafiscal BINARY SEARCH.

        IF sy-subrc NE 0.
          lv_autorizado = abap_false.
          EXIT.
        ENDIF.

        IF ls_mun->br_nfedocumentstatus NE '1'.
          lv_autorizado = abap_false.
          EXIT.
        ENDIF.

*        IF ls_nf->BR_NFIsCanceled IS NOT INITIAL.
*          lv_autorizado = abap_false.
*          EXIT.
*        ENDIF.

      ENDLOOP.

      " Verifica se a mesma placa foi utilizada por outra MDF-e
      " -------------------------------------------------------------
      READ TABLE it_placa INTO DATA(ls_placa) WITH KEY freightorder = <fs_root>-tor_id.

      IF sy-subrc NE 0.
        CLEAR ls_placa.
      ENDIF.

* BEGIN OF DELETE - JWSILVA - 09.02.2023 - Foi solicitado a remoção desta validação
*
*      READ TABLE lt_placa_c TRANSPORTING NO FIELDS WITH KEY placa = ls_placa-placacaminhao  BINARY SEARCH.
*
*      IF sy-subrc EQ 0.
*        " Placa utilizada por outra MDF-e
*        lv_autorizado = abap_false.
*      ENDIF.
*
* END OF DELETE - JWSILVA - 09.02.2023

      " Verifica se as validações acima estão OK
      " -------------------------------------------------------------
      IF lv_autorizado NE abap_true.
        CONTINUE.
      ENDIF.

      APPEND <fs_root> TO lt_root[].

    ENDLOOP.

    rt_root[] = lt_root[].

  ENDMETHOD.


  METHOD sel3_valida_of_nf.

    DATA: lt_dados     TYPE ty_t_dados_of,
          lt_placa_key TYPE STANDARD TABLE OF zi_tm_mdf_criados.

    DATA(lt_mun) = it_mun.
    SORT lt_mun BY br_notafiscal.

    FREE: et_dados.

* ---------------------------------------------------------------------------
* Recupera as placas que já foram utilizadas por outra MDF-e
* ---------------------------------------------------------------------------
    IF it_dados IS NOT INITIAL.

      lt_placa_key = VALUE #( FOR ls_plc IN it_dados ( placa = ls_plc-placa ) ).
      SORT lt_placa_key BY placa.
      DELETE ADJACENT DUPLICATES FROM lt_placa_key COMPARING placa.

      SELECT DISTINCT *
        FROM zi_tm_mdf_criados
        FOR ALL ENTRIES IN @lt_placa_key
        WHERE placa      EQ @lt_placa_key-placa
          AND statuscode EQ '100' " Autorizado o uso da NF-e
          INTO TABLE @DATA(lt_placa_c).

      IF sy-subrc EQ 0.
        SORT lt_placa_c BY placa.
      ENDIF.

    ENDIF.

* ---------------------------------------------------------------------------
* Seleção das OF com MDF-e criada
* ---------------------------------------------------------------------------
    IF it_dados IS NOT INITIAL.

      SELECT DISTINCT *
          FROM zi_tm_get_agrupador
          FOR ALL ENTRIES IN @it_dados
          WHERE br_notafiscal = @it_dados-br_notafiscal
          INTO TABLE @DATA(lt_agrupador).

      IF sy-subrc EQ 0.
        SORT lt_agrupador BY br_notafiscal ASCENDING
                             agrupador DESCENDING.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida e separa as Ordens de Frete
* ---------------------------------------------------------------------------
    LOOP AT it_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

      DATA(lv_autorizado) = abap_true.

      " Verifica e remove se OF já possui MDF-e criada
      " ----------------------------------------------
      READ TABLE lt_agrupador REFERENCE INTO DATA(ls_agrupador) WITH KEY br_notafiscal = <fs_dados>-br_notafiscal BINARY SEARCH.

      IF sy-subrc EQ 0.
*        IF ls_agrupador->statuscode EQ '101'   " Cancelado
*        OR ls_agrupador->statuscode EQ '132'.  " Encerrado
        CONTINUE.
*        ENDIF.
      ENDIF.


      " Verifica e remove se NF não foi "Autorizada"
      " -------------------------------------------------------------
      READ TABLE lt_mun REFERENCE INTO DATA(ls_mun) WITH KEY br_notafiscal = <fs_dados>-br_notafiscal BINARY SEARCH.

      IF sy-subrc NE 0.
        lv_autorizado = abap_false.
        CONTINUE.
      ENDIF.

      IF ls_mun->br_nfedocumentstatus NE '1'.
        lv_autorizado = abap_false.
        CONTINUE.
      ENDIF.

      " Verifica se a mesma placa foi utilizada por outra MDF-e
      " -------------------------------------------------------------
      READ TABLE lt_placa_c TRANSPORTING NO FIELDS WITH KEY placa = <fs_dados>-placa BINARY SEARCH.

      IF sy-subrc EQ 0.
        " Placa utilizada por outra MDF-e
        lv_autorizado = abap_false.
      ENDIF.

      " Verifica se as validações acima estão OK
      " -------------------------------------------------------------
      IF lv_autorizado NE abap_true.
        CONTINUE.
      ENDIF.

      APPEND <fs_dados> TO lt_dados[].

    ENDLOOP.

    et_dados[] = lt_dados[].

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


  METHOD sel2_get_data.

    DATA: ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          ls_address1    TYPE addr1_val,
          lv_cgc_number  TYPE j_1bcgc,
          lt_parameters  TYPE /bobf/t_frw_query_selparam,
          lt_key         TYPE /bobf/t_frw_key,
          lt_tor_of      TYPE /scmtms/t_tor_root_k,
          lt_toraux      TYPE STANDARD TABLE OF /scmtms/s_tor_root_k,
          lt_itmtr       TYPE /scmtms/t_tor_item_tr_k,
          lt_auxitem     TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k.


    CONSTANTS: lc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR'.

* ---------------------------------------------------------------------------
* Recupera as MDFs criadas
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_criados
        WHERE br_notafiscal   IN @gs_param-br_notafiscal
        AND   ordemfrete      IN @gs_param-ordemfrete
        AND   br_mdfenumber   IN @gs_param-br_mdfenumber
        AND   localexpedicao  IN @gs_param-localexpedicao
        AND   placa           IN @gs_param-placa
        AND   statuscode      IN @gs_param-statuscode
        AND   datacriacao     IN @gs_param-datacriacao
        AND   empresa         IN @gs_param-empresa
        AND   agrupador       IN @gs_param-agrupador
        AND   stepstatus      IN @gs_param-stepstatus
        INTO TABLE @DATA(lt_dados).

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera data de emissão
* ---------------------------------------------------------------------------
    IF lt_dados IS NOT INITIAL.

      SELECT id,
             histcount,
             event,
             createtime
          FROM zi_tm_mdf_historico
          FOR ALL ENTRIES IN @lt_dados
          WHERE id = @lt_dados-guid
          INTO TABLE @DATA(lt_hist).

      IF sy-subrc EQ 0.
        SORT lt_hist BY id ASCENDING createtime DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_hist COMPARING id.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza dados de emitente (Preenchido via Virtual Elements)
* ---------------------------------------------------------------------------
    LOOP AT lt_dados REFERENCE INTO DATA(ls_dados).

      CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
        EXPORTING
          branch            = ls_dados->businessplace
          bukrs             = ls_dados->empresa
        IMPORTING
          address           = ls_address
          branch_data       = ls_branch_data
          cgc_number        = lv_cgc_number
          address1          = ls_address1
        EXCEPTIONS
          branch_not_found  = 1
          address_not_found = 2
          company_not_found = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ls_dados->regiao    = ls_address1-taxjurcode+3(2).
      ls_dados->idfiscal  = lv_cgc_number.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Separa as Ordens de Frete
* ---------------------------------------------------------------------------
    DATA(lt_of) = lt_dados.
    SORT lt_of BY ordemfrete agrupador.
    DELETE lt_of WHERE ordemfrete IS INITIAL.
    DELETE lt_of WHERE ordemfrete EQ '0000000000'.
    DELETE ADJACENT DUPLICATES FROM lt_of COMPARING ordemfrete agrupador.

    LOOP AT lt_of ASSIGNING FIELD-SYMBOL(<fs_of>).
      CLEAR <fs_of>-br_notafiscal.

      APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
      <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-root_elements-tor_id.
      <fs_parameters>-sign   = 'I'.
      <fs_parameters>-option = 'EQ'.
      <fs_parameters>-low    = <fs_of>-freightorder.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Separa as Notas Fiscais
* ---------------------------------------------------------------------------
    DATA(lt_nf) = lt_dados.
    SORT lt_nf BY br_notafiscal.
    DELETE lt_nf WHERE ordemfrete IS NOT INITIAL
                   AND ordemfrete NE '0000000000'.
    DELETE lt_nf WHERE br_notafiscal IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM lt_nf COMPARING br_notafiscal agrupador.

    "Service Manager
    DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

* ---------------------------------------------------------------------------
* Retorna os dados
* ---------------------------------------------------------------------------
*    ct_cockpit = VALUE #( BASE ct_cockpit FOR ls_of IN lt_of ( CORRESPONDING #( ls_of ) ) ).
    IF lt_parameters IS NOT INITIAL.
      lo_srv_tor->query(
                             EXPORTING
                               iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                               it_selection_parameters = lt_parameters
                               iv_fill_data            = abap_true
                             IMPORTING
                               et_key                  = lt_key
                               et_data                 = lt_tor_of
                          ).
      IF lt_tor_of IS NOT INITIAL.
        lt_toraux = lt_tor_of.
        SORT lt_toraux BY tor_id.
      ENDIF.
    ENDIF.

    LOOP AT lt_of ASSIGNING <fs_of>.

      APPEND INITIAL LINE TO ct_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>).
      MOVE-CORRESPONDING <fs_of> TO <fs_cockpit>.
      READ TABLE lt_toraux
      WITH KEY tor_id = <fs_of>-freightorder
      ASSIGNING FIELD-SYMBOL(<fs_aux>).
      IF sy-subrc = 0.
        CLEAR : lt_key,
                lt_itmtr,
                lt_auxitem.

        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = <fs_aux>-key CHANGING ct_key = lt_key ).

        lo_srv_tor->retrieve_by_association(
                                                   EXPORTING
                                                     iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                                     it_key                  = lt_key
                                                     iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                     iv_fill_data            = abap_true
                                                   IMPORTING
                                                     et_data                 = lt_itmtr
                                                 ).
        lt_auxitem = lt_itmtr.
        SORT lt_auxitem BY item_cat.
        READ TABLE lt_auxitem
        WITH KEY item_cat = lc_itemcat_avr
        BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_item>).

        IF sy-subrc = 0.
          <fs_cockpit>-placa1 = <fs_item>-ztrailer1.
          <fs_cockpit>-placa2 = <fs_item>-ztrailer2.
          <fs_cockpit>-placa3 = <fs_item>-ztrailer3.
        ENDIF.
      ENDIF.
    ENDLOOP.
    ct_cockpit = VALUE #( BASE ct_cockpit FOR ls_nf IN lt_nf ( CORRESPONDING #( ls_nf ) ) ).

    DATA(lt_nf_ext) = lt_dados.
    DELETE lt_nf_ext WHERE chaveacesso IS INITIAL.
    DELETE lt_nf_ext WHERE br_notafiscal IS NOT INITIAL.
    DELETE lt_nf_ext WHERE ordemfrete IS NOT INITIAL.

    IF lt_nf_ext[] IS NOT INITIAL.
      SORT lt_nf_ext BY br_notafiscal
                        agrupador.

      DELETE ADJACENT DUPLICATES FROM lt_nf_ext COMPARING br_notafiscal agrupador.
      ct_cockpit = VALUE #( BASE ct_cockpit FOR ls_nf_ext IN lt_nf_ext ( CORRESPONDING #( ls_nf_ext ) ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Remove os registros emitidos a mais de 30 dias
* ---------------------------------------------------------------------------
    LOOP AT ct_cockpit REFERENCE INTO DATA(ls_cockpit).

      DATA(lv_tabix) = sy-tabix.

      READ TABLE lt_hist REFERENCE INTO DATA(ls_hist) WITH KEY id = ls_cockpit->guid
                                                      BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      IF ls_hist->createtime IS INITIAL.
        CONTINUE.
      ENDIF.

      IF abap_false IN gs_param-periodovalido[].
        CONTINUE.
      ENDIF.

      CONVERT TIME STAMP ls_hist->createtime TIME ZONE sy-zonlo INTO DATE DATA(lv_date).

      " Remove os registros emitidos a mais de 30 dias
      IF sy-datum - lv_date >= 30.
        DELETE ct_cockpit INDEX lv_tabix.
      ENDIF.

    ENDLOOP.

    IF ct_cockpit[] IS NOT INITIAL.
      SORT ct_cockpit BY titulo
                         agrupador.

      DELETE ADJACENT DUPLICATES FROM ct_cockpit COMPARING titulo
                                                           agrupador.
    ENDIF.

  ENDMETHOD.


  METHOD sel3_get_data.

    DATA: ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          ls_address1    TYPE addr1_val,
          lv_cgc_number  TYPE j_1bcgc.

* ---------------------------------------------------------------------------
* Recupera NF sem OF
* ---------------------------------------------------------------------------
    SELECT *
    FROM zi_tm_nf_sem_of
        WHERE br_notafiscal   IN @gs_param-br_notafiscal
        AND   ordemfrete      IN @gs_param-ordemfrete
        AND   br_mdfenumber   IN @gs_param-br_mdfenumber
        AND   localexpedicao  IN @gs_param-localexpedicao
        AND   placa           IN @gs_param-placa
        AND   statuscode      IN @gs_param-statuscode
        AND   datacriacao     IN @gs_param-datacriacao
        AND   empresa         IN @gs_param-empresa
        AND   agrupador       IN @gs_param-agrupador
        AND   stepstatus      IN @gs_param-stepstatus
        INTO TABLE @DATA(lt_dados_temp).

* ---------------------------------------------------------------------------
* Seleção dos municípios de cada NF
* ---------------------------------------------------------------------------
    DATA(lt_nf_key) = lt_dados_temp.
    SORT lt_nf_key BY br_notafiscal.
    DELETE ADJACENT DUPLICATES FROM lt_nf_key COMPARING br_notafiscal.

    IF lt_nf_key IS NOT INITIAL.

      SELECT *
          FROM zi_tm_mdf_municipio_qty
          FOR ALL ENTRIES IN @lt_nf_key
          WHERE br_notafiscal = @lt_nf_key-br_notafiscal
          INTO TABLE @DATA(lt_mun).

      IF sy-subrc EQ 0.
        SORT lt_mun BY br_notafiscal.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Remove as OF nas seguintes situações:
* - Se alguma OF não possui NF
* - Se alguma NF de uma OF não foi "Autorizada"
* ---------------------------------------------------------------------------
    me->sel3_valida_of_nf( EXPORTING it_dados = lt_dados_temp
                                     it_mun   = lt_mun
                           IMPORTING et_dados = DATA(lt_dados) ).

* ---------------------------------------------------------------------------
* Atualiza dados de emitente (Preenchido via Virtual Elements)
* ---------------------------------------------------------------------------
    LOOP AT lt_dados REFERENCE INTO DATA(ls_dados).

      CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
        EXPORTING
          branch            = ls_dados->businessplace
          bukrs             = ls_dados->empresa
        IMPORTING
          address           = ls_address
          branch_data       = ls_branch_data
          cgc_number        = lv_cgc_number
          address1          = ls_address1
        EXCEPTIONS
          branch_not_found  = 1
          address_not_found = 2
          company_not_found = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ls_dados->regiao    = ls_address1-taxjurcode+3(2).
      ls_dados->idfiscal  = lv_cgc_number.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retorna os dados
* ---------------------------------------------------------------------------
    ct_cockpit = VALUE #( BASE ct_cockpit FOR ls_dds IN lt_dados ( CORRESPONDING #( ls_dds ) ) ).

  ENDMETHOD.


  METHOD set_ref_data.

    ASSIGN gr_br_notafiscal->*   TO FIELD-SYMBOL(<fs_r_nf>).
    ASSIGN gr_ordemfrete->*      TO FIELD-SYMBOL(<fs_r_odfrete>).
    ASSIGN gr_br_mdfenumber->*   TO FIELD-SYMBOL(<fs_r_mdfe>).
    ASSIGN gr_localexpedicao->*  TO FIELD-SYMBOL(<fs_r_localexp>).
    ASSIGN gr_placa->*           TO FIELD-SYMBOL(<fs_r_placa>).
    ASSIGN gr_statuscode->*      TO FIELD-SYMBOL(<fs_r_statusdoc>).
    ASSIGN gr_datacriacao->*     TO FIELD-SYMBOL(<fs_r_dtcriacao>).
    ASSIGN gr_tipooperacao->*    TO FIELD-SYMBOL(<fs_r_tpoperacao>).
    ASSIGN gr_empresa->*         TO FIELD-SYMBOL(<fs_r_empresa>).
    ASSIGN gr_agrupador->*       TO FIELD-SYMBOL(<fs_r_agrupador>).
    ASSIGN gr_stepstatus->*      TO FIELD-SYMBOL(<fs_r_stepstatus>).
    ASSIGN gr_periodovalido->*   TO FIELD-SYMBOL(<fs_r_periodovalido>).

    gs_param-br_notafiscal[]   = <fs_r_nf>.
    gs_param-ordemfrete[]      = <fs_r_odfrete>.
    gs_param-br_mdfenumber[]   = <fs_r_mdfe>.
    gs_param-localexpedicao[]  = <fs_r_localexp>.
    gs_param-placa[]           = <fs_r_placa>.
    gs_param-statuscode[]      = <fs_r_statusdoc>.
    gs_param-datacriacao[]     = <fs_r_dtcriacao>.
    gs_param-tipooperacao[]    = <fs_r_tpoperacao>.
    gs_param-empresa[]         = <fs_r_empresa>.
    gs_param-agrupador[]       = <fs_r_agrupador>.
    gs_param-stepstatus[]      = <fs_r_stepstatus>.
    gs_param-periodovalido[]   = <fs_r_periodovalido>.

    UNASSIGN <fs_r_nf>.
    UNASSIGN <fs_r_odfrete>.
    UNASSIGN <fs_r_mdfe>.
    UNASSIGN <fs_r_localexp>.
    UNASSIGN <fs_r_placa>.
    UNASSIGN <fs_r_statusdoc>.
    UNASSIGN <fs_r_dtcriacao>.
    UNASSIGN <fs_r_tpoperacao>.
    UNASSIGN <fs_r_empresa>.
    UNASSIGN <fs_r_agrupador>.
    UNASSIGN <fs_r_periodovalido>.
  ENDMETHOD.


  METHOD get_instance.

    IF ( go_instance IS INITIAL ).
      go_instance = NEW zcltm_monitor_mdf( ).
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD build.

    DATA: lt_agrupador TYPE ty_t_agrupador.

* ---------------------------------------------------------------------------
* Ler objetos de autorização p/ campos relevantes
* ---------------------------------------------------------------------------
    me->get_authorizations(
      IMPORTING
        er_auth_bukrs = DATA(lr_auth_bukrs)
    ).

* ---------------------------------------------------------------------------
* Dados Ordem de Frete
* ---------------------------------------------------------------------------
    IF line_exists( gs_param-tipooperacao[ low = '1' ] ) OR iv_agrupar IS SUPPLIED. "#EC CI_STDSEQ
      me->sel1_get_data( CHANGING ct_cockpit = rt_cockpit ).
    ENDIF.

* ---------------------------------------------------------------------------
* Dados MDF-e Criadas para os seguintes cenários:
* - OF
* - OF + NF Writer
* - NF Writer
* ---------------------------------------------------------------------------
    IF line_exists( gs_param-tipooperacao[ low = '2' ] ) OR iv_agrupar IS SUPPLIED. "#EC CI_STDSEQ
      me->sel2_get_data( CHANGING ct_cockpit = rt_cockpit ).
    ENDIF.

* ---------------------------------------------------------------------------
* Dados Notas Fiscais manuais sem MDF-e
* ---------------------------------------------------------------------------
    IF line_exists( gs_param-tipooperacao[ low = '3' ] ) OR iv_agrupar IS SUPPLIED. "#EC CI_STDSEQ
      me->sel3_get_data( CHANGING ct_cockpit = rt_cockpit ) .
    ENDIF.

    SORT rt_cockpit BY agrupador     DESCENDING
                       ordemfrete    DESCENDING
                       br_notafiscal DESCENDING.

    DELETE rt_cockpit
     WHERE empresa NOT IN lr_auth_bukrs
       AND empresa IS NOT INITIAL.
  ENDMETHOD.


  METHOD valida_agrupar.

    DATA ls_return TYPE bapiret2.

    DATA lv_code_conv TYPE i.

    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

* ---------------------------------------------------------------------------
* Valida número de linhas selecionadas
* ---------------------------------------------------------------------------
    IF lines( it_cockpit ) = 1.
      " Selecionar mais de uma linha para agrupar.
      rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '068' ) ).
      lo_events->format_message( CHANGING ct_return = rt_return[] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida local de expedição
* ---------------------------------------------------------------------------
    DATA(lt_cockpit) = it_cockpit.
    SORT lt_cockpit BY localexpedicao.
    DELETE ADJACENT DUPLICATES FROM lt_cockpit COMPARING localexpedicao.

    IF lines( lt_cockpit ) > 1.
      " Local de Expedição dos documentos é divergente. Agrupamento não permitido.
      rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '077' ) ).
      lo_events->format_message( CHANGING ct_return = rt_return[] ).
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Placa e motorista
* ---------------------------------------------------------------------------
    LOOP AT it_cockpit ASSIGNING FIELD-SYMBOL(<fs_dados>).

      ls_return = valida_campos( it_cockpit = it_cockpit is_cockpit = <fs_dados> ).

      IF ls_return IS NOT INITIAL.
        APPEND ls_return TO rt_return.
        lo_events->format_message( CHANGING ct_return = rt_return[] ).
        EXIT.
      ENDIF.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Valida Status do documento
* ---------------------------------------------------------------------------
    LOOP AT it_cockpit ASSIGNING <fs_dados>.

      IF <fs_dados>-statuscode = '100'.
        " Não é permitido agrupar MDF-e autorizado.
        rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '059' ) ).
        lo_events->format_message( CHANGING ct_return = rt_return[] ).
      ENDIF.

      IF <fs_dados>-statuscode > '100'.
        " Não é permitido agrupar MDF-e com erros.
        rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '061' ) ).
        lo_events->format_message( CHANGING ct_return = rt_return[] ).
      ENDIF.

*      IF <fs_dados>-qtdwriter > 0.
*
*        SELECT SINGLE traid
*        FROM j_1bnfdoc
*        INTO @DATA(lv_traid)
*        WHERE docnum = @<fs_dados>-br_notafiscal.    "#EC CI_SEL_NESTED
*
*        IF lv_traid <> <fs_dados>-placa.
*          " NF Writer - Placa do cavalo divergente. Agrupamento não possível.
*          rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '062' ) ).
*          lo_events->format_message( CHANGING ct_return = rt_return[] ).
*        ENDIF.
*
*
*        SELECT SINGLE zzmotorista
*        FROM j_1bnfdoc
*        INTO @DATA(lv_zzbp)
*        WHERE docnum = @<fs_dados>-bpmotorista.      "#EC CI_SEL_NESTED
*
*        IF lv_zzbp <> <fs_dados>-bpmotorista .
*          " BP do condutor divergente.Agrupamento não permitido.
*          rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '063' ) ).
*          lo_events->format_message( CHANGING ct_return = rt_return[] ).
*        ENDIF.
*
*        TRY.
*            DATA(lv_shipperid) = lt_tor[ 1 ]-shipperid.
*          CATCH cx_sy_itab_line_not_found.
*        ENDTRY.
*
*        IF lv_shipperid+6(4) <> <fs_dados>-localexpedicao.
*          " Local de Expedição dos documentos é divergente.Agrupamento não permitido.
*          rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '077' ) ).
*          lo_events->format_message( CHANGING ct_return = rt_return[] ).
*        ENDIF.
*
*      ENDIF.

    ENDLOOP.

    SORT rt_return BY number.
    DELETE ADJACENT DUPLICATES FROM rt_return COMPARING number.

    DATA(lt_cockpit_aux) = it_cockpit.

    SORT lt_cockpit_aux BY agrupador.
    DELETE ADJACENT DUPLICATES FROM lt_cockpit_aux COMPARING agrupador.

    IF line_exists( lt_cockpit_aux[ 2 ] ).

      TRY.
          ev_guid = lt_cockpit_aux[ 2 ]-id.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD valida_campos.
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).
    LOOP AT it_cockpit ASSIGNING FIELD-SYMBOL(<fs_dados>).
      IF is_cockpit-placa <> <fs_dados>-placa.
        " Ordens de Frete com placas distintas. Agrupamento não possível.
        rs_return = VALUE #( type = 'E' id = 'ZTM_MONITOR_MDF' number = '058' ).
        RETURN.
      ENDIF.

      IF is_cockpit-bpmotorista <> <fs_dados>-bpmotorista.
        " BP do condutor divergente.Agrupamento não permitido.
        rs_return = VALUE #( type = 'E' id = 'ZTM_MONITOR_MDF' number = '063' ).
        RETURN.
      ENDIF.

      IF is_cockpit-agrupador <> <fs_dados>-agrupador AND <fs_dados>-agrupador IS NOT INITIAL AND is_cockpit-agrupador IS NOT INITIAL.
        " Não é permitido agrupar MDF-e já agrupada anteriormente.
        rs_return = VALUE #( type = 'E' id = 'ZTM_MONITOR_MDF' number = '065' ).
        RETURN.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD add_message_to_container.
    ro_message_container = io_context->get_message_container( ).

    IF it_return IS SUPPLIED AND it_return IS NOT INITIAL.

      LOOP AT it_return INTO DATA(ls_return).

        IF ls_return-id     IS NOT INITIAL AND
           ls_return-type   IS NOT INITIAL.

          MESSAGE ID ls_return-id
             TYPE ls_return-type
           NUMBER ls_return-number
            WITH ls_return-message_v1
                 ls_return-message_v2
                 ls_return-message_v3
                 ls_return-message_v4
            INTO DATA(lv_dummy).

          ro_message_container->add_message_text_only(
                  EXPORTING iv_msg_type               = ls_return-type
                            iv_msg_text               = CONV #( fill_message( ) )
                            iv_add_to_response_header = abap_false ).

        ELSE.
          ro_message_container->add_message_text_only(
                  EXPORTING iv_msg_type               = ls_return-type
                            iv_msg_text               =  ls_return-message
                            iv_add_to_response_header = abap_false ).
        ENDIF.

      ENDLOOP.

    ELSE.
      ro_message_container->add_message_text_only(
              EXPORTING iv_msg_type               = sy-msgty
                        iv_msg_text               = CONV #( fill_message( ) )
                        iv_add_to_response_header = abap_true ).
    ENDIF.
  ENDMETHOD.


  METHOD fill_message.
    MESSAGE ID sy-msgid
      TYPE sy-msgty
    NUMBER sy-msgno
      INTO rv_message
      WITH sy-msgv1
           sy-msgv2
           sy-msgv3
           sy-msgv4.
  ENDMETHOD.


  METHOD desagrupar.

    DATA: lt_mcd     TYPE STANDARD TABLE OF zttm_mdf_mcd     WITH DEFAULT KEY,
          lt_placa_c TYPE STANDARD TABLE OF zttm_mdf_placa_c WITH DEFAULT KEY,
          lt_placa_v TYPE STANDARD TABLE OF zttm_mdf_placa_v WITH DEFAULT KEY,
          lt_placa   TYPE STANDARD TABLE OF zttm_mdf_placa   WITH DEFAULT KEY,
          lt_moto    TYPE STANDARD TABLE OF zttm_mdf_moto    WITH DEFAULT KEY,
          lt_mdf     TYPE STANDARD TABLE OF zttm_mdf         WITH DEFAULT KEY.

    DATA(lt_return) = me->valida_desagrupar( it_dados ).

    CHECK lt_return IS INITIAL.

    IF it_dados IS NOT INITIAL.

      SELECT guid, statuscode, procstep, stepstatus
      FROM zi_tm_mdf
      FOR ALL ENTRIES IN @it_dados
      WHERE agrupador  EQ @it_dados-agrupador
        AND stepstatus EQ '01'
        AND statuscode NOT IN ('100','101','132')
      INTO TABLE @DATA(lt_guid).

      IF sy-subrc NE 0.
        " Nenhum documento encontrado para desagrupar.
        rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '103' ) ).
        RETURN.
      ENDIF.
    ENDIF.

*    DELETE lt_guid WHERE Stepstatus NE '01'.  " Desconsiderar Documentos com retorno SEFAZ
*    DELETE lt_guid WHERE StatusCode EQ '100'. " Desconsiderar Documentos Aprovados
*    DELETE lt_guid WHERE StatusCode EQ '101'. " Desconsiderar Documentos Cancelados
*    DELETE lt_guid WHERE StatusCode EQ '132'. " Desconsiderar Documentos Encerrados

    IF lt_guid[] IS INITIAL.
      " Desagrupamento não permitido.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '104' ) ).
      RETURN.
    ENDIF.

    SORT lt_guid BY guid.
    DELETE ADJACENT DUPLICATES FROM lt_guid COMPARING guid. "#EC CI_SEL_DEL

    IF lt_guid[] IS NOT INITIAL.
      SELECT client, id, access_key, ordem_frete
      FROM zttm_mdf_mcd
      INTO TABLE @lt_mcd
      FOR ALL ENTRIES IN @lt_guid
      WHERE id = @lt_guid-guid.

      IF sy-subrc = 0.
        SORT lt_mcd BY id access_key ordem_frete.
        DELETE ADJACENT DUPLICATES FROM lt_mcd COMPARING id access_key ordem_frete. "#EC CI_SEL_DEL

        DELETE zttm_mdf_mcd FROM TABLE lt_mcd.
      ENDIF.

      SELECT client, id, placa, condutor
      FROM zttm_mdf_placa_c
      INTO TABLE @lt_placa_c
      FOR ALL ENTRIES IN @lt_guid
      WHERE id = @lt_guid-guid.

      IF sy-subrc = 0.
        SORT lt_placa_c BY id placa condutor.
        DELETE ADJACENT DUPLICATES FROM lt_placa_c COMPARING id placa condutor. "#EC CI_SEL_DEL

        DELETE zttm_mdf_placa_c FROM TABLE lt_placa_c.
      ENDIF.

      SELECT client, id, placa, n_compra
      FROM zttm_mdf_placa_v
      INTO TABLE @lt_placa_v
      FOR ALL ENTRIES IN @lt_guid
      WHERE id = @lt_guid-guid.

      IF sy-subrc = 0.
        SORT lt_placa_v BY id placa n_compra.
        DELETE ADJACENT DUPLICATES FROM lt_placa_v COMPARING id placa n_compra. "#EC CI_SEL_DEL

        DELETE zttm_mdf_placa_v FROM TABLE lt_placa_v.
      ENDIF.

      SELECT client, id, placa
      FROM zttm_mdf_placa
      INTO TABLE @lt_placa
      FOR ALL ENTRIES IN @lt_guid
      WHERE id = @lt_guid-guid.

      IF sy-subrc = 0.
        SORT lt_placa BY id placa.
        DELETE ADJACENT DUPLICATES FROM lt_placa COMPARING id placa. "#EC CI_SEL_DEL

        DELETE zttm_mdf_placa FROM TABLE lt_placa.
      ENDIF.

      SELECT client, id, line, motorista
      FROM zttm_mdf_moto
      INTO TABLE @lt_moto
      FOR ALL ENTRIES IN @lt_guid
      WHERE id = @lt_guid-guid.

      IF sy-subrc = 0.
        SORT lt_moto BY id line motorista.
        DELETE ADJACENT DUPLICATES FROM lt_moto COMPARING id line motorista. "#EC CI_SEL_DEL

        DELETE zttm_mdf_moto FROM TABLE lt_moto.
      ENDIF.

      SELECT client, id
      FROM zttm_mdf
      INTO TABLE @lt_mdf
      FOR ALL ENTRIES IN @lt_guid
      WHERE id = @lt_guid-guid.

      IF sy-subrc = 0.
        SORT lt_mdf BY id.
        DELETE ADJACENT DUPLICATES FROM lt_mdf COMPARING id. "#EC CI_SEL_DEL

        DELETE zttm_mdf FROM TABLE lt_mdf.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD valida_desagrupar.
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    IF line_exists( it_cockpit[ agrupador = '' ] ).      "#EC CI_STDSEQ
      rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '069' ) ).
      lo_events->format_message( CHANGING ct_return = rt_return[] ).
      RETURN.
    ENDIF.

    IF it_cockpit IS NOT INITIAL.
      SELECT  code
      FROM j_1bnfdoc
      INTO TABLE @DATA(lt_code)
      FOR ALL ENTRIES IN @it_cockpit
      WHERE docnum = @it_cockpit-br_notafiscal.
    ENDIF.

    IF line_exists( lt_code[ code = '100' ] ).           "#EC CI_STDSEQ
      rt_return[] = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '070' ) ).
      lo_events->format_message( CHANGING ct_return = rt_return[] ).
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD print_pdf.
    DATA(lo_events) = NEW zcltm_mdf_events_manual(  ).

    DATA lo_cached_response    TYPE REF TO if_http_response.

    DATA: lt_accesskey TYPE ty_t_access_key,
          lt_otf       TYPE STANDARD TABLE OF itcoo,
          lt_pdf       TYPE tlinet,
          lt_host      TYPE STANDARD TABLE OF /sdf/icm_data_struc.

    DATA: lv_smartform    TYPE rs38l_fnam,
          lv_pdf_filesize TYPE i,
          lv_guid         TYPE guid_32.

    DATA: ls_control_parameters TYPE ssfctrlop,
          ls_output_options     TYPE ssfcompop,
          ls_job_output_info    TYPE ssfcrescl.

* ----------------------------------------------------------------------
* Determine function name
* ----------------------------------------------------------------------
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname = gc_name_mdfe
      IMPORTING
        fm_name  = lv_smartform.

    IF lv_smartform IS INITIAL.
      " Relatório &1 indisponível.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '087' message_v1 = gc_name_mdfe ) ).
      lo_events->format_message( CHANGING ct_return = et_return[] ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Busca dados para preencher PDF
* ----------------------------------------------------------------------
    me->get_data_to_print( EXPORTING it_id         = it_id
                           IMPORTING et_print      = DATA(lt_print)
                                     et_return    = et_return ).

    lo_events->format_message( CHANGING ct_return = et_return[] ).

    CHECK lt_print[] IS NOT INITIAL.

* ----------------------------------------------------------------------
* Prepare information
* ----------------------------------------------------------------------
    LOOP AT lt_print ASSIGNING FIELD-SYMBOL(<fs_print>).

      " Spool control
      AT FIRST.
        ls_control_parameters-no_open  = abap_false.
        ls_control_parameters-no_close = abap_true.
      ENDAT.
      AT LAST.
        ls_control_parameters-no_close = abap_false.
      ENDAT.

      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-preview   = space.
      IF iv_printer IS INITIAL.
        ls_control_parameters-getotf    = abap_true.                " Return OTF. Later we will convert to PDF.
        ls_output_options-tddest        = gc_printer.
      ELSE.
        ls_output_options-tddest        = iv_printer.
        ls_output_options-tdimmed       = abap_true.
        ls_output_options-tdnewid       = abap_true.
      ENDIF.


      CALL FUNCTION lv_smartform
        EXPORTING
          control_parameters = ls_control_parameters
          output_options     = ls_output_options
          user_settings      = space
          gs_damdfe          = <fs_print>-damdfe
          iv_homologation    = abap_true
*         IV_CONTINGENCY     =
        IMPORTING
          job_output_info    = ls_job_output_info
        TABLES
          gt_condutor        = <fs_print>-t_condutor
          gt_nfe             = <fs_print>-t_nfe
          gt_observacao      = <fs_print>-t_observacao
        EXCEPTIONS
          formatting_error   = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.

      IF sy-subrc <> 0.
        " Houveram erros durante geração do relatório.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '089' ) ).
        RETURN.
      ENDIF.

      INSERT LINES OF ls_job_output_info-otfdata[] INTO TABLE lt_otf[].

* ----------------------------------------------------------------------
* Manage user input
* ----------------------------------------------------------------------
      IF ls_job_output_info-userexit   IS NOT INITIAL AND
         ls_job_output_info-outputdone IS INITIAL.
        RETURN.
      ENDIF.

* ----------------------------------------------------------------------
* Prepare parameters for next document
* ----------------------------------------------------------------------
      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-preview   = space.
      ls_control_parameters-no_open   = abap_true.

    ENDLOOP.

* ----------------------------------------------------------------------
* Print spool
* ----------------------------------------------------------------------
    TRY.
        " Relatório gerado! Nº spool: &1.
        et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '090' message_v1 = ls_job_output_info-spoolids[ 1 ] ) ).
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Convert smartform OTF to PDF
* ----------------------------------------------------------------------
    IF iv_printer IS INITIAL.

      CALL FUNCTION 'CONVERT_OTF'
        EXPORTING
          format                = 'PDF'
        IMPORTING
          bin_filesize          = lv_pdf_filesize
          bin_file              = ev_pdf_file
        TABLES
          otf                   = lt_otf[]
          lines                 = lt_pdf[]
        EXCEPTIONS
          err_max_linewidth     = 1
          err_format            = 2
          err_conv_not_possible = 3
          err_bad_otf           = 4
          OTHERS                = 5.

      IF sy-subrc <> 0.
        et_return[] = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
        RETURN.
      ENDIF.

    ENDIF.

* ======================================================================
* Verifica se opção de Publicar e recuperar URL foi selecionada
* ======================================================================
    IF iv_get_url IS NOT INITIAL.

* ----------------------------------------------------------------------
* Prepare to create HTTP Response
* ----------------------------------------------------------------------
      CREATE OBJECT lo_cached_response
        TYPE
        cl_http_response
        EXPORTING
          add_c_msg = 1.

* ----------------------------------------------------------------------
* Set the data and the headers
* ----------------------------------------------------------------------
      lo_cached_response->set_data( ev_pdf_file ).

      DATA(lv_app_type) = CONV string( '.PDF' ).

      lo_cached_response->set_header_field( name  = if_http_header_fields=>content_type
                                            value = lv_app_type ).

* ----------------------------------------------------------------------
* Set the Response Status
* ----------------------------------------------------------------------
      lo_cached_response->set_status( code = 200 reason = 'OK' ).

* ----------------------------------------------------------------------
* Set the Cache Timeout - 60 seconds - we only need this in the cache
* long enough to build the page
* ----------------------------------------------------------------------
      lo_cached_response->server_cache_expire_rel( expires_rel = 60 ).

* ----------------------------------------------------------------------
* Create a unique URL for the object and export URL
* ----------------------------------------------------------------------
*      CALL FUNCTION 'GUID_CREATE'
*        IMPORTING
*          ev_guid_32 = lv_guid.

      TRY.
          lv_guid = cl_system_uuid=>create_uuid_c32_static( ).
        CATCH cx_root.
      ENDTRY.

      CONCATENATE  '/sap/public' '/' lv_guid '.' 'pdf' INTO ev_url.

* ----------------------------------------------------------------------
* Cache the URL
* ----------------------------------------------------------------------
      cl_http_server=>server_cache_upload( url      = ev_url
                                           response = lo_cached_response ).

* ----------------------------------------------------------------------
* Get hostname and port
* ----------------------------------------------------------------------
      CALL FUNCTION '/SDF/GET_ICM_VIRT_HOST_DATA'
        TABLES
          icm_data       = lt_host[]
        EXCEPTIONS
          not_authorized = 1
          OTHERS         = 2.

      IF sy-subrc <> 0.
        FREE lt_host.
      ENDIF.

      TRY.
          ev_complete_url = |http://{ lt_host[ 1 ]-fqhostname }:{ lt_host[ 1 ]-port }{ ev_url }|.
        CATCH cx_root.
      ENDTRY.

    ENDIF.


  ENDMETHOD.

  METHOD get_data_to_print.
    DATA: ls_print       TYPE ty_print,
          ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          ls_address1    TYPE addr1_val,
          lv_cgc_number  TYPE j_1bcgc,
          lt_observacao  TYPE ty_t_observacao,
          lv_cont_placas TYPE i,
          lv_torid       TYPE n LENGTH 20.

    CONSTANTS: lc_descr_of TYPE char30 VALUE 'Ordem de Frete/Agrupamento'.

    FREE: et_print, et_return.

*    SELECT Guid, Agrupador, rntrc, BR_MDFeSeries, AccessKey, CompanyCode, HoraInicioViagem, BusinessPlace, QtdNfe, UfFim
    IF it_id IS NOT INITIAL.

      SELECT *
      FROM zi_tm_mdf
      FOR ALL ENTRIES IN @it_id
      WHERE guid       EQ @it_id-guid
        AND statuscode EQ '100'
      INTO TABLE @DATA(lt_mdf).

* ----------------------------------------------------------------------
* Validação inicial
* ----------------------------------------------------------------------
      IF sy-subrc NE 0.
        " Nenhum dado encontrado para os parâmetros informados
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '088' ) ).
        RETURN.
      ENDIF.

    ENDIF.

* ----------------------------------------------------------------------
* Recupera dados de complemento
* ----------------------------------------------------------------------
    IF it_id IS NOT INITIAL.

*      SELECT Guid, AccessKey, FreightOrder, BR_NotaFiscal, HeaderGrossweight, HeaderNetWeight,
      SELECT guid, accesskey, freightorder, br_notafiscal, headergrossweight, headernetweight, br_nfenumber
      FROM zi_tm_mdf_municipio
      FOR ALL ENTRIES IN @it_id
      WHERE guid EQ @it_id-guid
      INTO TABLE @DATA(lt_municipio).

      IF sy-subrc EQ 0.
        SORT lt_municipio BY guid.

        DATA(lt_of) = lt_municipio[].
        DELETE lt_of WHERE freightorder IS INITIAL.
        DELETE lt_of WHERE freightorder = '00000000000000000000'.

        IF lt_of[] IS NOT INITIAL.
          SORT lt_of BY guid
                        freightorder.
          DELETE ADJACENT DUPLICATES FROM lt_of COMPARING guid
                                                          freightorder.
        ENDIF.

        DATA(lt_nf) = lt_municipio[].
        DELETE lt_nf WHERE br_notafiscal IS INITIAL.

        IF lt_nf[] IS NOT INITIAL.
          SORT lt_nf BY guid
                        br_notafiscal.
          DELETE ADJACENT DUPLICATES FROM lt_nf COMPARING guid
                                                          br_notafiscal.
        ENDIF.
      ENDIF.

      SELECT id, uf, mod
      FROM zi_tm_mdf_complemento
      FOR ALL ENTRIES IN @it_id
      WHERE id       EQ @it_id-guid
      INTO TABLE @DATA(lt_complemento).

      IF sy-subrc EQ 0.
        SORT lt_complemento BY id.
      ENDIF.

      SELECT id, motorista, cpf, nome, atualmotorista
      FROM zi_tm_mdf_motorista
      FOR ALL ENTRIES IN @it_id
      WHERE id       EQ @it_id-guid
      INTO TABLE @DATA(lt_motorista).

      IF sy-subrc EQ 0.
        SORT lt_motorista BY id.
      ENDIF.

      SELECT id,
             dh_emi
      FROM zttm_mdf_ide
      FOR ALL ENTRIES IN @it_id
      WHERE id EQ @it_id-guid
      INTO TABLE @DATA(lt_mdf_ide).
    ENDIF.

* ----------------------------------------------------------------------
* Recupera dados de Placa
* ----------------------------------------------------------------------
    IF it_id IS NOT INITIAL.
      SELECT id, placa, reboque, tara, capkg, capm3,
             ativo, proprietario, nome, cpf, cpftext, cnpj, cnpjtext
      FROM zi_tm_mdf_placa
      FOR ALL ENTRIES IN @it_id
      WHERE id       EQ @it_id-guid
*        AND Reboque EQ @abap_false
      INTO TABLE @DATA(lt_placas).

      IF sy-subrc EQ 0.
        SORT lt_placas BY id reboque.
      ENDIF.
    ENDIF.

    IF lt_placas IS NOT INITIAL.

      SELECT id, placa, condutor, cpf, cpftext, nome
      FROM zi_tm_mdf_placa_condutor
      FOR ALL ENTRIES IN @lt_placas
      WHERE id    EQ @lt_placas-id
        AND placa EQ @lt_placas-placa
      INTO TABLE @DATA(lt_condutor).

      IF sy-subrc EQ 0.
        SORT lt_condutor BY id placa.
      ENDIF.

      SELECT id, placa, ncompra, fornecedor, cnpjforn,
             cnpjforntext, pagador, cnpjpg, cnpjpgtext, cpfpg,
             cpfpgtext, valorvaleped
      FROM zi_tm_mdf_placa_vale_pedagio
      FOR ALL ENTRIES IN @lt_placas
      WHERE id    EQ @lt_placas-id
        AND placa EQ @lt_placas-placa
      INTO TABLE @DATA(lt_vale_pedagio).

      IF sy-subrc EQ 0.
        SORT lt_vale_pedagio BY id placa.
      ENDIF.

    ENDIF.

    LOOP AT lt_mdf ASSIGNING FIELD-SYMBOL(<fs_mdf>).

      CLEAR ls_print.
      ls_print-damdfe-mdfenum         = <fs_mdf>-br_mdfenumber.
      ls_print-damdfe-num_nfe         = <fs_mdf>-br_mdfenumber.
      ls_print-damdfe-ch_nfe          = <fs_mdf>-br_mdfeseries.
      ls_print-damdfe-serie           = <fs_mdf>-br_mdfeseries.
      ls_print-damdfe-uf_carrega      = <fs_mdf>-ufinicio.
      ls_print-damdfe-uf_descarrega   = <fs_mdf>-uffim.
      ls_print-damdfe-rntrc           = <fs_mdf>-rntrc.
      ls_print-damdfe-serie           = <fs_mdf>-br_mdfeseries.
      ls_print-damdfe-chave_acesso    = <fs_mdf>-accesskey.
      ls_print-damdfe-bukrs           = <fs_mdf>-companycode.
      ls_print-damdfe-razao_social    = <fs_mdf>-companycodename.
*      ls_print-damdfe-data_emissao    = <fs_mdf>-datainicioviagem.
*      ls_print-damdfe-hora_emissao    = <fs_mdf>-horainicioviagem.

      IF line_exists( lt_mdf_ide[ id = <fs_mdf>-guid ] ).
        CONVERT TIME STAMP lt_mdf_ide[ id = <fs_mdf>-guid ]-dh_emi
                 TIME ZONE sy-zonlo
                 INTO TIME ls_print-damdfe-hora_emissao
                      DATE ls_print-damdfe-data_emissao.

      ENDIF.

      ls_print-damdfe-quant_nfe       = <fs_mdf>-qtdnfe + <fs_mdf>-qtdnfewrt + <fs_mdf>-qtdnfeext.  " CHANGE - JWSILVA - 01.03.2023
      ls_print-damdfe-agrupador       = |{ <fs_mdf>-agrupador ALPHA = OUT }|.

      LOOP AT lt_municipio REFERENCE INTO DATA(ls_municipio).
        CHECK ls_municipio->guid EQ <fs_mdf>-guid.
        ls_print-damdfe-peso_total = ls_print-damdfe-peso_total + ls_municipio->headergrossweight.

        lv_torid = ls_municipio->freightorder.
        IF lv_torid IS INITIAL.
          CLEAR: ls_municipio->freightorder.
        ENDIF.

*        ls_print-damdfe-ordens_frete = COND #( WHEN ls_municipio->freightorder IS NOT INITIAL AND ls_print-damdfe-ordens_frete IS INITIAL
*                                               THEN |{ ls_municipio->freightorder ALPHA = OUT }|
*                                               WHEN ls_municipio->freightorder IS NOT INITIAL AND ls_print-damdfe-ordens_frete IS NOT INITIAL
*                                               THEN |{ ls_print-damdfe-ordens_frete }, { ls_municipio->freightorder ALPHA = OUT }|
*                                               ELSE ls_print-damdfe-ordens_frete ).
*
*        ls_print-damdfe-nota_fiscal  = COND #( WHEN ls_municipio->br_notafiscal IS NOT INITIAL AND ls_print-damdfe-nota_fiscal IS INITIAL
*                                               THEN |{ ls_municipio->br_notafiscal ALPHA = OUT }|
*                                               WHEN ls_municipio->br_notafiscal IS NOT INITIAL AND ls_print-damdfe-nota_fiscal IS NOT INITIAL
*                                               THEN |{ ls_print-damdfe-nota_fiscal }, { ls_municipio->br_notafiscal ALPHA = OUT }|
*                                               ELSE ls_print-damdfe-nota_fiscal ).

*        ls_print-t_nfe[] = VALUE #( BASE ls_print-t_nfe ( text = |NFE { ls_municipio->BR_NotaFiscal } - { ls_municipio->AccessKey }| ) ).
        ls_print-t_nfe[] = VALUE #( BASE ls_print-t_nfe ( text = |NFE { ls_municipio->br_nfenumber } - { ls_municipio->accesskey }| ) ).
      ENDLOOP.

      READ TABLE lt_of TRANSPORTING NO FIELDS
                                     WITH KEY guid = <fs_mdf>-guid
                                     BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_of REFERENCE INTO DATA(ls_of) FROM sy-tabix.
          IF ls_of->guid NE <fs_mdf>-guid.
            EXIT.
          ENDIF.

          ls_print-damdfe-ordens_frete = COND #( WHEN ls_of->freightorder IS NOT INITIAL AND ls_print-damdfe-ordens_frete IS INITIAL
                                                 THEN |{ ls_of->freightorder ALPHA = OUT }|
                                                 WHEN ls_of->freightorder IS NOT INITIAL AND ls_print-damdfe-ordens_frete IS NOT INITIAL
                                                 THEN |{ ls_print-damdfe-ordens_frete }, { ls_of->freightorder ALPHA = OUT }|
                                                 ELSE ls_print-damdfe-ordens_frete ).
        ENDLOOP.
      ENDIF.

      READ TABLE lt_nf TRANSPORTING NO FIELDS
                                     WITH KEY guid = <fs_mdf>-guid
                                     BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_nf REFERENCE INTO DATA(ls_nf) FROM sy-tabix.
          IF ls_nf->guid NE <fs_mdf>-guid.
            EXIT.
          ENDIF.

          ls_print-damdfe-nota_fiscal  = COND #( WHEN ls_nf->br_notafiscal IS NOT INITIAL AND ls_print-damdfe-nota_fiscal IS INITIAL
                                                 THEN |{ ls_nf->br_notafiscal ALPHA = OUT }|
                                                 WHEN ls_nf->br_notafiscal IS NOT INITIAL AND ls_print-damdfe-nota_fiscal IS NOT INITIAL
                                                 THEN |{ ls_print-damdfe-nota_fiscal }, { ls_nf->br_notafiscal ALPHA = OUT }|
                                                 ELSE ls_print-damdfe-nota_fiscal ).
        ENDLOOP.
      ENDIF.

      ls_print-t_nfe[] = VALUE #( BASE ls_print-t_nfe ( text = |{ lc_descr_of } : { ls_print-damdfe-ordens_frete } / { ls_print-damdfe-agrupador }| ) ).

*      CLEAR: lv_cont_placas.
*     LOOP AT lt_placas ASSIGNING FIELD-SYMBOL(<fs_placas>) WHERE reboque EQ abap_true.
*
*        ADD 1 TO lv_cont_placas.
*
*        READ TABLE ls_print-t_nfe ASSIGNING FIELD-SYMBOL(<fs_nfe>) INDEX lv_cont_placas.

*       IF sy-subrc IS INITIAL.

*         <fs_nfe>-id_unid_transp = <fs_placas>-placa.

*       ELSE.

*         APPEND INITIAL LINE TO ls_print-t_nfe ASSIGNING <fs_nfe>.
*          <fs_nfe>-id_unid_transp = <fs_placas>-placa.

*        ENDIF.
*      ENDLOOP.

      ls_print-damdfe-protocolo       = <fs_mdf>-protocol.
      ls_print-damdfe-tknum           = space.

      CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
        EXPORTING
          branch            = <fs_mdf>-businessplace
          bukrs             = <fs_mdf>-companycode
        IMPORTING
          address           = ls_address
          branch_data       = ls_branch_data
          cgc_number        = lv_cgc_number
          address1          = ls_address1
        EXCEPTIONS
          branch_not_found  = 1
          address_not_found = 2
          company_not_found = 3
          OTHERS            = 4.

      IF sy-subrc EQ 0.
        ls_print-damdfe-cnpj          = lv_cgc_number.
*        ls_print-damdfe-logradouro    = ls_address1-street.
        ls_print-damdfe-logradouro    = |{ ls_address1-street && ', ' && ls_address1-house_num1 }|.
        ls_print-damdfe-bairro        = ls_address1-city2.
        ls_print-damdfe-cep           = ls_address1-post_code1.
        ls_print-damdfe-municipio     = ls_address1-city1.
        ls_print-damdfe-ie            = ls_branch_data-state_insc.
        ls_print-damdfe-complemento   = ls_address1-house_num2.
      ENDIF.

      " Recupera motorista atual
      TRY.
          DATA(ls_motorista) = lt_motorista[ id             = <fs_mdf>-guid
                                             atualmotorista = abap_true ].
        CATCH cx_root.
      ENDTRY.

      " Recupera restante dos motoristas
      DATA(lt_motorista_t) = lt_motorista[].
      DELETE lt_motorista_t WHERE id NE <fs_mdf>-guid.
      DELETE lt_motorista_t WHERE motorista EQ ls_motorista-motorista.
      SORT lt_motorista_t BY motorista.
      DELETE ADJACENT DUPLICATES FROM lt_motorista_t COMPARING motorista.

      " Caso não haja proprietário, então usar Emitente
      ls_print-damdfe-nome_cond     = ls_motorista-nome.
      ls_print-damdfe-cpf           = ls_motorista-cpf.

      DATA(lv_id) = 0.

      LOOP AT lt_motorista_t REFERENCE INTO DATA(ls_moto).

        ADD 1 TO lv_id.
        ls_print-t_condutor[] = VALUE #( BASE ls_print-t_condutor ( id     = lv_id
                                                                    x_nome = ls_moto->nome
                                                                    cpf    = ls_moto->cpf ) ).
      ENDLOOP.

*      LOOP AT lt_condutor REFERENCE INTO DATA(ls_condutor).
*
*        CHECK ls_condutor->Id EQ <fs_mdf>-Guid.
*        CHECK ls_condutor->Condutor NE ls_motorista-Motorista.
*
*        ADD 1 TO lv_id.
*        ls_print-t_condutor[] = VALUE #( BASE ls_print-t_condutor ( id     = lv_id
*                                                                    x_nome = ls_condutor->Nome
*                                                                    cpf    = ls_condutor->Cpf ) ).
*      ENDLOOP.

      READ TABLE lt_placas ASSIGNING FIELD-SYMBOL(<fs_placa>) WITH KEY id      = <fs_mdf>-guid
                                                                       reboque = abap_false
                                                              BINARY SEARCH.
      IF sy-subrc = 0.
        ls_print-damdfe-placa         = <fs_placa>-placa.

        IF <fs_placa>-proprietario IS NOT INITIAL.
          ls_print-damdfe-cnpj_prop     = <fs_placa>-cnpj.
        ENDIF.

        READ TABLE lt_vale_pedagio REFERENCE INTO DATA(ls_vale_pedagio) WITH KEY id    = <fs_placa>-id
                                                                                 placa = <fs_placa>-placa
                                                                         BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_print-damdfe-ped_cnpjpg     = ls_vale_pedagio->cnpjpg.
          ls_print-damdfe-ncompra        = ls_vale_pedagio->ncompra.
        ENDIF.

      ENDIF.

      LOOP AT lt_placas ASSIGNING <fs_placa>.

        CHECK <fs_placa>-id      = <fs_mdf>-guid
          AND <fs_placa>-reboque = abap_true.

        IF ls_print-damdfe-placa_sr1 IS INITIAL.
          ls_print-damdfe-placa_sr1   = <fs_placa>-placa.
          ls_print-damdfe-rntrc_sr1   = space.
          CONTINUE.
        ENDIF.

        IF ls_print-damdfe-placa_sr2 IS INITIAL.
          ls_print-damdfe-placa_sr2   = <fs_placa>-placa.
          ls_print-damdfe-rntrc_sr2   = space.
          CONTINUE.
        ENDIF.

        IF ls_print-damdfe-placa_sr3 IS INITIAL.
          ls_print-damdfe-placa_sr3   = <fs_placa>-placa.
          ls_print-damdfe-rntrc_sr3   = space.
          CONTINUE.
        ENDIF.

      ENDLOOP.

      READ TABLE lt_complemento ASSIGNING FIELD-SYMBOL(<fs_complemento>) WITH KEY id = <fs_mdf>-guid
                                                                         BINARY SEARCH.
      IF sy-subrc = 0.
        ls_print-damdfe-uf            = <fs_complemento>-uf.
        ls_print-damdfe-modelo        = <fs_complemento>-mod.
      ENDIF.

      IF <fs_mdf>-infofisco IS NOT INITIAL.
        FREE lt_observacao.
        CALL FUNCTION 'CONVERT_STRING_TO_TABLE'
          EXPORTING
            i_string         = <fs_mdf>-infofisco
            i_tabline_length = 255
          TABLES
            et_table         = lt_observacao.
      ENDIF.

      LOOP AT lt_observacao REFERENCE INTO DATA(ls_observacao).
        ls_print-t_observacao[] = VALUE #( BASE ls_print-t_observacao ( ls_observacao->* ) ).
      ENDLOOP.

      IF <fs_mdf>-infocontrib IS NOT INITIAL.
        FREE lt_observacao.
        CALL FUNCTION 'CONVERT_STRING_TO_TABLE'
          EXPORTING
            i_string         = <fs_mdf>-infocontrib
            i_tabline_length = 255
          TABLES
            et_table         = lt_observacao.
      ENDIF.

      LOOP AT lt_observacao REFERENCE INTO ls_observacao.
        ls_print-t_observacao[] = VALUE #( BASE ls_print-t_observacao ( ls_observacao->* ) ).
      ENDLOOP.

      APPEND ls_print TO et_print[].

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.
    IF er_auth_bukrs IS SUPPLIED.
      SELECT bukrs
        FROM t001
        INTO @DATA(lv_bukrs).

        IF zclfi_auth_zfibukrs=>check_custom(
            iv_bukrs = lv_bukrs
            iv_actvt = zclfi_auth_zfibukrs=>gc_actvt-exibir
        ) = abap_true.

          APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_bukrs ) TO er_auth_bukrs.

        ENDIF.
      ENDSELECT.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
