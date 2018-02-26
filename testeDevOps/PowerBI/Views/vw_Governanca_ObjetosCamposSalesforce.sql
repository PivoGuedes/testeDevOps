
CREATE VIEW [PowerBI].[vw_Governanca_ObjetosCamposSalesforce] AS

SELECT
	 SFF.[ObjectName]
	,SFF.[Name]
	,SFF.[Type]
	,SFF.[Label]
	,SFF.[SQLDefinition]
	,SFF.[Calculated]
	,SFF.[Createable]
	,SFF.[DefaultedOnCreate]
	,SFF.[Filterable]
	,SFF.[NameField]
	,SFF.[Nillable]
	,SFF.[Sortable]
	,SFF.[Unique]
	,SFF.[Updateable]
	,SFF.[AutoNumber]
	,SFF.[RestrictedPicklist]
	,SFF.[ExternalID]
	,SFF.[RelationshipName]
	,SFF.[HelpText]
FROM [SALESFORCE_PROD]...[sys_sffields] SFF

