CLASS zclmm_gko_process_doc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_selopt,
        bukrs  TYPE RANGE OF zttm_gkot001-bukrs,
        branch TYPE RANGE OF zttm_gkot001-branch,
        acckey TYPE RANGE OF zttm_gkot001-acckey,
        tcnpjc TYPE RANGE OF zttm_gkot001-tom_cnpj_cpf,
        tom_ie TYPE RANGE OF zttm_gkot001-tom_ie,
      END OF ty_selopt.

    METHODS constructor
      IMPORTING
        !ir_bukrs  TYPE ty_selopt-bukrs
        !ir_branch TYPE ty_selopt-branch
        !ir_acckey TYPE ty_selopt-acckey
        !ir_tcnpjc TYPE ty_selopt-tcnpjc
        !ir_tom_ie TYPE ty_selopt-tom_ie .
    METHODS get_data .
    METHODS process .

    "! Exibe logs
    "! @parameter iv_popup | Força exibição do popup
    "! @parameter it_return | Mensagens de retorno
    METHODS show_log
      IMPORTING
        !iv_popup  TYPE flag DEFAULT abap_false
        !it_return TYPE bapiret2_t OPTIONAL.

    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING
        !is_param TYPE ztca_param_val
      EXPORTING
        !et_value TYPE any .

    METHODS release_settlement
      IMPORTING is_doc    TYPE zi_mm_get_gko_doc
      EXPORTING et_return TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_001,
        acckey       TYPE zttm_gkot001-acckey,
        codstatus    TYPE zttm_gkot001-codstatus,
        tpdoc        TYPE zttm_gkot001-tpdoc,
        bukrs        TYPE zttm_gkot001-bukrs,
        branch       TYPE zttm_gkot001-branch,
        dtemi        TYPE zttm_gkot001-dtemi,
        model        TYPE zttm_gkot001-model,
        series       TYPE zttm_gkot001-series,
        prefno       TYPE zttm_gkot001-prefno,
        emit_cod     TYPE zttm_gkot001-emit_cod,
        tom_cnpj_cpf TYPE zttm_gkot001-tom_cnpj_cpf,
        tom_ie       TYPE zttm_gkot001-tom_ie,
        tom_uf       TYPE zttm_gkot001-tom_uf,
      END OF ty_001 .
    TYPES:
      BEGIN OF ty_005,
        acckey TYPE zttm_gkot005-acckey,
        ebeln  TYPE zttm_gkot005-ebeln,
        lblni  TYPE zttm_gkot005-lblni,
        ebelp  TYPE zttm_gkot005-ebelp,
      END OF ty_005 .
    TYPES:
      BEGIN OF ty_ekpo,
        ebeln TYPE ekpo-ebeln,
        ebelp TYPE ekpo-ebelp,
        zterm TYPE ekko-zterm,
      END OF ty_ekpo .
    TYPES:
      ty_t_001 TYPE TABLE OF ty_001 .
    TYPES:
      ty_t_005 TYPE TABLE OF ty_005 .
    TYPES:
      ty_t_ekpo TYPE TABLE OF ty_ekpo .
    TYPES ty_doc TYPE zi_mm_get_gko_doc .
    TYPES:
      ty_t_doc TYPE STANDARD TABLE OF ty_doc .

    DATA gt_doc TYPE ty_t_doc .
    DATA gt_001 TYPE ty_t_001 .
    DATA gt_005 TYPE ty_t_005 .
    DATA gs_selopt TYPE ty_selopt .
    DATA gt_return TYPE bapiret2_tab .
    DATA gt_ekpo TYPE ty_t_ekpo .
    CONSTANTS gc_po_created TYPE char3 VALUE '300' ##NO_TEXT.
    CONSTANTS gc_cte TYPE ze_gko_tpdoc VALUE 'CTE' ##NO_TEXT.
    CONSTANTS gc_nf55 TYPE j_1bnftype VALUE '55' ##NO_TEXT.
    CONSTANTS gc_nfs TYPE ze_gko_tpdoc VALUE 'NFS' ##NO_TEXT.
    CONSTANTS gc_nfe TYPE ze_gko_tpdoc VALUE 'NFE' ##NO_TEXT.
    DATA gv_bloq_pag TYPE ze_gko_parametro .
    DATA gv_doctype TYPE ze_gko_parametro .
    DATA gv_curr TYPE ze_gko_parametro .
    DATA gv_txt TYPE ze_gko_parametro .
    DATA:
      gr_witht  TYPE RANGE OF lfbw-witht .

    METHODS get_master_data .
    METHODS fill_bapi_item
      IMPORTING
        !is_doc_h   TYPE ty_doc
        !it_doc_i   TYPE ty_t_doc
      EXPORTING
        !et_tm_item TYPE tb_bapi_incinv_create_tm_item .
    METHODS get_param
      IMPORTING
        !iv_id          TYPE ze_gko_id
      RETURNING
        VALUE(rv_param) TYPE ze_gko_parametro .
    METHODS get_parameters
      EXPORTING
        !et_return TYPE bapiret2_t .
    METHODS fill_bapi_header
      IMPORTING
        !is_doc_h  TYPE ty_doc
      EXPORTING
        !es_header TYPE bapi_incinv_create_header .
    METHODS fill_bapi
      IMPORTING
        !is_doc_h   TYPE ty_doc
        !it_doc_i   TYPE ty_t_doc
      EXPORTING
        !es_header  TYPE bapi_incinv_create_header
        !et_tm_item TYPE tb_bapi_incinv_create_tm_item
        !et_account TYPE bapi_incinv_create_account_t .
    METHODS fill_bapi_acc
      IMPORTING
        !is_doc_h   TYPE ty_doc
        !it_doc_i   TYPE ty_t_doc
      EXPORTING
        !et_account TYPE bapi_incinv_create_account_t .
    METHODS bapi_miro
      IMPORTING
        !is_doc              TYPE zi_mm_get_gko_doc
        !is_header           TYPE bapi_incinv_create_header
        !it_tm_item          TYPE tb_bapi_incinv_create_tm_item
        !it_account          TYPE bapi_incinv_create_account_t
      EXPORTING
        !ev_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no
        !ev_fiscalyear       TYPE bapi_incinv_fld-fisc_year
        !et_return           TYPE bapiret2_t .
    METHODS determine_nfs_invoice_status
      IMPORTING
        !is_doc                 TYPE zi_mm_get_gko_doc
      RETURNING
        VALUE(rv_invoicestatus) TYPE rbstat .
    METHODS save_log
      IMPORTING
        !iv_acckey           TYPE zttm_gkot001-acckey
        !iv_codstatus        TYPE zttm_gkot006-codstatus
        !iv_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no OPTIONAL
        !iv_fiscalyear       TYPE bapi_incinv_fld-fisc_year OPTIONAL
        !it_return           TYPE bapiret2_t OPTIONAL .
    METHODS set_status
      IMPORTING
        !iv_acckey           TYPE zttm_gkot001-acckey
        !iv_codstatus        TYPE ze_gko_codstatus
        !iv_invoicedocnumber TYPE bapi_incinv_fld-inv_doc_no OPTIONAL
        !iv_fiscalyear       TYPE bapi_incinv_fld-fisc_year OPTIONAL .
    "! Formata as mensages de retorno
    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t .
ENDCLASS.



CLASS ZCLMM_GKO_PROCESS_DOC IMPLEMENTATION.


  METHOD constructor.

    gs_selopt-acckey = ir_acckey.
    gs_selopt-branch = ir_branch.
    gs_selopt-bukrs  = ir_bukrs.
    gs_selopt-tcnpjc = ir_tcnpjc.
    gs_selopt-tom_ie = ir_tom_ie.

    me->get_parameters( IMPORTING et_return = gt_return ).

  ENDMETHOD.


  METHOD fill_bapi.

    FREE: es_header, et_tm_item, et_account.

    fill_bapi_header( EXPORTING is_doc_h  = is_doc_h
                      IMPORTING es_header = es_header ).

    fill_bapi_item( EXPORTING is_doc_h   = is_doc_h
                              it_doc_i   = it_doc_i
                    IMPORTING et_tm_item = et_tm_item ).

    fill_bapi_acc( EXPORTING is_doc_h   = is_doc_h
                             it_doc_i   = it_doc_i
                   IMPORTING et_account = et_account ).

  ENDMETHOD.


  METHOD fill_bapi_header.

    FREE es_header.
    es_header-comp_code      = is_doc_h-po_bukrs.      " is_doc_h-bukrs.
    es_header-doc_date       = is_doc_h-dtemi.
    es_header-pstng_date     = sy-datum.
    es_header-calc_tax_ind   = abap_true.
    es_header-invoice_ind    = abap_true.

    IF is_doc_h-tpdoc EQ gc_cte OR is_doc_h-model = gc_nf55.
      es_header-gross_amount = is_doc_h-vtprest.
    ELSE.
      es_header-gross_amount = is_doc_h-vrec.
    ENDIF.

    IF is_doc_h-lifnr IS NOT INITIAL.
      es_header-diff_inv    = is_doc_h-lifnr.
    ELSE.
      " Emitente ZTTM_COCKPIT001-EMIT_COD não ampliado para fornecedor.
    ENDIF.

    es_header-pmnt_block    = gv_bloq_pag.
    es_header-doc_type      = gv_doctype.
    es_header-currency      = gv_curr.
    es_header-currency_iso  = gv_curr.
    es_header-item_text     = gv_txt.
    es_header-ref_doc_no    = is_doc_h-xblnr.

    " Solução temporária para não parar na validação dentro do ZCLFI_VALIDA_DOCPAGAR-VALIDA_U101
    IF es_header-doc_type = 'KR'.
      es_header-header_txt = 'ADM3CAF'.
    ELSE.
      es_header-header_txt = is_doc_h-xblnr.
    ENDIF.

    es_header-pmnttrms   = is_doc_h-zterm.
    es_header-j_1bnftype = is_doc_h-nftype.

    IF is_doc_h-werks IS INITIAL.
      "Centro do tomador não encontrado".
    ENDIF.

  ENDMETHOD.


  METHOD fill_bapi_item.

    FREE: et_tm_item.

    DATA lv_item TYPE i.

    " Monta tabela de chaves
    DATA(lt_doc_i) = it_doc_i[].
    SORT lt_doc_i BY acckey ebeln.
    DELETE ADJACENT DUPLICATES FROM lt_doc_i COMPARING acckey ebeln.

    " Recupera dados do pedido
    IF lt_doc_i[] IS NOT INITIAL.

      SELECT ebeln,
             ebelp,
             netwr,
             menge,
             meins,
             mwskz,
             txjcd,
             loekz
        FROM ekpo
        INTO TABLE @DATA(lt_ekpo)
        FOR ALL ENTRIES IN @lt_doc_i
        WHERE ebeln EQ @lt_doc_i-ebeln
          AND loekz NE 'L'.

      IF sy-subrc NE 0.
        FREE lt_ekpo.
      ENDIF.
    ENDIF.

    SORT lt_ekpo BY ebeln DESCENDING
                    ebelp ASCENDING.

    " Transfere dados de pedido
    LOOP AT lt_ekpo REFERENCE INTO DATA(ls_ekpo).

      ADD 1 TO lv_item.

      et_tm_item = VALUE #( BASE et_tm_item (
                   invoice_doc_item = lv_item
                   tor_number       = is_doc_h-tor_id
                   po_number        = ls_ekpo->ebeln
                   po_item          = ls_ekpo->ebelp
                   amt_doccur       = ls_ekpo->netwr
                   tax_code         = ls_ekpo->mwskz
                   taxjurcode       = ls_ekpo->txjcd ) ).

      EXIT.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_data.

*    CHECK NOT line_exists( me->gt_return[ type = 'E' ] ).

    SELECT * FROM zi_mm_get_gko_doc
       INTO TABLE @gt_doc
       WHERE acckey       IN @gs_selopt-acckey
         AND bukrs        IN @gs_selopt-bukrs
         AND branch       IN @gs_selopt-branch
         AND tom_cnpj_cpf IN @gs_selopt-tcnpjc
         AND tom_ie       IN @gs_selopt-tom_ie.

    IF sy-subrc NE 0.
      FREE gt_doc.
    ENDIF.

  ENDMETHOD.


  METHOD get_master_data.

    SELECT acckey,
           codstatus,
           tpdoc,
           bukrs,
           branch,
           dtemi,
           model,
           series,
           prefno,
           emit_cod,
           tom_cnpj_cpf,
           tom_ie,
           tom_uf
      FROM zttm_gkot001
      INTO TABLE @gt_001
      WHERE acckey       IN @gs_selopt-acckey
        AND bukrs        IN @gs_selopt-bukrs
        AND branch       IN @gs_selopt-branch
        AND tom_cnpj_cpf IN @gs_selopt-tcnpjc
        AND tom_ie       IN @gs_selopt-tom_ie.

  ENDMETHOD.


  METHOD get_param.

    SELECT SINGLE parametro
      FROM zttm_pcockpit001
      INTO rv_param
      WHERE id = iv_id.

  ENDMETHOD.


  METHOD get_parameters.

    CONSTANTS: lc_bloq_pag TYPE ze_gko_id VALUE '18',
               lc_doctype  TYPE ze_gko_id VALUE '17',
               lc_curr     TYPE ze_gko_id VALUE '04',
               lc_txt      TYPE ze_gko_id VALUE '06'.

    FREE: et_return.

    gv_bloq_pag = get_param( lc_bloq_pag ).
    gv_doctype  = get_param( lc_doctype ).
    gv_curr     = get_param( lc_curr ).
*    gv_txt      = get_param( lc_txt ).

    IF gv_bloq_pag IS INITIAL.
      " Parâmetro &1 de "&2" não encontrado na tabela de parâmetros &3.
      et_return = VALUE #( BASE et_return ( type       = 'E'
                                            id         = 'ZTM_GKO'
                                            number     = '101'
                                            message_v1 = lc_bloq_pag
                                            message_v2 = TEXT-p18
                                            message_v3 = 'ZTTM_PCOCKPIT001' ) ).
    ENDIF.

    IF gv_doctype IS INITIAL.
      " Parâmetro &1 de "&2" não encontrado na tabela de parâmetros &3.
      et_return = VALUE #( BASE et_return ( type       = 'E'
                                            id         = 'ZTM_GKO'
                                            number     = '101'
                                            message_v1 = lc_doctype
                                            message_v2 = TEXT-p17
                                            message_v3 = 'ZTTM_PCOCKPIT001') ).
    ENDIF.

    IF gv_curr IS INITIAL.
      " Parâmetro &1 de "&2" não encontrado na tabela de parâmetros &3.
      et_return = VALUE #( BASE et_return ( type       = 'E'
                                            id         = 'ZTM_GKO'
                                            number     = '101'
                                            message_v1 = lc_curr
                                            message_v2 = TEXT-p04
                                            message_v3 = 'ZTTM_PCOCKPIT001' ) ).
    ENDIF.

*    IF gv_txt IS INITIAL.
*      " Parâmetro &1 de "&2" não encontrado na tabela de parâmetros &3.
*      et_return = VALUE #( BASE et_return ( type       = 'E'
*                                            id         = 'ZTM_GKO'
*                                            number     = '101'
*                                            message_v1 = lc_txt
*                                            message_v2 = TEXT-p05
*                                            message_v3 = 'ZTTM_PCOCKPIT001'  ) ).
*    ENDIF.

  ENDMETHOD.


  METHOD process.

    DATA: lt_return TYPE bapiret2_t.

    " Ordena registros para o cabeçalho
    DATA(lt_doc_header) = gt_doc.
    SORT lt_doc_header BY acckey ASCENDING
                          ebeln  DESCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_doc_header COMPARING acckey.

    " Ordena registros para o item
    DATA(lt_doc_item) = gt_doc.
    SORT lt_doc_item BY acckey ASCENDING
                        ebeln  DESCENDING.

    IF line_exists( me->gt_return[ type = 'E' ] ).
      LOOP AT lt_doc_header ASSIGNING FIELD-SYMBOL(<fs_doc>).
        me->save_log( EXPORTING iv_acckey           = <fs_doc>-acckey
                                iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
                                it_return           = me->gt_return ).
        me->set_status( EXPORTING iv_acckey           = <fs_doc>-acckey
                                  iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro ).
      ENDLOOP.
      RETURN.
    ENDIF.

    LOOP AT lt_doc_header ASSIGNING <fs_doc>.

      FREE: lt_return.

      CHECK <fs_doc>-codstatus EQ gc_po_created.

      IF <fs_doc>-lifecycle NE '04'. " Lançado

        " Documento Faturamento de Frete (DFF) ainda não foi lançado.
        me->save_log( EXPORTING iv_acckey           = <fs_doc>-acckey
                                iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
                                it_return           = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '115'  ) ) ).

        me->set_status( EXPORTING iv_acckey           = <fs_doc>-acckey
                                  iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro ).

        " Erro durante faturamento para chave &1.
        lt_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '114' message_v1 = <fs_doc>-acckey ) ).
        INSERT LINES OF lt_return INTO TABLE gt_return.

        CONTINUE.
      ENDIF.

      IF <fs_doc>-confirmation NE '03'. " Confirmado

        " Documento Faturamento de Frete (DFF) ainda não foi confirmado.
        me->save_log( EXPORTING iv_acckey           = <fs_doc>-acckey
                                iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
                                it_return           = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '116'  ) ) ).

        me->set_status( EXPORTING iv_acckey           = <fs_doc>-acckey
                                  iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro ).

        " Erro durante faturamento para chave &1.
        lt_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '114' message_v1 = <fs_doc>-acckey ) ).
        INSERT LINES OF lt_return INTO TABLE gt_return.

        CONTINUE.
      ENDIF.

      IF <fs_doc>-ebeln IS INITIAL.

        " Pedido não encontrado.
        me->save_log( EXPORTING iv_acckey           = <fs_doc>-acckey
                                iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro " <fs_doc>-codstatus
                                it_return           = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '111'  ) ) ).

        me->set_status( EXPORTING iv_acckey           = <fs_doc>-acckey
                                  iv_codstatus        = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro ).

        " Pedido não encontrado para chave &1.
        lt_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '112' message_v1 = <fs_doc>-acckey ) ).
        INSERT LINES OF lt_return INTO TABLE gt_return.

        CONTINUE.
      ENDIF.

      SELECT COUNT(*) FROM zttm_gkot001 WHERE acckey = <fs_doc>-acckey AND tpdoc = 'NFS'. "#EC CI_SEL_NESTED
      IF sy-subrc = 0.
        SELECT COUNT(*) FROM zi_tm_attachment_file   "#EC CI_SEL_NESTED
        WHERE tor_id = @<fs_doc>-tor_id
          AND acckey = @<fs_doc>-acckey
          AND comprovante_nfs > 0.
        IF sy-subrc <> 0.
          " Sem anexo atribuído.
          me->save_log( EXPORTING iv_acckey           = <fs_doc>-acckey
                                  iv_codstatus        = zcltm_gko_process=>gc_codstatus-sem_anexo_atribuido             " CHANGE - JWSILVA - 03.04.2023
                                  it_return           = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '110'  ) ) ).

          me->set_status( EXPORTING iv_acckey           = <fs_doc>-acckey
                                    iv_codstatus        = zcltm_gko_process=>gc_codstatus-sem_anexo_atribuido ).        " CHANGE - JWSILVA - 03.04.2023

          " Sem anexo atribuído para chave &1.
          lt_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '152' message_v1 = <fs_doc>-acckey ) ).
          INSERT LINES OF lt_return INTO TABLE gt_return.
          CONTINUE.
        ENDIF.
      ENDIF.

      " Cria documento de faturamento
      IF <fs_doc>-re_belnr IS INITIAL.

        me->fill_bapi( EXPORTING is_doc_h   = <fs_doc>
                                 it_doc_i   = lt_doc_item
                       IMPORTING es_header  = DATA(ls_header)
                                 et_tm_item = DATA(lt_tm_item)
                                 et_account = DATA(lt_account)
                                  ).

        bapi_miro( EXPORTING is_doc              = <fs_doc>
                             is_header           = ls_header
                             it_tm_item          = lt_tm_item
                             it_account          = lt_account
                   IMPORTING ev_invoicedocnumber = <fs_doc>-re_belnr
                             ev_fiscalyear       = <fs_doc>-re_gjahr
                             et_return           = lt_return ).

        INSERT LINES OF lt_return INTO TABLE gt_return[].

        IF <fs_doc>-re_belnr IS NOT INITIAL.

          " Libera Documento de distribuição de custo
          me->release_settlement( EXPORTING is_doc    = <fs_doc>
                                  IMPORTING et_return = lt_return ).

          me->save_log( EXPORTING iv_acckey           = <fs_doc>-acckey
                                  iv_codstatus        = <fs_doc>-codstatus
                                  it_return           = lt_return ).

          INSERT LINES OF lt_return INTO TABLE gt_return.
        ENDIF.

      ELSE.

        " Chave &1: Documento &2/&3 já criado.
        gt_return = VALUE #( BASE gt_return ( type = 'W' id = 'ZTM_GKO' number = '103'
                                              message_v1 = <fs_doc>-acckey
                                              message_v2 = <fs_doc>-re_belnr
                                              message_v3 = <fs_doc>-re_gjahr ) ).

      ENDIF.


    ENDLOOP.

  ENDMETHOD.


  METHOD show_log.

    IF it_return IS SUPPLIED.
      DATA(lt_return) = it_return.
    ELSE.
      lt_return = gt_return.
    ENDIF.

    CHECK lt_return[] IS NOT INITIAL.

* ----------------------------------------------------------------------
* Filter information
* ----------------------------------------------------------------------
    DATA(lt_message) = VALUE esp1_message_tab_type(
                       FOR ls_return IN lt_return ( msgid  = ls_return-id
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
    IF lines( lt_message[] ) GT 1 OR iv_popup EQ abap_true.

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


  METHOD save_log.

    DATA: lt_log TYPE STANDARD TABLE OF zttm_gkot006,
          ls_log TYPE zttm_gkot006.

    CHECK iv_acckey IS NOT INITIAL.

    SELECT MAX( counter )
        FROM zttm_gkot006
        INTO @DATA(lv_counter)
        WHERE acckey = @iv_acckey.

    IF sy-subrc EQ 0.
      lv_counter = lv_counter + 1.
    ELSE.
      lv_counter = 1.
    ENDIF.

    DATA(lt_return) = it_return.
    me->format_return( CHANGING ct_return = lt_return ).

    IF iv_invoicedocnumber IS NOT INITIAL.

      TRY.
          DATA(ls_return) = lt_return[ 1 ].
        CATCH cx_root.
      ENDTRY.

      CLEAR ls_log.
      ls_log-acckey       = iv_acckey.
      ls_log-counter      = lv_counter.
      ls_log-codstatus    = iv_codstatus.
      ls_log-tpprocess    = COND #( WHEN sy-batch EQ abap_true
                                    THEN '1'      " Automático
                                    ELSE '2' ).   " Manual
      ls_log-newdoc       = iv_invoicedocnumber && iv_fiscalyear.
      ls_log-codigo       = space.
      ls_log-desc_codigo  = ls_return-message.
      ls_log-credat       = sy-datum.
      ls_log-cretim       = sy-uzeit.
      ls_log-crenam       = sy-uname.
      APPEND ls_log TO lt_log.

    ELSE.

      LOOP AT lt_return INTO ls_return.

        CLEAR ls_log.
        ls_log-acckey       = iv_acckey.
        ls_log-counter      = lv_counter = lv_counter + 1.
        ls_log-codstatus    = iv_codstatus.
        ls_log-tpprocess    = COND #( WHEN sy-batch EQ abap_true
                                      THEN '1'      " Automático
                                      ELSE '2' ).   " Manual
        ls_log-newdoc       = ls_return-id.
        ls_log-codigo       = ls_return-number.
        ls_log-desc_codigo  = ls_return-message.
        ls_log-credat       = sy-datum.
        ls_log-cretim       = sy-uzeit.
        ls_log-crenam       = sy-uname.
        APPEND ls_log TO lt_log.

      ENDLOOP.

    ENDIF.

    IF lt_log IS NOT INITIAL.

      MODIFY zttm_gkot006 FROM TABLE lt_log.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ELSE.
        ROLLBACK WORK.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD set_status.

* ----------------------------------------------------------------------
* Salva novo documento criado
* ----------------------------------------------------------------------
    IF iv_invoicedocnumber IS NOT INITIAL.

      UPDATE zttm_gkot001 SET   re_belnr  = iv_invoicedocnumber
                                re_gjahr  = iv_fiscalyear
                                codstatus = iv_codstatus
                          WHERE acckey    = iv_acckey.
    ELSE.

      UPDATE zttm_gkot001 SET   codstatus = iv_codstatus
                          WHERE acckey    = iv_acckey.

    ENDIF.

    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

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


  METHOD bapi_miro.

    SELECT SINGLE *
      FROM tvarvc
      WHERE name = 'DEBUG_BAPI_MIRO'
        AND low = @abap_true
      INTO @DATA(ls_tvarvc).

    IF sy-subrc = 0.
      DO.
        DATA(lv_debug) = abap_true.
      ENDDO.
    ENDIF.

    FREE: et_return.
* ======================================================================
* Regra baseada na lógica do SCQ - Classe ZCL_GKO_PROCESS-CREATE_MIRO_PO
* ======================================================================

    DATA: lt_item    TYPE bapi_incinv_create_item_t,
          lt_wht     TYPE bapi_incinv_create_withtax_t,
          lt_return  TYPE bapiret2_t,
          ls_history TYPE j_1bnfe_history.

    FREE: ev_invoicedocnumber,
          ev_fiscalyear.

    DATA(ls_header)     = is_header.
    DATA(lt_tm_item)    = it_tm_item.
    DATA(lt_account)    = it_account.

    DATA(lv_invoicestatus) =  COND rbstat( WHEN is_doc-tpdoc EQ zcltm_gko_process=>gc_tpdoc-nfs
                                           THEN me->determine_nfs_invoice_status( EXPORTING is_doc = is_doc )
                                           ELSE zcltm_gko_process=>gc_invoice_status-registrado ).

    IF is_header-j_1bnftype = 'EX' OR is_header-j_1bnftype = 'OX'.
      lv_invoicestatus =  zcltm_gko_process=>gc_invoice_status-registrado.
    ENDIF.


    DATA(lv_codstatus) = is_doc-codstatus.

* ----------------------------------------------------------------------
* Executa validações antes de executar a MIRO
* ----------------------------------------------------------------------
    TRY.
        DATA(lo_gko_process) = NEW zcltm_gko_process(
          iv_acckey        = is_doc-acckey
          iv_tpprocess     = zcltm_gko_process=>gc_tpprocess-automatico
          iv_locked_in_tab = abap_true
          iv_min_data_load = abap_false ).

        lo_gko_process->validate_po_miro( it_item_data = CORRESPONDING #( lt_tm_item ) ).

        lo_gko_process->attach_is_valid( ).

*        lo_gko_process->check_status_sefaz_direct( iv_acckey = is_doc-acckey  ).

* BEGIN OF INSERT - JWSILVA - 16.05.2023
        lo_gko_process->check_cte_canceled( EXPORTING iv_raise_when_error = abap_true ).
* BEGIN OF INSERT - JWSILVA - 16.05.2023

        IF is_doc-tpcte = zcltm_gko_process=>gc_tpcte-complemento_de_valores.

          lo_gko_process->check_doc_orig_is_posted( ).

        ELSE.

          lo_gko_process->check_doc_memo_miro( IMPORTING et_return = DATA(lt_return_memo_miro) ). " Tabela de retorno

          IF lt_return_memo_miro IS NOT INITIAL.

            et_return[] = lt_return_memo_miro[].

            IF is_doc-tpcte <> zcltm_gko_process=>gc_tpcte-complemento_de_valores.

*              SELECT *
*                FROM lfbw
*               WHERE lifnr     = @is_doc-lifnr
*                 AND bukrs     = @is_doc-bukrs
*                 AND wt_subjct = @abap_true
*                 AND wt_withcd IS NOT INITIAL
*                INTO @DATA(ls_wht_memo).
*                APPEND VALUE #(
*                  split_key   = 1
*                  wi_tax_type = ls_wht_memo-witht
*                  wi_tax_code = ls_wht_memo-wt_withcd
*                ) TO lt_wht.
*
*              ENDSELECT.
*
*              IF lines( lt_wht ) > 0.
*                ls_header-calc_tax_ind = abap_true.
*              ENDIF.
*
*              FREE: ls_header-j_1bnftype.
*              FREE: lt_return.

*              CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
*                EXPORTING
*                  headerdata       = ls_header
*                  invoicestatus    = zcltm_gko_process=>gc_invoice_status-memorizado_entrado
*                IMPORTING
*                  invoicedocnumber = ev_invoicedocnumber
*                  fiscalyear       = ev_fiscalyear
*                TABLES
*                  itemdata         = lt_item
*                  withtaxdata      = lt_wht
*                  tm_itemdata      = lt_tm_item
*                  accountingdata   = lt_account
*                  return           = lt_return.
*
*              IF line_exists( lt_return[ type = 'E' ] ).
*                CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*              ELSE.
*                CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*                  EXPORTING
*                    wait = 'X'.

*                lv_codstatus = zcltm_gko_process=>gc_codstatus-miro_memorizada.
                lv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro.

                " Fatura &1 memorizada com sucesso.
                me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                                        iv_codstatus        = lv_codstatus
*                                        iv_invoicedocnumber = ev_invoicedocnumber
*                                        iv_fiscalyear       = ev_fiscalyear
                                        it_return           = lt_return_memo_miro ).

*                " Fatura &1 memorizada com sucesso.
*                me->save_log( EXPORTING iv_acckey           = is_doc-acckey
*                                        iv_codstatus        = lv_codstatus
*                                        iv_invoicedocnumber = ev_invoicedocnumber
*                                        iv_fiscalyear       = ev_fiscalyear
*                                        it_return           = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '118' message_v1 = |{ ev_invoicedocnumber }{ ev_fiscalyear }| ) ) ).

                me->set_status( EXPORTING iv_acckey           = is_doc-acckey
                                          iv_codstatus        = lv_codstatus ).
*                                          iv_invoicedocnumber = ev_invoicedocnumber
*                                          iv_fiscalyear       = ev_fiscalyear ).

*              ENDIF.
              RETURN.
            ENDIF.
          ENDIF.
        ENDIF.

      CATCH  zcxtm_gko_process INTO DATA(lo_cx_gko_process).

        et_return = lo_cx_gko_process->get_bapi_return( ).

    ENDTRY.

    TRY.
        IF lo_gko_process IS BOUND.
          lo_gko_process->persist( ).
          lo_gko_process->free( ).
        ELSE.

          me->save_log( EXPORTING iv_acckey    = is_doc-acckey
                                  iv_codstatus = is_doc-codstatus
                                  it_return    = et_return ).
        ENDIF.
      CATCH zcxtm_gko_process INTO lo_cx_gko_process.

    ENDTRY.

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Executa validações antes de executar a MIRO - Fornecedor
* ----------------------------------------------------------------------
    SELECT SINGLE partner_guid, vendor
      FROM cvi_vend_link
      INTO @DATA(ls_tomador)
      WHERE vendor = @is_doc-emit_cod.

    IF sy-subrc NE 0.
      " Emitente &1 não ampliado para fornecedor.
      et_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '109' message_v1 = is_doc-emit_cod ) ).

      me->save_log( EXPORTING iv_acckey    = is_doc-acckey
                              iv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
                              it_return    = et_return ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera referências
* ----------------------------------------------------------------------
    SELECT *
      FROM zttm_gkot003
      WHERE acckey = @is_doc-acckey
      INTO TABLE @DATA(lt_gko_references).

    DATA(ls_zttm_gkot003) = lt_gko_references[ 1 ].

    SELECT SINGLE docstat
      FROM j_1bnfdoc
      WHERE docnum = @ls_zttm_gkot003-docnum
      INTO @DATA(ls_docstat).

    IF ls_docstat <> 1.
      et_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '148' message_v1 = is_doc-acckey ) ).

      me->save_log( EXPORTING iv_acckey    = is_doc-acckey
                              iv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
                              it_return    = et_return ).


      lv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro.

      me->set_status( EXPORTING iv_acckey           = is_doc-acckey
                                iv_codstatus        = lv_codstatus
                                iv_invoicedocnumber = ev_invoicedocnumber
                                iv_fiscalyear       = ev_fiscalyear ).

      RETURN.

    ENDIF.

* ----------------------------------------------------------------------
* Recupera anexos
* ----------------------------------------------------------------------
    CASE is_doc-tpdoc.

      WHEN 'CTE'.

        TRY.
            DATA(lv_xml_ref) = zcltm_gko_process=>get_xml_from_ref_nf( iv_bukrs     = is_doc-bukrs
                                                                       iv_branch    = is_doc-branch
                                                                       iv_acckey    = is_doc-acckey
                                                                       iv_direction = 'INBD'
                                                                       iv_doctype   = CONV #( is_doc-tpdoc ) ).
          CATCH cx_root.
        ENDTRY.
      WHEN 'NFE'.
        TRY.
            lv_xml_ref = zcltm_gko_process=>get_xml_from_ref_nf( iv_bukrs     = is_doc-bukrs
                                                                 iv_branch    = is_doc-branch
                                                                 iv_acckey    = is_doc-acckey
                                                                 iv_direction = 'OUTB'
                                                                 iv_doctype   = CONV #( is_doc-tpdoc ) ).
          CATCH cx_root.
        ENDTRY.

        IF lv_xml_ref IS INITIAL.
          TRY.
              lv_xml_ref = zcltm_gko_process=>get_xml_from_ref_nf( iv_bukrs     = is_doc-bukrs
                                                                   iv_branch    = is_doc-branch
                                                                   iv_acckey    = is_doc-acckey
                                                                   iv_direction = 'INBD'
                                                                   iv_doctype   = CONV #( is_doc-tpdoc ) ).
            CATCH cx_root.
          ENDTRY.
        ENDIF.

      WHEN OTHERS.
        CLEAR lv_xml_ref.

    ENDCASE.

    SELECT SINGLE vicms FROM zttm_gkot001
      INTO @DATA(lv_vicms)
      WHERE acckey = @is_doc-acckey.
    IF sy-subrc = 0.
      SELECT kwert UP TO 1 ROWS
        FROM eslh AS _eslh
        INNER JOIN prcd_elements AS _elements
        ON  _elements~knumv = _eslh~knumv
        AND _elements~kschl = 'ZFTI'
        INTO @DATA(lv_kwert)
        WHERE _eslh~ebeln = @is_doc-ebeln.
      ENDSELECT.
      IF sy-subrc = 0.
        lv_kwert = lv_kwert * -1.
        IF lv_kwert > lv_vicms.
          et_return = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '151' ) ).
          me->save_log(
            iv_acckey    = is_doc-acckey
            iv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
            it_return    = et_return
          ).
          DATA(lv_icms_cte_maior_xml_memoriza) = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera pedidos
* ----------------------------------------------------------------------
    SELECT *
      FROM zi_mm_get_gko_doc005
      WHERE acckey = @is_doc-acckey
      INTO TABLE @DATA(lt_gko_acckey_po).

    "Limpa a variável para evitar o erro 8B 219 'Documento de referência  não encontrado'
    "O mesmo ocorre quando o estorno é realizado e em seguida é realizada a criação da fatura
    ASSIGN ('(SAPLJ1BI)STORNO_FLAG') TO FIELD-SYMBOL(<fs_storno_flag>).
    IF sy-subrc IS INITIAL.
      FREE: <fs_storno_flag>.
    ENDIF.

    "Exporta a chave de acesso, para o correto processamento do ENHANCEMENT ZEIMM_TRATATIVA_CFOP_SERVICO
    EXPORT gko_acckey = is_doc-acckey TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

* ----------------------------------------------------------------------
* Tentativa 1 - Chama BAPI de criação de fatura
* ----------------------------------------------------------------------
    SELECT *
      FROM lfbw
     WHERE lifnr     = @is_doc-lifnr
       AND bukrs     = @is_doc-bukrs
       AND wt_subjct = @abap_true
       AND wt_withcd IS NOT INITIAL
      INTO @DATA(ls_wht).
      APPEND VALUE #(
        split_key   = 1
        wi_tax_type = ls_wht-witht
        wi_tax_code = ls_wht-wt_withcd
      ) TO lt_wht.

    ENDSELECT.

    IF lines( lt_wht ) > 0.
      ls_header-calc_tax_ind = abap_true.
    ENDIF.

    IF lv_icms_cte_maior_xml_memoriza = abap_true.
      lv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.
      CLEAR ls_header-j_1bnftype.
    ELSE.
      IF is_header-j_1bnftype <> 'EX' AND is_header-j_1bnftype <> 'OX'.
        IF sy-cprog    = 'ZMMR_GKO_PROCESSA'.
          IF ( is_doc-crtn = '1' OR is_doc-crtn = '2' OR is_doc-crtn = '4' ) AND ( ls_header-j_1bnftype = 'ZK' ).
            lv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.
            CLEAR ls_header-j_1bnftype.
          ELSE.
            lv_invoicestatus = zcltm_gko_process=>gc_invoice_status-registrado.
          ENDIF.
        ENDIF.
      ELSE.
        lv_invoicestatus = zcltm_gko_process=>gc_invoice_status-registrado.
      ENDIF.
    ENDIF.


    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata       = ls_header
        invoicestatus    = lv_invoicestatus
      IMPORTING
        invoicedocnumber = ev_invoicedocnumber
        fiscalyear       = ev_fiscalyear
      TABLES
        itemdata         = lt_item
        withtaxdata      = lt_wht
        return           = lt_return
        tm_itemdata      = lt_tm_item
        accountingdata   = lt_account.

    " Limpa memória
    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

    IF line_exists( lt_return[ type = 'E' ] )
    OR line_exists( lt_return[ type = 'A' ] ).  " INSERT - JWSILVA - 20.03.2023
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      " Armazena os erros na primeira tentativa da criação da MIRO
      me->save_log( EXPORTING iv_acckey    = is_doc-acckey
                              iv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro
                              it_return    = lt_return ).

    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ENDIF.

* ----------------------------------------------------------------------
* Tentativa 2 - Em caso de erro de diferença, criar fatura passando diferença
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ id = 'ZTM_GKO' number = '084' ] ) OR
       line_exists( lt_return[ id = 'M8'      number = '534' ] ).

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_s_return>) WHERE ( id     = 'ZGKO'
                                                                AND   number = '084'  )
                                                                OR  ( id     = 'M8'
                                                                AND   number = '534'  ).
        DATA(lv_diferenca_str) = <fs_s_return>-message_v1.
        TRANSLATE lv_diferenca_str USING ',.. '.
        CONDENSE lv_diferenca_str NO-GAPS.
        EXIT.
      ENDLOOP.

      DATA(lv_diferenca) = CONV zttm_gkot001-vtprest( lv_diferenca_str ).

      SELECT SINGLE
             parametro
        FROM zttm_pcockpit001
        INTO @DATA(lv_p_max_diferenca)
        WHERE id = @zcltm_gko_process=>gc_params-diferenca_maxima_arredonda. "Diferença máxima arredondamento.

      DATA(lv_max_diferenca) = CONV zttm_gkot001-vtprest( lv_p_max_diferenca ).

      "Caso o valor do parâmetro seja negativo, aceitar apenas diferenças negativas,
      "Caso contrário, aceitar ambos os valores
      IF ( lv_max_diferenca < 0 AND lv_diferenca >= lv_max_diferenca ) OR
         ( lv_max_diferenca > 0 AND abs( lv_diferenca ) <= lv_max_diferenca ).

        "Atribui a diferença ao item de maior valor e que possua valor de ICMS

        DATA(lt_itemdata_aux) = lt_tm_item.
        SORT lt_itemdata_aux BY tax_code.
        DELETE ADJACENT DUPLICATES FROM lt_itemdata_aux COMPARING tax_code.

        "Obtêm os IVAs com valor de ICMS
        SELECT mwskz
          FROM a003
          INNER JOIN j_1baj
            ON ( j_1baj~taxtyp = a003~kschl )
          INTO TABLE @DATA(lt_ivas_w_icms)
          FOR ALL ENTRIES IN @lt_itemdata_aux
          WHERE a003~kappl    =  'TX'
            AND a003~aland    =  'BR'
            AND a003~mwskz    =  @lt_itemdata_aux-tax_code
            AND j_1baj~taxtyp <> 'ICM0'
            AND j_1baj~taxgrp =  'ICMS'.

        SORT lt_tm_item BY amt_doccur DESCENDING.

        "Obtêm o item de maior valor e que possua ICMS
        LOOP AT lt_tm_item ASSIGNING FIELD-SYMBOL(<fs_s_item_data>).

          READ TABLE lt_ivas_w_icms TRANSPORTING NO FIELDS WITH KEY mwskz = <fs_s_item_data>-tax_code.
          CHECK sy-subrc IS INITIAL.

          DATA(lv_found) = abap_true.
          EXIT.

        ENDLOOP.

        IF lv_found = abap_true AND <fs_s_item_data> IS ASSIGNED.

          DATA(ls_item_arredondamento) = VALUE zcltm_gko_process=>ty_s_item_arredondamento( ebeln     = <fs_s_item_data>-po_number
                                                                                            ebelp     = <fs_s_item_data>-po_item
                                                                                            diferenca = lv_diferenca ).

          "Exporta a chave de acesso, para o correto processamento do ENHANCEMENT ZENH_GKO_NF_MIRO
          EXPORT gko_acckey = is_doc-acckey TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
          "Utilizado na BAdI ZCL_J_1BNF_ADD_DATA para distribuir o valor da diferença
          EXPORT item_arredondamento = ls_item_arredondamento TO MEMORY ID zcltm_gko_process=>gc_memory_id-item_arredondamento.

          SORT lt_tm_item BY invoice_doc_item ASCENDING.

          IF sy-cprog	  = 'ZMMR_GKO_PROCESSA'.
            IF is_doc-crtn = '1'
              OR is_doc-crtn =  '2'
              OR is_doc-crtn =  '4'.
              lv_invoicestatus = 'D' .
              IF ls_header-j_1bnftype = 'ZK'.
                CLEAR ls_header-j_1bnftype.
              ENDIF.
            ENDIF.
          ENDIF.

          FREE: lt_return.
          CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
            EXPORTING
              headerdata       = ls_header
              invoicestatus    = lv_invoicestatus
            IMPORTING
              invoicedocnumber = ev_invoicedocnumber
              fiscalyear       = ev_fiscalyear
            TABLES
              itemdata         = lt_item
              tm_itemdata      = lt_tm_item
              accountingdata   = lt_account
              return           = lt_return.

          " Limpa memória
          FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.
          FREE MEMORY ID zcltm_gko_process=>gc_memory_id-item_arredondamento.

          IF line_exists( lt_return[ type = 'E' ] )
          OR line_exists( lt_return[ type = 'A' ] ).  " INSERT - JWSILVA - 20.03.2023
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = 'X'.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

* ----------------------------------------------------------------------
* Em caso de sucesso na tentativa 1 ou 2, Atualiza Nota fiscal
* ----------------------------------------------------------------------
    IF ev_invoicedocnumber IS NOT INITIAL.

      IF is_doc-tpdoc = zcltm_gko_process=>gc_tpdoc-cte
      OR is_doc-tpdoc = zcltm_gko_process=>gc_tpdoc-nfe.

        DATA(lv_refkey) = CONV j_1bnflin-refkey( |{ ev_invoicedocnumber }{ ev_fiscalyear }| ).

        SELECT SINGLE atv~*
          FROM j_1bnfe_active AS atv
          INNER JOIN j_1bnflin AS lin
            ON lin~docnum = atv~docnum
          WHERE lin~refkey EQ @lv_refkey
          INTO @DATA(ls_active).

        SELECT SINGLE doc~*
          FROM j_1bnfdoc AS doc
          INNER JOIN j_1bnflin AS lin
            ON lin~docnum = doc~docnum
          WHERE lin~refkey EQ @lv_refkey
          INTO @DATA(ls_doc).

        IF sy-subrc IS INITIAL.

          DATA(ls_access_key) = CONV j_1b_nfe_access_key( is_doc-acckey ).
          MOVE-CORRESPONDING ls_access_key TO ls_active.

          TRY.
              ls_active-authdate = is_doc-dtemi.
              ls_active-authtime = is_doc-hremi.
              ls_active-authcod  = COND #( WHEN lv_xml_ref IS NOT INITIAL
                                           THEN zcltm_gko_process=>get_value_from_xml( iv_xml        = lv_xml_ref
                                                                                       iv_expression = '//*:nProt' )
                                           ELSE '000000000000000' ).
            CATCH cx_root.
          ENDTRY.

          ls_doc-authdate = ls_active-authdate.
          ls_doc-authtime = ls_active-authtime.
          ls_doc-authcod  = ls_active-authcod.

          "Check existing key entries for history table
          IF ls_history IS NOT INITIAL.
            CALL FUNCTION 'J_1B_NFE_HISTORY_COUNT'
              CHANGING
                ch_history = ls_history.
          ENDIF.

*        CALL FUNCTION 'J_1B_NFE_UPDATE_ACTIVE_W_LOCK'
*          EXPORTING
*            is_acttab            = ls_active
*            is_histtab           = ls_history
*            iv_updmode           = 'U'
*            iv_wait_after_commit = 'X'
*          EXCEPTIONS
*            update_error         = 1
*            lock_error           = 2
*            OTHERS               = 3.

          CALL FUNCTION 'J_1B_NFE_UPDATE_ACTIVE'
            EXPORTING
              i_acttab     = ls_active
              i_histtab    = ls_history
              i_doc        = ls_doc
              i_updmode    = 'U'
            EXCEPTIONS
              update_error = 1
              OTHERS       = 2.

        ENDIF.

      ENDIF.

      IF lv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.
        lv_codstatus = zcltm_gko_process=>gc_codstatus-miro_memorizada.
      ELSE.
        lv_codstatus = zcltm_gko_process=>gc_codstatus-miro_confirmada.
      ENDIF.

      " Fatura &1 criada com sucesso. /  Fatura &1 memorizada com sucesso.
      me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                              iv_codstatus        = lv_codstatus
                              iv_invoicedocnumber = ev_invoicedocnumber
                              iv_fiscalyear       = ev_fiscalyear
                              it_return           = COND #( WHEN lv_codstatus = zcltm_gko_process=>gc_codstatus-miro_memorizada
                                                            THEN VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '118' message_v1 = |{ ev_invoicedocnumber }{ ev_fiscalyear }| ) )
                                                            WHEN lv_codstatus = zcltm_gko_process=>gc_codstatus-miro_confirmada
                                                            THEN VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '117' message_v1 = |{ ev_invoicedocnumber }{ ev_fiscalyear }| ) )
                                                            ELSE VALUE #( ( ) ) ) ).

* ----------------------------------------------------------------------
* Tentativa 3 - Memorizar MIRO
* ----------------------------------------------------------------------
    ELSE.

      DATA(lt_return_aux) = lt_return.

      DELETE lt_return_aux WHERE type = 'S'
                             OR  type = 'W'
                             OR  type = 'I'.

      IF lv_invoicestatus = zcltm_gko_process=>gc_invoice_status-registrado
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '020' ] )  "O material & está bloqueado pelo usuário
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '022' ] )  "Dados de grupo de empresas do material & bloqueados pelo usuário &
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '023' ] )  "Os dados do centro estão bloqueados por usuário &
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '024' ] )  "Dados de avaliação p/o material & bloqueados pelo usuário &
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '025' ] )  "Dados SAD p/o material & bloqueados pelo usuário &
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '026' ] )  "Dados de venda e distr.p/o material & bloqueados pelo usuário &
                                                        AND NOT line_exists( lt_return[ id     = 'M3'
                                                                                        number = '029' ] ). "Material & no centro & está sendo processado )..

        FREE: ls_header-j_1bnftype.
        FREE: lt_return.
        CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
          EXPORTING
            headerdata       = ls_header
            invoicestatus    = zcltm_gko_process=>gc_invoice_status-memorizado_entrado
          IMPORTING
            invoicedocnumber = ev_invoicedocnumber
            fiscalyear       = ev_fiscalyear
          TABLES
            itemdata         = lt_item
            withtaxdata      = lt_wht
            tm_itemdata      = lt_tm_item
            accountingdata   = lt_account
            return           = lt_return.

        IF line_exists( lt_return[ type = 'E' ] ).
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        ELSE.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = 'X'.

          lv_codstatus = zcltm_gko_process=>gc_codstatus-miro_memorizada.

          " Fatura &1 memorizada com sucesso.
          me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                                  iv_codstatus        = lv_codstatus
                                  iv_invoicedocnumber = ev_invoicedocnumber
                                  iv_fiscalyear       = ev_fiscalyear
                                  it_return           = VALUE #( ( type = 'E' id = 'ZTM_GKO' number = '118' message_v1 = |{ ev_invoicedocnumber }{ ev_fiscalyear }| ) ) ).

        ENDIF.

      ENDIF.

    ENDIF.

* ----------------------------------------------------------------------
* Prepara mensagem para casos de sucesso
* ----------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'E' ] ) AND lt_return IS INITIAL.

      " Chave &1: Documento &2/&3 criado com sucesso.
      lt_return = VALUE #( BASE lt_return ( type = 'S' id = 'ZTM_GKO' number = '102'
                                            message_v1 = is_doc-acckey
                                            message_v2 = ev_invoicedocnumber
                                            message_v3 = ev_fiscalyear ) ).
    ENDIF.

    INSERT LINES OF lt_return[] INTO TABLE gt_return[].

* ----------------------------------------------------------------------
* Finaliza processo em caso de erro na MIRO
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] )
    OR line_exists( lt_return[ type = 'A' ] ).  " INSERT - JWSILVA - 20.03.2023

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      lv_codstatus = zcltm_gko_process=>gc_codstatus-erro_ao_criar_miro.

      me->save_log( EXPORTING iv_acckey    = is_doc-acckey
                              iv_codstatus = lv_codstatus
                              it_return    = lt_return ).

    ENDIF.

* ----------------------------------------------------------------------
* Salva novo documento criado
* ----------------------------------------------------------------------
    me->set_status( EXPORTING iv_acckey           = is_doc-acckey
                              iv_codstatus        = lv_codstatus
                              iv_invoicedocnumber = ev_invoicedocnumber
                              iv_fiscalyear       = ev_fiscalyear ).

  ENDMETHOD.


  METHOD release_settlement.

    DATA: lr_wbeln    TYPE RANGE OF wbrk-wbeln,
          lt_seltab   TYPE STANDARD TABLE OF rsparams,
          lt_list     TYPE STANDARD TABLE OF abaplist,
          lt_text     TYPE STANDARD TABLE OF char200,
          lt_text_ret TYPE string_table,
          ls_return   TYPE bapiret2,
          lv_text     TYPE string,
          lv_wbeln    TYPE wbrk-wbeln.

    FREE: et_return.

    " Recupera documento de distribuição de custos
    SELECT doc~acckey,
           doc~docgerado
        FROM zi_tm_monitor_gko_docger_u AS doc
        INNER JOIN wbrk
            ON  wbrk~wbeln = left( doc~docgerado, 10 )
            AND wbrk~lfart = 'ZCOM'
        WHERE doc~acckey  EQ @is_doc-acckey
          AND doc~tipodoc EQ '5'
          AND wbrk~rfbsk  EQ 'A'
        INTO TABLE @DATA(lt_docs).

    IF sy-subrc EQ 0.
      SORT lt_docs BY docgerado.
    ELSE.
      RETURN.
    ENDIF.

    lt_seltab =  VALUE #( BASE lt_seltab FOR ls_doc IN lt_docs
                        ( kind    = 'P'
                          sign    = 'I'
                          option  = 'EQ'
                          selname = 'S_WDTYP'
                          low     = 'A' ) ). " Documento de Faturamento do Fornecedor

    lt_seltab =  VALUE #( BASE lt_seltab FOR ls_doc IN lt_docs
                        ( kind    = 'P'
                          sign    = 'I'
                          option  = 'EQ'
                          selname = 'X_WBELN'
                          low     = ls_doc-docgerado ) ).

    lt_seltab =  VALUE #( BASE lt_seltab FOR ls_doc IN lt_docs
                        ( kind    = 'P'
                          sign    = 'I'
                          option  = 'EQ'
                          selname = 'S_PRUEF'
                          low     = abap_false ) ). " Execução de controle desativada

    " Chama transação WAB_RELEASE
    TRY.
        SUBMIT rwlf2056 WITH SELECTION-TABLE lt_seltab EXPORTING LIST TO MEMORY AND RETURN.

        CALL FUNCTION 'LIST_FROM_MEMORY'
          TABLES
            listobject = lt_list.

        CALL FUNCTION 'LIST_TO_TXT'
          EXPORTING
            list_index = -1
          TABLES
            listtxt    = lt_text
            listobject = lt_list.

      CATCH cx_root.
        " Falha na liberação do documento de administração &1.
        et_return = VALUE #( BASE et_return FOR ls_doc IN lt_docs ( id = 'W' type = 'ZTM_GKO' number = '144' message_v1 = ls_doc-docgerado ) ).

    ENDTRY.

    LOOP AT lt_text REFERENCE INTO DATA(ls_text).
      lv_text = COND #( WHEN lv_text IS INITIAL
                        THEN ls_text->*
                        ELSE lv_text && ls_text->* ).
    ENDLOOP.

    " Recupera mensagens de retorno
    SPLIT lv_text AT '|' INTO TABLE lt_text_ret.

    LOOP AT lt_text_ret REFERENCE INTO DATA(lv_text_ret).

      DATA(lv_index) = sy-tabix.

      lv_wbeln = |{ lv_text_ret->* ALPHA = IN }|.
      READ TABLE lt_docs TRANSPORTING NO FIELDS WITH KEY docgerado = lv_wbeln BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      TRY.
          CLEAR ls_return.
          ls_return-message_v1  = lv_text_ret->*.
          ls_return-id          = lt_text_ret[ lv_index + 1 ].
          ls_return-type        = lt_text_ret[ lv_index + 2 ].
          ls_return-number      = lt_text_ret[ lv_index + 3 ].
          ls_return-message     = lt_text_ret[ lv_index + 4 ].
          APPEND ls_return TO et_return.
        CATCH cx_root.
          CONTINUE.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD determine_nfs_invoice_status.

    " Inicialmente, será lançado como registrado
    rv_invoicestatus = zcltm_gko_process=>gc_invoice_status-registrado.

* ----------------------------------------------------------------------
* 1 - Verifica se transportadora tem código de regime tributário Simples Nacional
* ----------------------------------------------------------------------
    IF is_doc-crtn = '1'  " Simples Nacional
    OR is_doc-crtn = '2' " Simples Nacional - rendimento bruto abaixo limite inferior
    OR is_doc-crtn = '4'.
      rv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.
      me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                              iv_codstatus        = is_doc-codstatus
                              " Transp. &1 possui reg. trib. Simples Nacional. MIRO será memorizada.
                              it_return           = VALUE #( ( type = 'W' id = 'ZTM_GKO' number = '126' message_v1 = is_doc-emit_cod ) ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* 2 - Verifica se transportadora não tem campos de retenção marcados em seu cadastro
* ----------------------------------------------------------------------

    " Busca parâmetro para categoria IRF
    IF gr_witht IS INITIAL.
      me->get_parameter( EXPORTING is_param = VALUE #( modulo = gc_param_ctg_irf-modulo
                                                       chave1 = gc_param_ctg_irf-chave1
                                                       chave2 = gc_param_ctg_irf-chave2
                                                       chave3 = gc_param_ctg_irf-chave3 )
                         IMPORTING et_value = gr_witht ).
    ENDIF.

    IF gr_witht IS INITIAL.
      rv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.
      me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                              iv_codstatus        = is_doc-codstatus
                              " Ctg. IRF não foi encontrada na tabela de parâmetros. MIRO será memorizada
                              it_return           = VALUE #( ( type = 'W' id = 'ZTM_GKO' number = '127' ) ) ).
      RETURN.
    ENDIF.

    " Recupera categorias do fornecedor
    SELECT lifnr, bukrs, witht, wt_subjct
        FROM lfbw
        INTO TABLE @DATA(lt_lfbw)
        WHERE lifnr     EQ @is_doc-emit_cod
          AND bukrs     EQ @is_doc-bukrs
          AND witht     IN @gr_witht.

    " Verifica se todos estão sujeitos a IRF
    LOOP AT lt_lfbw REFERENCE INTO DATA(ls_lfbw).

      IF ls_lfbw->wt_subjct NE abap_true.

        rv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.

        me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                                iv_codstatus        = is_doc-codstatus
                                " Ctg &1 não está sujeito a IRF. MIRO será memorizada.
                                it_return           = VALUE #( ( type = 'W' id = 'ZTM_GKO' number = '130' message_v1 = ls_lfbw->witht ) ) ).
      ENDIF.
    ENDLOOP.

    IF sy-subrc NE 0.
      rv_invoicestatus = zcltm_gko_process=>gc_invoice_status-memorizado_entrado.

      me->save_log( EXPORTING iv_acckey           = is_doc-acckey
                              iv_codstatus        = is_doc-codstatus
                              " Fornecedor não está Sujeito a IRF. MIRO será memorizada.
                              it_return           = VALUE #( ( type = 'W' id = 'ZTM_GKO' number = '128' ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD get_parameter.

    FREE et_value.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                         iv_chave1 = is_param-chave1
                                         iv_chave2 = is_param-chave2
                                         iv_chave3 = is_param-chave3
                               IMPORTING et_range  = et_value ).
      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.


  METHOD fill_bapi_acc.

    FREE: et_account.

    DATA: lv_item   TYPE i,
          lv_serial TYPE dzekkn.

    " Monta tabela de chaves
    DATA(lt_doc_i) = it_doc_i[].
    SORT lt_doc_i BY acckey ebeln.
    DELETE ADJACENT DUPLICATES FROM lt_doc_i COMPARING acckey ebeln.

    " Recupera dados do pedido
    IF lt_doc_i[] IS NOT INITIAL.

      SELECT ebeln,
             ebelp,
             netwr,
             menge,
             meins,
             mwskz,
             txjcd,
             loekz,
             packno
        FROM ekpo
        INTO TABLE @DATA(lt_ekpo)
        FOR ALL ENTRIES IN @lt_doc_i
        WHERE ebeln EQ @lt_doc_i-ebeln
          AND loekz NE 'L'.

      IF sy-subrc IS NOT INITIAL.
        FREE lt_ekpo.
      ENDIF.

      IF lt_ekpo IS NOT INITIAL.

        DATA(lv_packno) = lt_ekpo[ 1 ]-packno.

        SELECT SINGLE sub_packno
          INTO @DATA(lv_sub_packno)
          FROM esll
          WHERE packno = @lv_packno.

        SELECT
          packno,
          introw,
          extrow,
          srvpos,
          menge,
          meins,
          brtwr,
          netwr,
          txjcd,
          mwskz
          FROM esll
          INTO TABLE @DATA(lt_esll)
          WHERE packno = @lv_sub_packno.

      ENDIF.

    ENDIF.

    DESCRIBE TABLE lt_esll LINES DATA(lv_lines).

    CHECK lv_lines > 1.

    SORT lt_esll BY introw.

    ADD 1 TO lv_item.

    " Transfere dados do serviço
    LOOP AT lt_esll REFERENCE INTO DATA(ls_esll).

      ADD 1 TO lv_serial.

      et_account = VALUE #( BASE et_account (
                   invoice_doc_item = lv_item
                   serial_no        = lv_serial
                   tax_code         = ls_esll->mwskz
                   taxjurcode       = ls_esll->txjcd
                   item_amount      = ls_esll->netwr ) ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
