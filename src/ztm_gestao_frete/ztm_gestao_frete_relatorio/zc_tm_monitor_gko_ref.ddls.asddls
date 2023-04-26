@EndUserText.label: 'Monitor GKO - Referências'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MONITOR_GKO_REF
  as projection on ZI_TM_MONITOR_GKO_REF
{
      @EndUserText.label: 'Chave de acesso'
  key acckey,
      @EndUserText.label: 'Chave referência'
  key acckey_ref,
      @EndUserText.label: 'Chave origem'
      acckey_orig,
      @EndUserText.label: 'Nº Documento'
      BR_NotaFiscal,
      @EndUserText.label: 'Produto acabado'
      @ObjectModel.text.element: ['desc_prod_acabado']
      prod_acabado,
      desc_prod_acabado,
      crit_prod_acabado,

      /* Associations */
      _monitor : redirected to parent ZC_TM_MONITOR_GKO
}
