@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GKO - Cenários'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_GKO_VH_CENARIO
  as select from    dd07l as Domain
    left outer join dd07t as Text on  Text.domname    = Domain.domname
                                  and Text.as4local   = Domain.as4local
                                  and Text.valpos     = Domain.valpos
                                  and Text.as4vers    = Domain.as4vers
                                  and Text.ddlanguage = $session.system_language
{
       @ObjectModel.text.element: ['Name']
  key  Domain.domvalue_l as CenarioCode,
       Text.ddtext       as Name
}
where
  Domain.domname = 'ZD_GKO_CENARIO'
