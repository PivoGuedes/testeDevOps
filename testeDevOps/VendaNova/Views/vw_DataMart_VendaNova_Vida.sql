





CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_Vida] AS 

WITH CTE AS ( --CARGA DOS PRODUTOS DA CORRETORA DE VIDA PARA A FATO VENDA NOVA/ESTOQUE

	SELECT
		PRD.CodigoComercializado, 
		COM.IDContrato, 
		PRP.ID AS IDProposta, 
		PRP.NumeroProposta,
		CNT.NumeroContrato, 
		COM.NumeroEndosso, 
		COM.IDOperacao,
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
	INNER JOIN [Corporativo].[Dados].[Produto] PRD ON COM.IDProduto = PRD.ID
	INNER JOIN [Corporativo].[Dados].[ComissaoOperacao] COP ON COP.ID = COM.IDOperacao
	INNER JOIN [Corporativo].[Dados].[Produtor] PRT ON COM.IDProdutor = PRT.ID
	INNER JOIN [Corporativo].[Dados].[ProdutoClassificacaoBloco] PCB ON PCB.IDEmpresa = COM.IDEmpresa AND PCB.CodigoClassificacaoVendaNova COLLATE DATABASE_DEFAULT = PRD.CodigoComercializado AND PCB.DescricaoClassificacaoVendaNova = 'Vida'
	LEFT JOIN [Corporativo].[Dados].[Proposta] PRP ON COM.IDProposta = PRP.ID
	LEFT JOIN [Corporativo].[Dados].[Contrato] CNT ON COM.IDContrato = CNT.ID 
	LEFT JOIN [Corporativo].[ControleDados].[ExportacaoFaturamento] EXF ON EXF.IDEmpresa = COM.IDEmpresa AND EXF.NumeroRecibo = COM.NumeroRecibo AND EXF.DataCompetencia = COM.DataCompetencia AND EXF.DataRecibo = COM.DataRecibo
	LEFT JOIN (SELECT EDS.IDContrato, EDS.NumeroEndosso, EDS.IDProposta, EDS.QuantidadeParcelas 
			   FROM [Corporativo].[Dados].[Endosso] EDS) EDS ON EDS.IDContrato = CNT.ID AND EDS.NumeroEndosso = COM.NumeroEndosso AND EDS.IDProposta = PRP.ID
	WHERE COM.IDEmpresa = 3
	AND PRD.CodigoComercializado NOT IN ('3701', '8105') --VIDA
	--AND PRD.CodigoComercializado IN ('3704', '3705', '3709', '3710', '6901', '6902', '6903', '6904', '6905', '6906', '6907', '6908', '8101', '8103', '8104', '8108', '8112', '8113', '8114',
	--								 '8115', '8116', '8117', '8118', '8119', '8120', '8121', '8122', '8123', '8124', '8125', '8126', '8129', '8132', '8138', '8184', '8191', '8199', '8201', '8202',
	--								 '8203', '8205', '8206', '8207', '8209', '8214', '8215', '8217', '8219', '8220', '8222', '8223', '8227', '9304', '9305', '9308', '9309', '9310', '9311', '9312',
	--								 '9313', '9314', '9318', '9319', '9320', '9321', '9322', '9323', '9324', '9325', '9326', '9327', '9328', '9329', '9330', '9332', '9333', '9334', '9337', '9343',
	--								 '9351', '9352', '9353', '9354', '9355', '9356', '9357', '9358', '9359', '9360', '9361', '9363', '9399', '9701', '9702', '9703', '9704', '9705', '9706', '9707', 
	--								 '9708', '9709', '9710', '9711', '9712', '9713', '9714', '9715', '9799', '9996', '9998') --VIDA 
	/* AND COM.DataCompetencia BETWEEN '2015-01-01' AND CAST(GETDATE() AS DATE) */
	GROUP BY PRD.CodigoComercializado, COM.IDContrato, PRP.ID, PRP.NumeroProposta, CNT.NumeroContrato, COM.NumeroEndosso, COM.IDOperacao, PRT.Codigo, COP.Codigo, COP.SinalOperacao, COM.DataRecibo, COM.NumeroParcela, EDS.QuantidadeParcelas, EXF.Autorizado, EXF.Processado, COM.NumeroRecibo, COM.DataCompetencia, PCB.DescricaoClassificacaoVendaNova

	UNION ALL

	SELECT
		PRD.CodigoComercializado, 
		COM.IDContrato, 
		PRP.ID AS IDProposta, 
		PRP.NumeroProposta,
		CNT.NumeroContrato, 
		COM.NumeroEndosso, 
		COM.IDOperacao,
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
	INNER JOIN [Corporativo].[Dados].[Produto] PRD ON COM.IDProduto = PRD.ID
	INNER JOIN [Corporativo].[Dados].[Contrato] CNT ON COM.IDContrato = CNT.ID 
	INNER JOIN [Corporativo].[Dados].[ComissaoOperacao] COP ON COP.ID = COM.IDOperacao
	INNER JOIN [Corporativo].[Dados].[Produtor] PRT ON COM.IDProdutor = PRT.ID
	INNER JOIN [Corporativo].[Dados].[ProdutoClassificacaoBloco] PCB ON PCB.IDEmpresa = COM.IDEmpresa AND PCB.CodigoClassificacaoVendaNova COLLATE DATABASE_DEFAULT = PRD.CodigoComercializado AND PCB.DescricaoClassificacaoVendaNova = 'Vida'
	LEFT JOIN [Corporativo].[Dados].[Proposta] PRP ON COM.IDProposta = PRP.ID
	LEFT JOIN [Corporativo].[ControleDados].[ExportacaoFaturamento] EXF ON EXF.IDEmpresa = COM.IDEmpresa AND EXF.NumeroRecibo = COM.NumeroRecibo AND EXF.DataCompetencia = COM.DataCompetencia AND EXF.DataRecibo = COM.DataRecibo
	LEFT JOIN (SELECT EDS.IDContrato, EDS.NumeroEndosso, EDS.IDProposta, EDS.QuantidadeParcelas 
			   FROM [Corporativo].[Dados].[Endosso] EDS) EDS ON EDS.IDContrato = CNT.ID AND EDS.NumeroEndosso = COM.NumeroEndosso AND EDS.IDProposta = PRP.ID
	WHERE COM.IDEmpresa = 3
	AND PRD.CodigoComercializado IN ('3701', '8105') --VIDA
	/* AND COM.DataCompetencia BETWEEN '2015-01-01' AND CAST(GETDATE() AS DATE) */
	AND (PRT.Codigo = '17256' OR COM.IDOperacao = 7) -- PRODUTOR FPC OU AJUSTE MANUAL
	GROUP BY PRD.CodigoComercializado, COM.IDContrato, PRP.ID, PRP.NumeroProposta, CNT.NumeroContrato, COM.NumeroEndosso, COM.IDOperacao, PRT.Codigo, COP.Codigo, COP.SinalOperacao, COM.DataRecibo, COM.NumeroParcela, EDS.QuantidadeParcelas, EXF.Autorizado, EXF.Processado, COM.NumeroRecibo, COM.DataCompetencia, PCB.DescricaoClassificacaoVendaNova

), CTE_VIDA_ORIGEM AS (

	SELECT 
		CAST(1 AS INT) AS CodigoEmpresa,
		CTE.CodigoComercializado AS CodigoProduto, 
		CTE.IDContrato, 
		CTE.IDProposta,
		CTE.NumeroProposta,
		CTE.NumeroContrato AS NumeroApolice, 
		ISNULL(CTE.NumeroEndosso, 0) AS NumeroEndosso,
		CTE.CodigoProdutor,
		CTE.IDOperacao,
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

), CTE_VENDANOVA AS (

SELECT
	CVI.IDContrato, --Somente Corretora
	CVI.IDProposta, 
	CVI.CodigoEmpresa,
	CVI.CodigoProduto,
	CVI.NumeroProposta, 
	CVI.NumeroApolice, 
	CVI.NumeroEndosso, 
	CVI.CodigoProdutor,
	--CVI.IDOperacao,
	CVI.CodigoOperacao, 
	CVI.SinalOperacao, 
	--Regras de Ajuste da Classificação de Venda Nova e Estoque
	ISNULL(CASE WHEN (CVI.NumeroParcela = 1 AND CVI.NumeroEndosso = 0) THEN 'Pagamento Mensal'	--'Parcela 1 de pagamento mensal'       --WHEN CVI.NumeroEndosso < 2000 AND CVI.NumeroParcela  = 0 THEN 'Fluxo'     
				WHEN (CVI.NumeroParcela = 1 AND CVI.NumeroEndosso > 2000) THEN 'Pagamento Mensal'	--'Parcela 1 de pagamento mensal'  
	 			WHEN (CVI.NumeroParcela = 0 AND CVI.NumeroEndosso IN (0, 1)) THEN	'Pagamento Único'	--'Primeira parcela de pagamento único'  
				WHEN (CVI.NumeroEndosso = 1 AND CVI.NumeroParcela IN (0)) THEN 'Pagamento Único'	--'Parcela 1 de bilhete' --Venda Nova
				WHEN (CVI.NumeroParcela = 0 AND CVI.NumeroEndosso > 2000) THEN 'Pagamento Único'
				WHEN (CVI.NumeroEndosso = 1 AND CVI.NumeroParcela IN (1)) THEN 'Pagamento Mensal'	--'Segundo pagamento de pagamento único '--CAST(0 AS BIT) - Fluxo        
				--WHEN (CVI.NumeroParcela = 0 AND CVI.NumeroEndosso > 2000) THEN 'Devolução'  
				--WHEN (CVI.NumeroParcela = 0 AND CVI.NumeroEndosso < 2000) THEN 'Devolução'
				--WHEN (CVI.NumeroParcela > 1 AND CVI.NumeroEndosso > 2000) THEN 'Devolução'
				
				WHEN (CVI.NumeroEndosso > 1 AND CVI.NumeroEndosso < 2000) THEN  -- aplicar case de range de parcela (demais parcelas de bilhete)
					--Regra do Estoque com Base no Número de Endosso
					CASE WHEN CVI.NumeroEndosso BETWEEN 2 AND 3 THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 4 AND 6 THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 7 AND 12 THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 13 AND 24 THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 25 AND 36 THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 37 AND 48 THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 49 AND 60 THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 61 AND 72 THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 73 AND 84 THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 85 AND 96 THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 97 AND 108 THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso BETWEEN 109 AND 120 THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroEndosso > 120 THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
					END
				--Regras de Pagamento Único
				WHEN (CVI.IDOperacao = 8) THEN 'Pagamento Único'	--'Primeira parcela de pagamento único'   /*ARREDONDAMENTO PAR*/    
				WHEN (CVI.IDOperacao IN (9, 10)) THEN 'Pagamento Único'	--'Primeira parcela de pagamento único'   /*LANÇAMENTO E ESTORNO DE LANÇAMENTO MANUAL*/    
				WHEN (CVI.NumeroParcela > 1) THEN --aplicar case de range de parcela (demais parcelas dos produtos exceto bilhete)
					--Regra do Estoque com Base no Número de Parcelas
					CASE WHEN CVI.NumeroParcela BETWEEN 2 AND 3 THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 4 AND 6 THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 7 AND 12 THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 13 AND 24 THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 25 AND 36 THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 37 AND 48 THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 49 AND 60 THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 61 AND 72 THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 73 AND 84 THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 85 AND 96 THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 97 AND 108 THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela BETWEEN 109 AND 120 THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
						 WHEN CVI.NumeroParcela > 120 THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
					END
			END, 'Não Informado') AS TipoPagamento,
	--Para o Produto 3701 é necessário duplicar o valor do Premio Liquido
	ISNULL(CASE WHEN CVI.CodigoProduto = '3701' THEN (CVI.PremioLiquido * 2) ELSE CVI.PremioLiquido END, 0) PremioLiquido,
	ISNULL(CVI.ValorComissao, 0) AS ValorComissao,
	CVI.DataRecibo, 
	CVI.NumeroParcela, 
	CVI.QuantidadeParcelas,
	ISNULL(CVI.Autorizado, 0) AS Autorizado,
	ISNULL(CVI.Processado, 0) AS Processado,
	CVI.NumeroRecibo,
	CVI.DataCompetencia,
	CVI.ClassificacaoProduto
FROM CTE_VIDA_ORIGEM CVI

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
	CVN.DataCompetencia,
	CVN.ClassificacaoProduto
FROM CTE_VENDANOVA CVN





