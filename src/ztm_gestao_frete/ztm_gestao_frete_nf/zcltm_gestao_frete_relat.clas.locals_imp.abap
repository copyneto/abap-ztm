*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CONSTANTS:

  BEGIN OF gc_formname,
    cte_comp TYPE tdsfname VALUE 'ZSFTM_DACTE_COMPL',
    cte      TYPE tdsfname VALUE 'ZSFTM_DACTE',
    nf       TYPE tdsfname VALUE 'ZSFTM_NFE',
  END OF gc_formname,

      "! Impressora local
    gc_device   TYPE rspoptype VALUE 'LOCL'.
