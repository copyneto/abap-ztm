@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Emitente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_EMITENTE
  as select from zttm_mdf
  association        to parent ZI_TM_MDF       as _MDF      on _MDF.guid = $projection.id
  association [0..1] to ZI_TM_MDF_EMITENTE_ORD as _Emitente on _Emitente.Id = $projection.id
{
  key id,
      _Emitente.CompanyCode,
      _Emitente.BusinessPlace,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Cnpj as abap.char(14) )           as Cnpj,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.CnpjText as abap.char(18) )       as CnpjText,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.InscricaoEstadual as j_1bstains ) as InscricaoEstadual,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.NomeEmpresa as name1 )            as NomeEmpresa,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Endereco as ad_addrnum )          as Endereco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Rua as ad_street )                as Rua,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Numero as ad_hsnm1 )              as Numero,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Complemento as ad_hsnm2 )         as Complemento,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Bairro as ad_city2 )              as Bairro,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.TaxJurCode as ad_txjcd )          as TaxJurCode,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Cidade as ad_city1 )              as Cidade,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLTM_MDF_EMITENTE_VE'
      cast ( _Emitente.Cep as ad_pstcd1 )                as Cep,

      /* associations */
      _MDF,
      _Emitente
}
