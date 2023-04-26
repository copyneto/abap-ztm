@EndUserText.label: 'Motivo Recusa'
define abstract entity zc_tm_motivo_recusa
{
  @Consumption.valueHelpDefinition: [ { entity:  { name: 'zi_tm_sh_motivo_rejeicao', element: 'not_code' } }]
  @ObjectModel.mandatory
  @EndUserText.label: 'Motivo da rejeição'
  motivoRejeicao : /xnfe/not_code;
}
