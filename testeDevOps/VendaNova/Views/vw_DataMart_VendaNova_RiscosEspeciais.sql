CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_RiscosEspeciais] AS 

WITH CTE_DATA AS (
	
	SELECT
		 CONVERT(VARCHAR(10), DIC.[DataInicioCarga], 112) AS [DataInicioCarga]
		,CONVERT(VARCHAR(10), DIC.[DataFimCarga], 112) AS [DataFimCarga]
	FROM [Corporativo].[VendaNova].[DefinicaoDataInicioFimCarga] DIC

), CTE_VENDANOVA AS (

	SELECT
		0 AS IDContrato,
		0 AS IDProposta,
		2 AS CodigoEmpresa,	--'PAR Riscos Especiais'
		ISNULL(CAST(CASE WHEN LEN(LTRIM(RTRIM(Z14.Z14_CDPROD))) = 0 THEN '-1' ELSE LTRIM(RTRIM(Z14.Z14_CDPROD)) END AS VARCHAR(10)), '-1') AS CodigoProduto,
		ISNULL(CAST(CASE WHEN LEN(LTRIM(RTRIM(Z14.Z14_NMPROD))) = 0 THEN 'Não Informado' ELSE LTRIM(RTRIM(Z14.Z14_NMPROD)) END AS VARCHAR(100)), 'Não Informado') AS NomeProduto,
		ISNULL(Z14.Z14_APOLIC, 0) AS NumeroApolice,
		CAST(ISNULL(Z14.Z14_ENDOSS, 0) AS VARCHAR(20)) AS NumeroEndosso,
		1 AS CodigoProdutor,
		1 AS CodigoOperacao,
		1 AS SinalOperacao,
		ISNULL(CASE WHEN Z14.Z14_NRPARC BETWEEN 0 AND 1 AND Z14.Z14_QTPARC BETWEEN 0 AND 1 THEN CAST('Pagamento Único' AS VARCHAR(50))
					WHEN (Z14.Z14_NRPARC = 1 OR Z14.Z14_NRPARC BETWEEN 0 AND 1) AND Z14.Z14_QTPARC > 1 THEN CAST('Pagamento Mensal' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 2 AND 3 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 4 AND 6 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 7 AND 12 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 13 AND 24 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 25 AND 36 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 37 AND 48 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 49 AND 60 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 61 AND 72 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 73 AND 84 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 85 AND 96 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 97 AND 108 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC BETWEEN 109 AND 120 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
					WHEN Z14.Z14_NRPARC > 120 AND ((Z14.Z14_QTPARC > 1) OR (Z14.Z14_QTPARC BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
				ELSE CAST('Não Informado' AS VARCHAR(50))
			END, 'Não Informado') AS TipoPagamento,
		ISNULL(Z14.Z14_PREMIO, 0) AS PremioLiquido,
		ISNULL(Z14.Z14_VLCOMI, 0) AS ValorComissao,
		CAST(Z14.Z14_DTRECI AS DATE) AS DataRecibo,
		ISNULL(Z14.Z14_NRPARC, 0) AS NumeroParcela,
		ISNULL(Z14.Z14_QTPARC, 0) AS QuantidadeParcelas,
		0 AS NumeroProposta,
		1 AS Autorizado,
		1 AS Processado,
		ISNULL(Z14.Z14_RECIBO, 0) AS NumeroRecibo,
		CAST(Z14.Z14_DTRECI AS DATE) AS DataCompetencia
	FROM [SCASE].[RBDF27].[dbo].[Z14060] Z14 --RISCOS ESPECIAIS
	INNER JOIN CTE_DATA DIC ON Z14.Z14_DTRECI BETWEEN DIC.[DataInicioCarga] AND DIC.[DataFimCarga]
	WHERE Z14.D_E_L_E_T_ = '' --and Z14.Z14_CDPROD = '334'
	/* AND Z14.Z14_DTRECI BETWEEN '20150101' AND CONVERT(VARCHAR(10), CAST(GETDATE() AS DATE), 112) */

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



