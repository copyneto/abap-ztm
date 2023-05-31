CLASS zcltm_ses_acc_assign DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_sfir_ses_acc_assign .
    INTERFACES if_badi_interface .

    METHODS busca_referencia
      IMPORTING
        !is_tor_fo           TYPE /scmtms/s_tor_root_k
      RETURNING
        VALUE(rt_tor_docref) TYPE /scmtms/t_tor_docref_k .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS determina_loc_origem_dest
      IMPORTING
        !it_sfir_item_data TYPE /scmtms/t_sfir_item_k
        !it_stage_loc_data TYPE /scmtms/cl_sfir_helper_root=>tty_stage_data
        !it_postal_addr    TYPE /bofu/t_addr_postal_addressk
      EXPORTING
        !es_loc_origem     TYPE /bofu/s_addr_postal_addressk
        !es_loc_dest       TYPE /bofu/s_addr_postal_addressk .
    METHODS trata_caracter_especial
      IMPORTING
        !iv_text       TYPE any
      RETURNING
        VALUE(rv_text) TYPE string .
ENDCLASS.



CLASS ZCLTM_SES_ACC_ASSIGN IMPLEMENTATION.


  METHOD /scmtms/if_sfir_ses_acc_assign~modify_acc_assign.

    DATA:
      lt_remessa TYPE tcm_t_vbrp,
      lt_refkey  TYPE zctgtm_cargo_refkey.

    DATA:
      lt_taxnum_tom  TYPE TABLE OF bptaxnum,
      lt_taxnum_rem  TYPE TABLE OF bptaxnum,
      lt_taxnum_dest TYPE TABLE OF bptaxnum.

    DATA: lr_locno_guid       TYPE RANGE OF /scmb/mdl_locid.

    DATA: lv_tor_id         TYPE /scmtms/tor_id,
          lv_rem_cod        TYPE ze_gko_rem_cod,
          lv_dest_cod       TYPE ze_gko_dest_cod,
          lv_ug_centro_orig TYPE /sapapo/locno,
          lv_ug_centro_dest TYPE /sapapo/locno.

    DATA: lo_post_sfir      TYPE REF TO /scmtms/cl_post_sfir_for_accru,
          lt_sfir_item_data TYPE /scmtms/t_sfir_item_k,
          lt_tor_root_data  TYPE /scmtms/t_tor_root_k,
          lt_tor_item_data  TYPE STANDARD TABLE OF /scmtms/s_tor_item_tr_k,
          lt_tor_stop       TYPE /scmtms/t_tor_stop_k,
          lv_transport_mode TYPE /scmtms/trmodcat.


    " Verifica se existe Frete de entrada
    DATA(lt_charge_ele) = ct_charge_ele.
    SORT lt_charge_ele BY service.

    READ TABLE lt_charge_ele TRANSPORTING NO FIELDS WITH KEY service = '000000000002000600'
                                                             BINARY SEARCH.
    IF sy-subrc EQ 0.
      " Não determinar conta quando for Frete de Entrada
      RETURN.
    ENDIF.

    lo_post_sfir = /scmtms/cl_post_sfir_for_accru=>get_instance( ).
    CALL METHOD lo_post_sfir->get_data
      IMPORTING
        et_sfir_root_data = DATA(lt_sfir_root_data)
        et_sfir_item_data = lt_sfir_item_data
        et_bupa_data      = DATA(lt_bupa_data)
        et_tor_root_data  = lt_tor_root_data
        et_tor_item_data  = DATA(lt_tor_item)
        et_loc_key        = DATA(lt_loc_key)
        et_tor_stop       = lt_tor_stop
        et_postal_addr    = DATA(lt_postal_addr)
        et_stage_loc_data = DATA(lt_stage_loc_data)
        et_location_data  = DATA(lt_location_data)
        et_fsd_po_item    = DATA(lt_fsd_po_item).

    " Determina Local de Expedição Origem/Destino
    determina_loc_origem_dest(
      EXPORTING
        it_sfir_item_data = lt_sfir_item_data   " Main Area: SFIR Item
        it_stage_loc_data = lt_stage_loc_data   " Stages
        it_postal_addr    = lt_postal_addr      " /SCMTMS/S_ADDR_POSTAL_ADDRESSK
      IMPORTING
        es_loc_origem     = DATA(ls_loc_origem) " Node structure for postal address data - internal
        es_loc_dest       = DATA(ls_loc_dest) )." Node structure for postal address data - internal

    READ TABLE lt_sfir_item_data ASSIGNING FIELD-SYMBOL(<fs_sfir_item>) WITH KEY parent_key COMPONENTS parent_key = iv_sfir_key.
    CHECK sy-subrc IS INITIAL.
    READ TABLE lt_tor_root_data ASSIGNING FIELD-SYMBOL(<fs_tor_root>) WITH TABLE KEY key = <fs_sfir_item>-tor_root_key.
    CHECK sy-subrc IS INITIAL.

    APPEND INITIAL LINE TO lr_locno_guid ASSIGNING FIELD-SYMBOL(<fs_locno>).
    <fs_locno>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_locno>-option = /bobf/if_conf_c=>sc_sign_equal.
    <fs_locno>-low    = ls_loc_origem-root_key.

    APPEND INITIAL LINE TO lr_locno_guid ASSIGNING <fs_locno>.
    <fs_locno>-sign   = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_locno>-option = /bobf/if_conf_c=>sc_sign_equal.
    <fs_locno>-low    = ls_loc_dest-root_key.

    SELECT loc~loc_uuid,
           partner~partner
      INTO TABLE @DATA(lt_partner)
      FROM       /sapapo/loc AS loc
      INNER JOIN but000      AS partner ON partner~partner_guid = loc~partner_guid
      WHERE loc~loc_uuid IN @lr_locno_guid.

    CHECK sy-subrc IS INITIAL.

    IF line_exists( lt_partner[ loc_uuid = ls_loc_origem-root_key ] ).
      lv_rem_cod        =  lt_partner[ loc_uuid = ls_loc_origem-root_key ]-partner.

      READ TABLE lt_location_data WITH KEY location_uuid = ls_loc_origem-root_key location_type_code = '1003' ASSIGNING FIELD-SYMBOL(<orig_loc>).
      IF sy-subrc IS INITIAL.
        lv_ug_centro_orig = <orig_loc>-location_id+3(4).
      ENDIF.
    ENDIF.

    IF line_exists( lt_partner[ loc_uuid = ls_loc_dest-root_key ] ).
      lv_dest_cod = lt_partner[ loc_uuid = ls_loc_dest-root_key ]-partner.

      READ TABLE lt_location_data WITH KEY location_uuid = ls_loc_dest-root_key location_type_code = '1003' ASSIGNING FIELD-SYMBOL(<dest_loc>).
      IF sy-subrc IS INITIAL.
        lv_ug_centro_dest = <dest_loc>-location_id+3(4).
      ENDIF.
    ENDIF.

    CLEAR: lv_tor_id.
    lv_tor_id = |{ <fs_tor_root>-tor_id ALPHA = IN }|.

*    SELECT * INTO TABLE @DATA(lt_001)
*      FROM zttm_gkot001
*     WHERE tor_id      = @lv_tor_id           AND
*           emit_cod    = @<fs_tor_root>-tspid AND
*           rem_cod     = @lv_rem_cod          AND
*           dest_cod    = @lv_dest_cod         .
*
*    IF sy-subrc IS INITIAL.
*      DATA(ls_001) = lt_001[ 1 ].
*    ELSE.
*      RETURN.
*    ENDIF.
*
*    CASE ls_001-cenario .
*      WHEN '06'. "fretes diversos

* ---------------------------------------------------------------------------
* Separa as remessas
* ---------------------------------------------------------------------------
    DATA(lt_fo_dcref)  = busca_referencia( <fs_tor_root> ).
    DELETE lt_fo_dcref WHERE btd_tco NE '73' AND  btd_tco NE '58'.
    CHECK lt_fo_dcref IS NOT INITIAL.

    lt_remessa = VALUE #( FOR ls_docref IN lt_fo_dcref ( ls_docref-btd_id+25(10) ) ).
    SORT lt_remessa BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_remessa COMPARING table_line.

* ---------------------------------------------------------------------------
* Recupera dados do FLUIG
* ---------------------------------------------------------------------------
    SELECT DISTINCT vbeln
      INTO TABLE @DATA(lt_faturas)
      FROM vbfa
      FOR ALL ENTRIES IN @lt_remessa
      WHERE vbelv   = @lt_remessa-table_line
        AND vbtyp_n = 'M'.

    IF sy-subrc IS INITIAL.

      LOOP AT lt_faturas ASSIGNING FIELD-SYMBOL(<fs_fat>).
        APPEND <fs_fat>-vbeln TO lt_refkey.
      ENDLOOP.

      SELECT DISTINCT *
         FROM j_1bnflin
         INTO TABLE @DATA(lt_lin)
         FOR ALL ENTRIES IN @lt_refkey
         WHERE refkey = @lt_refkey-table_line.

      IF sy-subrc IS INITIAL.
        DATA(lv_docnum) = lt_lin[ 1 ]-docnum.
      ENDIF.

      SELECT SINGLE * INTO @DATA(ls_active)
        FROM j_1bnfe_active
        WHERE docnum = @lv_docnum.            "#EC CI_ALL_FIELDS_NEEDED

      DATA(lv_acckey) = ls_active-regio && ls_active-nfyear && ls_active-nfmonth && ls_active-stcd1 && ls_active-model && ls_active-serie && ls_active-nfnum9 && ls_active-docnum9 && ls_active-cdv.

      SELECT *
        INTO TABLE @DATA(lt_fluig)
        FROM ztm_infos_fluig
        WHERE chave_nfe = @lv_acckey.

    ENDIF.

* ---------------------------------------------------------------------------
* Verifica e atualiza Centro de Custo e Conta contábil
* ---------------------------------------------------------------------------
    IF lt_fluig IS INITIAL.

      IF lt_remessa IS NOT INITIAL.
        SELECT *
          INTO TABLE lt_fluig
          FROM ztm_infos_fluig
          FOR ALL ENTRIES IN lt_remessa
          WHERE remessa EQ lt_remessa-table_line.
      ENDIF.
    ENDIF.

    IF lt_fluig IS NOT INITIAL.
      DATA(ls_fluig) = lt_fluig[ 1 ].

      LOOP AT ct_charge_ele ASSIGNING FIELD-SYMBOL(<fs_ct_charge_ele>).

        LOOP AT <fs_ct_charge_ele>-element_acc ASSIGNING FIELD-SYMBOL(<fs_element>).
          " Variavel para controle se houve modificação da Conta contabil
          DATA(lv_control_cc) = abap_true.

          <fs_element>-kostl = ls_fluig-centro_custo.
          <fs_element>-sakto = ls_fluig-conta_contabil.
        ENDLOOP.
      ENDLOOP.

    ELSEIF <fs_tor_root>-eikto IS NOT INITIAL.
      LOOP AT ct_charge_ele ASSIGNING <fs_ct_charge_ele>.

        LOOP AT <fs_ct_charge_ele>-element_acc ASSIGNING <fs_element>.
          " Variavel para controle se houve modificação da Conta contabil
          lv_control_cc =  abap_true.

          <fs_element>-kostl = <fs_tor_root>-eikto.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera a linha do DFF em processamento
* ---------------------------------------------------------------------------
    TRY.
        DATA(ls_sfir_root) = lt_sfir_root_data[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera dados da Ordem de Frete
* ---------------------------------------------------------------------------
    zcltm_gko_process=>determina_configuracao_p013( EXPORTING iv_acckey       = ls_sfir_root-zzacckey
                                                              iv_tor_id       = lv_tor_id
                                                    IMPORTING es_header       = DATA(ls_001)
                                                              ev_tom_branch   = DATA(lv_tom_branch)
                                                              ev_rem_branch   = DATA(lv_rem_branch)
                                                              ev_dest_branch  = DATA(lv_dest_branch)
                                                              ev_exped_branch = DATA(lv_exped_branch)
                                                              ev_receb_branch = DATA(lv_receb_branch)
                                                              es_p013         = DATA(ls_p013) ).

* ---------------------------------------------------------------------------
* Verifica se houve modificação da Conta Contábil e processa
* ---------------------------------------------------------------------------
    IF lv_control_cc IS INITIAL.

*      SELECT werks, kunnr, j_1bbranch
*        INTO TABLE @DATA(lt_tom_branch)
*        FROM t001w
*        WHERE kunnr = @ls_001-tom_cod.
*
*      SELECT werks, kunnr, j_1bbranch
*        INTO TABLE @DATA(lt_rem_branch)
*        FROM t001w
*        WHERE kunnr = @ls_001-rem_cod.
*
*      SELECT werks, kunnr, j_1bbranch
*        INTO TABLE @DATA(lt_dest_branch)
*        FROM t001w
*        WHERE kunnr = @ls_001-dest_cod.
*
*      IF lt_tom_branch IS NOT INITIAL.
*        DATA(lv_tom_branch) = lt_tom_branch[ 1 ]-j_1bbranch. "werks.
*      ENDIF.
*
*      IF lt_rem_branch IS NOT INITIAL.
*        DATA(lv_rem_branch) = lt_rem_branch[ 1 ]-j_1bbranch. "werks.
*      ENDIF.
*
*      IF lt_dest_branch IS NOT INITIAL.
*        DATA(lv_dest_branch) = lt_dest_branch[ 1 ]-j_1bbranch. "werks.
*      ENDIF.
*
*      SELECT *
*        INTO TABLE @DATA(lt_p013)
*        FROM zttm_pcockpit013
*        WHERE cenario     = @ls_001-cenario
*          AND uforig      = @ls_001-rem_uf
*          AND ufdest      = @ls_001-dest_uf
*          AND rem_branch  = @lv_rem_branch
*          AND tom_branch  = @lv_tom_branch
*          AND dest_branch = @lv_dest_branch
*          AND loc_ret     = @ls_001-ret_loc
*          AND loc_ent     = @ls_001-ent_loc.
*
*      IF sy-subrc IS NOT INITIAL.
*
*        SELECT *
*          INTO TABLE @lt_p013
*          FROM zttm_pcockpit013
*          WHERE cenario     = '00'
*            AND uforig      = @ls_001-rem_uf
*            AND ufdest      = @ls_001-dest_uf
*            AND rem_branch  = @lv_rem_branch
*            AND tom_branch  = @lv_tom_branch
*            AND dest_branch = @lv_dest_branch
*            AND loc_ret     = @ls_001-ret_loc
*            AND loc_ent     = @ls_001-ent_loc.
*
*        IF sy-subrc IS NOT INITIAL.
*
*          SELECT *
*            INTO TABLE @lt_p013
*            FROM zttm_pcockpit013
*            WHERE cenario     = '00'
*              AND uforig      = @ls_001-rem_uf
*              AND ufdest      = @ls_001-dest_uf
*              AND rem_branch  = @lv_rem_branch
*              AND tom_branch  = @lv_tom_branch.
*        ENDIF.
*
*      ENDIF.
*
*      IF  line_exists( lt_p013[ 1 ] ).
*        DATA(ls_p013) = lt_p013[ 1 ].
*      ENDIF.

      LOOP AT ct_charge_ele ASSIGNING <fs_ct_charge_ele>.
        LOOP AT <fs_ct_charge_ele>-element_acc ASSIGNING <fs_element>.
          IF ls_p013-kostl IS NOT INITIAL.
            <fs_element>-kostl = ls_p013-kostl.
          ENDIF.
          IF ls_p013-saknr IS NOT INITIAL.
            <fs_element>-sakto = ls_p013-saknr.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

    ENDIF.

*    ENDCASE.

*    LOOP AT ct_charge_ele ASSIGNING <fs_ct_charge_ele>.
*
*      LOOP AT <fs_ct_charge_ele>-element_acc ASSIGNING <fs_element>.
*        IF <fs_element>-sakto IS NOT INITIAL.
*          CONTINUE.
*        ENDIF.
*          <fs_element>-sakto = '4411000035'.
*        CASE <fs_element>-bukrs.
*          WHEN '2000'.
*            <fs_element>-kostl = '1306038443'.
*          WHEN '2200'.
*            <fs_element>-kostl = '1101010243'.
*          WHEN '2400'.
*            <fs_element>-kostl = '1231091W18'.
*          WHEN '2600'.
*            <fs_element>-kostl = '1033052943'.
*          WHEN '2800'.
*            <fs_element>-kostl = '1449104L43'.
*          WHEN '3400'.
*            <fs_element>-kostl = '1324038743'.
*        ENDCASE.
*      ENDLOOP.
*    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza log ( exceto para cenário de Entrada )
* ---------------------------------------------------------------------------
    DATA: lv_message TYPE char200.

    IF ls_001-cenario NE '07'.

      CONCATENATE ls_001-cenario
                  ls_001-rem_uf
                  ls_001-dest_uf
*                ls_001-tom_uf
                  lv_rem_branch
                  lv_tom_branch
                  lv_dest_branch
* BEGIN OF DELETE - RPORTES - 25.05.2023 - 8000007483, CORE4 - ERRO DETERMIN CENTRO DE CUSTO
*                  ls_001-ret_loc
*                  ls_001-ent_loc
* END OF DELETE - RPORTES - 25.05.2023 - 8000007483, CORE4 - ERRO DETERMIN CENTRO DE CUSTO
* BEGIN OF INSERT - RPORTES - 25.05.2023 - 8000007483, CORE4 - ERRO DETERMIN CENTRO DE CUSTO
                  lv_exped_branch
                  lv_receb_branch
* END OF INSERT - RPORTES - 25.05.2023 - 8000007483, CORE4 - ERRO DETERMIN CENTRO DE CUSTO
                  INTO lv_message SEPARATED BY space.

      IF <fs_element> IS ASSIGNED.
        IF <fs_element>-kostl IS INITIAL.
          " Não foi possível determinar o Centro de Custo e Conta Contábil &1&2&3&4.
          DATA(lt_return) = VALUE bapiret2_t( ( type       = 'E'
                                                id         = 'ZTM_GKO'
                                                number     = '046'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).
        ELSE.
          " Centro de Custo &1 e Conta Contábil &2 encontrado para &3&4.
          lt_return       = VALUE bapiret2_t( ( type       = 'I'
                                                id         = 'ZTM_GKO'
                                                number     = '125'
                                                message_v1 = <fs_element>-kostl
                                                message_v2 = <fs_element>-sakto
                                                message_v3 = lv_message+0(50)
                                                message_v4 = lv_message+50(50) ) ).
        ENDIF.
      ENDIF.

      TRY.
          IF lt_return IS NOT INITIAL.
            DATA(lr_gko_process) = NEW zcltm_gko_process( iv_acckey    = ls_001-acckey
                                                          iv_tpprocess = zcltm_gko_process=>gc_tpprocess-automatico ).
            IF line_exists( lt_return[ type = 'E' ] ).
              lr_gko_process->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_fat_frete
                                                    it_bapi_ret = lt_return ).
            ELSE.
              lr_gko_process->add_to_log( EXPORTING it_bapi_ret = lt_return ).
            ENDIF.
            lr_gko_process->persist( ).
            lr_gko_process->free( ).
          ENDIF.
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_msg) = lo_root->get_longtext( ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD busca_referencia.
    TRY.
        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root                     " Node
            it_key                  = VALUE #( ( key = is_tor_fo-key ) )                 " Key Table
            iv_association          = /scmtms/if_tor_c=>sc_association-root-docreference " Association
            iv_fill_data            = abap_true                                          " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = rt_tor_docref ).
      CATCH /bobf/cx_frw_contrct_violation.                                              " Caller violates a BOPF contract
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD determina_loc_origem_dest.

    " Documento Faturamento de Frete (DFF) Item
    IF line_exists( it_sfir_item_data[ 1 ] ).
      DATA(ls_sfir_item_data) = it_sfir_item_data[ 1 ].
    ENDIF.
    CHECK ls_sfir_item_data IS NOT INITIAL.

    " Busca Stage
    IF line_exists( it_stage_loc_data[ key = ls_sfir_item_data-tor_stage_key ] ).
      DATA(ls_stage_loc_data) = it_stage_loc_data[ key = ls_sfir_item_data-tor_stage_key ].
    ENDIF.
    CHECK ls_stage_loc_data IS NOT INITIAL.

    " Loc Origem
    IF line_exists( it_postal_addr[ root_key = ls_stage_loc_data-src_loc_uuid ] ).
      DATA(ls_loc_origem) = it_postal_addr[ root_key = ls_stage_loc_data-src_loc_uuid ].
    ENDIF.
    CHECK ls_loc_origem IS NOT INITIAL.

    " Loc Destino
    IF line_exists( it_postal_addr[ root_key = ls_stage_loc_data-des_loc_uuid ] ).
      DATA(ls_loc_dest) = it_postal_addr[ root_key = ls_stage_loc_data-des_loc_uuid ].
    ENDIF.
    CHECK ls_loc_dest IS NOT INITIAL.

    IF ls_loc_origem-city_name IS NOT INITIAL.
      ls_loc_origem-city_name = trata_caracter_especial( iv_text = ls_loc_origem-city_name ).
    ENDIF.

    IF ls_loc_dest-city_name IS NOT INITIAL.
      ls_loc_dest-city_name = trata_caracter_especial( iv_text = ls_loc_dest-city_name ).
    ENDIF.

    es_loc_origem = ls_loc_origem.
    es_loc_dest   = ls_loc_dest.

  ENDMETHOD.


  METHOD trata_caracter_especial.

    CALL FUNCTION 'SCP_REPLACE_STRANGE_CHARS'
      EXPORTING
        intext  = iv_text
      IMPORTING
        outtext = rv_text.

    IF rv_text IS INITIAL.
      rv_text = iv_text.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
