@AbapCatalog.sqlViewName: 'ZVTM_CFOP_CONFIG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CFOPs válidos para anexo de arquivos'
define view ZI_TM_VH_FRETE_CFOP_CONFIG
  as select from zttm_pcockpit007
{
  key cfop as cfop
}
union select from zttm_pcockpit007
{
  key cast( left( cfop, 4 ) as logbr_cfopcode ) as cfop
}
