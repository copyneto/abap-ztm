@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Placas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_PLACA
  as select from zttm_mdf_placa as Header
  association        to parent ZI_TM_MDF             as _MDF         on _MDF.Guid = $projection.Id

  composition [0..*] of ZI_TM_MDF_PLACA_CONDUTOR     as _Condutor
  composition [0..*] of ZI_TM_MDF_PLACA_VALE_PEDAGIO as _ValePedagio

  association [0..1] to ZI_TM_VH_EQUNR               as _Equipamento on _Equipamento.Equipamento = $projection.Placa
  association [0..1] to ZI_CA_VH_REGIO_BR            as _Regio       on _Regio.Region = $projection.Uf
  association [0..1] to ZI_CA_VH_REGIO_BR            as _RegioProp   on _RegioProp.Region = $projection.UfProp
{
  key Header.id                                    as Id,
  key Header.placa                                 as Placa,
      _Equipamento.Text                            as PlacaText,
      _Equipamento.CategoriaEquip                  as CategoriaEquip,
      _Equipamento.CategoriaEquipText              as CategoriaEquipText,
      _Equipamento.TipoEquip                       as TipoEquip,
      _Equipamento.TipoEquipText                   as TipoEquipText,
      _Equipamento.Renavam                         as Renavam,
      cast( _Equipamento.Tara as abap.dec(13,3) )  as Tara,
      cast( _Equipamento.CapKg as abap.dec(13,3) ) as CapKg,
      cast( _Equipamento.CapM3 as abap.dec(13,3) ) as CapM3,
      _Equipamento.TpRod                           as TpRod,
      _Equipamento.TpRodText                       as TpRodText,
      _Equipamento.TpCar                           as TpCar,
      _Equipamento.TpCarText                       as TpCarText,
      _Equipamento.Uf                              as Uf,
      Header.reboque                               as Reboque,

      case Header.reboque
        when 'X' then 3
                 else 1
                 end                               as ReboqueCriticality,

      Header.ativo                                 as Ativo,

      case Header.ativo
        when 'X' then 3
                 else 1
                 end                               as AtivoCriticality,

      Header.proprietario                          as Proprietario,

      cast( Header.cpf as abap.char(11) )          as CPF,

      case when Header.cpf is initial then ''
           else concat( substring(Header.cpf, 1, 3),
                concat( '.',
                concat( substring(Header.cpf, 4, 3),
                concat( '.',
                concat( substring(Header.cpf, 7, 3),
                concat( '-', substring(Header.cpf, 10, 2) ) ) ) ) ) )
           end                                     as CPFText,

      cast( Header.cnpj as abap.char(14) )         as CNPJ,

      case when Header.cnpj is initial then ''
           else concat( substring(Header.cnpj, 1, 2),
                concat( '.',
                concat( substring(Header.cnpj, 3, 3),
                concat( '.',
                concat( substring(Header.cnpj, 6, 3),
                concat( '/',
                concat( substring(Header.cnpj, 9, 4),
                concat( '-',  substring(Header.cnpj, 13, 2) ) ) ) ) ) ) ) )
      end                                          as CNPJText,

      //Header.rntrc                         as RNTRC,
      Header.x_nome                                as Nome,
      Header.ie                                    as IE,
      Header.uf_prop                               as UfProp,
      Header.tp_prop                               as TpProp,

      @Semantics.user.createdBy: true
      created_by                                   as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                   as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                              as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                              as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                        as LocalLastChangedAt,
      _Equipamento.Rntrc                           as Rntrc,


      /* associations */
      _MDF,
      _Condutor,
      _ValePedagio,

      _Equipamento,
      _Regio,
      _RegioProp
}
