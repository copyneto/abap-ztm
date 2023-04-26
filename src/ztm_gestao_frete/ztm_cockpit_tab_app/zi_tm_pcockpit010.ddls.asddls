@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 010'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT010
  as select from zttm_pcockpit010
  association        to ZC_MM_VH_MWSKZ           as _MWSKZ   on _MWSKZ.IVACode = $projection.Mwskz
  association        to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
  association        to ZC_TM_VH_CONTAS_RAZAO    as _Conta   on _Conta.saknr = $projection.Saknr
  association [0..1] to ZC_TM_VH_NFTYPE          as _NFTYPE  on _NFTYPE.nftype = $projection.Nftype
{
  key    guid               as Guid,
  key    guid10             as Guid10,
  key    mwskz              as Mwskz,
  key    nftype             as Nftype,
         saknr              as Saknr,

         //  key rem_uf            as RemUf,

         rem_uf             as RemUf,


         _Conta.TextoConta  as TextoConta,
         _NFTYPE.TextoNFType,
         _MWSKZ.IVACodeName as TextoIva,
         _Cockpit
}
