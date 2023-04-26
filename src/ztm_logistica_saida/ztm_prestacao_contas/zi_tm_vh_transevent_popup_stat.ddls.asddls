@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Eventos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_TM_VH_TRANSEVENT_POPUP_STAT
  as select from I_TranspOrdEventCode
{
      @ObjectModel.text.element: ['TranspOrdEventCodeDesc']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
   key TranspOrdEventCode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
  _Text[ 1:Language = $session.system_language ].TranspOrdEventCodeDesc

  }
  where TranspOrdEventCode = 'ENTREGUE'
     or TranspOrdEventCode = 'DEVOLVIDO'
     or TranspOrdEventCode = 'PENDENTE'
     or TranspOrdEventCode = 'SINISTRO'
     or TranspOrdEventCode = 'COLETADO'
     or TranspOrdEventCode = 'NÃO COLETADO'
