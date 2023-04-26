@EndUserText.label: 'Proj.Log upload CTe NFe'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_TM_LOG_CTE_NFE
  as projection on ZI_TM_LOG_CTE_NFE
{
  key Guid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_DOCTYPE_CTE_NFE', element: 'Doctype' } } ]
      @ObjectModel.text.element: ['DoctypeText']
      Doctype,
      DoctypeText,
      DoctypeCrit,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_STATUS_CTE_NFE', element: 'Status' } } ]
      @ObjectModel.text.element: ['StatusText']
      Status,
      StatusText,
      StatusCrit,
      Message,
      Filename,
      Documenttype,
      Documentnumber,
      Documentversion,
      Documentpart,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } } ]
      @ObjectModel.text.element: ['CreatedByName']
      CreatedBy,
      CreatedByName,
      CreatedAt,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } } ]
      @ObjectModel.text.element: ['LastChangedByName']
      LastChangedBy,
      LastChangedByName,
      LastChangedAt,
      LocalLastChangedAt
}
