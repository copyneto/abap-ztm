@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Search Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_TM_VH_TIPO_OPERACAO
  as select from dd07l as Dominio
    join         dd07t as Text on  Text.domname    = Dominio.domname
                               and Text.as4local   = Dominio.as4local
                               and Text.valpos     = Dominio.valpos
                               and Text.as4vers    = Dominio.as4vers
                               and Text.ddlanguage = $session.system_language
{
      @EndUserText.label: 'Tipo de operação'
      @ObjectModel.text.element: ['Valor']
  key cast ( substring( Dominio.domvalue_l, 1, 1 ) as ze_type_sel_mdfe preserving type ) as Id,
      @EndUserText.label: 'Descrição'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      substring ( Text.ddtext, 1, 60 )                                                   as Valor,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Search.fuzzinessThreshold: 0.7
      @UI.hidden: true
      Dominio.domvalue_l                                                                 as IdSearch
}
where
      Dominio.domname  = 'ZD_TYPE_SEL_MDFE'
  and Dominio.as4local = 'A'
