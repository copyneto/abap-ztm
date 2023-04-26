@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Configuração das UFs do percurso'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_tm_mdf_percurso
  as select from zttm_mdf_perc
{
      @EndUserText.label : 'UF origem do transporte'
  key uf_orig               as UfOrigem,
      @EndUserText.label : 'UF destino do transporte'
  key uf_dest               as UfDestino,
      @EndUserText.label : 'UFs do Percurso'
      uf_percuso            as UfPercurso,

      //Controle
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
