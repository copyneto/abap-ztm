@EndUserText.label: 'Informações MDF-e : Percurso'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MDF_PERCURSO_DOC
  as projection on ZI_TM_MDF_PERCURSO_DOC
{
  key Id,
      @ObjectModel.text.element: ['UfInicioText']
      UfInicio,
      @ObjectModel.text.element: ['UfFimText']
      UfFim,
      _RegioIni.RegionName as UfInicioText,
      _RegioFim.RegionName as UfFimText,
      Percurso,
      PercursoCriticality,

      /* Associations */
      _MDF : redirected to parent ZC_TM_MDF
}
