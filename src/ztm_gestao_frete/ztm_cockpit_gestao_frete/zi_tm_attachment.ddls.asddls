@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Anexos dos documentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_ATTACHMENT
  as select from /scmtms/d_torrot as FreightOrder

    inner join   /bobf/d_atf_rt   as _Folder   on _Folder.host_key = FreightOrder.db_key

    inner join   /bobf/d_atf_do   as _Document on _Document.parent_key = _Folder.db_key

{
  key FreightOrder.tor_id        as tor_id,
      _Folder.att_schema         as att_schema,
      _Folder.storage_category   as storage_category,
      _Document.category_code    as category_code,
      _Document.mimecode         as mimecode,
      _Document.name             as name,
      _Document.alternative_name as alternative_name,
      _Document.description      as description,
      _Document.filesize_content as filesize_content,
      _Document.attachment_type  as attachment_type
}
where
  FreightOrder.tor_cat = 'TO' -- Ordem de Frete
