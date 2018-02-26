﻿

CREATE VIEW [PowerBI].[vw_HomologacaoMobilizeDMSF]
AS 

SELECT
     CAST(ISNULL(TMC.[ChaveUnicaTMC], '-1') AS VARCHAR(200)) AS [ChaveUnica]
    ,CAST(ISNULL(TMC.[CodigoAgencia], -1) AS INT) AS [CodigoAgencia]
	,CAST(ISNULL(AG2.[CodigoAgencia], -1) AS INT) AS [CodigoUnidadeSuperior]
    ,CAST(ISNULL(TMC.[Agencia], 'Não Informado') AS VARCHAR(100)) AS [Agencia]
    ,CAST(ISNULL(TMC.[TipoUnidade], 'Não Informado') AS VARCHAR(20)) AS [TipoUnidade]
    ,CAST(ISNULL(TMC.[Ano], -1) AS INT) AS [Ano]
    ,CAST(ISNULL(TMC.[Mes], -1) AS INT) AS [Mes]
    ,CAST(ISNULL(TMC.[DataReferencia], '1900-01-01') AS DATE) AS [DataReferencia]
	,CAST(ISNULL(TMC.[DataArquivo], '1900-01-01') AS DATE) AS [DataArquivo]
    ,CAST(ISNULL(TMC.[QtdOfertasTotal_DM], 0) AS DECIMAL(18,2)) AS [Metrica1_DM]
    ,CAST(ISNULL(TMC.[QtdOfertasTotal_SF], 0) AS DECIMAL(18,2)) AS [Metrica1_SF]
    ,CAST(ISNULL(TMC.[VerificaQtdOfertasTotal], 0) AS INT) AS [VerificaMetrica1]
    ,CAST(ISNULL(TMC.[QtdTransacoes_DM], 0) AS DECIMAL(18,2)) AS [Metrica2_DM]
    ,CAST(ISNULL(TMC.[QtdTransacoes_SF], 0) AS DECIMAL(18,2)) AS [Metrica2_SF]
    ,CAST(ISNULL(TMC.[VerificaQtdTransacoes], 0) AS INT) AS [VerificaMetrica2]
	,CAST(ISNULL(TMC.[QtdRegistro_DM], 0) AS INT) AS [QtdRegistro_DM]
	,CAST(ISNULL(TMC.[QtdRegistro_SF], 0) AS INT) AS [QtdRegistro_SF]
	,CAST(ISNULL(TMC.[VerificaQtdRegistro], 0) AS INT) AS [VerificaQtdRegistro]
	,CAST(ISNULL(TMC.[TransacaoBancaria], 'Não Informado') AS VARCHAR(50)) AS [DetalhamentoMetricas]
	,CAST('Tem Mais Caixa' AS VARCHAR(20)) AS [FonteDados]
	,CAST('Mobilize' AS VARCHAR(20)) AS [OrigemDados]
	,CAST(1 AS INT) AS [QtdChavesUnicas]
	,CAST(TMC.[ImagemValidacao] AS VARCHAR(200)) AS [ImagemValidacao]
	,CAST(TMC.[StatusValidacao] AS VARCHAR(20)) AS [StatusValidacao]	
	,CAST(ISNULL(TMC.[DataFimEnvio], '1900-01-01') AS DATETIME) AS [DataFimEnvio]
	,CAST(GETDATE() AS DATETIME) AS [DataAtualizacaoPainel]
	,CAST(TMC.[DataAtualizacaoValidador] AS DATETIME) AS [DataAtualizacaoValidador]
FROM [Corporativo].[PowerBI].[HomologacaoTemMaisCaixaDMSF] TMC
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AGE ON AGE.[CodigoAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = TMC.[CodigoAgencia]
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AG2 ON AG2.[IDAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = AGE.[UnidadeSuperior__c]

UNION ALL

SELECT
     CAST(ISNULL(REM.[ChaveUnicaREM], '-1') AS VARCHAR(200)) AS [ChaveUnica]
    ,CAST(ISNULL(REM.[CodigoAgencia], -1) AS INT) AS [CodigoAgencia]
	,CAST(ISNULL(AG2.[CodigoAgencia], -1) AS INT) AS [CodigoUnidadeSuperior]
    ,CAST(ISNULL(REM.[Agencia], 'Não Informado') AS VARCHAR(100)) AS [Agencia]
    ,CAST(ISNULL(REM.[TipoUnidade], 'Não Informado') AS VARCHAR(20)) AS [TipoUnidade]
    ,CAST(ISNULL(REM.[Ano], -1) AS INT) AS [Ano]
    ,CAST(ISNULL(REM.[Mes], -1) AS INT) AS [Mes]
    ,CAST(ISNULL(REM.[DataReferencia], '1900-01-01') AS DATE) AS [DataReferencia]
    ,CAST(ISNULL(REM.[DataArquivo], '1900-01-01') AS DATE) AS [DataArquivo]
    ,CAST(ISNULL(REM.[TotalGapMes_DM], 0) AS DECIMAL(18,2)) AS [Metrica1_DM]
    ,CAST(ISNULL(REM.[TotalGapMes_SF], 0) AS DECIMAL(18,2)) AS [Metrica1_SF]
    ,CAST(ISNULL(REM.[VerificaTotalGapMes], 0) AS INT) AS [VerificaMetrica1]
    ,CAST(ISNULL(REM.[TotalGapSemestre_DM], 0) AS DECIMAL(18,2)) AS [Metrica2_DM]
    ,CAST(ISNULL(REM.[TotalGapSemestre_SF], 0) AS DECIMAL(18,2)) AS [Metrica2_SF]
    ,CAST(ISNULL(REM.[VerificaTotalGapSemestre], 0) AS INT) AS [VerificaMetrica2]
	,CAST(ISNULL(REM.[QtdRegistro_DM], 0) AS INT) AS [QtdRegistro_DM]
	,CAST(ISNULL(REM.[QtdRegistro_SF], 0) AS INT) AS [QtdRegistro_SF]
	,CAST(ISNULL(REM.[VerificaQtdRegistro], 0) AS INT) AS [VerificaQtdRegistro]
	,CAST('Realize Empregado' AS VARCHAR(50)) AS [DetalhamentoMetricas]
	,CAST('Realize Empregado' AS VARCHAR(20)) AS [FonteDados]
	,CAST('Mobilize' AS VARCHAR(20)) AS [OrigemDados]
	,CAST(1 AS INT) AS [QtdChavesUnicas]
	,CAST(REM.[ImagemValidacao] AS VARCHAR(200)) AS [ImagemValidacao]
	,CAST(REM.[StatusValidacao] AS VARCHAR(20)) AS [StatusValidacao]
	,CAST(ISNULL(REM.[DataFimEnvio], '1900-01-01') AS DATETIME) AS [DataFimEnvio]
	,CAST(GETDATE() AS DATETIME) AS [DataAtualizacaoPainel]
	,CAST(REM.[DataAtualizacaoValidador] AS DATETIME) AS [DataAtualizacaoValidador]
FROM [Corporativo].[PowerBI].[HomologacaoRealizeEmpregadoDMSF] REM
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AGE ON AGE.[CodigoAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = REM.[CodigoAgencia]
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AG2 ON AG2.[IDAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = AGE.[UnidadeSuperior__c]

UNION ALL

SELECT
     CAST(ISNULL(REA.[ChaveUnicaREA], '-1') AS VARCHAR(200)) AS [ChaveUnica]
    ,CAST(ISNULL(REA.[CodigoAgencia], -1) AS INT) AS [CodigoAgencia]
	,CAST(ISNULL(AG2.[CodigoAgencia], -1) AS INT) AS [CodigoUnidadeSuperior]
    ,CAST(ISNULL(REA.[Agencia], 'Não Informado') AS VARCHAR(100)) AS [Agencia]
    ,CAST(ISNULL(REA.[TipoUnidade], 'Não Informado') AS VARCHAR(20)) AS [TipoUnidade]
    ,CAST(ISNULL(REA.[Ano], -1) AS INT) AS [Ano]
    ,CAST(ISNULL(REA.[Mes], -1) AS INT) AS [Mes]
    ,CAST(ISNULL(REA.[DataReferencia], '1900-01-01') AS DATE) AS [DataReferencia]
    ,CAST(ISNULL(REA.[DataArquivo], '1900-01-01') AS DATE) AS [DataArquivo]
    ,CAST(ISNULL(REA.[TotalRealizado_DM], 0) AS DECIMAL(18,2)) AS [Metrica1_DM]
    ,CAST(ISNULL(REA.[TotalRealizado_SF], 0) AS DECIMAL(18,2)) AS [Metrica1_SF]
    ,CAST(ISNULL(REA.[VerificaTotalRealizado], 0) AS INT) AS [VerificaMetrica1]
    ,CAST(ISNULL(REA.[TotalMeta_DM], 0) AS DECIMAL(18,2)) AS [Metrica2_DM]
    ,CAST(ISNULL(REA.[TotalMeta_SF], 0) AS DECIMAL(18,2)) AS [Metrica2_SF]
    ,CAST(ISNULL(REA.[VerificaTotalMeta], 0) AS INT) AS [VerificaMetrica2]
	,CAST(ISNULL(REA.[QtdRegistro_DM], 0) AS INT) AS [QtdRegistro_DM]
	,CAST(ISNULL(REA.[QtdRegistro_SF], 0) AS INT) AS [QtdRegistro_SF]
	,CAST(ISNULL(REA.[VerificaQtdRegistro], 0) AS INT) AS [VerificaQtdRegistro]
	,CAST('Realize' AS VARCHAR(50)) AS [DetalhamentoMetricas]
	,CAST('Realize' AS VARCHAR(20)) AS [FonteDados]
	,CAST('Mobilize' AS VARCHAR(20)) AS [OrigemDados]
	,CAST(1 AS INT) AS [QtdChavesUnicas]
	,CAST(REA.[ImagemValidacao] AS VARCHAR(200)) AS [ImagemValidacao]
	,CAST(REA.[StatusValidacao] AS VARCHAR(20)) AS [StatusValidacao]
	,CAST(ISNULL(REA.[DataFimEnvio], '1900-01-01') AS DATETIME) AS [DataFimEnvio]
	,CAST(GETDATE() AS DATETIME) AS [DataAtualizacaoPainel]
	,CAST(REA.[DataAtualizacaoValidador] AS DATETIME) AS [DataAtualizacaoValidador]
FROM [Corporativo].[PowerBI].[HomologacaoRealizeDMSF] REA
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AGE ON AGE.[CodigoAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = REA.[CodigoAgencia]
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AG2 ON AG2.[IDAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = AGE.[UnidadeSuperior__c]

UNION ALL

SELECT
     CAST(ISNULL(TMV.[ChaveUnicaTMV], '-1') AS VARCHAR(200)) AS [ChaveUnica]
    ,CAST(ISNULL(TMV.[CodigoAgencia], -1) AS INT) AS [CodigoAgencia]
	,CAST(ISNULL(AG2.[CodigoAgencia], -1) AS INT) AS [CodigoUnidadeSuperior]
    ,CAST(ISNULL(TMV.[Agencia], 'Não Informado') AS VARCHAR(100)) AS [Agencia]
    ,CAST(ISNULL(TMV.[TipoUnidade], 'Não Informado') AS VARCHAR(20)) AS [TipoUnidade]
    ,CAST(ISNULL(TMV.[Ano], -1) AS INT) AS [Ano]
    ,CAST(ISNULL(TMV.[Mes], -1) AS INT) AS [Mes]
    ,CAST(ISNULL(TMV.[DataReferencia], '1900-01-01') AS DATE) AS [DataReferencia]
    ,CAST(ISNULL(TMV.[DataArquivo], '1900-01-01') AS DATE) AS [DataArquivo]
    ,CAST(ISNULL(TMV.[QtdVendasTotal_DM], 0) AS DECIMAL(18,2)) AS [Metrica1_DM]
    ,CAST(ISNULL(TMV.[QtdVendasTotal_SF], 0) AS DECIMAL(18,2)) AS [Metrica1_SF]
    ,CAST(ISNULL(TMV.[VerificaQtdVendasTotal], 0) AS INT) AS [VerificaMetrica1]
    ,CAST(ISNULL(TMV.[QtdFuncionarios_DM], 0) AS DECIMAL(18,2)) AS [Metrica2_DM]
    ,CAST(ISNULL(TMV.[QtdFuncionarios_SF], 0) AS DECIMAL(18,2)) AS [Metrica2_SF]
    ,CAST(ISNULL(TMV.[VerificaQtdFuncionarios], 0) AS INT) AS [VerificaMetrica2]
	,CAST(ISNULL(TMV.[QtdRegistro_DM], 0) AS INT) AS [QtdRegistro_DM]
	,CAST(ISNULL(TMV.[QtdRegistro_SF], 0) AS INT) AS [QtdRegistro_SF]
	,CAST(ISNULL(TMV.[VerificaQtdRegistro], 0) AS INT) AS [VerificaQtdRegistro]
	,CAST('Time de Vendas' AS VARCHAR(50)) AS [DetalhamentoMetricas]
	,CAST('Time de Vendas' AS VARCHAR(20)) AS [FonteDados]
	,CAST('Mobilize' AS VARCHAR(20)) AS [OrigemDados]
	,CAST(1 AS INT) AS [QtdChavesUnicas]
	,CAST(TMV.[ImagemValidacao] AS VARCHAR(200)) AS [ImagemValidacao]
	,CAST(TMV.[StatusValidacao] AS VARCHAR(20)) AS [StatusValidacao]
	,CAST(ISNULL(TMV.[DataFimEnvio], '1900-01-01') AS DATETIME) AS [DataFimEnvio]
	,CAST(GETDATE() AS DATETIME) AS [DataAtualizacaoPainel]
	,CAST(TMV.[DataAtualizacaoValidador] AS DATETIME) AS [DataAtualizacaoValidador]
FROM [Corporativo].[PowerBI].[HomologacaoTimeVendasDMSF] TMV
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AGE ON AGE.[CodigoAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = TMV.[CodigoAgencia]
LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AG2 ON AG2.[IDAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = AGE.[UnidadeSuperior__c]

--UNION ALL

--SELECT
--     CAST(ISNULL(AIC.[ChaveUnicaAIC], '-1') AS VARCHAR(200)) AS [ChaveUnica]
--    ,CAST(ISNULL(AIC.[CodigoAgencia], -1) AS INT) AS [CodigoAgencia]
--	,CAST(ISNULL(AG2.[CodigoAgencia], -1) AS INT) AS [CodigoUnidadeSuperior]
--    ,CAST(ISNULL(AIC.[Agencia], 'Não Informado') AS VARCHAR(100)) AS [Agencia]
--    ,CAST(ISNULL(AIC.[TipoUnidade], 'Não Informado') AS VARCHAR(20)) AS [TipoUnidade]
--    ,CAST(ISNULL(AIC.[Ano], -1) AS INT) AS [Ano]
--    ,CAST(ISNULL(AIC.[Mes], -1) AS INT) AS [Mes]
--    ,CAST(ISNULL(AIC.[DataReferencia], '1900-01-01') AS DATE) AS [DataReferencia]
--    ,CAST(ISNULL(AIC.[DataArquivo], '1900-01-01') AS DATE) AS [DataArquivo]
--    ,CAST(ISNULL(AIC.[QtdEmissoes_DM], 0) AS DECIMAL(18,2)) AS [Metrica1_DM]
--    ,CAST(ISNULL(AIC.[QtdEmissoes_SF], 0) AS DECIMAL(18,2)) AS [Metrica1_SF]
--    ,CAST(ISNULL(AIC.[VerificaQtdEmissoes], 0) AS INT) AS [VerificaMetrica1]
--    ,CAST(ISNULL(AIC.[QtdVendas_DM], 0) AS DECIMAL(18,2)) AS [Metrica2_DM]
--    ,CAST(ISNULL(AIC.[QtdVendas_SF], 0) AS DECIMAL(18,2)) AS [Metrica2_SF]
--    ,CAST(ISNULL(AIC.[VerificaQtdVendas], 0) AS INT) AS [VerificaMetrica2]
--	,CAST(ISNULL(AIC.[QtdRegistro_DM], 0) AS INT) AS [QtdRegistro_DM]
--	,CAST(ISNULL(AIC.[QtdRegistro_SF], 0) AS INT) AS [QtdRegistro_SF]
--	,CAST(ISNULL(AIC.[VerificaQtdRegistro], 0) AS INT) AS [VerificaQtdRegistro]
--	,CAST('AIC Sumarizado' AS VARCHAR(50)) AS [DetalhamentoMetricas]
--	,CAST('AIC Sumarizado' AS VARCHAR(20)) AS [FonteDados]
--	,CAST('Mobilize' AS VARCHAR(20)) AS [OrigemDados]
--	,CAST(1 AS INT) AS [QtdChavesUnicas]
--	,CAST(AIC.[ImagemValidacao] AS VARCHAR(200)) AS [ImagemValidacao]
--	,CAST(AIC.[StatusValidacao] AS VARCHAR(20)) AS [StatusValidacao]
--	,CAST(ISNULL(AIC.[DataFimEnvio], '1900-01-01') AS DATETIME) AS [DataFimEnvio]
--	,CAST(GETDATE() AS DATETIME) AS [DataAtualizacaoPainel]
--	,CAST(AIC.[DataAtualizacaoValidador] AS DATETIME) AS [DataAtualizacaoValidador]
--FROM [Corporativo].[PowerBI].[HomologacaoAICSumarizadoDMSF] AIC
--LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AGE ON AGE.[CodigoAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = AIC.[CodigoAgencia]
--LEFT JOIN [Stage_Salesforce].[dbo].[Account_Agencias_Hierarquia] AG2 ON AG2.[IDAgencia] COLLATE SQL_Latin1_General_CP1_CI_AS = AGE.[UnidadeSuperior__c]


