@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Condição de expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TIPO_EXPED
  as select from zttm_tipo_exped
{

      @EndUserText: {
          label: 'Tipo de expedição',
          quickInfo: 'Tipo de expedição'
      }
  key tipo_exped           as TipoExped,

      @EndUserText: {
            label: 'Descrição',
            quickInfo: 'Descrição'
        }
      descricao             as Descricao,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt

}
