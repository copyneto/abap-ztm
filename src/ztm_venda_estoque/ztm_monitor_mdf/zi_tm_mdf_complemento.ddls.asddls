@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Dados Complementares'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_COMPLEMENTO
  as select from zttm_mdf_ide

  association        to parent ZI_TM_MDF       as _MDF      on _MDF.Guid = $projection.Id

  association [0..1] to ZI_TM_MDF_TOTALS       as _Total    on _Total.Guid = $projection.Id
  association [0..1] to ZI_CA_VH_REGIO_BR      as _Regio    on _Regio.Region = $projection.Uf
  association [0..1] to ZI_CA_VH_XNFE_TPAMB    as _TpAmb    on _TpAmb.TpAmb = $projection.TpAmb
  association [0..1] to ZI_CA_VH_XNFE_TPEMIT   as _TpEmit   on _TpEmit.TpEmit = $projection.TpEmit
  association [0..1] to ZI_CA_VH_XNFE_TPTRANSP as _TpTransp on _TpTransp.TpTransp = $projection.TpTransp
  association [0..1] to ZI_CA_VH_XNFE_MOD      as _Mod      on _Mod.Mod = $projection.Mod
  association [0..1] to ZI_CA_VH_XNFE_MODAL    as _Modal    on _Modal.Modal = $projection.Modal
  association [0..1] to ZI_CA_VH_XNFE_TPEMIS   as _TpEmis   on _TpEmis.TpEmis = $projection.TpEmis
{
  key id                                                            as Id,

      case when c_uf is not initial
           then c_uf
           else cast( substring( _Total.Carga, 1, 3) as regio ) end as Uf,

      tp_amb                                                        as TpAmb,

      case tp_amb
      when '1' then 3
      when '2' then 2
               else 0 end                                           as TpAmbCriticality,

      tp_emit                                                       as TpEmit,
      tp_transp                                                     as TpTransp,
      mod                                                           as Mod,
      c_mdf                                                         as CMdf,
      c_dv                                                          as CDv,
      modal                                                         as Modal,
      dh_emi                                                        as DhEmi,
      tp_emis                                                       as TpEmis,

      case tp_emis
      when '1' then 3
      when '2' then 2
               else 0 end                                           as TpEmisCriticality,

      @Semantics.user.createdBy: true
      created_by                                                    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                                    as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                                               as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                               as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                         as LocalLastChangedAt,

      /* associations */
      _MDF,
      _Regio,
      _TpAmb,
      _TpEmit,
      _TpTransp,
      _Mod,
      _Modal,
      _TpEmis
}
