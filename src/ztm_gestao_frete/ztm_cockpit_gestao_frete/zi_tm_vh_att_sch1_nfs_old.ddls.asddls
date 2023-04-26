@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Tipos de Anexo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_ATT_SCH1_NFS_OLD
  as select from    /bobf/c_att_sch1 as Attachment

    left outer join /bobf/c_att_typt as _Text on  _Text.attachment_type = Attachment.attachment_type
                                              and _Text.language        = $session.system_language
{
      @ObjectModel.text.element: ['AttachmentTypeText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Attachment.attachment_type as AttachmentType,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.description          as AttachmentTypeText

}
where
      Attachment.att_schema      = 'TM_COCKPIT'
  and Attachment.attachment_type = 'NFS'
