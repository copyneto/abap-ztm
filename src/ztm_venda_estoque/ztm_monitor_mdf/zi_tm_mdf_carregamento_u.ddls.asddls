@AbapCatalog.sqlViewName: 'ZVTM_MDF_CARGA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Carregamento (Union)'
define view ZI_TM_MDF_CARREGAMENTO_U
  as select from zttm_mdf
{
  key id                              as Id,
  key domfiscalini                    as TaxJurCode,
      substring( domfiscalini, 1, 2 ) as Region
}
where
  domfiscalini is not initial

//union select from ZI_TM_MDF_MUNICIPIO
//{
//  key Guid                     as Id,
//  key Carga                    as TaxJurCode,
//      substring( Carga, 1, 2 ) as Region
//}
//where
//  Carga is not initial
//group by
//  Guid,
//  Carga
