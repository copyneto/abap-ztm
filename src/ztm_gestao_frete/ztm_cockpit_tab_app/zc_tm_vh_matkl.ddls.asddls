@AbapCatalog.sqlViewName: 'ZC_TM_MATKL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Grupo de Mercadoria'
define view ZC_TM_VH_MATKL as select from ZI_TM_VH_MATKL 
{

  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  @EndUserText.label: 'Grupo Mercadoria'
  key MATKL ,
  
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  @EndUserText.label: 'Descrição'
  TextoMATKL  
    
}
