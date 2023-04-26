@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Log Alter. Motorista'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_TM_MDF_HIST_MOTORISTA
  as projection on ZI_TM_MDF_HIST_MOTORISTA as _Historico
{
  key Guid,
  key Docnum,
      Data,
      Hora,
      Uname,
      @Consumption.groupWithElement: 'Placa_New'
      @EndUserText.label: 'Placa Anterior'
      Placa_Old,
      @EndUserText.label: 'Placa Atual'
      Placa_New,
      @Consumption.groupWithElement: 'Condutor_New'
      @EndUserText.label: 'Motorista Anterior'
      Condutor_Old,
      @EndUserText.label: 'Motorista Atual'
      Condutor_New,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Writer : redirected to parent ZC_TM_MDF_MOTORISTA_CHANGE
}
