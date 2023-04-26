@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Ordem de Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_VH_ORDEM_FRETE
  as select from /scmtms/d_torrot
{
      @EndUserText.label: 'Ordem de Frete'
  key tor_id                    as OrdemFrete,
      //  key lpad( cast(tor_id as abap.char(20)), 20, '0' ) as OrdemFrete,
      @EndUserText.label: 'Tipo Ordem de Frete'
      tor_type                  as TipoOrdemFrete,
      @EndUserText.label: 'Descrição'
      labeltxt                  as Descricao,
      @EndUserText.label: 'Status'
      execution                 as StatusExec,
      @UI.hidden: true
      substring(tor_id, 11, 10) as OrdemFreteId,

      zz_mdf                    as BR_MDFeNumber,
      zz_code                   as StatusCode

}
where
      tor_cat =  'TO'
  and tor_id  <> ''
