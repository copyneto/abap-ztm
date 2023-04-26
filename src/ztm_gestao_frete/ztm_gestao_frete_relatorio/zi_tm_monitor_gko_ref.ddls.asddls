@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor GKO - Referências'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MONITOR_GKO_REF
  as select from zttm_gkot003
  association        to parent ZI_TM_MONITOR_GKO as _monitor      on _monitor.acckey = $projection.acckey

  association [0..1] to ZI_TM_VH_PROD_ACABADO    as _prod_acabado on _prod_acabado.prod_acabado = $projection.prod_acabado

{
  key acckey,
  key acckey_ref,
      acckey_orig,
      docnum              as BR_NotaFiscal,
      prod_acabado,
      _prod_acabado.desc_prod_acabado,

      case prod_acabado
      when '0' then 1 -- Não
      when '1' then 3 -- Sim, todos os itens
      when '2' then 2 -- Parcial, somente alguns itens
               else 0 end as crit_prod_acabado,

      /* Associations */
      _monitor
}
