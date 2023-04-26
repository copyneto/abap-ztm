@EndUserText.label: 'Cockpit Gestão de Frota'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_TM_COCKPIT_FROTA_OLD
  as projection on ZI_TM_COCKPIT_FROTA_OLD
{
      @EndUserText.label: 'Ordem de Frete'
  key FreightOrder,
      @EndUserText.label: 'Unidade de Frete'
  key FreightUnit,
      @EndUserText.label: 'Ordem de Venda'
  key SalesDocument,
      @EndUserText.label: 'Remessa'
  key DeliveryDocument,
      @EndUserText.label: 'Fatura'
  key BillingDocument,
      @EndUserText.label: 'Nº Documento'
  key BR_NotaFiscal,
      @EndUserText.label: 'ID veículo'
  key VehicleId,
      @EndUserText.label: 'ID Produto'
  key ProductId,
      @EndUserText.label: 'Motorista'
  key Driver,

      /* Dados de ordem de frete */

      @EndUserText.label: 'ID Ordem de Frete'
      FreightOrderId,
      @EndUserText.label: 'Ocupação do veículo'
      MaxUtil,
      @EndUserText.label: 'Data de criação OF'
      CreatedOn,

      /* Dados de ordem de venda */

      @EndUserText.label: 'Canal de distribuição'
      @ObjectModel.text.element: ['DistributionChannelName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
      DistributionChannel,
      DistributionChannelName,

      /* Dados de nota fiscal */

      @EndUserText.label: 'Nota Fiscal'
      BR_NFNumber,
      @EndUserText.label: 'Chave de acesso'
      AccessKey,

      /* Dados de veículo */

      @EndUserText.label: 'Placa'
      PlateNumber,
      @EndUserText.label: 'Tipo de equipamento'
      @ObjectModel.text.element: ['EquipmentCodeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_TURES_TCO', element: 'EquipmentCode' } } ]
      EquipmentCode,
      EquipmentCodeText,
      @EndUserText.label: 'Recebedor da mercadoria'
      @ObjectModel.text.element: ['ConsigneeName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_CONSIGNEE_ID', element: 'Partner' } } ]
      Consignee,
      ConsigneeName,
      @EndUserText.label: 'CPF'
      @ObjectModel.text.element: ['ConsigneeCPFText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_CONSIGNEE_ID', element: 'CPF' } } ]
      ConsigneeCPF,
      ConsigneeCPFText,
      @EndUserText.label: 'CNPJ'
      @ObjectModel.text.element: ['ConsigneeCNPJText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_CONSIGNEE_ID', element: 'CNPJ' } } ]
      ConsigneeCNPJ,
      ConsigneeCNPJText,
      @EndUserText.label: 'Peso bruto'
      GrossWeightValue,
      @EndUserText.label: 'Unidade do peso'
      GrossWeightUnit,
      @EndUserText.label: 'Volume bruto'
      GrossVolumeValue,
      @EndUserText.label: 'Unidade do volume'
      GrossVolumeUnit,
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['ProductText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
      Product,
      ProductText,
      @EndUserText.label: 'Centro'
      @ObjectModel.text.element: ['PlantName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      Plant,
      PlantName,
      @EndUserText.label: 'Empresa'
      @ObjectModel.text.element: ['CompanyName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_COMPANY', element: 'CompanyCode' } } ]
      Company,
      CompanyName,

      /* Dados do produto */

      @EndUserText.label: 'ID Parada de origem'
      FirstStopKey,
      @EndUserText.label: 'Parada origem'
      @ObjectModel.text.element: ['FirstStopNextText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_WH_NEXT_REL', element: 'StopNext' } } ]
      FirstStopNext,
      FirstStopNextText,
      @EndUserText.label: 'UG origem'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_LOCATION_ID', element: 'LocationId' } } ]
      FirstLocationId,
      @EndUserText.label: 'Período origem'
      FirstPeriod,
      @EndUserText.label: 'Nome UG origem'
      FirstName,
      @EndUserText.label: 'País origem'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Country' } } ]
      FirstCountryCode,
      @EndUserText.label: 'Região origem'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Region' } } ]
      FirstRegion,
      @EndUserText.label: 'Cidade origem'
      FirstCityName,
      @EndUserText.label: 'Endereço origem'
      FirstAddressNumber,
      @EndUserText.label: 'Domicílio fiscal origem'
      @ObjectModel.text.element: ['FirstTaxJurCodeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' } } ]
      FirstTaxJurCode,
      FirstTaxJurCodeText,

      /* Parada de destino */

      @EndUserText.label: 'ID Parada de destino'
      LastStopKey,
      @EndUserText.label: 'Parada destino'
      @ObjectModel.text.element: ['LastStopNextText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_WH_NEXT_REL', element: 'StopNext' } } ]
      LastStopNext,
      LastStopNextText,
      @EndUserText.label: 'UG destino'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_TM_VH_LOCATION_ID', element: 'LocationId' } } ]
      LastLocationId,
      @EndUserText.label: 'Período destino'
      LastPeriod,
      @EndUserText.label: 'Nome UG destino'
      LastName,
      @EndUserText.label: 'País destino'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Country' } } ]
      LastCountryCode,
      @EndUserText.label: 'Região destino'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_REGIO', element: 'Region' } } ]
      LastRegion,
      @EndUserText.label: 'Cidade destino'
      LastCityName,
      @EndUserText.label: 'Endereço destino'
      LastAddressNumber,
      @EndUserText.label: 'Domicílio fiscal origem'
      @ObjectModel.text.element: ['LastTaxJurCodeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' } } ]
      LastTaxJurCode,
      LastTaxJurCodeText,
      @EndUserText.label: 'Distância (KM)'
      DistanceKm,

      /* Dados de equipamento */

      @EndUserText.label: 'Inicio validade veículo'
      ValidityStartDate,
      @EndUserText.label: 'Fim validade veículo'
      ValidityEndDate,
      @EndUserText.label: 'Fabricante'
      AssetManufacturerName,
      @EndUserText.label: 'Unidade'
      @ObjectModel.text.element: ['MaintenancePlantName']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
      MaintenancePlant,
      MaintenancePlantName,
      @EndUserText.label: 'Idade do veículo'
      EquipmentAge,
      @EndUserText.label: 'Ano de fabricação'
      ConstructionYear,
      @EndUserText.label: 'Mês de fabricação'
      ConstructionMonth,
      @EndUserText.label: 'Data de fabricação'
      ConstructionDate,
      @EndUserText.label: 'Tipo de equipamento'
      @ObjectModel.text.element: ['TechnicalObjectTypeText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_EQART', element: 'TipoEquip' } } ]
      TechnicalObjectType,
      TechnicalObjectTypeText,
      @EndUserText.label: 'Operação'
      @ObjectModel.text.element: ['EquipmentCategoryText']
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_CA_VH_EQTYP', element: 'CategoriaEquip' } } ]
      EquipmentCategory,
      EquipmentCategoryText,
      @EndUserText.label: 'Classe'
      EquipmentClass,
      @EndUserText.label: 'Nº Inventário'
      InventoryNumber,

      /* Dados de motorista */

      DriverName,

      /* Dados de despesa (proporcional) */

      @EndUserText.label: 'Litros de combustível (L)'
      @Aggregation.default: #SUM
      MeasureFuelVolume,
      @EndUserText.label: 'Valor do combustível'
      @Aggregation.default: #SUM
      MeasureFuelValue,
      @EndUserText.label: 'Quilometragem (KM)'
      @Aggregation.default: #SUM
      MeasureFuelDistanceKm,
      @EndUserText.label: 'Depreciação'
      @Aggregation.default: #SUM
      MeasureDepreciationCost,
      @EndUserText.label: 'Lavagem'
      @Aggregation.default: #SUM
      MeasureWashingCost,
      @EndUserText.label: 'Manutenção preventiva'
      @Aggregation.default: #SUM
      MeasurePreventiveMaintCost,
      @EndUserText.label: 'Manutenção corretiva'
      @Aggregation.default: #SUM
      MeasureCorrectiveMaintCost,
      @EndUserText.label: 'PNEUS'
      @Aggregation.default: #SUM
      MeasureTiresCost,
      @EndUserText.label: 'Documentação'
      @Aggregation.default: #SUM
      MeasureDocumentationCost,
      @EndUserText.label: 'Mão-de-obra'
      @Aggregation.default: #SUM
      MeasureLaborCost,

      /* Dados de despesa (original) */

      @EndUserText.label: 'Total Litros de combustível (L)'
      @Aggregation.default: #SUM
      OriginalFuelVolume,
      @EndUserText.label: 'Total Valor do combustível'
      @Aggregation.default: #SUM
      OriginalFuelValue,
      @EndUserText.label: 'Total Quilometragem (KM)'
      @Aggregation.default: #SUM
      OriginalFuelDistanceKm,
      @EndUserText.label: 'Total Depreciação'
      @Aggregation.default: #SUM
      OriginalDepreciationCost,
      @EndUserText.label: 'Total Lavagem'
      @Aggregation.default: #SUM
      OriginalWashingCost,
      @EndUserText.label: 'Total Manutenção preventiva'
      @Aggregation.default: #SUM
      OriginalPreventiveMaintCost,
      @EndUserText.label: 'Total Manutenção corretiva'
      @Aggregation.default: #SUM
      OriginalCorrectiveMaintCost,
      @EndUserText.label: 'Total PNEUS'
      @Aggregation.default: #SUM
      OriginalTiresCost,
      @EndUserText.label: 'Total Documentação'
      @Aggregation.default: #SUM
      OriginalDocumentationCost,
      @EndUserText.label: 'Total Mão-de-obra'
      @Aggregation.default: #SUM
      OriginalLaborCost,

      /* Total */

      @EndUserText.label: 'Qtd. ordem de venda'
      @Aggregation.default: #SUM
      TotalSalesDocument,
      @EndUserText.label: 'Qtd. clientes'
      @Aggregation.default: #SUM
      TotalCustomers,
      @EndUserText.label: 'Qtd. Kg Transportados'
      @Aggregation.default: #SUM
      TotalWeightKg,
      @EndUserText.label: 'Valor da Carga'
      @Aggregation.default: #SUM
      TotalLoadingValue,
      @EndUserText.label: 'KM/L'
      @Aggregation.default: #SUM
      TotalKmPerLiter,
      @EndUserText.label: 'Valor total'
      @Aggregation.default: #SUM
      TotalValue,
      @EndUserText.label: 'R$/L'
      @Aggregation.default: #SUM
      TotalValuePerLiter,
      @EndUserText.label: 'R$/Km'
      @Aggregation.default: #SUM
      TotalValuePerKm,
      @EndUserText.label: 'R$/Kg'
      @Aggregation.default: #SUM
      TotalValuePerKg,
      @EndUserText.label: 'R$/Kg Cliente'
      @Aggregation.default: #SUM
      TotalValuePerKgPerCustomer

}
