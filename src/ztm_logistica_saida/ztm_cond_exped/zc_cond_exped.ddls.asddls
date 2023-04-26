@EndUserText.label: 'Condição de expedição'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_COND_EXPED
  as projection on ZI_COND_EXPED
{
  key CondExped,
      Descricao,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
