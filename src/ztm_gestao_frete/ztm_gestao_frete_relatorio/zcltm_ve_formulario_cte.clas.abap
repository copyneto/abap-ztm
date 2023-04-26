CLASS zcltm_ve_formulario_cte DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_ve_formulario_cte IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT CONV string( 'ACCKEY' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'CHCTE' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'CHNFSE' ) INTO TABLE et_Requested_orig_elements[].

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_cte          TYPE STANDARD TABLE OF zi_tm_formulario_cte,
          lt_nfe_key      TYPE STANDARD TABLE OF zi_tm_formulario_nfe,
          lt_key          TYPE STANDARD TABLE OF zi_tm_formulario_u,
          lt_monitor      TYPE STANDARD TABLE OF zi_tm_monitor_gko,
          lt_cnpj_cpf_key TYPE STANDARD TABLE OF zi_ca_vh_partner_cnpj_cpf.

    lt_cte = CORRESPONDING #( it_original_data ).
    DELETE lt_cte WHERE chcte IS INITIAL.

    lt_nfe_key = CORRESPONDING #( it_original_data ).
    DELETE lt_nfe_key WHERE chnfse IS INITIAL.

* --------------------------------------------------------------------
* CTE - Recupera e transform as informações do XML (XSTRING) para os campos
* --------------------------------------------------------------------
    IF lt_cte[] IS NOT INITIAL.
      TRY.
          DATA(lo_gko) = NEW zcltm_gko_process( ).

          lo_gko->fill_relatorio_cte( CHANGING ct_cte = lt_cte ).
          SORT lt_cte BY acckey.

        CATCH cx_root.
          RETURN.
      ENDTRY.
    ENDIF.

* --------------------------------------------------------------------
* NFE - Recupera os campos
* --------------------------------------------------------------------
    IF lt_nfe_key IS NOT INITIAL.
      SELECT *
          FROM zi_tm_formulario_u
          FOR ALL ENTRIES IN @lt_nfe_key
          WHERE acckey = @lt_nfe_key-acckey
          INTO TABLE @DATA(lt_nfe).

      IF sy-subrc EQ 0.
        SORT lt_nfe BY acckey.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Recupera textos
* --------------------------------------------------------------------
    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( model = ls_c-model ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( model = ls_n-model ) ).
    SORT lt_key BY model.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING model.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_ca_vh_model
          FOR ALL ENTRIES IN @lt_key
          WHERE model = @lt_key-model
          INTO TABLE @DATA(lt_model).

      IF sy-subrc EQ 0 .
        SORT lt_model BY model.
      ENDIF.
    ENDIF.

    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( tpemis = ls_c-tpemis ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( tpemis = ls_n-tpemis ) ).
    SORT lt_key BY tpemis.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING tpemis.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_ca_vh_tpemis
          FOR ALL ENTRIES IN @lt_key
          WHERE TipoEmissao   = @lt_key-tpemis
          INTO TABLE @DATA(lt_tpemis).

      IF sy-subrc EQ 0 .
        SORT lt_tpemis BY TipoEmissao.
      ENDIF.
    ENDIF.

    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( modal = ls_c-modal ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( modal = ls_n-modal ) ).
    SORT lt_key BY modal.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING modal.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_modal
          FOR ALL ENTRIES IN @lt_key
          WHERE modal = @lt_key-modal
          INTO TABLE @DATA(lt_modal).

      IF sy-subrc EQ 0 .
        SORT lt_modal BY modal.
      ENDIF.
    ENDIF.

    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( tpcte = ls_c-tpcte ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( tpcte = ls_n-tpcte ) ).
    SORT lt_key BY tpcte.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING tpcte.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_tpcte
          FOR ALL ENTRIES IN @lt_key
          WHERE tpcte = @lt_key-tpcte
          INTO TABLE @DATA(lt_tpcte).

      IF sy-subrc EQ 0 .
        SORT lt_tpcte BY tpcte.
      ENDIF.
    ENDIF.

    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( tpserv = ls_c-tpserv ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( tpserv = ls_n-tpserv ) ).
    SORT lt_key BY tpserv.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING tpserv.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_tpserv
          FOR ALL ENTRIES IN @lt_key
          WHERE tpserv = @lt_key-tpserv
          INTO TABLE @DATA(lt_tpserv).

      IF sy-subrc EQ 0 .
        SORT lt_tpserv BY tpserv.
      ENDIF.
    ENDIF.

    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( tomador = ls_c-tomador ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( tomador = ls_n-tomador ) ).
    SORT lt_key BY tomador.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING tomador.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_tomador
          FOR ALL ENTRIES IN @lt_key
          WHERE tomador = @lt_key-tomador
          INTO TABLE @DATA(lt_tomador).

      IF sy-subrc EQ 0 .
        SORT lt_tomador BY tomador.
      ENDIF.
    ENDIF.

    FREE lt_key.
    lt_key = VALUE #( BASE lt_key FOR ls_c IN lt_cte ( cst = ls_c-cst ) ).
    lt_key = VALUE #( BASE lt_key FOR ls_n IN lt_nfe ( cst = ls_n-cst ) ).
    SORT lt_key BY cst.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING cst.

    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_tm_vh_cst
          FOR ALL ENTRIES IN @lt_key
          WHERE cst = @lt_key-cst
          INTO TABLE @DATA(lt_cst).

      IF sy-subrc EQ 0 .
        SORT lt_cst BY cst.
      ENDIF.
    ENDIF.

    FREE: lt_cnpj_cpf_key.
    lt_cnpj_cpf_key = VALUE #( BASE lt_cnpj_cpf_key FOR ls_c IN lt_cte ( cnpj_cpf = ls_c-emit_cnpj_cpf ) ).
    lt_cnpj_cpf_key = VALUE #( BASE lt_cnpj_cpf_key FOR ls_c IN lt_cte ( cnpj_cpf = ls_c-rem_cnpj_cpf ) ).
    lt_cnpj_cpf_key = VALUE #( BASE lt_cnpj_cpf_key FOR ls_c IN lt_cte ( cnpj_cpf = ls_c-dest_cnpj_cpf ) ).
    lt_cnpj_cpf_key = VALUE #( BASE lt_cnpj_cpf_key FOR ls_c IN lt_cte ( cnpj_cpf = ls_c-tom_cnpj_cpf ) ).
    lt_cnpj_cpf_key = VALUE #( BASE lt_cnpj_cpf_key FOR ls_c IN lt_cte ( cnpj_cpf = ls_c-exped_cnpj_cpf ) ).
    lt_cnpj_cpf_key = VALUE #( BASE lt_cnpj_cpf_key FOR ls_c IN lt_cte ( cnpj_cpf = ls_c-receb_cnpj_cpf ) ).

    IF lt_cnpj_cpf_key[] IS NOT INITIAL.

      SELECT *
          FROM zi_ca_vh_partner_cnpj_cpf
          FOR ALL ENTRIES IN @lt_cnpj_cpf_key
          WHERE cnpj_cpf = @lt_cnpj_cpf_key-cnpj_cpf
          INTO TABLE @DATA(lt_cnpj_cpf).

      IF sy-subrc EQ 0 .
        SORT lt_cnpj_cpf BY cnpj_cpf InscricaoEstadual.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Transfere dados convertidos
* --------------------------------------------------------------------
    lt_monitor = CORRESPONDING #( it_original_data ).

    LOOP AT lt_monitor REFERENCE INTO DATA(ls_monitor).

      READ TABLE lt_cte INTO DATA(ls_cte) WITH KEY acckey = ls_monitor->acckey
                                          BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cte.
      ENDIF.

      READ TABLE lt_nfe INTO DATA(ls_nfe) WITH KEY acckey = ls_monitor->acckey
                                          BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_nfe.
      ENDIF.

      READ TABLE lt_model INTO DATA(ls_model) WITH KEY model = ls_cte-model
                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_model.
      ENDIF.

      READ TABLE lt_tpemis INTO DATA(ls_tpemis) WITH KEY TipoEmissao = ls_cte-tpemis
                                                BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_tpemis.
      ENDIF.

      READ TABLE lt_modal INTO DATA(ls_modal) WITH KEY modal = ls_cte-modal
                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_modal.
      ENDIF.

      READ TABLE lt_tpcte INTO DATA(ls_tpcte) WITH KEY tpcte = ls_cte-tpcte
                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_tpcte.
      ENDIF.

      READ TABLE lt_tpserv INTO DATA(ls_tpserv) WITH KEY tpserv = ls_cte-tpserv
                                                BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_tpserv.
      ENDIF.

      READ TABLE lt_tomador INTO DATA(ls_tomador) WITH KEY tomador = ls_cte-tomador
                                                  BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_tomador.
      ENDIF.

      READ TABLE lt_cst INTO DATA(ls_cst) WITH KEY cst = ls_cte-cst
                                          BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cst.
      ENDIF.

      READ TABLE lt_cnpj_cpf INTO DATA(ls_cnpj_cpf_emit) WITH KEY cnpj_cpf = ls_cte-emit_cnpj_cpf
                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cnpj_cpf_emit.
      ENDIF.

      READ TABLE lt_cnpj_cpf INTO DATA(ls_cnpj_cpf_rem) WITH KEY cnpj_cpf = ls_cte-rem_cnpj_cpf
                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cnpj_cpf_rem.
      ENDIF.

      READ TABLE lt_cnpj_cpf INTO DATA(ls_cnpj_cpf_dest) WITH KEY cnpj_cpf = ls_cte-dest_cnpj_cpf
                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cnpj_cpf_dest.
      ENDIF.

      READ TABLE lt_cnpj_cpf INTO DATA(ls_cnpj_cpf_tom) WITH KEY cnpj_cpf          = ls_cte-tom_cnpj_cpf
                                                                 InscricaoEstadual = ls_cte-tom_ie
                                                        BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE lt_cnpj_cpf INTO ls_cnpj_cpf_tom WITH KEY cnpj_cpf = ls_cte-tom_cnpj_cpf
                                                     BINARY SEARCH.
        IF sy-subrc NE 0.
          CLEAR ls_cnpj_cpf_tom.
        ENDIF.
      ENDIF.

      READ TABLE lt_cnpj_cpf INTO DATA(ls_cnpj_cpf_exped) WITH KEY cnpj_cpf = ls_cte-exped_cnpj_cpf
                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cnpj_cpf_exped.
      ENDIF.

      READ TABLE lt_cnpj_cpf INTO DATA(ls_cnpj_cpf_receb) WITH KEY cnpj_cpf = ls_cte-receb_cnpj_cpf
                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_cnpj_cpf_receb.
      ENDIF.

      ls_monitor->c0_chcte                  = ls_cte-chcte.
      ls_monitor->c0_xml_found              = COND #( WHEN ls_cte-attach_content IS NOT INITIAL
                                                      THEN abap_true
                                                      ELSE abap_false ).
      ls_monitor->c0_xml_found_criticality  = COND #( WHEN ls_cte-attach_content IS NOT INITIAL
                                                      THEN 3
                                                      ELSE 1 ).
      ls_monitor->c0_natop                  = ls_cte-natop.
      ls_monitor->c0_nfenum                 = ls_cte-nfenum.
      ls_monitor->c0_serie                  = ls_cte-serie.
      ls_monitor->c0_tp_oper                = ls_cte-tp_oper.
      ls_monitor->c0_tp_oper_criticality    = SWITCH #( ls_cte-tp_oper
                                                        WHEN 'Entrada'
                                                        THEN 3
                                                        ELSE 1 ).
      ls_monitor->c0_valor                  = ls_cte-valor.
      ls_monitor->c0_lifnr                  = ls_cte-lifnr.
      ls_monitor->c0_lifnr_txt              = ls_cte-lifnr_name1.

      ls_monitor->n0_chnfse                 = ls_nfe-chnfse.
      ls_monitor->n0_dtemiss                = ls_nfe-dtemi.
      ls_monitor->n0_nfenum                 = ls_nfe-nfenum.
      ls_monitor->n0_serie                  = ls_nfe-serie.
      ls_monitor->n0_tp_oper                = ls_nfe-tp_oper.
      ls_monitor->n0_tp_oper_criticality    = SWITCH #( ls_nfe-tp_oper
                                                        WHEN 'Entrada'
                                                        THEN 3
                                                        ELSE 1 ).
      ls_monitor->n0_valor                  = ls_nfe-valor.
      ls_monitor->n0_lifnr                  = ls_nfe-lifnr.
      ls_monitor->n0_lifnr_txt              = ls_nfe-lifnr_name1.

      ls_monitor->c1_regio                  = ls_cte-regio.
      ls_monitor->c1_nfyear                 = ls_cte-nfyear.
      ls_monitor->c1_nfmonth                = ls_cte-nfmonth.
      ls_monitor->c1_stcd1                  = ls_cte-stcd1.
      ls_monitor->c1_stcd1_txt              = COND #( WHEN strlen( ls_monitor->c1_stcd1 ) = 14
                                                      THEN ls_monitor->c1_stcd1+0(2) && '.' &&
                                                           ls_monitor->c1_stcd1+2(3) && '.' &&
                                                           ls_monitor->c1_stcd1+5(3) && '/' &&
                                                           ls_monitor->c1_stcd1+8(4) && '-' &&
                                                           ls_monitor->c1_stcd1+12(2)
                                                      WHEN strlen( ls_monitor->c1_stcd1 ) = 11
                                                      THEN ls_monitor->c1_stcd1+0(3) && '.' &&
                                                           ls_monitor->c1_stcd1+3(3) && '.' &&
                                                           ls_monitor->c1_stcd1+6(3) && '-' &&
                                                           ls_monitor->c1_stcd1+9(2)
                                                      ELSE ls_monitor->c1_stcd1 ).

      ls_monitor->c1_model                  = ls_cte-model.
      ls_monitor->c1_model_txt              = ls_model-model_txt.
      ls_monitor->c1_serie                  = ls_cte-serie.
      ls_monitor->c1_nfenum                 = ls_cte-nfenum.
      ls_monitor->c1_tpemis                 = ls_cte-tpemis.
      ls_monitor->c1_tpemis_txt             = ls_tpemis-TipoEmissaoText.
      ls_monitor->c1_docnum8                = ls_cte-docnum8.
      ls_monitor->c1_cdv                    = ls_cte-cdv.

      ls_monitor->c1_digest_value           = ls_cte-digest_value.
      ls_monitor->c1_nprot                  = ls_cte-nprot.
      ls_monitor->c1_dhemi                  = ls_cte-dhemi.
      ls_monitor->c1_cstat                  = ls_cte-cstat.

      ls_monitor->c1_xmotivo                = ls_cte-xmotivo.
      ls_monitor->c1_tpcte                  = ls_cte-tpcte.
      ls_monitor->c1_tpcte_txt              = ls_tpcte-desc_tpcte.
      ls_monitor->c1_tpserv                 = ls_cte-tpserv.
      ls_monitor->c1_tpserv_txt             = ls_tpserv-desc_tpserv.
      ls_monitor->c1_tomador                = ls_cte-tomador.
      ls_monitor->c1_tomador_txt            = ls_tomador-desc_tomador.
      ls_monitor->c1_inicio_prestsrv        = ls_cte-inicio_prestsrv.
      ls_monitor->c1_termino_prestsrv       = ls_cte-termino_prestsrv.
      ls_monitor->c1_modal                  = ls_cte-modal.
      ls_monitor->c1_modal_txt              = ls_modal-desc_modal.

      IF ls_monitor->chcte IS NOT INITIAL.

        ls_monitor->emit_cod                  = ls_cnpj_cpf_emit-parceiro.
        ls_monitor->emit_nome                 = ls_cte-emit_nome.
        ls_monitor->emit_cnpj_cpf             = ls_cte-emit_cnpj_cpf.
        ls_monitor->emit_cnpj_cpf_txt         = COND #( WHEN strlen( ls_monitor->emit_cnpj_cpf ) = 14
                                                        THEN ls_monitor->emit_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->emit_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->emit_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->emit_cnpj_cpf ) = 11
                                                    THEN ls_monitor->emit_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->emit_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->emit_cnpj_cpf ).
        ls_monitor->emit_endereco         = ls_cte-emit_endereco.
        ls_monitor->emit_complemento      = ls_cte-emit_complemento.
        ls_monitor->emit_cep_bairro       = ls_cte-emit_cep_bairro.
        ls_monitor->emit_municipio_uf     = ls_cte-emit_municipio_uf.
        ls_monitor->emit_ie               = ls_cte-emit_ie.

        ls_monitor->rem_cod               = ls_cnpj_cpf_rem-parceiro.
        ls_monitor->rem_nome              = ls_cte-rem_nome.
        ls_monitor->rem_cnpj_cpf          = ls_cte-rem_cnpj_cpf.
        ls_monitor->rem_cnpj_cpf_txt      = COND #( WHEN strlen( ls_monitor->rem_cnpj_cpf ) = 14
                                                    THEN ls_monitor->rem_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->rem_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->rem_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->rem_cnpj_cpf ) = 11
                                                    THEN ls_monitor->rem_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->rem_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->rem_cnpj_cpf ).
        ls_monitor->rem_endereco          = ls_cte-rem_endereco.
        ls_monitor->rem_complemento       = ls_cte-rem_complemento.
        ls_monitor->rem_cep_bairro        = ls_cte-rem_cep_bairro.
        ls_monitor->rem_municipio_uf      = ls_cte-rem_municipio_uf.
        ls_monitor->rem_ie                = ls_cte-rem_ie.

        ls_monitor->dest_cod              = ls_cnpj_cpf_dest-parceiro.
        ls_monitor->dest_nome             = ls_cte-dest_nome.
        ls_monitor->dest_cnpj_cpf         = ls_cte-dest_cnpj_cpf.
        ls_monitor->dest_cnpj_cpf_txt     = COND #( WHEN strlen( ls_monitor->dest_cnpj_cpf ) = 14
                                                    THEN ls_monitor->dest_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->dest_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->dest_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->dest_cnpj_cpf ) = 11
                                                    THEN ls_monitor->dest_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->dest_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->dest_cnpj_cpf ).
        ls_monitor->dest_endereco         = ls_cte-dest_endereco.
        ls_monitor->dest_complemento      = ls_cte-dest_complemento.
        ls_monitor->dest_cep_bairro       = ls_cte-dest_cep_bairro.
        ls_monitor->dest_municipio_uf     = ls_cte-dest_municipio_uf.
        ls_monitor->dest_ie               = ls_cte-dest_ie.

        ls_monitor->tom_cod               = ls_cnpj_cpf_tom-parceiro.
        ls_monitor->tom_nome              = ls_cte-tom_nome.
        ls_monitor->tom_cnpj_cpf          = ls_cte-tom_cnpj_cpf.
        ls_monitor->tom_cnpj_cpf_txt      = COND #( WHEN strlen( ls_monitor->tom_cnpj_cpf ) = 14
                                                    THEN ls_monitor->tom_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->tom_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->tom_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->tom_cnpj_cpf ) = 11
                                                    THEN ls_monitor->tom_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->tom_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->tom_cnpj_cpf ).
        ls_monitor->tom_endereco          = ls_cte-tom_endereco.
        ls_monitor->tom_complemento       = ls_cte-tom_complemento.
        ls_monitor->tom_cep_bairro        = ls_cte-tom_cep_bairro.
        ls_monitor->tom_municipio_uf      = ls_cte-tom_municipio_uf.
        ls_monitor->tom_ie                = ls_cte-tom_ie.

        ls_monitor->exped_cod             = ls_cnpj_cpf_exped-parceiro.
        ls_monitor->exped_nome            = ls_cte-exped_nome.
        ls_monitor->exped_cnpj_cpf        = ls_cte-exped_cnpj_cpf.
        ls_monitor->exped_cnpj_cpf_txt    = COND #( WHEN strlen( ls_monitor->exped_cnpj_cpf ) = 14
                                                  THEN ls_monitor->exped_cnpj_cpf+0(2) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+2(3) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+5(3) && '/' &&
                                                       ls_monitor->exped_cnpj_cpf+8(4) && '-' &&
                                                       ls_monitor->exped_cnpj_cpf+12(2)
                                                  WHEN strlen( ls_monitor->exped_cnpj_cpf ) = 11
                                                  THEN ls_monitor->exped_cnpj_cpf+0(3) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+3(3) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+6(3) && '-' &&
                                                       ls_monitor->exped_cnpj_cpf+9(2)
                                                  ELSE ls_monitor->exped_cnpj_cpf ).
        ls_monitor->exped_endereco        = ls_cte-exped_endereco.
        ls_monitor->exped_complemento     = ls_cte-exped_complemento.
        ls_monitor->exped_cep_bairro      = ls_cte-exped_cep_bairro.
        ls_monitor->exped_municipio_uf    = ls_cte-exped_municipio_uf.
        ls_monitor->exped_ie              = ls_cte-exped_ie.

        ls_monitor->receb_cod             = ls_cnpj_cpf_receb-parceiro.
        ls_monitor->receb_nome            = ls_cte-receb_nome.
        ls_monitor->receb_cnpj_cpf        = ls_cte-receb_cnpj_cpf.
        ls_monitor->receb_cnpj_cpf_txt    = COND #( WHEN strlen( ls_monitor->receb_cnpj_cpf ) = 14
                                                  THEN ls_monitor->receb_cnpj_cpf+0(2) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+2(3) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+5(3) && '/' &&
                                                       ls_monitor->receb_cnpj_cpf+8(4) && '-' &&
                                                       ls_monitor->receb_cnpj_cpf+12(2)
                                                  WHEN strlen( ls_monitor->receb_cnpj_cpf ) = 11
                                                  THEN ls_monitor->receb_cnpj_cpf+0(3) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+3(3) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+6(3) && '-' &&
                                                       ls_monitor->receb_cnpj_cpf+9(2)
                                                  ELSE ls_monitor->receb_cnpj_cpf ).
        ls_monitor->receb_endereco        = ls_cte-receb_endereco.
        ls_monitor->receb_complemento     = ls_cte-receb_complemento.
        ls_monitor->receb_cep_bairro      = ls_cte-receb_cep_bairro.
        ls_monitor->receb_municipio_uf    = ls_cte-receb_municipio_uf.
        ls_monitor->receb_ie              = ls_cte-receb_ie.

      ELSEIF ls_monitor->chnfse IS NOT INITIAL.

        ls_monitor->emit_cod                  = ls_nfe-emit_cod.
        ls_monitor->emit_nome                 = ls_nfe-emit_nome.
        ls_monitor->emit_cnpj_cpf             = ls_nfe-emit_cnpj_cpf.
        ls_monitor->emit_cnpj_cpf_txt         = COND #( WHEN strlen( ls_monitor->emit_cnpj_cpf ) = 14
                                                        THEN ls_monitor->emit_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->emit_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->emit_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->emit_cnpj_cpf ) = 11
                                                    THEN ls_monitor->emit_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->emit_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->emit_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->emit_cnpj_cpf ).
        ls_monitor->emit_endereco         = ls_nfe-emit_endereco.
        ls_monitor->emit_complemento      = ls_nfe-emit_complemento.
        ls_monitor->emit_cep_bairro       = ls_nfe-emit_cep_bairro.
        ls_monitor->emit_municipio_uf     = ls_nfe-emit_municipio_uf.
        ls_monitor->emit_ie               = ls_nfe-emit_ie.

        ls_monitor->rem_cod               = ls_nfe-rem_cod.
        ls_monitor->rem_nome              = ls_nfe-rem_nome.
        ls_monitor->rem_cnpj_cpf          = ls_nfe-rem_cnpj_cpf.
        ls_monitor->rem_cnpj_cpf_txt      = COND #( WHEN strlen( ls_monitor->rem_cnpj_cpf ) = 14
                                                    THEN ls_monitor->rem_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->rem_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->rem_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->rem_cnpj_cpf ) = 11
                                                    THEN ls_monitor->rem_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->rem_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->rem_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->rem_cnpj_cpf ).
        ls_monitor->rem_endereco          = ls_nfe-rem_endereco.
        ls_monitor->rem_complemento       = ls_nfe-rem_complemento.
        ls_monitor->rem_cep_bairro        = ls_nfe-rem_cep_bairro.
        ls_monitor->rem_municipio_uf      = ls_nfe-rem_municipio_uf.
        ls_monitor->rem_ie                = ls_nfe-rem_ie.

        ls_monitor->dest_cod              = ls_nfe-dest_cod.
        ls_monitor->dest_nome             = ls_nfe-dest_nome.
        ls_monitor->dest_cnpj_cpf         = ls_nfe-dest_cnpj_cpf.
        ls_monitor->dest_cnpj_cpf_txt     = COND #( WHEN strlen( ls_monitor->dest_cnpj_cpf ) = 14
                                                    THEN ls_monitor->dest_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->dest_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->dest_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->dest_cnpj_cpf ) = 11
                                                    THEN ls_monitor->dest_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->dest_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->dest_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->dest_cnpj_cpf ).
        ls_monitor->dest_endereco         = ls_nfe-dest_endereco.
        ls_monitor->dest_complemento      = ls_nfe-dest_complemento.
        ls_monitor->dest_cep_bairro       = ls_nfe-dest_cep_bairro.
        ls_monitor->dest_municipio_uf     = ls_nfe-dest_municipio_uf.
        ls_monitor->dest_ie               = ls_nfe-dest_ie.

        ls_monitor->tom_cod               = ls_nfe-tom_cod.
        ls_monitor->tom_nome              = ls_nfe-tom_nome.
        ls_monitor->tom_cnpj_cpf          = ls_nfe-tom_cnpj_cpf.
        ls_monitor->tom_cnpj_cpf_txt      = COND #( WHEN strlen( ls_monitor->tom_cnpj_cpf ) = 14
                                                    THEN ls_monitor->tom_cnpj_cpf+0(2) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+2(3) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+5(3) && '/' &&
                                                         ls_monitor->tom_cnpj_cpf+8(4) && '-' &&
                                                         ls_monitor->tom_cnpj_cpf+12(2)
                                                    WHEN strlen( ls_monitor->tom_cnpj_cpf ) = 11
                                                    THEN ls_monitor->tom_cnpj_cpf+0(3) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+3(3) && '.' &&
                                                         ls_monitor->tom_cnpj_cpf+6(3) && '-' &&
                                                         ls_monitor->tom_cnpj_cpf+9(2)
                                                    ELSE ls_monitor->tom_cnpj_cpf ).
        ls_monitor->tom_endereco          = ls_nfe-tom_endereco.
        ls_monitor->tom_complemento       = ls_nfe-tom_complemento.
        ls_monitor->tom_cep_bairro        = ls_nfe-tom_cep_bairro.
        ls_monitor->tom_municipio_uf      = ls_nfe-tom_municipio_uf.
        ls_monitor->tom_ie                = ls_nfe-tom_ie.

        ls_monitor->exped_cod             = ls_nfe-exped_cod.
        ls_monitor->exped_nome            = ls_nfe-exped_nome.
        ls_monitor->exped_cnpj_cpf        = ls_nfe-exped_cnpj_cpf.
        ls_monitor->exped_cnpj_cpf_txt    = COND #( WHEN strlen( ls_monitor->exped_cnpj_cpf ) = 14
                                                  THEN ls_monitor->exped_cnpj_cpf+0(2) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+2(3) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+5(3) && '/' &&
                                                       ls_monitor->exped_cnpj_cpf+8(4) && '-' &&
                                                       ls_monitor->exped_cnpj_cpf+12(2)
                                                  WHEN strlen( ls_monitor->exped_cnpj_cpf ) = 11
                                                  THEN ls_monitor->exped_cnpj_cpf+0(3) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+3(3) && '.' &&
                                                       ls_monitor->exped_cnpj_cpf+6(3) && '-' &&
                                                       ls_monitor->exped_cnpj_cpf+9(2)
                                                  ELSE ls_monitor->exped_cnpj_cpf ).
        ls_monitor->exped_endereco        = ls_nfe-exped_endereco.
        ls_monitor->exped_complemento     = ls_nfe-exped_complemento.
        ls_monitor->exped_cep_bairro      = ls_nfe-exped_cep_bairro.
        ls_monitor->exped_municipio_uf    = ls_nfe-exped_municipio_uf.
        ls_monitor->exped_ie              = ls_nfe-exped_ie.

        ls_monitor->receb_cod             = ls_nfe-receb_cod.
        ls_monitor->receb_nome            = ls_nfe-receb_nome.
        ls_monitor->receb_cnpj_cpf        = ls_nfe-receb_cnpj_cpf.
        ls_monitor->receb_cnpj_cpf_txt    = COND #( WHEN strlen( ls_monitor->receb_cnpj_cpf ) = 14
                                                  THEN ls_monitor->receb_cnpj_cpf+0(2) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+2(3) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+5(3) && '/' &&
                                                       ls_monitor->receb_cnpj_cpf+8(4) && '-' &&
                                                       ls_monitor->receb_cnpj_cpf+12(2)
                                                  WHEN strlen( ls_monitor->receb_cnpj_cpf ) = 11
                                                  THEN ls_monitor->receb_cnpj_cpf+0(3) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+3(3) && '.' &&
                                                       ls_monitor->receb_cnpj_cpf+6(3) && '-' &&
                                                       ls_monitor->receb_cnpj_cpf+9(2)
                                                  ELSE ls_monitor->receb_cnpj_cpf ).
        ls_monitor->receb_endereco        = ls_nfe-receb_endereco.
        ls_monitor->receb_complemento     = ls_nfe-receb_complemento.
        ls_monitor->receb_cep_bairro      = ls_nfe-receb_cep_bairro.
        ls_monitor->receb_municipio_uf    = ls_nfe-receb_municipio_uf.
        ls_monitor->receb_ie              = ls_nfe-receb_ie.
      ENDIF.

      ls_monitor->c6_vtpres             = ls_cte-vtprest.
      ls_monitor->c6_vrec               = ls_cte-vrec.
      ls_monitor->c6_cst                = ls_cte-cst.
      ls_monitor->c6_cst_txt            = ls_cst-desc_cst.
      ls_monitor->c6_predbc             = ls_cte-predbc.

      ls_monitor->c6_vcred              = ls_cte-vcred.
      ls_monitor->c6_vbcicms            = ls_cte-vbcicms.
      ls_monitor->c6_picms              = ls_cte-picms.
      ls_monitor->c6_vicms              = ls_cte-vicms.
      ls_monitor->c6_vtottrib           = ls_cte-vtottrib.

      ls_monitor->c7_vcarga             = ls_cte-vcarga.
      ls_monitor->c7_propred            = ls_cte-propred.
      ls_monitor->c7_xoutcat            = ls_cte-xoutcat.
      ls_monitor->c7_xobs               = ls_cte-xobs.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_monitor ).

  ENDMETHOD.

ENDCLASS.
