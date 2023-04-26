CLASS zcxtm_gko_process DEFINITION
  PUBLIC
  INHERITING FROM zcxtm_gko
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_payment_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_payment_not_found .
    CONSTANTS:
      BEGIN OF gc_cancel_not_success,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_cancel_not_success .
    CONSTANTS:
      BEGIN OF gc_error_unlock_document,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_unlock_document .
    CONSTANTS:
      BEGIN OF gc_error_on_get_xml_value,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_get_xml_value .
    CONSTANTS:
      BEGIN OF gc_doc_in_process,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_doc_in_process .
    CONSTANTS:
      BEGIN OF gc_error_on_persist_data_on_db,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_persist_data_on_db .
    CONSTANTS:
      BEGIN OF gc_acckey_blocked,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_acckey_blocked .
    CONSTANTS:
      BEGIN OF gc_acckey_blocked_fo,
        " Ordem de Frete &1 bloqueada pelo usuário &2.
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '150',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_acckey_blocked_fo.
    CONSTANTS:
      BEGIN OF gc_document_wo_finished_prdcts,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '014',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_document_wo_finished_prdcts .
    CONSTANTS:
      BEGIN OF gc_attachment_already_imported,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '015',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_attachment_already_imported .
    CONSTANTS:
      BEGIN OF gc_error_on_open_file,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_open_file .
    CONSTANTS:
      BEGIN OF gc_attach_orig_dir_not_cnfg,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_attach_orig_dir_not_cnfg .
    CONSTANTS:
      BEGIN OF gc_attach_proc_dir_not_cnfg,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_attach_proc_dir_not_cnfg .
    CONSTANTS:
      BEGIN OF gc_directory_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '019',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_directory_not_found .
    CONSTANTS:
      BEGIN OF gc_no_write_permission,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_no_write_permission .
    CONSTANTS:
      BEGIN OF gc_error_on_check_drctr,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_check_drctr .
    CONSTANTS:
      BEGIN OF gc_no_auth_dir,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '022',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_no_auth_dir .
    CONSTANTS:
      BEGIN OF gc_empty_directory,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '023',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_empty_directory .
    CONSTANTS:
      BEGIN OF gc_error_get_file_lst_dir,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '024',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_get_file_lst_dir .
    CONSTANTS:
      BEGIN OF gc_valid_file_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '025',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_valid_file_not_found .
    CONSTANTS:
      BEGIN OF gc_only_backgroun_exctn,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '026',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_only_backgroun_exctn .
    CONSTANTS:
      BEGIN OF gc_job_already_in_exctn,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '027',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_job_already_in_exctn .
    CONSTANTS:
      BEGIN OF gc_cte_nfs_not_found_for_fls,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '028',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_cte_nfs_not_found_for_fls .
    CONSTANTS:
      BEGIN OF gc_error_on_create_file,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '029',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_create_file .
    CONSTANTS:
      BEGIN OF gc_error_on_read_file,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '030',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_read_file .
    CONSTANTS:
      BEGIN OF gc_error_on_delete_file,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '031',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_error_on_delete_file .
    CONSTANTS:
      BEGIN OF gc_ref_nf_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '032',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_ref_nf_not_found .
    CONSTANTS:
      BEGIN OF gc_xml_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '035',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_xml_not_found .
    CONSTANTS:
      BEGIN OF gc_ref_docs_not_informed,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '036',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_ref_docs_not_informed .
    CONSTANTS:
      BEGIN OF gc_event_not_allowed_for_tpdoc,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '036',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_event_not_allowed_for_tpdoc .
    CONSTANTS:
      BEGIN OF gc_rfc_destination_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '039',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF gc_rfc_destination_not_found .
    CONSTANTS:
      BEGIN OF emit_werks_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '044',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF emit_werks_not_found .
    CONSTANTS:
      BEGIN OF for_scenar_mat_data_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '045',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_scenar_mat_data_not_found .
    CONSTANTS:
      BEGIN OF not_able_to_determ_cc_account,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '046',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF not_able_to_determ_cc_account .
    CONSTANTS:
      BEGIN OF branch_tom_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '047',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF branch_tom_not_found .
    CONSTANTS:
      BEGIN OF tom_cnpj_not_equal,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '107',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF tom_cnpj_not_equal .
    CONSTANTS:
      BEGIN OF tom_cnpj_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '108',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF tom_cnpj_not_found.
    CONSTANTS:
      BEGIN OF for_rateio_iva_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '048',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_rateio_iva_not_found .
    CONSTANTS:
      BEGIN OF parameter_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '052',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF parameter_not_found .
    CONSTANTS:
      BEGIN OF for_nfs_iva_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '053',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_nfs_iva_not_found .
    CONSTANTS:
      BEGIN OF status_not_allowed_for_reproc,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '054',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF status_not_allowed_for_reproc .
    CONSTANTS:
      BEGIN OF error_on_rev_doc_group_inv,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '055',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF error_on_rev_doc_group_inv .
    CONSTANTS:
      BEGIN OF error_on_cancel_doc_group_inv,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '056',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF error_on_cancel_doc_group_inv .
    CONSTANTS:
      BEGIN OF error_on_reversal_inc_invoice,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '057',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF error_on_reversal_inc_invoice .
    CONSTANTS:
      BEGIN OF error_on_reversal_po,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '058',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF error_on_reversal_po .
    CONSTANTS:
      BEGIN OF error_on_determine_nf_type,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '059',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF error_on_determine_nf_type .
    CONSTANTS:
      BEGIN OF emit_not_expanded_for_vendor,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '060',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF emit_not_expanded_for_vendor .
    CONSTANTS:
      BEGIN OF for_scenario_iva_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '061',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_scenario_iva_not_found .
    CONSTANTS:
      BEGIN OF for_nf_item_iva_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '062',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_nf_item_iva_not_found .
    CONSTANTS:
      BEGIN OF for_status_action_not_allowed,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '066',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_status_action_not_allowed .
    CONSTANTS:
      BEGIN OF miro_not_created_for_ref_nf,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '077',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF miro_not_created_for_ref_nf .
    CONSTANTS:
      BEGIN OF miro_items_not_found_for_nfs,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '079',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF miro_items_not_found_for_nfs .
    CONSTANTS:
      BEGIN OF pmnt_cond_not_found_for_transp,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '082',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF pmnt_cond_not_found_for_transp .
    CONSTANTS:
      BEGIN OF no_entry_made_for_nf_ref,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '083',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF no_entry_made_for_nf_ref .
    CONSTANTS:
      BEGIN OF for_doc_rem_is_not_a_bus_pl,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '087',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF for_doc_rem_is_not_a_bus_pl .
    CONSTANTS:
      BEGIN OF no_entry_was_made_for_nf,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '088',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF no_entry_was_made_for_nf .
    CONSTANTS:
      BEGIN OF doc_emis_date_not_allowed,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '089',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF doc_emis_date_not_allowed .
    CONSTANTS:
      BEGIN OF tom_werks_not_found,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '090',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF tom_werks_not_found .
    CONSTANTS:
      BEGIN OF werks_po_differs_from_werks_to,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '092',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF werks_po_differs_from_werks_to .
    CONSTANTS:
      BEGIN OF ref_docs_not_found_for_acckey,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '093',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF ref_docs_not_found_for_acckey .
    CONSTANTS:
      BEGIN OF orig_acckey_not_posted,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '094',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF orig_acckey_not_posted .
    CONSTANTS:
      BEGIN OF acckey_wo_conf_rej_evt,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '096',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF acckey_wo_conf_rej_evt .
    CONSTANTS:
      BEGIN OF acckey_no_attachment,
        msgid TYPE symsgid VALUE 'ZTM_GKO',
        msgno TYPE symsgno VALUE '110',
        attr1 TYPE scx_attrname VALUE 'MV_MSGV1',
        attr2 TYPE scx_attrname VALUE 'MV_MSGV2',
        attr3 TYPE scx_attrname VALUE 'MV_MSGV3',
        attr4 TYPE scx_attrname VALUE 'MV_MSGV4',
      END OF acckey_no_attachment .

    METHODS constructor
      IMPORTING
        !textid         LIKE if_t100_message=>t100key OPTIONAL
        !previous       LIKE previous OPTIONAL
        !gv_msgv1       TYPE msgv1 OPTIONAL
        !gv_msgv2       TYPE msgv2 OPTIONAL
        !gv_msgv3       TYPE msgv3 OPTIONAL
        !gv_msgv4       TYPE msgv4 OPTIONAL
        !gt_errors      TYPE ty_t_errors OPTIONAL
        !gt_bapi_return TYPE bapiret2_t OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxtm_gko_process IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous       = previous
        gv_msgv1       = gv_msgv1
        gv_msgv2       = gv_msgv2
        gv_msgv3       = gv_msgv3
        gv_msgv4       = gv_msgv4
        gt_errors      = gt_errors
        gt_bapi_return = gt_bapi_return.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
