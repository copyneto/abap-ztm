@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Busca Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_GET_MOTORISTA
  as select from    but000           as Pessoa
    left outer join /scmtms/d_torrot as _RootNode on Pessoa.partner = _RootNode.zz_motorista
{
  key _RootNode.tor_id  as TorId,
      Pessoa.name1_text as Nome
}
where
      Pessoa.type      =  '1'
  and _RootNode.tor_id <> ''
