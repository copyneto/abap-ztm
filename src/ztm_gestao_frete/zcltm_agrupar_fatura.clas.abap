CLASS zcltm_agrupar_fatura DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_parametros,
        root     TYPE pd_objid_r,
        desconto TYPE wrbtr,
      END OF ty_parametros,

      ty_r_xblnr TYPE RANGE OF zttm_gkot001-num_fatura.

    CLASS-DATA:
      go_instance   TYPE REF TO zcltm_agrupar_fatura,
      gs_parametros TYPE ty_parametros.

    "! Cria instancia
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcltm_agrupar_fatura.

    "! Recupera parâmetros cadastrados
    METHODS busca_parametros
      EXPORTING
        es_parametros TYPE ty_parametros.

    "! Inicia processo de agrupamento de faturas
    METHODS agrupar_fatura
      IMPORTING
        !iv_stcd1           TYPE stcd1
        !iv_vlr_total       TYPE wrbtr
        !iv_vlr_desconto    TYPE wrbtr
        !iv_fatura_trasnpo  TYPE xblnr
        !iv_data_vencimento TYPE dzfbdt
        !it_acckey          TYPE zctgsd_acckey
      EXPORTING
        !et_mensagens       TYPE bapiret2_tab.

    "! Dispara Workflow (WF)
    METHODS dispara_wf
      IMPORTING is_group TYPE zttm_gkot009.

    "! Busca aprovadores (WF)
    METHODS busca_aprovadores
      IMPORTING
        !iv_objkey    TYPE swotobjid-objkey
        !it_container TYPE swconttab
      CHANGING
        !ct_actor_tab TYPE tswhactor
      EXCEPTIONS
        nobody_found.

    "! Busca nível de desconto. Necessário para determinar quantos aprovadores serão envolvidos.
    METHODS busca_nivel_desconto
      IMPORTING
        !iv_xblnr TYPE zttm_gkot009-xblnr
        !iv_stcd1 TYPE zttm_gkot009-stcd1
        !iv_bldat TYPE zttm_gkot009-bldat
      EXPORTING
        !ev_nivel TYPE twb_level.

    "! Efetivar agrupamento
    METHODS efetivar_agrupamento
      IMPORTING
        !it_xblnr       TYPE zctgtm_gko009 OPTIONAL
        !ir_xblnr       TYPE ty_r_xblnr OPTIONAL
      EXPORTING
        !et_return      TYPE bapiret2_tab
        !et_bapi_return TYPE bapiret2_t.

    "! Exibir mensagens de log
    METHODS show_log
      IMPORTING it_return TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_agrupar_fatura IMPLEMENTATION.


  METHOD get_instance.

    go_instance = COND #( WHEN go_instance IS NOT INITIAL
                          THEN go_instance
                          ELSE NEW zcltm_agrupar_fatura( ) ).

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD busca_parametros.

    FREE: es_parametros.

    IF gs_parametros-root IS INITIAL.
      TRY.
          NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = gc_modulo
                                                                  iv_chave1 = gc_chave1
                                                                  iv_chave2 = gc_chave2
                                                        IMPORTING ev_param  = gs_parametros-root ).

        CATCH zcxca_tabela_parametros.
      ENDTRY.
    ENDIF.

    IF gs_parametros-desconto IS INITIAL.
      TRY.
          NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = gc_modulo
                                                                  iv_chave1 = gc_chave1
                                                                  iv_chave2 = gc_chave2
                                                                  iv_chave3 = gc_chave3
                                                        IMPORTING ev_param  = gs_parametros-desconto ).

        CATCH zcxca_tabela_parametros.
      ENDTRY.
    ENDIF.

    es_parametros = gs_parametros.

  ENDMETHOD.


  METHOD agrupar_fatura.

    CONSTANTS: gc_error       TYPE bapi_mtype VALUE 'E',
               gc_sucess      TYPE bapi_mtype VALUE 'S',
               gc_symsgid     TYPE symsgid VALUE 'ZTM_GESTAO_FRETE',
               gc_symsgno_000 TYPE symsgno VALUE '000', "Chave inválida
               gc_symsgno_110 TYPE symsgno VALUE '110', "Usuário não autorizado a agrupar faturas
               gc_symsgno_112 TYPE symsgno VALUE '112', "Agrupamento não gerado
               gc_symsgno_111 TYPE symsgno VALUE '111', "Nenhuma fatura a ser agrupada
               gc_symsgno_113 TYPE symsgno VALUE '113', "
               gc_symsgno_114 TYPE symsgno VALUE '114', "
               gc_symsgno_115 TYPE symsgno VALUE '115', "
               gc_symsgno_105 TYPE symsgno VALUE '105'.

    DATA: lt_acckey         TYPE zctgsd_acckey,
          lv_error          TYPE flag,
          ls_gkot009        TYPE zttm_gkot009,
          lt_gkot010        TYPE TABLE OF zttm_gkot010,
          lt_gkot011        TYPE TABLE OF zttm_gkot011,
          lt_return         TYPE bapiret2_t,
          lt_msgs           TYPE bapiret2_t,
          lv_vlr_total      TYPE wrbtr,
          lv_vlr_total_desc TYPE wrbtr,
          lv_fator_mult     TYPE wrbtr.

    FREE: et_mensagens.

    CLEAR: lv_vlr_total.

    AUTHORITY-CHECK OBJECT 'ZTMAGRUFAT'
     ID 'ACTVT' FIELD '46'.
    IF sy-subrc <> 0.

      APPEND VALUE #( type = gc_error
                      id = gc_symsgid
                      number = gc_symsgno_110 ) TO et_mensagens.
      EXIT.
    ENDIF.

    CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
      EXPORTING
        date                      = iv_data_vencimento
      EXCEPTIONS
        plausibility_check_failed = 1
        OTHERS                    = 2.

    IF sy-subrc <> 0.
      et_mensagens = VALUE #( BASE et_mensagens ( id         = sy-msgid
                                                  type       = 'E'
                                                  number     = sy-msgno
                                                  message_v1 = sy-msgv1
                                                  message_v2 = sy-msgv2
                                                  message_v3 = sy-msgv3
                                                  message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

    lt_acckey = it_acckey.
    SORT lt_acckey BY acckey.
    DELETE lt_acckey WHERE acckey IS INITIAL.
    SORT lt_acckey.
    DELETE ADJACENT DUPLICATES FROM lt_acckey.

    IF lt_acckey IS INITIAL.
      APPEND VALUE #( type   = gc_error
                      id     = gc_symsgid
                      number = gc_symsgno_111 ) TO et_mensagens.
      EXIT.
    ENDIF.

    SELECT *
      FROM zttm_gkot001
      INTO TABLE @DATA(lt_gkot001)
      FOR ALL ENTRIES IN @lt_acckey
      WHERE acckey = @lt_acckey-acckey.

    IF lines( lt_gkot001 ) <> lines( lt_acckey ).

      LOOP AT lt_acckey ASSIGNING FIELD-SYMBOL(<fs_acckey>).
        IF NOT line_exists( lt_gkot001[ acckey = <fs_acckey>-acckey ] ).
          APPEND VALUE #( type = gc_error
                          id = gc_symsgid
                          number = gc_symsgno_112
                           ) TO et_mensagens.
        ENDIF.
      ENDLOOP.

      APPEND VALUE #( type   = gc_error
                      id     = gc_symsgid
                      number = gc_symsgno_112 ) TO et_mensagens.
      EXIT.
    ENDIF.

*    CLEAR: lv_fator_mult,
*           lv_vlr_total_desc.
*
*    IF iv_vlr_desconto IS NOT INITIAL AND
*       iv_vlr_total    IS NOT INITIAL.
*
*      lv_fator_mult = iv_vlr_desconto / iv_vlr_total.
*
*    ENDIF.

    LOOP AT lt_gkot001 ASSIGNING FIELD-SYMBOL(<fs_gkot001>).

      IF sy-tabix = 1.
        DATA(lv_emit_cnpj_cpf) = <fs_gkot001>-emit_cnpj_cpf.
        DATA(lv_tom_cnpj_cpf)  = <fs_gkot001>-tom_cnpj_cpf.
      ENDIF.

      IF lv_emit_cnpj_cpf <> <fs_gkot001>-emit_cnpj_cpf.
        APPEND VALUE #( type   = gc_error
                        id     = gc_symsgid
                        number = gc_symsgno_113 ) TO et_mensagens.
        lv_error = abap_true.
        EXIT.
      ENDIF.

      IF lv_tom_cnpj_cpf <> <fs_gkot001>-tom_cnpj_cpf.
        APPEND VALUE #( type   = gc_error
                        id     = gc_symsgid
                        number = gc_symsgno_114 ) TO et_mensagens.
        lv_error = abap_true.
        EXIT.
      ENDIF.

* ---------------------------------------------------------------------------
* Caso não haja desconto, então não há necessidade de fluxo de aprovação
* ---------------------------------------------------------------------------
      IF iv_vlr_desconto IS NOT INITIAL.
        " Aguardando aprovação WF do agrupamento
        <fs_gkot001>-codstatus = zcltm_gko_process=>gc_codstatus-aguardando_aprovacao_wf.
      ELSE.
        " Aguardando a realização do agrupamento
        <fs_gkot001>-codstatus = zcltm_gko_process=>gc_codstatus-aguardando_reagrupamento.
      ENDIF.

      <fs_gkot001>-num_fatura  = iv_fatura_trasnpo.
* ---------------------------------------------------------------------------

      CASE <fs_gkot001>-tpdoc.
        WHEN 'CTE'.
          DATA(lv_seqcte) = lines( lt_gkot010 ) + 1.
          APPEND VALUE #( xblnr = iv_fatura_trasnpo
                          stcd1 = lv_emit_cnpj_cpf " iv_stcd1
                          bldat = sy-datum
                          seqcte = lv_seqcte
                          acckey = <fs_gkot001>-acckey ) TO lt_gkot010.
        WHEN 'NFS' OR 'NFE'.
          DATA(lv_seqnfs) = lines( lt_gkot011 ) + 1.
          APPEND VALUE #( xblnr   = iv_fatura_trasnpo
                          stcd1   = lv_emit_cnpj_cpf " iv_stcd1
                          bldat   = sy-datum
                          seqnfs  = lv_seqnfs
                          docdat  = <fs_gkot001>-budat
                          prefno  = COND #( WHEN <fs_gkot001>-prefno IS NOT INITIAL
                                            THEN <fs_gkot001>-prefno
                                            WHEN <fs_gkot001>-nfnum9 IS NOT INITIAL
                                            THEN <fs_gkot001>-nfnum9 )
                          nfnum   = COND #( WHEN strlen( <fs_gkot001>-nfnum9 ) = 6
                                            THEN <fs_gkot001>-nfnum9
                                            ELSE 0  )
                          nfenum  = COND #( WHEN strlen( <fs_gkot001>-nfnum9 ) = 9
                                            THEN <fs_gkot001>-nfnum9
                                            ELSE space  )
                          series  = <fs_gkot001>-series
                          stcd1_transp = <fs_gkot001>-emit_cnpj_cpf ) TO lt_gkot011.
        WHEN OTHERS.
          APPEND VALUE #( type   = gc_error
                          id     = gc_symsgid
                          number = gc_symsgno_115 ) TO et_mensagens.
          lv_error = abap_true.
          EXIT.

      ENDCASE.

      lv_vlr_total = lv_vlr_total + <fs_gkot001>-vtprest.

*      " Calculo Proporcional de Desconto
*      IF lv_fator_mult IS NOT INITIAL.
*        <fs_gkot001>-desconto = lv_fator_mult * <fs_gkot001>-vtprest.
*        lv_vlr_total_desc = lv_vlr_total_desc + <fs_gkot001>-desconto.
*      ENDIF.
*
*      AT LAST.
*        lv_vlr_total_desc = lv_vlr_total_desc - iv_vlr_desconto.
*        <fs_gkot001>-desconto = <fs_gkot001>-desconto + lv_vlr_total_desc.
*      ENDAT.
    ENDLOOP.

    IF lv_error = abap_true.
      " Agrupamento não gerado
      APPEND VALUE #( type   = gc_error
                      id     = gc_symsgid
                      number = gc_symsgno_111 ) TO et_mensagens.
      RETURN.
    ENDIF.

    IF iv_vlr_total IS NOT INITIAL.

      lv_vlr_total = iv_vlr_total.

    ENDIF.

    ls_gkot009-xblnr  = iv_fatura_trasnpo.
    ls_gkot009-stcd1  = lv_emit_cnpj_cpf. " iv_stcd1.
    ls_gkot009-bldat  = sy-datum.
    ls_gkot009-zfbdt  = iv_data_vencimento.
    ls_gkot009-newtr  = lv_vlr_total.
    ls_gkot009-newdis = iv_vlr_desconto.

* ---------------------------------------------------------------------------
* Fluxo do processo de agrupamento
* ---------------------------------------------------------------------------
* 1) '502'  Aguardando aprovação WF do agrupamento
* 2) '501'  Aguardando a realização do agrupamento
* 3) '500'  Agrupamento efetuado
* ---------------------------------------------------------------------------

* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* O disparo do Workflow é feito apenas quando há desconto no status '502'.
* No final do fluxo de aprovação no WF (objeto ZTMW_AGRUPAMENTO_FATURAS),
* o status muda para '501'. Na sequencia o job (program ZFIR_GKO_AGRUP_FATURA)
* faz o agrupamento e atualiza o status para '500'.
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
    IF iv_vlr_desconto IS NOT INITIAL.

      MODIFY zttm_gkot009 FROM ls_gkot009.
      MODIFY zttm_gkot001 FROM TABLE lt_gkot001.
      MODIFY zttm_gkot010 FROM TABLE lt_gkot010.
      MODIFY zttm_gkot011 FROM TABLE lt_gkot011.

      COMMIT WORK AND WAIT.

      " Atualiza log
      LOOP AT lt_gkot001 ASSIGNING <fs_gkot001>.

        TRY.
            DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey = <fs_gkot001>-acckey ).
            " Solicitação enviada para aprovadores. Favor verificar caixa de mensagens.
            lr_gko_process->set_status( iv_status  = <fs_gkot001>-codstatus
                                        it_bapi_ret = VALUE #( (  type = 'I' id = 'ZTM_GKO' number = '147' ) ) ).
            lr_gko_process->persist( ).
            lr_gko_process->free( ).
          CATCH cx_root.
        ENDTRY.

      ENDLOOP.

      " Job executado com sucesso
      APPEND VALUE #( type   = gc_sucess
                      id     = gc_symsgid
                      number = gc_symsgno_105 ) TO et_mensagens.

      me->dispara_wf( is_group = ls_gkot009 ).

* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* Para descontos inferiores desse limite, o agrupamento é feito sem necessidade
* de apropvação. Mudamos o status para '501' e chamamos a lógica de agrupamento
* para atualizar pro status '500'.
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
    ELSE.

      " Agrupamento realizado. Favor verificar log de execução.
      DATA(ls_invoice) = VALUE zstm_gko_002( invoice_number         = ls_gkot009-xblnr
                                             invoice_issue_date     = ls_gkot009-bldat
                                             invoice_due_date       = ls_gkot009-zfbdt
                                             cnpj_issue             = ls_gkot009-stcd1
                                             invoice_value          = ls_gkot009-newtr
                                             invoice_discount_value = ls_gkot009-newdis
                                             user_approval          = ls_gkot009-user_approv
                                             cte                    = VALUE zctgtm_gko001( FOR ls_010 IN lt_gkot010 ( CONV zstm_gko_003( ls_010-acckey ) ) )
                                             nfs                    = VALUE zctgtm_gko002( FOR ls_011 IN lt_gkot011 ( issue_date   = ls_011-bldat
                                                                                                                      prefno       = ls_011-prefno
                                                                                                                      series       = ls_011-series
                                                                                                                      nfnum        = ls_011-nfnum
                                                                                                                      nfenum       = ls_011-nfenum
                                                                                                                      stcd1_transp = ls_011-stcd1_transp ) ) ).

      DATA(lt_errors) = NEW zclfi_gko_incoming_invoice( )->set_invoice( is_invoice = ls_invoice )->start(  )->get_errors( IMPORTING et_return = lt_return ).
      DATA(lt_bapi_return) =  NEW zcxtm_gko_incoming_invoice( gt_errors = lt_errors )->get_bapi_return( ).
      lt_msgs = CORRESPONDING #( BASE ( lt_msgs ) lt_bapi_return ).
      lt_msgs = CORRESPONDING #( BASE ( lt_msgs ) lt_return ).

* ---------------------------------------------------------------------------
* Atualiza log
* ---------------------------------------------------------------------------
      LOOP AT lt_gkot001 ASSIGNING <fs_gkot001>.
        TRY.
            lr_gko_process = NEW zcltm_gko_process( iv_acckey = <fs_gkot001>-acckey ).
            lr_gko_process->set_status( iv_status   = COND #( WHEN NOT line_exists( lt_msgs[ type = 'E' ] )
                                                              THEN zcltm_gko_process=>gc_codstatus-agrupamento_efetuado
                                                              WHEN sy-batch EQ abap_true
                                                              THEN zcltm_gko_process=>gc_codstatus-erro_agrupamento
                                                              ELSE zcltm_gko_process=>gc_codstatus-erro_agrupamento_manual )
                                        it_bapi_ret = lt_msgs ).
            lr_gko_process->persist( ).
            lr_gko_process->free( ).
          CATCH cx_root.
        ENDTRY.
      ENDLOOP.

      IF line_exists( lt_msgs[ type = 'E' ] ).
        " Agrupamento contêm erros. Favor verificar log de execução.
        APPEND VALUE #( type   = 'E'
                        id     = 'ZTM_GESTAO_FRETE'
                        number = '137' ) TO et_mensagens.
      ELSE.
        " Agrupamento realizado.
        APPEND VALUE #( type   = 'S'
                        id     = 'ZTM_GESTAO_FRETE'
                        number = '136' ) TO et_mensagens.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD dispara_wf.

    TYPES:
      BEGIN OF ty_objkey,
        xblnr TYPE xblnr,
        stcd1 TYPE stcd1,
        bldat TYPE bldat,
      END OF ty_objkey.

    CONSTANTS:
      lc_objtype TYPE swo_objtyp VALUE 'ZAGRPFAT',
      lc_event   TYPE swo_event  VALUE 'CREATED'.

    DATA(ls_objkey) = CORRESPONDING ty_objkey( is_group ).
    DATA(lv_objkey) = CONV swo_typeid( ls_objkey ).

    CALL FUNCTION 'SWE_EVENT_CREATE'
*      STARTING NEW TASK 'SWE_EVENT_CREATE'
      EXPORTING
        objtype           = lc_objtype
        objkey            = lv_objkey
        event             = lc_event
*       no_commit_for_queue = abap_true
      EXCEPTIONS
        objtype_not_found = 1
        OTHERS            = 2.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD busca_aprovadores.

* ---------------------------------------------------------------------------
* Método chamado no WF. Debugar com usuário SAP_WFRT
* ---------------------------------------------------------------------------

    TYPES: BEGIN OF ty_objkey,
             reference    TYPE zttm_gkot009-xblnr,
             cnpj         TYPE zttm_gkot009-stcd1,
             documentdate TYPE zttm_gkot009-bldat,
           END OF ty_objkey.


    DATA: lt_org_units    TYPE TABLE OF rhldapo,
          lt_org_pers_rel TYPE TABLE OF rhldapop,
          lt_person_tab   TYPE STANDARD TABLE OF rhldapp,
          lt_001_key      TYPE STANDARD TABLE OF zttm_gkot001,
          ls_objkey       TYPE ty_objkey.

    ls_objkey = iv_objkey.

** ---------------------------------------------------------------------------
** Busca documento CTE
** ---------------------------------------------------------------------------
*    SELECT DISTINCT xblnr, stcd1, bldat, acckey
*        FROM zttm_gkot010
*        WHERE xblnr EQ @ls_objkey-reference
*          AND stcd1 EQ @ls_objkey-cnpj
*          AND bldat EQ @ls_objkey-documentdate
*        INTO TABLE @DATA(lt_gkot010).
*
*    IF lt_gkot010 IS NOT INITIAL.
*      SELECT acckey, bukrs, branch
*        FROM zttm_gkot001
*        FOR ALL ENTRIES IN @lt_gkot010
*        WHERE acckey EQ @lt_gkot010-acckey
*        APPENDING TABLE @DATA(lt_gkot001).
*    ENDIF.
*
** ---------------------------------------------------------------------------
** Busca documento NFS ou NFE
** ---------------------------------------------------------------------------
*    SELECT DISTINCT xblnr, stcd1, bldat, docdat, prefno, nfnum, nfenum, series, stcd1_transp
*      FROM zttm_gkot011
*      WHERE xblnr EQ @ls_objkey-reference
*        AND stcd1 EQ @ls_objkey-cnpj
*        AND bldat EQ @ls_objkey-documentdate
*      INTO TABLE @DATA(lt_gkot011).
*
*    IF lt_gkot011 IS NOT INITIAL.
*
*      lt_001_key = VALUE #( FOR ls_011 IN lt_gkot011 ( budat         = ls_011-docdat
*                                                       prefno        = ls_011-prefno
*                                                       nfnum9        = ls_011-nfenum
*                                                       series        = ls_011-series
*                                                       emit_cnpj_cpf = ls_011-stcd1_transp ) ).
*
*      SELECT acckey, bukrs, branch
*        FROM zttm_gkot001
*        FOR ALL ENTRIES IN @lt_001_key
*        WHERE budat         EQ @lt_001_key-budat
*          AND prefno        EQ @lt_001_key-prefno
*          AND nfnum9        EQ @lt_001_key-nfnum9
*          AND series        EQ @lt_001_key-series
*          AND emit_cnpj_cpf EQ @lt_001_key-emit_cnpj_cpf
*        APPENDING TABLE @lt_gkot001.
*    ENDIF.


    SELECT DISTINCT xblnr, stcd1, bldat
        FROM zttm_gkot009
        WHERE xblnr EQ @ls_objkey-reference
          AND stcd1 EQ @ls_objkey-cnpj
          AND bldat EQ @ls_objkey-documentdate
        INTO TABLE @DATA(lt_gkot009).

    IF lt_gkot009 IS NOT INITIAL.

      lt_001_key = VALUE #( FOR ls_009 IN lt_gkot009 ( num_fatura         = ls_009-xblnr
                                                       emit_cnpj_cpf      = ls_009-stcd1 ) ).

      SELECT acckey, bukrs, branch
        FROM zttm_gkot001
        FOR ALL ENTRIES IN @lt_001_key
        WHERE num_fatura    EQ @lt_001_key-num_fatura
          AND emit_cnpj_cpf EQ @lt_001_key-emit_cnpj_cpf
        APPENDING TABLE @DATA(lt_gkot001).
    ENDIF.

    TRY.
        DATA(ls_gko001) = lt_gkot001[ 1 ].
      CATCH cx_sy_itab_line_not_found INTO DATA(ls_exception).
        RAISE nobody_found.
    ENDTRY.

    LOOP AT it_container ASSIGNING FIELD-SYMBOL(<fs_container>).
      CASE <fs_container>-element.
        WHEN 'NIVEL'.
          DATA(lv_nivel) = <fs_container>-value.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    IF lv_nivel IS INITIAL.
      RAISE nobody_found.
    ENDIF.

    " Recupera parâmetros
    me->busca_parametros( IMPORTING es_parametros = DATA(ls_parametros) ).

    IF ls_parametros-root IS INITIAL.
      RAISE nobody_found.
    ENDIF.

    CALL FUNCTION 'RH_DIR_ORG_STRUC_GET'
      EXPORTING
        act_orgunit     = ls_parametros-root
      TABLES
        org_units       = lt_org_units
        person_tab      = lt_person_tab
        org_pers_rel    = lt_org_pers_rel
      EXCEPTIONS
        no_active_plvar = 1
        OTHERS          = 2.
    IF sy-subrc NE 0.
      RAISE nobody_found.
    ENDIF.

    SORT lt_org_units    BY parentid short.
    SORT lt_org_pers_rel BY orgid postitle.

    " Busca o nó raiz
    READ TABLE lt_org_units INTO DATA(ls_org_root) WITH KEY parentid = '00000000'
                                                            BINARY SEARCH.
    IF sy-subrc NE 0.
      RAISE nobody_found.
    ENDIF.

    " Busca a empresa
    READ TABLE lt_org_units INTO DATA(ls_org_company) WITH KEY parentid = ls_org_root-orgid
                                                               short    = ls_gko001-bukrs
                                                               BINARY SEARCH.
    IF sy-subrc NE 0.
      RAISE nobody_found.
    ENDIF.

    CASE lv_nivel.

      WHEN '01'.

        " Busca loca de negócio
        READ TABLE lt_org_units INTO DATA(ls_org_branch) WITH KEY parentid = ls_org_company-orgid
                                                                  short    = ls_gko001-branch
                                                                  BINARY SEARCH.
        IF sy-subrc NE 0.
          RAISE nobody_found.
        ENDIF.

        " Adiciona os usuários vinculados ao local de negócio (nivel 01)
        LOOP AT lt_org_pers_rel ASSIGNING FIELD-SYMBOL(<fs_org_pers_rel>).

          CHECK <fs_org_pers_rel>-orgid EQ ls_org_branch-orgid.

          APPEND VALUE #( otype = <fs_org_pers_rel>-otype
                          objid = <fs_org_pers_rel>-objid ) TO ct_actor_tab.
        ENDLOOP.

      WHEN '02'.

        " Adiciona os usuários vinculados à empresa (nivel 02)
        LOOP AT lt_org_pers_rel ASSIGNING <fs_org_pers_rel>.

          CHECK <fs_org_pers_rel>-orgid EQ ls_org_company-orgid.

          APPEND VALUE #( otype = <fs_org_pers_rel>-otype
                          objid = <fs_org_pers_rel>-objid ) TO ct_actor_tab.
        ENDLOOP.

    ENDCASE.

    IF ct_actor_tab[] IS INITIAL.
      RAISE nobody_found.
    ENDIF.

  ENDMETHOD.


  METHOD busca_nivel_desconto.

* ---------------------------------------------------------------------------
* Método chamado no WF. Debugar com usuário SAP_WFRT
* ---------------------------------------------------------------------------

    DATA: lv_desconto TYPE wrbtr.

    FREE: ev_nivel.

    me->busca_parametros( IMPORTING es_parametros = DATA(ls_parametros) ).

    " Busca valores
    SELECT SINGLE *
        FROM zttm_gkot009
        INTO @DATA(ls_009)
        WHERE xblnr = @iv_xblnr
          AND stcd1 = @iv_stcd1
          AND bldat = @iv_bldat.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    " Calcula percentual (%) de desconto.
    TRY.
        lv_desconto = ( ls_009-newdis / ls_009-newtr ) * 100.
      CATCH cx_root.
        lv_desconto = 0.
    ENDTRY.

    " Se Desconto for abaixo do cadastrado (15%) então nivel 1.
    " Se Desconto for acima do cadastrado (15%) então nivel 2.
    ev_nivel = COND #( WHEN lv_desconto IS INITIAL
                       THEN 0
                       WHEN lv_desconto <= ls_parametros-desconto
                       THEN 1
                       ELSE 2 ).

  ENDMETHOD.


  METHOD efetivar_agrupamento.

    DATA: lt_faturas     TYPE zctgtm_gko009,
          lt_return      TYPE bapiret2_t,
          lt_bapi_return TYPE bapiret2_t,
          lt_msgs        TYPE bapiret2_t.

    FREE: et_return, et_bapi_return.

    CHECK it_xblnr IS NOT INITIAL OR ir_xblnr IS NOT INITIAL.

    IF it_xblnr IS NOT INITIAL.

      SELECT
          t001~acckey,
          t001~codstatus,
          t001~num_fatura,
          t001~emit_cnpj_cpf
        FROM zttm_gkot001 AS t001
        FOR ALL ENTRIES IN @it_xblnr
        WHERE t001~num_fatura EQ @it_xblnr-table_line
          AND t001~codstatus  EQ @zclfi_gko_incoming_invoice=>gc_codstatus-aguardando_reagrupamento
        INTO TABLE @DATA(lt_header).

    ELSEIF ir_xblnr IS NOT INITIAL.

      SELECT
          t001~acckey,
          t001~codstatus,
          t001~num_fatura,
          t001~emit_cnpj_cpf
        FROM zttm_gkot001 AS t001
        INTO TABLE @lt_header
        WHERE t001~num_fatura IN @ir_xblnr
          AND t001~codstatus  EQ @zclfi_gko_incoming_invoice=>gc_codstatus-aguardando_reagrupamento.

    ENDIF.

    IF lt_header IS INITIAL.
      "-- Nenhum registro válido foi encontrado
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GKO' number = '124' ) ).
      RETURN.
    ENDIF.

    SORT lt_header BY num_fatura emit_cnpj_cpf.
    DATA(lt_header_key) = lt_header.
    SORT lt_header_key BY num_fatura emit_cnpj_cpf.
    DELETE ADJACENT DUPLICATES FROM lt_header_key COMPARING num_fatura emit_cnpj_cpf.

    LOOP AT lt_header_key ASSIGNING FIELD-SYMBOL(<fs_s_header_key>).

      FREE: lt_return, lt_bapi_return.

      DATA(lo_invoice) = NEW zclfi_gko_incoming_invoice( ).

      lo_invoice->set_invoice( iv_invoice_number = <fs_s_header_key>-num_fatura
                               iv_cnpj_issue     = CONV #( <fs_s_header_key>-emit_cnpj_cpf ) ).

      lo_invoice->check_status( IMPORTING et_return = lt_return ).

      IF lt_return IS NOT INITIAL.
        INSERT LINES OF lt_return INTO TABLE et_bapi_return.
        CONTINUE.
      ENDIF.

      lo_invoice->start( ).

      DATA(lt_errors) = lo_invoice->get_errors( IMPORTING et_return = lt_return  ).

*      DATA(lt_errors) = NEW zclfi_gko_incoming_invoice( )->set_invoice( iv_invoice_number = <fs_s_header_key>-num_fatura
*                                                                        iv_cnpj_issue     = CONV #( <fs_s_header_key>-emit_cnpj_cpf )
*                            )->start(  )->get_errors( IMPORTING et_return = lt_return ).

      lt_bapi_return =  NEW zcxtm_gko_incoming_invoice( gt_errors = lt_errors )->get_bapi_return( ).
      lt_msgs = CORRESPONDING #( BASE ( lt_msgs ) lt_bapi_return ).
      lt_msgs = CORRESPONDING #( BASE ( lt_msgs ) lt_return ).

* ---------------------------------------------------------------------------
* Atualiza log
* ---------------------------------------------------------------------------
      LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_s_header>) WHERE num_fatura    = <fs_s_header_key>-num_fatura
                                                                AND emit_cnpj_cpf = <fs_s_header_key>-emit_cnpj_cpf.
        TRY.
            DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey = <fs_s_header>-acckey ).
            lr_gko_process->set_status( iv_status   = COND #( WHEN NOT line_exists( lt_msgs[ type = 'E' ] )
                                                              THEN zcltm_gko_process=>gc_codstatus-agrupamento_efetuado
                                                              WHEN sy-batch EQ abap_true
                                                              THEN zcltm_gko_process=>gc_codstatus-erro_agrupamento
                                                              ELSE zcltm_gko_process=>gc_codstatus-erro_agrupamento_manual )
                                        it_bapi_ret = lt_msgs ).
            lr_gko_process->persist( ).
            lr_gko_process->free( ).
          CATCH cx_root.
        ENDTRY.
      ENDLOOP.

      INSERT LINES OF lt_msgs INTO TABLE et_bapi_return.

    ENDLOOP.

  ENDMETHOD.


  METHOD show_log.

    CHECK it_return[] IS NOT INITIAL.

* ----------------------------------------------------------------------
* Filter information
* ----------------------------------------------------------------------
    DATA(lt_message) = VALUE esp1_message_tab_type(
                       FOR ls_return IN it_return ( msgid  = ls_return-id
                                                    msgty  = ls_return-type
                                                    msgno  = ls_return-number
                                                    msgv1  = ls_return-message_v1
                                                    msgv2  = ls_return-message_v2
                                                    msgv3  = ls_return-message_v3
                                                    msgv4  = ls_return-message_v4
                                                    lineno = sy-tabix ) ).

* ----------------------------------------------------------------------
* Show multiple messages as pop-up
* ----------------------------------------------------------------------
    IF lines( lt_message[] ) GT 1.

      CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
        TABLES
          i_message_tab = lt_message[].

* ----------------------------------------------------------------------
* Show single message
* ----------------------------------------------------------------------
    ELSE.

      TRY.
          DATA(ls_message) = lt_message[ 1 ].

          MESSAGE ID ls_message-msgid
                TYPE 'S'
              NUMBER ls_message-msgno
             DISPLAY
                LIKE ls_message-msgty
                WITH ls_message-msgv1
                     ls_message-msgv2
                     ls_message-msgv3
                     ls_message-msgv4.

        CATCH cx_root.
      ENDTRY.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
