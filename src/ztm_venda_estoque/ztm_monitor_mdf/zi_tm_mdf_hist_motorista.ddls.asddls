@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Log Alter. Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HIST_MOTORISTA
  as select from zttm_mdfe_hist
  association to parent ZI_TM_MDF_MOTORISTA_CHANGE as _Writer on $projection.Docnum = _Writer.Docnum
{
  key guid                  as Guid,
  key docnum                as Docnum,
      data                  as Data,
      hora                  as Hora,
      uname                 as Uname,
      placa                 as Placa_Old,
      placa_nova            as Placa_New,
      condutor              as Condutor_Old,
      condutor_novo         as Condutor_New,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      
      _Writer
}
