*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* CONSTANTS
* ===========================================================================

CONSTANTS:

  BEGIN OF gc_status,
    aprovado  TYPE /xnfe/statuscode VALUE '100',
    cancelado TYPE /xnfe/statuscode VALUE '101',
    encerrado TYPE /xnfe/statuscode VALUE '132',
  END OF gc_status,

  BEGIN OF gc_tpamb,
    produtivo TYPE /xnfe/tpamb VALUE '1',
    teste     TYPE /xnfe/tpamb VALUE '2',
  END OF gc_tpamb,

  BEGIN OF gc_tpemit,
    nao_transporte TYPE /xnfe/tpemit VALUE '2',
  END OF gc_tpemit,

  BEGIN OF gc_tptransp,
    etc TYPE /xnfe/tp_transp VALUE '1',
  END OF gc_tptransp,

  BEGIN OF gc_mod,
    58 TYPE /xnfe/mdfe_mod VALUE '58',
  END OF gc_mod,

  BEGIN OF gc_modal,
    rua TYPE /xnfe/mdfe_modal  VALUE '01',
  END OF gc_modal,

  BEGIN OF gc_tpemis,
    normal       TYPE /xnfe/mdfe_tpemis VALUE '1',
    contingencia TYPE /xnfe/mdfe_tpemis VALUE '2',
  END OF gc_tpemis,

  BEGIN OF gc_direct,
    entrada TYPE j_1bnfdoc-direct VALUE '1',
    saida   TYPE j_1bnfdoc-direct VALUE '2',
  END OF gc_direct,

  BEGIN OF gc_docsta,
    inicial    TYPE j_1bnfe_active-docsta VALUE space,
    autorizado TYPE j_1bnfe_active-docsta VALUE '1',
    recusado   TYPE j_1bnfe_active-docsta VALUE '2',
    rejeitado  TYPE j_1bnfe_active-docsta VALUE '3',
  END OF gc_docsta,

  BEGIN OF gc_cds,
    mdf             TYPE string VALUE 'MDF',                  " MDF
    carregamento    TYPE string VALUE 'CARREGAMENTO',         " Carregamento
    complemento     TYPE string VALUE 'COMPLEMENTO',          " Complemento
    descarregamento TYPE string VALUE 'DESCARREGAMENTO',      " Descarregamento
    emitente        TYPE string VALUE 'EMITENTE',             " Emitente
    historico       TYPE string VALUE 'HISTORICO',            " Historico
    motorista       TYPE string VALUE 'MOTORISTA',            " Motorista
    municipio       TYPE string VALUE 'MUNICIPIO',            " Municipio
    percurso        TYPE string VALUE 'PERCURSO_DOC',         " Percurso
    placa           TYPE string VALUE 'PLACA',                " Placa
    condutor        TYPE string VALUE 'CONDUTOR',             " Condutor
    valepedagio     TYPE string VALUE 'VALE_PEDAGIO',         " ValePedagio
  END OF gc_cds,

  BEGIN OF gc_text,
    cnpj_pagador TYPE string VALUE 'CNPJ Pagador' ##NO_TEXT,
    cpf_pagador  TYPE string VALUE 'CPF Pagador' ##NO_TEXT,
  END OF gc_text.
