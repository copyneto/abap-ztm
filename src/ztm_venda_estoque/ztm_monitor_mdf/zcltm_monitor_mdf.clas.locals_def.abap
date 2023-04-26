*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

TYPES:
  ty_agrupador   TYPE zi_tm_get_agrupador,

  ty_t_agrupador TYPE STANDARD TABLE OF ty_agrupador
                 WITH NON-UNIQUE SORTED KEY nf
                 COMPONENTS BR_NotaFiscal OrdemFrete
                 WITH NON-UNIQUE SORTED KEY of
                 COMPONENTS OrdemFrete.
