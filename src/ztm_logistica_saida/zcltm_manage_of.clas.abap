CLASS zcltm_manage_of DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_interface,
        sap          TYPE ze_tm_interface VALUE '00',
        saga         TYPE ze_tm_interface VALUE '01',
        gko          TYPE ze_tm_interface VALUE '02',
        greenmile    TYPE ze_tm_interface VALUE '03',
        roadnet      TYPE ze_tm_interface VALUE '04',
        trafegus     TYPE ze_tm_interface VALUE '05',
        intercompany TYPE ze_tm_interface VALUE '06',
        ecommerce    TYPE ze_tm_interface VALUE '07',
      END OF gc_interface.

    CLASS-METHODS change_of
      IMPORTING iv_interface           TYPE ze_tm_interface OPTIONAL
                is_root_fu             TYPE /scmtms/s_tor_root_k OPTIONAL
                iv_vbeln               TYPE likp-vbeln OPTIONAL
                iv_root_tspid          TYPE /scmtms/s_tor_root_k-tspid OPTIONAL
                iv_root_labeltxt       TYPE /scmtms/s_tor_root_k-labeltxt OPTIONAL
                iv_root_zznr_saga      TYPE /scmtms/s_tor_root_k-zznr_saga OPTIONAL
                iv_root_zz_motorista   TYPE /scmtms/s_tor_root_k-zz_motorista OPTIONAL
                iv_root_zz1_cond_exped TYPE /scmtms/s_tor_root_k-zz1_cond_exped OPTIONAL
                iv_root_zz1_tipo_exped TYPE /scmtms/s_tor_root_k-zz1_tipo_exped OPTIONAL
                iv_root_zzchapa        TYPE /scmtms/s_tor_root_k-zzchapa OPTIONAL
                iv_root_zzcustochapa   TYPE /scmtms/s_tor_root_k-zzcustochapa OPTIONAL
                iv_root_zz_code        TYPE /scmtms/s_tor_root_k-zz_code OPTIONAL
                iv_root_zz_mdf         TYPE /scmtms/s_tor_root_k-zz_mdf OPTIONAL
      CHANGING  cs_root                TYPE /scmtms/s_tor_root_k
                ct_changed             TYPE /bobf/t_frw_name OPTIONAL.

    "! Recupera empresa
    "! @parameter iv_fo_tor_id | Ordem de Frete
    "! @parameter iv_fu_tor_id | Unidade de Frete
    "! @parameter ev_purch_company_code | Empresa
    "! @parameter rv_purch_company_code | Empresa
    CLASS-METHODS get_of_company_code
      IMPORTING iv_fo_tor_id                 TYPE /scmtms/s_tor_root_k-tor_id OPTIONAL
                iv_fu_tor_id                 TYPE /scmtms/s_tor_root_k-tor_id OPTIONAL
                iv_vbeln                     TYPE likp-vbeln OPTIONAL
      EXPORTING ev_purch_company_code        TYPE /scmtms/s_tor_root_k-purch_company_code
      RETURNING VALUE(rv_purch_company_code) TYPE /scmtms/s_tor_root_k-purch_company_code.

    CLASS-METHODS get_of_company_org_id
      IMPORTING iv_purch_company_code          TYPE /scmtms/s_tor_root_k-purch_company_code
      EXPORTING ev_purch_company_org_id        TYPE /scmtms/s_tor_root_k-purch_company_org_id
      RETURNING VALUE(rv_purch_company_org_id) TYPE /scmtms/s_tor_root_k-purch_company_org_id.

    CLASS-METHODS get_of_tspid
      IMPORTING iv_vbeln        TYPE likp-vbeln
      EXPORTING ev_tspid        TYPE /scmtms/s_tor_root_k-tspid
      RETURNING VALUE(rv_tspid) TYPE /scmtms/s_tor_root_k-tspid.

    CLASS-METHODS get_of_tsp
      IMPORTING iv_tspid      TYPE /scmtms/s_tor_root_k-tspid
      EXPORTING ev_tsp        TYPE /scmtms/s_tor_root_k-tsp
      RETURNING VALUE(rv_tsp) TYPE /scmtms/s_tor_root_k-tsp.

    CLASS-METHODS get_parameter
      IMPORTING
        iv_modulo TYPE ztca_param_par-modulo
        iv_chave1 TYPE ztca_param_par-chave1
        iv_chave2 TYPE ztca_param_par-chave2 OPTIONAL
        iv_chave3 TYPE ztca_param_par-chave3 OPTIONAL
      EXPORTING
        ev_param  TYPE any.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLTM_MANAGE_OF IMPLEMENTATION.


  METHOD change_of.

* ---------------------------------------------------------------------------
* Lógicas específicas de integração
* ---------------------------------------------------------------------------
    CASE iv_interface.

      WHEN gc_interface-sap.
      WHEN gc_interface-saga.

        cs_root-tor_type = '1030'.
        APPEND 'TOR_TYPE' TO ct_changed.

      WHEN gc_interface-gko.
      WHEN gc_interface-greenmile.
      WHEN gc_interface-roadnet.

        cs_root-tor_type = '1010'.
        APPEND 'TOR_TYPE' TO ct_changed.

      WHEN gc_interface-trafegus.
      WHEN gc_interface-intercompany.
      WHEN gc_interface-ecommerce.

        cs_root-tor_type = '1030'.
        APPEND 'TOR_TYPE' TO ct_changed.

    ENDCASE.
* ---------------------------------------------------------------------------
* Atualiza Categoria de documento comercial
* ---------------------------------------------------------------------------
    IF cs_root-tor_cat NE 'TO'.
      cs_root-tor_cat = 'TO'.
      APPEND 'TOR_CAT' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza agente de frete
* ---------------------------------------------------------------------------
    IF iv_root_tspid IS SUPPLIED.
      cs_root-tspid = iv_root_tspid.
      APPEND 'TSPID' TO ct_changed.

      cs_root-tsp = get_of_tsp( EXPORTING iv_tspid = cs_root-tspid ).
      APPEND 'TSP' TO ct_changed.
    ENDIF.

    IF cs_root-tspid IS INITIAL AND iv_vbeln IS NOT INITIAL.

      cs_root-tspid = get_of_tspid( EXPORTING iv_vbeln = iv_vbeln ).

      IF cs_root-tspid IS NOT INITIAL.
        APPEND 'TSPID' TO ct_changed.

        cs_root-tsp = get_of_tsp( EXPORTING iv_tspid = cs_root-tspid ).
        APPEND 'TSP' TO ct_changed.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Legenda
* ---------------------------------------------------------------------------
    IF iv_root_labeltxt IS SUPPLIED.
      cs_root-labeltxt = iv_root_labeltxt.
      APPEND 'LABELTXT' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Número carga SAGA
* ---------------------------------------------------------------------------
    IF iv_root_zznr_saga IS SUPPLIED.
      cs_root-zznr_saga = iv_root_zznr_saga.
      APPEND 'ZZNR_SAGA' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Motorista Parceiro
* ---------------------------------------------------------------------------
    IF iv_root_zz_motorista IS SUPPLIED.
      cs_root-zz_motorista = iv_root_zz_motorista.
      APPEND 'ZZ_MOTORISTA' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Condição de Expedição
* ---------------------------------------------------------------------------
    IF iv_root_zz1_cond_exped IS SUPPLIED.
      cs_root-zz1_cond_exped = iv_root_zz1_cond_exped.
      APPEND 'ZZ1_COND_EXPED' TO ct_changed.
    ENDIF.

    IF cs_root-zz1_cond_exped IS INITIAL.

      IF iv_interface EQ gc_interface-saga
      OR iv_interface EQ gc_interface-ecommerce.

        get_parameter( EXPORTING iv_modulo = 'TM'
                                 iv_chave1 = 'INTEGRACAO_SAGA'
                                 iv_chave2 = 'COND_EXPED'
                       IMPORTING ev_param  = cs_root-zz1_cond_exped ).

        APPEND 'ZZ1_COND_EXPED' TO ct_changed.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Tipo de expedição
* ---------------------------------------------------------------------------
    IF iv_root_zz1_tipo_exped IS SUPPLIED.
      cs_root-zz1_tipo_exped = iv_root_zz1_tipo_exped.
      APPEND 'ZZ1_TIPO_EXPED' TO ct_changed.
    ENDIF.

    IF cs_root-zz1_tipo_exped IS INITIAL.

      IF iv_interface EQ gc_interface-saga
      OR iv_interface EQ gc_interface-ecommerce.

        get_parameter( EXPORTING iv_modulo = 'TM'
                                 iv_chave1 = 'INTEGRACAO_SAGA'
                                 iv_chave2 = 'TIPO_EXP'
                       IMPORTING ev_param  = cs_root-zz1_tipo_exped ).

        APPEND 'ZZ1_TIPO_EXPED' TO ct_changed.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Meio de Transporte
* ---------------------------------------------------------------------------
    IF iv_interface EQ gc_interface-saga
    OR iv_interface EQ gc_interface-ecommerce.
      cs_root-mtr = '0004'.
      APPEND 'MTR' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Chapa
* ---------------------------------------------------------------------------
    IF iv_root_zzchapa IS SUPPLIED.
      cs_root-zzchapa = iv_root_zzchapa.
      APPEND 'ZZCHAPA' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Custo Chapa
* ---------------------------------------------------------------------------
    IF iv_root_zzcustochapa IS SUPPLIED.
      cs_root-zzcustochapa = iv_root_zzcustochapa.
      APPEND 'ZZCUSTOCHAPA' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Código de status do documento
* ---------------------------------------------------------------------------
    IF iv_root_zz_code IS SUPPLIED.
      cs_root-zz_code = iv_root_zz_code.
      APPEND 'ZZ_CODE' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Nº do MDF-e
* ---------------------------------------------------------------------------
    IF iv_root_zz_mdf IS SUPPLIED.
      cs_root-zz_mdf = iv_root_zz_mdf.
      APPEND 'ZZ_MDF' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Status de subcontratação
* ---------------------------------------------------------------------------
    IF cs_root-tspid IS NOT INITIAL.
      cs_root-subcontracting = /scmtms/if_tor_status_c=>sc_root-subcontracting-v_carrier_assigned.
      APPEND 'SUBCONTRACTING' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza Empresa de suprimento do serviço de transporte
* ---------------------------------------------------------------------------
    IF cs_root-purch_company_code IS INITIAL AND cs_root-tor_id IS NOT INITIAL.
      cs_root-purch_company_code = get_of_company_code( EXPORTING iv_fo_tor_id = cs_root-tor_id ).
      APPEND 'PURCH_COMPANY_CODE' TO ct_changed.
    ENDIF.

    IF cs_root-purch_company_code IS INITIAL AND is_root_fu-tor_id IS NOT INITIAL.
      cs_root-purch_company_code = get_of_company_code( EXPORTING iv_fu_tor_id = is_root_fu-tor_id ).
      APPEND 'PURCH_COMPANY_CODE' TO ct_changed.
    ENDIF.

    IF cs_root-purch_company_code IS INITIAL AND iv_vbeln IS NOT INITIAL.
      cs_root-purch_company_code = get_of_company_code( EXPORTING iv_vbeln = iv_vbeln ).
      APPEND 'PURCH_COMPANY_CODE' TO ct_changed.
    ENDIF.


* ---------------------------------------------------------------------------
* Atualiza Organização empresarial que compra o serviço de transporte
* ---------------------------------------------------------------------------
    IF cs_root-purch_company_code IS NOT INITIAL AND cs_root-purch_company_org_id IS INITIAL.
      cs_root-purch_company_org_id = get_of_company_org_id( EXPORTING iv_purch_company_code = cs_root-purch_company_code ).
      APPEND 'PURCH_COMPANY_ORG_ID' TO ct_changed.
    ENDIF.

* ---------------------------------------------------------------------------
* Remove campos duplicados
* ---------------------------------------------------------------------------
    SORT ct_changed BY table_line.
    DELETE ADJACENT DUPLICATES FROM ct_changed COMPARING table_line.

  ENDMETHOD.


  METHOD get_of_company_code.

    FREE: ev_purch_company_code.

    CHECK iv_fo_tor_id IS NOT INITIAL
       OR iv_fu_tor_id IS NOT INITIAL
       OR iv_vbeln IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Recupera fluxo de documentos utilizando Ordem de Frete
* ---------------------------------------------------------------------------
    IF iv_fo_tor_id IS NOT INITIAL.

      SELECT SINGLE *                                "#EC CI_SEL_NESTED
          FROM zi_tm_gestao_frota_docs_of
          WHERE FreightOrder EQ @iv_fo_tor_id
          INTO @DATA(ls_fluxo).

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera fluxo de documentos utilizando Unidade de Frete
* ---------------------------------------------------------------------------
    IF iv_fu_tor_id IS NOT INITIAL.

      SELECT SINGLE *                                "#EC CI_SEL_NESTED
          FROM zi_tm_gestao_frota_docs_of
          WHERE FreightUnit EQ @iv_fu_tor_id
          INTO @ls_fluxo.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera fluxo de documentos utilizando Remessa
* ---------------------------------------------------------------------------
    IF iv_vbeln IS NOT INITIAL.

      SELECT SINGLE vbeln AS DeliveryDocument,
                    vgbel AS SalesDocument           "#EC CI_SEL_NESTED
          FROM lips
          WHERE vbeln EQ @iv_vbeln
          INTO CORRESPONDING FIELDS OF @ls_fluxo.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados da ordem de venda
* ---------------------------------------------------------------------------
    SELECT SINGLE vbeln, bukrs_vf                    "#EC CI_SEL_NESTED
        FROM vbak
        WHERE vbeln EQ @ls_fluxo-SalesDocument
        INTO @DATA(ls_vbak).

    IF sy-subrc NE 0.
      CLEAR ls_vbak.
    ENDIF.

    IF ls_vbak-bukrs_vf IS NOT INITIAL.
      ev_purch_company_code = rv_purch_company_code = ls_vbak-bukrs_vf.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados do pedido de compras
* ---------------------------------------------------------------------------
    SELECT SINGLE ebeln, bukrs                       "#EC CI_SEL_NESTED
        FROM ekko
        INTO @DATA(ls_ekko)
        WHERE ebeln = @ls_fluxo-SalesDocument.

    IF sy-subrc NE 0.
      CLEAR ls_ekko.
    ENDIF.

    IF ls_ekko-bukrs IS NOT INITIAL.
      ev_purch_company_code = rv_purch_company_code = ls_ekko-bukrs.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados da Nota Fiscal
* ---------------------------------------------------------------------------
    SELECT SINGLE docnum, bukrs                      "#EC CI_SEL_NESTED
        FROM j_1bnfdoc
        INTO @DATA(ls_doc)
        WHERE docnum = @ls_fluxo-BR_NotaFiscal.

    IF sy-subrc NE 0.
      CLEAR ls_doc.
    ENDIF.

    IF ls_doc-bukrs IS NOT INITIAL.
      ev_purch_company_code = rv_purch_company_code = ls_doc-bukrs.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_of_company_org_id.

    FREE: ev_purch_company_org_id.

    CHECK iv_purch_company_code IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Recupera fluxo de documentos
* ---------------------------------------------------------------------------
    SELECT SINGLE internal_id, short                 "#EC CI_SEL_NESTED
      FROM /scmb/dv_orgunit
      INTO @DATA(ls_orgunit)
      WHERE short = @iv_purch_company_code.

    IF sy-subrc NE 0.
      CLEAR ls_orgunit.
    ENDIF.

    IF ls_orgunit-internal_id IS NOT INITIAL.
      ev_purch_company_org_id = rv_purch_company_org_id = ls_orgunit-internal_id.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_of_tspid.

    FREE: ev_tspid.

    CHECK iv_vbeln IS NOT INITIAL.

    SELECT SINGLE vbeln, posnr, parvw, kunnr, lifnr
       FROM vbpa
       INTO @DATA(ls_vbpa)
       WHERE vbeln = @iv_vbeln
         AND parvw = 'SP'.   " Parceiro SP

    IF sy-subrc NE 0.
      CLEAR ls_vbpa.
    ENDIF.

    IF ls_vbpa-kunnr IS NOT INITIAL.
      ev_tspid = rv_tspid = ls_vbpa-kunnr.
      RETURN.
    ENDIF.

    IF ls_vbpa-lifnr IS NOT INITIAL.
      ev_tspid = rv_tspid = ls_vbpa-lifnr.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_of_tsp.

    FREE: ev_tsp.

    CHECK iv_tspid IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Recupera GUID de um parceiro de negócios
* ---------------------------------------------------------------------------
    SELECT SINGLE Supplier, BusinessPartner, BusinessPartnerUUID "#EC CI_SEL_NESTED
      FROM i_businesspartnersupplier
      WHERE supplier = @iv_tspid
      INTO @DATA(ls_business).

    IF sy-subrc NE 0.
      CLEAR ls_business.
    ENDIF.

    IF ls_business-BusinessPartnerUUID IS NOT INITIAL.
      ev_tsp = rv_tsp = ls_business-BusinessPartnerUUID.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera GUID de um parceiro de negócios
* ---------------------------------------------------------------------------
    SELECT SINGLE partner, partner_guid              "#EC CI_SEL_NESTED
      FROM but000
      INTO @DATA(ls_but000)
      WHERE partner = @iv_tspid.

    IF sy-subrc NE 0.
      CLEAR ls_but000.
    ENDIF.

    IF ls_but000-partner_guid IS NOT INITIAL.
      ev_tsp = rv_tsp = ls_but000-partner_guid.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_parameter.

    FREE: ev_param.

    TRY.
        NEW zclca_tabela_parametros( )->m_get_single( EXPORTING iv_modulo = iv_modulo
                                                                iv_chave1 = iv_chave1
                                                                iv_chave2 = iv_chave2
                                                                iv_chave3 = iv_chave3
                                                      IMPORTING ev_param  = ev_param ).
      CATCH zcxca_tabela_parametros.
        CLEAR ev_param.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
