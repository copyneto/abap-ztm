@AbapCatalog.sqlViewAppendName: 'ZITORITEMEXT'
@EndUserText.label: 'Extension - ZI_TRANSPORTATIONORDERITEM'
extend view ZI_TRANSPORTATIONORDERITEM with ZI_TRANSPORTATIONORDERITEMEXT
{
  item.base_btd_key  as TranspOrdDocReferenceKey,
  item.orig_ref_root as TranspOrigRefRoot
}
