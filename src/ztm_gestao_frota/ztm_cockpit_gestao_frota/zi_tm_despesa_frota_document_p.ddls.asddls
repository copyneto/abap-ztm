@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de despesas: Doc X Período'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_DESPESA_FROTA_DOCUMENT_P
  as select from I_EquipmentData as Equipment

    inner join   bsak_view       as _Accounting on  _Accounting.xref1 = Equipment.Equipment
                                                and _Accounting.bukrs = Equipment.CompanyCode
                                                and _Accounting.bschl = '31' -- Fatura
  //                                                  and _Accounting.blart = 'KR' -- Fatura do fornecedor
  //                                                  and _Accounting.blart = 'RE' -- Fatura - bruto

    inner join   bseg            as _Document   on  _Document.bukrs = _Accounting.bukrs
                                                and _Document.belnr = _Accounting.belnr
                                                and _Document.gjahr = _Accounting.gjahr
                                                and _Document.buzei = _Accounting.buzei

{
  key cast( Equipment.Equipment as /scmtms/resplatenr ) as Equipment,
  key cast( left( _Accounting.augdt, 6 ) as spmon )     as Period,
      cast( _Document.wrbtr  as abap.dec(23,2) )        as DocumentationCost
}
