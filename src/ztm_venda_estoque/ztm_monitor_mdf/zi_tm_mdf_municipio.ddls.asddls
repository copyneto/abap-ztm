@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Município'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_MUNICIPIO
  as select from    zttm_mdf_mcd                  as Municipio 

    left outer join ZI_TM_GET_STOP_FIRST_AND_LAST as _Stop       on _Stop.FreightOrder = Municipio.ordem_frete

    left outer join j_1bnfe_active                as _Active     on  _Active.regio   = substring(
      Municipio.access_key, 1, 2
    )
                                                                 and _Active.nfyear  = substring(
      Municipio.access_key, 3, 2
    )
                                                                 and _Active.nfmonth = substring(
      Municipio.access_key, 5, 2
    )
                                                                 and _Active.stcd1   = substring(
      Municipio.access_key, 7, 14
    ) 
                                                                 and _Active.model   = substring(
      Municipio.access_key, 21, 2
    )
                                                                 and _Active.serie   = substring(
      Municipio.access_key, 23, 3
    )
                                                                 and _Active.nfnum9  = substring(
      Municipio.access_key, 26, 9
    )
                                                                 and _Active.docnum9 = substring(
      Municipio.access_key, 35, 9
    )
                                                                 and _Active.cdv     = substring(
      Municipio.access_key, 44, 1
    )
                                                                 and _Active.direct  = '2'

    left outer join j_1bnfdoc                     as _NF         on _NF.docnum = _Active.docnum
    left outer join ZI_CA_VH_DOMICILIO_FISCAL     as _TaxJurCode on _TaxJurCode.Txjcd = _NF.txjcd
    left outer join ZI_TM_VH_MDF_NF_OF            as _NF_OF      on _NF_OF.AccessKey = Municipio.access_key

  association        to parent ZI_TM_MDF          as _MDF          on  _MDF.Guid = $projection.Guid

  association [1..1] to ZI_TM_MDF_MUNICIPIO_QTY   as _Quantidade   on  _Quantidade.BR_NotaFiscal = $projection.BR_NotaFiscal
  association [0..1] to ZI_CA_VH_ORDEM_FRETE_UUID as _FreightOrder on  _FreightOrder.TransportationOrder = $projection.FreightOrder
                                                                   and _FreightOrder.TransportationOrder is not initial
{
  key Municipio.id                                                           as Guid,
  key Municipio.access_key                                                   as AccessKey,
  key Municipio.ordem_frete                                                  as OrdemFrete,
      _Active.docnum                                                         as BR_NotaFiscal,

      case when _NF_OF.FreightOrder is not initial
           then _NF_OF.FreightOrder
           else Municipio.ordem_frete end                                    as FreightOrder,

      case when _NF.nfenum is not initial
           then _NF.nfenum
           else substring( Municipio.access_key, 26, 9 ) end                 as BR_NFeNumber,

      case when _Stop.FirstTaxJurCode is not null
           then _Stop.FirstTaxJurCode
           else _NF.txjcd end                                                as Carga,

      case when _Stop.FirstTaxJurCode is not null
           then _Stop.FirstTaxJurCodeText
           else _TaxJurCode.Text end                                         as CargaText,

      case when _Stop.LastTaxJurCode is not null
           then _Stop.LastTaxJurCode
           else _NF.txjcd end                                                as Descarga,

      case when _Stop.LastTaxJurCode is not null
           then _Stop.LastTaxJurCodeText
           else _TaxJurCode.Text end                                         as DescargaText,

      Municipio.reentrega                                                    as Reentrega,

      case Municipio.reentrega
      when 'X' then 3
               else 0
               end                                                           as ReentregaCriticality,

      Municipio.segcodbarra                                                  as SegCodigoBarra,

      cast (_NF.manual as boole_d )                                          as Manual,

      case _NF.manual
      when 'X' then 3
               else 0
               end                                                           as ManualCriticality,

      _Active.docsta                                                         as DocStatus,

      _NF.cancel                                                             as Cancel,

      case _NF.cancel
      when 'X' then 1
               else 0
               end                                                           as CancelCriticality,

      _Active.nfnum9                                                         as Num_NotaFiscal,

      /*
      Para Notas Fiscais criadas na SAP, buscar os valores no sistema
      Para Notas Fiscais externas (não existentes no SAP) usaremos os valores armazenados na tabela customizada
      */

      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then cast( 1 as abap.int4 )
            else cast( 0 as abap.int4 ) end                                                       as QtdNfExtrn,

      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then cast( 'X' as boole_d )
            else cast( ' ' as boole_d ) end                                  as NfExtrn,

      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then 3
            else 0 end                                                       as NfExtrnCriticality,

      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then cast( 'BRL' as waerk )
            else _Quantidade.SalesDocumentCurrency end                       as SalesDocumentCurrency,

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then cast( Municipio.v_carga as abap.dec(15,2) )
            else cast( _Quantidade.BR_NFTotalAmount as abap.dec(15,2) ) end  as BR_NFTotalAmount,

      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
      //            then Municipio.c_unid
            then cast( 'KG' as gewei )
            else _Quantidade.HeaderWeightUnit end                            as HeaderWeightUnit,

      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then
            case when Municipio.c_unid = 'KG' or Municipio.c_unid = 'TO'
                 then 3
                 when Municipio.c_unid = '' or Municipio.c_unid = ' '
                 then 0
                 else 1
                 end
            else
            case when _Quantidade.HeaderWeightUnit = 'KG' or _Quantidade.HeaderWeightUnit = 'TO'
                 then 3
                 when _Quantidade.HeaderWeightUnit = '' or _Quantidade.HeaderWeightUnit = ' '
                 then 0
                 else 1
                 end
            end                                                              as HeaderWeightUnitCriticality,

      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then cast( 0 as abap.dec(15,2) )
            else cast( _Quantidade.HeaderNetWeight as abap.dec(15,2) ) end   as HeaderNetWeight,

      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      case when Municipio.access_key  is not initial
            and ( Municipio.ordem_frete is initial or Municipio.ordem_frete = '00000000000000000000' )
            and ( _Active.docnum is null or _Active.docnum is initial or _Active.docnum = '0000000000' )
            then cast( Municipio.q_carga as abap.dec(15,2) )
            else cast( _Quantidade.HeaderGrossWeight as abap.dec(15,3) ) end as HeaderGrossWeight,

      @Semantics.user.createdBy: true
      Municipio.created_by                                                   as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Municipio.created_at                                                   as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Municipio.last_changed_by                                              as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Municipio.last_changed_at                                              as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Municipio.local_last_changed_at                                        as LocalLastChangedAt,

      /* Associations */
      _MDF,
      _Quantidade,
      _FreightOrder

}
where
     Municipio.ordem_frete is initial
  or Municipio.ordem_frete = '00000000000000000000'
  or Municipio.ordem_frete = _NF_OF.FreightOrder
