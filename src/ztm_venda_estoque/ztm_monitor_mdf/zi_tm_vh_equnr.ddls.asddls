@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Transporte (PM)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_TM_VH_EQUNR
  as select from           equi                  as Equipamento
    inner join             eqkt                  as _Text        on  _Text.equnr = Equipamento.equnr
                                                                 and _Text.spras = $session.system_language
    inner join             ZI_CA_PARAM_VAL       as _Param       on  _Param.Modulo = 'TM'
                                                                 and _Param.Chave1 = 'CATEGORIA_TRANSPORTE'
                                                                 and _Param.Chave2 = 'EQTYP'
                                                                 and _Param.Chave3 = ''
                                                                 and _Param.Sign   = 'I'
                                                                 and _Param.Opt    = 'EQ'
                                                                 and _Param.Low    = Equipamento.eqtyp

    left outer join        fleet                 as _Tecnico     on _Tecnico.objnr = Equipamento.objnr

    left outer to one join ZI_TM_VH_EQUNR_CENTRO as _Localizacao on _Localizacao.Equipamento = Equipamento.equnr

    left outer join        t001w                 as _Regio       on _Regio.werks = _Localizacao.Centro

  association [0..1] to ZI_CA_VH_EQTYP            as _CatEqui        on _CatEqui.CategoriaEquip = $projection.CategoriaEquip
  association [0..1] to ZI_CA_VH_EQART            as _TipEqui        on _TipEqui.TipoEquip = $projection.TipoEquip
  association [0..1] to zi_tm_mdf_tipo_transporte as _TipoTransporte on _TipoTransporte.Categoria = $projection.TipoEquip
{
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Placa'
  key Equipamento.equnr               as Equipamento,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Descrição'
      _Text.eqktx                     as Text,
      @EndUserText.label: 'Categoria de equipamento'
      Equipamento.eqtyp               as CategoriaEquip,
      @EndUserText.label: 'Categoria de equipamento'
      _CatEqui.Text                   as CategoriaEquipText,
      @EndUserText.label: 'Tipo equipamento'
      Equipamento.eqart               as TipoEquip,
      @EndUserText.label: 'Tipo equipamento'
      _TipEqui.Text                   as TipoEquipText,
      @EndUserText.label: 'RENAVAM'
      cast( '' as /xnfe/renavam_cte ) as Renavam,
      @EndUserText.label: 'Tara'
      @Semantics.quantity.unitOfMeasure : 'KgUnid'
      _Tecnico.load_wgt               as Tara,
      @EndUserText.label: 'Capacidade (KG)'
      @Semantics.quantity.unitOfMeasure : 'KgUnid'
      _Tecnico.gross_wgt              as CapKg,
      @UI.hidden: true
      _Tecnico.wgt_unit               as KgUnid,
      @EndUserText.label: 'Capacidade (M3)'
      @Semantics.quantity.unitOfMeasure : 'M3Unid'
      _Tecnico.load_vol               as CapM3,
      @UI.hidden: true
      _Tecnico.vol_unit               as M3Unid,
      @EndUserText.label: 'Meio de transporte'
      _TipoTransporte.TpRod           as TpRod,
      @EndUserText.label: 'Meio de transporte'
      _TipoTransporte.TpRodText       as TpRodText,
      @EndUserText.label: 'Tipo do reboque'
      _TipoTransporte.TpCar           as TpCar,
      @EndUserText.label: 'Tipo do reboque'
      _TipoTransporte.TpCarText       as TpCarText,
      _Regio.regio                    as Uf,
      _Tecnico.key_num                as Rntrc
}
