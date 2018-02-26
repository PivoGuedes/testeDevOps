


CREATE VIEW [PowerBI].[vw_TaskRaySprint] AS

WITH CTE_USUARIO AS (

	SELECT DISTINCT
		 USU.[Id] AS [UserId]
		,CASE WHEN USU.[Name] LIKE '%FREDERICO%' THEN CAST('Frederico Cerdeira' AS VARCHAR(150)) 
			  WHEN USU.[Name] LIKE '%Danilo de Macedo Teixeira%' THEN CAST('Danilo Teixeira' AS VARCHAR(150)) 
			  WHEN USU.[Name] LIKE '%João Gabriel de Britto e Silva%' THEN CAST('João Gabriel' AS VARCHAR(150)) 
			  WHEN USU.[Name] LIKE '%Lucas Shimabuko Silva Rocha%' THEN CAST('Lucas Rocha' AS VARCHAR(150)) 
			  WHEN USU.[Name] LIKE '%Bruno Pereira Passos%' THEN CAST('Bruno Passos' AS VARCHAR(150)) 
			  WHEN USU.[Name] LIKE '%THIAGO FELIPE DE OLIVEIRA AMARANTE SANTOS%' THEN CAST('Thiago Amarante' AS VARCHAR(150)) 
			  ELSE CAST(USU.[Name] AS VARCHAR(150))
		 END AS [Usuario]
		,CASE WHEN USU.[Id] IN ('0051a000001H9ikAAC', '0051a0000023qfMAAQ') THEN '00E1a000000QHCcEAO'
			  WHEN USU.[Id] IN ('0051a000002P8RjAAK') THEN '00E1a000000EMykEAG'
			  ELSE USU.[UserRoleId]
		 END [UserRoleId]
		,CASE WHEN USU.[Id] IN ('0051a000001H9ikAAC', '0051a000001RaJ0AAK', '0051a000001sHo6AAE', '0051a0000024Qk3AAE', '0051a0000024Qk8AAE', '0051a000001RaI7AAK', '0051a000000T6J7AAK', '0051a000001RaIHAA0', '0051a000002avjsAAA', '0051a0000023qfMAAQ') THEN CAST('Desenvolvimento' AS VARCHAR(150))
			  WHEN USU.[Id] IN ('0051a000002P8RjAAK', '0051a000001RaHEAA0', '0051a000001RaHJAA0', '0051a000001RnZBAA0', '0051a000001sZx6AAE', '0051a0000025wXYAAY', '0051a00000266H1AAI', '0051a000002bW7MAAU', '0051a000001RaHdAAK') THEN CAST('BI' AS VARCHAR(150))
			  WHEN USU.[Id] IN ('0051a000001rDTlAAM', '0051a000001RaGuAAK', '0051a000001RaGzAAK', '0051a0000025f87AAA', '0051a00000266GwAAI') THEN CAST('Infraestrutura' AS VARCHAR(150))
			  ELSE CAST(URO.[Name] AS VARCHAR(150))
		 END AS [AreaUsuario] --SELECT DISTINCT URO.[Name], USU.[Id]
	FROM [SALESFORCE BACKUPS].[dbo].[User] USU
	LEFT JOIN [SALESFORCE BACKUPS].[dbo].[UserRole] URO ON URO.[Id] = USU.[UserRoleId]
	WHERE USU.[Id] IN ('0051a000001RaHdAAK', '0051a000001RaHJAA0', '0051a0000024Qk3AAE', '0051a000001sHo6AAE', '0051a0000025f87AAA', '0051a000001H9ikAAC', '0051a000002P8RjAAK', 
		'0051a000002avjsAAA', '0051a000001sZx6AAE', '0051a000001rDTlAAM', '0051a0000024Qk8AAE', '0051a000001RaJ0AAK', '0051a000001RaGuAAK', '0051a000001RnZBAA0', 
		'0051a0000023qfMAAQ', '0051a000001RaGzAAK', '0051a00000266GwAAI', '0051a0000025wXYAAY', '0051a00000266H1AAI', '0051a000001RaHEAA0', '0051a000001RaIHAA0', '0051a000002bW7MAAU', '0051a000001RaI7AAK')
	--AND USU.[Id] IN (SELECT DISTINCT TR1.[OwnerId] FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project_Task__c] TR1)
	--AND USU.[UserRoleId] IN ('00E1a000000LzXQEA0', '00E1a000000QHCcEAO', '00E1a000000QHChEAO', '00E1a000000Yr7XEAS', '00E1a000000LqMIEA0')
	--ORDER BY 1, 2

), CTE_HISTORICO_TASK_TEMP AS (

	SELECT
		 THI.[CreatedDate]
		,THI.[Field]
		,THI.[Id]
		,THI.[IsDeleted]
		,THI.[OldValue]
		,THI.[NewValue]
		,THI.[ParentId] --ID DA DEMANDA DO TASKRAY
		,ROW_NUMBER() OVER(PARTITION BY THI.[ParentId] ORDER BY THI.[CreatedDate] DESC) AS [Ordem] --PEGA SEMPRE A ULTIMA MODIFICACAO
	FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project_Task__History] THI
	WHERE THI.[Field] = 'TASKRAY__List__c'
	AND THI.[IsDeleted] = 'false'
	--AND THI.[ParentId] IN ('a0r1a000002o8jsAAA', 'a0r1a000000y8g3AAA')
	--ORDER BY THI.[ParentId], THI.[CreatedDate] DESC

), CTE_HISTORICO_TASK AS (

	SELECT
		 HTT.[CreatedDate]
		,HTT.[Field]
		,HTT.[Id]
		,HTT.[IsDeleted]
		,HTT.[OldValue]
		,HTT.[NewValue]
		,HTT.[ParentId]
		,HTT.[Ordem]  
	FROM CTE_HISTORICO_TASK_TEMP HTT
	WHERE HTT.[Ordem] = 1	--FILTRA PELA MAIOR MODIFICACAO

)--, CTE AS (

SELECT
	 TR1.[ChecklistsConcluidas__c]
    ,TR1.[ChecklistsPlanejadas__c]
    ,TR1.[CreatedById]
    ,TR1.[CreatedDate]
    ,ISNULL(CAST(TR1.[Data_Fim_da_Sprint__c] AS DATE), '1900-01-01') AS [Data_Fim_da_Sprint__c]
    ,ISNULL(TR1.[Delay_Task__c], 'Não Informado') AS [Delay_Task__c]
    ,TR1.[DiasAtraso__c]
    ,TR1.[Duration__c]
    ,ISNULL(TR1.[E_emergencial__c], 'Normal') AS [E_emergencial__c]
    ,TR1.[Emergencial__c]
    ,ISNULL(TR1.[Id], '-1') AS [Id]
	,CASE WHEN ISNULL(TR1.[Id], '-1') = '-1' THEN 0 ELSE 1 END AS [QtdDemandas]
    ,TR1.[ImageAtividadesCriticas__c]
    ,TR1.[IsDeleted]
    ,TR1.[LastModifiedById]
    ,TR1.[LastModifiedDate]
    ,TR1.[LastReferencedDate]
    ,TR1.[LastViewedDate]
    ,TR1.[Mes_de_Conclusao__c]
    ,TR1.[MilestoneMeta__c]
    ,TR1.[MKT_Carteira_Task__c]
    ,TR1.[MKT_ID_Task__c]
    ,ISNULL(CASE WHEN LEN(LTRIM(RTRIM(TR1.[MKT_Tipo_Task__c]))) <= 1 THEN NULL ELSE TR1.[MKT_Tipo_Task__c] END, 'Não Informado') AS [MKT_Tipo_Task__c]
    ,TR1.[Name]
    ,ISNULL(OWN.[Usuario], 'Não Informado') AS [ResponsavelDemanda]
	,CAST(CASE WHEN ISNULL(OWN.[Usuario], 'Não Informado') = 'Não Informado' THEN 0 ELSE 1 END AS INT) AS [FlagResponsavelDemanda]
	,ISNULL(OWN.[UserId], 'Não Informado') AS [UserId]
	,ISNULL(OWN.[UserRoleId], 'Não Informado') AS [UserRoleId]
	,ISNULL(OWN.[AreaUsuario], 'Não Informado') AS [AreaUsuario]
    ,TR1.[PercentComplete__c]
    ,TR1.[PlanejamentoChecklist__c]
    ,TR1.[PlannedCost__c]
    ,TR1.[Pontuacao__c]
    ,ISNULL(CAST(TR1.[RealStart__c] AS DATE), '1900-01-01') AS [RealStart__c]
	,ISNULL(CAST(TR1.[RealEnd__c] AS DATE), '1900-01-01') AS [RealEnd__c]
    ,TR1.[RecordTypeId]
    ,TR1.[Resquest_Date__c]
    ,TR1.[Sprint__c]
    ,ISNULL(TR1.[Stakeholder__c], 'Não Informado') AS [Stakeholder__c]
    ,TR1.[SystemModstamp]
    ,TR1.[TASKRAY__Archived__c]
	,CAST(CASE WHEN TR1.[TASKRAY__Archived__c] = 'false' THEN 0 
			   WHEN TR1.[TASKRAY__Archived__c] = 'true' THEN 1 
		  END AS INT) AS [FlagDemandaArquivada]
    ,TR1.[TASKRAY__Blocked__c]
    ,TR1.[TASKRAY__Deadline__c]
	,ISNULL(CAST(COALESCE(TR1.[TASKRAY__Deadline__c], TR1.[RealEnd__c]) AS DATE), '1900-01-01') AS [DataFimDemanda]
    ,TR1.[TASKRAY__Dependent_On__c]
    ,TR1.[TASKRAY__Dependent_Update_Pending__c]
    ,TR1.[TASKRAY__Description__c]

	/* A LISTA DE ATIVIDADES DA TASKRAY TASK E DA CTE HISTORICA É A MESMA, VOU USAR COMO PARAMETRO A DATA DO HISTORICO PARA MARCAR A SPRINT */
    ,ISNULL(CASE WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) = 'Ideia' THEN '1 - Ideia'
				 WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) = 'Planejamento' THEN '2 - Planejamento'
				 WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) = 'Priorização' THEN '3 - Priorização'
				 WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) = 'Execução' THEN '4 - Execução'
				 WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) = 'Homologação' THEN '5 - Homologação'
				 WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) = 'Conclusão' THEN '6 - Conclusão'
				 ELSE NULL
			END, 'Não Informado') AS [TASKRAY__List__c]
	,ISNULL(CASE WHEN COALESCE(CHT.[NewValue], TR1.[TASKRAY__List__c]) = 'Ideia' THEN '1 - Ideia'
				 WHEN COALESCE(CHT.[NewValue], TR1.[TASKRAY__List__c]) = 'Planejamento' THEN '2 - Planejamento'
				 WHEN COALESCE(CHT.[NewValue], TR1.[TASKRAY__List__c]) = 'Priorização' THEN '3 - Priorização'
				 WHEN COALESCE(CHT.[NewValue], TR1.[TASKRAY__List__c]) = 'Execução' THEN '4 - Execução'
				 WHEN COALESCE(CHT.[NewValue], TR1.[TASKRAY__List__c]) = 'Homologação' THEN '5 - Homologação'
				 WHEN COALESCE(CHT.[NewValue], TR1.[TASKRAY__List__c]) = 'Conclusão' THEN '6 - Conclusão'
				 ELSE NULL
			END, 'Não Informado') AS [ListaAtividadesTaskRay]
	,ISNULL(CAST(CHT.[CreatedDate] AS DATETIME), '1900-01-01') AS [DataAtividadesTaskRay]
	,ISNULL(CAST(CASE WHEN LTRIM(RTRIM(TR1.[TASKRAY__List__c])) IN ('Ideia') THEN 0 ELSE 1 END AS INT), 0) AS [FlagDemandaSprint]
    ,TR1.[TASKRAY__Priority__c]
	,ISNULL(COALESCE(PRJ.[IDTaskRayProjeto], TR1.[TASKRAY__Project__c]), '-1') AS [TASKRAY__Project__c]
	,ISNULL(LTRIM(RTRIM(PRJ.[NomeTaskRayProjeto])), 'Não Informado') AS [NomeProjetoTaskRay]
	,ISNULL(LTRIM(RTRIM(DDS.[NomeTaskRayProjeto])), 'Não Informado') AS [NomeTaskRayProjeto]
	,ISNULL(LTRIM(RTRIM(PRJ.[NomeTaskRayProjetoAjustado])), 'Não Informado') AS [NomeTaskRayProjetoAjustado]
	,CAST(CASE WHEN ISNULL(DDS.[IDTaskRayProjeto], '-1') = '-1' THEN 0
			   ELSE 1
		  END AS INT) AS [FlagDemandaSemanaSprint]
	,ISNULL(COALESCE(PRJ.[IDTaskRayProjeto], TR1.[TASKRAY__Project__c], DDS.[IDTaskRayProjeto]), '-1') AS [IDTaskRayProjeto]
	,ISNULL(COALESCE(PRJ.[IDTaskRayProjetoSup], DDS.[IDTaskRayProjetoSup]), '-1') AS [IDTaskRayProjetoSup]
	,ISNULL(DDS.[FlagCarteiraSprint], 0) AS [FlagCarteiraSprint]
    ,TR1.[TASKRAY__Repeat_End_Date__c]
    ,TR1.[TASKRAY__Repeat_Every__c]
    ,TR1.[TASKRAY__Repeat_Interval_Type__c]
    ,TR1.[TASKRAY__Repeat_Week_Days__c]
    ,TR1.[TASKRAY__RepeatCreated__c]
    ,TR1.[TASKRAY__SortOrder__c]
    ,TR1.[TASKRAY__Status__c]
    ,TR1.[TASKRAY__trAccount__c]
    ,TR1.[TASKRAY__trCompleted__c]
    ,TR1.[TASKRAY__trDepOffset__c]
    ,TR1.[TASKRAY__trDuration__c]
    ,TR1.[TASKRAY__trEstimatedHours__c]
    ,TR1.[TASKRAY__trHidden__c]
    ,TR1.[TASKRAY__trHideUntil__c]
    ,TR1.[TASKRAY__trHideUntilOffset__c]
    ,TR1.[TASKRAY__trIsMilestone__c]
    ,TR1.[TASKRAY__trOpportunity__c]
    ,TR1.[TASKRAY__trProjectSortOrder__c]
    ,ISNULL(CAST(TR1.[TASKRAY__trStartDate__c] AS DATE), '1900-01-01') AS [TASKRAY__trStartDate__c]
	,ISNULL(CAST(COALESCE(TR1.[TASKRAY__trStartDate__c], TR1.[RealStart__c], TR1.[RealEnd__c]) AS DATE), '1900-01-01') AS [DataInicioTaskRay]
	,ISNULL(CAST(CHT.[CreatedDate] AS DATE), '1900-01-01') AS [DataAtividadesSprint]
    ,TR1.[TASKRAY__trTime_Entry_Count__c]
    ,TR1.[TASKRAY__trTotalTimeOnTask__c]
    ,TR1.[Time_Act_Est__c]
    ,ISNULL(CASE WHEN LEN(LTRIM(RTRIM(TR1.[Type__c]))) <= 1 THEN NULL ELSE TR1.[Type__c] END, 'Não Informado') AS [Type__c]
FROM [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project_Task__c] TR1
LEFT JOIN CTE_USUARIO OWN ON OWN.[UserId] = TR1.[OwnerId]
--LEFT JOIN [SALESFORCE BACKUPS].[dbo].[TASKRAY__Project__c] PRJ ON PRJ.[Id] = TR1.[TASKRAY__Project__c]
LEFT JOIN [Corporativo].[PowerBI].[vw_TaskRayProjeto] PRJ ON PRJ.[IDTaskRayProjeto] = TR1.[TASKRAY__Project__c]
LEFT JOIN CTE_HISTORICO_TASK CHT ON CHT.[ParentId] = TR1.[Id]
LEFT JOIN [Corporativo].[PowerBI].[vw_TaskRayDefinicaoDemandasSprint] DDS ON DDS.[IDTaskRayProjeto] = TR1.[TASKRAY__Project__c]
--WHERE OWN.[UserId] NOT IN ('0051a000001QxbIAAS', '0051a000001QyZDAA0', '0051a000001HFiXAAW', '0051a000000T5X8AAK')
--WHERE TR1.Id = 'a0r1a000000yF8OAAU' --'a0r1a000002o8jsAAA'
--AND TR1.Name LIKE '%Z06%'

--)

--SELECT DISTINCT
--	NomeProjetoTaskRay, [IDTaskRayProjeto]
--FROM CTE
--ORDER BY 1




