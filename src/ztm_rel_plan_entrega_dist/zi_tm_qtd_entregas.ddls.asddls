@AbapCatalog.sqlViewName: 'ZITM_QTDENT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Total de entregas por ordem de frete'
define view ZI_TM_QTD_ENTREGAS 
as select from ZI_TRANSPORTATIONORDERITEM {
    SourceStopUUID,     
    count(distinct Consignee) as totalEntregas
}
where TranspOrdItemType = 'PRD'
group by SourceStopUUID
