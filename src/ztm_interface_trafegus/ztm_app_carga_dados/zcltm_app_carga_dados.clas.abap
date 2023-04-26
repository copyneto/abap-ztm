CLASS zcltm_app_carga_dados DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider,
      if_rap_query_filter .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_dados,
        businesspartner     TYPE i_businesspartner-businesspartner,
        bptaxnumber         TYPE i_businesspartnertaxnumber-bptaxnumber,
        businesspartnername TYPE i_businesspartner-businesspartnername,
      END OF ty_dados .
    TYPES:
      BEGIN OF ty_veiculo,
        equnr TYPE equi-equnr,
        eqart TYPE equi-eqart,
        eqktk TYPE eqkt-eqktx,
      END OF ty_veiculo .
    TYPES:
      ty_r_valor TYPE RANGE OF string .
    TYPES:
      ty_r_bp TYPE RANGE OF but000-partner .
    TYPES:
      ty_t_dados TYPE TABLE OF ty_dados .
    TYPES:
      ty_t_veiculo TYPE TABLE OF ty_veiculo .
    TYPES:
      ty_t_cds TYPE TABLE OF zc_tm_carga_dados WITH DEFAULT KEY .

    "! Lista de filtros range da tela
    DATA gt_filtro_ranges TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA gt_motorista TYPE ty_t_dados .
    DATA gt_transportador TYPE ty_t_dados .
    DATA gt_veiculo TYPE ty_t_veiculo .
    DATA gt_dados TYPE ty_t_cds .
    DATA gr_motorista TYPE ty_r_bp .
    DATA gr_transportador TYPE ty_r_bp .
    DATA gr_veiculo TYPE ty_r_valor .
    CONSTANTS gc_motorista TYPE ze_tipo_carga_tmv VALUE '1' ##NO_TEXT.
    CONSTANTS gc_transportador TYPE ze_tipo_carga_tmv VALUE '2' ##NO_TEXT.
    CONSTANTS gc_veiculo TYPE ze_tipo_carga_tmv VALUE '3' ##NO_TEXT.
    DATA go_log TYPE REF TO zclca_save_log .
    CONSTANTS gc_sub TYPE balsubobj VALUE 'LOG_INT' ##NO_TEXT.
    CONSTANTS gc_tcode TYPE sy-tcode VALUE 'ZZ1_TRAFEGUS' ##NO_TEXT.
    DATA gt_return TYPE tt_bapiret2 .

    METHODS msg_erro
      IMPORTING iv_codigo TYPE string .
    METHODS msg_sucesso
      IMPORTING iv_codigo TYPE string .
    METHODS envia_motorista .
    METHODS envia_transportador .
    METHODS envia_veiculo .
    METHODS set_output_motorista .
    METHODS set_bp_range
      IMPORTING
        !ir_bp TYPE if_rap_query_filter=>tt_range_option
      CHANGING
        !cr_bp TYPE zcltm_app_carga_dados=>ty_r_bp .

    METHODS get_motorista .
    METHODS check_tipo_carga
      RETURNING
        VALUE(rv_tipo) TYPE string .
    METHODS process .
    METHODS check_modo_teste
      RETURNING
        VALUE(rv_modo) TYPE string .
    METHODS modo_teste .
    METHODS modo_efetivo .
    METHODS get_transportador .
    METHODS set_output_transp .
    METHODS get_veiculo .
    METHODS set_output_veiculo .
ENDCLASS.



CLASS ZCLTM_APP_CARGA_DADOS IMPLEMENTATION.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    TRY.
        me->gt_filtro_ranges = io_request->get_filter( )->get_as_ranges( ) .
        SORT me->gt_filtro_ranges BY name.
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

    me->process( ).

    IF gt_dados IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
      DATA(lt_result_page) = gt_dados[].
      lt_result_page = VALUE #( FOR ls_result_aux IN gt_dados FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result_aux ) ).
* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
      io_response->set_total_number_of_records( CONV #( lines( gt_dados[] ) ) ).
      io_response->set_data( lt_result_page[] ).

    ENDIF.

  ENDMETHOD.


  METHOD check_modo_teste.

    DATA lr_modo TYPE RANGE OF string.

    READ TABLE me->gt_filtro_ranges ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY name = 'MODO_TESTE'
                                                                        BINARY SEARCH.

    IF sy-subrc = 0.

      lr_modo = <fs_filtro>-range.

      READ TABLE lr_modo ASSIGNING FIELD-SYMBOL(<fs_modo>) INDEX 1.
      IF sy-subrc = 0.
        rv_modo = <fs_modo>-low.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_tipo_carga.

    DATA lr_tipo TYPE RANGE OF string.

    READ TABLE me->gt_filtro_ranges ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY name = 'TIPO_CARGA'
                                                                        BINARY SEARCH.

    IF sy-subrc = 0.

      lr_tipo = <fs_filtro>-range.

      READ TABLE lr_tipo ASSIGNING FIELD-SYMBOL(<fs_tipo>) INDEX 1.
      IF sy-subrc = 0.
        rv_tipo = <fs_tipo>-low.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_motorista.

    READ TABLE me->gt_filtro_ranges ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY name = 'MOTORISTA'
                                                                        BINARY SEARCH.

    IF sy-subrc = 0.

      set_bp_range( EXPORTING ir_bp = <fs_filtro>-range
                    CHANGING  cr_bp = gr_motorista ).

    ENDIF.

    SELECT
      businesspartner,
      bptaxnumber,
      businesspartnername
      FROM zi_tm_get_motorista1
      INTO TABLE @gt_motorista
      WHERE businesspartner IN @gr_motorista.

  ENDMETHOD.


  METHOD get_transportador.

    READ TABLE me->gt_filtro_ranges ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY name = 'TRANSPORTADOR'
                                                                        BINARY SEARCH.

    IF sy-subrc = 0.

      set_bp_range( EXPORTING ir_bp = <fs_filtro>-range
                    CHANGING  cr_bp = gr_transportador ).

    ENDIF.

    SELECT
      businesspartner,
      bptaxnumber,
      businesspartnername
      FROM zi_tm_get_transp
      INTO TABLE @gt_transportador
      WHERE businesspartner IN @gr_transportador.



  ENDMETHOD.


  METHOD modo_efetivo.

    go_log = NEW zclca_save_log( gc_tcode ).
    go_log->create_log( gc_sub ).

    CASE me->check_tipo_carga( ).
      WHEN gc_motorista.
        get_motorista( ).
        envia_motorista( ).
      WHEN gc_transportador.
        get_transportador( ).
        envia_transportador( ).
      WHEN gc_veiculo.
        get_veiculo( ).
        envia_veiculo( ).
    ENDCASE.

    go_log->add_msgs( gt_return ).
    go_log->save( ).

    COMMIT WORK.

  ENDMETHOD.


  METHOD modo_teste.

    CASE me->check_tipo_carga( ).
      WHEN gc_motorista.
        get_motorista( ).
        set_output_motorista( ).
      WHEN gc_transportador.
        get_transportador( ).
        set_output_transp( ).
      WHEN gc_veiculo.
        get_veiculo( ).
        set_output_veiculo( ).
    ENDCASE.

  ENDMETHOD.


  METHOD process.

    IF check_modo_teste( ).
      modo_teste( ).
    ELSE.
      modo_efetivo( ).
    ENDIF.

  ENDMETHOD.


  METHOD set_output_motorista.

    LOOP AT gt_motorista ASSIGNING FIELD-SYMBOL(<fs_motorista>).

      APPEND INITIAL LINE TO gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

      <fs_dados>-id        = <fs_motorista>-bptaxnumber.
      <fs_dados>-motorista = <fs_motorista>-businesspartner.
      <fs_dados>-descricao = <fs_motorista>-businesspartnername.

    ENDLOOP.

  ENDMETHOD.


  METHOD set_output_transp.

    LOOP AT gt_transportador ASSIGNING FIELD-SYMBOL(<fs_transportador>).

      APPEND INITIAL LINE TO gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

      <fs_dados>-id            = <fs_transportador>-bptaxnumber.
      <fs_dados>-transportador = <fs_transportador>-businesspartner.
      <fs_dados>-descricao     = <fs_transportador>-businesspartnername.

    ENDLOOP.

  ENDMETHOD.


  METHOD set_bp_range.

    LOOP AT ir_bp ASSIGNING FIELD-SYMBOL(<fs_bp>).

      APPEND INITIAL LINE TO cr_bp ASSIGNING FIELD-SYMBOL(<fs_bp_out>).

      <fs_bp_out>-sign   = <fs_bp>-sign.
      <fs_bp_out>-option = <fs_bp>-option.
      <fs_bp_out>-low    = |{ <fs_bp>-low ALPHA = IN }|.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_veiculo.

    READ TABLE me->gt_filtro_ranges ASSIGNING FIELD-SYMBOL(<fs_filtro>) WITH KEY name = 'VEICULO'
                                                                        BINARY SEARCH.

    IF sy-subrc = 0.
      gr_veiculo = <fs_filtro>-range.
    ENDIF.

    SELECT equip~equnr, equip~eqart , equip_text~eqktx
      FROM equi AS equip
      INNER JOIN eqkt AS equip_text ON equip~equnr = equip_text~equnr
      AND equip_text~spras = @sy-langu
      INTO TABLE @gt_veiculo
      WHERE equip~equnr IN @gr_veiculo.

  ENDMETHOD.


  METHOD set_output_veiculo.

    LOOP AT gt_veiculo ASSIGNING FIELD-SYMBOL(<fs_veiculo>).

      APPEND INITIAL LINE TO gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).

      <fs_dados>-id            = <fs_veiculo>-equnr.
      <fs_dados>-veiculo       = <fs_veiculo>-equnr.
      <fs_dados>-descricao     = <fs_veiculo>-eqktk.

    ENDLOOP.

  ENDMETHOD.


  METHOD envia_motorista.

    LOOP AT gt_motorista ASSIGNING FIELD-SYMBOL(<fs_motorista>).
      TRY.

          CHECK <fs_motorista>-businesspartnername IS NOT INITIAL.

          DATA(lo_exec) = NEW zclbp_co_si_enviar_business_pa( ).
          lo_exec->si_enviar_business_partner_out( output = VALUE #(
            mt_business_partner-firstname                     = <fs_motorista>-businesspartnername
            mt_business_partner-partnerexternal-results       = VALUE #( ( partnerexternal = TEXT-003 && sy-sysid+2(1) ) )
            mt_business_partner-to_businesspartnertax-results = VALUE #( ( bptaxnumber = <fs_motorista>-bptaxnumber ) )
            mt_business_partner-businesspartnertype = '0011'
          ) ).
          msg_sucesso( CONV #( <fs_motorista>-bptaxnumber ) ).

        CATCH cx_ai_system_fault.
          msg_erro( CONV #( <fs_motorista>-bptaxnumber ) ).
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD envia_transportador.

    LOOP AT gt_transportador ASSIGNING FIELD-SYMBOL(<fs_transportador>).
      TRY.

          CHECK <fs_transportador>-businesspartnername IS NOT INITIAL.

          DATA(lo_exec) = NEW zclbp_co_si_enviar_business_pa( ).
          lo_exec->si_enviar_business_partner_out( output = VALUE #(
            mt_business_partner-businesspartnername           = <fs_transportador>-businesspartnername
            mt_business_partner-partnerexternal-results       = VALUE #( ( partnerexternal = TEXT-004 && sy-sysid+2(1) ) )
            mt_business_partner-to_businesspartnertax-results = VALUE #( ( bptaxnumber = <fs_transportador>-bptaxnumber ) )
            mt_business_partner-to_businesspartnerrole-results = VALUE #( ( businesspartnerrole = 'CRM010' ) )
          ) ).
          msg_sucesso( CONV #( <fs_transportador>-bptaxnumber ) ).

        CATCH cx_ai_system_fault.
          msg_erro( CONV #( <fs_transportador>-bptaxnumber ) ).
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD envia_veiculo.

    DATA: ls_veiculos TYPE zstm_dt_equipamentos_veiculo_v,
          ls_output   TYPE zstm_mt_equipamentos_veiculo,
          lr_veiculo  TYPE RANGE OF equi-eqart.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range(
          EXPORTING
            iv_modulo = 'TM'
            iv_chave1 = 'TRAFEGUS'
            iv_chave2 = 'TIPOVEICULO'
          IMPORTING
            et_range  = lr_veiculo
        ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    SORT lr_veiculo BY low.

    LOOP AT gt_veiculo ASSIGNING FIELD-SYMBOL(<fs_veiculo>).

*      TRY.
*          DATA(lo_param) = NEW zclca_tabela_parametros( ).
*
*          lo_param->m_get_range(
*            EXPORTING
*              iv_modulo = 'TM'
*              iv_chave1 = 'TRAFEGUS'
*              iv_chave2 = 'TIPOVEICULO'
*            IMPORTING
*              et_range  = lr_veiculo
*          ).
*        CATCH zcxca_tabela_parametros.
*      ENDTRY.

      ls_veiculos-platenumber = <fs_veiculo>-equnr.
      READ TABLE lr_veiculo WITH KEY low = <fs_veiculo>-eqart INTO DATA(ls_tipo_veiculo) BINARY SEARCH.
      ls_veiculos-tures_tco = ls_tipo_veiculo-high.

      APPEND ls_veiculos TO ls_output-mt_equipamentos_veiculo-vehicle.
      TRY.
          DATA(lo_exec) = NEW zcltm_co_si_enviar_equipamento( ).
          lo_exec->si_enviar_equipamentos_veiculo( output = ls_output ).

          msg_sucesso( CONV #( <fs_veiculo>-equnr ) ).

        CATCH cx_ai_system_fault.
          msg_erro( CONV #( <fs_veiculo>-equnr ) ).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD msg_erro.

    APPEND INITIAL LINE TO gt_return ASSIGNING FIELD-SYMBOL(<fs_ret>).

    <fs_ret>-type          = 'E'.
    <fs_ret>-id            = 'ZTM_OF_TRAFEGUS'.
    <fs_ret>-number        = '003'.
    <fs_ret>-message_v1    = iv_codigo.

    IF gt_dados IS INITIAL.
      APPEND INITIAL LINE TO gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      <fs_dados>-descricao = TEXT-002.
    ENDIF.

  ENDMETHOD.


  METHOD msg_sucesso.

    APPEND INITIAL LINE TO gt_return ASSIGNING FIELD-SYMBOL(<fs_ret>).

    <fs_ret>-type          = 'S'.
    <fs_ret>-id            = 'ZTM_OF_TRAFEGUS'.
    <fs_ret>-number        = '002'.
    <fs_ret>-message_v1    = iv_codigo.

    IF gt_dados IS INITIAL.
      APPEND INITIAL LINE TO gt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      <fs_dados>-descricao = TEXT-001.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
