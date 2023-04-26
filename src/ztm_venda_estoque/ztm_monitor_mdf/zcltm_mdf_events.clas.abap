"!<p><h2>Rotinas de tratamento dos eventos do MDF-e</h2></p>
"!<p><strong>Autor:</strong>Guido Olivan</p>
"!<p><strong>Data:</strong>11 de nov de 2021</p>
CLASS zcltm_mdf_events DEFINITION INHERITING FROM cl_abap_behv
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_reported          TYPE RESPONSE FOR REPORTED EARLY zc_tm_mdf_cockpit.

    "!Mensagem de erro
    CLASS-DATA gv_msg_e TYPE bapi_mtype VALUE 'E' ##NO_TEXT.
    "!Mensagem de status
    CLASS-DATA gv_msg_s TYPE bapi_mtype VALUE 'S' ##NO_TEXT.
    "Mensagem de advertência
    CLASS-DATA gv_msg_w TYPE bapi_mtype VALUE 'W' ##NO_TEXT.

    CLASS-METHODS get_messages
      EXPORTING
        !et_return TYPE bapiret2_t .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
    "! Numerar e Enviar MDF-e à Sefaz
    "! @parameter iv_docnum | Nº do agrupador
    "! @parameter iv_id | Id (Guid) do agrupador
    "! @parameter ev_statuscode | Novo status
    "! @parameter rt_return | Mensagens de processamento
    CLASS-METHODS mdf_send_background
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !iv_id           TYPE sysuuid_x16 OPTIONAL
        !iv_resend       TYPE /xnfe/resend OPTIONAL
      EXPORTING
        !ev_statuscode   TYPE /xnfe/statuscode
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Numerar e Enviar MDF-e à Sefaz
    "! @parameter iv_docnum | Nº do agrupador
    "! @parameter iv_id | Id (Guid) do agrupador
    "! @parameter ev_statuscode | Novo status
    "! @parameter rt_return | Mensagens de processamento
    CLASS-METHODS mdf_send
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !iv_id           TYPE sysuuid_x16 OPTIONAL
        !iv_resend       TYPE /xnfe/resend OPTIONAL
      EXPORTING
        !ev_statuscode   TYPE /xnfe/statuscode
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Efetuar o cancelamento de um MDF-e
    "! @parameter iv_docnum |Nº do agrupador
    "! @parameter iv_id |Id (Guid) do agrupador
    "! @parameter ev_statuscode | Novo status
    "! @parameter rt_return |Mensagens de processamento
    CLASS-METHODS mdf_cancel
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !iv_id           TYPE sysuuid_x16 OPTIONAL
      EXPORTING
        !ev_statuscode   TYPE /xnfe/statuscode
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Efetuar o encerramento de um MDF-e
    "! @parameter iv_docnum |Nº do agrupador
    "! @parameter iv_id |Id (Guid) do agrupador
    "! @parameter ev_statuscode | Novo status
    "! @parameter rt_return |Mensagens de processamento
    CLASS-METHODS mdf_close
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !iv_id           TYPE sysuuid_x16 OPTIONAL
      EXPORTING
        !ev_statuscode   TYPE /xnfe/statuscode
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Alteração do nome do motorista no MDF-e
    "! @parameter iv_docnum |Nº do agrupador
    "! @parameter is_parameters |Parâmetros do motorista
    "! @parameter iv_id |Id (Guid) do agrupador
    "! @parameter rt_return |Mensagens de processamento
    CLASS-METHODS mdf_driver_change_background
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !is_parameters   TYPE zc_tm_mdf_motorista_popup
        !iv_id           TYPE sysuuid_x16 OPTIONAL
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Alteração do nome do motorista no MDF-e
    "! @parameter iv_docnum |Nº do agrupador
    "! @parameter is_parameters |Parâmetros do motorista
    "! @parameter iv_id |Id (Guid) do agrupador
    "! @parameter rt_return |Mensagens de processamento
    CLASS-METHODS mdf_driver_change
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !is_parameters   TYPE zc_tm_mdf_motorista_popup
        !iv_id           TYPE sysuuid_x16 OPTIONAL
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Converter mensagem simples em tabela padrão de retorno
    "! @parameter ct_return | Tabela de mensagens no formato padrão
    CLASS-METHODS mdf_catalog_message
      IMPORTING
        !iv_type       TYPE bapi_mtype
        !iv_id         TYPE symsgid
        !iv_number     TYPE symsgno
        !iv_message_v1 TYPE symsgv OPTIONAL
        !iv_message_v2 TYPE symsgv OPTIONAL
        !iv_message_v3 TYPE symsgv OPTIONAL
        !iv_message_v4 TYPE symsgv OPTIONAL
      CHANGING
        !ct_return     TYPE bapiret2_t .
    "! Ler informações do business partner
    "! @parameter iv_partner | Código do parceiro
    "! @parameter rs_bp | Estrutura com os dados do parceiro
    CLASS-METHODS read_bp
      IMPORTING
        !iv_partner  TYPE bu_partner
      RETURNING
        VALUE(rs_bp) TYPE zi_ca_vh_partner_pf .
    "! Ler o histórico de envios do MDF-e
    "! @parameter iv_id |Id (Guid) do agrupador
    "! @parameter rt_return |Mensagens de processamento
    CLASS-METHODS mdf_history
      IMPORTING
        !iv_id           TYPE sysuuid_x16
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Ler o status de processamento do MDF-e
    "! @parameter iv_docnum |Nº do agrupador
    "! @parameter iv_id |Id (Guid) do agrupador
    "! @parameter es_mdfehd |Cabeçalho do MDF
    "! @parameter es_event |Evento processado
    "! @parameter rt_return |Mensagens de processamento
    CLASS-METHODS mdf_status
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum OPTIONAL
        !iv_id           TYPE sysuuid_x16 OPTIONAL
      EXPORTING
        !es_mdfehd       TYPE /xnfe/outmdfehd
        !es_event        TYPE /xnfe/events
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Atualização de status do MDF
    "! @parameter is_mdfehd |Cabeçalho do MDF
    "! @parameter is_event |Evento processado
    "! @parameter iv_id |Id (Guid) do agrupador
    CLASS-METHODS mdf_status_update
      IMPORTING
        !is_mdfehd TYPE /xnfe/outmdfehd
        !is_event  TYPE /xnfe/events OPTIONAL
        !iv_id     TYPE sysuuid_x16 .
    "! Criação da chave de acesso do MDF-e
    "! @parameter is_zttm_mdf |Cabeçalho do MDF
    "! @parameter is_zttm_mdf_ide |Detalhes do MDF
    "! @parameter rs_access_key |Chave de acesso
    CLASS-METHODS accesskey_create
      IMPORTING
        !is_zttm_mdf         TYPE zi_tm_mdf
        !is_zttm_mdf_ide     TYPE zttm_mdf_ide
        !iv_cnpj             TYPE /xnfe/cnpj
      RETURNING
        VALUE(rs_access_key) TYPE j_1b_nfe_access_key .
    "! Criar número aleatório para a chave de acesso
    "! @parameter rv_randomnum |Nº aleatório gerado
    CLASS-METHODS ramdom_num_create
      RETURNING
        VALUE(rv_randomnum) TYPE /xnfe/mdfe_cnf .
    "! Obter o número de controle (interno) do MDF-e
    "! @parameter rv_docnum |Novo nº criado para MDF-e (interno)
    CLASS-METHODS doc_mdfe_create
      EXPORTING
        !et_return       TYPE bapiret2_t
      RETURNING
        VALUE(rv_docnum) TYPE j_1bdocnum .
    "! Obter o número do MDF-e a ser enviado à Sefaz (externo)
    "! @parameter is_zttm_mdf |Cabeçalho do MDF
    "! @parameter rv_mdfenum |Novo nº criado para MDF-e (externo)
    CLASS-METHODS num_mdfe_create
      IMPORTING
        !is_zttm_mdf      TYPE zi_tm_mdf
      EXPORTING
        !et_return        TYPE bapiret2_t
      RETURNING
        VALUE(rv_mdfenum) TYPE zi_tm_mdf-br_mdfenumber .

    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING it_return   TYPE bapiret2_t
      EXPORTING es_reported TYPE ty_reported.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA gt_return TYPE bapiret2_t .
    CLASS-DATA gv_wait_async TYPE abap_bool .
ENDCLASS.



CLASS zcltm_mdf_events IMPLEMENTATION.


  METHOD accesskey_create.

    DATA: ls_access_key TYPE j_1b_nfe_access_key.

*    SELECT SINGLE txjcd INTO @DATA(lv_txjcd)
*      FROM t001w
*      WHERE werks = @is_zttm_mdf-rntrc.
*
*    SELECT docnum INTO @DATA(lv_docnum_ref)
*      FROM zttm_mdf
*      UP TO 1 ROWS
*      WHERE id = @is_zttm_mdf-Guid.
*    ENDSELECT.

    DATA(lv_ano) = sy-datum+2(2).
    DATA(lv_mes) = sy-datum+4(2).

    DATA(lv_changetype) = is_zttm_mdf_ide-c_mdf + 100000000.

*    ls_access_key-regio   = lv_txjcd+3(2).
    ls_access_key-regio   = is_zttm_mdf-domfiscalinicio+3(2).
    ls_access_key-nfyear  = lv_ano.
    ls_access_key-nfmonth = lv_mes.
    ls_access_key-stcd1   = iv_cnpj.
    ls_access_key-model   = '58'.
    ls_access_key-serie   = is_zttm_mdf-br_mdfeseries.
    ls_access_key-nfnum9  = is_zttm_mdf-br_mdfenumber.
    ls_access_key-docnum9 = lv_changetype.

    CALL FUNCTION 'J_1B_NFE_CREATE_CHECK_DIGIT'
      CHANGING
        c_acckey = ls_access_key.

    rs_access_key = ls_access_key.
  ENDMETHOD.


  METHOD mdf_cancel.

    DATA:
      lt_index_rows	TYPE lvc_t_row,
      lt_row_no	    TYPE lvc_t_roid.

    DATA:
      lr_seqevento_in TYPE RANGE OF /xnfe/ev_nseqevento.

    DATA:
      lv_access_key   TYPE /xnfe/id,
      lv_docnum       TYPE /xnfe/docnum          VALUE '000000000',
      lv_event_type   TYPE /xnfe/ev_tpevento     VALUE '110111',
      lv_int_seq_numb TYPE /xnfe/ev_nseqevento,
      lv_timestamp    TYPE timestampl,
      lv_timezone     TYPE tznzone               VALUE 'BRZLWE',
      lv_cuf          TYPE /xnfe/cuf,
      lv_cmun         TYPE /xnfe/cmun,
      lv_dtenc        TYPE /xnfe/dtenc,
      lv_resend       TYPE /xnfe/resend,
      lv_error_status TYPE /xnfe/ev_error_status,
      lv_message      TYPE bapi_msg,
      lt_return       TYPE bapirettab.

    FREE: ev_statuscode.

    SELECT SINGLE * INTO @DATA(ls_mdf)
      FROM zttm_mdf
      WHERE id = @iv_id.

*    IF ls_mdf IS INITIAL.
*      mdf_catalog_message( EXPORTING iv_type       = gv_msg_e
*                                     iv_id         = 'ZTM_MDF'
*                                     iv_number     = '031'
*                                     iv_message_v1 = CONV #( iv_docnum )
*                           CHANGING  ct_return     =  rt_return ).
*      RETURN.
*    ENDIF.
*
*    mdf_status( EXPORTING iv_id     = ls_mdf-id
*                IMPORTING es_mdfehd = DATA(ls_mdfehd) ).
*
*    ev_statuscode = ls_mdfehd-statcod.
*
*    CASE ls_mdfehd-statcod.
*      WHEN '132'.
*      WHEN '101'.
*      WHEN OTHERS.
*    ENDCASE.

    ev_statuscode = ls_mdf-statcod.

    SELECT MAX( nseqevento_int )
       FROM /xnfe/events
       INTO @DATA(lv_nseqevento)
       WHERE chnfe    EQ @ls_mdf-access_key
         AND tpevento EQ @lv_event_type.

    IF sy-subrc IS INITIAL.
      lv_int_seq_numb = lv_nseqevento + 1.
    ENDIF.

    GET TIME STAMP FIELD lv_timestamp.
    lv_access_key   = ls_mdf-access_key.
    lv_resend       = space.
    lv_docnum       = ls_mdf-docnum.

    CALL FUNCTION '/XNFE/EV_ISSUE_MDFE_CANCEL' DESTINATION 'NONE'
*    DESTINATION gv_destination
      EXPORTING
        iv_access_key               = lv_access_key
        iv_docnum                   = lv_docnum
        iv_event_type               = lv_event_type
        iv_internal_sequence_number = lv_int_seq_numb
        iv_timestamp                = lv_timestamp
        iv_timezone                 = lv_timezone
        iv_xjust                    = 'Cancelamento MDF-e'(t03)
        iv_resend                   = lv_resend
      IMPORTING
        ev_error_status             = lv_error_status
        et_bapiret2                 = rt_return.

*    IF NOT line_exists( rt_return[ type = gv_msg_e ] ).  "#EC CI_STDSEQ
*      " Recupera novo status
*      mdf_status( EXPORTING iv_id     = ls_mdf-id
*                  IMPORTING es_mdfehd = ls_mdfehd ).
*
*      ev_statuscode = ls_mdfehd-statcod.
*    ENDIF.

  ENDMETHOD.


  METHOD mdf_close.

    DATA:
      lt_index_rows TYPE lvc_t_row,
      lt_row_no     TYPE lvc_t_roid.

    DATA:
      lr_seqevento_in TYPE RANGE OF /xnfe/ev_nseqevento.

    DATA:
      lv_access_key   TYPE /xnfe/id,
      lv_docnum       TYPE /xnfe/docnum          VALUE '000000000',
      lv_event_type   TYPE /xnfe/ev_tpevento     VALUE '110112',
      lv_int_seq_numb TYPE /xnfe/ev_nseqevento,
      lv_timestamp    TYPE timestampl,
      lv_timezone     TYPE tznzone               VALUE 'BRZLWE',
      lv_cuf          TYPE /xnfe/cuf,
      lv_cmun         TYPE /xnfe/cmun,
      lv_dtenc        TYPE /xnfe/dtenc,
      lv_resend       TYPE /xnfe/resend,
      lv_error_status TYPE /xnfe/ev_error_status,
      lv_message      TYPE bapi_msg,
      lt_return       TYPE bapirettab.

    FREE: ev_statuscode, rt_return.

    SELECT SINGLE *
      FROM zi_tm_mdf
      WHERE guid = @iv_id
      INTO @DATA(ls_mdf).

    IF ls_mdf IS INITIAL.
      mdf_catalog_message( EXPORTING iv_type       = gv_msg_e
                                     iv_id         = 'ZTM_MDF'
                                     iv_number     = '031'
                                     iv_message_v1 = CONV #( iv_docnum )
                           CHANGING  ct_return     =  rt_return ).
      RETURN.
    ENDIF.

*    mdf_status( EXPORTING iv_id     = ls_mdf-id
*                IMPORTING es_mdfehd = DATA(ls_mdfehd) ).
*
*    ev_statuscode = ls_mdfehd-statcod.
*
*    CASE ls_mdfehd-statcod.
*      WHEN '132'.
*      WHEN '101'.
*      WHEN OTHERS.
*    ENDCASE.

    SELECT MAX( nseqevento_int )
       FROM /xnfe/events
       INTO @DATA(lv_nseqevento)
       WHERE chnfe    EQ @ls_mdf-accesskey
         AND tpevento EQ @lv_event_type.

    IF sy-subrc IS INITIAL.
      lv_int_seq_numb = lv_nseqevento + 1.
    ENDIF.

    GET TIME STAMP FIELD lv_timestamp.
    lv_access_key   = ls_mdf-accesskey.
    lv_resend       = space.
    lv_docnum       = ls_mdf-agrupador.
    lv_cuf          = ls_mdf-accesskey(2).
    lv_cmun         = ls_mdf-domfiscalinicio+3(7).
    lv_dtenc        = sy-datum.

    CALL FUNCTION '/XNFE/EV_ISSUE_MDFE_CLOSE' DESTINATION 'NONE'
*    DESTINATION gv_destination
      EXPORTING
        iv_access_key               = lv_access_key
        iv_docnum                   = lv_docnum
        iv_event_type               = lv_event_type
        iv_internal_sequence_number = lv_int_seq_numb
        iv_timestamp                = lv_timestamp
        iv_timezone                 = lv_timezone
        iv_cuf                      = lv_cuf
        iv_cmun                     = lv_cmun
        iv_dtenc                    = lv_dtenc
        iv_resend                   = lv_resend
      IMPORTING
        ev_error_status             = lv_error_status
        et_bapiret2                 = rt_return.

*    IF NOT line_exists( rt_return[ type = gv_msg_e ] ).  "#EC CI_STDSEQ
*      " Recupera novo status
*      mdf_status( EXPORTING iv_id     = ls_mdf-id
*                  IMPORTING es_mdfehd = ls_mdfehd ).
*
*      ev_statuscode = ls_mdfehd-statcod.
*    ENDIF.

  ENDMETHOD.


  METHOD mdf_catalog_message.

    DATA(ls_return) = VALUE bapiret2( id         = iv_id
                                      type       = iv_type
                                      number     = iv_number
                                      message_v1 = iv_message_v1
                                      message_v2 = iv_message_v2
                                      message_v3 = iv_message_v3
                                      message_v4 = iv_message_v4 ).

    TRY.
        CALL FUNCTION 'FORMAT_MESSAGE'
          EXPORTING
            id        = ls_return-id
            lang      = sy-langu
            no        = ls_return-number
            v1        = ls_return-message_v1
            v2        = ls_return-message_v2
            v3        = ls_return-message_v3
            v4        = ls_return-message_v4
          IMPORTING
            msg       = ls_return-message
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.

        IF sy-subrc <> 0.
          CLEAR ls_return-message.
        ENDIF.

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = lo_root->get_longtext( ).
    ENDTRY.

    APPEND ls_return TO ct_return.

  ENDMETHOD.


  METHOD mdf_driver_change_background.

    FREE: gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_MDF_DRIVER_CHANGE'
      STARTING NEW TASK 'MDF_DRIVER_CHANGE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_docnum     = iv_docnum
        is_parameters = is_parameters
        iv_id         = iv_id.

    WAIT UNTIL gv_wait_async = abap_true.
    rt_return = gt_return.

  ENDMETHOD.


  METHOD mdf_driver_change.

    DATA:
      lt_party      TYPE /scmtms/t_tor_party_k,
      lt_parameters TYPE /bobf/t_frw_query_selparam,
      lt_keys       TYPE /bobf/t_frw_key,
      lt_data       TYPE /scmtms/t_tor_root_k,
      lt_mod        TYPE /bobf/t_frw_modification.

    DATA:
      lv_access_key               TYPE j_1b_nfe_access_key_dtel44,
      lv_docnum                   TYPE j_1bdocnum,
      lv_event_type               TYPE /xnfe/ev_tpevento,
      lv_internal_sequence_number TYPE numc2,
      lv_timestamp                TYPE timestampl,
      lv_timezone                 TYPE tznzone VALUE 'BRZLWE',
      lv_xname                    TYPE c LENGTH 60,
      lv_cpf                      TYPE char11,
      lv_error_status             TYPE /xnfe/ev_error_status, "/xnfe/ev_tpevento,
      lt_return                   TYPE bapiret2_t,
      ls_return                   TYPE bapiret2,
      lv_returncode               TYPE c.

    DATA:
      lv_docref   TYPE  char10,
      lo_message  TYPE REF TO /bobf/if_frw_message,
      lv_rejected TYPE boole_d.

    FREE: rt_return.

* ---------------------------------------------------------------------------
* Recupera e solicita troca de motorista (se existir MDF-e)
* ---------------------------------------------------------------------------
    SELECT SINGLE id, docnum, access_key, mdfenum, statcod
      FROM zttm_mdf
      INTO @DATA(ls_mdf)
      WHERE id = @iv_id.

    IF ls_mdf-mdfenum IS NOT INITIAL AND ls_mdf-statcod = '100'.

      lv_access_key               = ls_mdf-access_key.
      lv_docnum                   = ls_mdf-docnum.
      lv_event_type               = '110114'.

      SELECT MAX( nseqevento_int )
         FROM /xnfe/events
         INTO @DATA(lv_nseqevento)
         WHERE chnfe    EQ @ls_mdf-access_key
           AND tpevento EQ @lv_event_type.

      IF sy-subrc IS INITIAL.
        lv_internal_sequence_number = lv_nseqevento + 1.
      ENDIF.

      GET TIME STAMP FIELD lv_timestamp.

      DATA(ls_bp)   = read_bp( is_parameters-motorista ).
      lv_xname      = ls_bp-nome.
      lv_cpf        = ls_bp-cpf.

      CALL FUNCTION '/XNFE/EV_ISSUE_MDFE_ADD_DRIVER' DESTINATION 'NONE'
        EXPORTING
          iv_access_key               = lv_access_key
          iv_docnum                   = lv_docnum
          iv_event_type               = lv_event_type
          iv_internal_sequence_number = lv_internal_sequence_number
          iv_timestamp                = lv_timestamp
          iv_timezone                 = lv_timezone
          iv_xnome                    = lv_xname
          iv_cpf                      = lv_cpf
        IMPORTING
          ev_error_status             = lv_error_status
          et_bapiret2                 = lt_return.

      IF line_exists( lt_return[ type = 'E' ] ).

        FREE: lt_return.
        CALL FUNCTION '/XNFE/EV_ISSUE_MDFE_ADD_DRIVER' DESTINATION 'NONE'
          EXPORTING
            iv_access_key               = lv_access_key
            iv_docnum                   = lv_docnum
            iv_event_type               = lv_event_type
            iv_internal_sequence_number = lv_internal_sequence_number
            iv_timestamp                = lv_timestamp
            iv_timezone                 = lv_timezone
            iv_xnome                    = lv_xname
            iv_cpf                      = lv_cpf
            iv_resend                   = abap_true
          IMPORTING
            ev_error_status             = lv_error_status
            et_bapiret2                 = lt_return.

      ENDIF.

      APPEND LINES OF lt_return TO rt_return.

      IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'W' ] ).
        " Falha ao enviar solicitação de troca de motorista à SEFAZ.
        rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '102' ) ).
        RETURN.
      ELSE.
        " Solicitação de troca de motorista enviado à SEFAZ.
        rt_return = VALUE #( BASE rt_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '101' ) ).
      ENDIF.

    ELSE.
      " Somente é possível a troca de motorista para documentos autorizados.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_MONITOR_MDF' number = '105' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Notas Fiscais com Ordem de Frete
* ---------------------------------------------------------------------------
    SELECT *
      FROM zi_tm_mdf_municipio
      WHERE guid          EQ @iv_id
        AND freightorder IS NOT INITIAL
      INTO TABLE @DATA(lt_zttm_mdf_mcd).      "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    TRY.
        DATA(lo_tor_srvmgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
        DATA(lo_bo_config)  = /bobf/cl_frw_factory=>get_configuration( /scmtms/if_tor_c=>sc_bo_key ).
        DATA(lo_txn_mngr)   = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
      CATCH /bobf/cx_frw.
        RETURN.
    ENDTRY.

    SORT lt_zttm_mdf_mcd BY freightorder.

    LOOP AT lt_zttm_mdf_mcd INTO DATA(ls_mdf_mcd). "#EC CI_LOOP_INTO_WA
      APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameter>).
      <fs_parameter>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-qdb_torid-tor_id.
      <fs_parameter>-sign           = 'I'.
      <fs_parameter>-option         = 'EQ'.
      <fs_parameter>-low            = ls_mdf_mcd-freightorder.
    ENDLOOP.

    CALL METHOD lo_tor_srvmgr->query
      EXPORTING
        iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
        it_selection_parameters = lt_parameters
        iv_fill_data            = abap_true
      IMPORTING
        et_key                  = lt_keys
        et_data                 = lt_data.

* ---------------------------------------------------------------------------
* Atualiza motorista no cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      <fs_data>-zz_motorista = is_parameters-motorista.
    ENDLOOP.

    /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
                                                       iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                       it_data        = lt_data
                                              CHANGING ct_mod         = lt_mod ).

    lo_tor_srvmgr->modify( EXPORTING it_modification = lt_mod
                           IMPORTING eo_change  = DATA(lo_change)
                                     eo_message = lo_message ).

    lo_txn_mngr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                       IMPORTING ev_rejected         = lv_rejected
                                 eo_change           = lo_change
                                 eo_message          = lo_message
                                 et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).

    IF NOT lo_message IS INITIAL.
      CLEAR lt_return.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = lt_return[] ).

      DATA(lt_return_i) = lt_return.

      DATA(lo_events) = NEW zcltm_mdf_events_manual( ).
      lo_events->format_message( EXPORTING iv_change_error_type   = abap_true
                                           iv_change_warning_type = abap_true
                                 CHANGING  ct_return              = lt_return_i ).

      APPEND LINES OF lt_return_i TO rt_return.
    ENDIF.

    IF line_exists( lt_return[ type = 'E' ] ) OR line_exists( lt_return[ type = 'W' ] ).
      " Falha ao atualizar motorista na Ordem de Frete.
      rt_return = VALUE #( BASE rt_return ( type = 'I' id = 'ZTM_MONITOR_MDF' number = '100' ) ).
    ELSE.
      " Motorista atualizado na Ordem de Frete.
      rt_return = VALUE #( BASE rt_return ( type = 'S' id = 'ZTM_MONITOR_MDF' number = '099' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* ATENÇÃO: SOLUÇÃO ABAIXO OBSOLETA
* ---------------------------------------------------------------------------
* Existe um enhancement que chama a classe ZCLTM_MOTORISTA_TOR
* Ela busca o motorista do ROOT-ZZ_MOTORISTA e transfere na linha da PARTY = 'YM'
* ---------------------------------------------------------------------------
*    lo_tor_srvmgr->retrieve_by_association( EXPORTING iv_node_key     = /scmtms/if_tor_c=>sc_node-root
*                                                      it_key          = lt_keys
*                                                      iv_association  = /scmtms/if_tor_c=>sc_association-root-party
*                                                      iv_fill_data    = abap_true
*                                            IMPORTING et_data         = lt_party ).
*
**    DELETE lt_party WHERE party_rco <> 'ZM' AND party_rco <> 'YM'. "#EC CI_SORTSEQ "O campo party_rco não faz parte dos índices da tabela
*
*    LOOP AT lt_party ASSIGNING FIELD-SYMBOL(<fs_party>).
*      " Atualiza informação de motorista
*      <fs_party>-party_id   = is_parameters-motorista.
*    ENDLOOP.
*
*    IF lt_party IS NOT INITIAL.
*
*      /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-party
*                                                         iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                         it_data        = lt_party
*                                                CHANGING ct_mod         = lt_mod ).
*
*      lo_tor_srvmgr->modify( EXPORTING it_modification = lt_mod
*                             IMPORTING eo_change  = lo_change
*                                       eo_message = lo_message ).
*
*      " Salva valores modificados
*      lo_txn_mngr->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                         IMPORTING ev_rejected         = lv_rejected
*                                   eo_change           = lo_change
*                                   eo_message          = lo_message
*                                   et_rejecting_bo_key = ls_rejecting_bo_key ).
*
*      IF NOT lo_message IS INITIAL.
*        CLEAR lt_return.
*        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
*                                                               CHANGING  ct_bapiret2 = lt_return[] ).
*
*
*        APPEND LINES OF lt_return TO rt_return.
*      ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD mdf_history.

    DATA:
      lv_access_key TYPE  /xnfe/id,

      ls_mdfehd     TYPE  /xnfe/outmdfehd,
      ls_xml_mdfe   TYPE  /xnfe/outmdfexml,
      lt_hdsta      TYPE  /xnfe/outhdsta_t,
      lt_hist       TYPE  /xnfe/outhist_t,
      lt_symsg      TYPE  /xnfe/symsg_t,
      lv_histcount  TYPE  /xnfe/histcount,

      lt_return     TYPE bapiret2_t,
      ls_return     TYPE bapiret2.


    DATA:
      lt_index_rows	TYPE lvc_t_row,
      lt_row_no	    TYPE lvc_t_roid.

    SELECT SINGLE access_key INTO @DATA(lv_ackey)
      FROM zttm_mdf
      WHERE id = @iv_id.

    CHECK sy-subrc IS INITIAL.

    lv_access_key = lv_ackey.

    CALL FUNCTION '/XNFE/OUTMDFE_READ_MFE_FOR_UPD'
      EXPORTING
        iv_mdfeid           = lv_access_key
      IMPORTING
        es_mdfehd           = ls_mdfehd
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
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    DELETE lt_symsg WHERE msgid IS INITIAL. "#EC CI_STDSEQ O campo msgid não faz parte da chave ou índice da tabela
    SORT lt_symsg BY histcount.

    LOOP AT lt_hist INTO DATA(ls_hist).            "#EC CI_LOOP_INTO_WA

      READ TABLE lt_symsg INTO DATA(ls_symsg) WITH KEY histcount = ls_hist-histcount. "#EC CI_STDSEQ O campo histcount não faz parte da chave

      CHECK sy-subrc = 0.

      mdf_catalog_message( EXPORTING iv_type       = gv_msg_s
                                     iv_id         = ls_symsg-msgid
                                     iv_number     = ls_symsg-msgno
                                     iv_message_v1 = ls_symsg-msgv1
                                     iv_message_v2 = ls_symsg-msgv2
                                     iv_message_v3 = ls_symsg-msgv3
                                     iv_message_v4 = ls_symsg-msgv4
                           CHANGING  ct_return     =  rt_return ).
    ENDLOOP.


  ENDMETHOD.


  METHOD mdf_send.

    DATA:
      ls_mdfe_header         TYPE  /xnfe/if_mdfe_header_s,
      ls_mdfe_ide            TYPE  /xnfe/if_mdfe_ide_300_s,
      lt_mdfe_inf_percurso   TYPE  /xnfe/if_mdfe_inf_percurso_t,
      ls_mdfe_inf_percurso   LIKE LINE OF lt_mdfe_inf_percurso,

      lt_mdfe_inf_muncarrega TYPE  /xnfe/if_mdfe_inf_muncarrega_t,
      ls_mdfe_inf_muncarrega LIKE LINE OF lt_mdfe_inf_muncarrega,
      ls_mdfe_emit           TYPE  /xnfe/if_mdfe_emit_s,
      lt_mdfe_rodo_veic      TYPE  /xnfe/if_mdfe_rodo_veic_t,
      ls_mdfe_rodo_veic      LIKE LINE OF lt_mdfe_rodo_veic,
      lt_mdfe_rodo_prop      TYPE  /xnfe/if_mdfe_rodo_prop_t,
      ls_mdfe_rodo_prop      LIKE LINE OF lt_mdfe_rodo_prop,

      ls_mdfe_infmodal_rodo  TYPE  /xnfe/if_mdfe_rodo_300_s,

      lt_mdfe_rodo_condutor  TYPE  /xnfe/if_mdfe_rodo_condutor_t,
      ls_mdfe_rodo_condutor  LIKE LINE OF lt_mdfe_rodo_condutor,
      lt_mdfe_rodo_disp      TYPE  /xnfe/if_mdfe_rodo_disp_300_t,
      ls_mdfe_rodo_disp      LIKE LINE OF lt_mdfe_rodo_disp,
      lt_mdfe_inf_mundescarg TYPE  /xnfe/if_mdfe_inf_mundescarg_t,
      ls_mdfe_inf_mundescarg LIKE LINE OF lt_mdfe_inf_mundescarg,

      lt_mdfe_infunidtransp  TYPE /xnfe/if_cte_infunidtransp_t,
      ls_mdfe_infunidtransp  LIKE LINE OF lt_mdfe_infunidtransp,
      lt_mdfe_infunidcarga   TYPE /xnfe/if_cte_infunidcarga_t,
      ls_mdfe_infunidcarga   LIKE LINE OF lt_mdfe_infunidcarga,
      lt_mdfe_infnfe         TYPE  /xnfe/if_mdfe_infnfe_300_t,
      ls_mdfe_infnfe         LIKE LINE OF lt_mdfe_infnfe,
      ls_mdfe_tot            TYPE  /xnfe/if_mdfe_tot_s,

      lt_mdfe_autxml         TYPE  /xnfe/if_mdfe_autxml_t,
      ls_mdfe_autxml         LIKE LINE OF lt_mdfe_autxml,

      ls_mdfe_infresptec     TYPE  /xnfe/if_mdfe_infresptec_s,

      ls_mdfe_infadic        TYPE  /xnfe/if_mdfe_infadic_s,

      lv_error_status        TYPE  /xnfe/errstatus,

      lt_return              TYPE bapiret2_t.

*    DATA:
*      lt_parameters TYPE /bobf/t_frw_query_selparam,
*      lt_keys       TYPE /bobf/t_frw_key,
*      lt_data       TYPE /scmtms/t_tor_root_k,
*      lt_mod        TYPE /bobf/t_frw_modification.

    DATA:
      ls_address     TYPE sadr,
      ls_branch_data TYPE j_1bbranch,
      lv_cgc_number  TYPE j_1bwfield-cgc_number,
      ls_address1    TYPE addr1_val,

      lv_message     TYPE bapi_msg.

    DATA:
      lv_seq_no TYPE i,
      lv_id     TYPE i.

    FREE: ev_statuscode, rt_return.

* ---------------------------------------------------------------------------
* Recupera MDF-e - Dados de cabeçalho
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zi_tm_mdf
        WHERE guid = @iv_id
        INTO @DATA(ls_mdf).

    IF sy-subrc NE 0.
      mdf_catalog_message( EXPORTING iv_type       = gv_msg_e
                                     iv_id         = 'ZTM_MDF'
                                     iv_number     = '031'
                                     iv_message_v1 = CONV #( iv_docnum )
                           CHANGING  ct_return     =  rt_return ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica status do MDF-e
* ---------------------------------------------------------------------------
*    mdf_status( EXPORTING iv_id      = iv_id
*                IMPORTING es_mdfehd = DATA(ls_mdfehd) ).
*
*    ev_statuscode = ls_mdfehd-statcod.
*
*    CASE ls_mdfehd-statcod.
*      WHEN '132'.
*      WHEN '101'.
*      WHEN OTHERS.
*    ENDCASE.

* ---------------------------------------------------------------------------
* Recupera MDF-e - Dados complementares (IDE)
* ---------------------------------------------------------------------------
    SELECT SINGLE *
        FROM zttm_mdf_ide
        INTO @DATA(ls_mdf_ide)
        WHERE id = @iv_id.

    IF sy-subrc NE 0.
      FREE ls_mdf_ide.
    ENDIF.

    IF ls_mdf_ide-c_mdf IS INITIAL.
      ls_mdf_ide-c_mdf      = ramdom_num_create( ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera e preenche dados do Emitente
* ---------------------------------------------------------------------------
    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = ls_mdf-businessplace
        bukrs             = ls_mdf-companycode
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

    IF sy-subrc NE 0.
      CLEAR: ls_address, ls_branch_data, lv_cgc_number, ls_address1.
    ENDIF.

    CLEAR ls_mdfe_emit.
    ls_mdfe_emit-cnpj     = lv_cgc_number.
    TRANSLATE ls_branch_data-state_insc USING '- '. CONDENSE ls_branch_data-state_insc NO-GAPS.
    ls_mdfe_emit-ie       = ls_branch_data-state_insc.
    ls_mdfe_emit-x_nome   = |{ ls_address-name1 } { ls_address-name2 }|.
    ls_mdfe_emit-x_fant   = ls_branch_data-name.
    ls_mdfe_emit-x_lgr    = ls_address1-street.
    ls_mdfe_emit-nro      = ls_address1-house_num1.
    ls_mdfe_emit-x_cpl    = ls_address1-house_num2.
    ls_mdfe_emit-x_bairro = ls_address1-city2.
    ls_mdfe_emit-c_mun    = ls_address-txjcd.
    ls_mdfe_emit-x_mun    = ls_address1-city1.
    TRANSLATE ls_address1-post_code1 USING '- '. CONDENSE ls_address1-post_code1 NO-GAPS.
    ls_mdfe_emit-cep      = ls_address1-post_code1.
    ls_mdfe_emit-uf       = ls_address-regio.
    ls_mdfe_emit-fone     = ls_address-telf1.
    ls_mdfe_emit-email    = space.

* ---------------------------------------------------------------------------
* Gera novo número MDF-e
* ---------------------------------------------------------------------------
    IF ls_mdf-br_mdfenumber IS INITIAL.
      ls_mdf-br_mdfeseries     = '001'.
      ls_mdf-br_mdfenumber    = num_mdfe_create( EXPORTING is_zttm_mdf = ls_mdf
                                                 IMPORTING et_return   = rt_return ).
      ls_mdf-accesskey = accesskey_create( is_zttm_mdf = ls_mdf is_zttm_mdf_ide = ls_mdf_ide iv_cnpj = ls_mdfe_emit-cnpj ).
    ENDIF.

    IF rt_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    IF ls_mdf-createdby IS INITIAL.
      ls_mdf-createdby               = sy-uname.
      GET TIME STAMP FIELD ls_mdf-createdat.
      ls_mdf-lastchangedby          = ls_mdf-createdby.
      ls_mdf-lastchangedat          = ls_mdf-createdat.
      ls_mdf-locallastchangedat    = ls_mdf-createdat.
    ELSE.
      ls_mdf-lastchangedby          = sy-uname.
      GET TIME STAMP FIELD ls_mdf-lastchangedat.
      ls_mdf-locallastchangedat    = ls_mdf-lastchangedat.
    ENDIF.

    IF ls_mdf_ide-c_dv IS INITIAL.
      ls_mdf_ide-c_dv       = ls_mdf-accesskey+43(1).
    ENDIF.

    IF ls_mdf_ide-created_by IS INITIAL.
      ls_mdf_ide-created_by               = sy-uname.
      GET TIME STAMP FIELD ls_mdf_ide-created_at.
      ls_mdf_ide-last_changed_by          = ls_mdf_ide-created_by.
      ls_mdf_ide-last_changed_at          = ls_mdf_ide-created_at.
      ls_mdf_ide-local_last_changed_at    = ls_mdf_ide-created_at.
    ELSE.
      ls_mdf_ide-last_changed_by          = sy-uname.
      GET TIME STAMP FIELD ls_mdf_ide-last_changed_at.
      ls_mdf_ide-local_last_changed_at    = ls_mdf_ide-last_changed_at.
    ENDIF.

* ---------------------------------------------------------------------------
* Preenche dados de cabeçalho
* ---------------------------------------------------------------------------
    CLEAR ls_mdfe_header.
    ls_mdfe_header-rfc_version = '0001'.
    ls_mdfe_header-docnum      = ls_mdf-agrupador.
    ls_mdfe_header-logsys      = sy-sysid && 'CLNT' && sy-mandt.
    ls_mdfe_header-accesskey   = ls_mdf-accesskey.

* ---------------------------------------------------------------------------
* Preenche Informações adicionais
* ---------------------------------------------------------------------------
    ls_mdfe_infadic-inf_ad_fisco = ls_mdf-infofisco.
    ls_mdfe_infadic-inf_cpl      = ls_mdf-infocontrib.

* ---------------------------------------------------------------------------
* Preenche dados IDE
* ---------------------------------------------------------------------------
    CLEAR ls_mdfe_ide.
*    ls_mdfe_ide-c_uf           = ls_mdf_ide-c_uf.
    ls_mdfe_ide-c_uf           = ls_mdf-domfiscalinicio+3(2).
    ls_mdfe_ide-tp_amb         = ls_mdf_ide-tp_amb.
    ls_mdfe_ide-tp_emit        = ls_mdf_ide-tp_emit.
    ls_mdfe_ide-mod            = ls_mdf_ide-mod.
    ls_mdfe_ide-serie          = ls_mdf-br_mdfeseries.
    ls_mdfe_ide-n_mdf          = ls_mdf-br_mdfenumber.
    ls_mdfe_ide-c_mdf          = ls_mdf_ide-c_mdf.
    ls_mdfe_ide-modal          = ls_mdf_ide-modal.
    ls_mdfe_ide-c_dv           = ls_mdf_ide-c_dv.
    ls_mdfe_ide-dh_emi         = ls_mdf_ide-dh_emi.
    ls_mdfe_ide-tp_emis        = ls_mdf_ide-tp_emis.
    ls_mdfe_ide-proc_emi       = '0'.
    ls_mdfe_ide-ver_proc       = '1.0.0'.
    ls_mdfe_ide-ufini          = ls_mdf-ufinicio.
    ls_mdfe_ide-uffim          = ls_mdf-uffim.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de percurso
* ---------------------------------------------------------------------------
    SELECT SINGLE uf_percuso
      FROM zttm_mdf_perc
     WHERE uf_orig = @ls_mdf-ufinicio
       AND uf_dest = @ls_mdf-uffim
      INTO @DATA(lv_ufs_percuso).

    IF sy-subrc IS INITIAL.

      SPLIT lv_ufs_percuso AT ';' INTO TABLE DATA(lt_percursos).

      LOOP AT lt_percursos ASSIGNING FIELD-SYMBOL(<fs_percursos>).
        ls_mdfe_inf_percurso-id    = sy-tabix.
        ls_mdfe_inf_percurso-ufper = <fs_percursos>.
        APPEND ls_mdfe_inf_percurso TO lt_mdfe_inf_percurso.
        CLEAR ls_mdfe_inf_percurso.
      ENDLOOP.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de municipio e descarregamento
* ---------------------------------------------------------------------------
    SELECT SINGLE txjcd,
                  text
      FROM zi_ca_vh_domicilio_fiscal
      WHERE txjcd = @ls_mdf-domfiscalfim
      INTO @DATA(ls_domfiscal).

    SELECT guid,
           ordemfrete,
           br_notafiscal,
           descarga,
           descargatext,
           accesskey,
           carga,
           NfExtrn,
           segcodigobarra,
           headergrossweight
      FROM zi_tm_mdf_municipio
      WHERE guid = @iv_id
      INTO TABLE @DATA(lt_municipio).         "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc EQ 0.
      SORT lt_municipio BY descarga.
    ENDIF.

*    IF ls_mdf-manual <> abap_true. " Automático
*
*      LOOP AT lt_municipio INTO DATA(ls_municipio). "#EC CI_LOOP_INTO_WA
*
*        CLEAR ls_mdfe_infnfe.
*        ls_mdfe_infnfe-id            = sy-tabix.
*        ls_mdfe_infnfe-seq_no        = sy-tabix.
*        ls_mdfe_infnfe-ch_nfe        = ls_municipio-accesskey.
*        ls_mdfe_infnfe-seg_cod_barra = ls_municipio-segcodigobarra.
*        APPEND ls_mdfe_infnfe TO lt_mdfe_infnfe.
*
*        IF ls_municipio-descarga IS NOT INITIAL.
*          CLEAR ls_mdfe_inf_mundescarg.
*          ls_mdfe_inf_mundescarg-infnfe_ref     = ls_mdfe_infnfe-id.
*          ls_mdfe_inf_mundescarg-id             = lines( lt_mdfe_inf_mundescarg ) + 1.
*          ls_mdfe_inf_mundescarg-c_mun_descarga = ls_municipio-descarga+3.
*          ls_mdfe_inf_mundescarg-x_mun_descarga = ls_municipio-descargatext.
*          APPEND ls_mdfe_inf_mundescarg TO lt_mdfe_inf_mundescarg.
*        ENDIF.
*      ENDLOOP.
*
*      IF lt_mdfe_inf_mundescarg[] IS INITIAL.
*        CLEAR ls_mdfe_inf_mundescarg.
*        ADD 1 TO ls_mdfe_inf_mundescarg-infnfe_ref.
*        ls_mdfe_inf_mundescarg-id             = lines( lt_mdfe_inf_mundescarg ) + 1.
*        ls_mdfe_inf_mundescarg-c_mun_descarga = ls_mdf-domfiscalfim+3.
*        ls_mdfe_inf_mundescarg-x_mun_descarga = ls_domfiscal-text.
*        APPEND ls_mdfe_inf_mundescarg TO lt_mdfe_inf_mundescarg.
*      ENDIF.
*
*    ELSE. " Manual

    CLEAR ls_mdfe_inf_mundescarg.
    ADD 1 TO ls_mdfe_inf_mundescarg-infnfe_ref.
    ls_mdfe_inf_mundescarg-id             = lines( lt_mdfe_inf_mundescarg ) + 1.
    ls_mdfe_inf_mundescarg-c_mun_descarga = ls_mdf-domfiscalfim+3.
    ls_mdfe_inf_mundescarg-x_mun_descarga = ls_domfiscal-text.
    APPEND ls_mdfe_inf_mundescarg TO lt_mdfe_inf_mundescarg.

    LOOP AT lt_municipio INTO DATA(ls_municipio) WHERE descarga IS NOT INITIAL.

      CLEAR ls_mdfe_infnfe.
      ls_mdfe_infnfe-id            = ls_mdfe_inf_mundescarg-infnfe_ref.
      ls_mdfe_infnfe-seq_no        = sy-tabix.
      ls_mdfe_infnfe-ch_nfe        = ls_municipio-accesskey.
      ls_mdfe_infnfe-seg_cod_barra = ls_municipio-segcodigobarra.
      APPEND ls_mdfe_infnfe TO lt_mdfe_infnfe.

    ENDLOOP.

    LOOP AT lt_municipio INTO ls_municipio.

      IF ( ls_municipio-ordemfrete = '00000000000000000000' OR
           ls_municipio-ordemfrete IS INITIAL )
      AND ls_municipio-br_notafiscal IS INITIAL.

        CLEAR ls_mdfe_infnfe.
        ls_mdfe_infnfe-id            = ls_mdfe_inf_mundescarg-infnfe_ref.
        ls_mdfe_infnfe-seq_no        = sy-tabix.
        ls_mdfe_infnfe-ch_nfe        = ls_municipio-accesskey.
        ls_mdfe_infnfe-seg_cod_barra = ls_municipio-segcodigobarra.
        APPEND ls_mdfe_infnfe TO lt_mdfe_infnfe.

      ENDIF.

    ENDLOOP.
*    ENDIF.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de carregamento
* ---------------------------------------------------------------------------
    SELECT id,
           taxjurcode,
           taxjurcodetext
      FROM zi_tm_mdf_carregamento
      WHERE id = @iv_id
      INTO TABLE @DATA(lt_carregamento).                "#EC CI_SEL_DEL

    IF sy-subrc EQ 0.
      SORT lt_carregamento BY taxjurcode.
      DELETE ADJACENT DUPLICATES FROM lt_carregamento COMPARING taxjurcode.
    ENDIF.

    LOOP AT lt_carregamento INTO DATA(ls_carregamento). "#EC CI_LOOP_INTO_WA
      CLEAR ls_mdfe_inf_muncarrega.
      ls_mdfe_inf_muncarrega-id            = sy-tabix.
      ls_mdfe_inf_muncarrega-c_mun_carrega = ls_carregamento-taxjurcode+3.
      ls_mdfe_inf_muncarrega-x_mun_carrega = ls_carregamento-taxjurcodetext.
      APPEND ls_mdfe_inf_muncarrega TO lt_mdfe_inf_muncarrega.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera e preenche dados do total
* ---------------------------------------------------------------------------
    CLEAR ls_mdfe_tot.
    ls_mdfe_tot-c_unid = '01'.
    ls_mdfe_tot-q_nfe   = ls_mdf-QtdNfe + ls_mdf-QtdNfeWrt + ls_mdf-QtdNfeExt.                      " CHANGE - JWSILVA - 24.02.2023
    ls_mdfe_tot-v_carga = ls_mdf-vlrcarga.

    ls_mdfe_tot-q_carga = REDUCE #( INIT lv_carga = '0.0000'
                                    FOR <fs_carga> IN lt_municipio
                                    WHERE ( descarga IS NOT INITIAL OR NfExtrn IS NOT INITIAL )     " CHANGE - JWSILVA - 24.02.2023
                                    NEXT lv_carga = lv_carga + <fs_carga>-headergrossweight ).

    ls_mdfe_infmodal_rodo-rntrc           = '00000000'.
    ls_mdfe_infmodal_rodo-veictracao_ref  = '000001'.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de Placa
* ---------------------------------------------------------------------------
    SELECT *
      FROM zi_tm_mdf_placa
      WHERE id = @iv_id
      INTO TABLE @DATA(lt_mdf_placa).

    LOOP AT lt_mdf_placa INTO DATA(ls_mdf_placa).  "#EC CI_LOOP_INTO_WA

      IF ls_mdf_placa-reboque IS INITIAL.
        ls_mdfe_rodo_veic-id        = '000001'.
      ELSE.
        ls_mdfe_rodo_veic-id                  = '000002'.
        ls_mdfe_infmodal_rodo-veicreboque_ref = '000002'.
      ENDIF.

      ls_mdfe_rodo_veic-seq_no    = sy-tabix.
      TRANSLATE ls_mdf_placa-placa USING '- '. CONDENSE ls_mdf_placa-placa NO-GAPS.
      ls_mdfe_rodo_veic-placa     = ls_mdf_placa-placa.
      ls_mdfe_rodo_veic-renavam   = ls_mdf_placa-renavam.
      ls_mdfe_rodo_veic-tara      = ls_mdf_placa-tara.
      ls_mdfe_rodo_veic-tp_rod    = ls_mdf_placa-tprod.
      ls_mdfe_rodo_veic-tp_car    = ls_mdf_placa-tpcar.
      ls_mdfe_rodo_veic-uf        = ls_mdf_placa-uf.
      ls_mdfe_rodo_veic-cap_kg    = ls_mdf_placa-capkg.
      ls_mdfe_rodo_veic-cap_m3    = ls_mdf_placa-capm3.
      APPEND ls_mdfe_rodo_veic TO lt_mdfe_rodo_veic.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de Propietário
* ---------------------------------------------------------------------------
    CLEAR ls_mdfe_rodo_prop.
    ls_mdfe_rodo_prop-id      = 1.
    ls_mdfe_rodo_prop-seq_no  = 1.
    ls_mdfe_rodo_prop-cpf     = ls_mdf_placa-cpf.
    ls_mdfe_rodo_prop-cnpj    = ls_mdf_placa-cnpj.
    ls_mdfe_rodo_prop-rntrc   = ls_mdf_placa-rntrc.
    ls_mdfe_rodo_prop-x_nome  = ls_mdf_placa-nome.
    ls_mdfe_rodo_prop-ie      = ls_mdf_placa-ie.
    ls_mdfe_rodo_prop-uf      = ls_mdf_placa-ufprop.
    ls_mdfe_rodo_prop-tp_prop = ls_mdf_placa-tpprop.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de Vale Pedágio
* ---------------------------------------------------------------------------
    SELECT *
      INTO TABLE @DATA(lt_valepedagio)
      FROM zttm_mdf_placa_v
      WHERE id = @iv_id.

    IF sy-subrc NE 0.
      FREE lt_valepedagio.
    ENDIF.

    LOOP AT lt_valepedagio INTO DATA(ls_valepedagio). "#EC CI_LOOP_INTO_WA
      CLEAR ls_mdfe_rodo_disp.
      ls_mdfe_rodo_disp-id         = sy-tabix.
      ls_mdfe_rodo_disp-cnpjforn   = ls_valepedagio-cnpjforn.
      ls_mdfe_rodo_disp-cnpjpg     = ls_valepedagio-cnpjpg.
      ls_mdfe_rodo_disp-cpfpg      = ls_valepedagio-cpfpg.
      ls_mdfe_rodo_disp-n_compra   = ls_valepedagio-n_compra.
      ls_mdfe_rodo_disp-v_vale_ped = ls_valepedagio-v_vale_ped.
      APPEND ls_mdfe_rodo_disp TO lt_mdfe_rodo_disp[].
    ENDLOOP.

* ---------------------------------------------------------------------------
* Recupera e preenche dados de Motorista (Condutor)
* ---------------------------------------------------------------------------
    SELECT SINGLE id, line, motorista
      FROM zi_tm_mdf_motorista
      WHERE id             = @iv_id
        AND atualmotorista = @abap_true
      INTO @DATA(ls_mdf_moto).

    IF ls_mdf_moto IS INITIAL.
      mdf_catalog_message( EXPORTING iv_type       = gv_msg_e
                                     iv_id         = 'ZTM_MDF'
                                     iv_number     = '032'
                                     iv_message_v1 = CONV #( iv_docnum )
                           CHANGING  ct_return     =  rt_return ).
      RETURN.
    ENDIF.

    DATA(ls_bp)    = read_bp( ls_mdf_moto-motorista ).
    CLEAR ls_mdfe_rodo_condutor.
    ls_mdfe_rodo_condutor-id     = '000001'.
    ls_mdfe_rodo_condutor-x_nome = ls_bp-nome.
    ls_mdfe_rodo_condutor-cpf    = ls_bp-cpf.
    APPEND ls_mdfe_rodo_condutor TO lt_mdfe_rodo_condutor.

* ---------------------------------------------------------------------------
* Envia MDF-e
* ---------------------------------------------------------------------------
    DATA(lv_resend) = iv_resend.

    CALL FUNCTION '/XNFE/OUTMDFE_58_CREATE'
*      DESTINATION 'NONE'
      EXPORTING
        is_mdfe_header         = ls_mdfe_header
*       it_mdfe_text           =
        is_mdfe_ide            = ls_mdfe_ide
        it_mdfe_inf_percurso   = lt_mdfe_inf_percurso
        it_mdfe_inf_muncarrega = lt_mdfe_inf_muncarrega
        is_mdfe_emit           = ls_mdfe_emit
*       is_mdfe_infmodal_aereo =
*       is_mdfe_infmodal_aquav =
*       it_mdfe_inftermcarreg  =
*       it_mdfe_inftermdescarreg        =
*       it_mdfe_infembcomb     =
*       it_mdfe_infunidcargavazia       =
*       is_mdfe_infmodal_ferrov         =
*       it_mdfe_ferov_vag      =
        is_mdfe_infmodal_rodo  = ls_mdfe_infmodal_rodo
        it_mdfe_rodo_veic      = lt_mdfe_rodo_veic
        it_mdfe_rodo_prop      = lt_mdfe_rodo_prop
        it_mdfe_rodo_condutor  = lt_mdfe_rodo_condutor
        it_mdfe_rodo_disp      = lt_mdfe_rodo_disp
        it_mdfe_inf_mundescarg = lt_mdfe_inf_mundescarg
*       it_mdfe_infcte         =
        it_mdfe_infnfe         = lt_mdfe_infnfe
*       it_mdfe_infmdfetransp  =
*       it_mdfe_infunidtransp  = lt_mdfe_infunidtransp
*       it_mdfe_infunidcarga   = lt_mdfe_infunidcarga
        is_mdfe_tot            = ls_mdfe_tot
*       it_mdfe_autxml         = lt_mdfe_autxml
*       is_mdfe_infresptec     = ls_mdfe_infresptec
        is_mdfe_infadic        = ls_mdfe_infadic
*       iv_text_id_lacre       =
        iv_resend              = lv_resend
      IMPORTING
        ev_error_status        = lv_error_status
        et_bapiret2            = lt_return.

    IF lt_return IS INITIAL.
      lt_return[] = VALUE #( ( type       = 'S'
                               id         = 'ZTM_MONITOR_MDF'
                               number     = COND #( WHEN lv_resend IS INITIAL
                                                    THEN '094'   " MDF-e &1 criado.
                                                    ELSE '095' ) " MDF-e &1 reenviado.
                               message_v1 = |{ ls_mdf-br_mdfenumber ALPHA = OUT }| ) ).
    ENDIF.

    APPEND LINES OF lt_return TO rt_return.

* ---------------------------------------------------------------------------
* Em caso de sucesso, atualiza informações
* ---------------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = gv_msg_e ] ).  "#EC CI_STDSEQ

      UPDATE zttm_mdf SET mdfenum               = ls_mdf-br_mdfenumber
                          series                = ls_mdf-br_mdfeseries
                          access_key            = ls_mdf-accesskey
                          created_by            = ls_mdf-createdby
                          created_at            = ls_mdf-createdat
                          last_changed_by       = ls_mdf-lastchangedby
                          last_changed_at       = ls_mdf-lastchangedat
                          local_last_changed_at = ls_mdf-locallastchangedat
                      WHERE id EQ ls_mdf-guid.      "#EC CI_IMUD_NESTED

      UPDATE zttm_mdf_ide SET c_mdf                 = ls_mdf_ide-c_mdf
                              c_dv                  = ls_mdf_ide-c_dv
                              created_by            = ls_mdf_ide-created_by
                              created_at            = ls_mdf_ide-created_at
                              last_changed_by       = ls_mdf_ide-last_changed_by
                              last_changed_at       = ls_mdf_ide-last_changed_at
                              local_last_changed_at = ls_mdf_ide-local_last_changed_at
                          WHERE id EQ ls_mdf-guid.  "#EC CI_IMUD_NESTED

      " Recupera novo status
*      mdf_status( EXPORTING iv_id     = iv_id
*                  IMPORTING es_mdfehd = ls_mdfehd ).
*
*      ev_statuscode = ls_mdfehd-statcod.
*
*      SELECT *
*        FROM zi_tm_mdf_municipio
*        WHERE Guid         EQ @iv_id
*          AND FreightOrder IS NOT INITIAL
*        INTO TABLE @DATA(lt_zttm_mdf_mcd).    "#EC CI_ALL_FIELDS_NEEDED
*
*      IF sy-subrc NE 0.
*        RETURN.
*      ENDIF.
*
*      TRY.
*          DATA(lo_tor_mgr)    = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
*          DATA(lo_bo_config)  = /bobf/cl_frw_factory=>get_configuration( /scmtms/if_tor_c=>sc_bo_key ).
*          DATA(lo_txn_tor)   = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
*        CATCH /bobf/cx_frw.
*          RETURN.
*      ENDTRY.
*
*      SORT lt_zttm_mdf_mcd BY FreightOrder.
*
*      LOOP AT lt_zttm_mdf_mcd INTO DATA(ls_mdf_mcd). "#EC CI_LOOP_INTO_WA
*        APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameter>).
*        <fs_parameter>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-qdb_torid-tor_id.
*        <fs_parameter>-sign           = 'I'.
*        <fs_parameter>-option         = 'EQ'.
*        <fs_parameter>-low            = ls_mdf_mcd-FreightOrder.
*      ENDLOOP.
*
*      CALL METHOD lo_tor_mgr->query
*        EXPORTING
*          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
*          it_selection_parameters = lt_parameters
*          iv_fill_data            = abap_true
*        IMPORTING
*          et_key                  = lt_keys
*          et_data                 = lt_data
*          eo_message              = DATA(lo_message).
*
*      IF NOT lo_message IS INITIAL.
*        CLEAR lt_return.
*        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
*                                                               CHANGING  ct_bapiret2 = lt_return[] ).
*
*        APPEND LINES OF lt_return TO rt_return.
*      ENDIF.
*
*      LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*        <fs_data>-zz_mdf  = ls_mdf-BR_MDFeNumber.
*        <fs_data>-zz_code = ls_mdfehd-statcod.
*      ENDLOOP.
*
*      /scmtms/cl_mod_helper=>mod_update_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-root
*                                                         iv_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                         it_data        = lt_data
*                                                CHANGING ct_mod         = lt_mod ).
*
*
*      lo_tor_mgr->modify( EXPORTING it_modification = lt_mod
*                          IMPORTING eo_change  = DATA(lo_change)
*                                    eo_message = lo_message ).
*
*      IF NOT lo_message IS INITIAL.
*        CLEAR lt_return.
*        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
*                                                               CHANGING  ct_bapiret2 = lt_return[] ).
*
*        APPEND LINES OF lt_return TO rt_return.
*      ENDIF.
*
*      lo_txn_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
*                        IMPORTING ev_rejected         = DATA(lv_rejected)
*                                  eo_change           = lo_change
*                                  eo_message          = DATA(lo_message_save)
*                                  et_rejecting_bo_key = DATA(ls_rejecting_bo_key) ).
*
*
*      IF NOT lo_message_save IS INITIAL.
*        CLEAR lt_return.
*        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message_save
*                                                               CHANGING  ct_bapiret2 = lt_return[] ).
*
*        APPEND LINES OF lt_return TO rt_return.
*      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD mdf_status.

    DATA:
      lv_access_key TYPE  /xnfe/id,

      ls_mdfehd     TYPE  /xnfe/outmdfehd,
      ls_xml_mdfe   TYPE  /xnfe/outmdfexml,
      lt_hdsta      TYPE  /xnfe/outhdsta_t,
      lt_hist       TYPE  /xnfe/outhist_t,
      lt_symsg      TYPE  /xnfe/symsg_t,
      lv_histcount  TYPE  /xnfe/histcount.

    FREE: es_event, es_mdfehd.

    SELECT SINGLE access_key INTO @DATA(lv_ackey)
      FROM zttm_mdf
      WHERE id = @iv_id.

    CHECK sy-subrc IS INITIAL.

    lv_access_key = lv_ackey.

    CALL FUNCTION '/XNFE/OUTMDFE_READ_MFE_FOR_UPD' DESTINATION 'NONE'
*    DESTINATION gv_destination
      EXPORTING
        iv_mdfeid           = lv_access_key
      IMPORTING
        es_mdfehd           = ls_mdfehd
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

    CHECK sy-subrc IS INITIAL.
* Implement suitable error handling here

    DATA:
      ls_event           TYPE  /xnfe/events,
      ls_xml             TYPE  /xnfe/event_xml,
      lt_status          TYPE  /xnfe/event_stat_t,
      lt_hist_event      TYPE  /xnfe/event_hist_t,
      lt_symsg_event     TYPE  /xnfe/symsg_t,
      lv_histcount_event TYPE  /xnfe/histcount,

      lv_guid            TYPE  /xnfe/guid_16,
      lv_tpevento        TYPE  /xnfe/ev_tpevento,
      lv_proctyp         TYPE  /xnfe/proctyp,
      lv_event_exists    TYPE  abap_bool,
      lv_current         TYPE  /xnfe/actstat.

    lv_tpevento   = '110114'.
    lv_proctyp    = 'ISSMDRIV'.

    CALL FUNCTION '/XNFE/EVENT_EXISTS'
      EXPORTING
        iv_chnfe          = lv_access_key
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
        et_symsg             = lt_symsg
        ev_histcount         = lv_histcount_event
      EXCEPTIONS
        event_does_not_exist = 1
        event_locked         = 2
        technical_error      = 3
        OTHERS               = 4.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    mdf_status_update( iv_id = iv_id
                       is_mdfehd = ls_mdfehd
                       is_event = ls_event ).

*    CALL FUNCTION 'ZTMF_MDF_ATUALIZA_STATUS_SEFAZ'
*      EXPORTING
*        is_mdfehd      = ls_MDFEHD
*        is_event       = ls_event
*      CHANGING
*        cs_ztmt0003    = ps_ztmt0003
*      EXCEPTIONS
*        update_success = 1
*        OTHERS         = 2.
*
*    IF sy-subrc = 1.
*      MESSAGE ID      sy-msgid
*              TYPE    sy-msgty
*              NUMBER  sy-msgno
*                WITH  sy-msgv1
*                      sy-msgv2
*                      sy-msgv3
*                      sy-msgv4.
*
** Status & atualizado para MDF-e &
*    ENDIF.

*    mdf_status_update( is_MDFEHD = ls_MDFEHD
*                       is_event  = ls_event ).


    es_mdfehd = ls_mdfehd.
    es_event  = ls_event.
  ENDMETHOD.


  METHOD mdf_status_update.

    DATA:
      lv_message TYPE bapi_msg,
      lt_return  TYPE bapiret2_t.

    SELECT SINGLE * INTO @DATA(ls_mdf)
      FROM zttm_mdf
      WHERE id = @iv_id.

    IF ls_mdf IS INITIAL.
      mdf_catalog_message( EXPORTING iv_type       = gv_msg_e
                                     iv_id         = 'ZTM_MDF'
                                     iv_number     = '031'
                                     iv_message_v1 = CONV #( iv_id )
                           CHANGING  ct_return     =  lt_return ).
      RETURN.
    ENDIF.

    DATA(lv_xmotivo) = is_mdfehd-xmotivo.
    DATA(lv_status)  = 1.

    CASE is_mdfehd-statcod.
      WHEN space.
        RETURN.
      WHEN 100.
        lv_status = 1.
      WHEN 101.
        lv_status = 3.
        lv_xmotivo = 'MDF-e cancelada'(t01).
      WHEN 132.
        lv_status = 2.
        lv_xmotivo = 'MDF-e encerrada'(t02).
      WHEN OTHERS.
    ENDCASE.

    ls_mdf-nprot     = is_mdfehd-nprot.
    ls_mdf-dhrecbto  = is_mdfehd-dhrecbto.
    ls_mdf-xmotivo   = lv_xmotivo.
    ls_mdf-statcod   = is_mdfehd-statcod.
    ls_mdf-cstat     = is_event-cstat.

    UPDATE zttm_mdf SET statcod    = is_mdfehd-statcod
                        xmotivo    = lv_xmotivo
                        nprot      = is_mdfehd-nprot
                        dhrecbto   = is_mdfehd-dhrecbto
                        cstat      = ls_mdf-cstat
                  WHERE id = ls_mdf-id.             "#EC CI_IMUD_NESTED

  ENDMETHOD.


  METHOD ramdom_num_create.

    DATA: lv_random TYPE qf00-ran_int.

* ---------------------------------------------------------------------------
* Gerar número aleatório
* ---------------------------------------------------------------------------
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 99999999
        ran_int_min   = 1
      IMPORTING
        ran_int       = lv_random
      EXCEPTIONS
        invalid_input = 1
        OTHERS        = 2.

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    rv_randomnum = lv_random.

  ENDMETHOD.


  METHOD read_bp.

* ---------------------------------------------------------------------------
* Recupera informações do parceiro
* ---------------------------------------------------------------------------
    SELECT SINGLE *
      FROM zi_ca_vh_partner_pf
      WHERE parceiro = @iv_partner
      INTO CORRESPONDING FIELDS OF @rs_bp.           "#EC CI_SEL_NESTED

    IF sy-subrc NE 0.
      FREE rs_bp.
    ENDIF.

  ENDMETHOD.


  METHOD doc_mdfe_create.

    DATA: lv_number TYPE j_1bdocnum.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera próximo número do objeto de numeração
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZTM_MDF_NR'
      IMPORTING
        number                  = lv_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.
      et_return[] = VALUE #( BASE et_return ( type        = sy-msgty
                                              id          = sy-msgid
                                              number      = sy-msgno
                                              message_v1  = sy-msgv1
                                              message_v2  = sy-msgv2
                                              message_v3  = sy-msgv3
                                              message_v4  = sy-msgv4 ) ).
      EXIT.
    ENDIF.

    rv_docnum = lv_number.

  ENDMETHOD.


  METHOD num_mdfe_create.

    DATA: lv_number TYPE ze_tm_mdfenum.

    FREE: et_return.

    DATA(lv_range_nr) = COND nrnr( WHEN is_zttm_mdf-manual IS INITIAL
                                   THEN '01'
                                   ELSE '02' ).

* ---------------------------------------------------------------------------
* Recupera próximo número do objeto de numeração
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = lv_range_nr
        object                  = 'ZTM_MDFE'
      IMPORTING
        number                  = lv_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.
      et_return[] = VALUE #( BASE et_return ( type        = sy-msgty
                                              id          = sy-msgid
                                              number      = sy-msgno
                                              message_v1  = sy-msgv1
                                              message_v2  = sy-msgv2
                                              message_v3  = sy-msgv3
                                              message_v4  = sy-msgv4 ) ).
      EXIT.
    ENDIF.

    rv_mdfenum = lv_number.

  ENDMETHOD.


  METHOD get_messages.

    et_return = gt_return.

  ENDMETHOD.


  METHOD mdf_send_background.
*     DATA: LV_STATUS type /XNFE/STATUSCODE.
    FREE: gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_MDF_SEND_BACK'
      STARTING NEW TASK 'MDF_SEND_BACK'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_docnum = iv_docnum
        iv_id     = iv_id
        iv_resend = iv_resend.
*      importing
*         et_return = gt_return
*         ev_statuscode = LV_STATUS.
*
    WAIT UNTIL gv_wait_async = abap_true.
    rt_return = gt_return.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'MDF_SEND_BACK'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_MDF_SEND_BACK'
            IMPORTING
                et_return     = gt_return.

      WHEN 'MDF_DRIVER_CHANGE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_MDF_DRIVER_CHANGE'
            IMPORTING
                et_return     = gt_return.

      WHEN OTHERS.

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD build_reported.

    DATA: lo_dataref TYPE REF TO data,
          ls_cockpit TYPE zc_tm_mdf_cockpit.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-cockpit.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-cockpit.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-cockpit.
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
        WHEN gc_cds-cockpit.
          es_reported-cockpit[] = VALUE #( BASE es_reported-cockpit[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-cockpit[] = VALUE #( BASE es_reported-cockpit[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
