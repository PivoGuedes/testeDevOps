


CREATE VIEW [PowerBI].[vw_TaskRayProjeto] AS

WITH CTE_USUARIO AS (

	SELECT DISTINCT
		 USU.[Id]
		,CAST(USU.[Name] AS VARCHAR(150)) AS [Usuario]
	FROM [SALESFORCE BACKUPS].[dbo].[User] USU

), CTE_TASKRAY_N1 AS (

	SELECT --DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR1.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR1.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,TR1.[TASKRAY__Status__c] AS [StatusProjeto]
		,ISNULL(LTRIM(RTRIM(TR1.[Delay_Project__c])), 'Não Informado') AS [DelayProjeto]
		,ISNULL(CAST(TR1.[MilestoneMetaConcluidos__c] AS INT), 0) AS [MilestoneMetaConcluidos]
		,ISNULL(CAST(TR1.[MilestoneMetaTotais__c] AS INT), 0) AS [MilestoneMetaTotais]
		,ISNULL(CAST(TR1.[MilestonesFormalizadosMeta__c] AS DECIMAL(18,2)), 0) AS [MilestonesFormalizadosMeta] 
		,ISNULL(CAST(TR1.[MilestonesProjetoConcluidos__c] AS INT), 0) AS [MilestonesProjetoConcluidos]
		,ISNULL(CAST(TR1.[MilestonesTotais__c] AS INT), 0) AS [MilestonesTotais]
		,ISNULL(CAST(TR1.[MilestonesTotaisProjeto__c] AS INT), 0) AS [MilestonesTotaisProjeto]
		,ISNULL(CAST(TR1.[TASKRAY__trCompletionPercentage__c] AS DECIMAL(18,2)), 0) AS [TaskRayPercentualConcluido]
		,ISNULL(LTRIM(RTRIM(TR1.[Status_Taskray_project__c])), 'Não Informado') AS [TaskRayStatusProjeto]
		,ISNULL(CAST(TR1.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01') AS [TaskRayDataInicialProjeto]
		,ISNULL(CAST(TR1.[TASKRAY__Project_End__c] AS DATE), '1900-01-01') AS [TaskRayDataFinalProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR1.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR1.[TASKRAY__Project_End__c] AS DATE), '1900-01-01')) AS [TaskRayDiferencaDias]
		,ISNULL(CAST(TR1.[RealStart__c] AS DATE), '1900-01-01') AS [DataInicialRealProjeto]
		,ISNULL(CAST(TR1.[RealEnd__c] AS DATE), '1900-01-01') AS [DataFinalRealProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR1.[RealStart__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR1.[RealEnd__c] AS DATE), '1900-01-01')) AS [DiferencaDiasRealProjeto]
		,ISNULL(CAST(TR1.[RealCost__c] AS DECIMAL(18,2)), 0) AS [CustoRealProjeto]
		,ISNULL(CAST(TR1.[PlannedCost__c] AS DECIMAL(18,2)), 0) AS [CustoPlanejadoProjeto]
		,ISNULL(CAST(TR1.[PlannedPercent__c] AS INT), 0) AS [PercentualPlanejado]
		,CAST('Nível 01' AS VARCHAR(10)) AS [NivelHierarquia]
		,CAST(ROW_NUMBER() OVER(ORDER BY TR1.[Name]) AS VARCHAR(10)) AS [CodigoNivelHierarquia]
		,ISNULL(CAST(LTRIM(RTRIM(TR1.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade1]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade2]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade3]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade4]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade5]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade6]
		,CAST(1 AS INT) AS [FlagAtivaHieraquiaAtividadades]
		,CAST(1 AS INT) AS [FlagAtivaHieAtivN1]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN2]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN3]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN4]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN5]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN6]
		,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelProjeto]
		,ISNULL(PRA.[Usuario], 'Não Informado') AS [AnalistaProjeto]
		,ISNULL(PRM.[Usuario], 'Não Informado') AS [GerenteProjeto]--, TR1.*
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR1
	LEFT JOIN CTE_USUARIO OWN ON OWN.[Id] = TR1.[OwnerId]
	LEFT JOIN CTE_USUARIO PRA ON PRA.[Id] = TR1.[ProjectAnalyst__c]
	LEFT JOIN CTE_USUARIO PRM ON PRM.[Id] = TR1.[ProjectManager__c]
	WHERE TR1.[TASKRAY__Project_Parent__c] IS NULL
	--AND TR1.[TASKRAY__Status__c] = 'false'
	--AND TR1.[Id] IN ('a0t1a000001LXAPAA4'/*'a0t1a000001B8FuAAK'*/)	--, 'a0t1a000002IIp3AAG' --'a0t1a000001lllTAAQ'

), CTE_TASKRAY_N2 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR2.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR2.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR2.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,TR2.[TASKRAY__Status__c] AS [StatusProjeto]
		,ISNULL(LTRIM(RTRIM(TR2.[Delay_Project__c])), 'Não Informado') AS [DelayProjeto]
		,ISNULL(CAST(TR2.[MilestoneMetaConcluidos__c] AS INT), 0) AS [MilestoneMetaConcluidos]
		,ISNULL(CAST(TR2.[MilestoneMetaTotais__c] AS INT), 0) AS [MilestoneMetaTotais]
		,ISNULL(CAST(TR2.[MilestonesFormalizadosMeta__c] AS DECIMAL(18,2)), 0) AS [MilestonesFormalizadosMeta] 
		,ISNULL(CAST(TR2.[MilestonesProjetoConcluidos__c] AS INT), 0) AS [MilestonesProjetoConcluidos]
		,ISNULL(CAST(TR2.[MilestonesTotais__c] AS INT), 0) AS [MilestonesTotais]
		,ISNULL(CAST(TR2.[MilestonesTotaisProjeto__c] AS INT), 0) AS [MilestonesTotaisProjeto]
		,ISNULL(CAST(TR2.[TASKRAY__trCompletionPercentage__c] AS DECIMAL(18,2)), 0) AS [TaskRayPercentualConcluido]
		,ISNULL(LTRIM(RTRIM(TR2.[Status_Taskray_project__c])), 'Não Informado') AS [TaskRayStatusProjeto]
		,ISNULL(CAST(TR2.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01') AS [TaskRayDataInicialProjeto]
		,ISNULL(CAST(TR2.[TASKRAY__Project_End__c] AS DATE), '1900-01-01') AS [TaskRayDataFinalProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR2.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR2.[TASKRAY__Project_End__c] AS DATE), '1900-01-01')) AS [TaskRayDiferencaDias]
		,ISNULL(CAST(TR2.[RealStart__c] AS DATE), '1900-01-01') AS [DataInicialRealProjeto]
		,ISNULL(CAST(TR2.[RealEnd__c] AS DATE), '1900-01-01') AS [DataFinalRealProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR2.[RealStart__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR2.[RealEnd__c] AS DATE), '1900-01-01')) AS [DiferencaDiasRealProjeto]
		,ISNULL(CAST(TR2.[RealCost__c] AS DECIMAL(18,2)), 0) AS [CustoRealProjeto]
		,ISNULL(CAST(TR2.[PlannedCost__c] AS DECIMAL(18,2)), 0) AS [CustoPlanejadoProjeto]
		,ISNULL(CAST(TR2.[PlannedPercent__c] AS INT), 0) AS [PercentualPlanejado]
		,CAST('Nível 02' AS VARCHAR(10)) AS [NivelHierarquia]
		,TR1.[CodigoNivelHierarquia] + '.' + CAST(ROW_NUMBER() OVER(PARTITION BY TR1.[CodigoNivelHierarquia] ORDER BY TR2.[Name]) AS VARCHAR(10)) AS [CodigoNivelHierarquia]
		,ISNULL(CAST(LTRIM(RTRIM(TR1.[NomeAtividade1])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade1]
		,ISNULL(CAST(LTRIM(RTRIM(TR2.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade2]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade3]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade4]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade5]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade6]
		,CAST(1 AS INT) AS [FlagAtivaHieraquiaAtividadades]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN1]
		,CAST(1 AS INT) AS [FlagAtivaHieAtivN2]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN3]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN4]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN5]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN6]
		,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelProjeto]
		,ISNULL(PRA.[Usuario], 'Não Informado') AS [AnalistaProjeto]
		,ISNULL(PRM.[Usuario], 'Não Informado') AS [GerenteProjeto]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR2
	INNER JOIN CTE_TASKRAY_N1 TR1 ON TR1.[IDTaskRayProjeto] = TR2.[TASKRAY__Project_Parent__c]
	LEFT JOIN CTE_USUARIO OWN ON OWN.[Id] = TR2.[OwnerId]
	LEFT JOIN CTE_USUARIO PRA ON PRA.[Id] = TR2.[ProjectAnalyst__c]
	LEFT JOIN CTE_USUARIO PRM ON PRM.[Id] = TR2.[ProjectManager__c]

), CTE_TASKRAY_N3 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR3.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR3.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR3.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,TR3.[TASKRAY__Status__c] AS [StatusProjeto]
		,ISNULL(LTRIM(RTRIM(TR3.[Delay_Project__c])), 'Não Informado') AS [DelayProjeto]
		,ISNULL(CAST(TR3.[MilestoneMetaConcluidos__c] AS INT), 0) AS [MilestoneMetaConcluidos]
		,ISNULL(CAST(TR3.[MilestoneMetaTotais__c] AS INT), 0) AS [MilestoneMetaTotais]
		,ISNULL(CAST(TR3.[MilestonesFormalizadosMeta__c] AS DECIMAL(18,2)), 0) AS [MilestonesFormalizadosMeta] 
		,ISNULL(CAST(TR3.[MilestonesProjetoConcluidos__c] AS INT), 0) AS [MilestonesProjetoConcluidos]
		,ISNULL(CAST(TR3.[MilestonesTotais__c] AS INT), 0) AS [MilestonesTotais]
		,ISNULL(CAST(TR3.[MilestonesTotaisProjeto__c] AS INT), 0) AS [MilestonesTotaisProjeto]
		,ISNULL(CAST(TR3.[TASKRAY__trCompletionPercentage__c] AS DECIMAL(18,2)), 0) AS [TaskRayPercentualConcluido]
		,ISNULL(LTRIM(RTRIM(TR3.[Status_Taskray_project__c])), 'Não Informado') AS [TaskRayStatusProjeto]
		,ISNULL(CAST(TR3.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01') AS [TaskRayDataInicialProjeto]
		,ISNULL(CAST(TR3.[TASKRAY__Project_End__c] AS DATE), '1900-01-01') AS [TaskRayDataFinalProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR3.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR3.[TASKRAY__Project_End__c] AS DATE), '1900-01-01')) AS [TaskRayDiferencaDias]
		,ISNULL(CAST(TR3.[RealStart__c] AS DATE), '1900-01-01') AS [DataInicialRealProjeto]
		,ISNULL(CAST(TR3.[RealEnd__c] AS DATE), '1900-01-01') AS [DataFinalRealProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR3.[RealStart__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR3.[RealEnd__c] AS DATE), '1900-01-01')) AS [DiferencaDiasRealProjeto]
		,ISNULL(CAST(TR3.[RealCost__c] AS DECIMAL(18,2)), 0) AS [CustoRealProjeto]
		,ISNULL(CAST(TR3.[PlannedCost__c] AS DECIMAL(18,2)), 0) AS [CustoPlanejadoProjeto]
		,ISNULL(CAST(TR3.[PlannedPercent__c] AS INT), 0) AS [PercentualPlanejado]
		,CAST('Nível 03' AS VARCHAR(10)) AS [NivelHierarquia]
		,TR2.[CodigoNivelHierarquia] + '.' + CAST(ROW_NUMBER() OVER(PARTITION BY TR2.[CodigoNivelHierarquia] ORDER BY TR3.[Name]) AS VARCHAR(10)) AS [CodigoNivelHierarquia]
		,ISNULL(CAST(LTRIM(RTRIM(TR2.[NomeAtividade1])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade1]
		,ISNULL(CAST(LTRIM(RTRIM(TR2.[NomeAtividade2])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade2]
		,ISNULL(CAST(LTRIM(RTRIM(TR3.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade3]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade4]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade5]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade6]
		,CAST(1 AS INT) AS [FlagAtivaHieraquiaAtividadades]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN1]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN2]
		,CAST(1 AS INT) AS [FlagAtivaHieAtivN3]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN4]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN5]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN6]
		,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelProjeto]
		,ISNULL(PRA.[Usuario], 'Não Informado') AS [AnalistaProjeto]
		,ISNULL(PRM.[Usuario], 'Não Informado') AS [GerenteProjeto]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR3
	INNER JOIN CTE_TASKRAY_N2 TR2 ON TR2.[IDTaskRayProjeto] = TR3.[TASKRAY__Project_Parent__c]
	LEFT JOIN CTE_USUARIO OWN ON OWN.[Id] = TR3.[OwnerId]
	LEFT JOIN CTE_USUARIO PRA ON PRA.[Id] = TR3.[ProjectAnalyst__c]
	LEFT JOIN CTE_USUARIO PRM ON PRM.[Id] = TR3.[ProjectManager__c]

), CTE_TASKRAY_N4 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR4.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR4.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR4.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,TR4.[TASKRAY__Status__c] AS [StatusProjeto]
		,ISNULL(LTRIM(RTRIM(TR4.[Delay_Project__c])), 'Não Informado') AS [DelayProjeto]
		,ISNULL(CAST(TR4.[MilestoneMetaConcluidos__c] AS INT), 0) AS [MilestoneMetaConcluidos]
		,ISNULL(CAST(TR4.[MilestoneMetaTotais__c] AS INT), 0) AS [MilestoneMetaTotais]
		,ISNULL(CAST(TR4.[MilestonesFormalizadosMeta__c] AS DECIMAL(18,2)), 0) AS [MilestonesFormalizadosMeta] 
		,ISNULL(CAST(TR4.[MilestonesProjetoConcluidos__c] AS INT), 0) AS [MilestonesProjetoConcluidos]
		,ISNULL(CAST(TR4.[MilestonesTotais__c] AS INT), 0) AS [MilestonesTotais]
		,ISNULL(CAST(TR4.[MilestonesTotaisProjeto__c] AS INT), 0) AS [MilestonesTotaisProjeto]
		,ISNULL(CAST(TR4.[TASKRAY__trCompletionPercentage__c] AS DECIMAL(18,2)), 0) AS [TaskRayPercentualConcluido]
		,ISNULL(LTRIM(RTRIM(TR4.[Status_Taskray_project__c])), 'Não Informado') AS [TaskRayStatusProjeto]
		,ISNULL(CAST(TR4.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01') AS [TaskRayDataInicialProjeto]
		,ISNULL(CAST(TR4.[TASKRAY__Project_End__c] AS DATE), '1900-01-01') AS [TaskRayDataFinalProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR4.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR4.[TASKRAY__Project_End__c] AS DATE), '1900-01-01')) AS [TaskRayDiferencaDias]
		,ISNULL(CAST(TR4.[RealStart__c] AS DATE), '1900-01-01') AS [DataInicialRealProjeto]
		,ISNULL(CAST(TR4.[RealEnd__c] AS DATE), '1900-01-01') AS [DataFinalRealProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR4.[RealStart__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR4.[RealEnd__c] AS DATE), '1900-01-01')) AS [DiferencaDiasRealProjeto]
		,ISNULL(CAST(TR4.[RealCost__c] AS DECIMAL(18,2)), 0) AS [CustoRealProjeto]
		,ISNULL(CAST(TR4.[PlannedCost__c] AS DECIMAL(18,2)), 0) AS [CustoPlanejadoProjeto]
		,ISNULL(CAST(TR4.[PlannedPercent__c] AS INT), 0) AS [PercentualPlanejado]
		,CAST('Nível 04' AS VARCHAR(10)) AS [NivelHierarquia]
		,TR3.[CodigoNivelHierarquia] + '.' + CAST(ROW_NUMBER() OVER(PARTITION BY TR3.[CodigoNivelHierarquia] ORDER BY TR4.[Name]) AS VARCHAR(10)) AS [CodigoNivelHierarquia]
		,ISNULL(CAST(LTRIM(RTRIM(TR3.[NomeAtividade1])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade1]
		,ISNULL(CAST(LTRIM(RTRIM(TR3.[NomeAtividade2])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade2]
		,ISNULL(CAST(LTRIM(RTRIM(TR3.[NomeAtividade3])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade3]
		,ISNULL(CAST(LTRIM(RTRIM(TR4.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade4]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade5]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade6]
		,CAST(1 AS INT) AS [FlagAtivaHieraquiaAtividadades]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN1]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN2]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN3]
		,CAST(1 AS INT) AS [FlagAtivaHieAtivN4]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN5]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN6]
		,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelProjeto]
		,ISNULL(PRA.[Usuario], 'Não Informado') AS [AnalistaProjeto]
		,ISNULL(PRM.[Usuario], 'Não Informado') AS [GerenteProjeto]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR4
	INNER JOIN CTE_TASKRAY_N3 TR3 ON TR3.[IDTaskRayProjeto] = TR4.[TASKRAY__Project_Parent__c]
	LEFT JOIN CTE_USUARIO OWN ON OWN.[Id] = TR4.[OwnerId]
	LEFT JOIN CTE_USUARIO PRA ON PRA.[Id] = TR4.[ProjectAnalyst__c]
	LEFT JOIN CTE_USUARIO PRM ON PRM.[Id] = TR4.[ProjectManager__c]

), CTE_TASKRAY_N5 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR5.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR5.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR5.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,TR5.[TASKRAY__Status__c] AS [StatusProjeto]
		,ISNULL(LTRIM(RTRIM(TR5.[Delay_Project__c])), 'Não Informado') AS [DelayProjeto]
		,ISNULL(CAST(TR5.[MilestoneMetaConcluidos__c] AS INT), 0) AS [MilestoneMetaConcluidos]
		,ISNULL(CAST(TR5.[MilestoneMetaTotais__c] AS INT), 0) AS [MilestoneMetaTotais]
		,ISNULL(CAST(TR5.[MilestonesFormalizadosMeta__c] AS DECIMAL(18,2)), 0) AS [MilestonesFormalizadosMeta] 
		,ISNULL(CAST(TR5.[MilestonesProjetoConcluidos__c] AS INT), 0) AS [MilestonesProjetoConcluidos]
		,ISNULL(CAST(TR5.[MilestonesTotais__c] AS INT), 0) AS [MilestonesTotais]
		,ISNULL(CAST(TR5.[MilestonesTotaisProjeto__c] AS INT), 0) AS [MilestonesTotaisProjeto]
		,ISNULL(CAST(TR5.[TASKRAY__trCompletionPercentage__c] AS DECIMAL(18,2)), 0) AS [TaskRayPercentualConcluido]
		,ISNULL(LTRIM(RTRIM(TR5.[Status_Taskray_project__c])), 'Não Informado') AS [TaskRayStatusProjeto]
		,ISNULL(CAST(TR5.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01') AS [TaskRayDataInicialProjeto]
		,ISNULL(CAST(TR5.[TASKRAY__Project_End__c] AS DATE), '1900-01-01') AS [TaskRayDataFinalProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR5.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR5.[TASKRAY__Project_End__c] AS DATE), '1900-01-01')) AS [TaskRayDiferencaDias]
		,ISNULL(CAST(TR5.[RealStart__c] AS DATE), '1900-01-01') AS [DataInicialRealProjeto]
		,ISNULL(CAST(TR5.[RealEnd__c] AS DATE), '1900-01-01') AS [DataFinalRealProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR5.[RealStart__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR5.[RealEnd__c] AS DATE), '1900-01-01')) AS [DiferencaDiasRealProjeto]
		,ISNULL(CAST(TR5.[RealCost__c] AS DECIMAL(18,2)), 0) AS [CustoRealProjeto]
		,ISNULL(CAST(TR5.[PlannedCost__c] AS DECIMAL(18,2)), 0) AS [CustoPlanejadoProjeto]
		,ISNULL(CAST(TR5.[PlannedPercent__c] AS INT), 0) AS [PercentualPlanejado]
		,CAST('Nível 05' AS VARCHAR(10)) AS [NivelHierarquia]
		,TR4.[CodigoNivelHierarquia] + '.' + CAST(ROW_NUMBER() OVER(PARTITION BY TR4.[CodigoNivelHierarquia] ORDER BY TR5.[Name]) AS VARCHAR(10)) AS [CodigoNivelHierarquia]
		,ISNULL(CAST(LTRIM(RTRIM(TR4.[NomeAtividade1])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade1]
		,ISNULL(CAST(LTRIM(RTRIM(TR4.[NomeAtividade2])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade2]
		,ISNULL(CAST(LTRIM(RTRIM(TR4.[NomeAtividade3])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade3]
		,ISNULL(CAST(LTRIM(RTRIM(TR4.[NomeAtividade4])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade4]
		,ISNULL(CAST(LTRIM(RTRIM(TR5.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade5]
		,ISNULL(CAST(NULL AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade6]
		,CAST(1 AS INT) AS [FlagAtivaHieraquiaAtividadades]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN1]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN2]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN3]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN4]
		,CAST(1 AS INT) AS [FlagAtivaHieAtivN5]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN6]
		,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelProjeto]
		,ISNULL(PRA.[Usuario], 'Não Informado') AS [AnalistaProjeto]
		,ISNULL(PRM.[Usuario], 'Não Informado') AS [GerenteProjeto]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR5
	INNER JOIN CTE_TASKRAY_N4 TR4 ON TR4.[IDTaskRayProjeto] = TR5.[TASKRAY__Project_Parent__c]
	LEFT JOIN CTE_USUARIO OWN ON OWN.[Id] = TR5.[OwnerId]
	LEFT JOIN CTE_USUARIO PRA ON PRA.[Id] = TR5.[ProjectAnalyst__c]
	LEFT JOIN CTE_USUARIO PRM ON PRM.[Id] = TR5.[ProjectManager__c]

), CTE_TASKRAY_N6 AS (

	SELECT DISTINCT
		 ISNULL(CAST(LTRIM(RTRIM(TR6.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeTaskRayProjeto]
		,ISNULL(TR6.[Id], -1) AS [IDTaskRayProjeto]
		,ISNULL(TR6.[TASKRAY__Project_Parent__c], -1) AS [IDTaskRayProjetoSup]
		,TR6.[TASKRAY__Status__c] AS [StatusProjeto]
		,ISNULL(LTRIM(RTRIM(TR6.[Delay_Project__c])), 'Não Informado') AS [DelayProjeto]
		,ISNULL(CAST(TR6.[MilestoneMetaConcluidos__c] AS INT), 0) AS [MilestoneMetaConcluidos]
		,ISNULL(CAST(TR6.[MilestoneMetaTotais__c] AS INT), 0) AS [MilestoneMetaTotais]
		,ISNULL(CAST(TR6.[MilestonesFormalizadosMeta__c] AS DECIMAL(18,2)), 0) AS [MilestonesFormalizadosMeta] 
		,ISNULL(CAST(TR6.[MilestonesProjetoConcluidos__c] AS INT), 0) AS [MilestonesProjetoConcluidos]
		,ISNULL(CAST(TR6.[MilestonesTotais__c] AS INT), 0) AS [MilestonesTotais]
		,ISNULL(CAST(TR6.[MilestonesTotaisProjeto__c] AS INT), 0) AS [MilestonesTotaisProjeto]
		,ISNULL(CAST(TR6.[TASKRAY__trCompletionPercentage__c] AS DECIMAL(18,2)), 0) AS [TaskRayPercentualConcluido]
		,ISNULL(LTRIM(RTRIM(TR6.[Status_Taskray_project__c])), 'Não Informado') AS [TaskRayStatusProjeto]
		,ISNULL(CAST(TR6.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01') AS [TaskRayDataInicialProjeto]
		,ISNULL(CAST(TR6.[TASKRAY__Project_End__c] AS DATE), '1900-01-01') AS [TaskRayDataFinalProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR6.[TASKRAY__Project_Start__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR6.[TASKRAY__Project_End__c] AS DATE), '1900-01-01')) AS [TaskRayDiferencaDias]
		,ISNULL(CAST(TR6.[RealStart__c] AS DATE), '1900-01-01') AS [DataInicialRealProjeto]
		,ISNULL(CAST(TR6.[RealEnd__c] AS DATE), '1900-01-01') AS [DataFinalRealProjeto]
		,DATEDIFF(DD, ISNULL(CAST(TR6.[RealStart__c] AS DATE), '1900-01-01'), ISNULL(CAST(TR6.[RealEnd__c] AS DATE), '1900-01-01')) AS [DiferencaDiasRealProjeto]
		,ISNULL(CAST(TR6.[RealCost__c] AS DECIMAL(18,2)), 0) AS [CustoRealProjeto]
		,ISNULL(CAST(TR6.[PlannedCost__c] AS DECIMAL(18,2)), 0) AS [CustoPlanejadoProjeto]
		,ISNULL(CAST(TR6.[PlannedPercent__c] AS INT), 0) AS [PercentualPlanejado]
		,CAST('Nível 06' AS VARCHAR(10)) AS [NivelHierarquia]
		,TR5.[CodigoNivelHierarquia] + '.' + CAST(ROW_NUMBER() OVER(PARTITION BY TR5.[CodigoNivelHierarquia] ORDER BY TR6.[Name]) AS VARCHAR(10)) AS [CodigoNivelHierarquia]
		,ISNULL(CAST(LTRIM(RTRIM(TR5.[NomeAtividade1])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade1]
		,ISNULL(CAST(LTRIM(RTRIM(TR5.[NomeAtividade2])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade2]
		,ISNULL(CAST(LTRIM(RTRIM(TR5.[NomeAtividade3])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade3]
		,ISNULL(CAST(LTRIM(RTRIM(TR5.[NomeAtividade4])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade4]
		,ISNULL(CAST(LTRIM(RTRIM(TR5.[NomeAtividade5])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade5]
		,ISNULL(CAST(LTRIM(RTRIM(TR6.[Name])) AS VARCHAR(150)), 'Não Informado') AS [NomeAtividade6]
		,CAST(1 AS INT) AS [FlagAtivaHieraquiaAtividadades]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN1]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN2]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN3]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN4]
		,CAST(0 AS INT) AS [FlagAtivaHieAtivN5]
		,CAST(1 AS INT) AS [FlagAtivaHieAtivN6]
		,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelProjeto]
		,ISNULL(PRA.[Usuario], 'Não Informado') AS [AnalistaProjeto]
		,ISNULL(PRM.[Usuario], 'Não Informado') AS [GerenteProjeto]
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] TR6
	INNER JOIN CTE_TASKRAY_N5 TR5 ON TR5.[IDTaskRayProjeto] = TR6.[TASKRAY__Project_Parent__c]
	LEFT JOIN CTE_USUARIO OWN ON OWN.[Id] = TR6.[OwnerId]
	LEFT JOIN CTE_USUARIO PRA ON PRA.[Id] = TR6.[ProjectAnalyst__c]
	LEFT JOIN CTE_USUARIO PRM ON PRM.[Id] = TR6.[ProjectManager__c]

)

SELECT 
	 *
	,CAST([CodigoNivelHierarquia] + ' - ' + [NomeTaskRayProjeto] AS VARCHAR(150)) AS [NomeTaskRayProjetoAjustado]
FROM CTE_TASKRAY_N1

UNION ALL

SELECT 
	 *
	,CAST([CodigoNivelHierarquia] + ' - ' + [NomeTaskRayProjeto] AS VARCHAR(150)) AS [NomeTaskRayProjetoAjustado]
FROM CTE_TASKRAY_N2

UNION ALL

SELECT 
	 *
	,CAST([CodigoNivelHierarquia] + ' - ' + [NomeTaskRayProjeto] AS VARCHAR(150)) AS [NomeTaskRayProjetoAjustado]
FROM CTE_TASKRAY_N3

UNION ALL

SELECT 
	 *
	,CAST([CodigoNivelHierarquia] + ' - ' + [NomeTaskRayProjeto] AS VARCHAR(150)) AS [NomeTaskRayProjetoAjustado]
FROM CTE_TASKRAY_N4

UNION ALL

SELECT 
	 *
	,CAST([CodigoNivelHierarquia] + ' - ' + [NomeTaskRayProjeto] AS VARCHAR(150)) AS [NomeTaskRayProjetoAjustado]
FROM CTE_TASKRAY_N5

UNION ALL

SELECT 
	 *
	,CAST([CodigoNivelHierarquia] + ' - ' + [NomeTaskRayProjeto] AS VARCHAR(150)) AS [NomeTaskRayProjetoAjustado]
FROM CTE_TASKRAY_N6
--ORDER BY CodigoNivelHierarquia



