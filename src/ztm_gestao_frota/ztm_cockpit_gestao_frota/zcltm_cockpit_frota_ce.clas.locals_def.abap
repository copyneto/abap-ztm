*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ====================================================================
* Constantes
* ====================================================================

CONSTANTS:
  BEGIN OF gc_param_hodometro,
    modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'COCKPIT_FROTA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'HODOMETRO-APONT' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE '' ##NO_TEXT,
  END OF gc_param_hodometro,

  BEGIN OF gc_param_combustivel,
    modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'COCKPIT_FROTA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'COMBUSTIVEL-APONT' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE '' ##NO_TEXT,
  END OF gc_param_combustivel,

  BEGIN OF gc_param_abastecimento,
    modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
    chave1 TYPE ztca_param_val-chave1 VALUE 'COCKPIT_FROTA' ##NO_TEXT,
    chave2 TYPE ztca_param_val-chave2 VALUE 'ABASTECIMENTO-APONT' ##NO_TEXT,
    chave3 TYPE ztca_param_val-chave3 VALUE '' ##NO_TEXT,
  END OF gc_param_abastecimento.

* ====================================================================
* Tipos
* ====================================================================

TYPES:

  BEGIN OF ty_measure_fuel,
    FreightOrder      TYPE /scmtms/tor_id,
    Equipment         TYPE /scmtms/resplatenr,
    Volume            TYPE zi_tm_cockpit_frota-MeasureFuelVolume,
    Value             TYPE zi_tm_cockpit_frota-MeasureFuelValue,
    DistanceKm        TYPE zi_tm_cockpit_frota-MeasureFuelDistanceKm,
    Stops             TYPE i,
    CurrentStop       TYPE i,
    CurrentVolume     TYPE zi_tm_cockpit_frota-MeasureFuelVolume,
    CurrentValue      TYPE zi_tm_cockpit_frota-MeasureFuelValue,
    CurrentDistanceKm TYPE zi_tm_cockpit_frota-MeasureFuelDistanceKm,
  END OF ty_measure_fuel,

  ty_t_measure_fuel TYPE SORTED TABLE OF ty_measure_fuel
                    WITH UNIQUE KEY FreightOrder Equipment,

  BEGIN OF ty_measure_depreciation,
    FreightOrder    TYPE /scmtms/tor_id,
    Equipment       TYPE /scmtms/resplatenr,
    InventoryNumber TYPE invnr,
    Value           TYPE zi_tm_cockpit_frota-MeasureDepreciationCost,
    Stops           TYPE i,
    CurrentStop     TYPE i,
    CurrentValue    TYPE zi_tm_cockpit_frota-MeasureDepreciationCost,
  END OF ty_measure_depreciation,

  ty_t_measure_depreciation TYPE SORTED TABLE OF ty_measure_depreciation
                            WITH UNIQUE KEY FreightOrder Equipment InventoryNumber,

  BEGIN OF ty_measure_washing,
    FreightOrder TYPE /scmtms/tor_id,
    Equipment    TYPE /scmtms/resplatenr,
    Value        TYPE zi_tm_cockpit_frota-MeasureWashingCost,
    Stops        TYPE i,
    CurrentStop  TYPE i,
    CurrentValue TYPE zi_tm_cockpit_frota-MeasureWashingCost,
  END OF ty_measure_washing,

  ty_t_measure_washing TYPE SORTED TABLE OF ty_measure_washing
                       WITH UNIQUE KEY FreightOrder Equipment,

  BEGIN OF ty_measure_preventive_maint,
    FreightOrder TYPE /scmtms/tor_id,
    Equipment    TYPE /scmtms/resplatenr,
    Value        TYPE zi_tm_cockpit_frota-MeasurePreventiveMaintCost,
    Stops        TYPE i,
    CurrentStop  TYPE i,
    CurrentValue TYPE zi_tm_cockpit_frota-MeasurePreventiveMaintCost,
  END OF ty_measure_preventive_maint,

  ty_t_measure_preventive_maint TYPE SORTED TABLE OF ty_measure_preventive_maint
                                WITH UNIQUE KEY FreightOrder Equipment,

  BEGIN OF ty_measure_corrective_maint,
    FreightOrder TYPE /scmtms/tor_id,
    Equipment    TYPE /scmtms/resplatenr,
    Value        TYPE zi_tm_cockpit_frota-MeasureCorrectiveMaintCost,
    Stops        TYPE i,
    CurrentStop  TYPE i,
    CurrentValue TYPE zi_tm_cockpit_frota-MeasureCorrectiveMaintCost,
  END OF ty_measure_corrective_maint,

  ty_t_measure_corrective_maint TYPE SORTED TABLE OF ty_measure_corrective_maint
                                WITH UNIQUE KEY FreightOrder Equipment,

  BEGIN OF ty_measure_documentation,
    FreightOrder TYPE /scmtms/tor_id,
    Equipment    TYPE /scmtms/resplatenr,
    Value        TYPE zi_tm_cockpit_frota-MeasureDocumentationCost,
    Stops        TYPE i,
    CurrentStop  TYPE i,
    CurrentValue TYPE zi_tm_cockpit_frota-MeasureDocumentationCost,
  END OF ty_measure_documentation,

  ty_t_measure_documentation TYPE SORTED TABLE OF ty_measure_documentation
                                  WITH UNIQUE KEY FreightOrder Equipment,

  BEGIN OF ty_measure_tires,
    FreightOrder TYPE /scmtms/tor_id,
    Equipment    TYPE /scmtms/resplatenr,
    Value        TYPE zi_tm_cockpit_frota-MeasureTiresCost,
    Stops        TYPE i,
    CurrentStop  TYPE i,
    CurrentValue TYPE zi_tm_cockpit_frota-MeasureTiresCost,
  END OF ty_measure_tires,

  ty_t_measure_tires TYPE SORTED TABLE OF ty_measure_tires
                     WITH UNIQUE KEY FreightOrder Equipment.
