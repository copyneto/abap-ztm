@AbapCatalog.sqlViewName: 'ZVTMPLANCARG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Plano de carga ordem de frete'
define view ZI_TM_PLANO_CARGA
  as select distinct from /scmtms/d_torrot             as _OrdemFrete
    left outer join       /scmtms/d_torite             as _Veiculo           on  _Veiculo.parent_key = _OrdemFrete.db_key
                                                                             and _Veiculo.item_type  = 'TRUC'
    left outer join       /scmtms/d_torpty             as _Parceiros         on _Parceiros.parent_key = _OrdemFrete.db_key

    inner join            /scmtms/d_torite             as _OrdemFreteItem    on  _OrdemFreteItem.parent_key      = _OrdemFrete.db_key
                                                                             and _OrdemFreteItem.main_cargo_item = 'X'
                                                                             and _OrdemFreteItem.base_btd_tco    = '73'
    left outer join       I_DeliveryDocument           as _Remessa           on _Remessa.DeliveryDocument = right(
      _OrdemFreteItem.base_btd_id, 10
    )
    inner join            I_DeliveryDocumentItem       as _RemessaItem       on  _RemessaItem.DeliveryDocument      =  _Remessa.DeliveryDocument
                                                                             and _RemessaItem.ItemIsBillingRelevant <> ' '
//    left outer join       /scmtms/d_torite             as _OrdemFreteItemFat on  _OrdemFreteItemFat.item_parent_key = _OrdemFreteItem.db_key
//                                                                             and _OrdemFreteItemFat.base_btd_tco    = '73'

    left outer join       /scmtms/d_torsts             as _Paradas           on _Paradas.succ_stop_key = _OrdemFreteItem.des_stop_key
    left outer join       I_BusinessPartner            as _Motorista         on _Motorista.BusinessPartner  = _Parceiros.party_id
    left outer join       I_BR_NFDocumentFlow_C        as _NFDocumentFlow    on  _NFDocumentFlow.PredecessorReferenceDocument = _RemessaItem.DeliveryDocument
                                                                             and _NFDocumentFlow.PredecessorReferenceDocItem  = _RemessaItem.DeliveryDocumentItem
    left outer join       I_BusinessPartner            as _RecebedorColeta   on _RecebedorColeta.BusinessPartner = _Remessa.ShipToParty
    left outer join       I_BusinessPartnerDefaultAddr as _DefaultAddress    on _DefaultAddress.BusinessPartner = _RecebedorColeta.BusinessPartner
    left outer join       adrc                         as _Address           on  _Address.addrnumber = _DefaultAddress.BusinessPartnerAddressID
                                                                             and _Address.date_to    = '99991231'
    left outer join       I_BR_NFDocument              as _NFDocument        on _NFDocument.BR_NotaFiscal = _NFDocumentFlow.BR_NotaFiscal
    left outer join       vbrk                         as _Fatura            on _Fatura.vbeln = _NFDocumentFlow.ReferenceDocument

{
  key _OrdemFrete.db_key                                                     as TransportationOrderKey,
  key _Remessa.DeliveryDocument                                              as DeliveryDocument,
      _OrdemFrete.tor_id                                                     as TransportationOrder,
      _Veiculo.platenumber                                                   as PlacaVeiculo,
      _NFDocumentFlow.ReferenceDocument                                      as Fatura,
      _Motorista.BusinessPartner                                             as Motorista,
      _Motorista.BusinessPartnerFullName                                     as NomeMotorista,
      case
        when _Remessa.DeliveryDocumentType <> 'Y026' then _NFDocument.BR_NFeNumber
        else 'Coleta' end                                                    as NotaFiscal,
      case
        when _Remessa.DeliveryDocumentType <> 'Y026' and _NFDocument.BR_NotaFiscal <> ' ' then _NFDocument.BR_NFPartner
        else _RecebedorColeta.BusinessPartner end                            as Recebedor,
      case
        when _Remessa.DeliveryDocumentType <> 'Y026' and _NFDocument.BR_NotaFiscal <> ' ' then _NFDocument.BR_NFPartnerName1
        else _RecebedorColeta.BusinessPartnerFullName end                    as RazaoSocial,
      case
        when _Remessa.DeliveryDocumentType <> 'Y026' and _NFDocument.BR_NotaFiscal <> ' ' then _NFDocument.BR_NFPartnerStreetName
        else concat(_Address.street, concat(', ', _Address.house_num1) ) end as Endereco,
      case
        when _Remessa.DeliveryDocumentType <> 'Y026' and _NFDocument.BR_NotaFiscal <> ' ' then _NFDocument.BR_NFPartnerDistrictName
        else _Address.city2 end                                              as Bairro,
      case
        when _Remessa.DeliveryDocumentType <> 'Y026' and _NFDocument.BR_NotaFiscal <> ' ' then _NFDocument.BR_NFPartnerCityName
        else _Address.city1 end                                              as Cidade,
      _Remessa.DeliveryDocumentType,
      _Fatura.zlsch                                                          as FormaPagamento,
      @Semantics.amount.currencyCode: 'Moeda'
      _NFDocument.BR_NFTotalAmount                                           as ValorTotal,
      _NFDocument.SalesDocumentCurrency                                      as Moeda,
      _Paradas.successor_id                                                  as StopOrder
}
where
  _OrdemFrete.tor_cat = 'TO'
