class ZCLTM_CO_SI_CONSULTA_SESSAO_OU definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods SI_CONSULTA_SESSAO_OUT
    importing
      !OUTPUT type ZCLTM_MT_CONSULTA_SESSAO
    exporting
      !INPUT type ZCLTM_MT_CONSULTA_SESSAO_RESP
    raising
      CX_AI_SYSTEM_FAULT
      ZCLTM_CX_FMT_CONSULTA_SESSAO_E .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_CO_SI_CONSULTA_SESSAO_OU IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLTM_CO_SI_CONSULTA_SESSAO_OU'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_CONSULTA_SESSAO_OUT.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
    ( name = 'INPUT' kind = '1' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_CONSULTA_SESSAO_OUT'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
