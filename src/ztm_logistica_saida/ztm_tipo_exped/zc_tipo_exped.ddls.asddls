@EndUserText.label: 'Condição de expedição'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_TIPO_EXPED
  as projection on ZI_TIPO_EXPED
{
  key TipoExped,
      Descricao,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
