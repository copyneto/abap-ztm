*&---------------------------------------------------------------------*
*& Report ZTMR_CREATE_FILE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztmr_create_file.

DATA(go_report) = NEW zcltm_create_file( ).

START-OF-SELECTION.

  go_report->get_directories( ).
  go_report->create_file( ).

END-OF-SELECTION.
