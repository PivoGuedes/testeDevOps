
/*
	Autor: Egler Vieira
	Data Criação: 27/02/2014

	Descrição: 
	
	Última alteração : 14/05/2014
	Alterado por: Windson
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaLancamentoManual
	Descrição: Procedimento que realiza uma consulta retornando um dataset com os lançamentos manuais filtrado por datas
			
	Parâmetros de entrada: @DataReciboInicial - Data do recibo
	                       @DataReciboFinal   - Data do recibo
						   @IDEmpresa - Código da empresa
	
					
	Retorno:
	
		
	Exemplo de utilização:
	  Vide fim deste arquivo para o exemplo simples de utilização.	
*******************************************************************************/ 
CREATE PROCEDURE [Dados].[proc_RecuperaLancamentoManual] (@DataInicial date, @DataFinal Date, @IDEmpresa INT)
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
    c.LancamentoManual = 1 AND C.IDEmpresa = @IDEmpresa AND DataCompetencia BETWEEN  @DataInicial AND @DataFinal

-- EXEC Dados.proc_RecuperaLancamentoManual ('2014-02-19',2014-02-19)
