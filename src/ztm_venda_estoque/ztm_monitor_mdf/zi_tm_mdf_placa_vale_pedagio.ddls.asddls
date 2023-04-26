@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e: Placas x Vale Pedágio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_PLACA_VALE_PEDAGIO
  as select from zttm_mdf_placa_v
  association        to parent ZI_TM_MDF_PLACA as _Placa      on  _Placa.Id    = $projection.Id
                                                              and _Placa.Placa = $projection.Placa
  association [1..1] to ZI_TM_MDF              as _MDF        on  _MDF.Guid = $projection.Id

  association [0..1] to ZI_CA_VH_PARTNER_PJ    as _Fornecedor on  _Fornecedor.Parceiro = $projection.Fornecedor
  association [0..1] to ZI_CA_VH_PARTNER       as _Pagador    on  _Pagador.Parceiro = $projection.Pagador
{
  key id                                as Id,
  key placa                             as Placa,
  key n_compra                          as NCompra,
      fornecedor                        as Fornecedor,

      cast( cnpjforn as abap.char(14) ) as CnpjForn,

      case when cnpjforn is initial then ''
           else concat( substring(cnpjforn, 1, 2),
                concat( '.',
                concat( substring(cnpjforn, 3, 3),
                concat( '.',
                concat( substring(cnpjforn, 6, 3),
                concat( '/',
                concat( substring(cnpjforn, 9, 4),
                concat( '-',  substring(cnpjforn, 13, 2) ) ) ) ) ) ) ) )
      end                               as CnpjFornText,

      pagador                           as Pagador,

      cast( cnpjpg as abap.char(14) )   as CnpjPg,

      case when cnpjpg is initial then ''
           else concat( substring(cnpjpg, 1, 2),
                concat( '.',
                concat( substring(cnpjpg, 3, 3),
                concat( '.',
                concat( substring(cnpjpg, 6, 3),
                concat( '/',
                concat( substring(cnpjpg, 9, 4),
                concat( '-',  substring(cnpjpg, 13, 2) ) ) ) ) ) ) ) )
      end                               as CnpjPgText,

      cast( cpfpg as abap.char(11) )    as CpfPg,

      case when cpfpg is initial then ''
           else concat( substring(cpfpg, 1, 3),
                concat( '.',
                concat( substring(cpfpg, 4, 3),
                concat( '.',
                concat( substring(cpfpg, 7, 3),
                concat( '-', substring(cpfpg, 10, 2) ) ) ) ) ) )
           end                          as CpfPgText,

      v_vale_ped                        as ValorValePed,
      @Semantics.user.createdBy: true
      created_by                        as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                        as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                   as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                   as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at             as LocalLastChangedAt,

      /* associations */
      _MDF,
      _Placa,

      _Fornecedor,
      _Pagador

}
