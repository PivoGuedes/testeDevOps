


CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_AutoCaixaSeguros] AS 

WITH CTE AS ( --CARGA DOS PRODUTOS DA CORRETORA DE AUTO CAIXA SEGUROS PARA A FATO VENDA NOVA/ESTOQUE

	SELECT --TOP 1000
		PRD.CodigoComercializado, 
		COM.IDContrato, 
		PRP.ID AS IDProposta, 
		PRP.NumeroProposta,
		CNT.NumeroContrato, 
		COM.NumeroEndosso, 
		PRT.Codigo AS CodigoProdutor,
		COP.Codigo AS CodigoOperacao, 
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
	INNER JOIN [Corporativo].[Dados].[Proposta] PRP ON COM.IDProposta = PRP.ID
	INNER JOIN [Corporativo].[Dados].[Produto] PRD ON COM.IDProduto = PRD.ID
	INNER JOIN [Corporativo].[Dados].[Produtor] PRT ON COM.IDProdutor = PRT.ID
	INNER JOIN [Corporativo].[Dados].[Contrato] CNT ON COM.IDContrato = CNT.ID 
	INNER JOIN [Corporativo].[Dados].[ComissaoOperacao] COP ON COP.ID = COM.IDOperacao
	INNER JOIN [Corporativo].[Dados].[ProdutoClassificacaoBloco] PCB ON PCB.IDEmpresa = COM.IDEmpresa AND PCB.CodigoClassificacaoVendaNova COLLATE DATABASE_DEFAULT = PRD.CodigoComercializado AND PCB.DescricaoClassificacaoVendaNova = 'Auto Caixa Seguros' 
	LEFT JOIN [Corporativo].[ControleDados].[ExportacaoFaturamento] EXF ON EXF.IDEmpresa = COM.IDEmpresa AND EXF.NumeroRecibo = COM.NumeroRecibo AND EXF.DataCompetencia = COM.DataCompetencia AND EXF.DataRecibo = COM.DataRecibo
	LEFT JOIN (SELECT EDS.IDContrato, EDS.NumeroEndosso, EDS.IDProposta, EDS.QuantidadeParcelas 
			   FROM [Corporativo].[Dados].[Endosso] EDS) EDS ON EDS.IDContrato = CNT.ID AND EDS.NumeroEndosso = COM.NumeroEndosso AND EDS.IDProposta = PRP.ID
	WHERE COM.IDEmpresa = 3
	--AND PRD.CodigoComercializado IN ('3104', '3107', '3120', '3133', '3136', '3138', '3142', '3143', '3144', '3145', '3146', '3147', '3148', '3149', '3172', '3173', '3174', '3175', '3176', '3177', '3178', '3179', '3180', '3181', '3183', '5302', '5303', '5304')
	/*AND COM.DataCompetencia BETWEEN '2015-01-01' AND CAST(GETDATE() AS DATE)*/
	--AND CNT.NumeroContrato = '1103100449884'
	--AND COM.IDContrato = 21382977
	--AND COM.IDContrato = 20007091
	--AND EXISTS (SELECT * FROM [Corporativo].[Dados].[PropostaAutomovel] PRA WHERE PRA.IDProposta = PRP.ID)
	GROUP BY PRD.CodigoComercializado, COM.IDContrato, PRP.ID, PRP.NumeroProposta, CNT.NumeroContrato, COM.NumeroEndosso, PRT.Codigo, COP.Codigo, COP.SinalOperacao, COM.DataRecibo, COM.NumeroParcela, EDS.QuantidadeParcelas, EXF.Autorizado, EXF.Processado, COM.NumeroRecibo, COM.DataCompetencia, PCB.DescricaoClassificacaoVendaNova

), PAC AS (

	SELECT 
		PAT.IDProposta, 
		PAT.QuantidadeParcelas, 
		(ROW_NUMBER() OVER(PARTITION BY PAT.IDProposta ORDER BY PAT.DataInicioVigencia ASC) - 1) AS N
	FROM [Corporativo].[Dados].[PropostaAutomovel] PAT
	--WHERE PAT.IDProposta = 56935608
	LEFT JOIN CTE ON CTE.IDProposta = PAT.IDProposta

), CTE_AUTOCS_ORIGEM AS (

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
		ISNULL(CASE WHEN CTE.QuantidadeParcelas IS NULL THEN PAC.QuantidadeParcelas 
					ELSE CTE.QuantidadeParcelas 
			   END, 0) AS QuantidadeParcelas,
		CTE.Autorizado, 
		CTE.Processado,
		CTE.NumeroRecibo,
		CTE.DataCompetencia,
		CTE.ClassificacaoProduto
	FROM CTE
	LEFT JOIN PAC ON PAC.IDProposta = CTE.IDProposta AND PAC.N = CTE.NumeroEndosso

), CTE_VENDANOVA AS (

SELECT --TOP 10 
	CAC.IDContrato, --Somente Corretora
	CAC.IDProposta, 
	CAC.CodigoEmpresa,
	CAC.CodigoProduto, 
	CAC.NumeroProposta,
	CAC.NumeroApolice, 
	CAC.NumeroEndosso, 
	CAC.CodigoProdutor,
	CAC.CodigoOperacao, 
	CAC.SinalOperacao, 
	ISNULL(CASE WHEN CAC.NumeroParcela BETWEEN 0 AND 1 AND CAC.QuantidadeParcelas BETWEEN 0 AND 1 THEN CAST('Pagamento Único' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 0 AND 1 AND CAC.QuantidadeParcelas > 1 THEN CAST('Pagamento Mensal' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 2 AND 3 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 4 AND 6 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 7 AND 12 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 13 AND 24 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 25 AND 36 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 37 AND 48 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 49 AND 60 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 61 AND 72 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 73 AND 84 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 85 AND 96 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 97 AND 108 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela BETWEEN 109 AND 120 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
				WHEN CAC.NumeroParcela > 120 AND ((CAC.QuantidadeParcelas > 1) OR (CAC.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
				ELSE CAST('Não Informado' AS VARCHAR(50))
			END, 'Não Informado') AS TipoPagamento,
	ISNULL((CAC.PremioLiquido * 2), 0) AS PremioLiquido, 
	ISNULL(CAC.ValorComissao, 0) AS ValorComissao, 
	CAC.DataRecibo, 
	CAC.NumeroParcela, 
	CAC.QuantidadeParcelas,
	ISNULL(CAC.Autorizado, 0) AS Autorizado, 
	ISNULL(CAC.Processado, 0) AS Processado,
	CAC.NumeroRecibo,
	CAC.DataCompetencia,
	CAC.ClassificacaoProduto
FROM CTE_AUTOCS_ORIGEM CAC

)

SELECT
	CVN.IDContrato, --Somente Corretora
	CVN.IDProposta, 
	CVN.CodigoEmpresa,
	CVN.CodigoProduto,
	CVN.NumeroProposta, 
	CVN.NumeroApolice, 
	CVN.NumeroEndosso, 
	CVN.CodigoProdutor,
	CVN.CodigoOperacao, 
	CVN.SinalOperacao, 
	CASE WHEN ((CVN.PremioLiquido >= 0 AND CVN.ValorComissao >= 0) OR (CVN.PremioLiquido >= 0 OR CVN.ValorComissao >= 0)) AND CVN.TipoPagamento IN ('Pagamento Único', 'Pagamento Mensal') THEN CAST('Venda Nova' AS VARCHAR(20))
		 WHEN ((CVN.PremioLiquido >= 0 AND CVN.ValorComissao >= 0) OR (CVN.PremioLiquido >= 0 OR CVN.ValorComissao >= 0)) AND CVN.TipoPagamento NOT IN ('Pagamento Único', 'Pagamento Mensal', 'Não Informado') THEN CAST('Estoque' AS VARCHAR(20))
		 WHEN ((CVN.PremioLiquido < 0 AND CVN.ValorComissao < 0) OR (CVN.PremioLiquido < 0 OR CVN.ValorComissao < 0)) THEN CAST('Devolução' AS VARCHAR(20))
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
	CVN.DataCompetencia,
	CVN.ClassificacaoProduto
FROM CTE_VENDANOVA CVN





