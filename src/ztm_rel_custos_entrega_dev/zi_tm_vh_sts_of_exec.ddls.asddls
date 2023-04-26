@AbapCatalog.sqlViewName: 'ZTM_VH_SOE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Status Ordem Frete Execucao'
define view ZI_TM_VH_STS_OF_EXEC 
 as select from    I_TransportationOrderExecSts  as _StatusOrdemFrete
{
      @ObjectModel.text.element: ['Descricao']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Código'
  key TransportationOrderExecSts             as Codigo,
  
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Descricao'
      _Text[Language = $session.system_language ].TransportationOrderExecStsDesc   as Descricao
}

