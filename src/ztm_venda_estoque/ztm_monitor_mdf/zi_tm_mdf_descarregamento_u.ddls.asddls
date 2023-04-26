@AbapCatalog.sqlViewName: 'ZVTM_MDF_DCARGA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Descarregam. (Union)'
define view ZI_TM_MDF_DESCARREGAMENTO_U
  as select from zttm_mdf
{
  key id                              as Id,
  key domfiscalfim                    as TaxJurCode,
      substring( domfiscalfim, 1, 2 ) as Region
}
where
  domfiscalfim is not initial

union select from ZI_TM_MDF_MUNICIPIO as _Municipio
  inner join      ZI_TM_MDF           as _Cabec on _Cabec.Guid = _Municipio.Guid
{
  key _Municipio.Guid                        as Id,
  key _Municipio.Descarga                    as TaxJurCode,
      substring( _Municipio.Descarga, 1, 2 ) as Region
}
where
      _Municipio.Descarga is not initial
  and _Cabec.Manual       is initial
group by
  _Municipio.Guid,
  _Municipio.Descarga
