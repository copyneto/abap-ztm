CLASS zcltm_gko_process_group DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_t_docs TYPE TABLE OF REF TO zcltm_gko_process WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_doc_po,
        doc     TYPE REF TO zcltm_gko_process,
        po_item TYPE zcltm_gko_process=>ty_t_po_item,
      END OF ty_s_doc_po .
    TYPES:
      ty_t_doc_po TYPE TABLE OF ty_s_doc_po WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_po_item_x_acckey,
        doc        TYPE REF TO zcltm_gko_process,
        ebelp_from TYPE ekpo-ebelp,
        ebelp_to   TYPE ekpo-ebelp,
      END OF ty_s_po_item_x_acckey .
    TYPES:
      ty_t_po_item_x_acckey TYPE TABLE OF ty_s_po_item_x_acckey WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_new_po,
        ebeln            TYPE ekpo-ebeln,
        po_item_x_acckey TYPE ty_t_po_item_x_acckey,
        po_header        TYPE bapimepoheader,
        po_headerx       TYPE bapimepoheaderx,
        po_item          TYPE zcltm_gko_process=>ty_t_po_item,
        po_itemx         TYPE zcltm_gko_process=>ty_t_po_itemx,
        po_cond          TYPE zcltm_gko_process=>ty_t_po_cond,
        po_condx         TYPE zcltm_gko_process=>ty_t_po_condx,
        po_account       TYPE zcltm_gko_process=>ty_t_po_account,
        po_accountx      TYPE zcltm_gko_process=>ty_t_po_accountx,
        po_partner       TYPE bapiekkop_tp,
      END OF ty_s_new_po .
    TYPES:
      ty_t_new_po TYPE TABLE OF ty_s_new_po WITH DEFAULT KEY .

    CLASS-METHODS reversal_invoice_grouping
      IMPORTING
        !it_docs TYPE ty_t_docs
      RAISING
        zcxtm_process_group .
    METHODS constructor
      IMPORTING
        !it_docs TYPE ty_t_docs
      RAISING
        zcxtm_gko_process_group .
    METHODS process
      RAISING
        zcxtm_gko_process_group .
    METHODS persist_free
      RAISING
        zcxtm_gko_process_group .
    METHODS persist
      RAISING
        zcxtm_gko_process_group .
    METHODS free .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gt_docs TYPE ty_t_docs .

    METHODS validate_docs
      RAISING
        zcxtm_gko_process_group .
    METHODS get_po_params
      EXPORTING
        !ev_out_doc_type  TYPE bapimepoheader-doc_type
        !ev_out_purch_org TYPE bapimepoheader-purch_org
        !ev_out_pur_group TYPE bapimepoheader-pur_group
        !ev_out_currency  TYPE bapimepoheader-currency
      RAISING
        zcxtm_gko_process_group .
ENDCLASS.



CLASS ZCLTM_GKO_PROCESS_GROUP IMPLEMENTATION.


  METHOD constructor.

    gt_docs = it_docs.

    IF gt_docs IS INITIAL.

      "Nenhum documento foi informado.
      RAISE EXCEPTION TYPE zcxtm_gko_process_group
        EXPORTING
          textid = zcxtm_gko_process_group=>gc_no_document_informed.

    ENDIF.

    validate_docs( ).

  ENDMETHOD.


  METHOD free.

    LOOP AT gt_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).

      <fs_s_doc>->free( ).

    ENDLOOP.

    FREE: gt_docs.

  ENDMETHOD.


  METHOD get_po_params.

    DATA: lt_errors         TYPE zcxtm_gko=>ty_t_errors,
          lo_cx_gko_process TYPE REF TO zcxtm_gko_process.

    DEFINE _get_param.
      TRY.
          &2 = zcltm_gko_process=>get_parameter( &1 ).
        CATCH zcxtm_gko_process INTO lo_cx_gko_process.
          APPEND lo_cx_gko_process TO lt_errors.
      ENDTRY.
    END-OF-DEFINITION.

    _get_param: zcltm_gko_process=>gc_params-tipo_pedido         ev_out_doc_type,
                zcltm_gko_process=>gc_params-organizacao_compras ev_out_purch_org,
                zcltm_gko_process=>gc_params-grupo_compras       ev_out_pur_group,
                zcltm_gko_process=>gc_params-moeda               ev_out_currency.

    IF lt_errors IS NOT INITIAL.

      "Os parâmetros do cabeçalho do pedido, não foram encontrados.
      RAISE EXCEPTION TYPE zcxtm_gko_process_group
        EXPORTING
          textid    = zcxtm_gko_process_group=>GC_po_header_params_not_found
          gt_errors = lt_errors.

    ENDIF.

  ENDMETHOD.


  METHOD persist.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.

    LOOP AT gt_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).

      TRY.
          <fs_s_doc>->persist( ).
        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
          APPEND lr_cx_gko_process TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcxtm_gko_process_group
        EXPORTING
          gt_errors = lt_errors.
    ENDIF.

  ENDMETHOD.


  METHOD persist_free.

    DATA: lt_errors TYPE zcxtm_gko=>ty_t_errors.

    LOOP AT gt_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).

      TRY.
          <fs_s_doc>->persist( ).
          <fs_s_doc>->free( ).
        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
          APPEND lr_cx_gko_process TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      RAISE EXCEPTION TYPE ZCXTM_gko_PROCESS_GROUP
        EXPORTING
          gt_errors = lt_errors.
    ENDIF.

  ENDMETHOD.


  METHOD process.

    DATA: lt_po_item          TYPE zcltm_gko_process=>ty_t_po_item,
          lt_po_itemx         TYPE zcltm_gko_process=>ty_t_po_itemx,
          lt_po_cond          TYPE zcltm_gko_process=>ty_t_po_cond,
          lt_po_condx         TYPE zcltm_gko_process=>ty_t_po_condx,
          lt_po_account       TYPE zcltm_gko_process=>ty_t_po_account,
          lt_po_accountx      TYPE zcltm_gko_process=>ty_t_po_accountx,
          lt_return           TYPE STANDARD TABLE OF bapiret2,
          lt_po_partner       TYPE STANDARD TABLE OF bapiekkop,
          lt_gko_header       TYPE zcltm_gko_process=>ty_t_zgkot001,
          ls_po_header        TYPE bapimepoheader,
          ls_po_headerx       TYPE bapimepoheaderx,
          lv_last_item        TYPE bapimepoitem-po_item,
          lv_vendor           TYPE bapimepoheader-vendor,
          ls_po_header_result TYPE bapimepoheader,
          lt_new_po           TYPE ty_t_new_po.                       "GFX - JVRS - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020

*** GFX - JVRS - Início - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020
    FIELD-SYMBOLS: <fs_s_po_item>     LIKE LINE OF lt_po_item,
                   <fs_s_po_itemx>    LIKE LINE OF lt_po_itemx,
                   <fs_s_po_cond>     LIKE LINE OF lt_po_cond,
                   <fs_s_po_condx>    LIKE LINE OF lt_po_condx,
                   <fs_s_po_account>  LIKE LINE OF lt_po_account,
                   <fs_s_po_accountx> LIKE LINE OF lt_po_accountx,
                   <fs_s_new_po>      LIKE LINE OF lt_new_po.
*** GFX - JVRS - Fim - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020

    DEFINE _fill_po_header.
      ls_po_header-&1  = &2.
      ls_po_headerx-&1 = &3.
    END-OF-DEFINITION.

    DEFINE _fill_new_po_struct.
      ASSIGN lt_&1[ sy-index ] TO <fs_s_&1>.
      IF sy-subrc IS INITIAL.
        <fs_s_&1>-&2 = &3.
        APPEND <fs_s_&1> TO <fs_s_new_po>-&1.
        DELETE lt_&1 INDEX sy-index.
      ENDIF.
    END-OF-DEFINITION.

    CAST zcltm_gko_process( gt_docs[ 1 ] )->get_data( IMPORTING es_gko_header = DATA(ls_gko_header) ).

    SELECT SINGLE
           vendor
      FROM but000
      INNER JOIN cvi_vend_link
        ON ( cvi_vend_link~partner_guid = but000~partner_guid )
      INTO lv_vendor
      WHERE partner = ls_gko_header-emit_cod.

    get_po_params(
      IMPORTING
        ev_out_doc_type  = DATA(lv_doc_type)
        ev_out_purch_org = DATA(lv_purch_org)
        ev_out_pur_group = DATA(lv_pur_group)
        ev_out_currency  = DATA(lv_currency)
    ).

    _fill_po_header: comp_code        ls_gko_header-bukrs 'X',    "Empresa
                     doc_type         lv_doc_type         'X',    "Tipo de documento
                     item_intvl       '10'                'X',    "Intervalo de nºs de item
                     vendor           lv_vendor           'X',    "Fornecedor
                     purch_org        lv_purch_org        'X',    "Organização de compras
                     pur_group        lv_pur_group        'X',    "Grupo de compradores
                     doc_date         sy-datum            'X',    "Data documento
                     currency         lv_currency         'X'.    "Moeda

    IF ls_gko_header-emit_uf <> ls_gko_header-rem_uf.

      SELECT SINGLE
             cvi_vend_link~vendor
        FROM but000
        INNER JOIN cvi_vend_link
          ON ( cvi_vend_link~partner_guid = but000~partner_guid )
        INTO @DATA(lv_vendor_rem)
        WHERE but000~partner = @ls_gko_header-rem_cod.

      IF sy-subrc IS INITIAL.

        SELECT SINGLE
               pabez
          FROM tpaum
          INTO @DATA(lv_pabez)
          WHERE spras = @sy-langu
            AND parvw = 'WL'.

        lt_po_partner = VALUE #( ( buspartno   = lv_vendor_rem
                                   partnerdesc = lv_pabez
                                   langu       = sy-langu      ) ).

      ENDIF.

    ENDIF.

*** GFX - JVRS - Início - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020

    "Obtêm a quantidade máxima de itens para o cenário e-Commerce
    IF ls_gko_header-cenario = zcltm_gko_process=>gc_cenario-e_commerce .

      TRY.
          DATA(lv_qtd_maxima_de_itens) = CONV syst_tabix( zcltm_gko_process=>get_parameter( iv_id = '22' ) ).
        CATCH zcxtm_gko_process.
          lv_qtd_maxima_de_itens = 0.
      ENDTRY.

    ELSE.

      lv_qtd_maxima_de_itens = 0.

    ENDIF.

    "Insere o primeiro registro
    APPEND INITIAL LINE TO lt_new_po ASSIGNING <fs_s_new_po>.
    <fs_s_new_po>-po_header  = ls_po_header.
    <fs_s_new_po>-po_headerx = ls_po_headerx.
    <fs_s_new_po>-po_partner = lt_po_partner.

*** GFX - JVRS - Fim - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020

    LOOP AT gt_docs ASSIGNING FIELD-SYMBOL(<fs_doc>).

      <fs_doc>->get_data( IMPORTING es_gko_header = ls_gko_header ). APPEND ls_gko_header TO lt_gko_header.

      DATA(lv_last_item_aux) = lv_last_item.

      TRY.
*** GFX - JVRS - Início - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020
          FREE: lt_po_item,    lt_po_itemx,
                lt_po_cond,    lt_po_condx,
                lt_po_account, lt_po_accountx.
*** GFX - JVRS - Fim - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020

          <fs_doc>->get_po_data(
            EXPORTING
              iv_item_intvl     = <fs_s_new_po>-po_header-item_intvl
            CHANGING
              cv_last_item_num  = lv_last_item
              ct_po_item        = lt_po_item
              ct_po_itemx       = lt_po_itemx
              ct_po_cond        = lt_po_cond
              ct_po_condx       = lt_po_condx
              ct_po_account     = lt_po_account
              ct_po_accountx    = lt_po_accountx
          ).

*** GFX - JVRS - Início - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020
          DATA(lv_qtd_de_itens) = lines( <fs_s_new_po>-po_item ) + lines( lt_po_item ).

          "Efetua a criação da forma atual
          IF lv_qtd_maxima_de_itens <= 0 OR lv_qtd_de_itens <= lv_qtd_maxima_de_itens.

            APPEND LINES OF lt_po_item     TO <fs_s_new_po>-po_item    .
            APPEND LINES OF lt_po_itemx    TO <fs_s_new_po>-po_itemx   .
            APPEND LINES OF lt_po_cond     TO <fs_s_new_po>-po_cond    .
            APPEND LINES OF lt_po_condx    TO <fs_s_new_po>-po_condx   .
            APPEND LINES OF lt_po_account  TO <fs_s_new_po>-po_account .
            APPEND LINES OF lt_po_accountx TO <fs_s_new_po>-po_accountx.

            "Insere o registro base para a atualização das chaves de acesso
            APPEND VALUE #( doc        = <fs_doc>
                            ebelp_from = ( lv_last_item_aux + <fs_s_new_po>-po_header-item_intvl )
                            ebelp_to   = lv_last_item                                              )
                      TO <fs_s_new_po>-po_item_x_acckey.

          ELSE.


            "Insere um novo registro, para o novo pedido
            APPEND INITIAL LINE TO lt_new_po ASSIGNING <fs_s_new_po>.
            <fs_s_new_po>-po_header  = ls_po_header.
            <fs_s_new_po>-po_headerx = ls_po_headerx.
            <fs_s_new_po>-po_partner = lt_po_partner.

            FREE: lv_last_item.

            <fs_doc>->get_po_data(
              EXPORTING
                iv_item_intvl     = <fs_s_new_po>-po_header-item_intvl
              CHANGING
                cv_last_item_num  = lv_last_item
                ct_po_item        = <fs_s_new_po>-po_item
                ct_po_itemx       = <fs_s_new_po>-po_itemx
                ct_po_cond        = <fs_s_new_po>-po_cond
                ct_po_condx       = <fs_s_new_po>-po_condx
                ct_po_account     = <fs_s_new_po>-po_account
                ct_po_accountx    = <fs_s_new_po>-po_accountx
            ).

            "Insere o registro base para a atualização das chaves de acesso
            APPEND VALUE #( doc        = <fs_doc>
                            ebelp_from = <fs_s_new_po>-po_header-item_intvl
                            ebelp_to   = lv_last_item                       )
                      TO <fs_s_new_po>-po_item_x_acckey.

          ENDIF.

*** GFX - JVRS - Fim - V-3COR24 - Ajuste criação do pedido e-Commerce - 09.10.2020

        CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).

          DELETE <fs_s_new_po>-po_item     WHERE po_item    > lv_last_item_aux.
          DELETE <fs_s_new_po>-po_itemx    WHERE po_item    > lv_last_item_aux.
          DELETE <fs_s_new_po>-po_cond     WHERE itm_number > lv_last_item_aux.
          DELETE <fs_s_new_po>-po_condx    WHERE itm_number > lv_last_item_aux.
*** Correção verificado na melhoria referente a pré-validação de Domicílio Fiscal
*          DELETE lt_po_account  WHERE itm_number > lv_last_item_aux.
*          DELETE lt_po_accountx WHERE itm_number > lv_last_item_aux.
          DELETE <fs_s_new_po>-po_account  WHERE po_item > lv_last_item_aux.
          DELETE <fs_s_new_po>-po_accountx WHERE po_item > lv_last_item_aux.
***
          lv_last_item = lv_last_item_aux.

          TRY.
              <fs_doc>->set_status( iv_status   = zcltm_gko_process=>gc_codstatus-erro_ao_identificar_of
                                    it_bapi_ret = lr_cx_gko_process->get_bapi_return( )                     ).
              <fs_doc>->persist( ).
              <fs_doc>->free( ).
            CATCH zcxtm_gko_process.
              <fs_doc>->free( ).
          ENDTRY.

      ENDTRY.

    ENDLOOP.

*** GFX - JVRS - Início - V-3COR24 - Ajuste criação do pedido e-Commerce - 11.11.2020
    DELETE lt_new_po WHERE po_item IS INITIAL..
*** GFX - JVRS - Fim - V-3COR24 - Ajuste criação do pedido e-Commerce - 11.11.2020

    CHECK lt_new_po IS NOT INITIAL.

    "Exporta os dados das chaves de acesso, para identificar que o pedido é do GKO
    EXPORT gko_header_tab = lt_gko_header TO MEMORY ID zcltm_gko_process=>gc_memory_id-acckey_header_tab.

    LOOP AT lt_new_po ASSIGNING <fs_s_new_po>.

      FREE: ls_po_header_result, lt_return.

      CALL FUNCTION 'BAPI_PO_CREATE1'
        EXPORTING
          poheader         = <fs_s_new_po>-po_header
          poheaderx        = <fs_s_new_po>-po_headerx
          no_price_from_po = 'X'
        IMPORTING
          expheader        = ls_po_header_result
        TABLES
          return           = lt_return
          poitem           = <fs_s_new_po>-po_item
          poitemx          = <fs_s_new_po>-po_itemx
          poaccount        = <fs_s_new_po>-po_account
          poaccountx       = <fs_s_new_po>-po_accountx
          pocond           = <fs_s_new_po>-po_cond
          pocondx          = <fs_s_new_po>-po_condx
          popartner        = <fs_s_new_po>-po_partner.

      IF NOT line_exists( lt_return[ type = 'E' ] ) OR ls_po_header_result-po_number IS NOT INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = 'X'.

        LOOP AT <fs_s_new_po>-po_item_x_acckey ASSIGNING FIELD-SYMBOL(<fs_s_po_item_x_acckey>).

          <fs_s_po_item_x_acckey>-doc->set_po( iv_po_number = ls_po_header_result-po_number
                                               it_po_item   = VALUE #( FOR ls_po_item IN <fs_s_new_po>-po_item WHERE ( po_item >= <fs_s_po_item_x_acckey>-ebelp_from
                                                                                                                 AND   po_item <= <fs_s_po_item_x_acckey>-ebelp_to   )
                                                                         ( ls_po_item ) )  ).

        ENDLOOP.

      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        DELETE lt_return WHERE type <> 'E'.

        LOOP AT <fs_s_new_po>-po_item_x_acckey ASSIGNING <fs_s_po_item_x_acckey>.

          <fs_s_po_item_x_acckey>-doc->set_status( iv_status   = zcltm_gko_process=>gc_codstatus-erro_ao_identificar_of
                                                   it_bapi_ret = lt_return                                                 ).

        ENDLOOP.

      ENDIF.

    ENDLOOP.

    FREE MEMORY ID zcltm_gko_process=>gc_memory_id-acckey_header_tab.

  ENDMETHOD.


  METHOD reversal_invoice_grouping.

    TRY.
        CAST zcltm_gko_process( it_docs[ 1 ] )->get_data( IMPORTING es_gko_header = DATA(ls_gko_header) ).

        "Busca os documentos
        SELECT bukrs
             , belnr
             , gjahr
             , buzei
          FROM bsak_view
          INTO TABLE @DATA(lt_documents)
          WHERE bukrs = @ls_gko_header-bukrs_doc
            AND augbl = @ls_gko_header-belnr
            AND auggj = @ls_gko_header-gjahr.

        IF sy-subrc NE 0.
          RAISE EXCEPTION TYPE zcxtm_process_group
            EXPORTING
              iv_textid      = zcxtm_gko_process=>gc_cancel_not_success
              iv_msgv1       = |{ ls_gko_header-bukrs_doc } { ls_gko_header-belnr } { ls_gko_header-gjahr }|
              it_bapi_return = VALUE #( ( id         = 'ZTM_GKO'
                                          number     = '009'
                                          type       = 'E'
                                          message_v1 = |{ ls_gko_header-bukrs_doc } { ls_gko_header-belnr } { ls_gko_header-gjahr }|
                                          ) ).
        ENDIF.

        "Estorna os documentos
        CALL FUNCTION 'CALL_FBRA'
          EXPORTING
            i_bukrs      = ls_gko_header-bukrs_doc
            i_augbl      = ls_gko_header-belnr
            i_gjahr      = ls_gko_header-gjahr
          EXCEPTIONS
            not_possible = 1
            OTHERS       = 2.

        IF sy-subrc <> 0 AND sy-msgid <> 'F0' AND sy-msgno <> '604' AND sy-msgty = 'E'.
          RAISE EXCEPTION TYPE zcxtm_process_group
            EXPORTING
              iv_textid      = zcxtm_gko_process=>gc_cancel_not_success
              iv_msgv1       = |{ ls_gko_header-bukrs_doc } { ls_gko_header-belnr } { ls_gko_header-gjahr }|
              it_bapi_return = VALUE #( ( id         = 'ZTM_GKO'
                                          number     = '009'
                                          type       = 'E'
                                          message_v1 = |{ ls_gko_header-bukrs_doc } { ls_gko_header-belnr } { ls_gko_header-gjahr }|
                                           ) ).
        ENDIF.

        SELECT SINGLE
               budat
          FROM bkpf
          INTO @DATA(lv_budat)
          WHERE bukrs = @ls_gko_header-bukrs_doc
            AND belnr = @ls_gko_header-belnr
            AND gjahr = @ls_gko_header-gjahr.

        CALL FUNCTION 'CALL_FB08'
          EXPORTING
            i_bukrs      = ls_gko_header-bukrs_doc
            i_belnr      = ls_gko_header-belnr
            i_gjahr      = ls_gko_header-gjahr
            i_stgrd      = '01'
            i_budat      = lv_budat
          EXCEPTIONS
            not_possible = 1
            OTHERS       = 2.
        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE zcxtm_process_group
            EXPORTING
              iv_textid = zcxtm_gko_process=>gc_cancel_not_success
              iv_msgv1  = CONV msgv1( |{ ls_gko_header-bukrs_doc } { ls_gko_header-belnr } { ls_gko_header-gjahr }| )
              it_bapi_return = VALUE #( ( id         = 'ZTM_GKO'
                                          number     = '009'
                                          type       = 'E'
                                          message_v1 = |{ ls_gko_header-bukrs_doc } { ls_gko_header-belnr } { ls_gko_header-gjahr }| ) ).
        ENDIF.

        "Bloqueia novamente os documentos
        LOOP AT lt_documents ASSIGNING FIELD-SYMBOL(<fs_s_documents>).

          DATA(lt_accchg) = VALUE fdm_t_accchg( ( fdname = 'ZLSPR' newval = 'G' ) ).

          CALL FUNCTION 'FI_DOCUMENT_CHANGE'
            EXPORTING
              i_bukrs              = <fs_s_documents>-bukrs
              i_belnr              = <fs_s_documents>-belnr
              i_gjahr              = <fs_s_documents>-gjahr
              i_buzei              = <fs_s_documents>-buzei
            TABLES
              t_accchg             = lt_accchg
            EXCEPTIONS
              no_reference         = 1
              no_document          = 2
              many_documents       = 3
              wrong_input          = 4
              overwrite_creditcard = 5
              OTHERS               = 6.

          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message_error).
            RAISE EXCEPTION TYPE zcxtm_process_group
              EXPORTING
                iv_textid      = zcxtm_gko_process=>gc_error_unlock_document
                iv_msgv1       = CONV msgv1( <fs_s_documents>-belnr )
                iv_msgv2       = CONV msgv2( lv_message_error )
                it_bapi_return = VALUE #( ( id         = 'ZTM_GKO'
                                            number     = '008'
                                            type       = 'E'
                                            message_v1 = CONV msgv1( <fs_s_documents>-belnr )
                                            message_v2 = CONV msgv2( lv_message_error ) ) ).
          ENDIF.

        ENDLOOP.

        LOOP AT it_docs ASSIGNING FIELD-SYMBOL(<fs_s_doc>).
          TRY.
              <fs_s_doc>->set_reversal_invoice_grouping( ).
              <fs_s_doc>->persist( ).
            CATCH zcxtm_gko_process INTO DATA(lr_cx_gko_process).
              CONTINUE.
          ENDTRY.
        ENDLOOP.

      CATCH zcxtm_gko INTO DATA(lr_cx_gko).

        LOOP AT it_docs ASSIGNING <fs_s_doc>.
          TRY.
              <fs_s_doc>->set_status( iv_status   = zcltm_gko_process=>gc_codstatus-erro_estorno_agrupamento
                                      it_bapi_ret = lr_cx_gko->get_bapi_return( )                         ).
              <fs_s_doc>->persist( ).
            CATCH zcxtm_gko_process INTO lr_cx_gko_process.
              CONTINUE.
          ENDTRY.
        ENDLOOP.

    ENDTRY.

  ENDMETHOD.


  METHOD validate_docs.

    DATA: lt_cenario TYPE TABLE OF zttm_gkop003-cenario,
          lt_errors  TYPE zcxtm_gko=>ty_t_errors.

    SELECT cenario
      FROM zttm_gkop003
      INTO TABLE lt_cenario
      WHERE docger = zcltm_gko_process=>gc_docger-pedido_miro.

    IF sy-subrc IS NOT INITIAL.

      "Nenhum cenário configurado para o processamento agrupado.
      RAISE EXCEPTION TYPE zcxtm_gko_process_group
        EXPORTING
          textid = zcxtm_gko_process_group=>gc_scenario_not_allow_gro_proc.

    ENDIF.

    LOOP AT gt_docs ASSIGNING FIELD-SYMBOL(<fs_doc>).

      TRY.
          <fs_doc>->get_data(
            IMPORTING
              es_gko_header = DATA(ls_gko_header)
          ).

          IF NOT line_exists( lt_cenario[ table_line = ls_gko_header-cenario ] ).

            "O cenário & não permite o processamento agrupado.
            RAISE EXCEPTION TYPE zcxtm_gko_process_group
              EXPORTING
                textid   = zcxtm_process_group=>gc_scenario_not_allow_grp_proc
                gv_msgv1 = CONV msgv1( ls_gko_header-cenario ).

          ENDIF.

        CATCH zcxtm_gko_process_group INTO DATA(lr_cx_gko_proc_group).
          APPEND lr_cx_gko_proc_group TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.

      RAISE EXCEPTION TYPE zcxtm_gko_process_group
        EXPORTING
          gt_errors = lt_errors.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
