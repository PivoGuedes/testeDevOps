
/*
	Autor: Egler Vieira
	Data Criação: 19/08/2014

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaExtratoIndicadores
	Descrição: Procedimento que realiza a recuperação do extrato de pontos de um indicador.
	           O extrato traz o valor bruto e um calculo (regra de 3) com a distribuição do valor liquido (quando houver).
			   
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/	

CREATE FUNCTION Dados.fn_RecuperaExtratoIndicadores(@IDIndicador INT, @AnoCompetencia INT, @MesCompetencia int, @Gerente bit = 0)
RETURNS TABLE
AS
RETURN
WITH CTE
AS
(
SELECT F.Matricula, F.CPF, F.Nome, U.Codigo [CodigoUnidade], /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado [Produto], PP.Descricao [NomeProduto]
     , PRI.NumeroParcela, PRI.NumeroApolice, PRI.NumeroTitulo, SUM(PRI.ValorBruto) [ValorBrutoAnalitico]
       , RI.ValorBruto [ValorBrutoSintetico], /*ISNULL(RI.ValorIRF,0) +*/ ISNULL(RI.CalculadoValorIRRF,0) [ValorIRFSintetico], /*ISNULL(RI.ValorISS,0) +*/ ISNULL(RI.CalculadoValorISS,0) [ValorISSSintetico]
       ,/* ISNULL(RI.ValorINSS,0) +*/ ISNULL(RI.CalculadoValorINSS,0) [ValorINSSintetico]
       , RI.ValorBruto -  ISNULL(RI.CalculadoValorINSS,0) - ISNULL(RI.CalculadoValorISS,0) - ISNULL(RI.CalculadoValorIRRF,0) [ValorLiquidoSintetico]
       , PRI.DataArquivo--, YEAR(PRI.DataArquivo) [AnoCompetentia], MONTH(PRI.DataArquivo) [MesCompetentia]
FROM Dados.PremiacaoIndicadores PRI
INNER JOIN Dados.ProdutoPremiacao PP
ON PP.ID = PRI.IDProdutoPremiacao
INNER JOIN Dados.Funcionario F
ON PRI.IDFuncionario = F.ID
INNER JOIN Dados.Unidade U
ON U.ID = PRI.IDUnidade
INNER JOIN ControleDados.LoteProtheus LT
ON PRI.IDLote = LT.ID
OUTER APPLY (--SUM E GROUP BY APLICADOS EM 29/01/2015 PARA TRATAR PAGAMENTO DE AJUSTE
			SELECT RI.DataReferencia, SUM(Cast(RI.ValorBruto as decimal(24,9))) ValorBruto
			                    , SUM(Cast(RI.CalculadoValorIRRF as decimal(24,9))) CalculadoValorIRRF
								, SUM(Cast(RI.ValorIRF as decimal(24,9))) ValorIRF
								, SUM(Cast(RI.ValorINSS as decimal(24,9))) ValorINSS
								, SUM(Cast(RI.CalculadoValorINSS as decimal(24,9))) CalculadoValorINSS
								, SUM(Cast(RI.ValorISS as decimal(24,9))) ValorISS
								, SUM(Cast(RI.CalculadoValorISS as decimal(24,9))) CalculadoValorISS
                FROM Dados.RepremiacaoIndicadores RI
                WHERE  PRI.IDFuncionario = RI.IDFuncionario
                    AND YEAR(PRI.DataArquivo)  = YEAR(RI.DataReferencia)
                    AND MONTH(PRI.DataArquivo) = MONTH(RI.DataReferencia)
					AND LT.ID = RI.IDLote
                GROUP BY RI.DataReferencia
                     --SUM E GROUP BY APLICADOS EM 29/01/2015 PARA TRATAR PAGAMENTO DE AJUSTE
             ) RI
WHERE PRI.IDFuncionario = @IDIndicador 
  AND YEAR(PRI.DataArquivo) = @AnoCompetencia 
  AND  MONTH(PRI.DataArquivo) = @MesCompetencia
  AND PRI.Gerente = @Gerente
  AND LT.Tipo = CASE WHEN @Gerente = 1 THEN 'GI' ELSE 'I' END
  AND (
		   YEAR(PRI.DataArquivo) = @AnoCompetencia 
	  AND  MONTH(PRI.DataArquivo) = @MesCompetencia 
	  AND NOT EXISTS (SELECT * FROM ControleDados.IndicadoresAjustes I WHERE I.DataAjuste = PRI.DataArquivo)
      )
--where f.matricula = '00528250'
--WHERE PRI.IDFuncionario = 5678 and YEAR(PRI.DataArquivo) = 2012 and  MONTH(PRI.DataArquivo) = 12
--WHERE YEAR(RI.DataReferencia) >= 2014
GROUP BY  F.CPF, F.Nome, F.Matricula, U.Codigo, /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado, PP.Descricao
        , YEAR(RI.DataReferencia), MONTH(RI.DataReferencia), PRI.NumeroParcela, PRI.NumeroApolice, PRI.NumeroTitulo
              , RI.ValorBruto
              , ISNULL(RI.CalculadoValorIRRF,0) 
              ,  ISNULL(RI.CalculadoValorISS,0) 
           ,  ISNULL(RI.CalculadoValorINSS,0) 
              , RI.ValorBruto - ISNULL(RI.CalculadoValorINSS,0) - ISNULL(RI.CalculadoValorISS,0) - ISNULL(RI.CalculadoValorIRRF,0)
              , PRI.DataArquivo--YEAR(PRI.DataArquivo), MONTH(PRI.DataArquivo)
)

       SELECT CTE.Matricula
              , CTE.CPF
              , CTE.Nome
              , CTE.[CodigoUnidade]
              , /*CTE.IDProdutoPremiacao,*/ CTE.[Produto]
              , CTE.[NomeProduto]
              --, [AnoCompetentia]
              --, [MesCompetentia]
              , CTE.DataArquivo
              , NumeroParcela
              , CTE.NumeroApolice
              , CTE.NumeroTitulo
              --###, CTE.[ValorBrutoSintetico]
              , (CTE.ValorLiquidoSintetico / CTE.[ValorBrutoSintetico]) relacao_ValorLiquidoSintetico_BrutoSintetico
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
       FROM CTE
  --SELECT * FROM Dados.fn_RecuperaExtratoIndicadores(6497, 2014,  4, 0)
