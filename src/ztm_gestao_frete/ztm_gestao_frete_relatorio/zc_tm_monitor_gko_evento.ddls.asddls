@EndUserText.label: 'Gestão de Fretes - Monitor GKO - Evento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_TM_MONITOR_GKO_EVENTO
  as projection on ZI_TM_MONITOR_GKO_EVENTO
{
      @EndUserText.label: 'Chave de acesso'
  key acckey,
      @EndUserText.label: 'Código evento'
      @ObjectModel.text.element: ['desc_codevento']
      codevento,
      desc_codevento,
      @EndUserText.label: 'Nº evento'
      nseqevento,
      @EndUserText.label: 'UF'
      @ObjectModel.text.element: ['desc_uf']
      uf,
      desc_uf,
      @EndUserText.label: 'Ambiente de sistema'
      @ObjectModel.text.element: ['desc_tpamb']
      tpamb,
      desc_tpamb,
      @EndUserText.label: 'Status da resposta'
      cstat,
      @EndUserText.label: 'Descrição da resposta'
      xmotivo,
      @EndUserText.label: 'Momento do registro'
      dhregevento,
      @EndUserText.label: 'Nº protocolo'
      nprot,
      @EndUserText.label: 'Registro da hora'
      dh_regevento_int,
      @EndUserText.label: 'Cadeia'
      digval,

      /* Associations */
      _monitor : redirected to parent ZC_TM_MONITOR_GKO
}
