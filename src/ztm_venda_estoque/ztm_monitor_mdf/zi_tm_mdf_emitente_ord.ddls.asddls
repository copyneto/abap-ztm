@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações MDF-e : Emitente ( Função)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MDF_EMITENTE_ORD
  as select from zttm_mdf
{
  key id     as Id,
      bukrs  as CompanyCode,
      branch as BusinessPlace,
      ''     as Cnpj,
      ''     as CnpjText,
      ''     as InscricaoEstadual,
      ''     as NomeEmpresa,
      ''     as Endereco,
      ''     as Rua,
      ''     as Numero,
      ''     as Complemento,
      ''     as Bairro,
      ''     as TaxJurCode,
      ''     as Cidade,
      ''     as Cep
}
