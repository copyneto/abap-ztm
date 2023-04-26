@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - Entrega'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_DOCDFF_ENTR
  as select from    ZI_TM_COCKPIT001_DOCDFF as dff

    left outer join ZI_TM_COCKPIT001_DOCDFF as _entrega on  _entrega.tor_id   = dff.tor_id
                                                        and _entrega.tpevento = 'ENTREGA'
{
  key dff.tor_id                      as tor_id,

      max( case when _entrega.tpevento is not null
                then _entrega.db_key
                else dff.db_key end ) as db_key
}
where
  dff.tpevento = 'FRETE_SAIDA'
group by
  dff.tor_id
