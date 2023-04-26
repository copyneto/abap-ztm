CLASS zcltm_cockpit_prestacao DEFINITION INHERITING FROM cl_abap_behv
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_lc_status,
        esboco           TYPE /scmtms/tor_lc_status VALUE '00' ##NO_TEXT,
        novo             TYPE /scmtms/tor_lc_status VALUE '01' ##NO_TEXT,
        em_processamento TYPE /scmtms/tor_lc_status VALUE '02' ##NO_TEXT,
        concluido        TYPE /scmtms/tor_lc_status VALUE '05' ##NO_TEXT,
        cancelado        TYPE /scmtms/tor_lc_status VALUE '10' ##NO_TEXT,
      END OF gc_lc_status,

      BEGIN OF gc_cds,
        cockpit  TYPE string VALUE 'COCKPIT',              " Cockpit
        execucao TYPE string VALUE 'EXECUCAO',             " Execução
      END OF gc_cds,

      BEGIN OF gc_permission,
        processar      TYPE activ_auth VALUE '02' ##NO_TEXT,
        inserir_evento TYPE activ_auth VALUE '76' ##NO_TEXT,
        definir_status TYPE activ_auth VALUE 'A3' ##NO_TEXT,
        imprimir       TYPE activ_auth VALUE '04' ##NO_TEXT,
      END OF gc_permission.

    TYPES:
      ty_reported TYPE RESPONSE FOR REPORTED EARLY zi_tm_cockpit_prestacao_contas,

      BEGIN OF ty_parameter,
        r_auart TYPE RANGE OF vbak-auart,
      END OF ty_parameter.

    DATA:
      gs_parameter  TYPE ty_parameter.

    "! Chama função remota para mudar de status
    "! @parameter iv_actvt | Atividade
    "! @parameter ev_ok | Mensagem de sucesso
    "! @parameter et_return | Mensagens de retorno
    METHODS check_permission
      IMPORTING iv_actvt     TYPE activ_auth
      EXPORTING ev_ok        TYPE flag
                et_return    TYPE bapiret2_t
      RETURNING VALUE(rv_ok) TYPE flag.

    "! Chama função remota para mudar de status
    "! @parameter iv_FreightOrderUUID | ID da Ordem de Frete
    "! @parameter iv_status | Novo status
    "! @parameter et_return | Mensagens de retorno
    METHODS call_change_order_status
      IMPORTING iv_FreightOrderUUID TYPE /bobf/conf_key
                iv_status           TYPE /scmtms/tor_lc_status
      EXPORTING et_return           TYPE bapiret2_t.

    "! Chama função remota para mudar de status da unidade de frete
    "! @parameter iv_FreightOrderUUID | ID da Ordem de Frete
    "! @parameter iv_FreightUnitUUID | ID da Ordem de Frete
    "! @parameter iv_transpordeventcode | Novo status
    "! @parameter et_return | Mensagens de retorno
    METHODS call_insert_unit_event_status
      IMPORTING iv_FreightOrderUUID   TYPE /bobf/conf_key
                iv_FreightUnitUUID    TYPE /bobf/conf_key
                iv_transpordeventcode TYPE zi_tm_cockpit_event_popup-transpordeventcode
      EXPORTING et_return             TYPE bapiret2_t.

    "! Chama função para verificar disponibilidade de troca de status
    "! @parameter iv_FreightOrderUUID | ID da Ordem de Frete
    "! @parameter iv_status | Novo status
    "! @parameter et_return | Mensagens de retorno
    METHODS check_change_order_status
      IMPORTING iv_FreightOrderUUID TYPE /bobf/conf_key
                iv_status           TYPE /scmtms/tor_lc_status
      EXPORTING et_return           TYPE bapiret2_t.

    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING it_return   TYPE bapiret2_t
      EXPORTING es_reported TYPE ty_reported.

    "! Mudar status da Ordem de Frete
    "! @parameter iv_FreightOrderUUID | ID da Ordem de Frete
    "! @parameter iv_status | Novo status
    "! @parameter et_return | Mensagens de retorno
    METHODS change_order_status
      IMPORTING iv_FreightOrderUUID TYPE /bobf/conf_key
                iv_status           TYPE /scmtms/tor_lc_status
      EXPORTING et_return           TYPE bapiret2_t.

    "! Mudar status da Unidade de Frete
    "! @parameter iv_FreightOrderUUID | ID da Ordem de Frete
    "! @parameter iv_FreightUnitUUID | ID da Unidade de Frete
    "! @parameter iv_transpordeventcode | Novo status
    "! @parameter et_return | Mensagens de retorno
    METHODS insert_unit_event_status
      IMPORTING iv_FreightOrderUUID   TYPE /bobf/conf_key
                iv_FreightUnitUUID    TYPE /bobf/conf_key
                iv_transpordeventcode TYPE zi_tm_cockpit_event_popup-transpordeventcode
      EXPORTING et_return             TYPE bapiret2_t.


    "! Recupera arquivo de impressão
    "! @parameter iv_FreightOrderUUID | ID da Ordem de Frete
    "! @parameter iv_FreightUnitUUID | ID da Unidade de Frete
    "! @parameter iv_PrintName | Nome da impressão
    "! @parameter ev_filename | Nome do arquivo
    "! @parameter ev_file | Arquivo em binário
    "! @parameter et_return | Mensagens de retorno
    METHODS get_print
      IMPORTING iv_FreightOrderUUID TYPE /bobf/conf_key
                iv_FreightUnitUUID  TYPE /bobf/conf_key
                iv_PrintName        TYPE ppftttcu-name
      EXPORTING ev_filename         TYPE string
                ev_file             TYPE xstring
                et_return           TYPE bapiret2_t.

    "! Recupera tipo de formulário
    "! @parameter iv_PrintName | Nome da impressão
    "! @parameter ev_formname| Nome do formulário
    "! @parameter eo_printout | Dados de formulário
    "! @parameter et_return | Mensagens de retorno
    METHODS get_print_loadout
      IMPORTING iv_PrintName TYPE ppftttcu-name
      EXPORTING ev_formname  TYPE fpname
                eo_printout  TYPE REF TO /scmtms/cl_printout
                et_return    TYPE bapiret2_t.

    "! Ler as mensagens geradas pelo processamento
    "! @parameter p_task |Noma da task executada
    CLASS-METHODS setup_messages
      IMPORTING p_task TYPE clike.

    "! Retorna as mensagens geradas durante o processamento
    "! @parameter et_messages | Lista de mensagens
    CLASS-METHODS get_messages
      EXPORTING et_messages TYPE bapiret2_t.

    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_message
      CHANGING ct_return TYPE bapiret2_t.

    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING is_param TYPE ztca_param_val
      EXPORTING et_value TYPE any.

    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING es_parameter TYPE ty_parameter
                et_return    TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
      "!Armazenamento das mensagens de processamento
      gt_messages   TYPE STANDARD TABLE OF bapiret2,

      "!Flag para sincronizar o processamento da função de criação de ordens de produção
      gv_wait_async TYPE abap_bool.


ENDCLASS.


CLASS zcltm_cockpit_prestacao IMPLEMENTATION.


  METHOD check_permission.

    FREE: et_return, ev_ok.

* ---------------------------------------------------------------------------
* Botões mapeados no objeto de autorização
* ---------------------------------------------------------------------------
* 02 - Botão Processar
* 76 - Botão Inserir Evento
* A3 - Botão Definir Status
* 04 - Botão imprimir
* ---------------------------------------------------------------------------
    AUTHORITY-CHECK OBJECT 'ZPRESTCONT'
     ID 'ACTVT' FIELD iv_actvt.

    IF sy-subrc NE 0.
      " Sem autorização para acessar esta funcionalidade.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '005' ) ).
    ELSE.
      rv_ok = ev_ok = abap_true.
    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD call_change_order_status.

    FREE: et_return, gt_messages.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = zcltm_cockpit_prestacao=>gc_permission-definir_status
                          IMPORTING et_return = et_return ).

    IF et_return[] IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica se é possível mudar o status
* ---------------------------------------------------------------------------
    me->check_change_order_status( EXPORTING iv_freightorderuuid = iv_freightorderuuid
                                             iv_status           = iv_status
                                   IMPORTING et_return           = et_return ).

    IF et_return[] IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Chama evento para troca de status
* ---------------------------------------------------------------------------
    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMTM_PRESTACAO_DEF_STS'
      STARTING NEW TASK 'PRESTACAO_DEF_STS'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_freightorderuuid = iv_freightorderuuid
        iv_status           = iv_status.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_messages.

  ENDMETHOD.


  METHOD call_insert_unit_event_status.

    FREE: et_return, gt_messages.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = zcltm_cockpit_prestacao=>gc_permission-definir_status
                          IMPORTING et_return = et_return ).

    IF et_return[] IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Chama evento para troca de status
* ---------------------------------------------------------------------------
    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMTM_PRESTACAO_DEF_STS_UNID'
      STARTING NEW TASK 'PRESTACAO_DEF_STS_UNID'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_freightorderuuid   = iv_freightorderuuid
        iv_freightunituuid    = iv_freightunituuid
        iv_transpordeventcode = iv_transpordeventcode.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_messages.

  ENDMETHOD.


  METHOD check_change_order_status.

    FREE et_return.

    CHECK iv_status = gc_lc_status-concluido.

* ---------------------------------------------------------------------------
* Recupera Ordem de Frete X Unidade de Frete
* ---------------------------------------------------------------------------
    SELECT Cockpit~FreightOrderUUID,
           Cockpit~FreightUnitUUID,
           Cockpit~FreightOrder,
           Cockpit~FreightUnit,
           Cockpit~BR_NotaFiscal,
           Cockpit~TranspOrdEventCode,
           Status~TranspOrdEventCode AS TranspOrdEventCodeOK
      FROM zi_tm_cockpit_prestacao_contas AS Cockpit
      LEFT OUTER JOIN zi_tm_vh_transpordevent_status AS Status
        ON Cockpit~TranspOrdEventCode = Status~TranspOrdEventCode
      WHERE Cockpit~FreightOrderUUID = @iv_FreightOrderUUID
      INTO TABLE @DATA(lt_cockpit).                  "#EC CI_SEL_NESTED

    IF sy-subrc NE 0.
      " Nenhuma Ordem de Frete encontrada.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '001' ) ).
    ENDIF.

    LOOP AT lt_cockpit INTO DATA(ls_cockpit).      "#EC CI_LOOP_INTO_WA

      IF ls_cockpit-TranspOrdEventCode EQ gc_status_event-pendente.
        " Não é possível concluir. Ordem de Frete &1 possui status 'Pendente'.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '008'
                                                message_v1 = |{ ls_cockpit-FreightOrder ALPHA = OUT }| ) ).
        CONTINUE.
      ENDIF.

      IF ls_cockpit-TranspOrdEventCodeOK IS INITIAL.
        " Status '&1' inválido. Utilizar um status válido.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '007'
                                                message_v1 = ls_cockpit-TranspOrdEventCode ) ).
        CONTINUE.
      ENDIF.

      IF ls_cockpit-TranspOrdEventCodeOK IS INITIAL.
        IF ls_cockpit-BR_NotaFiscal IS NOT INITIAL.
          " Não é possível concluir a Ordem de Frete &1. Nota Fiscal &2 sem status.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '002'
                                                  message_v1 = |{ ls_cockpit-FreightOrder ALPHA = OUT }|
                                                  message_v2 = |{ ls_cockpit-BR_NotaFiscal ALPHA = OUT }| ) ).
          CONTINUE.

        ELSEIF ls_cockpit-FreightUnit IS NOT INITIAL.
          " Não é possível concluir a Ordem de Frete &1. Unid. Frete &2 sem status.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '003'
                                                  message_v1 = |{ ls_cockpit-FreightOrder ALPHA = OUT }|
                                                  message_v2 = |{ ls_cockpit-FreightUnit ALPHA = OUT }| ) ).
          CONTINUE.
        ELSE.
          " Não é possível concluir a Ordem de Frete &1. Ordem sem Unidade de Frete.
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '004'
                                                  message_v1 = |{ ls_cockpit-FreightOrder ALPHA = OUT }| ) ).
          CONTINUE.
        ENDIF.
      ENDIF.

    ENDLOOP.

    me->format_message( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD build_reported.

    DATA: lo_dataref            TYPE REF TO data,
          ls_mdf                TYPE zi_tm_mdf,
          ls_carregamento       TYPE zi_tm_mdf_carregamento,
          ls_descarregamento    TYPE zi_tm_mdf_descarregamento,
          ls_complemento        TYPE zi_tm_mdf_complemento,
          ls_emitente           TYPE zi_tm_mdf_emitente,
          ls_historico          TYPE zi_tm_mdf_historico,
          ls_motorista          TYPE zi_tm_mdf_motorista,
          ls_municipio          TYPE zi_tm_mdf_municipio,
          ls_percurso_doc       TYPE zi_tm_mdf_percurso_doc,
          ls_placa              TYPE zi_tm_mdf_placa,
          ls_placa_condutor     TYPE zi_tm_mdf_placa_condutor,
          ls_placa_vale_pedagio TYPE zi_tm_mdf_placa_vale_pedagio.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-cockpit.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-cockpit.
        WHEN gc_cds-execucao.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-execucao.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-cockpit.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = new_message( id       = ls_return-id
                                     number   = ls_return-number
                                     v1       = ls_return-message_v1
                                     v2       = ls_return-message_v2
                                     v3       = ls_return-message_v3
                                     v4       = ls_return-message_v4
                                     severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-cockpit.
          es_reported-cockpit[]         = VALUE #( BASE es_reported-cockpit[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-execucao.
          es_reported-execucao[]        = VALUE #( BASE es_reported-execucao[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-cockpit[]         = VALUE #( BASE es_reported-cockpit[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD change_order_status.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Declara gerenciador de serviço
* ---------------------------------------------------------------------------
    DATA(lo_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    DATA(lt_key) = VALUE /bobf/t_frw_key( ( key = iv_freightorderuuid ) ).

    DATA(lr_set_lc_params) = NEW /scmtms/s_tor_a_set_lc_comp( ).

    DATA(lv_act_key) = SWITCH #( iv_status WHEN gc_lc_status-em_processamento
                                           THEN /scmtms/if_tor_c=>sc_action-root-set_lc_in_process
                                           WHEN gc_lc_status-concluido
                                           THEN /scmtms/if_tor_c=>sc_action-root-set_lc_complete
                                           ELSE space ).

* ---------------------------------------------------------------------------
* Modifica status da Ordem de Frete
* ---------------------------------------------------------------------------
    lo_srvmgr_tor->do_action( EXPORTING iv_act_key              = lv_act_key
                                        it_key                  = lt_key[]
                                        is_parameters           = lr_set_lc_params
                              IMPORTING eo_change               = DATA(lo_change)
                                        eo_message              = DATA(lo_message)
                                        et_failed_key           = DATA(lt_failed_key)
                                        et_failed_action_key    = DATA(lt_failed_action_key)
    ).

    IF ( lt_failed_key IS NOT INITIAL OR lt_failed_action_key IS NOT INITIAL ).

      IF lo_message IS BOUND.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                               CHANGING  ct_bapiret2 = et_return ).
      ENDIF.

    ELSE.

      IF lo_message IS BOUND.
        /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                               CHANGING  ct_bapiret2 = et_return ).
      ENDIF.

      " Salva alterações
      DATA(lo_tramgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

      lo_tramgr->save( IMPORTING eo_message  = lo_message
                                 ev_rejected = DATA(lv_rejected) ).

    ENDIF.

    me->format_message( CHANGING ct_return = et_return[] ).

    gt_messages = et_return.

  ENDMETHOD.


  METHOD get_print.

    DATA:
      lv_function_name   TYPE funcname,
      ls_outputparams    TYPE sfpoutputparams,
      lv_document_number TYPE ppfdsort,
      ls_formoutput      TYPE fpformoutput,
      ls_joboutput       TYPE sfpjoboutput,
      lo_message         TYPE REF TO /bobf/if_frw_message,
      ls_docparams       TYPE sfpdocparams,
      lv_document_title  TYPE string.

    FREE: ev_filename, ev_file, et_return.

* ---------------------------------------------------------------------------
* Recupera tipo de impressão
* ---------------------------------------------------------------------------
    me->get_print_loadout( EXPORTING iv_printname = iv_printname
                           IMPORTING ev_formname  = DATA(lv_formname)
                                     eo_printout  = DATA(lo_printout)
                                     et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Preenche parâmetros
* ---------------------------------------------------------------------------
    DATA(lt_keys) = VALUE /bobf/t_frw_key( ( key = iv_freightorderuuid  ) ).

    TRY.
        CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
          EXPORTING
            i_name     = lv_formname
          IMPORTING
            e_funcname = lv_function_name.
      CATCH cx_root.
        CLEAR lv_function_name.
    ENDTRY.

    ls_outputparams-device      = 'PRINTER'.
    ls_outputparams-nodialog    = abap_true.
    ls_outputparams-dest        = 'LP01'.
    ls_outputparams-reqnew      = abap_true.
    ls_outputparams-reqimm      = abap_true.
    ls_outputparams-covtitle    = iv_printname.
    ls_outputparams-arcmode     = abap_true.
    ls_outputparams-getpdf      = abap_true.

    IF lo_printout IS BOUND.
*   Fill data and print document.
      CALL METHOD lo_printout->print_document
        EXPORTING
          it_keys            = lt_keys
          ip_function_name   = lv_function_name
          ip_form_name       = lv_formname
          is_outputparams    = ls_outputparams
        IMPORTING
          es_formoutput      = ls_formoutput
          es_joboutput       = ls_joboutput
          eo_message         = lo_message
          ev_document_number = lv_document_number
        CHANGING
          cs_docparams       = ls_docparams
          cp_document_title  = lv_document_title.
    ENDIF.

    IF lo_message IS NOT INITIAL.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                            CHANGING  ct_bapiret2 = et_return ).

      RETURN.
    ENDIF.

    ev_file     = ls_formoutput-pdf.
    ev_filename = |{ lv_document_number }_{ sy-datum }{ sy-uzeit }.pdf|.

  ENDMETHOD.


  METHOD get_print_loadout.

* ---------------------------------------------------------------------------
* Método extraído do /SCMTMS/CL_PPF_SERV_FOR_TOR método PERSONALIZE_DOC_BY_ABAP
* ---------------------------------------------------------------------------
    FREE: eo_printout, ev_formname, et_return.

    CASE iv_printname.
      WHEN gc_ad_print_vics OR
           gc_ad_print_vics_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_vics.

      WHEN gc_ad_print_cmr OR
           gc_ad_print_cmr_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_cmr.

      WHEN gc_ad_print_airport_transfer.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_airport_tr.

      WHEN gc_ad_print_truck_manifest.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_truck_mfst.

      WHEN gc_ad_print_pickup_order.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_pickup.

      WHEN gc_ad_print_delivery_order.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_delivery.

      WHEN gc_ad_print_fbl OR
           gc_ad_print_fbl_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_fbl.

      WHEN gc_ad_print_ffi OR
           gc_ad_print_ffi_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_ffi.

      WHEN gc_ad_print_hawb OR
           gc_ad_print_hawb_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_hawb.

      WHEN gc_ad_print_hawb_fu OR
           gc_ad_print_hawb_man_fu.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_hawb.

      WHEN gc_ad_print_hbl OR
           gc_ad_print_hbl_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_hbl.

      WHEN gc_ad_print_lab OR
           gc_ad_print_lab_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_lab.

      WHEN gc_ad_print_man OR
           gc_ad_print_man_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_man.

      WHEN gc_ad_print_mawb OR
           gc_ad_print_mawb_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_mawb.

      WHEN gc_ad_print_mbl OR
           gc_ad_print_mbl_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_mbl.

      WHEN gc_ad_print_mbli OR
           gc_ad_print_mbli_man.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_mbli.

      WHEN gc_ad_print_mawb_label.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_mawb_label.

      WHEN gc_ad_print_hawb_label.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_hawb_label.

      WHEN gc_ad_print_comb_label.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_comb_label.

      WHEN gc_ad_print_manifest_addr OR gc_ad_print_manifest.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_manfst_air.

      WHEN gc_ad_print_load_plan.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_load_plan.

      WHEN gc_ad_print_loadplan_air.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_load_plan.

      WHEN gc_ad_print_loadplan_sea.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_load_plan.

      WHEN gc_ad_print_loadplan_road.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_load_plan.

      WHEN gc_ad_print_sec_manifest.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_manfst_air. "/SCMTMS/CL_PRINTOUT_SEC_MAN.

      WHEN gc_ad_print_uld_manifest.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_uld_manfst.

      WHEN gc_ad_print_uld_tag.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_uld_tag.

      WHEN gc_ad_print_packlist.
*     Create instance of class for document to be printed.
*      CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_packlist.

      WHEN gc_ad_print_parcel_man.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_parcel_man.

      WHEN gc_ad_print_parcel_lbl_all.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_lbl.

      WHEN gc_ad_print_shprs_dcl.
*     Create instance of class for document to be printed.
        CREATE OBJECT eo_printout TYPE /scmtms/cl_printout_shprs_dcl.

      WHEN OTHERS.
*     where used list enabling for the message with dummy message
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = '/scmtms/tor' number = '700'
                               message_v1 = iv_printname
                               message_v2 = '/SCMTMS/CL_PPF_SERV_FOR_TOR~PERSONALIZE_DOC_BY_ABAP' ) ).

    ENDCASE.

    ev_formname = '/SCMTMS/FP_FFI'.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'PRESTACAO_DEF_STS'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_PRESTACAO_DEF_STS'
            IMPORTING
                et_messages = gt_messages.

      WHEN 'PRESTACAO_DEF_STS_UNID'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMTM_PRESTACAO_DEF_STS_UNID'
            IMPORTING
                et_messages = gt_messages.

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD get_messages.

    et_messages = gt_messages.

  ENDMETHOD.


  METHOD insert_unit_event_status.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Action /SCMTMS/CL_TOR_A_EXI_REP_EVENT
* ---------------------------------------------------------------------------

    DATA: ls_exec_info    TYPE /scmtms/s_tor_exec,
          lo_message      TYPE REF TO /bobf/if_frw_message,
          lv_execution_id TYPE numc10.

* ---------------------------------------------------------------------------
* Recupera último evento inserido
* ---------------------------------------------------------------------------
    SELECT SINGLE TranspOrdExecution
        FROM zi_tm_prestacao_contas_ult_exe
        WHERE TransportationOrderUUID = @iv_freightunituuid
        INTO @DATA(lv_TranspOrdExecution).

    IF sy-subrc EQ 0.
      TRY.
          lv_execution_id = lv_TranspOrdExecution.
        CATCH cx_root.
          CLEAR lv_execution_id.
      ENDTRY.
    ENDIF.

    ADD 10 TO lv_execution_id.

* ---------------------------------------------------------------------------
* Recupera Raiz da unidade de frete
* ---------------------------------------------------------------------------
    SELECT SINGLE db_key, parent_key
       FROM /scmtms/d_torite
       WHERE parent_key = @iv_freightunituuid
         AND item_cat   = 'FUR'
       INTO @DATA(ls_root_item_link).

    IF sy-subrc NE 0.
      " Ordem sem unidade de frete.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '009') ).
      me->format_message( CHANGING ct_return = et_return[] ).
      gt_messages = et_return.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida se Tipo de Ordem de Venda está cadastrado
* ---------------------------------------------------------------------------
    SELECT SINGLE
           FreightOrderUUID,
           FreightUnitUUID,
           FreightOrder,
           FreightUnit,
           SalesDocumentType
      FROM zi_tm_cockpit_prestacao_contas
      WHERE FreightOrderUUID = @iv_FreightOrderUUID
        AND FreightUnitUUID  = @iv_FreightUnitUUID
      INTO @DATA(ls_cockpit).                        "#EC CI_SEL_NESTED

    IF sy-subrc NE 0.
      " Ordem sem unidade de frete.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '009') ).
      me->format_message( CHANGING ct_return = et_return[] ).
      gt_messages = et_return.
      RETURN.
    ENDIF.

    IF iv_transpordeventcode EQ gc_status_event-coletado
    OR iv_transpordeventcode EQ gc_status_event-nao_coletado.

      me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                       et_return    = et_return ).

      IF et_return IS NOT INITIAL.
        me->format_message( CHANGING ct_return = et_return[] ).
        gt_messages = et_return.
        RETURN.
      ENDIF.

      IF ls_cockpit-SalesDocumentType NOT IN ls_parameter-r_auart[] AND ls_parameter-r_auart[] IS NOT INITIAL.
        " Tipo de Ordem de Venda &1 não cadastrado para este evento.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '011'
                                                message_v1 = ls_cockpit-SalesDocumentType ) ).
        me->format_message( CHANGING ct_return = et_return[] ).
        gt_messages = et_return.
        RETURN.
      ENDIF.

    ENDIF.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Cria novo registro manualmente
* ---------------------------------------------------------------------------
    CLEAR ls_exec_info.
    ls_exec_info-execution_id       = lv_execution_id.
    ls_exec_info-toritmuuid         = ls_root_item_link-db_key.
    ls_exec_info-actual_date        = lv_timestamp.
    ls_exec_info-actual_tzone       = 'BRAZIL'.
    ls_exec_info-event_code         = iv_transpordeventcode.
    ls_exec_info-event_status       = /scmtms/if_tor_const=>sc_event_status-unexpected.
    ls_exec_info-execinfo_source    = /scmtms/if_tor_const=>sc_tor_event_source-application.
    ls_exec_info-created_by         = sy-uname.
    ls_exec_info-created_on         = lv_timestamp.
    ls_exec_info-changed_by         = sy-uname.
    ls_exec_info-changed_on         = lv_timestamp.

    /scmtms/cl_mod_helper=>mod_create_single(
        EXPORTING
          is_data        = ls_exec_info
          iv_parent_key  = iv_freightunituuid
          iv_root_key    = iv_freightunituuid
          iv_node        = /scmtms/if_tor_c=>sc_node-executioninformation
          iv_source_node = /scmtms/if_tor_c=>sc_node-root
          iv_association = /scmtms/if_tor_c=>sc_association-root-exec_valid
        IMPORTING
          es_mod         = DATA(ls_mod) ).

    DATA(lt_mod) = VALUE /bobf/t_frw_modification( ( ls_mod ) ).

* ---------------------------------------------------------------------------
* Prepara mensagem de retorno
* ---------------------------------------------------------------------------
    /scmtms/cl_tor_helper_event=>get_event_code_cust(
      EXPORTING
        iv_langu        = sy-langu
        iv_event_code   = ls_exec_info-event_code
      IMPORTING
        ev_event_desc   = DATA(lv_event_desc) ).

    MESSAGE s152(/scmtms/tor) INTO DATA(lv_dummy) WITH lv_event_desc.

    CALL METHOD /scmtms/cl_common_helper=>msg_helper_add_symsg
      EXPORTING
        iv_key       = iv_freightunituuid
        iv_node_key  = /scmtms/if_tor_c=>sc_node-root
        iv_subobject = /scmtms/cl_applog_helper=>sc_al_sobj_em
      CHANGING
        co_message   = lo_message.

    /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                           CHANGING  ct_bapiret2 = et_return ).

* ---------------------------------------------------------------------------
* Atualiza serviço com o novo status
* ---------------------------------------------------------------------------
    DATA(lo_srvmgr_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    lo_srvmgr_tor->modify( EXPORTING it_modification = lt_mod
                           IMPORTING eo_change       = DATA(lo_change)
                                     eo_message      = lo_message ).

    IF lo_message IS BOUND.
      /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                             CHANGING  ct_bapiret2 = et_return ).
    ENDIF.

    " Salva alterações
    DATA(lo_tramgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    lo_tramgr->save( IMPORTING eo_message  = lo_message
                               ev_rejected = DATA(lv_rejected) ).

    me->format_message( CHANGING ct_return = et_return[] ).

    gt_messages = et_return.

  ENDMETHOD.


  METHOD format_message.

    DATA: ls_return_format TYPE bapiret2.

    LOOP AT ct_Return REFERENCE INTO DATA(ls_return).

      CHECK ls_return->message IS INITIAL.

      TRY.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = ls_Return->id
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

    ENDLOOP.

  ENDMETHOD.

  METHOD get_parameter.

    FREE et_value.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                         iv_chave1 = is_param-chave1
                                         iv_chave2 = is_param-chave2
                                         iv_chave3 = is_param-chave3
                               IMPORTING et_range  = et_value ).
      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de Tipo de Ordem de Venda
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_auart IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_auart-modulo
                                                 chave1 = gc_param_auart-chave1
                                                 chave2 = gc_param_auart-chave2
                                                 chave3 = gc_param_auart-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING et_value = me->gs_parameter-r_auart[] ).

    ENDIF.

    IF me->gs_parameter-r_auart IS INITIAL.
      " Tipo de Ordem de Venda não cadastrado para validação.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZTM_PRESTACAO_CONTAS' number = '010'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

    es_parameter = me->gs_parameter.

  ENDMETHOD.

ENDCLASS.
