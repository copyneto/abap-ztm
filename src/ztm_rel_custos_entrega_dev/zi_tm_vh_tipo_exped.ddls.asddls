@AbapCatalog.sqlViewName: 'ZTM_VH_TE'
@EndUserText.label: 'Value Help: Tipo de Expedição'
@Search.searchable: true

define view ZI_TM_VH_TIPO_EXPED
  as select from zttm_tipo_exped as _TipoExpedicao
{
      @ObjectModel.text.element: ['Descricao']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Código'
  key tipo_exped as TipoExped,

      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Tipo Expedição'
      descricao  as Descricao
}
