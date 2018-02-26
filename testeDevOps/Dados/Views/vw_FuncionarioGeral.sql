

/*
	Autor: Egler Vieira
	Data Criação: 14/11/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_FuncionarioGeral]
	Descrição: View que rastreia todas as atualização de todos os Funcionários
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_FuncionarioGeral]
AS	

SELECT 
        F.ID [IDFuncionario]
      , F.Nome
	  , F.CPF
	  , F.Email
	  , F.Matricula
	  , F.PIS
	  , F.IDEmpresa
	  , F.DDD
	  , F.Telefone
      , F.DataCriacao
	  , F.IDTipoVinculo
	  , F.IDSexo
	  , F.DataNascimento
	  , FH.IDSituacaoFuncionario
	  , FH.IDFuncao
	  , FH.IDUnidade
	  , FH.DataAdmissao
	  , FH.DataAtualizacaoCargo
	  , FH.DataAtualizacaoVolta
	  , FH.Salario
	  , FH.Cargo
	  , FH.LotacaoUF
	  , FH.LotacaoCidade
	  , FH.LotacaoDataInicio
	  , FH.LotacaoSigla
	  , FH.LotacaoEmail
	  , FH.ParticipanteEmail
	  , FH.ParticipanteLotacaoDDD
	  , FH.ParticipanteLotacaoTelefone
	  , FH.FuncaoDataInicio
	  , FH.NomeArquivo
	  , FH.DataArquivo
FROM Dados.Funcionario AS F 
	LEFT JOIN Dados.FuncionarioHistorico AS FH 
	ON F.ID = FH.IDFuncionario
WHERE FH.LastValue = 1


--SELECT * FROM [Dados].[vw_ProdutoGeral]

