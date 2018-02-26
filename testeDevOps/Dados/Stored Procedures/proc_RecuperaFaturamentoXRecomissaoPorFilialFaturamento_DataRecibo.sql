
/*
	Autor: Egler Vieira
	Data Criação: 06/02/2013

	Descrição: 
	
	Última alteração : Egler - 2013-02-08 (Inclusão de data final)

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaFaturamentoXRecomissaoPorFilialFaturamento_DataRecibo
	Descrição: Procedimento que realiza uma consulta retornando um
	RELATÓRIO, AGRUPANDO O FATURAMENTO POR FILIAL DE FATURAMENTO E CRUZANDO OS DADOS 
	DE COMISSÃO COM A RECOMISSÃO (VALIDAÇÃO)
		
	Parâmetros de entrada: @DataReciboInicial - Data do recibo
	                       @DataReciboFinal   - Data do recibo

	
					
	Retorno:
	
*********************************** ********************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaFaturamentoXRecomissaoPorFilialFaturamento_DataRecibo](@DataReciboInicial Date, @DataReciboFinal Date)
AS
/*************************************************************************************************************************************************/
/*RELATÓRIO RECONCILIAÇÃO*/
/*************************************************************************************************************************************************/
 select /*C.IDFilialFaturamento,*/ FF.Codigo, FF.Nome, FF.Cidade
 , CASE WHEN FF.BaseISS = 'T' THEN 'TOTAL' WHEN FF.BaseISS = 'R' THEN 'REDUZIDA'  ELSE FF.BaseISS END [BaseISS]
 , CASE WHEN FF.RetemIR = 1 THEN 'SIM' ELSE 'NÃO' END RetemIR
 , Cast(SUM(C.ValorBase) as numeric(15,2)) [ValorBase-COMISSAO], Cast(SUM(C.ValorCorretagem) as numeric(15,2)) [ValorCorretagem-COMISSAO]
 , [ValorCorretagem-RECOMISSAO], [ValorAdiantamento-RECOMISSAO]
 , [ValorRecuperacao-RECOMISSAO], [ValorISS-RECOMISSAO]
 , [ValorIRF-RECOMISSAO], [ValorAIRE-RECOMISSAO],  [ValorLiquido-RECOMISSAO]  
from Dados.Comissao C
INNER JOIN Dados.FilialFaturamento FF
ON FF.ID = C.IDFilialFaturamento
FULL OUTER JOIN (SELECT R.IDFilialFaturamento,
                       SUM(R.ValorCorretagem) [ValorCorretagem-RECOMISSAO], SUM(ValorAdiantamento) [ValorAdiantamento-RECOMISSAO]
                     , SUM(ValorRecuperacao) [ValorRecuperacao-RECOMISSAO], SUM(ValorISS) [ValorISS-RECOMISSAO]
                     , SUM(ValorIRF) [ValorIRF-RECOMISSAO], SUM(ValorAIRE) [ValorAIRE-RECOMISSAO], SUM(ValorLiquido) [ValorLiquido-RECOMISSAO] 
                 FROM Dados.Recomissao R
                 WHERE   R.DataArquivo BETWEEN @DataReciboInicial AND @DataReciboFinal
                 GROUP BY R.IDFilialFaturamento   
                ) R
ON FF.ID = R.IDFilialFaturamento
WHERE C.DataRecibo BETWEEN @DataReciboInicial AND @DataReciboFinal
  AND C.Arquivo <> 'MANUAL'
group by C.IDFilialFaturamento, FF.Codigo, FF.Nome, FF.Cidade 
,CASE WHEN FF.BaseISS = 'T' THEN 'TOTAL' WHEN FF.BaseISS = 'R' THEN 'REDUZIDA' ELSE FF.BaseISS END
,CASE WHEN FF.RetemIR = 1 THEN 'SIM' ELSE 'NÃO' END
,[ValorCorretagem-RECOMISSAO], [ValorAdiantamento-RECOMISSAO]
 , [ValorRecuperacao-RECOMISSAO], [ValorISS-RECOMISSAO]
 , [ValorIRF-RECOMISSAO], [ValorAIRE-RECOMISSAO],  [ValorLiquido-RECOMISSAO]
ORDER BY FF.Codigo 
/*************************************************************************************************************************************************/
--EXEC Dados.proc_RecuperaFaturamentoXRecomissaoPorFilialFaturamento_DataRecibo @DataReciboInicial = '2012-12-01', @DataReciboFinal = '2012-12-31' 
