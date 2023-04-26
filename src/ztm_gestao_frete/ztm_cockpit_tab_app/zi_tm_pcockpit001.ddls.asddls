@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 001'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_PCOCKPIT001
  as select from zttm_pcockpit001
  association to ZI_TM_VH_ID  as _CONFID on _CONFID.DomvalueL = $projection.Id
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
  key guid      as Guid,  
      @Search.defaultSearchElement: true
      key id    as Id,
      parametro as Parametro,     
      _Cockpit,
      
  //Associações
      _CONFID.Text              as TextoParametro
      
}
