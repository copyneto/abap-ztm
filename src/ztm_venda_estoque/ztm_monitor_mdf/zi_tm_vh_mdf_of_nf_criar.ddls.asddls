@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Frete X Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_MDF_OF_NF_CRIAR
  as select from ZI_TM_VH_ORDEM_FRETE_PLACA as _OrdemFrete
    inner join   ZI_TM_VH_EQUNR             as _Placa on _Placa.Equipamento = _OrdemFrete.PlacaCaminhao

{
  key substring( _OrdemFrete.FreightOrder, 11, 10) as FreightOrder
}
group by
  _OrdemFrete.FreightOrder
