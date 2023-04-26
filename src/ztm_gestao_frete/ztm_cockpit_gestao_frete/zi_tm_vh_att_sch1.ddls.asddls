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
define view entity ZI_TM_VH_ATT_SCH1
  as select from    dd07l as Domain
    left outer join dd07t as _Text on  _Text.domname    = Domain.domname
                                   and _Text.as4local   = Domain.as4local
                                   and _Text.valpos     = Domain.valpos
                                   and _Text.as4vers    = Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['AttachmentTypeText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key case when Domain.domvalue_l = '2'
           then cast( 'GNRE' as /bobf/attachment_type )
           when Domain.domvalue_l = '3'
           then cast( 'CGNRE' as /bobf/attachment_type )
           else cast( '' as /bobf/attachment_type )
           end                                     as AttachmentType,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      cast( _Text.ddtext as /bobf/bs_description ) as AttachmentTypeText

}
where
       Domain.domname    = 'ZD_GKO_ATTACH_TYPE'
  and  Domain.as4local   = 'A'
  and(
       Domain.domvalue_l = '2'
    or Domain.domvalue_l = '3'
  )
