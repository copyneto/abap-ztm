CLASS lhc_cockpittab DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTTM_COCKPIT_TAB'.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR cockpittab RESULT result.

    METHODS t001_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _001~t001_Create.

    METHODS t003_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _003~t003_Create.

    METHODS t005_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _005~t005_Create.

    METHODS t006_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _006~t006_Create.

    METHODS t007_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _007~t007_Create.

    METHODS t008_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _008~t008_Create.

    METHODS t009_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _009~t009_Create.

    METHODS t010_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _010~t010_Create.

    METHODS t011_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _011~t011_Create.

    METHODS t012_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _012~t012_Create.

    METHODS t013_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _013~t013_Create.

    METHODS t014_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _014~t014_Create.

    METHODS t016_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _016~t016_Create.

    METHODS t017_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _017~t017_Create.

    METHODS t018_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _018~t018_Create.

    METHODS t019_Create FOR VALIDATE ON SAVE
      IMPORTING keys FOR _019~t019_Create.
    METHODS t001_id_05 FOR VALIDATE ON SAVE
      IMPORTING keys FOR _001~t001_id_05.

ENDCLASS.

CLASS lhc_cockpittab IMPLEMENTATION.

  METHOD get_authorizations.
    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
         ENTITY CockpitTab
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_data)
         FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA lv_update TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zcltm_auth_ztmmtable=>update( gc_table ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky        = <fs_data>-%tky
                      %update     = lv_update
                      %delete     = if_abap_behv=>auth-unauthorized
                      %assoc-_001 = lv_update
                      %assoc-_003 = lv_update
                      %assoc-_005 = lv_update
                      %assoc-_006 = lv_update
                      %assoc-_007 = lv_update
                      %assoc-_008 = lv_update
                      %assoc-_009 = lv_update
                      %assoc-_010 = lv_update
                      %assoc-_011 = lv_update
                      %assoc-_012 = lv_update
                      %assoc-_013 = lv_update
                      %assoc-_014 = lv_update
                      %assoc-_016 = lv_update
                      %assoc-_017 = lv_update
                      %assoc-_018 = lv_update
                      %assoc-_019 = lv_update
                    )
             TO result.
    ENDLOOP.
  ENDMETHOD.
  METHOD t001_create.

    DATA: lr_id TYPE RANGE OF ze_gko_id.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
        ENTITY _001
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.
      lr_id =
                    VALUE #(
                      "( sign = 'I' option = 'BT' low = '001' high = '002' )
                      FOR ls_data IN lt_data
                        LET s = 'I'
                            o = 'EQ'
                          IN sign     = s
                             option   = o
                      ( low = ls_data-Id )
                    ).

      IF lr_id IS NOT INITIAL.

        SELECT DISTINCT DomvalueL
        FROM zi_tm_vh_id
        WHERE
           DomvalueL IN @lr_id
        INTO TABLE @DATA(lt_id).
        IF sy-subrc = 0.
          SORT lt_id BY DomvalueL.
        ENDIF.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-Parametro IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'PARAMETRO' )
                      TO reported-_001.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'PARAMETRO'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Parametro = if_abap_behv=>mk-on )
          TO reported-_001.

      ENDIF.


      IF <fs_data>-Id IS NOT INITIAL.
        READ TABLE lt_id
        WITH KEY DomvalueL = <fs_data>-Id
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'ID' )
                    TO reported-_001.

          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'ID'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Id do parâmetro'
                                                                msgno = '002' ) )
                          %element-Parametro = if_abap_behv=>mk-on )
            TO reported-_001.
        ENDIF.

      ENDIF.

      IF reported-_001 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_001.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD t001_id_05.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
        ENTITY _001
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data REFERENCE INTO DATA(ls_data).

      " Validação para "Tipo do documento da fatura"
      IF ls_data->Id = '05' AND strlen( ls_data->parametro ) > 2.

        APPEND VALUE #( %tky        = ls_data->%tky
                        %state_area = 'PARAMETRO' )
                      TO reported-_001.

        " Tipo de documento deve ser apenas de tamanho 2.
        APPEND VALUE #( %tky        = ls_data->%tky
                        %state_area = 'PARAMETRO'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_GKO'
                                                              msgno = '135' ) )
                        %element-Parametro = if_abap_behv=>mk-on )
          TO reported-_001.

      ENDIF.

      IF reported-_001 IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_data->%tky ) TO failed-_001.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD t003_create.
    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
        ENTITY _003
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).
*OR <fs_data>-Cenario IS INITIAL

    IF lt_data IS NOT INITIAL.

      SELECT DISTINCT cfop
      FROM zc_tm_vh_cfop
      FOR ALL ENTRIES IN @lt_data
      WHERE
        cfop = @lt_data-cfop
      INTO TABLE @DATA(lt_cfop).

      IF sy-subrc = 0.
        SORT lt_cfop BY cfop.
      ENDIF.


      SELECT
         DISTINCT IVACode
      FROM zc_mm_vh_mwskz
      FOR ALL ENTRIES IN @lt_data
      WHERE IVACode    = @lt_data-Dmwskz
            OR ivacode = @lt_data-Pmwskz
      INTO TABLE @DATA(lt_iva).

      IF sy-subrc = 0.
        SORT lt_iva BY ivacode.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-Cfop IS INITIAL .

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP' )
                      TO reported-_003.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Cfop = if_abap_behv=>mk-on )
          TO reported-_003.

      ENDIF.

      IF <fs_data>-Dmwskz IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'DMWSKZ' )
                        TO reported-_003.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'DMWSZK'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Dmwskz = if_abap_behv=>mk-on )
        TO reported-_003.
      ENDIF.

      IF <fs_data>-cfop IS NOT INITIAL.

        IF <fs_data>-cfop NE '0'.
          READ TABLE lt_cfop
          WITH KEY cfop = <fs_data>-Cfop
          BINARY SEARCH TRANSPORTING NO FIELDS.

          IF sy-subrc NE 0.

            APPEND VALUE #( %tky        = <fs_data>-%tky
                            %state_area = 'CFOP' )
                          TO reported-_003.
            APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CFOP'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'CFOP'
                                                                msgno = '002' ) )
                          %element-Dmwskz = if_abap_behv=>mk-on )
            TO reported-_003.

          ENDIF.

        ENDIF.
      ENDIF.

      IF <fs_data>-Dmwskz IS NOT INITIAL.
        READ TABLE lt_iva
        WITH KEY ivacode = <fs_data>-Dmwskz
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'DMWSKZ' )
                        TO reported-_003.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'DMWSKZ'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'IVA de'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_003.
        ENDIF.
      ENDIF.

      IF <fs_data>-Pmwskz IS NOT INITIAL.

        READ TABLE lt_iva
         WITH KEY ivacode = <fs_data>-Pmwskz
         BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'PMWSKZ' )
                        TO reported-_003.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'PMWSKZ'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'IVA para'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_003.
        ENDIF.

      ENDIF.


      IF reported-_003 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_003.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t005_create.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
          ENTITY _005
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.

      SELECT
        DISTINCT bland
      FROM zc_tm_vh_regio
      FOR ALL ENTRIES IN @lt_data
      WHERE bland    = @lt_data-RegioTo
            OR bland  = @lt_data-RegioFrom
      INTO TABLE @DATA(lt_regio).

      IF sy-subrc = 0.
        SORT lt_regio BY bland .
      ENDIF.


      SELECT
        DISTINCT inco1
      FROM zi_tm_vh_incoterms
      FOR ALL ENTRIES IN @lt_data
      WHERE
           inco1 = @lt_data-Incoterm
      INTO TABLE @DATA(lt_inco).

      IF sy-subrc = 0.
        SORT lt_inco BY inco1.
      ENDIF.

      SELECT
        DISTINCT CompanyCode
      FROM C_CompanyCodeValueHelp
      FOR ALL ENTRIES IN @lt_data
      WHERE CompanyCode = @lt_data-Burks
      INTO TABLE @DATA(lt_company).

      IF sy-subrc = 0.
        SORT lt_company BY CompanyCode.
      ENDIF.

      SELECT
        DISTINCT ShippingPoint
      FROM C_ShippingPointVH
      FOR ALL ENTRIES IN @lt_data
      WHERE
        ShippingPoint = @lt_data-Vstel
      INTO TABLE @DATA(lt_vstel).

      IF sy-subrc = 0.
        SORT lt_vstel BY ShippingPoint.
      ENDIF.

      SELECT
        DISTINCT IVACode
      FROM zc_mm_vh_mwskz
      FOR ALL ENTRIES IN @lt_data
      WHERE
         IVACode = @lt_data-Mwskz
      INTO TABLE @DATA(lt_iva).

      IF sy-subrc = 0.
        SORT lt_iva BY IVACode.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CHECK <fs_data>-RegioFrom IS INITIAL
*            OR <fs_data>-RegioTo IS INITIAL
*            OR <fs_data>-Incoterm IS INITIAL
*            OR <fs_data>-Burks IS INITIAL
*            OR <fs_data>-Vstel IS INITIAL.


      IF <fs_data>-RegioFrom IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'REGIOFROM' )
                      TO reported-_005.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'REGIOFROM'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-RegioFrom = if_abap_behv=>mk-on )
          TO reported-_005.

      ENDIF.

      IF <fs_data>-RegioTo IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'REGIOTO' )
                      TO reported-_005.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'REGIOTO'
                   %msg        = NEW zcxca_authority_check(
                                     severity = if_abap_behv_message=>severity-error
                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                         msgno = '001' ) )
                   %element-RegioTo = if_abap_behv=>mk-on )
         TO reported-_005.
      ENDIF.

      IF <fs_data>-Incoterm IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'INCOTERM' )
                      TO reported-_005.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'INCOTERM'
                   %msg        = NEW zcxca_authority_check(
                                     severity = if_abap_behv_message=>severity-error
                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                         msgno = '001' ) )
                   %element-Incoterm = if_abap_behv=>mk-on )
         TO reported-_005.
      ENDIF.

      IF <fs_data>-Burks IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'BURKS' )
                      TO reported-_005.


        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'BURKS'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Burks = if_abap_behv=>mk-on )
        TO reported-_005.
      ENDIF.

      IF <fs_data>-Vstel IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'VSTEL' )
                      TO reported-_005.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'VSTEL'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Vstel = if_abap_behv=>mk-on )
        TO reported-_005.
      ENDIF.

      IF <fs_data>-RegioFrom IS NOT INITIAL.
        READ TABLE lt_regio
        WITH KEY bland  = <fs_data>-RegioFrom
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'REGIOFROM' )
                   TO reported-_005.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'REGIOFROM'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Origem'
                                                           msgno = '002' ) )
                     %element-Incoterm = if_abap_behv=>mk-on )
           TO reported-_005.


        ENDIF.

      ENDIF.


      IF <fs_data>-RegioTo IS NOT INITIAL.
        READ TABLE lt_regio
        WITH KEY bland  = <fs_data>-RegioTo
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'REGIOTO' )
                   TO reported-_005.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'REGIOTO'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Destino'
                                                           msgno = '002' ) )
                     %element-Incoterm = if_abap_behv=>mk-on )
           TO reported-_005.
        ENDIF.

      ENDIF.

      IF <fs_data>-Incoterm IS NOT INITIAL.
        READ TABLE lt_inco
        WITH KEY inco1 = <fs_data>-Incoterm
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'INCOTERM' )
                 TO reported-_005.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'INCOTERM'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Incoterms'
                                                           msgno = '002' ) )
                     %element-Incoterm = if_abap_behv=>mk-on )
           TO reported-_005.

        ENDIF.
      ENDIF.

      IF <fs_data>-Burks IS NOT INITIAL.

        READ TABLE lt_company
        WITH KEY CompanyCode = <fs_data>-Burks
        BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                 %state_area = 'BURKS' )
               TO reported-_005.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'BURKS'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Empresa'
                                                           msgno = '002' ) )
                     %element-Incoterm = if_abap_behv=>mk-on )
           TO reported-_005.
        ENDIF.
      ENDIF.

      IF <fs_data>-Vstel IS NOT INITIAL.
        READ TABLE lt_vstel
        WITH KEY  ShippingPoint = <fs_data>-Vstel
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
               %state_area = 'VSTEL' )
             TO reported-_005.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'VSTEL'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Local Expedição'
                                                           msgno = '002' ) )
                     %element-Incoterm = if_abap_behv=>mk-on )
           TO reported-_005.
        ENDIF.


      ENDIF.

      IF <fs_Data>-Mwskz IS NOT INITIAL.
        READ TABLE lt_iva
        WITH KEY  IVACode = <fs_data>-Mwskz
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                 %state_area = 'MWSKZ' )
               TO reported-_005.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'MWSKZ'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Código de imposto'
                                                           msgno = '002' ) )
                     %element-Incoterm = if_abap_behv=>mk-on )
           TO reported-_005.
        ENDIF.

      ENDIF.


      IF reported-_005 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_005.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t006_create.
    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
          ENTITY _006
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.
      SELECT DISTINCT cfop
    FROM zc_tm_vh_cfop
    FOR ALL ENTRIES IN @lt_data
    WHERE
      cfop = @lt_data-cfop
    INTO TABLE @DATA(lt_cfop).

      IF sy-subrc = 0.
        SORT lt_cfop BY cfop.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CHECK <fs_data>-Cfop IS INITIAL.
      IF <fs_data>-Cfop IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP' )
                      TO reported-_006.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Cfop = if_abap_behv=>mk-on )
          TO reported-_006.
      ENDIF.

      IF <fs_data>-Cfop IS NOT INITIAL.
        READ TABLE lt_cfop
        WITH KEY cfop = <fs_data>-Cfop
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP' )
                      TO reported-_006.

          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CFOP'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'CFOP'
                                                                msgno = '002' ) )
                          %element-Cfop = if_abap_behv=>mk-on )
            TO reported-_006.

        ENDIF.

      ENDIF.


      IF reported-_006 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_006.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD t007_create.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
            ENTITY _007
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.
      SELECT DISTINCT cfop
        FROM zc_tm_vh_cfop
        FOR ALL ENTRIES IN @lt_data
        WHERE
          cfop = @lt_data-cfop
        INTO TABLE @DATA(lt_cfop).

      IF sy-subrc = 0.
        SORT lt_cfop BY cfop.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      IF <fs_data>-Cfop IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP' )
                      TO reported-_007.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Cfop = if_abap_behv=>mk-on )
          TO reported-_007.

      ENDIF.

      IF <fs_data>-Cfop IS NOT INITIAL.
        READ TABLE lt_cfop
        WITH KEY cfop = <fs_data>-Cfop
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CFOP' )
                      TO reported-_007.


          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CFOP'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'CFOP'
                                                                msgno = '002' ) )
                          %element-Cfop = if_abap_behv=>mk-on )
            TO reported-_007.

        ENDIF.

      ENDIF.

      IF reported-_007 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_007.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t008_create.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
             ENTITY _008
             ALL FIELDS WITH CORRESPONDING #( keys )
             RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.
      SELECT DISTINCT cfop
        FROM zc_tm_vh_cfop
        FOR ALL ENTRIES IN @lt_data
        WHERE
          cfop = @lt_data-pcfop
          OR cfop = @lt_data-Dcfop
        INTO TABLE @DATA(lt_cfop).

      IF sy-subrc = 0.
        SORT lt_cfop BY cfop.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-Dcfop IS INITIAL.


        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'DCFOP' )
                      TO reported-_008.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'DCFOP'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Dcfop = if_abap_behv=>mk-on )
          TO reported-_008.

      ENDIF.

      IF <fs_data>-Dcfop IS NOT INITIAL.

        READ TABLE lt_cfop
        WITH KEY cfop = <fs_data>-Dcfop
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'DCFOP' )
                      TO reported-_008.

          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'DCFOP'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'CFOP Saída'
                                                                msgno = '002' ) )
                          %element-Dcfop = if_abap_behv=>mk-on )
            TO reported-_008.
        ENDIF.

      ENDIF.


      IF <fs_data>-pcfop IS NOT INITIAL.

        READ TABLE lt_cfop
        WITH KEY cfop = <fs_data>-pcfop
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'PCFOP' )
                      TO reported-_008.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'PCFOP'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'CFOP Entrada'
                                                                msgno = '002' ) )
                          %element-Dcfop = if_abap_behv=>mk-on )
            TO reported-_008.
        ENDIF.

      ENDIF.

      IF reported-_008 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_008.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t009_create.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
               ENTITY _009
               ALL FIELDS WITH CORRESPONDING #( keys )
               RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.
      SELECT
        DISTINCT mtart
      FROM zi_tm_vh_tpmaterial
      FOR ALL ENTRIES IN @lt_data
      WHERE mtart = @lt_data-TipoMat
      INTO TABLE @DATA(lt_material).

      IF sy-subrc = 0.
        SORT lt_material BY mtart.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      IF <fs_data>-TipoMat IS INITIAL. "Categoria IS INITIAL OR

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TIPOMAT' )
                       TO reported-_009.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'TIPOMAT'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-TipoMat = if_abap_behv=>mk-on )
        TO reported-_009.
      ENDIF.

      IF <fs_data>-TipoMat IS NOT INITIAL.

        READ TABLE lt_material
        WITH KEY mtart = <fs_data>-TipoMat
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'TIPOMAT' )
                     TO reported-_009.

          APPEND VALUE #( %tky        = <fs_data>-%tky
           %state_area = 'TIPOMAT'
           %msg        = NEW zcxca_authority_check(
                           severity = if_abap_behv_message=>severity-error
                           textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                               attr1 = 'Tipo de Material'
                                               msgno = '002' ) )
            %element-TipoMat = if_abap_behv=>mk-on )
           TO reported-_009.
        ENDIF.
      ENDIF.

      IF reported-_009 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_009.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD t010_create.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                   ENTITY _010
                   ALL FIELDS WITH CORRESPONDING #( keys )
                   RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.

      SELECT
          DISTINCT IVACode
        FROM zc_mm_vh_mwskz
        FOR ALL ENTRIES IN @lt_data
        WHERE
           IVACode = @lt_data-Mwskz
        INTO TABLE @DATA(lt_iva).

      IF sy-subrc = 0.
        SORT lt_iva BY IVACode.
      ENDIF.

      SELECT
        DISTINCT saknr
      FROM zc_tm_vh_contas_razao
      FOR ALL ENTRIES IN @lt_data
      WHERE
         saknr = @lt_data-Saknr
      INTO TABLE @DATA(lt_cntrazao).

      IF sy-subrc = 0.
        SORT lt_cntrazao BY saknr.
      ENDIF.


      SELECT
        DISTINCT nftype
      FROM zc_tm_vh_nftype
      FOR ALL ENTRIES IN @lt_data
      WHERE
        nftype = @lt_data-Nftype
      INTO TABLE @DATA(lt_nftype).

      IF sy-subrc = 0.
        SORT lt_nftype BY nftype.
      ENDIF.

    ENDIF.


    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).


      IF <fs_data>-Saknr IS INITIAL." OR <fs_data>-RemUf IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'SAKNR' )
                      TO reported-_010.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'SAKNR'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Saknr = if_abap_behv=>mk-on )
          TO reported-_010.

      ENDIF.


      IF <fs_data>-Mwskz IS NOT INITIAL.

        READ TABLE lt_iva
        WITH KEY  IVACode = <fs_data>-Mwskz
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                            %state_area = 'MWSKZ' )
                          TO reported-_010.

          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'MWSKZ'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Código de imposto'
                                                                msgno = '002' ) )
                          %element-Saknr = if_abap_behv=>mk-on )
            TO reported-_010.
        ENDIF.

      ENDIF.

      IF <fs_data>-Saknr IS NOT INITIAL.
        READ TABLE lt_cntrazao
        WITH KEY saknr = <fs_data>-Saknr
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                            %state_area = 'SAKNR' )
                          TO reported-_010.

          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'SAKNR'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Conta do Razão'
                                                                msgno = '002' ) )
                          %element-Saknr = if_abap_behv=>mk-on )
            TO reported-_010.
        ENDIF.

      ENDIF.

      IF <fs_data>-Nftype IS NOT INITIAL.
        READ TABLE lt_nftype
        WITH KEY nftype = <fs_data>-Nftype
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                              %state_area = 'NFTYPE' )
                            TO reported-_010.

          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'NFTYPE'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Ctg.de nota fiscal'
                                                                msgno = '002' ) )
                          %element-Saknr = if_abap_behv=>mk-on )
            TO reported-_010.

        ENDIF.

      ENDIF.

      IF reported-_010 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_010.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t011_create.

    DATA: lr_domvalue TYPE RANGE OF domvalue_l,
          lr_rateio   TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                     ENTITY _011
                     ALL FIELDS WITH CORRESPONDING #( keys )
                     RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.

      lr_domvalue =
                    VALUE #(
                      "( sign = 'I' option = 'BT' low = '001' high = '002' )
                      FOR ls_data IN lt_data
                        LET s = 'I'
                            o = 'EQ'
                          IN sign     = s
                             option   = o
                      ( low = ls_data-cenario )
                    ).

      lr_rateio =
                   VALUE #(
                     "( sign = 'I' option = 'BT' low = '001' high = '002' )
                     FOR ls_datar IN lt_data
                       LET s = 'I'
                           o = 'EQ'
                         IN sign     = s
                            option   = o
                     ( low = ls_datar-Rateio )
                   ).

      IF lr_domvalue IS NOT INITIAL.
        SELECT DISTINCT
          DomvalueL
        FROM zi_tm_vh_id_cenario
          WHERE DomvalueL IN @lr_domvalue
          INTO TABLE @DATA(lt_cenario).
      ENDIF.

      SORT lt_cenario BY DomvalueL.

      SELECT
        DISTINCT inco1
      FROM zi_tm_vh_incoterms
      FOR ALL ENTRIES IN @lt_data
      WHERE
        inco1 = @lt_data-Incoterms
      INTO TABLE @DATA(lt_inco).
      IF sy-subrc = 0.
        SORT lt_inco BY inco1.
      ENDIF.

      IF lr_rateio IS NOT INITIAL.
        SELECT DISTINCT
          DomvalueL
        FROM zi_tm_vh_id_tprateio
        WHERE DomvalueL IN @lr_rateio
        INTO TABLE @DATA(lt_rateio).
        IF sy-subrc = 0.
          SORT lt_rateio BY DomvalueL.
        ENDIF.
      ENDIF.

      SELECT
         DISTINCT IVACode
      FROM zc_mm_vh_mwskz
      FOR ALL ENTRIES IN @lt_data
      WHERE IVACode    = @lt_data-Dmwskz
            OR ivacode = @lt_data-Pmwskz
            OR ivacode = @lt_data-Gmwskz
      INTO TABLE @DATA(lt_iva).

      IF sy-subrc = 0.
        SORT lt_iva BY ivacode.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

*      CHECK <fs_data>-Cenario IS INITIAL OR <fs_data>-Rateio IS INITIAL.

      IF   <fs_data>-Cenario IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CENARIO' )
                      TO reported-_011.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CENARIO'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Cenario = if_abap_behv=>mk-on )
          TO reported-_011.

      ENDIF.

      IF <fs_data>-Rateio IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'RATEIO' )
                       TO reported-_011.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'RATEIO'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Rateio = if_abap_behv=>mk-on )
        TO reported-_011.

      ENDIF.



      IF <fs_data>-cenario IS NOT INITIAL.
        READ TABLE lt_cenario
        WITH KEY DomvalueL = <fs_data>-cenario
        BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CENARIO' )
                          TO reported-_011.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CENARIO'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'Cenário'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_011.

        ENDIF.
      ENDIF.


      IF <fs_data>-Incoterms IS NOT INITIAL.

        READ TABLE lt_inco
        WITH KEY inco1 = <fs_data>-Incoterms
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'INCONTERMS' )
                        TO reported-_011.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'INCONTERMS'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'Incoterms'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_011.
        ENDIF.

      ENDIF.

      IF <fs_data>-Dmwskz IS NOT INITIAL.
        READ TABLE lt_iva
        WITH KEY ivacode = <fs_data>-Dmwskz
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'DMWSKZ' )
                        TO reported-_011.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'DMWSKZ'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'IVA com ICMS destacado no XML'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_011.
        ENDIF.
      ENDIF.

      IF <fs_data>-Pmwskz IS NOT INITIAL.

        READ TABLE lt_iva
         WITH KEY ivacode = <fs_data>-Pmwskz
         BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'PMWSKZ' )
                        TO reported-_011.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'PMWSKZ'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'IVA sem ICMS destacado no XML'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_011.
        ENDIF.

      ENDIF.

      IF <fs_data>-Gmwskz IS NOT INITIAL.

        READ TABLE lt_iva
         WITH KEY ivacode = <fs_data>-Gmwskz
         BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'GMWSKZ' )
                        TO reported-_011.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'GMWSKZ'
                          %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'IVA NF sem Produto Acabado'
                                                            msgno = '002' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
         TO reported-_011.
        ENDIF.

      ENDIF.

      IF reported-_011 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_011.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.

  METHOD t012_create.

    DATA: lr_tpdoc TYPE RANGE OF domvalue_l,
          lr_modnf TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                      ENTITY _012
                      ALL FIELDS WITH CORRESPONDING #( keys )
                      RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.

      lr_tpdoc =
                      VALUE #(
                        "( sign = 'I' option = 'BT' low = '001' high = '002' )
                        FOR ls_data IN lt_data
                          LET s = 'I'
                              o = 'EQ'
                            IN sign     = s
                               option   = o
                        ( low = ls_data-Tpdoc )
                      ).

      lr_modnf =
                     VALUE #(
                       "( sign = 'I' option = 'BT' low = '001' high = '002' )
                       FOR ls_data IN lt_data
                         LET s = 'I'
                             o = 'EQ'
                           IN sign     = s
                              option   = o
                       ( low = ls_data-Model )
                     ).


      IF lr_tpdoc IS NOT INITIAL.
        SELECT
          DISTINCT DomvalueL
        FROM zi_tm_vh_id_tpdoc
        WHERE
          DomvalueL IN @lr_tpdoc
        INTO TABLE @DATA(lt_tpdoc).

        IF sy-subrc = 0.
          SORT lt_tpdoc BY DomvalueL.
        ENDIF.
      ENDIF.

      SELECT
          DISTINCT nftype
        FROM zc_tm_vh_nftype
        FOR ALL ENTRIES IN @lt_data
        WHERE
          nftype = @lt_data-Nftype
        INTO TABLE @DATA(lt_nftype).

      IF sy-subrc = 0.
        SORT lt_nftype BY nftype.
      ENDIF.

      IF lr_modnf IS NOT INITIAL.

        SELECT
            DISTINCT DomvalueL
          FROM zi_tm_vh_mod_nf
          WHERE
            DomvalueL IN @lr_modnf
          INTO TABLE @DATA(lt_modnf).

        IF sy-subrc = 0.
          SORT lt_modnf BY DomvalueL.
        ENDIF.

      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF  <fs_data>-Tpdoc IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TPDOC' )
                      TO reported-_012.

        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TPDOC'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Tpdoc = if_abap_behv=>mk-on )
          TO reported-_012.
      ENDIF.

*      IF  <fs_data>-Model IS INITIAL.
*
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                        %state_area = 'MODEL' )
*                       TO reported-_012.
*
*
*
*
*
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                      %state_area = 'MODEL'
*                      %msg        = NEW zcxca_authority_check(
*                                        severity = if_abap_behv_message=>severity-error
*                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
*                                                            msgno = '001' ) )
*                      %element-Model = if_abap_behv=>mk-on )
*        TO reported-_012.
*      ENDIF.


      IF <fs_data>-Tpdoc IS NOT INITIAL.
        READ TABLE lt_tpdoc
        WITH KEY DomvalueL = <fs_data>-Tpdoc
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TPDOC' )
                      TO reported-_012.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'TPDOC'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Tipo de documento'
                                                                msgno = '002' ) )
                          %element-Tpdoc = if_abap_behv=>mk-on )
            TO reported-_012.

        ENDIF.
      ENDIF.


      IF <fs_data>-Nftype IS NOT INITIAL.
        READ  TABLE lt_nftype
        WITH KEY nftype = <fs_data>-Nftype
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'NFTYPE' )
                    TO reported-_012.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'NFTYPE'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Ctg.nota fiscal'
                                                                msgno = '002' ) )
                          %element-Tpdoc = if_abap_behv=>mk-on )
            TO reported-_012.

        ENDIF.

      ENDIF.

      IF <fs_data>-Model IS NOT INITIAL.

        READ TABLE lt_modnf
        WITH KEY DomvalueL = <fs_data>-Model
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'MODEL' )
                      TO reported-_012.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'MODEL'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Modelo nota fiscal'
                                                                msgno = '002' ) )
                          %element-Tpdoc = if_abap_behv=>mk-on )
            TO reported-_012.

        ENDIF.

      ENDIF.

      IF reported-_012 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_012.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD t013_create.
    DATA: lr_cenario TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                        ENTITY _013
                        ALL FIELDS WITH CORRESPONDING #( keys )
                        RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.

      SELECT COUNT(*)
          FROM zttm_pcockpit013
          FOR ALL ENTRIES IN @lt_data
          WHERE guid          EQ @lt_data-Guid
            AND guid013       NE @lt_data-Guid013
            AND uforig        EQ @lt_data-Uforig
            AND ufdest        EQ @lt_data-Ufdest
            AND rem_branch    EQ @lt_data-RemBranch
            AND tom_branch    EQ @lt_data-TomBranch
            AND cenario       EQ @lt_data-Cenario
            AND dest_branch   EQ @lt_data-DestBranch
            AND loc_ret       EQ @lt_data-LocRet
            AND loc_ent       EQ @lt_data-LocEnt
            AND kostl         EQ @lt_data-Kostl
            AND saknr         EQ @lt_data-Saknr.

      IF sy-subrc EQ 0.
        "Registro de mesma chave já foi cadastrado.
        APPEND VALUE #( %msg        = NEW zcxca_authority_check(
                                      severity = if_abap_behv_message=>severity-error
                                      textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          msgno = '003' ) ) )
        TO reported-_013.
        RETURN.
      ENDIF.
    ENDIF.

    IF lt_data IS NOT INITIAL.

      lr_cenario =
                      VALUE #(
                        "( sign = 'I' option = 'BT' low = '001' high = '002' )
                        FOR ls_data IN lt_data
                          LET s = 'I'
                              o = 'EQ'
                            IN sign     = s
                               option   = o
                        ( low = ls_data-cenario )
                      ).

      IF lr_cenario IS NOT INITIAL.
        SELECT DISTINCT
          DomvalueL
        FROM zi_tm_vh_id_cenario
        WHERE DomvalueL IN @lr_cenario
        INTO TABLE @DATA(lt_cenario).

        IF sy-subrc = 0.
          SORT lt_cenario BY DomvalueL.
        ENDIF.

      ENDIF.

      SELECT
        DISTINCT branch
      FROM zi_tm_vh_branch
      FOR ALL ENTRIES IN @lt_data
      WHERE
        branch = @lt_data-RemBranch
        OR branch = @lt_data-TomBranch
        OR branch = @lt_data-DestBranch
        OR branch = @lt_data-LocEnt
        OR branch = @lt_data-LocRet
     INTO TABLE @DATA(lt_branch).

      IF sy-subrc = 0.
        SORT lt_branch BY branch.
      ENDIF.

*      SELECT DISTINCT WerksCode as werks
*      FROM zi_ca_vh_werks
*      FOR ALL ENTRIES IN @lt_data
*      WHERE WerksCode = @lt_data-LocEnt
*         OR WerksCode = @lt_data-LocRet
*     INTO TABLE @DATA(lt_werks).
*
*      IF sy-subrc = 0.
*        SORT lt_werks BY werks.
*      ENDIF.

      SELECT
        DISTINCT saknr
      FROM zc_tm_vh_contas_razao
      FOR ALL ENTRIES IN @lt_data
      WHERE
         saknr = @lt_data-Saknr
      INTO TABLE @DATA(lt_cntrazao).

      IF sy-subrc = 0.
        SORT lt_cntrazao BY saknr.
      ENDIF.

      SELECT
        DISTINCT CostCenter
      FROM I_CostCenter
      FOR ALL ENTRIES IN @lt_data
      WHERE
        CostCenter = @lt_data-Kostl
      INTO TABLE @DATA(lt_cost).

      IF sy-subrc = 0.
        SORT lt_cost BY CostCenter.
      ENDIF.


    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CHECK "<fs_data>-Cenario IS INITIAL



      IF <fs_data>-Uforig IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'UFORIG' )
                       TO reported-_013.

        "Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                    %state_area = 'UFORIG'
                    %msg        = NEW zcxca_authority_check(
                                      severity = if_abap_behv_message=>severity-error
                                      textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          msgno = '001' ) )
                    %element-Uforig = if_abap_behv=>mk-on )
        TO reported-_013.

      ENDIF.

      IF <fs_data>-Ufdest IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'UFDEST' )
                       TO reported-_013.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'UFDEST'
                   %msg        = NEW zcxca_authority_check(
                                     severity = if_abap_behv_message=>severity-error
                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                         msgno = '001' ) )
                   %element-Ufdest = if_abap_behv=>mk-on )
     TO reported-_013.

      ENDIF.

      IF <fs_data>-RemBranch IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'REMBRANCH' )
                       TO reported-_013.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'REMBRANCH'
                   %msg        = NEW zcxca_authority_check(
                                     severity = if_abap_behv_message=>severity-error
                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                         msgno = '001' ) )
                   %element-RemBranch = if_abap_behv=>mk-on )
         TO reported-_013.
      ENDIF.

      IF  <fs_data>-TomBranch IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TOMBRANCH' )
                       TO reported-_013.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'TOMBRANCH'
                   %msg        = NEW zcxca_authority_check(
                                     severity = if_abap_behv_message=>severity-error
                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                         msgno = '001' ) )
                   %element-TomBranch = if_abap_behv=>mk-on )
       TO reported-_013.

      ENDIF.

      IF <fs_data>-Cenario IS NOT INITIAL.

        READ TABLE lt_cenario
        WITH KEY DomvalueL = <fs_data>-Cenario
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CENARIO' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'CENARIO'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Cenário/Processo'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-RemBranch IS NOT INITIAL.

        READ TABLE lt_branch
        WITH KEY branch = <fs_data>-RemBranch
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'REMBRANCH' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'REMBRANCH'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'UF remetente'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-DestBranch IS NOT INITIAL.

        READ TABLE lt_branch
        WITH KEY branch = <fs_data>-DestBranch
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'DESTBRANCH' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'DESTBRANCH'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'UF destinatário'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-TomBranch IS NOT INITIAL.

        READ TABLE lt_branch
        WITH KEY branch = <fs_data>-TomBranch
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TOMBRANCH' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'TOMBRANCH'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Filial Tomador'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-LocEnt IS NOT INITIAL.

        READ TABLE lt_branch
        WITH KEY branch = <fs_data>-LocEnt
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'LOCENT' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'LOCENT'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Local de Entrega'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-LocRet IS NOT INITIAL.

        READ TABLE lt_branch
        WITH KEY branch = <fs_data>-LocRet
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'LOCRET' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'LOCRET'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Local de Retirada'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-Saknr IS NOT INITIAL.

        READ TABLE lt_cntrazao
        WITH KEY saknr = <fs_data>-Saknr
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'SAKNR' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'SAKNR'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Conta do Razão'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF <fs_data>-Kostl IS NOT INITIAL.

        READ TABLE lt_cost
        WITH KEY CostCenter = <fs_data>-Kostl
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'KOSTL' )
                       TO reported-_013.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'KOSTL'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Centro de Custo'
                                                           msgno = '002' ) )
                     %element-TomBranch = if_abap_behv=>mk-on )
         TO reported-_013.

        ENDIF.

      ENDIF.

      IF reported-_013 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_013.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t014_create.
    DATA: lr_cenario TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                        ENTITY _014
                        ALL FIELDS WITH CORRESPONDING #( keys )
                        RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.

      lr_cenario =
                    VALUE #(
                      "( sign = 'I' option = 'BT' low = '001' high = '002' )
                      FOR ls_data IN lt_data
                        LET s = 'I'
                            o = 'EQ'
                          IN sign     = s
                             option   = o
                      ( low = ls_data-TipoDoc )
                    ).
      IF lr_cenario IS NOT INITIAL.
        SELECT DISTINCT
          DomvalueL
        FROM zi_tm_vh_id_cenario
          WHERE DomvalueL IN @lr_cenario
          INTO TABLE @DATA(lt_cenario).
        IF sy-subrc = 0.
          SORT lt_cenario BY DomvalueL.
        ENDIF.
      ENDIF.

      SELECT DISTINCT VH_TpCusto FROM zc_tm_vh_tpcusto
      FOR ALL ENTRIES IN @lt_data
      WHERE
        VH_TpCusto = @lt_data-TpCustoTm
      INTO TABLE @DATA(lt_tpcusto).

      IF sy-subrc = 0.
        SORT lt_tpcusto BY VH_TpCusto.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      IF <fs_data>-EventoExtra IS INITIAL. "<fs_data>-TipoDoc IS INITIAL OR


        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'EVENTOEXTRA' )
                       TO reported-_014.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'EVENTOEXTRA'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-EventoExtra = if_abap_behv=>mk-on )
        TO reported-_014.
      ENDIF.

      IF <fs_data>-TipoDoc IS  NOT INITIAL.
        READ TABLE lt_cenario
        WITH KEY DomvalueL = <fs_data>-TipoDoc
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'TIPODOC' )
                     TO reported-_014.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TIPODOC'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Cenário/Processo'
                                                              msgno = '002' ) )
                        %element-EventoExtra = if_abap_behv=>mk-on )
          TO reported-_014.

        ENDIF.

      ENDIF.

      IF <fs_data>-TpCustoTm IS NOT INITIAL.
        READ TABLE lt_tpcusto
        WITH KEY VH_TpCusto = <fs_data>-TpCustoTm
        BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                    %state_area = 'TPCUSTOTM' )
                   TO reported-_014.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'TPCUSTOTM'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Tipo de custo TM'
                                                              msgno = '002' ) )
                        %element-EventoExtra = if_abap_behv=>mk-on )
          TO reported-_014.

        ENDIF.
      ENDIF.

      IF reported-_014 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_014.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t016_create.
    DATA: lr_acao      TYPE RANGE OF domvalue_l,
          lr_statusDe  TYPE RANGE OF domvalue_l,
          lr_statusAte TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                          ENTITY _016
                          ALL FIELDS WITH CORRESPONDING #( keys )
                          RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.

      lr_acao =
                    VALUE #(
                      "( sign = 'I' option = 'BT' low = '001' high = '002' )
                      FOR ls_data IN lt_data
                        LET s = 'I'
                            o = 'EQ'
                          IN sign     = s
                             option   = o
                      ( low = ls_data-Acao )
                    ).

      lr_statusate =
                   VALUE #(
                     "( sign = 'I' option = 'BT' low = '001' high = '002' )
                     FOR ls_data IN lt_data
                       LET s = 'I'
                           o = 'EQ'
                         IN sign     = s
                            option   = o
                     ( low = ls_data-CodstatusPara )
                   ).
      lr_statusde =
                   VALUE #(
                     "( sign = 'I' option = 'BT' low = '001' high = '002' )
                     FOR ls_data IN lt_data
                       LET s = 'I'
                           o = 'EQ'
                         IN sign     = s
                            option   = o
                     ( low = ls_data-CodstatusDe )
                   ).

      IF lr_acao IS NOT INITIAL.
        SELECT
        DISTINCT DomvalueL
        FROM zi_tm_vh_id_acao
        WHERE
           DomvalueL IN @lr_acao
        INTO TABLE @DATA(lt_acao).
        IF sy-subrc = 0.
          SORT lt_acao BY DomvalueL.
        ENDIF.
      ENDIF.

      IF lr_statusde IS NOT INITIAL.
        SELECT
        DISTINCT DomvalueL
        FROM zi_tm_vh_id_codstatus
        WHERE
           DomvalueL IN @lr_statusde
        INTO TABLE @DATA(lt_StatusDe).
        IF sy-subrc = 0.
          SORT lt_statusde BY DomvalueL.
        ENDIF.
      ENDIF.

      IF lr_statusate IS NOT INITIAL.
        SELECT
        DISTINCT DomvalueL
        FROM zi_tm_vh_id_codstatus
        WHERE
           DomvalueL IN @lr_statusate
        INTO TABLE @DATA(lt_StatusAte).
        IF sy-subrc = 0.
          SORT lt_statusate BY DomvalueL.
        ENDIF.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CHECK <fs_data>-Acao IS INITIAL OR <fs_data>-CodstatusDe IS INITIAL OR <fs_data>-CodstatusPara IS INITIAL.
      IF <fs_data>-Acao IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'ACAO' )
                      TO reported-_016.
        " Preencher campo obrigatório.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'ACAO'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              msgno = '001' ) )
                        %element-Acao = if_abap_behv=>mk-on )
          TO reported-_016.
      ENDIF.

      IF <fs_data>-CodstatusDe IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                       %state_area = 'CODSTATUSDE' )
                      TO reported-_016.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'CODSTATUSDE'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           msgno = '001' ) )
                     %element-CodstatusDe = if_abap_behv=>mk-on )
         TO reported-_016.
      ENDIF.

      IF <fs_data>-CodstatusPara IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CODSTATUSPARA' )
                       TO reported-_016.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                    %state_area = 'CODSTATUSPARA'
                    %msg        = NEW zcxca_authority_check(
                                      severity = if_abap_behv_message=>severity-error
                                      textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          msgno = '001' ) )
                    %element-CodstatusPara = if_abap_behv=>mk-on )
         TO reported-_016.
      ENDIF.



      IF <fs_data>-Acao IS NOT INITIAL.

        READ TABLE lt_acao
        WITH KEY DomvalueL = <fs_data>-Acao
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'ACAO' )
                        TO reported-_016.
          " Preencher campo obrigatório.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'ACAO'
                          %msg        = NEW zcxca_authority_check(
                                            severity = if_abap_behv_message=>severity-error
                                            textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                                attr1 = 'Ação'
                                                                msgno = '002' ) )
                          %element-Acao = if_abap_behv=>mk-on )
            TO reported-_016.

        ENDIF.
      ENDIF.

      IF <fs_data>-CodstatusDe IS NOT INITIAL.

        READ TABLE lt_statusde
        WITH KEY DomvalueL = <fs_data>-CodstatusDe
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                         %state_area = 'CODSTATUSDE' )
                        TO reported-_016.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                       %state_area = 'CODSTATUSDE'
                       %msg        = NEW zcxca_authority_check(
                                         severity = if_abap_behv_message=>severity-error
                                         textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                             attr1 = 'Status proc De'
                                                             msgno = '002' ) )
                       %element-CodstatusDe = if_abap_behv=>mk-on )
           TO reported-_016.
        ENDIF.
      ENDIF.

      IF <fs_data>-CodstatusPara IS NOT INITIAL.
        READ TABLE lt_statusate
        WITH KEY DomvalueL = <fs_data>-CodstatusPara
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CODSTATUSPARA' )
                         TO reported-_016.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'CODSTATUSPARA'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'Status proc Até'
                                                            msgno = '002' ) )
                      %element-CodstatusPara = if_abap_behv=>mk-on )
           TO reported-_016.
        ENDIF.
      ENDIF.

      IF reported-_016 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_016.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t017_create.

    DATA: lr_cenario TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                           ENTITY _017
                           ALL FIELDS WITH CORRESPONDING #( keys )
                           RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.

      lr_cenario =
                    VALUE #(
                      "( sign = 'I' option = 'BT' low = '001' high = '002' )
                      FOR ls_data IN lt_data
                        LET s = 'I'
                            o = 'EQ'
                          IN sign     = s
                             option   = o
                      ( low = ls_data-Operacao )
                    ).
      IF lr_cenario IS NOT INITIAL.
        SELECT DISTINCT
          DomvalueL
        FROM zi_tm_vh_id_cenario
          WHERE DomvalueL IN @lr_cenario
          INTO TABLE @DATA(lt_cenario).
        IF sy-subrc = 0.
          SORT lt_cenario BY DomvalueL.
        ENDIF.
      ENDIF.

      SELECT
        DISTINCT
        Ekgrp
      FROM zi_tm_vh_grp_compradores
      FOR ALL ENTRIES IN @lt_data
      WHERE ekgrp = @lt_data-Ekgrp
      INTO TABLE @DATA(lt_grp).
      IF sy-subrc = 0.
        SORT lt_grp BY ekgrp.
      ENDIF.

      SELECT
        DISTINCT mtart
      FROM zi_tm_vh_tpmaterial
      FOR ALL ENTRIES IN @lt_data
      WHERE mtart = @lt_data-Mtart
      INTO TABLE @DATA(lt_material).

      IF sy-subrc = 0.
        SORT lt_material BY mtart.
      ENDIF.

      SELECT DISTINCT bsart FROM zi_tm_vh_tpdoccomp
      FOR ALL ENTRIES IN @lt_data
      WHERE
         bsart = @lt_data-Bsart
      INTO TABLE @DATA(lt_tpdoccomp).

      IF sy-subrc = 0.
        SORT lt_tpdoccomp BY bsart.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CHECK <fs_data>-Bsart IS INITIAL
*            OR <fs_data>-Ekgrp IS INITIAL
*            OR <fs_data>-Mtart IS INITIAL.

      IF <fs_data>-Bsart IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'BSART' )
                      TO reported-_017.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'BSART'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Bsart = if_abap_behv=>mk-on )
        TO reported-_017.
      ENDIF.


*      IF <fs_data>-Ekgrp IS INITIAL.
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                        %state_area = 'EKGRP' )
*                       TO reported-_017.
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                   %state_area = 'EKGRP'
*                   %msg        = NEW zcxca_authority_check(
*                                     severity = if_abap_behv_message=>severity-error
*                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
*                                                         msgno = '001' ) )
*                   %element-Ekgrp = if_abap_behv=>mk-on )
*        TO reported-_017.
*      ENDIF.
*
*      IF <fs_data>-Mtart IS INITIAL.
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                        %state_area = 'MTART' )
*                       TO reported-_017.
*
*
*        APPEND VALUE #( %tky        = <fs_data>-%tky
*                   %state_area = 'MTART'
*                   %msg        = NEW zcxca_authority_check(
*                                     severity = if_abap_behv_message=>severity-error
*                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
*                                                         msgno = '001' ) )
*                   %element-Mtart = if_abap_behv=>mk-on )
*        TO reported-_017.
*
*      ENDIF.



      IF <fs_data>-Bsart IS NOT INITIAL.
        READ TABLE lt_tpdoccomp
        WITH KEY bsart = <fs_data>-Bsart
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'BSART' )
                        TO reported-_017.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'BSART'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Tipo doc.compras'
                                                              msgno = '002' ) )
                        %element-Bsart = if_abap_behv=>mk-on )
          TO reported-_017.
        ENDIF.
      ENDIF.


      IF <fs_data>-Mtart IS NOT INITIAL.

        READ TABLE lt_material
        WITH KEY mtart = <fs_data>-Mtart
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'MTART' )
                         TO reported-_017.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'MTART'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           attr1 = 'Tipo de material'
                                                           msgno = '002' ) )
                     %element-Mtart = if_abap_behv=>mk-on )
          TO reported-_017.
        ENDIF.
      ENDIF.

      IF <fs_data>-Ekgrp IS NOT INITIAL.
        READ TABLE lt_grp
        WITH KEY ekgrp = <Fs_data>-Ekgrp
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'EKGRP' )
                         TO reported-_017.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'EKGRP'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          attr1 = 'Grupo de compradores'
                                                           msgno = '002' ) )
                     %element-Ekgrp = if_abap_behv=>mk-on )
          TO reported-_017.
        ENDIF.
      ENDIF.

      IF <fs_data>-Operacao IS NOT INITIAL.
        READ TABLE lt_cenario
        WITH KEY DomvalueL = <Fs_data>-Operacao
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'OPERACAO' )
                         TO reported-_017.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'OPERACAO'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          attr1 = 'Cenário/Processo'
                                                           msgno = '002' ) )
                     %element-Ekgrp = if_abap_behv=>mk-on )
          TO reported-_017.
        ENDIF.
      ENDIF.

      IF reported-_017 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_017.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t018_create.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                             ENTITY _018
                             ALL FIELDS WITH CORRESPONDING #( keys )
                             RESULT DATA(lt_data).

    IF lt_data IS NOT INITIAL.
      SELECT DISTINCT ShippingPoint
      FROM C_ShippingPointVH FOR ALL ENTRIES IN @lt_data
      WHERE
        ShippingPoint = @lt_data-Vstel
      INTO TABLE @DATA(lt_vstel).

      IF sy-subrc = 0.
        SORT lt_vstel BY ShippingPoint.
      ENDIF.

      SELECT
         DISTINCT IVACode
      FROM zc_mm_vh_mwskz
      FOR ALL ENTRIES IN @lt_data
      WHERE  ivacode = @lt_data-Mwskz
      INTO TABLE @DATA(lt_iva).

      IF sy-subrc = 0.
        SORT lt_iva BY ivacode.
      ENDIF.

      SELECT DISTINCT matkl FROM zc_tm_vh_matkl
      FOR ALL ENTRIES IN @lt_data
      WHERE matkl = @lt_data-Mtart
      INTO TABLE @DATA(lt_tpmat).

      IF sy-subrc = 0.
        SORT lt_tpmat BY matkl.
      ENDIF.

    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*      CHECK <fs_data>-Vstel IS INITIAL
*            OR <fs_data>-Mwskz IS INITIAL
*            OR <fs_data>-Mtart IS INITIAL.
      IF <fs_data>-Vstel IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'VSTEL' )
                      TO reported-_018.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'VSTEL'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Vstel = if_abap_behv=>mk-on )
        TO reported-_018.

      ENDIF.

      IF <fs_data>-Mwskz IS INITIAL.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'MWSKZ' )
                       TO reported-_018.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                    %state_area = 'MWSKZ'
                    %msg        = NEW zcxca_authority_check(
                                      severity = if_abap_behv_message=>severity-error
                                      textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          msgno = '001' ) )
                    %element-Mwskz = if_abap_behv=>mk-on )
         TO reported-_018.
      ENDIF.

      IF <fs_data>-Mtart IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'MTART' )
                       TO reported-_018.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                    %state_area = 'MTART'
                    %msg        = NEW zcxca_authority_check(
                                      severity = if_abap_behv_message=>severity-error
                                      textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                          msgno = '001' ) )
                    %element-Mtart = if_abap_behv=>mk-on )
         TO reported-_018.

      ENDIF.

      IF <fs_data>-Vstel IS NOT INITIAL.

        READ TABLE lt_vstel
        WITH KEY ShippingPoint = <fs_data>-Vstel
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'VSTEL' )
                        TO reported-_018.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'VSTEL'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Local expedição'
                                                              msgno = '002' ) )
                        %element-Vstel = if_abap_behv=>mk-on )
          TO reported-_018.
        ENDIF.


      ENDIF.



      IF <fs_data>-Mwskz IS NOT INITIAL.

        READ TABLE lt_iva
        WITH KEY ivacode = <fs_data>-Mwskz
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'MWSKZ' )
                         TO reported-_018.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'MWSKZ'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'Código de imposto'
                                                            msgno = '002' ) )
                      %element-Mwskz = if_abap_behv=>mk-on )
           TO reported-_018.
        ENDIF.

      ENDIF.


      IF <fs_data>-Mtart IS NOT INITIAL.
        READ TABLE lt_tpmat
        WITH KEY matkl = <fs_data>-Mtart
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'MTART' )
                         TO reported-_018.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'MTART'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            attr1 = 'Grupo de mercadorias'
                                                            msgno = '002' ) )
                      %element-Mtart = if_abap_behv=>mk-on )
           TO reported-_018.
        ENDIF.
      ENDIF.

      IF reported-_018 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_018.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD t019_create.

    DATA: lr_cenario TYPE RANGE OF domvalue_l.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
                                 ENTITY _019
                                 ALL FIELDS WITH CORRESPONDING #( keys )
                                 RESULT DATA(lt_data).


    IF lt_data IS NOT INITIAL.
      lr_cenario =
                  VALUE #(
                    "( sign = 'I' option = 'BT' low = '001' high = '002' )
                    FOR ls_data IN lt_data
                      LET s = 'I'
                          o = 'EQ'
                        IN sign     = s
                           option   = o
                    ( low = ls_data-cenario )
                  ).

      IF lr_cenario IS NOT INITIAL.
        SELECT DISTINCT
          DomvalueL
        FROM zi_tm_vh_id_cenario
          WHERE DomvalueL IN @lr_cenario
          INTO TABLE @DATA(lt_cenario).
        IF sy-subrc = 0.
          SORT lt_cenario BY DomvalueL.
        ENDIF.
      ENDIF.

      SELECT
         DISTINCT IVACode
      FROM zc_mm_vh_mwskz
      FOR ALL ENTRIES IN @lt_data
      WHERE IVACode    = @lt_data-IvaFrete
            OR ivacode = @lt_data-IvaNf
      INTO TABLE @DATA(lt_iva).

      IF sy-subrc = 0.
        SORT lt_iva BY ivacode.
      ENDIF.


    ENDIF.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).


*      CHECK <fs_data>-Cenario IS INITIAL
*            OR <fs_data>-IcmsXml IS INITIAL
*            OR <fs_data>-IvaNf IS INITIAL.

      IF <fs_data>-Cenario IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CENARIO' )
                      TO reported-_019.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                      %state_area = 'CENARIO'
                      %msg        = NEW zcxca_authority_check(
                                        severity = if_abap_behv_message=>severity-error
                                        textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                            msgno = '001' ) )
                      %element-Cenario = if_abap_behv=>mk-on )
        TO reported-_019.

      ENDIF.
      IF <fs_data>-IcmsXml IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'ICMSXML' )
                       TO reported-_019.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                   %state_area = 'ICMSXML'
                   %msg        = NEW zcxca_authority_check(
                                     severity = if_abap_behv_message=>severity-error
                                     textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                         msgno = '001' ) )
                   %element-IcmsXml = if_abap_behv=>mk-on )
         TO reported-_019.
      ENDIF.

      IF <fs_data>-IvaNf IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'IVANF' )
                       TO reported-_019.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'IVANF'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           msgno = '001' ) )
                     %element-IvaNf = if_abap_behv=>mk-on )
       TO reported-_019.

      ENDIF.

      IF <fs_data>-IvaFrete IS INITIAL.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'IVAFRETE' )
                       TO reported-_019.
        APPEND VALUE #( %tky        = <fs_data>-%tky
                     %state_area = 'IVAFRETE'
                     %msg        = NEW zcxca_authority_check(
                                       severity = if_abap_behv_message=>severity-error
                                       textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                           msgno = '001' ) )
                     %element-IvaFrete = if_abap_behv=>mk-on )
       TO reported-_019.

      ENDIF.

      IF <fs_data>-Cenario IS NOT INITIAL.
        READ TABLE lt_cenario
        WITH KEY DomvalueL = <fs_data>-cenario
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'CENARIO' )
                        TO reported-_019.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'CENARIO'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Cenário/Processo'
                                                              msgno = '002' ) )
                        %element-Cenario = if_abap_behv=>mk-on )
          TO reported-_019.

        ENDIF.

      ENDIF.

      IF <fs_data>-IvaFrete IS NOT INITIAL.
        READ TABLE lt_iva
        WITH KEY IVACode = <fs_data>-IvaFrete
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'IVAFRETE' )
                        TO reported-_019.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'IVAFRETE'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Iva Frete'
                                                              msgno = '002' ) )
                        %element-Cenario = if_abap_behv=>mk-on )
          TO reported-_019.

        ENDIF.

      ENDIF.

      IF <fs_data>-IvaNf IS NOT INITIAL.
        READ TABLE lt_iva
        WITH KEY IVACode = <fs_data>-IvaNf
        BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc NE 0.
          APPEND VALUE #( %tky        = <fs_data>-%tky
                          %state_area = 'IVANF' )
                        TO reported-_019.

          APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = 'IVANF'
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = VALUE #( msgid = 'ZTM_COCKPIT_TAB'
                                                              attr1 = 'Iva NF'
                                                              msgno = '002' ) )
                        %element-Cenario = if_abap_behv=>mk-on )
          TO reported-_019.

        ENDIF.

      ENDIF.

      IF reported-_019 IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_019.
      ENDIF.


    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*CLASS lhc__003 DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS t003_Create FOR VALIDATE ON SAVE
*      IMPORTING keys FOR _003~t003_Create.
*
*    METHODS get_authorizations FOR AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR _003 RESULT result.
*
*ENDCLASS.

CLASS lhc__006 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS convcfop FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _006~convcfop.

ENDCLASS.

CLASS lhc__006 IMPLEMENTATION.

  METHOD convcfop.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
        ENTITY _006
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_tab).

    MODIFY ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
    ENTITY _006
    UPDATE SET FIELDS WITH VALUE #( FOR ls_tab IN lt_tab
                                    ( %key    = ls_tab-%key
                                      CfopInt = zcltm_conv_cfop=>conv_cfop( ls_tab-cfop )  )
                                    ) REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.

CLASS lhc__007 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS convcfop1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _007~convcfop1.

ENDCLASS.

CLASS lhc__007 IMPLEMENTATION.

  METHOD convcfop1.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
        ENTITY _007
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_tab).

    MODIFY ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
    ENTITY _007
    UPDATE SET FIELDS WITH VALUE #( FOR ls_tab IN lt_tab
                                    ( %key    = ls_tab-%key
                                      CfopInt = zcltm_conv_cfop=>conv_cfop( ls_tab-cfop )  )
                                    ) REPORTED DATA(lt_reported).

  ENDMETHOD.

ENDCLASS.

CLASS lhc__008 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS convcfop2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _008~convcfop2.

ENDCLASS.

CLASS lhc__008 IMPLEMENTATION.

  METHOD convcfop2.

    READ ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
        ENTITY _008
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_tab).

    MODIFY ENTITIES OF zi_tm_cockpit_tab IN LOCAL MODE
    ENTITY _008
    UPDATE SET FIELDS WITH VALUE #( FOR ls_tab IN lt_tab
                                    ( %key    = ls_tab-%key
                                      DcfopInt = zcltm_conv_cfop=>conv_cfop( ls_tab-dcfop )
                                      PcfopInt = zcltm_conv_cfop=>conv_cfop( ls_tab-pcfop )  )
                                    ) REPORTED DATA(lt_reported).


  ENDMETHOD.

ENDCLASS.
