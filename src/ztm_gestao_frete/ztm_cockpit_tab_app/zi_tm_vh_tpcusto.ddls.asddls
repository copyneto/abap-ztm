@AbapCatalog.sqlViewName: 'ZI_TM_NF_TPCUSTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Tipo de Custo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_TPCUSTO as select from /scmtms/c_tcet 
{
    @Search.ranking: #MEDIUM
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @EndUserText.label: 'Tipo de Custo' 
    key tcet084 as TpCusto
}
