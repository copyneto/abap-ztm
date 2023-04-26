@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação Contas - Motorista (nó Party)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PRESTACAO_MOTORISTA_PTY
  as select from /scmtms/d_torpty
  association [0..1] to but000 as _Parceiro on _Parceiro.partner = $projection.DriverId
{
  key parent_key as ParentUUID,
  key node_key   as DriverUUID,
      party_id   as DriverId,

      case
        when length( _Parceiro.name1_text ) < 1
         then concat_with_space(_Parceiro.name_first, _Parceiro.name_last, 1 )
        else _Parceiro.name1_text
      end        as DriverName
}
where
  party_rco = 'YM'
