@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Histórico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_HISTORICO_MSG
  as select from zttm_mdf_hist
{
  key id                    as Id,
  key histcount             as Histcount,
  key event                 as Event,
      msgid                 as Msgid,
      msgno                 as Msgno,
      msgv1                 as Msgv1,
      msgv2                 as Msgv2,
      msgv3                 as Msgv3,
      msgv4                 as Msgv4,
      ''                    as Message
}
