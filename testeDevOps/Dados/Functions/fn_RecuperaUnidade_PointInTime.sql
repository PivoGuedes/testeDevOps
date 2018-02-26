

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaUnidade_PointInTime
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


CREATE FUNCTION Dados.fn_RecuperaUnidade_PointInTime(@IDUnidade smallint, @DataReferencia DATE)
RETURNS TABLE
AS   
 RETURN SELECT TOP 1 UH.IDFilialPARCorretora, UH.ASVEN, UH.IDUnidadeEscritorioNegocio, UH.Nome, UH.Codigo, UH.DataArquivo [DataReferenciaUnidade]
        FROM Dados.vw_UnidadeGeral UH
        WHERE UH.IDUnidade = @IDUnidade
         AND UH.DataArquivo <= @DataReferencia
        ORDER BY UH.IDUnidade ASC, UH.DataArquivo DESC, UH.ID DESC  

--SELECT * FROM Dados.fn_RecuperaUnidade_PointInTime(2,'2013-03-12')
