CLASS zcltm_cockpit_frete_new DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_reported  TYPE RESPONSE FOR REPORTED EARLY zc_tm_cockpit_new .
    TYPES:
      ty_failed    TYPE RESPONSE FOR FAILED EARLY zc_tm_cockpit_new .
    TYPES:
      ty_t_cockpit TYPE STANDARD TABLE OF zc_tm_cockpit_new WITH EMPTY KEY .
    TYPES:
      ty_t_log     TYPE STANDARD TABLE OF zc_tm_cockpit_log_new WITH EMPTY KEY .

    CONSTANTS gc_model_nfe TYPE j_1b_nfe_doctype VALUE 'NFE' ##NO_TEXT.
    CONSTANTS gc_model_cte TYPE j_1b_nfe_doctype VALUE 'CTE' ##NO_TEXT.
    CONSTANTS gc_model_nfs TYPE j_1b_nfe_doctype VALUE 'NFS' ##NO_TEXT.

    CLASS-DATA go_instance TYPE REF TO zcltm_cockpit_frete_new .
    CLASS-DATA gv_wait_async TYPE abap_bool .
    CLASS-DATA gv_wait_async_delete_cte TYPE abap_bool .
    CLASS-DATA gv_success TYPE char1 .
    CLASS-DATA gt_return TYPE bapiret2_t .
    CLASS-DATA gt_bapi_return TYPE bapiret2_t .

    "! Cria instancia
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO zcltm_cockpit_frete_new .
    "! Configura os filtros que serão utilizados no relatório
    "! @parameter it_range | Filtros do Aplicativo
    METHODS set_filters
      IMPORTING
        !it_range TYPE if_rap_query_filter=>tt_name_range_pairs .
    "! Configura os filtros que serão utilizados no relatório
    "! @parameter it_range | Filtros do Aplicativo
    "! @parameter iv_field | Nome do campo
    "! @parameter et_range | Filtros convertidos
    METHODS set_filters_field
      IMPORTING
        !it_range TYPE if_rap_query_filter=>tt_name_range_pairs
        !iv_field TYPE string
      EXPORTING
        !et_range TYPE ANY TABLE .
    "! Logica para buscar dados e apresentar relatorio
    "! @parameter rt_cockpit |Retorna tabela relatório
    METHODS build
      RETURNING
        VALUE(rt_cockpit) TYPE ty_t_cockpit .
    "! Logica para determinar vencimento e apresentar relatorio
    "! @parameter ct_cockpit |Retorna tabela relatório
    METHODS build_due_date
      CHANGING
        !ct_cockpit TYPE ty_t_cockpit .
    "! Logica para verificar se registros estão aptos para realizar o agrupamento
    "! @parameter ct_cockpit |Retorna tabela relatório
    METHODS build_check_grouping
      CHANGING
        !ct_cockpit TYPE ty_t_cockpit .
    "! Logica para buscar dados e apresentar relatorio
    "! @parameter rt_log |Retorna tabela relatório
    METHODS build_log
      IMPORTING
        !iv_filter    TYPE string
      RETURNING
        VALUE(rt_log) TYPE ty_t_log .
    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING
        !it_return   TYPE bapiret2_t
      EXPORTING
        !es_reported TYPE ty_reported .
    "! Aciona evento de falha
    "! @parameter it_key | Chaves da CDS
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_failed | Retorno do aplicativo
    METHODS build_failed
      IMPORTING
        !it_key    TYPE zctgtm_acckey
        !it_return TYPE bapiret2_t
      EXPORTING
        !es_failed TYPE ty_failed .
    "! Chama evento para estorno de agrupamento
    METHODS estorno_agrupamento
      IMPORTING
        !iv_estorno_miro   TYPE flag DEFAULT space
        !iv_estorno_pedido TYPE flag DEFAULT space
        !it_cockpit        TYPE ty_t_cockpit
      EXPORTING
        !et_return         TYPE bapiret2_t
        !et_bapi_return    TYPE bapiret2_t .
    "! Chama evento para estorno de agrupamento
    METHODS estorno_agrupamento_ex
      IMPORTING
        !iv_estorno_miro   TYPE flag DEFAULT space
        !iv_estorno_pedido TYPE flag DEFAULT space
        !it_cockpit        TYPE zctgtm_cockpit_new
      EXPORTING
        !et_return         TYPE bapiret2_t
        !et_bapi_return    TYPE bapiret2_t .
    "! Chama evento para estorno de fatura
    METHODS estorno_miro
      IMPORTING
        !iv_estorno_pedido TYPE flag DEFAULT space
        !iv_acckey         TYPE zc_tm_cockpit_new-acckey
      EXPORTING
        !et_return         TYPE bapiret2_t .
    "! Chama evento para estorno de pedido
    METHODS estorno_pedido
      IMPORTING
        !iv_acckey TYPE zc_tm_cockpit_new-acckey
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Eliminar registro
    METHODS delete
      IMPORTING
        !it_acckey TYPE zctgtm_acckey
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Eliminar registro
    METHODS delete_cte
      IMPORTING
        !iv_acckey TYPE j_1b_nfe_access_key_dtel44
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Eliminar registro
    METHODS delete_cte_ex
      IMPORTING
        !iv_acckey TYPE j_1b_nfe_access_key_dtel44
      EXPORTING
        !et_return TYPE bapiret2_t .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gs_filter TYPE ty_filter.
    METHODS:
      delete_cte_aux
        IMPORTING
          iv_acckey TYPE j_1b_nfe_access_key_dtel44
        EXPORTING
          et_return TYPE bapiret2_t .
ENDCLASS.



CLASS zcltm_cockpit_frete_new IMPLEMENTATION.


  METHOD get_instance.

    go_instance = COND #( WHEN go_instance IS NOT INITIAL
                          THEN go_instance
                          ELSE NEW zcltm_cockpit_frete_new( ) ).

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD set_filters.

    DATA: lv_tabname TYPE ddobjname VALUE 'ZC_TM_COCKPIT_NEW',
          lt_dfies   TYPE dfies_tab.

    FIELD-SYMBOLS: <fs_filter> TYPE any.

    CHECK it_range IS NOT INITIAL.

    FREE: gs_filter.

* ---------------------------------------------------------------------------
* Ordena a tabela de filtro
* ---------------------------------------------------------------------------
    DATA(lt_range) = it_range[].
    SORT lt_range BY name.

* ---------------------------------------------------------------------------
* Recupera todos os campos da CDS / Tabela
* ---------------------------------------------------------------------------
    CALL FUNCTION 'DDIF_FIELDINFO_GET'
      EXPORTING
        tabname        = lv_tabname
      TABLES
        dfies_tab      = lt_dfies
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Busca os filtros de seleção
* ---------------------------------------------------------------------------
    LOOP AT lt_dfies REFERENCE INTO DATA(ls_dfies).

      ASSIGN COMPONENT ls_dfies->fieldname OF STRUCTURE gs_filter TO <fs_filter>.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      TRY.
          me->set_filters_field( EXPORTING it_range = lt_range
                                           iv_field = CONV #( ls_dfies->fieldname )
                                 IMPORTING et_range = <fs_filter> ).
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_filters_field.

    FREE: et_range.

    READ TABLE it_range REFERENCE INTO DATA(ls_range) WITH KEY name = iv_field
                                                      BINARY SEARCH.
    IF sy-subrc EQ 0.
      et_range[] = CORRESPONDING #( ls_range->range[] ).
    ENDIF.

  ENDMETHOD.


  METHOD build.

    FREE: rt_cockpit.

* ---------------------------------------------------------------------------
* Recupera dados do cockpit de frete
* ---------------------------------------------------------------------------
    SELECT *
        FROM zc_tm_cockpit
        WHERE acckey                                IN @gs_filter-acckey
          AND doctype                               IN @gs_filter-doctype
          AND codstatus                             IN @gs_filter-codstatus
          AND codstatus_txt                         IN @gs_filter-codstatus_txt
          AND bukrs                                 IN @gs_filter-bukrs
          AND bukrs_txt                             IN @gs_filter-bukrs_txt
          AND werks                                 IN @gs_filter-werks
          AND werks_txt                             IN @gs_filter-werks_txt
          AND branch                                IN @gs_filter-branch
          AND branch_txt                            IN @gs_filter-branch_txt
          AND credat                                IN @gs_filter-credat
          AND cretim                                IN @gs_filter-cretim
          AND cenario                               IN @gs_filter-cenario
          AND cenario_txt                           IN @gs_filter-cenario_txt
          AND lblni                                 IN @gs_filter-lblni
          AND belnr                                 IN @gs_filter-belnr
          AND gjahr                                 IN @gs_filter-gjahr
          AND supplierinvoice                       IN @gs_filter-supplierinvoice
          AND fiscalyear                            IN @gs_filter-fiscalyear
          AND br_notafiscal                         IN @gs_filter-br_notafiscal
          AND driver                                IN @gs_filter-driver
          AND drivername                            IN @gs_filter-drivername
          AND emit_cnpj_cpf                         IN @gs_filter-emit_cnpj_cpf
          AND emit_ie                               IN @gs_filter-emit_ie
          AND emit_uf                               IN @gs_filter-emit_uf
          AND emit_uf_txt                           IN @gs_filter-emit_uf_txt
          AND emit_mun                              IN @gs_filter-emit_mun
          AND buyer                                 IN @gs_filter-buyer
          AND buyername                             IN @gs_filter-buyername
          AND tom_cnpj_cpf                          IN @gs_filter-tom_cnpj_cpf
          AND tom_ie                                IN @gs_filter-tom_ie
          AND tom_uf                                IN @gs_filter-tom_uf
          AND tom_uf_txt                            IN @gs_filter-tom_uf_txt
          AND tom_mun                               IN @gs_filter-tom_mun
          AND sender                                IN @gs_filter-sender
          AND sendername                            IN @gs_filter-sendername
          AND rem_cnpj_cpf                          IN @gs_filter-rem_cnpj_cpf
          AND rem_ie                                IN @gs_filter-rem_ie
          AND rem_uf                                IN @gs_filter-rem_uf
          AND rem_uf_txt                            IN @gs_filter-rem_uf_txt
          AND rem_mun                               IN @gs_filter-rem_mun
          AND consignee                             IN @gs_filter-consignee
          AND consigneename                         IN @gs_filter-consigneename
          AND dest_cnpj_cpf                         IN @gs_filter-dest_cnpj_cpf
          AND dest_ie                               IN @gs_filter-dest_ie
          AND dest_uf                               IN @gs_filter-dest_uf
          AND dest_uf_txt                           IN @gs_filter-dest_uf_txt
          AND dest_mun                              IN @gs_filter-dest_mun
          AND receiver                              IN @gs_filter-receiver
          AND receivername                          IN @gs_filter-receivername
          AND receb_cnpj_cpf                        IN @gs_filter-receb_cnpj_cpf
          AND receb_ie                              IN @gs_filter-receb_ie
          AND receb_uf                              IN @gs_filter-receb_uf
          AND receb_uf_txt                          IN @gs_filter-receb_uf_txt
          AND receb_mun                             IN @gs_filter-receb_mun
          AND shipper                               IN @gs_filter-shipper
          AND shippername                           IN @gs_filter-shippername
          AND exped_cnpj_cpf                        IN @gs_filter-exped_cnpj_cpf
          AND exped_ie                              IN @gs_filter-exped_ie
          AND exped_uf                              IN @gs_filter-exped_uf
          AND exped_uf_txt                          IN @gs_filter-exped_uf_txt
          AND exped_mun                             IN @gs_filter-exped_mun
          AND nfnum9                                IN @gs_filter-nfnum9
          AND not_code                              IN @gs_filter-not_code
          AND not_code_txt                          IN @gs_filter-not_code_txt
          AND cfop                                  IN @gs_filter-cfop
          AND cfop_ok                               IN @gs_filter-cfop_ok
          AND sitdoc                                IN @gs_filter-sitdoc
          AND sitdoc_txt                            IN @gs_filter-sitdoc_txt
          AND dtemi                                 IN @gs_filter-dtemi
          AND hremi                                 IN @gs_filter-hremi
          AND chadat                                IN @gs_filter-chadat
          AND chatim                                IN @gs_filter-chatim
          AND usr_lib                               IN @gs_filter-usr_lib
          AND usnam                                 IN @gs_filter-usnam
          AND usnam_txt                             IN @gs_filter-usnam_txt
          AND tpdoc                                 IN @gs_filter-tpdoc
          AND tpdoc_txt                             IN @gs_filter-tpdoc_txt
          AND possui_anexo_gnre                     IN @gs_filter-possui_anexo_gnre
          AND possui_comprovante_gnre               IN @gs_filter-possui_comprovante_gnre
          AND possui_anexo_nfs                      IN @gs_filter-possui_anexo_nfs
          AND num_fatura                            IN @gs_filter-num_fatura
          AND vct_gko                               IN @gs_filter-vct_gko
          AND counter                               IN @gs_filter-counter
          AND pago                                  IN @gs_filter-pago
          AND direct                                IN @gs_filter-direct
          AND direct_txt                            IN @gs_filter-direct_txt
          AND model                                 IN @gs_filter-model
          AND model_txt                             IN @gs_filter-model_txt
          AND prod_acabado                          IN @gs_filter-prod_acabado
          AND prod_acabado_desc                     IN @gs_filter-prod_acabado_desc
          AND rateio                                IN @gs_filter-rateio
          AND rateio_txt                            IN @gs_filter-rateio_txt
          AND codevento                             IN @gs_filter-codevento
          AND codevento_txt                         IN @gs_filter-codevento_txt
          AND dhregevento                           IN @gs_filter-dhregevento
          AND tpevento                              IN @gs_filter-tpevento
          AND tpcte                                 IN @gs_filter-tpcte
          AND tpcte_txt                             IN @gs_filter-tpcte_txt
          AND cstat                                 IN @gs_filter-cstat
          AND xmotivo                               IN @gs_filter-xmotivo
          AND vtprest                               IN @gs_filter-vtprest
          AND vrec                                  IN @gs_filter-vrec
          AND vbcicms                               IN @gs_filter-vbcicms
          AND vbciss                                IN @gs_filter-vbciss
          AND picms                                 IN @gs_filter-picms
          AND piss                                  IN @gs_filter-piss
          AND vicms                                 IN @gs_filter-vicms
          AND viss                                  IN @gs_filter-viss
          AND vcarga                                IN @gs_filter-vcarga
          AND qcarga                                IN @gs_filter-qcarga
          AND series                                IN @gs_filter-series
          AND funrural                              IN @gs_filter-funrural
          AND iss                                   IN @gs_filter-iss
          AND iss_curr                              IN @gs_filter-iss_curr
          AND inss                                  IN @gs_filter-inss
          AND inss_curr                             IN @gs_filter-inss_curr
          AND trio                                  IN @gs_filter-trio
          AND trio_curr                             IN @gs_filter-trio_curr
          AND irrf                                  IN @gs_filter-irrf
          AND irrf_curr                             IN @gs_filter-irrf_curr
          AND moeda                                 IN @gs_filter-moeda
          AND vstel                                 IN @gs_filter-vstel
          AND vstel_txt                             IN @gs_filter-vstel_txt
          AND frete_calculado_gko                   IN @gs_filter-frete_calculado_gko
          AND freightorder                          IN @gs_filter-freightorder
          AND sfir_id                               IN @gs_filter-sfir_id
          AND lifecycle                             IN @gs_filter-lifecycle
          AND lifecycle_txt                         IN @gs_filter-lifecycle_txt
          AND confirmation                          IN @gs_filter-confirmation
          AND confirmation_txt                      IN @gs_filter-confirmation_txt
          AND btd_id                                IN @gs_filter-btd_id
          AND belnr_fin                             IN @gs_filter-belnr_fin
*          AND wbeln                                 IN @gs_filter-wbeln
          AND sakto                                 IN @gs_filter-sakto
          AND sakto_txt                             IN @gs_filter-sakto_txt
          AND kostl                                 IN @gs_filter-kostl
          AND kostl_txt                             IN @gs_filter-kostl_txt
          AND rbkp_budat                            IN @gs_filter-rbkp_budat
          AND cputm                                 IN @gs_filter-cputm
          AND bukrs_doc                             IN @gs_filter-bukrs_doc
          AND bukrs_doc_txt                         IN @gs_filter-bukrs_doc_txt
          AND budat                                 IN @gs_filter-budat
          AND augdt                                 IN @gs_filter-augdt
          AND crenam                                IN @gs_filter-crenam
          AND crenam_txt                            IN @gs_filter-crenam_txt
          AND chanam                                IN @gs_filter-chanam
          AND chanam_txt                            IN @gs_filter-chanam_txt
          AND desconto                              IN @gs_filter-desconto
          AND pis                                   IN @gs_filter-pis
          AND cofins                                IN @gs_filter-cofins
          AND frete_cotado_fluig                    IN @gs_filter-frete_cotado_fluig
          AND gro_wei_val                           IN @gs_filter-gro_wei_val
          AND gro_wei_uni                           IN @gs_filter-gro_wei_uni
          AND autenticacao_bancaria                 IN @gs_filter-autenticacao_bancaria
          AND suplrfrtinvcrequuid                   IN @gs_filter-suplrfrtinvcrequuid
          AND purchaseorder                         IN @gs_filter-purchaseorder
          AND transportationorderuuid               IN @gs_filter-transportationorderuuid
          AND ultimolog                             IN @gs_filter-ultimolog
          AND motivorejeicao                        IN @gs_filter-motivorejeicao
          AND estornoagrupamento                    IN @gs_filter-estornoagrupamento
          AND estornomiro                           IN @gs_filter-estornomiro
          AND estornopedido                         IN @gs_filter-estornopedido
        INTO CORRESPONDING FIELDS OF TABLE @rt_cockpit.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Remove linhas duplicadas
* ---------------------------------------------------------------------------
    SORT rt_cockpit BY acckey.
    DELETE ADJACENT DUPLICATES FROM rt_cockpit COMPARING acckey.

* ---------------------------------------------------------------------------
* Determina data de vencimento e filtra as informações
* ---------------------------------------------------------------------------
    me->build_due_date( CHANGING ct_cockpit = rt_cockpit ).

* ---------------------------------------------------------------------------
* Verifica se os registros estão aptos a realizar o agrupamento
* ---------------------------------------------------------------------------
    me->build_check_grouping( CHANGING ct_cockpit = rt_cockpit ).


* ---------------------------------------------------------------------------
* Recupera dados do cockpit de frete - Referências
* ---------------------------------------------------------------------------
    IF rt_cockpit IS NOT INITIAL AND gs_filter-docnum_ref IS NOT INITIAL.

      SELECT acckey, acckey_ref, docnum
          FROM zttm_gkot003
          INTO TABLE @DATA(lt_ref)
*** INICIO - WMDO - Modificação do select - Chamado 8000004045
*          FOR ALL ENTRIES IN @rt_cockpit
          WHERE acckey_ref IN @gs_filter-docnum_ref.
*          WHERE acckey EQ @rt_cockpit-acckey
*            AND docnum IN @gs_filter-docnum_ref.
*** FIM - WMDO - Modificação do select - Chamado 8000004045
      IF sy-subrc EQ 0.
        SORT lt_ref BY acckey.
      ENDIF.

      " Filtra resultado do cockpit com base nos documentos de referência informado no filtro
      LOOP AT rt_cockpit REFERENCE INTO DATA(ls_cockpit).

        DATA(lv_index) = sy-tabix.

        READ TABLE lt_ref TRANSPORTING NO FIELDS WITH KEY acckey = ls_cockpit->acckey
                                                          BINARY SEARCH.
        IF sy-subrc NE 0.
          DELETE rt_cockpit INDEX lv_index.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD build_due_date.

    DATA: lv_last_date TYPE datum,
          lv_date      TYPE datum.

    DATA(lt_cockpit_key) = ct_cockpit.
    SORT lt_cockpit_key BY driver.
    DELETE ADJACENT DUPLICATES FROM lt_cockpit_key COMPARING driver.

* ---------------------------------------------------------------------------
* Recupera condição de pagamento do fornecedor
* ---------------------------------------------------------------------------
    IF lt_cockpit_key IS NOT INITIAL.

      SELECT DISTINCT
             lfm1~lifnr,
             lfm1~zterm,
             t052~ztagg,
             t052~zdart,
             t052~zfael,
             t052~zmona,
             t052~ztag1,
             t052u~text1
          FROM lfm1
          INNER JOIN t052
          ON  lfm1~zterm = t052~zterm
          LEFT OUTER JOIN t052u
          ON  t052u~spras = @sy-langu
          AND t052u~zterm = t052~zterm
          AND t052u~ztagg = t052~ztagg
          FOR ALL ENTRIES IN @lt_cockpit_key
          WHERE lfm1~lifnr = @lt_cockpit_key-driver
          INTO TABLE @DATA(lt_cond) BYPASSING BUFFER.

      IF sy-subrc EQ 0.
        SORT lt_cond BY lifnr.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Determina data de vencimento e vencimento líquido
* ---------------------------------------------------------------------------
    LOOP AT ct_cockpit REFERENCE INTO DATA(ls_cockpit).

      " Busca condição de pagamento
      READ TABLE lt_cond INTO DATA(ls_cond) WITH KEY lifnr = ls_cockpit->driver
                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      IF ls_cockpit->dtemi IS INITIAL.
        CONTINUE.
      ENDIF.

      IF ls_cond-zfael IS NOT INITIAL.           " Pagamento dia fixo

        IF ls_cockpit->dtemi+6(2) > ls_cond-zfael.
          " Para documento emitidos entre dia 16 e 30/31, devem ter vencimento para o último dia do mês seguinte.

          " Verifica o último dia próximo mês
          CALL FUNCTION 'PS_LAST_DAY_OF_NEXT_MONTH'
            EXPORTING
              day_in               = ls_cockpit->dtemi
            IMPORTING
              last_day_of_next_mon = lv_last_date
            EXCEPTIONS
              day_in_not_valid     = 1
              OTHERS               = 2.

          IF sy-subrc NE 0.
            CLEAR lv_last_date.
          ENDIF.

        ELSE.

* BEGIN OF CHANGE - JWSILVA - 03.03.2023
          " Para documento emitidos entre dia 01 e 15, devem ter vencimento para o dia 15 do mês seguinte.

          " Verifica o último dia do próximo mês
          CALL FUNCTION 'PS_LAST_DAY_OF_NEXT_MONTH'
            EXPORTING
              day_in               = ls_cockpit->dtemi
            IMPORTING
              last_day_of_next_mon = lv_last_date
            EXCEPTIONS
              day_in_not_valid     = 1
              OTHERS               = 2.

          IF sy-subrc EQ 0.
            lv_last_date = lv_last_date+0(6) && ls_cond-zfael.
          ENDIF.
* BEGIN OF CHANGE - JWSILVA - 03.03.2023

        ENDIF.

* BEGIN OF CHANGE - JWSILVA - 03.03.2023
*        " Se o último dia do mês for menor que a data de pagamento, usar o último dia do mês
*        IF sy-subrc EQ 0 AND lv_last_date+6(2) < ls_cond-zfael.
*          ls_cond-zfael = lv_last_date+6(2).
*        ENDIF.
*
*        ls_cockpit->vct_forn = |{ lv_last_date+0(6) }{ ls_cond-zfael }|.

        ls_cockpit->vct_forn = lv_last_date.
* END OF CHANGE - JWSILVA - 03.03.2023


      ELSEIF ls_cond-ztag1 IS NOT INITIAL.       " Pagamento em X dias

        ls_cockpit->vct_forn = ls_cockpit->dtemi + ls_cond-ztag1.

      ENDIF.

* BEGIN OF INSERT - JWSILVA - 03.03.2023
      IF ls_cockpit->vct_forn IS NOT INITIAL.
        CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
          EXPORTING
            date                      = ls_cockpit->vct_forn
          EXCEPTIONS
            plausibility_check_failed = 1
            OTHERS                    = 2.

        IF sy-subrc <> 0.
          CLEAR ls_cockpit->vct_forn.
        ENDIF.
      ENDIF.

      IF ls_cockpit->vct_gko IS NOT INITIAL.
        CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
          EXPORTING
            date                      = ls_cockpit->vct_gko
          EXCEPTIONS
            plausibility_check_failed = 1
            OTHERS                    = 2.

        IF sy-subrc <> 0.
          CLEAR ls_cockpit->vct_gko.
        ENDIF.
      ENDIF.
* END OF INSERT - JWSILVA - 03.03.2023

      ls_cockpit->vct_liq = COND #( WHEN ls_cockpit->vct_forn > ls_cockpit->vct_gko
                                    THEN ls_cockpit->vct_forn
                                    ELSE ls_cockpit->vct_gko ).

    ENDLOOP.

    " Filtra os dados de acordo com os parâmetros de seleção
    DELETE ct_cockpit WHERE vct_forn NOT IN gs_filter-vct_forn.
    DELETE ct_cockpit WHERE vct_liq  NOT IN gs_filter-vct_liq.

  ENDMETHOD.


  METHOD build_check_grouping.

* ---------------------------------------------------------------------------
* Recupera os status disponíveis para elimintação
* ---------------------------------------------------------------------------
    IF ct_cockpit IS NOT INITIAL.

      SELECT DISTINCT guid, acao, codstatus_de, codstatus_para
          FROM zttm_pcockpit016
          FOR ALL ENTRIES IN @ct_cockpit
          WHERE acao         EQ 'A' " Agrupamento de Faturas
            AND codstatus_de EQ @ct_cockpit-codstatus
          INTO TABLE @DATA(lt_016).

      IF sy-subrc EQ 0.
        SORT lt_016 BY acao.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    LOOP AT ct_cockpit REFERENCE INTO DATA(ls_cockpit).

      READ TABLE lt_016 INTO DATA(ls_016) WITH KEY codstatus_de = ls_cockpit->codstatus BINARY SEARCH.

      IF sy-subrc NE 0.
        ls_cockpit->agrupamento_ok = abap_false.
      ELSE.
        ls_cockpit->agrupamento_ok = abap_true.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_log.

    DATA: lt_acckey TYPE STANDARD TABLE OF zc_tm_cockpit_log_new-acckey.

    FREE: rt_log.

* ---------------------------------------------------------------------------
* Recupera as chaves da CDS anterior
* ---------------------------------------------------------------------------
    FIND ALL OCCURRENCES OF REGEX `ACCKEY = '([^\']*)'` IN iv_filter RESULTS DATA(lt_result).

    LOOP AT lt_result REFERENCE INTO DATA(ls_result).

      LOOP AT ls_result->submatches REFERENCE INTO DATA(ls_submatches).

        TRY.
            DATA(lv_acckey) = CONV j_1b_nfe_access_key_dtel44( iv_filter+ls_submatches->offset(ls_submatches->length) ).
            lt_acckey[] = VALUE #( BASE lt_acckey ( lv_acckey ) ).
          CATCH cx_root.
        ENDTRY.

      ENDLOOP.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Remove duplicatas
* ---------------------------------------------------------------------------
    SORT lt_acckey BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_acckey COMPARING table_line.

* ---------------------------------------------------------------------------
* Seleciona os dados do Log
* ---------------------------------------------------------------------------
    IF lt_acckey IS NOT INITIAL.

      SELECT *
          FROM zc_tm_cockpit_log
          FOR ALL ENTRIES IN @lt_acckey
          WHERE acckey = @lt_acckey-table_line
          INTO CORRESPONDING FIELDS OF TABLE @rt_log.

      IF sy-subrc NE 0.
        FREE rt_log.
      ENDIF.
    ENDIF.

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
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-_cockpitheader.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-_cockpitheader.
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
          es_reported-_cockpitheader[] = VALUE #( BASE es_reported-_cockpitheader[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-_cockpitheader[] = VALUE #( BASE es_reported-_cockpitheader[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_failed.

    FREE: es_failed.

* ---------------------------------------------------------------------------
* Verifica se existe mensagens de erro
* ---------------------------------------------------------------------------
    CHECK line_exists( it_return[ type = 'E' ] ).

* ---------------------------------------------------------------------------
* Marca a chave que falhou
* ---------------------------------------------------------------------------
    TRY.
        es_failed-_cockpitheader = VALUE #( ( %tky-acckey = it_key[ 1 ] ) ) .
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD estorno_agrupamento.

    DATA: lt_return     TYPE bapiret2_t,
          lt_return_all TYPE bapiret2_t.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors,
          lt_docs   TYPE zcltm_gko_process_group=>ty_t_docs,
          lt_acckey TYPE zctgtm_acckey.

    LOOP AT it_cockpit ASSIGNING FIELD-SYMBOL(<fs_cockpit>) GROUP BY <fs_cockpit>-belnr.

      " Limpa execução anterior
      LOOP AT lt_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).
        <fs_s_doc>->free( ).
      ENDLOOP.

      FREE: lt_errors, lt_docs.

      TRY.
          LOOP AT GROUP <fs_cockpit> ASSIGNING FIELD-SYMBOL(<fs_s_agrup_mbr>).

            TRY.
                zcltm_gko_process=>check_status_from_action( iv_action = zcltm_gko_process=>gc_acao-estorno
                                                             iv_status = <fs_s_agrup_mbr>-codstatus ).

                APPEND NEW zcltm_gko_process( iv_acckey    = <fs_s_agrup_mbr>-acckey
                                              iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ) TO lt_docs.

                APPEND <fs_s_agrup_mbr>-acckey TO lt_acckey.

              CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
                APPEND lr_cx_gko_process TO lt_errors.
                APPEND LINES OF lr_cx_gko_process->get_bapi_return( ) TO et_bapi_return.

            ENDTRY.
          ENDLOOP.

          IF lt_errors IS NOT INITIAL.
            CONTINUE.
          ENDIF.

          zcltm_gko_process_group=>reversal_invoice_grouping( lt_docs ).

          IF iv_estorno_miro = abap_true.

            LOOP AT lt_docs ASSIGNING <fs_s_doc>.

              DATA(lv_tabix) = sy-tabix.
              TRY.
                  DATA(lv_rev_miro) = <fs_s_doc>->reversal_invoice( ).

                  IF iv_estorno_pedido = abap_true AND lv_rev_miro = abap_true.
                    <fs_s_doc>->reversal_purchase_order_ex( ).
                  ENDIF.

                CATCH zcxtm_gko INTO DATA(lr_cx_gko).

                  <fs_s_doc>->persist( ).
                  <fs_s_doc>->free( ).

                  APPEND lr_cx_gko TO lt_errors.
                  APPEND LINES OF lr_cx_gko_process->get_bapi_return( ) TO et_bapi_return.

                  DELETE lt_docs INDEX lv_tabix.
                  CONTINUE.
              ENDTRY.

            ENDLOOP.

            IF lt_errors IS NOT INITIAL.
              CONTINUE.
            ENDIF.

          ENDIF.

          LOOP AT lt_docs ASSIGNING <fs_s_doc>.
            TRY.
                <fs_s_doc>->persist( ).
                <fs_s_doc>->free( ).
              CATCH zcxtm_gko INTO lr_cx_gko.
                <fs_s_doc>->free( ).
            ENDTRY.

          ENDLOOP.

        CATCH zcxtm_gko INTO lr_cx_gko.
          APPEND LINES OF lr_cx_gko->get_bapi_return( ) TO et_bapi_return.
        CATCH zcxtm_process_group  INTO DATA(lr_cx_process_group).
          APPEND LINES OF lr_cx_process_group->get_bapi_return( ) TO et_bapi_return.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD estorno_agrupamento_ex.

    FREE: et_return, et_bapi_return.

    SELECT *
      FROM zttm_gkot001
      INTO TABLE @DATA(lt_cockpit)
      FOR ALL ENTRIES IN @it_cockpit
      WHERE num_fatura    = @it_cockpit-num_fatura
        AND emit_cnpj_cpf = @it_cockpit-emit_cnpj_cpf
        AND codstatus     = @zcltm_gko_process=>gc_codstatus-agrupamento_efetuado.

    IF sy-subrc NE 0.
      " Nenhum agrupamento encontrado.
*      et_return = VALUE #( ( type = 'I' id = 'ZTM_GKO' number = '139' ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Método para realizar o estorno do agrupamento
* ----------------------------------------------------------------------
    FREE: gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_REVERSAL_INVOICE_GROUP'
      STARTING NEW TASK 'REVERSAL_INVOICE_GROUP'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_estorno_miro   = iv_estorno_miro
        iv_estorno_pedido = iv_estorno_pedido
        it_cockpit        = lt_cockpit.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return      = gt_return.
    et_bapi_return = gt_bapi_return.

  ENDMETHOD.


  METHOD estorno_miro.

    FREE: et_return.

    TRY.
        DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey    = iv_acckey
                                                      iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ).

        DATA(lv_rev_miro) = lr_gko_process->reversal_invoice( ).

        lr_gko_process->persist( ).

        IF iv_estorno_pedido = abap_true AND lv_rev_miro = abap_true.
          lr_gko_process->reversal_purchase_order_ex( IMPORTING et_return  = et_return ).
        ENDIF.

        lr_gko_process->persist( ).
        lr_gko_process->free( ).

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        et_return = lr_cx_gko_process->get_bapi_return( ).

        IF lr_gko_process IS BOUND.
          lr_gko_process->free( ).
        ENDIF.

    ENDTRY.

  ENDMETHOD.


  METHOD estorno_pedido.

    FREE: et_return.

    TRY.
        DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey    = iv_acckey
                                                      iv_tpprocess = zcltm_gko_process=>gc_tpprocess-manual ).

        lr_gko_process->reversal_purchase_order_ex( IMPORTING et_return  = et_return ).

        lr_gko_process->persist( ).
        lr_gko_process->free( ).

      CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

        et_return = lr_cx_gko_process->get_bapi_return( ).

        IF lr_gko_process IS BOUND.
          lr_gko_process->free( ).
        ENDIF.

    ENDTRY.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'REVERSAL_INVOICE_GROUP'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_REVERSAL_INVOICE_GROUP'
         IMPORTING
           et_return      = gt_return
           et_bapi_return = gt_bapi_return.

      WHEN 'DELETE_CTE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_DELETE_CTE'
         IMPORTING
           et_return      = gt_return.

        gv_wait_async = abap_true.

      WHEN 'METHOD_DELETE_CTE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_DELETE_CTE'
         IMPORTING
           et_return      = gt_return.

        gv_wait_async_delete_cte = abap_true.
    ENDCASE.

  ENDMETHOD.


  METHOD delete.
    DATA: lr_acckey TYPE RANGE OF zttm_gkot001-acckey.
    FREE: et_return.

    CHECK it_acckey IS NOT INITIAL.

    lr_acckey = VALUE #( FOR ls_acckey IN it_acckey (
      sign   = 'I'
      option = 'EQ'
      low    = ls_acckey )
    ).

    SELECT acckey, tpdoc
      FROM zttm_gkot001
      INTO TABLE @DATA(lt_acckey)
     WHERE acckey IN @lr_acckey.

    CLEAR lr_acckey.
    LOOP AT lt_acckey ASSIGNING FIELD-SYMBOL(<fs_acckey>).

      IF <fs_acckey>-tpdoc <> gc_model_nfs.
        me->delete_cte_aux( EXPORTING iv_acckey = <fs_acckey>-acckey
                            IMPORTING et_return = DATA(lt_return) ).

        INSERT LINES OF lt_return INTO TABLE et_return.
      ENDIF.

      CHECK lt_return IS INITIAL.
      lr_acckey = VALUE #( BASE lr_acckey ( sign   = 'I'
                                            option = 'EQ'
                                            low    = <fs_acckey> ) ).

    ENDLOOP.

    IF lr_acckey IS NOT INITIAL.
      DELETE FROM zttm_gkot001 WHERE acckey IN lr_acckey.
      DELETE FROM zttm_gkot002 WHERE acckey IN lr_acckey.
      DELETE FROM zttm_gkot003 WHERE acckey IN lr_acckey.
      DELETE FROM zttm_gkot006 WHERE acckey IN lr_acckey.
    ENDIF.

  ENDMETHOD.


  METHOD delete_cte.
    DATA:
      lt_cteid   TYPE /xnfe/nfeid_r_t,
      lt_inctehd TYPE /xnfe/inctehd_t.

    CALL FUNCTION '/XNFE/APPEND_RANGE'
      EXPORTING
        iv_value_low = iv_acckey
      CHANGING
        ct_range     = lt_cteid.

    CALL FUNCTION '/XNFE/B2BCTE_GET_LIST'
      EXPORTING
        it_so_cteid  = lt_cteid
      IMPORTING
        et_inctehd   = lt_inctehd
      EXCEPTIONS
        invalid_date = 1
        OTHERS       = 2.

    IF sy-subrc NE 0.
      FREE lt_inctehd.
    ENDIF.

    TRY.
        DATA(ls_inctehd) = lt_inctehd[ 1 ].
      CATCH cx_root.
    ENDTRY.

    CALL FUNCTION '/XNFE/B2BCTE_READ_CTE_FOR_UPD'
      EXPORTING
        iv_guid            = ls_inctehd-guid
      EXCEPTIONS
        cte_does_not_exist = 1
        cte_locked         = 2
        technical_error    = 3
        OTHERS             = 4.

    IF sy-subrc <> 0.
      et_return = VALUE #( BASE et_return ( id         = sy-msgid
                                            type       = sy-msgty
                                            number     = sy-msgno
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

    CALL FUNCTION '/XNFE/B2BCTE_DELETE_CTE'
      EXPORTING
        iv_guid         = ls_inctehd-guid
      EXCEPTIONS
        technical_error = 1
        OTHERS          = 2.

    IF sy-subrc <> 0.
      et_return = VALUE #( BASE et_return ( id         = sy-msgid
                                            type       = sy-msgty
                                            number     = sy-msgno
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

    CALL FUNCTION '/XNFE/B2BCTE_SAVE_TO_DB'.
    CALL FUNCTION '/XNFE/EV_SAVE_TO_DB'.
    COMMIT WORK.

  ENDMETHOD.


  METHOD delete_cte_ex.

    FREE: et_return.

    SELECT SINGLE acckey, codstatus, tpdoc
        FROM zttm_gkot001
        INTO @DATA(ls_001)
        WHERE acckey = @iv_acckey.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    IF ls_001-tpdoc NE 'CTE'.
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Método para realizar o estorno do agrupamento
* ----------------------------------------------------------------------
    FREE: gt_return, gv_wait_async.

    CALL FUNCTION 'ZFMTM_DELETE_CTE'
      STARTING NEW TASK 'DELETE_CTE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_acckey = iv_acckey.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return                = gt_return.

  ENDMETHOD.


  METHOD delete_cte_aux.
* ----------------------------------------------------------------------
* Método para realizar o estorno do agrupamento
* ----------------------------------------------------------------------
    CLEAR: gt_return, gv_wait_async_delete_cte.

    CALL FUNCTION 'ZFMTM_DELETE_CTE'
      STARTING NEW TASK 'METHOD_DELETE_CTE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_acckey = iv_acckey.

    WAIT UNTIL gv_wait_async_delete_cte = abap_true.
    et_return                = gt_return.
  ENDMETHOD.
ENDCLASS.
