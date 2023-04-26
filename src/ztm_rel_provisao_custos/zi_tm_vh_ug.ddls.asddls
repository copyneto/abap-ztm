@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unidade Gerencial'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Search.searchable: true

define view entity ZI_TM_VH_UG
  as select from /sapapo/loc  as Loc

    inner join   /sapapo/loct as _LocDescription on  _LocDescription.locid = Loc.locid
                                                 and _LocDescription.spras = $session.system_language

    inner join   adrc         as _Address        on  _Address.addrnumber = Loc.adrnummer
                                                 and _Address.nation     = ''

{
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @UI: {lineItem: [ {position: 10} ]}
  key Loc.locno               as LocationId,

      @UI: {lineItem: [ {position: 20} ]}
      @Search.defaultSearchElement: true
      @Semantics.text: true
      _LocDescription.descr40 as LocationDescription,

      @Semantics.address.country: true
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CountryVH', element: 'Country' } } ]
      _Address.country        as Country,

      @Semantics.address.region: true
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_RegionSrchHelp', element: 'Region' } } ]
      _Address.region         as Region,

      @Semantics.address.city: true
      @Search.defaultSearchElement: true
      _Address.city1          as CityName

}
