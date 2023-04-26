@AbapCatalog.sqlViewName: 'ZI_VH_TPDOCCOMP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta tipo de documento de compras'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view ZI_TM_VH_TPDOCCOMP
  as select from t161 as _T161
  association to t161t as _T161T on  _T161T.bstyp = $projection.bstyp
                                 and _T161T.bsart = $projection.bsart
                                 and _T161T.spras = $session.system_language
{
   @UI.hidden: true
  key _T161.bstyp,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Tipo de Doc'
      @ObjectModel.text.element: ['TextoTpDocComp']
  key _T161.bsart,
  
  @EndUserText.label: 'Descricao'  
  _T161T.batxt as TextoTpDocComp

}
 where
  bstyp = 'F'
