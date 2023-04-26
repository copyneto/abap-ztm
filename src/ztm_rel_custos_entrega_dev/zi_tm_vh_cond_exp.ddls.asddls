@AbapCatalog.sqlViewName: 'ZTM_VH_CE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Condição de Expedição'
define view ZI_TM_VH_COND_EXP 
 as select from    zttm_cond_exped  as _CondicaoExpedicao
{
      @ObjectModel.text.element: ['Descricao']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Código'
  key cond_exped            as CondExped,
  
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Cond. Expedição'
      descricao             as Descricao
}
