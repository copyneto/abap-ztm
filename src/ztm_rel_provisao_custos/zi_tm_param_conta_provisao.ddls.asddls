@AbapCatalog.sqlViewName: 'ZITMPARCTPROV'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro Data de Saída NFe'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_TM_PARAM_CONTA_PROVISAO
  as select from ztca_param_val
{
  key modulo               as Modulo,
  key chave1               as Chave1,
  key chave2               as Chave2,
  key chave3               as Chave3,
  key cast( low as hkont ) as Account

}
where
      modulo = 'TM'
  and chave1 = 'CONTA_PROVISAO'
  and chave2 = 'HKONT'
