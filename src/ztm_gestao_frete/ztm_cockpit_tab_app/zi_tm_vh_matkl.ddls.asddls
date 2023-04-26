@AbapCatalog.sqlViewName: 'ZI_TM_MATKL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Grupo de Mercadoria'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_MATKL as select from t023 as t023 
inner join t023t as _Text on t023.matkl = _Text.matkl                                
                                 and _Text.spras = $session.system_language
{

  @ObjectModel.text.element: ['TextoMATKL']
  @UI.textArrangement: #TEXT_LAST
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  key t023.matkl as MATKL ,
   _Text.wgbez  as TextoMATKL
    
}
