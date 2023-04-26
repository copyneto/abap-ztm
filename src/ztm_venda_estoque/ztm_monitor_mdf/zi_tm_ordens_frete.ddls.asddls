@EndUserText.label: 'Listagem das Ordens de Frete'
@UI.headerInfo: { typeName: 'Ordem de Frete',
                  typeNamePlural: 'Ordens de Frete' }
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_QUERY_ORDENS_FRETE'
define root custom entity zi_tm_ordens_frete
{
      @UI            : { lineItem:       [ { position: 10 },
                        { type: #FOR_ACTION, dataAction: 'gerar_mdf', label: 'Gerar MDF-e' } ],
                          selectionField: [ { position: 10 } ] }
      @EndUserText.label: 'Ordem de frete'
  key OrdemFrete     : /scmtms/tor_id;
      @UI            : { lineItem:       [ { position: 20 } ],
                         selectionField: [ { position: 30 } ] }
      @EndUserText.label: 'Local de expedição'
      LocalExpedicao : /scmtms/pty_shipper;
      @UI            : { lineItem:       [ { position: 30 } ],
                         selectionField: [ { position: 20 } ] }
      @EndUserText.label: 'Placa veículo'
      Placa          : /scmtms/resplatenr;
      @UI            : { lineItem:       [ { position: 40 } ] }
      @EndUserText.label: 'Quantidade de notas'
      QtdNotas       : ze_qtd_nfe;
      @UI            : { lineItem:       [ { position: 50 } ] }
      @EndUserText.label: 'Região'
      Regiao         : abap.char(2);
      @UI            : { lineItem:       [ { position: 60 } ] }
      @ObjectModel.text.element: ['NomeMotorista']
      BPMotorista    : /scmtms/bupa_internal_id;
      @UI            : { lineItem:       [ { position: 70 } ] }
      @EndUserText.label: 'Nome do motorista'
      //      NomeMotorista  : abap.char(60);
      NomeMotorista  : bu_name1tx;
      @UI            : { lineItem:       [ { position: 80 } ] }
      @EndUserText.label: 'UF início'
      UFInicio       : abap.char(2);
      @UI            : { lineItem:       [ { position: 90 } ] }
      @EndUserText.label: 'UF fim'
      UFFim          : abap.char(2);
      
      //BR_MDFeNumber
      //BR_MDFeSeries
      //BR_NotaFiscal
}
