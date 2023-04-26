class ZCLTM_TCC_CALC_COND definition
  public
  final
  create public .

PUBLIC SECTION.
    INTERFACES /scmtms/if_tc_calc_methods.
    TYPES:
      BEGIN OF ts_unloading_total,
        des_stop_key TYPE /scmtms/tor_stop_key,
        amt_gdsv_val TYPE /scmtms/amt_goodsvalue_val,
      END OF ts_unloading_total .
    TYPES:
      tt_unloading_total TYPE STANDARD TABLE OF ts_unloading_total WITH KEY des_stop_key .
    TYPES:
      BEGIN OF ts_stop_succ_perc,
        succ_stop_key  TYPE  /scmtms/tor_stop_key, " Stop Key
        successor_id   TYPE  /scmtms/succ_id,      " Stop ID
        perc_to_remove TYPE /scmtms/amount,        " Percentual a ser removido do valor do frete
      END OF ts_stop_succ_perc .
    TYPES:
      tt_stop_succ_perc TYPE TABLE OF ts_stop_succ_perc WITH DEFAULT KEY .
  methods CONSTRUCTOR .
protected section.

  class-data SV_LAST_MESSAGE type STRING .
private section.

  data C_BRL type /SCMTMS/CURRENCY value 'BRL' ##NO_TEXT.
  constants C_PRD type /SCMTMS/ITEM_CATEGORY value 'PRD' ##NO_TEXT.
  data MO_SERVICE_MANAGER type ref to /BOBF/IF_TRA_SERVICE_MANAGER .

  methods ADD_PERC_CALCULATION_RATE
    importing
      !IR_CHARGE_BASE type ref to /SCMTMS/S_TCC_TRCHRG_ELMNT_COM
      !IV_PERC_AMOUNT type /SCMTMS/AMOUNT .
  methods DETERMINE_PERC_REMOVE_FR_CUST
    returning
      value(RT_RESULT) type TT_STOP_SUCC_PERC .
  methods ADD_PERC_CREDIT_AMOUNT_LOC_CUR
    importing
      !IR_CHARGE_BASE type ref to /SCMTMS/S_TCC_TRCHRG_ELMNT_COM
      !IV_PERC_AMOUNT type /SCMTMS/AMOUNT .
  methods SUMMARIZE_UNLOADING_STOP_VL
    exporting
      !ET_UNLOADING_TOTAL type TT_UNLOADING_TOTAL
      !EV_PRD_TOTAL_VL type /SCMTMS/AMT_GOODSVALUE_VAL .
  methods ADD_PERC_MODIFIED_RATE_AFT_CL
    importing
      !IR_CHARGE_BASE type ref to /SCMTMS/S_TCC_TRCHRG_ELMNT_COM
      !IV_PERC_AMOUNT type /SCMTMS/AMOUNT .
  methods GET_REQUEST_KEY
    returning
      value(RS_RESULT) type /SCMTMS/IF_TCC_ENGINE=>TY_KEY .
  methods GET_TRANSPORT_CHARGES_VALUE
    returning
      value(RV_RESULT) type /SCMTMS/AMOUNT .
  methods GET_SERVICE_MANAGER
    returning
      value(RO_RESULT) type ref to /BOBF/IF_TRA_SERVICE_MANAGER .
  methods GET_DES_STOP_KEY_BY_STOP_SUCC
    importing
      !IV_KEY type /SCMTMS/TCC_KEY
    returning
      value(RV_RESULT) type /SCMTMS/TCC_KEY .
  methods GET_HIER_LOG_RB_REF
    returning
      value(RS_RESULT) type /SCMTMS/IF_TCC_ANALYSIS_LOG=>TY_RB_REF_KEY .
ENDCLASS.



CLASS ZCLTM_TCC_CALC_COND IMPLEMENTATION.


  METHOD /scmtms/if_tc_calc_methods~calculate.
    TRY.
        "Obter valores das paradas sucessoras
        DATA(lt_stop_succ_perc) = me->determine_perc_remove_fr_cust( ).

        DO lines( lt_stop_succ_perc ) TIMES.
          CHECK lt_stop_succ_perc[ sy-index ]-succ_stop_key = me->get_des_stop_key_by_stop_succ( me->get_hier_log_rb_ref( )-res_base_key-res_base_id ).

          "Atribuir a porcentagem na condição de Custo Frete Ajuste
          me->add_perc_credit_amount_loc_cur( ir_charge_base       = ir_charge_base
                                              iv_perc_amount       = lt_stop_succ_perc[ sy-index ]-perc_to_remove  ).

          "Atribuir a porcentagem na condição de Custo Frete Ajuste no Montante de preço tarifa )
          me->add_perc_calculation_rate( ir_charge_base       = ir_charge_base
                                         iv_perc_amount       = lt_stop_succ_perc[ sy-index ]-perc_to_remove ).

          " Atribuir a porcentagem na condição de Custo Frete Ajuste no "modified rate after class rate applied"
          me->add_perc_modified_rate_aft_cl( ir_charge_base       = ir_charge_base
                                             iv_perc_amount       = lt_stop_succ_perc[ sy-index ]-perc_to_remove ).
        ENDDO.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD /scmtms/if_tc_calc_methods~init_data.

    /scmtms/if_tc_calc_methods~mr_tccs_prc_elem   = ir_tccs_prc_elem.
    /scmtms/if_tc_calc_methods~mv_request_key     = iv_request_key.
    /scmtms/if_tc_calc_methods~mr_bus_data_access = ir_bus_data_access.
    IF is_rb_ref_key IS NOT INITIAL.
      /scmtms/if_tc_calc_methods~ms_hier_log_rb_ref = is_rb_ref_key.
    ELSE.
      /scmtms/if_tc_calc_methods~ms_hier_log_rb_ref-res_base_key-request_key = iv_request_key.
    ENDIF.

  ENDMETHOD.


  METHOD add_perc_calculation_rate.
    READ TABLE ir_charge_base->ratedetails ASSIGNING FIELD-SYMBOL(<fs_ratedetails_cal>)
      WITH KEY raterole_033_i  = /scmtms/if_tc_const=>cs_raterolecode-cal.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO ir_charge_base->ratedetails ASSIGNING <fs_ratedetails_cal>.
      <fs_ratedetails_cal>-raterole_033_i  = /scmtms/if_tc_const=>cs_raterolecode-cal.
      <fs_ratedetails_cal>-parent_node_id  = ir_charge_base->node_id.
      <fs_ratedetails_cal>-node_id         = /scmtms/cl_tc_util=>generate_node_id( ).
    ENDIF.
    <fs_ratedetails_cal>-amount          = iv_perc_amount * -1.
    <fs_ratedetails_cal>-currcode016     = '%'.
  ENDMETHOD.


  METHOD add_perc_credit_amount_loc_cur.
    READ TABLE ir_charge_base->amounts ASSIGNING FIELD-SYMBOL(<fs_amount>)
      WITH KEY  amountrco027_i = /scmtms/if_tc_const=>cs_amountrolecode-cal_sheet_amt.
    IF sy-subrc <> 0.
      APPEND INITIAL LINE TO ir_charge_base->amounts ASSIGNING <fs_amount>.
      <fs_amount>-amountrco027_i  = /scmtms/if_tc_const=>cs_amountrolecode-cal_sheet_amt.
      <fs_amount>-parent_node_id  = ir_charge_base->node_id.
      <fs_amount>-node_id         = /scmtms/cl_tc_util=>generate_node_id( ).
    ENDIF.
    <fs_amount>-currcode016          = '%'.
    <fs_amount>-amount               = iv_perc_amount .
    <fs_amount>-s_amount-amount      = iv_perc_amount .
    <fs_amount>-s_amount-currcode016 = '%'.
  ENDMETHOD.


  METHOD add_perc_modified_rate_aft_cl.
    READ TABLE ir_charge_base->ratedetails ASSIGNING FIELD-SYMBOL(<fs_ratedetails_ccr>)
      WITH KEY raterole_033_i  = /scmtms/if_tc_const=>cs_raterolecode-ccr.
    IF sy-subrc = 0.
      <fs_ratedetails_ccr>-amount          = iv_perc_amount * -1.
      <fs_ratedetails_ccr>-currcode016     = '%'.
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    /scmtms/if_tc_calc_methods~mo_hier_log = /scmtms/cl_tcc_factory=>get_analysis_log( iv_bo_key = /scmtms/if_tccs_c=>sc_bo_key ).
    me->mo_service_manager                 = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
  ENDMETHOD.


  METHOD determine_perc_remove_fr_cust.
    " Ler STOP SUCCESSOR pela ordem de frete
    DATA lt_stop_succ TYPE /scmtms/t_tor_stop_succ_k.
    me->get_service_manager( )->retrieve_by_association( EXPORTING it_key         = VALUE #( ( key = me->get_request_key( )-root_key  ) )
                                                                   iv_association = /scmtms/if_tor_c=>sc_association-root-stop_succ
                                                                   iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                                   iv_fill_data   = abap_true
                                                         IMPORTING et_target_key  = DATA(lt_item_tr_k)
                                                                   et_data        = lt_stop_succ ).

    " Distancia total das paradas
    DATA lv_total_distance_km TYPE /scmtms/decimal_value.
    DO lines( lt_stop_succ ) TIMES.
      lv_total_distance_km = lv_total_distance_km + lt_stop_succ[ sy-index ]-distance_km.
    ENDDO.

    " Criar estrutura de parada com o percentual a ser removido do valor total do frete
    DATA lv_total_perc(16) TYPE p DECIMALS 4.
    DO lines( lt_stop_succ ) TIMES.
      APPEND INITIAL LINE TO rt_result ASSIGNING FIELD-SYMBOL(<fs_stop_succ_perc>).
      <fs_stop_succ_perc>-succ_stop_key   = lt_stop_succ[ sy-index ]-succ_stop_key.
      <fs_stop_succ_perc>-successor_id    = lt_stop_succ[ sy-index ]-successor_id.
      <fs_stop_succ_perc>-perc_to_remove  = ( 1 - lt_stop_succ[ sy-index ]-distance_km / lv_total_distance_km ) / 100 .
      lv_total_perc = lv_total_perc + lt_stop_succ[ sy-index ]-distance_km / lv_total_distance_km.
    ENDDO.

    " Adicionar o percentual de diferença na primeira etapa, sendo ela considerada a que possui todas as embalagens
    DATA lv_add_perc TYPE /scmtms/amount.
    IF lv_total_perc < 1.
      " É dividido por 100 devido a divergencia de tamanho nas casas decimais(4 para 6)
      lv_add_perc = ( 1 - lv_total_perc ) / 100.
      READ TABLE rt_result ASSIGNING <fs_stop_succ_perc> WITH KEY successor_id = '0000000001'.
      IF sy-subrc = 0. <fs_stop_succ_perc>-perc_to_remove = <fs_stop_succ_perc>-perc_to_remove - lv_add_perc. ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_des_stop_key_by_stop_succ.
    DATA  lt_d_stop_succ TYPE /scmtms/t_tor_stop_succ_k.
    me->get_service_manager( )->retrieve( EXPORTING it_key         = VALUE #( ( key = iv_key ) )
                                                    iv_node_key    = /scmtms/if_tor_c=>sc_node-stop_successor
                                                    iv_fill_data   = abap_true
                                          IMPORTING et_failed_key  = DATA(lt_failed_key)
                                                    et_data        = lt_d_stop_succ ).
    IF lt_d_stop_succ IS NOT INITIAL.
      rv_result = lt_d_stop_succ[ 1 ]-succ_stop_key.
    ENDIF.
  ENDMETHOD.


  METHOD get_hier_log_rb_ref.
    rs_result = /scmtms/if_tc_calc_methods~ms_hier_log_rb_ref.
  ENDMETHOD.


  METHOD get_request_key.
   rs_result = /scmtms/if_tc_calc_methods~mv_request_key .
  ENDMETHOD.


  METHOD get_service_manager.
    ro_result = me->mo_service_manager.
  ENDMETHOD.


  METHOD get_transport_charges_value.
    " Via de regra só vai existir um transport charge por ordem de frete
    IF me->get_request_key( )-root_key IS NOT INITIAL AND
       me->get_service_manager( ) IS BOUND.

      DATA lt_tcc_d TYPE /scmtms/t_tcc_root_k.
      me->get_service_manager( )->retrieve_by_association( EXPORTING it_key         = VALUE #( ( key = me->get_request_key( )-root_key ) )
                                                                     iv_association = /scmtms/if_tor_c=>sc_association-root-transportcharges
                                                                     iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                                     iv_fill_data   = abap_true
                                                           IMPORTING
                                                                     et_target_key  = DATA(lt_tcc_k)
                                                                     et_data        = lt_tcc_d ).
      IF lt_tcc_d  IS NOT INITIAL.
        rv_result = lt_tcc_d[ 1 ]-total_amount.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD summarize_unloading_stop_vl.
    IF me->get_request_key( )-root_key IS NOT INITIAL AND
       me->get_service_manager( ) IS BOUND.

      DATA lt_item_tr_d TYPE /scmtms/t_tor_item_tr_k.
      me->get_service_manager( )->retrieve_by_association( EXPORTING it_key         = VALUE #( ( key = me->get_request_key( )-root_key  ) )
                                                                     iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                                     iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                                     iv_fill_data   = abap_true
                                                           IMPORTING et_target_key  = DATA(lt_item_tr_k)
                                                                     et_data        = lt_item_tr_d ).

      " Summarize by desc stop
      DO lines( lt_item_tr_d ) TIMES.
        CHECK lt_item_tr_d[ sy-index ]-item_cat = c_prd.

        DATA(ls_desc_total) = VALUE ts_unloading_total( des_stop_key = lt_item_tr_d[ sy-index ]-des_stop_key
                                                        amt_gdsv_val = lt_item_tr_d[ sy-index ]-amt_gdsv_val ).
        COLLECT ls_desc_total INTO et_unloading_total.

        ev_prd_total_vl = ( ev_prd_total_vl + ls_desc_total-amt_gdsv_val ).
      ENDDO.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
