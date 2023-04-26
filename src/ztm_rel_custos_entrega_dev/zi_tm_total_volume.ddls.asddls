@AbapCatalog.sqlViewName: 'ZITMPTOT'
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Somatório de volumes por ordem de frete'
define view ZI_TM_TOTAL_VOLUME 
as 
select from ZI_TRANSPORTATIONORDERITEM as _TransOrdemItem 
{
    TransportationOrderUUID,
    TranspOrdDocReferenceID,
    sum(TranspOrdItemGrossWeight) as PesoBrutoTotal
}
where _TransOrdemItem.IsMainCargoItem = 'X'
group by TransportationOrderUUID,
         TranspOrdDocReferenceID
