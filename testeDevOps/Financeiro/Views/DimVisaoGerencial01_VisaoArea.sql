﻿
CREATE VIEW [Financeiro].[DimVisaoGerencial01_VisaoArea]
AS

WITH CTE_AREAVG1 AS (

	SELECT
		 LTRIM(RTRIM(CTS.CTS_CONTAG)) AS CD_AGRUPAMENTO_AREA_VG1
		,LEFT(LTRIM(RTRIM(CTS.CTS_CONTAG)), 2) AS CD_NIVELI_AGRUPAMENTO_AREA_VG1
		,LTRIM(RTRIM(CTS.CTS_DESCCG)) AS DS_AGRUPAMENTO_AREA_VG1
	FROM [SCASE].[RBDF27].[dbo].[CTS010] CTS
	WHERE CTS.D_E_L_E_T_ = '' 
	AND CTS.CTS_CODPLA = '001'	--VISÃO GERENCIAL 1 - AGRUPAMENTO POR ÁREA
	GROUP BY CTS.CTS_CONTAG, CTS.CTS_DESCCG
	--ORDER BY CTS_CONTAG

), CTE_NIVELVG2 AS (

	SELECT DISTINCT
		 NV1.CD_AGRUPAMENTO_AREA_VG1 AS CD_NIVELI_AGRUPAMENTO_AREA_VG1
		,NV1.DS_AGRUPAMENTO_AREA_VG1 AS DS_NIVELI_AGRUPAMENTO_AREA_VG1
	FROM CTE_AREAVG1 NV1
	WHERE LEN(NV1.CD_AGRUPAMENTO_AREA_VG1) = 2

)

SELECT 
	 DV2.CD_NIVELI_AGRUPAMENTO_AREA_VG1
	,DV2.DS_NIVELI_AGRUPAMENTO_AREA_VG1
	,VG1.CD_AGRUPAMENTO_AREA_VG1
	,VG1.DS_AGRUPAMENTO_AREA_VG1
FROM CTE_AREAVG1 VG1
LEFT JOIN CTE_NIVELVG2 DV2 ON DV2.CD_NIVELI_AGRUPAMENTO_AREA_VG1 = VG1.CD_NIVELI_AGRUPAMENTO_AREA_VG1
WHERE LEN(VG1.CD_AGRUPAMENTO_AREA_VG1) = 4
--ORDER BY 1, 2

UNION

SELECT
	 '-1' AS CD_NIVELI_AGRUPAMENTO_AREA_VG1
	,'Não Informado' AS DS_NIVELI_AGRUPAMENTO_AREA_VG1
	,'-1' AS CD_AGRUPAMENTO_AREA_VG1
	,'Não Informado' AS DS_AGRUPAMENTO_AREA_VG1

UNION

SELECT 
	 '999999' AS CD_NIVELI_AGRUPAMENTO_AREA_VG1
	,'Pacote' AS DS_NIVELI_AGRUPAMENTO_AREA_VG1
	,'999999' AS CD_AGRUPAMENTO_AREA_VG1
	,'Pacote' AS DS_AGRUPAMENTO_AREA_VG1

