
/*
	Autor: Egler Vieira
	Data Criação: 13/03/2013

	Descrição: 
	
	Última alteração : 14/05/2014
	Alterado por: Windson

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaFaturamentoCompetenciaPorProduto
	Descrição: Procedimento que realiza uma consulta retornando um
	dataset AGRUPADO por DataCompetencia, Numero de Recibo e Produto, SUMARIZADO pelo ValorCorretagem, ValorComissaoPAR e ValorRepasse
			
	Parâmetros de entrada: @DataReciboInicial - Data do recibo
	                       @DataReciboFinal   - Data do recibo

	
					
	Retorno:
	
		
	Exemplo de utilização:
	  Vide fim deste arquivo para o exemplo simples de utilização.	
*******************************************************************************/    
CREATE PROCEDURE [Dados].[proc_RecuperaFaturamentoCompetenciaPorProduto](
	@DataReciboInicial DATE
  , @DataReciboFinal DATE
  , @IDEmpresa INT
  , @ExtraRede BIT = 0
  )
AS

SELECT C.DataCompetencia
	 , C.NumeroRecibo
	 , PRD.ID [IDProduto]
	 , PRD.CodigoComercializado [CodigoProduto]
	 , PRD.Descricao [Produto]
     , SUM(ValorCorretagem) ValorCorretagem
	 , SUM(ValorComissaoPAR) ValorComissaoPAR
	 , SUM(ValorRepasse) ValorRepasse
FROM Dados.Comissao C
	INNER JOIN Dados.Produto PRD
	ON C.IDProduto = PRD.ID
	WHERE c.IDEmpresa = @IDEmpresa
	 AND C.DataCompetencia BETWEEN @DataReciboInicial AND @DataReciboFinal	 
	 AND 1 = CASE WHEN @ExtraRede = 1 AND C.Arquivo  = 'COMI EXTRA REDE'  THEN 1
					WHEN @ExtraRede = 0 AND (C.Arquivo != 'COMI EXTRA REDE' OR C.Arquivo IS NULL) THEN 1 
			ELSE 0 END
GROUP BY C.DataCompetencia
	, C.NumeroRecibo
	, PRD.ID
	, PRD.CodigoComercializado
	, PRD.Descricao 
ORDER BY C.DataCompetencia
	, C.NumeroRecibo
	, PRD.CodigoComercializado
--EXEC Dados.proc_RecuperaFaturamentoCompetenciaPorProduto '2013-02-28', '2013-02-28'
