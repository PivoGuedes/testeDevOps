
/*
       Autor: Egler Vieira
       Data Criação: 19/08/2014

       Descrição: 
       
       Última alteração :  Pedro Luiz, 30/01/2015
						   Egler Vieira, 22/08/2016
						   Egler Vieira, 28/09/2016 (@Pago -> retornar lotes não pagos trazendo informações financeiras com valores NULL)
                                                                                      
*/

/*******************************************************************************
       Nome: CORPORATIVO.Dados.fn_RecuperaExtratoIndicadoresMundoCaixa
       Descrição: Procedimento que realiza a recuperação do extrato de pontos de um indicador.
                  O extrato traz o valor bruto e um calculo (regra de 3) com a distribuição do valor liquido (quando houver).
                        
       Parâmetros de entrada:
       
                                  
       Retorno:

*******************************************************************************/  
CREATE FUNCTION [Dados].[fn_RecuperaExtratoIndicadoresMundoCaixa](@IDIndicador INT, @AnoCompetencia INT, @MesCompetencia int, @Gerente bit = 0, @Pago bit = 1)
RETURNS TABLE
AS
RETURN

--DECLARE @IDIndicador INT = 27865
--      , @AnoCompetencia INT = 2016
--	  , @MesCompetencia int = 1
--	  , @Gerente BIT = 0
--	  , @Pago bit = 1;

WITH CTE
AS
(
SELECT F.Matricula, F.CPF, F.Nome, U.Codigo [CodigoUnidade], /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado [Produto], PP.Descricao [NomeProduto]
     , PRI.NumeroParcela, PRI.NumeroApolice, PRI.NumeroTitulo, CASE WHEN PRI.NomeArquivo like '%COPACAP%' OR PRI.NomeArquivo like '%CONSORC%' OR PP.CodigoBU IN ('00004','00006') THEN PRI.NumeroEndosso ELSE NULL END NumeroEndosso, SUM(Cast(PRI.ValorBruto as decimal(24,9))) [ValorBrutoAnalitico]
       , Cast( RI.ValorBruto as decimal(24,9)) [ValorBrutoSintetico]
	   , /*ISNULL(RI.ValorIRF,0) +*/ ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)) ,0) [ValorIRFSintetico]
	   , /*ISNULL(RI.ValorISS,0) +*/ ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) [ValorISSSintetico]
       ,/* ISNULL(RI.ValorINSS,0) +*/ ISNULL(Cast(RI.CalculadoValorINSS  as decimal(24,9)),0) [ValorINSSintetico]
       , Cast(RI.ValorBruto as decimal(24,9)) -  ISNULL(Cast(RI.CalculadoValorINSS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)),0) [ValorLiquidoSintetico]
       , PRI.DataArquivo--, YEAR(PRI.DataArquivo) [AnoCompetentia], MONTH(PRI.DataArquivo) [MesCompetentia]
	   , lt.Tipo, lt.id, PRI.Gerente, PRI.DataEmissao
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
WHERE 
      PRI.IDFuncionario = @IDIndicador 
  and PRI.Gerente = @Gerente
  AND LT.Tipo = CASE WHEN @Gerente = 1 THEN 'GI' ELSE 'I' END
  and (
		   YEAR(PRI.DataArquivo) = @AnoCompetencia 
	  and  MONTH(PRI.DataArquivo) = @MesCompetencia 
	  AND NOT EXISTS (SELECT * 
	                  FROM ControleDados.IndicadoresAjustes I 
	                  WHERE I.IDLote = PRI.IDLote 
					    AND I.ExibirExtrato = 0
					 )
      )
-----------------------------------------------------------------------------------
--Egler: 28/09/2016
-----------------------------------------------------------------------------------
  AND LT.Processado = @Pago
  --and NOT 0 = ISNULL(RI.CalculadoValorISS,0)
  AND 1 = CASE WHEN @Pago = 1 THEN 
                               CASE WHEN NOT 0 = ISNULL(RI.CalculadoValorISS,0) THEN 1 ELSE 0 END 
			   WHEN @Pago = 0 THEN 
								   CASE WHEN 0 = ISNULL(RI.CalculadoValorISS,0) THEN 1 ELSE 0 END
		  END --WAND @Pago = 0 THEN 1
-----------------------------------------------------------------------------------
--where f.matricula = '00528250'
--WHERE PRI.IDFuncionario = 5678 and YEAR(PRI.DataArquivo) = 2012 and  MONTH(PRI.DataArquivo) = 12
--WHERE YEAR(RI.DataReferencia) >= 2014
GROUP BY  F.CPF, F.Nome, F.Matricula, U.Codigo, /*PRI.IDProdutoPremiacao,*/ PP.CodigoComercializado, PP.Descricao
        , YEAR(RI.DataReferencia), MONTH(RI.DataReferencia), PRI.NumeroParcela, PRI.NumeroApolice, PRI.NumeroTitulo
			  ,  CASE WHEN PRI.NomeArquivo like '%COPACAP%' OR PRI.NomeArquivo like '%CONSORC%' OR PP.CodigoBU IN ('00004','00006') THEN PRI.NumeroEndosso ELSE NULL END 
              , RI.ValorBruto
              , ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)),0) 
              , ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) 
              , ISNULL(Cast(RI.CalculadoValorINSS as decimal(24,9)),0) 
              , Cast(RI.ValorBruto as decimal(24,9)) -  ISNULL(Cast(RI.CalculadoValorINSS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorISS as decimal(24,9)),0) - ISNULL(Cast(RI.CalculadoValorIRRF as decimal(24,9)),0)
              , PRI.DataArquivo--YEAR(PRI.DataArquivo), MONTH(PRI.DataArquivo)
			   , lt.Tipo, lt.id, PRI.Gerente, PRI.DataEmissao
)
SELECT   CTE.Matricula
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
		, CTE.NumeroEndosso
        --##, CTE.[ValorBrutoSintetico]
		-----------------------------------------------------------------------------------
		-- Implementação de CASE WHEN @Pago = 1 para que não seja exibido nenhum valor de $$$ sem o pagamento efetivado
		-----------------------------------------------------------------------------------
        , CASE WHEN @Pago = 1 THEN (CTE.ValorLiquidoSintetico / CTE.[ValorBrutoSintetico]) ELSE NULL END relacao_ValorLiquidoSintetico_BrutoSintetico
        , CASE WHEN @Pago = 1 THEN CTE.[ValorBrutoAnalitico] ELSE NULL END [ValorBrutoAnalitico]
        , CASE WHEN @Pago = 1 THEN CTE.[ValorBrutoAnalitico] * (CTE.ValorLiquidoSintetico / CTE.[ValorBrutoSintetico]) ELSE NULL END [ValorLiquidoAnalitico]
        --##,, CTE.[ValorIRFSintetico]   
        , CASE WHEN @Pago = 1 THEN CTE.[ValorBrutoAnalitico] * (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) ELSE NULL END [IRFAnalitico]
        , CASE WHEN @Pago = 1 THEN (CTE.[ValorIRFSintetico] / CTE.[ValorBrutoSintetico]) ELSE NULL END [% IR]
        --##, CTE.[ValorISSSintetico]
        , CASE WHEN @Pago = 1 THEN CTE.[ValorBrutoAnalitico] * (CTE.[ValorISSSintetico] / CTE.[ValorBrutoSintetico]) ELSE NULL END [ISSAnalitico]
        , CASE WHEN @Pago = 1 THEN (CTE.[ValorISSSintetico] / CTE.[ValorBrutoSintetico]) ELSE NULL END [% ISS]
        --###, [ValorINSSintetico]
        , CASE WHEN @Pago = 1 THEN CTE.[ValorBrutoAnalitico] * (CTE.[ValorINSSintetico] / CTE.[ValorBrutoSintetico]) ELSE NULL END [INSSAnalitico]
        , CASE WHEN @Pago = 1 THEN (CTE.[ValorINSSintetico] / CTE.[ValorBrutoSintetico]) ELSE NULL END [% INSS]
		, Tipo
		, id [Lote]
		, PIT.ValorTeto
		,cte.Gerente
		, Cast(cte.DataEmissao AS date) DataEmissao
        --###, CTE.[ValorLiquidoSintetico]
FROM CTE	   
CROSS APPLY (SELECT TOP 1 ValorTeto
	         FROM Dados.PremiacaoIndicadoresTeto PIT
			 WHERE PIT.DataInicio <= DataArquivo
			 AND PIT.Tipo = CTE.Tipo 
			 ORDER BY PIT.DataInicio DESC
			) PIT


  --SELECT * FROM Dados.fn_RecuperaExtratoIndicadoresMundoCaixa(10655, 2015,  1)
