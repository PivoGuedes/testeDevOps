
/*
	Autor: Egler Vieira
	Data Criação: 01/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_ProdutoHistorico_UNPIVOT]
	Descrição: View que rastreia todas as atualização de todos os Produtos e faz a operação de UNPIVOT, 
	           transformando as colunas em linhas
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW Dados.vw_ProdutoHistorico_UNPIVOT
AS
SELECT TOP 100 PERCENT
      CodigoComercializado, DataInicio, Dado, Valor
FROM 
  (
   SELECT CodigoComercializado, DataInicio, ISNULL(Cast(DataInicioComercializacao as varchar(50)), '-') DataInicioComercializacao, ISNULL(Cast(DataFimComercializacao as varchar(50)), '-') DataFimComercializacao, Cast((CASE WHEN MetaASVEN = 1 THEN 'SIM' WHEN MetaASVEN = 0 THEN 'NÃO' ELSE '-' END) AS VARCHAR(50)) MetaASVEN, Cast(CASE WHEN MetaAVCaixa = 1 THEN 'SIM' WHEN MetaAVCaixa = 0 THEN 'NÃO' ELSE '-' END AS VARCHAR(50)) MetaAVCaixa, ISNULL(Cast(PercentualASVEN as varchar(50)), '-') PercentualASVEN, ISNULL(Cast(PercentualCorretora as varchar(50)), '-') PercentualCorretora, ISNULL(Cast(PercentualRepasse as varchar(50)), '-') PercentualRepasse
   FROM Dados.vw_ProdutoGeral VW
--   WHERE VW.CodigoComercializado = '2'
  ) VW
UNPIVOT
(
  Valor FOR Dado IN (DataInicioComercializacao, DataFimComercializacao, MetaASVEN , MetaAVCaixa, PercentualASVEN, PercentualCorretora, PercentualRepasse)
) AS UNPIVOTED  
ORDER BY CodigoComercializado, DataInicio DESC  
