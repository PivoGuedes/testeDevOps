





/*
	Autor: Gustavo Moreira
	Data Criação: 23/07/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.Dados.vw_RetornaUltimaEmissao
	Descrição: View que retorna a última data de emissão
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_RetornaUltimaEmissao]
AS


SELECT  MAX(PGTO1.DataEfetivacao) [DATAULTIMAEMISSAO]
		FROM Dados.Pagamento PGTO1 
		inner JOIN Dados.Proposta PRP1 
		ON PRP1.ID = PGTO1.IDProposta 
		inner JOIN Dados.ProdutoSIGPF PSIG1 
		ON PSIG1.ID = PRP1.IDProdutoSIGPF 
		WHERE  PSIG1.CodigoProduto IN ('30', '31', '32', '33', '34', '35', '36', '37',
									  '38', '39', '42', '43', '44', '45', '49')
											  
											  
