@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela de Log - zttm_gkot006'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT006
  as select from zttm_gkot006
  association        to parent ZI_TM_COCKPIT001  as _Cockpit   on _Cockpit.acckey = $projection.Acckey

  association [0..1] to ZI_TM_VH_FRETE_CODSTATUS as _Codstatus on _Codstatus.codstatus = $projection.Codstatus
  association [0..1] to ZI_TM_VH_FRETE_TPPROCESS as _Tpprocess on _Tpprocess.tpprocess = $projection.Tpprocess
  association [0..1] to ZI_CA_VH_USER            as _Crenam    on _Crenam.Bname = $projection.Crenam
{
  key zttm_gkot006.acckey      as Acckey,
  key zttm_gkot006.counter     as Counter,
      zttm_gkot006.codstatus   as Codstatus,
      _Codstatus.codstatus_txt as CodstatusText,

      case left(zttm_gkot006.codstatus, 1)
      when ' ' then 0
      when 'E' then 1
               else 3 end      as CodstatusCrit,

      zttm_gkot006.tpprocess   as Tpprocess,
      _Tpprocess.tpprocess_txt as TpprocessText,

      case zttm_gkot006.tpprocess
      when '1' then 3
      when '2' then 2
               else 0 end      as TpprocessCrit,

      zttm_gkot006.newdoc      as Newdoc,
      zttm_gkot006.codigo      as Codigo,
      zttm_gkot006.desc_codigo as DescCodigo,
      zttm_gkot006.credat      as Credat,
      zttm_gkot006.cretim      as Cretim,
      zttm_gkot006.crenam      as Crenam,
      _Crenam.Text             as CrenamText,

      _Cockpit
}
