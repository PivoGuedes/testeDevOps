

CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_CoeficienteHabitacional] AS 

WITH CTE AS (

	SELECT  
		PRO.CodigoComercializado,
		--, COUNT(DISTINCT NumeroProposta) QtdContratos
		--, SUM(FE.PremioMip + FE.PremioDfi) Premio
        --, MIN(DATEDIFF(MM,PRP.DataProposta,FE.DataArquivo))--PRP.NumeroProposta, PRP.DataProposta, PRP.DataInicioVigencia, P.CodigoComercializado, FE.DataArquivo
        --CAST(CAST(YEAR(DATEADD(MM, 1, FEX.DataArquivo)) AS VARCHAR(4)) + RIGHT('00' + CAST(MONTH(DATEADD(MM, 1, FEX.DataArquivo)) AS VARCHAR(2)), 2) + '01' AS DATE) AS DataReferencia,
		LEFT(CONVERT(DATE, FEX.DataArquivo, 112), 7) AS DataReferencia,
		DATEDIFF(MM, PRP.DataProposta, FEX.DataArquivo) AS MesPagamento,
        CONVERT(DECIMAL(19,10), SUM(FEX.PremioMip + FEX.PremioDfi)) AS ValorPremio
        --, MAX(DATEDIFF(MM,PRP.DataProposta,FE.DataArquivo))
	FROM [Corporativo].[Dados].[FinanceiroExtrato] FEX
	INNER JOIN [Corporativo].[Dados].[Produto] PRO ON PRO.ID = FEX.IDProduto
	INNER JOIN [Corporativo].[Dados].[Proposta] PRP ON PRP.ID = FEX.IDProposta
	WHERE PRO.CodigoComercializado NOT LIKE '7%'
	AND PRO.CodigoComercializado NOT IN ('1408') 
	--AND FEX.DataArquivo = '20151130'
	--AND PRO.CodigoComercializado = '6116'
	GROUP BY PRO.CodigoComercializado, DATEDIFF(MM, PRP.DataProposta, FEX.DataArquivo), LEFT(Convert(DATE, FEX.DataArquivo, 112), 7)

), CTE_TOTAIS AS (

	SELECT 
		CTE.CodigoComercializado, 
		CTE.DataReferencia,
		CONVERT(DECIMAL(19,10), SUM(CTE.ValorPremio)) AS Premio
	FROM CTE
	GROUP BY CTE.CodigoComercializado, CTE.DataReferencia

), CTE_COEFICIENTE AS (

SELECT 
	CTE.CodigoComercializado,
	CAST(DATEADD(MM, 1, CTE.DataReferencia + '-01') AS DATE) AS DataReferencia,
    ISNULL(CASE WHEN CTE.MesPagamento = 1 THEN CAST('Pagamento Mensal' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 2 AND 3 THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 4 AND 6 THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 7 AND 12 THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 13 AND 24 THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 25 AND 36 THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 37 AND 48 THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 49 AND 60 THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 61 AND 72 THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 73 AND 84 THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 85 AND 96 THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 97 AND 108 THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 109 AND 120 THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento > 120  THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
		 ELSE 'Não Informado'
	END, 'Não Informado') DescricaoTipoPagamento,
    SUM(CTE.ValorPremio) AS Premio,
	CONVERT(DECIMAL(19,10), (CONVERT(DECIMAL(19,10), SUM(CTE.ValorPremio)) / CONVERT(DECIMAL(19,10), IIF(CTT.Premio = 0 , 1, CTT.Premio)))) AS Coeficiente
FROM CTE
INNER JOIN CTE_TOTAIS CTT ON CTT.CodigoComercializado = CTE.CodigoComercializado AND CTT.DataReferencia = CTE.DataReferencia
--WHERE CTE.DataReferencia = '2015-11-01'
--AND CTE.CodigoComercializado = '6116'
GROUP BY CTE.CodigoComercializado, CTE.DataReferencia,
     ISNULL(CASE WHEN CTE.MesPagamento = 1 THEN CAST('Pagamento Mensal' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 2 AND 3 THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 4 AND 6 THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 7 AND 12 THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 13 AND 24 THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 25 AND 36 THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 37 AND 48 THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 49 AND 60 THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 61 AND 72 THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 73 AND 84 THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 85 AND 96 THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 97 AND 108 THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento BETWEEN 109 AND 120 THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
         WHEN CTE.MesPagamento > 120  THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
		 ELSE 'Não Informado'
	END, 'Não Informado'),
    CTT.Premio
HAVING SUM(CTE.ValorPremio) <> 0

)

SELECT
	COE.CodigoComercializado,
	COE.DataReferencia,
    COE.DescricaoTipoPagamento,
    COE.Premio,
	COE.Coeficiente,
	CASE WHEN COE.DescricaoTipoPagamento = 'Não Informado' THEN 'Não Informado'
		 WHEN COE.DescricaoTipoPagamento = 'Pagamento Mensal' THEN 'Venda Nova'
		 ELSE 'Estoque'
	END AS DescricaoVendaNova
FROM CTE_COEFICIENTE COE