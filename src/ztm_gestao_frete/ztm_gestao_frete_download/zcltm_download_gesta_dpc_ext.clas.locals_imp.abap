*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
* ===========================================================================
* GLOBAL CONSTANTS
* ===========================================================================

TYPES:     ty_t_key_tab TYPE SORTED TABLE OF /iwbep/s_mgw_name_value_pair
                        WITH NON-UNIQUE KEY name,
           BEGIN OF ty_acckey,
             regio   TYPE j_1bnfe_active-regio,
             nfyear  TYPE j_1bnfe_active-nfyear,
             nfmonth TYPE j_1bnfe_active-nfmonth,
             stcd1   TYPE j_1bnfe_active-stcd1,
             model   TYPE j_1bnfe_active-model,
             serie   TYPE j_1bnfe_active-serie,
             nfnum9  TYPE j_1bnfe_active-nfnum9,
             docnum9 TYPE j_1bnfe_active-docnum9,
             cdv     TYPE j_1bnfe_active-cdv,
           END OF ty_acckey.

CONSTANTS: BEGIN OF gc_name,
             acckey  TYPE string VALUE 'Acckey' ##NO_TEXT,
             doctype TYPE string VALUE 'Doctype' ##NO_TEXT,
             auto    TYPE string VALUE 'Auto' ##NO_TEXT,
           END OF gc_name,

           BEGIN OF gc_entity,
             download      TYPE string VALUE 'download' ##NO_TEXT,
             downloadCheck TYPE string VALUE 'downloadCheck' ##NO_TEXT,
           END OF gc_entity.
