@EndUserText.label: 'Configuração das UFs do percurso'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_TM_MDF_PERCURSO
  as projection on zi_tm_mdf_percurso
{
  key UfOrigem,
  key UfDestino,
      UfPercurso,

      //Controle
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
