@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 016'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT016 as select from zttm_pcockpit016 
association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
association to ZI_TM_VH_ID_ACAO as _Acao on _Acao.DomvalueL = $projection.Acao
association to ZI_TM_VH_ID_CODSTATUS as _Status on _Status.DomvalueL = $projection.CodstatusDe
association to ZI_TM_VH_ID_CODSTATUS as _StatusP on _StatusP.DomvalueL = $projection.CodstatusPara
{
    key guid as Guid,
    key acao as Acao,
    key codstatus_de as CodstatusDe,
    codstatus_para as CodstatusPara,
    
    _Cockpit,
    _Acao.Text as TextoAcao,
    _Status.Text as TextoStatusDe,
    _StatusP.Text as TextoStatusPara
}
