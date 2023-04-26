CLASS zcltm_tcc_rules DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES /scmtms/if_tcc_rules .

    METHODS busca_fu_assign
      IMPORTING
        !is_tor_fo           TYPE /scmtms/s_tor_root_k
      RETURNING
        VALUE(rt_tor_assign) TYPE /scmtms/t_tor_root_k .
    METHODS busca_referencia
      IMPORTING
        !is_tor_fo           TYPE /scmtms/s_tor_root_k
      RETURNING
        VALUE(rt_tor_docref) TYPE /scmtms/t_tor_docref_k .
    METHODS busca_bupa_ship_root
      IMPORTING
        !is_tor_fo               TYPE /scmtms/s_tor_root_k
      RETURNING
        VALUE(rt_bupa_ship_root) TYPE /bofu/t_bupa_root_k .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_tcc_rules IMPLEMENTATION.


  METHOD /scmtms/if_tcc_rules~agreement_exclusion.
    RETURN.
  ENDMETHOD.


  METHOD /scmtms/if_tcc_rules~calc_sheet_item_precondition.
    RETURN.
  ENDMETHOD.


  METHOD /scmtms/if_tcc_rules~calc_sheet_precondition.
    RETURN.
  ENDMETHOD.


  METHOD /scmtms/if_tcc_rules~charge_calc_through_formula.

    DATA: lt_rem    TYPE tcm_t_vbrp,
          lt_refkey TYPE zctgtm_cargo_refkey,
          ls_tor_fo TYPE /scmtms/s_tor_root_k,
          lv_status TYPE ze_gko_codstatus.

    FIELD-SYMBOLS:
          <fs_amounts> TYPE /scmtms/s_tcc_amt_w_role_com.

    TRY.
        " Recupera primeiro registro, se existir
        DATA(ls_bus_data) = it_bus_data[ 1 ].
      CATCH cx_root.
    ENDTRY.

    ls_tor_fo-key       = ls_bus_data-key.
    ls_tor_fo-tor_id    = ls_bus_data-document_id.

    DATA(lt_fu_assign)  = busca_fu_assign( ls_tor_fo ).
    DATA(lt_fo_dcref)   = busca_referencia( ls_tor_fo ).
    DATA(lt_bupa_root)  = busca_bupa_ship_root( ls_tor_fo ).
    DATA(ls_bupa_root)  = lt_bupa_root[ 1 ].

    lt_rem = VALUE #( FOR ls_docref IN lt_fo_dcref ( ls_docref-btd_id+25(10) ) ).
    SORT lt_rem BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_rem COMPARING table_line.

    DELETE lt_fo_dcref WHERE btd_tco NE '73' AND btd_tco NE '58'.

    IF lt_fo_dcref IS INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados do FLUIG
* ---------------------------------------------------------------------------
    SELECT DISTINCT *
      INTO TABLE @DATA(lt_fluig)
      FROM ztm_infos_fluig
      FOR ALL ENTRIES IN @lt_rem
      WHERE remessa = @lt_rem-table_line.

    IF lt_fluig IS NOT INITIAL.

    ELSE.

      SELECT DISTINCT vbeln
        INTO TABLE @DATA(lt_faturas)
        FROM vbfa
        FOR ALL ENTRIES IN @lt_rem
        WHERE vbelv   = @lt_rem-table_line
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
          WHERE docnum = @lv_docnum.          "#EC CI_ALL_FIELDS_NEEDED

        DATA(lv_acckey) = ls_active-regio && ls_active-nfyear && ls_active-nfmonth && ls_active-stcd1 && ls_active-model && ls_active-serie && ls_active-nfnum9 && ls_active-docnum9 && ls_active-cdv.

        SELECT DISTINCT *
          INTO TABLE @lt_fluig
          FROM ztm_infos_fluig
          WHERE chave_nfe = @lv_acckey.

      ENDIF.

    ENDIF.

* ---------------------------------------------------------------------------
* Diferentes processamentos dependendo do tipo de custo
* ---------------------------------------------------------------------------
    CASE cr_charge_line->tcet084.

      WHEN 'FRETE_FLUIG_ADC'.
        IF lt_fluig IS NOT INITIAL.
          LOOP AT cr_charge_line->amounts ASSIGNING <fs_amounts>.
            <fs_amounts>-amount = lt_fluig[ 1 ]-custo_adicional / 10000.
          ENDLOOP.
        ENDIF.

      WHEN 'FRETE_FLUIG'.
        IF lt_fluig IS NOT INITIAL.
          LOOP AT cr_charge_line->amounts ASSIGNING <fs_amounts>.
            <fs_amounts>-amount = lt_fluig[ 1 ]-vlr_frete / 10000.
          ENDLOOP.
        ENDIF.

*      WHEN 'COBFRETE'.
*
*        SELECT SINGLE vtprest INTO @DATA(lv_vlr_frete)
*          FROM zttm_gkot001
*          WHERE tor_id = @ls_tor_fo-tor_id.
*
*        IF sy-subrc IS INITIAL.
*          LOOP AT cr_charge_line->amounts ASSIGNING <fs_amounts>.
*            <fs_amounts>-amount = lv_vlr_frete / 10000.
*          ENDLOOP.
*        ENDIF.

      WHEN 'COCKPIT'.

* ------------------------------------------------------
* Validação será feita no ZCLTM_EVENTOS_EXTRAS
* ------------------------------------------------------

*        " Verifica os valores de Frete FLUIG
*        LOOP AT is_do_charges-chargeelements[] INTO DATA(ls_chargeelements).
*
*          " Se existir algum valor, não atualizar o cockpit.
*          IF ls_chargeelements-tcet084 = 'FRETE_FLUIG' AND ls_chargeelements-amount NE 0.
*            RETURN.
*          ENDIF.
*
*          " Se existir algum valor, não atualizar o cockpit.
*          IF ls_chargeelements-tcet084 = 'FRETE_FLUIG_ADC' AND ls_chargeelements-amount NE 0.
*            RETURN.
*          ENDIF.
*
*        ENDLOOP.
*
*        IF ls_bus_data-destloc_id IS NOT INITIAL AND ls_bus_data-bill_from_party_id IS INITIAL.
*
*          " Verifica se a Ordem de frete em processamento é do evento "Normal"
*          SELECT SINGLE acckey, vtprest
*            FROM zttm_gkot001
*            WHERE tor_id   = @ls_tor_fo-tor_id
*              AND dest_cod = @ls_bus_data-ship_to_party_id
*              AND rem_cod  = @ls_bupa_root-partner+0(10)
*              AND emit_cod = @ls_bus_data-tsp_id
*              AND ( tpevento = 'NORMAL' OR tpevento = 'ENTREGA' )
*            INTO @DATA(ls_gko001).
*
*          IF sy-subrc EQ 0.
*            LOOP AT cr_charge_line->amounts ASSIGNING <fs_amounts>.
*              <fs_amounts>-amount = ls_gko001-vtprest / 10000.
*            ENDLOOP.
*          ENDIF.
*        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD /scmtms/if_tcc_rules~rate_table_determination.
    RETURN.
  ENDMETHOD.


  METHOD busca_fu_assign.

    DATA:
      lt_tor_root_key TYPE /bobf/t_frw_key.

    CHECK is_tor_fo IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_tor_fo-key CHANGING ct_key = lt_tor_root_key ).


    lo_tor_mgr->retrieve_by_association(
      EXPORTING
          it_key         = lt_tor_root_key
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
          iv_fill_data   = abap_true
      IMPORTING
           et_data     = rt_tor_assign ).

  ENDMETHOD.


  METHOD busca_referencia.

    DATA:
      lt_tor_root_key TYPE /bobf/t_frw_key.

    CHECK is_tor_fo IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_tor_fo-key CHANGING ct_key = lt_tor_root_key ).

    lo_tor_mgr->retrieve_by_association(
      EXPORTING
          it_key         = lt_tor_root_key
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          iv_association = /scmtms/if_tor_c=>sc_association-root-docreference
          iv_fill_data   = abap_true
      IMPORTING
           et_data     = rt_tor_docref ).

  ENDMETHOD.


  METHOD busca_bupa_ship_root.

    DATA: lt_tor_root_key TYPE /bobf/t_frw_key.

    CHECK is_tor_fo IS NOT INITIAL.

    DATA(lo_tor_mgr) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = is_tor_fo-key CHANGING ct_key = lt_tor_root_key ).

    lo_tor_mgr->retrieve_by_association(
      EXPORTING
          it_key         = lt_tor_root_key
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          iv_association = /scmtms/if_tor_c=>sc_association-root-bupa_ship_root
          iv_fill_data   = abap_true
      IMPORTING
           et_data     = rt_bupa_ship_root ).
  ENDMETHOD.


ENDCLASS.
