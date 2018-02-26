
/*
	Autor: Egler Vieira
	Data Criação: 23/10/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_AtualizaCanalVendaPAR_Proposta
	Descrição: Procedimento que atualiza os canais de vendas de proposta
		
	Parâmetros de entrada: 
	                       @ForcarAtualizacaoCompleta - 0 para atualizar somente lançamentos SEM canal. 1 para atualizar todos os lançamentos do dia.
					
	Retorno:
	
*******************************************************************************/
CREATE PROCEDURE Dados.proc_AtualizaCanalVendaPAR_Proposta(@ForcarAtualizacaoCompleta bit = 0)
AS
BEGIN
--print @data
--DECLARE @DataReferencia date = '2013-02-06', @ForcarAtualizacaoCompleta bit = 1  
UPDATE Dados.Proposta SET IDCanalVendaPAR = ISNULL(Dados.fn_CalculaCanalVendaPAR(PRP.NumeroProposta, PRDD.CodigoComercializado, NULL),-1) /*[IDCanalVendaCalculado]*/
FROM Dados.Proposta PRP
INNER JOIN Dados.Produto PRDD
ON PRP.IDProduto = PRDD.ID
WHERE PRP.IDProduto <> -1
   AND CASE WHEN PRP.IDCanalVendaPAR IS NULL OR PRP.IDCanalVendaPAR = -1 THEN 1 ELSE 0 END IN (SELECT 1 UNION SELECT CASE WHEN @ForcarAtualizacaoCompleta = 1 THEN 0 ELSE 1 END) 

END

--EXEC Dados.proc_AtualizaCanalVendaPAR_Proposta

