"!<p><h2>Integração de Ordens de Frete com o Sistema GKO</h2></p>
"!<p>Esta classe é utilizada na chamada da rotina PPF na ordem de frete.
"!Deve ser configurada para todos os tipos de ordem de frete relevantes para a integração com o GKO</p>
"!<p><strong>Autor: </strong>Marcos Roberto de Souza</p>
"!<p><strong>Data: </strong>25 de fev de 2022</p>
CLASS zcltm_interface_fo_gko DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES:
      "!Tipo de dados para informações de nota fiscal eletrônica
      BEGIN OF ty_notas,
        remessa TYPE c LENGTH 10,
        fatura  TYPE c LENGTH 10,
        docnum  TYPE j_1bdocnum,
*        cfop       TYPE j_1bnflin-cfop,
        status  TYPE j_1bstatuscode,
        nfe_key TYPE c LENGTH 44,
        nftype  TYPE j_1bnfdoc-nftype,
        nfenum  TYPE j_1bnfdoc-nfenum,
        series  TYPE j_1bnfdoc-series,
        docdat  TYPE j_1bnfdoc-docdat,
        partyp  TYPE j_1bnfdoc-partyp,
        bukrs   TYPE j_1bnfdoc-bukrs,
        branch  TYPE j_1bnfdoc-branch,
        parid   TYPE j_1bnfdoc-parid,
        inco1   TYPE j_1bnfdoc-inco1,
        lfart   TYPE likp-lfart,
      END OF ty_notas .
    TYPES:
      BEGIN OF ty_taxanf,
        docnum TYPE j_1bdocnum,
        itmnum TYPE j_1bitmnum,
        taxtyp TYPE j_1btaxtyp,
        base   TYPE j_1bbase,
        rate   TYPE j_1btxrate,
        taxval TYPE j_1btaxval,
        excbas TYPE j_1bexcbas,
        othbas TYPE j_1bothbas,
        stattx TYPE j_1bstattx,
        matnr  TYPE j_1bnflin-matnr,
      END OF ty_taxanf .
    TYPES:
      BEGIN OF ty_datagen,
        cdmotor        TYPE ze_motorista,
        nmmotor        TYPE c LENGTH 100,
        cdtransp       TYPE /scmtms/pty_carrier,
        cnpj_transp    TYPE bptaxnum,
        dthr_inicarreg TYPE /scmtms/stop_assgn_start_l,
        wei_romaneio   TYPE /scmtms/qua_net_wei_val,
        vrtotalkm      TYPE /scmtms/total_distance,
        tures_tco      TYPE /scmtms/equip_type,
        platernumber   TYPE /scmtms/resplatenr,
      END OF ty_datagen .
    TYPES:
            "!Tabela de notas fiscais eletrônicas
      ty_notas_t TYPE SORTED TABLE OF ty_notas WITH NON-UNIQUE KEY remessa
                                               WITH NON-UNIQUE SORTED KEY status COMPONENTS status .
    TYPES:
      BEGIN OF ty_ref,
        vbeln_vl TYPE /scmtms/base_btd_id, "lips-vbeln,
        posnr_vl TYPE /scmtms/base_btd_item_id, "lips-posnr,
        vbeln_vf TYPE vbrp-vbeln,
        posnr_vf TYPE vbrp-posnr,
        docnum   TYPE j_1bnflin-docnum,
        itmnum   TYPE j_1bnflin-itmnum,
        cfop     TYPE j_1bnflin-cfop,
        netwr    TYPE j_1bnflin-netwr,
      END OF ty_ref .
    TYPES:
      ty_ref_t TYPE SORTED TABLE OF ty_ref
                  WITH NON-UNIQUE KEY vbeln_vl posnr_vl .
    TYPES ty_notas_red TYPE zi_tm_integra_gko_redespacho .
    TYPES:
      ty_notas_red_t TYPE SORTED TABLE OF ty_notas_red WITH NON-UNIQUE KEY freightorder
                                                           WITH NON-UNIQUE SORTED KEY status COMPONENTS status .
    TYPES:
      ty_taxnf_t TYPE SORTED TABLE OF ty_taxanf WITH UNIQUE KEY docnum itmnum taxtyp .
    TYPES:
      "!Tipo com os documentos fiscais da ordem de frete
      BEGIN OF ty_bp,
        bptaxtype   TYPE i_businesspartnertaxnumber-bptaxtype,
        bptaxnumber TYPE i_businesspartnertaxnumber-bptaxnumber,
      END OF ty_bp .
    TYPES:
            "!Tabela dos documentos fiscais dos parceiros
      ty_bp_t TYPE SORTED TABLE OF ty_bp WITH UNIQUE KEY primary_key COMPONENTS bptaxtype .
    TYPES:
      "!Tipo com as paradas da ordem de frete
      BEGIN OF ty_stops,
        stop_id       TYPE i_transportationorderstop-transportationorderstopuuid,
        stop_cat      TYPE i_transportationorderstop-transpordstopcategory,
        stop_location TYPE i_transportationorderstop-locationid,
      END OF ty_stops .
    TYPES:
            "!Tipo Tabela com as paradas da ordem de frete
      ty_stops_t TYPE SORTED TABLE OF ty_stops WITH NON-UNIQUE KEY primary_key COMPONENTS stop_cat .
    TYPES:
      "!Tipo com informações sobre os parceiros da OF
      BEGIN OF ty_partner,
        br_nfpartnerfunction          TYPE i_br_nfpartner_c-br_nfpartnerfunction,
        br_nfpartner                  TYPE i_br_nfpartner_c-br_nfpartner,
        br_nfpartnertype              TYPE i_br_nfpartner_c-br_nfpartnertype,
        br_nfpartnernamefrmtddesc     TYPE i_br_nfpartner_c-br_nfpartnernamefrmtddesc,
        br_nfpartnerstreetname        TYPE i_br_nfpartner_c-br_nfpartnerstreetname,
        br_nfpartnerdistrictname      TYPE i_br_nfpartner_c-br_nfpartnerdistrictname,
        br_nfpartnercityname          TYPE i_br_nfpartner_c-br_nfpartnercityname,
        br_nfpartnerregioncode        TYPE i_br_nfpartner_c-br_nfpartnerregioncode,
        br_nfpartnerpostalcode        TYPE i_br_nfpartner_c-br_nfpartnerpostalcode,
        br_nfpartnerisnaturalperson   TYPE i_br_nfpartner_c-br_nfpartnerisnaturalperson,
        br_nfpartnerregistrationfrmtd TYPE i_br_nfpartner_c-br_nfpartnerregistrationfrmtd,
        br_notafiscal                 TYPE i_br_nfpartner_c-br_notafiscal,
        br_nfpartnerstatetaxnumber    TYPE i_br_nfpartner_c-br_nfpartnerstatetaxnumber,
      END OF ty_partner .
    TYPES:
            "!Tipo de tabela dos parceiros da OF
      ty_partners TYPE STANDARD TABLE OF ty_partner .    "SORTED TABLE OF ty_partner WITH NON-UNIQUE KEY primary_key COMPONENTS br_nfpartnerfunction .
    TYPES:
      "!Tipo com os dados da cubagem da OF
      BEGIN OF ty_cubagem,
        remessa    TYPE zttm_cubagem-remessa,
        peso_total TYPE zttm_cubagem-peso_total,
        volume     TYPE zttm_cubagem-volume,
      END OF ty_cubagem .
    TYPES:
            "!Tipo de tabela de cubagens
      ty_cubagem_t TYPE SORTED TABLE OF ty_cubagem WITH UNIQUE KEY primary_key COMPONENTS remessa .
    TYPES:
      "!Tipo com a hierarquia dos produtos
      BEGIN OF ty_hierarquia,
        matnr TYPE /scmtms/s_tor_item_tr_k-product_id,
        prdha TYPE mara-prdha,
        matkl TYPE mara-matkl,
      END OF ty_hierarquia .
    TYPES:
            "!Tipo de tabela da hierarquia dos produtos
      ty_hierarquia_t TYPE SORTED TABLE OF ty_hierarquia WITH UNIQUE KEY primary_key COMPONENTS matnr .

    CONSTANTS:
             "!Classe de mensagens de erros
      gc_msg TYPE c LENGTH 10 VALUE 'ZTM_IF_GKO' ##NO_TEXT.
    CONSTANTS:
      BEGIN OF gc_interface,
        gko       TYPE c LENGTH 2 VALUE '01',
        greenmile TYPE c LENGTH 2 VALUE '02',
        trafegus  TYPE c LENGTH 2 VALUE '03',
      END OF gc_interface .

    "! Verificação e geração do arquivo para o GKO
    "! @parameter iv_tor_key | Chave da ordem de frete
    "! @parameter et_messages | Mensagens durante o processamento da interface
    METHODS gerar_arquivo_gko
      IMPORTING
        !iv_tor_key  TYPE /bobf/conf_key
      EXPORTING
        !et_messages TYPE /scmtms/t_symsg .
    METHODS check_all_ok
      IMPORTING
        !iv_tor_key   TYPE /bobf/conf_key
        !iv_interface TYPE char2 DEFAULT zcltm_interface_fo_gko=>gc_interface-gko
      EXPORTING
        !et_messages  TYPE /scmtms/t_symsg
      RETURNING
        VALUE(rv_ok)  TYPE abap_bool .
  PRIVATE SECTION.

    DATA : BEGIN OF gr_parameter,
             tor_type   TYPE RANGE OF /scmtms/tor_type,
             cond_exped TYPE RANGE OF ze_cond_exped,
             tipo_exped TYPE RANGE OF ze_tipo_exped,
             lfart      TYPE RANGE OF likp-lfart,
           END OF gr_parameter.

    "!Instância do service manager da ordem de frete (/SCMTMS/TOR)
    DATA go_srv_mng TYPE REF TO /bobf/if_tra_service_manager .
    "!Conteúdo do nó root da ordem de frete
    DATA gs_root TYPE /scmtms/s_tor_root_k .
    "!Conteúdo do nó root da unidade de frete
    DATA gt_unid_frete TYPE /scmtms/t_tor_root_k .
    "!Conteúdo do nó ITEM_TR da ordem de frete
    DATA gt_items TYPE /scmtms/t_tor_item_tr_k .
    DATA:
            "!Conteúdo do arquivo a ser gravado
      gt_file_content  TYPE STANDARD TABLE OF string .
    "!Lista de remessas da ordem de frete
    DATA gt_remessas TYPE ty_notas_t .
    DATA gt_ref TYPE ty_ref_t .
    "!Lista de remessas da ordem de frete redespacho
    DATA gt_remessas_red TYPE ty_notas_red_t .
    "!Documentos fiscais do recebedor da mercadoria
    DATA gt_consignee TYPE ty_bp_t .
    "!Documentos fiscais da transportadora
    DATA gt_carrier TYPE ty_bp_t .
    "!Paradas da ordem de frete
    DATA gt_stops TYPE ty_stops_t .
    "!Parceiros da ordem de frete
    DATA gt_partners TYPE ty_partners .
    "Cubagem das remessas na ordem de frete
    DATA gt_cubagem TYPE ty_cubagem_t .
    "!Hierarquia dos produtos contidos na ordem de frete
    DATA gt_hierarquia TYPE ty_hierarquia_t .
    "!Diretório onde será gerado o arquivo
    DATA gv_pasta_arquivo TYPE string .
    DATA gs_datagen TYPE ty_datagen .
    DATA gt_taxanf TYPE ty_taxnf_t .

    "! Em caso de redespacho, recupera o ID da mãe
    METHODS get_mother_tor_id
      IMPORTING
        !iv_tor_key TYPE /bobf/conf_key
      EXPORTING
        !ev_tor_key TYPE /bobf/conf_key .
    "! Ler os dados do nó root da ordem de frete
    "! @parameter iv_tor_key | Chave da ordem de frete
    METHODS get_root
      IMPORTING
        !iv_tor_key TYPE /bobf/conf_key .
    "! Ler os ítens da ordem de frete
    METHODS get_items .
    "!Dados fiscais do emissor da ordem de frete
    METHODS get_consignee .
    "!Dados fiscais da transportadora da ordem de frete
    METHODS get_carrier .
    "! Verificar se a ordem de frete deve ser enviada ao GKO
    "! @parameter et_messages | Mensagens da validação
    "! @parameter ev_error | Flag caso haja erro de validação
    METHODS validar_parametros
      IMPORTING
        !iv_interface TYPE char02 DEFAULT zcltm_interface_fo_gko=>gc_interface-gko
      EXPORTING
        !et_messages  TYPE /scmtms/t_symsg
        !ev_error     TYPE abap_bool .
    "! Verificar se as notas fiscais estão aprovadas na SEFAZ
    "! @parameter et_messages | Mensagens da validação
    "! @parameter ev_error | Flag caso haja erro de validação
    METHODS validar_notas
      EXPORTING
        !et_messages TYPE /scmtms/t_symsg
        !ev_error    TYPE abap_bool .
    "! Verificar se a ordem de frete é de e-commerce
    "! @parameter rv_ecommerce | <ol><li>ABAP_TRUE - para e-commerce</li><li>ABAP_FALSE - não é e-commerce</li></ol>
    METHODS is_ecommerce
      RETURNING
        VALUE(rv_ecommerce) TYPE abap_bool .
    "!Realiza a leitura dos dados básicos da ordem de frete
    METHODS ler_dados_ordem_frete .
    "!Prepara os registros para gravação do arquivo
    METHODS preparar_arquivo .
    "!Criação/geração do registro tipo 000
    METHODS registro_000 .
    "!Criação/geração do registro tipo 060
    METHODS registro_060
      IMPORTING
        !iv_partner      TYPE j_1bparvw
      EXPORTING
        !es_registro_060 TYPE zstm_fo_gko_reg_060 .
    "!Criação/geração do registro tipo 100
    METHODS registro_100
      IMPORTING
        !is_remessa      TYPE ty_notas
        !iv_partner      TYPE j_1bparvw
      EXPORTING
        !es_registro_100 TYPE zstm_fo_gko_reg_100 .
    "!Cabeçalho de documento de notificaç1ão de embarque
    METHODS registro_140
      IMPORTING
        !is_remessa      TYPE ty_notas
        !iv_partner      TYPE j_1bparvw
        !is_registro_100 TYPE zstm_fo_gko_reg_100
      EXPORTING
        !es_registro_140 TYPE zstm_fo_gko_reg_140 .
    "!Referências de DNE
    METHODS registro_142
      IMPORTING
        !is_registro_100 TYPE zstm_fo_gko_reg_100 .
    "!Criação/geração do registro tipo 147 (Redespacho)
    METHODS registro_147
      IMPORTING
        !is_remessa      TYPE ty_notas_red
        !is_registro_060 TYPE zstm_fo_gko_reg_060
        !is_registro_140 TYPE zstm_fo_gko_reg_140 .
    "!Criação/geração do registro tipo 150
    "! @parameter is_item |Dados do ítem da ordem de frete
    METHODS registro_150
      IMPORTING
        !is_item TYPE /scmtms/s_tor_item_tr_k .
    "!Criação/geração do registro tipo 160
    "! @parameter is_item |Dados do ítem da ordem de frete
    METHODS registro_160
      IMPORTING
        !is_item      TYPE /scmtms/s_tor_item_tr_k
        !is_remessa   TYPE ty_notas
        !is_ref       TYPE ty_ref
        !iv_nontaitem TYPE i .
    "!Gravar o arquivo no diretório configurado
    METHODS criar_arquivo .
    METHODS valida_fu .
ENDCLASS.



CLASS zcltm_interface_fo_gko IMPLEMENTATION.


  METHOD gerar_arquivo_gko.

    me->get_mother_tor_id( EXPORTING iv_tor_key = iv_tor_key
                           IMPORTING ev_tor_key = DATA(lv_tor_key) ).
*    DATA(lv_tor_key) = iv_tor_key.

    go_srv_mng = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    "Ler dados de cabeçalho da ordem de frete
    get_root( EXPORTING iv_tor_key = lv_tor_key ).
    CHECK gs_root-tor_cat = 'TO'.

    "Ler os ítens da ordem de frete
    get_items( ).

    "Validar se ordem de frete deve ser realmente enviada ao GKO
    validar_parametros( EXPORTING iv_interface = zcltm_interface_fo_gko=>gc_interface-gko " Interface de Disparo
                        IMPORTING et_messages = et_messages
                                  ev_error    = DATA(lv_erro_validacao) ).

    CHECK lv_erro_validacao = abap_false.

    "Validar se todas as notas fiscais estão autorizadas na SEFAZ
    validar_notas( IMPORTING et_messages = et_messages
                             ev_error    = DATA(lv_erro_validacao_nfes) ).
    CHECK lv_erro_validacao_nfes = abap_false.

    IF check_all_ok( EXPORTING iv_tor_key =  lv_tor_key
                     IMPORTING et_messages = et_messages ) = abap_true.

      "Ler os dados necessários para a geração do arquivo
      ler_dados_ordem_frete( ).

      "Preparar e formatar os dados
      preparar_arquivo( ).

      "Ler dados de cabeçalho da ordem de frete
      CLEAR gs_root.
      get_root( EXPORTING iv_tor_key = iv_tor_key ).

      "Gerar arquivo
      criar_arquivo( ).
    ENDIF.
  ENDMETHOD.


  METHOD get_mother_tor_id.

    FREE ev_tor_key.

    SELECT SINGLE FreightOrderId
        FROM zi_tm_integra_gko_redespacho
        WHERE FreightOrderRedId = @iv_tor_key
        INTO @ev_tor_key.

    IF sy-subrc NE 0.
      ev_tor_key = iv_tor_key.
    ENDIF.

  ENDMETHOD.


  METHOD get_root.

    DATA lt_root TYPE /scmtms/t_tor_root_k.
    IF gs_root IS INITIAL.
      go_srv_mng->retrieve( EXPORTING iv_node_key  = /scmtms/if_tor_c=>sc_node-root
                                      it_key       = VALUE #( ( key = iv_tor_key ) )
                                      iv_edit_mode = /bobf/if_conf_c=>sc_edit_read_only
                                      iv_fill_data = abap_true
                            IMPORTING eo_change    = DATA(lo_change)
                                      et_data      = lt_root ).
      IF lines( lt_root ) > 0.
        gs_root = lt_root[ 1 ].
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD is_ecommerce.

    "Verificar se condição de expedição é de e-commerce
    IF gs_root-zz1_cond_exped = '14' OR
       gs_root-zz1_cond_exped = '15'.

      rv_ecommerce = abap_true.

    ELSE.
      rv_ecommerce = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD validar_parametros.

    DATA: lr_param_fo TYPE RANGE OF char2,
          lt_execucao TYPE /scmtms/t_tor_exec_k.

    ev_error = abap_false.
    DATA(lo_config) = NEW zclca_tabela_parametros( ).

    CASE iv_interface.
      WHEN zcltm_interface_fo_gko=>gc_interface-gko.

        TRY.
            lo_config->m_get_range(
              EXPORTING
                iv_modulo = 'TM'
                iv_chave1 = 'INTEGRACAO_GKO'
                iv_chave2 = 'TOR_TYPE'
              IMPORTING
                et_range  = gr_parameter-tor_type ).

            lo_config->m_get_range(
              EXPORTING
                iv_modulo = 'TM'
                iv_chave1 = 'INTEGRACAO_GKO'
                iv_chave2 = 'COND_EXPED'
              IMPORTING
                et_range  = gr_parameter-cond_exped ).

            lo_config->m_get_range(
              EXPORTING
                iv_modulo = 'TM'
                iv_chave1 = 'INTEGRACAO_GKO'
                iv_chave2 = 'TIPO_EXPED'
              IMPORTING
                et_range  = gr_parameter-tipo_exped ).

* BEGIN OF INSERT - JWSILVA - 15.05.2023
            lo_config->m_get_range(
              EXPORTING
                iv_modulo = 'TM'
                iv_chave1 = 'INTEGRACAO_GKO'
                iv_chave2 = 'FRDNE'
                iv_chave3 = 'LFART'
              IMPORTING
                et_range  = gr_parameter-lfart ).
* END OF INSERT - JWSILVA - 15.05.2023

*        lo_config->m_get_single(
*          EXPORTING
*            iv_modulo = 'TM'
*            iv_chave1 = 'INTEGRACAO_GKO'
*            iv_chave2 = 'PASTA_OF'
*          IMPORTING
*            ev_param  = gv_pasta_arquivo ).

            SELECT parametro
              FROM zttm_pcockpit001
              WHERE id = 24       "Diretório destino aquivo Ordem de Frete
              INTO @gv_pasta_arquivo
              UP TO 1 ROWS.
            ENDSELECT.

          CATCH zcxca_tabela_parametros.
            et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '000' msgty = 'E' ) ). "Falta configuração de parâmetros: módulo: TM, chave1: INTEGRACAO_GKO
            ev_error = abap_true.
            RETURN.
        ENDTRY.

        "Verificar parâmetros da ordem de frete
        IF NOT gs_root-tor_type IN gr_parameter-tor_type.
          et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '001' msgty = 'E' msgv1 = gs_root-tor_type ) ).
          ev_error = abap_true.
        ENDIF.

        IF NOT gs_root-zz1_cond_exped IN gr_parameter-cond_exped.
          et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '002' msgty = 'E' msgv1 = gs_root-zz1_cond_exped ) ).
          ev_error = abap_true.
        ENDIF.

        IF NOT gs_root-zz1_tipo_exped IN gr_parameter-tipo_exped.
          et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '003' msgty = 'E' msgv1 = gs_root-zz1_tipo_exped ) ).
          ev_error = abap_true.
        ENDIF.

* BEGIN OF INSERT - JWSILVA - 15.05.2023
        IF NOT gr_parameter-lfart IS NOT INITIAL.
          " Falta cadastro do tipo de remessa para envio ao GKO.
          et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '015' msgty = 'E' ) ).
          ev_error = abap_true.
        ENDIF.
* END OF INSERT - JWSILVA - 15.05.2023

*        "Verificar nos eventos da ordem se ela já saiu para entrega
*        go_srv_mng->retrieve_by_association(
*                                             EXPORTING
*                                               iv_node_key             = /scmtms/if_tor_c=>sc_node-root
*                                               it_key                  = VALUE #( ( key = gs_root-key ) )
*                                               iv_association          = /scmtms/if_tor_c=>sc_association-root-exec_valid
*                                               iv_fill_data            = abap_true
*                                             IMPORTING
*                                               et_data                 = lt_execucao ).
*
*        IF line_exists( lt_execucao[ KEY event event_code = 'DEPARTURE' ] ).
*        ELSE.
*          et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '004' msgty = 'E' ) ).
*          ev_error = abap_true.
*        ENDIF.

        "Verificar se existe tipo de veículo determinado
        ASSIGN gt_items[ KEY root_itmcat root_key = gs_root-root_key item_cat = 'AVR' ] TO FIELD-SYMBOL(<fs_item>).
        IF <fs_item> IS NOT ASSIGNED OR
           <fs_item>-tures_tco IS INITIAL.

          et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '005' msgty = 'E' ) ).
          ev_error = abap_true.
        ENDIF.

      WHEN zcltm_interface_fo_gko=>gc_interface-greenmile.

        TRY.
            lo_config->m_get_range(
              EXPORTING
                iv_modulo = 'TM'
                iv_chave1 = 'COND_EXPED_GREENMILE'
              IMPORTING
                et_range  = lr_param_fo ).

            IF NOT gs_root-zz1_cond_exped IN lr_param_fo.
              et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '005' msgty = 'E' ) ).
              ev_error = abap_true.
            ENDIF.

          CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
        ENDTRY.

      WHEN zcltm_interface_fo_gko=>gc_interface-trafegus.



      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD get_items.

    "Let os ítens da ordem de frete
    IF gt_items IS INITIAL.
      go_srv_mng->retrieve_by_association(
                                            EXPORTING
                                              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                              it_key                  = VALUE #( ( key = gs_root-key ) )
                                              iv_association          = /scmtms/if_tor_c=>sc_association-root-item_tr
                                              iv_fill_data            = abap_true
                                            IMPORTING
                                              et_data                 = gt_items ).
    ENDIF.

  ENDMETHOD.


  METHOD validar_notas.

    ev_error = abap_false.
    CLEAR : gt_remessas, gt_ref.

    " Relacionamento documentos
    TRY.
        SELECT vbeln_vl,
               posnr_vl,
               vbeln_vf,
               posnr_vf,
               docnum,
               itmnum,
               cfop,
               netwr
            FROM zi_tm_integra_gko_ref
            FOR ALL ENTRIES IN @gt_items
            WHERE base_btd_id     = @gt_items-base_btd_id
              AND base_btditem_id = @gt_items-base_btditem_id
            INTO TABLE @gt_ref.
      CATCH cx_root INTO DATA(lo_root).
    ENDTRY.

    " Recupera remessas da ordem de frete
    TRY.
        SELECT DISTINCT remessa,
                        fatura,
                        doc_nfe,
                        status,
                        nfe_key,
                        nftype,
                        nfenum,
                        series,
                        docdat,
                        partyp,
                        bukrs,
                        branch,
                        parid,
                        inco1,
                        lfart
            FROM zi_tm_integra_gko_remessa
            FOR ALL ENTRIES IN @gt_items
            WHERE base_btd_id = @gt_items-base_btd_id
            INTO TABLE @gt_remessas.
      CATCH cx_root INTO lo_root.
    ENDTRY.

    " Recupera ordem de frete redespacho e suas remessas
    SELECT DISTINCT *
        FROM zi_tm_integra_gko_redespacho
        WHERE freightorder = @gs_root-tor_id
        INTO TABLE @gt_remessas_red.

    IF sy-subrc NE 0.
      FREE gt_remessas_red.
    ENDIF.

    DELETE gt_remessas WHERE nfe_key IS INITIAL.        "#EC CI_SEL_DEL

    IF gt_remessas IS INITIAL.
      ev_error = abap_true.
      " Não foram encontradas remessas para a ordem de frete &1
      et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '008' msgty = 'E' msgv1 = gs_root-tor_id ) ).
      RETURN.
    ENDIF.

    LOOP AT gt_remessas ASSIGNING FIELD-SYMBOL(<fs_remessa_invalida>)
                        WHERE status <> '100'.
      ev_error = abap_true.
      et_messages = VALUE #( BASE et_messages ( msgid = gc_msg msgno = '006' msgty = 'E' msgv1 = <fs_remessa_invalida>-remessa ) ).
    ENDLOOP.

    IF gt_remessas IS NOT INITIAL AND ev_error = abap_false.
      CLEAR gt_taxanf.
      SELECT
        stx~docnum ,
        stx~itmnum ,
        stx~taxtyp ,
        stx~base   ,
        stx~rate   ,
        stx~taxval ,
        stx~excbas ,
        stx~othbas ,
        stx~stattx ,
        lin~matnr
     FROM j_1bnfstx AS stx
     INNER JOIN j_1bnflin AS lin
        ON  stx~docnum = lin~docnum
        AND stx~itmnum = lin~itmnum
     FOR ALL ENTRIES IN @gt_remessas
     WHERE stx~docnum = @gt_remessas-docnum
     INTO TABLE @gt_taxanf.

      IF sy-subrc = 0.
*        SORT gt_taxanf BY docnum itmnum taxtyp.
      ENDIF.

      SELECT FROM i_br_nfpartner_c
      FIELDS br_nfpartnerfunction, br_nfpartner, br_nfpartnertype, br_nfpartnernamefrmtddesc, br_nfpartnerstreetname, br_nfpartnerdistrictname,
                   br_nfpartnercityname, br_nfpartnerregioncode, br_nfpartnerpostalcode, br_nfpartnerisnaturalperson, br_nfpartnerregistrationfrmtd, br_notafiscal, br_nfpartnerstatetaxnumber
            FOR ALL ENTRIES IN @gt_remessas
            WHERE
               br_notafiscal = @gt_remessas-docnum
            INTO TABLE @gt_partners.
      SORT gt_partners BY br_notafiscal br_nfpartnerfunction.

    ENDIF.

  ENDMETHOD.


  METHOD ler_dados_ordem_frete.

    DATA : lt_sumary  TYPE /scmtms/t_tor_root_transient_k,
           lt_vehicle TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k.


    "Obter os dados do destinatário da ordem de frete
    get_consignee( ).

    "obter dados da transportadora
    get_carrier( ).

    go_srv_mng->retrieve_by_association(
                                          EXPORTING
                                            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                            it_key                  = VALUE #( ( key = gs_root-key ) )
                                            iv_association          = /scmtms/if_tor_c=>sc_association-root-summary
                                            iv_fill_data            = abap_true
                                          IMPORTING
                                            et_data                 = lt_sumary ).

    IF lt_sumary IS NOT INITIAL.
*      gs_datagen-dthr_inicarreg = lt_sumary[ 1 ]-first_stop_aggr_assgn_start_l.
      gs_datagen-dthr_inicarreg = lt_sumary[ 1 ]-first_activity_st.
      gs_datagen-wei_romaneio   = lt_sumary[ 1 ]-quantity-net_wei_val.
      gs_datagen-vrtotalkm      = lt_sumary[ 1 ]-tot_distance_km.
    ENDIF.

    SELECT SINGLE name1, name2 FROM lfa1
    WHERE
      lifnr = @gs_root-zz_motorista
    INTO ( @DATA(lv_name1), @DATA(lv_name2) ).
    gs_datagen-cdmotor = gs_root-zz_motorista.

    IF sy-subrc = 0.
      CONCATENATE lv_name1 lv_name2 INTO  gs_datagen-nmmotor SEPARATED BY space.
    ENDIF.


    "Ler as paradas da ordem
    SELECT FROM /scmtms/d_torstp
        FIELDS db_key, stop_cat, log_locid
        WHERE parent_key = @gs_root-key
        INTO TABLE @gt_stops.

    "Ler informações de cubagem da Of
    go_srv_mng->retrieve_by_association(
                                          EXPORTING
                                            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
                                            it_key                  = VALUE #( ( key = gs_root-key ) )
                                            iv_association          = /scmtms/if_tor_c=>sc_association-root-assigned_fus
                                            iv_fill_data            = abap_true
                                          IMPORTING
                                            et_data                 = gt_unid_frete ).
    IF gt_unid_frete IS NOT INITIAL.

      SELECT FROM @gt_unid_frete AS a
      INNER JOIN zttm_cubagem AS b
      ON b~unidade_frete = a~tor_id
      FIELDS b~remessa, b~peso_total, b~volume
      INTO TABLE @gt_cubagem.
    ENDIF.

    IF gt_items IS NOT INITIAL.
      "Obter a hierarquia dos produtos
      SELECT FROM @gt_items AS a
      INNER JOIN mara AS b ON b~matnr = a~product_id
      FIELDS DISTINCT a~product_id, b~prdha, b~matkl
      INTO TABLE @gt_hierarquia.

      lt_vehicle = gt_items.
      SORT lt_vehicle BY item_cat.
    ENDIF.


    SELECT SINGLE taxnum
    FROM dfkkbptaxnum
    WHERE
      partner = @gs_root-tspid
    AND taxtype = 'BR1'
    INTO @gs_datagen-cnpj_transp.

    gs_datagen-cdtransp =   gs_root-tspid.

    READ TABLE lt_vehicle
    WITH KEY item_cat = 'AVR'
    ASSIGNING FIELD-SYMBOL(<fs_vehicle>) BINARY SEARCH.

    IF sy-subrc = 0.
      gs_datagen-tures_tco    = <fs_vehicle>-tures_tco.
      gs_datagen-platernumber = <fs_vehicle>-platenumber.
    ENDIF.

  ENDMETHOD.


  METHOD get_consignee.

    SELECT FROM i_businesspartnertaxnumber
        FIELDS bptaxtype, bptaxnumber
        WHERE businesspartner = @gs_root-consigneeid
        INTO TABLE @gt_consignee.
  ENDMETHOD.


  METHOD get_carrier.

    SELECT FROM i_businesspartnertaxnumber
        FIELDS bptaxtype, bptaxnumber
        WHERE businesspartner = @gs_root-tspid
        INTO TABLE @gt_carrier.
  ENDMETHOD.


  METHOD preparar_arquivo.

    DATA: lv_freightorder TYPE /scmtms/tor_id,
          lv_base_btd_id  TYPE /scmtms/base_btd_id,
          lt_items        TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,
          lv_partner      TYPE j_1bparvw.

    lt_items = gt_items.
    SORT lt_items BY parent_key
                     root_key
                     item_cat
                     base_btd_id
                     base_btditem_id.


    IF is_ecommerce( ).
      lv_partner = 'AG'. "Emissor da ordem
    ELSE.
      lv_partner = 'WE'. "Recebedor da Mercadoria
    ENDIF.

    "Inserir cabeçalho do arquivo
    registro_000( ).

    "Inserir o plano de carga
    registro_060( EXPORTING iv_partner      = lv_partner
                  IMPORTING es_registro_060 = DATA(ls_registro_060) ).

    LOOP AT gt_remessas ASSIGNING FIELD-SYMBOL(<fs_remessa>).
      "Inserir os parceiros comerciais
      registro_100( EXPORTING is_remessa      = <fs_remessa>
                              iv_partner      = lv_partner
                    IMPORTING es_registro_100 = DATA(ls_registro_100) ).

      "Cabeçalho de documento de notificação de embarque
      registro_140( EXPORTING is_remessa      = <fs_remessa>
                              iv_partner      = lv_partner
                              is_registro_100 = ls_registro_100
                    IMPORTING es_registro_140 = DATA(ls_registro_140) ).

      "ReferÊncias de DNE
      registro_142( EXPORTING is_registro_100 = ls_registro_100 ).

      lv_freightorder = gs_root-tor_id.
      lv_freightorder = |{ lv_freightorder ALPHA = IN }|.

      READ TABLE gt_remessas_red ASSIGNING FIELD-SYMBOL(<fs_remessa_red>)
        WITH KEY
          FreightOrder = lv_freightorder
          remessa      = <fs_remessa>-remessa.

      IF sy-subrc IS INITIAL.
        registro_147( EXPORTING is_remessa      = <fs_remessa_red>
                                is_registro_060 = ls_registro_060
                                is_registro_140 = ls_registro_140 ).
      ENDIF.
*    ENDLOOP.

      lv_base_btd_id = <fs_remessa>-remessa.
      lv_base_btd_id = |{ lv_base_btd_id ALPHA = IN }|.

      "Gerar registros de materiais
      DATA(lv_nontaitem) = 0.
      LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_item>)
                       WHERE root_key = gs_root-root_key
                         AND item_cat = 'PRD'
*                         AND parent_key = <fs_remessa>-parent_key      " DELETE - JWSILVA - 14.02.2023
                         AND base_btd_id = lv_base_btd_id.

        READ TABLE gt_ref INTO DATA(ls_ref) WITH KEY vbeln_vl = <fs_item>-base_btd_id+25(10)
                                                     posnr_vl = <fs_item>-base_btditem_id+4(6)
                                                     BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.

        lv_nontaitem = lv_nontaitem + 1.

        registro_150( <fs_item> ).

        registro_160( EXPORTING is_item      = <fs_item>
                                is_remessa   = <fs_remessa>
                                is_ref       = ls_ref
                                iv_nontaitem = lv_nontaitem ).
      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.


  METHOD registro_000.

    DATA ls_record TYPE zstm_fo_gko_reg_000.

    ls_record-tipo_reg     = '000'.
    ls_record-nminterface  = 'IntDNE'.
    ls_record-versao       = '6.49a'.
    ls_record-remetente    = 'SAP S/4HANA'.
    ls_record-destinatario = 'GKO'.
    ls_record-cdambiente   = sy-sysid.

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.
  ENDMETHOD.


  METHOD registro_060.

    DATA: BEGIN OF ls_dt,
            ano TYPE c LENGTH 4,
            mes TYPE c LENGTH 2,
            dia TYPE c LENGTH 2,
          END OF ls_dt.

    DATA : ls_record       TYPE zstm_fo_gko_reg_060,
           lv_aux          TYPE c LENGTH 15,
           lv_pardestremet TYPE c LENGTH 15.

    FREE es_registro_060.

    ls_record-tipo_reg    = '060'.
    ls_record-floperacao  = 'A'.

    lv_aux = gs_datagen-dthr_inicarreg. "lt_sumary[ 1 ]-first_stop_aggr_assgn_start_l.
    IF lv_aux IS NOT INITIAL.
      ls_dt = lv_aux(8).
      ls_record-actual_date = ls_dt-dia && '/' && ls_dt-mes && '/' && ls_dt-ano.
      ls_record-hsembarque = lv_aux+8(4).
    ENDIF.

    ls_record-vrtotalpesoembarcado = gs_datagen-wei_romaneio.
    ls_record-tax_number           = gs_datagen-cnpj_transp.
    ls_record-tures_tco            = gs_datagen-tures_tco.
    ls_record-dsplacaveiculo       = gs_datagen-platernumber.
*    ls_record-nmmotorista          = gs_datagen-nmmotor.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = gs_datagen-nmmotor
      IMPORTING
        outtext = ls_record-nmmotorista.

    SHIFT gs_root-tor_id  LEFT DELETING LEADING '0'.
    ls_record-tor_id               = gs_root-tor_id.
    ls_record-vrtotalkm            = gs_datagen-vrtotalkm.

    ASSIGN gt_remessas[ 1 ] TO FIELD-SYMBOL(<fs_remessa>).
    IF <fs_remessa> IS ASSIGNED.

      READ TABLE gt_partners
      WITH KEY br_notafiscal = <fs_remessa>-docnum
               br_nfpartnerfunction = iv_partner
      ASSIGNING FIELD-SYMBOL(<fs_partner>) BINARY SEARCH.

      IF sy-subrc = 0.
        SELECT SINGLE partner, bpkind
            FROM but000
            INTO @DATA(ls_partner_kind)
            WHERE partner = @<fs_partner>-br_nfpartner.

        IF sy-subrc NE 0.
          CLEAR ls_partner_kind.
        ENDIF.
      ELSE.
        CLEAR ls_partner_kind.
      ENDIF.

      CASE <fs_remessa>-inco1.

        WHEN 'CIF'.
          IF gs_root-tor_type = '1090'  "Ordem de transferência
          OR gs_root-tor_type = '1120'. "OF Vendas Coligadas
            ls_record-br_nfpartner = <fs_remessa>-branch.
          ELSE. "Ordem de venda
            ls_record-br_nfpartner = <fs_remessa>-branch.
          ENDIF.

        WHEN 'FOB'.
* BEGIN OF INSERT - JWSILVA - 20.03.2023
          IF <fs_remessa>-lfart = 'Z004'.

            SELECT SINGLE t001w~werks, t001w~j_1bbranch, t001w~kunnr, kna1~stcd1
                FROM t001w
                LEFT OUTER JOIN kna1
                ON kna1~kunnr = t001w~kunnr
                INTO @DATA(ls_t001w)
                WHERE t001w~kunnr = @<fs_remessa>-parid.

            IF sy-subrc EQ 0.
              ls_record-br_nfpartner = ls_t001w-j_1bbranch.
            ENDIF.
          ELSE.
* END OF INSERT - JWSILVA - 20.03.2023
            IF ls_partner_kind-bpkind = '0002'.
              ls_record-br_nfpartner = <fs_remessa>-parid+4(4).
            ELSE.
              ls_record-br_nfpartner = <fs_remessa>-parid.
            ENDIF.
          ENDIF.
      ENDCASE.

    ENDIF.

    ls_record-tpviagem               = '1'.
    ls_record-stexcluirefextromaneio = '1'.

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.

    es_registro_060 = ls_record.

  ENDMETHOD.


  METHOD registro_100.

    DATA:
      ls_record     TYPE zstm_fo_gko_reg_100,
      lv_postalcode TYPE n LENGTH 8.

    FREE: es_registro_100.
*
*    IF gt_remessas IS NOT INITIAL.
*      CLEAR gt_partners.
*
*      SELECT FROM i_br_nfpartner_c
*             FIELDS br_nfpartnerfunction, br_nfpartner, br_nfpartnernamefrmtddesc, br_nfpartnerstreetname, br_nfpartnerdistrictname,
*                    br_nfpartnercityname, br_nfpartnerregioncode, br_nfpartnerpostalcode, br_nfpartnerisnaturalperson, br_nfpartnerregistrationfrmtd, br_notafiscal
*             FOR ALL ENTRIES IN @gt_remessas
*             WHERE
*                br_notafiscal = @gt_remessas-docnum
*             INTO TABLE @DATA(lt_partners).
*
*      IF sy-subrc = 0.
*        SORT lt_partners BY br_notafiscal br_nfpartnerfunction.
*        gt_partners = CORRESPONDING #( lt_partners ).
*      ENDIF.
*    ENDIF.

*    LOOP AT gt_remessas ASSIGNING FIELD-SYMBOL(is_remessa).
    CLEAR : ls_record.

    ls_record-tipo_reg    = '100'.
    ls_record-floperacao  = 'A'.

    READ TABLE gt_partners
    WITH KEY br_notafiscal = is_remessa-docnum
             br_nfpartnerfunction = iv_partner
    ASSIGNING FIELD-SYMBOL(<fs_partner>) BINARY SEARCH.

    IF sy-subrc = 0.
      CLEAR lv_postalcode.
      ls_record-tax_number         = replace( val = <fs_partner>-br_nfpartnerregistrationfrmtd regex = '\.|/|-' with = '' occ = 0 ).
      ls_record-partner            = <fs_partner>-br_nfpartner.
      ls_record-partner_ref_id     = <fs_partner>-br_nfpartnernamefrmtddesc.
      ls_record-street_name        = <fs_partner>-br_nfpartnerstreetname.
      ls_record-district_name      = <fs_partner>-br_nfpartnerdistrictname.
      ls_record-city_name          = <fs_partner>-br_nfpartnercityname.
      ls_record-region             = <fs_partner>-br_nfpartnerregioncode.
      ls_record-street_postal_code = lv_postalcode = <fs_partner>-br_nfpartnerpostalcode.
      ls_record-tax_number_flag    = COND #( WHEN <fs_partner>-br_nfpartnerisnaturalperson = abap_true THEN '1' ELSE '2' ).
      ls_record-tax_numer_br3      = <fs_partner>-BR_NFPartnerStateTaxNumber.

      SELECT SINGLE partner, bpkind
          FROM but000
          INTO @DATA(ls_partner_kind)
          WHERE partner = @<fs_partner>-br_nfpartner.

      IF sy-subrc NE 0.
        CLEAR ls_partner_kind.
      ENDIF.
    ELSE.
      CLEAR ls_partner_kind.
    ENDIF.

    "Ordem de Macro distribuição?
*    IF gs_root-tor_type = '1020'.
    IF ls_partner_kind-bpkind = '0002'.
      ls_record-br_nfpartnertype = '1'.
    ELSE.
      ls_record-br_nfpartnertype = '2'.
    ENDIF.

    "Valores fixos
    ls_record-stcontribuinteicms   = '1'.
    ls_record-stregcredicms        = '0'.
    ls_record-stexcluirefextparcom = '1'.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-partner_ref_id
      IMPORTING
        outtext = ls_record-partner_ref_id.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-street_name
      IMPORTING
        outtext = ls_record-street_name.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-district_name
      IMPORTING
        outtext = ls_record-district_name.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-city_name
      IMPORTING
        outtext = ls_record-city_name.

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.
*    ENDLOOP.

    es_registro_100 = ls_record.

  ENDMETHOD.


  METHOD registro_140.

    DATA: BEGIN OF ls_dt,
            ano TYPE c LENGTH 4,
            mes TYPE c LENGTH 2,
            dia TYPE c LENGTH 2,
          END OF ls_dt.

    DATA: ls_record       TYPE zstm_fo_gko_reg_140,
          lv_volumes      TYPE n LENGTH 6,
          lv_peso_bruto   TYPE n LENGTH 15,
          lv_peso_cubado  TYPE n LENGTH 15,
          lv_aux          TYPE c LENGTH 15,
          lv_base_btd_id  TYPE /scmtms/base_btd_id,
          lv_date         TYPE datum,
          lv_vrpesobruto  TYPE p LENGTH 10 DECIMALS 4,
          lv_vrpesocubado TYPE p LENGTH 15 DECIMALS 2,
          ls_parnad       TYPE j_1binnad.

    FREE: es_registro_140.

    DATA : lt_stop_last   TYPE /scmtms/t_tor_stop_k.

    CLEAR : ls_record,
            lv_volumes,
            lv_peso_bruto,
            lv_peso_cubado,
            lv_aux.

    ls_record-tipo_reg              = '140'.
    ls_record-floperacao            = 'A'.
    ls_record-tpdocumento           = '1'.
    ls_record-cddocumentovinculado  = is_remessa-remessa.
    ls_record-parceirocomercial     = '1' && is_remessa-branch.
    ls_record-cdnota                = is_remessa-nfenum.
    ls_record-cdserie               = COND #( WHEN is_remessa-series IS INITIAL THEN '0' ELSE is_remessa-series ).
    ls_record-dtemissao             = replace( val = |{ is_remessa-docdat DATE = USER }| regex = '\.' with = '/' occ = 0 ).

    CONVERT TIME STAMP gs_datagen-dthr_inicarreg TIME ZONE sy-zonlo INTO DATE lv_date.

    IF lv_date IS NOT INITIAL AND lv_date NE '00000000'.
      ls_record-dtembarque = replace( val = |{ lv_date DATE = USER }| regex = '\.' with = '/' occ = 0 ).
    ENDIF.

    " Recupera emissor da mercadoria
    READ TABLE gt_partners INTO DATA(ls_partners_e)  WITH KEY br_notafiscal        = is_remessa-docnum
                                                              br_nfpartnerfunction = iv_partner
                                                              BINARY SEARCH.
    IF sy-subrc NE 0.
      CLEAR ls_partners_e.
    ENDIF.

    IF is_registro_100-br_nfpartnertype = '1'.

      SELECT SINGLE j_1bbranch
        FROM t001w
        WHERE kunnr = @ls_partners_e-br_nfpartner
        INTO @DATA(lv_branch).

      IF sy-subrc NE 0.
        CLEAR lv_branch.
      ENDIF.

      ls_record-pardestremet      = COND #( WHEN lv_branch IS NOT INITIAL THEN '1' && lv_branch
                                            WHEN is_remessa-partyp EQ 'B' THEN '1' && ls_partners_e-br_nfpartner+4(4)    " is_remessa-parid+4(4)
                                                                          ELSE '1' && ls_partners_e-br_nfpartner ).      " is_remessa-parid

    ELSE.
      ls_record-pardestremet      = SWITCH #( is_remessa-partyp WHEN 'C' THEN '2' && ls_partners_e-br_nfpartner         " is_remessa-parid
                                                                WHEN 'V' THEN '3' && ls_partners_e-br_nfpartner ).      " is_remessa-parid
    ENDIF.

    ls_record-cdtiponota        = is_remessa-nftype.
    ls_record-tpfrete           = SWITCH #( is_remessa-inco1 WHEN 'CIF' THEN '1'
                                                           WHEN 'FOB' THEN '2' ).
    ls_record-dschaveacesso     = is_remessa-nfe_key.

    " Recupera recebedor da mercadoria
    READ TABLE gt_partners INTO DATA(ls_partners)  WITH KEY br_notafiscal = is_remessa-docnum
                                                            br_nfpartner  = is_remessa-parid.

    IF sy-subrc NE 0.

      READ TABLE gt_partners INTO ls_partners  WITH KEY br_notafiscal        = is_remessa-docnum
                                                        br_nfpartnerfunction = 'WE'
                                                        BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_partners.
      ENDIF.
    ENDIF.

* BEGIN OF CHANGE - JWSILVA - 15.03.2023
    IF is_remessa-inco1 = 'FOB'
    AND ( is_remessa-lfart IN gr_parameter-lfart[] AND gr_parameter-lfart IS NOT INITIAL ). " INSERT - JWSILVA - 15.05.2023
*    AND ( is_remessa-lfart = 'Z004'      " Venda Intercompany                              " DELETE - JWSILVA - 15.05.2023
*     OR   is_remessa-lfart = 'ZNLC' ).   " Tipo Remessa-Transferencia                      " DELETE - JWSILVA - 15.05.2023
      ls_partners-br_nfpartner        = is_remessa-bukrs && is_remessa-branch.
    ENDIF.
* END OF CHANGE - JWSILVA - 15.03.2023

    CALL FUNCTION 'J_1B_NF_PARTNER_READ'
      EXPORTING
        partner_type           = ls_partners-br_nfpartnertype
        partner_id             = ls_partners-br_nfpartner
        doc_number             = ls_partners-br_notafiscal
        partner_function       = ls_partners-br_nfpartnerfunction
      IMPORTING
        parnad                 = ls_parnad
      EXCEPTIONS
        partner_not_found      = 1
        partner_type_not_found = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      CLEAR ls_parnad.
    ENDIF.

    ls_record-dsenderecodestremet   = ls_parnad-stras.
    ls_record-dsbairrodestremet     = ls_parnad-ort02.
    ls_record-nomecidade            = ls_parnad-ort01.
    ls_record-uf                    = ls_parnad-regio.
    ls_record-nocepdestremet        = ls_parnad-pstlz.

* Buscar bairro do BP na UG
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
      EXPORTING
        iv_node_key             = /scmtms/if_tor_c=>sc_node-root
        it_key                  = VALUE #( ( key = gs_root-key ) )
        iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_last
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_stop_last ).

    IF lt_stop_last IS NOT INITIAL.
      SELECT *
        FROM /sapapo/loc
        INTO TABLE @DATA(lt_locno)
        FOR ALL ENTRIES IN @lt_stop_last
      WHERE locno = @lt_stop_last-log_locid.

      IF sy-subrc IS INITIAL.
        SELECT *
          FROM adrc
          INTO TABLE @DATA(lt_adrc)
          FOR ALL ENTRIES IN @lt_locno
        WHERE addrnumber = @lt_locno-adrnummer.

        READ TABLE lt_adrc INTO DATA(ls_adrc) INDEX 1.

        IF ls_adrc-city2 IS NOT INITIAL.
          ls_record-dsbairrodestremet     = ls_adrc-city2.
        ENDIF.
      ENDIF.
    ENDIF.

*    ls_record-dsenderecodestremet   = ls_partners-br_nfpartnerstreetname.
*    ls_record-dsbairrodestremet     = ls_partners-br_nfpartnerdistrictname.
*    ls_record-nomecidade            = ls_partners-br_nfpartnercityname.
*    ls_record-uf                    = ls_partners-br_nfpartnerregioncode.
*    ls_record-nocepdestremet        = ls_partners-br_nfpartnerpostalcode.

* BEGIN OF CHANGE - JWSILVA - 15.03.2023
    IF is_remessa-inco1 = 'FOB'
    AND ( is_remessa-lfart IN gr_parameter-lfart[] AND gr_parameter-lfart IS NOT INITIAL ). " INSERT - JWSILVA - 15.05.2023
*    AND ( is_remessa-lfart = 'Z004'      " Venda Intercompany                              " DELETE - JWSILVA - 15.05.2023
*     OR   is_remessa-lfart = 'ZNLC' ).   " Tipo Remessa-Transferencia                      " DELETE - JWSILVA - 15.05.2023
      ls_record-tpentradasaida        = '1'.
    ELSE.
      ls_record-tpentradasaida        = '2'.
    ENDIF.
* END OF CHANGE - JWSILVA - 15.03.2023

    ls_record-cdmeiotransporte      = '0001'.
*    ls_record-cdterritorio          = '01'.
    ls_record-cdromaneio            = gs_root-tor_id. "gs_root-tor_id+10.
    ls_record-stisentoimposto       = '0'.
    ls_record-stitemsubtribnacompra = '0'.
    ls_record-sturgenciaentrega     = '0'.
    ls_record-stfretediferenciado   = '0'.

    lv_base_btd_id = is_remessa-remessa.
    lv_base_btd_id = |{ lv_base_btd_id ALPHA = IN }|.
    READ TABLE gt_unid_frete INTO DATA(ls_unid_frete) WITH KEY base_btd_id = lv_base_btd_id.

    IF sy-subrc EQ 0.
      CONVERT TIME STAMP ls_unid_frete-dlv_plan_goods_mvmnt_date TIME ZONE sy-zonlo INTO DATE lv_date.

      IF lv_date IS NOT INITIAL AND lv_date NE '00000000'.
        ls_record-dtentrega           = replace( val = |{ lv_date DATE = USER }| regex = '\.' with = '/' occ = 0 ).
      ENDIF.

    ENDIF.

    ls_record-cdtipocarga           = gs_root-zz1_tipo_exped. "zz1_cond_exped.
    ls_record-tpstatusdne           = '1'.

    ls_record-cdtransportadora = gs_datagen-cnpj_transp.
    ls_record-vrfretepgcliente      = '0'.

    ls_record-cdequipamento = gs_datagen-tures_tco.
*    ls_record-cdvendedor    = '00000'.
*    ls_record-cdtransportadora = gs_datagen-cnpj_transp.


    TRY.
*        ls_record-chaverespfrete = gt_carrier[ bptaxtype = 'BR1' ]-bptaxnumber.
        ls_record-chaverespfrete =  SWITCH #( is_remessa-inco1 WHEN 'CIF' THEN '1' && is_remessa-branch
                                                               WHEN 'FOB' THEN ls_record-pardestremet ).
      CATCH cx_sy_itab_line_not_found.
*        ls_record-chaverespfrete =  SWITCH #( is_remessa-inco1 WHEN 'CIF' THEN '1' && <fs_nfe>-branch
*                                                             WHEN 'FOB' THEN ls_record-pardestremet ).
    ENDTRY.

    LOOP AT gt_items ASSIGNING FIELD-SYMBOL(<fs_item>)
                     USING KEY root_itmcat
                     WHERE root_key = gs_root-root_key AND
                           item_cat = 'PRD'.
      lv_volumes += <fs_item>-sales_qty_val.
*      ls_record-vrpesobruto += <fs_item>-
*      ls_record-vrpesobruto = ls_record-vrpesobruto + <fs_item>-gro_wei_val.
    ENDLOOP.

    ls_record-qtvolume = lv_volumes.

    TRY.
        lv_vrpesobruto   = gt_cubagem[ 1 ]-volume.
        lv_vrpesocubado  = gt_cubagem[ 1 ]-peso_total.

        ls_record-vrpesobruto  = lv_vrpesobruto.
        ls_record-vrpesobruto  = replace( val = ls_record-vrpesobruto regex = '[^0-9]' with = '' occ = 0 ).
        CONDENSE ls_record-vrpesobruto NO-GAPS.
        SHIFT ls_record-vrpesobruto RIGHT DELETING TRAILING space.

        ls_record-vrpesocubado = lv_vrpesocubado.
        ls_record-vrpesocubado = replace( val = ls_record-vrpesocubado regex = '[^0-9]' with = '' occ = 0 ).
        CONDENSE ls_record-vrpesocubado NO-GAPS.
        SHIFT ls_record-vrpesocubado RIGHT DELETING TRAILING space.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-dsenderecodestremet
      IMPORTING
        outtext = ls_record-dsenderecodestremet.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-dsbairrodestremet
      IMPORTING
        outtext = ls_record-dsbairrodestremet.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = ls_record-nomecidade
      IMPORTING
        outtext = ls_record-nomecidade.

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.

    es_registro_140 = ls_record.

  ENDMETHOD.


  METHOD registro_147.

    DATA: ls_record TYPE zstm_fo_gko_reg_147.

    SELECT SINGLE *
        FROM zi_tm_gestao_frota_truck
        WHERE FreightOrder = @is_remessa-FreightOrderRed
        INTO @DATA(ls_equipamento).

    ls_record-tipo_reg              = '147'.
    ls_record-floperacao            = 'A'.
    ls_record-noordem               = '01'.
    ls_record-tpfreteredespacho     = '1'.
    ls_record-tpstatustrecho        = '1'.
    ls_record-cdmeiotransporte      = '0001'.
    ls_record-stfretediferenciado   = '0'.

    ls_record-dslote                = |{ is_remessa-FreightOrderRed ALPHA = OUT }|.
    ls_record-parceirocomercial     = |1{ is_registro_060-br_nfpartner }|.

    ls_record-cdnota                = is_remessa-nfenum.
    ls_record-cdserie               = is_remessa-series.
    ls_record-cdequipamento         = ls_equipamento-EquipmentCode.

    " Recupera dados do local de negócio
    SELECT SINGLE *
        FROM zi_ca_vh_partner
        WHERE Parceiro  = @ls_equipamento-FirstBusinessPartnerId " ls_equipamento-FirstLocationId
        INTO @DATA(ls_partner_local).

    IF sy-subrc NE 0.
      CLEAR ls_partner_local.
    ENDIF.

    IF ls_equipamento-FirstLocationTypeCode = '1003'. " Local de expedição

      SELECT SINGLE werks, j_1bbranch
        FROM t001w
        WHERE werks = @ls_equipamento-FirstLocationId+3(4)
        INTO @DATA(ls_t001w).

      IF sy-subrc NE 0.
        CLEAR ls_t001w.
      ENDIF.

      ls_record-chaveredespacho       = COND #( WHEN ls_partner_local-bpkind = '0002' " Empresa
                                                THEN |1{ ls_t001w-j_1bbranch }|
                                                WHEN ls_partner_local-bpkind = '0020' " Transportador
                                                THEN |4{ ls_t001w-j_1bbranch }|
                                                WHEN ls_partner_local-bpkind = '0023' " Local de Redespacho
                                                THEN |5{ ls_t001w-j_1bbranch }|
                                                WHEN ls_partner_local-bpkind IS NOT INITIAL " Cliente
                                                THEN |2{ ls_t001w-j_1bbranch }|
                                                ELSE space ).
    ELSE.

      ls_record-chaveredespacho       = COND #( WHEN ls_partner_local-bpkind = '0002' " Empresa
                                                THEN |1{ ls_partner_local-cnpj }|
                                                WHEN ls_partner_local-bpkind = '0020' " Transportador
                                                THEN |4{ ls_partner_local-cnpj }|
                                                WHEN ls_partner_local-bpkind = '0023' " Local de Redespacho
                                                THEN |5{ ls_partner_local-cnpj }|
                                                WHEN ls_partner_local-bpkind IS NOT INITIAL " Cliente
                                                THEN |2{ ls_partner_local-cnpj }|
                                                ELSE space ).
    ENDIF.

    " Recupera dados do transportador
    SELECT SINGLE *
        FROM zi_ca_vh_partner
        WHERE Parceiro  = @is_remessa-tspid
        INTO @DATA(ls_partner_transp).

    IF sy-subrc NE 0.
      CLEAR ls_partner_transp.
    ENDIF.

    ls_record-cdtrpredespacho       = COND #( WHEN ls_partner_transp-bpkind = '0020'
                                              THEN ls_partner_transp-cnpj
                                              ELSE space ).

    APPEND ls_record TO gt_file_content.

  ENDMETHOD.


  METHOD registro_150.

    DATA: ls_record TYPE zstm_fo_gko_reg_150.

    ls_record-tipo_reg    = '150'.
    ls_record-floperacao  = 'A'.

*    ls_record-dsitem = is_item-item_descr.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = is_item-item_descr
      IMPORTING
        outtext = ls_record-dsitem.

    ls_record-cditem = is_item-product_id.
    SHIFT ls_record-cditem LEFT DELETING LEADING '0'.
    TRY.
        IF gt_hierarquia[ matnr = is_item-product_id ]-prdha IS NOT INITIAL.
          ls_record-cditmcategoria = gt_hierarquia[ matnr = is_item-product_id ]-prdha(5).
        ENDIF.
*        ls_record-cditmcategoria = gt_hierarquia[ matnr = is_item-product_id ]-matkl.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.
  ENDMETHOD.


  METHOD registro_160.

    DATA: ls_record    TYPE zstm_fo_gko_reg_160,
          lv_itm       TYPE j_1bitmnum,
          lv_VBELN     TYPE vbeln_vl,
          lv_aux       TYPE /scmtms/base_btd_id,
          lv_vrntaitem TYPE /scmtms/amt_goodsvalue_val.

    DATA: lv_tts  TYPE p LENGTH 15 DECIMALS 2,
          lv_cvlr TYPE c LENGTH 15.

    ls_record-tipo_reg        = '160'.
    ls_record-floperacao      = 'A'.
    ls_record-cdcontacontabil = '5'.
    ls_record-cdcentrocusto   = '99999'.
    lv_aux = is_item-base_btd_id.
    SHIFT lv_aux LEFT DELETING LEADING '0'.
    lv_vbeln = lv_aux.
    UNPACK lv_vbeln TO lv_vbeln.


    ls_record-parceirocomercial = '1' && is_remessa-branch.

    ls_record-cdnota     = is_remessa-nfenum.

    ls_record-cdserie    = is_remessa-series.
    IF is_ref-cfop IS NOT INITIAL.
      DATA(lv_len) = strlen( is_ref-cfop ) - 2.
      IF lv_len > 0 .
        ls_record-cdnatureza = is_ref-cfop(lv_len).
      ENDIF.
    ENDIF.

    IF ls_record-cdserie IS INITIAL.
      ls_record-cdserie = '0'.
    ENDIF.

    ls_record-nontaitem     = iv_nontaitem. " is_item-base_btditem_id / 10.
    ls_record-cditem        = is_item-product_id.

    lv_vrntaitem            = is_ref-netwr.

*    lv_vrntaitem            = is_item-amt_gdsv_val * 10000.
*    LOOP AT  gt_taxanf REFERENCE INTO DATA(ls_taxanf) WHERE docnum = is_ref-docnum
*                                                        AND itmnum = is_ref-itmnum.
*      lv_vrntaitem     = lv_vrntaitem + ls_taxanf->taxval.
*    ENDLOOP.

    lv_tts = lv_vrntaitem.
    lv_cvlr = lv_tts.
    REPLACE '.' WITH '' INTO lv_cvlr.
    CONDENSE lv_cvlr NO-GAPS.
    ls_record-vrntaitem     = lv_cvlr.
    SHIFT ls_record-vrntaitem RIGHT DELETING TRAILING space.

    lv_tts = is_item-gro_wei_val.
    lv_cvlr = lv_tts.
    REPLACE '.' WITH '' INTO lv_cvlr.
    ls_record-qtpesobruto   = lv_cvlr.

    lv_tts = is_item-net_wei_val.
    lv_cvlr = lv_tts.
    REPLACE '.' WITH '' INTO lv_cvlr.
    ls_record-qtpesoliquido = lv_cvlr.

    lv_tts = is_item-qua_pcs_val.
    lv_cvlr = lv_tts.
    REPLACE '.' WITH '' INTO lv_cvlr.
    ls_record-qtitem        = lv_cvlr.

    ls_record-dsuniitem     = is_item-qua_pcs_uni.

    ls_record-stcreditoicms     = '0'.
    ls_record-stcreditoimposto1 = '0'.

    lv_itm = ls_record-nontaitem.
    SHIFT lv_itm LEFT DELETING LEADING '0'.
    UNPACK lv_itm TO lv_itm.

    READ TABLE gt_taxanf WITH KEY docnum = is_remessa-docnum
                                  itmnum = lv_itm
                                  taxtyp = 'ICM3'
    ASSIGNING FIELD-SYMBOL(<fs_taxa>) BINARY SEARCH.

    IF sy-subrc = 0.
      ls_record-stcreditoicms     = '1'.
      ls_record-stcreditoimposto1 = '1'.
    ENDIF.

    TRY.
        ls_record-vrcubagem = gt_cubagem[ 1 ]-volume * 10000.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.

  ENDMETHOD.


  METHOD criar_arquivo.

    DATA: lv_tor_id TYPE char10.

    " DATA(lv_filename) = gv_pasta_arquivo && '/' && TEXT-000 && gs_root-tor_id+10 && '-' && sy-datum && '-' && sy-uzeit && '.txt'.

    DATA lv_dir TYPE val_text.

    SELECT SINGLE parametro
      FROM zttm_pcockpit001
     WHERE id = 24        "Parametro Diretorio OF GKO
      INTO @lv_dir.

    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = gs_root-tor_id
        IMPORTING
          output = lv_tor_id.

      DATA(lv_filename) = lv_dir && '/' && TEXT-000 && lv_tor_id && '-' && sy-datum && '-' && sy-uzeit && '.txt'.

      OPEN DATASET lv_filename FOR OUTPUT IN TEXT MODE ENCODING UTF-8.
      IF sy-subrc = 0.
        LOOP AT gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
          TRANSFER <fs_content> TO lv_filename.
        ENDLOOP.

        CLOSE DATASET lv_filename.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD registro_142.

    DATA: ls_record TYPE zstm_fo_gko_reg_142.

    ls_record-tipo_reg      = '142'.
    ls_record-cdreferencia1 = 'Operacao'(001).
    ls_record-dsreferencia1 = COND #( WHEN is_registro_100-br_nfpartnertype = '1'
                                      THEN 'Macro'(003)
                                      WHEN gs_root-tor_type = '1030'
                                      THEN 'Ecommerce'(004)
                                      ELSE 'Micro'(002) ).

*    ls_record-dsreferencia1 = SWITCH #( gs_root-tor_type WHEN '1010' THEN 'Micro'(002)
*                                                         WHEN '1020' THEN 'Macro'(003)
*                                                         WHEN '1030' THEN 'Ecommerce'(004) ).

    APPEND INITIAL LINE TO gt_file_content ASSIGNING FIELD-SYMBOL(<fs_content>).
    <fs_content> = ls_record.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    "Rotina para teste unitário
    DATA(lo_obj) = NEW zcltm_interface_fo_gko( ).
    lo_obj->gerar_arquivo_gko(
      EXPORTING
*        iv_tor_key  = '005056B095991EECA48F09C1B164B700' "S4D-100
*        iv_tor_key  = '005056B095991EDCA6FA300D62EAFE6E' "S4D-110
         iv_tor_key  = '005056B095991EECA9ACB0429B7BAB74' "S4D-110 FO:6100000266
      IMPORTING
        et_messages = DATA(lt_msg) ).
  ENDMETHOD.


  METHOD check_all_ok.

    go_srv_mng = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = /scmtms/if_tor_c=>sc_bo_key ).

    "Ler dados de cabeçalho da ordem de frete
    get_root( EXPORTING iv_tor_key = iv_tor_key ).

    CHECK gs_root-tor_cat = 'TO'.

    "Ler os ítens da ordem de frete
    get_items( ).
    rv_ok = abap_false.

    "Validar se ordem de frete deve ser realmente enviada ao GKO
    validar_parametros( EXPORTING iv_interface = iv_interface " Interface de Disparo
                        IMPORTING et_messages  = et_messages
                                  ev_error     = DATA(lv_erro_validacao) ).

    CHECK lv_erro_validacao = abap_false.

    IF iv_interface EQ zcltm_interface_fo_gko=>gc_interface-greenmile.
      valida_fu( ).
    ENDIF.

    "Validar se todas as notas fiscais estão autorizadas na SEFAZ
    validar_notas( IMPORTING et_messages = et_messages
                             ev_error    = DATA(lv_erro_validacao_nfes) ).
    CHECK lv_erro_validacao_nfes = abap_false.
    rv_ok = abap_true.

  ENDMETHOD.


  METHOD valida_fu.

    " Tables
    DATA: lt_fu_root TYPE /scmtms/t_tor_root_k.

    " Ranges
    DATA: lr_fu_root TYPE RANGE OF /bobf/conf_key.

    TRY.
        go_srv_mng->retrieve_by_association(
          EXPORTING
            iv_node_key    = /scmtms/if_tor_c=>sc_node-root                     " Node
            it_key         = VALUE #( ( key = gs_root-key ) )                   " Key Table
            iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus " Association
            iv_fill_data   = abap_true
          IMPORTING
            et_data        = lt_fu_root ).

        DELETE lt_fu_root WHERE tor_type NE 'F013'.

        CHECK lt_fu_root[] IS NOT INITIAL.

        lr_fu_root = VALUE #( FOR <fs_fu_root> IN lt_fu_root
                            ( sign   = /bobf/if_conf_c=>sc_sign_option_including
                              option = /bobf/if_conf_c=>sc_sign_equal
                              low    = <fs_fu_root>-key ) ).

        DELETE gt_items WHERE fu_root_key IN lr_fu_root.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
