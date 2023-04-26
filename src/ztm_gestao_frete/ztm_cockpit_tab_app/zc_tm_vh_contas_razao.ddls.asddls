@AbapCatalog.sqlViewName: 'ZC_TM_RAZAO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Contas do Razão'
define view ZC_TM_VH_CONTAS_RAZAO as select from ZI_TM_VH_CONTAS_RAZAO 

{   
     
    @UI.textArrangement: #TEXT_LAST
    @Search.ranking: #MEDIUM
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    key saknr,
//     @UI.hidden: true
//    ktopl,  
    TextoConta    
}
