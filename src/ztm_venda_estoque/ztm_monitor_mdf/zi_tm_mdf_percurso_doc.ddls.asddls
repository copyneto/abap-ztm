@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Percurso'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_PERCURSO_DOC
  as select from    zttm_mdf
    inner join      ZI_TM_MDF          as Header    on Header.Guid = zttm_mdf.id
    left outer join zi_tm_mdf_percurso as _Percurso on  _Percurso.UfOrigem  = Header.UfInicio
                                                    and _Percurso.UfDestino = Header.UfFim
  association        to parent ZI_TM_MDF  as _MDF      on _MDF.Guid = $projection.Id
  association [0..1] to ZI_CA_VH_REGIO_BR as _RegioIni on _RegioIni.Region = $projection.UfInicio
  association [0..1] to ZI_CA_VH_REGIO_BR as _RegioFim on _RegioFim.Region = $projection.UfFim
{
  key Header.Guid          as Id,
      Header.UfInicio      as UfInicio,
      Header.UfFim         as UfFim,
      _Percurso.UfPercurso as UfPercurso,
      _Percurso.UfPercurso as Percurso,

      case when _Percurso.UfPercurso is not initial
           then 3
           else 1 end      as PercursoCriticality,

      /* associations */
      _MDF,
      _RegioIni,
      _RegioFim
}
