CLASS zcltm_mdf_events_manual DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_t_municipio       TYPE STANDARD TABLE OF zi_tm_mdf_municipio .
    TYPES:
      ty_t_placa           TYPE STANDARD TABLE OF zi_tm_mdf_placa .
    TYPES:
      ty_t_placa_condutor  TYPE STANDARD TABLE OF zi_tm_mdf_placa_condutor .
    TYPES:
      ty_t_placa_vale_ped  TYPE STANDARD TABLE OF zi_tm_mdf_placa_vale_pedagio .
    TYPES:
      ty_t_carregamento    TYPE STANDARD TABLE OF zi_tm_mdf_carregamento .
    TYPES:
      ty_t_descarregamento TYPE STANDARD TABLE OF zi_tm_mdf_descarregamento .
    TYPES:
      ty_t_complemento     TYPE STANDARD TABLE OF zi_tm_mdf_complemento .
    TYPES:
      ty_t_motorista       TYPE STANDARD TABLE OF zi_tm_mdf_motorista .
    TYPES:
      ty_t_mdf             TYPE STANDARD TABLE OF zi_tm_mdf .
    TYPES:
      ty_reported          TYPE RESPONSE FOR REPORTED EARLY zi_tm_mdf .
    TYPES:
      ty_t_freight_order   TYPE STANDARD TABLE OF /scmtms/tor_id WITH DEFAULT KEY .
    TYPES:
      ty_t_nota_fiscal     TYPE STANDARD TABLE OF j_1bnfdoc-docnum .
    TYPES:
      ty_t_access_key      TYPE STANDARD TABLE OF j_1b_nfe_access_key_dtel44 .
    TYPES:
      ty_t_mdf_nf          TYPE STANDARD TABLE OF zi_tm_vh_mdf_nf .
    TYPES:
      ty_tab_mdf           TYPE STANDARD TABLE OF zttm_mdf .
    TYPES:
      ty_tab_ide           TYPE STANDARD TABLE OF zttm_mdf_ide .
    TYPES:
      ty_tab_municipio     TYPE STANDARD TABLE OF zttm_mdf_mcd .
    TYPES:
      ty_tab_motorista     TYPE STANDARD TABLE OF zttm_mdf_moto .
    TYPES:
*      ty_tab_carregamento    TYPE STANDARD TABLE OF zttm_mdf_munc,
*      ty_tab_descarregamento TYPE STANDARD TABLE OF zttm_mdf_mund,
      ty_tab_placa_c       TYPE STANDARD TABLE OF zttm_mdf_placa_c .
    TYPES:
      ty_tab_placa_v       TYPE STANDARD TABLE OF zttm_mdf_placa_v .
    TYPES:
      ty_tab_placa         TYPE STANDARD TABLE OF zttm_mdf_placa .
    TYPES:
      ty_tab_historico     TYPE STANDARD TABLE OF zttm_mdf_hist .

    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_message
      IMPORTING
        !iv_change_error_type   TYPE flag OPTIONAL
        !iv_change_warning_type TYPE flag OPTIONAL
      CHANGING
        !ct_return              TYPE bapiret2_t .
    "! Recupera ID do MDF-e
    "! @parameter iv_agrupador | Código do agrupador
    "! @parameter ev_id | ID do MDF-e
    "! @parameter rv_id | ID do MDF-e
    METHODS get_id
      IMPORTING
        !iv_agrupador TYPE zttm_mdf-docnum
      EXPORTING
        !ev_id        TYPE zttm_mdf-id
      RETURNING
        VALUE(rv_id)  TYPE zttm_mdf-id .
    "! Valida Informações MF-e
    "! @parameter is_mdf | Informações MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_mdf
      IMPORTING
        !is_mdf    TYPE zi_tm_mdf
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Determina valores para tabela de cabeçalho
    "! @parameter it_municipio | Lista de municípios (NF)
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cs_mdf | Informações de cabeçalho
    METHODS determine_mdf
      IMPORTING
        !it_municipio TYPE ty_t_municipio
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !cs_mdf       TYPE zi_tm_mdf .
    "! Salva regustris na tabela de cabeçalho
    "! @parameter is_mdf | Informações MDF-e
    "! @parameter es_mdf | Informações MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS save_mdf
      IMPORTING
        !iv_save   TYPE flag DEFAULT abap_true
        !is_mdf    TYPE zi_tm_mdf
      EXPORTING
        !es_mdf    TYPE zttm_mdf
        !et_return TYPE bapiret2_t .
    "! Valida informações complementares
    "! @parameter is_mdf_ide | Informações Complementares MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_complemento
      IMPORTING
        !is_mdf_ide TYPE zi_tm_mdf_complemento
      EXPORTING
        !et_return  TYPE bapiret2_t .
    "! Determina valores inciais para tabela IDE
    "! @parameter is_mdf | Informações MDF-e
    "! @parameter es_mdf_ide | Informações Complementares MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS determine_complemento
      IMPORTING
        !is_mdf     TYPE zi_tm_mdf
      EXPORTING
        !es_mdf_ide TYPE zi_tm_mdf_complemento
        !et_return  TYPE bapiret2_t .
    "! Salva registros na tabela IDE
    "! @parameter is_mdf_ide | Informações Complementares MDF-e
    "! @parameter es_mdf_ide | Informações Complementares MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS save_complemento
      IMPORTING
        !iv_save    TYPE flag DEFAULT abap_true
        !is_mdf_ide TYPE zi_tm_mdf_complemento
      EXPORTING
        !es_mdf_ide TYPE zttm_mdf_ide
        !et_return  TYPE bapiret2_t .
    "! Valida dados de carregamento
    "! @parameter it_carregamento |  Informações dos municípios de carregamento
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_carregamento
      IMPORTING
        !it_carregamento TYPE ty_t_carregamento
      EXPORTING
        !et_return       TYPE bapiret2_t .
    "! Valida dados de descarregamento
    "! @parameter it_descarregamento |  Informações dos municípios de descarregamento
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_descarregamento
      IMPORTING
        !it_descarregamento TYPE ty_t_descarregamento
      EXPORTING
        !et_return          TYPE bapiret2_t .
    "! Valida Informações de placa
    "! @parameter it_placa | Informações de placa
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_placa
      IMPORTING
        !it_placa  TYPE ty_t_placa
        !iv_send   TYPE flag OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Salva registros na tabela de placa
    "! @parameter it_placa | Informações de placa
    "! @parameter et_return | Mensagens de retorno
    METHODS save_placa
      IMPORTING
        !iv_save      TYPE flag DEFAULT abap_true
        !it_placa     TYPE ty_t_placa
      EXPORTING
        !et_mdf_placa TYPE zctgtm_mdf_placa
        !et_return    TYPE bapiret2_t .
    "! Salva registros na tabela de placa
    "! @parameter it_condutor | Informações de condutor
    "! @parameter et_return | Mensagens de retorno
    METHODS save_placa_condutor
      IMPORTING
        !iv_save        TYPE flag DEFAULT abap_true
        !it_condutor    TYPE ty_t_placa_condutor
      EXPORTING
        !et_mdf_placa_c TYPE zctgtm_mdf_placa_c
        !et_return      TYPE bapiret2_t .
    "! Salva registros na tabela de placa
    "! @parameter it_vale_pedagio | Informações de vale pedágio
    "! @parameter et_return | Mensagens de retorno
    METHODS save_placa_vale_pedagio
      IMPORTING
        !iv_save         TYPE flag DEFAULT abap_true
        !it_vale_pedagio TYPE ty_t_placa_vale_ped
      EXPORTING
        !et_mdf_placa_v  TYPE zctgtm_mdf_placa_v
        !et_return       TYPE bapiret2_t .
    "! Valida campos de proprietário na placa
    "! @parameter is_placa | Informações de placa
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_proprietario
      IMPORTING
        !is_placa  TYPE zi_tm_mdf_placa
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Determina automaticamente informações do Proprietário
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cs_placa | Informações de placa
    METHODS determine_placa
      EXPORTING
        !et_return TYPE bapiret2_t
      CHANGING
        !cs_placa  TYPE zi_tm_mdf_placa .
    "! Determina valores para tabela de cabeçalho
    "! @parameter it_municipio | Lista de municípios (NF)
    "! @parameter et_placa | Informações de placa
    "! @parameter et_return | Mensagens de retorno
    METHODS determine_placa_from_fo
      IMPORTING
        !it_municipio TYPE ty_t_municipio
      EXPORTING
        !et_placa     TYPE ty_t_placa
        !et_return    TYPE bapiret2_t .
    "! Determina placa para tabela de cabeçalho
    "! @parameter it_access_key | Chave de acesso
    "! @parameter et_placa | Informações de placa
    "! @parameter et_return | Mensagens de retorno
    METHODS determine_placa_from_acckey
      IMPORTING
        !is_mdf        TYPE zi_tm_mdf
        !it_access_key TYPE ty_t_access_key
      EXPORTING
        !et_placa      TYPE ty_t_placa
        !et_return     TYPE bapiret2_t .
    "! Determina motorista para tabela de cabeçalho
    "! @parameter it_access_key | Chave de acesso
    "! @parameter es_motorista | Informações de motorista
    "! @parameter et_return | Mensagens de retorno
    METHODS determine_moto_from_acckey
      IMPORTING
        !is_mdf        TYPE zi_tm_mdf
        !it_access_key TYPE ty_t_access_key
      EXPORTING
        !es_motorista  TYPE zi_tm_mdf_motorista
        !et_return     TYPE bapiret2_t .
    "! Valida campos do Vale Pedágio
    "! @parameter is_vale | Informações de vale pedágio
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_vale_pedagio
      IMPORTING
        !is_vale   TYPE zi_tm_mdf_placa_vale_pedagio
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Determina dados do Vale Pedágio
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cs_vale | Informações de vale pedágio
    METHODS determine_vale_pedagio
      EXPORTING
        !et_return TYPE bapiret2_t
      CHANGING
        !cs_vale   TYPE zi_tm_mdf_placa_vale_pedagio .
    "! Determina automaticamente informações dos municípios (Notas Transporte)
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_municipio | Informações de município
    METHODS determine_municipio
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_municipio TYPE ty_t_municipio .
    "! Determina municipios de carga e descarga da Nota Fiscal
    "! @parameter it_municipio | Informações de município
    "! @parameter et_municipio | Informações de município
    METHODS determine_municipio_info
      IMPORTING
        !it_municipio TYPE ty_t_municipio
      EXPORTING
        !et_municipio TYPE ty_t_municipio .
    "! Valida informações dos municípios (Notas Transporte)
    "! @parameter it_municipio | Informações de município
    "! @parameter et_municipio_ok | Informações de município válidos
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_municipio
      IMPORTING
        !it_municipio    TYPE ty_t_municipio
      EXPORTING
        !et_municipio_ok TYPE ty_t_municipio
        !et_return       TYPE bapiret2_t .
    "! Salva informações dos municípios
    "! @parameter it_municipio | Informações de município
    "! @parameter et_mdf_mcd | Informações de município
    "! @parameter et_return | Mensagens de retorno
    METHODS save_municipio
      IMPORTING
        !iv_save      TYPE flag DEFAULT abap_true
        !it_municipio TYPE ty_t_municipio
      EXPORTING
        !et_mdf_mcd   TYPE zctgtm_mdf_mcd
        !et_return    TYPE bapiret2_t .
    "! Determina e salva informações dos municípios (Notas Transporte)
    "! @parameter iv_id | Identificador
    "! @parameter iv_accesskey | Lita de chaves de acesso
    "! @parameter iv_ordens | Ordens de frete
    "! @parameter et_return | Mensagens de retorno
    METHODS save_mcd_list
      IMPORTING
        !iv_id        TYPE zi_tm_mdf_municipio-guid
        !iv_accesskey TYPE string OPTIONAL
        !iv_ordens    TYPE string OPTIONAL
      EXPORTING
        !et_return    TYPE bapiret2_t .
    "! Valida dados do condutor
    "! @parameter is_condutor | Informações do condutor
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_condutor
      IMPORTING
        !is_condutor TYPE zi_tm_mdf_placa_condutor
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Determina dados do condutor
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cs_condutor | Informações do condutor
    METHODS determine_condutor
      EXPORTING
        !et_return   TYPE bapiret2_t
      CHANGING
        !cs_condutor TYPE zi_tm_mdf_placa_condutor .
    "! Valida dados de motorista
    "! @parameter is_motorista | Informações de motorista
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_motorista
      IMPORTING
        !is_motorista TYPE zi_tm_mdf_motorista
      EXPORTING
        !et_return    TYPE bapiret2_t .
    "! Determina dados de motorista
    "! @parameter iv_id | Id do MDF-e
    "! @parameter iv_motorista | Novo motorista
    "! @parameter es_motorista | Informações de motorista
    "! @parameter et_return | Mensagens de retorno
    METHODS determine_motorista
      IMPORTING
        !iv_id        TYPE zi_tm_mdf-guid
        !iv_motorista TYPE zc_tm_mdf_motorista_popup-motorista
      EXPORTING
        !es_motorista TYPE zi_tm_mdf_motorista
        !et_return    TYPE bapiret2_t .
    "! Adiciona motorista
    "! @parameter is_motorista | Informações de motorista
    "! @parameter es_mdf_moto | Informações de motorista
    "! @parameter et_return | Mensagens de retorno
    METHODS add_motorista
      IMPORTING
        !iv_save      TYPE flag DEFAULT abap_true
        !is_motorista TYPE zi_tm_mdf_motorista
      EXPORTING
        !es_mdf_moto  TYPE zttm_mdf_moto
        !et_return    TYPE bapiret2_t .
    "! Valida dados de percurso
    "! @parameter is_percurso | Informações de percurso
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_percurso
      IMPORTING
        !is_percurso TYPE zi_tm_mdf_percurso_doc
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Realiza todas as validações
    "! @parameter iv_id | Id do MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_all
      IMPORTING
        !iv_id     TYPE zi_tm_mdf-guid
        !iv_send   TYPE flag DEFAULT space
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING
        !it_return   TYPE bapiret2_t
      EXPORTING
        !es_reported TYPE ty_reported .
    "! Utiliza Ordem de Frete para criar MDF-e
    "! @parameter it_freight_order | Ordem de Frete
    "! @parameter iv_save | Salva os dados
    "! @parameter iv_send | Envio MDF-e
    "! @parameter et_return | Mensagens de retorno
    METHODS use_fo_create_mdf
      IMPORTING
        !it_freight_order TYPE ty_t_freight_order OPTIONAL
        !it_nota_fiscal   TYPE ty_t_nota_fiscal OPTIONAL
        !iv_save          TYPE flag DEFAULT abap_true
        !iv_send          TYPE flag DEFAULT abap_true
      EXPORTING
        !et_return        TYPE bapiret2_t .
    "! Cria dados de MDFe a partir da Ordem de frete
    "! @parameter it_freight_order | Ordem de Frete
    "! @parameter es_mdf | Cabeçalho da MDFe
    "! @parameter es_complemento | Dados de complemento
    "! @parameter et_municipio | Dados de município
    "! @parameter es_motorista | Dados de motorista
    "! @parameter et_placa | Dados de placa
    "! @parameter et_condutor | Dados de condutor
    "! @parameter et_vale_pedagio | Dados de Vale Pedágio
    "! @parameter et_return | Mensagens de retorno
    METHODS get_data_fo_to_mdf
      IMPORTING
        !iv_id            TYPE sysuuid_x16 OPTIONAL
        !it_freight_order TYPE ty_t_freight_order OPTIONAL
        !it_nota_fiscal   TYPE ty_t_nota_fiscal OPTIONAL
        !it_access_key    TYPE ty_t_access_key OPTIONAL
      EXPORTING
        !es_mdf           TYPE zi_tm_mdf
        !es_complemento   TYPE zi_tm_mdf_complemento
        !et_municipio     TYPE ty_t_municipio
        !es_motorista     TYPE zi_tm_mdf_motorista
        !et_placa         TYPE ty_t_placa
        !et_condutor      TYPE ty_t_placa_condutor
        !et_vale_pedagio  TYPE ty_t_placa_vale_ped
        !et_return        TYPE bapiret2_t .
    "! Recupera dados da chave de acesso e verifica se não é uma NF externa
    METHODS get_and_validate_acckey
      IMPORTING
        !it_access_key TYPE ty_t_access_key
      EXPORTING
        !et_nf         TYPE ty_t_mdf_nf
        !et_return     TYPE bapiret2_t .
    "! Cria MDFe a partir de uma MDFe existente
    "! @parameter iv_id | Identificador
    "! @parameter et_mdf | Cabeçalho da MDFe
    "! @parameter et_ide | Dados de complemento
    "! @parameter et_municipio | Dados de município
    "! @parameter et_motorista | Dados de motorista
    "! @parameter et_placa_c | Dados de condutor
    "! @parameter et_placa_v | Dados de Vale Pedágio
    "! @parameter et_placa | Dados de placa
    "! @parameter et_return | Mensagens de retorno
    METHODS get_exist_data_mdfe
      IMPORTING
        !iv_id        TYPE sysuuid_x16
      EXPORTING
        !et_mdf       TYPE ty_tab_mdf
        !et_ide       TYPE ty_tab_ide
        !et_municipio TYPE ty_tab_municipio
        !et_motorista TYPE ty_tab_motorista
        !et_placa_c   TYPE ty_tab_placa_c
        !et_placa_v   TYPE ty_tab_placa_v
        !et_placa     TYPE ty_tab_placa
        !et_return    TYPE bapiret2_t .
    "! Clona dados de MDFe a partir da mdfe selecionada
    "! @parameter iv_id | ID do MDFe
    "! @parameter et_return | Mensagens de retorno
    METHODS use_exist_mdfe_to_new_mdfe
      IMPORTING
        !iv_id     TYPE sysuuid_x16
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Salva dados
    "! @parameter is_mdf | Cabeçalho da MDFe
    "! @parameter is_complemento | Dados de complemento
    "! @parameter it_municipio | Dados de município
    "! @parameter is_motorista | Dados de motorista
    "! @parameter it_placa | Dados de placa
    "! @parameter it_condutor | Dados de condutor
    "! @parameter it_vale_pedagio | Dados de Vale Pedágio
    "! @parameter et_return | Mensagens de retorno
    METHODS save
      IMPORTING
        !is_mdf          TYPE zi_tm_mdf OPTIONAL
        !is_complemento  TYPE zi_tm_mdf_complemento OPTIONAL
        !it_municipio    TYPE ty_t_municipio OPTIONAL
        !is_motorista    TYPE zi_tm_mdf_motorista OPTIONAL
        !it_placa        TYPE ty_t_placa OPTIONAL
        !it_condutor     TYPE ty_t_placa_condutor OPTIONAL
        !it_vale_pedagio TYPE ty_t_placa_vale_ped OPTIONAL
      EXPORTING
        !et_return       TYPE bapiret2_t .
    "! Salva dados
    "! @parameter is_mdf | Cabeçalho da MDFe
    "! @parameter is_mdf_ide | Dados de complemento
    "! @parameter it_mdf_mcd | Dados de município
    "! @parameter is_mdf_moto | Dados de motorista
    "! @parameter it_mdf_placa | Dados de placa
    "! @parameter it_mdf_placa_c | Dados de condutor
    "! @parameter it_mdf_placa_v | Dados de Vale Pedágio
    "! @parameter et_return | Mensagens de retorno
    METHODS save_background
      IMPORTING
        !is_mdf         TYPE zttm_mdf
        !is_mdf_ide     TYPE zttm_mdf_ide
        !it_mdf_mcd     TYPE zctgtm_mdf_mcd
        !is_mdf_moto    TYPE zttm_mdf_moto
        !it_mdf_placa   TYPE zctgtm_mdf_placa
        !it_mdf_placa_c TYPE zctgtm_mdf_placa_c
        !it_mdf_placa_v TYPE zctgtm_mdf_placa_v
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Recupera histórico da MDF-e
    "! @parameter is_mdf | Cabeçalho da MDFe
    "! @parameter et_return | Mensagens de retorno
    METHODS get_history
      IMPORTING
        !iv_id     TYPE zttm_mdf-id OPTIONAL
        !is_mdf    TYPE zttm_mdf OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Recupera histórico da MDF-e (background)
    "! @parameter is_mdf | Cabeçalho da MDFe
    "! @parameter es_mdfehd | MDF-e Outbound Header Data
    "! @parameter et_return | Mensagens de retorno
    METHODS get_history_background
      IMPORTING
        !is_mdf    TYPE zttm_mdf
      EXPORTING
        !es_mdfehd TYPE /xnfe/outmdfehd
        !et_return TYPE bapiret2_t .
    "! Atualiza Ordem de Frete com novo status
    "! @parameter is_mdfehd | MDF-e Outbound Header Data
    "! @parameter et_return | Mensagens de retorno
    METHODS update_freight_order
      IMPORTING
        !is_mdf    TYPE zttm_mdf
        !is_mdfehd TYPE /xnfe/outmdfehd
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS update_mdf_using_fo
      IMPORTING
        !iv_id     TYPE zttm_mdf-id OPTIONAL
        !is_mdf    TYPE zttm_mdf OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Ler as mensagens geradas pelo processamento
    "! @parameter p_task |Noma da task executada
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA:
      "!Armazenamento das mensagens de processamento
      gt_return     TYPE STANDARD TABLE OF bapiret2,

      "!Flag para sincronizar o processamento da função de criação de ordens de produção
      gv_wait_async TYPE abap_bool.

ENDCLASS.



CLASS zcltm_mdf_events_manual IMPLEMENTATION.


  METHOD format_message.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E' AND iv_change_error_type IS NOT INITIAL
                                THEN 'I'
                                WHEN ls_return->type EQ 'W' AND iv_change_warning_type IS NOT INITIAL
                                THEN 'I'
                                ELSE ls_return->type ).

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


  METHOD get_id.

    FREE: ev_id.

* ---------------------------------------------------------------------------
* Recupera Id do MDF-e
* ---------------------------------------------------------------------------
    SELECT SINGLE id
       FROM zttm_mdf
       WHERE docnum = @iv_agrupador
       INTO @ev_id.

    IF sy-subrc NE 0.
      FREE ev_id.
    ENDIF.

    rv_id = ev_id.

  ENDMETHOD.


  METHOD validate_mdf.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Validação de campos
* ---------------------------------------------------------------------------
*    IF is_mdf-TipoEmissao IS INITIAL.
*      " Favor preencher campo 'Tipo de emissão'
*      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'TIPOEMISSAO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '022' ) ).
*    ENDIF.

    IF is_mdf-modfrete IS INITIAL.
      " Favor preencher campo 'Modalidade de Frete'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'MODFRETE' type = 'E' id = 'ZTM_MONITOR_MDF' number = '023' ) ).
    ENDIF.

    IF is_mdf-domfiscalinicio IS INITIAL.
      " Favor preencher campo 'Domicílio Fiscal'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'DOMFISCALINICIO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '024' ) ).
    ENDIF.

    IF is_mdf-domfiscalfim IS INITIAL.
      " Favor preencher campo 'Domicílio Fiscal'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'DOMFISCALFIM' type = 'E' id = 'ZTM_MONITOR_MDF' number = '024' ) ).
    ENDIF.

    IF is_mdf-localexpedicao IS INITIAL.
      " Favor preencher campo 'Local de Expedição'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'LOCALEXPEDICAO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '025' ) ).
    ENDIF.

*    IF is_mdf-rntrc IS INITIAL.
*      " Favor preencher campo 'RNTRC'.
*      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'RNTRC' type = 'E' id = 'ZTM_MONITOR_MDF' number = '026' ) ).
*    ENDIF.

    IF is_mdf-ufinicio IS INITIAL.
      " Favor preencher campo 'UF Origem'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'UFINICIO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '027' ) ).
    ENDIF.

    IF is_mdf-uffim IS INITIAL.
      " Favor preencher campo 'UF Destino'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'UFFIM' type = 'E' id = 'ZTM_MONITOR_MDF' number = '028' ) ).
    ENDIF.

    IF is_mdf-datainicioviagem IS INITIAL.
      " Favor preencher campo 'Data Início Viagem'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'DATAINICIOVIAGEM' type = 'E' id = 'ZTM_MONITOR_MDF' number = '029' ) ).
    ENDIF.

*    IF is_mdf-HoraInicioViagem IS INITIAL.
*      " Favor preencher campo 'Hora Início Viagem'.
*      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'HORAINICIOVIAGEM' type = 'E' id = 'ZTM_MONITOR_MDF' number = '030' ) ).
*    ENDIF.

    IF is_mdf-companycode IS INITIAL.
      " Favor preencher campo 'Empresa'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'COMPANYCODE' type = 'E' id = 'ZTM_MONITOR_MDF' number = '031' ) ).
    ENDIF.

    IF is_mdf-businessplace IS INITIAL.
      " Favor preencher campo 'Local de negócio'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'BUSINESSPLACE' type = 'E' id = 'ZTM_MONITOR_MDF' number = '032' ) ).
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD determine_mdf.

    FREE: et_return.

    IF it_municipio IS NOT INITIAL.

      SELECT *
          FROM zi_tm_mdf_municipio_qty
          FOR ALL ENTRIES IN @it_municipio
          WHERE br_notafiscal = @it_municipio-br_notafiscal
          INTO TABLE @DATA(lt_mun).           "#EC CI_FAE_LINES_ENSURED

      IF sy-subrc NE 0.
        FREE lt_mun.
      ENDIF.

      SELECT DISTINCT
             nf~accesskey,
             doc~docnum,
             doc~bukrs,
             doc~branch,
             doc~modfrete,
             doc~vstel,
             doc~rntc,
             doc~txjcd,
             lin~werks,
             t001w~txjcd AS werks_txjcd
        FROM zi_tm_vh_mdf_nf AS nf
        INNER JOIN j_1bnfdoc AS doc
            ON doc~docnum = nf~br_notafiscal
        INNER JOIN j_1bnflin AS lin
            ON doc~docnum = lin~docnum
        LEFT OUTER JOIN t001w
            ON t001w~werks = lin~werks
        FOR ALL ENTRIES IN @it_municipio
        WHERE nf~accesskey = @it_municipio-accesskey
        INTO TABLE @DATA(lt_doc).

      IF sy-subrc NE 0.
        FREE lt_doc.
      ENDIF.

      TRY.
          DATA(ls_doc)  = lt_doc[ 1 ].
          DATA(lv_tjxcd_ini) = ls_doc-werks_txjcd.
          DATA(lv_tjxcd_fim) = ls_doc-werks_txjcd.
        CATCH cx_root.
      ENDTRY.

    ENDIF.

* ---------------------------------------------------------------------------
* Primeira busca:
* Recupera pontos de parada da Ordem de Frete (Carregamento e Descarregamento)
* ---------------------------------------------------------------------------
    IF it_municipio IS NOT INITIAL.

      SELECT *
          FROM zi_tm_get_stop_first_and_last
          FOR ALL ENTRIES IN @it_municipio
          WHERE freightorder = @it_municipio-freightorder
          INTO TABLE @DATA(lt_stop).

      IF sy-subrc NE 0.
        FREE lt_stop.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Segunda busca:
* Recupera pontos de parada da Nota Fiscal (Carregamento e Descarregamento)
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_municipio) = it_municipio.
        DELETE lt_municipio WHERE carga IS INITIAL.
        SORT lt_municipio BY carga.
        lv_tjxcd_ini = lt_municipio[ 1 ]-carga.
      CATCH cx_root.
    ENDTRY.

    TRY.
        lt_municipio = it_municipio.
        DELETE lt_municipio WHERE descarga IS INITIAL.
        SORT lt_municipio BY descarga.
        lv_tjxcd_fim = lt_municipio[ 1 ]-descarga.
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Prepara ponto de parada
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_stop) = lt_stop[ 1 ].
      CATCH cx_root.
        CLEAR ls_stop.
        ls_stop-firstregion     = lv_tjxcd_ini+0(3).
        ls_stop-firsttaxjurcode = lv_tjxcd_ini.
        ls_stop-lastregion      = lv_tjxcd_fim+0(3).
        ls_stop-lasttaxjurcode  = lv_tjxcd_fim.
    ENDTRY.

* ---------------------------------------------------------------------------
* Calcula totais
* ---------------------------------------------------------------------------
    TRY.
        cs_mdf-qtdnfe     = REDUCE ze_qtd_nfe(
                            INIT lv_qtd_nfe TYPE ze_qtd_nfe
                            FOR ls_mun IN lt_mun
                            NEXT lv_qtd_nfe = lv_qtd_nfe + 1 ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        cs_mdf-qtdnfewrt  = REDUCE ze_qtd_nfe(
                            INIT lv_qtd_nfe TYPE ze_qtd_nfe
                            FOR ls_mun IN lt_mun
                            WHERE ( br_nfiscreatedmanually = abap_true )
                            NEXT lv_qtd_nfe = lv_qtd_nfe + 1 ). "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.

    cs_mdf-vlrcarga       = REDUCE ze_qtd_nfe(
                            INIT lv_qtd_nfe TYPE ze_qtd_nfe
                            FOR ls_mun IN lt_mun
                            NEXT lv_qtd_nfe = lv_qtd_nfe + ls_mun-br_nftotalamount ).

    TRY.
        cs_mdf-moeda  = lt_mun[ 1 ]-salesdocumentcurrency.
      CATCH cx_root.
    ENDTRY.

    cs_mdf-datainicioviagem = COND #( WHEN cs_mdf-datainicioviagem IS INITIAL
                                      THEN sy-datum
                                      ELSE cs_mdf-datainicioviagem ).

    cs_mdf-horainicioviagem = COND #( WHEN cs_mdf-datainicioviagem IS INITIAL
                                      THEN sy-uzeit
                                      ELSE cs_mdf-horainicioviagem ).

    cs_mdf-companycode      = COND #( WHEN cs_mdf-companycode IS INITIAL
                                      THEN ls_doc-bukrs
                                      ELSE cs_mdf-companycode ).

    cs_mdf-businessplace    = COND #( WHEN cs_mdf-businessplace IS INITIAL
                                      THEN ls_doc-branch
                                      ELSE cs_mdf-businessplace ).

    cs_mdf-modfrete         = COND #( WHEN cs_mdf-modfrete IS INITIAL
                                      THEN ls_doc-modfrete
                                      ELSE cs_mdf-modfrete ).

    cs_mdf-ufinicio         = COND #( WHEN cs_mdf-ufinicio IS INITIAL
                                      THEN ls_stop-firstregion
                                      ELSE cs_mdf-ufinicio ).

    cs_mdf-uffim            = COND #( WHEN cs_mdf-uffim IS INITIAL
                                      THEN ls_stop-lastregion
                                      ELSE cs_mdf-uffim ).

    cs_mdf-domfiscalinicio  = COND #( WHEN cs_mdf-domfiscalinicio IS INITIAL
                                      THEN ls_stop-firsttaxjurcode
                                      ELSE cs_mdf-domfiscalinicio ).

    cs_mdf-domfiscalfim     = COND #( WHEN cs_mdf-domfiscalfim IS INITIAL
                                      THEN ls_stop-lasttaxjurcode
                                      ELSE cs_mdf-domfiscalfim ).

    cs_mdf-localexpedicao   = COND #( WHEN cs_mdf-localexpedicao IS INITIAL
                                      THEN ls_doc-vstel
                                      ELSE cs_mdf-localexpedicao ).

    cs_mdf-rntrc            = COND #( WHEN cs_mdf-rntrc IS INITIAL
                                      THEN ls_doc-rntc
                                      ELSE cs_mdf-rntrc ).

    cs_mdf-agrupador        = COND #( WHEN cs_mdf-agrupador IS INITIAL
                                      THEN zcltm_mdf_events=>doc_mdfe_create( IMPORTING et_return = et_return )
                                      ELSE cs_mdf-agrupador ).

  ENDMETHOD.


  METHOD save_mdf.

    FREE: et_return, es_mdf.

* ---------------------------------------------------------------------------
* Prepara informações IDE
* ---------------------------------------------------------------------------
    CHECK is_mdf IS NOT INITIAL.

    CLEAR es_mdf.
    es_mdf-id           = is_mdf-guid.
    es_mdf-docnum       = is_mdf-agrupador.
    es_mdf-manual       = is_mdf-manual.
    es_mdf-mdfenum      = is_mdf-br_mdfenumber.
    es_mdf-series       = is_mdf-br_mdfeseries.
    es_mdf-access_key   = is_mdf-accesskey.
    es_mdf-bukrs        = is_mdf-companycode.
    es_mdf-branch       = is_mdf-businessplace.
    es_mdf-modfrete     = is_mdf-modfrete.
    es_mdf-domfiscalini = is_mdf-domfiscalinicio.
    es_mdf-domfiscalfim = is_mdf-domfiscalfim.
    es_mdf-dtini        = is_mdf-datainicioviagem.
    es_mdf-hrini        = is_mdf-horainicioviagem.
    es_mdf-vstel        = is_mdf-localexpedicao.
    es_mdf-rntrc        = is_mdf-rntrc.
    es_mdf-correcao     = is_mdf-correcao.
    es_mdf-ref_of       = is_mdf-refof.
    es_mdf-nprot        = is_mdf-protocol.
    es_mdf-dhrecbto     = is_mdf-datahorarecebimento.
    es_mdf-statcod      = is_mdf-statuscode.
    es_mdf-xmotivo      = is_mdf-motivo.
    es_mdf-cstat        = is_mdf-cstat.
    es_mdf-inf_ad_fisco = is_mdf-infofisco.
    es_mdf-inf_cpl      = is_mdf-infocontrib.

    IF es_mdf-created_by IS INITIAL.
      es_mdf-created_by               = sy-uname.
      GET TIME STAMP FIELD es_mdf-created_at.
      es_mdf-last_changed_by          = es_mdf-created_by.
      es_mdf-last_changed_at          = es_mdf-created_at.
      es_mdf-local_last_changed_at    = es_mdf-created_at.
    ELSE.
      es_mdf-last_changed_by          = sy-uname.
      GET TIME STAMP FIELD es_mdf-last_changed_at.
      es_mdf-local_last_changed_at    = es_mdf-last_changed_at.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva informações de cabeçalho
* ---------------------------------------------------------------------------
    IF iv_save EQ abap_true.
      MODIFY zttm_mdf FROM es_mdf.

      IF sy-subrc NE 0.
        " Falha ao salvar as informações de cabeçalho.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '020' ) ).
        me->format_message( CHANGING ct_return = et_return[] ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_complemento.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Validação de campos
* ---------------------------------------------------------------------------
    IF is_mdf_ide-uf IS INITIAL.
      " Favor preencher campo complementar 'UF'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'UF' type = 'E' id = 'ZTM_MONITOR_MDF' number = '031' ) ).
    ENDIF.

    IF is_mdf_ide-tpamb IS INITIAL.
      " Favor preencher campo complementar 'Ambiente de Sistema'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'TPAMB' type = 'E' id = 'ZTM_MONITOR_MDF' number = '032' ) ).
    ENDIF.

    IF is_mdf_ide-tpemit IS INITIAL.
      " Favor preencher campo complementar 'Tipo de emitente'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'TPEMIT' type = 'E' id = 'ZTM_MONITOR_MDF' number = '033' ) ).
    ENDIF.

    IF is_mdf_ide-tptransp IS INITIAL.
      " Favor preencher campo complementar 'Tipo de transportadora'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'TPTRANSP' type = 'E' id = 'ZTM_MONITOR_MDF' number = '034' ) ).
    ENDIF.

    IF is_mdf_ide-mod IS INITIAL.
      "Favor preencher campo complementar 'Modelo MDF-e'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'MOD' type = 'E' id = 'ZTM_MONITOR_MDF' number = '035' ) ).
    ENDIF.

*    IF is_mdf_ide-CMdf IS INITIAL.
*      " Favor preencher campo complementar 'Nº aleatório'.
*      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'CMDF' type = 'E' id = 'ZTM_MONITOR_MDF' number = '036' ) ).
*    ENDIF.
*
*    IF is_mdf_ide-CDv IS INITIAL.
*      " Favor preencher campo complementar 'Dígito verificador'.
*      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'CDV' type = 'E' id = 'ZTM_MONITOR_MDF' number = '037' ) ).
*    ENDIF.

    IF is_mdf_ide-modal IS INITIAL.
      " Favor preencher campo complementar 'Tipo de transporte'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'MODAL' type = 'E' id = 'ZTM_MONITOR_MDF' number = '038' ) ).
    ENDIF.

    IF is_mdf_ide-dhemi IS INITIAL.
      " Favor preencher campo complementar 'Data/hora da emissão'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'DHEMI' type = 'E' id = 'ZTM_MONITOR_MDF' number = '039' ) ).
    ENDIF.

    IF is_mdf_ide-tpemis IS INITIAL.
      " Favor preencher campo complementar 'Tipo de emissão'.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-complemento field = 'TPEMIS' type = 'E' id = 'ZTM_MONITOR_MDF' number = '040' ) ).
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD determine_complemento.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Determina valores IDE para processo Manual/Automático
* ---------------------------------------------------------------------------
    FREE: es_mdf_ide.
    es_mdf_ide-id               = is_mdf-guid.
    es_mdf_ide-uf               = is_mdf-ufinicio.

    CALL FUNCTION 'PRGN_CHECK_SYSTEM_PRODUCTIVE'
      EXCEPTIONS
        client_is_productive = 1
        OTHERS               = 2.

    IF sy-subrc EQ 1.
      es_mdf_ide-tpamb          = gc_tpamb-produtivo.
    ELSE.
      es_mdf_ide-tpamb          = gc_tpamb-teste.
    ENDIF.

    es_mdf_ide-tpemit           = gc_tpemit-nao_transporte.
    es_mdf_ide-tptransp         = gc_tptransp-etc.
    es_mdf_ide-mod              = gc_mod-58.
    es_mdf_ide-modal            = gc_modal-rua.

    GET TIME STAMP FIELD es_mdf_ide-dhemi.

*    IF is_mdf-TipoEmissao EQ gc_tpemis-normal.
    es_mdf_ide-tpemis         = gc_tpemis-normal.
*    ELSE.
*      es_mdf_ide-TpEmis         = gc_tpemis-contingencia.
*    ENDIF.

*    IF is_mdf-Manual NE abap_true.
*
*      SELECT SINGLE docnum, docnum9, cdv
*         FROM j_1bnfe_active
*         INTO @DATA(ls_active)
*         WHERE docnum  = @is_mdf-Agrupador
*           AND conting = @abap_true.
*
*      IF sy-subrc NE 0.
*        CLEAR ls_active.
*      ENDIF.
*
*      es_mdf_ide-CMdf             = ls_active-docnum9.
*      es_mdf_ide-CDv              = ls_active-cdv.
*
*    ENDIF.

*    es_mdf_ide-CMdf = zcltm_mdf_events=>ramdom_num_create( ).
*    es_mdf_ide-CDv  = 0.

  ENDMETHOD.


  METHOD save_complemento.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Prepara informações IDE
* ---------------------------------------------------------------------------
    CLEAR es_mdf_ide.
    es_mdf_ide-id                       = is_mdf_ide-id.
    es_mdf_ide-c_uf                     = is_mdf_ide-uf.
    es_mdf_ide-tp_amb                   = is_mdf_ide-tpamb.
    es_mdf_ide-tp_emit                  = is_mdf_ide-tpemit.
    es_mdf_ide-tp_transp                = is_mdf_ide-tptransp.
    es_mdf_ide-mod                      = is_mdf_ide-mod.
    es_mdf_ide-c_mdf                    = is_mdf_ide-cmdf.
    es_mdf_ide-c_dv                     = is_mdf_ide-cdv.
    es_mdf_ide-modal                    = is_mdf_ide-modal.
    es_mdf_ide-dh_emi                   = is_mdf_ide-dhemi.
    es_mdf_ide-tp_emis                  = is_mdf_ide-tpemis.

    IF es_mdf_ide-created_by IS INITIAL.
      es_mdf_ide-created_by               = sy-uname.
      GET TIME STAMP FIELD es_mdf_ide-created_at.
      es_mdf_ide-last_changed_by          = es_mdf_ide-created_by.
      es_mdf_ide-last_changed_at          = es_mdf_ide-created_at.
      es_mdf_ide-local_last_changed_at    = es_mdf_ide-created_at.
    ELSE.
      es_mdf_ide-last_changed_by          = sy-uname.
      GET TIME STAMP FIELD es_mdf_ide-last_changed_at.
      es_mdf_ide-local_last_changed_at    = es_mdf_ide-last_changed_at.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva informações IDE
* ---------------------------------------------------------------------------
    IF iv_save EQ abap_true.
      MODIFY zttm_mdf_ide FROM es_mdf_ide.

      IF sy-subrc NE 0.
        " Falha ao salvar as informações IDE.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '001' ) ).
        me->format_message( CHANGING ct_return = et_return[] ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_carregamento.

    FREE: et_return.

    IF it_carregamento IS INITIAL.
      " Nenhum município de carregamento encontrado.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-carregamento field = 'TAXJURCODE' type = 'E' id = 'ZTM_MONITOR_MDF' number = '046' ) ).
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD validate_descarregamento.

    FREE: et_return.

    IF it_descarregamento IS INITIAL.
      " Nenhum município de descarregamento encontrado.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-descarregamento field = 'TAXJURCODE' type = 'E' id = 'ZTM_MONITOR_MDF' number = '045' ) ).
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD validate_placa.

    FREE: et_return.

    DATA(lt_placa) = it_placa[].
    DELETE lt_placa WHERE reboque EQ abap_true.          "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Validar se a placa está em uso
* ---------------------------------------------------------------------------
    IF iv_send  IS NOT INITIAL
   AND it_placa IS NOT INITIAL.

      SELECT DISTINCT agrupador,
                      placa
        FROM zi_tm_mdf_criados
         FOR ALL ENTRIES IN @it_placa
       WHERE placa      EQ @it_placa-placa
         AND statuscode EQ '100' " Autorizado o uso da NF-e
        INTO TABLE @DATA(lt_placa_uso).

      IF sy-subrc IS INITIAL.
        et_return = VALUE #( FOR ls_placa_uso IN lt_placa_uso ( parameter  = gc_cds-placa
                                                                field      = 'PLACA'
                                                                type       = 'E'
                                                                id         = 'ZTM_MONITOR_MDF'
                                                                number     = '114'
                                                                message_v1 = ls_placa_uso-placa
                                                                message_v2 = ls_placa_uso-agrupador ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recuperar lista de placas
* ---------------------------------------------------------------------------
    IF it_placa[] IS NOT INITIAL.

      SELECT equipamento
        FROM zi_tm_vh_equnr
         FOR ALL ENTRIES IN @it_placa
       WHERE equipamento = @it_placa-placa
        INTO TABLE @DATA(lt_equipamento).

      IF sy-subrc EQ 0.
        SORT lt_equipamento BY equipamento.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Validação de campos
* ---------------------------------------------------------------------------
    IF lines( lt_placa ) > 1.
      " Não é possível marcar mais de uma placa com 'Não' Reboque.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'REBOQUE' type = 'E' id = 'ZTM_MONITOR_MDF' number = '043' ) ).
    ENDIF.

    LOOP AT it_placa INTO DATA(ls_placa).          "#EC CI_LOOP_INTO_WA

      IF ls_placa-placa IS INITIAL.
        " Favor corrigir campo 'Placa' em branco
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'PLACA' type = 'E' id = 'ZTM_MONITOR_MDF' number = '049') ).
      ENDIF.

      IF NOT line_exists( lt_equipamento[ equipamento = ls_placa-placa ] ). "#EC CI_STDSEQ
        " Favor corrigir campo 'Placa'. Placa '&1' não é válida.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'PLACA' type = 'E' id = 'ZTM_MONITOR_MDF' number = '050' message_v1 = ls_placa-placa ) ).
      ENDIF.

*      IF ls_placa-Renavam IS INITIAL.
*        " Favor preencher campo de transporte 'CT-e RENAVAM' da placa &1.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'RENAVAM' type = 'E' id = 'ZTM_MONITOR_MDF' number = '051' message_v1 = ls_placa-Placa ) ).
*      ENDIF.

*      IF ls_placa-Tara IS INITIAL.
*        " Favor preencher campo de transporte 'Tara em KG' da placa &1.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'TARA' type = 'E' id = 'ZTM_MONITOR_MDF' number = '052' message_v1 = ls_placa-Placa ) ).
*      ENDIF.
*
*      IF ls_placa-CapKg IS INITIAL.
*        " Favor preencher campo de transporte 'Capacidade em KG' da placa &1.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'CAPKG' type = 'E' id = 'ZTM_MONITOR_MDF' number = '053' message_v1 = ls_placa-Placa ) ).
*      ENDIF.
*
*      IF ls_placa-CapM3 IS INITIAL.
*        " Favor preencher campo de transporte 'Capacidade em M3' da placa &1.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'CAPM3' type = 'E' id = 'ZTM_MONITOR_MDF' number = '054' message_v1 = ls_placa-Placa ) ).
*      ENDIF.

      IF ls_placa-tprod IS INITIAL.
        " Favor preencher campo de transporte 'Meio de transporte' da placa &1.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'TPROD' type = 'E' id = 'ZTM_MONITOR_MDF' number = '055' message_v1 = ls_placa-placa ) ).
      ENDIF.

*      IF ls_placa-TpCar IS INITIAL.
*        " Favor preencher campo de transporte 'Tipo do reboque' da placa &1.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'TPCAR' type = 'E' id = 'ZTM_MONITOR_MDF' number = '056' message_v1 = ls_placa-Placa ) ).
*      ENDIF.

      IF ls_placa-uf IS INITIAL.
        " Favor preencher campo de transporte 'Região' da placa &1.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'UF' type = 'E' id = 'ZTM_MONITOR_MDF' number = '057' message_v1 = ls_placa-placa ) ).
      ENDIF.

    ENDLOOP.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD save_placa.

    DATA: ls_placa TYPE zttm_mdf_placa.

    FREE: et_return, et_mdf_placa.

* ---------------------------------------------------------------------------
* Prepara placa
* ---------------------------------------------------------------------------
    LOOP AT it_placa INTO DATA(ls_cds_placa).      "#EC CI_LOOP_INTO_WA

      CLEAR ls_placa.
      ls_placa-id                       = ls_cds_placa-id.
      ls_placa-placa                    = ls_cds_placa-placa.
      ls_placa-reboque                  = ls_cds_placa-reboque.
      ls_placa-ativo                    = ls_cds_placa-ativo.
      ls_placa-proprietario             = ls_cds_placa-proprietario.
      ls_placa-cpf                      = ls_cds_placa-cpf.
      ls_placa-cnpj                     = ls_cds_placa-cnpj.
      ls_placa-rntrc                    = ls_cds_placa-rntrc.
      ls_placa-x_nome                   = ls_cds_placa-nome.
      ls_placa-ie                       = ls_cds_placa-ie.
      ls_placa-uf_prop                  = ls_cds_placa-ufprop.
      ls_placa-tp_prop                  = ls_cds_placa-tpprop.

      IF ls_placa-created_by IS INITIAL.
        ls_placa-created_by               = sy-uname.
        GET TIME STAMP FIELD ls_placa-created_at.
        ls_placa-last_changed_by          = ls_placa-created_by.
        ls_placa-last_changed_at          = ls_placa-created_at.
        ls_placa-local_last_changed_at    = ls_placa-created_at.
      ELSE.
        ls_placa-last_changed_by          = sy-uname.
        GET TIME STAMP FIELD ls_placa-last_changed_at.
        ls_placa-local_last_changed_at    = ls_placa-last_changed_at.
      ENDIF.

      APPEND ls_placa TO et_mdf_placa[].

    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva municípios de placa
* ---------------------------------------------------------------------------
    IF et_mdf_placa[] IS NOT INITIAL AND iv_save EQ abap_true.

      MODIFY zttm_mdf_placa FROM TABLE et_mdf_placa[].

      IF sy-subrc NE 0.
        " Falha ao salvar as placas.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '060' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD save_placa_condutor.

    FREE: et_return, et_mdf_placa_c.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Prepara placa
* ---------------------------------------------------------------------------
    et_mdf_placa_c[] = VALUE #( FOR ls_cds_condutor IN it_condutor (
                                id                    = ls_cds_condutor-id
                                placa                 = ls_cds_condutor-placa
                                condutor              = ls_cds_condutor-condutor
                                cpf                   = ls_cds_condutor-cpf
                                x_nome                = ls_cds_condutor-nome
                                created_by            = COND #( WHEN ls_cds_condutor-createdby IS INITIAL
                                                                THEN sy-uname
                                                                ELSE ls_cds_condutor-createdby )
                                created_at            = COND #( WHEN ls_cds_condutor-createdby IS INITIAL
                                                                THEN lv_timestamp
                                                                ELSE ls_cds_condutor-createdat )
                                last_changed_by       = sy-uname
                                last_changed_at       = lv_timestamp
                                local_last_changed_at = lv_timestamp ) ).

* ---------------------------------------------------------------------------
* Salva condutor
* ---------------------------------------------------------------------------
    IF et_mdf_placa_c[] IS NOT INITIAL AND iv_save EQ abap_true.

      MODIFY zttm_mdf_placa_c FROM TABLE et_mdf_placa_c[].

      IF sy-subrc NE 0.
        " Falha ao salvar as placas x condutores.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '081' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD save_placa_vale_pedagio.

    FREE: et_return.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Prepara placa
* ---------------------------------------------------------------------------
    et_mdf_placa_v[] = VALUE #( FOR ls_cds_vale IN it_vale_pedagio (
                                id                    = ls_cds_vale-id
                                placa                 = ls_cds_vale-placa
                                n_compra              = ls_cds_vale-ncompra
                                fornecedor            = ls_cds_vale-fornecedor
                                cnpjforn              = ls_cds_vale-cnpjforn
                                cnpjpg                = ls_cds_vale-cnpjpgtext
                                pagador               = ls_cds_vale-pagador
                                cpfpg                 = ls_cds_vale-cpfpg
                                v_vale_ped            = ls_cds_vale-valorvaleped
                                created_by            = COND #( WHEN ls_cds_vale-createdby IS INITIAL
                                                                THEN sy-uname
                                                                ELSE ls_cds_vale-createdby )
                                created_at            = COND #( WHEN ls_cds_vale-createdby IS INITIAL
                                                                THEN lv_timestamp
                                                                ELSE ls_cds_vale-createdat )
                                last_changed_by       = sy-uname
                                last_changed_at       = lv_timestamp
                                local_last_changed_at = lv_timestamp ) ).

* ---------------------------------------------------------------------------
* Salva condutor
* ---------------------------------------------------------------------------
    IF et_mdf_placa_v[] IS NOT INITIAL AND iv_save EQ abap_true.

      MODIFY zttm_mdf_placa_v FROM TABLE et_mdf_placa_v[].

      IF sy-subrc NE 0.
        " Falha ao salvar as placas x vale pedágio.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '082' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD validate_proprietario.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica se dados foram preenchidos
* ---------------------------------------------------------------------------
    IF is_placa-ativo IS NOT INITIAL AND is_placa-proprietario IS  INITIAL.
      " Favor informar parceiro.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'PROPRIETARIO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '041' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Fornecedor
* ---------------------------------------------------------------------------
    IF is_placa-proprietario IS NOT INITIAL.

      SELECT COUNT(*)
        FROM zi_ca_vh_partner
        WHERE parceiro = @is_placa-proprietario.     "#EC CI_SEL_NESTED

      IF sy-subrc NE 0.
        " O Parceiro informado não existe.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'PROPRIETARIO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '015' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida campo CPF
* ---------------------------------------------------------------------------
    IF is_placa-cpf IS NOT INITIAL.

      DATA(lv_cpf) = CONV string( is_placa-cpf ).

      FIND REGEX '[^0-9]' IN lv_cpf.

      IF sy-subrc EQ 0.
        " Informar apenas números no campo &1
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'CPF' type = 'E' id = 'ZTM_MONITOR_MDF' number = '007' message_v1 = 'CPF' ) ).
      ENDIF.

      IF strlen( lv_cpf ) NE 11.
        " Insira um código com tamanho máximo de &1 caracteres
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'CPF' type = 'E' id = 'ZTM_MONITOR_MDF' number = '008' message_v1 = '11' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida campo CNPJ
* ---------------------------------------------------------------------------
    IF is_placa-cnpj IS NOT INITIAL.

      DATA(lv_cnpj) = CONV string( is_placa-cnpj ).

      FIND REGEX '[^0-9]' IN lv_cnpj.

      IF sy-subrc EQ 0.
        " Informar apenas números no campo &1
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'CNPJ' type = 'E' id = 'ZTM_MONITOR_MDF' number = '007' message_v1 = 'CNPJ' ) ).
      ENDIF.

      IF strlen( lv_cnpj ) NE 14.
        " Insira um código com tamanho máximo de &1 caracteres
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'CNPJ' type = 'E' id = 'ZTM_MONITOR_MDF' number = '008' message_v1 = '14' ) ).
      ENDIF.
    ENDIF.

    IF is_placa-ativo IS INITIAL AND is_placa-proprietario IS NOT INITIAL.
      " Favor marcar antes de cadastrar proprietário diferente.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-placa field = 'ATIVO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '017' ) ).
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD determine_placa.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera placa
* ---------------------------------------------------------------------------
    IF cs_placa-placa IS NOT INITIAL.

      SELECT SINGLE *
          FROM zi_tm_vh_equnr
          WHERE equipamento = @cs_placa-placa
          INTO @DATA(ls_placa).

      IF sy-subrc NE 0.
        CLEAR ls_placa.
      ENDIF.
    ENDIF.

    cs_placa-categoriaequip = ls_placa-categoriaequip.
    cs_placa-tipoequip      = ls_placa-tipoequip.
    cs_placa-renavam        = ls_placa-renavam.
    cs_placa-tara           = ls_placa-tara.
    cs_placa-capkg          = ls_placa-capkg.
    cs_placa-capm3          = ls_placa-capm3.
    cs_placa-tprod          = ls_placa-tprod.
    cs_placa-tpcar          = ls_placa-tpcar.
    cs_placa-uf             = ls_placa-uf.

* ---------------------------------------------------------------------------
* Recupera Proprietário
* ---------------------------------------------------------------------------
    IF cs_placa-proprietario IS NOT INITIAL.

      SELECT SINGLE *
        FROM zi_ca_vh_partner
        WHERE parceiro = @cs_placa-proprietario
        INTO @DATA(ls_proprietario).

      IF sy-subrc EQ 0.
        cs_placa-cnpj = ls_proprietario-cnpj.
        cs_placa-cpf  = ls_proprietario-cpf.
        cs_placa-nome = ls_proprietario-nome.
        cs_placa-ie   = ls_proprietario-inscricaoestadual.
      ENDIF.
    ENDIF.

    IF cs_placa-ativo IS INITIAL AND cs_placa-proprietario IS INITIAL.
      cs_placa-cnpj     = space.
      cs_placa-cpf      = space.
      cs_placa-nome     = space.
      cs_placa-ie       = space.
      cs_placa-tpprop   = space.
      cs_placa-rntrc    = space.
      cs_placa-ufprop   = space.
    ENDIF.

  ENDMETHOD.


  METHOD determine_placa_from_fo.

    FREE: et_placa, et_return.

    DATA(lt_municipio) = it_municipio[].
    SORT lt_municipio BY freightorder.
    DELETE lt_municipio WHERE freightorder IS INITIAL.
    DELETE ADJACENT DUPLICATES FROM lt_municipio COMPARING freightorder.

* ---------------------------------------------------------------------------
* Recupera placa
* ---------------------------------------------------------------------------
    IF lt_municipio IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_ordem_frete_placa
          FOR ALL ENTRIES IN @lt_municipio
          WHERE freightorder = @lt_municipio-freightorder
          INTO TABLE @DATA(lt_platenumber).

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

    TRY.
        DATA(ls_municipio) = lt_municipio[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera a primeira placa de caminhão (só pode existir um )
* ---------------------------------------------------------------------------
    DATA(lt_caminhao) = lt_platenumber.
    DELETE lt_caminhao WHERE placacaminhao IS INITIAL.

    TRY.
        DATA(ls_caminhao) = lt_caminhao[ 1 ].
        et_placa = VALUE #( BASE et_placa (
                            id    = ls_municipio-guid
                            placa = ls_caminhao-placacaminhao ) ).
      CATCH cx_root.
    ENDTRY.

    IF lines( lt_caminhao ) > 1.
      " Mais de uma placa encontrada para as Ordens de Frete informadas.
      et_return[] = VALUE #( BASE et_return ( type = 'W' id = 'ZTM_MONITOR_MDF' number = '106' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera as placas de reboque
* ---------------------------------------------------------------------------
    DATA(lt_reboque) = lt_platenumber.
    DELETE lt_reboque WHERE placareboque IS INITIAL.

    et_placa = VALUE #( BASE et_placa FOR ls_reboque IN lt_reboque (
                        id      = ls_municipio-guid
                        placa   = ls_reboque-placareboque
                        reboque = abap_true ) ).

* ---------------------------------------------------------------------------
* Atualiza dados de placa
* ---------------------------------------------------------------------------
    LOOP AT et_placa REFERENCE INTO DATA(ls_placa).
      me->determine_placa( CHANGING cs_placa  = ls_placa->* ).
    ENDLOOP.

  ENDMETHOD.


  METHOD determine_placa_from_acckey.

    FREE: et_placa, et_return.

* ---------------------------------------------------------------------------
* Recupera placas
* ---------------------------------------------------------------------------
    IF it_access_key IS NOT INITIAL.

      SELECT accesskey, docnum, placa
         FROM zi_tm_mdf_motorista_change  " Aplicativo NF-e Update
         FOR ALL ENTRIES IN @it_access_key
         WHERE accesskey = @it_access_key-table_line
         INTO TABLE @DATA(lt_update).

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

    SORT lt_update BY placa.
    DELETE ADJACENT DUPLICATES FROM lt_update COMPARING placa.
    DELETE lt_update WHERE placa IS INITIAL.

    IF lines( lt_update ) > 1.
      " Mais de uma placa encontrada para as Ordens de Frete informadas.
      et_return[] = VALUE #( BASE et_return ( type = 'W' id = 'ZTM_MONITOR_MDF' number = '106' ) ).
    ENDIF.

    TRY.
        DATA(ls_update) = lt_update[ 1 ].
        et_placa = VALUE #( BASE et_placa (
                            id    = is_mdf-guid
                            placa = ls_update-placa ) ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD determine_moto_from_acckey.

    FREE: es_motorista, et_return.

* ---------------------------------------------------------------------------
* Recupera placas
* ---------------------------------------------------------------------------
    IF it_access_key IS NOT INITIAL.

      SELECT accesskey, docnum, motorista
         FROM zi_tm_mdf_motorista_change  " Aplicativo NF-e Update
         FOR ALL ENTRIES IN @it_access_key
         WHERE accesskey = @it_access_key-table_line
         INTO TABLE @DATA(lt_update).

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

    SORT lt_update BY motorista.
    DELETE ADJACENT DUPLICATES FROM lt_update COMPARING motorista.
    DELETE lt_update WHERE motorista IS INITIAL.

    TRY.
        DATA(ls_update) = lt_update[ 1 ].
        es_motorista = VALUE #( id    = is_mdf-guid
                                motorista = ls_update-motorista ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD validate_vale_pedagio.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Valida Fornecedor
* ---------------------------------------------------------------------------
    IF is_vale-fornecedor IS NOT INITIAL.

      SELECT COUNT(*)
        FROM zi_ca_vh_partner_pj
        WHERE parceiro = @is_vale-fornecedor.

      IF sy-subrc NE 0.
        " O Parceiro informado não existe ou não possui CNPJ.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'FORNECEDOR' type = 'E' id = 'ZTM_MONITOR_MDF' number = '016' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Pagador
* ---------------------------------------------------------------------------
    IF is_vale-pagador IS NOT INITIAL.

      SELECT COUNT(*)
        FROM zi_ca_vh_partner
        WHERE parceiro = @is_vale-pagador.

      IF sy-subrc NE 0.
        " O Parceiro informado não existe.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'PAGADOR' type = 'E' id = 'ZTM_MONITOR_MDF' number = '015' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida campo CNPJ Fornecedor
* ---------------------------------------------------------------------------
    IF is_vale-cnpjforn IS NOT INITIAL.

      DATA(lv_cnpjforn) = CONV string( is_vale-cnpjforn ).

      FIND REGEX '[^0-9]' IN lv_cnpjforn.

      IF sy-subrc EQ 0.
        " Informar apenas números no campo &1
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'CNPJFORN' type = 'E' id = 'ZTM_MONITOR_MDF' number = '007' message_v1 = gc_text-cnpj_pagador  ) ).
      ENDIF.

      IF strlen( lv_cnpjforn ) NE 14.
        " Insira um código com tamanho máximo de &1 caracteres
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'CNPJFORN' type = 'E' id = 'ZTM_MONITOR_MDF' number = '008' message_v1 = '14' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida campo CPF Pagador
* ---------------------------------------------------------------------------
    IF is_vale-cpfpg IS NOT INITIAL.

      DATA(lv_cpfpg) = CONV string( is_vale-cpfpg ).

      FIND REGEX '[^0-9]' IN lv_cpfpg.

      IF sy-subrc EQ 0.
        " Informar apenas números no campo &1
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'CPFPG' type = 'E' id = 'ZTM_MONITOR_MDF' number = '007' message_v1 = gc_text-cpf_pagador ) ).
      ENDIF.

      IF strlen( lv_cpfpg ) NE 11.
        " Insira um código com tamanho máximo de &1 caracteres
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'CPFPG' type = 'E' id = 'ZTM_MONITOR_MDF' number = '008' message_v1 = '11' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida campo CNPJ Pagador
* ---------------------------------------------------------------------------
    IF is_vale-cnpjpg IS NOT INITIAL.

      DATA(lv_cnpjpg) = CONV string( is_vale-cnpjpg ).

      FIND REGEX '[^0-9]' IN lv_cnpjpg.

      IF sy-subrc EQ 0.
        " Informar apenas números no campo &1
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'CNPJPG' type = 'E' id = 'ZTM_MONITOR_MDF' number = '007' message_v1 = gc_text-cnpj_pagador ) ).
      ENDIF.

      IF strlen( lv_cnpjpg ) NE 14.
        " Insira um código com tamanho máximo de &1 caracteres
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-valepedagio field = 'CNPJPG' type = 'E' id = 'ZTM_MONITOR_MDF' number = '008' message_v1 = '14' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD determine_vale_pedagio.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera Fornecedor
* ---------------------------------------------------------------------------
    IF cs_vale-fornecedor IS NOT INITIAL.

      SELECT SINGLE parceiro, cnpj, cpf
        FROM zi_ca_vh_partner
        WHERE parceiro = @cs_vale-fornecedor
        INTO @DATA(ls_fornecedor).

      IF sy-subrc EQ 0.
        cs_vale-cnpjforn = ls_fornecedor-cnpj.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Pagador
* ---------------------------------------------------------------------------
    IF cs_vale-pagador IS NOT INITIAL.

      SELECT SINGLE *
        FROM zi_ca_vh_partner
        WHERE parceiro = @cs_vale-pagador
        INTO @DATA(ls_pagador).

      IF sy-subrc EQ 0.
        cs_vale-cnpjpg = ls_pagador-cnpj.
        cs_vale-cpfpg  = ls_pagador-cpf.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD determine_municipio.


    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    me->determine_municipio_info( EXPORTING it_municipio = ct_municipio
                                  IMPORTING et_municipio = DATA(lt_municipio_new) ).

* ---------------------------------------------------------------------------
* Atualiza informações
* ---------------------------------------------------------------------------
    LOOP AT ct_municipio REFERENCE INTO DATA(ls_municipio).

      READ TABLE lt_municipio_new INTO DATA(ls_mun_new) BINARY SEARCH
                                                        WITH KEY Guid        = ls_municipio->guid
                                                                 AccessKey   = ls_municipio->AccessKey
                                                                 OrdemFrete  = ls_municipio->OrdemFrete.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      ls_municipio->NfExtrn                     = ls_mun_new-NfExtrn.
      ls_municipio->NfExtrnCriticality          = ls_mun_new-NfExtrnCriticality.
      ls_municipio->BR_NFTotalAmount            = ls_mun_new-BR_NFTotalAmount.
      ls_municipio->SalesDocumentCurrency       = ls_mun_new-SalesDocumentCurrency.
      ls_municipio->HeaderWeightUnit            = ls_mun_new-HeaderWeightUnit.
      ls_municipio->HeaderWeightUnitCriticality = ls_mun_new-HeaderWeightUnitCriticality.
      ls_municipio->HeaderGrossWeight           = ls_mun_new-HeaderGrossWeight.
      ls_municipio->HeaderNetWeight             = ls_mun_new-HeaderNetWeight.

*      ls_municipio->accesskey = ls_mun_new-accesskey.
*      ls_municipio->manual    = ls_mun_new-manual.
*
*      ls_municipio->carga      = COND #( WHEN ls_municipio->carga IS NOT INITIAL
*                                         THEN ls_municipio->carga
*                                         ELSE ls_mun_new-carga ).
*
*      ls_municipio->descarga   = COND #( WHEN ls_municipio->descarga IS NOT INITIAL
*                                         THEN ls_municipio->descarga
*                                         ELSE ls_mun_new-descarga ).

    ENDLOOP.

  ENDMETHOD.


  METHOD determine_municipio_info.

    IF it_municipio IS NOT INITIAL.

      SELECT *
          FROM zi_tm_mdf_municipio
          FOR ALL ENTRIES IN @it_municipio
          WHERE Guid       EQ @it_municipio-Guid
            AND AccessKey  EQ @it_municipio-AccessKey
            AND OrdemFrete EQ @it_municipio-OrdemFrete
            INTO TABLE @et_municipio.
      IF sy-subrc EQ 0.
        SORT et_municipio BY Guid AccessKey OrdemFrete.
      ENDIF.
    ENDIF.

*    FREE et_municipio.
*
*    DATA(lt_acckey) = VALUE j_1b_nfe_access_key_tab( FOR ls_mun IN it_municipio (
*                                                     regio      =  ls_mun-AccessKey+0(2)
*                                                     nfyear     =  ls_mun-AccessKey+2(2)
*                                                     nfmonth    =  ls_mun-AccessKey+4(2)
*                                                     stcd1      =  ls_mun-AccessKey+6(14)
*                                                     model      =  ls_mun-AccessKey+20(2)
*                                                     serie      =  ls_mun-AccessKey+22(3)
*                                                     nfnum9     =  ls_mun-AccessKey+25(9)
*                                                     docnum9    =  ls_mun-AccessKey+34(9)
*                                                     cdv        =  ls_mun-AccessKey+43(1) ) ).
*    SORT lt_acckey BY table_line.
*    DELETE ADJACENT DUPLICATES FROM lt_acckey COMPARING table_line.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    IF lt_acckey[] IS NOT INITIAL.
*
*      SELECT doc~docnum,
*             doc~direct,
*             doc~txjcd,
*             doc~manual,
*             doc~branch,
*             active~docsta,
*             active~regio,
*             active~nfyear,
*             active~nfmonth,
*             active~stcd1,
*             active~model,
*             active~serie,
*             active~nfnum9,
*             active~docnum9,
*             active~cdv
*          FROM j_1bnfe_active AS active
*          INNER JOIN j_1bnfdoc AS doc
*          ON doc~docnum = active~docnum
*          INTO TABLE @DATA(lt_active)
*          FOR ALL ENTRIES IN @lt_acckey
*          WHERE active~regio   EQ @lt_acckey-regio
*            AND active~nfyear  EQ @lt_acckey-nfyear
*            AND active~nfmonth EQ @lt_acckey-nfmonth
*            AND active~stcd1   EQ @lt_acckey-stcd1
*            AND active~model   EQ @lt_acckey-model
*            AND active~serie   EQ @lt_acckey-serie
*            AND active~nfnum9  EQ @lt_acckey-nfnum9
*            AND active~docnum9 EQ @lt_acckey-docnum9
*            AND active~cdv     EQ @lt_acckey-cdv.
*
*      IF sy-subrc EQ 0.
*        SORT lt_active BY regio nfyear nfmonth stcd1 model serie nfnum9 docnum9 cdv.
*      ENDIF.
*    ENDIF.
*
*    IF lt_active IS NOT INITIAL.
*
*      SELECT BR_NotaFiscal, FreightOrder
*          FROM zi_tm_vh_mdf_nf_of
*          FOR ALL ENTRIES IN @lt_active
*          WHERE BR_NotaFiscal = @lt_active-docnum
*            AND BR_NotaFiscal IS NOT INITIAL
*          INTO TABLE @DATA(lt_nf_of).
*
*      IF sy-subrc EQ 0.
*        SORT lt_nf_of BY BR_NotaFiscal.
*      ENDIF.
*
*      SELECT werks,
*             txjcd,
*             j_1bbranch AS branch
*        FROM t001w
*        INTO TABLE @DATA(lt_t001w)
*        FOR ALL ENTRIES IN @lt_active
*        WHERE j_1bbranch EQ @lt_active-branch.
*
*      IF sy-subrc EQ 0.
*        SORT lt_t001w BY branch.
*      ENDIF.
*    ENDIF.
*
** ---------------------------------------------------------------------------
** Atualiza informações
** ---------------------------------------------------------------------------
*    LOOP AT it_municipio INTO DATA(ls_municipio).  "#EC CI_LOOP_INTO_WA
*
*      TRY.
*          DATA(ls_active) = lt_active[ regio      =  ls_municipio-AccessKey+0(2)
*                                       nfyear     =  ls_municipio-AccessKey+2(2)
*                                       nfmonth    =  ls_municipio-AccessKey+4(2)
*                                       stcd1      =  ls_municipio-AccessKey+6(14)
*                                       model      =  ls_municipio-AccessKey+20(2)
*                                       serie      =  ls_municipio-AccessKey+22(3)
*                                       nfnum9     =  ls_municipio-AccessKey+25(9)
*                                       docnum9    =  ls_municipio-AccessKey+34(9)
*                                       cdv        =  ls_municipio-AccessKey+43(1) ]. "#EC CI_STDSEQ
*        CATCH cx_root.
*          CONTINUE.
*      ENDTRY.
*
*      TRY.
*          DATA(ls_t001w) = lt_t001w[ branch = ls_active-branch ]. "#EC CI_STDSEQ
*        CATCH cx_root.
*          CONTINUE.
*      ENDTRY.
*
*      TRY.
*          ls_municipio-FreightOrder = lt_nf_of[ BR_NotaFiscal = ls_active-docnum ]-FreightOrder.
*        CATCH cx_root.
*      ENDTRY.
*
*      ls_municipio-Manual        = ls_active-manual.
*      ls_municipio-BR_NotaFiscal = ls_active-docnum.
*
*      ls_municipio-Carga     = COND #( WHEN ls_active-direct = gc_direct-entrada
*                                       THEN ls_active-txjcd
*                                       ELSE ls_t001w-txjcd ).
*
*      ls_municipio-Descarga  = COND #( WHEN ls_active-direct = gc_direct-entrada
*                                    THEN ls_t001w-txjcd
*                                    ELSE ls_active-txjcd ).
*
*      APPEND ls_municipio TO et_municipio[].
*
*    ENDLOOP.
*
*    SORT et_municipio BY Guid BR_NotaFiscal FreightOrder.

  ENDMETHOD.


  METHOD validate_municipio.

    FREE: et_municipio_ok, et_return.

* ---------------------------------------------------------------------------
* Verifica NF informada é utilizada me outroa agrupamento
* ---------------------------------------------------------------------------
    IF it_municipio[] IS NOT INITIAL.

      SELECT mun~guid,
             mun~accesskey,
             mun~br_notafiscal,
             mun~docstatus,
             mdf~agrupador
        FROM zi_tm_mdf_municipio AS mun
        INNER JOIN zi_tm_mdf AS mdf
          ON mdf~guid = mun~guid
        FOR ALL ENTRIES IN @it_municipio
        WHERE mun~guid      EQ @it_municipio-guid
          AND mun~accesskey EQ @it_municipio-accesskey
        INTO TABLE @DATA(lt_doc).

      IF sy-subrc EQ 0.
        SORT lt_doc BY accesskey.
      ENDIF.

      SELECT mun~guid,
             mun~accesskey,
             mun~br_notafiscal,
             mun~docstatus,
             mdf~agrupador,
             mdf~statuscode
        FROM zi_tm_mdf_municipio AS mun
        INNER JOIN zi_tm_mdf AS mdf
          ON mdf~guid = mun~guid
        FOR ALL ENTRIES IN @it_municipio
        WHERE mun~guid        NE @it_municipio-guid
          AND mun~accesskey   EQ @it_municipio-accesskey
          AND mdf~statuscode  NE @gc_status-encerrado
          AND mdf~statuscode  NE @gc_status-cancelado
        INTO TABLE @DATA(lt_doc_new).

      IF sy-subrc EQ 0.
        SORT lt_doc_new BY accesskey.
      ENDIF.

      SELECT DISTINCT msehi, msehl
        FROM zi_tm_vh_mdf_nf_ext_um
        FOR ALL ENTRIES IN @it_municipio
        WHERE msehi = @it_municipio-HeaderWeightUnit
        INTO TABLE @DATA(lt_unid).

      IF sy-subrc EQ 0.
        SORT lt_unid BY msehi.
      ENDIF.
    ENDIF.

** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    me->determine_municipio_info( EXPORTING it_municipio = it_municipio
*                                  IMPORTING et_municipio = DATA(lt_municipio_new) ).

* ---------------------------------------------------------------------------
* Valida campos
* ---------------------------------------------------------------------------
    LOOP AT it_municipio INTO DATA(ls_municipio).  "#EC CI_LOOP_INTO_WA

      READ TABLE lt_doc_new INTO DATA(ls_doc) BINARY SEARCH WITH KEY accesskey = ls_municipio-accesskey.

      IF sy-subrc EQ 0.
        " Chave de acesso &1 faz parte do agrupamento &2.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'BR_NOTAFISCAL' type = 'E' id = 'ZTM_MONITOR_MDF' number = '066'
                                                message_v1 = |{ ls_municipio-accesskey ALPHA = OUT }|
                                                message_v2 = |{ ls_doc-agrupador ALPHA = OUT }| ) ).
        CONTINUE.
      ENDIF.

      IF ls_municipio-br_notafiscal IS NOT INITIAL.

        CASE ls_municipio-docstatus.

          WHEN gc_docsta-inicial.
            " Nota Fiscal &1 ainda não autorizada.
            et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'BR_NOTAFISCAL' type = 'E' id = 'ZTM_MONITOR_MDF' number = '076'
                                                    message_v1 = |{ ls_municipio-br_notafiscal ALPHA = OUT }| ) ).
            CONTINUE.

          WHEN gc_docsta-recusado.
            " Nota Fiscal &1 é um documento recusado.
            et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'BR_NOTAFISCAL' type = 'E' id = 'ZTM_MONITOR_MDF' number = '074'
                                                    message_v1 = |{ ls_municipio-br_notafiscal ALPHA = OUT }| ) ).
            CONTINUE.

          WHEN gc_docsta-rejeitado.
            " Nota Fiscal &1 é um documento rejeitado.
            et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'BR_NOTAFISCAL' type = 'E' id = 'ZTM_MONITOR_MDF' number = '075'
                                                    message_v1 = |{ ls_municipio-br_notafiscal ALPHA = OUT }| ) ).
            CONTINUE.

        ENDCASE.

      ENDIF.

      " Validação para NF Externa
      IF ls_municipio-NfExtrn IS NOT INITIAL.

        IF ls_municipio-BR_NFTotalAmount IS INITIAL.
          " Favor informar o valor da carga para Nota Fiscal externa &1
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'BR_NFTOTALAMOUNT' type = 'E' id = 'ZTM_MONITOR_MDF' number = '115'
                                                  message_v1 = |{ ls_municipio-AccessKey ALPHA = OUT }| ) ).
        ENDIF.

        IF ls_municipio-HeaderGrossWeight IS INITIAL.
          " Favor informar a quantidade da carga para Nota Fiscal externa &1
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'HEADERGROSSWEIGHT' type = 'E' id = 'ZTM_MONITOR_MDF' number = '116'
                                                  message_v1 = |{ ls_municipio-AccessKey ALPHA = OUT }| ) ).
        ENDIF.

        IF ls_municipio-HeaderWeightUnit IS INITIAL.
          " Favor informar a quantidade da carga para Nota Fiscal externa &1
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'HEADERWEIGHTUNIT' type = 'E' id = 'ZTM_MONITOR_MDF' number = '117'
                                                  message_v1 = |{ ls_municipio-AccessKey ALPHA = OUT }| ) ).
        ENDIF.

        IF NOT line_exists( lt_unid[ msehi = ls_municipio-HeaderWeightUnit ] ).
          " Unidade de medida &1 não é válida.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'HEADERWEIGHTUNIT' type = 'E' id = 'ZTM_MONITOR_MDF' number = '118'
                                                  message_v1 = |{ ls_municipio-HeaderWeightUnit ALPHA = OUT }| ) ).
        ENDIF.

      ENDIF.

      READ TABLE lt_doc TRANSPORTING NO FIELDS BINARY SEARCH WITH KEY accesskey = ls_municipio-accesskey.

      IF sy-subrc NE 0.
        " Adicionando chave de acesso &1.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-municipio field = 'ACCESSKEY' type = 'S' id = 'ZTM_MONITOR_MDF' number = '067'
                                                message_v1 = |{ ls_municipio-accesskey ALPHA = OUT }| ) ).
      ENDIF.

      APPEND ls_municipio TO et_municipio_ok[].
    ENDLOOP.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD save_municipio.

    DATA: ls_mdf_mcd TYPE zttm_mdf_mcd.

    FREE: et_return, et_mdf_mcd.

* ---------------------------------------------------------------------------
* Prepara municípios de carregamento
* ---------------------------------------------------------------------------
    LOOP AT it_municipio INTO DATA(ls_municipio).  "#EC CI_LOOP_INTO_WA

      CLEAR ls_mdf_mcd.
      ls_mdf_mcd-id                         = ls_municipio-guid.
      ls_mdf_mcd-ordem_frete                = ls_municipio-freightorder.
      ls_mdf_mcd-access_key                 = ls_municipio-accesskey.
      ls_mdf_mcd-reentrega                  = ls_municipio-reentrega.
      ls_mdf_mcd-segcodbarra                = ls_municipio-segcodigobarra.

      IF ls_municipio-NfExtrn IS NOT INITIAL.
        ls_mdf_mcd-v_carga                    = ls_municipio-BR_NFTotalAmount.
        ls_mdf_mcd-c_unid                     = ls_municipio-HeaderWeightUnit.
        ls_mdf_mcd-q_carga                    = ls_municipio-HeaderGrossWeight.
      ENDIF.

      ls_mdf_mcd-created_by                 = ls_municipio-createdby.
      ls_mdf_mcd-created_at                 = ls_municipio-createdat.
      ls_mdf_mcd-last_changed_by            = ls_municipio-lastchangedby.
      ls_mdf_mcd-last_changed_at            = ls_municipio-lastchangedat.
      ls_mdf_mcd-local_last_changed_at      = ls_municipio-locallastchangedat.

      IF ls_mdf_mcd-created_by IS INITIAL.
        ls_mdf_mcd-created_by               = sy-uname.
        GET TIME STAMP FIELD ls_mdf_mcd-created_at.
        ls_mdf_mcd-last_changed_by          = ls_mdf_mcd-created_by.
        ls_mdf_mcd-last_changed_at          = ls_mdf_mcd-created_at.
        ls_mdf_mcd-local_last_changed_at    = ls_mdf_mcd-created_at.
      ELSE.
        ls_mdf_mcd-last_changed_by          = sy-uname.
        GET TIME STAMP FIELD ls_mdf_mcd-last_changed_at.
        ls_mdf_mcd-local_last_changed_at    = ls_mdf_mcd-last_changed_at.
      ENDIF.

      APPEND ls_mdf_mcd TO et_mdf_mcd[].

    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva municípios
* ---------------------------------------------------------------------------
    IF it_municipio IS NOT INITIAL AND iv_save EQ abap_true.

      MODIFY zttm_mdf_mcd FROM TABLE et_mdf_mcd[].

      IF sy-subrc NE 0.
        " Falha ao salvar os dados de municípios e notas transportadas.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '009' ) ).
        me->format_message( CHANGING ct_return = et_return[] ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD save_mcd_list.

    TYPES: BEGIN OF ty_nf_of,
             accesskey    TYPE zi_tm_vh_mdf_nf_of-accesskey,
             freightorder TYPE zi_tm_vh_mdf_nf_of-freightorder,
           END OF  ty_nf_of,

           ty_t_nf_of TYPE SORTED TABLE OF ty_nf_of
                        WITH UNIQUE KEY table_line.

    DATA: lt_accesskey     TYPE STANDARD TABLE OF zttm_mdf_mcd-access_key,
          lt_ordem         TYPE STANDARD TABLE OF zttm_mdf_mcd-ordem_frete,
          lt_mcd           TYPE STANDARD TABLE OF zttm_mdf_mcd,
          lt_municipio     TYPE STANDARD TABLE OF zi_tm_mdf_municipio,
          lt_municipio_all TYPE STANDARD TABLE OF zi_tm_mdf_municipio,
          lt_nf_of         TYPE ty_t_nf_of,
          ls_nf_of         TYPE ty_nf_of,
          lt_return        TYPE bapiret2_t.

    FREE: et_return.

    IF iv_accesskey IS INITIAL AND iv_accesskey IS SUPPLIED.
      " Nenhuma nota fiscal informada.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '010' ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
      RETURN.
    ENDIF.

    IF iv_ordens IS INITIAL AND iv_ordens IS SUPPLIED.
      " Nenhuma ordem de frete informada.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '078' ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Notas Fiscais já criadas
* ---------------------------------------------------------------------------
    DATA(lv_id)    = iv_id.

    SELECT *
        FROM zttm_mdf_mcd
        WHERE id = @lv_id
        INTO TABLE @lt_mcd.                   "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      SORT lt_mcd[] BY access_key.
    ENDIF.

    SELECT SINGLE *
        FROM zi_tm_mdf
        WHERE guid = @lv_id
        INTO @DATA(ls_mdf).

    IF sy-subrc NE 0.
      FREE ls_mdf.
    ENDIF.

* ---------------------------------------------------------------------------
* Separa apenas as novas Notas Fiscais
* ---------------------------------------------------------------------------
    IF iv_accesskey IS NOT INITIAL.

      SPLIT iv_accesskey AT ';' INTO TABLE lt_accesskey.

      SELECT accesskey,
             freightorder
        FROM zi_tm_vh_mdf_nf_of
        FOR ALL ENTRIES IN @lt_accesskey
        WHERE accesskey = @lt_accesskey-table_line
        INTO TABLE @lt_nf_of.

      IF sy-subrc NE 0.
        FREE lt_nf_of.
      ENDIF.

      " Insere as chaves de acesso não encontradas
      LOOP AT lt_accesskey REFERENCE INTO DATA(lv_accesskey).

        READ TABLE lt_nf_of TRANSPORTING NO FIELDS WITH KEY accesskey = lv_accesskey->* BINARY SEARCH.
        CHECK sy-subrc NE 0.

        CLEAR ls_nf_of.
        ls_nf_of-accesskey = lv_accesskey->*.
        INSERT ls_nf_of INTO TABLE lt_nf_of[].
      ENDLOOP.

    ENDIF.

* ---------------------------------------------------------------------------
* Separa apenas as novas Chaves de Acesso X Ordens de Frete
* ---------------------------------------------------------------------------
    IF iv_ordens IS NOT INITIAL.

      SPLIT iv_ordens AT ';' INTO TABLE lt_ordem.
      LOOP AT lt_ordem REFERENCE INTO DATA(lv_r_ordem). "#EC CI_LOOP_INTO_WA
        lv_r_ordem->* = |{ lv_r_ordem->* ALPHA = IN }|.
      ENDLOOP.

      SELECT accesskey, freightorder
        FROM zi_tm_vh_mdf_nf_of
        FOR ALL ENTRIES IN @lt_ordem
        WHERE freightorder = @lt_ordem-table_line
          AND accesskey    IS NOT INITIAL
        INTO TABLE @lt_nf_of.

      IF sy-subrc NE 0.
        " Nenhum Nota Fiscal encontrada para Ordem de Frete informada.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '079' ) ).
        RETURN.
      ENDIF.
    ENDIF.

    LOOP AT lt_nf_of INTO ls_nf_of.                "#EC CI_LOOP_INTO_WA

      ls_nf_of-accesskey     = ls_nf_of-accesskey.
      ls_nf_of-freightorder  = COND #( WHEN ls_nf_of-freightorder IS NOT INITIAL
                                       THEN |{ ls_nf_of-freightorder ALPHA = IN }|
                                       ELSE |{ '0' ALPHA = IN }| ).

      CHECK NOT line_exists( lt_mcd[ access_key  = ls_nf_of-accesskey
                                     ordem_frete = ls_nf_of-freightorder ] ). "#EC CI_STDSEQ

      lt_municipio[] = VALUE #( BASE lt_municipio ( guid         = lv_id
                                                    accesskey    = ls_nf_of-accesskey
                                                    freightorder = ls_nf_of-freightorder ) ).
    ENDLOOP.

    IF lt_municipio IS INITIAL.
      " As notas fiscais informadas já constam na lista
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '011' ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Separa todas as novas Notas Fiscais
* ---------------------------------------------------------------------------
    lt_municipio_all[] = lt_municipio[].
    lt_municipio_all[] = VALUE #( BASE lt_municipio_all FOR ls_mcd IN lt_mcd ( guid         = lv_id
                                                                               accesskey    = ls_mcd-access_key
                                                                               freightorder = ls_mcd-ordem_frete ) ).

* ---------------------------------------------------------------------------
* Determina informações automaticamente
* ---------------------------------------------------------------------------
    me->validate_municipio( EXPORTING it_municipio    = lt_municipio
                            IMPORTING et_municipio_ok = DATA(lt_municipio_ok)
                                      et_return       = et_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->determine_mdf( EXPORTING it_municipio = lt_municipio_all
                       IMPORTING et_return    = lt_return
                       CHANGING  cs_mdf       = ls_mdf ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->determine_complemento( EXPORTING is_mdf     = ls_mdf
                               IMPORTING es_mdf_ide = DATA(ls_mdf_ide)
                                         et_return  = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->determine_municipio( IMPORTING et_return    = lt_return
                             CHANGING  ct_municipio = lt_municipio_ok ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Motorista
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zi_tm_mdf_motorista
        WHERE id EQ @lv_id
        INTO @DATA(ls_motorista_old).         "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE ls_motorista_old.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Placa
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_placa
        WHERE id EQ @lv_id
        INTO TABLE @DATA(lt_placa_old).       "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_placa_old.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica se alguns dados do MDF-e já foram criados
* ---------------------------------------------------------------------------
    me->get_data_fo_to_mdf( EXPORTING iv_id              = ls_mdf-guid
                                      it_access_key      = lt_accesskey
                            IMPORTING et_municipio       = DATA(lt_municipio_new)
                                      es_motorista       = DATA(ls_motorista_new)
                                      et_placa           = DATA(lt_placa_new) ).

    IF ls_motorista_new-motorista EQ ls_motorista_old-motorista.
      FREE ls_motorista_new.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva informações
* ---------------------------------------------------------------------------
    me->save_mdf( EXPORTING is_mdf    = ls_mdf
                  IMPORTING et_return = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->save_complemento( EXPORTING is_mdf_ide = ls_mdf_ide
                          IMPORTING et_return  = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->save_municipio( EXPORTING it_municipio = lt_municipio_ok
                        IMPORTING et_return    = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->save_placa( EXPORTING it_placa     = lt_placa_new
                    IMPORTING et_return    = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->add_motorista( EXPORTING is_motorista = ls_motorista_new
                       IMPORTING et_return    = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    IF et_return IS INITIAL.
      " Lista de notas fiscais atualizada.
      et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '012' ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
      RETURN.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD validate_condutor.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Valida parceiro
* ---------------------------------------------------------------------------
    IF is_condutor-condutor IS NOT INITIAL.

      SELECT COUNT(*)
        FROM zi_ca_vh_partner_pf
        WHERE parceiro = @is_condutor-condutor.

      IF sy-subrc NE 0.
        " O Parceiro informado não existe ou não possui CPF.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-condutor field = 'CONDUTOR' type = 'E' id = 'ZTM_MONITOR_MDF' number = '014' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD determine_condutor.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera Condutor
* ---------------------------------------------------------------------------
    IF cs_condutor-condutor IS NOT INITIAL.

      SELECT SINGLE *
        FROM zi_ca_vh_partner_pf
        WHERE parceiro EQ @cs_condutor-condutor
        INTO @DATA(ls_parceiro).

      IF sy-subrc EQ 0.
        cs_condutor-cpf  = ls_parceiro-cpf.
        cs_condutor-nome = ls_parceiro-nome.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_motorista.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Validação de campos
* ---------------------------------------------------------------------------
    IF is_motorista-motorista IS INITIAL.
      " Favor informar algum motorista.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-motorista field = 'MOTORISTA' type = 'E' id = 'ZTM_MONITOR_MDF' number = '042' ) ).

    ELSE.

      SELECT COUNT(*)
        FROM zi_tm_vh_motorista
        WHERE parceiro = @is_motorista-motorista.

      IF sy-subrc NE 0.
        " O Parceiro informado não existe ou não possui CPF.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-motorista field = 'MOTORISTA' type = 'E' id = 'ZTM_MONITOR_MDF' number = '014' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD determine_motorista.

    FREE: es_motorista, et_return.

    es_motorista-id        = iv_id.
    es_motorista-motorista = iv_motorista.

    IF es_motorista-createdby IS INITIAL.
      es_motorista-createdby           = sy-uname.
      GET TIME STAMP FIELD es_motorista-createdat.
      es_motorista-lastchangedby       = es_motorista-createdby.
      es_motorista-lastchangedat       = es_motorista-createdat.
      es_motorista-locallastchangedat  = es_motorista-createdat.
    ELSE.
      es_motorista-lastchangedby          = sy-uname.
      GET TIME STAMP FIELD es_motorista-lastchangedat.
      es_motorista-locallastchangedat    = es_motorista-lastchangedat.
    ENDIF.

  ENDMETHOD.


  METHOD add_motorista.

    FREE: et_return, es_mdf_moto.

    CHECK is_motorista-motorista IS NOT INITIAL.

*    BREAK-POINT.

* ---------------------------------------------------------------------------
* Verifica o último motorista inserido
* ---------------------------------------------------------------------------
    SELECT COUNT(*)
      FROM zttm_mdf_moto
      WHERE id = is_motorista-id.

    IF sy-subrc EQ 0.
      es_mdf_moto-line = sy-dbcnt + 1.
    ELSE.
      es_mdf_moto-line = 1.
    ENDIF.

* ---------------------------------------------------------------------------
* Prepara novo motorista
* ---------------------------------------------------------------------------
    es_mdf_moto-id        = is_motorista-id.
    es_mdf_moto-motorista = is_motorista-motorista.

    IF es_mdf_moto-created_by IS INITIAL.
      es_mdf_moto-created_by            = sy-uname.
      GET TIME STAMP FIELD es_mdf_moto-created_at.
      es_mdf_moto-last_changed_by       = es_mdf_moto-created_by.
      es_mdf_moto-last_changed_at       = es_mdf_moto-created_at.
      es_mdf_moto-local_last_changed_at = es_mdf_moto-created_at.
    ELSE.
      es_mdf_moto-last_changed_by       = sy-uname.
      GET TIME STAMP FIELD es_mdf_moto-last_changed_at.
      es_mdf_moto-local_last_changed_at = es_mdf_moto-last_changed_at.
    ENDIF.

* ---------------------------------------------------------------------------
* Adiciona novo motorista
* ---------------------------------------------------------------------------
    IF iv_save EQ abap_true.
      MODIFY zttm_mdf_moto FROM es_mdf_moto.        "#EC CI_IMUD_NESTED

      IF sy-subrc NE 0.
        " Falha ao salvar os dados de motorista.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '047' ) ).
        me->format_message( CHANGING ct_return = et_return[] ).
        RETURN.
      ENDIF.

      " Motorista atualizado com sucesso.
      et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '048' ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
    ENDIF.

  ENDMETHOD.


  METHOD use_fo_create_mdf.

    DATA: lv_statuscode TYPE /xnfe/statuscode.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Gera dados MDF a partir de uma Ordem de frete
* ---------------------------------------------------------------------------
    me->get_data_fo_to_mdf( EXPORTING it_freight_order   = it_freight_order
                                      it_nota_fiscal     = it_nota_fiscal
                            IMPORTING es_mdf             = DATA(ls_mdf)
                                      es_complemento     = DATA(ls_complemento)
                                      et_municipio       = DATA(lt_municipio)
                                      es_motorista       = DATA(ls_motorista)
                                      et_placa           = DATA(lt_placa)
                                      et_condutor        = DATA(lt_condutor)
                                      et_vale_pedagio    = DATA(lt_vale_pedagio)
                                      et_return          = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE et_return[].
    CHECK NOT line_exists( lt_return[ type = 'E ' ] ).   "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Salva a nova MDF-e
* ---------------------------------------------------------------------------
    IF iv_save EQ abap_true.

      me->save( EXPORTING is_mdf                 = ls_mdf
                          is_complemento         = ls_complemento
                          it_municipio           = lt_municipio
                          is_motorista           = ls_motorista
                          it_placa               = lt_placa
                          it_condutor            = lt_condutor
                          it_vale_pedagio        = lt_vale_pedagio
                IMPORTING et_return              = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

      " Agrupamento &1 criado com sucesso.
      et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '084' message_v1 = |{ ls_mdf-agrupador ALPHA = OUT }| ) ).

    ENDIF.

* ---------------------------------------------------------------------------
* Valida as informações MDF-e
* ---------------------------------------------------------------------------
    IF iv_send EQ abap_true.

      me->validate_all( EXPORTING iv_id     = ls_mdf-guid
                                  iv_send   = abap_true
                        IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Processo de Envio MDF-e
* ---------------------------------------------------------------------------
      me->get_history( EXPORTING iv_id     = ls_mdf-guid
                       IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return[].
      CHECK lt_return IS INITIAL.

      lt_return[] = zcltm_mdf_events=>mdf_send_background( EXPORTING iv_id         = ls_mdf-guid
                                                           IMPORTING ev_statuscode = lv_statuscode ).

      INSERT LINES OF lt_return INTO TABLE et_return[].

      me->get_history( EXPORTING iv_id     = ls_mdf-guid
                       IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return[].

    ENDIF.

    me->format_message( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD get_data_fo_to_mdf.

    DATA: lt_freight_order TYPE ty_t_freight_order,
          ls_access_key    TYPE j_1b_nfe_access_key,
          lt_access_key    TYPE ty_t_access_key.

    FREE: es_mdf,
          es_complemento,
          et_municipio,
          es_motorista,
          et_placa,
          et_condutor,
          et_vale_pedagio,
          et_return.

    lt_freight_order = VALUE #( FOR lv_fo IN it_freight_order ( |{ lv_fo ALPHA = IN }| ) ).

* ---------------------------------------------------------------------------
* Recupera Ordem de Frete X Notas Fiscais
* ---------------------------------------------------------------------------
    IF it_freight_order IS NOT INITIAL.

      SELECT b~br_notafiscal,
             b~accesskey,
             b~freightorder,
             b~freightorderuuid,
             b~br_nfiscanceled
        FROM zi_tm_filtroult_mdf_nf_of AS a
       INNER JOIN zi_tm_vh_mdf_nf_of AS b ON a~freightorder     = b~freightorder
                                         AND a~deliverydocument = b~deliverydocument
                                         AND a~br_notafiscal    = b~br_notafiscal
         FOR ALL ENTRIES IN @lt_freight_order
       WHERE a~freightorder = @lt_freight_order-table_line
        INTO TABLE @DATA(lt_nf_of).

      IF sy-subrc EQ 0.

        IF line_exists( lt_nf_of[ br_nfiscanceled = abap_true ] ).
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '113' ) ).
          RETURN.
        ENDIF.

        SORT lt_nf_of BY accesskey freightorder.

      ENDIF.
    ENDIF.

    IF  it_nota_fiscal IS NOT INITIAL.

      SELECT br_notafiscal, accesskey
        FROM zi_tm_vh_mdf_nf
         FOR ALL ENTRIES IN @it_nota_fiscal
       WHERE br_notafiscal = @it_nota_fiscal-table_line
        INTO TABLE @DATA(lt_nf).

    ENDIF.

    IF it_access_key IS NOT INITIAL.

      lt_access_key = it_access_key.

      me->get_and_validate_acckey( EXPORTING it_access_key = it_access_key
                                   IMPORTING et_nf         = DATA(lt_nf_a)
                                             et_return     = DATA(lt_return) ).

      lt_nf = VALUE #( BASE lt_nf FOR ls_nf_a IN lt_nf_a ( CORRESPONDING #( ls_nf_a ) ) ).
      INSERT LINES OF lt_return INTO TABLE et_return.

    ELSE.
      lt_access_key = VALUE #( FOR ls_nf IN lt_nf ( ls_nf-accesskey ) ).
    ENDIF.

    SORT lt_nf BY accesskey     ASCENDING
                  br_notafiscal DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_nf COMPARING accesskey.

    " Remove as Notas Fiscais que foram encontradas via Ordem de Frete
    LOOP AT lt_nf_of REFERENCE INTO DATA(ls_r_nf_of) FROM 1.
      READ TABLE lt_nf TRANSPORTING NO FIELDS WITH KEY accesskey = ls_r_nf_of->accesskey BINARY SEARCH.

      IF sy-subrc EQ 0.
        DELETE lt_nf INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

    lt_nf_of = VALUE #( BASE lt_nf_of FOR ls_nf IN lt_nf ( accesskey = ls_nf-accesskey ) ).
    SORT lt_nf_of BY accesskey freightorder.

    IF lt_nf_of IS INITIAL.
      " Nenhuma Nota Fiscal encontrada para Ordem de Frete informada.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '079' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Ordem de Frete x Motorista
* ---------------------------------------------------------------------------
    SELECT DISTINCT *
        FROM zi_tm_vh_ordem_frete_moto
        FOR ALL ENTRIES IN @lt_nf_of
        WHERE parentuuid = @lt_nf_of-freightorderuuid
        INTO TABLE @DATA(lt_nf_of_moto).

    IF sy-subrc NE 0.
      FREE lt_nf_of_moto.
    ENDIF.

* ---------------------------------------------------------------------------
* Gera novo ID
* ---------------------------------------------------------------------------
    TRY.
        IF iv_id IS SUPPLIED.
          DATA(lv_id) = iv_id.
        ELSE.
          lv_id = cl_system_uuid=>create_uuid_x16_static( ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta dados de município
* ---------------------------------------------------------------------------
    et_municipio = VALUE #( FOR ls_nf_of IN lt_nf_of (
                            guid          = lv_id
                            accesskey     = ls_nf_of-accesskey
                            ordemfrete    = ls_nf_of-freightorder
                            freightorder  = ls_nf_of-freightorder
                            br_notafiscal = ls_nf_of-br_notafiscal ) ).

    me->determine_municipio( IMPORTING et_return    = lt_return
                             CHANGING  ct_municipio = et_municipio ).

* ---------------------------------------------------------------------------
* Monta dados de cabeçalho
* ---------------------------------------------------------------------------
    es_mdf = VALUE #( guid  = lv_id
                      refof = abap_true ).

    me->determine_mdf( EXPORTING it_municipio = et_municipio
                       CHANGING  cs_mdf       = es_mdf ).

* ---------------------------------------------------------------------------
* Monta dados de complemento
* ---------------------------------------------------------------------------
    me->determine_complemento( EXPORTING is_mdf     = es_mdf
                               IMPORTING es_mdf_ide = es_complemento ).

* ---------------------------------------------------------------------------
* Monta dados de placa
* ---------------------------------------------------------------------------
    me->determine_placa_from_fo( EXPORTING it_municipio = et_municipio
                                 IMPORTING et_placa     = et_placa
                                           et_return    = lt_return ).

    INSERT LINES OF lt_return INTO TABLE et_return.

    IF et_placa[] IS INITIAL.
      me->determine_placa_from_acckey( EXPORTING is_mdf        = es_mdf
                                                 it_access_key = lt_access_key
                                       IMPORTING et_placa      = et_placa
                                                 et_return     = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return.
    ENDIF.

* ---------------------------------------------------------------------------
* Monta dados de motorista
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_nf_of_moto) = lt_nf_of_moto[ 1 ].
        es_motorista = VALUE #( id        = lv_id
                                motorista = ls_nf_of_moto-driverid ).
      CATCH cx_root.

        me->determine_moto_from_acckey( EXPORTING is_mdf        = es_mdf
                                                  it_access_key = lt_access_key
                                        IMPORTING es_motorista  = es_motorista
                                                  et_return     = lt_return ).

        INSERT LINES OF lt_return INTO TABLE et_return.

    ENDTRY.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD get_and_validate_acckey.

    FREE: et_nf, et_return.

* ---------------------------------------------------------------------------
* Recupear Nota Fiscal referente à chave de acesso
* ---------------------------------------------------------------------------
    IF it_access_key[] IS NOT INITIAL.

      SELECT br_notafiscal, accesskey
          FROM zi_tm_vh_mdf_nf
          FOR ALL ENTRIES IN @it_access_key
          WHERE accesskey = @it_access_key-table_line
          INTO TABLE @DATA(lt_nf).

      IF sy-subrc EQ 0.
        SORT lt_nf BY accesskey     ASCENDING
                      br_notafiscal DESCENDING.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida se Nota Fiscal foi encontrada
* ---------------------------------------------------------------------------
    LOOP AT it_access_key REFERENCE INTO DATA(ls_access_key).

      READ TABLE lt_nf INTO DATA(ls_nf) WITH KEY accesskey = ls_access_key->*  BINARY SEARCH.

      IF sy-subrc NE 0.
        CLEAR ls_nf.
        ls_nf-accesskey = ls_access_key->*.
      ENDIF.

      IF ls_nf-br_notafiscal IS INITIAL.
        " Chave externa identificada: &1.
        et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZTM_MONITOR_MDF' number = '112' message_v1 = ls_access_key->* ) ).
      ENDIF.

      et_nf = VALUE #( BASE et_nf ( CORRESPONDING #( ls_nf ) ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD validate_percurso.

    FREE: et_return.

*    IF is_percurso-UfPercurso IS INITIAL.
*      " Percurso não configurado.
*      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-percurso field = 'PERCURSO' type = 'E' id = 'ZTM_MONITOR_MDF' number = '044' ) ).
*    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD validate_all.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Cabeçalho / Dados Organizacionais
* ---------------------------------------------------------------------------
    SELECT SINGLE *
      FROM zi_tm_mdf
      WHERE guid EQ @iv_id
      INTO @DATA(ls_mdf).                     "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      " MDF-e não encontrada.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-mdf field = 'BR_NOTAFISCAL' type = 'E' id = 'ZTM_MONITOR_MDF' number = '021' ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Complemento
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zi_tm_mdf_complemento
      WHERE id EQ @iv_id
      INTO @DATA(ls_complemento).             "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE ls_complemento.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Notas Transportadas
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_municipio
        WHERE guid EQ @iv_id
        INTO TABLE @DATA(lt_municipio).       "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_municipio.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Motorista
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zi_tm_mdf_motorista
        WHERE id EQ @iv_id
        INTO @DATA(ls_motorista).             "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE ls_motorista.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Placa
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_placa
        WHERE id EQ @iv_id
        INTO TABLE @DATA(lt_placa).           "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_placa.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Percurso
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zi_tm_mdf_percurso_doc
        WHERE id EQ @iv_id
        INTO @DATA(ls_percurso).              "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE ls_percurso.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Municípios Carregamento
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_carregamento
        WHERE id EQ @iv_id
        INTO TABLE @DATA(lt_carregamento).    "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_carregamento.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Municípios Descarregamento
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_descarregamento
        WHERE id EQ @iv_id
        INTO TABLE @DATA(lt_descarregamento). "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_descarregamento.
    ENDIF.

* ---------------------------------------------------------------------------
* Validação de campos
* ---------------------------------------------------------------------------
    me->validate_mdf( EXPORTING is_mdf    = ls_mdf
                      IMPORTING et_return = DATA(lt_return) ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->validate_complemento( EXPORTING is_mdf_ide = ls_complemento
                              IMPORTING et_return  = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->validate_municipio( EXPORTING it_municipio = lt_municipio
                            IMPORTING et_return    = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->validate_motorista( EXPORTING is_motorista = ls_motorista
                            IMPORTING et_return    = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->validate_placa( EXPORTING it_placa  = lt_placa
                                  iv_send   = iv_send
                        IMPORTING et_return = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    LOOP AT lt_placa INTO DATA(ls_placa).          "#EC CI_LOOP_INTO_WA

      me->validate_proprietario( EXPORTING is_placa  = ls_placa
                                 IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return[].
    ENDLOOP.

    me->validate_percurso( EXPORTING is_percurso = ls_percurso
                           IMPORTING et_return   = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->validate_carregamento( EXPORTING it_carregamento = lt_carregamento
                               IMPORTING et_return       = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    me->validate_descarregamento( EXPORTING it_descarregamento = lt_descarregamento
                                  IMPORTING et_return          = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

    IF line_exists( et_return[ type = 'E ' ] ) AND iv_send EQ abap_true. "#EC CI_STDSEQ
      " Corrigir os erros antes de prosseguir com o envio MDF-e.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '086' ) ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD build_reported.

    DATA: lo_dataref            TYPE REF TO data,
          ls_mdf                TYPE zi_tm_mdf,
          ls_carregamento       TYPE zi_tm_mdf_carregamento,
          ls_descarregamento    TYPE zi_tm_mdf_descarregamento,
          ls_complemento        TYPE zi_tm_mdf_complemento,
          ls_emitente           TYPE zi_tm_mdf_emitente,
          ls_historico          TYPE zi_tm_mdf_historico,
          ls_motorista          TYPE zi_tm_mdf_motorista,
          ls_municipio          TYPE zi_tm_mdf_municipio,
          ls_percurso_doc       TYPE zi_tm_mdf_percurso_doc,
          ls_placa              TYPE zi_tm_mdf_placa,
          ls_placa_condutor     TYPE zi_tm_mdf_placa_condutor,
          ls_placa_vale_pedagio TYPE zi_tm_mdf_placa_vale_pedagio.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-mdf.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-mdf.
        WHEN gc_cds-carregamento.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-carregamento.
        WHEN gc_cds-descarregamento.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-descarregamento.
        WHEN gc_cds-complemento.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-complemento.
        WHEN gc_cds-emitente.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-emitente.
        WHEN gc_cds-historico.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-historico.
        WHEN gc_cds-motorista.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-motorista.
        WHEN gc_cds-municipio.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-municipio.
        WHEN gc_cds-percurso.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-percurso.
        WHEN gc_cds-placa.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-placa.
        WHEN gc_cds-condutor.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-condutor.
        WHEN gc_cds-valepedagio.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-valepedagio.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-mdf.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = new_message( id       = ls_return-id
                                     number   = ls_return-number
                                     v1       = ls_return-message_v1
                                     v2       = ls_return-message_v2
                                     v3       = ls_return-message_v3
                                     v4       = ls_return-message_v4
                                     severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-mdf.
          es_reported-mdf[]             = VALUE #( BASE es_reported-mdf[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-carregamento.
          es_reported-carregamento[]    = VALUE #( BASE es_reported-carregamento[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-descarregamento.
          es_reported-descarregamento[] = VALUE #( BASE es_reported-descarregamento[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-complemento.
          es_reported-complemento[]     = VALUE #( BASE es_reported-complemento[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-emitente.
          es_reported-emitente[]        = VALUE #( BASE es_reported-emitente[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-historico.
          es_reported-historico[]       = VALUE #( BASE es_reported-historico[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-motorista.
          es_reported-motorista[]       = VALUE #( BASE es_reported-motorista[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-municipio.
          es_reported-municipio[]       = VALUE #( BASE es_reported-municipio[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-percurso.
          es_reported-percurso[]        = VALUE #( BASE es_reported-percurso[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-placa.
          es_reported-placa[]           = VALUE #( BASE es_reported-placa[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-condutor.
          es_reported-condutor[]        = VALUE #( BASE es_reported-condutor[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-valepedagio.
          es_reported-valepedagio[]     = VALUE #( BASE es_reported-valepedagio[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-mdf[]             = VALUE #( BASE es_reported-mdf[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD use_exist_mdfe_to_new_mdfe.

    DATA:
      lt_mdf        TYPE TABLE OF zttm_mdf,
      lt_ide        TYPE TABLE OF zttm_mdf_ide,
      lt_municipio  TYPE TABLE OF zttm_mdf_mcd,
      lt_motorista  TYPE TABLE OF zttm_mdf_moto,
*      lt_carregamento    TYPE TABLE OF zttm_mdf_munc,
*      lt_descarregamento TYPE TABLE OF zttm_mdf_mund,
      lt_placa_c    TYPE TABLE OF zttm_mdf_placa_c,
      lt_placa_v    TYPE TABLE OF zttm_mdf_placa_v,
      lt_placa      TYPE TABLE OF zttm_mdf_placa,
      lv_statuscode TYPE /xnfe/statuscode,

      lv_docnum     TYPE zttm_mdf-docnum.

    FREE: et_return.

    DATA lt_return TYPE bapiret2_t.

    me->get_exist_data_mdfe( EXPORTING iv_id              = iv_id
                             IMPORTING et_mdf             = lt_mdf
                                       et_ide             = lt_ide
                                       et_municipio       = lt_municipio
                                       et_motorista       = lt_motorista
                                       et_placa_c         = lt_placa_c
                                       et_placa_v         = lt_placa_v
                                       et_placa           = lt_placa
                                       et_return          = et_return ).

* ---------------------------------------------------------------------------
* Gera novo ID
* ---------------------------------------------------------------------------
    TRY.
        DATA(lv_id) = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_root.
    ENDTRY.

    lv_docnum = zcltm_mdf_events=>doc_mdfe_create( IMPORTING et_return = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Cria dados MDF-e - Cabeçalho / Dados Organizacionais
* ---------------------------------------------------------------------------
    SORT lt_mdf BY id.
    READ TABLE lt_mdf ASSIGNING FIELD-SYMBOL(<fs_mdf>) WITH KEY id = iv_id
                                                       BINARY SEARCH.
    IF sy-subrc = 0.
      <fs_mdf>-id                       = lv_id.
      <fs_mdf>-docnum                   = lv_docnum.
      <fs_mdf>-manual                   = abap_false.
      <fs_mdf>-dtini                    = sy-datum.
      <fs_mdf>-hrini                    = sy-uzeit.
      <fs_mdf>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_mdf>-created_at.
      <fs_mdf>-last_changed_by          = <fs_mdf>-created_by.
      <fs_mdf>-last_changed_at          = <fs_mdf>-created_at.
      <fs_mdf>-local_last_changed_at    = <fs_mdf>-created_at.
      CLEAR: <fs_mdf>-mdfenum, <fs_mdf>-access_key, <fs_mdf>-series, <fs_mdf>-ref_of, <fs_mdf>-statcod.
    ENDIF.

* ---------------------------------------------------------------------------
* Cria dados MDF-e - Interface IDE
* ---------------------------------------------------------------------------
    LOOP AT lt_ide ASSIGNING FIELD-SYMBOL(<fs_ide>).
      <fs_ide>-id = lv_id.
      GET TIME STAMP FIELD <fs_ide>-dh_emi.
      <fs_ide>-c_mdf                    = 0.
      <fs_ide>-c_dv                     = space.
      <fs_ide>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_ide>-created_at.
      <fs_ide>-last_changed_by          = <fs_ide>-created_by.
      <fs_ide>-last_changed_at          = <fs_ide>-created_at.
      <fs_ide>-local_last_changed_at    = <fs_ide>-created_at.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Criar dados MDF-e - Municipio, carregamento, descarregamento
* ---------------------------------------------------------------------------
    LOOP AT lt_municipio ASSIGNING FIELD-SYMBOL(<fs_mcd>).
      <fs_mcd>-id = lv_id.
      <fs_mcd>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_mcd>-created_at.
      <fs_mcd>-last_changed_by          = <fs_mcd>-created_by.
      <fs_mcd>-last_changed_at          = <fs_mcd>-created_at.
      <fs_mcd>-local_last_changed_at    = <fs_mcd>-created_at.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Motorista
* ---------------------------------------------------------------------------
    LOOP AT lt_motorista ASSIGNING FIELD-SYMBOL(<fs_motorista>).
      <fs_motorista>-id = lv_id.
      <fs_motorista>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_motorista>-created_at.
      <fs_motorista>-last_changed_by          = <fs_motorista>-created_by.
      <fs_motorista>-last_changed_at          = <fs_motorista>-created_at.
      <fs_motorista>-local_last_changed_at    = <fs_motorista>-created_at.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Placas x Condutores
* ---------------------------------------------------------------------------
    LOOP AT lt_placa_c ASSIGNING FIELD-SYMBOL(<fs_placa_c>).
      <fs_placa_c>-id = lv_id.
      <fs_placa_c>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_placa_c>-created_at.
      <fs_placa_c>-last_changed_by          = <fs_placa_c>-created_by.
      <fs_placa_c>-last_changed_at          = <fs_placa_c>-created_at.
      <fs_placa_c>-local_last_changed_at    = <fs_placa_c>-created_at.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Placas x Vale pedagio
* ---------------------------------------------------------------------------
    LOOP AT lt_placa_v ASSIGNING FIELD-SYMBOL(<fs_placa_v>).
      <fs_placa_v>-id = lv_id.
      <fs_placa_v>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_placa_v>-created_at.
      <fs_placa_v>-last_changed_by          = <fs_placa_v>-created_by.
      <fs_placa_v>-last_changed_at          = <fs_placa_v>-created_at.
      <fs_placa_v>-local_last_changed_at    = <fs_placa_v>-created_at.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Placas
* ---------------------------------------------------------------------------
    LOOP AT lt_placa ASSIGNING FIELD-SYMBOL(<fs_placa>).
      <fs_placa>-id = lv_id.
      <fs_placa>-created_by               = sy-uname.
      GET TIME STAMP FIELD <fs_placa>-created_at.
      <fs_placa>-last_changed_by          = <fs_placa>-created_by.
      <fs_placa>-last_changed_at          = <fs_placa>-created_at.
      <fs_placa>-local_last_changed_at    = <fs_placa>-created_at.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva informações MDF
* ---------------------------------------------------------------------------
    IF lt_mdf[] IS NOT INITIAL.
      MODIFY zttm_mdf FROM TABLE lt_mdf[].

      IF sy-subrc NE 0.
        " Falha ao salvar as informações de cabeçalho.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '020' ) ).
        me->format_message( CHANGING ct_return = et_return[] ).
        RETURN.
      ENDIF.

* ---------------------------------------------------------------------------
* Salva informações IDE
* ---------------------------------------------------------------------------
      IF lt_ide[] IS NOT INITIAL.

        MODIFY zttm_mdf_ide FROM TABLE lt_ide[].

        IF sy-subrc NE 0.
          " Falha ao salvar as informações IDE.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '001' ) ).
          me->format_message( CHANGING ct_return = et_return[] ).
          RETURN.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Salva municípios de carregamento
* ---------------------------------------------------------------------------
      IF lt_municipio[] IS NOT INITIAL.

        MODIFY zttm_mdf_mcd FROM TABLE lt_municipio[].

        IF sy-subrc NE 0.
          " Falha ao salvar os dados de municípios e notas transportadas.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '009' ) ).
          me->format_message( CHANGING ct_return = et_return[] ).
          RETURN.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona novo motorista
* ---------------------------------------------------------------------------
      IF lt_motorista[] IS NOT INITIAL.
        MODIFY zttm_mdf_moto FROM TABLE lt_motorista[]. "#EC CI_IMUD_NESTED

        IF sy-subrc NE 0.
          " Falha ao salvar os dados de motorista.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '047' ) ).
          me->format_message( CHANGING ct_return = et_return[] ).
          RETURN.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Salva municípios de placa
* ---------------------------------------------------------------------------
      IF lt_placa[] IS NOT INITIAL.

        MODIFY zttm_mdf_placa FROM TABLE lt_placa[].

        IF sy-subrc NE 0.
          " Falha ao salvar as placas.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '060' ) ).
          me->format_message( CHANGING ct_return = et_return[] ).
          RETURN.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Salva placas x condutores
* ---------------------------------------------------------------------------
      IF lt_placa_c[] IS NOT INITIAL.

        MODIFY zttm_mdf_placa_c FROM TABLE lt_placa_c[].

        IF sy-subrc NE 0.
          " Falha ao salvar as placas.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '081' ) ).
          me->format_message( CHANGING ct_return = et_return[] ).
          RETURN.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Salva placas x vale pedagio
* ---------------------------------------------------------------------------
      IF lt_placa_v[] IS NOT INITIAL.

        MODIFY zttm_mdf_placa_v FROM TABLE lt_placa_v[].

        IF sy-subrc NE 0.
          " Falha ao salvar as placas.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '082' ) ).
          me->format_message( CHANGING ct_return = et_return[] ).
          RETURN.
        ENDIF.
      ENDIF.

    ENDIF.

    IF et_return[] IS INITIAL.
      " Agrupamento &1 criado com sucesso.
      et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '084' message_v1 = |{ lv_docnum ALPHA = OUT }| ) ).
      me->format_message( CHANGING ct_return = et_return[] ).
    ENDIF.

* ---------------------------------------------------------------------------
* Valida as informações MDF-e
* ---------------------------------------------------------------------------
    LOOP AT lt_mdf REFERENCE INTO DATA(ls_mdf).

      " Verifica se alguma informação da ordem de frete foi atualizada
      me->update_mdf_using_fo( EXPORTING iv_id     = ls_mdf->id
                               IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].

      me->validate_all( EXPORTING iv_id     = ls_mdf->id
                                  iv_send   = abap_true
                        IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].
      CHECK NOT line_exists( lt_return[ type = 'E ' ] ). "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Processo de Envio MDF-e
* ---------------------------------------------------------------------------
      me->get_history( EXPORTING iv_id     = ls_mdf->id
                       IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return[].
      CHECK lt_return IS INITIAL.

      lt_return[] = zcltm_mdf_events=>mdf_send_background( EXPORTING iv_id         = ls_mdf->id
                                                           IMPORTING ev_statuscode = lv_statuscode ).

      INSERT LINES OF lt_return INTO TABLE et_return[].

      me->get_history( EXPORTING iv_id     = ls_mdf->id
                       IMPORTING et_return = lt_return ).

      INSERT LINES OF lt_return INTO TABLE et_return[].

    ENDLOOP.

    me->format_message( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD get_exist_data_mdfe.

** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Cabeçalho / Dados Organizacionais
** ---------------------------------------------------------------------------
    SELECT *
    FROM zttm_mdf
    INTO TABLE @et_mdf
    WHERE id = @iv_id.                        "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc = 0.
** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Interface IDE
** ---------------------------------------------------------------------------
      SELECT *
      FROM zttm_mdf_ide
      INTO TABLE @et_ide
      WHERE id = @iv_id.                      "#EC CI_ALL_FIELDS_NEEDED

** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Municipio, carregamento, descarregamento
** ---------------------------------------------------------------------------
      SELECT *
      FROM zttm_mdf_mcd
      INTO TABLE @et_municipio
      WHERE id = @iv_id.                      "#EC CI_ALL_FIELDS_NEEDED

** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Motorista
** ---------------------------------------------------------------------------
      SELECT *
      FROM zttm_mdf_moto
      INTO TABLE @et_motorista
      WHERE id = @iv_id.                      "#EC CI_ALL_FIELDS_NEEDED

      " Recupera apenas o atual motorista
      SORT et_motorista BY id ASCENDING line DESCENDING.
      DELETE ADJACENT DUPLICATES FROM et_motorista COMPARING id.

** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Placas x Condutores
** ---------------------------------------------------------------------------
      SELECT *
      FROM zttm_mdf_placa_c
      INTO TABLE @et_placa_c
      WHERE id = @iv_id.                      "#EC CI_ALL_FIELDS_NEEDED

** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Placas x Vale pedagio
** ---------------------------------------------------------------------------
      SELECT *
      FROM zttm_mdf_placa_v
      INTO TABLE @et_placa_v
      WHERE id = @iv_id.                      "#EC CI_ALL_FIELDS_NEEDED

** ---------------------------------------------------------------------------
** Recupera dados MDF-e - Placas
** ---------------------------------------------------------------------------
      SELECT *
      FROM zttm_mdf_placa
      INTO TABLE @et_placa
      WHERE id = @iv_id.                      "#EC CI_ALL_FIELDS_NEEDED

    ENDIF.

  ENDMETHOD.


  METHOD save.

    me->save_mdf( EXPORTING iv_save   = abap_false
                            is_mdf    = is_mdf
                  IMPORTING es_mdf    = DATA(ls_mdf)
                            et_return = DATA(lt_return) ).

    me->save_complemento( EXPORTING iv_save    = abap_false
                                    is_mdf_ide = is_complemento
                          IMPORTING es_mdf_ide = DATA(ls_mdf_ide)
                                    et_return  = lt_return ).

    me->save_municipio( EXPORTING iv_save      = abap_false
                                  it_municipio = it_municipio
                        IMPORTING et_mdf_mcd   = DATA(lt_mdf_mcd)
                                  et_return    = lt_return ).

    me->add_motorista( EXPORTING iv_save      = abap_false
                                 is_motorista = is_motorista
                       IMPORTING es_mdf_moto  = DATA(ls_mdf_moto)
                                 et_return    = lt_return ).

    me->save_placa( EXPORTING iv_save       = abap_false
                              it_placa      = it_placa
                    IMPORTING et_mdf_placa  = DATA(lt_mdf_placa)
                              et_return     = lt_return ).

    me->save_placa_condutor( EXPORTING iv_save        = abap_false
                                       it_condutor    = it_condutor
                             IMPORTING et_mdf_placa_c = DATA(lt_mdf_placa_c)
                                       et_return      = lt_return ).

    me->save_placa_vale_pedagio( EXPORTING iv_save         = abap_false
                                           it_vale_pedagio = it_vale_pedagio
                                 IMPORTING et_mdf_placa_v  = DATA(lt_mdf_placa_v)
                                           et_return       = lt_return ).

* ---------------------------------------------------------------------------
* Chama processo para salvar dados em background
* ---------------------------------------------------------------------------
    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMTM_MONITOR_MDF_SALVAR'
      STARTING NEW TASK 'MONITOR_MDF_SALVAR'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_mdf         = ls_mdf
        is_mdf_ide     = ls_mdf_ide
        it_mdf_mcd     = lt_mdf_mcd
        is_mdf_moto    = ls_mdf_moto
        it_mdf_placa   = lt_mdf_placa
        it_mdf_placa_c = lt_mdf_placa_c
        it_mdf_placa_v = lt_mdf_placa_v.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'MONITOR_MDF_SALVAR'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_MONITOR_MDF_SALVAR'
            IMPORTING
                et_return = gt_return.

      WHEN 'MONITOR_MDF_BUSCA_HIST'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_MONITOR_MDF_BUSCA_HIST'
            IMPORTING
                et_return = gt_return.
    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD save_background.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Salva informações de cabeçalho
* ---------------------------------------------------------------------------
    MODIFY zttm_mdf FROM is_mdf.

    IF sy-subrc NE 0.
      " Falha ao salvar as informações de cabeçalho.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '020' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Salva informações IDE
* ---------------------------------------------------------------------------
    MODIFY zttm_mdf_ide FROM is_mdf_ide.

    IF sy-subrc NE 0.
      " Falha ao salvar as informações IDE.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '001' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Salva municípios de carregamento
* ---------------------------------------------------------------------------
    IF it_mdf_mcd IS NOT INITIAL.

      MODIFY zttm_mdf_mcd FROM TABLE it_mdf_mcd[].

      IF sy-subrc NE 0.
        " Falha ao salvar os dados de municípios e notas transportadas.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '009' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Adiciona novo motorista
* ---------------------------------------------------------------------------
    IF is_mdf_moto-motorista IS NOT INITIAL.

      MODIFY zttm_mdf_moto FROM is_mdf_moto.        "#EC CI_IMUD_NESTED

      IF sy-subrc NE 0.
        " Falha ao salvar os dados de motorista.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '047' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva municípios de placa
* ---------------------------------------------------------------------------
    IF it_mdf_placa[] IS NOT INITIAL.

      MODIFY zttm_mdf_placa FROM TABLE it_mdf_placa[].

      IF sy-subrc NE 0.
        " Falha ao salvar as placas.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '060' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva condutor
* ---------------------------------------------------------------------------
    IF it_mdf_placa_c[] IS NOT INITIAL.

      MODIFY zttm_mdf_placa_c FROM TABLE it_mdf_placa_c[].

      IF sy-subrc NE 0.
        " Falha ao salvar as placas x condutores.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '081' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva condutor
* ---------------------------------------------------------------------------
    IF it_mdf_placa_v[] IS NOT INITIAL.

      MODIFY zttm_mdf_placa_v FROM TABLE it_mdf_placa_v[].

      IF sy-subrc NE 0.
        " Falha ao salvar as placas x vale pedágio.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '082' ) ).
      ENDIF.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

    IF NOT line_exists( et_return[ type = 'E ' ] ).      "#EC CI_STDSEQ
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


  METHOD get_history.

* ---------------------------------------------------------------------------
* Recupera dados MDF se necessário
* ---------------------------------------------------------------------------
    IF is_mdf IS NOT INITIAL.

      DATA(ls_mdf) = is_mdf.

    ELSEIF iv_id IS NOT INITIAL.

      SELECT SINGLE *
        FROM zttm_mdf
        INTO @ls_mdf
        WHERE id = @iv_id.

      IF sy-subrc NE 0.
        FREE ls_mdf.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Chama processo para salvar dados em background
* ---------------------------------------------------------------------------
    FREE: et_return, gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_MONITOR_MDF_BUSCA_HIST'
      STARTING NEW TASK 'MONITOR_MDF_BUSCA_HIST'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_mdf = ls_mdf.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

  ENDMETHOD.


  METHOD get_history_background.

    DATA: lt_historico_new   TYPE ty_tab_historico,
          lt_hdsta           TYPE /xnfe/outhdsta_t,
          lt_hist            TYPE /xnfe/outhist_t,
          lt_symsg           TYPE /xnfe/symsg_t,
          lt_status          TYPE /xnfe/event_stat_t,
          lt_hist_event      TYPE /xnfe/event_hist_t,
          lv_histcount_event TYPE /xnfe/histcount,
          lt_symsg_event     TYPE /xnfe/symsg_t,

          ls_xml_mdfe        TYPE /xnfe/outmdfexml,
          ls_event           TYPE /xnfe/events,
          ls_xml             TYPE /xnfe/event_xml,

          lv_histcount       TYPE /xnfe/histcount,
          lv_tpevento        TYPE /xnfe/ev_tpevento,
          lv_proctyp         TYPE /xnfe/proctyp,
          lv_guid            TYPE /xnfe/guid_16,
          lv_event_exists    TYPE abap_bool,
          lv_current         TYPE /xnfe/actstat.

    FREE: et_return, es_mdfehd.

    IF is_mdf-access_key IS INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera status antigo
* ---------------------------------------------------------------------------
    SELECT id, histcount, event
        FROM zttm_mdf_hist
        INTO TABLE @DATA(lt_historico_old)
        WHERE id = @is_mdf-id.

    IF sy-subrc EQ 0.
      SORT lt_historico_old BY id histcount event.
    ENDIF.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Recupera histórico para verifica Status do MDF-e
* ---------------------------------------------------------------------------
    CALL FUNCTION '/XNFE/OUTMDFE_READ_MFE_FOR_UPD'
      EXPORTING
        iv_mdfeid           = is_mdf-access_key
      IMPORTING
        es_mdfehd           = es_mdfehd
        es_xml_mdfe         = ls_xml_mdfe
        et_hdsta            = lt_hdsta
        et_hist             = lt_hist
        et_symsg            = lt_symsg
        ev_histcount        = lv_histcount
      EXCEPTIONS
        mdfe_does_not_exist = 1
        mdfe_locked         = 2
        technical_error     = 3
        OTHERS              = 4.

    IF sy-subrc NE 0.
      FREE: lt_hist, lt_symsg.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera histórico para verifica Status do MDF-e (Eventos)
* ---------------------------------------------------------------------------
    lv_tpevento   = '110114'.
    lv_proctyp    = 'ISSMDRIV'.

    CALL FUNCTION '/XNFE/EVENT_EXISTS'
      EXPORTING
        iv_chnfe          = is_mdf-access_key
        iv_tpevento       = lv_tpevento
        iv_proctyp        = lv_proctyp
      IMPORTING
        ev_event_exists   = lv_event_exists
        ev_guid           = lv_guid
        ev_current_status = lv_current.

    CALL FUNCTION '/XNFE/EVENT_READ'
      EXPORTING
        iv_guid              = lv_guid
      IMPORTING
        es_event             = ls_event
        es_xml               = ls_xml
        et_status            = lt_status
        et_hist              = lt_hist_event
        et_symsg             = lt_symsg_event
        ev_histcount         = lv_histcount_event
      EXCEPTIONS
        event_does_not_exist = 1
        event_locked         = 2
        technical_error      = 3
        OTHERS               = 4.

    IF sy-subrc NE 0.
      FREE: lt_hist_event, lt_symsg_event.
    ENDIF.

    IF lt_hist IS INITIAL AND lt_hist_event IS INITIAL.
      " Nenhum histórico encontrado.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '092' ) ).
      me->format_message( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

    SORT lt_hist BY histcount.
    SORT lt_symsg BY histcount.
    SORT lt_hist_event BY histcount.
    SORT lt_symsg_event BY histcount.

* ---------------------------------------------------------------------------
* Separa as novas mensagens
* ---------------------------------------------------------------------------
    LOOP AT lt_hist REFERENCE INTO DATA(ls_hist).  "#EC CI_LOOP_INTO_WA

      READ TABLE lt_historico_old TRANSPORTING NO FIELDS WITH KEY id        = is_mdf-id
                                                                  histcount = ls_hist->histcount
                                                                  event     = 0
                                                                  BINARY SEARCH.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.

      READ TABLE lt_symsg REFERENCE INTO DATA(ls_symsg) WITH KEY histcount = ls_hist->histcount
                                                                 BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      lt_historico_new = VALUE #( BASE lt_historico_new (
                                  id                    = is_mdf-id
                                  histcount             = ls_hist->histcount
                                  event                 = 0
                                  proctyp               = ls_hist->proctyp
                                  procstep              = ls_hist->procstep
                                  stepstatus            = ls_hist->stepstatus
                                  createtime            = ls_hist->createtime
                                  username              = ls_hist->username
                                  msgid                 = ls_symsg->msgid
                                  msgno                 = ls_symsg->msgno
                                  msgv1                 = ls_symsg->msgv1
                                  msgv2                 = ls_symsg->msgv2
                                  msgv3                 = ls_symsg->msgv3
                                  msgv4                 = ls_symsg->msgv4
                                  created_by            = sy-uname
                                  created_at            = lv_timestamp
                                  local_last_changed_at = lv_timestamp ) ).
    ENDLOOP.

    LOOP AT lt_hist_event REFERENCE INTO DATA(ls_hist_event). "#EC CI_LOOP_INTO_WA

      READ TABLE lt_historico_old TRANSPORTING NO FIELDS WITH KEY id        = is_mdf-id
                                                                  histcount = ls_hist_event->histcount
                                                                  event     = ls_event-nseqevento_int
                                                                  BINARY SEARCH.
      IF sy-subrc EQ 0.
        CONTINUE.
      ENDIF.

      READ TABLE lt_symsg_event REFERENCE INTO DATA(ls_symsg_event) WITH KEY histcount = ls_hist_event->histcount
                                                                    BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      lt_historico_new = VALUE #( BASE lt_historico_new (
                                  id                    = is_mdf-id
                                  histcount             = ls_hist_event->histcount
                                  event                 = ls_event-nseqevento_int
                                  proctyp               = ls_hist_event->proctyp
                                  procstep              = ls_hist_event->procstep
                                  stepstatus            = ls_hist_event->stepstatus
                                  createtime            = ls_hist_event->createtime
                                  username              = ls_hist_event->username
                                  msgid                 = ls_symsg_event->msgid
                                  msgno                 = ls_symsg_event->msgno
                                  msgv1                 = ls_symsg_event->msgv1
                                  msgv2                 = ls_symsg_event->msgv2
                                  msgv3                 = ls_symsg_event->msgv3
                                  msgv4                 = ls_symsg_event->msgv4
                                  created_by            = sy-uname
                                  created_at            = lv_timestamp
                                  local_last_changed_at = lv_timestamp ) ).
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva as novas mensagens
* ---------------------------------------------------------------------------
    IF lt_historico_new IS NOT INITIAL.

      MODIFY zttm_mdf_hist FROM TABLE lt_historico_new.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ELSE.
        " Falha ao salvar os dados de histórico.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '093' ) ).
        me->format_message( CHANGING ct_return = et_return ).
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera a última mensagem
* ---------------------------------------------------------------------------
    READ TABLE lt_symsg REFERENCE INTO ls_symsg WITH KEY histcount = lv_histcount
                                                         BINARY SEARCH.
    IF sy-subrc EQ 0.
      et_return = VALUE #( BASE et_return ( type       = 'I'
                                            id         = ls_symsg->msgid
                                            number     = ls_symsg->msgno
                                            message_v1 = ls_symsg->msgv1
                                            message_v2 = ls_symsg->msgv2
                                            message_v3 = ls_symsg->msgv3
                                            message_v4 = ls_symsg->msgv4 ) ).
      me->format_message( CHANGING ct_return = et_return ).
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza status da MDF-e
* ---------------------------------------------------------------------------
    DATA(ls_mdf) = is_mdf.
    ls_mdf-statcod = es_mdfehd-statcod.
    ls_mdf-nprot   = COND #( WHEN es_mdfehd-nprot IS NOT INITIAL
                             THEN es_mdfehd-nprot
                             WHEN ls_event-nprot IS NOT INITIAL
                             THEN ls_event-nprot
                             ELSE ls_mdf-nprot ).

    MODIFY zttm_mdf FROM ls_mdf.

    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD update_freight_order.

    DATA:
      lt_parameters TYPE /bobf/t_frw_query_selparam,
      lt_keys       TYPE /bobf/t_frw_key,
      lt_data       TYPE /scmtms/t_tor_root_k,
      lt_mod        TYPE /bobf/t_frw_modification,
      lt_return     TYPE bapiret2_t.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera somente as Ordens de Frete que não estão com status atualizado
* ---------------------------------------------------------------------------
    SELECT municipio~*
      FROM zi_tm_mdf_municipio AS municipio
      LEFT OUTER JOIN zi_tm_vh_ordem_frete AS of
      ON of~ordemfrete = municipio~freightorder
      WHERE municipio~guid         EQ @is_mdf-id
        AND municipio~freightorder IS NOT INITIAL
        AND of~statuscode          NE @is_mdfehd-statcod
      INTO TABLE @DATA(lt_municipio).         "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    TRY.
        DATA(lo_tor_mgr)    = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
        DATA(lo_bo_config)  = /bobf/cl_frw_factory=>get_configuration( /scmtms/if_tor_c=>sc_bo_key ).
        DATA(lo_txn_tor)   = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
      CATCH /bobf/cx_frw.
        RETURN.
    ENDTRY.

    lt_parameters[] = VALUE #( FOR ls_mun IN lt_municipio ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-qdb_torid-tor_id
                                                            sign           = 'I'
                                                            option         = 'EQ'
                                                            low            = ls_mun-freightorder ) ).

    CALL METHOD lo_tor_mgr->query
      EXPORTING
        iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
        it_selection_parameters = lt_parameters
        iv_fill_data            = abap_true
      IMPORTING
        et_key                  = lt_keys
        et_data                 = lt_data
        eo_message              = DATA(lo_message).

    IF NOT lo_message IS INITIAL.
      FREE: lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return ).
      INSERT LINES OF lt_return INTO TABLE et_return.
    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      <fs_data>-zz_mdf  = is_mdf-mdfenum.
      <fs_data>-zz_code = is_mdfehd-statcod.
    ENDLOOP.

    " Atualiza campos da Ordem de Frete
    TRY.
        zcltm_manage_of=>change_of( CHANGING cs_root = <fs_data> ).
      CATCH cx_root.
    ENDTRY.

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       it_data        = lt_data
                                              CHANGING ct_mod         = lt_mod ).


    lo_tor_mgr->modify( EXPORTING it_modification = lt_mod
                        IMPORTING eo_change  = DATA(lo_change)
                                  eo_message = lo_message ).

*    IF NOT lo_message IS INITIAL.
*      FREE: lt_return.
*      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
*                                                             CHANGING  ct_bapiret2 = et_return[] ).
*      INSERT LINES OF lt_return INTO TABLE et_return.
*    ENDIF.

    lo_txn_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected         = DATA(lv_rejected)
                                eo_change           = lo_change
                                eo_message          = DATA(lo_message_save)
                                et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).


    IF NOT lo_message_save IS INITIAL.
      FREE: lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
                                                             CHANGING  ct_bapiret2 = lt_return[] ).
      INSERT LINES OF lt_return INTO TABLE et_return.
    ENDIF.

  ENDMETHOD.


  METHOD update_mdf_using_fo.

    DATA: lt_freight_order TYPE ty_t_freight_order,
          lt_access_key    TYPE ty_t_access_key,

          lt_municipio_del TYPE ty_tab_municipio,
          lt_placa_del     TYPE ty_tab_placa.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera dados MDF se necessário
* ---------------------------------------------------------------------------
    IF is_mdf IS NOT INITIAL.

      DATA(ls_mdf) = is_mdf.

    ELSEIF iv_id IS NOT INITIAL.

      SELECT SINGLE *
        FROM zttm_mdf
        INTO @ls_mdf
        WHERE id = @iv_id.

      IF sy-subrc NE 0.
        FREE ls_mdf.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Somente continuar para MDF-e com processo automático
* ---------------------------------------------------------------------------
*    IF ls_mdf-manual IS NOT INITIAL.
*      RETURN.
*    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Motorista
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zi_tm_mdf_motorista
        WHERE id EQ @iv_id
        INTO @DATA(ls_motorista).             "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE ls_motorista.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Placa
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_placa
        WHERE id EQ @iv_id
        INTO TABLE @DATA(lt_placa).           "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_placa.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados MDF-e - Notas Transportadas
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_mdf_municipio
        WHERE guid EQ @ls_mdf-id
        INTO TABLE @DATA(lt_municipio).       "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      FREE lt_municipio.
    ENDIF.

    LOOP AT lt_municipio REFERENCE INTO DATA(ls_municipio).

      IF ls_municipio->ordemfrete IS NOT INITIAL AND ls_municipio->ordemfrete NE '00000000000000000000'.
        lt_freight_order[] = VALUE #( BASE lt_freight_order ( ls_municipio->ordemfrete ) ).
      ENDIF.

      IF ( ls_municipio->ordemfrete IS INITIAL OR ls_municipio->ordemfrete EQ '00000000000000000000' )
      AND ls_municipio->accesskey IS NOT INITIAL.
        lt_access_key[] = VALUE #( BASE lt_access_key ( ls_municipio->accesskey ) ).
      ENDIF.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Gera novamente os dados MDF a partir de uma Ordem de frete e Chave de acesso
* ---------------------------------------------------------------------------
    me->get_data_fo_to_mdf( EXPORTING iv_id              = ls_mdf-id
                                      it_freight_order   = lt_freight_order
                                      it_access_key      = lt_access_key
                            IMPORTING et_municipio       = DATA(lt_municipio_new)
                                      es_motorista       = DATA(ls_motorista_new)
                                      et_placa           = DATA(lt_placa_new)
                                      et_return          = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE et_return[].
    CHECK NOT line_exists( lt_return[ type = 'E ' ] ).   "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Valida se houve alteração
* ---------------------------------------------------------------------------
    IF ls_motorista_new-motorista IS NOT INITIAL.
      IF ls_motorista-motorista EQ ls_motorista_new-motorista.
        FREE ls_motorista_new.
      ELSE.
        " Informações de Motorista atualizado com sucesso da Ordem de Frete.
        et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '107' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva os novos dados
* ---------------------------------------------------------------------------
    me->save( EXPORTING it_municipio    = lt_municipio_new
                        is_motorista    = ls_motorista_new
                        it_placa        = lt_placa_new
              IMPORTING et_return       = lt_return ).

    INSERT LINES OF lt_return INTO TABLE et_return[].
    CHECK NOT line_exists( lt_return[ type = 'E ' ] ).   "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Remove registros antigos
* ---------------------------------------------------------------------------
    SORT lt_municipio BY guid accesskey ordemfrete.
    SORT lt_municipio_new BY guid accesskey ordemfrete.

    LOOP AT lt_municipio REFERENCE INTO ls_municipio.

      READ TABLE lt_municipio_new REFERENCE INTO DATA(ls_municipio_new) WITH KEY guid       = ls_municipio->guid
                                                                                 accesskey  = ls_municipio->accesskey
                                                                                 ordemfrete = ls_municipio->ordemfrete
                                                                                 BINARY SEARCH.
      CHECK sy-subrc NE 0.

      lt_municipio_del = VALUE #( BASE lt_municipio_del ( id          = ls_municipio->guid
                                                          access_key  = ls_municipio->accesskey
                                                          ordem_frete = ls_municipio->ordemfrete ) ).
    ENDLOOP.

    SORT lt_placa BY id placa.
    SORT lt_placa_new BY id placa.

    IF lt_placa_new[] IS NOT INITIAL.
      LOOP AT lt_placa REFERENCE INTO DATA(ls_placa).

        READ TABLE lt_placa_new REFERENCE INTO DATA(ls_placa_new) WITH KEY id    = ls_placa->id
                                                                           placa = ls_placa->placa
                                                                           BINARY SEARCH.
        CHECK sy-subrc NE 0.

        lt_placa_del = VALUE #( BASE lt_placa_del ( id    = ls_placa->id
                                                    placa = ls_placa->placa ) ).

      ENDLOOP.
    ENDIF.

    IF lt_municipio_del IS NOT INITIAL.
      DELETE zttm_mdf_mcd FROM TABLE lt_municipio_del[].
      " Informações de Notas atualizadas com sucesso da Ordem de Frete.
      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '108' ) ).
*    ELSEIF lt_municipio_del IS INITIAL AND lt_municipio IS NOT INITIAL.
*      " Informações de Notas atualizadas com sucesso da Ordem de Frete.
*      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '108' ) ).
    ENDIF.

    IF lt_placa_del IS NOT INITIAL.
      DELETE zttm_mdf_placa FROM TABLE lt_placa_del[].
      " Informações de Placas atualizadas com sucesso da Ordem de Frete.
      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '109' ) ).
*    ELSEIF lt_placa_del IS INITIAL AND lt_placa IS NOT INITIAL.
*      " Informações de Placas atualizadas com sucesso da Ordem de Frete.
*      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '109' ) ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
