

CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_Saude] AS 

WITH CTE_DATA AS (
	
	SELECT
		 CONVERT(VARCHAR(10), DIC.[DataInicioCarga], 112) AS [DataInicioCarga]
		,CONVERT(VARCHAR(10), DIC.[DataFimCarga], 112) AS [DataFimCarga]
	FROM [Corporativo].[VendaNova].[DefinicaoDataInicioFimCarga] DIC

), CTE_VENDANOVA AS (

	SELECT
		0 AS IDContrato,
		0 AS IDProposta,
		3 AS CodigoEmpresa,	--'PAR Saúde'
		ISNULL(CAST(CASE WHEN LEN(LTRIM(RTRIM(Z06.Z06_CDPROD))) = 0 THEN '-1' ELSE LTRIM(RTRIM(Z06.Z06_CDPROD)) END AS VARCHAR(10)), '-1') AS CodigoProduto,
		ISNULL(CAST(CASE WHEN LEN(LTRIM(RTRIM(Z06.Z06_NMPROD))) = 0 THEN 'Não Informado' ELSE LTRIM(RTRIM(Z06.Z06_NMPROD)) END AS VARCHAR(100)), 'Não Informado') AS NomeProduto,
		ISNULL(Z06.Z06_CODIGO, 0) AS NumeroApolice,
		CASE WHEN LEN(LTRIM(RTRIM(Z06.Z06_ENDOSS))) = 0 THEN 0 ELSE LTRIM(RTRIM(Z06.Z06_ENDOSS)) END AS NumeroEndosso,
		1 AS CodigoProdutor,
		1 AS CodigoOperacao,
		1 AS SinalOperacao,
		ISNULL(CASE WHEN /*ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) = 0 AND*/ LTRIM(RTRIM(Z06.Z06_TPCOMI)) = 'A' THEN CAST('Pagamento Único' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 0 AND 1 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Pagamento Mensal' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 2 AND 3 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 4 AND 6 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 7 AND 12 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 13 AND 24 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 25 AND 36 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 37 AND 48 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 49 AND 60 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 61 AND 72 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 73 AND 84 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 85 AND 96 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 97 AND 108 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) BETWEEN 109 AND 120 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
					WHEN ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) > 120 AND LTRIM(RTRIM(Z06.Z06_TPCOMI)) <> 'A' THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
				ELSE CAST('Não Informado' AS VARCHAR(50))
			END, 'Não Informado') AS TipoPagamento,
		ISNULL(Z06.Z06_VLPREM, 0) AS PremioLiquido,
		ISNULL(Z06.Z06_VLCOMI, 0) AS ValorComissao,
		CAST(Z06.Z06_DTRECI AS DATE) AS DataRecibo,
		ISNULL(CAST(Z06.Z06_PARCEL AS INT), 0) AS NumeroParcela,
		0 AS QuantidadeParcelas,
		0 AS NumeroProposta,
		1 AS Autorizado,
		1 AS Processado,
		0 AS NumeroRecibo,
		CAST(Z06.Z06_DTRECI AS DATE) AS DataCompetencia	
	FROM [SCASE].[RBDF27].[dbo].[Z06020] Z06	
	INNER JOIN CTE_DATA DIC ON Z06.Z06_DTRECI BETWEEN DIC.[DataInicioCarga] AND DIC.[DataFimCarga]
	WHERE Z06.D_E_L_E_T_ = '' 
	/* AND Z06.Z06_DTRECI BETWEEN '20150101' AND CONVERT(VARCHAR(10), CAST(GETDATE() AS DATE), 112) */

)

SELECT
	CVN.IDContrato, --Somente Corretora
	CVN.IDProposta, 
	CVN.CodigoEmpresa,
	CVN.CodigoProduto,
	CVN.NomeProduto,
	CVN.NumeroProposta, 
	CVN.NumeroApolice, 
	CVN.NumeroEndosso, 
	CVN.CodigoProdutor,
	CVN.CodigoOperacao, 
	CVN.SinalOperacao, 
	CASE WHEN ((CVN.PremioLiquido >= 0 AND CVN.ValorComissao >= 0) OR (CVN.PremioLiquido >= 0 OR CVN.ValorComissao >= 0)) AND CVN.TipoPagamento IN ('Pagamento Único', 'Pagamento Mensal') THEN CAST('Venda Nova' AS VARCHAR(20))
		 WHEN ((CVN.PremioLiquido >= 0 AND CVN.ValorComissao >= 0) OR (CVN.PremioLiquido >= 0 OR CVN.ValorComissao >= 0)) AND CVN.TipoPagamento NOT IN ('Pagamento Único', 'Pagamento Mensal', 'Não Informado') THEN CAST('Estoque' AS VARCHAR(20))
		 WHEN ((CVN.PremioLiquido < 0 AND CVN.ValorComissao < 0) OR (CVN.PremioLiquido < 0 OR CVN.ValorComissao < 0) OR (CVN.PremioLiquido >= 0 AND CVN.ValorComissao < 0)) THEN CAST('Devolução' AS VARCHAR(20))
		 ELSE CAST('Não Informado' AS VARCHAR(20))
	END AS DescricaoVendaNova,
	CVN.TipoPagamento,
	CVN.PremioLiquido, 
	CVN.ValorComissao,
	CVN.DataRecibo, 
	CVN.NumeroParcela, 
	CVN.QuantidadeParcelas,
	CVN.Autorizado,
	CVN.Processado,
	CVN.NumeroRecibo,
	CVN.DataCompetencia
FROM CTE_VENDANOVA CVN

