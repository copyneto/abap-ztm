@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: MDF-e Criadas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_MDF
  as select from ZI_TM_MDF
{
  key BR_MDFeNumber,
      @EndUserText.label: 'Agrupador'
      Agrupador

}
where
  BR_MDFeNumber <> '000000000'
