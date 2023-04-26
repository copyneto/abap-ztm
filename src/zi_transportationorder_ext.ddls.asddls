@AbapCatalog.sqlViewAppendName: 'ZZTM_TORROTEXT'
@EndUserText.label: 'Transportation Orders Extended'
extend view I_TransportationOrder with ZI_TransportationOrder_EXT
  association [0..1] to I_TranspOrganizationalUnit as _OrgUnit on $projection.PurgOrgCompanyId = _OrgUnit.OrganizationalUnit
{

  purch_company_org_id                  as PurgOrgCompanyId,

  @ObjectModel.foreignKey.association: '_OrgUnit'
  @Consumption.valueHelpDefinition: [{ entity: {name: 'I_CompanyCodeVH' , element: 'CompanyCode'}}]
  _OrgUnit.OrganizationalUnitExternalID as PurgOrgCompanyCodeAux,
  
  @ObjectModel.text.element: [ 'PurgOrgCompanyCodeAux' ]
  _OrgUnit._OrganizationalUnitText[1:Language = $session.system_language].OrganizationalUnitName as CompanyText,
  
  _OrgUnit
}
