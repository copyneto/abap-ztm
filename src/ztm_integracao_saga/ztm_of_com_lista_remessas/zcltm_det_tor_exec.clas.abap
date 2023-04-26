"!<p><h2>Envia dados da remessa para o SAGA</h2></p>
"!<p><strong>Autor: </strong>Eliabe Lima</p>
"!<p><strong>Data: </strong>11/03/2022</p>
CLASS zcltm_det_tor_exec DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS gc_itmtype_truc TYPE /scmtms/tor_item_type VALUE 'TRUC' ##NO_TEXT.
    CONSTANTS gc_itmtype_trl TYPE /scmtms/tor_item_type VALUE 'TRL' ##NO_TEXT.
    CONSTANTS gc_itemcat_avr TYPE /scmtms/item_category VALUE 'AVR' ##NO_TEXT.
    CONSTANTS gc_itemcat_pvr TYPE /scmtms/item_category VALUE 'PVR' ##NO_TEXT.
    CONSTANTS gc_itmtype_prd TYPE /scmtms/tor_item_type VALUE 'PRD' ##NO_TEXT.
    CONSTANTS gc_item_btd_entrega TYPE /scmtms/base_btd_tco VALUE '73' ##NO_TEXT.
    CONSTANTS gc_sep_split TYPE char1 VALUE '_' ##NO_TEXT.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_event_lib_p_carregar TYPE /scmtms/tor_event VALUE 'LIBERADO P/CARREGAR' ##NO_TEXT.
    DATA go_srv_tor TYPE REF TO /bobf/if_tra_service_manager .
    CONSTANTS gc_event_fim_carreg TYPE /scmtms/tor_event VALUE 'FIM DO CARREGAMENTO' ##NO_TEXT.
    CONSTANTS gc_event_faturar_carregar TYPE /scmtms/tor_event VALUE 'FATURAR/CARREGAR' ##NO_TEXT.

    METHODS get_event_db
      IMPORTING
        !iv_key        TYPE /bobf/conf_key
      RETURNING
        VALUE(rt_exec) TYPE /scmtms/t_tor_exec_k .
    METHODS send_data_saga
      IMPORTING
        !iv_key TYPE /bobf/conf_key .
ENDCLASS.



CLASS ZCLTM_DET_TOR_EXEC IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA: lt_tor_root   TYPE /scmtms/t_tor_root_k,
          lt_tor_docref TYPE /scmtms/t_tor_docref_k,
          lt_tor_exec   TYPE /scmtms/t_tor_exec_k,
          lt_rem_saga   TYPE TABLE OF ztsd_rem_saga,
          lt_remessa    TYPE vbeln_vl_t.

    io_read->retrieve(
      EXPORTING iv_node         = /scmtms/if_tor_c=>sc_node-executioninformation          " Node Name
                it_key          = it_key                                                  " Key Table
      IMPORTING et_data         = lt_tor_exec ).

    io_read->retrieve(
      EXPORTING iv_node         = /scmtms/if_tor_c=>sc_node-root                          " Node Name
                it_key          = CORRESPONDING #( lt_tor_exec MAPPING key = parent_key ) " Key Table
      IMPORTING et_data         = lt_tor_root ).

    DELETE lt_tor_root WHERE tor_cat <> /scmtms/if_tor_const=>sc_tor_category-active.
    CHECK lt_tor_root IS NOT INITIAL.

    io_read->retrieve_by_association(
      EXPORTING iv_node         = /scmtms/if_tor_c=>sc_node-root                          " Node Name
                it_key          = CORRESPONDING #( lt_tor_root MAPPING key = key )        " Key Table
                iv_association  = /scmtms/if_tor_c=>sc_association-root-docreference      " Name of Association
                iv_fill_data    = abap_true                                               " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
      IMPORTING et_data         = lt_tor_docref ).

    DELETE lt_tor_docref WHERE btd_tco <> '73'
                           AND btd_tco <> '58'.
    CHECK lt_tor_docref IS NOT INITIAL.

    LOOP AT lt_tor_docref ASSIGNING FIELD-SYMBOL(<fs_tor_docref>).
      APPEND INITIAL LINE TO lt_remessa ASSIGNING FIELD-SYMBOL(<fs_remessa>).
      <fs_remessa> = |{ <fs_tor_docref>-btd_id    ALPHA = OUT }|.
      <fs_remessa> = |{ <fs_remessa> ALPHA = IN  }|.
    ENDLOOP.

    SELECT a~vbeln AS remessa,
           a~lfart AS tipo_remessa,
           b~werks AS centro
      FROM likp AS a
      INNER JOIN lips AS b ON b~vbeln = a~vbeln
      FOR ALL ENTRIES IN @lt_remessa
      WHERE a~vbeln EQ @lt_remessa-table_line
      INTO TABLE @DATA(lt_likp).

    LOOP AT lt_tor_docref ASSIGNING <fs_tor_docref>.
      IF line_exists( lt_tor_root[ key = <fs_tor_docref>-parent_key ] ).
        APPEND INITIAL LINE TO lt_rem_saga ASSIGNING FIELD-SYMBOL(<fs_remessa_saga>).
        <fs_remessa_saga>-mandt       = sy-mandt.
        <fs_remessa_saga>-remessa     = |{ <fs_tor_docref>-btd_id    ALPHA = OUT }|.
        <fs_remessa_saga>-remessa     = |{ <fs_remessa_saga>-remessa ALPHA = IN  }|.
        <fs_remessa_saga>-ordem_frete = lt_tor_root[ key = <fs_tor_docref>-parent_key ]-tor_id.

        IF line_exists( lt_likp[ remessa = <fs_remessa_saga>-remessa ] ).
          <fs_remessa_saga>-tipo_remessa = lt_likp[ remessa = <fs_remessa_saga>-remessa ]-tipo_remessa.
          <fs_remessa_saga>-centro       = lt_likp[ remessa = <fs_remessa_saga>-remessa ]-centro.
        ENDIF.

      ENDIF.
    ENDLOOP.

    IF lt_rem_saga[] IS NOT INITIAL.

      CALL FUNCTION 'ZFMTM_REMESSA_SAGA'
        STARTING NEW TASK 'REMESSA_SAGA'
        TABLES
          it_remessa = lt_rem_saga.

    ENDIF.


*    DATA: lt_exec    TYPE /scmtms/t_tor_exec_k,
*          lt_execdb  TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
*          lt_auxexc  TYPE STANDARD TABLE OF /scmtms/s_tor_exec_k,
*          lv_send    TYPE abap_bool,
*          lv_qtdtela TYPE i,
*          lv_qtddb   TYPE i,
*          lv_tabix   TYPE sy-tabix,
*          lv_key     TYPE /bobf/conf_key.
*    TRY.
*
*        go_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).
*
*        go_srv_tor->retrieve(
*          EXPORTING
*            iv_node_key             = /scmtms/if_tor_c=>sc_node-executioninformation
*            it_key                  = it_key
*            iv_fill_data            = abap_true
*          IMPORTING
*            et_data                 = lt_exec
*        ).
*
*        lt_auxexc = lt_exec.
*        SORT lt_auxexc BY event_code.
*        lv_send = abap_false.
*
*        IF  line_exists( lt_auxexc[ event_code = gc_event_faturar_carregar ] ) "#EC CI_STDSEQ
*         OR line_exists( lt_auxexc[ event_code = gc_event_lib_p_carregar ] ). "#EC CI_STDSEQ
*
*          lv_send = abap_true.
*          lv_tabix = sy-tabix.
*
*          IF lt_exec IS NOT INITIAL.
*            lv_key = lt_exec[ 1 ]-root_key.
*            lt_execdb = get_event_db( iv_key = lv_key  ).
*          ENDIF.
*
***          IF lt_execdb IS NOT INITIAL.
***            SORT lt_execdb BY event_code.
***
****            READ TABLE lt_execdb
****                 WITH KEY event_code = gc_event_fim_carreg "gc_event_lib_p_carregar
****                        BINARY SEARCH TRANSPORTING NO FIELDS.
***
****            IF sy-subrc = 0.
****              lv_send = abap_false.
****              LOOP AT lt_execdb FROM sy-tabix ASSIGNING FIELD-SYMBOL(<fs_execdb>).
****                IF <fs_execdb>-event_code NE gc_event_lib_p_carregar.
****                  EXIT.
****                ENDIF.
****                lv_qtddb = lv_qtddb + 1.
****              ENDLOOP.
****
****              LOOP AT lt_auxexc FROM lv_tabix ASSIGNING FIELD-SYMBOL(<fs_aux>).
****                IF <fs_aux>-event_code NE gc_event_lib_p_carregar.
****                  EXIT.
****                ENDIF.
****                lv_qtdtela = lv_qtdtela + 1.
****              ENDLOOP.
****              IF lv_qtdtela <= lv_qtddb.
****                lv_send = abap_false.
****              ENDIF.
****            ENDIF.
***
***          ENDIF.
*        ENDIF.
*
*        IF lv_send = abap_true.
*          send_data_saga( iv_key = lv_key ).
*        ENDIF.
*
*      CATCH cx_root INTO DATA(lo_cx_root).
*
*    ENDTRY.

  ENDMETHOD.


  METHOD get_event_db.
    DATA: lo_srv_tor TYPE REF TO /bobf/if_tra_service_manager,
          lt_tor     TYPE /scmtms/t_tor_root_k,
          lt_key     TYPE /bobf/t_frw_key,
          lt_filtro  TYPE /bobf/t_frw_key,
          lt_exec    TYPE /scmtms/t_tor_exec_k.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    APPEND INITIAL LINE TO lt_filtro ASSIGNING FIELD-SYMBOL(<fs_filtro>).
    <fs_filtro>-key = iv_key.

    lo_srv_tor->query(
               EXPORTING
                 iv_query_key            = /scmtms/if_tor_c=>sc_query-root-root_elements
                 it_filter_key           = lt_filtro
                 iv_fill_data            = abap_true
               IMPORTING
                 et_data                 = lt_tor
                 et_key                  = lt_key
              ).

    IF lt_key IS NOT INITIAL.

      lo_srv_tor->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root
            it_key                  = lt_key
            iv_association          = /scmtms/if_tor_c=>sc_association-root-exec
            iv_fill_data            = abap_true
          IMPORTING
            et_data                 = lt_exec
        ).
      rt_exec = lt_exec.
    ENDIF.

  ENDMETHOD.


  METHOD send_data_saga.

    TYPES: BEGIN OF ty_remessa,
             vbeln TYPE c LENGTH 10,
           END OF ty_remessa.

    DATA: lt_key     TYPE /bobf/t_frw_key,
          lt_tor     TYPE /scmtms/t_tor_root_k,
          lt_itemtr  TYPE /scmtms/t_tor_item_tr_k,
          lt_remessa TYPE STANDARD TABLE OF ty_remessa.

    DATA: ls_output  TYPE zclsd_mt_remessa_ordem,
          ls_outsend TYPE zclsd_mt_remessa_ordem.

    DATA: lv_cavalo   TYPE string,
          lv_carreta  TYPE string,
          lv_lcarreta TYPE abap_bool,
          lv_torid    TYPE /scmtms/tor_id,
          lv_auxbtdid TYPE /scmtms/base_btd_id,
          lv_vbeln    TYPE vbeln.

    IF go_srv_tor IS NOT INITIAL.
      /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = iv_key
                                                   CHANGING ct_key = lt_key ).

      go_srv_tor->retrieve( EXPORTING iv_node_key  = /scmtms/if_tor_c=>sc_node-root
                                      it_key       = lt_key
                                      iv_fill_data = abap_true
                            IMPORTING et_data      = lt_tor ).

      IF lt_tor IS NOT INITIAL.
        CLEAR lt_key.

        /scmtms/cl_common_helper=>check_insert_key( EXPORTING iv_key = lt_tor[ 1 ]-key
                                                     CHANGING ct_key = lt_key ).

        go_srv_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                       it_key         = lt_key
                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
                                                       iv_fill_data   = abap_true
                                             IMPORTING et_data        = lt_itemtr ).

        LOOP AT lt_itemtr ASSIGNING FIELD-SYMBOL(<fs_itemtr>).

          IF <fs_itemtr>-item_cat EQ gc_itemcat_avr  " CAVALO
          OR <fs_itemtr>-item_cat EQ gc_itemcat_pvr. " CARRETA - Recurso passivo

            IF <fs_itemtr>-platenumber IS NOT INITIAL
           AND <fs_itemtr>-item_cat EQ gc_itemcat_avr. "CAVALO
              lv_cavalo = <fs_itemtr>-platenumber.
            ENDIF.

            IF ls_output-mt_remessa_ordem-transporte-ztpveic IS INITIAL.
              ls_output-mt_remessa_ordem-transporte-ztpveic = <fs_itemtr>-tures_tco.
            ENDIF.

            IF <fs_itemtr>-platenumber IS NOT INITIAL
           AND <fs_itemtr>-item_cat EQ gc_itemcat_pvr.
              lv_carreta = lv_carreta && gc_sep_split && <fs_itemtr>-platenumber.
              lv_lcarreta = abap_true.
            ENDIF.

          ENDIF.

          IF <fs_itemtr>-base_btd_tco = gc_item_btd_entrega
         AND <fs_itemtr>-base_btd_id IS NOT INITIAL.

            lv_auxbtdid = <fs_itemtr>-base_btd_id.
            SHIFT lv_auxbtdid LEFT DELETING LEADING '0'.
            APPEND INITIAL LINE TO lt_remessa ASSIGNING FIELD-SYMBOL(<fs_remessa>).
            <fs_remessa>-vbeln = lv_auxbtdid.
          ENDIF.

        ENDLOOP.

        IF lv_lcarreta EQ abap_true.
          ls_output-mt_remessa_ordem-transporte-platnumber = lv_cavalo && lv_carreta.
        ELSE.
          ls_output-mt_remessa_ordem-transporte-platnumber = lv_cavalo.
        ENDIF.

        lv_torid = lt_tor[ 1 ]-tor_id.
        SHIFT lv_torid LEFT DELETING LEADING '0'.
        ls_output-mt_remessa_ordem-zordemfrete = lv_torid(10).
        ls_output-mt_remessa_ordem-zobspostal  = gc_event_lib_p_carregar.

        IF lt_tor[ 1 ]-zz_motorista IS NOT INITIAL.

          ls_output-mt_remessa_ordem-transporte-zcodmot = lt_tor[ 1 ]-zz_motorista.

          SELECT SINGLE lifnr,
                        mcod1,
                        stcd2
           FROM lfa1
           INTO @DATA(ls_lfa1)
          WHERE lifnr = @ls_output-mt_remessa_ordem-transporte-zcodmot.

          IF sy-subrc = 0.
            ls_output-mt_remessa_ordem-transporte-znomemot = ls_lfa1-mcod1.
            ls_output-mt_remessa_ordem-transporte-zcpfmot  = ls_lfa1-stcd2.
          ENDIF.
        ENDIF.
      ENDIF.

      IF ls_output IS NOT INITIAL.

        SORT lt_remessa BY vbeln.
        DELETE ADJACENT DUPLICATES FROM lt_remessa COMPARING vbeln.

        LOOP AT lt_remessa ASSIGNING <fs_remessa>.

          ls_outsend = ls_output.

          TRY.

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = <fs_remessa>-vbeln
                IMPORTING
                  output = lv_vbeln.

              ls_outsend-mt_remessa_ordem-vbeln = lv_vbeln.

*              NEW zclsd_co_si_envia_remessa_orde( )->si_envia_remessa_ordem_out( output = ls_outsend  ).
*
*              UNPACK ls_outsend-mt_remessa_ordem-vbeln TO ls_outsend-mt_remessa_ordem-vbeln.

              " Implementacao realizada após reuniao do gap 516
              NEW zclsd_saga_envio_pre_registro( )->envio_registro( EXPORTING iv_ordemfrete = CONV ze_ordemfrete( lv_torid )
                                                                              iv_remessa    = CONV #( ls_outsend-mt_remessa_ordem-vbeln ) ).

            CATCH cx_ai_system_fault. " Erro de comunicação.
          ENDTRY.

        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
