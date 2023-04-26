*&---------------------------------------------------------------------*
*& Report ZMMR_GKO_PROCESSA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmmr_gko_processa.

TABLES: zttm_gkot001.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.

  SELECT-OPTIONS: s_bukrs  FOR zttm_gkot001-bukrs,
                  s_branch FOR zttm_gkot001-branch,
                  s_acckey FOR zttm_gkot001-acckey,
                  s_tcnpjc FOR zttm_gkot001-tom_cnpj_cpf,
                  s_tom_ie FOR zttm_gkot001-tom_ie.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  DATA(go_report) = NEW zclmm_gko_process_doc( ir_bukrs  = s_bukrs[]
                                               ir_branch = s_branch[]
                                               ir_acckey = s_acckey[]
                                               ir_tcnpjc = s_tcnpjc[]
                                               ir_tom_ie = s_tom_ie[] ).

  go_report->get_data( ).

  go_report->process( ).

  go_report->show_log( ).
