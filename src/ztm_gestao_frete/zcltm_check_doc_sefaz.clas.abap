CLASS zcltm_check_doc_sefaz DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS check_sefaz
      IMPORTING
        !iv_acckey    TYPE j_1b_nfe_access_key_dtel44
        !iv_local     TYPE flag OPTIONAL
      EXPORTING
        !et_mensagens TYPE bapiret2_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_check_doc_sefaz IMPLEMENTATION.


  METHOD check_sefaz.

    DATA:
      lv_messageid   TYPE /xnfe/sxmsmguid,
      ls_infprot     TYPE /xnfe/infprot_cte_status,
      ls_infprot_cte TYPE /xnfe/infprot_cte_status,
      ls_infprot_nfe TYPE /xnfe/infprot_nfe_status,
      lt_events_prot TYPE /xnfe/events_prot_t,
      ls_006         TYPE zttm_gkot006.

    FREE: et_mensagens.

    " Recupera dados do cockpit de frete
    SELECT SINGLE acckey, codstatus, tpdoc
      FROM zttm_gkot001
      INTO @DATA(ls_001)
      WHERE acckey = @iv_acckey.

    IF sy-subrc <> 0.
      " Chave inválida
      APPEND VALUE #( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '102' ) TO et_mensagens.
      EXIT.
    ENDIF.

    IF ls_001-tpdoc = 'CTE'.

      SELECT SINGLE guid, cteid, cuf, tpamb, tpemis
        FROM /xnfe/inctehd
        INTO @DATA(ls_inctehd)
        WHERE cteid = @iv_acckey.

      IF sy-subrc <> 0.
        " CT-e Incoming Header Data não encontrado
        APPEND VALUE #( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '103' ) TO et_mensagens.
        EXIT.
      ENDIF.

      CALL FUNCTION '/XNFE/CTE_STATUS_CHECK_SYNC'
        EXPORTING
          iv_cuf                 = ls_inctehd-cuf
          iv_tpamb               = ls_inctehd-tpamb
          iv_tpemis              = ls_inctehd-tpemis
          iv_cteid               = ls_inctehd-cteid
        IMPORTING
          ev_messageid           = lv_messageid
          es_infprot             = ls_infprot_cte
          et_events_prot         = lt_events_prot
        EXCEPTIONS
          version_not_maintained = 1
          error_proxy_call       = 2
          transformation_error   = 3
          OTHERS                 = 4.

      IF sy-subrc <> 0.
        " Erro ao buscar status na SEFAZ
        APPEND VALUE #( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '104' ) TO et_mensagens.
        EXIT.
      ENDIF.

      IF ls_infprot_cte-c_stat = ls_001-codstatus.
        " Não houve mudança de status
        APPEND VALUE #( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '105' ) TO et_mensagens.
        EXIT.
      ENDIF.

      ls_infprot = ls_infprot_cte.

    ELSE.

      SELECT SINGLE guid_header, nfeid, cuf, tpamb, tpemis, mod, cnpj_emit
        FROM /xnfe/innfehd
        INTO @DATA(ls_innfehd)
        WHERE nfeid = @iv_acckey.

      IF sy-subrc <> 0.
        " NF-e não encontrado.
        APPEND VALUE #( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '133' ) TO et_mensagens.
        EXIT.
      ENDIF.

      CALL FUNCTION '/XNFE/NFE_STATUS_CHECK_SYNC'
        EXPORTING
          iv_cuf                 = ls_innfehd-cuf
          iv_tpamb               = ls_innfehd-tpamb
          iv_tpemis              = ls_innfehd-tpemis
          iv_cnpj                = ls_innfehd-cnpj_emit
          iv_mod                 = ls_innfehd-mod
          iv_nfeid               = ls_innfehd-nfeid
        IMPORTING
          ev_messageid           = lv_messageid
          es_infprot             = ls_infprot_nfe
          et_events_prot         = lt_events_prot
        EXCEPTIONS
          version_not_maintained = 1
          error_proxy_call       = 2
          transformation_error   = 3
          OTHERS                 = 4.

      IF sy-subrc <> 0.
        " Erro ao buscar status na SEFAZ
        APPEND VALUE #( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '104' ) TO et_mensagens.
        EXIT.
      ENDIF.

      IF ls_infprot_nfe-c_stat = ls_001-codstatus.
        " Não houve mudança de status
        APPEND VALUE #( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '105' ) TO et_mensagens.
        EXIT.
      ENDIF.

      ls_infprot = ls_infprot_nfe.

    ENDIF.

    " Prepara log. Atualiza contador na função. Também cria um registro na 001.
    CLEAR ls_006.
    ls_006-acckey       = ls_001-acckey.
    ls_006-counter      = 0.
    ls_006-codstatus    = ls_infprot-c_stat.
    ls_006-codigo       = ls_infprot-c_msg.
    ls_006-desc_codigo  = ls_infprot-x_msg.
    ls_006-credat       = sy-datum.
    ls_006-cretim       = sy-uzeit.
    ls_006-crenam       = sy-uname.

    APPEND VALUE #( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '000'
                    message_v1 = |{ ls_infprot-c_stat } - |
                    message_v2 = |{ ls_infprot-x_motivo(50) }|
                    message_v3 = |{ ls_infprot-x_motivo+50(50) }|
                    message_v4 = |{ ls_infprot-x_motivo+100(50) }| ) TO et_mensagens.

    APPEND VALUE #( type = 'S' id = 'ZTM_GESTAO_FRETE' number = '000'
                    message_v1 = |{ ls_infprot-c_msg } - |
                    message_v2 = |{ ls_infprot-x_msg(50) }|
                    message_v3 = |{ ls_infprot-x_msg+50(50) }|
                    message_v4 = |{ ls_infprot-x_msg+100(50) }| ) TO et_mensagens.

    IF iv_local IS SUPPLIED AND iv_local = abap_true.

      CALL FUNCTION 'ZFMTM_REFRESH_STATUS_SEFAZ'
        EXPORTING
          is_gkot006 = ls_006.
    ELSE.
      DATA(lv_task) = |REFRESH{ sy-uzeit }|.

      CALL FUNCTION 'ZFMTM_REFRESH_STATUS_SEFAZ'
        STARTING NEW TASK lv_task
        EXPORTING
          is_gkot006 = ls_006.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
