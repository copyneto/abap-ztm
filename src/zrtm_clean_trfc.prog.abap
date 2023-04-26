*&---------------------------------------------------------------------*
*& Report ZRTM_CLEAN_TRFC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrtm_clean_trfc.

TRY.
    DELETE FROM bgrfc_i_runnable WHERE unit_id <> space.
    DELETE FROM trfc_i_dest WHERE unit_id <> space.
    DELETE FROM trfc_i_sdata WHERE unit_id <> space.
    DELETE FROM trfc_i_err_state WHERE unit_id <> space.
    DELETE FROM trfc_i_exe_state WHERE unit_id <> space.
    DELETE FROM trfc_i_unit_sess WHERE unit_id <> space.
    DELETE FROM trfc_i_unit_lock WHERE unit_id <> space.
    DELETE FROM trfc_i_unit WHERE unit_id <> space.
  CATCH cx_root.
ENDTRY.
