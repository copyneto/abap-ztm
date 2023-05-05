CLASS zcltm_atc_folder_fo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_doc_list,
        acckey  TYPE /bobf/conf_key,
        filekey TYPE /bobf/conf_key,
        name    TYPE sdok_filnm,
        atctype TYPE /bobf/attachment_type,
      END OF ty_doc_list .
    TYPES:
      BEGIN OF ty_split_data,
        tp_doc  TYPE char6,
        dt_emi  TYPE char8,
        cnpj_tp TYPE ze_gko_emit_cnjp_cpf,
        nfnum   TYPE j_1bnfnum9,
      END OF ty_split_data .
    TYPES:
      BEGIN OF ty_gkot001,
        acckey TYPE zttm_gkot001-acckey,
        tor_id TYPE zttm_gkot001-tor_id,
      END OF ty_gkot001 .
    TYPES:
      ty_t_doc_list TYPE STANDARD TABLE OF ty_doc_list .
    TYPES:
      ty_t_zgkot006 TYPE STANDARD TABLE OF zttm_gkot006 WITH DEFAULT KEY .

    CONSTANTS gc_gnre TYPE char5 VALUE 'GNRE' ##NO_TEXT.
    CONSTANTS gc_gnrenv TYPE char5 VALUE 'GGNRE' ##NO_TEXT.
    CONSTANTS gc_comp_gnre TYPE char5 VALUE 'CGNRE' ##NO_TEXT.
    CONSTANTS gc_cgnre TYPE char5 VALUE 'CGNRE' ##NO_TEXT.
    CONSTANTS gc_nfs TYPE char5 VALUE 'NFS' ##NO_TEXT.
    CONSTANTS gc_nfserv TYPE char5 VALUE 'NFSER' ##NO_TEXT.
    CONSTANTS gc_mime_type TYPE w3conttype VALUE 'application/pdf' ##NO_TEXT.
    CONSTANTS gc_name TYPE sdok_filnm VALUE 'File' ##NO_TEXT.
    CONSTANTS gc_directory TYPE char9 VALUE 'directory' ##NO_TEXT.
    CONSTANTS gc_anexos TYPE char6 VALUE 'Anexos' ##NO_TEXT.
    CONSTANTS gc_backup TYPE char6 VALUE 'Backup' ##NO_TEXT.
    CONSTANTS gc_msg_id TYPE symsgid VALUE 'ZTM_GESTAO_FRETE' ##NO_TEXT.
    CONSTANTS:
      BEGIN OF gc_msgs,
        of_nao_encontrada TYPE symsgno VALUE '132',
      END OF gc_msgs .

    METHODS constructor .
    METHODS get_data
      IMPORTING
        !iv_acckey       TYPE zi_tm_cockpit001-acckey
      EXPORTING
        !es_cockpit      TYPE zi_tm_cockpit001
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    METHODS add_file
      IMPORTING
        !iv_torid        TYPE /scmtms/tor_id
        !iv_filename     TYPE sdok_filnm
        !iv_atc_type     TYPE /bobf/attachment_type
        !iv_mime_type    TYPE w3conttype
        !iv_name         TYPE sdok_filnm
        !iv_data         TYPE xstring
        !iv_acckey       TYPE zi_tm_cockpit001-acckey
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    METHODS add_file_002
      IMPORTING
        !iv_acckey       TYPE zi_tm_cockpit001-acckey
        !iv_filename     TYPE sdok_filnm
        !iv_extension    TYPE zttm_gkot002-attach_extension
        !iv_atc_type     TYPE /bobf/attachment_type
        !iv_data         TYPE xstring
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    METHODS get_doc_list
      IMPORTING
        !iv_torid              TYPE /scmtms/tor_id
        !iv_acckey             TYPE zi_tm_cockpit001-acckey
      EXPORTING
        VALUE(et_atf_doc_list) TYPE ty_t_doc_list .
    METHODS get_doc_list_002
      IMPORTING
        !iv_acckey             TYPE zi_tm_cockpit001-acckey
      EXPORTING
        VALUE(et_atf_doc_list) TYPE zcltm_gestao_frete_a_mpc=>tt_getfilelist .
    METHODS get_file
      IMPORTING
        !iv_torid          TYPE /scmtms/tor_id
        !iv_file_key       TYPE /bobf/conf_key
        !iv_acckey         TYPE zi_tm_cockpit001-acckey
      RETURNING
        VALUE(rs_atf_file) TYPE /bobf/s_atf_file_content_k .
    METHODS get_file_002
      IMPORTING
        !iv_acckey         TYPE zi_tm_cockpit001-acckey
        !iv_attach_type    TYPE zttm_gkot002-attach_type
      RETURNING
        VALUE(rs_atf_file) TYPE /bobf/s_atf_file_content_k .
    METHODS get_directory_listing
      IMPORTING
        !iv_directory         TYPE epsdirnam
      EXPORTING
        !et_directory_content TYPE slandirt .
    METHODS process_dir
      IMPORTING
        !it_directory_content TYPE slandirt .
    METHODS process_file
      IMPORTING
        !it_arquivos TYPE slandirt
        !is_dir      TYPE slandir .
    METHODS read_file
      IMPORTING
        !is_dir_file        TYPE slandir
      RETURNING
        VALUE(rv_data_file) TYPE xstring .
    METHODS split_data
      IMPORTING
        !iv_file_title             TYPE epspath
      RETURNING
        VALUE(es_split_title_file) TYPE ty_split_data .
    METHODS get_fo
      IMPORTING
        !is_split_title_file TYPE ty_split_data
      RETURNING
        VALUE(rs_gkot001)    TYPE ty_gkot001 .
    METHODS transfer_file
      IMPORTING
        !is_source_directory TYPE epsdirnam
        !is_source_file      TYPE epsfilnam
        !is_target_directory TYPE epsdirnam
        !is_target_file      TYPE epsfilnam .
    METHODS get_msgs
      RETURNING
        VALUE(rt_msgs) TYPE bapiret2_tab .
    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_message
      CHANGING
        !ct_return TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA gs_log TYPE bapiret2 .
    CLASS-DATA gt_log TYPE bapiret2_t .
    DATA gt_gko_logs TYPE ty_t_zgkot006 .
    DATA gv_acckey TYPE zttm_gkot001-acckey .
ENDCLASS.



CLASS zcltm_atc_folder_fo IMPLEMENTATION.


  METHOD add_file.

    TYPES: BEGIN OF ty_ls_att_with_content.
             INCLUDE TYPE /scmtms/s_gw_gen_att.
    TYPES:   attachmenttocontent TYPE /scmtms/s_gw_gen_att_cont,
           END OF ty_ls_att_with_content.

    DATA: lo_message         TYPE REF TO /bobf/if_frw_message,
          lt_tor_key         TYPE /bobf/t_frw_key, "tor key of object wto which we attach the picture
          ls_tor_key         TYPE /bobf/s_frw_key,
          lv_action_key      TYPE /bobf/conf_key,
          lv_tor_key         TYPE /bobf/conf_key,
          lo_change          TYPE REF TO /bobf/if_tra_change,
          lt_failed_key      TYPE /bobf/t_frw_key,
          lt_mod             TYPE /bobf/t_frw_modification,
          ls_mod             TYPE /bobf/s_frw_modification,
          lv_rejected        TYPE boole_d,
          lr_action_par      TYPE REF TO /bobf/s_atf_a_create_file,
          lr_atf_root        TYPE REF TO /bobf/s_atf_root_k,
          ls_attachment_data TYPE ty_ls_att_with_content,
          ls_parameters      TYPE /bobf/s_atf_a_create_file,
          lt_document_data   TYPE /bobf/t_atf_document_k,
          lv_message         TYPE char200.

    DATA : lt_rej_bo_key TYPE /bobf/t_frw_key2,
           lt_bapiret    TYPE TABLE OF bapiret2.

    "Initiate service and transaction managers
    DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )."Srv Manager TOR object
    DATA(lo_tra_tor) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    lv_tor_key       = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = iv_torid ).

    IF lv_tor_key IS NOT INITIAL.

      APPEND VALUE #( key = lv_tor_key ) TO lt_tor_key.

      TRY.
          "find attachment key via the association
          lo_srv_tor->retrieve_by_association(
            EXPORTING
              iv_node_key    = /scmtms/if_tor_c=>sc_node-attachmentfolder               " Node
              it_key         = lt_tor_key                                               " Key Table
              iv_association = /scmtms/if_tor_c=>sc_association-root-attachmentfolder   " Association
            IMPORTING
              et_target_key  = DATA(lt_atf_key)                                         " Key Table
              et_failed_key  = lt_failed_key ).                                         " Key Table

        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          RETURN.
      ENDTRY.

      ls_attachment_data-attachmenttocontent-content = iv_data.
      ls_attachment_data-mime_type                   = iv_mime_type.
      ls_attachment_data-name                        = iv_name.

      "fill the parameter table
      CREATE DATA lr_action_par.
      GET REFERENCE OF ls_parameters INTO lr_action_par.
      ls_parameters-alternative_name                 = iv_filename.
      ls_parameters-content                          = ls_attachment_data-attachmenttocontent-content.
      ls_parameters-file_name                        = iv_filename.
      ls_parameters-mime_code                        = ls_attachment_data-mime_type.
      ls_parameters-name                             = ls_attachment_data-name.
      ls_parameters-description_language_code        = sy-langu.
*      ls_parameters-description                      = ls_attachment_data-name.
      ls_parameters-description                      = iv_acckey.
*      ls_parameters-description_content              = ls_attachment_data-name.
      ls_parameters-description_content              = iv_acckey.
      ls_parameters-attachment_type                  = iv_atc_type.
      ls_parameters-attachment_schema                = 'DEFAULT'.

      IF lt_atf_key[] IS INITIAL.
        DATA: ls_atf_root        TYPE /bobf/s_atf_root_k.

        CREATE DATA lr_atf_root.
        GET REFERENCE OF ls_atf_root INTO lr_atf_root.
        ls_atf_root-key        = lo_srv_tor->get_new_key( ).
        ls_atf_root-parent_key = lv_tor_key.
        ls_atf_root-root_key   = lv_tor_key.

        /scmtms/cl_mod_helper=>mod_create_single(
            EXPORTING
              is_data        = ls_atf_root
              iv_parent_key  = ls_atf_root-root_key
              iv_root_key    = ls_atf_root-root_key
              iv_node        = /scmtms/if_tor_c=>sc_node-attachmentfolder
              iv_source_node = /scmtms/if_tor_c=>sc_node-root
              iv_association = /scmtms/if_tor_c=>sc_association-root-attachmentfolder
            IMPORTING
              es_mod         = ls_mod ).

        INSERT ls_mod INTO TABLE lt_mod.

        TRY.
            lo_srv_tor->modify( EXPORTING it_modification = lt_mod
                                IMPORTING eo_change       = lo_change                   " Interface for transaction change objects
                                          eo_message      = lo_message ).               " Changes
          CATCH /bobf/cx_frw_contrct_violation.                                         " Caller violates a BOPF contract
            RETURN.
        ENDTRY.

        IF lo_message IS NOT INITIAL.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_bapiret ).
          IF line_exists( lt_bapiret[ type = if_xo_const_message=>error ] )
          OR line_exists( lt_bapiret[ id = '/SCMTMS/MSG' number = '252' ] )
          OR line_exists( lt_bapiret[ id = '/SCMTMS/MSG' number = '253' ] ) .
            rt_return = CORRESPONDING #( lt_bapiret ).
            RETURN.
          ENDIF.
        ENDIF.

        lo_tra_tor->save( IMPORTING ev_rejected = lv_rejected                           " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
                                    eo_change   = lo_change                             " Interface for transaction change objects
                                    eo_message  = lo_message ).                         " Interface of Message Object

        IF lo_message IS NOT INITIAL.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_bapiret ).
          IF line_exists( lt_bapiret[ type = if_xo_const_message=>error ] )
          OR line_exists( lt_bapiret[ id = '/SCMTMS/MSG' number = '252' ] )
          OR line_exists( lt_bapiret[ id = '/SCMTMS/MSG' number = '253' ] ) .
            rt_return = CORRESPONDING #( lt_bapiret ).
            RETURN.
          ENDIF.
        ENDIF.

        INSERT VALUE #( key = lr_atf_root->key ) INTO TABLE lt_atf_key.
      ENDIF.

      CALL METHOD /scmtms/cl_common_helper=>get_do_keys_4_action
        EXPORTING
          iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
          iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
          iv_do_action_key    = /bobf/if_attachment_folder_c=>sc_action-root-create_file
        IMPORTING
          ev_action_key       = lv_action_key.

      CALL METHOD lo_srv_tor->do_action
        EXPORTING
          iv_act_key    = lv_action_key
          it_key        = lt_atf_key
          is_parameters = lr_action_par
        IMPORTING
          et_failed_key = DATA(lt_failed_key_atf)
          eo_change     = lo_change
          eo_message    = lo_message.

      IF lt_failed_key_atf[] IS INITIAL.
        lo_tra_tor->save( IMPORTING ev_rejected         = lv_rejected
                                    eo_change           = lo_change
                                    eo_message          = lo_message
                                    et_rejecting_bo_key = lt_rej_bo_key ).
      ENDIF.

      IF lo_message IS NOT INITIAL.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                               CHANGING  ct_bapiret2 = lt_bapiret ).
        IF lt_bapiret[] IS NOT INITIAL.
          rt_return = CORRESPONDING #( lt_bapiret ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD add_file_002.

    DATA: ls_002 TYPE zttm_gkot002.

    FREE: rt_return.

    ls_002-acckey           = iv_acckey.
    ls_002-attach_type      = SWITCH #( iv_atc_type
                                        WHEN 'GNRE'  THEN 2
                                        WHEN 'CGNRE' THEN 3
                                        WHEN 'NFS'   THEN 4 ).
    ls_002-attach_name      = iv_filename.
    ls_002-attach_content   = iv_data.
    ls_002-attach_extension = iv_extension.
    ls_002-credat           = sy-datum.
    ls_002-cretim           = sy-uzeit.
    ls_002-crenam           = sy-uname.

    MODIFY zttm_gkot002 FROM ls_002.

    IF sy-subrc EQ 0.
      COMMIT WORK.
    ELSE.
      " Falha ao anexar arquivo.
      rt_return = VALUE #( ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '134' ) ).
      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


  METHOD get_doc_list.

    DATA: lt_doc           TYPE        /bobf/t_atf_document_k.

    "Initiate service and transaction managers
    DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ). "Srv Manager TOR object
    DATA(lv_tor_key) = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = iv_torid ).

    /scmtms/cl_common_helper=>get_do_keys_4_rba( EXPORTING  iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                            iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
                                                            iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-root
                                                            iv_do_assoc_key     = /bobf/if_attachment_folder_c=>sc_association-root-document
                                                  IMPORTING ev_node_key         = DATA(lv_do_root_key)
                                                            ev_assoc_key        = DATA(lv_do_doc) ).

    TRY.

        lo_srv_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                       it_key         = VALUE #( ( key = lv_tor_key ) )
                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-attachmentfolder
                                             IMPORTING eo_message     = DATA(lo_message)
                                                       et_target_key  = DATA(lt_target_key) ).

        CHECK lt_target_key[] IS NOT INITIAL.

        lo_srv_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-attachmentfolder
                                                       it_key         = lt_target_key
                                                       iv_fill_data   = abap_true
                                                       iv_association = lv_do_doc
                                             IMPORTING eo_message     = lo_message
                                                       et_data        = lt_doc ).

        DELETE lt_doc WHERE description <> iv_acckey.

      CATCH /bobf/cx_frw_contrct_violation.                                           " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    IF lt_doc[] IS NOT INITIAL.
      et_atf_doc_list = VALUE #( FOR <fs_doc_list> IN lt_doc
                               ( filekey = <fs_doc_list>-key
                                 name    = <fs_doc_list>-alternative_name
                                 atctype = <fs_doc_list>-attachment_type ) ). "#EC CI_VALPAR
    ENDIF.

*    /scmtms/cl_common_helper=>get_do_keys_4_action( EXPORTING iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                              iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
*                                                              iv_do_action_key    = /bobf/if_attachment_folder_c=>sc_action-root-create_file
*                                                    IMPORTING ev_action_key       = lv_do_action_key ).





*    /scmtms/cl_common_helper=>get_do_keys_4_rba(
*       EXPORTING
*         iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*         iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
*         iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-root
*       IMPORTING
*         ev_node_key         = DATA(lv_attachment_node_root_key) ).
*
**     get atf documents (needed because root might be there but without documents attached)
*    /scmtms/cl_common_helper=>get_do_keys_4_rba(
*      EXPORTING
*        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*        iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
*        iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-document
*        iv_do_assoc_key     = /bobf/if_attachment_folder_c=>sc_association-root-document_list
*      IMPORTING
*        ev_node_key         = DATA(lv_attachment_node_do_key)
*        ev_assoc_key        = DATA(lv_attachment_node_assoc_key) ).
*
*    lo_srv_tor->retrieve_by_association(
*      EXPORTING
*        iv_node_key             = lv_do_atf_node_key                                  "/scmtms/if_tor_c=>sc_node-attachmentfolder    " Node
*        it_key                  = lt_atf_key                                          " Key Table
*        iv_association          = lv_do_atf_root_docs_assoc                           " Association
*        iv_fill_data            = abap_true
*      IMPORTING
*        et_data                 = rt_atf_doc_list ).                                  " Return Data


*    /scmtms/cl_common_helper=>get_do_keys_4_rba(
*      EXPORTING
*        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key                                 " Business Object
*        iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder                  " Host BO Node Key
*        iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-document              " DO Node Key
*        iv_do_assoc_key     = /bobf/if_attachment_folder_c=>sc_association-root-document  " DO Association Key
*      IMPORTING
*        ev_node_key         = DATA(lv_attachment_node_do_key)                             " Runtime Node Key
*        ev_assoc_key        = DATA(lv_attachment_node_assoc_key) ).                       " Runtime Association Key
*
*    /scmtms/cl_common_helper=>get_do_keys_4_rba(
*      EXPORTING
*        iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key                                 " Business Object
*        iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder                  " Host BO Node Key
*        iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-document              " DO Node Key
*        iv_do_assoc_key     = /bobf/if_attachment_folder_c=>sc_association-root-document  " DO Association Key
*      IMPORTING
*        ev_node_key         = DATA(lv_attachment_node_do_key)                             " Runtime Node Key
*        ev_assoc_key        = DATA(lv_attachment_node_assoc_key) ).                       " Runtime Association Key

*    /scmtms/cl_tcc_calc_utility=>get_bo_do_assoc(
*      EXPORTING
*        iv_bo_key        = /scmtms/if_tor_c=>sc_bo_key                                " Business Object
*        iv_node_key      = /scmtms/if_tor_c=>sc_node-root                             " Node
*        iv_do_key        = /scmtms/if_bvatf_c=>sc_bo_key
*      IMPORTING
*        ev_root_node_key = DATA(lv_do_key)                                            " NodeID
*        ev_assoc_key     = DATA(lv_bo_do_assoc_key) ).                                " Node
*
*    DATA(lv_root_node_key) = /scmtms/cl_common_helper=>get_do_entity_key( iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                                          iv_host_do_node_key = lv_do_key
*                                                                          iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
*                                                                          iv_do_entity_key    = /scmtms/if_bvatf_c=>sc_node-root ).
*
*    DATA(lv_doc_node_key)  = /scmtms/cl_common_helper=>get_do_entity_key( iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                                          iv_host_do_node_key = lv_do_key
*                                                                          iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
*                                                                          iv_do_entity_key    = /scmtms/if_bvatf_c=>sc_node-document ).
*
*    DATA(lv_file_node_key) = /scmtms/cl_common_helper=>get_do_entity_key( iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
*                                                                          iv_host_do_node_key = lv_do_key
*                                                                          iv_do_entity_cat    = /bobf/if_conf_c=>sc_content_nod
*                                                                          iv_do_entity_key    = /scmtms/if_bvatf_c=>sc_node-file_content ).

*    lo_srv_tor->retrieve_by_association(
*      EXPORTING
*        iv_node_key             = lv_do_atf_node_key                                  "/scmtms/if_tor_c=>sc_node-attachmentfolder    " Node
*        it_key                  = lt_atf_key                                          " Key Table
*        iv_association          = lv_do_atf_root_docs_assoc                           " Association
*        iv_fill_data            = abap_true
*      IMPORTING
*        et_data                 = rt_atf_doc_list ).                                  " Return Data





*    DATA(lo_atf) = NEW cl_ehfnd_atf_mngr( iv_bo_key       = /scmtms/if_tor_c=>sc_bo_key
*                                          iv_do_node_key  = /scmtms/if_tor_c=>sc_node-root ).
*
*    lo_atf->get_document_list_for_do_node( io_do_node =  ).


  ENDMETHOD.


  METHOD get_doc_list_002.

    FREE: et_atf_doc_list.

* ----------------------------------------------------------------------
* Recupera lista de arquivos
* ----------------------------------------------------------------------
    SELECT *
      FROM zttm_gkot002
      INTO TABLE @DATA(lt_002)
      WHERE acckey = @iv_acckey.              "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    et_atf_doc_list = VALUE #( FOR ls_002 IN lt_002 ( acckey  = iv_acckey
                                                      filekey = ls_002-attach_type
                                                      name    = ls_002-attach_name
                                                      atctype = SWITCH #( ls_002-attach_type
                                                                          WHEN 2 THEN 'GNRE'
                                                                          WHEN 3 THEN 'CGNRE'
                                                                          WHEN 4 THEN 'NFS' ) ) ).

  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD get_file.

    DATA: lt_doc  TYPE /bobf/t_atf_document_k,
          lt_file TYPE /bobf/t_atf_file_content_k.

    " Iniciar Gerenciadores de Serviços e Transações
    DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ). "Srv Manager TOR object

    " Busca Chave da OF Baseada no TORID
    DATA(lv_tor_key) = /scmtms/cl_tor_helper_root=>return_key_for_torid( iv_torid = iv_torid ).

    " Busca Associação Entre TOR Root e Pasta de Anexos - Retorna Lista de Arquivos
    /scmtms/cl_common_helper=>get_do_keys_4_rba( EXPORTING  iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                            iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
                                                            iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-root
                                                            iv_do_assoc_key     = /bobf/if_attachment_folder_c=>sc_association-root-document
                                                  IMPORTING ev_node_key         = DATA(lv_do_root_key)
                                                            ev_assoc_key        = DATA(lv_do_doc) ).

    " Busca Associação Entre Pasta de anexos e Conteúdo do arquivo - Retorna Detalhes do arquivo
    /scmtms/cl_common_helper=>get_do_keys_4_rba( EXPORTING  iv_host_bo_key      = /scmtms/if_tor_c=>sc_bo_key
                                                            iv_host_do_node_key = /scmtms/if_tor_c=>sc_node-attachmentfolder
                                                            iv_do_node_key      = /bobf/if_attachment_folder_c=>sc_node-document
                                                            iv_do_assoc_key     = /bobf/if_attachment_folder_c=>sc_association-document-file_content
                                                  IMPORTING ev_node_key         = DATA(lv_do_doc_key)
                                                            ev_assoc_key        = DATA(lv_do_file) ).

    TRY.

        " Retorna Chave da Pasta de Anexos
        lo_srv_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                                       it_key         = VALUE #( ( key = lv_tor_key ) )
                                                       iv_association = /scmtms/if_tor_c=>sc_association-root-attachmentfolder
                                             IMPORTING eo_message     = DATA(lo_message)
                                                       et_target_key  = DATA(lt_target_key) ).

        CHECK lt_target_key[] IS NOT INITIAL.

        " Retorna Chaves da Lista de Arquivos
        lo_srv_tor->retrieve_by_association( EXPORTING iv_node_key    = /scmtms/if_tor_c=>sc_node-attachmentfolder
                                                       it_key         = lt_target_key
                                                       iv_fill_data   = abap_true
                                                       iv_association = lv_do_doc
                                             IMPORTING eo_message     = lo_message
                                                       et_data        = lt_doc
                                                       et_target_key  = DATA(lt_doc_target_key) ).

        CHECK lt_doc_target_key[] IS NOT INITIAL.

        " Retorna Conteúdo dos Arquivos
        lo_srv_tor->retrieve_by_association( EXPORTING iv_node_key    = lv_do_doc_key
                                                       it_key         = lt_doc_target_key
                                                       iv_fill_data   = abap_true
                                                       iv_association = lv_do_file
                                             IMPORTING eo_message     = lo_message
                                                       et_data        = lt_file ).

      CATCH /bobf/cx_frw_contrct_violation.                                           " Caller violates a BOPF contract
        RETURN.
    ENDTRY.

    " Prepara Retorno
    IF iv_file_key IS NOT INITIAL.
      IF line_exists( lt_file[ key = iv_file_key ] ).
        rs_atf_file = lt_file[ key = iv_file_key ].
        IF line_exists( lt_doc[ key = iv_file_key ] ).
          rs_atf_file-file_name = lt_doc[ key = iv_file_key ]-alternative_name.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_file_002.

    FREE: rs_atf_file.

* ----------------------------------------------------------------------
* Recupera arquivo
* ----------------------------------------------------------------------
    SELECT SINGLE *
      FROM zttm_gkot002
      INTO @DATA(ls_002)
      WHERE acckey = @iv_acckey
        AND attach_type = @iv_attach_type.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    rs_atf_file-key        = space.
    rs_atf_file-parent_key = space.
    rs_atf_file-root_key   = space.
    rs_atf_file-file_name  = ls_002-attach_name.
    rs_atf_file-content    = ls_002-attach_content.

    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = ls_002-attach_extension
      IMPORTING
        mimetype  = rs_atf_file-mime_code.

  ENDMETHOD.


  METHOD get_data.

    FREE: es_cockpit, rt_return.

    " Recupera a linha do cockpit
    SELECT SINGLE *
         FROM zi_tm_cockpit001
         WHERE acckey = @iv_acckey
         INTO @es_cockpit.

    IF sy-subrc NE 0.
      " Linha do relatório não encontrada para chave de acesso &1.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '117' message_v1 = iv_acckey ) ).
      RETURN.
    ENDIF.

    IF es_cockpit-tor_id IS INITIAL.
      " Linha do relatório sem Ordem de Frete.
      rt_return = VALUE #( BASE rt_return ( type = 'E' id = 'ZTM_GESTAO_FRETE' number = '118' ) ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    CLEAR: gs_log,
           gt_log[],
           gt_gko_logs[],
           gv_acckey.

  ENDMETHOD.


  METHOD get_directory_listing.

    cl_cts_language_file_io=>get_directory_listing( EXPORTING  im_directory         = iv_directory          " Directory name
                                                    IMPORTING  ex_directory_content = et_directory_content  " Directory Contents
                                                    EXCEPTIONS too_many_read_errors = 1                     " Too Many Read Errors
                                                               empty_directory_list = 2                     " Empty Directory
                                                               directory_read_error = 3                     " Error when Reading Directory
                                                               OTHERS               = 4 ).

    IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*     WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDMETHOD.


  METHOD get_fo.

    DATA: lv_data_emi TYPE ze_gko_dtemi,
          lv_nfnum    TYPE char9.

    lv_data_emi = |{ is_split_title_file-dt_emi+4(4) }{ is_split_title_file-dt_emi+2(2) }{ is_split_title_file-dt_emi(2) }|.
    lv_nfnum = |{ is_split_title_file-nfnum ALPHA = IN }|.

    SELECT SINGLE acckey,
                  tor_id
      FROM zttm_gkot001
      INTO @DATA(ls_gkot001)
     WHERE dtemi          EQ @lv_data_emi
       AND nfnum9         EQ @lv_nfnum
       AND emit_cnpj_cpf  EQ @is_split_title_file-cnpj_tp. "#EC CI_SEL_NESTED

    IF sy-subrc IS NOT INITIAL.
      SELECT SINGLE acckey,
                    tor_id
        FROM zttm_gkot001
        INTO @ls_gkot001
       WHERE dtemi          EQ @lv_data_emi
         AND prefno         EQ @lv_nfnum
         AND emit_cnpj_cpf  EQ @is_split_title_file-cnpj_tp.
    ENDIF.


    IF sy-subrc IS INITIAL.

      rs_gkot001-acckey = ls_gkot001-acckey.
      rs_gkot001-tor_id = ls_gkot001-tor_id.

    ELSE.

      APPEND INITIAL LINE TO gt_log ASSIGNING FIELD-SYMBOL(<fs_log>).

      <fs_log>-id     = gc_msg_id.
      <fs_log>-number = gc_msgs-of_nao_encontrada.
      <fs_log>-type   = if_xo_const_message=>error.

      MESSAGE ID <fs_log>-id
            TYPE <fs_log>-type
          NUMBER <fs_log>-number
            INTO <fs_log>-message.

    ENDIF.

  ENDMETHOD.


  METHOD get_msgs.

    rt_msgs[] = gt_log[].

  ENDMETHOD.


  METHOD process_dir.

    DATA: lv_directory TYPE epsdirnam.

    DATA(lt_dir) = VALUE slandirt( FOR <fs_directory> IN it_directory_content
                                   WHERE ( type_long = gc_directory )
                                 ( CORRESPONDING #( <fs_directory> ) ) ).

    LOOP AT lt_dir ASSIGNING FIELD-SYMBOL(<fs_dir>).

      lv_directory = |{ <fs_dir>-dirname && |/| && <fs_dir>-name && |/| && gc_anexos }|.

      get_directory_listing( EXPORTING iv_directory         = lv_directory          " directory name
                             IMPORTING et_directory_content = DATA(lt_dir_anexos) )." Conteúdo de diretório

      DELETE lt_dir_anexos WHERE name EQ '.' OR
                                 name EQ '..'.

      IF lt_dir_anexos[] IS INITIAL.
        CONTINUE.
      ENDIF.

      process_file( EXPORTING it_arquivos = lt_dir_anexos                           " Conteúdo de diretório
                              is_dir      = <fs_dir>   ).                           " Estrutura de uma entrada diretório sistema de file


    ENDLOOP.
  ENDMETHOD.


  METHOD process_file.

    DATA: lv_atc_type    TYPE /bobf/attachment_type,
          lv_filename    TYPE sdok_filnm,
          lv_mime_type   TYPE w3conttype,
          lv_name        TYPE sdok_filnm,
          lv_source_file TYPE epsfilnam,
          lv_target_file TYPE epsfilnam,
          lv_desc_msg    TYPE zttm_gkot006-desc_codigo,
          ls_dir         TYPE slandir.

    ls_dir = is_dir.

    LOOP AT it_arquivos ASSIGNING FIELD-SYMBOL(<fs_arq>) WHERE type_long(4) EQ 'file'.

      " Separa o Nome do Arquivo
      DATA(ls_title_file) = split_data( iv_file_title = <fs_arq>-name ).

      " Busca Ordem de Frete
      DATA(ls_gkot001)    = get_fo( is_split_title_file = ls_title_file ).
      IF ls_gkot001-tor_id IS INITIAL.
        CONTINUE.
      ENDIF.

      DATA(lo_cl_gko_process) = NEW zcltm_gko_process( iv_acckey = ls_gkot001-acckey ).

      " Carrega Dados do Arquivo
      DATA(lv_data_file)  = read_file( is_dir_file = <fs_arq> ).
      IF lv_data_file IS INITIAL.
        lv_desc_msg = ls_title_file-tp_doc.
        lo_cl_gko_process->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_carregar_arquivo " Erro ao carregar arquivo
                                                 iv_desc_cod = lv_desc_msg ).
        CONTINUE.
      ENDIF.

      " Nome do Arquivo
      lv_filename         = <fs_arq>-name.

      " Tipo do Arquivo
      lv_atc_type = SWITCH #( ls_title_file-tp_doc
                              WHEN gc_gnrenv    THEN gc_gnre            " GNRE
                              WHEN gc_comp_gnre THEN gc_cgnre           " Comprovante de Pagamento da Guia
                              WHEN gc_nfserv    THEN gc_nfs ).          " Nota fiscal de Serviço

      " Adiciona Arquivo na Ordem de Frete
      DATA(lt_return)     = add_file( iv_torid     = ls_gkot001-tor_id
                                      iv_filename  = lv_filename
                                      iv_atc_type  = lv_atc_type
                                      iv_mime_type = gc_mime_type
                                      iv_name      = gc_name
                                      iv_data      = lv_data_file
                                      iv_acckey    = ls_gkot001-acckey ).

      IF line_exists( lt_return[ type = if_xo_const_message=>error ] ).
        lo_cl_gko_process->set_status( EXPORTING iv_status   = zcltm_gko_process=>gc_codstatus-erro_carregar_arquivo " Erro ao carregar arquivo
                                                 it_bapi_ret = lt_return ).
        CONTINUE.
      ENDIF.

      CLEAR: lv_data_file,
             lv_source_file.

      ls_dir-dirname = |{ ls_dir-dirname }/{ ls_dir-name }/{ gc_backup }|.
      lv_source_file = lv_target_file = lv_filename.

      " Transfere o arquivo
      transfer_file( EXPORTING is_source_directory = <fs_arq>-dirname   " Source: Directory
                               is_source_file      = lv_source_file     " Source: File Name
                               is_target_directory = ls_dir-dirname     " Target: Directory
                               is_target_file      = lv_target_file ).  " Target: File Name

    ENDLOOP.

  ENDMETHOD.


  METHOD read_file.

    DATA: lv_file_s TYPE string,
          lv_mess   TYPE string.

    CLEAR: lv_file_s.
    lv_file_s = |{ is_dir_file-dirname }/{ is_dir_file-name }|.

    OPEN DATASET  lv_file_s FOR INPUT IN BINARY MODE MESSAGE lv_mess.

    IF sy-subrc IS INITIAL.

      READ DATASET  lv_file_s INTO rv_data_file.
      CLOSE DATASET lv_file_s.

    ENDIF.

  ENDMETHOD.


  METHOD split_data.

*    SPLIT iv_file_title AT '_' INTO es_split_title_file-tp_doc
*                                    es_split_title_file-dt_emi
*                                    es_split_title_file-cnpj_tp
*                                    es_split_title_file-nfnum.

    es_split_title_file-tp_doc  = iv_file_title(5).
    es_split_title_file-dt_emi  = iv_file_title+5(8).
    es_split_title_file-cnpj_tp = iv_file_title+13(14).
    es_split_title_file-nfnum   = iv_file_title+27(9).

  ENDMETHOD.


  METHOD transfer_file.

    DATA: lv_source_file TYPE string.
*
*    cl_cts_language_file_io=>copy_files_local(
*      EXPORTING
*        im_source_file           = is_source_file       " Source: File Name
*        im_source_directory      = is_source_directory  " Source: Directory
*        im_target_file           = is_target_file       " Target: File Name
*        im_target_directory      = is_target_directory  " Target: Directory
*        im_overwrite_mode        = 'F'                  " Overwrite mode
*      IMPORTING
*        ex_file_size             = DATA(lv_file_size)   " File size
*      EXCEPTIONS
*        open_input_file_failed   = 1                    " Could Not Open Source File
*        open_output_file_failed  = 2                    " Could Not Create Target File
*        write_block_failed       = 3                    " Error when Writing to Target File
*        read_block_failed        = 4                    " Error when Reading Source File
*        close_output_file_failed = 5                    " Error when Closing Target File
*        OTHERS                   = 6 ).
*
*    IF sy-subrc <> 0.
*
*      APPEND INITIAL LINE TO gt_log ASSIGNING FIELD-SYMBOL(<fs_log>).
*      <fs_log>-id         = sy-msgid.
*      <fs_log>-number     = sy-msgno.
*      <fs_log>-type       = sy-msgty.
*      <fs_log>-message_v1 = sy-msgv1.
*      <fs_log>-message_v2 = sy-msgv2.
*      <fs_log>-message_v3 = sy-msgv3.
*      <fs_log>-message_v4 = sy-msgv4.
*
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO <fs_log>-message.
*
*      RETURN.
*    ELSE.
*
*    ENDIF.


    DATA: lv_source_file_path   TYPE trfile,
          lv_source_file_size   TYPE epsfilsiz,
          lv_target_file_path   TYPE trfile,
          lv_target_file_size   TYPE epsfilsiz,
          lv_target_file_exists TYPE c.

    DATA: lv_overwrite TYPE c.

    DATA: lv_eof_reached   TYPE c,
          lv_buffer(20480),
          lv_buflen        TYPE i.

* check existence and file size of the source file
    CALL FUNCTION 'EPS_GET_FILE_ATTRIBUTES'
      EXPORTING
        file_name              = is_source_file
        dir_name               = is_source_directory
      IMPORTING
        file_size              = lv_source_file_size
      EXCEPTIONS
        read_directory_failed  = 1
        read_attributes_failed = 2
        OTHERS                 = 3.

    CHECK sy-subrc EQ 0.

* check existence and file size of the target file
    CLEAR lv_target_file_exists.
    CALL FUNCTION 'EPS_GET_FILE_ATTRIBUTES'
      EXPORTING
        file_name              = is_target_file
        dir_name               = is_target_directory
      IMPORTING
        file_size              = lv_target_file_size
      EXCEPTIONS
        read_directory_failed  = 1
        read_attributes_failed = 2
        OTHERS                 = 3.

    IF sy-subrc EQ 0.
      CLEAR: lv_source_file.

      lv_source_file = |{ is_source_directory }/{ is_source_file }|.
      DELETE DATASET lv_source_file.
      RETURN.
    ENDIF.

* build full file path
    CALL 'BUILD_DS_SPEC' ID 'FILENAME' FIELD is_source_file
                         ID 'PATH'     FIELD is_source_directory
                         ID 'RESULT'   FIELD lv_source_file_path.

    CALL 'BUILD_DS_SPEC' ID 'FILENAME' FIELD is_target_file
                         ID 'PATH'     FIELD is_target_directory
                         ID 'RESULT'   FIELD lv_target_file_path.

* open source and target files and start copying
    CLEAR: lv_source_file_path.
    lv_source_file_path = |{ is_source_directory }/{ is_source_file }|.
    OPEN DATASET lv_source_file_path FOR INPUT IN BINARY MODE.
    CHECK sy-subrc EQ 0.

    CLEAR: lv_target_file_path.
    lv_target_file_path = |{ is_target_directory }/{ is_target_file }|.
    OPEN DATASET lv_target_file_path FOR OUTPUT IN BINARY MODE.
    CHECK sy-subrc EQ 0.

    CLEAR lv_eof_reached.

    DO.
      CLEAR lv_buffer.

      READ DATASET lv_source_file_path
              INTO lv_buffer LENGTH lv_buflen.

      IF sy-subrc = 4.
        lv_eof_reached = 'X'.
      ENDIF.

      TRANSFER lv_buffer TO lv_target_file_path
        LENGTH lv_buflen.

      IF lv_eof_reached = 'X'.  EXIT.  ENDIF.
    ENDDO.

    CLOSE DATASET lv_source_file_path.
    CLOSE DATASET lv_target_file_path.

    CLEAR: lv_source_file.

    lv_source_file = |{ is_source_directory }/{ is_source_file }|.
    DELETE DATASET lv_source_file.

  ENDMETHOD.

  METHOD format_message.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
