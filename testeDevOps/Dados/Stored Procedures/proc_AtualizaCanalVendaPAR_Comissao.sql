
/*
	Autor: Egler Vieira
	Data Criação: 18/02/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_AtualizaCanalVendaPAR_Comissao
	Descrição: Procedimento que atualiza os canais de vendas de comissionamento
		
	Parâmetros de entrada: @DataRecibo - Data do recibo
	                       @ForcarAtualizacaoCompleta - 0 para atualizar somente lançamentos SEM canal. 1 para atualizar todos os lançamentos do dia.
					
	Retorno:
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_AtualizaCanalVendaPAR_Comissao](@DataRecibo date, @ForcarAtualizacaoCompleta bit = 0, @IDEmpresa smallint=3)
AS
BEGIN
--print @data
--DECLARE @DataRecibo date = '2016-03-15', @ForcarAtualizacaoCompleta bit = 0  
UPDATE Dados.Comissao_Partitioned SET IDCanalVendaPAR = CASE WHEN C.IDOperacao = 8 THEN 37 ELSE Dados.fn_CalculaCanalVendaPAR(C.NumeroProposta, C.CodigoProduto, NULL) END/*[IDCanalVendaCalculado]*/
FROM Dados.Comissao_Partitioned C
WHERE 
    (C.LancamentoManual = 0 OR C.LancamentoManual IS NULL)
AND C.DataCompetencia = @DataRecibo
AND CASE WHEN C.IDCanalVendaPAR IS NULL THEN 1 ELSE 0 END IN (SELECT 1 UNION SELECT CASE WHEN @ForcarAtualizacaoCompleta = 1 THEN 0 ELSE 1 END) 
AND IDEmpresa = @IDEmpresa
OPTION (OPTIMIZE FOR (@DataRecibo UNKNOWN, @IDEmpresa UNKNOWN))

END
