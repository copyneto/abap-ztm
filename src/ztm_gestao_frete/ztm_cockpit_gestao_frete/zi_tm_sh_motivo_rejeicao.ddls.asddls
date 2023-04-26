@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Motivo Rejeição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
//@ObjectModel.usageType:{
//  serviceQuality: #X,
//  sizeCategory: #S,
//  dataClass: #MIXED
//}
define view entity zi_tm_sh_motivo_rejeicao
  as select from /xnfe/notifyd as Notify
  association to /xnfe/notifyt as _Text on  _Text.doctype  = $projection.doctype
                                        and _Text.not_code = $projection.not_code
                                        and _Text.langu    = $session.system_language
{

      @UI.hidden: true
  key doctype            as doctype,
      @ObjectModel.text.element: ['Text']
  key not_code           as not_code,
      _Text.notification as Text
}
where
  Notify.doctype = 'CTE';
