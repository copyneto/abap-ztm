@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VH Transportador Trafegus'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_TRANSP_TRAFEGUS
  as select from ZI_TM_GET_TRANSP
{
      @Search.ranking: #HIGH
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: ['BusinessPartnerName']
  key BusinessPartner as BusinessPartner,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      @Semantics.text: true
      BusinessPartnerName
}  
