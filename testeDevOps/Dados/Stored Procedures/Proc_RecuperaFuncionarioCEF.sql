CREATE PROCEDURE [Dados].[Proc_RecuperaFuncionarioCEF]
@CPF VARCHAR(20)
,@Matricula VARCHAR(20)
AS
	SELECT F.CPF, F.Matricula, F.Nome, LotacaoCidade, LotacaoUF, F.DDD, F.Telefone, DataNascimento, UH.Nome AS NomeUnidade, UH.Codigo AS CodigoUnidade, S.Descricao AS Sexo
	FROM Dados.FuncionarioHistorico AS FH
	INNER JOIN Dados.Funcionario AS F
	ON F.ID=FH.IDFuncionario
	AND FH.LastValue=1
	INNER JOIN Dados.Unidade AS U
	ON U.ID=FH.IDUnidade
	INNER JOIN Dados.UnidadeHistorico AS UH
	ON UH.IDUnidade=U.ID
	AND UH.LastValue=1
	INNER JOIN Dados.Sexo AS S
	ON S.ID=F.IDSexo
	WHERE F.IDEmpresa=1
	AND (CPF=@CPF OR Matricula=@Matricula)

