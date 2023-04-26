@EndUserText.label: 'Parâmetros de Entrada: Interface Roadnet'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['centro', 'session_id' ]

define root view entity ZC_TM_PARAM_ROADNET
  as projection on ZI_TM_PARAM_ROADNET
{
       @EndUserText.label: 'Centro'
       @ObjectModel.text.element: ['centro_txt']
       @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
  key  centro,
       @EndUserText.label: 'Data Sessão'
  key  session_data,
       @EndUserText.label: 'ID Sessão'
       @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_SESSION_ID', element: 'session_id' } } ]
       session_id,
       total_route_id,
       CreatedBy,
       CreatedAt,
       LastChangedBy,
       LastChangedAt,
       LocalLastChangedAt,

       /* Association */
       _centro.WerksCodeName as centro_txt
}
