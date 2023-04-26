@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 013'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT013
  as select from zttm_pcockpit013

  association to ZI_TM_VH_ID_CENARIO      as _CONFID  on _CONFID.DomvalueL = $projection.Cenario
  association to ZI_TM_VH_BRANCH          as _Rem     on _Rem.branch = $projection.RemBranch
  association to ZI_TM_VH_BRANCH          as _Tom     on _Tom.branch = $projection.TomBranch
  association to ZI_TM_VH_BRANCH          as _Dest    on _Dest.branch = $projection.DestBranch
  association to ZI_TM_VH_BRANCH          as _LocRet  on _LocRet.branch = $projection.LocRet
  association to ZI_TM_VH_BRANCH          as _LocEnt  on _LocEnt.branch = $projection.LocEnt
  association to I_CostCenterText         as _Cost    on _Cost.CostCenter = $projection.Kostl
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
{
  key guid                 as Guid,
  key guid013              as Guid013,
      uforig               as Uforig,
      ufdest               as Ufdest,
      rem_branch           as RemBranch,
      tom_branch           as TomBranch,

      dest_branch          as DestBranch,
      loc_ret              as LocRet,
      loc_ent              as LocEnt,

      cenario              as Cenario,


      kostl                as Kostl,
      saknr                as Saknr,
      @EndUserText.label: 'Descrição da Operação'
      descop,

      _Cockpit,
      //Associações
      _CONFID.Text         as TextoCenario,
      _Rem.nome            as TextoRem,
      _Tom.nome            as TextoTom,
      _Dest.nome           as TextoDest,
      _LocRet.nome         as TextoRet,
      _LocEnt.nome         as TextoEnt,
      //      _Conta.TextoConta as TextoConta,
      _Cost.CostCenterName as TextoCC
}
