





CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_Prestamista] AS 

WITH CTE AS ( --CARGA DOS PRODUTOS DA CORRETORA DE PRESTAMISTA PARA A FATO VENDA NOVA/ESTOQUE

	SELECT --TOP 1000
		PRD.CodigoComercializado, 
		COM.IDContrato, 
		PRP.ID AS IDProposta, 
		PRP.NumeroProposta,
		CNT.NumeroContrato, 
		COM.NumeroEndosso, 
		PRT.Codigo AS CodigoProdutor,
		COP.Codigo AS COdigoOperacao, 
		COP.SinalOperacao, 
		SUM(COM.ValorBase) AS PremioLiquido, 
		SUM(COM.ValorComissaoPAR) AS ValorComissao, 
		COM.DataRecibo, 
		COM.NumeroParcela, 
		EDS.QuantidadeParcelas, 
		EXF.Autorizado, 
		EXF.Processado,
		COM.NumeroRecibo,
		COM.DataCompetencia,
		PCB.DescricaoClassificacaoVendaNova AS ClassificacaoProduto,
		--PA.N, 
		ROW_NUMBER() OVER(PARTITION BY CNT.NumeroContrato, COM.NumeroEndosso, COM.NumeroParcela ORDER BY CNT.NumeroContrato, COM.NumeroEndosso, COM.NumeroParcela) AS NN
	FROM [Corporativo].[Dados].[Comissao] COM
	INNER JOIN [Corporativo].[VendaNova].[DefinicaoDataInicioFimCarga] DIC ON COM.DataCompetencia BETWEEN DIC.[DataInicioCarga] AND DIC.[DataFimCarga]
	INNER JOIN [Corporativo].[Dados].[Produto] PRD ON COM.IDProduto = PRD.ID
	INNER JOIN [Corporativo].[Dados].[Produtor] PRT ON COM.IDProdutor = PRT.ID
	INNER JOIN [Corporativo].[Dados].[ComissaoOperacao] COP ON COP.ID = COM.IDOperacao
	INNER JOIN [Corporativo].[Dados].[ProdutoClassificacaoBloco] PCB ON PCB.IDEmpresa = COM.IDEmpresa AND PCB.CodigoClassificacaoVendaNova COLLATE DATABASE_DEFAULT = PRD.CodigoComercializado AND PCB.DescricaoClassificacaoVendaNova = 'Prestamista'
	LEFT JOIN [Corporativo].[Dados].[Proposta] PRP ON COM.IDProposta = PRP.ID
	LEFT JOIN [Corporativo].[Dados].[Contrato] CNT ON COM.IDContrato = CNT.ID 
	LEFT JOIN [Corporativo].[ControleDados].[ExportacaoFaturamento] EXF ON EXF.IDEmpresa = COM.IDEmpresa AND EXF.NumeroRecibo = COM.NumeroRecibo AND EXF.DataCompetencia = COM.DataCompetencia AND EXF.DataRecibo = COM.DataRecibo
	LEFT JOIN (SELECT EDS.IDContrato, EDS.NumeroEndosso, EDS.IDProposta, EDS.QuantidadeParcelas 
			   FROM [Corporativo].[Dados].[Endosso] EDS) EDS ON EDS.IDContrato = CNT.ID AND EDS.NumeroEndosso = COM.NumeroEndosso AND EDS.IDProposta = PRP.ID
	WHERE COM.IDEmpresa = 3
	--AND RIGHT('0000' + LTRIM(RTRIM(PRD.CodigoComercializado)), 4) IN ('0077', '7525', '7701', '7704', '7705', '7706', '7707', '7709', '7710', '7711', '7712', '7713', '7714', '7715', '7716',  '7725', '9301', '9306', '9995') --PRESTAMISTA
	/* AND COM.DataCompetencia BETWEEN '2015-01-01' AND CAST(GETDATE() AS DATE) */
	--AND CNT.NumeroContrato = '107700000011'
	--AND COM.IDContrato = 21382977
	--AND COM.IDContrato = 20007091
	--AND EXISTS (SELECT * FROM [Corporativo].[Dados].[PropostaResidencial] PRE WHERE PRE.IDProposta = PRP.ID)
	GROUP BY PRD.CodigoComercializado, COM.IDContrato, PRP.ID, PRP.NumeroProposta, CNT.NumeroContrato, COM.NumeroEndosso, PRT.Codigo, COP.Codigo, COP.SinalOperacao, COM.DataRecibo, COM.NumeroParcela, EDS.QuantidadeParcelas, EXF.Autorizado, EXF.Processado, COM.NumeroRecibo, COM.DataCompetencia, PCB.DescricaoClassificacaoVendaNova

--), PAC AS (

--	SELECT 
--		PAR.IDProposta, 
--		PAR.QuantidadeParcelas, 
--		(ROW_NUMBER() OVER(PARTITION BY PAR.IDProposta ORDER BY PAR.DataArquivo ASC) - 1) AS N
--    FROM [Corporativo].[Dados].[PropostaResidencial] PAR
--    LEFT JOIN CTE ON CTE.IDProposta = PAR.IDProposta
--	--WHERE PAR.IDProposta = 56935608

), CTE_PRESTAMISTA_ORIGEM AS (

	SELECT 
		CAST(1 AS INT) AS CodigoEmpresa,
		CTE.CodigoComercializado AS CodigoProduto, 
		CTE.IDContrato, 
		CTE.IDProposta,
		CTE.NumeroProposta,
		CTE.NumeroContrato AS NumeroApolice, 
		CTE.NumeroEndosso, 
		CTE.CodigoProdutor,
		CTE.CodigoOperacao, 
		CTE.SinalOperacao,
		ISNULL(CTE.PremioLiquido, 0) AS PremioLiquido,
		ISNULL(CTE.ValorComissao, 0) AS ValorComissao,
		CTE.DataRecibo, 
		ISNULL(CTE.NumeroParcela, 0) AS NumeroParcela,
		CTE.NN,
		--CTE.QuantidadeParcelas, 
		ISNULL(CASE WHEN CTE.QuantidadeParcelas IS NULL THEN 0 --PAC.QuantidadeParcelas 
					ELSE CTE.QuantidadeParcelas 
			   END, 0) AS QuantidadeParcelas,
		CTE.Autorizado, 
		CTE.Processado,
		CTE.NumeroRecibo,
		CTE.DataCompetencia,
		CTE.ClassificacaoProduto
	FROM CTE
	--LEFT JOIN PAC ON PAC.IDProposta = CTE.IDProposta AND PAC.N = CTE.NumeroEndosso

)

SELECT --TOP 10 
	CPR.IDContrato, --Somente Corretora
	CPR.IDProposta, 
	CPR.CodigoEmpresa,
	CPR.CodigoProduto,
	CPR.NumeroProposta, 
	CPR.NumeroApolice, 
	CPR.NumeroEndosso, 
	CPR.CodigoProdutor,
	CPR.CodigoOperacao, 
	CPR.SinalOperacao, 
	ISNULL(CASE WHEN ((CPR.PremioLiquido > 0 AND CPR.ValorComissao > 0) OR (CPR.PremioLiquido > 0 OR CPR.ValorComissao > 0)) THEN CAST('Venda Nova' AS VARCHAR(20))
		 WHEN ((CPR.PremioLiquido < 0 AND CPR.ValorComissao < 0) OR (CPR.PremioLiquido < 0 OR CPR.ValorComissao < 0)) THEN CAST('Devolução' AS VARCHAR(20))
		 ELSE CAST('Não Informado' AS VARCHAR(20))
	END, 'Não Informado') AS DescricaoVendaNova,
	ISNULL(CASE WHEN ((CPR.PremioLiquido > 0 AND CPR.ValorComissao > 0) OR (CPR.PremioLiquido > 0 OR CPR.ValorComissao > 0)) THEN CAST('Pagamento Único' AS VARCHAR(50))
		 WHEN ((CPR.PremioLiquido < 0 AND CPR.ValorComissao < 0) OR (CPR.PremioLiquido < 0 OR CPR.ValorComissao < 0)) THEN CAST('Pagamento Único' AS VARCHAR(50))
		 ELSE CAST('Não Informado' AS VARCHAR(50))
	END, 'Não Informado') AS TipoPagamento,
	ISNULL(CPR.PremioLiquido, 0) AS PremioLiquido,
	ISNULL(CPR.ValorComissao, 0) AS ValorComissao,
	CPR.DataRecibo, 
	CPR.NumeroParcela, 
	CPR.QuantidadeParcelas,
	ISNULL(CPR.Autorizado, 0) AS Autorizado,
	ISNULL(CPR.Processado, 0) AS Processado,
	CPR.NumeroRecibo,
	CPR.DataCompetencia,
	CPR.ClassificacaoProduto
FROM CTE_PRESTAMISTA_ORIGEM CPR
--WHERE CPR.NumeroApolice = '107700000011'
--ORDER BY NumeroApolice, NumeroParcela





