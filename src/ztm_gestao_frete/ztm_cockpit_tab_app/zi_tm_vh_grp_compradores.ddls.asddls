@AbapCatalog.sqlViewName: 'ZI_VH_GRP_COMP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta grupo de compradores'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_GRP_COMPRADORES as select from t024
{
    @UI.textArrangement: #TEXT_LAST
    @Search.ranking: #MEDIUM
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    key ekgrp,
    eknam as Descricao
}
