

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaProduto_PointInTime
	Descrição: Função auxiliar buscar os produto na tabela ProdutoHistorico
  Data de Criação: 2013/03/07
  Criador: Egler Vieira
  Ultima atialização: Egler Vieira - 18/03/2013 - Adição da coluna de indicação de produto RUNOFF
		              Egler Vieira - 10/06/2014 - Adição da coluna de indicação de período de contratação
	Parâmetros de entrada:
		@IDUnidade smallint
	Retorno:
		VARCHAR(20): ID do Produto
	
	Exemplo de utilização:
		Vide fim deste arquivo para alguns exemplos simples de utilização.
	
*******************************************************************************/

CREATE FUNCTION Dados.fn_RecuperaProduto_PointInTime(@IDProduto smallint, @DataReferencia DATE)
RETURNS TABLE
AS   
 RETURN SELECT TOP 1 PH.Descricao, PH.CodigoComercializado
                   , PH.IDRamoPAR
                   , PH.PercentualCorretora, PH.PercentualASVEN, PH.PercentualRepasse
                   , CASE WHEN (PH.DataFimComercializacao IS NOT NULL AND PH.DataFimComercializacao <= @DataReferencia) THEN Cast(1 as bit)  ELSE Cast(0 as bit) END [RunOff]
                   , PH.MetaASVEN, PH.MetaAVCaixa, PH.DataInicio, PH.DataFim
                   , PH.DataInicioComercializacao, PH.DataFimComercializacao
				   , PH.IDPeriodoContratacao  
                   , PH.IDProdutoSegmento
        FROM Dados.vw_ProdutoGeral PH
        WHERE PH.IDProduto = @IDProduto
         AND PH.DataInicio <= @DataReferencia
        ORDER BY PH.IDProduto ASC, PH.DataInicio DESC, PH.DataFim DESC, PH.ID DESC  

--SELECT * FROM Dados.fn_RecuperaProduto_PointInTime(2,'2013-03-12')
