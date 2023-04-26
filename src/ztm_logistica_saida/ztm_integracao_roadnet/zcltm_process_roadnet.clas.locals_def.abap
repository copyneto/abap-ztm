*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ====================================================================
* Constantes
* ====================================================================

CONSTANTS:
  BEGIN OF gc_param_entrega,
    modulo TYPE ztca_param_val-modulo VALUE 'TM'                ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'ROADNET'           ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'ENTREGA'           ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'SESSAO'            ##NO_TEXT,
  END OF gc_param_entrega,

  BEGIN OF gc_param_crossdocking,
    modulo TYPE ztca_param_val-modulo VALUE 'TM'                ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'ROADNET'           ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'CROSSDOCKING'      ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'SESSAO'            ##NO_TEXT,
  END OF gc_param_crossdocking,

  BEGIN OF gc_param_redespacho,
    modulo TYPE ztca_param_val-modulo VALUE 'TM'                ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'ROADNET'           ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'REDESPACHO'        ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE 'SESSAO'             ##NO_TEXT,
  END OF gc_param_redespacho.
