@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Placas x Condutores'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_PLACA_CONDUTOR
  as select from zttm_mdf_placa_c
  association        to parent ZI_TM_MDF_PLACA as _Placa on  _Placa.Id    = $projection.Id
                                                         and _Placa.Placa = $projection.Placa
  association [1..1] to ZI_TM_MDF              as _MDF   on  _MDF.Guid = $projection.Id

{
  key id                           as Id,
  key placa                        as Placa,
  key condutor                     as Condutor,
      cast( cpf as abap.char(11) ) as Cpf,

      case when cpf is initial then ''
           else concat( substring(cpf, 1, 3),
                concat( '.',
                concat( substring(cpf, 4, 3),
                concat( '.',
                concat( substring(cpf, 7, 3),
                concat( '-', substring(cpf, 10, 2) ) ) ) ) ) )
           end                     as CPFText,

      x_nome                       as Nome,
      @Semantics.user.createdBy: true
      created_by                   as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                   as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by              as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at              as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at        as LocalLastChangedAt,

      /* associations */
      _MDF,
      _Placa
}
