@EndUserText.label: 'Cockpit Gestão de Frota'
@ObjectModel.query.implementedBy: 'ABAP:ZCLTM_COCKPIT_FROTA_CE'

@UI: { headerInfo: { title: { type: #STANDARD, value: 'FreightOrder' },
                     typeName: 'Gestão de Frota',
                     typeNamePlural: 'Gestão de Frota' },

  presentationVariant: [{ sortOrder: [{ by: 'FreightOrder', direction: #DESC },
                                      { by: 'FreightUnit', direction: #ASC },
                                      { by: 'SalesDocument', direction: #ASC },
                                      { by: 'OutboundDelivery', direction: #ASC },
                                      { by: 'BillingDocument', direction: #ASC },
                                      { by: 'BR_NotaFiscal', direction: #ASC },
                                      { by: 'Driver', direction: #ASC }],

//                           requestAtLeast: [ 'DistributionChannelName',
//                                             'DistributionChannelName',
//                                             'EquipmentCodeText',
//                                             'ConsigneeName',
//                                             'ConsigneeCPFText',
//                                             'ConsigneeCNPJText',
//                                             'ProductText',
//                                             'PlantName',
//                                             'CompanyName',
//                                             'FirstStopNextText',
//                                             'FirstTaxJurCodeText',
//                                             'LastStopNextText',
//                                             'LastTaxJurCodeText',
//                                             'MaintenancePlantName',
//                                             'TechnicalObjectTypeText',
//                                             'EquipmentCategoryText'] }] }

                           requestAtLeast: [ 'FreightOrder',
'FreightUnit',
'SalesDocument',
'OutboundDelivery',
'BillingDocument',
'BR_NotaFiscal',
'VehicleId',
'ProductId',
'Driver',
'FreightOrderId',
'MaxUtil',
'CreatedOn',
'DistributionChannel',
'DistributionChannelName',
'BR_NFNumber',
'AccessKey',
'Equipment',
'EquipmentCode',
'EquipmentCodeText',
'Consignee',
'ConsigneeName',
'EconomicGroup',
'ConsigneeCPF',
'ConsigneeCPFText',
'ConsigneeCNPJ',
'ConsigneeCNPJText',
'GrossWeightValue',
'GrossWeightUnit',
'GrossVolumeValue',
'GrossVolumeUnit',
'Product',
'ProductText',
'Plant',
'PlantName',
'Company',
'CompanyName',
'FirstStopKey',
'FirstStopNext',
'FirstStopNextText',
'FirstLocationId',
'FirstPeriod',
'FirstName',
'FirstCountryCode',
'FirstRegion',
'FirstCityName',
'FirstAddressNumber',
'FirstTaxJurCode',
'FirstTaxJurCodeText',
'LastStopKey',
'LastStopNext',
'LastStopNextText',
'LastLocationId',
'LastPeriod',
'LastName',
'LastCountryCode',
'LastRegion',
'LastCityName',
'LastAddressNumber',
'LastTaxJurCode',
'LastTaxJurCodeText',
'DistanceKm',
'AllDistanceKm',
'ValidityStartDate',
'ValidityEndDate',
'AssetManufacturerName',
'MaintenancePlant',
'MaintenancePlantName',
'EquipmentAge',
'ConstructionYear',
'ConstructionMonth',
'ConstructionDate',
'TechnicalObjectType',
'TechnicalObjectTypeText',
'EquipmentCategory',
'EquipmentCategoryText',
'EquipmentClass',
'InventoryNumber',
'DriverName',
'MeasureFuelVolume',
'MeasureFuelValue',
'MeasureFuelDistanceKm',
'MeasureDepreciationCost',
'MeasureWashingCost',
'MeasurePreventiveMaintCost',
'MeasureCorrectiveMaintCost',
'MeasureTiresCost',
'MeasureDocumentationCost',
'MeasureLaborCost',
'OriginalFuelVolume',
'OriginalFuelValue',
'OriginalFuelDistanceKm',
'OriginalDepreciationCost',
'OriginalWashingCost',
'OriginalPreventiveMaintCost',
'OriginalCorrectiveMaintCost',
'OriginalTiresCost',
'OriginalDocumentationCost',
'OriginalLaborCost',
'TotalSalesDocument',
'TotalCustomers',
'TotalAllCustomers',
'TotalWeightKg',
'TotalKmPerLiter',
'TotalLoadingValue',
'TotalValue',
'TotalValuePerLiter',
'TotalValuePerKm',
'TotalValuePerKg',
'TotalValuePerKgPerCustomer'
                                             ] }] }



define root custom entity ZC_TM_COCKPIT_FROTA
{
      // ------------------------------------------------------
      // Header information
      // ------------------------------------------------------
      @UI.facet                   : [ { id             : 'CABECALHO',
                                        isSummary      : true,
                                        type           : #COLLECTION,
                                        label          : 'Cabeçalho',
                                        position       : 10 },

                                      { parentId       : 'CABECALHO',
                                        id             : 'Cabecalho',
                                        type           : #FIELDGROUP_REFERENCE,
                                        position       : 10,
                                        targetQualifier: 'Cabecalho' },

                                      { id             : 'DADOS',
                                        isSummary      : true,
                                        type           : #COLLECTION,
                                        label          : 'Dados',
                                        position       : 20 },

                                             { parentId       : 'DADOS',
                                               id             : 'Dados',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Dados' },

                                      { id         : 'VEICULO',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Veículo',
                                        position   : 30 },

                                             { parentId       : 'VEICULO',
                                               id             : 'Veiculo',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Veiculo' },

                                      { id         : 'PRODUTO',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Produto',
                                        position   : 40 },

                                             { parentId       : 'PRODUTO',
                                               id             : 'Produto',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Produto' },

                                      { id         : 'PARADAORIGEM',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Parada Origem',
                                        position   : 50 },

                                             { parentId       : 'PARADAORIGEM',
                                               id             : 'ParadaOrigem',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'ParadaOrigem' },

                                      { id         : 'PARADADESTINO',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Parada Destino',
                                        position   : 60 },

                                             { parentId       : 'PARADADESTINO',
                                               id             : 'ParadaDestino',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'ParadaDestino' },

                                      { id         : 'EQUIPAMENTO',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Equipamento',
                                        position   : 70 },

                                             { parentId       : 'EQUIPAMENTO',
                                               id             : 'Equipamento',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Equipamento' },

                                      { id         : 'MOTORISTA',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Motorista',
                                        position   : 80 },

                                             { parentId       : 'MOTORISTA',
                                               id             : 'Motorista',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Motorista' },

                                      { id         : 'DESPESA',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Despesa',
                                        position   : 90 },

                                             { parentId       : 'DESPESA',
                                               id             : 'Despesa',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Despesa' },

                                      { id         : 'ORIGINAL',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Original',
                                        position   : 100 },

                                             { parentId       : 'ORIGINAL',
                                               id             : 'Original',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Original' },

                                      { id         : 'TOTAL',
                                        isSummary  : true,
                                        type       : #COLLECTION,
                                        label      : 'Total',
                                        position   : 110 },

                                             { parentId       : 'TOTAL',
                                               id             : 'Total',
                                               type           : #FIELDGROUP_REFERENCE,
                                               position       : 10,
                                               targetQualifier: 'Total' } ]

      // ------------------------------------------------------
      // Field information
      // ------------------------------------------------------

      @Consumption.semanticObject : 'FreightOrder'
      @UI.lineItem                : [ { position: 10, semanticObjectAction: 'displayRoad', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Cabecalho', semanticObjectAction: 'displayRoad', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.selectionField          : [ { position: 80 } ]
      @EndUserText.label          : 'Ordem de Frete'
  key FreightOrder                : /scmtms/tor_id;

      @Consumption.semanticObject : 'FreightUnit'
      @UI.lineItem                : [ { position: 20, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Cabecalho', semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @EndUserText.label          : 'Unidade de Frete'
  key FreightUnit                 : /scmtms/tor_id;

      @Consumption.semanticObject : 'SalesDocument'
      @UI.lineItem                : [ { position: 30, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Cabecalho', semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @EndUserText.label          : 'Ordem de Venda'
  key SalesDocument               : vbeln_va;

      @Consumption.semanticObject : 'OutboundDelivery'
      @UI.lineItem                : [ { position: 40, semanticObjectAction: 'displayInWebGUI', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Cabecalho', semanticObjectAction: 'displayInWebGUI', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @EndUserText.label          : 'Remessa'
  key OutboundDelivery            : vbeln_vl;

      @Consumption.semanticObject : 'BillingDocument'
      @UI.lineItem                : [ { position: 50, semanticObjectAction: 'displayBillingDocument', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Cabecalho', semanticObjectAction: 'displayBillingDocument', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @EndUserText.label          : 'Fatura'
  key BillingDocument             : vbeln_vf;

      @Consumption.semanticObject : 'NotaFiscal'
      @UI.lineItem                : [ { position: 60, semanticObjectAction: 'zzdisplay', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Cabecalho', semanticObjectAction: 'zzdisplay', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @EndUserText.label          : 'Nº Documento'
  key BR_NotaFiscal               : j_1bdocnum;

      //@UI.lineItem                : [ { position: 70 } ]
      //@UI.fieldGroup              : [ { position: 70, qualifier: 'Dados' } ]
      @EndUserText.label          : 'ID veículo'
  key VehicleId                   : /bobf/conf_key;

      //@UI.lineItem                : [ { position: 80 } ]
      //@UI.fieldGroup              : [ { position: 80, qualifier: 'Dados' } ]
      @EndUserText.label          : 'ID Produto'
  key ProductId                   : /bobf/conf_key;

      @Consumption.semanticObject : 'BusinessPartnerDriver'
      @UI.lineItem                : [ { position: 90, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Dados', semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @EndUserText.label          : 'Motorista'
  key Driver                      : /scmtms/res_name;

      /* Dados de ordem de frete */

      //@EndUserText.label          : 'ID Ordem de Frete'
      //FreightOrderId              : /bobf/conf_key;

      @UI.lineItem                : [ { position: 100 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Dados' } ]
      @EndUserText.label          : 'Ocupação do veículo'
      MaxUtil                     : /scmtms/pln_max_util;

      @UI.lineItem                : [ { position: 110 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Dados' } ]
      @EndUserText.label          : 'Data de criação OF'
      CreatedOn                   : log_created_on;

      /* Dados de ordem de venda */

      @UI.lineItem                : [ { position: 120 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Dados' } ]
      @UI.selectionField          : [ { position: 90 } ]
      @EndUserText.label          : 'Canal de distribuição'
      @ObjectModel.text.element   : [ 'DistributionChannelName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
      DistributionChannel         : vtweg;

      DistributionChannelName     : vtext;

      /* Dados de nota fiscal */

      @UI.lineItem                : [ { position: 130 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Dados' } ]
      @UI.selectionField          : [ { position: 100 } ]
      @EndUserText.label          : 'Nota Fiscal'
      BR_NFNumber                 : logbr_nfnumb;

      @UI.lineItem                : [ { position: 140 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Dados' } ]
      @EndUserText.label          : 'Chave de acesso'
      AccessKey                   : j_1b_nfe_access_key_dtel44;

      /* Dados de veículo */

      @Consumption.semanticObject : 'DefenseMaintenanceTechnicalObj'
      @UI.lineItem                : [ { position: 150, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Veiculo', semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.selectionField          : [ { position: 10 } ]
      @EndUserText.label          : 'Placa'
      Equipment                   : /scmtms/resplatenr; -- PlateNumber

      @UI.lineItem                : [ { position: 160 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Veiculo' } ]
      @UI.selectionField          : [ { position: 40 } ]
      @EndUserText.label          : 'Tipo de equipamento'
      @ObjectModel.text.element   : [ 'EquipmentCodeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_TURES_TCO', element: 'EquipmentCode' } } ]
      EquipmentCode               : /scmtms/equip_type;

      EquipmentCodeText           : /scmb/de_equi_code;

      @Consumption.semanticObject : 'BusinessPartnerConsignee'
      @UI.lineItem                : [ { position: 170, semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Produto', semanticObjectAction: 'display', type: #WITH_INTENT_BASED_NAVIGATION } ]
      @UI.selectionField          : [ { position: 70 } ]
      @EndUserText.label          : 'Recebedor da mercadoria'
      @ObjectModel.text.element   : [ 'ConsigneeName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_CONSIGNEE_ID', element: 'Partner' } } ]
      Consignee                   : /scmtms/pty_consignee;

      ConsigneeName               : abap.char( 100 );

      @UI.lineItem                : [ { position: 180 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Grupo Econômico'
      EconomicGroup               : bu_id_number;

      @UI.lineItem                : [ { position: 190 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Produto' } ]
      @EndUserText.label          : 'CPF'
      @ObjectModel.text.element   : [ 'ConsigneeCPFText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_CONSIGNEE_ID', element: 'CPF' } } ]
      ConsigneeCPF                : bptaxnum;

      ConsigneeCPFText            : abap.char( 14 );

      @UI.lineItem                : [ { position: 200 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Produto' } ]
      @EndUserText.label          : 'CNPJ'
      @ObjectModel.text.element   : [ 'ConsigneeCNPJText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_CONSIGNEE_ID', element: 'CNPJ' } } ]
      ConsigneeCNPJ               : bptaxnum;

      ConsigneeCNPJText           : abap.char( 18 );

      @UI.lineItem                : [ { position: 210 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Peso bruto'
      @Semantics.quantity.unitOfMeasure : 'GrossWeightUnit'
      @Aggregation.default        : #SUM
      GrossWeightValue            : abap.quan(31,3); -- /sapmp/qty_long

      @UI.lineItem                : [ { position: 220 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Unidade do peso'
      GrossWeightUnit             : /scmtms/qua_gro_wei_uni;

      @UI.lineItem                : [ { position: 230 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Volume bruto'
      @Semantics.quantity.unitOfMeasure : 'GrossVolumeUnit'
      GrossVolumeValue            : abap.quan(31,3); -- /sapmp/qty_long

      @UI.lineItem                : [ { position: 240 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Unidade do volume'
      GrossVolumeUnit             : /scmtms/qua_gro_wei_uni;

      @UI.lineItem                : [ { position: 250 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Material'
      @ObjectModel.text.element   : [ 'ProductText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
      Product                     : /scmtms/product_id;

      ProductText                 : maktx;

      @UI.lineItem                : [ { position: 260 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'Produto' } ]
      @UI.selectionField          : [ { position: 60 } ]
      @EndUserText.label          : 'Centro'
      @ObjectModel.text.element   : [ 'PlantName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      Plant                       : /scmtms/plant_id;

      PlantName                   : name1;

      @UI.lineItem                : [ { position: 270 } ]
      @UI.fieldGroup              : [ { position: 110, qualifier: 'Produto' } ]
      @EndUserText.label          : 'Empresa'
      @ObjectModel.text.element   : [ 'CompanyName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_COMPANY', element: 'CompanyCode' } } ]
      Company                     : /scmtms/company_code;

      CompanyName                 : butxt;

      /* Dados do produto */

      /*@UI.lineItem                : [ { position: 280 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'ID Parada de origem'
      FirstStopKey                : /scmtms/tor_stop_key;*/

      @UI.lineItem                : [ { position: 290 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'Parada origem'
      @ObjectModel.text.element   : [ 'FirstStopNextText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_WH_NEXT_REL', element: 'StopNext' } } ]
      FirstStopNext               : /scmtms/stop_wh_next;

      FirstStopNextText           : val_text;

      @UI.lineItem                : [ { position: 300 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'UG origem'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_LOCATION_ID', element: 'LocationId' } } ]
      FirstLocationId             : /scmtms/location_id;

      @UI.lineItem                : [ { position: 310 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'ParadaOrigem' } ]
      @UI.selectionField          : [ { position: 50 } ]
      @EndUserText.label          : 'Período origem'
      FirstPeriod                 : abap.dats;

      @UI.lineItem                : [ { position: 320 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'Nome UG origem'
      FirstName                   : ad_name1;

      @UI.lineItem                : [ { position: 330 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'País origem'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Country' } } ]
      FirstCountryCode            : land1;

      @UI.lineItem                : [ { position: 340 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'ParadaOrigem' } ]
      @UI.selectionField          : [ { position: 110 } ]
      @EndUserText.label          : 'Região origem'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Region' } } ]
      FirstRegion                 : regio;

      @UI.lineItem                : [ { position: 350 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'ParadaOrigem' } ]
      @UI.selectionField          : [ { position: 120 } ]
      @EndUserText.label          : 'Cidade origem'
      FirstCityName               : ad_city1;

      @UI.lineItem                : [ { position: 360 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'Endereço origem'
      FirstAddressNumber          : ad_addrnum;

      @UI.lineItem                : [ { position: 370 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'ParadaOrigem' } ]
      @EndUserText.label          : 'Domicílio fiscal origem'
      @ObjectModel.text.element   : [ 'FirstTaxJurCodeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' } } ]
      FirstTaxJurCode             : ad_txjcd;

      FirstTaxJurCodeText         : text60;

      /* Parada de destino */

      /*@UI.lineItem                : [ { position: 380 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'ID Parada de destino'
      LastStopKey                 : /scmtms/tor_stop_key;*/

      @UI.lineItem                : [ { position: 390 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Parada destino'
      @ObjectModel.text.element   : [ 'LastStopNextText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_WH_NEXT_REL', element: 'StopNext' } } ]
      LastStopNext                : /scmtms/stop_wh_next;

      LastStopNextText            : val_text;

      @UI.lineItem                : [ { position: 400 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'UG destino'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_LOCATION_ID', element: 'LocationId' } } ]
      LastLocationId              : /scmtms/location_id;

      @UI.lineItem                : [ { position: 410 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Período destino'
      LastPeriod                  : abap.dats;

      @UI.lineItem                : [ { position: 420 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Nome UG destino'
      LastName                    : ad_name1;

      @UI.lineItem                : [ { position: 430 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'País destino'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Country' } } ]
      LastCountryCode             : land1;

      @UI.lineItem                : [ { position: 440 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Região destino'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Region' } } ]
      LastRegion                  : regio;

      @UI.lineItem                : [ { position: 450 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Cidade destino'
      LastCityName                : ad_city1;

      @UI.lineItem                : [ { position: 460 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Endereço destino'
      LastAddressNumber           : ad_addrnum;

      @UI.lineItem                : [ { position: 470 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Domicílio fiscal origem'
      @ObjectModel.text.element   : [ 'LastTaxJurCodeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' } } ]
      LastTaxJurCode              : ad_txjcd;

      LastTaxJurCodeText          : text60;

      @UI.lineItem                : [ { position: 480 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Distância (KM)'
      //@UI.fieldGroup              : [ { position: 30, qualifier: 'Despesa' } ]
      //@EndUserText.label          : 'Quilometragem (KM)'
      @Aggregation.default        : #SUM
      DistanceKm                  : abap.dec(28,3); -- /scmtms/decimal_value;

      @UI.lineItem                : [ { position: 490 } ]
      @UI.fieldGroup              : [ { position: 110, qualifier: 'ParadaDestino' } ]
      @EndUserText.label          : 'Distância total (KM)'
      AllDistanceKm               : abap.dec(28,3); -- /scmtms/decimal_value;

      /* Dados de equipamento */

      @UI.lineItem                : [ { position: 500 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Inicio validade veículo'
      ValidityStartDate           : datab;

      @UI.lineItem                : [ { position: 510 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Fim validade veículo'
      ValidityEndDate             : datbi;

      @UI.lineItem                : [ { position: 520 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Equipamento' } ]
      @UI.selectionField          : [ { position: 20 } ]
      @EndUserText.label          : 'Fabricante'
      AssetManufacturerName       : herst;

      @UI.lineItem                : [ { position: 530 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Unidade'
      @ObjectModel.text.element   : [ 'MaintenancePlantName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      MaintenancePlant            : swerk;

      MaintenancePlantName        : werks_name;

      @UI.lineItem                : [ { position: 540 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Equipamento' } ]
      @UI.selectionField          : [ { position: 140 } ]
      @EndUserText.label          : 'Idade do veículo'
      EquipmentAge                : abap.dec( 10 );

      @UI.lineItem                : [ { position: 550 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Ano de fabricação'
      ConstructionYear            : gjahr;

      @UI.lineItem                : [ { position: 560 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Mês de fabricação'
      ConstructionMonth           : monat;

      @UI.lineItem                : [ { position: 570 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Data de fabricação'
      ConstructionDate            : abap.dats;

      @UI.lineItem                : [ { position: 580 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Tipo de equipamento'
      @ObjectModel.text.element   : [ 'TechnicalObjectTypeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_EQART', element: 'TipoEquip' } } ]
      TechnicalObjectType         : eqart;

      TechnicalObjectTypeText     : eartx;

      @UI.lineItem                : [ { position: 590 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'Equipamento' } ]
      @UI.selectionField          : [ { position: 30 } ]
      @EndUserText.label          : 'Operação'
      @ObjectModel.text.element   : [ 'EquipmentCategoryText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_EQTYP', element: 'CategoriaEquip' } } ]
      EquipmentCategory           : eqtyp;

      EquipmentCategoryText       : etytx;

      @UI.lineItem                : [ { position: 600 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'Equipamento' } ]
      @UI.selectionField          : [ { position: 130 } ]
      @EndUserText.label          : 'Classe'
      EquipmentClass              : abap.char( 70 );

      @UI.lineItem                : [ { position: 610 } ]
      @UI.fieldGroup              : [ { position: 140, qualifier: 'Equipamento' } ]
      @EndUserText.label          : 'Nº Inventário'
      InventoryNumber             : invnr;

      /* Dados de motorista */

      @UI.lineItem                : [ { position: 620 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Motorista' } ]
      @EndUserText.label          : 'Nome do Motorista'
      DriverName                  : /scmtms/item_description;

      /* Dados de despesa (proporcional) */

      @UI.lineItem                : [ { position: 630 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Litros de combustível (L)'
      @Aggregation.default        : #SUM
      MeasureFuelVolume           : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 640 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Valor do combustível'
      @Aggregation.default        : #SUM
      MeasureFuelValue            : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 650 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Quilometragem (KM)'
      //@UI.fieldGroup              : [ { position: 100, qualifier: 'ParadaDestino' } ]
      //@EndUserText.label          : 'Distância (KM)'
      @Aggregation.default        : #SUM
      MeasureFuelDistanceKm       : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 660 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Depreciação'
      @Aggregation.default        : #SUM
      MeasureDepreciationCost     : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 670 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Lavagem'
      @Aggregation.default        : #SUM
      MeasureWashingCost          : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 680 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Manutenção preventiva'
      @Aggregation.default        : #SUM
      MeasurePreventiveMaintCost  : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 690 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Manutenção corretiva'
      @Aggregation.default        : #SUM
      MeasureCorrectiveMaintCost  : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 700 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'PNEUS'
      @Aggregation.default        : #SUM
      MeasureTiresCost            : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 710 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Documentação'
      @Aggregation.default        : #SUM
      MeasureDocumentationCost    : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 720 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'Despesa' } ]
      @EndUserText.label          : 'Mão-de-obra'
      @Aggregation.default        : #SUM
      MeasureLaborCost            : abap.dec( 21, 2 );

      /* Dados de despesa (original) */

      @UI.lineItem                : [ { position: 730 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Litros de combustível (L)'
      OriginalFuelVolume          : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 740 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Valor do combustível'
      OriginalFuelValue           : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 750 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Quilometragem (KM)'
      OriginalFuelDistanceKm      : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 760 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Depreciação'
      OriginalDepreciationCost    : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 770 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Lavagem'
      OriginalWashingCost         : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 780 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Manutenção preventiva'
      OriginalPreventiveMaintCost : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 790 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Manutenção corretiva'
      OriginalCorrectiveMaintCost : abap.dec( 21, 2 );


      @UI.lineItem                : [ { position: 800 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total PNEUS'
      OriginalTiresCost           : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 810 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Documentação'
      OriginalDocumentationCost   : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 820 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'Original' } ]
      @EndUserText.label          : 'Total Mão-de-obra'
      OriginalLaborCost           : abap.dec( 21, 2 );

      /* Total */

      @UI.lineItem                : [ { position: 830 } ]
      @UI.fieldGroup              : [ { position: 10, qualifier: 'Total' } ]
      @EndUserText.label          : 'Qtd. ordem de venda'
      //@Aggregation.default        : #SUM
      TotalSalesDocument          : abap.int4;

      @UI.lineItem                : [ { position: 840 } ]
      @UI.fieldGroup              : [ { position: 20, qualifier: 'Total' } ]
      @EndUserText.label          : 'Qtd. clientes distintos'
      TotalCustomers              : abap.int4;

      @UI.lineItem                : [ { position: 850 } ]
      @UI.fieldGroup              : [ { position: 30, qualifier: 'Total' } ]
      @EndUserText.label          : 'Qtd. clientes'
      TotalAllCustomers           : abap.int4;

      @UI.lineItem                : [ { position: 860 } ]
      @UI.fieldGroup              : [ { position: 40, qualifier: 'Total' } ]
      @EndUserText.label          : 'Qtd. Kg Transportados'
      @Aggregation.default        : #SUM
      TotalWeightKg               : abap.dec( 21, 3 );

      @UI.lineItem                : [ { position: 870 } ]
      @UI.fieldGroup              : [ { position: 50, qualifier: 'Total' } ]
      @EndUserText.label          : 'KM/L'
      @Aggregation.default        : #SUM
      TotalKmPerLiter             : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 880 } ]
      @UI.fieldGroup              : [ { position: 60, qualifier: 'Total' } ]
      @EndUserText.label          : 'Valor da Carga'
      @Aggregation.default        : #SUM
      TotalLoadingValue           : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 890 } ]
      @UI.fieldGroup              : [ { position: 70, qualifier: 'Total' } ]
      @EndUserText.label          : 'Valor total'
      @Aggregation.default        : #SUM
      TotalValue                  : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 900 } ]
      @UI.fieldGroup              : [ { position: 80, qualifier: 'Total' } ]
      @EndUserText.label          : 'R$/L'
      @Aggregation.default        : #SUM
      TotalValuePerLiter          : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 910 } ]
      @UI.fieldGroup              : [ { position: 90, qualifier: 'Total' } ]
      @EndUserText.label          : 'R$/Km'
      @Aggregation.default        : #SUM
      TotalValuePerKm             : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 920 } ]
      @UI.fieldGroup              : [ { position: 100, qualifier: 'Total' } ]
      @EndUserText.label          : 'R$/Kg'
      @Aggregation.default        : #SUM
      TotalValuePerKg             : abap.dec( 21, 2 );

      @UI.lineItem                : [ { position: 930 } ]
      @UI.fieldGroup              : [ { position: 110, qualifier: 'Total' } ]
      @EndUserText.label          : 'R$/Kg Cliente'
      @Aggregation.default        : #SUM
      TotalValuePerKgPerCustomer  : abap.dec( 21, 2 );

}
