CLASS zcltm_create_save_methods DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS change_ship_to_party_ecommerce
      IMPORTING
        !io_methpar TYPE REF TO /sctm/cl_meth_parameter
        !it_request TYPE /sctm/tt_request .
    METHODS cria_recebedor_mercadoria
      IMPORTING
        VALUE(iv_emissor)   TYPE bu_partner OPTIONAL
        VALUE(iv_vbeln)     TYPE vbeln OPTIONAL
      EXPORTING
        VALUE(ev_bp_number) TYPE bu_partner .
  PROTECTED SECTION.
*"* protected components of class ZCLTM_CREATE_SAVE_METHODS
*"* do not include other source files here!!!
  PRIVATE SECTION.
*"* private components of class ZCLTM_CREATE_SAVE_METHODS
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCLTM_CREATE_SAVE_METHODS IMPLEMENTATION.


  METHOD change_ship_to_party_ecommerce.

    DATA: lo_tor_save_request    TYPE REF TO /scmtms/cl_chaco_request,
          lt_bupa_ship_root      TYPE /scmtms/t_tor_party_k,
          lt_bupa_consignee_root TYPE /bofu/t_bupa_root_k,
          lt_changed             TYPE /bobf/t_frw_name,
          lt_mod                 TYPE /bobf/t_frw_modification,
          lt_doc_reference       TYPE /scmtms/t_tor_docref_k,
          lt_stop_last           TYPE /scmtms/t_tor_stop_k,
          lt_loc_bupa_root       TYPE /scmtms/t_bo_loc_root_k.

    LOOP AT it_request ASSIGNING FIELD-SYMBOL(<fs_request>).
      lo_tor_save_request = /scmtms/cl_tor_helper_chaco=>cast_request( <fs_request> ).
      CHECK lo_tor_save_request IS BOUND.

      TRY.
          lo_tor_save_request->mo_tor_srvmgr->retrieve_by_association(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
              it_key                  = lo_tor_save_request->mt_tor_key_active
              iv_association          = /scmtms/if_tor_c=>sc_association-root-party
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_bupa_ship_root ).

          CHECK lt_bupa_ship_root IS NOT INITIAL.

          lo_tor_save_request->mo_tor_srvmgr->retrieve_by_association(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
              it_key                  = lo_tor_save_request->mt_tor_key_active
              iv_association          = /scmtms/if_tor_c=>sc_association-root-bupa_consignee_root
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_bupa_consignee_root ).

          lo_tor_save_request->mo_tor_srvmgr->retrieve_by_association(
            EXPORTING
              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
              it_key                  = lo_tor_save_request->mt_tor_key_active
              iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_last
              iv_fill_data            = abap_true
            IMPORTING
              et_data                 = lt_stop_last ).

*          lo_tor_save_request->mo_tor_srvmgr->retrieve_by_association(
*            EXPORTING
*              iv_node_key             = /scmtms/if_tor_c=>sc_node-root
*              it_key                  = lo_tor_save_request->mt_tor_key_active
*              iv_association          = /scmtms/if_tor_c=>sc_association-root-docreference
*              iv_fill_data            = abap_true
*            IMPORTING
*              et_data                 = lt_doc_reference ).
*
*          IF line_exists( lt_doc_reference[ btd_tco = '73' ] ).
*            DATA(lv_vbeln) = VALUE #( lt_doc_reference[ btd_tco = '73' ]-btd_id ).
*
*            SHIFT lv_vbeln LEFT DELETING LEADING '0'.
*            lv_vbeln = '00' && lv_vbeln.
*
*            me->cria_recebedor_mercadoria(
*              EXPORTING
*                iv_emissor   = VALUE #( lt_bupa_ship_root[ party_rco = 'AG'  ]-party_id OPTIONAL )
*                iv_vbeln     = CONV #( lv_vbeln )
*              IMPORTING
*                ev_bp_number = DATA(lv_bp_new) ).

* BP criado
*            IF lv_bp_new IS NOT INITIAL.
          IF line_exists( lt_bupa_ship_root[ party_rco = 'AG' ] ).
            SELECT *
              FROM but000
              INTO TABLE @DATA(lt_but000_new)
              FOR ALL ENTRIES IN @lt_bupa_ship_root
            WHERE partner = @lt_bupa_ship_root-party_id.

            SELECT *
              FROM /sapapo/loc
              INTO TABLE @DATA(lt_locno)
              FOR ALL ENTRIES IN @lt_stop_last
            WHERE locno = @lt_stop_last-log_locid.

            IF sy-subrc IS INITIAL.
              LOOP AT lt_locno ASSIGNING FIELD-SYMBOL(<fs_locno>).
                IF lt_but000_new IS NOT INITIAL.
                  READ TABLE lt_but000_new INTO DATA(ls_but000_new) INDEX 1.

                  <fs_locno>-partner      = ls_but000_new-partner.
                  <fs_locno>-partner_guid = ls_but000_new-partner_guid.
                ENDIF.
              ENDLOOP.

              MODIFY /sapapo/loc FROM TABLE lt_locno.
            ENDIF.
          ENDIF.
*          ENDIF.

        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          RETURN.
      ENDTRY.

    ENDLOOP.
  ENDMETHOD.


  METHOD cria_recebedor_mercadoria.

* Variaveis
    DATA : lv_partner TYPE bu_partner,
           ls_address TYPE  bapibus1006_address.

* Tabelas internas
    DATA : lt_msg TYPE TABLE OF bapiret2.

* Buscar dados do emissor de mercadoria
    SELECT SINGLE *
      FROM but000
      INTO @DATA(ls_but000)
    WHERE partner = @iv_emissor.

    CHECK sy-subrc IS INITIAL.

* Buscar dados do endereço do emissor de mercadoria
    SELECT SINGLE *
      FROM vbpa
      INTO @DATA(ls_vbpa)
    WHERE vbeln = @iv_vbeln
      AND parvw = 'WE'.

* Considerar o enedereço do Recebedor de mercadoria genérico informado na Remessa
    IF sy-subrc IS INITIAL.
      SELECT SINGLE *
        FROM adrc
        INTO @DATA(ls_adrc)
      WHERE addrnumber = @ls_vbpa-adrnr.
    ENDIF.

* Verificar se já existe um BP com o mesmo endereço
    SELECT *
      FROM adrc
      INTO TABLE @DATA(lt_adrc_to)
    WHERE post_code1 = @ls_adrc-post_code1
      AND street     = @ls_adrc-street
      AND house_num1 = @ls_adrc-house_num1
      AND country    = @ls_adrc-country
      AND region     = @ls_adrc-region.

    IF sy-subrc IS INITIAL.
      SELECT *
        FROM but020 UP TO 1 ROWS
        INTO @DATA(ls_but020)
        FOR ALL ENTRIES IN @lt_adrc_to
      WHERE addrnumber = @lt_adrc_to-addrnumber.
      ENDSELECT.

      IF sy-subrc IS INITIAL.
        ev_bp_number = ls_but020-partner.
        RETURN.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'BUPA_ADDRESS_READ_DETAIL'
      EXPORTING
        iv_partner            = iv_emissor
      IMPORTING
        es_address            = ls_address
      EXCEPTIONS
        no_partner_specified  = 1
        no_valid_record_found = 2
        not_found             = 3
        blocked_partner       = 4
        OTHERS                = 5.

    IF sy-subrc <> 0.

    ENDIF.

* Add General Data
    DATA(ls_data)        = VALUE bapibus1006_central( searchterm1 = ls_but000-name_first
                                                      searchterm2 = ls_but000-name_last
                                                      partnertype = '0015' ).

* Add Address Data
    DATA(ls_address_bp)     = VALUE bapibus1006_address( c_o_name   = ls_but000-name_first
                                                         city       = ls_adrc-city1
                                                         postl_cod1 = ls_adrc-post_code1
                                                         street     = ls_adrc-street
                                                         house_no   = ls_adrc-house_num1
                                                         country    = ls_adrc-country
                                                         taxjurcode = ls_adrc-taxjurcode
                                                         region     = ls_adrc-region
                                                         district   = ls_address-district
                                                         distrct_no = ls_address-distrct_no ).

    DATA(ls_person)     = VALUE bapibus1006_central_person( firstname   = ls_but000-name_first
                                                            lastname    = ls_but000-name_last
                                                            correspondlanguage = 'PT' ).

* Create BP for Carrier
    CALL FUNCTION 'BUPA_CREATE_FROM_DATA'
      EXPORTING
        iv_category    = '1'
        iv_group       = 'APFI'
        is_data        = ls_data
        is_data_person = ls_person
        is_address     = ls_address_bp
        iv_x_save      = abap_true
      IMPORTING
        ev_partner     = lv_partner
      TABLES
        et_return      = lt_msg.

    DELETE lt_msg WHERE type NE 'E'.

    IF lt_msg[] IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      SELECT *
        FROM tb003
        INTO TABLE @DATA(lt_tb003)
      WHERE role = 'FLCU01'
         OR role = 'FLCU00'
         OR role = 'FS0000'.

* Inserção da roles do Emissor de mercadoria no Novo BP (Recebdor de metrcadoria)
      IF sy-subrc IS INITIAL.
* CPF do emissor
        SELECT SINGLE *
          FROM dfkkbptaxnum
          INTO @DATA(ls_cpf_emissor)
        WHERE partner = @iv_emissor.

        DATA(ls_dfkkbptaxnum) = VALUE dfkkbptaxnum( partner = lv_partner
                                                    taxtype = 'BR2'
                                                    taxnum  = ls_cpf_emissor-taxnum ).

        MODIFY dfkkbptaxnum FROM ls_dfkkbptaxnum.
        COMMIT WORK.

        LOOP AT lt_tb003 ASSIGNING FIELD-SYMBOL(<fs_roles>).
* Add BP to Carrier Role
          CALL FUNCTION 'BAPI_BUPA_ROLE_ADD_2'
            EXPORTING
              businesspartner             = lv_partner
              businesspartnerrole         = <fs_roles>-role
              businesspartnerrolecategory = <fs_roles>-rolecategory
              validfromdate               = sy-datum
              validuntildate              = '99991231'
            TABLES
              return                      = lt_msg.

          READ TABLE lt_msg INTO DATA(ls_return) WITH KEY type = 'E'.

          IF sy-subrc IS NOT INITIAL.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

* Código do novo BP
    ev_bp_number = lv_partner.

  ENDMETHOD.
ENDCLASS.
