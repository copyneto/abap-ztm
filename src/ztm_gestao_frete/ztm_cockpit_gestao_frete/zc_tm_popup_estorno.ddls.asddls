@EndUserText.label: 'Realizar Estorno'
define abstract entity zc_tm_popup_estorno
{
  @EndUserText.label: 'Agrupamento'
  estornoAgrupamento : boole_d;
  @EndUserText.label: 'Estorno MIRO'
  estornoMiro        : boole_d;
  @EndUserText.label: 'Estorno Doc. Fatura Frete'
  estornoPedido      : boole_d;
}
