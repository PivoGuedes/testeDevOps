
/*
	Autor: Egler Vieira
	Data Criação: 27/02/2014

	Descrição: 
	
	Última alteração : 14/05/2014 - Windson

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaLancamentoManualPorOperacao
	Descrição: Procedimento que realiza uma consulta retornando um dataset com os lançamentos manuais filtrado por datas e operação
			
	Parâmetros de entrada: @DataReciboInicial - Data do recibo
	                       @DataReciboFinal   - Data do recibo

	
					
	Retorno:
	
		
	Exemplo de utilização:
	  Vide fim deste arquivo para o exemplo simples de utilização.	
*******************************************************************************/ 
CREATE PROCEDURE [Dados].[proc_RecuperaLancamentoManualPorOperacao] (@IDOperacao tinyint, @DataInicial date, @DataFinal Date, @IDEmpresa INT)
AS
SELECT 
    PRD.Descricao NomeProduto,
	NumeroRecibo,
	DataRecibo,
	DataCompetencia,
	CO.Descricao NomeComissaoOperacao,                    
	C.ValorComissaoPAR TotalValorCorretagem
FROM [Dados].[Comissao] C	WITH(NOLOCK)
INNER JOIN Dados.Produto PRD WITH(NOLOCK)
ON C.IDProduto = PRD.ID
INNER JOIN Dados.ComissaoOperacao CO WITH(NOLOCK)
ON CO.ID = C.IDOperacao  
WHERE 
    c.LancamentoManual = 1 AND C.IDEmpresa = @IDEmpresa AND (IDOperacao = @IDOperacao) 
AND DataCompetencia BETWEEN  @DataInicial AND @DataFinal
