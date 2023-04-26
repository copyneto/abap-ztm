@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 014'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT014 as select from zttm_pcockpit014 
association to ZI_TM_VH_ID_CENARIO  as _CONFID on _CONFID.DomvalueL = $projection.TipoDoc
association to parent ZI_TM_COCKPIT_TAB as _Cockpit on _Cockpit.Guid = $projection.Guid
association to ZC_TM_VH_TPCUSTO  as _vhTpCusto on _vhTpCusto.VH_TpCusto = $projection.TpCustoTm
{
    key guid as Guid,
    
    key evento_extra as EventoExtra,
    @EndUserText.label: 'Cenário/Processo'
     tipo_doc as TipoDoc,
    tp_custo_tm as TpCustoTm,
    @EndUserText.label: 'Descrição'
    descricao,
    _Cockpit,
    //Associacoes
     _CONFID.Text              as TextoCenario   
}
