FUNCTION zfmtm_param_roadnet_importar.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_CENTRO) TYPE  WERKS_D
*"     VALUE(IV_DATA) TYPE  SYDATUM
*"     VALUE(IV_DATA_ATE) TYPE  SYDATUM OPTIONAL
*"     VALUE(IV_SESSAO) TYPE  ZTTM_ROAD_SESSIO-ID_SESSION_ROADNET
*"     VALUE(IT_ROUTES) TYPE  ZCTGTM_ROUTE_ID
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  CALL FUNCTION 'ENQUEUE_EZ_TM_ROADNET'
    EXPORTING
      werks          = iv_centro
      dtsession      = iv_data
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc = 0.
**********************************************************************
*    IF sy-uname = 'CGARCIA'.
    et_messages = NEW zcltm_roadnet_integration( )->execute( "#EC CI_CONV_OK
    VALUE #(
      region_identity = iv_centro
      date_start      = iv_data
      date_end        = iv_data_ate
      routes          = it_routes
    ) ).
    IF line_exists( et_messages[ message = 'CROSSDOCKING' ] ).
*    ELSE.
      DATA: lo_interface TYPE REF TO ziftm_integracao_roadnet.

      lo_interface ?= NEW zcltm_process_roadnet( ).

      lo_interface->executar(
        EXPORTING
          iv_centro   = iv_centro
          iv_data     = iv_data
          iv_data_ate = iv_data_ate
          iv_sessao   = iv_sessao
        IMPORTING
          et_messages = et_messages
      ).
    ENDIF.
  ENDIF.

  CALL FUNCTION 'DEQUEUE_EZ_TM_ROADNET'
    EXPORTING
      werks     = iv_centro
      dtsession = iv_data.

ENDFUNCTION.
