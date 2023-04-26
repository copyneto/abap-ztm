@EndUserText.label: 'Monitor GKO - Documentos Gerados'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MONITOR_GKO_DOCGER
  as projection on ZI_TM_MONITOR_GKO_DOCGER
{
      @EndUserText.label: 'Chave de acesso'
  key acckey,
      @EndUserText.label: 'Documento gerado'
  key docgerado,
      @EndUserText.label: 'Tipo Documento'
      @ObjectModel.text.element: ['desc_tipodoc']
      tipodoc,
      desc_tipodoc,

      /* Associations */
      _monitor : redirected to parent ZC_TM_MONITOR_GKO

}
