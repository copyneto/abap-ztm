@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Evento de impressão'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_TM_VH_PRINT_STATUS
  as select from    ppftttcu  as Print
    left outer join ppftttcut as _Text on  _Text.name  = Print.name
                                       and _Text.langu = $session.system_language
{
      @EndUserText.label: 'Tipo de ação'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Print.name as PrintName,
      @EndUserText.label: 'Descrição'
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.text as PrintText
}
where
  Print.contxtname = '/SCMTMS/TOR_PRINT_ROAD' --Ações para documentos de impressão frete rodoviário
  and Print.inactive is initial
