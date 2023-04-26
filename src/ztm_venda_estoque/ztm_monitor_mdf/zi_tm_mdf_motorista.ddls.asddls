@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_MOTORISTA
  as select from zttm_mdf_moto as Motorista

  association        to parent ZI_TM_MDF      as _MDF    on _MDF.Guid = $projection.Id
  association [0..1] to ZI_TM_MDF_MOTORISTA_L as _Ultimo on _Ultimo.Id = $projection.Id
  association [0..1] to ZI_TM_VH_MOTORISTA    as _Moto   on _Moto.Parceiro = $projection.Motorista
{
  key Motorista.id                    as Id,
  key Motorista.line                  as Line,
  key Motorista.motorista             as Motorista,
      _Moto.CPF                       as CPF,
      _Moto.CPFText                   as CPFText,
      _Moto.Nome                      as Nome,

      case when Motorista.line = _Ultimo.Line
      then cast( 'X' as boole_d )
      else cast( '' as boole_d ) end  as AtualMotorista,

      case when Motorista.line = _Ultimo.Line
      then 3
      else 0 end                      as Criticality,

      @Semantics.user.createdBy: true
      Motorista.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Motorista.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Motorista.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Motorista.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Motorista.local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _MDF,
      _Moto
}
