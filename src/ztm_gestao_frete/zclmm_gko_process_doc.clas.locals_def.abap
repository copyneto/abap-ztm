*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ====================================================================
* Constantes
* ====================================================================

CONSTANTS:
  BEGIN OF gc_param_ctg_irf,
    modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'COD_RETENCAO' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'CTG_IRF' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE '' ##NO_TEXT,
  END OF gc_param_ctg_irf.
