






CREATE VIEW [VendaNova].[vw_DataMart_VendaNova_Outros] AS 

WITH CTE AS ( --CARGA DOS PRODUTOS DA CORRETORA DE OUTROS PARA A FATO VENDA NOVA/ESTOQUE

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
	INNER JOIN [Corporativo].[Dados].[Produto] PRD ON COM.IDProduto = PRD.ID
	INNER JOIN [Corporativo].[Dados].[Produtor] PRT ON COM.IDProdutor = PRT.ID
	INNER JOIN [Corporativo].[Dados].[ComissaoOperacao] COP ON COP.ID = COM.IDOperacao
	INNER JOIN [Corporativo].[Dados].[ProdutoClassificacaoBloco] PCB ON PCB.IDEmpresa = COM.IDEmpresa AND RIGHT('0000' + LTRIM(RTRIM(PCB.CodigoClassificacaoVendaNova)), 4) COLLATE DATABASE_DEFAULT = RIGHT('0000' + LTRIM(RTRIM(PRD.CodigoComercializado)), 4) AND PCB.DescricaoClassificacaoVendaNova = 'Outros'
	LEFT JOIN [Corporativo].[Dados].[Proposta] PRP ON COM.IDProposta = PRP.ID
	LEFT JOIN [Corporativo].[Dados].[Contrato] CNT ON COM.IDContrato = CNT.ID 
	LEFT JOIN [Corporativo].[ControleDados].[ExportacaoFaturamento] EXF ON EXF.IDEmpresa = COM.IDEmpresa AND EXF.NumeroRecibo = COM.NumeroRecibo AND EXF.DataCompetencia = COM.DataCompetencia AND EXF.DataRecibo = COM.DataRecibo
	LEFT JOIN (SELECT EDS.IDContrato, EDS.NumeroEndosso, EDS.IDProposta, EDS.QuantidadeParcelas 
			   FROM [Corporativo].[Dados].[Endosso] EDS) EDS ON EDS.IDContrato = CNT.ID AND EDS.NumeroEndosso = COM.NumeroEndosso AND EDS.IDProposta = PRP.ID
	WHERE COM.IDEmpresa = 3
	--AND RIGHT('0000' + LTRIM(RTRIM(PRD.CodigoComercializado)), 4) IN ('0001', '0002', '0003', '0005', '0008', '0010', '0011', '0012', '0014', '0017', '0018', '0019', '0020', '0021', '0022', '0023', '0024', '0025', '0026', '0027', '0028', '0030', '0033', '0047', '0056', '0058', '0060', '0062', '0063', '0064', '0066', '0067', '0069', '0097', '0098', '0201', '0202', '0203', '0210', '0222', '0223', '0402', '0403', '0405', '0406', '0407', '0408', '0409', '0410', '0413', '1001', '1065', '1066', '1081', '1082', '1083', '1084', '1085', '1086', '1087', '1088', '1090', '1091', '1092', '1093', '1095', '1096', '1097', '1098', '1099', '1100', '1106', '1108', '1109', 
	--		 '1110', '1113', '1114', '1115', '1116', '1117', '1118', '1119', '1120', '1121', '1122', '1123', '1124', '1125', '1126', '1127', '1130', '1131', '1132', '1133', '2002', '2005', '2007', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024', '2027', '2028', '2030', '2032', '2035', '2036', '2039', '2042', '2048', '2049', '2050', '2051', '2052', '2053', '2054', '3101', '3102', '3105', '3114', '3199', '3707', '3708', '4005', '4007', '4500', '4505', '4507', '5102', '5103', '5501', '5502', '5503', '5504', '5505', '5506', '5507', '5508', '5510', '5511', '5512', 
	--		 '5513', '5514', '5515', '5516', '5517', '5521', '5535', '5536', '5537', '5538', '5540', '5541', '5542', '5543', '5544', '5545', '5548', '5550', '5552', '5553', '5554', '5555', '5556', '5557', '5558', '5559', '5560', '5561', '5562', '5563', '5564', '5565', '5566', '5567', '5568', '5569', '5570', '5601', '5602', '5603', '5604', '5605', '5606', '5607', '5608', '5609', '5610', '5611', '5612', '5613', '5614', '5615', '5616', '5617', '5621', '5622', '5623', '5625', '5627', '5629', '5630', '6128', '6129', '6130', '6132', '6133', '6134', '6700', '6701', '7105', '7719', '8211', '8299', '9201', '9202', '9203', '9204', 
	--		 '9205', '9206', '9207', '9208', '9209', '9210', '9223', '9224', '9225', '9226', '9227', '9228', '9230', '9231', '9232', '9233', '9234', '9235', '9236', '9237', '9238', '9239', '9240', '9241', '9242', '9243', '9246', '9247', '9248', '9249', '9250', '9331', '9339', '9340', '9341', '9347', '9348', '9349', '9350', '9401', '9402', '9403', '9404', '9405', '9406', '9407', '9408', '9409', '9410', '9411', '9412', '9910', '9922', '9924', '9925', '9991', '9992', '9993', '9997', '9999')  --OUTROS
	/* AND COM.DataCompetencia BETWEEN '2015-01-01' AND CAST(GETDATE() AS DATE) */
	--AND CNT.NumeroContrato = '1103100449884'
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

), CTE_OUTROS_ORIGEM AS (

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

), CTE_VENDANOVA AS (

SELECT --TOP 10 
	COU.IDContrato, --Somente Corretora
	COU.IDProposta, 
	COU.CodigoEmpresa,
	COU.CodigoProduto,
	COU.NumeroProposta, 
	COU.NumeroApolice, 
	COU.NumeroEndosso, 
	COU.CodigoProdutor,
	COU.CodigoOperacao, 
	COU.SinalOperacao, 
	ISNULL(CASE WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.QuantidadeParcelas BETWEEN 0 AND 1 THEN CAST('Pagamento Único' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela = 1 AND COU.QuantidadeParcelas > 1 THEN CAST('Pagamento Mensal' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 2 AND 3 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - até 90 dias' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 4 AND 6 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - 90 - 180 dias' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 7 AND 12 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - 180 - 365 dias' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 13 AND 24 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 01 ano < 02 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 25 AND 36 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 02 anos < 03 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 37 AND 48 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 03 anos < 04 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 49 AND 60 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 04 anos < 05 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 61 AND 72 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 05 anos < 06 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 73 AND 84 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 06 anos < 07 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 85 AND 96 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 07 anos < 08 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 97 AND 108 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 08 anos < 09 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela BETWEEN 109 AND 120 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 09 anos < 10 anos' AS VARCHAR(50))
				WHEN ((COU.PremioLiquido >= 0 AND COU.ValorComissao >= 0) OR (COU.PremioLiquido >= 0 OR COU.ValorComissao >= 0) OR (COU.PremioLiquido < 0 AND COU.ValorComissao < 0)) AND COU.NumeroParcela > 120 AND ((COU.QuantidadeParcelas > 1) OR (COU.QuantidadeParcelas BETWEEN 0 AND 1)) THEN CAST('Demais Parcelas - > 10 anos' AS VARCHAR(50))
				ELSE CAST('Não Informado' AS VARCHAR(50))
			END, 'Não Informado') AS TipoPagamento,
	ISNULL(COU.PremioLiquido, 0) AS PremioLiquido,
	ISNULL(COU.ValorComissao, 0) AS ValorComissao,
	COU.DataRecibo, 
	COU.NumeroParcela, 
	COU.QuantidadeParcelas,
	ISNULL(COU.Autorizado, 0) AS Autorizado,
	ISNULL(COU.Processado, 0) AS Processado,
	COU.NumeroRecibo,
	COU.DataCompetencia,
	COU.ClassificacaoProduto
FROM CTE_OUTROS_ORIGEM COU

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






