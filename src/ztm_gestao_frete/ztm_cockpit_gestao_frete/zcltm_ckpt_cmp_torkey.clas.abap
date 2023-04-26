CLASS zcltm_ckpt_cmp_torkey DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_ckpt_cmp_torkey IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_tm_cockpit001 WITH DEFAULT KEY,
          lv_rootkey       TYPE c LENGTH 100.

    lt_original_data = CORRESPONDING #( it_original_data ).

    IF lt_original_data IS NOT INITIAL.
      SELECT
        tor_id,
        db_key
      FROM /scmtms/d_torrot
      FOR ALL ENTRIES IN @lt_original_data
      WHERE
         tor_id = @lt_original_data-tor_id
      INTO TABLE @DATA(lt_torkey).

      IF sy-subrc = 0.
        SORT lt_torkey BY tor_id.
      ENDIF.


      SELECT
          sfir_id,
          db_key
      FROM /scmtms/d_sf_rot
      FOR ALL ENTRIES IN @lt_original_data
      WHERE
        sfir_id = @lt_original_data-sfir_id
      INTO TABLE @DATA(lt_sfirkey).

      IF sy-subrc = 0.
        SORT lt_sfirkey BY sfir_id.
      ENDIF.

    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-tor_id IS NOT INITIAL.
        READ TABLE lt_torkey
        WITH KEY tor_id = <fs_data>-tor_id
        BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_torkey>).

        IF sy-subrc = 0.
          lv_rootkey =  <fs_torkey>-db_key.
          <fs_data>-TransportationOrderUUID =  lv_rootkey ."'005056B095991EECA1A37EDC8C4D368D'.
        ELSE.
          CLEAR <fs_data>-TransportationOrderUUID.
        ENDIF.
      ENDIF.

      IF <fs_data>-sfir_id IS NOT INITIAL.
        READ TABLE lt_sfirkey
       WITH KEY sfir_id = <fs_data>-sfir_id
       BINARY SEARCH ASSIGNING FIELD-SYMBOL(<fs_sfirkey>).

        IF sy-subrc = 0.
          lv_rootkey = <fs_sfirkey>-db_key.
          <fs_data>-SuplrFrtInvcReqUUID = lv_rootkey.
        ENDIF.
      ENDIF.

    ENDLOOP.
    ct_calculated_data = CORRESPONDING #(  lt_original_data ).


  ENDMETHOD.
  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
