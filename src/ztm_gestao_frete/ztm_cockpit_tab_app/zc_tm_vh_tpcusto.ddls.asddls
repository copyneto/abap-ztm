@AbapCatalog.sqlViewName: 'ZC_TM_TPCUSTO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Tipo de Custo'
define view ZC_TM_VH_TPCUSTO as select from ZI_TM_VH_TPCUSTO 

{
    @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key TpCusto as VH_TpCusto 
}
