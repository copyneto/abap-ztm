CLASS zcltm_gestao_frete_relat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS cte_process
      IMPORTING
        iv_tp_cte      TYPE ze_gko_tpcte
        is_dados_dacte TYPE zstm_gko_008
      EXPORTING
        ev_pdf         TYPE xstring
        et_return      TYPE bapiret2_t.

    METHODS print_nf
      IMPORTING
        iv_acckey TYPE zttm_gkot001-acckey
        iv_popup  TYPE flag DEFAULT abap_false
      EXPORTING
        ev_pdf    TYPE xstring
        et_return TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
    "! Arquivo pdf binário
    DATA gv_pdf_file TYPE xstring .
    DATA gt_otf TYPE tsfotf .

    DATA gt_cte TYPE TABLE OF zstm_gko_008.

    METHODS get_data_nf
      IMPORTING iv_acckey TYPE zttm_gkot001-acckey
      EXPORTING es_header TYPE zstm_nfe_header
                et_return TYPE bapiret2_t.

    "! Download NF/CTE-Normal/CTE-Comp
    "! @parameter it_table      | Tabela de entrada
    "! @parameter iv_nf         | NF?
    "! @parameter iv_cte_normal | CTE-Normal?
    "! @parameter iv_cte_comp   | CTE-Comp?
    "! @parameter et_return     | Retorna mensagens
    METHODS download_pdf
      IMPORTING
        it_table      TYPE STANDARD TABLE
        iv_nf         TYPE flag OPTIONAL
        iv_cte_normal TYPE flag OPTIONAL
        iv_cte_comp   TYPE flag OPTIONAL
        iv_popup      TYPE flag DEFAULT abap_false
      EXPORTING
        ev_pdf        TYPE xstring
        et_return     TYPE bapiret2_t.

    "! Método para converter OTF
    "! @parameter it_otf | Relatório em OTF
    METHODS convert_otf
      IMPORTING
        it_otf    TYPE tt_itcoo
      EXPORTING
        ev_pdf    TYPE xstring
        et_return TYPE bapiret2_t.

ENDCLASS.



CLASS ZCLTM_GESTAO_FRETE_RELAT IMPLEMENTATION.


  METHOD download_pdf.

    DATA: lt_otf                TYPE STANDARD TABLE OF itcoo,
          lt_return             TYPE bapiret2_t,

          ls_control_parameters TYPE ssfctrlop,
          ls_output_options     TYPE ssfcompop,
          ls_job_output_info    TYPE ssfcrescl,
          lv_smartform          TYPE rs38l_fnam,
          lv_tipo_relat         TYPE tdsfname,
          lv_user_settings      TYPE tdbool.

    FREE: ev_pdf, et_return.

* ----------------------------------------------------------------------
* Tipo do documento
* ----------------------------------------------------------------------
    IF iv_nf IS NOT INITIAL.
      lv_tipo_relat = gc_formname-nf.
    ELSEIF iv_cte_normal IS NOT INITIAL.
      lv_tipo_relat = gc_formname-cte.
    ELSE.
      lv_tipo_relat = gc_formname-cte_comp.
    ENDIF.

* ----------------------------------------------------------------------
* Determina nome da função
* ----------------------------------------------------------------------
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname = lv_tipo_relat
      IMPORTING
        fm_name  = lv_smartform.

    IF lv_smartform IS INITIAL.
      " Relatório &1 indisponível.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '099' message_v1 = gc_formname-cte_comp ) ).
      RETURN.
    ENDIF.

    LOOP AT it_table ASSIGNING FIELD-SYMBOL(<fs_table>).

      " Controle do spool
      AT FIRST.
        ls_control_parameters-no_open  = abap_false.
        ls_control_parameters-no_close = abap_true.
      ENDAT.
      AT LAST.
        ls_control_parameters-no_close = abap_false.
      ENDAT.

      IF iv_popup IS INITIAL.
        ls_control_parameters-preview   = space.
        ls_control_parameters-getotf    = abap_true.                " Retorna OTF que será convertido posteriormente em PDF
        ls_output_options-tddest        = gc_device.
        ls_control_parameters-no_dialog = abap_true.
        lv_user_settings                = abap_false.
      ELSE.
        ls_control_parameters-preview   = abap_true.
        ls_control_parameters-getotf    = abap_false.
        ls_output_options-tddest        = gc_device.
        ls_control_parameters-no_dialog = abap_false.
        lv_user_settings                = abap_true.
      ENDIF.

      IF iv_nf IS NOT INITIAL.

        CALL FUNCTION lv_smartform
          EXPORTING
            control_parameters = ls_control_parameters
            output_options     = ls_output_options
            user_settings      = lv_user_settings
            is_header          = <fs_table>
          IMPORTING
            job_output_info    = ls_job_output_info
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.

      ELSEIF iv_cte_normal IS NOT INITIAL.

        CALL FUNCTION lv_smartform
          EXPORTING
            control_parameters = ls_control_parameters
            output_options     = ls_output_options
            user_settings      = lv_user_settings
            is_dados_cte       = <fs_table>
          IMPORTING
            job_output_info    = ls_job_output_info
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.

      ELSE.

        CALL FUNCTION lv_smartform
          EXPORTING
            control_parameters = ls_control_parameters
            output_options     = ls_output_options
            user_settings      = lv_user_settings
            dados_cte          = <fs_table>
          IMPORTING
            job_output_info    = ls_job_output_info
          EXCEPTIONS
            formatting_error   = 1
            internal_error     = 2
            send_error         = 3
            user_canceled      = 4
            OTHERS             = 5.

      ENDIF.

      IF sy-subrc <> 0.
        " Houveram erros durante geração do relatório.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '100' ) ).
        RETURN.

      ENDIF.

      INSERT LINES OF ls_job_output_info-otfdata[] INTO TABLE lt_otf[].

* ----------------------------------------------------------------------
* Gerencia entrada do usuário
* ----------------------------------------------------------------------
      IF ls_job_output_info-userexit   IS NOT INITIAL AND
         ls_job_output_info-outputdone IS INITIAL.
        RETURN.
      ENDIF.

* ----------------------------------------------------------------------
* Prepara parâmetros para o próximo documento
* ----------------------------------------------------------------------
      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-preview   = space.
      ls_control_parameters-no_open   = abap_true.

    ENDLOOP.

* ----------------------------------------------------------------------
* Converte OTF em binário XSTRING
* ----------------------------------------------------------------------
    convert_otf( EXPORTING it_otf    = lt_otf
                 IMPORTING ev_pdf    = ev_pdf
                           et_return = lt_return ).

    IF lt_return[] IS NOT INITIAL.
      APPEND LINES OF lt_return TO et_return.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_data_nf.

    FREE: es_header, et_return.

* ----------------------------------------------------------------------
* Recupera dados de frete
* ----------------------------------------------------------------------
*    IF iv_guid IS NOT INITIAL.
*
*      SELECT SINGLE *
*          FROM zttm_gkot001
*          INTO @DATA(ls_001)
*          WHERE guid = @iv_guid.
*
*      IF sy-subrc NE 0.
*        FREE ls_001.
*      ENDIF.
*
*    ELSEIF iv_acckey IS NOT INITIAL.

    SELECT SINGLE *
        FROM zttm_gkot001
        INTO @DATA(ls_001)
        WHERE acckey = @iv_acckey.

    IF sy-subrc NE 0.
      FREE ls_001.
    ENDIF.
*    ENDIF.

    IF ls_001 IS INITIAL.
      " Nenhuma Nota Fiscal encontrada para a chave informada.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '101' ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera Referências CTe/NFS
* ----------------------------------------------------------------------
    IF ls_001 IS NOT INITIAL.

      SELECT acckey, acckey_ref, acckey_orig, nfnum9
          FROM zttm_gkot003
          INTO TABLE @DATA(lt_003)
          WHERE acckey = @ls_001-acckey.

      IF sy-subrc EQ 0.
        TRY.
            DATA(ls_003) = lt_003[ 1 ].
          CATCH cx_root.
        ENDTRY.
      ENDIF.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera Dados complementares
* ----------------------------------------------------------------------
    IF ls_001 IS NOT INITIAL.

      SELECT SINGLE *
          FROM zttm_gkot004
          INTO @DATA(ls_004)
          WHERE acckey = @ls_001-acckey.

      IF sy-subrc NE 0.
        FREE lt_003.
      ENDIF.
    ENDIF.

* ----------------------------------------------------------------------
* Recupera texto do CFOP
* ----------------------------------------------------------------------
    SELECT SINGLE *
          FROM j_1bagnt
          INTO @DATA(ls_cfop)
          WHERE spras = @sy-langu
            AND cfop  = @ls_001-cfop.

    IF sy-subrc NE 0.
      FREE ls_cfop.
    ENDIF.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Cabeçalho DANFE
* ----------------------------------------------------------------------
    es_header-emit_nome           = ls_004-emit_nome.

    es_header-emit_lgr_nro        = COND #( WHEN ls_004-emit_nro IS NOT INITIAL
                                            THEN |{ ls_004-emit_lgr }, { ls_004-emit_nro }|
                                            ELSE |{ ls_004-emit_lgr }| ).

    es_header-emit_bairro         = ls_004-emit_bairro.

    es_header-emit_mun_cep        = COND #( WHEN ls_004-emit_cep IS NOT INITIAL
                                            THEN |{ ls_004-emit_mun } - CEP: { ls_004-emit_cep+0(5) }-{ ls_004-emit_cep+5(3) }|
                                            ELSE |{ ls_004-emit_mun }| ).

    IF ls_001-emit_cnpj_cpf > 99999999999.
      WRITE ls_001-emit_cnpj_cpf TO es_header-emit_cnpj USING EDIT MASK '__.___.___/____-__'.   " CNPJ
      CONDENSE es_header-emit_cnpj NO-GAPS.
    ELSEIF ls_001-emit_cnpj_cpf IS NOT INITIAL.
      WRITE ls_001-emit_cnpj_cpf TO es_header-emit_cnpj USING EDIT MASK '___.___.___-__'.       " CPF
      CONDENSE es_header-emit_cnpj NO-GAPS.
    ENDIF.

    es_header-emit_ie             = ls_001-emit_ie.
    es_header-emit_tel            = space.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Chave de acesso
* ----------------------------------------------------------------------
    es_header-direct              = COND #( WHEN ls_001-direct = '1'
                                              OR ls_001-direct = '4'
                                            THEN '0'
                                            WHEN ls_001-direct = '2'
                                              OR ls_001-direct = '3'
                                            THEN '1' ).
    es_header-model               = ls_001-model.
    es_header-serie               = ls_001-series.
    es_header-nfnum9              = ls_001-nfnum9.
    es_header-fl                  = '1/1'.
    WRITE ls_001-dtemi TO es_header-dtemi DD/MM/YYYY.
    REPLACE ALL OCCURRENCES OF '.' IN es_header-dtemi WITH '/'.

* ----------------------------------------------------------------------
* Prepara dados do formulário - CFOP
* ----------------------------------------------------------------------
    es_header-cfop                = ls_001-cfop.
    es_header-cfop_txt            = ls_cfop-cfotxt.

    IF ls_001-acckey IS NOT INITIAL.
      es_header-acckey              = ls_001-acckey.
      WRITE ls_001-acckey TO es_header-acckey_txt USING EDIT MASK '__.____.__.___.___/____-__-__-___-___.___.___-___.___.___-_'.
      CONDENSE es_header-acckey_txt NO-GAPS.
    ENDIF.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Protocolo de autorização
* ----------------------------------------------------------------------
    es_header-authcod             = space.
    es_header-authdate            = space.
    es_header-authtime            = space.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Destinatário
* ----------------------------------------------------------------------
    es_header-dest_nome           = ls_004-dest_nome.
    es_header-dest_mun            = ls_004-dest_mun.
    es_header-dest_cep            = COND #( WHEN ls_004-dest_cep IS NOT INITIAL
                                            THEN |{ ls_004-dest_cep+0(5) }-{ ls_004-dest_cep+5(3) }|
                                            ELSE space ).
    es_header-dest_endereco       = |{ ls_004-dest_lgr } { ls_004-dest_nro }, { ls_004-dest_bairro }|.

    IF ls_001-dest_cnpj > 99999999999.
      WRITE ls_001-dest_cnpj TO es_header-dest_cnpj_cpf USING EDIT MASK '__.___.___/____-__'.   " CNPJ
      CONDENSE es_header-dest_cnpj_cpf NO-GAPS.
    ELSEIF ls_001-dest_cnpj IS NOT INITIAL.
      WRITE ls_001-dest_cnpj TO es_header-dest_cnpj_cpf USING EDIT MASK '___.___.___-__'.       " CPF
      CONDENSE es_header-dest_cnpj_cpf NO-GAPS.
    ENDIF.

    es_header-dest_ie             = ls_001-dest_ie.
    es_header-dest_tel            = space.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Cálculo do imposto
* ----------------------------------------------------------------------
    es_header-vl_base_icms        = '0,00'.
    es_header-vl_frete            = '0,00'.
    es_header-vl_icms             = '0,00'.
    es_header-vl_seguro           = '0,00'.
    es_header-vl_base_icms_st     = '0,00'.
    es_header-vl_othbas           = '0,00'.
    es_header-vl_icms_st          = '0,00'.
    es_header-vl_tot_ipi          = '0,00'.
    es_header-vl_tot_prod         = '0,00'.
    WRITE ls_001-vtprest TO es_header-vl_total CURRENCY 'BRL'.
    CONDENSE es_header-vl_total NO-GAPS.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Transportador
* ----------------------------------------------------------------------
    es_header-transp_nome         = space.
    es_header-transp_frete        = space.
    es_header-transp_placa        = space.
    es_header-transp_placa_uf     = space.
    es_header-transp_cnpj_cpf     = space.
    es_header-transp_endereco     = space.
    es_header-transp_municipio    = space.
    es_header-transp_uf           = space.
    es_header-transp_ie           = space.
    es_header-transp_qtd          = space.
    es_header-transp_especie      = space.
    es_header-transp_marca        = space.
    es_header-transp_numero       = space.
    es_header-transp_peso_bruto   = space.
    es_header-transp_peso_liquido = space.

* ----------------------------------------------------------------------
* Prepara dados do formulário - Cálculo do imposto
* ----------------------------------------------------------------------
    es_header-issqn_ie            = ls_001-emit_ie.
    WRITE ls_001-vtprest TO es_header-vl_total_servico CURRENCY 'BRL'. CONDENSE es_header-vl_total_servico NO-GAPS.
    WRITE ls_001-vbciss TO es_header-vl_base_issqn CURRENCY 'BRL'. CONDENSE es_header-vl_base_issqn NO-GAPS.
    WRITE ls_001-viss TO es_header-vl_issqn CURRENCY 'BRL'. CONDENSE es_header-vl_issqn NO-GAPS.

* ----------------------------------------------------------------------
* Prepara dados de Item - Dados de produto
* ----------------------------------------------------------------------
    es_header-item-produto        = space.
    es_header-item-produto_txt    = space.
    es_header-item-ncm            = space.
    es_header-item-cst            = space.
    es_header-item-unid           = space.
    es_header-item-quantidade     = space.
    es_header-item-valor_unitario = space.

    WRITE ls_001-vtprest TO es_header-item-valor_total CURRENCY 'BRL'. CONDENSE es_header-item-valor_total NO-GAPS.

    es_header-item-aliq_icms      = space.

* ----------------------------------------------------------------------
* Prepara dados de Item - Dados de produto - Remetente
* ----------------------------------------------------------------------
    es_header-item-rem_nome         = |REMETENTE: { ls_004-rem_nome }|.
    es_header-item-rem_lgr_nro_cpl  = |END: { ls_004-rem_lgr } { ls_004-rem_nro }, { ls_004-rem_cpl }|.

    es_header-item-rem_mun_cep      = COND #( WHEN ls_004-rem_cep IS NOT INITIAL
                                              THEN |MUN: { ls_004-rem_mun } CEP: { ls_004-rem_cep+0(5) }-{ ls_004-rem_cep+5(3) } |
                                              ELSE |MUN: { ls_004-rem_mun }| ).

    IF ls_001-rem_cnpj_cpf IS NOT INITIAL.
      WRITE ls_001-rem_cnpj_cpf TO es_header-item-rem_cnpj USING EDIT MASK '__.___.___/____-__'.   " CNPJ
      CONDENSE es_header-item-rem_cnpj NO-GAPS.
    ENDIF.

    es_header-item-rem_ie           = ls_001-rem_ie.

    es_header-item-rem_cnpj_ie      = COND #( WHEN es_header-item-rem_cnpj IS NOT INITIAL AND es_header-item-rem_ie IS NOT INITIAL
                                              THEN |CNPJ: { es_header-item-rem_cnpj } INSCR: { es_header-item-rem_ie }|
                                              WHEN es_header-item-rem_cnpj IS NOT INITIAL AND es_header-item-rem_ie IS INITIAL
                                              THEN |CNPJ: { es_header-item-rem_cnpj }|
                                              WHEN es_header-item-rem_cnpj IS INITIAL AND es_header-item-rem_ie IS NOT INITIAL
                                              THEN |INSCR: { es_header-item-rem_ie }| ).

* ----------------------------------------------------------------------
* Prepara dados de Item - Dados de produto - Destinatário
* ----------------------------------------------------------------------
    es_header-item-dest_nome        = |ENTREGA: { ls_004-dest_nome }|.
    es_header-item-dest_lgr_nro_cpl = |END: { ls_004-dest_lgr } { ls_004-dest_nro }, { ls_004-dest_cpl }|.

    es_header-item-dest_mun_cep     = COND #( WHEN ls_004-dest_cep IS NOT INITIAL
                                              THEN |MUN: { ls_004-dest_mun } CEP: { ls_004-dest_cep+0(5) }-{ ls_004-dest_cep+5(3) } |
                                              ELSE |MUN: { ls_004-dest_mun }| ).

    IF ls_001-dest_cnpj IS NOT INITIAL.
      WRITE ls_001-dest_cnpj TO es_header-item-dest_cnpj USING EDIT MASK '__.___.___/____-__'.   " CNPJ
      CONDENSE es_header-item-dest_cnpj NO-GAPS.
    ENDIF.

    es_header-item-dest_ie          = ls_001-dest_ie.

    es_header-item-dest_cnpj_ie     = COND #( WHEN es_header-item-dest_cnpj IS NOT INITIAL AND es_header-item-dest_ie IS NOT INITIAL
                                              THEN |CNPJ: { es_header-item-dest_cnpj } INSCR: { es_header-item-dest_ie }|
                                              WHEN es_header-item-dest_cnpj IS NOT INITIAL AND es_header-item-dest_ie IS INITIAL
                                              THEN |CNPJ: { es_header-item-dest_cnpj }|
                                              WHEN es_header-item-dest_cnpj IS INITIAL AND es_header-item-dest_ie IS NOT INITIAL
                                              THEN |INSCR: { es_header-item-dest_ie }| ).

* ----------------------------------------------------------------------
* Prepara dados de Item - Dados de produto - Nota
* ----------------------------------------------------------------------
    es_header-item-nota_nfnum9      = ls_003-nfnum9.
    es_header-item-nota_qtde        = '0'.
    es_header-item-nota_peso        = '0.00'.
    es_header-item-nota_valor       = '0,00'.
    es_header-item-nota_txt         = |NOTA: { es_header-item-nota_nfnum9 } QTDE: { es_header-item-nota_qtde } PESO: { es_header-item-nota_peso } VALOR: { es_header-item-nota_valor }|.

  ENDMETHOD.


  METHOD print_nf.

    DATA: lt_header TYPE zctgtm_nfe_header.

    FREE: et_return.

* ----------------------------------------------------------------------
* Prepara dados do formulário NF
* ----------------------------------------------------------------------
    me->get_data_nf( EXPORTING iv_acckey = iv_acckey
                     IMPORTING es_header = DATA(ls_header)
                               et_return = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    APPEND ls_header TO lt_header[].

* ----------------------------------------------------------------------
* Recupera PDF do formulário NF
* ----------------------------------------------------------------------
    me->download_pdf( EXPORTING it_table      = lt_header
                                iv_nf         = abap_true
                                iv_popup      = iv_popup
                      IMPORTING ev_pdf        = ev_pdf
                                et_return     = et_return ).
  ENDMETHOD.


  METHOD cte_process.
    DATA: lt_dados_dacte TYPE TABLE OF zstm_gko_008.

    APPEND is_dados_dacte TO lt_dados_dacte[].

    CASE iv_tp_cte.
      WHEN 1.
        me->download_pdf( EXPORTING it_table      = lt_dados_dacte
                                    iv_cte_comp   = abap_true
                          IMPORTING ev_pdf        = ev_pdf
                                    et_return     = et_return ).
      WHEN OTHERS.
        me->download_pdf( EXPORTING it_table      = lt_dados_dacte
                                    iv_cte_normal = abap_true
                          IMPORTING ev_pdf        = ev_pdf
                                    et_return     = et_return ).
    ENDCASE.
  ENDMETHOD.


  METHOD convert_otf.

    DATA lt_pdf                TYPE tlinet.
    DATA lv_pdf_filesize       TYPE i.

    FREE: ev_pdf, et_return.

    gt_otf = it_otf[].

    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_filesize          = lv_pdf_filesize
        bin_file              = gv_pdf_file
      TABLES
        otf                   = it_otf[]
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

    ENDIF.

    ev_pdf = gv_pdf_file.

  ENDMETHOD.
ENDCLASS.
