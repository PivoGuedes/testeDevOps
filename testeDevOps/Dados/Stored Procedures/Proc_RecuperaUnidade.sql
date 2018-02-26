
CREATE PROCEDURE [Dados].[Proc_RecuperaUnidade]
@CodigoUnidade SMALLINT
AS
		SELECT Codigo, Nome, Endereco, Bairro, CEP, DDD, Responsavel, NomeMunicipio, UFMunicipio, Telefone1, TipoTelefone1,Telefone2, TipoTelefone2 
		FROM Dados.UnidadeHistorico 
		WHERE 
			Codigo=@CodigoUnidade
			AND LastValue=1

