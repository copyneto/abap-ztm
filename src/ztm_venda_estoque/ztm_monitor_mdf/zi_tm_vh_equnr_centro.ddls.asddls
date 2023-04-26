@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Placa X Centro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_EQUNR_CENTRO
  as select from    equz as Intervalo

    left outer join iloa as _Localizacao on _Localizacao.iloan = Intervalo.iloan

{
  key Intervalo.equnr    as Equipamento,
      Intervalo.datbi    as DataValidade,
      Intervalo.eqlfn    as Sequencial,
      Intervalo.iloan    as Localizacao,
      _Localizacao.swerk as Centro

}
where
  Intervalo.datbi >= $session.system_date
