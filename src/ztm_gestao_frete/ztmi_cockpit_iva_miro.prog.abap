*&---------------------------------------------------------------------*
*& Include          ZTMI_COCKPIT_IVA_MIRO
*&---------------------------------------------------------------------*

    IF lt_drseg_co[] IS NOT INITIAL.
      DATA(lv_iva) = lt_drseg_co[ 1 ]-mwskz.
      LOOP AT ct_drseg ASSIGNING FIELD-SYMBOL(<fs_drseg>).
        CHECK <fs_drseg>-mwskz = '**'.
        <fs_drseg>-mwskz = lv_iva.
      ENDLOOP.
    ENDIF.
