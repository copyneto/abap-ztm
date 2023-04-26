*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

    CONSTANTS:
      BEGIN OF gc_field,
        id         TYPE string VALUE 'Id' ##NO_TEXT,
        accesskey  TYPE string VALUE 'AccessKey' ##NO_TEXT,
        ordemfrete TYPE string VALUE 'OrdemFrete' ##NO_TEXT,
        carga      TYPE string VALUE 'Carga' ##NO_TEXT,
      END OF gc_field,

      gc_filename TYPE string VALUE 'Mdf-e.pdf' ##NO_TEXT.
