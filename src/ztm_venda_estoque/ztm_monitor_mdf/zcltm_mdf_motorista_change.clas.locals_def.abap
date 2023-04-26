*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CONSTANTS: gc_kind TYPE but000-bpkind VALUE '0011',

           BEGIN OF gc_msg_no,
             m_034 TYPE sy-msgno VALUE '034',
             m_035 TYPE sy-msgno VALUE '035',
             m_036 TYPE sy-msgno VALUE '036',
           END OF gc_msg_no,

           gc_mg_id TYPE sy-msgid VALUE 'ZTM_MDF'.
