*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ======================================================================
* Global constants
* ======================================================================

    CONSTANTS:
      BEGIN OF gc_fields,
        guid TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'Guid' ##NO_TEXT,
      END OF gc_fields,

      BEGIN OF gc_entity,
        document    TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'document' ##NO_TEXT,
        downloadPDF TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'downloadPDF' ##NO_TEXT,
      END OF gc_entity.
