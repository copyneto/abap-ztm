@EndUserText.label: 'Dados do formulário CTE - Componente'
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_CE_MONITOR_GKO_CTE_COMP'

@UI: { headerInfo: { typeName: 'Componente',
                     typeNamePlural: 'Componentes' } }

define custom entity ZC_TM_MONITOR_GKO_CTE_COMP
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet: [ { id:            'Componente',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Componente',
                     position:      10 }  ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------
      @UI.hidden: true
      @EndUserText.label: 'Chave de acesso'
  key acckey : j_1b_nfe_access_key_dtel44;

      @UI    : { lineItem:        [ { position: 10, label: 'Nome do componente' } ],
                 identification:  [ { position: 10, label: 'Nome do componente' } ] }
      @EndUserText.label: 'Nome do componente'
  key xnome  : abap.char(15);

      @UI    : { lineItem:        [ { position: 20, label: 'Valor do componente' } ],
                 identification:  [ { position: 20, label: 'Valor do componente' } ] }
      @EndUserText.label: 'Valor do componente'
      vcomp  : abap.dec(15,2);
}
