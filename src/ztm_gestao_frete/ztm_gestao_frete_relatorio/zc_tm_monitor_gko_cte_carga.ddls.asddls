@EndUserText.label: 'Dados do formulário CTE - Carga'
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_CE_MONITOR_GKO_CTE_CARGA'

@UI: { headerInfo: { typeName: 'Quantidade de Carga',
                     typeNamePlural: 'Quantidade de Carga' } }

define custom entity ZC_TM_MONITOR_GKO_CTE_CARGA
{

      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet: [ { id:            'Carga',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Quantidade de Carga',
                     position:      10 }  ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------
      @UI.hidden: true
      @EndUserText.label: 'Chave de acesso'
  key acckey : j_1b_nfe_access_key_dtel44;

      @UI    : { lineItem:        [ { position: 10, label: 'Unidade de Medida' } ],
                 identification:  [ { position: 10, label: 'Unidade de Medida' } ] }
      @EndUserText.label: 'Unidade de medida'
  key cunid  : abap.char(2);

      @UI    : { lineItem:        [ { position: 20, label: 'Tipo da Medida' } ],
                 identification:  [ { position: 20, label: 'Tipo da Medida' } ] }
      @EndUserText.label: 'Tipo da Medida'
  key tpmed  : abap.char(20);

      @UI    : { lineItem:        [ { position: 30, label: 'Quantidade' } ],
                 identification:  [ { position: 30, label: 'Quantidade' } ] }
      @EndUserText.label: 'Quantidade'
      qcarga : abap.dec(15,4);

}
