---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
/*
	Autor: Egler Vieira
	Data Criação: 16/04/2014

	Descrição: 
	
	Última alteração : 12/05/2014
	Adicionado paramentro IDTipoProduto

*/

/*******************************************************************************
	Nome: CORPORATIVO.Premiacao.proc_PremiacaoCorrespondenteAT_Analitico
	Descrição: Procedimento para retornar a premiação analítica dos atendentes lotéricos SAF.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Premiacao].[proc_PremiacaoCorrespondenteAT_Analitico]
	@Mes CHAR(2),
	@Ano CHAR(4),
	@IDTipoProduto SMALLINT
AS

DECLARE	@Dia CHAR(2) = '01',
		@DataInicio date,
		@DataFim date

SET @DataInicio = CAST(@Ano + '-' + @Mes + '-' + @Dia AS DATE)
SET @DataFim = DATEADD(DD,-1,DATEADD(MM,1,@DataInicio))

SELECT 
	VW.ID, 
	VW.Matricula, 
	VW.CPFCNPJ, 
	VW.Nome, 
	VW.Cidade, 
	VW.UF,
	VW.Banco,	
	VW.[AgenciaConta],	
	REPLACE(VW.[ContaCorrente],'-',' . '),
	VW.NumeroProposta, 
	VW.NumeroContrato, 
	VW.NumeroBilhete, 
	VW.NumeroEndosso, 
	VW.NumeroRecibo, 
	VW.NumeroParcela, 
	VW.[CodigoOperacao],  
	VW.DataArquivo, 
	VW.[ValoCorretagem]
FROM Premiacao.vw_PremiacaoCorrespondenteAT_Analitico VW
WHERE VW.DataArquivo BETWEEN @DataInicio  and  @DataFim AND VW.IDTipoProduto = @IDTipoProduto
and VW.CPFCNPJ IS NOT NULL
ORDER BY vw.NOME


--EXEC [Premiacao].[proc_PremiacaoCorrespondenteAT_Analitico]	 '04', '2014',2


