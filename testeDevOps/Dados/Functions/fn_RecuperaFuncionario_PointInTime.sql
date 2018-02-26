

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaFuncionario_PointInTime
	Descrição: Função auxiliar buscar os Funcionario na tabela FuncionarioHistorico
  Data de Criação: 2013/11/14
  Criador: Egler Vieira
  Ultima atialização:		
	Parâmetros de entrada:
		@IDFuncionario smallint
	Retorno:
		VARCHAR(20): ID do Funcionario
	
	Exemplo de utilização:
		Vide fim deste arquivo para alguns exemplos simples de utilização.
	
*******************************************************************************/

CREATE FUNCTION Dados.fn_RecuperaFuncionario_PointInTime(@IDFuncionario int, @DataReferencia DATE)
RETURNS TABLE
AS   
 RETURN SELECT TOP 1 *
        FROM
		(   
			SELECT *
			FROM
			(
				SELECT TOP 1 *
				FROM Dados.vw_FuncionarioGeral FH
				WHERE FH.IDFuncionario = @IDFuncionario
				 AND FH.DataArquivo <= @DataReferencia
				ORDER BY FH.IDFuncionario ASC, FH.DataArquivo DESC
			) A
			UNION
			SELECT *
			FROM
			(
				SELECT TOP 1 *
				FROM Dados.vw_FuncionarioGeral FH
				WHERE FH.IDFuncionario = @IDFuncionario
				 AND FH.DataArquivo >= @DataReferencia
				ORDER BY FH.IDFuncionario ASC, FH.DataArquivo ASC
			) B
		) RESULTSET
		ORDER BY RESULTSET.DataArquivo ASC

--SELECT * FROM Dados.fn_RecuperaFuncionario_PointInTime(2,'2013-03-12')
