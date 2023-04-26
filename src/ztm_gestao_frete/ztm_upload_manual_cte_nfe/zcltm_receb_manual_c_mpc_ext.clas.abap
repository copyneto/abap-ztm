CLASS zcltm_receb_manual_c_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcltm_receb_manual_c_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS define
        REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_receb_manual_c_mpc_ext IMPLEMENTATION.


  METHOD define.

    super->define( ).

    DATA: lo_entity   TYPE REF TO  /iwbep/if_mgw_odata_entity_typ,
          lo_property TYPE REF TO  /iwbep/if_mgw_odata_property.

    lo_entity = model->get_entity_type( iv_entity_name = gc_entity-document ).

    IF lo_entity IS BOUND.
      lo_property = lo_entity->get_property( iv_property_name = gc_fields-guid ).
      lo_property->set_as_content_type( ).
    ENDIF.

    lo_entity = model->get_entity_type( iv_entity_name = gc_entity-downloadpdf ).

    IF lo_entity IS BOUND.
      lo_property = lo_entity->get_property( iv_property_name = gc_fields-guid ).
      lo_property->set_as_content_type( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
