
CREATE VIEW [Marketing].[vw_PremiacaoIndicadores_ImpostosCalculados]
AS
WITH CTE
AS
(
SELECT F.Matricula, F.CPF, F.Nome, U.Codigo [CodigoUnidade], /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado [Produto], ISNULL(PP.Descricao, PRI.NomeArquivo) [NomeProduto]
     , YEAR(RI.DataReferencia) [AnoReferencia], MONTH(RI.DataReferencia) [MesReferencia], PRI.NumeroParcela, SUM(PRI.ValorBruto) [ValorBrutoAnalitico]
	 , RI.ValorBruto [ValorBrutoSintetico], ISNULL(RI.ValorIRF,0) + ISNULL(RI.CalculadoValorIRRF,0) [ValorIRFSintetico], ISNULL(RI.ValorISS,0) + ISNULL(RI.CalculadoValorISS,0) [ValorISSSintetico]
	 , ISNULL(ValorINSS,0) + ISNULL(RI.CalculadoValorINSS,0) [ValorINSSintetico]
	 , RI.ValorBruto -  ISNULL(RI.CalculadoValorINSS,0) - ISNULL(RI.CalculadoValorISS,0) - ISNULL(RI.CalculadoValorIRRF,0) [ValorLiquidoSintetico]
	 , YEAR(DataCompetencia) [AnoCompetentia], MONTH(DataCompetencia) [MesCompetentia]
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
--where f.matricula = '00528250'
--WHERE PRI.IDFuncionario = 5678 and YEAR(RI.DataReferencia) = 2014 and  MONTH(RI.DataReferencia) = 02
WHERE YEAR(RI.DataReferencia) >= 2013
GROUP BY  F.CPF, F.Nome, F.Matricula, U.Codigo, /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado, ISNULL(PP.Descricao, PRI.NomeArquivo)
        , YEAR(RI.DataReferencia), MONTH(RI.DataReferencia), PRI.NumeroParcela
		, RI.ValorBruto
		, ISNULL(RI.ValorIRF,0) + ISNULL(RI.CalculadoValorIRRF,0) 
		, ISNULL(RI.ValorISS,0) + ISNULL(RI.CalculadoValorISS,0) 
	    , ISNULL(ValorINSS,0) + ISNULL(RI.CalculadoValorINSS,0) 
		, RI.ValorBruto - ISNULL(RI.CalculadoValorINSS,0) - ISNULL(RI.CalculadoValorISS,0) - ISNULL(RI.CalculadoValorIRRF,0)
		, YEAR(DataCompetencia), MONTH(DataCompetencia)
)
,
A AS
(
SELECT CTE.Matricula
     , CTE.CPF
	 , CTE.Nome
	 , CTE.[CodigoUnidade]
	 , /*CTE.IDProdutoPremiacao,*/ CTE.[Produto]
	 , CTE.[NomeProduto]
     , [AnoReferencia]
	 , [MesReferencia]
	 , NumeroParcela
	 --###, CTE.[ValorBrutoSintetico]
	 , CTE.[ValorBrutoAnalitico]
	 , CTE.[ValorBrutoAnalitico] * (CTE.ValorLiquidoSintetico / CTE.[ValorBrutoSintetico]) [ValorLiquidoAnalitico]
	 --###, CTE.[ValorIRFSintetico]	 
	 , CTE.[ValorBrutoAnalitico] * (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) [IRFAnalitico]
	 , (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) [% IR]
	 --###, CTE.[ValorISSSintetico]
	 , CTE.[ValorBrutoAnalitico] * (CTE.[ValorISSSintetico] / CTE.[ValorBrutoSintetico]) [ISSAnalitico]
	 , (CTE.[ValorISSSintetico] / CTE.[ValorBrutoSintetico]) [% ISS]
	 --###, [ValorINSSintetico]
	 , CTE.[ValorBrutoAnalitico] * (CTE.[ValorINSSintetico] / CTE.[ValorBrutoSintetico]) [INSSAnalitico]
	 , (CTE.[ValorINSSintetico] / CTE.[ValorBrutoSintetico]) [% INSS]
	 --###, CTE.[ValorLiquidoSintetico]
	 , [AnoCompetentia]
	 , [MesCompetentia] 
FROM CTE

--AND (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) * CTE.[ValorIRFSintetico] > 0 
--order by [AnoCompetentia], [MesCompetentia] 
)
SELECT *
    --   SUM([ValorLiquidoAnalitico]) [ValorLiquidoAnalitico],
    --   SUM([IRFAnalitico]) [IRFAnalitico],
	   --SUM([INSSAnalitico]) [INSSAnalitico],
	   --SUM([ISSAnalitico]) [ISSAnalitico]
	   --,A.AnoReferencia
	   --, A.MesReferencia    
FROM A
--GROUP BY A.AnoReferencia, A.MesReferencia 
--###ORDER BY  A.AnoReferencia, A.MesReferencia 


--2.954.521,92

--3.005.213,54


