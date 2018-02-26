


CREATE VIEW [PowerBI].[vw_Compliance_AssinaturaCompliance]
/*WITH SCHEMABINDING*/
AS 

WITH CTE_FUNCIONARIO AS (

	SELECT DISTINCT
		 TFB.Empresa
		,TFB.Matricula 
		,CAST(TFB.Matricula AS INT) AS MatriculaNova
		,TFB.NomeCompleto 
		,TFB.CPF 
		,CAST(TFB.CPF AS BIGINT) AS CPFNovo
		,[Corporativo].[dbo].[RemoveEspacosFormatacao](LOWER(COALESCE(SUBSTRING(LTRIM(RTRIM(TFB.Email)), 0, CHARINDEX('@', TFB.Email)), 'Verificar Email'))) AS Login2
		,CASE WHEN TFB.Empresa = 'PAR Saúde' AND TFB.Matricula = 76 AND TFB.NomeCompleto = 'HEVERTON PESSOA DE MELO PEIXOTO' THEN 'heverton@parsaude.com.br' 
			 ELSE ISNULL(CASE WHEN LEN(LTRIM(RTRIM(TFB.Email))) = 0 THEN NULL ELSE LTRIM(RTRIM(TFB.Email)) END, 'Verificar Email')
		 END AS Email
		,TFB.CodHierarquiaSup1
		,TFB.CodHierarquiaSup2
		,TFB.CodHierarquiaSup3
		,TFB.CodHierarquiaSup4
		,TFB.CodHierarquiaSup5
		,TFB.CodEmpresa
		,TFB.FUCODSITU
		,TFB.CodigoCargo
		,TFB.Cargo
		,CASE WHEN CMP.NomeTermo IN ('Termo de Ciência e Responsabilidade') AND TFB.CodigoCargo = 56 THEN 1
			  WHEN CMP.NomeTermo IN ('Termo de Ciência e Responsabilidade') AND TFB.CodigoCargo <> 56 THEN 0
			  WHEN CMP.NomeTermo IN ('Termo de Ciência Código de Ética', 'Termo Compliance', 'Politica Uso Recursos Tecnológicos') THEN 1
		 END AS FlagFiltroTermos
		,ISNULL(TFB.SituacaoFuncionario, 'NÃO INFORMADO') AS SituacaoFuncionario
		,TFB.DataSituacao
		,CMP.NomeTermo
		,CMP.Arquivo
		,TFB.CodigoCentroCusto
		,REPLACE(REPLACE(ISNULL(TFB.CentroCusto, 'NÃO INFORMADO'), 'OVERHEAD', 'REGIONAL'), 'COM ASVEN', '') AS CentroCusto
		,CASE WHEN CAST(PMW.[MATRICULA] AS INT) IS NOT NULL THEN 'Sim' 
			  ELSE 'Não'
		 END FlagFiltroPMW
	FROM [Corporativo].[PowerBI].[TabelaFuncionariosBasePropay] TFB
	CROSS JOIN (
		SELECT
			 ISNULL(CASE WHEN POL.[Name] IS NULL OR POL.[Name] = 'Teste' THEN 'Termo Compliance' ELSE POL.[Name] END, 'Não Informado') AS NomeTermo
			,ISNULL(REVERSE(LEFT(REVERSE(POL.[Path]), (CHARINDEX('/', REVERSE(POL.[Path])) -1))), 'Não Informado') AS Arquivo
		FROM [Compliance].[dbo].[Politica] POL
		WHERE POL.ID IN (1, 3, 4) ) CMP
	LEFT JOIN [Corporativo].[PowerBI].[BaseFuncionariosPMW] PMW ON CAST(PMW.[MATRICULA] AS INT) = TFB.Matricula 

), CTE_HIERARQUIA AS (

	SELECT DISTINCT
		 HFB.CodEmpresa
		,HFB.CodHierarquia
		,HFB.CodigoCargo
		,HFB.Cargo
	FROM [Corporativo].[PowerBI].[HierarquiaFuncionariosBasePropay] HFB
	--WHERE HFB.Cargo LIKE '%ASSISTENTE DE VENDAS%'

), CTE_COMPLIANCE_TEMP AS (

	--1877
	SELECT
		 MAX(UPL.[DateAccept]) AS DataAceitacao
		,US2.[Matricula]
		,CAST(US2.[Matricula] AS INT) AS MatriculaNova
		,US2.[CPF]
		,CAST(REPLACE(REPLACE(US2.[CPF], '.', ''), '-', '') AS BIGINT) CPFNovo
		,USU.[Login]
		,USU.[Login] AS Login2
		,USU.[Name] AS NomeReduzido
		,[Corporativo].[dbo].[RemoveEspacosFormatacao](LOWER(USU.[Email])) AS Email
		,ISNULL(CASE WHEN POL.[Name] IS NULL OR POL.[Name] = 'Teste' THEN 'Termo Compliance' ELSE POL.[Name] END, 'Não Informado') AS NomeTermo
		,ISNULL(REVERSE(LEFT(REVERSE(POL.[Path]), (CHARINDEX('/', REVERSE(POL.[Path])) -1))), 'Não Informado') AS Arquivo
	FROM [Compliance].[dbo].[UserPolitica] UPL
	LEFT JOIN [Compliance].[dbo].[Usuario] US2 ON US2.UserID = UPL.UserID
	LEFT JOIN [Compliance].[ControleAcesso].[User] USU ON USU.ID = UPL.UserID
	LEFT JOIN [Compliance].[dbo].[Politica] POL ON POL.ID = UPL.IDPolitica
	WHERE POL.ID IN (1, 3, 4)
	--AND USU.[Login] = 'windsonsantos'
	GROUP BY USU.[Login], US2.[Matricula], CAST(US2.[Matricula] AS INT), US2.[CPF], CAST(REPLACE(REPLACE(US2.[CPF], '.', ''), '-', '') AS BIGINT),
		USU.[Name], USU.[Email], ISNULL(REVERSE(LEFT(REVERSE(POL.[Path]), (CHARINDEX('/', REVERSE(POL.[Path])) -1))), 'Não Informado'),
		ISNULL(CASE WHEN POL.[Name] IS NULL OR POL.[Name] = 'Teste' THEN 'Termo Compliance' ELSE POL.[Name] END, 'Não Informado'), REVERSE(POL.[Path])

), CTE_COMPLIANCE AS (

	SELECT DISTINCT
		 TM1.DataAceitacao
		,TM1.Matricula
		,TM1.MatriculaNova
		,TM1.CPF
		,TM1.CPFNovo
		,TM1.[Login]
		,TM1.Login2
		,TM1.NomeReduzido
		,TM1.Email
		,TM1.NomeTermo
		,TM1.Arquivo
	FROM CTE_COMPLIANCE_TEMP TM1

	UNION ALL

	SELECT DISTINCT
		 TMP.DataAceitacao
		,TMP.Matricula
		,TMP.MatriculaNova
		,TMP.CPF
		,TMP.CPFNovo
		,'heverton' COLLATE DATABASE_DEFAULT AS [Login]
		,'heverton' COLLATE DATABASE_DEFAULT AS Login2
		,TMP.NomeReduzido COLLATE DATABASE_DEFAULT AS NomeReduzido
		,'heverton@parsaude.com.br' COLLATE DATABASE_DEFAULT AS Email
		,TMP.NomeTermo COLLATE DATABASE_DEFAULT AS NomeTermo
		,TMP.Arquivo COLLATE DATABASE_DEFAULT AS Arquivo
	FROM CTE_COMPLIANCE_TEMP TMP
	WHERE TMP.[Login] = 'hevertonpeixoto'

), CTE_COMPLIANCE_DATA_ARQUIVO AS (

	SELECT 
		 MAX(CMP.DataAceitacao) AS DataMaiorAssinatura
		,MAX(CMP.NomeTermo) AS NomeTermo
		,MAX(CMP.Arquivo) AS ArquivoCompliance
	FROM CTE_COMPLIANCE CMP

), CTE_NOME_USUARIO AS (

	SELECT DISTINCT
		 NOM.[CPFNovo]
		,NOM.[Login]
		,NOM.[Login2]
		,NOM.[NomeReduzido]
		,NOM.[Email]
	FROM CTE_COMPLIANCE NOM

)

SELECT DISTINCT
	 FUN.Empresa
	,FUN.Matricula
	,[Corporativo].[Dados].[fn_FormataCPF](FUN.CPFNovo) AS CPF
	,FUN.NomeCompleto
	,ISNULL(COALESCE(COM.[Login], NOM.[Login], CASE WHEN LEN(LTRIM(RTRIM(FUN.Login2))) = 0 THEN NULL ELSE FUN.Login2 END), 'Não Informado') AS [Login]
    ,ISNULL(COALESCE(COM.NomeReduzido, NOM.NomeReduzido), 'Não Informado') AS NomeReduzido
	,FUN.Cargo
	,FUN.Email
	,FUN.Email AS EmailFuncionario
	,COALESCE(COM.Email, NOM.Email) AS EmailCompliance
	,COM.DataAceitacao
	,FUN.NomeTermo
	--,ISNULL(COM.NomeTermo, 'Termo Compliance') AS NomeTermo
	,FUN.Arquivo
	--,ISNULL(COM.Arquivo, 'PoliticaUsoRecursosTecnologicos_ParCorretora.pdf') AS Arquivo
	,CASE WHEN COM.CPFNovo IS NULL THEN 'Não Assinou' ELSE 'Assinou' END AS FlagAceitacao
	--,(CASE WHEN COM.Email IS NULL THEN 'Não Assinou' ELSE 'Assinou' END) FlagAceitacao
	,1 AS Usuário
	,CMP.DataMaiorAssinatura
	,GETDATE() AS DataMaiorAtualizacao
	,FUN.CodHierarquiaSup1
	,H1.Cargo AS HierarquiaSup1
	,FUN.CodHierarquiaSup2
	,H2.Cargo AS HierarquiaSup2
	,FUN.CodHierarquiaSup3
	,H3.Cargo AS HierarquiaSup3
	,FUN.CodHierarquiaSup4
	,H4.Cargo AS HierarquiaSup4
	,FUN.CodHierarquiaSup5
	,H5.Cargo AS HierarquiaSup5
	,FUN.SituacaoFuncionario
	,FUN.DataSituacao
	,CAST(FUN.FlagFiltroPMW AS VARCHAR(10)) AS FlagFiltroPMW
	,FUN.CodigoCentroCusto
	,FUN.CentroCusto
FROM CTE_FUNCIONARIO FUN
LEFT JOIN CTE_COMPLIANCE COM ON COM.CPFNovo = FUN.CPFNovo AND COM.NomeTermo = FUN.NomeTermo AND COM.Arquivo = FUN.Arquivo
LEFT JOIN CTE_NOME_USUARIO NOM ON NOM.CPFNovo = FUN.CPFNovo
--LEFT JOIN CTE_COMPLIANCE COM ON LTRIM(RTRIM(COM.Login2)) = LTRIM(RTRIM(FUN.Login2)) AND COM.NomeTermo = FUN.NomeTermo AND COM.Arquivo = FUN.Arquivo --LTRIM(RTRIM(COM.Email)) = LTRIM(RTRIM(FUN.Email))
LEFT JOIN CTE_HIERARQUIA H1 ON H1.CodHierarquia = FUN.CodHierarquiaSup1 AND H1.CodEmpresa = FUN.CodEmpresa AND H1.CodigoCargo = FUN.CodigoCargo
LEFT JOIN CTE_HIERARQUIA H2 ON H2.CodHierarquia = FUN.CodHierarquiaSup2 AND H2.CodEmpresa = FUN.CodEmpresa
LEFT JOIN CTE_HIERARQUIA H3 ON H3.CodHierarquia = FUN.CodHierarquiaSup3 AND H3.CodEmpresa = FUN.CodEmpresa
LEFT JOIN CTE_HIERARQUIA H4 ON H4.CodHierarquia = FUN.CodHierarquiaSup4 AND H4.CodEmpresa = FUN.CodEmpresa
LEFT JOIN CTE_HIERARQUIA H5 ON H5.CodHierarquia = FUN.CodHierarquiaSup5 AND H5.CodEmpresa = FUN.CodEmpresa
CROSS JOIN CTE_COMPLIANCE_DATA_ARQUIVO CMP
WHERE FUN.FlagFiltroTermos = 1
--AND FUN.NomeCompleto = 'ADRIELE DA SILVA GOMES'
--AND COM.NomeReduzido IS NULL
--AND FUN.MatriculaNova = 5380
--AND FUN.NomeCompleto = 'TICIANE DE MATOS RODRIGUES'
--ORDER BY 2, 4

