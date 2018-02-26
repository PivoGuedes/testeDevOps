
CREATE VIEW [PowerBI].[vw_TaskRayDefinicaoDemandasSprint] AS

WITH CTE_N1 AS (

	SELECT DISTINCT 
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,CAST(CASE WHEN TR1.[Id] = 'a0t1a000001lllTAAQ' THEN 1 ELSE 0 END AS INT) AS [FlagCarteiraSprint]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	WHERE TR1.[TASKRAY__Project_Parent__c] IS NULL
	AND TR1.[TASKRAY__Status__c] = 'false'
	AND TR1.[Id] = 'a0t1a000001lllTAAQ'

), CTE_N2 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,CN1.[FlagCarteiraSprint]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	INNER JOIN CTE_N1 CN1 ON CN1.[IDTaskRayProjeto] = TR1.[TASKRAY__Project_Parent__c]

), CTE_N3 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,CN2.[FlagCarteiraSprint]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	INNER JOIN CTE_N2 CN2 ON CN2.[IDTaskRayProjeto] = TR1.[TASKRAY__Project_Parent__c]

), CTE_N4 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,CN3.[FlagCarteiraSprint]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	INNER JOIN CTE_N3 CN3 ON CN3.[IDTaskRayProjeto] = TR1.[TASKRAY__Project_Parent__c]

), CTE_N5 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,CN4.[FlagCarteiraSprint]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	INNER JOIN CTE_N4 CN4 ON CN4.[IDTaskRayProjeto] = TR1.[TASKRAY__Project_Parent__c]

), CTE_N6 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,CN5.[FlagCarteiraSprint]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	INNER JOIN CTE_N5 CN5 ON CN5.[IDTaskRayProjeto] = TR1.[TASKRAY__Project_Parent__c]

)

SELECT 
	 CN1.[NomeTaskRayProjeto]
	,CN1.[IDTaskRayProjeto]
	,CN1.[IDTaskRayProjetoSup]
	,CN1.[FlagCarteiraSprint]
FROM CTE_N1 CN1

UNION 

SELECT 
	 CN2.[NomeTaskRayProjeto]
	,CN2.[IDTaskRayProjeto]
	,CN2.[IDTaskRayProjetoSup]
	,CN2.[FlagCarteiraSprint]
FROM CTE_N2 CN2

UNION 

SELECT 
	 CN3.[NomeTaskRayProjeto]
	,CN3.[IDTaskRayProjeto]
	,CN3.[IDTaskRayProjetoSup]
	,CN3.[FlagCarteiraSprint]
FROM CTE_N3 CN3

UNION 

SELECT 
	 CN4.[NomeTaskRayProjeto]
	,CN4.[IDTaskRayProjeto]
	,CN4.[IDTaskRayProjetoSup]
	,CN4.[FlagCarteiraSprint]
FROM CTE_N4 CN4

UNION 

SELECT 
	 CN5.[NomeTaskRayProjeto]
	,CN5.[IDTaskRayProjeto]
	,CN5.[IDTaskRayProjetoSup]
	,CN5.[FlagCarteiraSprint]
FROM CTE_N5 CN5

UNION 

SELECT 
	 CN6.[NomeTaskRayProjeto]
	,CN6.[IDTaskRayProjeto]
	,CN6.[IDTaskRayProjetoSup]
	,CN6.[FlagCarteiraSprint]
FROM CTE_N6 CN6


