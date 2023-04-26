@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Anexos dos documentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_ATTACHMENT_FILE
  as select from ZI_TM_ATTACHMENT
{
  key tor_id                                            as tor_id,
  key cast( description as j_1b_nfe_access_key_dtel44 ) as acckey,

      sum( case when attachment_type = 'GNRE'
           then 1
           else 0 end )                                 as anexo_gnre,

      sum( case when attachment_type = 'CGNRE'
           then 1
           else 0 end )                                 as comprovante_gnre,

      sum( case when attachment_type = 'NFS'
           then 1
           else 0 end )                                 as comprovante_nfs
}
group by
  tor_id,
  description
