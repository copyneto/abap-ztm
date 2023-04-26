CLASS zcltm_fsd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
   GLOBAL FRIENDS /scmtms/cl_cfir_controller .

  PUBLIC SECTION.

    INTERFACES /scmtms/if_enh_stlmnt_index.

    METHODS execute_split_inv
      IMPORTING
        io_methpar TYPE REF TO /sctm/cl_meth_parameter
        it_request TYPE /sctm/tt_request .

  PRIVATE SECTION.
    DATA:
      gt_transport_root  TYPE /scmtms/t_tcc_root_k,
      gt_charge_items    TYPE /scmtms/t_tcc_chrgitem_k,
      gt_charge_elements TYPE /scmtms/t_tcc_trchrg_element_k.

    METHODS:
      get_data IMPORTING iv_key TYPE /bobf/conf_key.
ENDCLASS.



CLASS zcltm_fsd IMPLEMENTATION.

  METHOD execute_split_inv.

    exit.

*    DATA: lo_request TYPE REF TO /scmtms/cl_sfir_pro_request.
*    FIELD-SYMBOLS: <fs_ref>      TYPE /scmtms/t_tcc_comm_root,
*                   <fs_comm_str> TYPE /scmtms/s_tcc_comm_root,
*                   <fs_item>     TYPE /scmtms/s_tcc_comm_item.
*
*
*    IF sy-uname = 'MSOUZA'.
*      CHECK lines( it_request ) > 0.
*      lo_request ?= it_request[ 1 ].
*      CHECK lo_request IS BOUND.
*
*      ASSIGN lo_request->mt_data_input[ 1 ] TO FIELD-SYMBOL(<fs_request>).
*      CHECK lines( <fs_request>-sfir_settlement_index ) > 0.
*
*      ASSIGN <fs_request>-data_ref->* TO <fs_ref>.
*      DATA(lv_root_key) = <fs_ref>[ 1 ]-key.
*
*      get_data( lv_root_key ).
*
*      "Obter o nº de pacotes da ordem de frete
**      SELECT FROM @gt_charge_elements AS elementos
**        FIELDS COUNT( DISTINCT btd_id006 )
**        INTO @DATA(lv_pacotes).
*
*      ASSIGN <fs_ref>[ 1 ] TO FIELD-SYMBOL(<fs_fatura>).
*      LOOP AT gt_charge_elements ASSIGNING FIELD-SYMBOL(<fs_group>)
*                                 GROUP BY <fs_group>-btd_id006
*                                 ASCENDING
*                                 INTO DATA(lv_key).
*
*        APPEND INITIAL LINE TO <fs_fatura>-item.
*
**        LOOP AT GROUP lv_key ASSIGNING FIELD-SYMBOL(<fs_element>).
***          APPEND INITIAL LINE TO <fs_fatura>-item ASSIGNING <fs_item>.
***          <fs_item> = CORRESPONDING #( <fs_element> ).
**
***          IF <fs_element>-inactive = abap_false.
***            "Somar os valores do pacote
***          ENDIF.
**        ENDLOOP.
*      ENDLOOP.
*    ENDIF.
  ENDMETHOD.


  METHOD get_data.

    DATA: ls_ctx TYPE /scmtms/cl_tcc_do_helper=>ts_ctx.

    ls_ctx-host_bo_key        = /scmtms/if_tor_c=>sc_bo_key.
    ls_ctx-host_root_node_key = /scmtms/if_tor_c=>sc_node-root.
    ls_ctx-host_node_key      = /scmtms/if_tor_c=>sc_node-transportcharges.

    /scmtms/cl_tcc_do_helper=>retrive_do_nodes(
      EXPORTING
        is_ctx                   = ls_ctx
        it_root_key              = VALUE /bobf/t_frw_key( ( key = iv_key ) )
      IMPORTING
        et_charge_item           = gt_charge_items
        et_do_root               = gt_transport_root
        et_charge_element        = gt_charge_elements ).
  ENDMETHOD.


  METHOD /scmtms/if_enh_stlmnt_index~enhance_settlement_index.
    exit.
  ENDMETHOD.
ENDCLASS.
