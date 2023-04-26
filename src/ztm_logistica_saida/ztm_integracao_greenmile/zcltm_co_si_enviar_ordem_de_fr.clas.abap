class ZCLTM_CO_SI_ENVIAR_ORDEM_DE_FR definition
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
  methods SI_ENVIAR_ORDEM_DE_FRETE_OUT
    importing
      !OUTPUT type ZCLTM_MT_ORDEM_DE_FRETE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_CO_SI_ENVIAR_ORDEM_DE_FR IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLTM_CO_SI_ENVIAR_ORDEM_DE_FR'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_ENVIAR_ORDEM_DE_FRETE_OUT.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_ENVIAR_ORDEM_DE_FRETE_OUT'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
