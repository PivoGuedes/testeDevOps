
CREATE VIEW Dados.vw_IndicadoresConsolidadoProduto
AS	 
SELECT F.Matricula, F.CPF, F.Nome, U.Codigo [CodigoUnidade], /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado [Produto], PP.Descricao [NomeProduto]
     , YEAR(RI.DataReferencia) [AnoReferencia], MONTH(RI.DataReferencia) [MesReferencia], SUM(PRI.ValorBruto) [ValorBrutoAnalitico]
	 , RI.ValorBruto [ValorBrutoSintetico], RI.ValorIRF [ValorIRFSintetico], RI.ValorISS [ValorISSintetico]
	 , ValorINSS [ValorINSSintetico], RI.ValorLiquido [ValorLiquidointetico], YEAR(DataCompetencia) [AnoCompetentia], MONTH(DataCompetencia) [MesCompetentia]
FROM Dados.PremiacaoIndicadores PRI
INNER JOIN Dados.RepremiacaoIndicadores RI
ON       PRI.IDFuncionario = RI.IDFuncionario
AND YEAR(PRI.DataArquivo)  = YEAR(RI.DataReferencia)
AND MONTH(PRI.DataArquivo) = MONTH(RI.DataReferencia)
INNER JOIN Dados.ProdutoPremiacao PP
ON PP.ID = PRI.IDProdutoPremiacao
INNER JOIN Dados.Funcionario F
ON PRI.IDFuncionario = F.ID
INNER JOIN Dados.Unidade U
ON U.ID = PRI.IDUnidade
--WHERE PRI.IDFuncionario = 5678 and YEAR(RI.DataReferencia) = 2014 and  MONTH(RI.DataReferencia) = 02
GROUP BY  F.CPF, F.Nome, F.Matricula, U.Codigo, /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado, PP.Descricao
        , YEAR(RI.DataReferencia), MONTH(RI.DataReferencia), RI.ValorBruto, RI.ValorIRF , RI.ValorISS, ValorINSS, RI.ValorLiquido, YEAR(DataCompetencia), MONTH(DataCompetencia)



--CREATE VIEW Marketing.vw_IndicadoresConsolidadoProduto
--AS
--SELECT *
--FROM Dados.vw_IndicadoresConsolidadoProduto