


/*******************************************************************************
	Nome: Corporativo.Dados.fn_RetornaUnidadeCodigo
	Descrição: Função auxiliar buscar o código da unidade (Usada no campo calculado Codigo da tabela UnidadeHistorico)
  Data de Criação: 2013/03/07
  Criador: Egler Vieira
  Ultima atialização: - 
		
	Parâmetros de entrada:
		@IDUnidade smallint
	Retorno:
		VARCHAR(20): ID da Unidade
	
	Exemplo de utilização:
		Vide fim deste arquivo para alguns exemplos simples de utilização.
	
*******************************************************************************/ 


CREATE FUNCTION [Dados].[fn_RetornaUnidadeCodigo](@IDUnidade smallint)
RETURNS SMALLINT
WITH SCHEMABINDING
AS
BEGIN

RETURN (SELECT TOP 1 Codigo FROM Dados.Unidade WHERE ID = @IDUnidade)


--SELECT  Dados.fn_RetornaUnidadeCodigo(1)
END




