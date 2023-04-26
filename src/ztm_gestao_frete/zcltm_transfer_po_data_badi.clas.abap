CLASS zcltm_transfer_po_data_badi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_wzre_transfer_po_data_badi .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF lc_param_bsart,
        modulo TYPE ztca_param_par-modulo VALUE 'TM',
        chave1 TYPE ztca_param_par-chave1 VALUE 'STO_FREIGHT_EXPENSE',
        chave2 TYPE ztca_param_par-chave2 VALUE 'BSART',
      END OF lc_param_bsart.
ENDCLASS.



CLASS ZCLTM_TRANSFER_PO_DATA_BADI IMPLEMENTATION.


  METHOD if_wzre_transfer_po_data_badi~transfer.
    DATA:
      lr_bsart    TYPE RANGE OF ekko-bsart.
    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_param_bsart-modulo
            iv_chave1 = lc_param_bsart-chave1
            iv_chave2 = lc_param_bsart-chave2
          IMPORTING
            et_range  = lr_bsart
        ).
      CATCH cx_root.
    ENDTRY.

    SELECT SINGLE bwtar, PARGB, prctr, umwrk_cid
      FROM matdoc
      INTO @DATA(ls_matdoc)
     WHERE vbeln_im EQ @cs_item_fields-wbeln_v
*       AND vbelp_im EQ @cs_item_fields-posnr_v
       AND ebelp    EQ @cs_item_fields-posnr_v
       AND matbf    EQ @cs_item_fields-matnr
       AND werks    EQ @cs_item_fields-werks.


    IF sy-subrc IS INITIAL.
      IF is_ekko-bsart IN lr_bsart.
        cs_item_fields-gsber  = ls_matdoc-PARGB.
        cs_item_fields-werks = ls_matdoc-umwrk_cid.
      ENDIF.
      cs_item_fields-prctr = ls_matdoc-prctr.
      cs_item_fields-bwtar = ls_matdoc-bwtar.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
