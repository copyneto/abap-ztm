@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF - sfir root'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_SFIR
  as select from wbrp as wbrp
{
  key wbrp.ref_doc_nr_2        as ref_doc_nr_2,
      max( wbrp.ref_doc_nr_1 ) as ref_doc_nr_1,
      max( wbrp.wbeln )        as wbeln
}
group by
  wbrp.ref_doc_nr_2
