@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - Normal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_DOCDFF_NORMAL
  as select from    ZI_TM_COCKPIT001_DOCDFF as dff

    left outer join ZI_TM_COCKPIT001_DOCDFF as _normal on  _normal.tor_id   = dff.tor_id
                                                       and _normal.tpevento = 'NORMAL'
{
  key dff.tor_id                      as tor_id,

      max( case when _normal.tpevento is not null
                then _normal.db_key
                else dff.db_key end ) as db_key
}
where
  dff.tpevento = 'FRETE_SAIDA'
  or 
  dff.tpevento = 'FRETE_ENTRADA'
  or 
  dff.tpevento = 'FRETE_TRANSFER'
group by
  dff.tor_id
