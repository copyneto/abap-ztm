CLASS zcltm_cockpit_frota_ce DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
    INTERFACES if_rap_query_filter .

    TYPES: ty_frota   TYPE zi_tm_cockpit_frota,

           ty_t_frota TYPE STANDARD TABLE OF zi_tm_cockpit_frota,

           BEGIN OF ty_parameter,
             r_hodometro     TYPE RANGE OF rihimrg-psort,
             r_combustivel   TYPE RANGE OF rihimrg-psort,
             r_abastecimento TYPE RANGE OF rihimrg-psort,
           END OF ty_parameter.

    DATA: gs_parameter  TYPE ty_parameter.

  PROTECTED SECTION.

private section.

  data GT_FROTA type TY_T_FROTA .

    "! Calcula todos os custos
    "! @parameter it_ranges | Filtros do relatório
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE
    importing
      !IT_RANGES type IF_RAP_QUERY_FILTER=>TT_NAME_RANGE_PAIRS optional
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de combustível
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_FUEL
    importing
      !IT_RANGES type IF_RAP_QUERY_FILTER=>TT_NAME_RANGE_PAIRS optional
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de depreciação
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_DEPRECIATION
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de lavagem
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_WASHING
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de manutenção
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_CORR_MAINTENANCE
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de manutenção
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_PREV_MAINTENANCE
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de pneus
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_TIRES
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de documentação
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_DOCUMENTATION
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula custos relacionado à custos de mão-de-obra
    "! @parameter ct_frota | Relatório de frota
  methods CALCULATE_LABOR
    importing
      !IT_RANGES type IF_RAP_QUERY_FILTER=>TT_NAME_RANGE_PAIRS
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Calcula total dos valores
    "! @parameter ct_frota | Relatório de frota
  methods TOTAL
    changing
      !CT_FROTA type TY_T_FROTA .
    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
  methods GET_PARAMETER
    importing
      !IS_PARAM type ZTCA_PARAM_VAL
    exporting
      !ET_VALUE type ANY .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
  methods GET_CONFIGURATION
    exporting
      !ES_PARAMETER type TY_PARAMETER
      !ET_RETURN type BAPIRET2_T .
ENDCLASS.



CLASS ZCLTM_COCKPIT_FROTA_CE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: lt_result TYPE TABLE OF zi_tm_cockpit_frota.
* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).


    " Ao navegar pra Object Page, devemos setar como um registro .
    lv_top      = COND #( WHEN lv_top <= 0 THEN 1 ELSE lv_top ).
    lv_max_rows = COND #( WHEN lv_max_rows <= 0 THEN 1 ELSE lv_max_rows ).

* ---------------------------------------------------------------------------
* Recupera filtros do relatório
* ---------------------------------------------------------------------------
    TRY.
        DATA(lt_ranges) = io_request->get_filter( )->get_as_ranges( ).
        DATA(lv_filter) = io_request->get_filter( )->get_as_sql_string( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------
    SELECT *
        FROM zi_tm_cockpit_frota
        INTO TABLE @DATA(lt_result_cds).

    IF sy-subrc NE 0.
      FREE lt_result_cds.
    ENDIF.

    IF lv_filter IS NOT INITIAL.
      lt_result = VALUE #(
        FOR lw_result IN lt_result_cds
          WHERE (lv_filter)
          ( lw_result )  ).
    ELSE.
      lt_result[] = lt_result_cds[].
    ENDIF.

    gt_frota[] = lt_result[].

    SORT lt_result BY freightorder product.
    DELETE ADJACENT DUPLICATES FROM lt_result COMPARING freightorder product.

* --------------------------------------------------------------------
* Calcula despesas
* --------------------------------------------------------------------
    me->calculate( EXPORTING it_ranges = lt_ranges
                   CHANGING  ct_frota  = lt_result ).

    me->total( CHANGING ct_frota = lt_result ).

* ---------------------------------------------------------------------------
* Realiza ordenação de acordo com parâmetros de entrada
* ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).

    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.

* ---------------------------------------------------------------------------
* Realiza as agregações de acordo com as annotatios na custom entity
* ---------------------------------------------------------------------------
    DATA(lt_req_elements) = io_request->get_requested_elements( ).
    DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).

    SORT lt_req_elements BY table_line.

    LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).
      DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element.
      DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
      APPEND lv_aggregation TO lt_req_elements.
    ENDLOOP.

    DATA(lv_req_elements)    = concat_lines_of( table = lt_req_elements sep = ',' ).
    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping)        = concat_lines_of(  table = lt_grouped_element sep = ',' ).

    TRY.
        SELECT (lv_req_elements) FROM @lt_result AS dados
                                 GROUP BY (lv_grouping)
                                 INTO CORRESPONDING FIELDS OF TABLE @lt_result.
      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = lo_root->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result_aux IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result_aux ) ).

* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    ENDIF.

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_result_page[] ).
    ENDIF.

  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD calculate.

    me->calculate_fuel( EXPORTING it_ranges = it_ranges
                        CHANGING  ct_frota  = ct_frota ).

    me->calculate_depreciation( CHANGING ct_frota = ct_frota ).

    me->calculate_washing( CHANGING ct_frota = ct_frota ).

    me->calculate_corr_maintenance( CHANGING ct_frota = ct_frota ).

    me->calculate_prev_maintenance( CHANGING ct_frota = ct_frota ).

    me->calculate_tires( CHANGING ct_frota = ct_frota ).

    me->calculate_documentation( CHANGING ct_frota = ct_frota ).

    me->calculate_labor( EXPORTING it_ranges = it_ranges
                         CHANGING ct_frota = ct_frota ).

  ENDMETHOD.


  METHOD calculate_depreciation.

    DATA: lt_measure TYPE ty_t_measure_depreciation,
          ls_measure TYPE ty_measure_depreciation,
          lv_diff    TYPE zi_tm_cockpit_frota-OriginalDepreciationCost.

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY  Equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING Equipment.

* --------------------------------------------------------------------
* Recupera despesas relacionado à custos de pneus
* --------------------------------------------------------------------
    IF lt_frota IS NOT INITIAL.

      SELECT *
          FROM zi_tm_despesa_frota_deprecia
          FOR ALL ENTRIES IN @lt_frota
          WHERE Equipment = @lt_frota-Equipment
          INTO TABLE @DATA(lt_depreciacao).

      IF sy-subrc EQ 0.
        SORT lt_depreciacao BY Equipment.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).
      CLEAR ls_measure.
      ls_measure-FreightOrder    = ls_r_frota->FreightOrder.
      ls_measure-Equipment       = ls_r_frota->Equipment.
      ls_measure-InventoryNumber = ls_r_frota->InventoryNumber.
      ls_measure-stops           = 1.
      ls_measure-currentstop     = 0.
      ls_measure-currentvalue    = 0.

      READ TABLE lt_depreciacao REFERENCE INTO DATA(ls_r_depreciacao) WITH KEY Equipment = ls_r_frota->Equipment
                                                                               BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_measure-value = ls_r_depreciacao->DepreciationCost.
        DELETE lt_depreciacao INDEX sy-tabix.           "#EC CI_SEL_DEL
      ENDIF.

      COLLECT ls_measure INTO lt_measure.

    ENDLOOP.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH TABLE KEY FreightOrder    = ls_r_frota->FreightOrder
                                                                             Equipment       = ls_r_frota->Equipment
                                                                             InventoryNumber = ls_r_frota->InventoryNumber.
      CHECK sy-subrc EQ 0.

      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        CONTINUE.
      ENDIF.

      ls_r_frota->OriginalDepreciationCost = abs( ls_r_measure->value ).
      ls_r_frota->MeasureDepreciationCost  = abs( ls_r_measure->value ) / ls_r_measure->stops.

      ls_r_measure->currentstop     = ls_r_measure->currentstop + 1.
      ls_r_measure->currentvalue    = ls_r_measure->currentvalue + ls_r_frota->MeasureDepreciationCost.

      " Tratamento para corrigir a diferença de centavos e jogar no último registro
      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        lv_diff = ls_r_frota->OriginalDepreciationCost - ls_r_measure->currentvalue.
        ls_r_frota->MeasureDepreciationCost = ls_r_frota->MeasureDepreciationCost + lv_diff.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD calculate_documentation.

    DATA: lt_measure TYPE ty_t_measure_documentation,
          ls_measure TYPE ty_measure_documentation,
          lv_diff    TYPE zi_tm_cockpit_frota-originaldocumentationcost.

    TYPES: BEGIN OF ty_sorders,
             freightorder  TYPE zi_tm_cockpit_frota-freightorder,
             salesdocument TYPE zi_tm_cockpit_frota-salesdocument,
             counter       TYPE i,
           END OF ty_sorders.

    DATA: lt_sorders   TYPE TABLE OF ty_sorders,
          ls_sorders   TYPE ty_sorders.

    DATA(lt_frota_sorder) = ct_frota[].

    DELETE ADJACENT DUPLICATES FROM lt_frota_sorder COMPARING salesdocument.

    LOOP AT lt_frota_sorder REFERENCE INTO DATA(ls_r_frota_aux).
      ls_sorders-freightorder    = ls_r_frota_aux->freightorder.
      ls_sorders-salesdocument   = ls_r_frota_aux->salesdocument.
      ls_sorders-counter         = 1.
      COLLECT ls_sorders INTO lt_sorders.
    ENDLOOP.


    LOOP AT ct_frota REFERENCE INTO ls_r_frota_aux.

      READ TABLE lt_sorders INTO ls_sorders WITH KEY freightorder     = ls_r_frota_aux->freightorder
                                                     salesdocument    = ls_r_frota_aux->salesdocument.

      IF sy-subrc = 0.
        ls_r_frota_aux->totalsalesdocument  = ls_sorders-counter.
        ls_r_frota_aux->totalcustomers = ls_sorders-counter.
      ENDIF.

    ENDLOOP.

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING equipment.

* --------------------------------------------------------------------
* Recupera despesas relacionado à custos de pneus
* --------------------------------------------------------------------
    IF lt_frota IS NOT INITIAL.

      SELECT *
          FROM zi_tm_despesa_frota_document
          FOR ALL ENTRIES IN @lt_frota
          WHERE equipment   = @lt_frota-equipment
          INTO TABLE @DATA(lt_documentacao).

      IF sy-subrc EQ 0.
        SORT lt_documentacao BY equipment.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).
      CLEAR ls_measure.
      ls_measure-freightorder    = ls_r_frota->freightorder.
      ls_measure-equipment       = ls_r_frota->equipment.
      ls_measure-stops           = 1.
      ls_measure-currentstop     = 0.
      ls_measure-currentvalue    = 0.

      READ TABLE lt_documentacao REFERENCE INTO DATA(ls_r_documentacao) WITH KEY equipment   = ls_r_frota->equipment
                                                                                 BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_measure-value = ls_r_documentacao->documentationcost.
        DELETE lt_documentacao INDEX sy-tabix.          "#EC CI_SEL_DEL
      ENDIF.

      COLLECT ls_measure INTO lt_measure.

    ENDLOOP.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH TABLE KEY freightorder = ls_r_frota->freightorder
                                                                             equipment    = ls_r_frota->equipment.
      CHECK sy-subrc EQ 0.

      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        CONTINUE.
      ENDIF.

      ls_r_frota->originaldocumentationcost = ls_r_measure->value.
      ls_r_frota->measuredocumentationcost  = ls_r_measure->value / ls_r_measure->stops.

      ls_r_measure->currentstop     = ls_r_measure->currentstop + 1.
      ls_r_measure->currentvalue    = ls_r_measure->currentvalue + ls_r_frota->measuredocumentationcost.

      " Tratamento para corrigir a diferença de centavos e jogar no último registro
      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        lv_diff = ls_r_frota->originaldocumentationcost - ls_r_measure->currentvalue.
        ls_r_frota->measuredocumentationcost = ls_r_frota->measuredocumentationcost + lv_diff.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD calculate_fuel.

    TYPES: BEGIN OF ty_stops,
             freightorder TYPE zi_tm_gestao_frota_stop-freightorder,
             distancekm   TYPE zi_tm_gestao_frota_stop-distancekm,
             div_by       TYPE i,
           END OF ty_stops.

    TYPES: BEGIN OF ty_of_lines,
             freightorder TYPE zi_tm_gestao_frota_stop-freightorder,
             div_by       TYPE i,
           END OF ty_of_lines.

    DATA: lt_documents     TYPE STANDARD TABLE OF rihimrg,
          lt_documents_all TYPE STANDARD TABLE OF rihimrg,
          lt_measure       TYPE ty_t_measure_fuel,
          ls_measure       TYPE ty_measure_fuel,
          lv_equipment     TYPE equi-equnr,
          lv_diff_volume   TYPE zi_tm_cockpit_frota-originalfuelvolume,
          lv_diff_value    TYPE zi_tm_cockpit_frota-originalfuelvalue,
          lv_diff_distance TYPE zi_tm_cockpit_frota-originalfueldistancekm,
          lt_stops         TYPE TABLE OF ty_stops,
          lt_stops_sel     TYPE TABLE OF ty_stops,
          lt_of_lines      TYPE TABLE OF ty_of_lines,
          ls_of_lines      TYPE ty_of_lines,
          lv_total         TYPE zi_tm_cockpit_frota-distancekm.

* --------------------------------------------------------------------
* Recupera parâmetros
* --------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING equipment.
    DELETE lt_frota WHERE equipment IS INITIAL.


    LOOP AT ct_frota REFERENCE INTO DATA(ls_frota_count).
      ls_of_lines-freightorder = ls_frota_count->freightorder.
      ls_of_lines-div_by = 1.
      COLLECT ls_of_lines INTO lt_of_lines.
    ENDLOOP.

* --------------------------------------------------------------------
* Recupera filtro de data
* --------------------------------------------------------------------
    TRY.
        DATA(lr_firstperiod) = it_ranges[ name = 'FIRSTPERIOD' ]-range. "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.


    SELECT freightorder, distancekm
      FROM zi_tm_gestao_frota_stop
      INTO TABLE @lt_stops_sel
      FOR ALL ENTRIES IN @ct_frota
      WHERE freightorder = @ct_frota-freightorder.

    LOOP AT lt_stops_sel INTO DATA(ls_stops_sel).
      ls_stops_sel-div_by = 1.
      COLLECT ls_stops_sel INTO lt_stops.
      lv_total = lv_total + ls_stops_sel-distancekm.
    ENDLOOP.

    DATA(lv_stops_of) = lines( lt_stops ).

* --------------------------------------------------------------------
* Recupera despesas relacionado à combustível
* --------------------------------------------------------------------
    LOOP AT lt_frota REFERENCE INTO DATA(ls_frota).

      lv_equipment = ls_frota->equipment.

      FREE: lt_documents.
      CALL FUNCTION 'GET_MEASURING_DOCUMENTS'
        EXPORTING
          equipment  = lv_equipment
        TABLES
          et_rihimrg = lt_documents.

      INSERT LINES OF lt_documents INTO TABLE lt_documents_all[].
    ENDLOOP.

    " Ordena os dados pelo documento mais recente
    SORT lt_documents_all BY equnr ASCENDING
                             psort ASCENDING
                             idate ASCENDING
                             mdocm DESCENDING.


* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).

      CLEAR ls_measure.
      ls_measure-freightorder       = ls_r_frota->freightorder.
      ls_measure-equipment          = ls_r_frota->equipment.
      ls_measure-stops              = 1.
      ls_measure-currentstop        = 0.
      ls_measure-currentvolume      = 0.
      ls_measure-currentvalue       = 0.
      ls_measure-currentdistancekm  = 0.

      " Lógica para atribuir o valor do documento para apenas uma ordem de frete
      READ TABLE lt_documents_all TRANSPORTING NO FIELDS WITH KEY equnr = ls_r_frota->equipment BINARY SEARCH.

      IF sy-subrc EQ 0.

        LOOP AT lt_documents_all REFERENCE INTO DATA(ls_r_documents) FROM sy-tabix WHERE equnr = ls_r_frota->equipment.

          DATA(lv_index) = sy-tabix.

          TRANSLATE ls_r_documents->cdifc USING ',.'. CONDENSE ls_r_documents->cdifc.
          TRANSLATE ls_r_documents->recdc USING ',.'. CONDENSE ls_r_documents->recdc.

          " Recupera volume do combustível
          IF  ls_r_documents->equnr      EQ ls_r_frota->equipment
          AND ls_r_documents->psort      IN ls_parameter-r_combustivel AND ls_parameter-r_combustivel IS NOT INITIAL
          AND ls_r_documents->idate+0(6) EQ ls_r_frota->firstperiod+0(6)
          AND ls_r_documents->idate      IN lr_firstperiod[]
          AND ls_r_frota->firstperiod    IN lr_firstperiod[].

            ls_measure-volume     = ls_measure-volume +
                                    COND #( WHEN ls_r_documents->cdifc IS NOT INITIAL
                                            THEN ls_r_documents->cdifc
                                            ELSE ls_r_documents->recdc ).

            "DELETE lt_documents_all WHERE mdocm = ls_r_documents->mdocm.
            CONTINUE.
          ENDIF.

          " Recupera valor do combustível
          IF  ls_r_documents->equnr      EQ ls_r_frota->equipment
          AND ls_r_documents->psort      IN ls_parameter-r_abastecimento AND ls_parameter-r_abastecimento IS NOT INITIAL
          AND ls_r_documents->idate+0(6) EQ ls_r_frota->firstperiod+0(6)
          AND ls_r_documents->idate      IN lr_firstperiod[]
          AND ls_r_frota->firstperiod    IN lr_firstperiod[].

            ls_measure-value      = ls_measure-value +
                                    COND #( WHEN ls_r_documents->cdifc IS NOT INITIAL
                                            THEN ls_r_documents->cdifc
                                            ELSE ls_r_documents->recdc ).

            "DELETE lt_documents_all WHERE mdocm = ls_r_documents->mdocm.
            CONTINUE.
          ENDIF.

*          " Recupera distância percorrida
          IF  ls_r_documents->equnr      EQ ls_r_frota->equipment
          AND ls_r_documents->psort      IN ls_parameter-r_hodometro AND ls_parameter-r_hodometro IS NOT INITIAL
          AND ls_r_documents->idate+0(6) EQ ls_r_frota->firstperiod+0(6)
          AND ls_r_documents->idate      IN lr_firstperiod[]
          AND ls_r_frota->firstperiod    IN lr_firstperiod[].

            ls_measure-distancekm = ls_measure-distancekm +
                                    COND #( WHEN ls_r_documents->cdifc <> ls_r_documents->recdc
                                            THEN ls_r_documents->cdifc
                                            ELSE 0 ).

            "DELETE lt_documents_all WHERE mdocm = ls_r_documents->mdocm.
            CONTINUE.
          ENDIF.

        ENDLOOP.

      ENDIF.

      COLLECT ls_measure INTO lt_measure.

    ENDLOOP.

    IF lt_measure IS INITIAL.
      RETURN.
    ENDIF.

    DELETE lt_measure WHERE volume IS INITIAL AND value IS INITIAL AND distancekm IS INITIAL.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH KEY freightorder = ls_r_frota->freightorder
                                                                       equipment    = ls_r_frota->equipment.
      IF sy-subrc EQ 0.

        IF ls_r_measure->currentstop >= ls_r_measure->stops.
          CONTINUE.
        ENDIF.

        TRY.
            "Atualiza distância percorrida

            LOOP AT lt_stops INTO DATA(ls_stops) WHERE freightorder = ls_r_measure->freightorder.
              IF ls_stops-distancekm > 0.
                DATA(lv_distancekm) =  ls_stops-distancekm.
                EXIT.
              ENDIF.
            ENDLOOP.

            ls_r_frota->distancekm             = lv_distancekm / ls_r_measure->stops.
            ls_r_frota->originalfueldistancekm = ( ( ( ( lv_distancekm  * ls_r_measure->distancekm ) / ls_r_measure->distancekm ) / lv_total ) / 100 ) * 100.  "ls_r_measure->distancekm.
            ls_r_frota->measurefueldistancekm  = ( lv_distancekm * ls_r_measure->distancekm ) / ls_r_measure->stops." "ls_r_measure->distancekm / ls_r_measure->stops.
          CATCH cx_root.
        ENDTRY.

        DATA(lv_rate_percent) = ( ( ( lv_distancekm  * ls_r_measure->distancekm ) / ls_r_measure->distancekm ) / lv_total ) * 100.

        TRY.
            " Atualiza volume do combustível
            ls_r_frota->originalfuelvolume = ( ( ( lv_rate_percent * ls_r_measure->volume ) / 100 ) / ls_r_measure->stops ).
            ls_r_frota->measurefuelvolume  = ( ls_r_measure->volume / ls_r_measure->stops ) / lv_stops_of.
          CATCH cx_root.
        ENDTRY.

        TRY.
            " Atualiza valor do combustível
            ls_r_frota->originalfuelvalue  = ( ( ( lv_rate_percent * ls_r_measure->value ) / 100 ) / ls_r_measure->stops ).
            ls_r_frota->measurefuelvalue   = ( ls_r_measure->value / ls_r_measure->stops ).
          CATCH cx_root.
        ENDTRY.

        ls_r_measure->currentstop         = ls_r_measure->currentstop + 1.
        ls_r_measure->currentvolume       = ls_r_measure->currentvolume + ls_r_frota->measurefuelvolume.
        ls_r_measure->currentvalue        = ls_r_measure->currentvalue + ls_r_frota->measurefuelvalue.
        ls_r_measure->currentdistancekm   = ls_r_measure->currentdistancekm + ls_r_frota->measurefueldistancekm.

*      " Tratamento para corrigir a diferença de centavos e jogar no último registro
        IF ls_r_measure->currentstop >= ls_r_measure->stops.
          lv_diff_volume   = ls_r_frota->originalfuelvolume - ls_r_measure->currentvolume.
          ls_r_frota->measurefuelvolume = ls_r_frota->measurefuelvolume + lv_diff_volume.

          lv_diff_value    = ls_r_frota->originalfuelvalue - ls_r_measure->currentvalue.
          ls_r_frota->measurefuelvalue = ls_r_frota->measurefuelvalue + lv_diff_value.

          lv_diff_distance = ls_r_frota->originalfueldistancekm - ls_r_measure->currentdistancekm.
          ls_r_frota->measurefueldistancekm = ls_r_frota->measurefueldistancekm + lv_diff_distance.
        ENDIF.

      ELSE.
        LOOP AT lt_stops INTO ls_stops WHERE freightorder = ls_r_frota->freightorder.
          IF ls_stops-distancekm > 0.
            lv_distancekm =  ls_stops-distancekm.
            EXIT.
          ENDIF.
        ENDLOOP.

        READ TABLE lt_of_lines INTO ls_of_lines WITH KEY freightorder = ls_r_frota->freightorder.
        IF sy-subrc = 0.
          ls_r_frota->distancekm  = lv_distancekm / ls_of_lines-div_by.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD calculate_labor.

* Types
    TYPES : BEGIN OF ty_calc_total,
              plant        TYPE bukrs,
              equipment    TYPE /scmtms/resplatenr,
              rcntr        TYPE acdoca-rcntr,
              freightorder TYPE /scmtms/tor_id,
              total        TYPE i,
              div_by       TYPE i,
              div_tot      TYPE zi_tm_cockpit_frota-measurelaborcost,
            END OF ty_calc_total.
    TYPES : BEGIN OF ty_obra_p,
              rcntr TYPE acdoca-rcntr.
              INCLUDE TYPE zi_tm_despesa_frota_mao_obra_p.
  TYPES END OF ty_obra_p.


* Tabelas internas
    DATA: lt_measure         TYPE ty_t_measure_fuel,
          lt_truck           TYPE STANDARD TABLE OF zi_tm_despesa_frota_mao_obra2t,
          lt_frota_calc      TYPE STANDARD TABLE OF ty_calc_total,
          lt_frota_placa     TYPE STANDARD TABLE OF ty_calc_total,
          lt_frota_placa_aux TYPE STANDARD TABLE OF ty_calc_total,
          ls_frota_placa_aux TYPE ty_calc_total,
          lv_calc            TYPE p05_dec12_5,
          lv_total           TYPE char255,
          lt_obra_p          TYPE STANDARD TABLE OF ty_obra_p,
          ir_placa           TYPE RANGE OF equnr,
          ir_placa_valida    TYPE RANGE OF equnr,
          ir_empresa_valida  TYPE RANGE OF bukrs,
          is_empresa_valida  LIKE LINE OF ir_empresa_valida,
          lw_placa_valida_r  LIKE LINE OF ir_placa_valida,
          ls_placa           LIKE LINE OF ir_placa.

* Work areas
    DATA : " ls_measure    TYPE ty_measure_fuel,
      ls_obra_p      TYPE ty_obra_p,
      ls_frota_calc  TYPE ty_calc_total,
      ls_frota_placa TYPE ty_calc_total,
      lv_cont        TYPE i,
      ls_truck       TYPE zi_tm_despesa_frota_mao_obra2t.

* Variaveis
    DATA : lv_equipment     TYPE equi-equnr,
           lv_diff_volume   TYPE zi_tm_cockpit_frota-originalfuelvolume,
           lv_diff_value    TYPE zi_tm_cockpit_frota-originalfuelvalue,
           lv_diff_distance TYPE zi_tm_cockpit_frota-originalfueldistancekm.

* --------------------------------------------------------------------
* Recupera parâmetros
* --------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

** --------------------------------------------------------------------
* Recupera filtro de data
* --------------------------------------------------------------------
    TRY.
        DATA(lr_firstperiod) = it_ranges[ name = 'FIRSTPERIOD' ]-range. "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.

    SORT ct_frota BY equipment.

    SELECT * FROM zi_despesa_frt_mao_obra_aux
    INTO TABLE @DATA(lt_parameter)
    WHERE modulo = 'TM'
    AND   chave1 = 'FRT_MAO_DE_OBRA'.

    IF sy-subrc = 0.
      DATA(lt_select) = VALUE finst_acdoca(
      FOR ls_param IN lt_parameter
      ( racct     = ls_param-low
        rcntr     = ls_param-chave2 )
      ).

      SELECT werks , rbukrs , hsl, belnr, gjahr, docln, rcntr
        FROM acdoca
        FOR ALL ENTRIES IN @lt_select
        WHERE racct   = @lt_select-racct
        AND rcntr     = @lt_select-rcntr
        AND ktopl     = 'PC3C'
        AND kokrs     = 'AC3C'
        AND xreversed = @space
        INTO TABLE @DATA(lt_obra_aux).
    ENDIF.

    IF sy-subrc = 0.
      LOOP AT lt_obra_aux ASSIGNING FIELD-SYMBOL(<fs_obra>).
        ls_obra_p-plant       = <fs_obra>-werks.
        ls_obra_p-companycode = <fs_obra>-rbukrs.
        ls_obra_p-laborcost   = <fs_obra>-hsl.
        ls_obra_p-rcntr       = <fs_obra>-rcntr.
        COLLECT ls_obra_p INTO lt_obra_p.
      ENDLOOP.

      SORT lt_obra_p BY plant. "periodo.
    ENDIF.

    IF ct_frota IS NOT INITIAL.
      LOOP AT ct_frota INTO DATA(ls_frota_ranges).
        ls_placa-sign   = 'I'.
        ls_placa-option = 'EQ'.
        ls_placa-low    = ls_frota_ranges-equipment.
        IF ls_placa-low IS NOT INITIAL.
          APPEND ls_placa TO ir_placa.
        ENDIF.
        CLEAR ls_placa.
      ENDLOOP.

      SORT ir_placa BY low ASCENDING.
      DELETE ADJACENT DUPLICATES FROM ir_placa COMPARING low.

      IF lt_obra_p IS NOT INITIAL.
        SELECT DISTINCT bukrs, equnr, kostl
          FROM itob
          FOR ALL ENTRIES IN @lt_obra_p
          WHERE equnr IN @ir_placa
          AND   kostl = @lt_obra_p-rcntr
          AND   datbi >= @sy-datum
          INTO TABLE @DATA(lt_placa_valida).
      ENDIF.
    ENDIF.

    LOOP AT lt_placa_valida INTO DATA(lw_placa_valida).
      lw_placa_valida_r-sign   = 'I'.
      lw_placa_valida_r-option = 'EQ'.
      lw_placa_valida_r-low    = lw_placa_valida-equnr.
      IF lw_placa_valida_r-low IS NOT INITIAL.
        APPEND lw_placa_valida_r TO ir_placa_valida.
      ENDIF.
      CLEAR ls_placa.
    ENDLOOP.

    DATA(ct_frota_aux) = ct_frota.

    IF ir_placa_valida IS NOT INITIAL.
      DELETE ct_frota_aux WHERE equipment NOT IN ir_placa_valida.
    ENDIF.

    SELECT
      equipplant,
      plant,
      company AS companycode,
      platenumber,
      SUM( 1 ) AS qtd
    FROM zi_tm_gestao_frota_truck
    WHERE
      firstperiod IN @lr_firstperiod
      AND plant       IS NOT INITIAL
      AND company     IS NOT INITIAL
      AND firstperiod IS NOT INITIAL
    GROUP BY
      equipplant,
      platenumber,
      company,
      plant
    INTO TABLE @DATA(lt_obrat).
    SORT lt_obrat BY equipplant  platenumber.

* Total de linhas por ordens de frete
    DESCRIBE TABLE ct_frota_aux LINES DATA(lv_total_frota).
    SORT ct_frota_aux BY freightorder equipment ASCENDING.

    LOOP AT ct_frota_aux ASSIGNING FIELD-SYMBOL(<fs_frota>).
      DATA(lv_tabix) = sy-tabix.
      READ TABLE lt_placa_valida INTO DATA(ls_placa_valida) WITH KEY equnr = <fs_frota>-equipment
                                                                     bukrs = <fs_frota>-company.
      IF sy-subrc = 0.
        IF lv_tabix = 1.
          ls_frota_calc-rcntr        = ls_placa_valida-kostl.
          ls_frota_calc-equipment    = <fs_frota>-equipment.
          ADD 1 TO ls_frota_calc-total.

          CONTINUE.
        ENDIF.

        IF lv_tabix = lv_total_frota.

          IF <fs_frota>-equipment EQ ls_frota_calc-equipment.
            ADD 1 TO ls_frota_calc-total.
            COLLECT ls_frota_calc INTO lt_frota_calc.
            CLEAR ls_frota_calc.

            CONTINUE.
          ELSE.
            COLLECT ls_frota_calc INTO lt_frota_calc.
            CLEAR ls_frota_calc.
            ls_frota_calc-rcntr        = ls_placa_valida-kostl.
            ls_frota_calc-equipment    = <fs_frota>-equipment.
            ADD 1 TO ls_frota_calc-total.

            COLLECT ls_frota_calc INTO lt_frota_calc.
          ENDIF.
        ENDIF.

        IF <fs_frota>-equipment EQ ls_frota_calc-equipment.
          ADD 1 TO ls_frota_calc-total.
        ELSE.
          COLLECT ls_frota_calc INTO lt_frota_calc.
          CLEAR ls_frota_calc.
          ls_frota_calc-rcntr        = ls_placa_valida-kostl.
          ls_frota_calc-equipment    = <fs_frota>-equipment.
          ADD 1 TO ls_frota_calc-total.

          CONTINUE.
        ENDIF.
      ENDIF.
      CLEAR ls_placa_valida.
    ENDLOOP.
    CLEAR lv_tabix.

* Total de linhas por placa
    LOOP AT ct_frota_aux ASSIGNING <fs_frota>.
      lv_tabix = sy-tabix.
      READ TABLE lt_placa_valida INTO ls_placa_valida WITH KEY  equnr = <fs_frota>-equipment
                                                                bukrs = <fs_frota>-company.
      if sy-subrc = 0.
      IF lv_tabix = 1.
        ls_frota_placa-plant        = <fs_frota>-plant.
        ls_frota_placa-equipment    = <fs_frota>-equipment.
        ls_frota_placa-rcntr        = ls_placa_valida-kostl.
        ADD 1 TO ls_frota_placa-total.

        CONTINUE.
      ENDIF.

      IF lv_tabix = lv_total_frota.
        IF <fs_frota>-equipment EQ ls_frota_placa-equipment.
          ADD 1 TO ls_frota_placa-total.

          COLLECT ls_frota_placa INTO lt_frota_placa.
          CLEAR ls_frota_placa.

          CONTINUE.
        ELSE.
          COLLECT ls_frota_placa INTO lt_frota_calc.
          CLEAR ls_frota_placa.
          ls_frota_placa-rcntr        = ls_placa_valida-kostl.
          ls_frota_placa-plant        = <fs_frota>-plant.
          ls_frota_placa-equipment    = <fs_frota>-equipment.
          ADD 1 TO ls_frota_placa-total.

          COLLECT ls_frota_placa INTO lt_frota_placa.
        ENDIF.
      ENDIF.

      IF <fs_frota>-equipment EQ ls_frota_placa-equipment.
        ADD 1 TO ls_frota_placa-total.
      ELSE.
        COLLECT ls_frota_placa INTO lt_frota_placa.
        CLEAR ls_frota_placa.
        ls_frota_placa-rcntr        = ls_placa_valida-kostl.
        ls_frota_placa-plant        = <fs_frota>-plant.
        ls_frota_placa-equipment    = <fs_frota>-equipment.
        ADD 1 TO ls_frota_placa-total.

        CONTINUE.
      ENDIF.

    ENDIF.
    CLEAR ls_placa_valida.
  ENDLOOP.

  SORT lt_frota_placa BY plant ASCENDING.
  LOOP AT lt_frota_placa ASSIGNING FIELD-SYMBOL(<fs_frota_placa>).
    ls_frota_placa_aux-plant   = <fs_frota_placa>-plant.
    ls_frota_placa_aux-rcntr   = <fs_frota_placa>-rcntr.
    ls_frota_placa_aux-div_by  = 1.
    COLLECT ls_frota_placa_aux INTO lt_frota_placa_aux.
  ENDLOOP.

  LOOP AT lt_frota_placa ASSIGNING <fs_frota_placa>.
    READ TABLE lt_frota_placa_aux INTO ls_frota_placa_aux WITH KEY plant   = <fs_frota_placa>-plant
                                                                   rcntr   = <fs_frota_placa>-rcntr.
    IF sy-subrc = 0.
      <fs_frota_placa>-div_tot = <fs_frota_placa>-total / ls_frota_placa_aux-div_by.
      <fs_frota_placa>-div_by  = ls_frota_placa_aux-div_by.
    ENDIF.
  ENDLOOP.

  LOOP AT ct_frota_aux REFERENCE INTO DATA(ls_r_frota).
    READ TABLE lt_frota_calc INTO ls_frota_calc WITH KEY equipment = ls_r_frota->equipment .

    IF sy-subrc NE 0.
      CONTINUE.
    ELSE.
      READ TABLE lt_obrat ASSIGNING FIELD-SYMBOL(<fs_obrat>) WITH KEY platenumber = ls_r_frota->equipment
                                                                       plant      = ls_r_frota->plant.

      IF sy-subrc IS INITIAL.
        READ TABLE lt_obra_p ASSIGNING FIELD-SYMBOL(<fs_param>) WITH KEY companycode = <fs_obrat>-companycode.

        IF sy-subrc = 0.
          IF <fs_param>-laborcost NE 0 .
            READ TABLE lt_frota_placa INTO ls_frota_placa WITH KEY equipment = ls_r_frota->equipment.

            IF sy-subrc = 0.
              ls_r_frota->measurelaborcost = ( ( <fs_param>-laborcost / ls_frota_placa-div_by ) / ls_frota_placa-total ).
            ENDIF.
          ENDIF.
          ls_r_frota->originallaborcost = <fs_param>-laborcost.
          UNASSIGN: <fs_obrat>, <fs_param>.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.


  LOOP AT ct_frota ASSIGNING FIELD-SYMBOL(<fs_frota_upd>).
    READ TABLE ct_frota_aux INTO DATA(ls_frota_aux) WITH KEY freightorder        = <fs_frota_upd>-freightorder
                                                             freightunit         = <fs_frota_upd>-freightunit
                                                             salesdocument       = <fs_frota_upd>-salesdocument
                                                             outbounddelivery    = <fs_frota_upd>-outbounddelivery
                                                             billingdocument     = <fs_frota_upd>-billingdocument
                                                             br_notafiscal       = <fs_frota_upd>-br_notafiscal
                                                             vehicleid           = <fs_frota_upd>-vehicleid
                                                             productid           = <fs_frota_upd>-productid
                                                             driver              = <fs_frota_upd>-driver.
    IF sy-subrc = 0.
      <fs_frota_upd>-measurelaborcost  = ls_frota_aux-measurelaborcost.
      <fs_frota_upd>-originallaborcost = ls_frota_aux-originallaborcost.
    ENDIF.
  ENDLOOP.

  RETURN.

ENDMETHOD.


  METHOD calculate_corr_maintenance.

    DATA: lt_measure TYPE ty_t_measure_corrective_maint,
          ls_measure TYPE ty_measure_corrective_maint,
          lv_diff    TYPE zi_tm_cockpit_frota-OriginalCorrectiveMaintCost.

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY Equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING Equipment.

* --------------------------------------------------------------------
* Recupera despesas relacionado à custos de pneus
* --------------------------------------------------------------------
    IF lt_frota IS NOT INITIAL.

      SELECT *
          FROM zi_tm_despesa_frota_man_corr
          FOR ALL ENTRIES IN @lt_frota
          WHERE Equipment           EQ @lt_frota-Equipment
            AND CorrectiveMaintCost NE 0
          INTO TABLE @DATA(lt_manutencao).

      IF sy-subrc EQ 0.
        SORT lt_manutencao BY Equipment.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).

      CLEAR ls_measure.
      ls_measure-FreightOrder = ls_r_frota->FreightOrder.
      ls_measure-Equipment    = ls_r_frota->Equipment.
      ls_measure-stops        = 1.
      ls_measure-currentstop  = 0.
      ls_measure-currentvalue = 0.

      READ TABLE lt_manutencao REFERENCE INTO DATA(ls_r_manutencao) WITH KEY Equipment = ls_r_frota->Equipment
                                                                   BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_measure-value = ls_r_manutencao->CorrectiveMaintCost.
        DELETE lt_manutencao INDEX sy-tabix.            "#EC CI_SEL_DEL
      ENDIF.

      COLLECT ls_measure INTO lt_measure.

    ENDLOOP.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH TABLE KEY FreightOrder = ls_r_frota->FreightOrder
                                                                             Equipment    = ls_r_frota->Equipment.
      CHECK sy-subrc EQ 0.

      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        CONTINUE.
      ENDIF.

      ls_r_frota->OriginalCorrectiveMaintCost = ls_r_measure->value.
      ls_r_frota->MeasureCorrectiveMaintCost  = ls_r_measure->value / ls_r_measure->stops.

      ls_r_measure->currentstop     = ls_r_measure->currentstop + 1.
      ls_r_measure->currentvalue    = ls_r_measure->currentvalue + ls_r_frota->MeasureCorrectiveMaintCost.

      " Tratamento para corrigir a diferença de centavos e jogar no último registro
      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        lv_diff = ls_r_frota->OriginalCorrectiveMaintCost - ls_r_measure->currentvalue.
        ls_r_frota->MeasureCorrectiveMaintCost = ls_r_frota->MeasureCorrectiveMaintCost + lv_diff.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD calculate_prev_maintenance.

    DATA: lt_measure TYPE ty_t_measure_preventive_maint,
          ls_measure TYPE ty_measure_preventive_maint,
          lv_diff    TYPE zi_tm_cockpit_frota-OriginalPreventiveMaintCost.

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY Equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING Equipment.

* --------------------------------------------------------------------
* Recupera despesas relacionado à custos de pneus
* --------------------------------------------------------------------
    IF lt_frota IS NOT INITIAL.

      SELECT *
          FROM zi_tm_despesa_frota_man_prev
          FOR ALL ENTRIES IN @lt_frota
          WHERE Equipment           EQ @lt_frota-Equipment
            AND PreventiveMaintCost NE 0
          INTO TABLE @DATA(lt_manutencao).

      IF sy-subrc EQ 0.
        SORT lt_manutencao BY Equipment.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).

      CLEAR ls_measure.
      ls_measure-FreightOrder = ls_r_frota->FreightOrder.
      ls_measure-Equipment    = ls_r_frota->Equipment.
      ls_measure-stops        = 1.
      ls_measure-currentstop  = 0.
      ls_measure-currentvalue = 0.

      READ TABLE lt_manutencao REFERENCE INTO DATA(ls_r_manutencao) WITH KEY Equipment = ls_r_frota->Equipment
                                                                    BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_measure-value = ls_r_manutencao->PreventiveMaintCost.
        DELETE lt_manutencao INDEX sy-tabix.            "#EC CI_SEL_DEL
      ENDIF.

      COLLECT ls_measure INTO lt_measure.
    ENDLOOP.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH TABLE KEY FreightOrder = ls_r_frota->FreightOrder
                                                                             Equipment    = ls_r_frota->Equipment.
      CHECK sy-subrc EQ 0.

      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        CONTINUE.
      ENDIF.

      ls_r_frota->OriginalPreventiveMaintCost = ls_r_measure->value.
      ls_r_frota->MeasurePreventiveMaintCost  = ls_r_measure->value / ls_r_measure->stops.

      ls_r_measure->currentstop     = ls_r_measure->currentstop + 1.
      ls_r_measure->currentvalue    = ls_r_measure->currentvalue + ls_r_frota->MeasurePreventiveMaintCost.

      " Tratamento para corrigir a diferença de centavos e jogar no último registro
      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        lv_diff = ls_r_frota->OriginalPreventiveMaintCost - ls_r_measure->currentvalue.
        ls_r_frota->MeasurePreventiveMaintCost = ls_r_frota->MeasurePreventiveMaintCost + lv_diff.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD calculate_tires.

    DATA: lt_measure TYPE ty_t_measure_tires,
          ls_measure TYPE ty_measure_tires,
          lv_diff    TYPE zi_tm_cockpit_frota-OriginalTiresCost.

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY Equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING Equipment.

* --------------------------------------------------------------------
* Recupera despesas relacionado à custos de pneus
* --------------------------------------------------------------------
    IF lt_frota IS NOT INITIAL.

      SELECT *
          FROM zi_tm_despesa_frota_pneus
          FOR ALL ENTRIES IN @lt_frota
          WHERE Equipment EQ @lt_frota-Equipment
            AND TiresCost NE 0
          INTO TABLE @DATA(lt_pneus).

      IF sy-subrc EQ 0.
        SORT lt_pneus BY Equipment.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).
      CLEAR ls_measure.
      ls_measure-FreightOrder = ls_r_frota->FreightOrder.
      ls_measure-Equipment    = ls_r_frota->Equipment.
      ls_measure-stops        = 1.
      ls_measure-currentstop  = 0.
      ls_measure-currentvalue = 0.

      READ TABLE lt_pneus REFERENCE INTO DATA(ls_r_pneus) WITH KEY Equipment = ls_r_frota->Equipment
                                                                   BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_measure-value = ls_r_pneus->TiresCost.
        DELETE lt_pneus INDEX sy-tabix.                 "#EC CI_SEL_DEL
      ENDIF.

      COLLECT ls_measure INTO lt_measure.
    ENDLOOP.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH TABLE KEY FreightOrder = ls_r_frota->FreightOrder
                                                                             Equipment    = ls_r_frota->Equipment.
      CHECK sy-subrc EQ 0.

      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        CONTINUE.
      ENDIF.

      ls_r_frota->OriginalTiresCost = ls_r_measure->Value.
      ls_r_frota->MeasureTiresCost  = ls_r_measure->Value / ls_r_measure->stops.

      ls_r_measure->currentstop     = ls_r_measure->currentstop + 1.
      ls_r_measure->currentvalue    = ls_r_measure->currentvalue + ls_r_frota->MeasureTiresCost.

      " Tratamento para corrigir a diferença de centavos e jogar no último registro
      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        lv_diff = ls_r_frota->OriginalTiresCost - ls_r_measure->currentvalue.
        ls_r_frota->MeasureTiresCost = ls_r_frota->MeasureTiresCost + lv_diff.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD calculate_washing.

    DATA: lt_measure TYPE ty_t_measure_washing,
          ls_measure TYPE ty_measure_washing,
          lv_diff    TYPE zi_tm_cockpit_frota-OriginalWashingCost.

* --------------------------------------------------------------------
* Monta tabela de chaves
* --------------------------------------------------------------------
    DATA(lt_frota) = ct_frota[].
    SORT lt_frota BY Equipment.
    DELETE ADJACENT DUPLICATES FROM lt_frota COMPARING Equipment.

* --------------------------------------------------------------------
* Recupera despesas relacionado à custos de pneus
* --------------------------------------------------------------------
    IF lt_frota IS NOT INITIAL.

      SELECT *
          FROM zi_tm_despesa_frota_lavagem
          FOR ALL ENTRIES IN @lt_frota
          WHERE Equipment = @lt_frota-Equipment
          INTO TABLE @DATA(lt_lavagem).

      IF sy-subrc EQ 0.
        SORT lt_lavagem BY Equipment.
      ENDIF.
    ENDIF.

* --------------------------------------------------------------------
* Atualiza relatório - Valores originais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO DATA(ls_r_frota).
      CLEAR ls_measure.
      ls_measure-FreightOrder = ls_r_frota->FreightOrder.
      ls_measure-Equipment    = ls_r_frota->Equipment.
      ls_measure-stops        = 1.
      ls_measure-currentstop  = 0.
      ls_measure-currentvalue = 0.

      READ TABLE lt_lavagem REFERENCE INTO DATA(ls_r_lavagem) WITH KEY Equipment = ls_r_frota->Equipment
                                                                       BINARY SEARCH.
      IF sy-subrc EQ 0.
        ls_measure-value = ls_r_lavagem->WashingCost.
        DELETE lt_lavagem INDEX sy-tabix.               "#EC CI_SEL_DEL
      ENDIF.

      COLLECT ls_measure INTO lt_measure.
    ENDLOOP.

* --------------------------------------------------------------------
* Atualiza relatório - Valores proporcionais
* --------------------------------------------------------------------
    LOOP AT ct_frota REFERENCE INTO ls_r_frota.

      READ TABLE lt_measure REFERENCE INTO DATA(ls_r_measure) WITH TABLE KEY FreightOrder = ls_r_frota->FreightOrder
                                                                             Equipment    = ls_r_frota->Equipment.
      CHECK sy-subrc EQ 0.

      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        CONTINUE.
      ENDIF.

      ls_r_frota->OriginalWashingCost = ls_r_measure->value.
      ls_r_frota->MeasureWashingCost  = ls_r_measure->value / ls_r_measure->stops.

      ls_r_measure->currentstop     = ls_r_measure->currentstop + 1.
      ls_r_measure->currentvalue    = ls_r_measure->currentvalue + ls_r_frota->MeasureWashingCost.

      " Tratamento para corrigir a diferença de centavos e jogar no último registro
      IF ls_r_measure->currentstop >= ls_r_measure->stops.
        lv_diff = ls_r_frota->OriginalWashingCost - ls_r_measure->currentvalue.
        ls_r_frota->MeasureWashingCost = ls_r_frota->MeasureWashingCost + lv_diff.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD total.

    DATA: lv_value TYPE crdsef_decimal_value.

    LOOP AT ct_frota REFERENCE INTO DATA(ls_frota).

* --------------------------------------------------------------------
* Dados de teste
* --------------------------------------------------------------------
*      ls_frota->MeasureFuelVolume           = COND #( WHEN ls_frota->MeasureFuelVolume           IS INITIAL THEN 1  ELSE ls_frota->MeasureFuelVolume           ).
*      ls_frota->MeasureFuelValue            = COND #( WHEN ls_frota->MeasureFuelValue            IS INITIAL THEN 2  ELSE ls_frota->MeasureFuelValue            ).
*      ls_frota->MeasureFuelDistanceKm       = COND #( WHEN ls_frota->MeasureFuelDistanceKm       IS INITIAL THEN 3  ELSE ls_frota->MeasureFuelDistanceKm       ).
*      ls_frota->MeasureDepreciationCost     = COND #( WHEN ls_frota->MeasureDepreciationCost     IS INITIAL THEN 4  ELSE ls_frota->MeasureDepreciationCost     ).
*      ls_frota->MeasureWashingCost          = COND #( WHEN ls_frota->MeasureWashingCost          IS INITIAL THEN 5  ELSE ls_frota->MeasureWashingCost          ).
*      ls_frota->MeasurePreventiveMaintCost  = COND #( WHEN ls_frota->MeasurePreventiveMaintCost  IS INITIAL THEN 6  ELSE ls_frota->MeasurePreventiveMaintCost  ).
*      ls_frota->MeasureCorrectiveMaintCost  = COND #( WHEN ls_frota->MeasureCorrectiveMaintCost  IS INITIAL THEN 7  ELSE ls_frota->MeasureCorrectiveMaintCost  ).
*      ls_frota->MeasureTiresCost            = COND #( WHEN ls_frota->MeasureTiresCost            IS INITIAL THEN 8  ELSE ls_frota->MeasureTiresCost            ).
*      ls_frota->MeasureDocumentationCost    = COND #( WHEN ls_frota->MeasureDocumentationCost    IS INITIAL THEN 9  ELSE ls_frota->MeasureDocumentationCost    ).
*      ls_frota->MeasureLaborCost            = COND #( WHEN ls_frota->MeasureLaborCost            IS INITIAL THEN 10 ELSE ls_frota->MeasureLaborCost            ).
*      ls_frota->OriginalFuelVolume          = COND #( WHEN ls_frota->OriginalFuelVolume          IS INITIAL THEN 11 ELSE ls_frota->OriginalFuelVolume          ).
*      ls_frota->OriginalFuelValue           = COND #( WHEN ls_frota->OriginalFuelValue           IS INITIAL THEN 12 ELSE ls_frota->OriginalFuelValue           ).
*      ls_frota->OriginalFuelDistanceKm      = COND #( WHEN ls_frota->OriginalFuelDistanceKm      IS INITIAL THEN 13 ELSE ls_frota->OriginalFuelDistanceKm      ).
*      ls_frota->OriginalDepreciationCost    = COND #( WHEN ls_frota->OriginalDepreciationCost    IS INITIAL THEN 14 ELSE ls_frota->OriginalDepreciationCost    ).
*      ls_frota->OriginalWashingCost         = COND #( WHEN ls_frota->OriginalWashingCost         IS INITIAL THEN 15 ELSE ls_frota->OriginalWashingCost         ).
*      ls_frota->OriginalPreventiveMaintCost = COND #( WHEN ls_frota->OriginalPreventiveMaintCost IS INITIAL THEN 16 ELSE ls_frota->OriginalPreventiveMaintCost ).
*      ls_frota->OriginalCorrectiveMaintCost = COND #( WHEN ls_frota->OriginalCorrectiveMaintCost IS INITIAL THEN 17 ELSE ls_frota->OriginalCorrectiveMaintCost ).
*      ls_frota->OriginalTiresCost           = COND #( WHEN ls_frota->OriginalTiresCost           IS INITIAL THEN 18 ELSE ls_frota->OriginalTiresCost           ).
*      ls_frota->OriginalDocumentationCost   = COND #( WHEN ls_frota->OriginalDocumentationCost   IS INITIAL THEN 19 ELSE ls_frota->OriginalDocumentationCost   ).
*      ls_frota->OriginalLaborCost           = COND #( WHEN ls_frota->OriginalLaborCost           IS INITIAL THEN 20 ELSE ls_frota->OriginalLaborCost           ).
* --------------------------------------------------------------------

      lv_value                              = COND #( WHEN ls_frota->OriginalFuelVolume NE 0
                                                      THEN ls_frota->MeasureFuelDistanceKm / ls_frota->OriginalFuelVolume
                                                      ELSE 0  ).

      ls_frota->TotalKmPerLiter             = COND #( WHEN lv_value >= '0.01'
                                                      THEN lv_value
                                                      ELSE '0.01' ).

      lv_value                              = ( ls_frota->MeasureFuelValue
                                              + ls_frota->MeasureDepreciationCost
                                              + ls_frota->MeasureWashingCost
                                              + ls_frota->MeasurePreventiveMaintCost
                                              + ls_frota->MeasureCorrectiveMaintCost
                                              + ls_frota->MeasureTiresCost
                                              + ls_frota->MeasureDocumentationCost
                                              + ls_frota->MeasureLaborCost ).

      ls_frota->TotalValue                  = COND #( WHEN lv_value >= '0.01'
                                                      THEN lv_value
                                                      ELSE '0.01' ).

      lv_value                              = COND #( WHEN ls_frota->OriginalFuelValue NE 0
                                                      THEN ls_frota->TotalValue / ls_frota->OriginalFuelValue
                                                      ELSE 0  ).

      ls_frota->TotalValuePerLiter          = COND #( WHEN lv_value >= '0.01'
                                                      THEN lv_value
                                                      ELSE '0.01' ).

      lv_value                              = COND #( WHEN ls_frota->OriginalFuelDistanceKm NE 0
                                                      THEN ls_frota->TotalValue / ls_frota->OriginalFuelDistanceKm
                                                      ELSE 0  ).

      ls_frota->TotalValuePerKm             = COND #( WHEN lv_value >= '0.01'
                                                      THEN lv_value
                                                      ELSE '0.01' ).

      lv_value                              = COND #( WHEN ls_frota->TotalWeightKg NE 0
                                                      THEN ls_frota->TotalValue / ls_frota->TotalWeightKg
                                                      ELSE 0  ).

      ls_frota->TotalValuePerKg             = COND #( WHEN lv_value >= '0.01'
                                                      THEN lv_value
                                                      ELSE '0.01' ).

      lv_value                              = COND #( WHEN ls_frota->TotalAllCustomers NE 0
                                                      THEN ls_frota->TotalValuePerKg * ( ls_frota->TotalAllCustomers / ls_frota->TotalCustomers )
                                                      ELSE 0  ).

      ls_frota->TotalValuePerKgPerCustomer  = COND #( WHEN lv_value >= '0.01'
                                                      THEN lv_value
                                                      ELSE '0.01' ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera Parâmetro para HODOMETRO
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_hodometro IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_hodometro-modulo
                                                 chave1 = gc_param_hodometro-chave1
                                                 chave2 = gc_param_hodometro-chave2
                                                 chave3 = gc_param_hodometro-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_hodometro[] ).

    ENDIF.

    IF me->gs_parameter-r_hodometro IS INITIAL.
      " Medições para "Hodômetro" não cadastrado na tabela de parâmetros
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '121'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro para COMBUSTÍVEL
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_combustivel IS INITIAL.

      ls_parametro       = VALUE ztca_param_val( modulo = gc_param_combustivel-modulo
                                                 chave1 = gc_param_combustivel-chave1
                                                 chave2 = gc_param_combustivel-chave2
                                                 chave3 = gc_param_combustivel-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_combustivel[] ).

    ENDIF.

    IF me->gs_parameter-r_combustivel IS INITIAL.
      " Medições para "Combustível" não cadastrado na tabela de parâmetros
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '122'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro para VALOR ABASTECIMENTO
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_abastecimento IS INITIAL.

      ls_parametro       = VALUE ztca_param_val( modulo = gc_param_abastecimento-modulo
                                                 chave1 = gc_param_abastecimento-chave1
                                                 chave2 = gc_param_abastecimento-chave2
                                                 chave3 = gc_param_abastecimento-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_abastecimento[] ).

    ENDIF.

    IF me->gs_parameter-r_abastecimento IS INITIAL.
      " Medições para "Abastecimento" não cadastrado na tabela de parâmetros
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '123'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.




    es_parameter = me->gs_parameter.

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
ENDCLASS.
